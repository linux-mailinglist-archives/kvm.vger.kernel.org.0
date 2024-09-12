Return-Path: <kvm+bounces-26616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 507F19762DE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750C71C22A2D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D7018C90C;
	Thu, 12 Sep 2024 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oqoOuVtz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46C146A6F
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126771; cv=none; b=D2P6zCB/1+guZFbHhe0/+SpK47ZNmbMWqjUvY/4PKqv+FHeKaAxnw7Yrhzsz053k/7EgzxmNBcy5atGHiQaUSQ9S84eEbbJi83oHmQsB8y6WIzz9EsJXpXDGwzqAr5UFyqZaAtyPkYScthjWRPRT+p1rjvwdkfYAoH9x6R5dwf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126771; c=relaxed/simple;
	bh=Ob7QVp9Q2nCpn5MMIeG9ms6CuNJdyiFbdx04hmjn9M8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=micuSh8ErJ7P785GiZpLUHftl980sO3AM9mYhoYDQ4UgT4aA2qEWZt3TGkBdrf2JcvWu0eMqGLbxeyL4W4CEVvyTEAc2TYtcNkJQVPzQNQQZNaiNBEYsMO7msr/usLLELcxPhqwXWlNyDqt2RgHlgARvHmIG+MgxdFm75AOXYKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oqoOuVtz; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7db1f13b14aso632271a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126769; x=1726731569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRV8cs5vGajAoqqaVP2CMnCi0idLbKzQEkk2XTwPdlU=;
        b=oqoOuVtzdBlQBc4TchpZo/xqhsA7GvbfXbCMPypE9KyHdg3yxYvqUXO4NsLgdnjusX
         6qElGP64ZoTZoYjuJgv9Ds1rcFBcGpkKebL+YX97zNtOHTA3xzA/aauG7KM/LW0xxIxj
         psOj0aT2S//p3uSgCe7fGFfP8f9GsfhzFH2ev/zNlWVxaGyK255rcjSnQOJEyBymMt+D
         qR+xOFvmKzGKob37h9cDRfL5U1v+UKhay8AlytOaKy68hwu5cITpGfvjHoQ5qEhMUlfJ
         hh0lHMYrgIdxpzCgis/Sy2tNXpt6akq8H/5rBXxKdwsaDTNZzuT322SlwtzJCQaFJS3D
         VEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126769; x=1726731569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRV8cs5vGajAoqqaVP2CMnCi0idLbKzQEkk2XTwPdlU=;
        b=PN06RNfDVvUZAEC2RUZ28snmEMEzvjMGHHCTwd0abbWx1kVzUqKPCcgpKToo9R60rl
         tR1y40jEmoC/rMNozPMlIeES99F0NFhkCHGMsq8fzM0YUjkIaXev3wfDjV7hUI9aI0Ub
         RliPQ8+5dfvU8nH//vgcgsq5mx8LqJAM4uPXxENSX8c/GJos6Tvwl0iQy6Lrl/fxclSj
         LKc3N4oOV6Osh7EYjW+Ll7cppnmo2kwVYlZURc6mBDhtX+uwxaF6F0VFWGCvDOWoDoL3
         mzlli2U/B4SNkGqD1kCJ14bSYspqWIJSNf66ubiGwMvcxKqmlXgjGr8f5IDTxXVZX2Gk
         GeKA==
X-Forwarded-Encrypted: i=1; AJvYcCUHAEaD9FeedgMLn1z15TlJlUn7hwTOcGXOsvOpoUeIWiR6FJX7xisT6FenwvzU8eCOkgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuKXGtaf9ned6bP0KWW8Px2vy18ZpUuJQsGrQJJDN2GZ9bBvAS
	wxx3BaOMrYXR/nqcSQwQidR74HKd93yduNVvEJbHUj1hJBR50FPsPuATQDjQNcA=
X-Google-Smtp-Source: AGHT+IELQJ4LN1eiiJh78GYcEX/xms21hXHkteEXLmVpd/6Wpu6TPg6l8or6duVIN2euH8mSyIIX7A==
X-Received: by 2002:a05:6a21:10a:b0:1cf:434d:609 with SMTP id adf61e73a8af0-1cf75ec46b4mr3157664637.6.1726126768552;
        Thu, 12 Sep 2024 00:39:28 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:28 -0700 (PDT)
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
Subject: [PATCH v2 01/48] docs/spin: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:34 -0700
Message-Id: <20240912073921.453203-2-pierrick.bouvier@linaro.org>
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
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 docs/spin/aio_notify_accept.promela | 6 +++---
 docs/spin/aio_notify_bug.promela    | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/docs/spin/aio_notify_accept.promela b/docs/spin/aio_notify_accept.promela
index 9cef2c955dd..f929d303281 100644
--- a/docs/spin/aio_notify_accept.promela
+++ b/docs/spin/aio_notify_accept.promela
@@ -118,7 +118,7 @@ accept_if_req_not_eventually_false:
     if
         :: req -> goto accept_if_req_not_eventually_false;
     fi;
-    assert(0);
+    g_assert_not_reached();
 }
 
 #else
@@ -141,12 +141,12 @@ accept_if_event_not_eventually_true:
         :: !event && notifier_done  -> do :: true -> skip; od;
         :: !event && !notifier_done -> goto accept_if_event_not_eventually_true;
     fi;
-    assert(0);
+    g_assert_not_reached();
 
 accept_if_event_not_eventually_false:
     if
         :: event     -> goto accept_if_event_not_eventually_false;
     fi;
-    assert(0);
+    g_assert_not_reached();
 }
 #endif
diff --git a/docs/spin/aio_notify_bug.promela b/docs/spin/aio_notify_bug.promela
index b3bfca1ca4f..ce6f5177ed5 100644
--- a/docs/spin/aio_notify_bug.promela
+++ b/docs/spin/aio_notify_bug.promela
@@ -106,7 +106,7 @@ accept_if_req_not_eventually_false:
     if
         :: req -> goto accept_if_req_not_eventually_false;
     fi;
-    assert(0);
+    g_assert_not_reached();
 }
 
 #else
@@ -129,12 +129,12 @@ accept_if_event_not_eventually_true:
         :: !event && notifier_done  -> do :: true -> skip; od;
         :: !event && !notifier_done -> goto accept_if_event_not_eventually_true;
     fi;
-    assert(0);
+    g_assert_not_reached();
 
 accept_if_event_not_eventually_false:
     if
         :: event     -> goto accept_if_event_not_eventually_false;
     fi;
-    assert(0);
+    g_assert_not_reached();
 }
 #endif
-- 
2.39.2


