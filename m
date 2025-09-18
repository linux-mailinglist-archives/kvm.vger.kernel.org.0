Return-Path: <kvm+bounces-57995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09114B841C8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AB4D1C834F4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBCE2F745E;
	Thu, 18 Sep 2025 10:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiZhMNQQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05C613B280
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191427; cv=none; b=u9O5oNzkj+qRjSDrzy44UFiC5piY68ZAQxkMwz421AoIiBU72IO5O2+itfUuest/0itBAqmLZL/VKrh0SU3w2y7BfcfX/MgvUhpCz0XvuGdBI76r5aFadBXSatlGgufHHl/NErhcNopG50+nu0RIuOUGCY61C/ojQ5U+PJUTH7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191427; c=relaxed/simple;
	bh=dV4uVX4HWUQHDw0uWQev5aF1tKrV/zVT0JFkQA9+V58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsQGRQytGpmU2dW7ywjadX40tW9XPRW4TkYdR4BkuPHotMTcpJXQYklf/DCuUeuIGHGRpiFvVFY6B+zOP1xfs0lPHVpH8fP3E42tDUTz+Fg6xmjZXmYE0mUq946poEnbqJNeaNM4iJ0wXYe1bSjZUYEuBssNFpXCZMf348WUg7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiZhMNQQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD8CC4CEE7;
	Thu, 18 Sep 2025 10:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191426;
	bh=dV4uVX4HWUQHDw0uWQev5aF1tKrV/zVT0JFkQA9+V58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiZhMNQQqX+qwE8TUVeKT871F21iL8xvZOvQcJ/3kr9GoUC89cMk4p9n8xg38mESq
	 fCFmTJpc0ygxKSN/MyoYzdACI2T92v3qyf/u0X37kw20U7PxXv/I4F+SXGKtMFxmny
	 VAQwVQPiwvEjlQx0JGeqcCHw27DdSK06S5vIphII//HHDp9pvJLLuwo77XmRbTQNy8
	 Iwmr2xBwZWsuYhElA7eGb4Rfo31nRnOiw/pnYkD3vJAxvqlxLBn1LZmBhecbUxWNEJ
	 mMDeW94Hgwhm2UvY8RcTz6nc3SWOzvo3moOtgS1AFGEv7kR3BYxPkmpmGind/yXLxf
	 idBzH7Qoo89iQ==
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
Subject: [PATCH 4/8] target/i386: SEV: Validate that SEV-ES is enabled when VMSA features are used
Date: Thu, 18 Sep 2025 15:57:02 +0530
Message-ID: <f18700e9ff95efb68261ad4596ebf6a222710d7a.1758189463.git.naveen@kernel.org>
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

SEV features in the VMSA are only meaningful for SEV-ES and SEV-SNP
guests, as they control aspects of the encrypted guest state that are
not relevant for basic SEV guests.

Add a check in check_sev_features() to ensure that SEV-ES or SEV-SNP is
enabled when any SEV features are specified.

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 7c4cd1146b9a..f6e4333922ea 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -518,6 +518,12 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
             __func__);
         return -1;
     }
+    if (sev_features && !sev_es_enabled()) {
+        error_setg(errp,
+                   "%s: SEV features require either SEV-ES or SEV-SNP to be enabled",
+                   __func__);
+        return -1;
+    }
     if (sev_features & ~sev_common->supported_sev_features) {
         error_setg(errp,
                    "%s: VMSA contains unsupported sev_features: %lX, "
-- 
2.51.0


