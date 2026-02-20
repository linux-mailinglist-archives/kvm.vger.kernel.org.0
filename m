Return-Path: <kvm+bounces-71377-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AI3wHQuvl2nO5QIAu9opvQ
	(envelope-from <kvm+bounces-71377-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:47:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F1950163FC1
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D13430541C9
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 00:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027B9207A32;
	Fri, 20 Feb 2026 00:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZyEsHw4I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24479212FAD
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 00:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771548162; cv=none; b=laeg+YCGoy0R1AnG1qC+FvY/nYSGlGFhmjb4L3YEPo3zMQKfAqCeW6IvMKPS7TOkMEYtIu/Q/HI9tt/VTenP3b72mUyQdRm//t+yV9b9nTdWqygw6+y5v/kCm3tgtdnXzEyC4AMyGYb0GqtwonoybCiKmVLynPDjX4amVdGkJRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771548162; c=relaxed/simple;
	bh=oO/Mstnb/hv6xOZAhuRkyWPUemNHokmZU13swYe0ZWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LsgqLevWECzGKQ0avOk8Kpf1SbQUy5ceaxW8YKwM6hIMOtaIGQUMYnbgXz2PyPAXDlDjInZy0QzxN9A8TlUBKEvdPE2QvxtxnpWPyyftnEnmM6RkhX5LiqR8mVJNky88iZyBd8XRDKWH76eZDfoLwwidmrmPC7qxlMN7YnEmApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZyEsHw4I; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad5fc5b2fso13216405ad.1
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771548159; x=1772152959; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sQBtHoV4k6KEICmmP/ngOD0EM850XDOZaHNBuV2LJiQ=;
        b=ZyEsHw4InnQuTdXlWHCzlg9MMzD0RuQawLlINMFbK8AIttfWEGYdboD23xQrWvScai
         /GPL6GFKIxbEmf5ovltgVy77rQv8uT/MoU1D8pj1VXR/K4vjtZNsTpcm2SLPHdKgElnR
         VuHN0ZPdUy9yi9sEzlbl5ds39MJlsoxjZZwSAKQZsx3Ad8ltYgYq7bb3WZga1oOAdcdY
         +YibalptvHRf7gi4WM8wlcROa6gaoIp6Qhs/QDDzmQ2tkRbskzFoCM5OTzeoCQ4JADNG
         r8P3/WUhmSmUFLTuS0H9K8268GHjWeZ3iIoWaadjnFUBb6G91yLXz/TamQEMNcUUtB1K
         Dlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771548159; x=1772152959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQBtHoV4k6KEICmmP/ngOD0EM850XDOZaHNBuV2LJiQ=;
        b=aPvAHR4rL5z5CO5wwPGk3rDJndlhJI0JHu8TJfOZdc+956wT8E2bNOJuwQiCGQ1xJN
         a0b/+Damj/0p2lZoy/CNBjMZF6gOgxTISUa+dBuVb92DYMyTRGLS1um+95LhFD9JN8rO
         R/CqJire5wnxZ2J4CjXTCIl/YcBYb00ZcTyJLAQAgaIPZh3W/BqpuzqCfFXKnSFLLWhp
         /qPFs2ufLWY5MSXGOzygnKVAsqzsWk5NZ9SOasHEU24XeVE5Z845baSYPp8CO7p77JvS
         knHCjXqZkEhpyGsGOvIpl4j4YtY70b8+ATWWTUHsj+dDHgeGBq2AznDbR9ITVzVXf6Eb
         2DmA==
X-Forwarded-Encrypted: i=1; AJvYcCWCu2MA6O035CswSZYx44j7gnuovGMsenh7aL2HZS1RGo+eG7fnvU2G0XWkGX/UxDtny0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ5CSfLxdtwruSwSc/PGS8wSaG2S1XLwtztUxa2AnWB2IwL9dP
	1nvov3glVXidsgdl7LTesOXcSzugSmL8SXdaDIaFLarPlShpUkFfTpBdCD2iIfBNiTAjpOBGErw
	13Fgmwyo4nFIkIg==
X-Received: from pllk12.prod.google.com ([2002:a17:902:760c:b0:2a9:8200:4985])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:41c7:b0:2aa:dee9:dcf4 with SMTP id d9443c01a7336-2ad50ecdb29mr69263015ad.25.1771548159168;
 Thu, 19 Feb 2026 16:42:39 -0800 (PST)
Date: Fri, 20 Feb 2026 00:42:16 +0000
In-Reply-To: <20260220004223.4168331-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260220004223.4168331-4-dmatlack@google.com>
Subject: [PATCH v2 03/10] KVM: selftests: Use gpa_t for GPAs in Hyper-V selftests
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Bibo Mao <maobibo@loongson.cn>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Colin Ian King <colin.i.king@gmail.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71377-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[google.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,brainfault.org,linux.dev,loongson.cn,linux.ibm.com,gmail.com,kernel.org,arm.com,lists.linux.dev,lists.infradead.org,vger.kernel.org,redhat.com,hotmail.com,dabbelt.com,amd.com,sanechips.com.cn,huawei.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F1950163FC1
X-Rspamd-Action: no action

Fix various Hyper-V selftests to use gpa_t for variables that contain
guest physical addresses, rather than gva_t.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/x86/hyperv_evmcs.c    | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_features.c | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c      | 6 +++---
 tools/testing/selftests/kvm/x86/hyperv_svm_test.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 58f27dcc3d5f..9fa91b0f168a 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -76,7 +76,7 @@ void l2_guest_code(void)
 }
 
 void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
-		gva_t hv_hcall_page_gpa)
+		gpa_t hv_hcall_page_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 3fe5f52e404b..fde6682c49eb 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -82,7 +82,7 @@ static void guest_msr(struct msr_data *msr)
 	GUEST_DONE();
 }
 
-static void guest_hcall(gva_t pgs_gpa, struct hcall_data *hcall)
+static void guest_hcall(gpa_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
 	uint8_t vector;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index f6385346dd10..f239923e232d 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -45,13 +45,13 @@ struct hv_send_ipi_ex {
 	struct hv_vpset vp_set;
 };
 
-static inline void hv_init(gva_t pgs_gpa)
+static inline void hv_init(gpa_t pgs_gpa)
 {
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 }
 
-static void receiver_code(void *hcall_page, gva_t pgs_gpa)
+static void receiver_code(void *hcall_page, gpa_t pgs_gpa)
 {
 	u32 vcpu_id;
 
@@ -85,7 +85,7 @@ static inline void nop_loop(void)
 		asm volatile("nop");
 }
 
-static void sender_guest_code(void *hcall_page, gva_t pgs_gpa)
+static void sender_guest_code(void *hcall_page, gpa_t pgs_gpa)
 {
 	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
 	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 436c16460fe0..b7f35424c838 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -67,7 +67,7 @@ void l2_guest_code(void)
 
 static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 						    struct hyperv_test_pages *hv_pages,
-						    gva_t pgs_gpa)
+						    gpa_t pgs_gpa)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
-- 
2.53.0.414.gf7e9f6c205-goog


