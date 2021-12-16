Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE434771DF
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 13:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhLPMbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 07:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbhLPMbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 07:31:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C0DC061574
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 04:31:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4228CB8239A
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 12:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3638C36AE5;
        Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639657901;
        bh=CDudM23/Ldbqy4qHDQg2AGLcMYrp9+dLWLgU6xu+KYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pB4hG53OMFyNQuUXa1H1JO3ZRK+ntCjfRdXh21t/KOMk7sRRQRV70ygg6/smj3rwL
         co+V/iISlpnrkzt8CCQoxNv3fZ5YNvwbRjJ6P4ZHScLHAg6Ojg3NYMs1B7CQfrRVTg
         WDz8aG8QZ918fjUTA2bGpgfoct13NIStLcKQFlFgUFPvayNMdhVZKmbGSJ8fSr0tx+
         aOO3UW+tislIFNJ6YVuZqfdkHVYlTXph/Z9Ylo/jXTFPaGAJDEyEvoJIT8bn8hKcc9
         qKx9FejTwyb0v/l4W5vxosH0u0W6aYC1KfIwpaxCdK/+X80+G0Weu7X9LzHXC7DQ6a
         IppJEB+251twg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mxpv9-00CWIB-3p; Thu, 16 Dec 2021 12:31:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH 5/5] KVM: selftests: arm64: Add support for VM_MODE_P36V48_{4K,64K}
Date:   Thu, 16 Dec 2021 12:31:35 +0000
Message-Id: <20211216123135.754114-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211216123135.754114-1-maz@kernel.org>
References: <20211216123135.754114-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the arm64 systems out there have an IPA space that is
positively tiny. Nonetheless, they make great KVM hosts.

Add support for 36bit IPA support with 4kB pages, which makes
some of the fruity machines happy. Whilst we're at it, add support
for 64kB pages as well, though these boxes have no support for it.

16kB is left as a exercise for the eager reviewer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h      | 2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 8 ++++++++
 tools/testing/selftests/kvm/lib/guest_modes.c       | 4 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c          | 6 ++++++
 4 files changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d2ba830a1faf..a8f7605ddf48 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -48,6 +48,8 @@ enum vm_guest_mode {
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
 	VM_MODE_P47V64_4K,
 	VM_MODE_P44V64_4K,
+	VM_MODE_P36V48_4K,
+	VM_MODE_P36V48_64K,
 	NUM_VM_MODES,
 };
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index b4eeeafd2a70..a313fbed53a0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -264,6 +264,14 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init
 		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		tcr_el1 |= 2ul << 32; /* IPS = 40 bits */
 		break;
+	case VM_MODE_P36V48_4K:
+		tcr_el1 |= 0ul << 14; /* TG0 = 4KB */
+		tcr_el1 |= 1ul << 32; /* IPS = 36 bits */
+		break;
+	case VM_MODE_P36V48_64K:
+		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
+		tcr_el1 |= 1ul << 32; /* IPS = 36 bits */
+		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 8db9ea2c4032..f1d3b0c012c7 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -72,6 +72,10 @@ void guest_modes_append_default(void)
 			if (ps4k)
 				vm_mode_default = VM_MODE_P40V48_4K;
 		}
+		if (limit >= 36) {
+			guest_mode_append(VM_MODE_P36V48_4K, ps4k, ps4k);
+			guest_mode_append(VM_MODE_P36V48_64K, ps64k, ps64k);
+		}
 
 		/* Pick the largest supported IPA size */
 		for (i = 0;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index daf6fdb217a7..3dc554430082 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -172,6 +172,8 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_PXXV48_4K]	= "PA-bits:ANY, VA-bits:48,  4K pages",
 		[VM_MODE_P47V64_4K]	= "PA-bits:47,  VA-bits:64,  4K pages",
 		[VM_MODE_P44V64_4K]	= "PA-bits:44,  VA-bits:64,  4K pages",
+		[VM_MODE_P36V48_4K]	= "PA-bits:36,  VA-bits:48,  4K pages",
+		[VM_MODE_P36V48_64K]	= "PA-bits:36,  VA-bits:48, 64K pages",
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
@@ -191,6 +193,8 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_PXXV48_4K]	= {  0,  0,  0x1000, 12 },
 	[VM_MODE_P47V64_4K]	= { 47, 64,  0x1000, 12 },
 	[VM_MODE_P44V64_4K]	= { 44, 64,  0x1000, 12 },
+	[VM_MODE_P36V48_4K]	= { 36, 48,  0x1000, 12 },
+	[VM_MODE_P36V48_64K]	= { 36, 48, 0x10000, 16 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
@@ -252,9 +256,11 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 		vm->pgtable_levels = 3;
 		break;
 	case VM_MODE_P40V48_4K:
+	case VM_MODE_P36V48_4K:
 		vm->pgtable_levels = 4;
 		break;
 	case VM_MODE_P40V48_64K:
+	case VM_MODE_P36V48_64K:
 		vm->pgtable_levels = 3;
 		break;
 	case VM_MODE_PXXV48_4K:
-- 
2.30.2

