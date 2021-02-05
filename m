Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9395310B4F
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 13:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhBEMrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 07:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhBEMos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 07:44:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F5EC061786;
        Fri,  5 Feb 2021 04:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=reHVvWwUiUHiQPTU6j13brcAJoLO5jQM1ry2BytMqcc=; b=R1n4RV0vyJLbTuLFpIHymRStJl
        5gXDHW7EV+qn5DUve5kWhRtCEFJesHQp6Mk93U8/4/NUJPxDlOyQ+v3nvck4nZSO63/mM7DU6e1nt
        f8VRFzRH5eLU51bByKx1jGrdBVTi7QsKLM+pqEYfQpOVRnEQ6aeQiLyDyorhJdgHOlZiTObWb6GH9
        dZvjWBd5fpuYs9LZ8HutjAPCriMnEKv9eFpzVagqUl/Yy4krv2MUKhDtvRINJPOcAWooVUhX17MGj
        t8+G/HTfp7JKl6LTtiYLTy0QbR/Q1pxBOmmrkv6b0uuiN7dmqndKs0rA0tYL1bxMc0RnQmQVWSipf
        um3+K48A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l80Se-002ISd-K2; Fri, 05 Feb 2021 12:43:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 29A623012DF;
        Fri,  5 Feb 2021 13:43:43 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 146892BC43FEE; Fri,  5 Feb 2021 13:43:43 +0100 (CET)
Date:   Fri, 5 Feb 2021 13:43:43 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhimin Feng <fengzhimin@bytedance.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com
Subject: Re: [RFC: timer passthrough 5/9] KVM: vmx: use tsc_adjust to enable
 tsc_offset timer passthrough
Message-ID: <YB09f5oJ+sP9hiy6@hirez.programming.kicks-ass.net>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
 <20210205100317.24174-6-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205100317.24174-6-fengzhimin@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 06:03:13PM +0800, Zhimin Feng wrote:
> when in vm:
> rdtsc = host_tsc * (TSC multiplier) + tsc_offset(<0)
> so when vm write tsc_deadline_msr the value always less than
> tsc stampcounter msr value, the irq never be triggered.
> 
> the tsc_adjust msr use as below, host execute
> rdtsc = host_tsc + tsc_adjust
> 
> when vmentry, we set the tsc_adjust equal tsc_offset and vmcs
> tsc offset filed equal 0, so the vm execute rdtsc the result like this:
> rdtsc = host_tsc + tsc_adjust + 0
> the tsc_deadline_msr value will equal tsc stampcounter msr and
> the irq will trigger success.

That above is unintelligible..

> +static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, bool to_host)
> +{
> +	u64 tsc_adjust;
> +	struct timer_passth_info *local_timer_info;
> +
> +	local_timer_info = &per_cpu(passth_info, smp_processor_id());
> +
> +	if (to_host) {
> +		tsc_adjust = local_timer_info->host_tsc_adjust;
> +		wrmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust);
> +		vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
> +	} else {
> +		rdmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust);
> +		local_timer_info->host_tsc_adjust = tsc_adjust;
> +
> +		wrmsrl(MSR_IA32_TSC_ADJUST, tsc_adjust + vcpu->arch.tsc_offset);
> +		vmcs_write64(TSC_OFFSET, 0);
> +	}
> +}

NAK

This wrecks the host TSC value, any host code between this and actually
entering that VM will observe batshit time.
