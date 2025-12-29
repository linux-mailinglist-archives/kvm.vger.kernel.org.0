Return-Path: <kvm+bounces-66804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F14E3CE8577
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 00:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70D3A301BEB1
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EE327465C;
	Mon, 29 Dec 2025 23:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O9nNK9CW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FBD19D065
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 23:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767051294; cv=none; b=tYzL8VFBcxNeiNy6PDh4s/XFKJX9/vD90Hs8lXJBIrxPRQX6jiGjodot3fzcRPbdRjJOhnl4x/RA2IsNludfIbGces2PYRFrn7sogf6jOY9FmafezXAm4+I82RNbtkYEKEnvoIuc2DIJh3/cuypC4zylVSMfKhsp0UB9JcrIM9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767051294; c=relaxed/simple;
	bh=/aJb681tBAiaCJRJ+An6/QFc6l5/IXQugRa1qSkDZt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=shUh2SAmaMzq0hIrqt5tD+TNUCpVgKJeRF1b8gx5Wjcuj2c7DqK38u+0q4Dlbu3mA4SdnRQvSyhdv7Ef2cq07oGpy3dTcfmnyVyqanKUfu6z7B783nOSNtGah8kJNJlffgijkOUxWZkYw7jXOkWMx63kIYO9gPfvKwEVlPVgRCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O9nNK9CW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c21341f56so28629302a91.2
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767051291; x=1767656091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvBf+54LzPnjcFrB5B4FddFmIs5iUS+JmK7T0omX5hM=;
        b=O9nNK9CW+xM8Dkd+09upv4uxrbo6/Bd7I+5QVWQiG28irXvggNbWxcAFSxETpwaW1w
         aHlXLKQuI7TNeRCafr3srcFrNOgQsf2oOgZ6LinpAG0lpGdd2q1KrxWkbJbA2wTKiAkA
         I+4FxXate8Ciyy/Fd0PLmKJ1dzMrl4HMeokf/+ClIixV+1jGaf6o7OyPvtYNkrMgFdlV
         9WV0QGMmwbmV6O1gdc5e/XRTxzMlDP5NUjjX5Og9qmbJjCJSkhcsImQyMjlXbqINWS+0
         xA65U0meH7MCwwjox4OhSoyYpO7n8UXVWepZwaEttiKveQx2C7phwTU5v/jHZh2BCwYB
         o8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767051291; x=1767656091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvBf+54LzPnjcFrB5B4FddFmIs5iUS+JmK7T0omX5hM=;
        b=jWto9Q9vGW8w77lVIuF6CUSg8Mwi+iFzxFH5NtJn+qhfSiTOdI9Xde/i9FmOYhNI9r
         /WeiRBn4mkVk6RCXxO+ucCKfOdITt4wH+hw9yYGWNiiP1VuTW8D76zTepVc28//Yu8AV
         +V+Bm3ya7UY33BR06WBEIGtrdKWaKc+zghBEK8dDDppJ9hWfWHbHt8iY7IGH7AD497t1
         Bxe7apry3ThNNLkmz4TdXDXNqnFFF8N8dKPA++9TW6seld2S8//oiJGDM/t/F+aBCqsb
         Gvc22LwnNUAk3mbPsAaYyStzq3frad5HtIE/dpM/hC6pR1VtSQ5gizR0x/ekU2JVG9w9
         n/hg==
X-Forwarded-Encrypted: i=1; AJvYcCWT8ehWU+cnt5p6etCMhEThHm7UgTGuCNw5QCY4d66IRmi9QS1npUxL4hY+zlUbnW+yTrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOPOsddI/ylalAlwrQHPBVLVaIOL8Xl7Hb0fqvqHaEcnCLpu34
	GKDteDZBHHkF9Pszq9uwUIFczAIWQdC+XDpNmRr26T/sMUi/tBR+s8M0lI3mXrHtwRwUoVslZrr
	NA+BHHg==
