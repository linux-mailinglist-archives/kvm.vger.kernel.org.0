Return-Path: <kvm+bounces-34634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF9CA03106
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02FC43A3912
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954861DFE03;
	Mon,  6 Jan 2025 20:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="livjnYzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B33E1DF97C
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193806; cv=none; b=AMqlx24/S18GeTEB0ONCo9HHr0LlBBMSc2CWm4CfkFpLdw8uMPH1OTC0yzi+mVt4IGOM793dAp1z0zDee3YUGIDI/dPG16qBh4SfDFJ/c5uKvZnkClYgCXBk6srasBd2hyVJwI5oM0ueDVn3Lah1JJz+k8Elhyt9JPpuaOFG71M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193806; c=relaxed/simple;
	bh=jZ7uM/5ls9f5amJ9Rvsz2L3dolKK9SGFYa4mZLTw/k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=By1OhPsxE4CTC/j7fIJVWT7dnyy/KHZc2Tw3c0gWL4iIp0xtUmdYMDInFp8FKkSZW2igOs9CEjHz0cP861trQYmqoDRZjLFgXXH8kUxZDtjoMETuRi45EeXGi3EFiJ8EXos9TsPwaDqhofqv45xHNKUV5Fw5eIZYqdfMv8t7QS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=livjnYzL; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4362bae4d7dso106049015e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193803; x=1736798603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FEstRp4e2Qb00qEl2/J4TP29Zm1C+ONgiSLe4ofc5Fw=;
        b=livjnYzLN/IHGzYYzSFrMcv8pAjVaRIFPdlFZ/6Ll+qfhv8K+TVcuXgO3ziQ28LnvG
         s2vnRVujNKQUSMUAbdCCjvmHdV+zZW+QkZvcCiJPb95hcyp7PN1/r+dTtI7LngzDDphK
         HYQ8ynAE5Yj6KjTxOMe4DyMH8a8TND1Lld8PmPgEK55l55U8lvJxLOOPjvcGqL50bc+W
         6ijG26V/gy8F2ooLW8yLLAZusbqLiRjK4TO5jCuDCGBgEIVdQZYR7c1cVAczTON937Y6
         hq/Nui5sXH4Z4JwuwLPUmT1JiGq15w7xhWs1K+qENToCbUqNc2bTnYxo/kU447LeJBgm
         JRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193803; x=1736798603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FEstRp4e2Qb00qEl2/J4TP29Zm1C+ONgiSLe4ofc5Fw=;
        b=k1m9AB/Pl+CN76pUzVkw3LoxPto094FSBRAc/L6fsNH0rsoQXOqOCZG/oaHUtvd4nR
         wqjubWw9HeD+S+V129wOcobRC46mUayjCu0ZSitJhFPM+P56NiDAFUg4c+jndHSCHsFU
         7q1CddeMCpkSwO/f3H/TOf+Qyf4lI1fCazyNwgjZTM16k2Nk1j27RLBvG4dRLKfvYoW0
         G8Bzk/7F9QEVk4ey0eGh63nLDWXT6geg59niCLVlgFIkwCyJ88XPHluxZkzv1Qu+tW5D
         mzbJ4uPpZHhRoZkQC+6LLTigdaEr1wt3koPIXhRQFEg2CjtXF3vuhlOFlbOmBP1JrtR3
         lfxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3Y4F2JT6VAxaBU0I8Ou3ALDa4MViyI8BcOcugDBlp2wKvGOc0lkbYi27oUWsTR/Dodn0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5F8vSs3aARng8DRkUB9p3raww2dIaolQfVCBMqe0l/7VZWteC
	j46jADOH1y9JvAoZC5zp1MXp7RHeEA7ledVou83tNps8Dd2ZSa/CWs9R4ZdtGK4=
