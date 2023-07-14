Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3553E7542A8
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 20:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbjGNSiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 14:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbjGNSiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 14:38:05 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCF6C6;
        Fri, 14 Jul 2023 11:38:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-666ecf9a0ceso1576925b3a.2;
        Fri, 14 Jul 2023 11:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689359884; x=1691951884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rXrkXKhTz48jsZAdqqmCoAQFq3uNRK+HB8iei8TLbj0=;
        b=kcseM8nEMftNohp01XiTiCZW2/CK3yfRxth+b/U5yN91iRu5VCVYZ60pQpa8UaXj7i
         ozNO7SrfUm4HMEu5Rkb3O6YPQe7mYl0jNVIqUaHyIqgDTho1D1BKV5O4N9ThnWu+km5B
         4MH4+TKxDC80JLefpQ6UF53cRkk0qQZo7Gs91wZLuMXM9qlhXTr4caxT+MG/ZV0SF4hz
         g3HFp1RYe5ZhUECb0/VfORMw4E/eMsNSAhgoQ5uGuUD0gGpZKu6/WVk2At1HS7xTKfPz
         bbqVQvUrg+dK0EY/apVOx4y6ZPoPgD8KfHSSAOUqx/1RbpNKUMONHeB4zQ3pTbgswt3w
         pekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689359884; x=1691951884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXrkXKhTz48jsZAdqqmCoAQFq3uNRK+HB8iei8TLbj0=;
        b=b/Brt4LPcM8WbCJcQIApwTsxiuDl5FJWEhFRt9+3L2a/iBGCpFMBeDaVbolR0wbYEf
         xBXm+P38cCpjOCm8uc2DsF/w2qGk/e0IzDhypvLbNby/WqeI53flOVV7VrQAE8VrHzga
         zkluFdMdV53zQenWOKDg/h/xxGfKrYAnoj0DgZG8mtCrXU8kBf5oDoDUT5H8OhxrRfvG
         XGFpd3bUS/0+h4l0DsQrDR5YFLZ9yJCBYZBv1McnyOm46f5x3mewNQRi5ahUSm+cLP6Q
         OAygBCK2mr0wGqZysX95+SPTTkH8GJHyGGnmQCY9BUhbY/VlEvYt0rHddRVhi3r9eQf2
         oAFw==
X-Gm-Message-State: ABy/qLZV5iRXaxBZ9eX3pI0hjdBMN4g3zKggvFXsn0FP1ZnG10F43Ot0
        uZ0jxiqJWb21EHPeiLxcpR8=
X-Google-Smtp-Source: APBJJlGrR328rQN9cq0c7Le9Y/QfhQPSKMCT1KozLk711qR6r1IL9pgtFjRBRBIE7QqqVfcsBe3cxA==
X-Received: by 2002:a05:6a00:2445:b0:67a:31b7:456c with SMTP id d5-20020a056a00244500b0067a31b7456cmr5331346pfj.9.1689359884145;
        Fri, 14 Jul 2023 11:38:04 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:9d:2:fe13:1555:c84f:8fa3])
        by smtp.gmail.com with ESMTPSA id x22-20020aa793b6000000b006826c9e4397sm7495835pff.48.2023.07.14.11.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 11:38:03 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] kvm/vfio: ensure kvg instance stays around in kvm_vfio_group_add()
Date:   Fri, 14 Jul 2023 11:37:56 -0700
Message-ID: <20230714183800.3112449-1-dmitry.torokhov@gmail.com>
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
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

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

