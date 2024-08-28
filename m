Return-Path: <kvm+bounces-25243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EACE9626D6
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 721751C223CE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60401178364;
	Wed, 28 Aug 2024 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0vqntix"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150E2175D32
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724847684; cv=none; b=omKXsDwe/byshQhh+34ZcHvAPzrmUvp7QHA1soTaXMyZZeFjfKvu0KFKv40BJuizx+HPDTIgdVmu/l/1O/alvDMeuf8dDTPYPYo5XICvWE5abxLCihhzBvB+YYywWSb1dokQGUhtT0uJuB40D35mSg/0Y+KPSg2UtGZtEWmYNxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724847684; c=relaxed/simple;
	bh=s4H6HlQ2eKrbt6rQT0sAnpeH91fEvAkmDDLIFCbYnjo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gshjRiqXY0sN+uNBdchtsMRoATzad0C+Jzrxw/LUnxuQpqyR8WguG4yOGUE+d+8QChOcaarOI444np2tPAeQBAtg4XNSS3NCprLactlRtmkNtY8s1PxJ8Ti17sIJlt2nFtMnJFsXktAdx2IWj3ZnB+QY2HbYfQjkz1IAUUcbuBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T0vqntix; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724847681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ADe923Fii7AI3FN5HzxwnQB0W8HA5WANzAF8yGG84cQ=;
	b=T0vqntixSX9ZIuOlSiHj5/a+UYNBDoym/XWT8Jizyqg2yXXWK+aCdHddwBVq1lDIeQ57qe
	37q2ZcadWJt7kc3iC07N0LYcBhMFpesJxnCwhwYCg/N6zlOgQr26xd2ey8aqSJB07hOoGL
	duTWal7IEMbF5DZE6xC9BfbxIjNVNvs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-108-Tyt46i-1PbKg3OIIzowB5g-1; Wed,
 28 Aug 2024 08:21:16 -0400
X-MC-Unique: Tyt46i-1PbKg3OIIzowB5g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DE9C1955F4A;
	Wed, 28 Aug 2024 12:21:15 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D511919560AA;
	Wed, 28 Aug 2024 12:21:12 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SEV: Update KVM_AMD_SEV Kconfig entry and mention SEV-SNP
Date: Wed, 28 Aug 2024 14:21:11 +0200
Message-ID: <20240828122111.160273-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

SEV-SNP support is present since commit 1dfe571c12cf ("KVM: SEV: Add
initial SEV-SNP support") but Kconfig entry wasn't updated and still
mentions SEV and SEV-ES only. Add SEV-SNP there and, while on it, expand
'SEV' in the description as 'Encrypted VMs' is not what 'SEV' stands for.

No functional change.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 472a1537b7a9..faed96e33e38 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -144,8 +144,10 @@ config KVM_AMD_SEV
 	select HAVE_KVM_ARCH_GMEM_PREPARE
 	select HAVE_KVM_ARCH_GMEM_INVALIDATE
 	help
-	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
-	  with Encrypted State (SEV-ES) on AMD processors.
+	  Provides support for launching encrypted VMs which use Secure
+	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
+	  Encrypted State (SEV-ES), and Secure Encrypted Virtualization with
+	  Secure Nested Paging (SEV-SNP) technologies on AMD processors.
 
 config KVM_SMM
 	bool "System Management Mode emulation"
-- 
2.46.0


