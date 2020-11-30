Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6574C2C86E0
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgK3OfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:35:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726904AbgK3OfT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:35:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606746833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HFkLXb2ck3BWjmucBaw+f/gpFhUWWzy0p9pSm1cDYgw=;
        b=PLVnQjQGdbkw2Kf7AgFgp54saKynLvT7PNk+NK9JkppUTbwVNepI+/lnYAh4/jghPxjEeL
        8BnH1GW9CWrMI3xeqlptc2tpCnmpvCeRGz+sQQ2Kbdlz2CV3dZK9u4g2L0aY9SaGYZ3WlE
        4nsTyb8PPybZu2l6lzETjjSP42ZmfF0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-mfLp0DHaOiemXK-ciElmKw-1; Mon, 30 Nov 2020 09:33:51 -0500
X-MC-Unique: mfLp0DHaOiemXK-ciElmKw-1
Received: by mail-ej1-f72.google.com with SMTP id a8so5843628ejc.19
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 06:33:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HFkLXb2ck3BWjmucBaw+f/gpFhUWWzy0p9pSm1cDYgw=;
        b=e4Uc/rRB2K9hBZEBvpoEShJw4yKScu9IguGmIfitVRfWlooqeRQb37ZxyqSMk6ewKY
         DqgjhuqTNCxBqbaHboNeScCH1Ap41S0lFSsiGsUiX31eDSswSglQ+KNHgpFRL+klnGWt
         A961PSX2bbgniac7nd+Q5SkySL7BK0agiVWxXSjhy0v3LIgpcSstK0F/D+8VgVWlmvhm
         UsZkB1mHsNL2eDQUFnfo/+IC4ss2neseCP9gVuLXLuTai9QHTqiWIHkU4Ej6vIMTfv9Z
         CaNRw11tOx26/4ShtTTTMaMxqkh4LkFxEpoyjKaFQUIiLbrNJYGjTJ0CRm7skh4ia+Dc
         B+3w==
X-Gm-Message-State: AOAM530rDD3Z2Z8HJ3aJg/rlrFe9PmAXM+JA63NIvZjrikNVHSAIVccN
        +BcCZSIegKsjGd8CZtT97hMGXyxZeCWefKmgvek6gODEWA9Bvq2NQRVanQGt9ijJUIhMi/Yst7O
        yW6hQO6AfU1c9
X-Received: by 2002:a17:906:a218:: with SMTP id r24mr10440573ejy.372.1606746829959;
        Mon, 30 Nov 2020 06:33:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsu+a/K74PyJGaUN13cu1VH4GJRzXEObx7Bgwg01gB5/PI6z+n0lfbvWmX0Rt/JHx2FjPRLQ==
X-Received: by 2002:a17:906:a218:: with SMTP id r24mr10440470ejy.372.1606746828612;
        Mon, 30 Nov 2020 06:33:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w3sm9211804edt.84.2020.11.30.06.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 06:33:47 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: implement
 KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
 <20201130133559.233242-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <38602ef4-7ecf-a5fd-6db9-db86e8e974e4@redhat.com>
Date:   Mon, 30 Nov 2020 15:33:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130133559.233242-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 14:35, Maxim Levitsky wrote:
> +		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
> +			tsc_state.tsc_adjust = vcpu->arch.ia32_tsc_adjust_msr;
> +			tsc_state.flags |= KVM_TSC_STATE_TSC_ADJUST_VALID;
> +		}

This is mostly useful for userspace that doesn't disable the quirk, right?

> +		kvm_get_walltime(&wall_nsec, &host_tsc);
> +		diff = wall_nsec - tsc_state.nsec;
> +
> +		if (diff < 0 || tsc_state.nsec == 0)
> +			diff = 0;
> +

diff < 0 should be okay.  Also why the nsec==0 special case?  What about 
using a flag instead?

Paolo

