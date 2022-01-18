Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86294492B63
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbiARQhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiARQhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 11:37:52 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B47BC06161C
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:37:52 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g2so14578988pgo.9
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kkRu8NMn4TYT4qDJknsugWzbhBabQd+p561bnh/5jH4=;
        b=Qx3Tb9eh6l+RwJP4bEa93GBl8w19wvcKrIESQ5CMg7ptX52nx8+6NshQ68KLd1DuAD
         YJ3X+h4h6+HcALO1/xswVWMHagrdA14FI7Qj7CR6CEojmpXIZ3kejnyxRybDCE8qqKmf
         rJgYqLKcr8kHkjHb68aVW85/z76wvirl88dRp4yOHX93zccQejpo6yqi/vk2kOHe534m
         T7Kh64uU78zr3t2xgAXba/mn5vTvHCtAN8uAKWJHrsQJcgoHgg+ZB0v9KJvT07ypg+Z7
         zOh/ptk0NWW3fo9hgYJs0l1YxB+4eH6dcdUApf29OnG8sUa2FAYRl6zeKZDeqqHSb8+1
         1Jfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kkRu8NMn4TYT4qDJknsugWzbhBabQd+p561bnh/5jH4=;
        b=fqizoXwnDc+665ho5PS4kY6YrpBNzXlhxB/h4B8ezaO/zZPhH5qWgRSn4IRTHWC4BT
         3e6TBwGDkmNMA+dzXkmb5bFC9ZYagewi5525ihod24hjk1KjHNp1/Uf1mPeGSNfHbrkh
         NHeTdICJRlwCULSW8AHtUk4B/2+jsT0V7mAF1Lt723WZdJnha1zK6STcU7X+sh1M0R7Q
         dom/h/Erp3Hk24Xq4QLI3flmEu9EVxrVGl20ZQ6OOhxEOp8sPN0/5p1naZHQwD9K0n4M
         G0ZxO0ybv3Ehqm6Mgo26yR6uHx4i/vs6p3skYGDIblPF4dECyfVnkSB0JGSB8SaKHMXd
         Lrlg==
X-Gm-Message-State: AOAM530tI0zQ7i3PRQb4VvDfA54PwVa0hwILL1IPDd+qoJ7x0VgZrhm+
        umAMXfXSI7sx+W9Ok1arz/wZQw==
X-Google-Smtp-Source: ABdhPJwWF1IidkGYLau9uX3iN8TU/D+efj+X8QBJhtRtWf1sRKL2/N7Da2vQaoJyOztfQPsW+IP8wQ==
X-Received: by 2002:a63:6906:: with SMTP id e6mr12947300pgc.170.1642523871568;
        Tue, 18 Jan 2022 08:37:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lx10sm1545823pjb.4.2022.01.18.08.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:37:50 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:37:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN
Message-ID: <Yebs21Vnt4WBQBw5@google.com>
References: <20220118141801.2219924-1-vkuznets@redhat.com>
 <20220118141801.2219924-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118141801.2219924-3-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022, Vitaly Kuznetsov wrote:
> +/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
> +static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> +				 int nent)
> +{
> +	struct kvm_cpuid_entry2 *orig;
> +	int i;
> +
> +	if (nent != vcpu->arch.cpuid_nent)
> +		return -EINVAL;
> +
> +	for (i = 0; i < nent; i++) {
> +		orig = &vcpu->arch.cpuid_entries[i];
> +		if (e2[i].function != orig->function ||
> +		    e2[i].index != orig->index ||
> +		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
> +		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
> +			return -EINVAL;

This needs to check .flags for the above check on .index to be meaningful, and at
that point, can't we be even more agressive and just do?

	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(e2)))
		return -EINVAL;

	return 0;

> +	}
> +
> +	return 0;
> +}
> +
>  static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
>  {
>  	u32 function;
> @@ -313,6 +335,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  
>  	__kvm_update_cpuid_runtime(vcpu, e2, nent);
> +	/*
> +	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> +	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> +	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> +	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
> +	 * the core vCPU model on the fly. It would've been better to forbid any
> +	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
> +	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
> +	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
> +	 * whether the supplied CPUID data is equal to what's already set.

This is misleading/wrong.  KVM_RUN isn't the only problematic ioctl(), it's just
the one that we decided to use to detect that userspace is being stupid.  And
forbidding KVM_SET_CPUID after KVM_RUN (or even all problematic ioctls()) wouldn't
solve problem as providing different CPUID configurations for vCPUs in a VM will
also cause the MMU to fall on its face.

> +	if (vcpu->arch.last_vmentry_cpu != -1)
> +		return kvm_cpuid_check_equal(vcpu, e2, nent);

And technically, checking last_vmentry_cpu doesn't forbid changing CPUID after
KVM_RUN, it forbids changing CPUID after successfully entering the guest (or
emulating instructions on VMX).

I realize I'm being very pedantic, as a well-intended userspace is obviously not
going to change CPUID after -EINTR or whatever.  But I do want to highlight that
this approach is by no means bulletproof, and that what is/isn't allowed with
respect to guest CPUID isn't necessarily associated with what is/isn't "safe".
In other words, this check doesn't guarantee that userspace can't misuse KVM_SET_CPUID,
and on the flip side it disallows using KVM_SET_CPUID in ways that are perfectly ok
(if userspace is careful and deliberate).
