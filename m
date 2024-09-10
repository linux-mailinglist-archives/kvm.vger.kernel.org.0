Return-Path: <kvm+bounces-26381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BAD49745B8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9975DB24CBB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6811AD3F6;
	Tue, 10 Sep 2024 22:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xunltBAS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA211ACDFA
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006676; cv=none; b=SX97RzpWYkLjGe6fTOvvStYimXCY19+8ZlMPeKSKvJGNZQuflauPr882QVsAiv2VidmYSocw7hWyAeqTBqCiL7hB4dn88XFDeGFT4wAvqVrJKwbOgag2PV5VlscBDwLw0/BqYfxIBRhu7OPV7vEbSR2u3BNuAoS9ZjoQ8ejru/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006676; c=relaxed/simple;
	bh=73+xArPtGdQhSgylSBc2A/P2chBiYYe704uXZtKsGCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AXFOTqZrQbfWTpzVXM2qdwv0RyFkoLlTksplijX1WAKExbkXsgeKnV5JNxkY0Jj64Cz9G/QTn9uoio0iTwYkJ7xAUF657Rxl4nyrmHwJBmr3Z9idjESYHqlaniUCALKHUCXsJ0FMreAWEQuyDSUgj36XwBJVdEX2gRN0A9rVtcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xunltBAS; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-718d91eef2eso193695b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006674; x=1726611474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y03z6l8DG3u8GECV91NkbxRNu0WgfcfSpqwz7VG8iPg=;
        b=xunltBASrpuHN196bfzBW49ZwkbWMQzQGNWuX9yums5K+S255FAmHBUF9pgJc59fje
         Mudz9hSshr8FctL5pV+5PFwcSmyGmuUN549SzaCeU0jr0OEAzRcODZyhIhpMyy5ED+Fx
         xM3yYDEoOJ723Pd0Ad4iRsRmkpFdgvoih2fEZzNUCjRmb7TiF2QpXwhRwY/7gWeMjGmv
         NXCqTUY4QX8BhQq8AX0AeVw6eNmLpwzzlWG2fhdYEB3jVd+t//XM/ZjGb7iaPjcD1tvq
         mF3T7T0aS8GRDEthK1GxrVesOuVJ2D9YyO9Lf1dXzCLVA17w4hWqWDYcXvd3fi1iNcB2
         I9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006674; x=1726611474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y03z6l8DG3u8GECV91NkbxRNu0WgfcfSpqwz7VG8iPg=;
        b=OPQONSwmZhm4DGirXWSOaPkNQ1nglhjV7runDEDikwTceYKVu8v+LtBm4D8fMxhIXG
         JVyQvCBxH5X9l20dnLcP9k3UgqQu6YyKqK5jkN3QxL5K6jnjTRxlCg5f/d9mqsAluV4E
         /ozbEQnbeC5bQDmtjnaTu74lmU5Nw5oHzRAxrrA01l7Ya+ejLaazACw9Dnmk7GQrf7hW
         c7XfkQTVelN+wIwEKN9qQXU/1U+SMOMrDHB1Feqn8vOczupVO/j/ettF+CWXCAwnc4Dx
         L5pmRKnn92D5AAXBKo5RQVTp2/cZTKFuDRF0GAORKzQ40R/m2XftOdVTTUr+x4cV7kkN
         CeJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKtZmE5fAbiQsPvWpIlkIQzVgtXVWAA4IY21FfdW5uZibPad2Kh9WthrTA4DqD9afBthY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzitr1POd1czLzoiJHBkx2NRKe92AkWiwXZHpEH+eDVEEA2yrcn
	FRxxj4XizCrsJjnuyjz5L/sTLj6vbM5zS8lBDwNe5mhLGZJbyPSLT8cQ3EstEto=
X-Google-Smtp-Source: AGHT+IEF2VwVmQZRrfJAA7uZ+UwAfLlPUUkIQKs4NFR64dug9ZAQdsOWBGZU7vtbJ2ZkWpCk8KGdug==
X-Received: by 2002:a05:6a00:6f0c:b0:70d:26cd:9741 with SMTP id d2e1a72fcca58-71907f29d40mr6083429b3a.12.1726006674179;
        Tue, 10 Sep 2024 15:17:54 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:52 -0700 (PDT)
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
Subject: [PATCH 31/39] hw/scsi: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:58 -0700
Message-Id: <20240910221606.1817478-32-pierrick.bouvier@linaro.org>
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
 hw/scsi/virtio-scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 9f02ceea099..6637cfeaf51 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -357,7 +357,6 @@ static void virtio_scsi_do_one_tmf_bh(VirtIOSCSIReq *req)
 
     default:
         g_assert_not_reached();
-        break;
     }
 
 out:
-- 
2.39.2


