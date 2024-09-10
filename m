Return-Path: <kvm+bounces-26365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B62B97459A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4494B24F83
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593541AE87A;
	Tue, 10 Sep 2024 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aPSui43B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE531AED2B
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006607; cv=none; b=Atl3qoOGan/wspgiJle58L5AKGxQQrANv6y7bbQToWM/S9v5jX9Zq6tVPnVfcLKtSHZVhpeV5duNnoOswDecfrcDH5pzRnPBwlQTsGs0Jui1pr9P389EHPM7rqmltBfz88lFHeeHe+NZ7tHKH4JbEMdDC4VfjFw/Utj4H6/xt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006607; c=relaxed/simple;
	bh=+eUwWAgQrej9bl/Z/TDNwK8W+NkrBeALG9GwKc/FEos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sReZkgMuSXJTwxB9Iln+8kWt7MGVAXRg2sAgVhpaUMf6Fz04HRzusH+A+AujidcdUOUTsi2kHLAEq6lJpOi5OoS5txrQ2Bx+TypuEYqMraMYTifr4zrdUl33IR1o2UF8j5LIStxxTJeYdEm/BmqaPNkXYLoZ7r4GZU7k06d9m/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aPSui43B; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-718d962ad64so4416079b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006605; x=1726611405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaOeMd8XzZwIKO+BVAeDQHacTyR7MUVICUu2Groumoc=;
        b=aPSui43B+DkSRBsl5wkNLsZ/U3cTrJiJdzv8Mr9RC4zfmLqJS3htsDS4chuBVnVoDY
         FpN2yI1GQMN4TpzXIwv8p0igY5Lfo8mA6lzi2Sw4EmGjMgnghnyDZD5xqSWWMAJeLh9X
         HTQ2zTYNLmfKfzgAyf032sqc6UP+dMFXQHT1AIuEkBas3f65jhYC+Nc8yjnGNmSWxMl3
         cukEy8Cr2Yq3vmOVXWMi/wqKzPV8RfPsp46kcQlX9SvQlqH5KQgKE0zIGc/CIZnANrKU
         4NPfnB0ZsjBlnMDIPVHe8pDPvMEVLXvz3X8XoCFuvmbN+pOO+jJvrdbstOMgRbGVYUsn
         bklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006605; x=1726611405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zaOeMd8XzZwIKO+BVAeDQHacTyR7MUVICUu2Groumoc=;
        b=rLZeCPQq/YT7kkAab50+MH3LWEwP+TQ6iTK01wdT0kakGp7n2m+xxuWbp08AfPYG7C
         bs1ir0YWDjAmiFPbXocGY0cLJXx/xcOrkxtas39o0aucZ15vSCSB9CTeKmMgQFtBONll
         nD64QTeTJyRX2KyrR9yhEuzuFvMSnAAeOUtT1w++63ERHV9jJQk8wkrimq8Rv4YqM1Jd
         VnaaUzD04eURfwYorBpHUUpCgQ0UK5DNrL5c3o0DI73lvp+x9gIIPbI4u+FaDL9WC7du
         V2p+svKg31q74HCWj0AnkmWkn/XrerSsP1CvqM5eNu5mWWwq0xUj3NZRJSTjlwxHT5Wk
         gy7w==
X-Forwarded-Encrypted: i=1; AJvYcCXLbbC7F4Yd4+KvS1T5IlLK5peYGJAHwbms+Rr95Q+l4QYppDDjKd8k1MP4U1/Hf9eDQ/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSPHw3g/MwsaqYM+lDbCJX9lnppRHygN3+kIYWPxoxL+s2IMy3
	mz+c0jY3VTQIK9ZOejJHESoq3s5LaDDSaL8sk8Bv/Kh+cAEG8puMLsdHK6qxpF4=
X-Google-Smtp-Source: AGHT+IGXdkrxhCzNyeQ+oPHQ9x0IFNSkeXfls9xHWi0Sicojf8vp5qG1xhcR8cFIxRHQi1oprvgqcw==
X-Received: by 2002:a05:6a00:390e:b0:714:1ca1:7134 with SMTP id d2e1a72fcca58-718d5ee3ed9mr21940217b3a.18.1726006605401;
        Tue, 10 Sep 2024 15:16:45 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:44 -0700 (PDT)
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
Subject: [PATCH 15/39] block: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:42 -0700
Message-Id: <20240910221606.1817478-16-pierrick.bouvier@linaro.org>
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
 block/qcow2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/qcow2.c b/block/qcow2.c
index 70b19730a39..bdc6337826f 100644
--- a/block/qcow2.c
+++ b/block/qcow2.c
@@ -5299,7 +5299,7 @@ qcow2_get_specific_info(BlockDriverState *bs, Error **errp)
     } else {
         /* if this assertion fails, this probably means a new version was
          * added without having it covered here */
-        assert(false);
+        g_assert_not_reached();
     }
 
     if (encrypt_info) {
-- 
2.39.2


