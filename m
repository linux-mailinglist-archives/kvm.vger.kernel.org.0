Return-Path: <kvm+bounces-27123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65CE197C36F
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23DCF283A62
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70A21CD2C;
	Thu, 19 Sep 2024 04:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J4l9/fnN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB1C1BDDB
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721213; cv=none; b=ov/BHF/Y624PcjHh043x3D0trbe9sSBBSv8axWkkeYWt/TjZXt+Mbgm+Ih9jpOW60hJDHnSmdKT8hDaOOst3m7bfhLukPb4ZoR5BP0B+GX3pVtkSfZD43OUOzjdG1msN8isIDHWFRoyMfLD7zRYteSRrsDgoAv7LfY+bd9S87Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721213; c=relaxed/simple;
	bh=FClGeodaFTPTQ/kJ4c+VnhoYNpE0LBA7sz54iVx7eK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HwI1Wk4drPOvZJBfh/pVv7VFzHjiOheoqN0qaQJ0xMTLsdt65zhjWtwl9GNsISuG24JIoyfzva81wbCMjn24BsEDQLSCzb39k3E/jio2CQXG1w0rWIBOykZeuQMdeGh3ETt7TN3gwNhJ/rR1fAajdjKL0EHHW7glLGeinoKFUB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J4l9/fnN; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7198de684a7so264976b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721211; x=1727326011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OThPa8+cW/n1sVdbzQjJCeNQGruzF8/uwJ+qJfwzSeE=;
        b=J4l9/fnNxwR+7A9jtDp2bURYNyJbHWOwNAQGj/ltTScvfwE4lIv/2mnQN42RHSnjIN
         Qg1S3NwXmgswjlR0pXDMQQvTW568eUWXa/KqJ01g1NxLS/gsf/1OwqQuE2e9scfyJLnh
         OSkwqETqp6YyLmfJHOKS4zG88FCyJfZZ6RyDD+spMcrTts7NsKHCb7nn9he1uLsypUAe
         cWfF2TpaEjpoznmMBryScxGa/QX0o6ARv5h5kKuiivJ4gcaKIpYRkhc3Dd4ajkO5Zyld
         iq+T8Ch6/l9qPl954nr4cEMVAAHkuupCzIGtnzdsxxRTtQKECIkWaL3MtF8SHxg/4TpH
         Sckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721211; x=1727326011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OThPa8+cW/n1sVdbzQjJCeNQGruzF8/uwJ+qJfwzSeE=;
        b=O9Q4JRpAfB+a1w2IXtaAL573bqVxBVvyOKEHjSk54o21jbcNSNJSHPGdVv9X2K08bb
         vnkPgmEEpzRWddQwt0dXqsw9aWS/gcCbgUpmPWywp5/CVstw7HGE9ZmuFBHO0gQGYtkp
         IV+aw/9eUIkqtvnjOBSqDKHQNbxGQLazEDIeQQuEgwfInbMvCFt+n/whV1Wv6+E9kncT
         Q30KnugBMMDI+TJpdZAKZVWxuT5DvCv6uAxNdNlIDjbWguaYXcBUffxJRTH4C3zlcm4n
         QBw3YiPEoswbEMAQHKIAh5dcc8W3jyld+l/7MJ5srPvPxFEW4MIQFLHrBTkFYQxdVNC/
         NTMg==
X-Forwarded-Encrypted: i=1; AJvYcCUP8CnQAcaBHodGaRRF8kb08OzMXGyGCUS2CFvFc+0xR2z8G3NlNlcj6PWS3406rqIxmek=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSBrzyem8SUHllG+7cCUo8809yNQEQcV2IfB/3dLVFdiTGxaRn
	nmceJ4V0wUJ6wGUMugH/ve/1vaFc+7aAftVAaxBEjCJsgOy4l3J4HWaslUHTnL8=
X-Google-Smtp-Source: AGHT+IFQfcPKl3bpJHPW6gITFiRun3OBAH2WiwA3N0tnHOExmulwzhVj1BKzCqzynDuxHz8GGaT99w==
X-Received: by 2002:a05:6a20:b40a:b0:1cf:3838:1ec5 with SMTP id adf61e73a8af0-1cf75c7ea5cmr35256921637.5.1726721210847;
        Wed, 18 Sep 2024 21:46:50 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:46:50 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 02/34] hw/arm: replace assert(0) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:09 -0700
Message-Id: <20240919044641.386068-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
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
 hw/arm/highbank.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/highbank.c b/hw/arm/highbank.c
index 6915eb63c75..f103921d495 100644
--- a/hw/arm/highbank.c
+++ b/hw/arm/highbank.c
@@ -199,7 +199,7 @@ static void calxeda_init(MachineState *machine, enum cxmachines machine_id)
         machine->cpu_type = ARM_CPU_TYPE_NAME("cortex-a15");
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 
     for (n = 0; n < smp_cpus; n++) {
-- 
2.39.5


