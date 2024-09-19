Return-Path: <kvm+bounces-27153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1CC97C3A1
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54B161C209B9
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A463D13A894;
	Thu, 19 Sep 2024 04:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pr6F6Ev9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A83288C3
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721271; cv=none; b=f0tQ/jsTjpNuCiOF0JuTPz5cbIw70WWRrczafelyMGPQpFy2FmSErwOTweZbnKI1L3ESr5AvyxnP/UVaiwMdNrB+oEPR4HVId6edFVDEny4/QJAyTeY1mZEMvXTdYO47zf4D0LxPv1qGmoBMNBygbBOum8LtyBP3hIfF+zHtQqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721271; c=relaxed/simple;
	bh=STQD/JrIwGSp5JQg9H5J6QkyWrzeOa7Cmx8S98scipM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YP8OD+KPD4ThShI5bLDGHUiOQfd3BRyYYJy6S76Ez5buiDPJP2fjsImQ02CAXwJ5diPpsFgDXf5j+md8r5UfAELenG5ruStEYfkl6ZdbGggrqH85iWbSjLZP1dNyo7n1nSjNr8b9FtuJBAl1gXoJvcpR6leK6HttSVnv2GkEHEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pr6F6Ev9; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7db12af2f31so333779a12.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721270; x=1727326070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsHCjwrGb9kFALwWqgq3B+HDSbUQOfqxzvxaIUK0xNk=;
        b=Pr6F6Ev96mffvxwJjqPA97yQFeBkGMNYNM+glz2KXc0LD893CX/KuD5xp++eh6kEFh
         8u73o5dL0HYuvLqfey+mSUiVqHStWNjYACX587pHOvBGlxscDB44QuiLVyK34XO5WuXp
         opN2oiU98mGg9aQyiwHe2Mtd6aG1mEvj5mJ4RnA5IvkREfzXzovtjzFs2uowgugBkzBf
         YwbfaVrtGAUqUfKGD9gHS0pBYfzzS35rOr2CeWQ3SN0xd78mrpwWVmnO3cgtzL3V7nph
         Hg8+RwOoDj9fsgyqK6kgXmOYxAC0u0CwwvKNP4J+T7BJ5Je5VLHBFg/5H9axBSI7BBYs
         R3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721270; x=1727326070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsHCjwrGb9kFALwWqgq3B+HDSbUQOfqxzvxaIUK0xNk=;
        b=WxFONZzwm0o9I+QsvjP97wBmBFZgt9jMQV7TIxooKK/729DL+/DchQgXs1mN2AYLNE
         jpp7llX/17rbtcZYyDGIP2ghxOJFHYhJkv1hOAXHa7NUWsjYFdHFerBRdGBQmqCygiFH
         tjlNG9p/KglPGb6yJEXJID7fDwptJd7d34HfB+/F8qPT5fXCLGxEqhkkdk6D1Vt4vlLr
         mXZZrBmrgvuds3nne1vKab5Jup1vkXQYJBaIDB53HeXH7sLdL+0Blzim8IWdVFbyKqpc
         SWis1kfiYNBQkSPugTSzCPDiXnM27uICXmB/SKspXNLZAK0Zcav7victy3b/yZ9cFTNr
         P4ww==
X-Forwarded-Encrypted: i=1; AJvYcCVWBi4Qiv7w5yh4WnwQsH3UXLMd2kYGs3OlAHZq7LOfeRg+YLvzM55z9XgjCz2svRhOnwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnmOX9fcLzFM1QSDV7bqcBpnHp/OlG0bUQFjTdK7Q9i/MZaS/8
	VVhOFVzqy7vf7WreHhyywKMjJC44k/UB4LoVvsXFml/wvvMcNAaNclMckgvbg0s=
X-Google-Smtp-Source: AGHT+IGSEJfg9NiDwsfGQNgMzoJXvgeBnRfAVLKv9CjCjZDAdI9sAnhanA6KRSoF6muQ/s1OmrvU9A==
X-Received: by 2002:a05:6a20:cf8e:b0:1d2:bcba:70b7 with SMTP id adf61e73a8af0-1d2bcba78c6mr22172622637.27.1726721269821;
        Wed, 18 Sep 2024 21:47:49 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:49 -0700 (PDT)
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
Subject: [PATCH v3 32/34] qom: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:39 -0700
Message-Id: <20240919044641.386068-33-pierrick.bouvier@linaro.org>
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
 qom/object.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/qom/object.c b/qom/object.c
index 157a45c5f8b..28c5b66eab5 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -2079,7 +2079,6 @@ const char *object_get_canonical_path_component(const Object *obj)
 
     /* obj had a parent but was not a child, should never happen */
     g_assert_not_reached();
-    return NULL;
 }
 
 char *object_get_canonical_path(const Object *obj)
-- 
2.39.5


