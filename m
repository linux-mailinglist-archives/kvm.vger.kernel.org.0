Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567676ECF89
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 15:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjDXNsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 09:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjDXNsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 09:48:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1943D83DE;
        Mon, 24 Apr 2023 06:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682344104; x=1713880104;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oPqlnm5FAEkzjCzsM5wwOi+X/O97WzQZ5VPCNK7UoWo=;
  b=BSlADEd7/kIe/sZ0Rqu/+ceaXxHopDQlqj4L8L3b1fx1CLJ69t6C8F2f
   9UWAxbFOE17aKW7uhHNtmCPcRczn47PjhV3oO+orC5oToJinZtba78T9d
   gRH/r+dgOytrFrgArMKZEB10FJSDaL61t3lktL19/mz0WkcI2mrr3+hT7
   /6RtTCSj1nLWbP/8pmC0hK8bow+szUFT/Xvdwu8OHI7PEBSPz4vE10+qP
   mazCBP2rUxsgfQbSL1UQXfM4JVr1SYNZ+s+xEIZw+AlfAdfbpg+AdCyW9
   SDi3mXGaGeNfbJW62mkMNyv21wisVEQ7m4Sk7J107fUC+8HB2ZttFoJjQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="346479854"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="346479854"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 06:48:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="693087845"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="693087845"
Received: from mkavai-mobl2.amr.corp.intel.com (HELO [10.212.196.194]) ([10.212.196.194])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 06:48:09 -0700
Message-ID: <81c476f4-ef62-e4a6-0033-8a46a15379fd@intel.com>
Date:   Mon, 24 Apr 2023 06:48:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC 45/48] RISC-V: ioremap: Implement for arch specific ioremap
 hooks
Content-Language: en-US
To:     Atish Kumar Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
 <20230419221716.3603068-46-atishp@rivosinc.com>
 <69ba1760-a079-fd8f-b079-fcb01e3eedec@intel.com>
 <CAHBxVyFhDapAeMQ8quBqWZ10jWSHw1CdE227ciyKQpULHYzffA@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAHBxVyFhDapAeMQ8quBqWZ10jWSHw1CdE227ciyKQpULHYzffA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/23 12:24, Atish Kumar Patra wrote:
> On Fri, Apr 21, 2023 at 3:46 AM Dave Hansen <dave.hansen@intel.com> wrote:>> This callback appears to say to the host:
>>
>>         Hey, I (the guest) am treating this guest physical area as MMIO.
>>
>> But the host and guest have to agree _somewhere_ what the MMIO is used
>> for, not just that it is being used as MMIO.
> 
> Yes. The TSM (TEE Security Manager) which is equivalent to TDX also 
> needs to be aware of the MMIO regions so that it can forward the
> faults accordingly. Most of the MMIO is emulated in the host
> (userspace or kernel emulation if present). The host is outside the
> trust boundary of the guest. Thus, guest needs to make sure the host 
> only emulates the designated MMIO region. Otherwise, it opens an 
> attack surface from a malicious host.
How does this mechanism stop the host from emulating something outside
the designated region?

On TDX, for instance, the guest page table have a shared/private bit.
Private pages get TDX protections to (among other things) keep the page
contents confidential from the host.  Shared pages can be used for MMIO
and don't have those protections.

If the host goes and tries to flip a page from private->shared, TDX
protections will kick in and prevent it.

None of this requires the guest to tell the host where it expects MMIO
to be located.

> All other confidential computing solutions also depend on guest 
> initiated MMIO as well. AFAIK, the TDX & SEV relies on #VE like
> exceptions to invoke that while this patch is similar to what pkvm
> does. This approach lets the enlightened guest control which MMIO
> regions it wants the host to emulate.

I'm not _quite_ sure what "guest initiated" means.  But SEV and TDX
don't require an ioremap hook like this.  So, even if they *are* "guest
initiated", the question still remains how they work without this patch,
or what they are missing without it.

> It can be a subset of the region's host provided the layout. The
> guest device filtering solution is based on this idea as well [1].
> 
> [1] https://lore.kernel.org/all/20210930010511.3387967-1-sathyanarayanan.kuppuswamy@linux.intel.com/

I don't really see the connection.  Even if that series was going
forward (I'm not sure it is) there is no ioremap hook there.  There's
also no guest->host communication in that series.  The guest doesn't
_tell_ the host where the MMIO is, it just declines to run code for
devices that it didn't expect to see.

I'm still rather confused here.