X-Gm-Gg: ASbGnctCbLOPo/nTz+JkZmK74287dvqjKuR1hUupugrmUHtQAYzxbm7IhSI7V4Qs36T
	6/HSnrMgYkkt+Vl/WsAsM8XZPnezz/P/xYO2dkMNCFIrdCr06CCU0jX4fusd/7aTUOrWFVCbg3t
	WMmcCrECXkl47l+5LOR92ZTKtGpMbIv8WxbrIk78MVGVrKxCwHdAzqInC2W3oIUiUfw3pQSLXvh
	JzdCVD19r12MFL84+pYyuslKQO2MFiNRbWk9jzqEREzUr92QBy7246dBLXBiQNC4XnqgYj1Ybtc
	IKwxtlQcWMuiJXY03ya6iVNjzXF8H84=
X-Google-Smtp-Source: AGHT+IHMet/slV/sVRHbkbSGWWghuJnC++0pCmETj2WxsmX+/fk8W7s4g7KNnMtjYH7DDkOzwohlVQ==
X-Received: by 2002:a05:600c:4f84:b0:434:fec5:4ef5 with SMTP id 5b1f17b1804b1-43668643743mr497181795e9.14.1736193801273;
        Mon, 06 Jan 2025 12:03:21 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365c08afcbsm586765365e9.21.2025.01.06.12.03.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Alexander Graf <agraf@csgraf.de>,
	Paul Durrant <paul@xen.org>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-s390x@nongnu.org,
	Riku Voipio <riku.voipio@iki.fi>,
	Anthony PERARD <anthony@xenproject.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Edgar E . Iglesias" <edgar.iglesias@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	David Woodhouse <dwmw2@infradead.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>
Subject: [RFC PATCH 3/7] accel/tcg: Implement tcg_get_cpus_queue()
Date: Mon,  6 Jan 2025 21:02:54 +0100
Message-ID: <20250106200258.37008-4-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106200258.37008-1-philmd@linaro.org>
References: <20250106200258.37008-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use a specific vCPUs queue for our unique software accelerator.
Register the AccelOpsClass::get_cpus_queue() handler.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/tcg-accel-ops.h | 10 ++++++++++
 accel/tcg/tcg-accel-ops.c |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/accel/tcg/tcg-accel-ops.h b/accel/tcg/tcg-accel-ops.h
index 6feeb3f3e9b..7b1d6288742 100644
--- a/accel/tcg/tcg-accel-ops.h
+++ b/accel/tcg/tcg-accel-ops.h
@@ -13,10 +13,20 @@
 #define TCG_ACCEL_OPS_H
 
 #include "system/cpus.h"
+#include "hw/core/cpu.h"
 
 void tcg_cpu_destroy(CPUState *cpu);
 int tcg_cpu_exec(CPUState *cpu);
 void tcg_handle_interrupt(CPUState *cpu, int mask);
 void tcg_cpu_init_cflags(CPUState *cpu, bool parallel);
 
+#ifdef CONFIG_USER_ONLY
+#define tcg_cpus_queue cpus_queue
+#else
+/* Guard with qemu_cpu_list_lock */
+extern CPUTailQ tcg_cpus_queue;
+#endif
+
+#define CPU_FOREACH_TCG(cpu) QTAILQ_FOREACH_RCU(cpu, &tcg_cpus_queue, node)
+
 #endif /* TCG_ACCEL_OPS_H */
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 6e3f1fa92b2..1fb077f7b38 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -47,6 +47,13 @@
 
 /* common functionality among all TCG variants */
 
+CPUTailQ tcg_cpus_queue = QTAILQ_HEAD_INITIALIZER(tcg_cpus_queue);
+
+static CPUTailQ *tcg_get_cpus_queue(void)
+{
+    return &tcg_cpus_queue;
+}
+
 void tcg_cpu_init_cflags(CPUState *cpu, bool parallel)
 {
     uint32_t cflags;
@@ -199,6 +206,7 @@ static inline void tcg_remove_all_breakpoints(CPUState *cpu)
 
 static void tcg_accel_ops_init(AccelOpsClass *ops)
 {
+    ops->get_cpus_queue = tcg_get_cpus_queue;
     if (qemu_tcg_mttcg_enabled()) {
         ops->create_vcpu_thread = mttcg_start_vcpu_thread;
         ops->kick_vcpu_thread = mttcg_kick_vcpu_thread;
-- 
2.47.1


