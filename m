Return-Path: <kvm+bounces-26627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0250D9762EC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34E1B1C22E45
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E3B51922F7;
	Thu, 12 Sep 2024 07:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VFMqX8sz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B261922E3
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126797; cv=none; b=IzjqKDFOKeRbRX5ACJFeZnrv6ZnwVwhfHuPfifb5CWnE319INgBJAhHYlOKvvE2pHQ7wER2Of2iFgmgyKElMXXLdfdP0dD1ypl91rBXXYXPHafiuEAyAhEdbrsqK1Dvse0ekFBUkW9S0RdaBNuhfHzf8efV+qmvNLfFc4BG3xqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126797; c=relaxed/simple;
	bh=pj3bjl3Vf5F9ih6rboeaqBqp2b5Xf0xp4CoCS2JVczo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CRJoiXKTZlcjZj/zACyKaNs6x7eo5taBTvtUXi6ntpUTmDvv/vvd9oajN0m5eQKt1NEPKndKSnWR2IW7AvAf2kQcaLtn1qnBDkoGUH28OH4i/lkEn2tvBiYejSoXsObnZ6/WMiS26NCgrUsPA08PFmlyWnU3oNI2VZ7ooWkOuuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VFMqX8sz; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a043496fdeso2521505ab.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126795; x=1726731595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gl+JcJWeB9n4U9owGQI4EbvNVAnzvdcJPjSOFH/LTqM=;
        b=VFMqX8szMpbxOfvzQM7ClVOsJN8XTTvrzJZXxwn+8mRPYmzIoFUJjw2ErznswgfJZ5
         6Wm1X3k7VKLhRZxLaG//U2YYpOnqmnnJN8AKej2mRpQKgupl4OgOeC9ANAtc5ae3D1+F
         j0OuWE60MdsGB6EhCOidV4HiUjzLQyUYyHvriS8LwX2uKMiYMpxqSnMjI8f59F8fzarW
         CyI12CTD33KeENnFPIl/C2z4LLsrrJR/ZA7qKkODgF2cI0sBzujZBjx0fPKHQqiEJIFP
         +lurbUKGCiMbQufFAD8pQJmbIYrFb6G6doStIm4/3RZNGxc5WwJYHkOGcYzAeJS0Gsa2
         RTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126795; x=1726731595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gl+JcJWeB9n4U9owGQI4EbvNVAnzvdcJPjSOFH/LTqM=;
        b=aJ9i1/rAey8AfTaEc9V54nRY+OpZqbxoUtR49+Bg8qqQIDo/ZfYFBVLYuRn9MyMK4k
         5UZCHhhlorwHuxy3bKEUCf+1ldVjHF0zgNOtoIPcILXk2PrrtJHQjBYLm20e/Qkm7u4d
         yx+lVhp994MFb1iZjnT2iMjnq26RDaCUCVfZwh25HXYJxxOkGekD/KkayhbahtwLkcs/
         frCX2fLkH5RFXuE0A2spuTdwhUVDMYSjSNUzvS7dJ7R3Gw8z2HLniO5JeBMY/3EzDNCa
         dvPOtH17buKEVF0zq+qjwWGNPCuIa0W7Bd9Dfdg5RR8RDXC1KQ/s8OeMSrwYM7BmbbXz
         1I2g==
X-Forwarded-Encrypted: i=1; AJvYcCXw4BTT7INKB/07BiILU5+BxwOZgS+liDYQOnp/5ol2w4zUbd2uaCBftn45M0Dju7dFCNM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj4EOEat9BHrzR/cmhfZlw43MdGyjhD6tlI+/9IHtsjdjrVg6v
	UUPH7xViTffvp5EpxYP3aZ/yzu8mo/4A0dOEVJAdWGXnovWwVbcASApKcxQP68g=
X-Google-Smtp-Source: AGHT+IFc2U5w+P2/p0zo+AVbvStN+97kW37ZvG1bComHgG1CrEqJE1viLz5YY6RVesmsw9//+xNbnQ==
X-Received: by 2002:a05:6e02:1806:b0:3a0:1828:31d9 with SMTP id e9e14a558f8ab-3a0849736d4mr17121295ab.24.1726126795091;
        Thu, 12 Sep 2024 00:39:55 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:54 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 11/48] target/ppc: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:44 -0700
Message-Id: <20240912073921.453203-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/ppc/dfp_helper.c | 8 ++++----
 target/ppc/mmu_helper.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/ppc/dfp_helper.c b/target/ppc/dfp_helper.c
index 5967ea07a92..ecc3f793267 100644
--- a/target/ppc/dfp_helper.c
+++ b/target/ppc/dfp_helper.c
@@ -249,7 +249,7 @@ static void dfp_set_FPRF_from_FRT_with_context(struct PPC_DFP *dfp,
         fprf = 0x05;
         break;
     default:
-        assert(0); /* should never get here */
+        g_assert_not_reached();
     }
     dfp->env->fpscr &= ~FP_FPRF;
     dfp->env->fpscr |= (fprf << FPSCR_FPRF);
@@ -1243,7 +1243,7 @@ void helper_##op(CPUPPCState *env, ppc_fprp_t *t, ppc_fprp_t *b) \
         } else if (decNumberIsQNaN(&dfp.b)) {                  \
             vt.VsrD(1) = -2;                                   \
         } else {                                               \
-            assert(0);                                         \
+            g_assert_not_reached();                            \
         }                                                      \
         set_dfp64(t, &vt);                                     \
     } else {                                                   \
@@ -1252,7 +1252,7 @@ void helper_##op(CPUPPCState *env, ppc_fprp_t *t, ppc_fprp_t *b) \
         } else if ((size) == 128) {                            \
             vt.VsrD(1) = dfp.b.exponent + 6176;                \
         } else {                                               \
-            assert(0);                                         \
+            g_assert_not_reached();                            \
         }                                                      \
         set_dfp64(t, &vt);                                     \
     }                                                          \
@@ -1300,7 +1300,7 @@ void helper_##op(CPUPPCState *env, ppc_fprp_t *t, ppc_fprp_t *a,          \
         raw_inf = 0x1e000;                                                \
         bias = 6176;                                                      \
     } else {                                                              \
-        assert(0);                                                        \
+        g_assert_not_reached();                                           \
     }                                                                     \
                                                                           \
     if (unlikely((exp < 0) || (exp > max_exp))) {                         \
diff --git a/target/ppc/mmu_helper.c b/target/ppc/mmu_helper.c
index b0a0676beba..b167b37e0ab 100644
--- a/target/ppc/mmu_helper.c
+++ b/target/ppc/mmu_helper.c
@@ -316,7 +316,7 @@ void ppc_tlb_invalidate_one(CPUPPCState *env, target_ulong addr)
         break;
     default:
         /* Should never reach here with other MMU models */
-        assert(0);
+        g_assert_not_reached();
     }
 #else
     ppc_tlb_invalidate_all(env);
-- 
2.39.2


