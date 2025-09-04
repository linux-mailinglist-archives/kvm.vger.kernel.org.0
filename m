Return-Path: <kvm+bounces-56788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB7FB4353A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 918D31C273E1
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D17C2D23BC;
	Thu,  4 Sep 2025 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MkuJ0NZT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91CE2D24BD
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973524; cv=none; b=jyrT9VPlnBsS6LWXOHQh2a6GY7kCEhOh0quwkTFD37bexT3vArHn6bNnFNhv3nckOlhx2j9bcNBN46fBZ54rSajFYT6wvMyOcSKMJF5qxOOca1KS/6QsicZfmFbBvMIvob+a5bAgpObSRElYIRFkcprC0OPqddrdfvspWeOMyzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973524; c=relaxed/simple;
	bh=Jbj41lUT7Zd1OiopuYZLug37r4ct7efDAMtJJheBoLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLvDNrhdlYuVWWEMc9MLq/dvhX4mpDie86FC7XXylqPMQXW033sT+VNm++LSOSCezgZYWoC7K+bPA4nGkVXLUAZ4/RoblHbw1FhGkvWGtmTGBJGU+G/t+oVcsGk5Xs/ZcQuq/I300S4w2SueDvShroTIP5MBIwJPYM2l/kA0WCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MkuJ0NZT; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7322da8so151140466b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973521; x=1757578321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dryPG5cdTvon401P43IQAncMYcpBnZGjJaBP50H9h5s=;
        b=MkuJ0NZT8s3ajZA87SdJex7VD/mdD708vFmDGREVIDAul7N/KRiA7Gq1jHpphlprpC
         iLtvRzADnQnWSa4uq7fBoDQc1h7A9YW50VgoTeCRBNrN68rbMan5VjDdwMbTkVLnINjK
         IhTOcNWIN8a7wRHrOQ8++tu0XzROKclWlJU7EMzBHs4nJqDeL4+m4peAscywH1GBqw4O
         swdMWuGNCY+8Gswa3XIOWlVQCtsGaozvl8iGNvieLXTSctxcNX1Qw8jNn/i07qqxx22R
         hxGMg30EJrbOZsWJMcRODJl/QIxttAiX3hSTU8U13ctkeqldG5nq90VprLQyjo1ZYAtH
         ThdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973521; x=1757578321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dryPG5cdTvon401P43IQAncMYcpBnZGjJaBP50H9h5s=;
        b=pGJSm6bZrs5hAp+hnAotWLO0FLxKbkKLVHQpjnYENtrgAJj/jVj5sZRyKBCdQBwFR6
         74gUOnNTfALbvIOjojYkXhwDiNsA/9Kom1DBgYtGbI0zTfFgaWDSUSG5c+ysPNPtDEYb
         F4sqxkynIaAWYoKKf/SXV0bjruBb/x4p0wmroiubXzpUZrN6T7QI6EN7iS1jZg1O9NBf
         QMAY9Ziy58IpN68sijMNHEb1u3yq6k93QYMukriAK4HxllcMOU43ClIfuHiYEgt8Rdju
         aFHxrvyiAO2Q0817FZWkbbq+/NohWihRNKe3euwDzMfBUNzNWkLEp4pzUSXcWThQa7Nr
         LGNw==
X-Forwarded-Encrypted: i=1; AJvYcCWt+3uDwMG4KIpbpu7HDP7tTJbTg680isNqaPnGUPQxI70ux+GKsjrqpPweldRHaVgDYDU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL4ygllSpq3UBMWtc80LZnXs6uNnDAyfRsjJfnTHURGaY9aAJv
	rTLe1FXQQ4vrcuJvVpB750hx1WK6OWIeHgDN23gTa9EcyYb45eSpOmBXEz6OuKe6EDg=
