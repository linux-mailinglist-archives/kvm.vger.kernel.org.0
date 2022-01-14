Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D9D48E16F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 01:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiANAWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 19:22:10 -0500
Received: from mga14.intel.com ([192.55.52.115]:63684 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232240AbiANAWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 19:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642119730; x=1673655730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uyj9SBTTDkfBIklCvz32+HFrdyaje8fMudkALht8mgw=;
  b=JZFFsRLviAkrHeiqYf/MOVzByJTGaTQNpBkzqi1tTKt+7SM5W/c4S8Rg
   rZhXfMxHMEQ3DLHN0pyiBJI4O9Uty+h99KcBQ4N+lIg9zeqOGEKn5gq/Y
   t8GTUf3/+e79dY9K9g8qvtD/XFjZ7H3RBsHN9WQEOQUi6+jemrC6RfvVI
   rO99lxiLHPhYRJne1fWCqUgMIl88ADlEQ87e+LJr4UDJ905Bgzrk2/IZP
   GUnTCwREZPC4cA8rywGvlGlRrmUPyQfWZW55oEoZephzcvCn9vVDhOHcx
   A+/CLDzSyktBc4Y9uMkhcHtqWkQK4WS9ZnVQOpUkbDbjakMsevdfvSkn7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244350334"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="244350334"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 16:22:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="529171106"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jan 2022 16:22:04 -0800
Date:   Fri, 14 Jan 2022 08:22:03 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
Message-ID: <20220114002203.5dnxhnn5xydmfv43@yy-desk-7060>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
 <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
 <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
 <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
 <20220110074523.GA18434@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110074523.GA18434@gao-cwp>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 03:45:25PM +0800, Chao Gao wrote:
> On Fri, Jan 07, 2022 at 10:31:59AM +0200, Maxim Levitsky wrote:
> >On Fri, 2022-01-07 at 16:05 +0800, Zeng Guang wrote:
> >> On 1/6/2022 10:06 PM, Tom Lendacky wrote:
> >> > On 1/5/22 7:44 PM, Zeng Guang wrote:
> >> > > On 1/6/2022 3:13 AM, Tom Lendacky wrote:
> >> > > > On 12/31/21 8:28 AM, Zeng Guang wrote:
> >> > > > Won't this blow up on AMD since there is no corresponding SVM op?
> >> > > >
> >> > > > Thanks,
> >> > > > Tom
> >> > > Right, need check ops validness to avoid ruining AMD system. Same
> >> > > consideration on ops "update_ipiv_pid_table" in patch8.
> >> > Not necessarily for patch8. That is "protected" by the
> >> > kvm_check_request(KVM_REQ_PID_TABLE_UPDATE, vcpu) test, but it couldn't hurt.
> >>
> >> OK, make sense. Thanks.
> >
> >I haven't fully reviewed this patch series yet,
> >and I will soon.
> >
> >I just want to point out few things:
>
> Thanks for pointing them out.
>
> >
> >1. AMD's AVIC also has a PID table (its calle AVIC physical ID table).
> >It stores addressses of vCPUs apic backing pages,
> >and thier real APIC IDs.
> >
> >avic_init_backing_page initializes the entry (assuming apic_id == vcpu_id)
> >(which is double confusing)
> >
> >2. For some reason KVM supports writable APIC IDs. Does anyone use these?
> >Even Intel's PRM strongly discourages users from using them and in X2APIC mode,
> >the APIC ID is read only.
> >
> >Because of this we have quite some bookkeeping in lapic.c,
> >(things like kvm_recalculate_apic_map and such)
> >
> >Also AVIC has its own handling for writes to APIC_ID,APIC_LDR,APIC_DFR
> >which tries to update its physical and logical ID tables.
>
> Intel's IPI virtualization doesn't handle logical-addressing IPIs. They cause
> APIC-write vm-exit as usual. So, this series doesn't handle APIC_LDR/DFR.
>
> >
> >(it used also to handle apic base and I removed this as apic base otherwise
> >was always hardcoded to the default vaule)
> >
> >Note that avic_handle_apic_id_update is broken - it always copies the entry
> >from the default (apicid == vcpu_id) location to new location and zeros
> >the old location, which will fail in many cases, like even if the guest
> >were to swap few apic ids.
>
> This series differs from avic_handle_apic_id_update slightly:
>
> If a vCPU's APIC ID is changed, this series zeros the old entry in PID-pointer
> table and programs the vCPU's PID to the new entry (rather than copy from the
> old entry).
>
> But this series is also problematic if guest swaps two vCPU's APIC ID without
> using another free APIC ID; it would end up one of them having no valid entry.
>
> One solution in my mind is:
>
> when a vCPU's APIC ID is changed, KVM traverses all vCPUs to count vCPUs using
> the old APIC ID and the new APIC ID, programs corrsponding entries following
> below rules:
> 1. populate an entry with a vCPU's PID if the corrsponding APIC ID is
> exclusively used by that vCPU.
> 2. zero an entry for other cases.

Don't need to traverse I think, just not zero the old entry if it's not
belong to the vcpu:

+Take new one or exist vm level lock

+if (__pa(&to_vmx(vcpu)->pi_desc) == (pid_table[old_id] & ~PID_TABLE_ENTRY_VALID))
      WRITE_ONCE(pid_table[old_id], 0);
WRITE_ONCE(pid_table[new_id], __pa(&to_vmx(vcpu)->pi_desc) |
           PID_TABLE_ENTRY_VALID);

+Release new one or exist vm level lock


>
> Proper locking is needed in this process to prevent changes to vCPUs' APIC IDs.
>
> Or if it doesn't worth it, we can disable IPI virtualization for a guest on its
> first attempt to change xAPIC ID.
>
> Let us know which option is preferred.
