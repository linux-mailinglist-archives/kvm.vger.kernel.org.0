Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507BF1C6FF1
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 14:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgEFMH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 08:07:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47662 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbgEFMHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 08:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588766843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o3POGybZwq1RYi539JvtIqX/Yi97vn/ZlSVvVfdJeqQ=;
        b=ghhM9duRN43E4aJonBlmgihqV53vStBXBaLJGpP5bC+EJGdTB+ArFstyKh7uEMk8IrbWoJ
        hzXcx8S71qXlos/qsAdCbhwuPhTgnoGj1tbavIF7qfVQTTdKPnfCTMjCkQSmsu0pIKy09y
        CS2Mr0TBGgFPNDUnu2XoKCb0316RY1s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-iNAfFL1dMr6LRKY-JikDPw-1; Wed, 06 May 2020 08:07:20 -0400
X-MC-Unique: iNAfFL1dMr6LRKY-JikDPw-1
Received: by mail-wm1-f71.google.com with SMTP id f128so1103215wmf.8
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 05:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o3POGybZwq1RYi539JvtIqX/Yi97vn/ZlSVvVfdJeqQ=;
        b=C62+SV775b21wYzyPl+DsatwcNEuC2XkdV2B9UrKnJBoW3azB1KQDjRA1qQAB6bfVF
         kf2WBvKIgBJSHPStiAuzlxWS9gUalzDP3j4U12ozgNSYpPOVs2RHviUFOt6wLY8LgFCq
         gMcOu3DR93X2tr8yrq6GjSIk1PSlabkSgzGqkiUD36wd4vi24G1h61g2V812XE8V0IRC
         gC8G1WK79ukLWrFXw6Gee+wIs5lgFwl0Q3ZUu5KX5xiZOwXAQ6qUHNQsbrrVXwjOaAqL
         P+CsTvgCFn73tesixHclcWlYXuoW/OFlIqipxSyy9cAJ36zOJ90aEgfnyReEB46mKMZy
         0oAQ==
X-Gm-Message-State: AGi0PubnrYfYJgFMWFCukbxLnnYIL05WgutAppUXLHn0wnHyz3HHBxvy
        qWVjkMEhri33GULM3cl/DGgVQksWK/J1Eobk7FF+KSRvuEFkAZoAG3oC5Vb+K8iy80dNIo8xP1s
        Fi0+9aKPpSQ1U
X-Received: by 2002:adf:f086:: with SMTP id n6mr4913032wro.388.1588766839109;
        Wed, 06 May 2020 05:07:19 -0700 (PDT)
X-Google-Smtp-Source: APiQypLHx9+ro8EVzvDdVasYPOm5B/qk3xF2zcu54uQKiRX1wQlGLqJkQMXTLHAJ2RdMT/xTwkl7NQ==
X-Received: by 2002:adf:f086:: with SMTP id n6mr4913008wro.388.1588766838847;
        Wed, 06 May 2020 05:07:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id t71sm2849970wmt.31.2020.05.06.05.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 05:07:18 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: get vmcs12 pages before checking pending
 interrupts
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
References: <20200505232201.923-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
Date:   Wed, 6 May 2020 14:07:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505232201.923-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 01:22, Oliver Upton wrote:
> vmx_guest_apic_has_interrupt implicitly depends on the virtual APIC
> page being present + mapped into the kernel address space. Normally,
> upon VMLAUNCH/VMRESUME, we get the vmcs12 pages directly. However, if a
> live migration were to occur before reaching vcpu_block, the virtual
> APIC will not be restored on the target host.
> 
> Fix this by getting vmcs12 pages before inspecting the virtual APIC
> page.

Do you have a selftests testcase?

> 
> +	/*
> +	 * We must first get the vmcs12 pages before checking for interrupts
> +	 * (done in kvm_arch_vcpu_runnable) in case L1 is using
> +	 * virtual-interrupt delivery.
> +	 */
> +	if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> +		if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu)))
> +			return 0;
> +	}
> +


The patch is a bit ad hoc, I'd rather move the whole "if
(kvm_request_pending(vcpu))" from vcpu_enter_guest to vcpu_run (via a
new function).

Thanks,

Paolo