X-Gm-Gg: ASbGncv7zpZlp6vDIjMVj3SudNehn0TgzyGiaaJBpsbElsl5QQn481PfBWqnmisZElO
	kaBMJGDgxNGveEzJwaYxnuSk/oL7wAB6/Kq00QOmkyTocWc2V42MAAVF16hKQM7Fi2d3ZGdWHu/
	0vkumDTs4QGJD7nS+VszBtHslYq498z2cCbvz7O4MLDuGCLLOVvdeET3stmUHtOTBHM6TsBCorx
	DfdnAuR//9Rr0yTaNCPBzv/CVSu0NIIK6p5jZJ3Jal7TjhdakbVI8fgva7REkhHvJZhWb/Hr72X
	6tpaECllF+/u5+g2j4ByWgn7y0BMDfuQWtzIgn0r7U+bK9q8kpKuQJOr2CjFRg0zugfpf9m3dp5
	EFSU0ik3ewQSjE1KF90lNM98=
X-Google-Smtp-Source: AGHT+IGDnb25U4p97OCHED0J2lFk0ur4/KBbXrud2PABbqZVX6GA8E6Xsu3KLiaHB+cjs0txk70Kjg==
X-Received: by 2002:a17:907:7ea8:b0:b04:53cc:441c with SMTP id a640c23a62f3a-b0453cc4688mr868679666b.28.1756973521151;
        Thu, 04 Sep 2025 01:12:01 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff12a6b404sm1395198066b.88.2025.09.04.01.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 8A375601B3;
	Thu, 04 Sep 2025 09:11:34 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 051/281] linux-user: Move ppc uabi/asm/elf.h workaround to osdep.h
Date: Thu,  4 Sep 2025 09:07:25 +0100
Message-ID: <20250904081128.1942269-52-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Richard Henderson <richard.henderson@linaro.org>

Move the workaround out of linux-user/elfload.c, so that
we don't have to replicate it in many places.  Place it
immediately after the include of <signal.h>, which draws
in the relevant symbols.

Note that ARCH_DLINFO is not defined by the kernel header,
and so there's no need to undef it either.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/osdep.h |  8 ++++++++
 hw/core/loader.c     |  4 ----
 linux-user/elfload.c | 10 ----------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 96fe51bc390..be3460b32f2 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -133,6 +133,14 @@ QEMU_EXTERN_C int daemon(int, int);
 #include <setjmp.h>
 #include <signal.h>
 
+/*
+ * Avoid conflict with linux/arch/powerpc/include/uapi/asm/elf.h, included
+ * from <asm/sigcontext.h>, but we might as well do this unconditionally.
+ */
+#undef ELF_CLASS
+#undef ELF_DATA
+#undef ELF_ARCH
+
 #ifdef CONFIG_IOVEC
 #include <sys/uio.h>
 #endif
diff --git a/hw/core/loader.c b/hw/core/loader.c
index e7056ba4bd3..524af6f14a0 100644
--- a/hw/core/loader.c
+++ b/hw/core/loader.c
@@ -295,10 +295,6 @@ static void *load_at(int fd, off_t offset, size_t size)
     return ptr;
 }
 
-#ifdef ELF_CLASS
-#undef ELF_CLASS
-#endif
-
 #define ELF_CLASS   ELFCLASS32
 #include "elf.h"
 
diff --git a/linux-user/elfload.c b/linux-user/elfload.c
index ea214105ff8..4ca8c39dc26 100644
--- a/linux-user/elfload.c
+++ b/linux-user/elfload.c
@@ -35,16 +35,6 @@
 #include "target/arm/cpu-features.h"
 #endif
 
-#ifdef _ARCH_PPC64
-#undef ARCH_DLINFO
-#undef ELF_PLATFORM
-#undef ELF_HWCAP
-#undef ELF_HWCAP2
-#undef ELF_CLASS
-#undef ELF_DATA
-#undef ELF_ARCH
-#endif
-
 #ifndef TARGET_ARCH_HAS_SIGTRAMP_PAGE
 #define TARGET_ARCH_HAS_SIGTRAMP_PAGE 0
 #endif
-- 
2.47.2


