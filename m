Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81502754519
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 00:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjGNWpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 18:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjGNWpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 18:45:45 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2162C30FD;
        Fri, 14 Jul 2023 15:45:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6687466137bso1683694b3a.0;
        Fri, 14 Jul 2023 15:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689374743; x=1691966743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rt6PphGaSWp2+mm0gUhqAdDTRb1FCdl8+rMRxrEr5H4=;
        b=qeXTqgmpFTwkVy7IzpfccXoIuiWbJ+4Kj3ma4pXJvymox8TVb4aGcn+KOlAktvNMpS
         SS9fQggp18ftKGAA0c/s1oxcBq0AfhgzY4K/iWmz/cRpX7nEuOCBEbdS1RMUx0DEYGSD
         f6EutV7cd4XrwJAY+oDY/oUyUQuPraGXdlBun1/8cHhX4JiHv9ijqzIcdevq08yfxZGh
         9sFqq9A8F98lZ5hTCUXO17abPfcb5KMtfXvz2lOrV2UoUTgvJ9r4YKFImjDZgFOBsv2v
         YoZ50gE8Acv1vQAWXPszif7967EejGuJBEbD4BTygV5435Lw+wHSpNjTSQ1uAHqY1Kf8
         o+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689374743; x=1691966743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rt6PphGaSWp2+mm0gUhqAdDTRb1FCdl8+rMRxrEr5H4=;
        b=U9pLRldbdX/8vu7SCOs4nv7Nv2hOcGvXQdjuN9Bcf5HKdQvG9vzzkaxsJpNCOpMcjN
         QOXnSFG8+d96+Co9SSA/C0w4u9wTzTjcg5iFiC9y/cFFPmR3b5WUqpPUHQ4XpsHNJvvZ
         9nVK1P67JKEb91Nren7/G0zH0JbgPUN1fb89cm/fz9pCWIvwhZlUp9hHeenJLAR5b5TV
         p0RYTNDZJwrSrIt3xMwrwjgt1xBu5k4R01oOge7zjk7Y0VpO5wEVAkBgS+51INojYqGe
         wF99xplWFAZHChg8weJKw7PkV4jGZk/Yt3q/psztRPnwbHFgqbVnxJ9mlhxsOKUNygE/
         b/GA==
X-Gm-Message-State: ABy/qLY6LjURe45Gg0OG0K3TL+AB22JGaU/UH5th1620gO6q923gjUHC
        TfbrcPm1/6IKmoUQn2SY4RVUxiZ98+U=
X-Google-Smtp-Source: APBJJlGknl8/FXvmcINYtf3ns7KY0s8LBYD4T+UAw9SqbCkDqRWjjWyk0G4jwTBF9omW5JwwTDt51w==
X-Received: by 2002:a05:6a20:12cd:b0:133:5110:344c with SMTP id v13-20020a056a2012cd00b001335110344cmr5429857pzg.8.1689374742554;
        Fri, 14 Jul 2023 15:45:42 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:fe13:1555:c84f:8fa3])
        by smtp.gmail.com with ESMTPSA id jm23-20020a17090304d700b001b9de2b905asm8246120plb.231.2023.07.14.15.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 15:45:42 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] kvm/vfio: ensure kvg instance stays around in kvm_vfio_group_add()
Date:   Fri, 14 Jul 2023 15:45:32 -0700
Message-ID: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
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

kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
dropping kv->lock. If we race group addition and deletion calls, kvg
instance may get freed by the time we get around to calling
kvm_vfio_file_set_kvm().

Previous iterations of the code did not reference kvg->file outside of
the critical section, but used a temporary variable. Still, they had
similar problem of the file reference being owned by kvg structure and
potential for kvm_vfio_group_del() dropping it before
kvm_vfio_group_add() had a chance to complete.

Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
of kv->lock. We already call it while holding the same lock when vfio
group is being deleted, so it should be safe here as well.

Fixes: 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when group add/delete")
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v3: added Alex's reviewed-by

v2: updated commit description with the correct "Fixes" tag (per Alex),
    expanded commit description to mention issues with the earlier
    implementation of kvm_vfio_group_add().

 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9584eb57e0ed..cd46d7ef98d6 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -179,10 +179,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	list_add_tail(&kvg->node, &kv->group_list);
 
 	kvm_arch_start_assignment(dev->kvm);
+	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
-- 
2.41.0.255.g8b1d071c50-goog

