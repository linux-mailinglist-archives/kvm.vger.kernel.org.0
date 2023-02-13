Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9AC693C4F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjBMCbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjBMCbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:31:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA8CFF33
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6F1ytG82HghmM9+Be+OnSoaHtAltN0OwlcsGh3hnda0=;
        b=W1PhqLM1ld5Au25+SBe9Jy3shWjGGCKJUNEbHyyYvvSXN7+Ka35YGX8yLGNX0C2Muy3wBL
        rFZjlrs780fozeLhIel+qdimG/DpxSuEQrARxrQ1XZxGQlRc8l6reudJ+4Vox/gDrjtvBb
        rqTladoh/dBbs2gklcQbRw+omyRaotc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-75-FLWOelrANiK4J0qgQYRpEA-1; Sun, 12 Feb 2023 21:29:41 -0500
X-MC-Unique: FLWOelrANiK4J0qgQYRpEA-1
Received: by mail-wm1-f70.google.com with SMTP id o31-20020a05600c511f00b003dc53da325dso8356546wms.8
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6F1ytG82HghmM9+Be+OnSoaHtAltN0OwlcsGh3hnda0=;
        b=kBmomLDFYbvzn1TguyEGwdmmy2o1dwLGM+LBya27ZJ99FEOpuxyl38Rb7qpn71HI6+
         oXWbSLVYzIgREvvGJgFfgPIEmdUCB/ehOO/Tf5VrVFB1NV8+TnCHEac4f+gIsUEPMUCs
         jb+dGit55sQD/qc+X/V5h/TsxYHDruow05umg+uRwPv9GHjnHs2c7JqK0kbacyNZ87XH
         MtMgBGmxnV1mT7rE9F9ZP++dk1q5TMngZgClTs/CI9yceG+7+vB0FXjrCAKLB7qRuvB6
         CukgN5t+F2YOz6xpU408CtFfK649S7V0uE7y5sI2P7XE7K3GXj3KDy+BcXvBxEg0fT1X
         rDlw==
X-Gm-Message-State: AO0yUKVOVeW+SaELkM3L/nzvwrk2G36ZmoBwNxRpYq04h1fMFYcnrL6M
        ivyAONDclHLMYxxnz3gmoxY3HNngs19R8pwuMvhkAnPf3tmGXOqZGOdqKQPmMDtm4XQlRbwT7YU
        uvl8ZuwctMkY9
X-Received: by 2002:a5d:6b83:0:b0:2c5:52f9:8e9b with SMTP id n3-20020a5d6b83000000b002c552f98e9bmr2916187wrx.29.1676255380432;
        Sun, 12 Feb 2023 18:29:40 -0800 (PST)
X-Google-Smtp-Source: AK7set+w4tiiIr32cTPrOtsSdtBgrgswV6Foynst5WMlEHb8p54k7WY+DzrCcRZ8/v/aYqZB73LJYQ==
X-Received: by 2002:a5d:6b83:0:b0:2c5:52f9:8e9b with SMTP id n3-20020a5d6b83000000b002c552f98e9bmr2916177wrx.29.1676255380247;
        Sun, 12 Feb 2023 18:29:40 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d4cc5000000b002c558869934sm1603931wrt.81.2023.02.12.18.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:39 -0800 (PST)
From:   Xxx Xx <quintela@redhat.com>
X-Google-Original-From: Xxx Xx <xxx.xx@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 16/22] migration: Add a semaphore to count PONGs
Date:   Mon, 13 Feb 2023 03:29:05 +0100
Message-Id: <20230213022911.68490-17-xxx.xx@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213022911.68490-1-xxx.xx@gmail.com>
References: <20230213022911.68490-1-xxx.xx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

This is mostly useless, but useful for us to know whether the main channel
is correctly established without changing the migration protocol.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.h | 6 ++++++
 migration/migration.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/migration/migration.h b/migration/migration.h
index c351872360..4cb1cb6fa8 100644
--- a/migration/migration.h
+++ b/migration/migration.h
@@ -276,6 +276,12 @@ struct MigrationState {
          */
         bool          rp_thread_created;
         QemuSemaphore rp_sem;
+        /*
+         * We post to this when we got one PONG from dest. So far it's an
+         * easy way to know the main channel has successfully established
+         * on dest QEMU.
+         */
+        QemuSemaphore rp_pong_acks;
     } rp_state;
 
     double mbps;
diff --git a/migration/migration.c b/migration/migration.c
index fb0ecf5649..a2e362541d 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -3025,6 +3025,7 @@ retry:
         case MIG_RP_MSG_PONG:
             tmp32 = ldl_be_p(buf);
             trace_source_return_path_thread_pong(tmp32);
+            qemu_sem_post(&ms->rp_state.rp_pong_acks);
             break;
 
         case MIG_RP_MSG_REQ_PAGES:
@@ -4524,6 +4525,7 @@ static void migration_instance_finalize(Object *obj)
     qemu_sem_destroy(&ms->postcopy_pause_sem);
     qemu_sem_destroy(&ms->postcopy_pause_rp_sem);
     qemu_sem_destroy(&ms->rp_state.rp_sem);
+    qemu_sem_destroy(&ms->rp_state.rp_pong_acks);
     qemu_sem_destroy(&ms->postcopy_qemufile_src_sem);
     error_free(ms->error);
 }
@@ -4570,6 +4572,7 @@ static void migration_instance_init(Object *obj)
     qemu_sem_init(&ms->postcopy_pause_sem, 0);
     qemu_sem_init(&ms->postcopy_pause_rp_sem, 0);
     qemu_sem_init(&ms->rp_state.rp_sem, 0);
+    qemu_sem_init(&ms->rp_state.rp_pong_acks, 0);
     qemu_sem_init(&ms->rate_limit_sem, 0);
     qemu_sem_init(&ms->wait_unplug_sem, 0);
     qemu_sem_init(&ms->postcopy_qemufile_src_sem, 0);
-- 
2.39.1

