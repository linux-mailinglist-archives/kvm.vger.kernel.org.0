Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FFF754518
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 00:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjGNWpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 18:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjGNWpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 18:45:45 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4238E30FF;
        Fri, 14 Jul 2023 15:45:44 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b89bc52cd1so13543685ad.1;
        Fri, 14 Jul 2023 15:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689374744; x=1691966744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzVDB954Kue2g3HPSB+wZhpBO153V/L/a3HbEYrcniU=;
        b=cw1yLVVgi2nnIfoPZ+Ov0pTORSpLanxDOLf3vaqC6CCadkpUhuzVo+F5031X5lvrSs
         +KxUcwR9CFvU2QgGetgEp/VgCyW8TtJTJ+02m5sz5MEMaqAvLxNBjI84CQ1WRf97mXqs
         eYuD673OVWbTzDZNkuEMfqXmUg6BZSec0MUbUUpjE3g8GZgQhoYoyMvJTvd+d170PLo0
         n91ZAQL+QTjhqcifxT0LjEpo1DZH04PhPhTwQy3QB3ao1kaa2MWpLssi/R8su724UtJu
         gK8G+qcPNuIi2oz34XSzmfBkTRuF5baQggMQznWP+Bg3bh9nbP7fgE5Q4dD2hj4YvsRu
         AHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689374744; x=1691966744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XzVDB954Kue2g3HPSB+wZhpBO153V/L/a3HbEYrcniU=;
        b=Iq5/WYwcUWarVGRtdKWElDUzZmfIF2Di63Bj86OxOXOWacUVEzWOReMVCxbSTnlO9x
         9MB8Ub3bxGmZ40wmM2RNi1GGiTkkonOKAx5swSf7INy4dsVS2sz/DwEmTX7wkSWqltfL
         KtUZZMEGY1otpbKDB0FS4gTAjPc0WbGW3t+xZjnNa21EBf7SvD2naLxre9bJwg4XqaEq
         1tRcd9e3xSBBj3cgXEW5s7URooK+3wlUE+rQC9hXkiSnI6szn8ZYSdqyl7goVCM01uD1
         EfgSFtdVDu7XCry0e5uh8KhCZG9a7t+I4EV91NvKa+2g23tkySnY2AcYFZlJO6dHXPle
         CY3A==
X-Gm-Message-State: ABy/qLY+Ikoy6BZ4nrE1gFl6tAcqAWRiekyOmYxgz1/BCjohm/Jg3kmV
        MckTGlOcf5O2rmeUOigTbaI=
X-Google-Smtp-Source: APBJJlEX7qycWfHg7JlfebRVWAwjG3NJB/gHHmmn3iULEWdiJnTMCvweb3f9K+1prN6oZQSKybH2Uw==
X-Received: by 2002:a17:903:24d:b0:1b7:e49f:39 with SMTP id j13-20020a170903024d00b001b7e49f0039mr5023368plh.60.1689374743450;
        Fri, 14 Jul 2023 15:45:43 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:fe13:1555:c84f:8fa3])
        by smtp.gmail.com with ESMTPSA id jm23-20020a17090304d700b001b9de2b905asm8246120plb.231.2023.07.14.15.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 15:45:43 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] kvm/vfio: avoid bouncing the mutex when adding and deleting groups
Date:   Fri, 14 Jul 2023 15:45:33 -0700
Message-ID: <20230714224538.404793-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
In-Reply-To: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
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

Stop taking kv->lock mutex in kvm_vfio_update_coherency() and instead
call it with this mutex held: the callers of the function usually
already have it taken (and released) before calling
kvm_vfio_update_coherency(). This avoid bouncing the lock up and down.

The exception is kvm_vfio_release() where we do not take the lock, but
it is being executed when the very last reference to kvm_device is being
dropped, so there are no concerns about concurrency.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v3: initialize "ret" with 0 (per Alex), added Alex's reviewed-by

v2: new patch.

 virt/kvm/vfio.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index cd46d7ef98d6..dbf2b855cf78 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -122,8 +122,6 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	bool noncoherent = false;
 	struct kvm_vfio_group *kvg;
 
-	mutex_lock(&kv->lock);
-
 	list_for_each_entry(kvg, &kv->group_list, node) {
 		if (!kvm_vfio_file_enforced_coherent(kvg->file)) {
 			noncoherent = true;
@@ -139,8 +137,6 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 		else
 			kvm_arch_unregister_noncoherent_dma(dev->kvm);
 	}
-
-	mutex_unlock(&kv->lock);
 }
 
 static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
@@ -148,7 +144,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	struct kvm_vfio *kv = dev->private;
 	struct kvm_vfio_group *kvg;
 	struct file *filp;
-	int ret;
+	int ret = 0;
 
 	filp = fget(fd);
 	if (!filp)
@@ -157,7 +153,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	/* Ensure the FD is a vfio group FD.*/
 	if (!kvm_vfio_file_is_group(filp)) {
 		ret = -EINVAL;
-		goto err_fput;
+		goto out_fput;
 	}
 
 	mutex_lock(&kv->lock);
@@ -165,30 +161,26 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	list_for_each_entry(kvg, &kv->group_list, node) {
 		if (kvg->file == filp) {
 			ret = -EEXIST;
-			goto err_unlock;
+			goto out_unlock;
 		}
 	}
 
 	kvg = kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
 	if (!kvg) {
 		ret = -ENOMEM;
-		goto err_unlock;
+		goto out_unlock;
 	}
 
-	kvg->file = filp;
+	kvg->file = get_file(filp);
 	list_add_tail(&kvg->node, &kv->group_list);
 
 	kvm_arch_start_assignment(dev->kvm);
 	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
-
-	mutex_unlock(&kv->lock);
-
 	kvm_vfio_update_coherency(dev);
 
-	return 0;
-err_unlock:
+out_unlock:
 	mutex_unlock(&kv->lock);
-err_fput:
+out_fput:
 	fput(filp);
 	return ret;
 }
@@ -224,12 +216,12 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		break;
 	}
 
+	kvm_vfio_update_coherency(dev);
+
 	mutex_unlock(&kv->lock);
 
 	fdput(f);
 
-	kvm_vfio_update_coherency(dev);
-
 	return ret;
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

