Return-Path: <kvm+bounces-26059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA1496FF26
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 04:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25C301F23C95
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A5E1B949;
	Sat,  7 Sep 2024 02:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RU83MqBG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3931798C
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 02:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725675216; cv=none; b=MO5/SSRWiH2BX3X1yo2sDKshg1XT/xXVS7hQ9NCECe8gV9holDxQ/dYrP7uqGkGpiTXxVhmQJnX4WdvjuvYdrS0j2u46RYaUWCHb8Df3j/5aWz8xSV4fFkSoV1uppFfGKfx1nXLCn1douc2qiOBPc3ySv4Z9wA89NpQ+wQFmxLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725675216; c=relaxed/simple;
	bh=pgzKJKQsDhk64TV0oaUIuIF03fCRU69OvK3SFvBpjJY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbsEwIL+qpu++vl5xtDZ6dWcsDv2sq+y+vhv/lbOM58DT94rITt+NEEGWE3EooRS/jw9X7fQEOuSoUdX8NuQx3szs3ookH3LzZH0HoCTQKx0nuxqnbTbCcCjQ7NvaTXn3OvXP5mlrCi2mktrkE10hiSvk7HVWZPFHWkwgFFpGlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RU83MqBG; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2057c6c57b5so14766955ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 19:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725675215; x=1726280015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Ppll5og+7MZitnS1Ultyinon8CAl/ja+joa5yj6w7A=;
        b=RU83MqBG/0ZHPp85ZjdZkfgAwfZffa2vulIZGdwHnDS+QhLRhveypokM36F4nT2qU1
         7KvKDjldlpg7ZH/uyp5+NSkMm4dpe/WdhJZZZ/yjYnOjpBig2Quy72LNC5fSCg5tfzEZ
         kKiVLXgaNeXjSwY0grA/AUVYGVkepBvm1MXVlVITS+w+lH0SsHisWmDALPJ5nfjdzk9q
         F98ar3Wu0HyCaTx1PuX1M3PC2HSpMTlvy/kQmwTlX0TMgUDwrRD41kMydmaeP0hVdTVA
         CQ9Fsl5anQgQLmjrmxkY62RyhJXHXm2m6JHGCfnb2mf5ikfs79rHzVln+q5b08mijXLR
         6hHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725675215; x=1726280015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Ppll5og+7MZitnS1Ultyinon8CAl/ja+joa5yj6w7A=;
        b=IAMCw9GhaIFo/fg3h9w9kVQP6APkwGPU7M0KclRbrRgAAmXiG4OnXV63vPBDCV+74e
         BYgiXDOqVdp5U+MRSgRSKtI1/BQC8jEYAMStJEHgEGzf7mF0IDBhcsgyQGZM/BoCi9/Q
         V494MKQiqVDU+/B0Ly/I6/RxAEZ2z6ZK69fTo+36UmsU+0BiNnwoHtvnCGSH05cM1P0Q
         BYtiQXjrfIBKNzZ3hVTIAA/AcH2AIwwot4XckeZecWL3W1ezFCdWLHpmJG3VzunbG/Vy
         5WoJKvAtGp3hA8RDkSN2cKwifRJYE+Lbw67ApK6TBK9a2/Yty5hpp0uHZsQa49fwIlbt
         HCYA==
X-Gm-Message-State: AOJu0YzrLUc5zpKQ/+k7dlCfl+DQpv+UkXFz67I/S+85oxNqXML7j5GJ
	BS6INpMHhcsz6U2EfEsnhWXrhkQvIbslp1iBMsXULkRuinO5JzkHbWSjUuv4cgunbQ==
X-Google-Smtp-Source: AGHT+IFJDdU+KLw+QiLf3hkCmbQZRRBViQHuFKUXlz7OLU95cI6EBCyTFSFMtTT+yfjvY1myft0tMA==
X-Received: by 2002:a17:902:ec87:b0:205:4d27:616e with SMTP id d9443c01a7336-206eeb7a94cmr65661985ad.22.1725675214519;
        Fri, 06 Sep 2024 19:13:34 -0700 (PDT)
Received: from localhost.localdomain ([14.154.195.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710f20104sm1215845ad.233.2024.09.06.19.13.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 19:13:34 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvmtool v2 3/4] x86: Remove the "noapic" kernel cmdline parameter (for enable the IO APIC)
Date: Sat,  7 Sep 2024 10:13:20 +0800
Message-ID: <20240907021321.30222-4-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240907021321.30222-1-sidongli1997@gmail.com>
References: <20240907021321.30222-1-sidongli1997@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running guest kernel 6.9 and later and above and the number of vCPUs
is greater than 1, dmesg reports:

[    0.009932] CPU topo: CPU limit of 1 reached. Ignoring further CPUs

Only one CPU is available at this point, solve this problem by enabling IO APIC.

Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/kvm.c b/x86/kvm.c
index 71ebb1e..e07d964 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -130,7 +130,7 @@ void kvm__init_ram(struct kvm *kvm)
 /* Arch-specific commandline setup */
 void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
-	strcpy(cmdline, "noapic noacpi pci=conf1 reboot=k panic=1 i8042.direct=1 "
+	strcpy(cmdline, "noacpi pci=conf1 reboot=k panic=1 i8042.direct=1 "
 				"i8042.dumbkbd=1 i8042.nopnp=1");
 	if (video)
 		strcat(cmdline, " video=vesafb");
-- 
2.44.0


