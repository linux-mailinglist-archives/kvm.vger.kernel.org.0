Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9D4771D9
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 13:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhLPMbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 07:31:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43674 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLPMbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 07:31:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B016761DC5
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C52EC36AE5;
        Thu, 16 Dec 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639657900;
        bh=4rSkbQHvQNccr16rISKUtR7jY5pFieW8AWzfrNGTbuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGRNOAC7Xn3HzuELEenJ8leZ7alg6aXJK79jHjnyFAQElk80WahKlg2uASA+YCXVj
         zK1uuqVODsjdaGEEg8/5qKAGj7SlCslrwQADGPPtDhgOxibicd2Qt9McGwhqeCB/4v
         Xibt9BVS4Zaz4u0J3WIsgqxJ7cxk1v3afYgANmi2ioSEZZqC5CNJhUliAxM60QkV2O
         ppJ1bCfetwsGnTcu0CfTLWzbIEGFzDFhiaAaEirS5s4lc3yFHD9bswWbHR7//yitdF
         awo5jHJ3lWnT0F5IBNdHMWZ6PY4UEGeDym/9AoKIWedSZub3mRzkkp7c7svpKDuNxm
         7VattwRsmAHSg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mxpv8-00CWIB-6t; Thu, 16 Dec 2021 12:31:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH 1/5] KVM: selftests: Fix vm_compute_max_gfn on !x86
Date:   Thu, 16 Dec 2021 12:31:31 +0000
Message-Id: <20211216123135.754114-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211216123135.754114-1-maz@kernel.org>
References: <20211216123135.754114-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compiling the selftestts on arm64 leads to this:

gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 -fno-stack-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/arm64/include -I../../../../usr/include/ -Iinclude -Ilib -Iinclude/aarch64 -I..   -c lib/kvm_util.c -o /home/maz/arm-platforms/tools/testing/selftests/kvm/lib/kvm_util.o
In file included from lib/kvm_util.c:10:
include/kvm_util.h: In function ‘vm_compute_max_gfn’:
include/kvm_util.h:79:21: error: invalid use of undefined type ‘struct kvm_vm’
   79 |  return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
      |                     ^~
include/kvm_util.h:79:37: error: invalid use of undefined type ‘struct kvm_vm’
   79 |  return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
      |                                     ^~
[...]

This is all because struct kvm_vm is not defined yet (only declared).
Sidestep the whole issue by making vm_compute_max_gfn() a macro.

Fixes: c8cc43c1eae2 ("selftests: KVM: avoid failures due to reserved HyperTransport region")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index da2b702da71a..c74241ddf8b1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -74,10 +74,11 @@ enum vm_guest_mode {
 #if defined(__x86_64__)
 unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 #else
-static inline unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
-{
-	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
-}
+#define vm_compute_max_gfn(vm)						\
+	({								\
+		struct kvm_vm *__vm = vm;				\
+		((1ULL << __vm->pa_bits) >> __vm->page_shift) - 1;	\
+	})
 #endif
 
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
-- 
2.30.2

