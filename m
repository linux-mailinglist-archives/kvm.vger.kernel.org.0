Return-Path: <kvm+bounces-66914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AA6CECEA3
	for <lists+kvm@lfdr.de>; Thu, 01 Jan 2026 10:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D1FAB300BA2F
	for <lists+kvm@lfdr.de>; Thu,  1 Jan 2026 09:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBBD28C869;
	Thu,  1 Jan 2026 09:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IvltGpdH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYpnwz5A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BE328C849
	for <kvm@vger.kernel.org>; Thu,  1 Jan 2026 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767258329; cv=none; b=fM/jCLE8TCwcd8LKC1/hpY8u0cNNf6UNc3zIaVQ+quqHXZWTT9rp4/bIkpe6XGCvxL+ZJTHsHNPH7XEp2SGczt4A+07D0/p4Xe0c+b3tbYogdFDeLUCu0jL8Hr5FCgHuq2jx5be7uLZyGFGVQ48AA4iifh0XuRg6x3Htb4+Ym7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767258329; c=relaxed/simple;
	bh=uJUoC1fqh3nasXV2hJWPwZ4FEafFTmiIA/eN62LUbns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br3qjZ0L6THNX/0kESJxKxOmLWEIcBI239OubIJc7Y39mvu73VSO0q00EeWzg2hQw5DH1g2CZFIetHv4fIBQh0QFEV/CW8Z8m71t65X2qmEovnQYJSoV4ss0jJqzKSq7z3skh4ACDPvbkpG+zKj7oUpvF8BuVI0CbXDcrVl/UCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IvltGpdH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RYpnwz5A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767258325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iWm1grx6lrYHMd/frQidl905aBaP2UUBVSwZpsXb4ss=;
	b=IvltGpdHwbvYOY+R8DkS+F5JWzq+Ysfad4yOcYVQVUPSbpFfryhhXQCq555IEhIg/FJ7Qx
	ZBgqBrIG/fuDqPLvW8c3LS2AKf/HcMaUGVcfgEUw2PEzQj1zOVbi6nuppUqLMtdKg8qsbG
	PFxm0KbuQovuNW7I/9eP0oU7WnTw0JU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-GXnZWRVoMA2G7rT_cbEevg-1; Thu, 01 Jan 2026 04:05:24 -0500
X-MC-Unique: GXnZWRVoMA2G7rT_cbEevg-1
X-Mimecast-MFC-AGG-ID: GXnZWRVoMA2G7rT_cbEevg_1767258323
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f4609e80so5640579f8f.3
        for <kvm@vger.kernel.org>; Thu, 01 Jan 2026 01:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767258323; x=1767863123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iWm1grx6lrYHMd/frQidl905aBaP2UUBVSwZpsXb4ss=;
        b=RYpnwz5AULkgSPrLEeCB0esRGcFu6fJQ0Dq6zfGHuAXnE6m4ZfssIAGsPZmaRF+WNw
         Kn8ag18bZmtCTjQAqyZH6M2YPS2W1qkRXA7ZGrT1cvqX98l5yNEUr8MzfHD4dp67Lln2
         A/jo+BSK+NpcExDmGNFIhrl0mNwxP76XVEMmzh0+wyrZk9uKNwD5V5KvxdLPaT1p1026
         +FIk3+BI/iVdxZB0z9gGtJCL7DCFDrBEZSFxxC1PEXRX96SMq7OSJYHlnijy5/oPB/Yv
         SZSyjvCD7EiXyBsiPf/vSA2mVGDqK7eCKa+jNFOLSdzR9UwVXdisD6RBsuaCSdEg2csp
         Zkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767258323; x=1767863123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iWm1grx6lrYHMd/frQidl905aBaP2UUBVSwZpsXb4ss=;
        b=bfTPSMLKb8JyazDwxbhTPKWP0/oaR6v5CG9Z6XwzDnEyDycj98YLTS0TKLRyQGTCVi
         grothqxF7rHMkJZxqqIi+ZlSIjyRAb91k5aQzeK0CVtVYurzPrMutvoJ8Tuuy51tokG7
         hIi1QjRjkBJE0Ge+uRxtIcsbcPjf/ccCJ6C8JZpJtaiIvwxYmwbRzLYEkQ5Uo21TS3SR
         EWDovfPwrFgRab9gQl/hORphbGLkoRBFZe39cotZ0oZX/EK+Xx3hUreI9f9sio1W9aXh
         WJh3isdpypC/sHIsOAlgDLEvfLkqB+FnCjw0fWfm+lbvV3SySyCQerqIVEu1dCyKE/pm
         4cxw==
