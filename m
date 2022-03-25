Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0E04E7499
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358809AbiCYOBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243565AbiCYOBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:01:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE195F274;
        Fri, 25 Mar 2022 06:59:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w8so8093717pll.10;
        Fri, 25 Mar 2022 06:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bg55DIKCupebm5f4NqZ1g4YC1+NWU4JZUPE3B9his68=;
        b=AaqdW4yCybWq9oeRTyuwcMjcgay7UvUWcDwjQS7vzblvc3BBYtlsBPKtpSP97wC0YG
         KEhu667dydDhzy1pNmdvCsCZDomlYCNwSA1DMezLRj7Pq/65P2q5b75eJkskFCgHupcC
         mE0mjOYtaU5jCpJakMmHqigh1PXXQIM02iVieoZr375Nqrel6RZyTZ0LyGIP91IH11pN
         LAmGzWNZp5S2yDgG/Pppsnv5lBqeFS/RGx3EPNoEysuNPNztKCdN4BnhmlkfXg/jQ1bx
         fJS8u/HEGtb60VDNx4Sjr7lKCxXsQZ7BnWAEOg6RCdqmwKygB6DqUSZDkZc/KsB5fL6h
         1F9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bg55DIKCupebm5f4NqZ1g4YC1+NWU4JZUPE3B9his68=;
        b=Bz6TXbYMmYF3htiYKJSuztjQkdkVbQTnfLCstFUYuLRXQmFwM4kzwc5aBTFo/QEkos
         xkFC/Rr9JsSM0K+3qyquJh0oktXzAUwKa1Jvljox3tcSS0y472BUg/X8FFSBd/VS7UmZ
         2uz8EWwaPIkNLPHKmW1hx97hST0otktyfiwm5Sd8+2bLJIdTr6xLDICNtOHRtbSmJvKR
         BB/MjkNy5syHOADEgjqRBBcCFMRrC8nagRKT547TIIS2z5Mw+yE5oXxwcYavKMw3phng
         gu4dOBPkU++A4NNhU6YXHoY3tR7IgABMP1MPMFqx0LS2jYLZw4ga4rfk24kJLOhrqqTZ
         tnLQ==
X-Gm-Message-State: AOAM531zKRTFE0oAEFCraTQWXl4aUzlN28ooHDVwQ9ycabaVaP2+yzJT
        c8hNLdk8A0vcXK6p+i4NvXU+iYlqxms=
X-Google-Smtp-Source: ABdhPJz5BQba3hY0HQZbweCxsAW/gWaHhHMfuPXeOppEO/6EwRv27Kh+wlMeGZnn9C+jU7MoD//2qg==
X-Received: by 2002:a17:902:d486:b0:154:50c6:a0b5 with SMTP id c6-20020a170902d48600b0015450c6a0b5mr11622659plg.108.1648216769928;
        Fri, 25 Mar 2022 06:59:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm14470875pjb.53.2022.03.25.06.59.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:59:29 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 2/5] KVM: X86: Add guest interrupt disable state support
Date:   Fri, 25 Mar 2022 06:58:26 -0700
Message-Id: <1648216709-44755-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Let's get the information whether or not guests disable interruptions.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50f011a7445a..8e05cbfa9827 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -861,6 +861,7 @@ struct kvm_vcpu_arch {
 		bool preempt_count_enabled;
 		struct gfn_to_hva_cache preempt_count_cache;
 	} pv_pc;
+	bool irq_disabled;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af75e273cb32..425fd7f38fa9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4576,6 +4576,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	static_call(kvm_x86_vcpu_load)(vcpu, cpu);
 
+	vcpu->arch.irq_disabled = false;
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
 
@@ -4668,6 +4669,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
+	vcpu->arch.irq_disabled = !static_call(kvm_x86_get_if_flag)(vcpu);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -11225,6 +11227,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 	vcpu->arch.pv_pc.preempt_count_enabled = false;
+	vcpu->arch.irq_disabled = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
-- 
2.25.1

