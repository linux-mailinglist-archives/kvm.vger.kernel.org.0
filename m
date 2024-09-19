Return-Path: <kvm+bounces-27152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7A597C39F
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7082A1F21ADF
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4420139D1A;
	Thu, 19 Sep 2024 04:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NuRaeDW8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9047E25776
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721269; cv=none; b=SFkxeduX6H7rzWDhQ3TZRKC5bzh89Fah1xib1wywML7aFtTKGh18Ultv+PWTHaa21Fwnib1OeaWxwEkbxcLT9ZSnC9r4gLI8eVqbu+rfXqeXyV0qE4O1Yxjmp3PCmGaCM5QGrUFQUrwYn1H7fjEPur+IlFZ9L2DDBJFkWsyNBVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721269; c=relaxed/simple;
	bh=nrbaSR+EkYP6PuyDjsSDQ2S2g3Fhxr3AdAybeqnCY3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pOOOOGuMc1+dcyGCrXxdST+1rI8hYdXWQ7F2ZJsbTpYaR6qOSuKhxc1Wl1kTP6kqEnv6+FN8uI0lk6fNUMT5YibVPctzzHFDwhZivX1Dnt0o+yl4xmOAxZloHAFEl1Mut9pmiRXrgaI8uGA0xU48lpiDI2MoCiB38kR9/iBzhH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NuRaeDW8; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20570b42f24so5297605ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721268; x=1727326068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJWuRI2a+xcGlqE9ilLL21KPqsM5FE8vZBWYVBf4fqk=;
        b=NuRaeDW8sjP2EDzXIeLyQN0ud832IV/FAv78fZa8vRL2aY2xYqoYSWeqtHLNk4/PhX
         19BCcgegxcQtBY1LnaW+DA2ZBeboXJPVALY5mK7+ngzfROoNV2OErhfAhLG9whMHO4kw
         F1v/kqJ2FEZB19MOPPdQTOOD1z0HmxpX4/WMNvEQ39MQc0ykI+kECbvtGUfgDFpvkJYj
         pFJ6DNFHQ1Y7SCu0N1zKP+QgiDJZ3msP+htB5B1lQxEQAK/pcx1Nk2x+0IC3VR3WxBoY
         /0JcqRb66LnsMKIow7U+B6bAlcY2Cd/8Fc5WJoGVL8ldln5FsMnEUzar92P54pUv2T7i
         CriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721268; x=1727326068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lJWuRI2a+xcGlqE9ilLL21KPqsM5FE8vZBWYVBf4fqk=;
        b=U5yxJlpouYaOykfBYjk3FGayGX9j4fUj13fTJgPBEWvcEdzzNfz4oKzgJcVXkm2wVx
         3xqzC8drkojvDAP7uE5tBQw2+w2yUcmLBNh5Uq1k9RRp/KKM0hyIDgGKLwmKCF6EX0f0
         WaQ/mqPTkzFH9KHJVvAj5Ase5thTCgg7mRADG1+hMeddmJZxiGG9Qh2ND+UYZn0TUS1Q
         CKBL41cRUBUktfNft+ipQdM+f2setNbUuzX8ZhMzLv96NHPPdQ6QF5xcr5Ax4bHqO/TE
         2Ej1OwRxgvCJBVD/Q8JpJOur0Bs3ZS7qURr6gAfOWbKfjuWiFHgODWsnr31H2CiynP/o
         Rgpg==
X-Forwarded-Encrypted: i=1; AJvYcCXogQV43hA1AtQFHYeF4RS8GpD+5RdNSVYgDIacm2brCzgYZfFG/eC9Yn/z2O0McvdFYs8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFdOTnfWGvFuE2Hho1xD7oWUm1Ij2akhLsWJ+jWWPGFiousXse
	ujj+EMYFCKXNSLs+YgYg9zn95rmV0xH3fSla1kQYq6yvmHMNd3TPwauCSXNHcms=
X-Google-Smtp-Source: AGHT+IEWVDdbKcjFcT6g/UvYMSE83MFSMfB5S4IXaD3yJyhmupuCthkvU2aYKDc9W7+wO1/hWbEPng==
X-Received: by 2002:a05:6a21:3a81:b0:1d2:e8a5:689b with SMTP id adf61e73a8af0-1d2e8a569famr9583177637.14.1726721267939;
        Wed, 18 Sep 2024 21:47:47 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:47 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 31/34] qobject: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:38 -0700
Message-Id: <20240919044641.386068-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 qobject/qnum.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/qobject/qnum.c b/qobject/qnum.c
index 2138b563a9f..dd8ea495655 100644
--- a/qobject/qnum.c
+++ b/qobject/qnum.c
@@ -86,7 +86,6 @@ bool qnum_get_try_int(const QNum *qn, int64_t *val)
     }
 
     g_assert_not_reached();
-    return false;
 }
 
 /**
@@ -124,7 +123,6 @@ bool qnum_get_try_uint(const QNum *qn, uint64_t *val)
     }
 
     g_assert_not_reached();
-    return false;
 }
 
 /**
@@ -157,7 +155,6 @@ double qnum_get_double(QNum *qn)
     }
 
     g_assert_not_reached();
-    return 0.0;
 }
 
 char *qnum_to_string(QNum *qn)
@@ -173,7 +170,6 @@ char *qnum_to_string(QNum *qn)
     }
 
     g_assert_not_reached();
-    return NULL;
 }
 
 /**
-- 
2.39.5


