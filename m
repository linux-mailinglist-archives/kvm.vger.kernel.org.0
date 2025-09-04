Return-Path: <kvm+bounces-56784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABBCCB43534
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 130971882DF3
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4BA2D1F7B;
	Thu,  4 Sep 2025 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KAeavJqp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8E52D12ED
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973518; cv=none; b=glrSEyQ754MOaAMq1McGMhc2xXY/SmpEhabiG+joYEzOC4EIT/ZMIDa9Wrgm8t7H4uifXB01rbgPKy2RnrEtQWu3tIBgMNysktg7nelhI6ynDZCbvVLR7q7Zg/B2ib9aPTUT0rJx7c3pFiBlpecb7xTCJopJtdRtsUFD5Zw2ySI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973518; c=relaxed/simple;
	bh=Qm+nKayGtipuaRlw7oPzYnxjuZME3YPcTOffdEwhJD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lh2jC5YvCEmV34KZWYcMJxxnK+rB9sXF49TvcwzFThV+sc7BkRSujnDtVuuHcAQxh0LovB4sl+fLSN/2mBEprdFZ6YTcE/fBRW/we9CliFltMp5riKMSuHuYz1yzHRc6E4d4uyZBxpeLXv1EpVI64EEw6JwOT9L0MD93KjAyiyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KAeavJqp; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61ce4c32a36so1285773a12.3
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973515; x=1757578315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKf3LX74QuDicrn7aIOxjy5IHw4dOUBMKNzlJ8lYJDM=;
        b=KAeavJqpCjbiAH74z0Q6JHV2SNhuiZbmJldEgyIPXuPQ1XlIFdMuxkqTf7g2u6acZl
         EVQb9G6XnPLVkPW8BA9UeW+neCJY2PcUeUnBsSeC2NFNK32q9xsFSfYDAETEkIf93192
         CYPuxiCaRAKFx9gpBNn5PKy/+SN22yUtJrP8O4TrcjXLHz5Z6gCWRBCn50H31jjL9TyD
         qDXwKeBh/X9CkXSNeRg1TvM6qv0zwiSpnAsUXHg1L5RuzN0EKTuBZq17+nx/9YOt+P7d
         10U99MvNfHciDTTCdKDRqCj6dVJTkSjk+yWNAbf0xMO4/ZsKaJORV77njr/+1Lks6W9P
         tNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973515; x=1757578315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KKf3LX74QuDicrn7aIOxjy5IHw4dOUBMKNzlJ8lYJDM=;
        b=mtNNBqnBw8NNuuS/KQ3qmlo1gQyCrsl0AUigy/uJdQM4f5uqln6orEP68S7xtjHAtD
         X2Uld6b4cs6YYsk76bkSNX494gUV4syxlpNV0cjmX+EXigINv1pTf5AiIni0zklHswRT
         YPe2MawX0J4JVasP0kYVeRzlwb4xV/6ND39dGc/k4WLacMz4/XX59n8NgT8PaeWXwKfm
         7BLZHxXegr8RojFJqTm9XLoB8dtP1UYmNR3kbA7upP5kK7oLfwHWZ+dpnCpJC3T+gZV2
         PhkU0bOe16MbWMJPMDnW2R9+6lvF8Gs5RAqMYyNh8aX7SCYWePLmZ+VupNDZZUnIHMmP
         mb/A==
X-Forwarded-Encrypted: i=1; AJvYcCWX63rpyjJI8Y0Gduwx2gpOMXo6ex3nsSMJjTf2DZHC030kqSB4yustfkqKPOIWChv9xhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG0h148LH2qVoRh+th8eZHCS8GwvbWDhVDgOD4/3t4gIazvHl/
	Ha9Fzq90KprodcIb2BBtu9vVs/vRABqh7aMXvydy/1X28TtNqZSHH7MkwnmkmuIbCAw=
X-Gm-Gg: ASbGnctjBVHAnoxf4kaZkzULDv97O3ryGNsWpSsU8Z+M2eibcPSFnxoe3D037L8A6OO
	DuDqyLKeKAL2mqNInvmHYlOANqrMklEC2OyyTpbzoaoGBdQ/z7OTzREQ7wgDLOV461x36xYgQbe
	4tysesi6pQr6xyeTh91m9OcfV8LHw7oL5NNr80ASqf+gQa9pzRFoIQuJDgsc1FLS+BmV15GduSk
	e4CCU00IMYxM/S4WuRdYSuJsk+th1kIIgpnyjYHzMsHcJpDdkah54eYBLDNB8KHrGVMguXIh5JH
	uzLCR4CU327irMCtaw/Nz2P8k2ILZTKdUBCG/DIJnXN9IQ+39NzbdqQ9UjLHLKdfPH5fLobKZ6P
	bFAm8n5jwVlOQsg23njbDMj6PEIOcUUjYiA==
X-Google-Smtp-Source: AGHT+IGx8ZJxjps5cff/PZm9JBRuTzbh2ffGQw/tl1lRzj/lZpIUq6TJ0w2xsdrM6qRT2xpIi5PODA==
X-Received: by 2002:a05:6402:1e8c:b0:620:894c:656c with SMTP id 4fb4d7f45d1cf-620894c7c6fmr30028a12.29.1756973515184;
        Thu, 04 Sep 2025 01:11:55 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc5622f0sm13427169a12.51.2025.09.04.01.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:49 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A1FB260193;
	Thu, 04 Sep 2025 09:11:33 +0100 (BST)
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
Subject: [PATCH v2 045/281] rust/qemu-api-macros: make derive(Object) friendly when missing parent
Date: Thu,  4 Sep 2025 09:07:19 +0100
Message-ID: <20250904081128.1942269-46-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Link: https://lore.kernel.org/r/20250826133132.4064478-5-marcandre.lureau@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 rust/qemu-api-macros/src/lib.rs | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/rust/qemu-api-macros/src/lib.rs b/rust/qemu-api-macros/src/lib.rs
index b525d89c09e..a6147418891 100644
--- a/rust/qemu-api-macros/src/lib.rs
+++ b/rust/qemu-api-macros/src/lib.rs
@@ -85,7 +85,15 @@ fn derive_object_or_error(input: DeriveInput) -> Result<proc_macro2::TokenStream
     is_c_repr(&input, "#[derive(Object)]")?;
 
     let name = &input.ident;
-    let parent = &get_fields(&input, "#[derive(Object)]")?[0].ident;
+    let parent = &get_fields(&input, "#[derive(Object)]")?
+        .get(0)
+        .ok_or_else(|| {
+            Error::new(
+                input.ident.span(),
+                "#[derive(Object)] requires a parent field",
+            )
+        })?
+        .ident;
 
     Ok(quote! {
         ::qemu_api::assert_field_type!(#name, #parent,
-- 
2.47.2


