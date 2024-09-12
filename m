Return-Path: <kvm+bounces-26629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AAF9762F3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9A23B220B9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C17190063;
	Thu, 12 Sep 2024 07:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pm2CMFAb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4380E190047
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126802; cv=none; b=H0wwyd55WMdLvC13EKR4j66LFy2ggwsB9FZlI59mlq1Hd+KHKNiDykiehspmQYxyeE0D4WLvWzq1hMpzc6cXf9zPd0mrk+a3TYwsAjKRa3Y6v/5KH14unUY/P/V6mgtO/+1GixMM3NnfG5RwlVYZesqj3kDJ+ImSetM+KmtoDfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126802; c=relaxed/simple;
	bh=rGwr1vUCHvqHW+ILBB/ASnMP3I3a3rFp9bAatKHlp2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rRxVLlBIrd080utu6dO3EhPfzh2LMUgOXD4hmXkzpDlLK1Mb494tpYzURJrbItusC9Xy99wrZc5Yq4eHkh7x/C7an6gbxfG4VmNOgnnVH8GUrWPGmCDpwSIh8pBkUqUvcvPjm4nrURE2Pa/s1sSaOma2zht1JERIFUjWptyvsRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pm2CMFAb; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-70930972e19so185995a34.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126800; x=1726731600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+rVp3/BLJYyjxO33P6GwzzAqjbQ85NDH2br5JtXUaQ=;
        b=Pm2CMFAbgs9nRVC4e1o/NmmcButdVZgIoB/V2Zyvn57HrTvmgEVs9M6pDavNCJ0qjH
         BCSKdn0n0b4ZHlLM2ZQ2Q6XAvuKlhZpARBmh15yO0fea31OjlliOj6h6CsQLpzmM+Tn0
         RxnqE47ESAdPRcvVd5/hy3cD2jrknuH44A437+7CVQ3GmuSHQ0hA52ADP5sFEgoSSoCl
         9OpoWLlHpXEx/uCtlej9RtQIXED5AXSQyRC6oEnoxbcn9HTD0hKRis9Y+G90taTiZmZK
         P0bBgXhvytWaG3O6yM3W7/DyhxyRSS5Q2cox9HbTnjUHQJhP0asaV7Ex0YUjPkoueG8a
         lJ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126800; x=1726731600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+rVp3/BLJYyjxO33P6GwzzAqjbQ85NDH2br5JtXUaQ=;
        b=N+dUzA461DhwGsM5IqtmRSn+gJJZIgnCluUL7FVITtZv/jpFWs+Dmnf6NTuUX5m67S
         jT9B1Hm97+XoKZ/kTIYjx6s3b4+fpy+0M2YjYhqz8nVF37RarYwSjjs1obgBQDhF5GJH
         3Mp6P9fHEywO50AuRg+vP+H1lboR+vI6krsrKBner3mZ8s/puSiXGI9U+i0QW/P7RW8K
         vQe3Yxp955XiszrTPXFJJRM9+e5yYqoT1Cpy7AcnO0uCbWM7gjCkyVUOw8iUk0pK0MPz
         6fFk/eITqZjv6fnfLQsiMAXLEsglpW0tg59cqPsTCu4bvt6x1fnky1yOeXMi+2vUWCrj
         Xx5w==
X-Forwarded-Encrypted: i=1; AJvYcCXSN+3JfC2j++YdJTUxRre3hxmXSTgqNXuanQZ3HDuLWJLA4WXpQLP7Roz3d1dDtHt/PqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkXAaittE7YFOOeKrPNaW2MKMNp0UKeyrDbWlw5T1s7cdB8CBk
	VXo16H9ylg6dL2sXlb/8YvrzriQY9KU0/B0tLRFFFz9ojUWDgM+dNDPhMq2BXgs=
X-Google-Smtp-Source: AGHT+IG6+n9GSh9VOQuGu9AiTjxnE8dPu+UEy8HMFEQWjdljbFKlQEVbTyzIuHmcncyWJBtD1Vjx6g==
X-Received: by 2002:a05:6830:4994:b0:710:b19a:cea3 with SMTP id 46e09a7af769-711094727c0mr2302235a34.13.1726126800291;
        Thu, 12 Sep 2024 00:40:00 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:59 -0700 (PDT)
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
Subject: [PATCH v2 13/48] tests/unit: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:46 -0700
Message-Id: <20240912073921.453203-14-pierrick.bouvier@linaro.org>
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
 tests/unit/test-xs-node.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/unit/test-xs-node.c b/tests/unit/test-xs-node.c
index ac94e7ed6c2..2f447a73fb8 100644
--- a/tests/unit/test-xs-node.c
+++ b/tests/unit/test-xs-node.c
@@ -212,7 +212,7 @@ static void compare_tx(gpointer key, gpointer val, gpointer opaque)
         printf("Comparison failure in TX %u after serdes:\n", tx_id);
         dump_ref("Original", t1->root, 0);
         dump_ref("Deserialised", t2->root, 0);
-        g_assert(0);
+        g_assert_not_reached();
     }
     g_assert(t1->nr_nodes == t2->nr_nodes);
 }
@@ -257,7 +257,7 @@ static void check_serdes(XenstoreImplState *s)
         printf("Comparison failure in main tree after serdes:\n");
         dump_ref("Original", s->root, 0);
         dump_ref("Deserialised", s2->root, 0);
-        g_assert(0);
+        g_assert_not_reached();
     }
 
     nr_transactions1 = g_hash_table_size(s->transactions);
-- 
2.39.2


