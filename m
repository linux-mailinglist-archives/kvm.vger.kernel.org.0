Return-Path: <kvm+bounces-34216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A2D59F93F3
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 15:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26D341668E2
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 14:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D13216383;
	Fri, 20 Dec 2024 14:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eNSRMAXF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0911A8405
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 14:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734703643; cv=none; b=mslcX9LAu8FsbArbLSI6sObQW496C3uHtKu8MONqUe8YXEe42KXjbjuCiPJWdgz7ibYQPHnxDOH7gsxX6APTUGPdKRtWJk1LQhwgBElRaT7HQoNGWI3+l+JtXbBGj5qZKjF9d9jTG/8cav7MfupsB1lOhOHvCrwUAP3I7rrgfH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734703643; c=relaxed/simple;
	bh=YE66aKhza9Ak5H/2VRRQAUraPmDKqJYIvjprmkvXmc8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V90rE9IatwRkMNWT9UTBJf2u4Lpk1Nr2xvv0RHg1wJ1V7s6WshypqGtCWAW/UVvLJ4yxm6kjQYqEBtoF3RXYKxxsNCuGJSNDHbcHzgAqVcRfdiJgd3HmBikFxcdbNt5AxZIEnmluD8zIC96ImtUAzrO1peN8gXWbYmD2o7kVHQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eNSRMAXF; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361a8fc3bdso11006615e9.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 06:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734703640; x=1735308440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mvekECAF3Q81gSrxSh2SxyYxsRKpDjt8xXlNqbMmuK4=;
        b=eNSRMAXFZbOuER96SctEXYrmzWQHuVymynmAeOaIZL17XmeNkG+BdDeC0j/ru9GNO8
         lyraTeGXouk7DJ4ck3I/vJv/ifCwuau/nvlvbU67l6lZaUIX3xWuxgTIS6BmHhy2OZ+t
         Pp0hdGZO3JQBIY01EIejE1EW7cbg9k7Lpny1nq5xCC4YvTcbFGuehTlEyUFiiLukbD9C
         Vr1BjhMqWqX9RdhNCfA+T/DGoA7pMWUu0UUpSqtpmkcbqXaW+Oj34gsNVh0Uin9yqtui
         Xr8x2V79OSjoREW8esWU+8HJZtRWS84U8FdegtKoYaUBz7HAcNTvkVfvgj6U85O9rXfw
         QV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734703640; x=1735308440;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mvekECAF3Q81gSrxSh2SxyYxsRKpDjt8xXlNqbMmuK4=;
        b=rkQidsAY4bBw/mqb8EG5EsxFQblrXIhU55snilnhxEf3fDqnwMIfu+57IpS04BPXm0
         zl3fe+JcjhkXJA2AR/gv8vBO1EC7V2BmY0VjN+I8/5/5nw4FYTNJD87a9etgxzb2VRd+
         Re2sT7LmcZUmcgEprBVjPjm0q4E52Hd7kBPL0Y0KRr1aJVLvp7mb0fcTwk/uf9/ZqpxU
         I3J9aNoTpexOcZTUL/ekBzLX8FxXGTrr3dJbEuhJhEoJvwRnffEkxyXxY30a7+zpvwiH
         vK7m5E3Es0pGV0rPxyTQk4jXbRv6xABdJONmZggAWfHsH2kXfiOFDi17HmgKVzPPzE60
         tuPw==
X-Forwarded-Encrypted: i=1; AJvYcCV/EJbg+TtW8vSYBlkUTtzqGonAH/sO6wa9O0sD8USi3kVBwC5TYf0SmSJXbdN8309BWUo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi3nUExSrmJSpwvR7rzdNIp1sUaK9vZ+yJBsEqkpR9rO7PBtqO
	hxdu+KQtvFTX7EQML4ViWI3NHHyOZFeIg7jObFpdVaLBn3tvkWPqWbzolGpizheO8KGSHai9wNq
	c3GWm9xx5hw==
X-Google-Smtp-Source: AGHT+IEUFAJqAXwH+L2qoKSPsLwW76qncFZRqIWPDZi6OF4VgMD11slpXqVI4e0+Rd3UHYseGaEh3EHI9oyrLA==
X-Received: from wmbfl19.prod.google.com ([2002:a05:600c:b93:b0:434:f847:ba1b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ca1:b0:434:a350:207c with SMTP id 5b1f17b1804b1-43668b5e22fmr24629045e9.23.1734703640795;
 Fri, 20 Dec 2024 06:07:20 -0800 (PST)
Date: Fri, 20 Dec 2024 14:07:15 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABJ6ZWcC/x3MQQqAIBBA0avErBtwTFp0lWgRNdoQaWhIIN49a
 fkW/xdIHIUTTF2ByFmSBN9AfQfbsXrHKHszaKUNaa3wzBduwVtxmCU+EmzC0aiBViIyxkIr78h W3v86L7V+OZJA3WUAAAA=
X-Change-Id: 20241220-kvm-config-virtiofs-64031a11144f
X-Mailer: b4 0.15-dev
Message-ID: <20241220-kvm-config-virtiofs-v1-1-4f85019e38dc@google.com>
Subject: [PATCH] kvm_config: add CONFIG_VIRTIO_FS
From: Brendan Jackman <jackmanb@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

This is used for VMs, so add it. It depends on FUSE_FS for the
implementation.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 kernel/configs/kvm_guest.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/configs/kvm_guest.config b/kernel/configs/kvm_guest.config
index d0877063d925cd6db3136c9efd175669c1317131..86abe9de33bb2378ba0f7d46dbe4d84b49835506 100644
--- a/kernel/configs/kvm_guest.config
+++ b/kernel/configs/kvm_guest.config
@@ -33,3 +33,5 @@ CONFIG_SCSI_LOWLEVEL=y
 CONFIG_SCSI_VIRTIO=y
 CONFIG_VIRTIO_INPUT=y
 CONFIG_DRM_VIRTIO_GPU=y
+CONFIG_FUSE_FS=y
+CONFIG_VIRTIO_FS=y

---
base-commit: eabcdba3ad4098460a376538df2ae36500223c1e
change-id: 20241220-kvm-config-virtiofs-64031a11144f

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


