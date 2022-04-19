Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8224750606E
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 02:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiDSADJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 20:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiDSADE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 20:03:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A82DFF8;
        Mon, 18 Apr 2022 17:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650326423; x=1681862423;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LNgypJWu04+VBr0jxucBPW5eHtAN+yGVhhFKj1YoysA=;
  b=noxzZEujwGp/kZoHFYbhcCe/uXFA4VsfH8+dECwQvFzR2HHCtc/fwvfd
   H2GnTJzho1+Xcx1KY9QZNsBU8i2JI4hYr4kQczL85NvpwHTm6CJVAZGFj
   3Pyg0iCBN/VZdJqv/LEvQD5T70aIbR4OTe/TjDCYlpwaeGDs1Pxld8Iq7
   iPTpZyeFsA2NapJmWM0J1JhjZxWpDe6BFPRf7OVhlIGV4T6Sw3F91I/zS
   1ytW/SI4FoUGzHK8gmcSRWfL9MnOmHAZdhF9Y4oYKr9Gb7lyiCo29bRIQ
   e+NUPEwMlE/kghBK9Z31KIyviDcl4XuAFb9J/etBKK1Dk9S0uDvWfWhfP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="261239454"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="261239454"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 17:00:23 -0700
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="554454749"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 17:00:18 -0700
Date:   Tue, 19 Apr 2022 08:00:13 +0800
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
Message-ID: <20220419000007.GA15366@gao-cwp>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-10-guang.zeng@intel.com>
 <YlmOUtXgIdQcUTO1@google.com>
 <20220418092500.GA14409@gao-cwp>
 <Yl2AaxXFh7UfvpFx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl2AaxXFh7UfvpFx@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 18, 2022 at 03:14:51PM +0000, Sean Christopherson wrote:
>On Mon, Apr 18, 2022, Chao Gao wrote:
>> On Fri, Apr 15, 2022 at 03:25:06PM +0000, Sean Christopherson wrote:
>> >On Mon, Apr 11, 2022, Zeng Guang wrote:
>> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> >> index d1a39285deab..23fbf52f7bea 100644
>> >> --- a/arch/x86/kvm/x86.c
>> >> +++ b/arch/x86/kvm/x86.c
>> >> @@ -11180,11 +11180,15 @@ static int sync_regs(struct kvm_vcpu *vcpu)
>> >>  
>> >>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>> >>  {
>> >> +	int ret = 0;
>> >> +
>> >>  	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
>> >>  		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
>> >>  			     "guest TSC will not be reliable\n");
>> >>  
>> >> -	return 0;
>> >> +	if (kvm_x86_ops.alloc_ipiv_pid_table)
>> >> +		ret = static_call(kvm_x86_alloc_ipiv_pid_table)(kvm);
>> >
>> >Add a generic kvm_x86_ops.vcpu_precreate, no reason to make this so specific.
>> >And use KVM_X86_OP_RET0 instead of KVM_X86_OP_OPTIONAL, then this can simply be
>> >
>> >	return static_call(kvm_x86_vcpu_precreate);
>> >
>> >That said, there's a flaw in my genius plan.
>> >
>> >  1. KVM_CREATE_VM
>> >  2. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=1
>> >  3. KVM_CREATE_VCPU, create IPIv table but ultimately fails
>> >  4. KVM decrements created_vcpus back to '0'
>> >  5. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=4096
>> >  6. KVM_CREATE_VCPU w/ ID out of range
>> >
>> >In other words, malicious userspace could trigger buffer overflow.
>> 
>> can we simply return an error (e.g., -EEXIST) on step 5 (i.e.,
>> max_vcpu_ids cannot be changed after being set once)?
>> 
>> or
>> 
>> can we detect the change of max_vcpu_ids in step 6 and re-allocate PID
>> table?
>
>Returning an error is viable, but would be a rather odd ABI.  Re-allocating isn't
>a good option because the PID table could be in active use by other vCPUs, e.g.
>KVM would need to send a request and kick all vCPUs to have all vCPUs update their
>VMCS.
>
>And with both of those alternatives, I still don't like that every feature that
>acts on max_vcpu_ids would need to handle this same edge case.
>
>An alternative to another new ioctl() would be to to make KVM_CAP_MAX_VCPU_ID
>write-once, i.e. reject attempts to change the max once set (though we could allow
>re-writing the same value).  I think I like that idea better than adding an ioctl().
>
>It can even be done without an extra flag by zero-initializing the field and instead
>waiting until vCPU pre-create to lock in the value.  That would also help detect
>bad usage of max_vcpu_ids, especially if we added a wrapper to get the value, e.g.
>the wrapper could WARN_ON(!kvm->arch.max_vcpu_ids).

Yes, it looks simpler than adding an ioctl(). We will use this approach.
