Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07922793A1
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgIYVda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:33:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgIYVd3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 17:33:29 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3c4JA853+MUs8W705Chfme2NTUjBzFU4aO/rVsVwkNI=;
        b=Iq3hL+XBfh2SsM2L7vKIiRahkT+2DtB6wN77PHtNzBP8Zy4RHSFaMXGibVEE5G/8wEWzpw
        IhTtgKaYy19FHLf3BRbPDbUGa35XYk7x65RSuWQwvaEw/A4rpUvY5XQnMOPd2hvgIHAcqM
        GdtBjCbnuCbO6apKSIDSPu9UnBVGZBY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-rNvZl9PZPHm0cYmntg-Lxw-1; Fri, 25 Sep 2020 17:33:26 -0400
X-MC-Unique: rNvZl9PZPHm0cYmntg-Lxw-1
Received: by mail-wm1-f70.google.com with SMTP id m125so129897wmm.7
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3c4JA853+MUs8W705Chfme2NTUjBzFU4aO/rVsVwkNI=;
        b=k855lsc+IvoNL4Ae9aOtyrp+RfcHT3/Cdt32tLopAFvtHNP2gaQN59Y6gUwFJOj/jI
         T9jaWn9b1+OxN5M1wqtKN8kRK2QuE7kcvOxfB4tRnQLakzWR7qLhyaEdzfD2QHP525YT
         l8bZvVMmDFhue+6uSFg+kpqOeaA8eX9Uit0Fs7mknCkVcNw11mHtL5dO2L4DQnbO8E46
         kRuHtrBPkiVXn2gsXNMWZgG/a0xjmibhlpOq5rhKQ2OYLhaR985Op4ti6sOVdjnbb4lx
         NFeFynQiF/1zfSIyQgmvfkvixUXQQzw1qadgsNDOsvHRkY/cBRmXApQkhfGUjR4Nlbx0
         bLdA==
X-Gm-Message-State: AOAM532UioPvjTW4JFFMCwA/0wYOiDK3B2OvPRF+bxrXkB158qY05gWJ
        xIEuJmgztqiLo0p3cENrg7E392yCJhy65EYcBqB33k4csHyOQq2zVFuhwR0XXh/VtAFne6E2xiv
        I1udBaD29Z/g9
X-Received: by 2002:adf:f784:: with SMTP id q4mr6418194wrp.126.1601069605199;
        Fri, 25 Sep 2020 14:33:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqHSmLJdak02/gUQl83xsSwS5C5QPIsrVE9XdWg+w1sC7kbYKwff+7HcaHA2ECYOcR5Ugh4w==
X-Received: by 2002:adf:f784:: with SMTP id q4mr6418185wrp.126.1601069604992;
        Fri, 25 Sep 2020 14:33:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id h8sm4102707wrw.68.2020.09.25.14.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:33:23 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] KVM: nVMX: Explicitly check for valid guest state
 for !unrestricted guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
 <20200923184452.980-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0fc761eb-8758-ae96-65b1-90cc4d32f043@redhat.com>
Date:   Fri, 25 Sep 2020 23:33:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923184452.980-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 20:44, Sean Christopherson wrote:
> +bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu)
>  {
> -	if (enable_unrestricted_guest)
> -		return true;
> -
>  	/* real mode guest state checks */
>  	if (!is_protmode(vcpu) || (vmx_get_rflags(vcpu) & X86_EFLAGS_VM)) {
>  		if (!rmode_segment_valid(vcpu, VCPU_SREG_CS))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index d7ec66db5eb8..e147f180350f 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -343,6 +343,15 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>  void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>  u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
>  		   int root_level);
> +
> +bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu);
> +static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
> +{
> +	if (enable_unrestricted_guest)
> +		return true;
> +
> +	return __vmx_guest_state_valid(vcpu);

This is now "if (is_unrestricted_guest (vcpu))", but the patch otherwise
applies.

Paolo

