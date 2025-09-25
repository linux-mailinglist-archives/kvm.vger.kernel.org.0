Return-Path: <kvm+bounces-58733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8C1B9EA76
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D16A82A1B30
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F13A2F361C;
	Thu, 25 Sep 2025 10:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UM7/C8GE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6D02ED154
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796105; cv=none; b=a9FdQPQyfCiMCQFl/awFI0vd2Zydo9lJeEDURFsbzVVEmbD81iDne9RXJbYiTeW5bJNxodjvML2e3eAsNgJrK2QOiY0bd9IRvXeDjJfmmR7wnGfejxz9B18v1SgQneq6KAAHYkuh4kMBCIY0Qjo1nJquiUwuKtAirbMcEScDnts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796105; c=relaxed/simple;
	bh=2FIJjllcu3jZn+MyRCcCBl6y4Ac7kDylxi5/E7ubZUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4yPmjaqNasHBUGWjAIJ7GdPw0cwVjK0EAfqw/VST6AXlePpAbFIohl7LlJpkZifq5OL2sRCOknzQDidslh6uhjgSxDRqfEFgO5d3pCvl4tgiXjaz89Ez8GtjgJ3jdIWLuL6WF/QCNQHpcaua1EwFN6fHfYsrrpgMXoye9zJvUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UM7/C8GE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F265FC4CEF0;
	Thu, 25 Sep 2025 10:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796104;
	bh=2FIJjllcu3jZn+MyRCcCBl6y4Ac7kDylxi5/E7ubZUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UM7/C8GELZGIkyT763gqOIuPVv5wrBPQKvd0FkHDaZSWN+DjPo2XxxR07rfFN+GtR
	 soQDhHh13kb9w8OPuS6TXZWyKD2zsBbyFjvG9Kz2W2TYeUI/2emPcjRt+WtMNQbvWM
	 isN1ELg5rxA5iSukI219xaQviFKGhkCk1/z1hrUOnPpEzs+i4c913IiMyPc8jFch59
	 4pLzyoAkcMbXCp6FvVbMLHAuMrZDJvwNq5GBRInPl7Mwdc2m+fOmfSsDbi6fROYXiA
	 daSrxyXY8CsEoj3wmNkZrpYBZjvNlFB2rTiseNxnXV+EQtiB5INrzvWylYQ+QtrydN
	 TzO6uggV0LbSA==
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
Subject: [PATCH v2 5/9] target/i386: SEV: Enable use of KVM_SEV_INIT2 for SEV-ES guests
Date: Thu, 25 Sep 2025 15:47:34 +0530
Message-ID: <508561b1b274584a34f508453cc3ca2e913b5866.1758794556.git.naveen@kernel.org>
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

In preparation for allowing SEV-ES guests to enable VMSA SEV features,
update sev_init2_required() to return true if any SEV features are
requested. This enables qemu to use KVM_SEV_INIT2 for SEV-ES guests when
necessary.

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2f41e1c0b688..88dd0750d481 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1699,8 +1699,7 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
  */
 static bool sev_init2_required(SevGuestState *sev_guest)
 {
-    /* Currently no KVM_SEV_INIT2-specific options are exposed via QEMU */
-    return false;
+    return !!SEV_COMMON(sev_guest)->sev_features;
 }
 
 static int sev_kvm_type(X86ConfidentialGuest *cg)
-- 
2.51.0


