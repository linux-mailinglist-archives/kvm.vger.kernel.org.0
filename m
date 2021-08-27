Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82033F919E
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 03:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244043AbhH0A6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 20:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243930AbhH0A6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 20:58:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE47C0617AF
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e137-20020a25698f000000b0059b84c50006so4918349ybc.11
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 17:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AFHcFLQ8Zudn3D234yQQ371MlX0hPffSTnop5clNbU4=;
        b=ehODs2sAzX4fmqGdkUXhOCuacyAsZ5WG5XMN79bjP+xq4RU4v9fT+sBLKRTlQqGWyX
         q30luLe7UbUT+k5DL/N9U4aU2TEa+qPeGqAJxEBE/FVgE0CuiF3raXC1RXOK3ImBGaQ4
         XbKMz4w/DkAC9W9hss3rUtWCAWdzbERpB661AM+dQQmPgaw7Ftx+tH6bG8AYsTaZ9CDU
         e02FAinIj3+x9EA64fOdiwehQIAyNOzTqpYk8MnCh+cFqm78JcgPcKiioGpdAXvwto5l
         kIPH0qjJWMM4k2bYrS2zDHxLCqBbRaCfrumPTD8MLrYqYErmy2b3iS7uHQauGeKAtamE
         EuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AFHcFLQ8Zudn3D234yQQ371MlX0hPffSTnop5clNbU4=;
        b=aqE6V1nxkjG6C1cAEu8m2pQR/KuHkg6yzlcWw6DnRqWfhGPKA1+wwg41+C55Qcc4ca
         uNshTKX4x5v1IheViJFJOS8UuSyb4fOYcaxFP2Fg0i7JtniA9YXHwstgQeidd+VKYHxz
         nzwifsEowsg5Svlxi26T+Sfkkqvds+Itz+7bSt+rgEqoQc0vdZMAqU/1ithX68pWwFnx
         85hDKo24o759uPmojY0Wyi99l4a4RcD/7Jn9VzE8nPdkKyg3YOq5ubDbNokquX9tovue
         XHCBbt7hXiAGE0uAL9I9iPC30wr0Xb2g/EaHrq7Tti0+TkCl+e7y9gzhkAvwMCaH8fms
         V2Nw==
X-Gm-Message-State: AOAM5312vn+mBQ5wfEzb9MvMU7LyR6E4ON1WFU2KwrHLmi5VF2hKDVkv
        ktTDC71N8Q2NUSvxEWiy6febSo1HZd0=
X-Google-Smtp-Source: ABdhPJxdtTMoWPCFq9FJTrWuwV5L/MyoyJcLiUL8JKOdEyDnebSuapnzs9qVktMCvhy616hB+yWZoBPXnlo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:c16c:db05:96b2:1475])
 (user=seanjc job=sendgmr) by 2002:a25:7a03:: with SMTP id v3mr2037918ybc.202.1630025867497;
 Thu, 26 Aug 2021 17:57:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 26 Aug 2021 17:57:11 -0700
In-Reply-To: <20210827005718.585190-1-seanjc@google.com>
Message-Id: <20210827005718.585190-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210827005718.585190-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 08/15] KVM: x86: Drop current_vcpu in favor of kvm_running_vcpu
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM registers perf callbacks only when the CPU is "in guest",
use kvm_running_vcpu instead of current_vcpu to retrieve the associated
vCPU and drop current_vcpu.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 +++++-------
 arch/x86/kvm/x86.h |  4 ----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d4d91944fde7..e337aef60793 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8264,17 +8264,15 @@ static void kvm_timer_init(void)
 			  kvmclock_cpu_online, kvmclock_cpu_down_prep);
 }
 
-DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
-
 static int kvm_is_in_guest(void)
 {
-	return __this_cpu_read(current_vcpu) != NULL;
+	/* x86's callbacks are registered only when handling a guest NMI. */
+	return true;
 }
 
 static int kvm_is_user_mode(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	if (WARN_ON_ONCE(!vcpu))
 		return 0;
@@ -8284,7 +8282,7 @@ static int kvm_is_user_mode(void)
 
 static unsigned long kvm_get_guest_ip(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	if (WARN_ON_ONCE(!vcpu))
 		return 0;
@@ -8294,7 +8292,7 @@ static unsigned long kvm_get_guest_ip(void)
 
 static void kvm_handle_intel_pt_intr(void)
 {
-	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	if (WARN_ON_ONCE(!vcpu))
 		return;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4c5ba4128b38..f13f15d2fab8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -393,11 +393,8 @@ static inline void kvm_unregister_perf_callbacks(void)
 	__perf_unregister_guest_info_callbacks();
 }
 
-DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu, bool is_nmi)
 {
-	__this_cpu_write(current_vcpu, vcpu);
 	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, is_nmi);
 
 	kvm_register_perf_callbacks();
@@ -408,7 +405,6 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 	kvm_unregister_perf_callbacks();
 
 	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, false);
-	__this_cpu_write(current_vcpu, NULL);
 }
 
 
-- 
2.33.0.259.gc128427fd7-goog

