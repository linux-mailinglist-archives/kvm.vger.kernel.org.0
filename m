Return-Path: <kvm+bounces-26360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8506597458F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 496A328BEF5
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF971AE854;
	Tue, 10 Sep 2024 22:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XNZLwZS/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14981AD3F6
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006596; cv=none; b=Ts9hrFB0yFDHuB55GfD2l21chKD3MiUM8z6Bug6OKkNb6+ysGqP3AlzuNqgJMCgJQEubwHpwIyMX9c/tje/J5mA7EdXVPjLk5FmFZ1gXXG1a07EzGGnNJmx8UG1gsMNdJkkV6NTjQFYpZ8kEft8m/urH0IFubYrJc0OKzlisTJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006596; c=relaxed/simple;
	bh=nCOqM6efIUQGTp06w9U1vJnc3wBf1chvTf8ttPlrj04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qmimwbuJnWfyVUJQVc6RcapYg1wpOC26LTEePYJ+qZ2r0p+g+Avk8ljx2ocb1bXYu5Ba/60QQfj4bYHn84+DkUeMDSJpBTWnGlUTdPOEbLWXc/f4mPI7TcbZfySdRqp/pmGQVnhXs6tJK0k3//e7GK9d/O8qRAmtJncruYSL2S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XNZLwZS/; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-717929b671eso1162707b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006594; x=1726611394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kX/5mXkAZg/T7UoQ7ZiM27KDnvioZeAa7JGin+VRbgw=;
        b=XNZLwZS/CjIna1C48nZ6jUFsq18fSDW4gsrV2+xj3dRSMHi6gmzq1ZluM/sQrivUCI
         tB9tXBWeYwReMNgHajtr+ssnn5PCCPgEOe1UxaqlC81DUTzFj5flZo135WLkLFQwYMT9
         rxJkCTuw6wV82VVNRiluSyP+JhG8iIEFYAZvUqXp64oyRXUyRG2l9k5MLfdSHEgcWvcG
         qvb0sXdK+0S0UY+xYP7PI1cGAeaLnzfI9HaxsCUAF4uaSdgpjld9XBBYOrCAfMGR45Vd
         V0AsC2pntqOF72LX20hz4pmglhgnTWOULXoSE2DyvXbdn9PNyavlTf8OOHYx9KJbGbiV
         uMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006594; x=1726611394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kX/5mXkAZg/T7UoQ7ZiM27KDnvioZeAa7JGin+VRbgw=;
        b=FxSaLiTYSuuK4SgsxUNG/TkEsRhdOhcOpll9Caj8hxQLCF52ep/WekuU7Uuccwuezi
         Q8Bhji96qQ8hPxYCTP/OTccG0yR30gs0Cz5ItQ9Wk91X2PxqGmQxg03Z4/2OD4zaNQhy
         3y2KWyHw+Caf+wdHf5446vJRh5NDu4wgsudcShxrK4yfslHBb4kZFMyzjBSD0eol7qRw
         jKp/RCiMOSW3q9LlXEavozrKzGrK2Tqb+RkpFYgyxD0DvdX4vYlL+x0FxJcvPUCGyEOw
         Y2VZbMpQnlNoq4TpZJDltuoPZBP7Gz9gZxLZo/h+etyr6R7Ssh5a8Dgkl7YlDxAVGCKK
         PeWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+lQ64qFqbaIjxk19X1AufkO2gWaumYPENI7OaCzXWdHFDouow8ZpvUbFFlTd/AgP7H3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq8nKtZLFE/Yg6wzMBj6BT3kxlP5TacXAPhwxg45hBQ+VwpYiR
	jmyVRFpnrVsjjZbrRcHc1Ca6IC9218IjorciCOlmWz+MJAFLo63LpqPKc1DmHZA=
X-Google-Smtp-Source: AGHT+IFH48rM5zeGac+OC8ccWI5NmVtaDHDVn5dEo6JbJqidSyB3SpDh1xyjFSfF49d06KaSKXm8oQ==
X-Received: by 2002:a05:6a21:458b:b0:1c8:a5ba:d2ba with SMTP id adf61e73a8af0-1cf62cdaf9cmr1582093637.22.1726006594141;
        Tue, 10 Sep 2024 15:16:34 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:33 -0700 (PDT)
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
Subject: [PATCH 10/39] system: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:37 -0700
Message-Id: <20240910221606.1817478-11-pierrick.bouvier@linaro.org>
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
 system/rtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/system/rtc.c b/system/rtc.c
index dc44576686e..216d2aee3ae 100644
--- a/system/rtc.c
+++ b/system/rtc.c
@@ -62,7 +62,7 @@ static time_t qemu_ref_timedate(QEMUClockType clock)
         }
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
     return value;
 }
-- 
2.39.2


