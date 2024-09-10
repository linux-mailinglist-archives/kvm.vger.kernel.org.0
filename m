Return-Path: <kvm+bounces-26351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6ABB97457C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98D4F28BEE4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D173D1ABED2;
	Tue, 10 Sep 2024 22:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZzNV99pw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C02D1AB518
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006575; cv=none; b=CX7btZqpb4AJy7D5/ktMz+foxq0DRQiE4+bIeNlL1SVttka53LiV9UhIb4SfyUEDXMZqrqeIuhgWI/THO9VhyTR1xu2xa3Rr152azCVa++CeYwCQiX/gEnoPNFNYrv1LzoW+xK0093f2nuedmad8RWLm4TWsHWP3Y2VKDcrxwtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006575; c=relaxed/simple;
	bh=WVxhqW/nn5PajwY5XrDqoqMFLfwU8BPACvrNIjaN9C0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qonf+S2oSnJM4sKsw1iJbawayrBoFN67t5lgn/XPgNAnhQaOamaXZMgGjb6Bkh7SqwKjii4cbU3wZ9BnoaBLgq902IqViZJJg+RUjWWnTSOYKoxN5aLHAa7dhqOycbyZ6gyHGrsglKSPRmsO3Yh8bqJYjvUAQiuTyWTqTv4YilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZzNV99pw; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7179802b8fcso4380335b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006573; x=1726611373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CeSGQFthD+JPD1wVuC9PwgsK3RUFyGiI0SGu9xd9Ivo=;
        b=ZzNV99pwG8XqTIFy1henZPCUSDIvwywD4jA97Cafiln7e5W8s4oGU2X/6Sp1FKTLYV
         3V2hIgELY521YwTlOesSeX4noaA87yXq00QJBmh595B16yivDI8SxQZzoGz8USK+30qm
         /iSjrLKEiYkkrAxQYZ63WMRxOaTs36Enpi2OolbylNU2jmfAipavhntqpOfkN4D/vX5H
         T84f38oh7jEX4wH6LQSk0wwZgbCFbAcI2Phu3KxbQExxVg2VDsThiCtFEZ1M+v11suc2
         A0PVrhDRvUeLJr/ipRkNRCsH4+VXW6RaSYnLnEK97+kOF680XTaoBNSM0p+rXDvpjCTd
         0bWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006573; x=1726611373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CeSGQFthD+JPD1wVuC9PwgsK3RUFyGiI0SGu9xd9Ivo=;
        b=K9xtJSPAMmzyL35zqe/ltJJbTwg8cOAxemUjXB42SUVFruEd0duqcAFdUwh4Bwg5oM
         0LryhNB6UFKUlbEU8aOvTcI/aN201iZD8nrilW+pGCwpnLVTbLUZpVgwDVdt1vA0ghui
         PyMEtBwJa231ptgpjEzhBaPY02LjoJEg1k7kHpjE1mSnYyDVxUItpXXkH3h9tIkV+b8L
         XYFHbLJ/AJRaZUfsaFdjtNqajKLqj1q9JB2kA5rrCdhaF7sw86ra9KRUmvYjWigyD+G9
         23Y7+DoKneEE0LcKtToK/Ct3gtlh4Tplc8MJ+rjRy8m4fw6uY+1wCwOS8h8s4BG2hiKB
         Q+MA==
X-Forwarded-Encrypted: i=1; AJvYcCXhr4EQ1XcyZwdSI45egkIwT95Ov3SdwgBFhO3NcOxRUuAmsgufwG+WNXp9eFNRL1MfeKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgVf2u7UMlpXiHetAMze0wdEH95Zqmnuvaae0fzM/0Xrc5d3M1
	F1hA4xGCssHj1HAiFPxCz61GAShwTyRH/RRg7IOj/TTwc8Ct0ixNSjltXW/FwwY=
X-Google-Smtp-Source: AGHT+IE7453ZnoDagMTvxw086SwFz1gaHnvHw1jrau87eetjbI39fjMwGBgCRYADVfAcbJ/ECITkzQ==
X-Received: by 2002:a05:6a20:c703:b0:1cf:590f:ddbc with SMTP id adf61e73a8af0-1cf5e0b7845mr3064462637.18.1726006572754;
        Tue, 10 Sep 2024 15:16:12 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:12 -0700 (PDT)
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
Subject: [PATCH 01/39] docs/spin: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:28 -0700
Message-Id: <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
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


