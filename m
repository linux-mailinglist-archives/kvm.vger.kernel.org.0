Return-Path: <kvm+bounces-26359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE09397458D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02F6E1C211A4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087451AE049;
	Tue, 10 Sep 2024 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zc9x6teH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE961AD9CB
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006594; cv=none; b=l8jRBlKmgfxzRPp2b9P5yAGVcxyXxzbAaKUGM8Sgrk3NWlqN9Ja1H+bnrhACKcBQMVTAALN0EpPw4OtBtZSp3r+CCj6zYYO3wiSxzDCxgELnEIXABpmkEDiu/vLEzpI+2GX0AkAByJFipcnCZS/DIxbRJnlZQCYsQfClbNZf044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006594; c=relaxed/simple;
	bh=qMFk2adhkTggouNUpDnZWkQKvWmYLwBxzhoxE/RqVzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CqrA9O5Pg+m22D7Y/gWv64mGRMg/zKo2Tyu8rE0QOr5EZluaeO5iy4e7gOZzs8O4H1YuxyiOGVn6rKepMIstmhYFWSuumgeMZQX/i+zr6wba3wKk8lqE/kKv10YnQy8LPDDfTenuJ4ZZG2MHVOJEm4fx4kzRQm5LHVf9H5kTso0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zc9x6teH; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-718d91eef2eso193002b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006592; x=1726611392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5hvV7fm4k2lFXirrgZp/rTlQTvUf+N/hoDJJrlREps=;
        b=Zc9x6teH+cc32v+L2jzu7bgy5waRFHiXZErrGSGDS8DqJ8bWzDLw3ah6CxUgZcevuq
         C4zDWh72jJB4vi2p1qEwbOW2mXEKjwIOtmEQzISoKhnoTEndnNlRL2oP0PnywY3d3+WG
         fU9JSV9yGoF57wFJssm9xNhDf2yZps38hvjOlkUFIDUPLAQwGaoKmcBxVJF73ie6u15I
         9/H3z1v4l/iinV/pjqqJu9AtD3ru4FnozAxvOoFopGWB/EFtyEwUwhKObS6+4oYbt4xC
         sO3c0Lo4x77PC33JZn4jM2YewGDmWV9JkF5CqDQnQ+gqPnSQIVL9A9R6eA5Hn4ZNd6xh
         qxkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006592; x=1726611392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5hvV7fm4k2lFXirrgZp/rTlQTvUf+N/hoDJJrlREps=;
        b=TA+EWCaouCVpq7UmaufRdYNhEGERxzgwWieQgytIG+5ZjJaAIsmxNfFoKxOYxMKm0c
         LWZXMjdROge++0TyvbgfEFSaOjd86/KjnYbmATfRBeJ/8pqgy20qmKDAj4XVjsJFqBxt
         Q4V652AKFAtBtN2nDmrRodA3tGy4PR/29WKtSawgmC9fotxeJvFgaQTB8kckdifxI8BA
         5SbpiU5iqKg/jmj5bCv1oKjXfMJqabocDjFcyqxNsCNKuKFAlMoJo9tbmelKEcffeT9N
         b/SSiqyANUI4Q8s3dvslf6uX5/Ea7zzlAxqENFyQbnRmlI5fLAP0MLd7XqBK0TsPTool
         3VAw==
X-Forwarded-Encrypted: i=1; AJvYcCX+ryoZKEGT/zyBYZa/qV5bX8Ke8IXTWN9vf4zQxSoYPOe3zaWrOdJtHJsR401obHlSICE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx920Co2cmzdyevo7UtJPPIgVZPfhsWpXx49zVH/U54+E89eW9l
	l32hdphNtk6bc3KbGDLl9Wm7+d84uKiYljFkvLxOFfkrVxbTwgGYOnTT9uWUns0=
X-Google-Smtp-Source: AGHT+IHrtwn2gYefVYx/2/5eCHyu9r4kicYal1I+8TgQBE4ci3czTkRyYRsTQrsB0YAMlykwKK3uTQ==
X-Received: by 2002:a05:6a00:2d28:b0:704:151d:dcce with SMTP id d2e1a72fcca58-71907eb69b2mr7001325b3a.5.1726006591899;
        Tue, 10 Sep 2024 15:16:31 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:31 -0700 (PDT)
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
Subject: [PATCH 09/39] qobject: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:36 -0700
Message-Id: <20240910221606.1817478-10-pierrick.bouvier@linaro.org>
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
 qobject/qlit.c | 2 +-
 qobject/qnum.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/qobject/qlit.c b/qobject/qlit.c
index be8332136c2..a62865b6423 100644
--- a/qobject/qlit.c
+++ b/qobject/qlit.c
@@ -118,7 +118,7 @@ QObject *qobject_from_qlit(const QLitObject *qlit)
     case QTYPE_QBOOL:
         return QOBJECT(qbool_from_bool(qlit->value.qbool));
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 
     return NULL;
diff --git a/qobject/qnum.c b/qobject/qnum.c
index 2bbeaedc7b4..2138b563a9f 100644
--- a/qobject/qnum.c
+++ b/qobject/qnum.c
@@ -85,7 +85,7 @@ bool qnum_get_try_int(const QNum *qn, int64_t *val)
         return false;
     }
 
-    assert(0);
+    g_assert_not_reached();
     return false;
 }
 
@@ -123,7 +123,7 @@ bool qnum_get_try_uint(const QNum *qn, uint64_t *val)
         return false;
     }
 
-    assert(0);
+    g_assert_not_reached();
     return false;
 }
 
@@ -156,7 +156,7 @@ double qnum_get_double(QNum *qn)
         return qn->u.dbl;
     }
 
-    assert(0);
+    g_assert_not_reached();
     return 0.0;
 }
 
@@ -172,7 +172,7 @@ char *qnum_to_string(QNum *qn)
         return g_strdup_printf("%.17g", qn->u.dbl);
     }
 
-    assert(0);
+    g_assert_not_reached();
     return NULL;
 }
 
-- 
2.39.2


