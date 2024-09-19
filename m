Return-Path: <kvm+bounces-27124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADBC97C370
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64986B220FE
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73331F95A;
	Thu, 19 Sep 2024 04:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="chOe7lzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0A81CD15
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721215; cv=none; b=XYkYMPkD4rqmYGbfLSv6N3oW/HK/5uaL/6z882Bp3nkJ49DPkHpYrNL2LrHHQI8u6XNzrgicrzC6y/riOzwbNm3F+Uh1CqNEcdPbuyJJOmQNiIwq1tMxcfv/A7pP6xwV29lpTw/JG6ZIpQ8+yDAZrWbc9ivVEnqvOTOUycX12Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721215; c=relaxed/simple;
	bh=W5aWB2iyXXQuxV7o2KmXYYCNiRPnXk067barVEYx0UI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BpJqUDU9TK7A+wdz4WMitIQbhSwhY9f5+y6LUrwZzdTIXhnfJN9vQDB30fhlmXBEVnUfQcwrAZLQz1X2Tx1uL3o0RRhjJDKXe/Nez+pIKcnR6KuHeHMSXlTgtIb4g5/yPxryb0NP5Ilh6ak8esyeKEHRErdOBt0cULLeCZdtyfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=chOe7lzQ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-718e56d7469so301340b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721213; x=1727326013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/2IU4UYdfrAjMX4NizJG5E5V51UHXtFH8CwKGzIrQ0=;
        b=chOe7lzQeMQ+Gvnukn5Zcm48jaeUc1pqvnXT96Zc30bB0aslyo3SvzXcSxrPIx19XI
         0u+jBV73MOxDs7arVQIz5eJx/c9RD4oWRY5LuWlASbrJSOGpQUyI6vJj9DhQE8V1KGw+
         oSJjXnTC+EyspO9zue48+WmMeCkXODCSzsNaMdGXw/0ZwZQU147kIuwTvzLi5qhr43Jz
         CNDeEF7I/hFkIrpdHPbfViG7fyVchGYU2hUFD78w7haELatY5jpHySiuPm54QSwJaDHL
         xK1yCudFORPbkOYScv/vkHs+9LE8QxkdgUrg3sqpxkhBlwq5IUNTKeejGt5B8do6n94g
         bhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721213; x=1727326013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/2IU4UYdfrAjMX4NizJG5E5V51UHXtFH8CwKGzIrQ0=;
        b=Ue/YYzXQNvbP2U6Xmjn7J+oKmD9KtmnxF3QndKozLpcMh3VyvXqQ95uBydvXMsQxU6
         0Jlol4mjWCLuLpUQVymSWeLLogQupI6iLVmZPbgonjUv8EjW0J4KMzpEbtQXQW0PdJyV
         8ixFN/+iPJRemEW48v2iI3+OAOfoN+VOWAq3txh9lYxW2ircJ5a+Ibv+j57vD/hYzz5J
         QcNQuSFi1JEBkGTwTA9BrvABfUkof6N+DP9NKsSZ5zTpu3ge9JWt1yWUWL6LyAcjpjmw
         grxv6J6yQUBuxBs9ySdZRpgJYKeTLOXE8dlVN7xqbSJPzJ5OiFGUYOuK3iD7mFXU9TOF
         DU3g==
X-Forwarded-Encrypted: i=1; AJvYcCV3oAyeLQPTfUqf4w8oIZjUSZpl3wcH8EcpIOoRrzzTpngcB3FYPJAKzhxIV8a0q6PhT/o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5TWNoNeJIyIubYgDdXEpDXLR1DI607uOMYMVRD8KFbM5z07Mp
	hFdF0j6Y6lUpI6tAzty4/nfY0uGuizPleKUj+8vs2VYtBuLhpSXDKPQabpzbHP8=
X-Google-Smtp-Source: AGHT+IEcE62Tv8QknJc8pTjVPHSXUbymb6AaYmeRJfTOhBz1uvzhH2wZstAOj+tMDYx/X/qUzXsWew==
X-Received: by 2002:a05:6a00:3c73:b0:718:ea84:3e50 with SMTP id d2e1a72fcca58-71936afb98cmr25001957b3a.22.1726721212760;
        Wed, 18 Sep 2024 21:46:52 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:46:52 -0700 (PDT)
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
Subject: [PATCH v3 03/34] hw/net: replace assert(0) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:10 -0700
Message-Id: <20240919044641.386068-4-pierrick.bouvier@linaro.org>
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
 hw/net/i82596.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/net/i82596.c b/hw/net/i82596.c
index 6cc8292a65a..cd416a00ffa 100644
--- a/hw/net/i82596.c
+++ b/hw/net/i82596.c
@@ -282,7 +282,7 @@ static void command_loop(I82596State *s)
         case CmdDump:
         case CmdDiagnose:
             printf("FIXME Command %d !!\n", cmd & 7);
-            assert(0);
+            g_assert_not_reached();
         }
 
         /* update status */
-- 
2.39.5


