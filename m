Return-Path: <kvm+bounces-57310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B01B5318F
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AA40584ED6
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CACD31DDB9;
	Thu, 11 Sep 2025 11:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFkxMQ6z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22812D0612
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591854; cv=none; b=juf/ApybPdFfcDwIgLRuLGeFUkxsUgFn1OgJPniv7uC83k/+PUg7lmq26Bc0rOlgp0XZhpIooNtlkawIDsmrlk+CrY4NdgzCc7K54eqdeOHUY47tx+w2mN6QOZw0ISA4CMJTq/pN2MYhHT6bQTdCII+XKCg3n9wPOw1BaPg1RAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591854; c=relaxed/simple;
	bh=2z1LZETut4QsqrD4hbQwCdQhV7qbnpi4feefGZI8cIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9w4KZKTy/K/8EcaRjsbeo6eH8ufukVvIu3DWCU/B+Nzk2F7eITPLQwZAezQLMxgejqxcFJL+EERqTQOMXk48OKm3QLFwoeVMV1xgzJH06LkdCNXHyL7ChXehZaEcxdedmYZV7RK/66L3GwIk+3AMuOWL2B7B4uYnmZvk3r0blU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFkxMQ6z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F98C4CEF0;
	Thu, 11 Sep 2025 11:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591854;
	bh=2z1LZETut4QsqrD4hbQwCdQhV7qbnpi4feefGZI8cIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFkxMQ6zgcqS07/oUhpub27PmF1d+40G661vUe32HGLf3BVSOuboCHp2u6MEjva4s
	 /F/1qwZLufM7BhIz/JYFF3NzBNGt7ALXGFVqMYOL9y6BqgPRfQ+nFnvgU+04RMxYmC
	 OC18c/gxzjY11nfbT6k2AiqQYrd9WRkl4SdLbt7xcccs5CMYoGq7A/ZgCaAscJcKqy
	 MinjQYkQfNJBAfOe0BjURvJtlF6qYmvNMJYH0bPjRaDSU/DF/R5EDnRJtyfAKAEQvI
	 DLodAyr3j8XzR/mgp1NAIJm7poxn4fW9czLXGeeRcy8gZMfQym5RHah8+/KBgXIkoY
	 Nm3AFTcrM3tQQ==
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
Subject: [RFC PATCH 2/7] target/i386: SEV: Validate that SEV-ES is enabled when VMSA features are used
Date: Thu, 11 Sep 2025 17:24:21 +0530
Message-ID: <75d491d24e39a6d95049868c56e4f2088ed48d6e.1757589490.git.naveen@kernel.org>
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

SEV features in the VMSA are only meaningful for SEV-ES and SEV-SNP
guests, as they control aspects of the encrypted guest state that are
not relevant for basic SEV guests.

Add a check in check_sev_features() to ensure that SEV-ES or SEV-SNP is
enabled when any SEV features are specified.

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 243e9493ba8d..fa23b5c38e9b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -509,6 +509,12 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
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
2.50.1


