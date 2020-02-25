Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239A116C383
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgBYOLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:11:42 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49536 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729411AbgBYOLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:11:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582639900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GKHDw5PV8/xPAvqhmmhG1AHbyjOb0Qq4bjwWenRm9mc=;
        b=SUlA+9ic1BikcOpUu9+Ae3NbaHRElkT46x1V5JK/BKof8m3+zrB4KZUuqzrPHvKKJLaZzS
        aE21bmo9frt8s7JiTkQRjGvHd9plRUkGpqTMH+s/I0Vdlrgen+2+g1yCxWk4fpiHqlHplf
        pFlEO+WRiv/bGHzB0sBfF6IFn0DaEMU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-1Ca2M832PeetPgsSsp8N8g-1; Tue, 25 Feb 2020 09:11:38 -0500
X-MC-Unique: 1Ca2M832PeetPgsSsp8N8g-1
Received: by mail-wr1-f69.google.com with SMTP id n23so7358577wra.20
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:11:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GKHDw5PV8/xPAvqhmmhG1AHbyjOb0Qq4bjwWenRm9mc=;
        b=rilcTtXZuUqAjVzFdjDfaaCqwrnqdIauASJpeSL1JeJWU4PVz18ANN1l+vf6iQEDcQ
         fP8IJKDTVuMVqoD03MPyySIdaw50TcpgjZzwGXpIReDAyPDV9zTBtaHaAyRL5HAnHucT
         l5AIJgCytFzRGc3v3bVaIfd1ROkzqgLY3yNHuMQm1fxoziYf9ec7b+vImD+/6aWhmra3
         BOXvaYiGrZmab3vzA0hozmNfhcGq8hpo2kodAwNRrqq6WmWgzlwy1yz7cwQTeG0IwIdu
         /4Lwl1fUtIiFtQ0Yq7ad+qNNiMIBEUoJjkFHF2MeDKp9/WZZ3hHu8HWMa+L/ehTl8RiJ
         Gfxw==
X-Gm-Message-State: APjAAAUyYhGwszc8QSYyNsSguVQdbvB5d+UYHRRZ7aU3MYo9ZaLV4cCP
        bMyIYRSGk/uWqzz+tCKyA+Eda60TGrrBGPnbBEfXYftIenQ4dwHua0dVb+VIC9zTtA3lQi7iZHU
        WqgMACtKQZvWZ
X-Received: by 2002:adf:fac7:: with SMTP id a7mr45626967wrs.299.1582639897339;
        Tue, 25 Feb 2020 06:11:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyKCmvZ12ST55zWMg1X8RfybxJfO96qE+cAaSM2+tw4Bf1MlDzhnJHkx9riQ7E5IlHPohbcZQ==
X-Received: by 2002:adf:fac7:: with SMTP id a7mr45626944wrs.299.1582639897143;
        Tue, 25 Feb 2020 06:11:37 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r1sm23257768wrx.11.2020.02.25.06.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:11:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 54/61] KVM: x86: Check for Intel PT MSR virtualization using KVM cpu caps
In-Reply-To: <20200201185218.24473-55-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-55-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 15:11:35 +0100
Message-ID: <87mu96lpt4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use kvm_cpu_cap_has() to check for Intel PT when processing the list of
> virtualized MSRs to pave the way toward removing ->pt_supported().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e4353c03269c..9d38dcdbb613 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5251,23 +5251,23 @@ static void kvm_init_msr_list(void)
>  			break;
>  		case MSR_IA32_RTIT_CTL:
>  		case MSR_IA32_RTIT_STATUS:
> -			if (!kvm_x86_ops->pt_supported())
> +			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT))
>  				continue;
>  			break;
>  		case MSR_IA32_RTIT_CR3_MATCH:
> -			if (!kvm_x86_ops->pt_supported() ||
> +			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
>  			    !intel_pt_validate_hw_cap(PT_CAP_cr3_filtering))
>  				continue;
>  			break;
>  		case MSR_IA32_RTIT_OUTPUT_BASE:
>  		case MSR_IA32_RTIT_OUTPUT_MASK:
> -			if (!kvm_x86_ops->pt_supported() ||
> +			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
>  				(!intel_pt_validate_hw_cap(PT_CAP_topa_output) &&
>  				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
>  				continue;
>  			break;
>  		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
> -			if (!kvm_x86_ops->pt_supported() ||
> +			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
>  				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
>  				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>  				continue;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

