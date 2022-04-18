Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE60504E58
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbiDRJ1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 05:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiDRJ1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 05:27:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E03115FEE;
        Mon, 18 Apr 2022 02:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650273916; x=1681809916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ioZ9JXZxLCcWETmYWkAhKILzUEa+o6rWjiImVbx3U2I=;
  b=ZQWjxNmfy8uOm7Z9UynWX/87cgy8lxRzXZ01TvrNDSwOrWJKEG3B5GUR
   vmfR6+ka/DUNo2x+qj84JWVzCQfj+xOiBfOTnKd23GigiUhqEVe6V0LPz
   3XwHo1fMqFLp2RdtyiY/1MJKaEtzRRb3cm9GIeVS74fVnW13N2rQHYaR0
   bxBwsp8vzAZuJ4KaLPUw2wtu7zq4TzzDoshKc7Y3cBva4JyiaT0LkAK6x
   I+Ck2Zvl9oACM52g4FR3lpprKvEZuR76RKEyQERgKrO2Ebve+7rmb8Psr
   X7hxFFSho0a0UeaDAve/38GAi5VSL5yqzRM/uAA7C7HPedOUBluLNIIm4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="349935563"
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="349935563"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 02:25:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="575505697"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 02:25:10 -0700
Date:   Mon, 18 Apr 2022 17:25:05 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v8 9/9] KVM: VMX: enable IPI virtualization
Message-ID: <20220418092500.GA14409@gao-cwp>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-10-guang.zeng@intel.com>
 <YlmOUtXgIdQcUTO1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlmOUtXgIdQcUTO1@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 03:25:06PM +0000, Sean Christopherson wrote:
>On Mon, Apr 11, 2022, Zeng Guang wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d1a39285deab..23fbf52f7bea 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11180,11 +11180,15 @@ static int sync_regs(struct kvm_vcpu *vcpu)
>>  
>>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>  {
>> +	int ret = 0;
>> +
>>  	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
>>  		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
>>  			     "guest TSC will not be reliable\n");
>>  
>> -	return 0;
>> +	if (kvm_x86_ops.alloc_ipiv_pid_table)
>> +		ret = static_call(kvm_x86_alloc_ipiv_pid_table)(kvm);
>
>Add a generic kvm_x86_ops.vcpu_precreate, no reason to make this so specific.
>And use KVM_X86_OP_RET0 instead of KVM_X86_OP_OPTIONAL, then this can simply be
>
>	return static_call(kvm_x86_vcpu_precreate);
>
>That said, there's a flaw in my genius plan.
>
>  1. KVM_CREATE_VM
>  2. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=1
>  3. KVM_CREATE_VCPU, create IPIv table but ultimately fails
>  4. KVM decrements created_vcpus back to '0'
>  5. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=4096
>  6. KVM_CREATE_VCPU w/ ID out of range
>
>In other words, malicious userspace could trigger buffer overflow.

can we simply return an error (e.g., -EEXIST) on step 5 (i.e.,
max_vcpu_ids cannot be changed after being set once)?

or

can we detect the change of max_vcpu_ids in step 6 and re-allocate PID
table?

>
>That could be solved by adding an arch hook to undo precreate, but that's gross
>and a good indication that we're trying to solve this the wrong way.
>
>I think it's high time we add KVM_FINALIZE_VM, though that's probably a bad name
>since e.g. TDX wants to use that name for VM really, really, being finalized[*],
>i.e. after all vCPUs have been created.
>
>KVM_POST_CREATE_VM?  That's not very good either.
>
>Paolo or anyone else, thoughts?
>
>[*] https://lore.kernel.org/all/83768bf0f786d24f49d9b698a45ba65441ef5ef0.1646422845.git.isaku.yamahata@intel.com
