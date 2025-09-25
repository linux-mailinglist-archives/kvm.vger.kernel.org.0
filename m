Return-Path: <kvm+bounces-58730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6F4B9EA52
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6DC32A1A17
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97502EC085;
	Thu, 25 Sep 2025 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1J3WX54"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA81B2EB87C
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796082; cv=none; b=Y/srqg4BrlrTVv2O7jBpJ3K5cyk8DrQVQULh+d/G7c/37P8i4aCiEpyA5HhU0liUNZYXUECia+JUUSZ+SzUajdfJhKHet/ZqsZEQc4iZMJljitgbh7yYhfVu/X74jR8HF2Smj9osYDe5pdau+IfBmDcytjZFW1ZVf/g6vSfRD7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796082; c=relaxed/simple;
	bh=svkyMfF221tycwz6u0wk23zZbnYE0gSsTIe18ZQ5q+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4BRbnxurujAnvhRlROIy9v08yTUHkbouxm901l8p4l69Eu2+66xV+tIe81ChWt5rmeMUodvPiAMJvwCP3Xgs5y4fLG4xz328667XOl1oICTFfE++vrfz2XA4gGYh6qA+qlqNwNHHFhI+U4NIqlwY/BRO1nFvvM9tJyKl0Dm6ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1J3WX54; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E734C4CEF0;
	Thu, 25 Sep 2025 10:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796081;
	bh=svkyMfF221tycwz6u0wk23zZbnYE0gSsTIe18ZQ5q+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1J3WX54IiZkP+Cvgkur21qsisX7iqAzGnji2CGaxlYaXTTYfdwqcFAp0A4Wl4qZr
	 JZRTsK57sTMWt3IGIxhsVow42zIo9g8AipcjLiQRCOr/8WoRRx/SRwTWKMAo0qwigH
	 eS0xbK/tzyHC5BPA2KSMLm6BE81dbsZPm2LDLRheO/B5Qdo63x1WdYwg3z0344h5Ug
	 y4IlhDG2lDOXE7Wn1ojKxsxJpiJeeUKzHII/0GcRREm/jOhI02OFNn3nQdRqcVdG1p
	 S8/xXacECuaias/mvNUer/+xk0oTve6xn1lE/KtjS5EpuauMgnocMcjTtV5i6e+m00
	 s2Kmd77zsrYsw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [PATCH v2 2/9] target/i386: SEV: Ensure SEV features are only set through qemu cli or IGVM
Date: Thu, 25 Sep 2025 15:47:31 +0530
Message-ID: <9353c74e7d610780bc1638e60ae2bafb5e6012d0.1758794556.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758794556.git.naveen@kernel.org>
References: <cover.1758794556.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for qemu being able to set SEV features through the cli,
add a check to ensure that SEV features are not also set if using IGVM
files.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2fb1268ed788..ddd7c01f5a56 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1901,6 +1901,15 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
          * as SEV_STATE_UNINIT.
          */
         if (x86machine->igvm) {
+            /*
+             * Test only the user-set SEV features by masking out
+             * SVM_SEV_FEAT_SNP_ACTIVE which is set by default.
+             */
+            if (sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE) {
+                error_setg(errp, "%s: SEV features can't be specified when using IGVM files",
+                           __func__);
+                return -1;
+            }
             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
                     ->process(x86machine->igvm, machine->cgs, true, errp) ==
                 -1) {
-- 
2.51.0


