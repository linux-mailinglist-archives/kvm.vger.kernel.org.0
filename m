Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0E8505BBE
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345698AbiDRPs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345846AbiDRPrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 11:47:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC9C2C118
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 08:14:56 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so12582022plg.5
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 08:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B53fka1F3qxqQdxFr9SFgaJ7tbAOPZYraoihVoIiog0=;
        b=lU9I3+KSYNMyQdy1jahGZNiQONptfa7XVZSpq6ccWkud1YanLo2MnxmbwjUu7xPtey
         sHES3gLFWy29nz2uKm1FgqIPzRQmMbFp3uxQJ561Dt5+4dKfsIDdpeuKGt4WsnPGDNVq
         hngDN2TI+UKJNGqI6zICbKSEO1ctCKiiz0bnNV5+pfPDHD5wBObw7CDLG+4xbMR7QUTn
         elDurf84ml/MAFJIwJvg8NBA1JJTcWIJM/oyd69nwXUep2ju6DvdlFTFdShz9FfbWKrw
         Ki4oyYGKQb0RD+lY8U+istt85FQ7tI/7ji7RoyLzxyMXBScOD03syEolLZx2Kpw4fLOU
         aR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B53fka1F3qxqQdxFr9SFgaJ7tbAOPZYraoihVoIiog0=;
        b=oLvP26HQU92/QfeJufC27gp51sX9WlnZkeft4sbz5ps/nR/ARfWGgvC8Ad52PHAv/t
         omCdriWi6oanTkb+XnafUYt9xGW12UoTcMoYZe4dhwZkeL/EDhMBlvi3aFw7j+dxA4Sd
         efuRq/sg8pL1dgHQGoihxDMRdSuuT7v4DfvxKlhsJB1/26cbDniaexqSJzS7qEMR42Nn
         VxK5jC00bBj+7kRvlwom55Te7iKF05TPSl8KcPH4+A1IFxt9lv0di/C6U8Ei/cZ3VETm
         Fm2XgcxDNsAqzc3fTPSHPXlZU6zGkz/MK6WyNsrI5bG4EXhkSpAjmj23sauP88+fhuFK
         g7DA==
X-Gm-Message-State: AOAM530xhlAS+xA1nLmyv3dGxhjMkZMqwveYVLgTlMoVmVZHZteQvsqJ
        5TPLIeM2npgkg+YfAGDzBaqZDQ==
X-Google-Smtp-Source: ABdhPJwZ8N3FhPhpLHRas8PFdxxK3sGwC8rzRSRTSNYXeIDF8PM79p7kg+Plnw1pNvxBpvGU6f28ig==
X-Received: by 2002:a17:902:9b87:b0:156:bf3e:9ab5 with SMTP id y7-20020a1709029b8700b00156bf3e9ab5mr11225355plp.119.1650294895863;
        Mon, 18 Apr 2022 08:14:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78d18000000b0050564584660sm12482867pfe.32.2022.04.18.08.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 08:14:55 -0700 (PDT)
Date:   Mon, 18 Apr 2022 15:14:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
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
Message-ID: <Yl2AaxXFh7UfvpFx@google.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-10-guang.zeng@intel.com>
 <YlmOUtXgIdQcUTO1@google.com>
 <20220418092500.GA14409@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418092500.GA14409@gao-cwp>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 18, 2022, Chao Gao wrote:
> On Fri, Apr 15, 2022 at 03:25:06PM +0000, Sean Christopherson wrote:
> >On Mon, Apr 11, 2022, Zeng Guang wrote:
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index d1a39285deab..23fbf52f7bea 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -11180,11 +11180,15 @@ static int sync_regs(struct kvm_vcpu *vcpu)
> >>  
> >>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> >>  {
> >> +	int ret = 0;
> >> +
> >>  	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
> >>  		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
> >>  			     "guest TSC will not be reliable\n");
> >>  
> >> -	return 0;
> >> +	if (kvm_x86_ops.alloc_ipiv_pid_table)
> >> +		ret = static_call(kvm_x86_alloc_ipiv_pid_table)(kvm);
> >
> >Add a generic kvm_x86_ops.vcpu_precreate, no reason to make this so specific.
> >And use KVM_X86_OP_RET0 instead of KVM_X86_OP_OPTIONAL, then this can simply be
> >
> >	return static_call(kvm_x86_vcpu_precreate);
> >
> >That said, there's a flaw in my genius plan.
> >
> >  1. KVM_CREATE_VM
> >  2. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=1
> >  3. KVM_CREATE_VCPU, create IPIv table but ultimately fails
> >  4. KVM decrements created_vcpus back to '0'
> >  5. KVM_CAP_MAX_VCPU_ID, set max_vcpu_ids=4096
> >  6. KVM_CREATE_VCPU w/ ID out of range
> >
> >In other words, malicious userspace could trigger buffer overflow.
> 
> can we simply return an error (e.g., -EEXIST) on step 5 (i.e.,
> max_vcpu_ids cannot be changed after being set once)?
> 
> or
> 
> can we detect the change of max_vcpu_ids in step 6 and re-allocate PID
> table?

Returning an error is viable, but would be a rather odd ABI.  Re-allocating isn't
a good option because the PID table could be in active use by other vCPUs, e.g.
KVM would need to send a request and kick all vCPUs to have all vCPUs update their
VMCS.

And with both of those alternatives, I still don't like that every feature that
acts on max_vcpu_ids would need to handle this same edge case.

An alternative to another new ioctl() would be to to make KVM_CAP_MAX_VCPU_ID
write-once, i.e. reject attempts to change the max once set (though we could allow
re-writing the same value).  I think I like that idea better than adding an ioctl().

It can even be done without an extra flag by zero-initializing the field and instead
waiting until vCPU pre-create to lock in the value.  That would also help detect
bad usage of max_vcpu_ids, especially if we added a wrapper to get the value, e.g.
the wrapper could WARN_ON(!kvm->arch.max_vcpu_ids).

E.g.

int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
{
	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
		pr_warn_once("kvm: SMP vm created on host with unstable TSC; "
			     "guest TSC will not be reliable\n");

	if (!kvm->arch.max_vcpu_ids)
		kvm->arch.max_vcpu_ids = KVM_MAX_VCPU_IDS;

	return 0;
}


	case KVM_CAP_MAX_VCPU_ID:
		r = -EINVAL;
		if (cap->args[0] > KVM_MAX_VCPU_IDS)
			break;

		mutex_lock(&kvm->lock);
                if (kvm->arch.max_vcpu_ids == cap->args[0]) {
                        r = 0;
                } else if (!kvm->arch.max_vcpu_ids) {
			kvm->arch.max_vcpu_ids = cap->args[0];
			r = 0;
		}
		mutex_unlock(&kvm->lock);
		break;
