Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2867542AA
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 20:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbjGNSiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 14:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbjGNSiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 14:38:07 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134A5C6;
        Fri, 14 Jul 2023 11:38:06 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6687096c6ddso1603697b3a.0;
        Fri, 14 Jul 2023 11:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689359885; x=1691951885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD1dmN3bxDEdqDV+1dZ8LEKWyvqtOlq6ch3S0J+D7iY=;
        b=Z7FpuoydhgqAmHf73LcguYqA5qA5ASCNrjUnKLxxMGD2br9qhdf60OZUlzdk5bwB/Q
         L7QXX3uoqk4351djA8kGBsv+YBrmdWBvIrQlq8uTuIOnYhaTBXNefByNPDnqBzoywAqK
         7WCXT57wh3+zyE1HFQ0utQrBoxrkEOxQiCW/nAHJWAsQHEraK6jaVXfgG4mhVHigJBor
         HKCFv7ZaUxbBIvwQpRCgy1ok9FjU8yx7s/vSYaN3rTdXdkKsbcExtsWu1nv+EbXMt0Y4
         LDfr3L7xnxGjIJjpMw7/piZqHG0CtdjB22TQ9gjd8+zKJ9VHEA9a88rarWbdcA25rMpO
         mOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689359885; x=1691951885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BD1dmN3bxDEdqDV+1dZ8LEKWyvqtOlq6ch3S0J+D7iY=;
        b=RPk9a1f19ina6hVhaB1ZS2QmmpYHVDsWGpm/2c0bpSXdkTx6ac1Iap2RoNcK5Lvhs4
         xW6gHTqo1gSp/uldCpytHyS46FQm2gK9trJxqb86NmaBF0k0RZKQb/l1j/2HAv2d7d44
         +VR8eGkxeSJHpHJDMuVMzjanD3RqAWTGEvTvZcgc3BjCuyWFTqd9zu1xb/g651MgD7fq
         PTbxB+Yhh0fpBuhgHSVAqwuhYGdFGTWcUW15k3+c310YorF0Lo4Lha5H1jP68w96wKtx
         iOas6m9s0bDrHEdki3HH3pVIEykiaIBCeYlnYGujVX9Bl6bhi1bCgMx79cX96k/3+Pk9
         yIJw==
X-Gm-Message-State: ABy/qLY2Lnad0TACFesD26LD1J4n9iGN1TzasxtePpxHtP9VX2PUxRXY
        VbRkXGdsgl5Un6JioBF2ArU=
X-Google-Smtp-Source: APBJJlErbfdn7wiFeBwdLAW+5VE6qt4tti9MKFeExPcd0lNLSku4vhbvMFT7G2yoETMTB3miuEPsQg==
X-Received: by 2002:a05:6a00:1914:b0:66a:365c:a0e6 with SMTP id y20-20020a056a00191400b0066a365ca0e6mr5350387pfi.13.1689359885202;
        Fri, 14 Jul 2023 11:38:05 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:fe13:1555:c84f:8fa3])
        by smtp.gmail.com with ESMTPSA id x22-20020aa793b6000000b006826c9e4397sm7495835pff.48.2023.07.14.11.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 11:38:04 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] kvm/vfio: avoid bouncing the mutex when adding and deleting groups
Date:   Fri, 14 Jul 2023 11:37:57 -0700
Message-ID: <20230714183800.3112449-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
In-Reply-To: <20230714183800.3112449-1-dmitry.torokhov@gmail.com>
References: <20230714183800.3112449-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v2: new patch.

 virt/kvm/vfio.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index cd46d7ef98d6..9868e7ccb5fb 100644
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
@@ -157,7 +153,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	/* Ensure the FD is a vfio group FD.*/
 	if (!kvm_vfio_file_is_group(filp)) {
 		ret = -EINVAL;
-		goto err_fput;
+		goto out_fput;
 	}
 
 	mutex_lock(&kv->lock);
@@ -165,30 +161,27 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
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
+	ret = 0;
+out_unlock:
 	mutex_unlock(&kv->lock);
-err_fput:
+out_fput:
 	fput(filp);
 	return ret;
 }
@@ -224,12 +217,12 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
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