X-Google-Smtp-Source: AGHT+IG9+9rLi1SjpaDtdLgGXuzJ7TuJwiRPE7sKKvOdorBmDkSeU4/PN6zodnpKg8L11emCtJSAamvto54=
X-Received: from pjzz16.prod.google.com ([2002:a17:90b:58f0:b0:340:5073:f80f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:430f:b0:350:8066:6ebd
 with SMTP id adf61e73a8af0-376a81dcc63mr32942899637.13.1767051291411; Mon, 29
 Dec 2025 15:34:51 -0800 (PST)
Date: Mon, 29 Dec 2025 15:34:50 -0800
In-Reply-To: <20251224001249.1041934-4-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-4-pbonzini@redhat.com>
Message-ID: <aVMQGqydQPqhsrEJ@google.com>
Subject: Re: [PATCH 3/5] selftests: kvm: renumber some sync points in amx_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Content-Type: multipart/mixed; charset="UTF-8"; boundary="wIbW/lf6W61RV1YR"


--wIbW/lf6W61RV1YR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 24, 2025, Paolo Bonzini wrote:
> Make room for the next test; separated for ease of review.

Heh, but after review, the discontiguous sync numbers are super confusing.  Rather
than use arbitrary, incrementing numbers, what if we specify the action the host
should take?  Then there's very little "magic" or implicit synchronization between
the guest and host.  The only downside is that the "stage" prints are useless/lost,
but IMO that's largely a non-issue.

Tangentially related, the test doesn't ever verify that a #NM actually occurs, now
would be a good time to address that.

Full set of patches attached.

--wIbW/lf6W61RV1YR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-selftests-Use-named-sync-actions-in-AMX-test-ins.patch"

From 4031198ac76584a0e906e36796a3b41f6e428d1b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 24 Dec 2025 01:12:47 +0100
Subject: [PATCH 1/4] KVM: selftests: Use named sync actions in AMX test
 instead of arbitrary numbers

Rework the guest=>host syncs in the AMX test to use named actions instead
of arbitrary, incrementing numbers.  The "stage" of the test has no real
meaning, what matters is what action the test wants the host to perform.
The incrementing numbers are somewhat helpful for triaging failures, but
fully debugging failures almost always requires a much deeper dive into
the test (and KVM).

Opportunistically delete all prints to stderr as they aren't helpful
without the arbitrary numbers.

Using named actions will make it easier to extend the test to validate
more obscure/specific scenarios without creating a maintenance nightmare.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 88 +++++++++++-----------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index f4ce5a185a7d..3bcb10f26a70 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -124,6 +124,14 @@ static void set_tilecfg(struct tile_config *cfg)
 	}
 }
 
+enum amx_test_syncs {
+	AMX_SYNC_SAVE 		= BIT(0),
+	AMX_SYNC_RESTORE	= BIT(1),
+	AMX_SYNC_CHECK_TILEDATA	= BIT(2),
+
+	AMX_SYNC_SAVE_RESTORE = AMX_SYNC_SAVE | AMX_SYNC_RESTORE,
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
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(2);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == 0);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
-	GUEST_SYNC(3);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	/* Check save/restore when trap to userspace */
 	__tileloadd(tiledata);
-	GUEST_SYNC(4);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE | AMX_SYNC_CHECK_TILEDATA);
 	__tilerelease();
-	GUEST_SYNC(5);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	/*
 	 * After XSAVEC, XTILEDATA is cleared in the xstate_bv but is set in
 	 * the xcomp_bv.
@@ -166,13 +174,13 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA));
 
-	GUEST_SYNC(6);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
 	__tileloadd(tiledata);
-	GUEST_SYNC(10);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE | AMX_SYNC_CHECK_TILEDATA);
 
 	GUEST_DONE();
 }
@@ -180,18 +188,18 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 void guest_nm_handler(struct ex_regs *regs)
 {
 	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
-	GUEST_SYNC(7);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
-	GUEST_SYNC(8);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(9);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 }
 
 int main(int argc, char *argv[])
@@ -199,11 +207,10 @@ int main(int argc, char *argv[])
 	struct kvm_regs regs1, regs2;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct kvm_x86_state *state;
+	struct kvm_x86_state *state = NULL;
 	int xsave_restore_size;
 	vm_vaddr_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
-	u32 amx_offset;
 	int ret;
 
 	/*
@@ -253,47 +260,35 @@ int main(int argc, char *argv[])
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
-
-				/* Compacted mode, get amx offset by xsave area
-				 * size subtract 8K amx size.
-				 */
-				amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
-				state = vcpu_save_state(vcpu);
-				void *amx_start = (void *)state->xsave + amx_offset;
-				void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
-				/* Only check TMM0 register, 1 tile */
-				ret = memcmp(amx_start, tiles_data, TILE_SIZE);
-				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
-				kvm_x86_state_cleanup(state);
-				break;
-			case 9:
-				fprintf(stderr,
-				"GUEST_SYNC(%ld), #NM exception and enable amx\n", uc.args[1]);
-				break;
-			}
 			break;
 		case UCALL_DONE:
-			fprintf(stderr, "UCALL_DONE\n");
 			goto done;
 		default:
 			TEST_FAIL("Unknown ucall %lu", uc.cmd);
 		}
 
