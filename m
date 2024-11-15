Return-Path: <kvm+bounces-31908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C25409CD502
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 02:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FA37B2480F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 01:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55521E522;
	Fri, 15 Nov 2024 01:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JiMIKNqB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E7E2D7BF;
	Fri, 15 Nov 2024 01:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731633694; cv=none; b=HWoSPfxO8mBxdZ4gUdDpReU9EkJTQnRdJtvoERzH/CDV6HSDoKXaebLDmmDfngpCn0IqYQE3hj6cDcImiqif4S2dtKpdAnUsJlbowgzUkOyw2Uu9dMiRBOnUg0izCz0teFK0I+uNa8DLuShUGmJvu3jsFSAOxTctKgusuBrMFgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731633694; c=relaxed/simple;
	bh=qSbEpx3MPH5WMHVUzgI23tLS0qo5RoScUOwmCoRBrcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nzVNJhQ5YIQFEvoGpKGHmLz+bIN8KgEG1TIMTjyhVbhqbMc97+fTf6fOsg4eiIETsB95Z9c1PoLhO57f7iwS2CKGQn8Acl4co2LhC1U+2IHIsiRLTTXFXPZ+owsuvMxpurC+xsGqFcG6AfT+OnKnExxiKglKjQPQ+6MjX1DvCP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JiMIKNqB; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cf844d5a60so1577612a12.1;
        Thu, 14 Nov 2024 17:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731633692; x=1732238492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K4SxzXcUOTfNFk+31HBVCyd87PgVtWIQnMIx3uawTpg=;
        b=JiMIKNqBZr4GsqnjRHBQR1AAw2SQa7lxoF5kADEVnIcKWz8uTidAZOdRNIzuS3cXAn
         urotSycVSrGIQRW1OSh8k9cCecx28AgVhv3fHaajbxnjg2ljULTqIg5agz2X+Cczr5ru
         +3Rwc6fgyAQ9wcag0tcIej/r4Z1A9DiNPRmtTPe6aJhf/c30P+bXgJh2lwWEjBTikdcH
         qcMvQe+zHX575TSgtAAd7RDLZ7q7Do3MfCEGe9AmhJPbWqa4rUp7pmV9cU+JdG039D+R
         aER9ElidK2Ufqpu8JEdvITdRu/FgSEwGm/24bRFi2MBfXxf687j4RUBeeu8CPtruBVMI
         wjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731633692; x=1732238492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K4SxzXcUOTfNFk+31HBVCyd87PgVtWIQnMIx3uawTpg=;
        b=TUHY8PtLkCdguit2+kaYPUjiaIJHjtbBeMbU+HxrgBN0UhAuAZBY7wH0Xk9K6W4OE+
         iszhR6xfzynupn1tYUxyscP/mVQtz0+FAE4k4YgKjjkmFs0ez3ciD2Prno84nZc2OBfx
         wAdOUYtTTAkW6YjPNBOol7c+fOBlA9DRw3/B9w7uvr1ddQKKvj7FqWla+j51O2ADycpT
         YDDQUQvk+99VDdWlIfpC3NEfZDeO2V8qxl5eZ3pM2e3SJnk64GUZ2t1pQ5lZfKLD6mcK
         qRo9sTiZolZo1IdO7vwbEMNKmXq+3r3a0Jsl7fPGIY1wkusnqkm0bwTaXjl0MVl2QJ0k
         pKxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbxU4xVq34IVLe8sqTZvMRRt5+hzZ2cCohffj6SGVCGwuQMKbIVnbS41kztZ0nuOm9/UkaAzEs4Pk=@vger.kernel.org, AJvYcCUzD0Mtp+oZ6BsC0PaUsYCriX9Zy2Spb5daglg52bozCY0rObrq1W3Pxz0zTGFhtEw/bQRyhoD+CsCxjPoC@vger.kernel.org
X-Gm-Message-State: AOJu0YwprzwGacjSOO5dYG/piKDiBn8wreXuKQipQYsR2DdqzCe8i4vg
	R79ZwyPfXAsQQGbulvCvH26fcuczThzSNxet/+qPeRQmcqFfGWSj
X-Google-Smtp-Source: AGHT+IH57fPHsz5nrCROK7JC7I5XWaRtJiaQzkQjFuTXNiO+kJzJKVECVzRk72Kym8g9qwEwwETexQ==
X-Received: by 2002:a05:6402:2696:b0:5cf:758e:cf94 with SMTP id 4fb4d7f45d1cf-5cf8de675a2mr947977a12.8.1731633691373;
        Thu, 14 Nov 2024 17:21:31 -0800 (PST)
Received: from gi4n-KLVL-WXX9.. ([2a01:e11:5400:7400:dc78:53a0:d8e6:28cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df51653sm120724466b.48.2024.11.14.17.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 17:21:30 -0800 (PST)
From: Gianfranco Trad <gianf.trad@gmail.com>
To: pbonzini@redhat.com,
	corbet@lwn.net
Cc: kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gianfranco Trad <gianf.trad@gmail.com>
Subject: [PATCH v2] Documentation: kvm: fix typo in api.rst
Date: Fri, 15 Nov 2024 02:18:35 +0100
Message-ID: <20241115011831.300705-5-gianf.trad@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix minor typo in api.rst where the word physical was misspelled
as physcial.

Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
---
Notes: 
  - changes in v2: fixed a typo in the shortlog...

 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index edc070c6e19b..4ed8f222478a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5574,7 +5574,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA
   in guest physical address space. This attribute should be used in
   preference to KVM_XEN_ATTR_TYPE_SHARED_INFO as it avoids
   unnecessary invalidation of an internal cache when the page is
-  re-mapped in guest physcial address space.
+  re-mapped in guest physical address space.
 
   Setting the hva to zero will disable the shared_info page.
 
-- 
2.43.0