X-Forwarded-Encrypted: i=1; AJvYcCUsYRvLfvUwMdjLic1d/BbjaWw2L4vjyHQ5NKgrqVMRgX222f99g8HThRViCnt2Cc5YCvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YykM1ErAVvSLE8xMdd0QK/hjpJuVhGC7NfZD0XgnDbvVwTcSPJr
	Q3oxC0tOSJhRxZ/TVWxeBT3ihC4gMaCFOIyuFGmEJAEQxLf+slJLPrnxaFQqsJ8vd+wHBCv1m4G
	YMf1iWUjYcyrYTEV5BO3GMce73HAw7n/IrK+1C3DOAFWikmj9p5zHCw==
X-Gm-Gg: AY/fxX6micAiE29w3dQSgf3sMwbQlr8ZnGKkOmLiEaa5vnGWdaEh3sSNqcqGmBXO6NR
	beBanGNWG10xLft2yw8XtrpUzfVEZM1V7PZoQ1JV8g4hhOmKdR/QddCFEyUqbA/f2g0R+8MGxMj
	UGi02wPBLhAWxrguzDzLdTCtP4n+vo2fSe6+C7S7r3DNzxAC5LTUIPqFv8ohXNhA4zjPQeXHcD6
	M7H4x6FE/8Wiforl2NW0kvsyhC9AeIugsq92WMKPhlMmCzd6XCwWJwYRqmHBhZri0nloRNmp3dM
	lQbYQZDRbO0eT3ELw6qyd6xn70Anxw2oT1v1e78ScxLvpw3AlLrMHseGl4StEZCP5U6rjIeosHI
	XZdEeyT0EQ0t4IPsBEKCAcS60nkXgbaokNRXe5qmbbIhQWutLgFWy2iizUAe1HtCyKl5oOhGhAf
	ChJMimlb429F2JNw==
X-Received: by 2002:a05:6000:22c3:b0:431:488:b9a8 with SMTP id ffacd0b85a97d-4324e4faa8fmr52012239f8f.33.1767258322736;
        Thu, 01 Jan 2026 01:05:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHK4rSinXKO0GzMCec4k1MO9LSkvX69N11QioqyctAOPuoTwcgEc6vYyjGquBJKrJl4vCa5KA==
X-Received: by 2002:a05:6000:22c3:b0:431:488:b9a8 with SMTP id ffacd0b85a97d-4324e4faa8fmr52012206f8f.33.1767258322288;
        Thu, 01 Jan 2026 01:05:22 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2ebfsm77898315f8f.40.2026.01.01.01.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 01:05:21 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/4] selftests: kvm: replace numbered sync points with actions
Date: Thu,  1 Jan 2026 10:05:14 +0100
Message-ID: <20260101090516.316883-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260101090516.316883-1-pbonzini@redhat.com>
References: <20260101090516.316883-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rework the guest=>host syncs in the AMX test to use named actions instead
of arbitrary, incrementing numbers.  The "stage" of the test has no real
meaning, what matters is what action the test wants the host to perform.
The incrementing numbers are somewhat helpful for triaging failures, but
fully debugging failures almost always requires a much deeper dive into
the test (and KVM).

Using named actions not only makes it easier to extend the test without
having to shift all sync point numbers, it makes the code easier to read.

[Commit message by Sean Christopherson]

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	I wrote this before seeing your patch... It's obviously
	similar but different enough that I kept my version. :)
	Thanks anyway for including it, your commit message was
	better so I used it.

 tools/testing/selftests/kvm/x86/amx_test.c | 88 +++++++++++-----------
 1 file changed, 43 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index f4ce5a185a7d..4ac41c1a7255 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -124,6 +124,14 @@ static void set_tilecfg(struct tile_config *cfg)
 	}
 }
 
+enum {
+	/* Check TMM0 against tiledata */
+	TEST_COMPARE_TILEDATA = 1,
+
+	/* Full VM save/restore */
+	TEST_SAVE_RESTORE = 2,
+};
+
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
 						    struct xstate *xstate)