-		state = vcpu_save_state(vcpu);
+		if (uc.args[1] & AMX_SYNC_SAVE)
+			state = vcpu_save_state(vcpu);
+
+		if (uc.args[1] & AMX_SYNC_CHECK_TILEDATA) {
+			/* Compacted mode, get amx offset by xsave area
+			 * size subtract 8K amx size.
+			 */
+			u32 amx_offset = xsave_restore_size - NUM_TILES*TILE_SIZE;
+			void *amx_start = (void *)state->xsave + amx_offset;
+			void *tiles_data = (void *)addr_gva2hva(vm, tiledata);
+
+			/* Only check TMM0 register, 1 tile */
+			ret = memcmp(amx_start, tiles_data, TILE_SIZE);
+			TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
+		}
+
+
+		if (!(uc.args[1] & AMX_SYNC_RESTORE))
+			continue;
+
+		TEST_ASSERT(state, "RESTORE without a SAVE");
+
 		memset(&regs1, 0, sizeof(regs1));
 		vcpu_regs_get(vcpu, &regs1);
 
@@ -303,6 +298,7 @@ int main(int argc, char *argv[])
 		vcpu = vm_recreate_with_one_vcpu(vm);
 		vcpu_load_state(vcpu, state);
 		kvm_x86_state_cleanup(state);
+		state = NULL;
 
 		memset(&regs2, 0, sizeof(regs2));
 		vcpu_regs_get(vcpu, &regs2);

base-commit: d5228761ade7dda4bd54d273374041c15041c29e
-- 
2.52.0.351.gbe84eed79e-goog


--wIbW/lf6W61RV1YR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-selftests-Extend-AMX-test-to-set-XFD-with-active.patch"

From e4dac37229beede8658fccffd6600e7d20c55a04 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 29 Dec 2025 15:05:46 -0800
Subject: [PATCH 2/4] KVM: selftests: Extend AMX test to set XFD with active
 XTILE data

Re-load tile data in the AMX test before setting XFD, e.g. to verify that
KVM doesn't try to state for a disabled component.

Explicitly release tile data before performing the #NM test to minimize
the chances of a false pass, and to verify that TILERELEASE can execute
even if XFD[18]=1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 3bcb10f26a70..ab6d8748d7b8 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -162,6 +162,11 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT(xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA);
 
+	set_tilecfg(amx_cfg);
+	__ldtilecfg(amx_cfg);
+	__tileloadd(tiledata);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE | AMX_SYNC_CHECK_TILEDATA);
+
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
@@ -176,6 +181,7 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 
 	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
+	__tilerelease();
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
-- 
2.52.0.351.gbe84eed79e-goog


--wIbW/lf6W61RV1YR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-selftests-Add-test-to-verify-KVM-allows-loading-.patch"

From 9f69a3c7912b3ab855567960f9a574b98355cfba Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 29 Dec 2025 10:45:43 -0800
Subject: [PATCH 3/4] KVM: selftests: Add test to verify KVM allows loading
 XTILE data with XFD=1

Extend the AMX test to verify that loading guest state via KVM_SET_XSAVE
for a disabled component, i.e. with XSTATE_BV[i]=1 and XFD[i]=1, doesn't
cause KVM to explode.  To load the "bad" state, load XSAVE state from a
snapshot taken before setting XFD.  Take care to restore *only* XSAVE
state, as restoring GPRs will corrupt the guest and restoring MSRs will
make the test useless (because the test would revert to XFD=0).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 44 ++++++++++++++++++----
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index ab6d8748d7b8..1d5fffddc625 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -128,6 +128,7 @@ enum amx_test_syncs {
 	AMX_SYNC_SAVE 		= BIT(0),
 	AMX_SYNC_RESTORE	= BIT(1),
 	AMX_SYNC_CHECK_TILEDATA	= BIT(2),
+	AMX_SYNC_RESTORE_XSTATE	= BIT(3),
 
 	AMX_SYNC_SAVE_RESTORE = AMX_SYNC_SAVE | AMX_SYNC_RESTORE,
 };
