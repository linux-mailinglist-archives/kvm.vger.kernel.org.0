Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B3E6EE280
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 15:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbjDYNKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 09:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjDYNKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 09:10:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE812D64;
        Tue, 25 Apr 2023 06:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682428232; x=1713964232;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rjBDnveYTlgu+7sEbRfwz2mR/VV2dupmzj53Ht6fq5I=;
  b=NKUEO8DuhVFhAoD+6hOMK5wdMJxc/izqLPJL9D05PvM4ByxoJFxi22hI
   es4sIlIFYKDJTgjeuCgfrKkbliBRO3TYJp57IYR3RAbPEYyQ54mV7ez8t
   MOpRV9n7bOUB2/6Zj6YiE4aKUSibZxgTqkPg0v3TXlQGykdOmz8QPZZll
   R44YUCfUrd8NoM57MoiHGDNr+a/COylq0CBIBmuvXhvUXOr69XxM5d9GA
   vs4be1pNLpYKfWd0tT7qaKaFOaCvotiK00rnfpGqsk2kRT4GJOnv1SiFr
   iAXkC2XRA4uhCBmWy8La+xy5mETXNpW93eDWRq2zta7PzMH22H87kr5Mw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="326360145"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="326360145"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 06:10:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="939765044"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="939765044"
Received: from gchacko-mobl1.gar.corp.intel.com (HELO [10.215.145.52]) ([10.215.145.52])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 06:10:17 -0700
Message-ID: <fe1a849a-3276-5fad-869b-bad54bc918f6@intel.com>
Date:   Tue, 25 Apr 2023 06:10:12 -0700
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
 <81c476f4-ef62-e4a6-0033-8a46a15379fd@intel.com>
 <CAHBxVyHg7vTaQJWKoVSD8budVZEYSo1eDOyZyZK7gcJApR7SbA@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAHBxVyHg7vTaQJWKoVSD8budVZEYSo1eDOyZyZK7gcJApR7SbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/23 01:00, Atish Kumar Patra wrote:
> On Mon, Apr 24, 2023 at 7:18 PM Dave Hansen <dave.hansen@intel.com> wrote:
>> On 4/21/23 12:24, Atish Kumar Patra wrote:
>> I'm not _quite_ sure what "guest initiated" means.  But SEV and TDX
>> don't require an ioremap hook like this.  So, even if they *are* "guest
>> initiated", the question still remains how they work without this patch,
>> or what they are missing without it.
> 
> Maybe I misunderstood your question earlier. Are you concerned about guests
> invoking any MMIO region specific calls in the ioremap path or passing
> that information to the host ?

My concern is that I don't know why this patch is here.  There should be
a very simple answer to the question: Why does RISC-V need this patch
but x86 does not?

> Earlier, I assumed the former but it seems you are also concerned
> about the latter as well. Sorry for the confusion in that case.
> The guest initiation is necessary while the host notification can be
> made optional.
> The "guest initiated" means the guest tells the TSM (equivalent of TDX
> module in RISC-V) the MMIO region details.
> The TSM keeps a track of this and any page faults that happen in that
> region are forwarded
> to the host by the TSM after the instruction decoding. Thus TSM can
> make sure that only ioremapped regions are
> considered MMIO regions. Otherwise, all memory outside the guest
> physical region will be considered as the MMIO region.

Ahh, OK, that's a familiar problem.  I see the connection to device
filtering now.

Is this functionality in the current set?  I went looking for it and all
I found was the host notification side.

Is this the only mechanism by which the guest tells the TSM which parts
of the guest physical address space can be exposed to the host?

For TDX and SEV, that information is inferred from a bit in the page
tables.  Essentially, there are dedicated guest physical addresses that
tell the hardware how to treat the mappings: should the secure page
tables or the host's EPT/NPT be consulted?

If that mechanism is different for RISC-V, it would go a long way to
explaining why RISC-V needs this patch.

> In the current CoVE implementation, that MMIO region information is also
> passed to the host to provide additional flexibility. The host may
> choose to do additional
> sanity check and bail if the fault address does not belong to
> requested MMIO regions without
> going to the userspace. This is purely an optimization and may not be mandatory.

Makes sense, thanks for the explanation.

>>> It can be a subset of the region's host provided the layout. The
>>> guest device filtering solution is based on this idea as well [1].
>>>
>>> [1] https://lore.kernel.org/all/20210930010511.3387967-1-sathyanarayanan.kuppuswamy@linux.intel.com/
>>
>> I don't really see the connection.  Even if that series was going
>> forward (I'm not sure it is) there is no ioremap hook there.  There's
>> also no guest->host communication in that series.  The guest doesn't
>> _tell_ the host where the MMIO is, it just declines to run code for
>> devices that it didn't expect to see.
> 
> This is a recent version of the above series from tdx github. This is
> a WIP as well and has not been posted to
> the mailing list. Thus, it may be going under revisions as well.
> As per my understanding the above ioremap changes for TDX mark the
> ioremapped pages as shared.
> The guest->host communication happen in the #VE exception handler
> where the guest converts this to a hypercall by invoking TDG.VP.VMCALL
> with an EPT violation set. The host would emulate an MMIO address if
> it gets an VMCALL with EPT violation.
> Please correct me if I am wrong.

Yeah, TDX does:

1. Guest MMIO access
2. Guest #VE handler (if the access faults)
3. Guest hypercall->host
4. Host fixes the fault
5. Hypercall returns, guest returns from #VE via IRET
6. Guest retries MMIO instruction

From what you said, RISC-V appears to do:

1. Guest MMIO access
2. Host MMIO handler
3. Host handles the fault, returns
4. Guest retries MMIO instruction

In other words, this mechanism does the same thing but short-circuits
the trip through #VE and the hypercall.

What happens if this ioremap() hook is not in place?  Does the hardware
(or TSM) generate an exception like TDX gets?  If so, it's probably
possible to move this "notify the TSM" code to that exception handler
instead of needing an ioremap() hook.

I'm not saying that it's _better_ to do that, but it would allow you to
get rid of this patch for now and get me to shut up. :)

> As I said above, the objective here is to notify the TSM where the 
> MMIO is. Notifying the host is just an optimization that we choose to
> add. In fact, in this series the KVM code doesn't do anything with
> that information. The commit text probably can be improved to clarify
> that.

Just to close the loop here, please go take a look at
pgprot_decrypted().  That's where the x86 guest page table bit gets to
tell the hardware that the mapping might cause a #VE and is under the
control of the host.  That's the extent of what x86 does at ioremap() time.

So, to summarize, we have:

x86:
1. Guest page table bit to mark shared (host) vs. private (guest)
   control
2. #VE if there is a fault on a shared mapping to call into the host

RISC-V:
1. Guest->TSM call to mark MMIO vs. private
2. Faults in the MMIO area are then transparent to the guest

That design difference would, indeed, help explain why this patch is
here.  I'm still not 100% convinced that the patch is *required*, but I
at least understand how we arrived here.
