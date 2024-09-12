Return-Path: <kvm+bounces-26625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D91829762EA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0942E1C213DE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F9C1922D5;
	Thu, 12 Sep 2024 07:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gvS1+ZuS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E22191F8E
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126792; cv=none; b=TB1ev1eVqkJHXokCpN+/SqOHSK8sDY70S7BWSjlq79XC+QH5BKqjFarZiupX0R4cLTHaThOF8Xh6FTRJ5jDYEhHjlDD3N5adaOBBOHSOY+OPe7bevMrXwEGm5eU0RlniIK953IQWUdNSRY6Eiw7sxe+fO4AYdEb4dHg+twiVsQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126792; c=relaxed/simple;
	bh=UYtppdslI+bYPL1y07sV7UHsm9O1TPNWp1iYCz1LPog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jejt1eJMIzrLMc4kogMCyIVfIU4pW/gr8fMfWWwv4NN2pejC7DIzToZlOnJulazNFNwy60yhbuZggBI3gMQbvxhz6uBpxaZ8BEAkfBdzoDF0cUatuI+3BECsko8BrVUrAQSvpUE2aWx+7DPorucV5p2L6ecC13iFFGicQZsz768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gvS1+ZuS; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-718da0821cbso489793b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126790; x=1726731590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoLCWKN35Kx1zze7qPnMX6nUM44hrew4lUqaYQU21Hw=;
        b=gvS1+ZuSFylJjMLDvztog/HBjlRpYNe6Z5RyL1F/p1iz7ohyqyb628tdHdK1zRhNPP
         fkG38Q6I0VS8LDgI88E64Zb0LB5PWvkuFRNk0YpV54xRU71uvhw85pK5dgqIbkNz5DN0
         WYUDyOyvpEuxtQhJWUjVY3Tyx6BQlXokrdGwViSUw5pajwm/fd5qe2Sa63wloqtwUFju
         NCzMT6nOYLVu9k8PGlym9tL/CpWw6kPCCU0vDbvX37MTltWTOqDqwZsak6Y5GqLCqaMq
         5JIlWxraJhyFt+7AE/puNXkynh9E4TDyusCELldXW5q2bx+CUG6/9sUI9xTQzQIFrxz9
         H6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126790; x=1726731590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoLCWKN35Kx1zze7qPnMX6nUM44hrew4lUqaYQU21Hw=;
        b=KUrJEwPgTR0T1rMG1lUPalWv1vG8rjd19wc5aUGBkONmrfKcrBecEME7nePpt+/BgP
         IgFB3rIyhArqdNNgqzI1uceQDq2MmI6jjphvB+bKIWEWDBH8ZkuZpNygaOvdDLuN4cnv
         LqlVfsk0mqehl/Lm0q669cA/WmRu3i5APcFgHdO7pvTo+jT5vV9rZJN1CsX5bM3T6sZu
         peeTW4Agvx3rcWD1/rq/7ThJnCTzlZcqD5AwAbB8fcPgwY16sDSlp6eCJTpTkcX6nz0W
         g6mekga2yjfwKVas9xeBWe78RFNy5biKXB/5CMfVFOsF84qwhEfT0eQ65CllgKP5Mn2q
         C01w==
X-Forwarded-Encrypted: i=1; AJvYcCUJJS8ihPavqZgOCKww6heRzg0BoDXKIcdS68L9ooZiHhX7Cp/tPBseMDI3u0c1aoRih2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy+DTUlftyu95qwlL15c724eWiP2KGgase8LUjx6JqieujPHrp
	8vQAbT5K8Apyg73QU00qJVZm+Bzn3+sY7llKYiE4Bjz4SdN/DAI9izBXoWIZYS8=
X-Google-Smtp-Source: AGHT+IE0w+LZngOafibQdFlnRgSn7EWh+CAdX4bvMvefU5tar1r2kJCPjwqFlGTA67eF851XZaN0PA==
X-Received: by 2002:aa7:8895:0:b0:718:da06:a4bf with SMTP id d2e1a72fcca58-71926067e21mr2772666b3a.2.1726126789771;
        Thu, 12 Sep 2024 00:39:49 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:49 -0700 (PDT)
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
Subject: [PATCH v2 09/48] qobject: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:42 -0700
Message-Id: <20240912073921.453203-10-pierrick.bouvier@linaro.org>
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
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
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


