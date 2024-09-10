Return-Path: <kvm+bounces-26363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96956974593
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8FB7B24A48
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAC41AC44D;
	Tue, 10 Sep 2024 22:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KpXQyR9G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0E01AE871
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006603; cv=none; b=qbN9eqQ+0fYeyfWN63j/3QIRQoeTL6HHAYSk3y6r045OvOvAy68mxWbjHDw84RGsBlBYyr1mpajwpMtjinCOXAbTPyTsX2SW9/9VtqPOh2hlrT4amEAQzxWS6bSaV965SB/Mwh+a3Mtpfq2QUm64GgZawzAVstY75+PW/lEXZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006603; c=relaxed/simple;
	bh=92BhXZRoeGkzfqg5qeTFXvYRSY4g14ftt70be96+95o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hUdHE/kTX8HnQfm7bMJENot9kn/TZxzaQZ1hylq9n+ZOh7+921TGXXSqG+4VLruGgyozeehizDSsj9TG1C6OUiWM7RYEKTw8Gwf6U3Al6e45qvql0O5/gPe5/HHKyixQxdyNan5PWc/y44SUa3ZnAbx9f1xPnNsDcA5GqWSY9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KpXQyR9G; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71798a15ce5so220954b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006601; x=1726611401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tK8yXM1iDeE54P3xeT7FLI43fZ41GyYVDWl++WFS7uI=;
        b=KpXQyR9GLFQs66jxu6/kvO695S+IO3DJR4MzBvi8ZW1Ytt6GmSxOtfxsCjXtPONmQA
         MCQm4Mag60dNHzJN4y0RcoL/GU9BIpsVhMQ1Du31B08pc0qerWQwq21Sx53RBnm5I6ws
         14f440gh47qnHi7d/SDxj1tI6iZt+J9OsUteONrxWUDQx1zQb92LqCbt17DE5jizwa1y
         yfh2j6e/+ZDrMxMkjrRa2Sry7baDw8XiJxwH/zkOgDlAU14omVpTTtWDVFmgs0SK/1hO
         44JgxmALjoo4g4RiNUBo8V0D6gD3vYWgyey0cD2MU87OawKdbkDTZ2T+UXajNboCsCty
         A8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006601; x=1726611401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tK8yXM1iDeE54P3xeT7FLI43fZ41GyYVDWl++WFS7uI=;
        b=OmcxmX9ySY3VopJeUdCDGKBWDRzhhoI50JuHNkKt84bSMyCY+mWpaCLsDGZLO73YS4
         DnLBD2b+021nYpeiRGsLBEeirs4HijRoTVYvQx7qflM5XRppuTJ3sk03LB0bk+nAc+e6
         vG6dQ7hlC6V7DOaqJ8esM/mEmOt8GsRVjeD4mcwqsEGWYDO1xvhjllSGjN6d1hAPTq3K
         oqMAMX7VU44oxpBRHwqGul04uMQOQZNMCCqK0ze/Q4VYN1xx6hbMbMkEzn4nMzjm11Sb
         +LjFbInPQ8dWb1qj2Y1jqOjEFD0Yx0RllHkJxzGKwG6gJtEqlf08Ptzo4c7E5peStfGO
         iUFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsu9x4IiaABDFhWHKnnFBKPsPcey85DFxnkx40dPPIuCIhTSh4TtUnStcI2EavY/ZHq6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiektiLT2nAAHm2vU+nZJrPPev2XZbN6gjIxAeY6tXC4y1aFzi
	M13O1YYb/8Tonj+WHiqERRjtlm9Yg+idQe9nsdVfLS1ondG/YxtlUgRAmiyDCLA=
X-Google-Smtp-Source: AGHT+IHBeJSCPLVgyC868IAgFwwRmLEKo/giNhof2aXBBMvErXgNAwTCgjauJtLdTsaN9WD8c9bHhg==
X-Received: by 2002:a05:6a21:398d:b0:1cf:3816:d104 with SMTP id adf61e73a8af0-1cf5e3cf5d6mr4003930637.3.1726006600863;
        Tue, 10 Sep 2024 15:16:40 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:40 -0700 (PDT)
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
Subject: [PATCH 13/39] tests/unit: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:40 -0700
Message-Id: <20240910221606.1817478-14-pierrick.bouvier@linaro.org>
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


