Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17486E9EA5
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 00:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjDTWQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 18:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjDTWQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 18:16:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6B0EB;
        Thu, 20 Apr 2023 15:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682028960; x=1713564960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IS7ZXuBIDcdEHWCz73K8Pgp/gskIbDBObXQBP3E1Hs8=;
  b=LCGkVQR+vY0wm6YguB8KSpPq1Q6tjr/ZtgQ2hj28Ijqm9VHh4fzbN8As
   NsVdY/baZlD6Hw8Hfqzx6ugN+VC083moBTUKxCDW/p6YefT7fP03auiam
   KOEgj7PfJU6ylf+6IwntSD0nFpW5/LdvJ0lGsL+4oOPDWFWdywpyvFhlH
   e4acXtuKQTBu5X0lqHECiBZyrmIcTtuzczR80gxfz6EgW6/pqtykQ6ebd
   fHNlBTldcNscfic8Wo7kVg3Bq0ejbveAO7v4Y9kz51h+77eXpraRQl5K8
   uHkeSReC/p1LvG+KH9R+JfdzccSWCZl8S9wQ4/gilb4yCkeZ6r52eZpwB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="373781270"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="373781270"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 15:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756693577"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="756693577"
Received: from ashleyst-mobl1.amr.corp.intel.com (HELO [10.209.71.65]) ([10.209.71.65])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 15:15:58 -0700
Message-ID: <69ba1760-a079-fd8f-b079-fcb01e3eedec@intel.com>
Date:   Thu, 20 Apr 2023 15:15:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC 45/48] RISC-V: ioremap: Implement for arch specific ioremap
 hooks
Content-Language: en-US
To:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230419221716.3603068-46-atishp@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/19/23 15:17, Atish Patra wrote:
> The guests running in CoVE must notify the host about its mmio regions
> so that host can enable mmio emulation.

This one doesn't make a lot of sense to me.

The guest and host must agree about the guest's physical layout up
front.  In general, the host gets to dictate that layout.  It tells the
guest, up front, what is present in the guest physical address space.

This callback appears to say to the host:

	Hey, I (the guest) am treating this guest physical area as MMIO.

But the host and guest have to agree _somewhere_ what the MMIO is used
for, not just that it is being used as MMIO.


