Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7CE470528
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbhLJQGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbhLJQGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:06:31 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A1C061746;
        Fri, 10 Dec 2021 08:02:55 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so32205579edv.1;
        Fri, 10 Dec 2021 08:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/pkJHvkTfabgrFQXprPevptDQISmN/4EQn4Qrf0/B5w=;
        b=BYYU8cVJm1bdb6CJZ7f9UU3YrRYGE/5Ba1PAe+LRINvDA9fY6nbxyhy+/M7pjoYleR
         gcnOvij5CYygQ0X0NXpwySIKB6rpDyg3MJyJaiv1qwnL/p5oEmP1wVu+M6a6NVdgclvO
         YBnYjTtCIa8A9LHUE1Ho1h5OFJIIDsBdDnfoCrKMcBk/qH3AAvuWUB/0iDgd1dE0AY5d
         /6TfPwbuLAweLfhX0ci2gxe3vYFpQorYDgfIrqjxmphOKSqGB/Mxz9/ds9wzVsfKq4MN
         6dCnajj0B3MrmwIcqrZwcGu534j/fYVYND9mSPyxkcx1wY8erlUp9HD/6mQFNPQ1SS5A
         dA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/pkJHvkTfabgrFQXprPevptDQISmN/4EQn4Qrf0/B5w=;
        b=MpgC0XSOjtWaYKKfZg1mN9LcyaJKyW98xPtHOdzfzNOl7MC5pBu6L+zwtrIF70oax5
         kyBpEUMCgejWAqWj1k1mrUCst7cHAGu6uzamTt3WcTj3VYKX7VtbAlwdz9IPUaDlkEcd
         xoanaeHypjaHUvm2PYrgJjlskth9QbhMEKJv4rsy6oLZtl8T5wH0AxX+CdzYZpd/1ZQ9
         SXLOJWTEMpnioi0xTw2wyzwUXwLY5TgEsAEjY7OPWhAMbQ9ZOq7AoyDWBpXbUAb8nbC3
         bZqtbgJLQaJv5n/jhd4Gf8g2b8EYy3UtF0pK3qSyDDFajEVc9Pb59RiGC0VdSiX09bRR
         QyHA==
X-Gm-Message-State: AOAM530uwbvyw1J4EJNyB3/OjYkZg53UTVyGqDqejOB8+XxixrSMRvPk
        Ow3Nw2/xlClEG9zxcHrYTAg=
X-Google-Smtp-Source: ABdhPJzssn4S/xQ5V49eHRjMYCrQLa4HgYN/sv8evrMol0f204BZKdptMwGflzm3QIXSjB7iif+2BQ==
X-Received: by 2002:a17:906:4792:: with SMTP id cw18mr25672327ejc.224.1639152174324;
        Fri, 10 Dec 2021 08:02:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id gn16sm1672620ejc.67.2021.12.10.08.02.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:02:53 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
Date:   Fri, 10 Dec 2021 17:02:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-11-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First, the MSR should be added to msrs_to_save_all and 
kvm_cpu_cap_has(X86_FEATURE_XFD) should be checked in kvm_init_msr_list.

It seems that RDMSR support is missing, too.

More important, please include:

- documentation for the new KVM_EXIT_* value

- a selftest that explains how userspace should react to it.

This is a strong requirement for any new API (the first has been for 
years; but the latter is also almost always respected these days).  This 
series should not have been submitted without documentation.

Also:

On 12/8/21 01:03, Yang Zhong wrote:
> 
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XFD))
> +			return 1;

This should allow msr->host_initiated always (even if XFD is not part of 
CPUID).  However, if XFD is nonzero and kvm_check_guest_realloc_fpstate 
returns true, then it should return 1.

The selftest should also cover using KVM_GET_MSR/KVM_SET_MSR.

> +		/* Setting unsupported bits causes #GP */
> +		if (~XFEATURE_MASK_USER_DYNAMIC & data) {
> +			kvm_inject_gp(vcpu, 0);
> +			break;
> +		}

This should check

	if (data & ~(XFEATURE_MASK_USER_DYNAMIC &
		    vcpu->arch.guest_supported_xcr0))

instead.

Paolo
