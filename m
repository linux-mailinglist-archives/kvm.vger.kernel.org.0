Return-Path: <kvm+bounces-27140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7B297C38B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46AA2B22149
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF58B54278;
	Thu, 19 Sep 2024 04:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z2ec0F4T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B2208B8
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721246; cv=none; b=mgmDZwFqaOxnyVZ8bqxa7JGLHyn/jVDMPOuY41Bpu67uxMdqzV0/lqOp+jlpEOwNCEcjfxEQDoRvnbI8V2hJue1DimMraxy7OUQpn3xd2I0bG0HfJ991ENBXu/Fs25kfDGlzejWRnrKPqH5DXbXWPWa9FJktCo0gFDjUXzFwDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721246; c=relaxed/simple;
	bh=/YgPPDVBxt/OAJU/NmCCEhS4tA4WAYYnO4Wjhf5MEdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YGs4QVRc6kyaxQYRUfkcpNJzTxc7ndPSaI/2EUyiAQDbsCVFt2huTxvEY5q4RMNy10WmGFt6zYuos5Agbgbn3MwzEkcljlZp/vun4GZMBSzkJTgpKQwunu1PEwANSu/SogcfNIo97Ud55OYdhfzhWZ2iT5qNuxydP/K2+RLWNlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z2ec0F4T; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7197970e2aeso262675b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721244; x=1727326044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHltE5X3jHFpn43VYV0IEXfKWmPwceAvVFkYvY3AXAY=;
        b=Z2ec0F4To+xh1hR5JCYFZ9HWfgThXF/JHqSA3c6knNaJJsohcpWzQ0eyafkvimFWjb
         Pq5aQ/ablX2Cn9T2QID5ZvGmsEm4nnlX6erJf5/J4MUHmjdkSj2ADLWiwhaplmPWNh0A
         TJ027PUwiiGYovgyZ3QoTHxqa+MDxdYr8L8dycfnPPko/8dU2Lu+oODTFTk/qDrxZMRG
         ygKJ6lxtMW69onUbHvwsP5lN5XsMQi5NnHPmQFqcDCKoScGGio4BxtxeRz430Oohl2S8
         BcaeWBlEs+PAVr0AkbEquCNO2VaydBphjSbtJJ8SMPGMkBdhB8ikV/F4RI9tNn7PVHcf
         /sAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721244; x=1727326044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHltE5X3jHFpn43VYV0IEXfKWmPwceAvVFkYvY3AXAY=;
        b=oYYDQ3gKYdh1wYleNf9i1qvRfezHkhby3mSJ+JCjSpLr7RNtyp5L998Jn3YVw6eOIi
         LkiWciJwp+r1CxyOeP26tLdtAaEb4T5BqckZwSfDhRmn87v/hX8IluxbV+T8tWvN6m2+
         7ru1tY2e9fDBZv/8N9vuoVeSLzBDZhsRI+ZNWZvlCMY79oHWFEit77+/MjjMNU2g1Z9M
         rkspeOvZTjW33of0QUza3+xfriDIjKzlg/azI0f+KeoV6i/glVk/HI4s0usXnFiA/D99
         kmaKKrlQ1Egk5h2yQfaBWeLxddyfMi/D61BDU1SggPN6tV8GF49RqlxGui/l0rlfPXdg
         kxYA==
X-Forwarded-Encrypted: i=1; AJvYcCVbzoXkHIr61BrfXQDYUl84UX8wx2aNB+3VkjGf8Ba8GEJQ0zJHZHdIaEK4FlJRfCxe5t4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMp1s+new3MXDALKQIszogVFKTB8lLqN7ROD9VTfN0x211ruwV
	inLpfzA/afnG9r4mzjmdCbE6INskESmxe4kgB/r14dgSoU8Ohgu1Fg6Cp3Qo1BU=
X-Google-Smtp-Source: AGHT+IEr6T2O+sP6OWidgpOc/m8gapGLSSLw0H5w0hv1V3XRgPMEmphvXT69kJGdrAWtPBAoW9bd/w==
X-Received: by 2002:a05:6a20:1918:b0:1cf:37bd:b548 with SMTP id adf61e73a8af0-1d112e8bf2cmr21148987637.37.1726721244023;
        Wed, 18 Sep 2024 21:47:24 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:23 -0700 (PDT)
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
Subject: [PATCH v3 19/34] hw/scsi: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:26 -0700
Message-Id: <20240919044641.386068-20-pierrick.bouvier@linaro.org>
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
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
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
2.39.5


