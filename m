Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855D14275FB
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244534AbhJICPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244451AbhJICPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:15:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42F7C061788
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f8-20020a2585480000b02905937897e3daso15198346ybn.2
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=v9oEyavsvbZNuuh7Q+PKViZhWtX7WRERjDZsEYQR4V4=;
        b=SCbmKo34lA8oU3dDYTZHOvAjjDoLBR2GtJ37FhHZtdcyaf6gZ6bVC5uP3+oE2UTrpm
         SJ1/Of1dkXNWhoAvrrrc0TBpKSCl7QbMbUP05V4KS7XrfFN5yznrDd3S3rpM+VJAfNxW
         sgJsB3R3InfKb1YxSdio9cjUyN5vLtdRPSuiKEuzXF8FYwyexaMMd9+vSRILinVV6qSV
         xoprkuvodBmblmVDAvTCkF2/PUTZlIljlA8Ho6n+DzaVU4wysVfev3JmNpwSBGxwUiGy
         zAM+39D7BSF2N/tsIW4ULNBWFxHAGE3XzfEwYZiASKhZBF1Ybs3+4AJhw+TkNz0XHMRV
         DQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=v9oEyavsvbZNuuh7Q+PKViZhWtX7WRERjDZsEYQR4V4=;
        b=jI+cryrPsdy/ksfcF4WRijnb701gkmqj1xYi8zu+nFSFpnL/4RxkEAW6DbpSyqhLFQ
         08FqlYeAz3RmYdhLjHB4bKPoZlDUFZFBEIfF2NcmD4oRkgGpRYPZV+6cy6XQGKuClgMF
         Lr3yQEkHkIDWh9idnEhObnHxH4uKi3DUo8K0ZczOi819xTplMWZ8RMk3WaUbIORWjMzI
         jr7DbBDIFAI26+nbys6fSz27UsdjQ7S0eAR8rBZ7391NYFTuP3GyaOjhLGuRlu+yYRto
         V347E1yeMC1gKLswX2HWZlk78p1VyGLGKWhVYK00kykMqnI2dp2bLP4TLW+JOeOmX6TU
         O8RA==
X-Gm-Message-State: AOAM533VR6Vhhzl7TuykEED172RaiAa0AxnJNRLNZrQ6xrvtEucY/Nnz
        t6Ur27jj9l9LOM/hIPNSeqtYfK5WnW4=
X-Google-Smtp-Source: ABdhPJwUqQu18tVTrfSb9It/bTdj70+Yz1bQzfPNIbddjOrg1SwRs7KNWGr+9IBciM02rc1wp9LnG/EuPwQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:4cc3:: with SMTP id z186mr7298391yba.212.1633745598902;
 Fri, 08 Oct 2021 19:13:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:08 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-16-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 15/43] KVM: stats: Add stat to detect if vcpu is currently blocking
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Zhang <jingzhangos@google.com>

Add a "blocking" stat that userspace can use to detect the case where a
vCPU is not being run because of an vCPU/guest action, e.g. HLT or WFS on
x86, WFI on arm64, etc...  Current guest/host/halt stats don't show this
well, e.g. if a guest halts for a long period of time then the vCPU could
could appear pathologically blocked due to a host condition, when in
reality the vCPU has been put into a not-runnable state by the guest.

Originally-by: Cannon Matthews <cannonmatthews@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
[sean: renamed stat to "blocking", massaged changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h  | 3 ++-
 include/linux/kvm_types.h | 1 +
 virt/kvm/kvm_main.c       | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2d837e06eeec..bdaa0e70b060 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1462,7 +1462,8 @@ struct _kvm_stats_desc {
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
 			HALT_POLL_HIST_COUNT),				       \
 	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
-			HALT_POLL_HIST_COUNT)
+			HALT_POLL_HIST_COUNT),				       \
+	STATS_DESC_ICOUNTER(VCPU_GENERIC, blocking)
 
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 2237abb93ccd..c4f9257bf32d 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -94,6 +94,7 @@ struct kvm_vcpu_stat_generic {
 	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
 	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
+	u64 blocking;
 };
 
 #define KVM_STATS_NAME_SIZE	48
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 42894ff7c474..a36ccdc93a72 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3211,6 +3211,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool waited = false;
 
+	vcpu->stat.generic.blocking = 1;
+
 	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(wait);
@@ -3227,6 +3229,8 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	kvm_arch_vcpu_unblocking(vcpu);
 
+	vcpu->stat.generic.blocking = 0;
+
 	return waited;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

