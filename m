Return-Path: <kvm+bounces-26379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD169745B3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE5E11C21960
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776041AC440;
	Tue, 10 Sep 2024 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HDdbtBAo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFA31AC42D
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006669; cv=none; b=fh6DEhg6q0DGdy20oQA4vdGbJCn9LVnMfP4ErLjkXMo0kmPUeNGtgcgBwnDeTlcf42YalJdqRCJ/+hNPup/CRwhAIaS9nSDH5EuNJw6A9DBbj8oPDOc6qcI3jn4vmH+RAJFXvNJdtrumybQ1ujaCHfm66tr1JjBT9yoPC4ukAZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006669; c=relaxed/simple;
	bh=diNjrKPpqNxPe0EZv6i+WDXphBEludRJsD06CRE7eVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qj3Ykxcc8A5Rwz1pCkBwrExOKSKQ+7Nmltzd3ZcL+tixWeta9DKILOl+78wRtLxIBeyFc0X7HP+zXm0xsfxMwnFGW/+Inq0Olt58bXWSd311QTIdfa2+s3V96CEpLD3WLxpXDLktPxLB5oXWgNP0P3olk3sAZH7k/lPXnsW21Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HDdbtBAo; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71781f42f75so4835304b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006667; x=1726611467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwL33KJkM4Q6sZhv70DYnj8c/5K/FMceLOUvjv0df2Q=;
        b=HDdbtBAoxjmnlr3pt9pC9B2QWjTpgyXBLYG5At42oMkW/X80iVKjPBJqfAZllvGYVh
         srnO2H0y1HKEoUXRJGNd/mFVIqvaTjS5WuYSK3fe91woGWMppe1bk7EerPcfQwTuKquO
         p47drs9VLO0urxJw7kQ8l0weoFblVi7E2m7D0zxuqEWmASGN2OzZLodyyNmJ5KkLxqtf
         9PYoLpmEDBqcuzaTcO7wR8f1FCOlceAdFRgcUGbEkAnQr/Gi4KABZYvn1XTfDaIOaeV0
         hPO52FzXt69e+ubUDUJdTkrxycdWXtH1s9un9Jc85jbSSzvcZUvqAIx9ZsNfJNtyESkF
         RiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006667; x=1726611467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pwL33KJkM4Q6sZhv70DYnj8c/5K/FMceLOUvjv0df2Q=;
        b=WghClE2fiOowJpVI4buqsCRdzX3Djr3s9QYKg/0PtF1G2dRE0mZA3DjKS2DHG8ihfo
         EqSSZeHzHvHz27TIKo9Na60FpNBM8YMgx3F8Rp4+o4AH0YmfqxR/oKm3gpUPc3a3RWb3
         LBMfVMMGWPKROG1eCBU9ER2EIMaqObGarebEOZngCz/Q7A1XOJpnWiurnBlBTnHFShZx
         4rlmbRqa1Fnq7lJJMimmi90Chec8sK+b9mmgMmQiV98f1P+/BWIJyaMGJwNE+oJNGlBK
         QIRAOaaeDDclSTvZm2U0ccNRzoodshKtfFQE8ni6AFxW52QkeGNnHSdpFmscWPUSnnaU
         blxg==
X-Forwarded-Encrypted: i=1; AJvYcCX+7FZPYimjd1oYSA24j8VfwHuWyhUucJv8LXR6zJXo1ePnn0Gq64VVLLllKjW2utWKNXE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnzmJshaK2Sssjpt/j5WUD3JN4W6nKRU64qY7TbqHGm/drACP4
	yzr7WilTJuxk50sTGjUJ1n/uwJeCzmvIXQ+hxzVobvBbRNGIrlTFA6cJaet1aA0=
X-Google-Smtp-Source: AGHT+IGLJQ5enOtPE13aQ+/NIdbH6s0S5HLwnq2JQ7qsPrp+J14Xh+TVi3Hmr9X9Sr+7gsTyHm2Dpg==
X-Received: by 2002:a05:6a21:9d91:b0:1cf:3201:c3ad with SMTP id adf61e73a8af0-1cf5e1c8112mr3689026637.49.1726006667581;
        Tue, 10 Sep 2024 15:17:47 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:47 -0700 (PDT)
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
Subject: [PATCH 29/39] hw/net: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:56 -0700
Message-Id: <20240910221606.1817478-30-pierrick.bouvier@linaro.org>
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


