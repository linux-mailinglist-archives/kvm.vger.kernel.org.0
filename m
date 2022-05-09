Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCA452060A
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiEIUo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiEIUo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:26 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE6285AEF
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:31 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y19so18480934ljd.4
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i8qxP48vN9/zQM69jzAYoYPtnM1ANtvpA9KX5gEF4dE=;
        b=XoYRR8NWTCJWdLR/ofppYXQmWnFLz74I9aKa0f9JqjLZWjzvZMZr8gde2lWCLwXARM
         nMLVq6xPxOSM2wvYq2WllluzN7VDrz5pEiRyt9FV5/QEE44VxYanuXRkF23o2JPet7a9
         JyjJJQ2HFNorqXUitsGZIsoOhP5AwBz4AHVp9yWo5Oh7mPNbuwFn0Qsn8ZWTvnZdu1lE
         deoeQedfr4Ou8ccoSh8IdQshElC0ik03f7QIhpnAMXZ/UtvM9OUPxb+G6nXisReRQaEq
         mBwMs2+TuFVZgFZkFgnmQBNpQCpwan9qiNAv8W8r0knYXgogZ94KxNPlwfj0AuDxa1vj
         jnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i8qxP48vN9/zQM69jzAYoYPtnM1ANtvpA9KX5gEF4dE=;
        b=vmucVIVHXqXs54sKj8YTy2A/epVmAJtfPjpN3JoEN7OlqLAde4pIgDEadCxBp/B2I3
         GEQ/Tebkw7491gf2mVYtSSts7/5FkBMMCEn+vmiVvkVwwQcgu3ukdajjPuOOAfCaUtAM
         z8yj9NZjupvfQhVoT2gdUzzYKls3fiQu43T9urGJhlPE8GvDWF75E8EQjbFr4iGsXj+o
         zfWUjukKf71A4dErLlDpaEi1cdJBnu/jiyxAvcu/eM+1eedLZV4+XP2JBE6r1Rj9V0HM
         RIc8fUgKlm7HYbrQNbZ/MduGf0aJJ5JHwspmZ8FWT5/jXDPrH/m3n0CreHusCgH5lMKT
         xySg==
X-Gm-Message-State: AOAM531/erO9N7P00+u/pW563Sk64CIh/ZV553yYk2s36yGayQp7E7aw
        tAcViTTzs5jaqEiyt+Xs+QmufkMxjno=
X-Google-Smtp-Source: ABdhPJzBnNU2VRJ8pljIcvf/lkvRdZ5vzl5XY6Nfe8O6Tb418nFZKJF2CnYGjdjTu24G+SSqKPQznw==
X-Received: by 2002:a2e:a806:0:b0:250:84e5:723f with SMTP id l6-20020a2ea806000000b0025084e5723fmr11673557ljq.354.1652128829605;
        Mon, 09 May 2022 13:40:29 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:29 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 3/6] virtio: Use u32 instead of int in pci_data_in/out
Date:   Mon,  9 May 2022 23:39:37 +0300
Message-Id: <20220509203940.754644-4-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509203940.754644-1-martin.b.radev@gmail.com>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PCI access size type is changed from a signed type
to an unsigned type since the size is never expected to
be negative, and the type also matches the type in the
signature of virtio_pci__io_mmio_callback.
This change simplifies size checking in the next patch.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 virtio/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 2777d1c..bcb205a 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -116,7 +116,7 @@ static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 }
 
 static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *vdev,
-					 void *data, int size, unsigned long offset)
+					 void *data, u32 size, unsigned long offset)
 {
 	u32 config_offset;
 	struct virtio_pci *vpci = vdev->virtio;
@@ -146,7 +146,7 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 }
 
 static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev,
-				unsigned long offset, void *data, int size)
+				unsigned long offset, void *data, u32 size)
 {
 	bool ret = true;
 	struct virtio_pci *vpci;
@@ -211,7 +211,7 @@ static void update_msix_map(struct virtio_pci *vpci,
 }
 
 static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
-					  void *data, int size, unsigned long offset)
+					  void *data, u32 size, unsigned long offset)
 {
 	struct virtio_pci *vpci = vdev->virtio;
 	u32 config_offset, vec;
@@ -285,7 +285,7 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 }
 
 static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
-				 unsigned long offset, void *data, int size)
+				 unsigned long offset, void *data, u32 size)
 {
 	bool ret = true;
 	struct virtio_pci *vpci;
-- 
2.25.1

