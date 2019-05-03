Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F7E12E3F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbfECMrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:07 -0400
Received: from foss.arm.com ([217.140.101.70]:60878 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfECMrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA8DE15AD;
        Fri,  3 May 2019 05:47:06 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 736623F220;
        Fri,  3 May 2019 05:47:03 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 41/56] KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
Date:   Fri,  3 May 2019 13:44:12 +0100
Message-Id: <20190503124427.190206-42-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

The current error code documentation for KVM_GET_ONE_REG and
KVM_SET_ONE_REG could be read as implying that all architectures
implement these error codes, or that KVM guarantees which error
code is returned in a particular situation.

Because this is not really the case, this patch waters down the
documentation explicitly to remove such guarantees.

EPERM is marked as arm64-specific, since for now arm64 really is
the only architecture that yields this error code for the
finalization-required case.  Keeping this as a distinct error code
is useful however for debugging due to the statefulness of the API
in this instance.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Fixes: 395f562f2b4c ("KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG")
Fixes: 50036ad06b7f ("KVM: arm64/sve: Document KVM API extensions for SVE")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 5519df0d3ed0..818ac97fdabc 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1873,8 +1873,10 @@ Parameters: struct kvm_one_reg (in)
 Returns: 0 on success, negative value on failure
 Errors:
   ENOENT:   no such register
-  EPERM:    register access forbidden for architecture-dependent reasons
-  EINVAL:   other errors, such as bad size encoding for a known register
+  EINVAL:   invalid register ID, or no such register
+  EPERM:    (arm64) register access not allowed before vcpu finalization
+(These error codes are indicative only: do not rely on a specific error
+code being returned in a specific situation.)
 
 struct kvm_one_reg {
        __u64 id;
@@ -2260,10 +2262,12 @@ Architectures: all
 Type: vcpu ioctl
 Parameters: struct kvm_one_reg (in and out)
 Returns: 0 on success, negative value on failure
-Errors:
+Errors include:
   ENOENT:   no such register
-  EPERM:    register access forbidden for architecture-dependent reasons
-  EINVAL:   other errors, such as bad size encoding for a known register
+  EINVAL:   invalid register ID, or no such register
+  EPERM:    (arm64) register access not allowed before vcpu finalization
+(These error codes are indicative only: do not rely on a specific error
+code being returned in a specific situation.)
 
 This ioctl allows to receive the value of a single register implemented
 in a vcpu. The register to read is indicated by the "id" field of the
-- 
2.20.1

