Return-Path: <kvm+bounces-26659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85144976320
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A91AF1C214FD
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651D71A0BCA;
	Thu, 12 Sep 2024 07:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q1P4Xz2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B541A0BC2
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126882; cv=none; b=hWhn3/VwFyQwQffAvVTP2/wMc0rclxFAHN6xEBE0FJntiSlUMlK4lBg6Ws0/oIOZqiZkb55fF586Cvc/xDVO2D4AYEqfw1G6sfQ5IrH3jR0BS7HTaDzdB2m2F5B7m8le122I0+dyRArEM/L8GFa6DzCpKHnYH8PS/c/ugvpa4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126882; c=relaxed/simple;
	bh=NQ1Zt4vBB9ezlf/RurG1vcjVnoZ5wH69J+1HyxHdmmg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gPkeQG6Z+6ZBTnVYrESONmXERu4irqe26ZHtzywqWSzjNwQFeuCHFbdNIVfDOogEktG9HVn9lYrxaWTgFBaOwGZSxpJy/Gl2xT9n33/MWkBZtHjLdr87jy1MRhXbMPxMVWsaJwr1OSCChMY8wWJSo9IKU6Lhv3RvNqmHA/PBh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q1P4Xz2E; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3e0438e81aaso388887b6e.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126880; x=1726731680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufez9dB+YBOc+7iflBPh4kX/ooB3/U9U7kq4P7lOFRo=;
        b=Q1P4Xz2EcDqvSJjHpWvrZIULYlG7fTXTLcbOAWvgEd/JIGn/oyqBhGlNDjGujLfnSj
         pWSSHcvis99Tjc9aT8u5Exmpco7ZAzjYjwYzDe7PoO2W2pEQp18kemf1ndY83lf2fsg7
         5of0QpDv9Cm6WBMFVJI6DityGSykvcwHLa5U8KK+40l72xsKofrsEU1b5pSydGAa9br4
         WPYQTmD+Tl1O5MBKmQ9GJkBJgxuHD5LMRMX2kUi0TQ9IWLdSpVtfp43XeXWAuhPGFVb8
         i15an073kABBAgOJjNN21pCeBRbX7+QbATmLGmmPfJz0b7JgO30ZW1VQFtdz1s2epUjF
         VNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126880; x=1726731680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ufez9dB+YBOc+7iflBPh4kX/ooB3/U9U7kq4P7lOFRo=;
        b=oCT27n0I8VQ4kP15Se0GPemJxBJXv/GVmvdX/i3/M+SkCWD+ZOzteLGmjJUMnZCc0J
         LhTDyj1KgIN3hbaaQF90efS3lzuyxiM9EX+Frbto2RRx2oqRmvVj6689NROg3epGZ3MO
         82WOw8M0VoUFee4Jm2M7rcPaMHsUncFGd6kkhu2ifyUGXyzXHXAcJxc56qg0vERhIbwh
         p4WgwG/ycx8l6kDO6Di9vgEUWTho8cBj6rnFJz2g2LBoXQU2yQvC2wMNeMtAYQAG06L+
         zG5pK70eveLraIW6KcKFc7nICmM5G9N0kIAyi0BgDxMH4saNDTxAOXIvdrOsMuIxepED
         PzNg==
X-Forwarded-Encrypted: i=1; AJvYcCUPRgNq3g1o6pEIWF1zHPJEPAFNlghxOEVNWBWBKpbtpfrM2A7Z33ItJZyIykOIMHbqFMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhfBKLQneJ4DTa5+BQyyAGdht1N7Rn4ozyzq1z/3fclbACnSGV
	ivc0cG3q8z66RMNmv69+ZHSAaesK4jTdV0HQOWQZnAcxvjhngOilmbhVCR3OGaE=
X-Google-Smtp-Source: AGHT+IEahP6jvi2FuHplutVqQN81TXossfZA34JXn70LhsQgJakrG7hFdv/bnJa3CeA2ta6y/uKqJg==
X-Received: by 2002:a05:6808:159f:b0:3e0:4faf:242 with SMTP id 5614622812f47-3e071a9a5fdmr1180584b6e.19.1726126880116;
        Thu, 12 Sep 2024 00:41:20 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:41:19 -0700 (PDT)
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
Subject: [PATCH v2 43/48] hw/ppc: remove return after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:16 -0700
Message-Id: <20240912073921.453203-44-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/ppc/ppc.c          | 1 -
 hw/ppc/spapr_events.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index e6fa5580c01..fde46194122 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -267,7 +267,6 @@ static void power9_set_irq(void *opaque, int pin, int level)
         break;
     default:
         g_assert_not_reached();
-        return;
     }
 }
 
diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
index 38ac1cb7866..4dbf8e2e2ef 100644
--- a/hw/ppc/spapr_events.c
+++ b/hw/ppc/spapr_events.c
@@ -646,7 +646,6 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
          * that don't support them
          */
         g_assert_not_reached();
-        return;
     }
 
     if (hp_id == RTAS_LOG_V6_HP_ID_DRC_COUNT) {
-- 
2.39.2