@@ -131,20 +139,20 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE) &&
 		     this_cpu_has(X86_FEATURE_OSXSAVE));
 	check_xtile_info();
-	GUEST_SYNC(1);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(2);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == 0);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
-	GUEST_SYNC(3);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	/* Check save/restore when trap to userspace */
 	__tileloadd(tiledata);
-	GUEST_SYNC(4);
+	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
 	__tilerelease();
-	GUEST_SYNC(5);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	/*
 	 * After XSAVEC, XTILEDATA is cleared in the xstate_bv but is set in
 	 * the xcomp_bv.
@@ -154,6 +162,8 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT(xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA);
 
+	/* #NM test */
+
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
@@ -166,13 +176,13 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA));
 
-	GUEST_SYNC(6);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
 	__tileloadd(tiledata);
-	GUEST_SYNC(10);
+	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
 
 	GUEST_DONE();
 }
@@ -180,18 +190,18 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 void guest_nm_handler(struct ex_regs *regs)
 {
 	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
-	GUEST_SYNC(7);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
-	GUEST_SYNC(8);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(9);
+	GUEST_SYNC(TEST_SAVE_RESTORE);
 }
 
 int main(int argc, char *argv[])
@@ -244,6 +254,7 @@ int main(int argc, char *argv[])
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
+	int iter = 0;
 	for (;;) {
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
@@ -253,20 +264,9 @@ int main(int argc, char *argv[])
 			REPORT_GUEST_ASSERT(uc);
 			/* NOT REACHED */
 		case UCALL_SYNC:
-			switch (uc.args[1]) {
-			case 1:
-			case 2:
-			case 3:
-			case 5:
-			case 6:
-			case 7:
-			case 8:
-				fprintf(stderr, "GUEST_SYNC(%ld)\n", uc.args[1]);
-				break;
-			case 4:
-			case 10:
-				fprintf(stderr,
-				"GUEST_SYNC(%ld), check save/restore status\n", uc.args[1]);
+			++iter;
+			if (uc.args[1] & TEST_COMPARE_TILEDATA) {
+				fprintf(stderr, "GUEST_SYNC #%d, check TMM0 contents\n", iter);
 
 				/* Compacted mode, get amx offset by xsave area
 				 * size subtract 8K amx size.
@@ -279,11 +279,25 @@ int main(int argc, char *argv[])
 				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
 				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
 				kvm_x86_state_cleanup(state);
-				break;
-			case 9:
-				fprintf(stderr,
-				"GUEST_SYNC(%ld), #NM exception and enable amx\n", uc.args[1]);
-				break;
+			}
+			if (uc.args[1] & TEST_SAVE_RESTORE) {
+				fprintf(stderr, "GUEST_SYNC #%d, save/restore VM state\n", iter);
+				state = vcpu_save_state(vcpu);
+				memset(&regs1, 0, sizeof(regs1));
+				vcpu_regs_get(vcpu, &regs1);
+
+				kvm_vm_release(vm);
+
+				/* Restore state in a new VM.  */
+				vcpu = vm_recreate_with_one_vcpu(vm);
+				vcpu_load_state(vcpu, state);
+				kvm_x86_state_cleanup(state);
+
+				memset(&regs2, 0, sizeof(regs2));
+				vcpu_regs_get(vcpu, &regs2);
+				TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
+					    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
+					    (ulong) regs2.rdi, (ulong) regs2.rsi);
 			}
 			break;
 		case UCALL_DONE:
@@ -293,22 +307,6 @@ int main(int argc, char *argv[])
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
 
-		state = vcpu_save_state(vcpu);
-		memset(&regs1, 0, sizeof(regs1));
-		vcpu_regs_get(vcpu, &regs1);
-
-		kvm_vm_release(vm);
-
-		/* Restore state in a new VM.  */
-		vcpu = vm_recreate_with_one_vcpu(vm);
-		vcpu_load_state(vcpu, state);
-		kvm_x86_state_cleanup(state);
-
-		memset(&regs2, 0, sizeof(regs2));
-		vcpu_regs_get(vcpu, &regs2);
-		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
-			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
-			    (ulong) regs2.rdi, (ulong) regs2.rsi);
 	}
 done:
 	kvm_vm_free(vm);
-- 
2.52.0


