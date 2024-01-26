Return-Path: <kvm+bounces-7215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2EC83E476
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EABEB21B39
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B1925543;
	Fri, 26 Jan 2024 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L6+F6Zbr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32D250F9
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306660; cv=none; b=ks7ZjswsN2nOSwH5sz621f+zyOW4Dn5Ak9j9YCNZF0cCqpvKBQD8wejD/U/frLoMw3rQKxuXROTVGi/tMfjkKsdiOjw9pkWswp9RDI9BF89JDy5Xf6XdHi2nsTMaFr81X/bMwXJ1p3oc0Gbjlvjf8NE73K54OUVw0hD5H2WsNTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306660; c=relaxed/simple;
	bh=9RBSo+pQhwiHSiotI8xWa/iq//UpNyo9T7/+Ad7gNZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1nt0GY0qSSNKFy+PukOv0kjVyqZZD/+UCSV0yAmjUtpmo5rA5BpEsULNz3Z0cQQCVEDk8egj0qkjm/1tl2Ap/BgQ87m0pumY+0mMh7SvhWFr4WlYlNxZ4lmx3WmDNlB8P8VeM6Yn7nzoV6amtXSA8fFZsxH3Jd8/gdGeikDAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L6+F6Zbr; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55c2c90c67dso588859a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306656; x=1706911456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhPW+/fhD522LvSZgboHJx0z0AbZf2+RXOPHpa2tqdM=;
        b=L6+F6ZbrPjJZUYME+9ZMsiODmpxHaXLIVa5NcdSgIcRFdWqz5BWWndcwiTHmS7d2an
         pVaay3Yz0+NmbON5nmiUe7XSrc+BjnkJYhUZPhfZ+pcLRkcPfkpH7sp+oawsjO7YX+Cf
         RZ+HSep0bCDNHKannsJGjc4E6csSdNgvdir/DmHG+aGqpkU8t3OTnR3gM++UCVgm4Aiz
         l1uSaew1jKTG13UOyBVzgcD0j+U2SwnKgsGVBFeJ5RM0qafckvgiJbkv8zEVSb07V5yK
         BkEjFEoYo6n2dtMnn9qtuu9EuDU42/hG229m/iUjmc48qHuRCQcFyWzFopKX5+rGfMa+
         UcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306656; x=1706911456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fhPW+/fhD522LvSZgboHJx0z0AbZf2+RXOPHpa2tqdM=;
        b=k6p24EaI7UT4OKJxgl3GMuez0/WjFQLsUpr7x/uI8Lynrs/K5fYE6hvM809Gl+EtDS
         md1DxqnMjyE042zMgt10EvUy8PGvNQOCH2NYd55Cg8+aLsyUy/C//ltlsRnqnucUePyO
         9GLDAZlf+jM/1wGzkWmmNofzkSnc/Yt5wR3gY6S5lXow4JU1YbVhJVz+ITFjWAzjl/Z7
         s9QD3OEZ9Gpob4EKNyKKOUhj/eVg830NUvtCcjfud6F9/F/h53hZ4xkXZgj9RO8VR4S3
         oeJEljTGP0sjDhr+jkRPytJQcfXZqBj46zCr9qeysi68TwutnPk5AEnuZSJAOTBLyDv/
         bYJQ==
X-Gm-Message-State: AOJu0YyUePlXBu5kti3+N5k8Ouq+CUlwdIq8hnEOVYiVl2wpchIbfwYa
	rB2lfAZyxL8Z1uIHJ9wpcmkxt0U49M0l8Qa8YZC+9yPlC5QqXVs6Sn1zcHQnj88=
X-Google-Smtp-Source: AGHT+IG4Wg8rywDTMVuRM7GkwEmCFZtMm4l+BGhG1j8wou81QLrVUKTsIfgDuyEQppKx/hJqB7/64Q==
X-Received: by 2002:a05:6402:34d4:b0:55d:357f:1837 with SMTP id w20-20020a05640234d400b0055d357f1837mr298106edc.1.1706306656478;
        Fri, 26 Jan 2024 14:04:16 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id d26-20020a056402401a00b0055c6048544fsm1007886eda.66.2024.01.26.14.04.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:16 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Subject: [PATCH v2 01/23] hw/acpi/cpu: Use CPUState typedef
Date: Fri, 26 Jan 2024 23:03:43 +0100
Message-ID: <20240126220407.95022-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

QEMU coding style recommend using structure typedefs:
https://www.qemu.org/docs/master/devel/style.html#typedefs

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/acpi/cpu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/acpi/cpu.h b/include/hw/acpi/cpu.h
index bc901660fb..209e1773f8 100644
--- a/include/hw/acpi/cpu.h
+++ b/include/hw/acpi/cpu.h
@@ -19,7 +19,7 @@
 #include "hw/hotplug.h"
 
 typedef struct AcpiCpuStatus {
-    struct CPUState *cpu;
+    CPUState *cpu;
     uint64_t arch_id;
     bool is_inserting;
     bool is_removing;
-- 
2.41.0


