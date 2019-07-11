Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C419657EB
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfGKNff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:35:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35160 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfGKNfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:35:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id y4so6364787wrm.2
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pH6IES3/nGr4r5FV4z7rtiiDK0sH4ktfyPk5fhHI6mI=;
        b=jRfmJy9uBGPjaqCwJ+K+wLapstFcqcHMBp29g8bhbOCwKsrn7HBDIye/hQ3Se4olhw
         m3g+5sPu3bVi9LsuLUyNAZWHb3UQ2kTWMXwCh8N6uU2QY/7XQ1ISMFpvfqG/DGyFgL8P
         ZZSFlSh+jI6mWaOTzjJrHSD8qCNFUU8U9EPiBCqoACIeTifvxltHjPaNbxSkdlYA0PZ1
         cHjf+45OP7Yb0JnRKaIOVQkSIRu701IcSWg/h64pL/N9RreD3gmg1cqYPR2JbC4tSDjK
         C3i2JXeASkELJu6eQQ6Kh3L6ttLUsJtSivq8ZBIaAqhhTaFG8FqO2nlo53yVJ8Z6vk1o
         E+kg==
X-Gm-Message-State: APjAAAVOBYN7eA5PV7ASxrEgCKq3EMB5lSH0yKTLl0tYuvOCT+SjWBjV
        5RVD5tB3vlKTQbudutO69E8QYhS0IWY=
X-Google-Smtp-Source: APXvYqzFBLJaR1P1/N+yre7g2V1AxgFlkIWWBpWilfQe9fFGL4T3KG/XXXsJKlKUMwTFvJCgFHx0IQ==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr5527822wrx.236.1562852132665;
        Thu, 11 Jul 2019 06:35:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id q18sm1999839wrw.36.2019.07.11.06.35.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 06:35:31 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 2/4] target/i386: kvm: Init nested-state for
 vCPU exposed with SVM
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     Joao Martins <joao.m.martins@oracle.com>, ehabkost@redhat.com,
        kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-3-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e7b28be0-964a-755a-6349-02396887e7d9@redhat.com>
Date:   Thu, 11 Jul 2019 15:35:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705210636.3095-3-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 23:06, Liran Alon wrote:
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  target/i386/cpu.h | 5 +++++
>  target/i386/kvm.c | 2 ++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 93345792f4cb..cdb0e43676a9 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1867,6 +1867,11 @@ static inline bool cpu_has_vmx(CPUX86State *env)
>      return env->features[FEAT_1_ECX] & CPUID_EXT_VMX;
>  }
>  
> +static inline bool cpu_has_svm(CPUX86State *env)
> +{
> +    return env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM;
> +}
> +
>  /* fpu_helper.c */
>  void update_fp_status(CPUX86State *env);
>  void update_mxcsr_status(CPUX86State *env);
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index b57f873ec9e8..4e2c8652168f 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1721,6 +1721,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>              env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
>              vmx_hdr->vmxon_pa = -1ull;
>              vmx_hdr->vmcs12_pa = -1ull;
> +        } else if (cpu_has_svm(env)) {
> +            env->nested_state->format = KVM_STATE_NESTED_FORMAT_SVM;
>          }
>      }
>  
> 

I'm not sure about it.  We have no idea what the format will be, so we
shouldn't set the format carelessly.

Paolo
