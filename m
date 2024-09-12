Return-Path: <kvm+bounces-26643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50646976309
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74E461C21719
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F65519E998;
	Thu, 12 Sep 2024 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FWcgFIhS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193E418EFDC
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126840; cv=none; b=KZnXZd5WL+A5Eu5eXlxwHvsn5Wx2fTU9+OmBiJLdNYUvk1hftiOhHLCKWVKbSK8TbZJOiDS1d7a3Q6GdyibkMhRUNub2IfN4vBHEKyltQzXUWaB98nFPLc2V41RkVpNtrfC0BqGYby2VPi8sO0g2yOtLFbOb3C5DAvL8fhUwKB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126840; c=relaxed/simple;
	bh=mu69ZBumLbFFvRRxjSHST2u4HDWiZaAYs3CFfCmkv90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNoBqJcIehIE0+01LVvylD15269Xg1JbWD1C9UICxWAv0qCOGvhB8M5AvA+nRvlhAoslSNik/S2rdDeBay38/5H3WB+VARbcw/IrPfIYKlqwVZcN8o9EKi2SbQrnHnmsvjUI7Xe3kDM5YVC0lvN6ocHh7DpWz1jlh+w42cnyaxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FWcgFIhS; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7c3e1081804so358823a12.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126837; x=1726731637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4cUmRJxiWI+4P3xFKTX4Sejqig+SO3wUE6UW4QGJvI=;
        b=FWcgFIhSFQEejquGqFhurpoB3YK4HsP7ZQmUoCSfUfRT6Tjz38PSD09DlntBgxCZ7O
         gKR/14TzalfKtJCNIXGS6iYAIck9KmWgFrC0azZmADhboTs17fplBdmUosgR1x4ZGtuo
         GHMvLKVM2ICIWOp7CshRoQzdUDrZc0WVCTdJpUT9dhWsFOXA84c+zdDdyE0slFdPtfYo
         iF4UMormKFUaBUxhYO3IXq6nmQBEVwYgr+yGB/Eeu+LzF5Jee2Y6BmFYwyFPBmuJZF53
         WIFOF+yWvvfZmNO5e+AH5fmJ8BteJ8AWHnYe+rkjsSza6Q+RibWdhHxXO4TNysxnGn5/
         BTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126837; x=1726731637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4cUmRJxiWI+4P3xFKTX4Sejqig+SO3wUE6UW4QGJvI=;
        b=Mw4F7I8hZIUp01QTT/iFzCDPdwOSXzb49/tompTYsss0gXk2cZDeA6K5A21/kUFK9o
         jhJ7rn4fpw2ZxwRUZp85ct5lUtU+hxoIqCVMxWeK0I1Ovnb3cIQVDEzaI0vvxTYjxAlA
         leZpiUmRmV6jZwtT8C9nqqbdMvvRG6eKqBzsYaiIxqHTRmKN+LjZdeQMgokv/R+v7II0
         WBJaNW18djCFZS8OkU3VrIBT/ddnJZN6+qXk9LQf1FqceJyI8wJ8ipWbdBKlsyCcStmO
         HaRYbU/V1Pw/I5iAhlyUw+fIG7R2+60I7q0VqQzi19Ch6nAtDvPgNKVN1aY3Vfzvi7aH
         eERA==
X-Forwarded-Encrypted: i=1; AJvYcCUsrGhLkJCp4jVNO4c1QVjvVnYghHMu+wYHVtoymk9vbzQ+XR/6XBSEz3isOyZykefEUYE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+Ktb+cYG6NF6pLRCUY1Klih7CCyityZmt8XzjSP47ren+X93F
	JIix5SPKyp/IwlimwfGGvmjlrrFKhorBkoBIvxufrt/WCPb3BuINXPcdbX43Xxg=
X-Google-Smtp-Source: AGHT+IHas1oukAOaDNvjAJwoGhr1NcYPZnCTY9G18MbXXKsVaftCFarfJ0eM/UXI1bph8rnTKBJZdQ==
X-Received: by 2002:a05:6a20:c6c6:b0:1c4:9f31:ac9e with SMTP id adf61e73a8af0-1cf764c2648mr2589519637.42.1726126837349;
        Thu, 12 Sep 2024 00:40:37 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:36 -0700 (PDT)
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
Subject: [PATCH v2 27/48] hw/gpio: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:00 -0700
Message-Id: <20240912073921.453203-28-pierrick.bouvier@linaro.org>
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
 hw/gpio/nrf51_gpio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/gpio/nrf51_gpio.c b/hw/gpio/nrf51_gpio.c
index ffc7dff7964..f259be651e1 100644
--- a/hw/gpio/nrf51_gpio.c
+++ b/hw/gpio/nrf51_gpio.c
@@ -40,7 +40,6 @@ static bool is_connected(uint32_t config, uint32_t level)
         break;
     default:
         g_assert_not_reached();
-        break;
     }
 
     return state;
-- 
2.39.2


