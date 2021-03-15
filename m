Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F5733C4F7
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhCOR4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:56:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231285AbhCOR4J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 13:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615830968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j1kmtbisPwSoThfREWhg9euwF5pmgKyEO+1jHxVyvEg=;
        b=ODNe9oGzAD8AACCyZfyGi9zr2LwO1bWTVt0obt+d9nJOBA2Bg0CAyi8eXQ+7nhcT8RBlBM
        r8RyrYEJb3FgjzRemxexg2iD08O8HfiTHFrp8T/JSrDhEkiYOaug1VnoSzRdV19cELccy0
        0Vboz+5e4FWDP5CoP8Bxt9KiUuCs9fA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-mk9aQYE9Nl2OQ5yy89Oe9A-1; Mon, 15 Mar 2021 13:56:06 -0400
X-MC-Unique: mk9aQYE9Nl2OQ5yy89Oe9A-1
Received: by mail-ej1-f71.google.com with SMTP id di5so12374217ejc.1
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 10:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j1kmtbisPwSoThfREWhg9euwF5pmgKyEO+1jHxVyvEg=;
        b=WbfN3LGUex952gDFkkmnQlIU4XaMSli6KYJhgH1YAoRLD7rXPDHxUcH7XbYX3c4r3P
         3vZmdghcu1yGjcdM8Pweub28rgcnMPehTP6m7yEe2GIw/8SnMKqwaLTlUgmuX+HuhL8w
         A8rhumeM4KqHBtycgjbf4+WOZXQXBVCmQtbXbSIEY207WPeOTQEgfxEw2tyIN2mKasA6
         U0e4rfQXt48xDcfvWx9ISRVT9c2UJflDaBzyMvmY4sOV5G2QPglG0wxx93AHfIpb5Uzr
         04tIzjLp8hQ+3dX5vcS/ss+mQxHTfhZPrgPfYvjPLY4s65P9MlIrOTIqSG//+7HFLtiE
         zCZw==
X-Gm-Message-State: AOAM530Wd4J/fAGLq+FxlBJlm21Is95oXwgo2k3JuwMm+PdhYazXgCST
        drl5bnzWIzkwo9CdaAiCxmal3w/Gnf3Ax9NnIzpPZkWIQQLh0XAYNdmwtOkkPpNwtPLSWc4u9qA
        gr+E13JDCEBaV
X-Received: by 2002:a17:907:20e4:: with SMTP id rh4mr25396812ejb.369.1615830965578;
        Mon, 15 Mar 2021 10:56:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYS/S6RGenL0C9uMdNJZ5VHvxi3+MYTPCdVCM3+O9GQ3zLKEMu86WW4iJP/f9HtQWI5RUrjA==
X-Received: by 2002:a17:907:20e4:: with SMTP id rh4mr25396785ejb.369.1615830965381;
        Mon, 15 Mar 2021 10:56:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id la15sm7992488ejb.46.2021.03.15.10.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:56:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>
References: <20210315174316.477511-1-mlevitsk@redhat.com>
 <20210315174316.477511-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0dbcff57-8197-8fbb-809d-b47a4f5e9e77@redhat.com>
Date:   Mon, 15 Mar 2021 18:56:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210315174316.477511-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 18:43, Maxim Levitsky wrote:
> +	if (!guest_cpuid_is_intel(vcpu)) {
> +		/*
> +		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
> +		 * in VMCB and clear intercepts to avoid #VMEXIT.
> +		 */
> +		if (vls) {
> +			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
> +			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> +			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> +		}
> +		/* No need to intercept these msrs either */
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> +	}

An "else" is needed here to do the opposite setup (removing the "if 
(vls)" from init_vmcb).

This also makes the code more readable since you can write

	if (guest_cpuid_is_intel(vcpu)) {
		/*
		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
		 * accesses because the processor only stores 32 bits.
		 * For the same reason we cannot use virtual
		 * VMLOAD/VMSAVE.
		 */
		...
	} else {
		/* Do the opposite.  */
		...
	}

Paolo

