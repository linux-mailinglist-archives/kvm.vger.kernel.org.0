Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864A66869F7
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 16:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjBAPUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 10:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjBAPUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 10:20:40 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB791619B
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 07:20:24 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id q10-20020a1cf30a000000b003db0edfdb74so2584710wmq.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 07:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xtQsA13TYlM+mmZKq9X5QpwAzWCUp9nY5OqJW5BvJSo=;
        b=V4mEjI+8F3GWC1TCXZpEOZ0CI26JRAa0F3GJUk/W6DP4KCMDu7cyfBCAufQXbIGjWZ
         tHLX2Xpk9quZ7ESXwv9ejpCLK9b30Wq2kGs/M0siK2nd3ttwKC6zmyHBHRtrWd9myvw+
         smY2/Ik8nVlMVR/FnRRm467qPNoKsvxeEMHI72Qb2a/fFpwQAq1LFmQrSsUEk1SZdYPd
         dWfvYResNkC0D+WDzP2zAYUg2WoNymUGZbxcuB6aM0myWLP5sOXgoTmZULWOcb/wW2cJ
         F8RVIUs7JW/reSiyi3zipC+MxNV1fhus3+uRU2yECF/F0F5CWQPnT6DDbLyXSAkWFmge
         m6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xtQsA13TYlM+mmZKq9X5QpwAzWCUp9nY5OqJW5BvJSo=;
        b=vdLAFEstjevRj1ufguDggsov27QsKIC8APax9GtqhZ+FEE0Al5U9Xlw6USdjVeHLnN
         I4DbFFKzSF/3RJym0RqOYK6zbpmD1iWtXaHRqFIHWiuJHa9tKno5hTPfyaOePjR/vFpx
         wGrxKeUBxZndr8SBRv7B3xeJpSGrf+1CCSmgMMcQFgMSiksNGVPiGnb7slKqaVyDeUJO
         z1FQ5S/2uzv65ZEGBMM0IsnLmG26e8YW0Y+LhmYxG6LPo2eXSLEndZ2SYk07oVdemThC
         lgdAGeJOKYkl3pU4PbT37y2VEua4zKceNKCN888Ukm+gp/mBbbpkT/WWH/ymPnWH26Ap
         pLuA==
X-Gm-Message-State: AO0yUKXpILQ+Rn1jJwmuRBJn5NrxXTTYUKLgpnggPghGEY5JIOUvGhfy
        s+SmTtXDdToSnM627n3c2oIKcA==
X-Google-Smtp-Source: AK7set9t1SgmvFnQjp4ReDU4prkBxyvzV48+Z/jCzTTH3kq298LLTJyBb6i4/+9FKg0INz7ZndYTgg==
X-Received: by 2002:a05:600c:198f:b0:3dc:4355:25f6 with SMTP id t15-20020a05600c198f00b003dc435525f6mr8076594wmq.26.1675264823357;
        Wed, 01 Feb 2023 07:20:23 -0800 (PST)
Received: from alvaro-dell.. (bzq-84-110-153-254.static-ip.bezeqint.net. [84.110.153.254])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c12ca00b003dc0cb5e3f1sm2022801wmd.46.2023.02.01.07.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 07:20:22 -0800 (PST)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, Alvaro Karsz <alvaro.karsz@solid-run.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain fails
Date:   Wed,  1 Feb 2023 17:20:18 +0200
Message-Id: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a print explaining why vhost_vdpa_alloc_domain failed if the device
is not IOMMU cache coherent capable.

Without this print, we have no hint why the operation failed.

For example:

$ virsh start <domain>
	error: Failed to start domain <domain>
	error: Unable to open '/dev/vhost-vdpa-<idx>' for vdpa device:
	       Unknown error 524

Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 drivers/vhost/vdpa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 23db92388393..56287506aa0d 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1151,8 +1151,11 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	if (!bus)
 		return -EFAULT;
 
-	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
+	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
+		dev_err(&v->dev,
+			"Failed to allocate domain, device is not IOMMU cache coherent capable\n");
 		return -ENOTSUPP;
+	}
 
 	v->domain = iommu_domain_alloc(bus);
 	if (!v->domain)
-- 
2.34.1

