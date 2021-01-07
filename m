Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AE52ECEB0
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbhAGLWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbhAGLWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:22:42 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 926A92333F;
        Thu,  7 Jan 2021 11:21:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kxTM3-005p1o-Ny; Thu, 07 Jan 2021 11:21:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/18] KVM: Documentation: Add arm64 KVM_RUN error codes
Date:   Thu,  7 Jan 2021 11:20:52 +0000
Message-Id: <20210107112101.2297944-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com, mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com, shannon.zhao@linux.alibaba.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

The API documentation states that general error codes are not detailed, but
errors with specific meanings are. On arm64, KVM_RUN can return error
numbers with a different meaning than what is described by POSIX or the C99
standard (as taken from man 3 errno).

Absent from the newly documented error codes is ERANGE which can be
returned when making a change to the EL2 stage 1 tables if the address is
larger than the largest supported input address. Assuming no bugs in the
implementation, that is not possible because the input addresses which are
mapped are the result of applying the macro kern_hyp_va() on kernel virtual
addresses.

CC: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201201150157.223625-2-alexandru.elisei@arm.com
---
 Documentation/virt/kvm/api.rst | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e00a66d72372..4e5316ed10e9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -380,9 +380,14 @@ This ioctl is obsolete and has been removed.
 
 Errors:
 
-  =====      =============================
+  =======    ==============================================================
   EINTR      an unmasked signal is pending
-  =====      =============================
+  ENOEXEC    the vcpu hasn't been initialized or the guest tried to execute
+             instructions from device memory (arm64)
+  ENOSYS     data abort outside memslots with no syndrome info and
+             KVM_CAP_ARM_NISV_TO_USER not enabled (arm64)
+  EPERM      SVE feature set but not finalized (arm64)
+  =======    ==============================================================
 
 This ioctl is used to run a guest virtual cpu.  While there are no
 explicit parameters, there is an implicit parameter block that can be
-- 
2.29.2

