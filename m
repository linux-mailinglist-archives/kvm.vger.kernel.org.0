Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A04E12E3D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfECMrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:04 -0400
Received: from foss.arm.com ([217.140.101.70]:60858 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbfECMrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3047A15AD;
        Fri,  3 May 2019 05:47:03 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBE293F220;
        Fri,  3 May 2019 05:46:59 -0700 (PDT)
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
Subject: [PATCH 40/56] KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
Date:   Fri,  3 May 2019 13:44:11 +0100
Message-Id: <20190503124427.190206-41-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Userspace is only supposed to use KVM_ARM_VCPU_FINALIZE when there
is some vcpu feature that can actually be finalized.

This means that documenting KVM_ARM_VCPU_FINALIZE as available or
not depending on the capabilities present is not helpful.

This patch amends the documentation to describe availability in
terms of which capability is required for each finalizable feature
instead.

In any case, userspace sees the same error (EINVAL) regardless of
whether the given feature is not present or KVM_ARM_VCPU_FINALIZE
is not implemented at all.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 03df379a02b0..5519df0d3ed0 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3999,17 +3999,16 @@ userspace should not expect to get any particular value there.
 
 4.119 KVM_ARM_VCPU_FINALIZE
 
-Capability: KVM_CAP_ARM_SVE
 Architectures: arm, arm64
 Type: vcpu ioctl
 Parameters: int feature (in)
 Returns: 0 on success, -1 on error
 Errors:
   EPERM:     feature not enabled, needs configuration, or already finalized
-  EINVAL:    unknown feature
+  EINVAL:    feature unknown or not present
 
 Recognised values for feature:
-  arm64      KVM_ARM_VCPU_SVE
+  arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
 
 Finalizes the configuration of the specified vcpu feature.
 
-- 
2.20.1

