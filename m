Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EB84D9E3A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348288AbiCOO6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349435AbiCOO6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:58:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA59555779;
        Tue, 15 Mar 2022 07:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647356238; x=1678892238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wiowgzt+S+zwJZOS0VvV/vb4jvXFxf9uHBLJ2GB62nk=;
  b=Sh+HbAdT1sFN5xpwkYdQ07ER9q5ajL33CdMnKR4iapKeZXh9LWtIL1p6
   crx40T7FOiS98VbO3G/ckDQjfV6YhGL/3CCHvzsM/I6xcgc7fx3QjwZX3
   1dvWThSxjLvteuK4AD322g4BXHkagRO3NF+uWqfuRZkzvyUtDVwuZZXQZ
   c1bXj6CBCAQFtKEtUX5ZJUd+7TW6BMmMyErDXDp18sAfdsnH7ubyJ1RG/
   klcmmC/u1RWAbW9EfJTINc33/TwsEtuIlcrghPHwYuQyqDt5ASODXVeXM
   LbtimZtOFLGbgZfIJXDzW0OJTQwvfZSWIQA764rjkcAFaWwU8c+fpqQt9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255153951"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="255153951"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 07:57:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="515899241"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 07:57:03 -0700
Date:   Tue, 15 Mar 2022 23:10:34 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <20220315151033.GA6038@gao-cwp>
References: <Yifg4bea6zYEz1BK@google.com>
 <20220309052013.GA2915@gao-cwp>
 <YihCtvDps/qJ2TOW@google.com>
 <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
 <YirPkr5efyylrD0x@google.com>
 <29c76393-4884-94a8-f224-08d313b73f71@intel.com>
 <01586c518de0c72ff3997d32654b8fa6e7df257d.camel@redhat.com>
 <2900660d947a878e583ebedf60e7332e74a1af5f.camel@redhat.com>
 <20220313135335.GA18405@gao-cwp>
 <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 13, 2022 at 05:09:08PM +0200, Maxim Levitsky wrote:
>> > > This won't work with nested AVIC - we can't just inhibit a nested guest using its own AVIC,
>> > > because migration happens.
>> > 
>> > I mean because host decided to change its apic id, which it can in theory do any time,
>> > even after the nested guest has started. Seriously, the only reason guest has to change apic id,
>> > is to try to exploit some security hole.
>> 
>> Hi
>> 
>> Thanks for the information.  
>> 
>> IIUC, you mean KVM applies APICv inhibition only to L1 VM, leaving APICv
>> enabled for L2 VM. Shouldn't KVM disable APICv for L2 VM in this case?
>> It looks like a generic issue in dynamically toggling APICv scheme,
>> e.g., qemu can set KVM_GUESTDBG_BLOCKIRQ after nested guest has started.
>> 
>
>That is the problem - you can't disable it for L2, unless you are willing to emulate it in software.
>Or in other words, when nested guest uses a hardware feature, you can't at some point say to it:
>sorry buddy - hardware feature disappeared.

Hi Maxim,

I may miss something. When reading Sean's APICv inhibition cleanups, I
find AVIC is disabled for L1 when nested is enabled (SVM is advertised
to L1). Then, I think the new inhibition introduced for changed xAPIC ID
shouldn't be a problem for L2 VM. Or, you plan to remove
APICV_INHIBIT_REASON_NESTED and expose AVIC to L1?

svm_vcpu_after_set_cpuid:
                /*
                 * Currently, AVIC does not work with nested virtualization.
                 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
                 */
                if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
                        kvm_request_apicv_update(vcpu->kvm, false,
                                                 APICV_INHIBIT_REASON_NESTED);
