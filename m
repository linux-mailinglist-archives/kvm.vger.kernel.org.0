Return-Path: <kvm+bounces-26743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9398976E74
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669031F2462E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F042C1420D0;
	Thu, 12 Sep 2024 16:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="viEUtg0C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB9413D8AC
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157529; cv=none; b=iYnjLxvvhaNqHOkBf4HULW+9HbUplX1w+zAX034O8oQ8G5uTJ9xg5ufEyzkTrUvaQ6DNMK/J0zGIRiKpTGSBM6DR5nu+FRuEqPh2LcRiMyfO5oikA/OJxy4KDVt9pQr1ygr56KERtJkrZBa3BJ9KT1gBsuAhMPZizO9AuUk3BcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157529; c=relaxed/simple;
	bh=NT0bzYtCC79RMKqpRvOxbXK6zhmx5cfv0BdXvkVUgVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=juPGu7yfv93cEJ/jSHao1i6lKRJNkiKaCznQjXB+4FMJJwiOi9iES/TSKyR51NgnBjcvyx3wIOq6CkoQvPxMp8GAbizJdwjoqCw0QuZlgVb7z+fy0gII0p03Q5iO7inNcMysqcrd6sHeVwaHUIWOmogvH2Y7sdjNkJNH1v1V0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=viEUtg0C; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d8a54f1250so826663a91.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726157527; x=1726762327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qewOobu1vObZbuzJ+iuWYysDqS1YnBarNPQM9eHAdiY=;
        b=viEUtg0CGfEfkkdMM9Dfpz/AWwZKGFxN793ieQ2xq/FaD+pqgYJsO0cDBi8UcorMe1
         cSm2yrspddxcn0YlDlaoXIGMXBNwAsGz4a0VWo8nu1lKizh47Yagxj25LKekHHjAeQ0r
         D2u4UvMU89BomNRGfNA+uvbmnmaCKzzxzU/Tpf8BkiujdCt3SHtWIy+F2nNMgSaKXz4L
         BFFqWIrEJBxPMiAmZ8+MggnFTTUQphbBdSNEoXs5FGE/94ZR27Wf/pmomuLnqTadGH5I
         umWHaoDVoiUCzjdtA/sQrn/sZFRBP866QEWA/Plz+U6lYnN6VC3UOuc6njC4tMu+zmjt
         zPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157527; x=1726762327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qewOobu1vObZbuzJ+iuWYysDqS1YnBarNPQM9eHAdiY=;
        b=ff4UmKMPbhdCCiqDH0+4SRmAeXgmmLk5PwfdDTR1wXh0Uea+4iY4UCt/v7rHVY/C6w
         7YMCnhnM8xxFuVycIT7n4tgoXCOL3F9iwN7QIIUu3NbEXLz6Yc5zutxxJ1qkpsh6tL6S
         Adwg3i7t5KRISx9pp2ZRqwAXTrhlSnrhYvNtImVdbDIjvHMPjUYXBAD3tQLympvcBGS3
         FmSVLuMp0lg1ZjOBdcekGxaRaZNbV05gfu2JRLVx0dZiVSiMzZ2KRPKNXkNpfialnd0M
         7PIn68Pj8IzaCEH1ReKdiJMG6xgzwDSN91WhMfpr+KxxmzrHwbkUA5dyDfWSDRS8m6SI
         q4kg==
X-Forwarded-Encrypted: i=1; AJvYcCW6IjGaiHEEr0VfaIp+LzpGgsiFs+TFpHRX44XSXsKZZTZFFuwkYXzMTEfhk4tLolQDOKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzFbdywbnT7YM/I2V1IBWNZ424DUvL9bUV81PQLF6+uRRPmIbh
	W7zwKfuy+abwF9Jk3S3rQJQuFSsc0TaKFDBoPbzZDbBpuk01M/ezxbLmj4PE2UY=
X-Google-Smtp-Source: AGHT+IGfJHrcD4FeIRzLtjG1yF8QBxXB5+wVdXyMPyemp6yKvRgw1X8BWW7xKjm04CE0VvSJxj+cTg==
X-Received: by 2002:a17:90a:2f64:b0:2d3:ce76:4af2 with SMTP id 98e67ed59e1d1-2db9ffee48amr3456585a91.18.1726157526967;
        Thu, 12 Sep 2024 09:12:06 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db0419aab4sm10868139a91.15.2024.09.12.09.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:12:06 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-s390x@nongnu.org,
	Michael Rolnik <mrolnik@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>,
	qemu-riscv@nongnu.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Fabiano Rosas <farosas@suse.de>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Rob Herring <robh@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Jesper Devantier <foss@defmacro.it>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Fam Zheng <fam@euphon.net>,
	Klaus Jensen <its@irrelevant.dk>,
	Keith Busch <kbusch@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-ppc@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	WANG Xuerui <git@xen0n.name>,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Corey Minyard <minyard@acm.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 45/48] qobject: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 09:11:47 -0700
Message-Id: <20240912161150.483515-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
References: <20240912161150.483515-1-pierrick.bouvier@linaro.org>
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
2.39.2


