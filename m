Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78DD9A373
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405516AbfHVXCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405513AbfHVXCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:02:45 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BD80859FE
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 23:02:44 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id r1so3532902wmr.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 16:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kmQVTk4NF7XpUi8RpDZc9GfK/iw6yFL51cCifX3n1ok=;
        b=lxf/Oedx3MnLiMnLFSUeQCV3XmwMfzUW1z+aTjpM9xvtKvVN2zWYkA7z3Ux4wddCR3
         hadpfY1sYqwPYjQg5FUtFu0rSKySIST29zY3Q8xJU8u/jTTTzXiOGYLhFLRSPeLGxT1r
         +E3M5Srk7JlI/oDdaFI5RkyHH9cnWlabMXNzU1x9RBmUZavVqNpQflSSS426linS85F/
         FVnLsvhzL+/X+lJ4wfP6+FqMlo6YbTqC9PD+pOzAjUCvNuIAiYQwj+boYroaCp/znRfq
         xyood04oxBPTqqp6RTqCuungtxgFzB3o4GWwhnZxhmp3835HMc+SdXLWM3RFl80FkZqi
         zn2w==
X-Gm-Message-State: APjAAAV8aE1VjpKXPeazakRDUzh9vPxj7ztAeQxGL/OWnhg3zqlr25vr
        N1EgPX3PaNZ7uzhZZgznfpcV8SDlRHeyk/l9KCqZ5QgdNDizirYgwbmAjpspZlCosQfKbywnacZ
        TZ++ebSvnRgYt
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr1215893wro.31.1566514962633;
        Thu, 22 Aug 2019 16:02:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw+eQthuLSqmF7C2n8GS7RYzqQi6ASB9T+ssvnUGEgoQxNtMg02aB1D1t8DIs9SssHmNKP1zg==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr1215879wro.31.1566514962318;
        Thu, 22 Aug 2019 16:02:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:21b9:ff1f:a96c:9fb3? ([2001:b07:6468:f312:21b9:ff1f:a96c:9fb3])
        by smtp.gmail.com with ESMTPSA id e15sm697987wrj.74.2019.08.22.16.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:02:41 -0700 (PDT)
Subject: Re: [PATCH] i386: Omit all-zeroes entries from KVM CPUID table
To:     Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Yumei Huang <yuhuang@redhat.com>
References: <20190822225210.32541-1-ehabkost@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6e22e468-2f28-efdf-bb77-f4dae3d20f4f@redhat.com>
Date:   Fri, 23 Aug 2019 01:02:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822225210.32541-1-ehabkost@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/19 00:52, Eduardo Habkost wrote:
> KVM has a 80-entry limit at KVM_SET_CPUID2.  With the
> introduction of CPUID[0x1F], it is now possible to hit this limit
> with unusual CPU configurations, e.g.:
> 
>   $ ./x86_64-softmmu/qemu-system-x86_64 \
>     -smp 1,dies=2,maxcpus=2 \
>     -cpu EPYC,check=off,enforce=off \
>     -machine accel=kvm
>   qemu-system-x86_64: kvm_init_vcpu failed: Argument list too long
> 
> This happens because QEMU adds a lot of all-zeroes CPUID entries
> for unused CPUID leaves.  In the example above, we end up
> creating 48 all-zeroes CPUID entries.
> 
> KVM already returns all-zeroes when emulating the CPUID
> instruction if an entry is missing, so the all-zeroes entries are
> redundant.  Skip those entries.  This reduces the CPUID table
> size by half while keeping CPUID output unchanged.
> 
> Reported-by: Yumei Huang <yuhuang@redhat.com>
> Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1741508
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  target/i386/kvm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 8023c679ea..4e3df2867d 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1529,6 +1529,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>              c->function = i;
>              c->flags = 0;
>              cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
> +            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
> +                /*
> +                 * KVM already returns all zeroes if a CPUID entry is missing,
> +                 * so we can omit it and avoid hitting KVM's 80-entry limit.
> +                 */
> +                cpuid_i--;
> +            }
>              break;
>          }
>      }
> @@ -1593,6 +1600,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
>              c->function = i;
>              c->flags = 0;
>              cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
> +            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
> +                /*
> +                 * KVM already returns all zeroes if a CPUID entry is missing,
> +                 * so we can omit it and avoid hitting KVM's 80-entry limit.
> +                 */
> +                cpuid_i--;
> +            }
>              break;
>          }
>      }
> 

