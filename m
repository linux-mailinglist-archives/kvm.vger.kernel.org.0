Return-Path: <kvm+bounces-24475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8139C9560B5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE4601F214AC
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00451B5AA;
	Mon, 19 Aug 2024 01:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGEFkBcJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com [209.85.167.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815D1BC20
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 01:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029613; cv=none; b=WAJaRHAvpuXgBjnup12TU+oE+gwi4l31ax9qjDFrB00NpNWDWi+EpTiut7SbSn+Q19TSMSEcLyOhkxSxmZ9+lR9f52w5gRvsMk8okMQVEWV8cMFcIQoycG6Y+T2sSpavGnabRCIDFOvU21VXllH+J+hA/x0Q9bK8cPahJtYEwX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029613; c=relaxed/simple;
	bh=yQtneJNu6ZagGjhdtfRQoyCJf5yMN8rUVsK9/kqzDzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLU08i/8+xR5/ZPa4SinYZ5AbAAXqLHbIGMXnkF4joIF1G02wWpfR/ImZDhV+4GzMYzilZ+mIzmfzHBr/tcrGqB5UwtHX9WbNRqstw7AaHkC1XvS75WBxQMoE/cF2v6YbJ9PsP3PORgOno0PDJ5Hv+vvSgYLq+s5UxvZuM7R9IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGEFkBcJ; arc=none smtp.client-ip=209.85.167.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f196.google.com with SMTP id 5614622812f47-3db16a98d16so2358255b6e.0
        for <kvm@vger.kernel.org>; Sun, 18 Aug 2024 18:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724029611; x=1724634411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8DMONrCq5KQTQXp7Rw7pTf0+PDkeHOFVckSuH74uqc=;
        b=dGEFkBcJg+blDvo4ocGApUgg7ae1rpy3IammipMKUwhrSv8iRcvWCuFrVQrShPh3Or
         +rTg2+6NU/YDQTZ+u91fU6ZvgrbQaDVqddhnlVilfo7wSLbDUvPJmkRfXm99pjs81C6j
         VznPP6hwof0WAf52+fffIZqCI3SSqfPE6DfBQYPuX1sm7Lxfzy83A9nyxHVCqVIA+gW/
         CKzSd69nfJ/UO5jYEsjPCbA1snrQm7dEhDkd5vNndOsA2IUc2Cu91Z6gKiFWtx2IV4VA
         uV4Zb+c9R3xe5esT6Qjd/3QZRhnVMCPujCfxNivE37ZnGyw+uq9zi7XqPu9WFFa0n58j
         srrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724029611; x=1724634411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8DMONrCq5KQTQXp7Rw7pTf0+PDkeHOFVckSuH74uqc=;
        b=hwoyyDKWHjdethmgR8edPNVEkjubaHkXSl65oR0KyiFlzd/1NylWvfqAGo60XgUPST
         obj65TW3Vos0CNtaFf/ujbnf1i6wo2vl4O8JGcvSubabgSnZgsTKAhFTnSOrGDlCyfKz
         PximqlaBSC5BVh5wg91jh7DW7rWbjPswzE27WeXf5EvQVr86HuFHxfQ1lM9raX7VODRq
         RrFbgoWGSsw3n34pMGtX2DxW7ZTKmitNCwT/EFsYPzUf8SBmIlI9uy+sjl6Ij3drzWh4
         ZAN96BNdRTtPM43uogdpTDpt2xT0HrHTPNSZ4IjxpnSGYypLKiUPYo3FwRgL1/FVr8kV
         FFmQ==
X-Gm-Message-State: AOJu0YyGBsuniLFmLogZVlqi2tJS7MIrWh1MMJSKOxioqv01s0j+hbeQ
	bOdvQ5v3zTwBBCNni0Dgws8TcS7+rdrvXjT/Of3koCpUDTYWNQr0
X-Google-Smtp-Source: AGHT+IEFiTrUDZN3WYOajNbC7RewQtzXTod6o4ykKgLxRNilTkKP81hAi3+iM6S/JifxwfTyCDFCzw==
X-Received: by 2002:a05:6808:1147:b0:3db:2fe8:691e with SMTP id 5614622812f47-3dd3ae430acmr10938867b6e.42.1724029610778;
        Sun, 18 Aug 2024 18:06:50 -0700 (PDT)
Received: from localhost.localdomain ([45.63.58.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61a93aesm6519897a12.17.2024.08.18.18.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 18:06:50 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: sidongli1997@gmail.com
Cc: kvm@vger.kernel.org
Subject: [PATCH kvmtool 3/4] x86: Remove the noapic option from the kernel command line
Date: Mon, 19 Aug 2024 09:06:42 +0800
Message-ID: <20240819010642.13897-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240819010154.13808-1-sidongli1997@gmail.com>
References: <20240819010154.13808-1-sidongli1997@gmail.com>
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

Only one CPU is available at this point, solve this problem by enabling io apic.

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


