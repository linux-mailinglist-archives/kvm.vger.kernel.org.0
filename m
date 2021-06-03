Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F147939AA12
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 20:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFCSfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 14:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhFCSfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 14:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2C8613B8;
        Thu,  3 Jun 2021 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622745242;
        bh=osyrOd8rLcVCMiPHAeJKLzTGdMUBbbPPNLLfrYOVNtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOt+VKmNu2qb7NlmlC8F8f7NZks31mqaTKoFAcQTxTnnIZsP99bm4KVUW3Fy5BRvN
         k2jFjdJeC1Ex6aXIlzQTS6Z+2nmuqbXQ5BCBEDUFJ2hXtvBa2kF4PGG8m6Ug2xCo0Q
         2mkPnUbq1g9fcBSTNR1e0d8gzL2CvA8qU1mdCLwmONsEdMYiX9MBJPQUtdKpSzTkEr
         ei3Ud1mbQSStGuUhg7+ec20zSiVnEUYt0Fyd7Ylz0JXyoDEzLq6C2N7S8fN7v4J9dy
         l0CBMMnNmYEK9oOkkz2xWN2Ub6RyqV+ey0y9/m+fBqIL12YAOOv7nPK2CygTSFZayc
         TwB4LD/lrL5yg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] KVM: arm64: Extend comment in has_vhe()
Date:   Thu,  3 Jun 2021 19:33:45 +0100
Message-Id: <20210603183347.1695-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603183347.1695-1-will@kernel.org>
References: <20210603183347.1695-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

has_vhe() expands to a compile-time constant when evaluated from the VHE
or nVHE code, alternatively checking a static key when called from
elsewhere in the kernel. On face value, this looks like a case of
premature optimization, but in fact this allows symbol references on
VHE-specific code paths to be dropped from the nVHE object.

Expand the comment in has_vhe() to make this clearer, hopefully
discouraging anybody from simplifying the code.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/virt.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 7379f35ae2c6..3218ca17f819 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -111,6 +111,9 @@ static __always_inline bool has_vhe(void)
 	/*
 	 * Code only run in VHE/NVHE hyp context can assume VHE is present or
 	 * absent. Otherwise fall back to caps.
+	 * This allows the compiler to discard VHE-specific code from the
+	 * nVHE object, reducing the number of external symbol references
+	 * needed to link.
 	 */
 	if (is_vhe_hyp_code())
 		return true;
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

