Return-Path: <kvm+bounces-26649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D41C2976315
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 059DA1C217AE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BA119F401;
	Thu, 12 Sep 2024 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ko0X4Yst"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3277319F132
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126855; cv=none; b=m/aHYy6XOc0J8VOz4+G/fRLW79xIT9IUENZRXZzNkkx8oTFolCaKzz/wA9HgHusVWRoPaasK6qbFQ42So9O8yI8hq3XuwkIfIdPJdyRzhkCpeavrMSAohvADQ+/2tvhZkEV7SWOwLqKHTZmi3hDSBRtM3DIyiTdXIzyOwgm9PZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126855; c=relaxed/simple;
	bh=vUmggebk6axfRoX4t5h3002427da0v/xYYZvwb3DU+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k7tgKe9ppDshp1dH24brB6Gx9xqlZGTXWiGZQFmnMRDFnDn7uskc7C5BC3OyjjTXcuxTpb2oMIvLD0WuBa947UHDozkkGeoz4SSsGhXx4bod6UNtFJMpc8W67exbe4G1rOgB9I6TDAPeIpurXrBtpJRYSdYAk4n7xCnlZuc+xnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ko0X4Yst; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7c3e1081804so359139a12.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126853; x=1726731653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZcvwE9FJNxmdIVPlBQdfypY65+b/8lDno7KQ7aDgr+A=;
        b=Ko0X4YstiVV7VYalXNGevEEtmqCVzSfeT5D6c4CvJp/mHQGfcBb5x3fJZ+1oPyk3Pc
         YEg8oDMNidLg1YTOQj8W1rGn585NlOjKDFVf33c/+OIPlzqT34lswBicD9jhcuCdwVmN
         SVyJKt8unDgy+EeZvkgma6/FmYV1FRvULZ+EIQishVKpjQtm4/f1ox4rtvfcjHKaGXIa
         qA7qFydEEMCLdHu/Op9oQSVWKjVVoTeYX8SyRhOSDW6cOBxO1tRv2ERO8RF7NYEc24uf
         3C+uKN6mf9D5XZRfZAiK/QL2i8JDKhi/P2xflCO6QRVFiaGgPZpDdfqmV/14OheHImZt
         DY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126853; x=1726731653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZcvwE9FJNxmdIVPlBQdfypY65+b/8lDno7KQ7aDgr+A=;
        b=gTUUQw2CyOmi/aAo7+GXKIQIDxWeQ0BAm4Bl798JbGyzv/FapDm0yXdohyS4K9Bwsz
         mlMdT60SZct3iQ9FxH2voHszH1MjdW3yBOgruAkUzoYDGKsIAcC41Oykvd9gNUdx5dl9
         BPQ71MGlq3cV3LNfAM5q0SSak2u5871dUrDfRNpFUynJctCtO3lpj0cSEX8o7xPPlKoD
         9WIA6lQ5vwXFa7sZxmCwzgJO5n0F5uttV4YJ+jfxF3uDtc0JY6uOZnxLNz55yEvTVBcp
         rSSQ4CBBd8kfZvCc6Qq0bdJnJVGGYwQ5XoMmCLJRjaI2wPtGJ+eepv0ptVLUoUc2bF25
         oCWw==
X-Forwarded-Encrypted: i=1; AJvYcCUnt2RCuSx6kFuP37m7JSU9Ud0/8laBaNuNnKibaSXlvYGJFabAH7u7uozQ6wfD0/JGdgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLkPBo/e2fbkAnt+0wP3CBGl4CqszdQZgOHHbx6BlhM6/5ulHf
	Y1/HzZIw+XI0yQQtjP1EXfEamBJHpGZfOajTx1JD226L9XH3zQVgzHKBYRwYzQU=
X-Google-Smtp-Source: AGHT+IF+BwpPE4A3M7aIxv++xh3a9Ty8RvQxhzK9f6I85GUgpXeWj/nLy6PCJ/dYfr1LgiyAJ779DA==
X-Received: by 2002:a05:6a21:a34b:b0:1cf:6b93:5622 with SMTP id adf61e73a8af0-1cf75ee4d05mr2672158637.14.1726126853641;
        Thu, 12 Sep 2024 00:40:53 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:52 -0700 (PDT)
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
Subject: [PATCH v2 33/48] target/arm: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:06 -0700
Message-Id: <20240912073921.453203-34-pierrick.bouvier@linaro.org>
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
 target/arm/hyp_gdbstub.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/target/arm/hyp_gdbstub.c b/target/arm/hyp_gdbstub.c
index f120d55caab..1e861263b3d 100644
--- a/target/arm/hyp_gdbstub.c
+++ b/target/arm/hyp_gdbstub.c
@@ -158,7 +158,6 @@ int insert_hw_watchpoint(target_ulong addr, target_ulong len, int type)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
     if (len <= 8) {
         /* we align the address and set the bits in BAS */
-- 
2.39.2