@@ -165,11 +166,19 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	__tileloadd(tiledata);
-	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE | AMX_SYNC_CHECK_TILEDATA);
+
+	/* Save state and check tile data, but don't restore just yet. */
+	GUEST_SYNC(AMX_SYNC_SAVE | AMX_SYNC_CHECK_TILEDATA);
 
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
+	/*
+	 * Restore the previously saved XSTATE so that the host tries setting
+	 * tiledata while guest XFD is set.
+	 */
+	GUEST_SYNC(AMX_SYNC_RESTORE_XSTATE);
+
 	/*
 	 * XTILEDATA is cleared in xstate_bv but set in xcomp_bv, this property
 	 * remains the same even when amx tiledata is disabled by IA32_XFD.
@@ -289,20 +298,41 @@ int main(int argc, char *argv[])
 			TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
 		}
 
-
-		if (!(uc.args[1] & AMX_SYNC_RESTORE))
+		if (!(uc.args[1] & (AMX_SYNC_RESTORE | AMX_SYNC_RESTORE_XSTATE)))
 			continue;
 
 		TEST_ASSERT(state, "RESTORE without a SAVE");
 
+		TEST_ASSERT(!(uc.args[1] & AMX_SYNC_RESTORE) ||
+			    !(uc.args[1] & AMX_SYNC_RESTORE_XSTATE),
+			    "Only one type of restore is supported per sync");
+
 		memset(&regs1, 0, sizeof(regs1));
 		vcpu_regs_get(vcpu, &regs1);
 
-		kvm_vm_release(vm);
+		/*
+		 * Restore XSTATE from a previous snapshot, e.g. to verify that
+		 * KVM allows loading XTILE data when it's disabled via XFD.
+		 */
+		if (uc.args[1] & AMX_SYNC_RESTORE_XSTATE)
+			vcpu_xsave_set(vcpu, state->xsave);
+
+		if (uc.args[1] & AMX_SYNC_RESTORE) {
+			/*
+			 * Restoring *all* state from a previous snapshot will
+			 * corrupt the guest, e.g. GPRs and RIP, and send it
+			 * into the weeds.
+			 */
+			TEST_ASSERT(uc.args[1] & AMX_SYNC_SAVE,
+				    "Restoring an old snapshot will corrupt the guest");
+
+			kvm_vm_release(vm);
+
+			/* Restore state in a new VM.  */
+			vcpu = vm_recreate_with_one_vcpu(vm);
+			vcpu_load_state(vcpu, state);
+		}
 
-		/* Restore state in a new VM.  */
-		vcpu = vm_recreate_with_one_vcpu(vm);
-		vcpu_load_state(vcpu, state);
 		kvm_x86_state_cleanup(state);
 		state = NULL;
 
-- 
2.52.0.351.gbe84eed79e-goog


--wIbW/lf6W61RV1YR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-selftests-Verify-TILELOADD-actually-NM-faults-wh.patch"

From 9fc3309dbdf202e2bfaf7c79cbb608232d34e480 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 29 Dec 2025 12:23:30 -0800
Subject: [PATCH 4/4] KVM: selftests: Verify TILELOADD actually #NM faults when
 XFD[18]=1

Rework the AMX test's #NM handling to use kvm_asm_safe() to verify an #NM
actually occurs.  As is, a completely missing #NM could go unnoticed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/amx_test.c | 29 ++++++++++++++--------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 1d5fffddc625..09c0e3440f0e 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -69,6 +69,12 @@ static inline void __tileloadd(void *tile)
 		     : : "a"(tile), "d"(0));
 }
 
+static inline int tileloadd_safe(void *tile)
+{
+	return kvm_asm_safe(".byte 0xc4,0xe2,0x7b,0x4b,0x04,0x10",
+			    "a"(tile), "d"(0));
+}
+
 static inline void __tilerelease(void)
 {
 	asm volatile(".byte 0xc4, 0xe2, 0x78, 0x49, 0xc0" ::);
@@ -137,6 +143,8 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
 						    struct xstate *xstate)
 {
+	int vector;
+
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE) &&
 		     this_cpu_has(X86_FEATURE_OSXSAVE));
 	check_xtile_info();
@@ -193,16 +201,13 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	__tilerelease();
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
-	/* Trigger #NM exception */
-	__tileloadd(tiledata);
-	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE | AMX_SYNC_CHECK_TILEDATA);
 
-	GUEST_DONE();
-}
+	/* Verify TILELOADD gets #NM when XTILE_DATA is disabled via XFD. */
+	vector = tileloadd_safe(tiledata);
+	__GUEST_ASSERT(vector == NM_VECTOR,
+		       "Wanted #NM on tileloadd with XFD[18]=1, got %s",
+		       ex_str(vector));
 
-void guest_nm_handler(struct ex_regs *regs)
-{
-	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
 	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
@@ -215,6 +220,11 @@ void guest_nm_handler(struct ex_regs *regs)
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
 	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE);
+
+	__tileloadd(tiledata);
+	GUEST_SYNC(AMX_SYNC_SAVE_RESTORE | AMX_SYNC_CHECK_TILEDATA);
+
+	GUEST_DONE();
 }
 
 int main(int argc, char *argv[])
@@ -250,9 +260,6 @@ int main(int argc, char *argv[])
 
 	vcpu_regs_get(vcpu, &regs1);
 
-	/* Register #NM handler */
-	vm_install_exception_handler(vm, NM_VECTOR, guest_nm_handler);
-
 	/* amx cfg for guest_code */
 	amx_cfg = vm_vaddr_alloc_page(vm);
 	memset(addr_gva2hva(vm, amx_cfg), 0x0, getpagesize());
-- 
2.52.0.351.gbe84eed79e-goog


--wIbW/lf6W61RV1YR--

