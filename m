Return-Path: <kvm+bounces-48523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C61ACF279
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6FB3A496E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADC618DB01;
	Thu,  5 Jun 2025 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="inNINCqb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C01AC44D
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135780; cv=none; b=uT8T2xo8cEGOlnaX1ewPtRTq9JBB0GeBrsWXMeL7atDl34oG39FcUg+bhn2e32La65PiUkH+v/ZnZ1VxyxRoLfo7DhS7GGx61zT++RkdbbT7lintaf9HrdTkca23K3rBNETfxNKZ3ljGCj6LNNEAK40Gpgiy+1eQiURznWJfSFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135780; c=relaxed/simple;
	bh=6ebvtx27JnbmpcCRxTaFDXwmEkzSZL+DSbCdff1DwQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UyVa6ofN2fbWpG6bkWmD0W47/8IlWR7kinoAN5eyC3v9jDSWFT+blm4Ke5eb+ryUM41+ApDhRfgZdjyOJdvLRjeKdTVNzGLF+jDwPBrzRed/mzbLmAKeYd4YtQ5gkP2XU7KBTr/6Me0jp34wAui5NrrVswyKH5IGh2tvhrHeefk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=inNINCqb; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2e990e17650so1022222fac.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749135777; x=1749740577; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4QpCwuMDO3ieFJHgjbXdb25+Lz909bG6cS+4hVbc5I=;
        b=inNINCqbeUyMSgffnSG7LOznLR13o0rZGMxG1i3w1nTMx2n3hGzleCIPnRp53r+JEd
         03HuyLrcVZHo1diGFfNb4jJRImE2hUtM+LDmnuG7XFyschD2psVQtnug/Gv9ih6mJhF4
         JI6lATcu48XDfG/agCteHhg6EA4mcps/olDqMytMvnjw86XEVzfjvPIivSs3iFst4WW+
         NnxMZMKOSkvqZRyKlVzWniI370KZARCX0tK9GKSrtP4sb0EV4EU0/T9dU/QAlhmSTGNW
         GdyZSWYpM7bAonMa5bXfCuUOVDeKAmiKyqZ375m0HtF48XSN3UIVh1NLYN8qJ6x8Yuvx
         0XWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749135777; x=1749740577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F4QpCwuMDO3ieFJHgjbXdb25+Lz909bG6cS+4hVbc5I=;
        b=Q3hU/Yq9CHsDRIiJ11mnkGzj/Gcfy0gjVKKwrS1sVqHAXBkifUmY9XTZiej2MixYpE
         L2tHOq9GVx0Wb4Cx1pgVjiAMHhkmMz6wB9SwKso50Ag69LHgH3CXMfddqAmcuSOBRwOA
         xUjdPKhzwyqKLDyFdj5dTJM59qO8465SLd/l426gmbx1h36t0+quDuH3HaG+yn0t2hSk
         GA9k2FRJtoKUyrIRUOVF7hVtT87fZBNBUUJQCB8JFAGGJa2iGyc0YhP0ByH/QHkVhmhZ
         ziddQ6Fa8TlRC/xqm2x0LJAVYwQMuPNbwUpdK6ND15wnuCtXsqX7rm+xmtWyyAqXsd8w
         2bZA==
X-Gm-Message-State: AOJu0YxXT+R7B66Rr63kuGCYvk3POID9dP0KLzNQ3et37Yf+azLHF9P1
	gNngFbGd1dz5LKaa/IOz/tYAUvVVvOzyKsMD/+iN5LeKf/vOY7RfZPmol4sA2OlssD/EVvPqGDg
	Lxz/s6qwNFJNECGBGV4FhkQ45IMB7Hl+xR58EREoR94We6Trp/FG0+pMT6dWWlWhhELcFA575vI
	LgCmLJFFNBzLMFW+L3zEeaEZw2PAYIUS93J43EQDlezPfAZn9b9GDKbaQbbKk=
