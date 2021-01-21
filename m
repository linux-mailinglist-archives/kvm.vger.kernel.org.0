Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB32FECDD
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbhAUO2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:28:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbhAUO1Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 09:27:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611239148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilhpMvCfjFiElS7bgjbZqmd9IpUEn0B8JkfPwC0b+mk=;
        b=FOids93nIL2v99SXE0OtlkFAfculyOhH2MEwazs8np9ugfQP8NAHZr3Xp4rAchKlf519XD
        z6b04YbjY/Jvz7Iuyy015laBKqYTgjyXZOGWNqaz0L5X5Kp5mbtCXuqCbHQs6B5wDoHZEJ
        Zqd2XPNMWFEtSVfdaIj2pKyQNrykVQ8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-vkCR8SWsOtGRKeUS4hB39Q-1; Thu, 21 Jan 2021 09:25:46 -0500
X-MC-Unique: vkCR8SWsOtGRKeUS4hB39Q-1
Received: by mail-ej1-f69.google.com with SMTP id gt18so820008ejb.18
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 06:25:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ilhpMvCfjFiElS7bgjbZqmd9IpUEn0B8JkfPwC0b+mk=;
        b=Ug61akIIWw/SzWPapQv0u7ppW1oXSxrtA6jN+IPEZdMGBP2/CjXsp09WKMVJ+vJ1Fc
         UKN5Xlgk4EswBBUWiFJgJFPaRd1xBzi1/t5MZuW84DvVQ0qItiKB7s7nmEKDOXz1whls
         vq4HBspWvBjTgar3PAGVnHoGopo9RmIPSA+WKVQwGPa0uidT7dilIoI+Pq+HP2bVGf/y
         Peet8KW/KSFPJCFlazc6L9r2/SwIFkrWs5xpqfut5e+F3tppLgnGVCc9XTtJojy/dOkM
         gugOQ4UAiB9gaeZVDYwv7GvJmxZo8qop+UtgcMtqVe6JHDMubbSniBFLGT7AkBbhxVvd
         XM0w==
X-Gm-Message-State: AOAM532i8SI0lziFgf7uoqfjlarGj6vi+GLx0XBcvRAioKn90xBvwzxR
        jjbgTyIKtl0H7v4LeBpUg19ePkYX1PwJS5xD+mhjRltA4NO6N/372k3VdPbv1lOjvNEZZrpXb/5
        VUAtcSKzaIDXi
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr9395279ejq.517.1611239144787;
        Thu, 21 Jan 2021 06:25:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpASqyEPkiyX9HLBJSuLOzYLLasq+dJWlIvr4kVJBrv43P0n6PmUlJnq6LqcM4doL9ZwLq0A==
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr9395260ejq.517.1611239144659;
        Thu, 21 Jan 2021 06:25:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r10sm2870779edw.24.2021.01.21.06.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 06:25:43 -0800 (PST)
Subject: Re: [PATCH v2 4/4] KVM: SVM: Support #GP handling for the case of
 nested on nested
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        mlevitsk@redhat.com, seanjc@google.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210121065508.1169585-1-wei.huang2@amd.com>
 <20210121065508.1169585-5-wei.huang2@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8eb44204-51c2-d3c8-3adf-f825544f3c88@redhat.com>
Date:   Thu, 21 Jan 2021 15:25:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210121065508.1169585-5-wei.huang2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/21 07:55, Wei Huang wrote:
> +	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM)) {
> +		best = kvm_find_cpuid_entry(vcpu, 0x8000000A, 0);
> +		best->edx |= (1 << 28);
> +	}
> +

Instead of this, please use kvm_cpu_cap_set in svm_set_cpu_caps's "if 
(nested)".

Paolo

