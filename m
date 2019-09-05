Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11D3AA425
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 15:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733159AbfIENQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 09:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbfIENQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 09:16:33 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D93F83DBC2
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 13:16:32 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id n3so424949wmf.3
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 06:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Y5KsV7ATk9uJXfCuKSCQPB4cqNdjilx6B68siiGooKQ=;
        b=Wgxco/1/gdK7BZRV35n+Bs4Z8Q0Jj+SSCyUB8tq0wmKOxRP/hJ33UCtjID1k1ec1nw
         Plix6EivXOQu8eqNpOCT7z+Z5iGaTI6ZW9yNy0zk1B1e59/PKp7HlPU80OZNbDSguikQ
         EgcGwUEy6Tc5o8X71dAJCri2Img+Y1TC8pUUiog7csl9a8wXDXo9eczMq+riZGXXP73m
         NvjaIngE2tXcRljXouDk0CLv9uHrHtuRFZzCB/2264hIkZgAyEmENW66L/m5CE2vPmyf
         dyrBqsZfVPHFaZgibWaqsJmKnJBcDu5Hc1GXPgg8Uq2nrg4D8xwDbTZVtLtLyiFjfti9
         2ZRw==
X-Gm-Message-State: APjAAAVRtACzSVoD/qj617LGUN6pqPES4P/SltpOVqH6qTPsVjFoJk1j
        3HrnjN+MMz3VKrMRPpWKRGMslXbAnwK1jrz6Wzpk4LVxjfLOaeDICezANujHUZ1dFMGpgkGyaQn
        4YwlAwx3TWHWz
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr2552472wrx.156.1567689391451;
        Thu, 05 Sep 2019 06:16:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzHisw8e5EMgat1Tmc61GKp+RfNfYK77Y5v5JDYEPXy2BX75X/YzGnGNtotKMognTbhj4f+aw==
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr2552454wrx.156.1567689391235;
        Thu, 05 Sep 2019 06:16:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y13sm4075087wrg.8.2019.09.05.06.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 06:16:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] KVM: LAPIC: Fix SynIC Timers inject timer interrupt w/o LAPIC present
In-Reply-To: <1567680270-14022-1-git-send-email-wanpengli@tencent.com>
References: <1567680270-14022-1-git-send-email-wanpengli@tencent.com>
Date:   Thu, 05 Sep 2019 15:16:29 +0200
Message-ID: <87ftlakhn6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Reported by syzkaller:
>
> 	kasan: GPF could be caused by NULL-ptr deref or user memory access
> 	general protection fault: 0000 [#1] PREEMPT SMP KASAN
> 	RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
> 	Call Trace:
> 	kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
> 	stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
> 	stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
> 	kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
> 	vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
> 	vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
> 	kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
> 	kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765
>
> The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUNT,
> in addition, there is no lapic in the kernel, the counters value are small 
> enough in order that kvm_hv_process_stimers() inject this already-expired 
> timer interrupt into the guest through lapic in the kernel which triggers 
> the NULL deferencing. This patch fixes it by checking lapic_in_kernel, 
> discarding the inject if it is 0.
>
> Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/hyperv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index c10a8b1..461fcc5 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_stimer *stimer)
>  		.vector = stimer->config.apic_vector
>  	};
>  
> -	return !kvm_apic_set_irq(vcpu, &irq, NULL);
> +	if (lapic_in_kernel(vcpu))
> +		return !kvm_apic_set_irq(vcpu, &irq, NULL);
> +	return 0;
>  }
>  
>  static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)

Hm, but this basically means direct mode synthetic timers won't work
when LAPIC is not in kernel but the feature will still be advertised to
the guest, not good. Shall we stop advertizing it? Something like
(completely untested):

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 3f5ad84853fb..1dfa594eaab6 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1856,7 +1856,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
                        ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
                        ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
-                       ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+
+                       /*
+                        * Direct Synthetic timers only make sense with in-kernel
+                        * LAPIC
+                        */
+                       if (lapic_in_kernel(vcpu))
+                               ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 
                        break;



-- 
Vitaly
