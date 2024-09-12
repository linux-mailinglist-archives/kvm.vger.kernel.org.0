Return-Path: <kvm+bounces-26619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C03B29762E3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E683B21A3D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFAB7186E58;
	Thu, 12 Sep 2024 07:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jUXLxxsd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BCD18FDDB
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126776; cv=none; b=gheEtXY59gjvs9pf9D7zz8n7YRB2u/++z38ElcuU5H+HfGbXMgKrYH5jOQyjmcdgSv9h0+zyh7GCel79AGycZIXuPWhndprkbn4lcVPhUupcSmW7TBFrcL089DI9rFoBFClGYOuU3BG/fU8pNQvEDERAWurU3e8ck8LCSrO7hi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126776; c=relaxed/simple;
	bh=Sj7coItM62qUP6D+eQq9J9uYeGn03mxADiz4qcIcsrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BOTLwGqQstYVLvNR0sjaf5t6KSuDqsIHLaUl5MZKwsWIrKc1bTjoiJoySnb+oDX9h3833mgeUzBGvSDWI1451nV/ivJpFSUBhB0KdNvweE7RQ9hT0JknxWhYdx4x7d1r6GX8irIUo1wftonQXV76RG94mbHeb2TJj4oa5wOzwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jUXLxxsd; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-717934728adso468118b3a.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126774; x=1726731574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ty7Rs9QHnECV8EUUJMzVINdjzR9zKkzYj9QmIBEPQw=;
        b=jUXLxxsdNPL8wJzpUGQLs6kZjyPMWkOu9rkYyEc7jN55Ovixt8Nkan971T26Mn9yCg
         MHm0xpRCrBTNQroGw4kSnt+1LYyR72h/MOGDem+Yf7e4k2Ht6H4PemY2PIwyj1lsyLpg
         DvoAiL3BZ/0agtCV/bAtQlLWvLkDS8xGkm2PO+/gM6BPjEPDL272Ub9SJ0XzxvuwscBw
         UKvAsfw4BBAnwGBcPIFFyhf3N3o2jG2pyFP907WeCsAML47lOSMPGOrRZ/QrnJv3P2XH
         muLGyPY7FgkjA1suAoDEetqvL18X/0+h9W9iafQgBwkqNEDqJ+eDMX9ueNmCwAPkxnNp
         yvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126774; x=1726731574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ty7Rs9QHnECV8EUUJMzVINdjzR9zKkzYj9QmIBEPQw=;
        b=Enq5xnPaXB8Z3ui+nxsRQ1gZI2655V+m57gRww44w2RurfEOJjpFNjdkvU5g0jnnXN
         pyiKx6sPi3i/5rmzcksM2qOXhnVKftX+wNpS1ia/keGH568y8z91bo2KR/jBfk8IpjiU
         HmdroCAIWnFV5bIFCbokLgdoO5Yapb9vOwcA6ZvZ2f228QhGs0Fs4nshh1uTBZJVC8k3
         /tOToOvSBEJTTB0Z9e2kU9514lgjKLNfYvNHGSqPKpPGe6FQDebNfMpt2J5DqeIuC9K2
         Db2dBROnV1IN4Czk6cjCylSKPL99T+DChVRc3OHuJnqHVUilIWgnmRQunYpHt/ZRMqPl
         YXeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXfOxY/xWorAw/eAvp/ho98w4UNZU/wH4fRf6QS39OBRyLtbF66l+Wu/gB15opF1oiXvE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5pWoCIF6LZYvLIYCVNwDN4gpp6a5JqTr0GdnxlU5Z1xgOWpSk
	RqyrqlxcVl+DKMs6rQidPG9neK5Kbni+sJ4YSZFAHZ3Vhl8q1AcqScw48kgAcLA=
X-Google-Smtp-Source: AGHT+IGdy27o3NWIMJUV1QTbS6arySwH8o8Z7I8EmJsXVX+I+rG8YMWPvIhqlvjs8uvVetmJE6ek9A==
X-Received: by 2002:a05:6a00:1a86:b0:717:839c:6838 with SMTP id d2e1a72fcca58-71926095e9bmr2094282b3a.14.1726126773886;
        Thu, 12 Sep 2024 00:39:33 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:33 -0700 (PDT)
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
Subject: [PATCH v2 03/48] hw/arm: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:36 -0700
Message-Id: <20240912073921.453203-4-pierrick.bouvier@linaro.org>
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
 hw/arm/highbank.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/highbank.c b/hw/arm/highbank.c
index c71b1a8db32..72c4cbff39d 100644
--- a/hw/arm/highbank.c
+++ b/hw/arm/highbank.c
@@ -199,7 +199,7 @@ static void calxeda_init(MachineState *machine, enum cxmachines machine_id)
         machine->cpu_type = ARM_CPU_TYPE_NAME("cortex-a15");
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 
     for (n = 0; n < smp_cpus; n++) {
-- 
2.39.2


