Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAC87CAA6
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 19:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfGaRhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 13:37:16 -0400
Received: from foss.arm.com ([217.140.110.172]:52552 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfGaRhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 13:37:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67BC615BF;
        Wed, 31 Jul 2019 10:37:15 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B672C3F71F;
        Wed, 31 Jul 2019 10:37:12 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Andrew Murray <andrew.murray@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 5/5] arm64: KVM: hyp: debug-sr: Mark expected switch fall-through
Date:   Wed, 31 Jul 2019 18:36:50 +0100
Message-Id: <20190731173650.12627-6-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731173650.12627-1-maz@kernel.org>
References: <20190731173650.12627-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

When fall-through warnings was enabled by default the following warnings
was starting to show up:

../arch/arm64/kvm/hyp/debug-sr.c: In function ‘__debug_save_state’:
../arch/arm64/kvm/hyp/debug-sr.c:20:19: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
  case 15: ptr[15] = read_debug(reg, 15);   \
../arch/arm64/kvm/hyp/debug-sr.c:113:2: note: in expansion of macro ‘save_debug’
  save_debug(dbg->dbg_bcr, dbgbcr, brps);
  ^~~~~~~~~~
../arch/arm64/kvm/hyp/debug-sr.c:21:2: note: here
  case 14: ptr[14] = read_debug(reg, 14);   \
  ^~~~
../arch/arm64/kvm/hyp/debug-sr.c:113:2: note: in expansion of macro ‘save_debug’
  save_debug(dbg->dbg_bcr, dbgbcr, brps);
  ^~~~~~~~~~
../arch/arm64/kvm/hyp/debug-sr.c:21:19: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
  case 14: ptr[14] = read_debug(reg, 14);   \
../arch/arm64/kvm/hyp/debug-sr.c:113:2: note: in expansion of macro ‘save_debug’
  save_debug(dbg->dbg_bcr, dbgbcr, brps);
  ^~~~~~~~~~
../arch/arm64/kvm/hyp/debug-sr.c:22:2: note: here
  case 13: ptr[13] = read_debug(reg, 13);   \
  ^~~~
../arch/arm64/kvm/hyp/debug-sr.c:113:2: note: in expansion of macro ‘save_debug’
  save_debug(dbg->dbg_bcr, dbgbcr, brps);
  ^~~~~~~~~~

Rework to add a 'Fall through' comment where the compiler warned
about fall-through, hence silencing the warning.

Fixes: d93512ef0f0e ("Makefile: Globally enable fall-through warning")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
[maz: fixed commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/debug-sr.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 26781da3ad3e..0fc9872a1467 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -18,40 +18,70 @@
 #define save_debug(ptr,reg,nr)						\
 	switch (nr) {							\
 	case 15:	ptr[15] = read_debug(reg, 15);			\
+			/* Fall through */				\
 	case 14:	ptr[14] = read_debug(reg, 14);			\
+			/* Fall through */				\
 	case 13:	ptr[13] = read_debug(reg, 13);			\
+			/* Fall through */				\
 	case 12:	ptr[12] = read_debug(reg, 12);			\
+			/* Fall through */				\
 	case 11:	ptr[11] = read_debug(reg, 11);			\
+			/* Fall through */				\
 	case 10:	ptr[10] = read_debug(reg, 10);			\
+			/* Fall through */				\
 	case 9:		ptr[9] = read_debug(reg, 9);			\
+			/* Fall through */				\
 	case 8:		ptr[8] = read_debug(reg, 8);			\
+			/* Fall through */				\
 	case 7:		ptr[7] = read_debug(reg, 7);			\
+			/* Fall through */				\
 	case 6:		ptr[6] = read_debug(reg, 6);			\
+			/* Fall through */				\
 	case 5:		ptr[5] = read_debug(reg, 5);			\
+			/* Fall through */				\
 	case 4:		ptr[4] = read_debug(reg, 4);			\
+			/* Fall through */				\
 	case 3:		ptr[3] = read_debug(reg, 3);			\
+			/* Fall through */				\
 	case 2:		ptr[2] = read_debug(reg, 2);			\
+			/* Fall through */				\
 	case 1:		ptr[1] = read_debug(reg, 1);			\
+			/* Fall through */				\
 	default:	ptr[0] = read_debug(reg, 0);			\
 	}
 
 #define restore_debug(ptr,reg,nr)					\
 	switch (nr) {							\
 	case 15:	write_debug(ptr[15], reg, 15);			\
+			/* Fall through */				\
 	case 14:	write_debug(ptr[14], reg, 14);			\
+			/* Fall through */				\
 	case 13:	write_debug(ptr[13], reg, 13);			\
+			/* Fall through */				\
 	case 12:	write_debug(ptr[12], reg, 12);			\
+			/* Fall through */				\
 	case 11:	write_debug(ptr[11], reg, 11);			\
+			/* Fall through */				\
 	case 10:	write_debug(ptr[10], reg, 10);			\
+			/* Fall through */				\
 	case 9:		write_debug(ptr[9], reg, 9);			\
+			/* Fall through */				\
 	case 8:		write_debug(ptr[8], reg, 8);			\
+			/* Fall through */				\
 	case 7:		write_debug(ptr[7], reg, 7);			\
+			/* Fall through */				\
 	case 6:		write_debug(ptr[6], reg, 6);			\
+			/* Fall through */				\
 	case 5:		write_debug(ptr[5], reg, 5);			\
+			/* Fall through */				\
 	case 4:		write_debug(ptr[4], reg, 4);			\
+			/* Fall through */				\
 	case 3:		write_debug(ptr[3], reg, 3);			\
+			/* Fall through */				\
 	case 2:		write_debug(ptr[2], reg, 2);			\
+			/* Fall through */				\
 	case 1:		write_debug(ptr[1], reg, 1);			\
+			/* Fall through */				\
 	default:	write_debug(ptr[0], reg, 0);			\
 	}
 
-- 
2.20.1

