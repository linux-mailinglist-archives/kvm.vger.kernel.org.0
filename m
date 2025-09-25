Return-Path: <kvm+bounces-58732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30347B9EA6A
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D92CB4C78F8
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C6B2F260F;
	Thu, 25 Sep 2025 10:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYk330Ou"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2BF2F1FF5
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796096; cv=none; b=Vgyt4ZSt8VSWRdDxhZirFpCGXsor7/8akIrBuuArynIzBLDsedELMnZe9FCsxLXO/JkI828DBQ5JIPdfWlQ6H7y99xG6w3TYYirWB1biyL4eqJmYgWqBhzHethuy9XJ1Aegi+04oiiMMe8HQVZktvqpwrDma675N9NyZTgPl0+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796096; c=relaxed/simple;
	bh=zTjyNOX5qfNThUt3QCXjlNUgpQHT7Y8dtEBwrZW4XNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB1MvCenBdx7rXcWmjUGorHo5fVDRQVp38mWhH2f3WZywwnkeO+DD8hKj/17R1BOCuPB00IiRSvjAMWKD8/GWYI6XDEJAzod+/fmmJKLo8ODsmAfJjibAFtZcAla9tE49XmMzWvIeRqEXAvNAA2fxJOZR2kcO4mt8M1HqO6kdU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYk330Ou; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85624C113CF;
	Thu, 25 Sep 2025 10:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796095;
	bh=zTjyNOX5qfNThUt3QCXjlNUgpQHT7Y8dtEBwrZW4XNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYk330OuDfNejjkFh8VB5AzQkWTZ1LZySQ+ol7/zQk/hU2EtnJYGkMXbW3rZi+moE
	 +TDo+fuksDG2Kz9029tMTuWyvuuoly28PkmFcvsh6q4Q48PB4gAPutBe0yulST58fg
	 c8UFzlCQmuZIlboskw4wn55VqFpdBO7ZhdfQMsEK/Pw/bzmRwu9g8GTRIoB2kUjouw
	 zux77B3ABrMPKs2yltOyTGOja0ZCDJLZEB4WLgYv0u9BaN7LQQ3O9aPZ7TfYrx3VP5
	 gwjUoHrIpGxcYMipIqgA1mTs4CLuCg2B0p7MkZ8H9tSTF3M1+cnF4LFQsbKEqvo7aH
	 PLkF9IycM036g==
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
Subject: [PATCH v2 4/9] target/i386: SEV: Validate that SEV-ES is enabled when VMSA features are used
Date: Thu, 25 Sep 2025 15:47:33 +0530
Message-ID: <bbde63259b4fa7e474f1b874319d5a6aa9dd1309.1758794556.git.naveen@kernel.org>
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
index 3b11e61f78d8..2f41e1c0b688 100644
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


