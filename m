Return-Path: <kvm+bounces-45878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A307DAAFBC9
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4AB74C89A2
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEE622D9E1;
	Thu,  8 May 2025 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XgQm4QMI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43822D781
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711767; cv=none; b=ec3pIgIvXSyvizICKnzCruy9HjyPAcwpM7OwUVW+/P9e3V9rS5tEsDpwUvVDlYmpobuh7unvf9mZtov+8VeNHcisQQ71QfD7P/jjWL4I0b4ehi+OV/r8t+b4Y5wkxJf5QgihBg1sSVu2LBryRoDsX4T0SSDQ8yrwR0sP6TRMEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711767; c=relaxed/simple;
	bh=vUQaSJazdr9YigDJBTqWMGRf/XTUFjVVkpYWwLhFTYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OuNRpfPGtXEJwQJh+PX4LG0awkr4DzLbSIhV87F+5Y4mMQlaxFJ9EJ3Db+OelDFCrseNOeQx3z873EXuGt4pOGh0HNTKCAFZMcKqs1QSsEslsRgD3915GmuZNqLqp7Kc0cBPnKFPII1c4GZSBiwWbwBCJIR+BFsVAG9hQT8qImM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XgQm4QMI; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22c3407a87aso13407985ad.3
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711765; x=1747316565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gg679U0oeTq/CrQiB/JmPwYk2e2+O7nBapgQj4COJfQ=;
        b=XgQm4QMIShAJ9vxLiiG6viabU3fJ8Sv2ycbDus57gLVwxNoobH5RskshJiEwkVLK+R
         LkebQjrDWGP/8yrq7bDPJEAQ8aIK2ajyYfo8wl80EgKy0amt5f02M6+EMoqumRvnGlU+
         UasunuqlyP61MZrUU40DH8OCqVek0FKMY0kfpq8w6JgsNP8KfQwUCwuMOQz59CRmBPP6
         lHYeXhDwj1z2sovp0ERllakX94B+8GSNkyzs/4Vs53FONJ/+lj5xJ0cffJCd1S6yV8W+
         ylDK//Zlpua2bsZAur0upWu9cwRFJT4M5hz87MhHeXJ7DQFUp2lcCEN2Lwu10+YPUj+i
         GDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711765; x=1747316565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gg679U0oeTq/CrQiB/JmPwYk2e2+O7nBapgQj4COJfQ=;
        b=qv9qYb6ij27MaDCSogsrx/M8wXNmVgzzkO3eYV8MF0G1BqKMPL+P/MM/NuJ+DEw7aM
         x/FKzQCVZYibmReyWwTXQqaHHthOxbsCJVgTqYpae6tbn5OGoSiOnjUBibRsbY1T+wFa
         xoTnv+l0aWw4d0kF38hkS+8MCt8BFNgerKod7EdwS/5StWB/NAWgj2rVt5CdtwKtxe3o
         WNwe+w44AUxyPEqUAmnFFj6kxTvEbgG+F8VfoDhUcZkQvg5dLpPdajlWT/uOLOhXq+7t
         /u9qpk/g2XFvJ+J9Q3NNgOofc4YbKZojZ1JloiLV+1ncE+YlpPt24T1g8icx6HUPwkvL
         om5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUFhz7K4trgFzfSTegpllOktPvrMLb60ffpGoQFy97PfFUDbWmB5e7b0qxbTmCHjeIVYfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKR9WhlafDXCEpAt4uOGYiwgLOkW6Ytl4BAiUypN9hg2aiSWI7
	urEnMMuDg+b+pw43NhG7R9kV8Fn4VLuutlo88OST+2BPvplfhiDlPLeML4fl0Ew=
X-Gm-Gg: ASbGncspjRumloiyUpcH4PBtHeEAH9I7kmFS2PIWEltm/TosVo3GZrxmzF0bBf+A2Rg
	Ne/jj+8CHrRz7jtTpvB8AePu84aSF6/lMoYHMOll2w9RGu8XEJaRBD9TIJPlE5YeeOTpkyQH+FH
	+pfz0MCB2WsRV2YIup9y7Lrp5vPJJHn863XTcIuW2UVJn7sMQ6aNQbEolSVyC4coS4xFaL6n1sb
	2zT0H/2cenAB+Qtii7p3xJwsWNerKb4Qgem56o5bDGUWcOFFLHeC+XA4GP/gKX/JIM/m6R2X8YE
	xzliOH4pDTty4Y8cGeSFfQXZ7zR+hx2dFV9PI6xshYdtJp0T/FTzDT+xGfVCPoh/4K4hHmg9V5+
	lSQ09X5Z5VGqnLsQAsvJr8TLvoQ==
X-Google-Smtp-Source: AGHT+IGd2BdAYJt/pgnYduHUiEhOTqQEnoUCxH7HrPCg6BSmtWJTrp7/DQ1i/MuAD3g4No1s3jElvQ==
X-Received: by 2002:a17:903:41ca:b0:22e:421b:49ad with SMTP id d9443c01a7336-22e8f0b60a9mr53754775ad.46.1746711765042;
        Thu, 08 May 2025 06:42:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e15232655sm111626845ad.259.2025.05.08.06.42.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:42:44 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: [PATCH v4 18/27] hw/i386/pc: Remove pc_compat_2_7[] array
Date: Thu,  8 May 2025 15:35:41 +0200
Message-ID: <20250508133550.81391-19-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The pc_compat_2_7[] array was only used by the pc-q35-2.7
and pc-i440fx-2.7 machines, which got removed. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
---
 include/hw/i386/pc.h |  3 ---
 hw/i386/pc.c         | 10 ----------
 2 files changed, 13 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 4fb2033bc54..319ec82f709 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -289,9 +289,6 @@ extern const size_t pc_compat_2_9_len;
 extern GlobalProperty pc_compat_2_8[];
 extern const size_t pc_compat_2_8_len;
 
-extern GlobalProperty pc_compat_2_7[];
-extern const size_t pc_compat_2_7_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
                                                  const void *data) \
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 65a11ea8f99..c7cdbe93753 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -241,16 +241,6 @@ GlobalProperty pc_compat_2_8[] = {
 };
 const size_t pc_compat_2_8_len = G_N_ELEMENTS(pc_compat_2_8);
 
-GlobalProperty pc_compat_2_7[] = {
-    { TYPE_X86_CPU, "l3-cache", "off" },
-    { TYPE_X86_CPU, "full-cpuid-auto-level", "off" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "family", "15" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "model", "6" },
-    { "Opteron_G3" "-" TYPE_X86_CPU, "stepping", "1" },
-    { "isa-pcspk", "migrate", "off" },
-};
-const size_t pc_compat_2_7_len = G_N_ELEMENTS(pc_compat_2_7);
-
 /*
  * @PC_FW_DATA:
  * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables
-- 
2.47.1


