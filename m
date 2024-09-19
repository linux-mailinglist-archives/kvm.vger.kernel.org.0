Return-Path: <kvm+bounces-27132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9896C97C37F
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 559EA283C15
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3781638DDB;
	Thu, 19 Sep 2024 04:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qkyaT9yI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB79E2AF1B
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721230; cv=none; b=slcXz5z2EapANulVhOXTVJzAWJqAzrrYFR3QIQ4Q2jD6l53ZLjzMJGa0kF4EpGj/NGGmzyuoBdR7MDZ8qufNiBJdEJL8ctshpRZBWmJhR8E7hZSWKnTmAgrqUGfRcPdL9jepPzmGd4fW+m6SjFa0uDg1UsqcRpaOxD4D02A24kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721230; c=relaxed/simple;
	bh=lkULxEsAovLGG+eRqYN4iW86DH45flQJoKsBIg/reyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N/UatgEJIpzRjvqSmOchb6Yj2TJv2EvBwPTXteQp7xjeEGpCx8rDNS2G5wqqbqCgAqDOQl8nmw7X9Cj7qjAPAxhS7o4yqda8m6vBlJf5lBN6/uNmgcj9vxN7oHC6zEDpQKiczqiEEV8+56A7SszzBKlPsk4JY3L374LZcBQXmTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qkyaT9yI; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71979bf5e7aso286153b3a.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721228; x=1727326028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=la0dMEWQk3jt41a1BnPVKduxSUDoWih+Jb1d+U0bfqA=;
        b=qkyaT9yIAkCjdfkwo7MhAoCh7OqSbw2q3NNWlf/QIPZVarQXnj9lhk/EX5YZtozocw
         NwBO1blUvGayAdzqvwk2XNsGsl0SrXbLMMB8KKUOMNfeyq5539QNqfcKjYtUVFOmH8KM
         d/XfMstRHZNUrX37kHufIM07lYuji8ZXMdWdTZ8++tTXMTuhHc382E8Oa8TT9omqUf3B
         1COA2hwBGPcY8Xr6vMFH0qpKnGQgW93cre5fWKkVM+fzzE3XLheAVBNWwCRwx3wFbcY4
         pZY9YIDpnTV8+K1qTla7cuE/FdMFRC6TcL4mokPrEBee0AZQBUKB49dwcfGjdhqbaOyt
         zgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721228; x=1727326028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=la0dMEWQk3jt41a1BnPVKduxSUDoWih+Jb1d+U0bfqA=;
        b=FrB3yBA5b7MNEPryY925uAyt85W6JVPITRwt4bXU4TTrifQjg3gHmr20aSDgD/mNtx
         KXe9FPU11ahNkOVCvs8wL/wvPYfDO8wcmk+P2c5k0E4Ah0fK54aT+0iNM+XAtHerpnlu
         mxNWtqFyGP4NU9v7imYQRy97rBZA62xfmFpQDKNWu3zp7g/y9/qYy4jLQg/+wRphH6AL
         blltV/8bjSFzj4url3ugZGMLgQ9wjxrWQw6cTjJXCQVVLhKiy3eymA9ckUCMYoXvTj4d
         amfSYizslYu5oEH9acdP8w+ScfdO9whoQ66yXxVGKG7NTadSARR8TAks+EOvAowDZcGG
         09gQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfN/IV6QQ9UyMBv6Xg9v/FOwYsP92/p1aP+9n5HCzHN6ddB3ve+rpduYGz+0eewZxRSNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzllPO1OzLOvEVNulHD1X5tLrLDcJxA44o8J/v1zaWThNWTEdig
	c04rcl9CtDA73lkKNojifPfP52BC3cZqeNjGzkYRgjmCCWgS0cYY/qT5la2RW38=
X-Google-Smtp-Source: AGHT+IFO8bGqNik5TI7HaUtD4Bw4p0cKBe+nMmhw2c5B2Y+i3tMDnnj5/Vu2AHTpiIf90gDt5Orsag==
X-Received: by 2002:a05:6a00:2316:b0:714:1fc3:79fb with SMTP id d2e1a72fcca58-71925f9b26fmr39873231b3a.0.1726721228183;
        Wed, 18 Sep 2024 21:47:08 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:07 -0700 (PDT)
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
Subject: [PATCH v3 11/34] hw/pci: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:18 -0700
Message-Id: <20240919044641.386068-12-pierrick.bouvier@linaro.org>
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
 hw/pci/pci-stub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/pci/pci-stub.c b/hw/pci/pci-stub.c
index f0508682d2b..c6950e21bd4 100644
--- a/hw/pci/pci-stub.c
+++ b/hw/pci/pci-stub.c
@@ -46,13 +46,13 @@ void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict)
 /* kvm-all wants this */
 MSIMessage pci_get_msi_message(PCIDevice *dev, int vector)
 {
-    g_assert(false);
+    g_assert_not_reached();
     return (MSIMessage){};
 }
 
 uint16_t pci_requester_id(PCIDevice *dev)
 {
-    g_assert(false);
+    g_assert_not_reached();
     return 0;
 }
 
-- 
2.39.5


