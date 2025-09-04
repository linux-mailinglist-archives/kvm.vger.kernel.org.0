Return-Path: <kvm+bounces-56768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04AEBB43517
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBBF07C42B9
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCE72C08BE;
	Thu,  4 Sep 2025 08:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L/uYbVoh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97E22BEFF0
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973494; cv=none; b=dX2JY0jBKq7590qikv1GbZ1Z5TpSoLOZxxathVn0+VT2ib+Hgw8g8H4hsmk7ss16roMAWm/B4QKr2ftvVmcLI6JOA2ilS+EzEobFVqSST48KFTcDETy+4P+XATHOJZVp2de/nGZZ4uDN9/Xv3lzRUFtrBilO8HYYdlTVlrY64mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973494; c=relaxed/simple;
	bh=g2c2rwvNXwtPXn1nZWME/EQrYmx/Nv8VVrnHzRxtp64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKOLGb1/uj0f9oIWGrDdzkTQbHWGQzYNYu+15WA4rTXmyH90vFFuj14mYk5eZvElnMR4S2g5hAuMfvUZ1D+ci+7U/i2hDkeRnTqGbByMsRu9elLE1GEtwlqOnkKM7BlnoXDzZ/HPO5seRHMzlbnRotizy5oB8euo1F+dXKgTiEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L/uYbVoh; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61ce4c32a36so1285099a12.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973491; x=1757578291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNEGVA0a3lSomvk/RYtnyV9U8MhQRFndjMqEzv6fEMo=;
        b=L/uYbVoh5TxKCYzW79SN5CIPMRrEUdMb2C38lm62KXgVztSRlQw/YF0ZLU3+GDuFUm
         XeUZL9e69ZXGAZvwIQcg8bcFD81fr8s6NYk/4/ONPVBRQ+wL3taHjVYdeZ8TwaQvnRpD
         ++CU7gFevrQlOedSAvy2cV5JJTDPv/n19EX3NfxTwIDxtYvpmIopUTKFRM4Wbe8htxrm
         tINPuXDsnlXJwqpFbcixR+dOUj2Ikp5VzM1/dx6ESNsZaK9smrmRfCNL8w7oKQ82x2tQ
         pmjskts6deT6MTu9+1PDKYIshNZ1YqWRGg+Kt29IzaiLSVituSSWhkQaBZV7ugEtHejr
         Zyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973491; x=1757578291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNEGVA0a3lSomvk/RYtnyV9U8MhQRFndjMqEzv6fEMo=;
        b=rhF8Didr+jWbnM54Ox+CFmf+gSN/jtP+fFzk8nOQgiTs3fpzhFRSlndojb3OcQG/5c
         NiFEyF1CUJNGqo1opNwhZVCrfvNLcoh0SzQ/INhCyE/elD7L57jgfjrpyxfKZz/S9bVT
         ycQCaqFUJFQ62b6MzXIV9FjacgTwdUAzV2OZheh53ARsgd6hNFav3a1IV5cFiaWBdRmr
         dWhZyq3O88M0jGd+U2yJJhgdW5rOVnLwruEqmk1SXtnTwsJjFlhzjY4Xo8Xgvusp+ujB
         moiWp9ilfkf4xhSL110x0/uAb8bSjbMRQxuz48HipxRxpLNw7IT0nKwlfTuoz7i3rVhx
         Ks1A==
X-Forwarded-Encrypted: i=1; AJvYcCXI+qtGEa4n0iYU6Qf/VsH/YkMK/fbzn9UfEj8LFBPzl7s41shVq6lKo9cj4MqkmlknhjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOTcQ1BxZ5wa95AbWcUcGubDAUguFZpP8bMtMlIdxVntzSqSMf
	LaGRe2upvZie3ADpR+DczlmQz51TXug3ceqB8e2q+hlWgyVaQAoqgGPmq9LEPTefo2Y=
X-Gm-Gg: ASbGncuECS34NQ60lt6lWLLRg4aPUhhV1pVaIkDS3DzYsO4dKDhzuwhLAUS/+iHx7lf
	/DSbWtYQuS8ABcZu72FXxyfUYXbxk7Zj/2si8N5uqAgyCyaIbxRfdk6VtJ7y9pjZ9Umcz5PsnTF
	mNEm4jmDeJ87vHBCNl2TCwHGiS8kO8KorzAgngyNhzQtx8e2987KWtBMd/OygClZFj+tmWE2cFl
	KOiibjOZkwUn7UHk/bFkI8auk/P5noxyyB76Fq8tZ69dNu6RH+QRppTLmjpNUWn7b7t0ef8brWq
	DVbvtASJ1rXoZfzwOcYUu8a0Ronw2sLPN6xLkrt7Ds6tArujqVC2n52fwcsIeZ2ZIp/PSVAZrBr
	blI4ODEaaAgb8XRixYIc2rma5G2DQYgs/vA==
X-Google-Smtp-Source: AGHT+IHexK94NPWoWCrwjuk3gIAjHKSuKZUcH35FtgtMhup7hPhQojKoYZ1y3LzApeF9bdhKrTjgdQ==
X-Received: by 2002:a05:6402:1e8c:b0:620:894c:656c with SMTP id 4fb4d7f45d1cf-620894c7c6fmr28663a12.29.1756973490788;
        Thu, 04 Sep 2025 01:11:30 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc5575dcsm13745805a12.49.2025.09.04.01.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:29 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4CE8D5F900;
	Thu, 04 Sep 2025 09:11:28 +0100 (BST)
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
	John Levon <john.levon@nutanix.com>,
	Xin Wang <wangxinxin.wang@huawei.com>
Subject: [PATCH v2 001/281] target/i386: Add support for save/load of exception error code
Date: Thu,  4 Sep 2025 09:06:35 +0100
Message-ID: <20250904081128.1942269-2-alex.bennee@linaro.org>
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

From: Xin Wang <wangxinxin.wang@huawei.com>

For now, qemu save/load CPU exception info(such as exception_nr and
has_error_code), while the exception error_code is ignored. This will
cause the dest hypervisor reinject a vCPU exception with error_code(0),
potentially causing a guest kernel panic.

For instance, if src VM stopped with an user-mode write #PF (error_code 6),
the dest hypervisor will reinject an #PF with error_code(0) when vCPU resume,
then guest kernel panic as:
  BUG: unable to handle page fault for address: 00007f80319cb010
  #PF: supervisor read access in user mode
  #PF: error_code(0x0000) - not-present page
  RIP: 0033:0x40115d

To fix it, support save/load exception error_code.

Signed-off-by: Xin Wang <wangxinxin.wang@huawei.com>
Link: https://lore.kernel.org/r/20250819145834.3998-1-wangxinxin.wang@huawei.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 target/i386/machine.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index dd2dac1d443..45b7cea80aa 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -462,6 +462,24 @@ static const VMStateDescription vmstate_exception_info = {
     }
 };
 
+static bool cpu_errcode_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+
+    return cpu->env.has_error_code != 0;
+}
+
+static const VMStateDescription vmstate_error_code = {
+    .name = "cpu/error_code",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = cpu_errcode_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_INT32(env.error_code, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 /* Poll control MSR enabled by default */
 static bool poll_control_msr_needed(void *opaque)
 {
@@ -1746,6 +1764,7 @@ const VMStateDescription vmstate_x86_cpu = {
     },
     .subsections = (const VMStateDescription * const []) {
         &vmstate_exception_info,
+        &vmstate_error_code,
         &vmstate_async_pf_msr,
         &vmstate_async_pf_int_msr,
         &vmstate_pv_eoi_msr,
-- 
2.47.2


