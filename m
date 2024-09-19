Return-Path: <kvm+bounces-27138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC5A97C387
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 884301F231C7
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEB54CB36;
	Thu, 19 Sep 2024 04:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cyoSpCsc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB81200B5
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721241; cv=none; b=KDmI8Qwr0tVL9Bpv+p5y2yJpGBukrzFbW7zo8lBcjjO5IYtljl1QXST6bBqxmlG6e5pGmudXvI4eqxcYB/i5WQ7jOqheTfPaM1IgZjMI6SxczIrijH2Mz0ImIHOsvrB00B0josfLNKMfdZbLmUGg6FicwU7MzmqDlRins+mBWC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721241; c=relaxed/simple;
	bh=/ZFBn3QeKRgM0EwmDs7R1QyKAH3aMW8o/bGJD6Yr388=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ePrVOchNv+hW7lfw9xfAu+GD72vPoYiarI1kgVq95msJZ2ENVj4rMgmr0eM1cVMzfWx9ufhCCzwGnOcEFrUXUT6EPwuT+Vxm3ZK9QhDUYxZYDyvtebtAho7VUbf6jJkb6lK7OTxy6KfIAggDDNowgdQ1k7xQ4YrTXxUop5XxuK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cyoSpCsc; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71971d20ad9so305580b3a.3
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721240; x=1727326040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P31I3C44WXD62nQdqJ/4LHYU5tGPmQzloTc3BsmhhAw=;
        b=cyoSpCscPJ7LuS6x0y4xH4LJiXvJmyuJ+EdpOeisqA+cqDgam3Lwwl8QeymyQ05gwj
         S/IYSEQDGzNl4k5HzdcFDcVtxRSy+kFBcHvUBRamxwkHUN6EIumkWLFU+U3pmnmAMpEq
         bW5vXeGNqUIQpC7c27nTKHMvOkRzfnGZiv1GxapMaj3a1Ut+k2YHgoZXU4I3zcJK6YiP
         oO/00qwrdblnqroTj2nfQeuiGTdPFwFN8SBfBFaZkj4ypMhBA3OESvcVJmk/ImHoDg5f
         lbbC+lNhQvvGnTgTd2Vp9XdXnGRd6/6KWIKfhPhNOm99lq2CMuFhACxndtf6sGjBC5h5
         bIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721240; x=1727326040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P31I3C44WXD62nQdqJ/4LHYU5tGPmQzloTc3BsmhhAw=;
        b=K/7NdcHXI5siRna5+X6x/W1geTatcrULQbKoTOHeJf4P80lPBFB4qpUfw/ekCZ43gi
         lrr4Npl42sPeMwyZOgzGsFL9ENHYdc16hH8nTgi/jrDO9ul4d3dMxV2zcjRs/mbgT1JG
         43CJiJZv0IY57DYvclqo3rlLu3QfT8wHKweMvKzwwMZsJH+Nqy7968N8PDpVWf4sZZjB
         tvfgqURgJ3voEehNxYo0Ai5EuhEPWVtmR2phrnmTAg9f++u00sQt9IvTj1iNCmMiAFVN
         4QpM5I7LVU9dqFW2NJuRDnHqu5Gl/v6sU65kFRBJ3Si//2QBXena3Zl9gPMk9bxh/Mn5
         SLFA==
X-Forwarded-Encrypted: i=1; AJvYcCW8S5dvDhScFZj/uhgGdImg3kntfelyfcmigqHuflmqObaixhhJNytKmDzmkQGA87tm+gU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFEpeBnQ/t3XlKSzKHBYxxaSnI5teETlJcxco3bhK0pEVJj4KW
	9PoywalT7aPFC7qFFgsTleAVx3jXxw/SWAExEWBBKTuezMaBU9R6Uj8YBQ1lVsQ=
X-Google-Smtp-Source: AGHT+IE2vIINUcW+zK0eGbTcjS/rKf9+2RXdS9WcQeduP1VsjHVzuUVVefnTsjBWDqx5B00zhv9fSQ==
X-Received: by 2002:a05:6a20:304a:b0:1d1:1795:4b43 with SMTP id adf61e73a8af0-1d117954cb8mr21768562637.26.1726721239845;
        Wed, 18 Sep 2024 21:47:19 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:19 -0700 (PDT)
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
Subject: [PATCH v3 17/34] hw/acpi: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:24 -0700
Message-Id: <20240919044641.386068-18-pierrick.bouvier@linaro.org>
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
 hw/acpi/aml-build.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 006c506a375..34e0ddbde87 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -535,7 +535,6 @@ void aml_append(Aml *parent_ctx, Aml *child)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
     build_append_array(parent_ctx->buf, buf);
     build_free_array(buf);
-- 
2.39.5


