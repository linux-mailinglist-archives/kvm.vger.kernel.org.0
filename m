Return-Path: <kvm+bounces-27641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39717988EE2
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 11:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFA2D1F21BD1
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 09:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EDC19F471;
	Sat, 28 Sep 2024 09:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Dft0/sTD"
X-Original-To: kvm@vger.kernel.org
Received: from msa.smtpout.orange.fr (msa-210.smtpout.orange.fr [193.252.23.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8019F42A;
	Sat, 28 Sep 2024 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.252.23.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727517180; cv=none; b=jtwegGIKzaEfYzJfaeJWh7MCsfRWb9pbUycNtdVBdutWHUwG3mXOleOVc8+VysNn4hsr2fQvDs/L+TgjCs4KiVAmgZvWJY3gACjv8Bn1K+ywOqPRIT6qw9HKUE8g/sThvkAVc4nWpRZh7i0HoOi/OKzkYZmOrGehEDr/KZ7I/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727517180; c=relaxed/simple;
	bh=7LBotd+mvVGArVNgb1WZBr1TlO/0KWr8dETfdIaTdxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C9E+8br6YpFqhT94qV1hYnTwGfnBw4NDIBpX3cqWbRGzs4bAPgzVdCju8N3ZXlUJe/J115jG44C5tbNoqCHGJY90smDOVEXjzaCg7x7vi9rFNSJGTkkFYNRUNIHY4OuCf9Jq5A7QcGLZFJqB5v2PwtU9KrHrmrPII/0sqBG/loA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Dft0/sTD; arc=none smtp.client-ip=193.252.23.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id uU88s6tnX2QI1uU88soj2s; Sat, 28 Sep 2024 11:52:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1727517169;
	bh=+jfKu5zjNuHBQsu3lopjfX1zxk2IBwlnkS2CLQnqk9g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Dft0/sTDM2jltNjOVazbFJdjol8dWzWx9I7AOnYDi6PB2q0tQIt6S4QJA86pspETO
	 wlGjceW24dgSEhtGfUakJpFZoDNlCj6Cbq81goKEALEkVA8U12mzZ7AJSmINuiztUY
	 iXP1oKeKdOtpvh2GPOlx0U1fVVv1K17TsNGm4efwyv97ACZwHJtdgejy77URCfoL4L
	 4wqVI7MsxJV0pv0kPMcpS0PHSG7WEjx4a9YgWTnSWOzUsIqw3ZfkQlmGws4Ebzey82
	 K90/EBFX2zkBeHs+WLC/EB7eCYngxBpBcriTR1IxybShZdoebgoxLVYMa2nueQHG5J
	 5zUIy38tHhOSg==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 28 Sep 2024 11:52:49 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	kvm@vger.kernel.org
Subject: [PATCH] kvm/vfio: Constify struct kvm_device_ops
Date: Sat, 28 Sep 2024 11:52:46 +0200
Message-ID: <e7361a1bb7defbb0f7056b884e83f8d75ac9fe21.1727517084.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct kvm_device_ops' is not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
   2605	    169	     16	   2790	    ae6	virt/kvm/vfio.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
   2685	     89	     16	   2790	    ae6	virt/kvm/vfio.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 388ae471d258..e72a6a1d5a20 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -353,7 +353,7 @@ static void kvm_vfio_release(struct kvm_device *dev)
 
 static int kvm_vfio_create(struct kvm_device *dev, u32 type);
 
-static struct kvm_device_ops kvm_vfio_ops = {
+static const struct kvm_device_ops kvm_vfio_ops = {
 	.name = "kvm-vfio",
 	.create = kvm_vfio_create,
 	.release = kvm_vfio_release,
-- 
2.46.1


