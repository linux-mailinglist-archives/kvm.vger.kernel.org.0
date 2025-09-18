Return-Path: <kvm+bounces-57997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA9BB841CD
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FC7D1710A9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDC2302166;
	Thu, 18 Sep 2025 10:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uE1t75Hf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6584B2FBDE0
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191439; cv=none; b=TwVOxbrM0nIF94O2+3T/fUHc3iRx9IUazuE2o5AZGOT5EWooMaors498d7P2WeVe5USqDkxPH4yRoOBJUXrStHvMYDDyd9LiYRHin77MH4Qyi3Jxvjk8xJyZ8q0fhjUofRt93JY/Y/ef+e+J7Ob1wyCdok6JG9rgknuxVy+U9V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191439; c=relaxed/simple;
	bh=B7JHk9fWDpqUfKVj1TLxQafQWshyOG1fenZVw/oaq9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNkuRMruAmNuK7Dojbdpg60gOZnISWmTa0QB3Hco1G+yqbrgmMyFJl4IVHhBa8yY5OqUbGUobaJbO2d8GxJfhuko76/+wqC/caZjcQe76Z+ZRd09iIxuRIrTAxH/UjeDzfrRDcgKbcD/10R/1LOJxCPyqgW0hPiSiG1HyhxtRFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uE1t75Hf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4369DC4CEEB;
	Thu, 18 Sep 2025 10:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191439;
	bh=B7JHk9fWDpqUfKVj1TLxQafQWshyOG1fenZVw/oaq9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uE1t75Hff9IOa0GmD64eZ6wkalnBLB3pvn0CI39jiQqtP6LbUTmUptk6ZJdYUBYfh
	 yNxgQmhVpYsTQodWbf5HdwRNVglTECoF9Ri54omvfqVdAoaQaKB4yCoSnJJOxyOt00
	 EdvlIy/72j5jN/iE9RAZFqovAGLdwn9WYC9XWmafjUeSfoYElHYYq0hDvjonAGwv1Z
	 jLz/TLox3a4ZuuNWAwvWRkLGB9N4bWBB04nnmQkhKQ9hm+suyoRdzg+lee8WaT3lKo
	 H/xosADVCD9LtVUNKIkLUIlAx47YQnLM14r+w0ZJaKr3oKQhWzN6anpdfDbgDO2m5y
	 zbT/469fNqyaw==
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
Subject: [PATCH 6/8] target/i386: SEV: Enable use of KVM_SEV_INIT2 for SEV-ES guests
Date: Thu, 18 Sep 2025 15:57:04 +0530
Message-ID: <4d14083f34e3196a1ef179a958e30e800b5263fe.1758189463.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758189463.git.naveen@kernel.org>
References: <cover.1758189463.git.naveen@kernel.org>
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
index 4f1b0bf6ccc8..6b11359f06dd 100644
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
2.51.0


