Return-Path: <kvm+bounces-26383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D6A79745BB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E096D1F231EF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37A71AE84D;
	Tue, 10 Sep 2024 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EGSa8j0K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2001AE039
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006681; cv=none; b=VOjJyLM8R/b6yT471CVoALo7ts2vbe/6SsjHMd85L/0qDGG5JzYWcW4g8dkoNUx8/e04oRGtJwo1YpqF9mRZmaOjOmLPfrTBY9h19T5QGWNMv9r/7Gny4quQ+Ez/JYsY0fhdQ3kIcAWdXtmRAb1a/Cyedk7uvMgzhGBs08c4RZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006681; c=relaxed/simple;
	bh=AfRU5qLiYkUs/ycyWbnqZMzqmTE2MT/cxzy1Bf+/N7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hf81WwaXL7MlmC4cd7Os22C9uj813TeiwqnW8csDPtadiBQuPycjz/+fMM6i5r2bOmvAs5y73STsd4FvWiI8sh055U93DgkqtLlmXIJ1G42Y4+UBSVr+WvxiUzspbIXz6X8GvbXi4xz0+QPVzEKJLIlQLAzE650J7mwI31Bua9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EGSa8j0K; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-718d91eef2eso193776b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006679; x=1726611479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCyNLuF1LstqlhxKrvBEXR8Gg4TvMK5bWfzhaE1qWNA=;
        b=EGSa8j0KHAn2smdGUTlVTgKnmq29FFSHasercbKwkPBM0KX5muS8XqgFJluWC7Wvz1
         GhQ3bYfXlDGPlFcRwZ9g7R6AIBis25N3MDiUBkCXdfkiLcHrhFwfIuOvhnDtbGKPBTUZ
         j3MCHJvk6mtXTwHQ0/aOWzo12Xp6C/YSCQLP/mgAZwlts7BNuqRszJyvlKox2R561roN
         On+m4DL8xjwFC9W7AZkD4SAQdPJQVcNtqaZw4PLYaVGxedpi2NIxWzzOyUGHIdDHglH1
         1vHQz/BD+rO4fBFdm0N2ai6veethQtTW8/g10JPL2zO8CTMjtWNb2/R799sFQeGbJYJI
         1g6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006679; x=1726611479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCyNLuF1LstqlhxKrvBEXR8Gg4TvMK5bWfzhaE1qWNA=;
        b=M3I4znHahL7jEaP49QzoWeoWnjMucFbvy5Rs7AS7jPrAP1BO48nzRtEeIxf8SqjEMq
         F9HwgWpQmOIv3zvfhPYpNwfsj32Y/Ns1wMWzOSf75RCiQ5neZSXLxxvOOylo3wY3pkND
         M+l+0TkzT5Z+6gaBeUHr3jufp07YN/Wo9+ZII4UYaeExtGnbYA6FAwbqBk/n2Y2bD1Kh
         Pg+aEnCtpeLx+V+TvKXXymMFiYEQd8dBpGKLt/yjq4IgFr7gxNqklZrla6rNUqT2pZce
         NovM9DFczncJU1LT+NyXvHyghLnEyf08N1jenFRjvpgukrLnzRuLLLVzA6DnhG2X+N9x
         o25Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDhnKqOvebLCnR1QUgM+n+MZfIIxLF74509dBxnFGsRKE80z6Cb5K/mkJgQ/l8/JiehNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFdtG6pECJ47SQemF9aYWg2hzxvVLhJBT9ej3tj/RldKaR3ptN
	lMNLU1Hst8u8ZCYchU3k1KsnBLPYK++lHEo4pPzkwXMItDIY4ZBUrN/vfMDuGwo=
X-Google-Smtp-Source: AGHT+IFmGoBUAFx1KDM5UgKFB0SE/hPbgLc3THVYv58BQ1Gnmra8mNjSAuaAbG/yO+FnHS2rRbeS3A==
X-Received: by 2002:a05:6a00:3095:b0:718:d628:3d7c with SMTP id d2e1a72fcca58-71907f54f75mr6220196b3a.10.1726006678900;
        Tue, 10 Sep 2024 15:17:58 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 33/39] target/arm: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:16:00 -0700
Message-Id: <20240910221606.1817478-34-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/hyp_gdbstub.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/arm/hyp_gdbstub.c b/target/arm/hyp_gdbstub.c
index f120d55caab..1e861263b3d 100644
--- a/target/arm/hyp_gdbstub.c
+++ b/target/arm/hyp_gdbstub.c
@@ -158,7 +158,6 @@ int insert_hw_watchpoint(target_ulong addr, target_ulong len, int type)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
     if (len <= 8) {
         /* we align the address and set the bits in BAS */
-- 
2.39.2