X-Google-Smtp-Source: AGHT+IEGgg2iURpToiwcoNT/TtIwkShYVJHPggNKgfXkCJt3fQ3ClBkysBTk4Q3GO67DXJVVpKXITswreVrMxROnKw==
X-Received: from oablb10.prod.google.com ([2002:a05:6871:414a:b0:2d5:5a26:d92])
 (user=dionnaglaze job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:aa88:b0:296:9c08:51a3 with SMTP id 586e51a60fabf-2e9bf66b5f8mr4663231fac.39.1749135777310;
 Thu, 05 Jun 2025 08:02:57 -0700 (PDT)
Date: Thu,  5 Jun 2025 15:02:35 +0000
In-Reply-To: <20250605150236.3775954-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605150236.3775954-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250605150236.3775954-2-dionnaglaze@google.com>
Subject: [PATCH v6 1/2] kvm: sev: Add SEV-SNP guest request throttling
From: Dionna Glaze <dionnaglaze@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Thomas Lendacky <Thomas.Lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The AMD-SP is a precious resource that doesn't have a scheduler other
than a mutex lock queue. To avoid customers from causing a DoS, a
kernel module parameter for rate limiting guest requests is added.

The default value does not impose any rate limiting.

Throttling vs scheduling:
Even though Linux kernel mutexes have fair scheduling, the SEV command
mutex is not enough to balance the AMD-SP load in a manner that favors
the host to run VM launches for low boot latency over traffic from the
guest in the form of guests requests that it can't predict.
Boot sequence commands and guest request commands all contend on
the same mutex, so boot latency is affected by increased guest request
contention.

A VM launch may see dozens of SNP_LAUNCH_UPDATE commands before
SNP_LAUNCH_FINISH, and boot times are a heavily protected metric in
hyperscalars.
To favor lower latency of VM launches over each VM's ability to request
attestations at a high rate, the guest requests need a secondary
scheduling mechanism.
It's not good practice to hold a lock and return to user space, so using
a secondary lock for VM launch sequences is not an appropriate solution.
For simplicity, merely set a rate limit for every VM's guest requests
and allow a system administrator to tune that rate limit to platform
needs.

Design decisions:
The throttle rate for a VM cannot be changed once it has been started.
The rate the VM gets is its level of service, so it should not be
degradable by a mem_enc_ioctl for example.

Empirical investigation:
With a test methodology of turning up N-1 "antagonist" VMs with 2 vCPUs
and 4GiB RAM that all request a SEV-SNP attestation a tight loop before
measuring the boot latency of the Nth VM, an effective quality of service
should keep the average boot latency at levels without any guest request
contention.

On a dedicated 256 core AMD Zen3 with 1TiB of RAM, continuous performance
testing shows that a boot latency of 220ms +- 50ms is typical with N in
{4, 16, 32, 64} when the request rate is set to 1/s.

After N=64, the rate limit of 1 HZ is insufficient to hold back enough
time for the final VM launch to succeed consistently in the contention.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1aa0f07d3a63..e45f0cfae2bd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -12,13 +12,16 @@
 #include <linux/kvm_host.h>
 #include <linux/kernel.h>
 #include <linux/highmem.h>
+#include <linux/limits.h>
 #include <linux/psp.h>
 #include <linux/psp-sev.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
+#include <linux/ratelimit.h>
 #include <linux/trace_events.h>
+#include <linux/units.h>
 #include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
@@ -59,6 +62,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+/* set a per-VM rate limit for SEV-SNP guest requests on VM creation. 0 is unlimited. */
+static int sev_snp_request_ratelimit_khz = 0;
+module_param(sev_snp_request_ratelimit_khz, int, 0444);
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -367,6 +374,7 @@ static int snp_guest_req_init(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct page *req_page;
+	u64 throttle_interval;
 
 	req_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!req_page)
@@ -381,6 +389,9 @@ static int snp_guest_req_init(struct kvm *kvm)
 	sev->guest_req_buf = page_address(req_page);
 	mutex_init(&sev->guest_req_mutex);
 
+	throttle_interval = ((u64)sev_snp_request_ratelimit_khz * HZ) / HZ_PER_KHZ;
+	ratelimit_state_init(&sev->snp_guest_msg_rs, sev_snp_request_ratelimit_khz, 1);
+
 	return 0;
 }
 
@@ -4028,6 +4039,12 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 
 	mutex_lock(&sev->guest_req_mutex);
 
+	if (!__ratelimit(&sev->snp_guest_msg_rs)) {
+		svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
+		ret = 1;
+		goto out_unlock;
+	}
+
 	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE)) {
 		ret = -EIO;
 		goto out_unlock;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f16b068c4228..2643c940d054 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -18,6 +18,7 @@
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/bits.h>
+#include <linux/ratelimit.h>
 
 #include <asm/svm.h>
 #include <asm/sev-common.h>
@@ -112,6 +113,8 @@ struct kvm_sev_info {
 	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
+
+	struct ratelimit_state snp_guest_msg_rs; /* Limit guest requests */
 };
 
 struct kvm_svm {
-- 
2.50.0.rc0.642.g800a2b2222-goog


