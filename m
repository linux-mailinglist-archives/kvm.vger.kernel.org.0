Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21462304398
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391180AbhAZQS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:18:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391038AbhAZJ3Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 04:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611653278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TJqmWe0B1zwIrZ9/DXGf/qzkCZYW3LkB48QuI/Vyvzk=;
        b=HRRtZ4K4sE1bFnn7yM5x1XSy1waFyHjLyu2DHKGqTgzp2p0FV575LJav8fNNgPdf76IRze
        02UCwyURz650XGqdSAi+k21Khk3eMUj+cewCn9sLpK+6vDpt1Gx6GZHnV7o4mZMHyUx7fx
        3gPV2hr5MDpfVFiU1ZeNUv/oGzmDXNk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-8afVdrFUOu6-C8PXg9Z55Q-1; Tue, 26 Jan 2021 04:27:56 -0500
X-MC-Unique: 8afVdrFUOu6-C8PXg9Z55Q-1
Received: by mail-wm1-f72.google.com with SMTP id u67so1106716wmg.9
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 01:27:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TJqmWe0B1zwIrZ9/DXGf/qzkCZYW3LkB48QuI/Vyvzk=;
        b=QJSRDhlG6sxdjV10fi1STSMrbtd5MtYxaGW7KiMcmrQCLFOXHpEVmqQgucc780YIFU
         83wWAa6MIR7Ko3PXEAyVdoe02VPh5YqPHIjWeMkJrfXEF4Rlja5lI84HhK+cWJrr2vym
         iuL5XhYE8GJmHcJYGJPDr3W0pnqWDbQiaIMWQfgx09PV+wgDQKy7NUwpCVhFZC1OcWOh
         3Nk0vh0pd5svu+k0esV6RpO/MtZWtXZj+Ncl/5sm6iDMzbtZGKV6sl6+PKPKhTOIr8Y3
         /UwrMrJoHcrAi2U44BZWUrUDOCbyqxWIVK99tNIgAE+LEBUkIOnB8qvNcLqvgiO9U+JJ
         MEAg==
X-Gm-Message-State: AOAM533FPcttGqf8KXQe9XRWxnqC68dNMiyGJAht5q1pbjZEH5eSbSaR
        U9CbrRLxsNvgpKxjpHZQeHPwlP2Wurg+7BWW8gD1hZ2A+rc1aOANUuRdgtZ0TvBi8KMd5V5aHfp
        4NQJuLSoA9r8f
X-Received: by 2002:adf:d187:: with SMTP id v7mr5085170wrc.50.1611653274965;
        Tue, 26 Jan 2021 01:27:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxwJZvz1tWGNB31K2PdD/RQMxJIfSfaRIG9JEMFcujSvclTmPqLN1LlqyQzG38ZcxH8Ux9nVw==
X-Received: by 2002:adf:d187:: with SMTP id v7mr5085155wrc.50.1611653274835;
        Tue, 26 Jan 2021 01:27:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j2sm24648989wrh.78.2021.01.26.01.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 01:27:54 -0800 (PST)
Subject: Re: [RESEND v13 07/10] KVM: vmx/pmu: Reduce the overhead of LBR
 pass-through or cancellation
To:     Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108013704.134985-1-like.xu@linux.intel.com>
 <20210108013704.134985-8-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <59d947ae-3f6f-2efa-0d2d-3b130cb0bb5c@redhat.com>
Date:   Tue, 26 Jan 2021 10:27:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108013704.134985-8-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/21 02:37, Like Xu wrote:
> +
> +	/* A flag to reduce the overhead of LBR pass-through or cancellation. */
> +	bool already_passthrough;

	/* True if LBRs are marked as not intercepted in the MSR bitmap  */
	bool msr_passthrough;

>   };
>   
>   /*
> 

