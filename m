Return-Path: <kvm+bounces-57312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E15B53191
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B263584B55
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF103203B0;
	Thu, 11 Sep 2025 11:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTFhELJ9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9732D0612
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591863; cv=none; b=kbUdAhMgKcFknp/N+cEoO5yiKebFYWb+C3qzbObLA1F7dADm5jm1EZOm8tDQurkuNzSelbudQl9gKZJlw+f/vbKrFZDbTvsG8Prz8bFJRwVhNRFacgWLKJl+SxtB/3hYlg+PnKvMWw/NpY1RtKUGFLHvGPwogd3fvY3UIC+vTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591863; c=relaxed/simple;
	bh=FqYI/fFenEh9NNXj5tqAx70QKfo6zQDqB92zhCRqVd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYX/IrOJbu6TP2oyPVUSgAIKt7u69jZKyY6P8dz1Z/qaQVrywD070xrw/Kbx3PwwSUoftUjQuqbd5MQYfpXlv/qoPJ7ABRR+XwRruQMgOWAjYgH1Vh1vB7a4f879bN2MEHIku/OEL3hTc1EeOYM43BO72rNpfT32X/skyQC5duk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTFhELJ9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8F4C4CEF0;
	Thu, 11 Sep 2025 11:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591862;
	bh=FqYI/fFenEh9NNXj5tqAx70QKfo6zQDqB92zhCRqVd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTFhELJ9YB5jcNQyGYI1KUtcaO2BUbASn4g1PmS2sJsQn6OcojeuIw6jtKKdkSMN/
	 oJxFw93lEK+gCToqKgECCVzjgJIY/90OnzKEKLZdt9CbQwjDv3403JAg7KzL38c6kv
	 zLpRLHHBHumzlLo2KBPpqjIljGzS+TmDrUjTeUVIbjoX8mt6lVWFJoFjTzox9M2R1E
	 1FTZB98irrvpGjZAMcnXWvt/yHbzbxZ9GijPAQ0JrTGaQKbo4w4vQcbkI1VfvLarUD
	 5fp7ZS1vLrcg8D0ggoOVUNfwLUBBruWvpaYJM1psnY1VxA8TJhwqv9vzC6/t7A1r2G
	 lv4xxOxMxLs8g==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [RFC PATCH 4/7] target/i386: SEV: Enable use of KVM_SEV_INIT2 for SEV-ES guests
Date: Thu, 11 Sep 2025 17:24:23 +0530
Message-ID: <84893d59f11b16890612ef2436ad233526ebe3fd.1757589490.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757589490.git.naveen@kernel.org>
References: <cover.1757589490.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that users can enable VMSA SEV features, update sev_init2_required()
to return true if any SEV features are requested. This enables qemu to
use KVM_SEV_INIT2 for SEV-ES guests when necessary.

Sample command-line:
  -machine q35,confidential-guest-support=sev0 \
  -object sev-guest,id=sev0,policy=0x5,cbitpos=51,reduced-phys-bits=1,debug-swap=on

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index b3e4d0f2c1d5..3063ad2d077a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1704,8 +1704,7 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
  */
 static bool sev_init2_required(SevGuestState *sev_guest)
 {
-    /* Currently no KVM_SEV_INIT2-specific options are exposed via QEMU */
-    return false;
+    return !!SEV_COMMON(sev_guest)->sev_features;
 }
 
 static int sev_kvm_type(X86ConfidentialGuest *cg)
-- 
2.50.1


