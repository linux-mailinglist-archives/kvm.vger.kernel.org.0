Return-Path: <kvm+bounces-26645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E990F97630E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20E1FB21ED2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6E119F111;
	Thu, 12 Sep 2024 07:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xxZ/kTdc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A734B191F92
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126845; cv=none; b=qUTMVWsGNMMp/lTwA0afa5lXhfebheKZ8WOuAqlGjqG+7+F2SVUonS8XPingfQq415YWoxnV+q+JZVKel/n9OLOWRGQGzUHZA2X3dWjhT1FWQiVdZkd8kDFMVgeU9K1z7a0rK0VDO1Yvpyb+O/+/8fIwTHXhJ/6OkfbHVMhXiM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126845; c=relaxed/simple;
	bh=qC4wKnukB0flMb5G8CMBXNITeBvXE1SgEbkmGnnfXeE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iYHC7D2ZANT8mm/CKDHRrR1SZJCp4cnYFdHbT5tw47z36bw/uOJCMI1+UjFetxtjm47wkYuTQpwQ+bFLZCwAq0nZlpko6V4R+k2QZMYZXJDGpVBsZy5U3IvVGVX3SAwDU73tRdsXI/8RwNefXbeBiMF6XnO6O6LBrher1icmTxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xxZ/kTdc; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e03f8ecef8so373652b6e.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126843; x=1726731643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrI0OydCanDe4oYc5C9zQMsS9yO07eCq04VfB2/4Bq4=;
        b=xxZ/kTdcZruCuDQkaNij6s+j3CMR6nv1+R6CVwPmn9AFgLt8zrDgieK6Cu9VGkAdRN
         Ta593sOqlljaK1h/S3JaWGLTDOxFa1Oqs7ytRTBi4kTN3zQxNnuqC9H8YAW1kGsDsxoI
         poUbtyt/tZiZUjtJc8j3aF6n+u7+FvStj8A7SIZDKTQrkborMNIZsKh4NdG7RKDTzafz
         G8Sj15IJ6aSiOEzd7GAqL+z4wZSMMSt0iKY+QYMKjPoVAPKHDr5pnuEYYdInWgUMtmqS
         tKtsccTEhfKmC30P2loVaTEnSkpXJ7H4MTVan2vMXNfcIA1/T4pYIgoXWz/vtHuyim2+
         KPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126843; x=1726731643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrI0OydCanDe4oYc5C9zQMsS9yO07eCq04VfB2/4Bq4=;
        b=vDIj4zSxJ4/X00vVjHx152aq05KQU26hWOgZ7NoTsrzuCsZ5ADF/WbtY8WBzK38yTY
         j0mhmnTaNx3sR30cGycc4pR7YSspcW5I9HCrShcmHsmP/oYnIBCPazbt92PgHcaF2YPD
         VfOJuSV3OdwcNFG4i0+qqmlbhe3Ij8sTyyXcpSZ0artYrZEHPFVBg5piz0E8+FMBS18C
         mr8DKZOL3b3W+5uuo/cz6AH4Re5fdADR37ysXESRKLnUY7otVmOTealq7FpfF/ZXQgYT
         rJb6YxXvLU4kORlPylF0BTT2nojShzPaZTPtJiGU5Uk0doQNK+0o2qpNgid5wdyZIv3z
         UWPg==
X-Forwarded-Encrypted: i=1; AJvYcCWnXnXfm0yG5MuT+wTQDa7YLaAScc7gUC8gN+wVVX5ZizvzLJyOF0RQav6k7mXrji8FNP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXfx8psq2nZMpbVXn0DNMjTN8jIy1iGEKMZe927n7cKpL2Hb/D
	7wzLO20FGOFmyh031BW40BU2pUZo5qBnY5PVXdw9t8wBVyiivJRRBncreh5BdIA=
X-Google-Smtp-Source: AGHT+IEML6r9h3ccLEXSox/u2udrMxmikArR/M0ZN/wJcIkH+O7ao0M/eUBiNS4fvB7hhlhdN9XfxQ==
X-Received: by 2002:a05:6808:1594:b0:3d9:27f5:5251 with SMTP id 5614622812f47-3e071a852a7mr1675735b6e.5.1726126842725;
        Thu, 12 Sep 2024 00:40:42 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:42 -0700 (PDT)
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
Subject: [PATCH v2 29/48] hw/net: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:02 -0700
Message-Id: <20240912073921.453203-30-pierrick.bouvier@linaro.org>
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
 hw/net/net_rx_pkt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/net/net_rx_pkt.c b/hw/net/net_rx_pkt.c
index 6b9c4c9559d..0ea87344745 100644
--- a/hw/net/net_rx_pkt.c
+++ b/hw/net/net_rx_pkt.c
@@ -376,7 +376,6 @@ net_rx_pkt_calc_rss_hash(struct NetRxPkt *pkt,
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     net_toeplitz_key_init(&key_data, key);
-- 
2.39.2


