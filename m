Return-Path: <kvm+bounces-26646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7BB97630F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2C4F281BE4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC48619F11F;
	Thu, 12 Sep 2024 07:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IvhtMO/B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5E6191F80
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126848; cv=none; b=rOYU96DRNVoTJVndDE50h4inZgp9j+8LaQZh+V6kJMYfAiMrBkYGdnXzdrEHKJZImAUwMST0ARcCfbB3GEVMpEuepyeOntVnYpUAo5QRtxhG8mm7q2sKTsWUUE7/ZRfTknZoil6pv85cFT5y3Z4oy/cguy0jdlOCvsAepxKXYJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126848; c=relaxed/simple;
	bh=6IxNtV2pSABUGEVqYotLXDo3F9afyAR4ukMpE2TbNdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hy4c9u9T2Rkn1yxBMpTmGqbro5SQIytSYlQ17spSxQEfBsxEbt3BjlST3rVDPB2t9UGd706B+xrwC6fauGYUrs1CLnxM2aLar8FRdPdfS7fJLH8/aHB3ByjKdqPZCJF01AGtCvTArUyVWZzh6sd6dczlDR68sFbLA+udQ/4jtTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IvhtMO/B; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3e0510b6647so258039b6e.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126845; x=1726731645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G15/cfLWuhy58D3S6VTY2yyYFPoVOBpPVm7OgoLv/9Y=;
        b=IvhtMO/BHVqdK7MjPrRW5nr2C78T7/G/rz6xtOOGbE55V/SHpAXjqmgGnE3lQtSWad
         BFbCU2ifv9pPLePJtQbMng/g4ExZKYhFYKbFrNByYJxpfaUEZQ4MvrSJC3sfHCNWHJMW
         IrdKuPu9BZdwPjupLwZkECfr0PHgAoG0dZkKZ/bqSPy6mhr08ksDa5XLlwI27vi8tXVW
         nxVlsuiUsHteqNl+QTSS0cfKou4x3xq2vmOi/RfEZB8Gy+0ODy+3tJ2KMbtocnypv+XP
         YnwnMEyRYEZsJOeowArpjeiwS0FCYTbDSFn5G1oPbmjWraP9tLqXKAUfNUENfDU0L0Hv
         Ir1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126845; x=1726731645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G15/cfLWuhy58D3S6VTY2yyYFPoVOBpPVm7OgoLv/9Y=;
        b=b5wqAENDOSUta1a0whl2qSp63zSs4sIdEfqXryeDTFvOR5oIdMba2AIs1/AfJQgN4i
         BvfBFXI/kT1wyJg0KXlvsgJ06uCMrkm+qGSgHzI6c3ATOFS/1tisFWSf8XQKbIgzhx3B
         dpyP/2n3XLoqjUlAqAHON8kwkjLV4b6VTKHHfMOSzNJ6EtkdcA1Y7kQpNDMKuhvf53+o
         HsbQwVl+jST6/X1843Qb2q96hCEzhFVfoPLwhmH+gmd9JvGTZHIPLX+ACaB4wDabpqJo
         ejVTJuHfhgBComc17rfckk+I/Nkxj5huDlYAo3DNNKPXFKVz94bD/+GhOHuXA0xA/bnx
         MFaA==
X-Forwarded-Encrypted: i=1; AJvYcCVdQJvKKBVuHHTjZqqr3Z36CxXDlp7eXjfhEx6Yf9/CAxDSHcYagHMB4wh6segJPtw0jfI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwbtjY4+x/syXD9A1Z0MxoiFOFMRL6pUNzT0Kurvgyk7AQJj3N
	D/ih7NffwHIV1Msib3Bt/5tk+iA7UI1Zw70a8E8P9khxPP8iWPkAMkI0k7kLT88=
X-Google-Smtp-Source: AGHT+IETN6rcEOkN5n0lmGk313YArCk9WXbSbiIwWQ/b2J6sYsWxK5jf+hG5cA2W/PAz8ROKcimuCw==
X-Received: by 2002:a05:6808:448a:b0:3d6:3450:7fe0 with SMTP id 5614622812f47-3e071a835ffmr1063495b6e.9.1726126845522;
        Thu, 12 Sep 2024 00:40:45 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:44 -0700 (PDT)
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
Subject: [PATCH v2 30/48] hw/pci-host: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:03 -0700
Message-Id: <20240912073921.453203-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/pci-host/gt64120.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/hw/pci-host/gt64120.c b/hw/pci-host/gt64120.c
index 33607dfbec4..58557416629 100644
--- a/hw/pci-host/gt64120.c
+++ b/hw/pci-host/gt64120.c
@@ -689,7 +689,6 @@ static void gt64120_writel(void *opaque, hwaddr addr,
     case GT_PCI0_CFGDATA:
         /* Mapped via in gt64120_pci_mapping() */
         g_assert_not_reached();
-        break;
 
     /* Interrupts */
     case GT_INTRCAUSE:
@@ -933,7 +932,6 @@ static uint64_t gt64120_readl(void *opaque,
     case GT_PCI0_CFGDATA:
         /* Mapped via in gt64120_pci_mapping() */
         g_assert_not_reached();
-        break;
 
     case GT_PCI0_CMD:
     case GT_PCI0_TOR:
-- 
2.39.2


