Return-Path: <kvm+bounces-10992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E710872094
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AC23283781
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B03585C7A;
	Tue,  5 Mar 2024 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OInsPYbs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CDF85C51
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646202; cv=none; b=SJFZfO7YMNIRZ7GeWFIzT9CZm9ugk5JK9BwG4MDYkBVYUXTuiMZdPb3ai2xCaCgurHg+e/TpDejRIsukvqwyRcbOYdx+lgitVsKPe6My2gnhMB8eGut3NDf3v9hllRS2PZzalDU7V34DcBPJ96ek5JK/Nrn3G7db2pX4+hsI5vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646202; c=relaxed/simple;
	bh=FRfn7OHdBAT+8krgiLs6H9QEbnclLYJCqiPid1Q2jTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0MyQX6Q9ShkvyXzRGe5YXbIP+TTD2D5mvR8t4uxh37CSbObSg6Mx9IhMR5ojMjgkj4XUCaCsrujrgzIslHgKT2iMUHSfyflDx3FATic/YQP+o2DU6WeLXXV2wCwkBfh9AMFhbhxbQTHkXjUflIWhWTQc47ZnCk5MkVpLR2nBlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OInsPYbs; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a44665605f3so602132966b.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646199; x=1710250999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uaVgcIj5CZp4PgaMSlBhVfscYd2B9Mi4dr8ANISE2s=;
        b=OInsPYbsKuBZ65KEGHsuIn1NfpGbeWWM2dHqgF5d/JD7G0phCzFzGvynRtLjGh5gb6
         a51GjjTt716sRR9wsJQFGs5nurPmKO2imCfA1gB6VRtFAavZpHXvpSvG2mpA8/skrM94
         IO1nMJ/OyjayUInIX74z7vxbwReBFYJCpwqp36gjDWfsZJeRiafkX/fbuT4No0WSyFZ3
         l91xJ0oPIMAI+JDkjkNxSHoeK2zwH3AoInmiikOqo/rwd8lClcDV8mPmk5jxCD3agM6/
         cfvi+c7gEilhJkC0unFDYaoT1KfDUjkhQ6RcDemP+H7n4Y3fkiX6wteIA1X14UolFaNv
         ijrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646199; x=1710250999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/uaVgcIj5CZp4PgaMSlBhVfscYd2B9Mi4dr8ANISE2s=;
        b=jFMmTdxyNZmJkup4a4uzD/wprL4eUB02iDJVpoUo9ZhRdrMkKU7kG4WqBZ5nmmbA02
         KzdyC2OAxjVNmU1ZkGPQpiFGwgkYI47KnDJ5DjdBAMOjRtM7ZV9vQkNYIUAkNvkmLvK6
         BOiv04QL2+5lzwjdLd6oQiXSOhAYxgK+5jqZfnkq8P1TaEvLakoWGdsd0EY0LCm/sPi3
         CC8+TNIcZdXMZA82yknsv2FKoqKJhzzRCP2cq1LsfjACuNdqxcQA6nfA0SWHVgTNYQMf
         vkxxR48fris/ekc+fcb052a8jhAd7OjiChIM/AmMXcdVLWRBrsmfZR6oQ1q9KREfNz08
         KqPw==
X-Forwarded-Encrypted: i=1; AJvYcCVRaUioz9TuJm/dOh78RnthNrrz7DtN1eN542cTINUabicN77M5MF9MjqhvYWDxn53XbO4gTfNMUCK26Z+PJKteyIXx
X-Gm-Message-State: AOJu0YzGESPdZuFT6yI0s7/f752NAI1BaBfN95Hl17yaZ5eDq/seZAfk
	PDbKnmgUjUM1nhPRXUHb98dvLxI7plRblpHwXqsYBnNMHCrMRpHXuxxKxdzLrU0=
X-Google-Smtp-Source: AGHT+IFX0UlicD2nXIVlAQ+n7nrYayFTU70QHqN/oYZVIOnExi3rdtn3EIahhoj5s7wQRhibaK+BUw==
X-Received: by 2002:a17:906:f2d1:b0:a45:7d04:c1fa with SMTP id gz17-20020a170906f2d100b00a457d04c1famr2588070ejb.67.1709646199488;
        Tue, 05 Mar 2024 05:43:19 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b00a45aeaf9969sm238731ejo.5.2024.03.05.05.43.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:43:19 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH-for-9.1 08/18] hw/i386/pc: Remove PCMachineClass::smbios_uuid_encoded
Date: Tue,  5 Mar 2024 14:42:10 +0100
Message-ID: <20240305134221.30924-9-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

PCMachineClass::smbios_uuid_encoded was only used by the
pc-i440fx-2.1 machine, which got removed. It is now always
true, remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/i386/pc.h | 1 -
 hw/i386/fw_cfg.c     | 2 +-
 hw/i386/pc.c         | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index f77639d94f..f051ddafca 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -109,7 +109,6 @@ struct PCMachineClass {
     /* SMBIOS compat: */
     bool smbios_defaults;
     bool smbios_legacy_mode;
-    bool smbios_uuid_encoded;
     SmbiosEntryPointType default_smbios_ep_type;
 
     /* RAM / address space compat: */
diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index 98a478c276..176c086673 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -63,7 +63,7 @@ void fw_cfg_build_smbios(PCMachineState *pcms, FWCfgState *fw_cfg)
     if (pcmc->smbios_defaults) {
         /* These values are guest ABI, do not change */
         smbios_set_defaults("QEMU", mc->desc, mc->name,
-                            pcmc->smbios_legacy_mode, pcmc->smbios_uuid_encoded,
+                            pcmc->smbios_legacy_mode, true,
                             pcms->smbios_entry_point_type);
     }
 
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index d417cf106c..409114bba5 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1791,7 +1791,6 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     pcmc->has_acpi_build = true;
     pcmc->rsdp_in_ram = true;
     pcmc->smbios_defaults = true;
-    pcmc->smbios_uuid_encoded = true;
     pcmc->gigabyte_align = true;
     pcmc->has_reserved_memory = true;
     pcmc->enforce_aligned_dimm = true;
-- 
2.41.0


