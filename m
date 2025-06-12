Return-Path: <kvm+bounces-49291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A3BAD75C2
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6298818899F3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B132BDC34;
	Thu, 12 Jun 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0XzS4Ss"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9545D299A81;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741469; cv=none; b=MXdBFpNvtlsfvGeaOGvrDA7nuomBygU5mQYkrnBdbRxEY8nl2nJect0aQPgKq2ldtbx/k2bzHSQf/e9IpZAaWMephdUIKjoGEI3N+hN+NNVG2rNHxjCGtrXRD5w8MgvknkDgBwMfRHh9DykvQDlx28rsZ+K87nljEba6A4INfL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741469; c=relaxed/simple;
	bh=XDJZhmjHPDXPg7og3rQDpluO+ZElZEtkFB7TOHBZ6B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZNOyYE6EiXiXns4NXSVvap6Xh0ZPTewnglbwN2wtHnyxzNaVEfATUgVjtoiCC0ZBBPzoXdXX8NDKN7mdd1L3y2wB/0bJTQuhVjgvAcNkKQy6mM0JT/OGaMLduxDHQ3Zqbsqsxbol2cVm/t9Spl3cS7cl7tfKeOZuiHR646+ALc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0XzS4Ss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693B1C19421;
	Thu, 12 Jun 2025 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749741469;
	bh=XDJZhmjHPDXPg7og3rQDpluO+ZElZEtkFB7TOHBZ6B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0XzS4Ss2eW7Ykyf+R9NN1+Wd7takcs7fLioxh5YnuBURZSy6NpMjPzMXIevf/s7E
	 82WxLzAtxGHbm0Vq5p0e7J7hGOUZipnFUVE4m+zaeVVhjTBVPhXV2I5bLkM3pfUUSe
	 bt9LP4dUmbc0fUT9Blqf1Cz5VOakW427iRs5wgGo0rlvaxeyjBkK0rwzHNqB0TWqi2
	 5TCa0/EsoaiKs2cgcQgBDAhBxSuinKqL3DmkREcfrsJLxk16X2VhptFzBWO+keFnGD
	 VtWLv0uRpZA2QCF7AdlAaPldounV3XuvUncXSsBjW5Zs/hkuLLTmydIjMppuINM1jQ
	 j7MuiSjP5BvxQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.98.2)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1uPjgZ-00000005EwE-2cjy;
	Thu, 12 Jun 2025 17:17:47 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Ani Sinha" <anisinha@redhat.com>,
	"Dongjiu Geng" <gengdongjiu1@gmail.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	"Peter Maydell" <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Shannon Zhao" <shannon.zhaosl@gmail.com>,
	"Yanan Wang" <wangyanan55@huawei.com>,
	"Zhao Liu" <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 (RESEND) 17/20] acpi/generic_event_device.c: enable use_hest_addr for QEMU 10.x
Date: Thu, 12 Jun 2025 17:17:41 +0200
Message-ID: <9431b499f5902343652fea59c8612740eb41884c.1749741085.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749741085.git.mchehab+huawei@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Now that we have everything in place, enable using HEST GPA
instead of etc/hardware_errors GPA.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
---
 hw/acpi/generic_event_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
index 620a1e0d6b01..e9b344ef3e15 100644
--- a/hw/acpi/generic_event_device.c
+++ b/hw/acpi/generic_event_device.c
@@ -332,7 +332,7 @@ static void acpi_ged_send_event(AcpiDeviceIf *adev, AcpiEventStatusBits ev)
 static const Property acpi_ged_properties[] = {
     DEFINE_PROP_UINT32("ged-event", AcpiGedState, ged_event_bitmap, 0),
     DEFINE_PROP_BOOL("x-has-hest-addr", AcpiGedState,
-                     ghes_state.use_hest_addr, false),
+                     ghes_state.use_hest_addr, true),
 };
 
 static const VMStateDescription vmstate_memhp_state = {
-- 
2.49.0


