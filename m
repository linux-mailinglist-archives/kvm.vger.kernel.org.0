Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E974F1B5852
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgDWJjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:39:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWJjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587634754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=krIKFQitEIQii4FaNTmzJRbDm53HYqI5kEcn11R/yc8=;
        b=ah0zGEyER/wPsOMZK65GDplax2qj+NrrIZI9L3v7sWdCGmhuna9qlGKUjV2F36sc0yTK0y
        wnnpcIu4okOjqi1fuNk0KmEOoYbZEoTVPYaBS3sefApPWWiwXuUcrSErGfyJJGEIvmFjca
        1vMOOvdkj6ReVPiiv4tMqQkTjUxlNAk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-y9W4MobLMriKxt8mhMxcqw-1; Thu, 23 Apr 2020 05:39:12 -0400
X-MC-Unique: y9W4MobLMriKxt8mhMxcqw-1
Received: by mail-wm1-f69.google.com with SMTP id w2so218958wmc.3
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 02:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=krIKFQitEIQii4FaNTmzJRbDm53HYqI5kEcn11R/yc8=;
        b=ZFpmM1rQD7lMmimFzFEa+yjbgKZsXDzqxroUSU5d6KsPefmfKlyJbVvjFV0boVmKKA
         mlhLi74WYt3k5xR2A8hU8vV+fEY043TMGgBK80t/G2UyQUp1eOLkb5YoxP3SAy8ckkln
         PoWc4D2QSA9LObEU/qe2i5bn877BeUs7k3vCK60sSvvV9C3bPTONMhJZyezw1K1n2EmQ
         wiHSgEZwxSjqpCYXurrzShc/dnEZWSVbuSqQSPfAa4JzScjnQ40NOq/reWUCpRXWDPBP
         AQyKC2Ubj03zmpQFHXAWMj/SG2ik5RXyHO/D47sCRypGEjhojiaqQbrEOBm1402dWLX6
         sCVw==
X-Gm-Message-State: AGi0PuYQqAL7Ye0YURgH9W9PdyMEHNhWLOK531PGAiL2izgaQxjxSKOo
        hkRqdwh5Yfmq13GjPszWFsf/rBgx5LG3mavDSMhXFYnl23huUfJc1PKtk4pisSwNWejLkAypsT4
        xTh74h93f1TBs
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr4010839wrx.185.1587634751408;
        Thu, 23 Apr 2020 02:39:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypI6uS0O6WE67lrL00XGzKt4Wxu+kI7s3/b8HBMChSVaLLepDiKCBydP7j8Im1fqRhH3NZ+mJw==
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr4010807wrx.185.1587634751161;
        Thu, 23 Apr 2020 02:39:11 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id j13sm3015373wrq.24.2020.04.23.02.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:39:10 -0700 (PDT)
Subject: Re: [PATCH v2 4/5] KVM: X86: TSCDEADLINE MSR emulation fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-5-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1309372a-0dcf-cba6-9d65-e50139bbe46b@redhat.com>
Date:   Thu, 23 Apr 2020 11:37:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1587632507-18997-5-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 11:01, Wanpeng Li wrote:
> +
> +void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	if (__kvm_set_lapic_tscdeadline_msr(vcpu, data))
> +		start_apic_timer(vcpu->arch.apic);
> +}
> +
> +int kvm_set_lapic_tscdeadline_msr_fast(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +	if (__kvm_set_lapic_tscdeadline_msr(vcpu, data)) {
> +		atomic_set(&apic->lapic_timer.pending, 0);
> +		if (start_hv_timer(apic))
> +			return tscdeadline_expired_timer_fast(vcpu);
> +	}
> +
> +	return 1;
>  }
>
> +static int tscdeadline_expired_timer_fast(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
> +		kvm_clear_request(KVM_REQ_PENDING_TIMER, vcpu);
> +		kvm_inject_apic_timer_irqs_fast(vcpu);
> +		atomic_set(&vcpu->arch.apic->lapic_timer.pending, 0);
> +	}
> +
> +	return 0;
> +}

This could also be handled in apic_timer_expired.  For example you can
add an argument from_timer_fn and do

	if (!from_timer_fn) {
		WARN_ON(kvm_get_running_vcpu() != vcpu);
		kvm_inject_apic_timer_irqs_fast(vcpu);
		return;
	}

        if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
                ...
	}
	atomic_inc(&apic->lapic_timer.pending);
	kvm_set_pending_timer(vcpu);

and then you don't need kvm_set_lapic_tscdeadline_msr_fast and
everything else.  Anyway thanks, this is already much better.

Paoo

