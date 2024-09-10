Return-Path: <kvm+bounces-26369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E549745A3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41E061C2516C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91E41B2529;
	Tue, 10 Sep 2024 22:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bFPSJdo0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899C91B14EB
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006617; cv=none; b=nJfzW9fJLb6+MS7yjHHsgM5ptDWp7uC7+FjhG8gxa6K84KrmfoUuFUqrQEFu/+i7aj+QZHEjPb6DpUfNFuVmmYs9dgI5bximnlSa7BCo7bqR5lZ7txRg42q6fK0eXzdes3Xxga1R+bfJZfAhLU9YJYtqZmNFlQ3U0wsikXoIvY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006617; c=relaxed/simple;
	bh=l4HKBfFYF4Pe0rUEUEAwk0cR6NocD/ZjQRKhB1UJ1lI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VKpIoW0ugP171sAHKrIcwsT/sUhO0EH6XhPyVgJQqhoJkBxR6T4vWpHXdIsrpqwsk+oZeVs4AbLb3AwCiKpxNwHKxKL8nckoKWgBsbOif51GzXBwM9Tq31I9Md7X7Cc/YR5NZlfR6oR5dA7Hm3bXtJGgl5E6Kb40TevudzRRhyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bFPSJdo0; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7c6b4222fe3so4052611a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006616; x=1726611416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cAvzQslJtfBcWM7NZQthMrKt0WkAdMSo8X/GFMOx7xk=;
        b=bFPSJdo00IAgsv3GxwppA2dScPfdEESteVKbLkruK88NO4vvAGr+DD0FVXXd1VH95q
         I3wwaDSCJs/n0FjrWQUi2iip1ZnPibBDx6HrGuSehumsUVSvbHmFoEha6iWQIA4XKkSJ
         zZck21JDLsV/UY/UWwBbLDShrL2Sbmj6NViFTqBm+pIMT20O1leFb0CPH0E5YuiSJ5E6
         YGOqPNr2PhZUEfbP28mdeK64nsKrdUI9NJx+HC+96Jm/7XVZpHFyz39TTafFycxKU6oG
         Hjn/5aqoRNanbySnmBm5xaqsIfB+W2GF8JBHRWD7LAccjX58Gr2rrBLtpvWDisYRPYEJ
         rk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006616; x=1726611416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cAvzQslJtfBcWM7NZQthMrKt0WkAdMSo8X/GFMOx7xk=;
        b=re0y1OQM+xLQfWfk8CPSwM2ufG0CdAG8SC/FQ/GL0QZM2SbO1nyLT/I8sRCF0DcdbL
         L/T80xjmJXnzJrmrRU5LIkbD01U6Xpj2BLK9y5hfjUeNRcLgVeAjkDbLO9jU9faTdO2q
         cekWbtibCATx+6uUUOTF8J+fdni0/szHOiNqkdDnmFDXuBCY2zwXt6lM/CHJjjO6qUcj
         /YLQD/8FB99IM0lSQAS09ec8eOpNCkwVwPAFvJ39orE8aDwijt1Qcp+4rOn3tSycOf6S
         8sRgR8TqPfvez8KuxW8Bt/9H0/DRdiUO3uhA18YQYJd4rZJVTpfktsgH9tvXJzyC6PL9
         YZfA==
X-Forwarded-Encrypted: i=1; AJvYcCVLVcPV23/d9awSvy1X6giFQIfyKFRAHkcIjKJjnIWcgwtCFWQ2SB0IWnxn/0h+3zny7yQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzO6DgnNa5EWZz/Uiba3zJkC6ojPWLnl158+Db2hRTw1a4bhe8
	ITqKYqf3/YLs3CCc9XbSxl013Q6E6hDIuONuh+9/CSmHiTTtBptcXzhEEjwlSMs=
X-Google-Smtp-Source: AGHT+IE5hbdWS6CdkvBpTkLF73V6YsXkK3hpqDmltB7qoc29jRaoBm1Er3LHFhYvvN88E1vHLvAbAQ==
X-Received: by 2002:a05:6a20:cf8c:b0:1cf:3a0a:ae45 with SMTP id adf61e73a8af0-1cf5e156d0fmr3746837637.35.1726006615860;
        Tue, 10 Sep 2024 15:16:55 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:55 -0700 (PDT)
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
Subject: [PATCH 19/39] hw/pci: replace assert(false) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:46 -0700
Message-Id: <20240910221606.1817478-20-pierrick.bouvier@linaro.org>
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
2.39.2


