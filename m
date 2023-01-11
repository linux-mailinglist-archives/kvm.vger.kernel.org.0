Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136D46662D7
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjAKSeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAKSeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:34:12 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6882913F9E
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:34:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w9-20020a05690210c900b007b20e8d0c99so16878339ybu.0
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9KIwZTDSAmIppW3arQta89dBIMqNXF0skn62yduf4ZQ=;
        b=kV0DACr/rMJL2hpaEWN48WWzxdmEyQ0AC0c60/Ewbaxmpiq5TIs95p82ilfqdeC37y
         B2oI9ku51dzp4rQOImG6HlFD6HTrsAAF5NGk0kfv0Kahgs8FBxJzFLyoDao2N/SI4xRX
         d+zEQR3NkU9Vz77KEfcWoOW4RAjpHLaXicTtxJx8XxgYdrYZMJ46bxZInqvJh58NxSeV
         ntPbtTHhqOhYrVFkZw0ZygJw7NQWraxPLUPxTAFLd2X529uP5NiFygcpoDj9AxwiSMiw
         f8KjApR0+QuglrZZHB4zG65nPI9sa7DJfcPOjgFq2mtTLkxAslwKct+GeOUe44gD7XPV
         yqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9KIwZTDSAmIppW3arQta89dBIMqNXF0skn62yduf4ZQ=;
        b=we3R+mnEebGvsQKlcS6ze2+194MIci/GqMzZQKDDQ3cIs8YZZUjpmnPjdRZQ1/QMiJ
         kZroeAyNrZXJbVnInv62ZAZ5oXr8VeCR4JzJ+95pIAuJ1CMjxtthi/4VTzzrTplFyKPc
         MWZ25Ka6phHYaQB2Kc+gA8SKhCbp9G/kPitPQAiOQV2InT1VMR686FMnYrAwcgXzwb7U
         z8uZyv+vbt4sb/lzkuLH8Q7j9Fu1OLOyCe8YSZPh/rEM00jsgy8TMqNbwlo5gTU22CKD
         sjPOOU65mztKf3QwsbwbOYe8dx/irpIjn+Of7wgnTdvQCupr/6KTg/TxWq8cTPJdzXh+
         DN3Q==
X-Gm-Message-State: AFqh2krTFdtF398fz1tdfsnFREG+HH+PpudixU0op0t0S8NfhNLMkhOi
        BWZMVazATs4p0j91ES0lenm7oUSeIo/9
X-Google-Smtp-Source: AMrXdXvQBrek+QKvBaZd+mrabbLY7khNP7e9pQGNB6+CMZGEjPvfFHANzOZ3Aj+gMUE4UqCdKSimwoCRc0fK
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:cecb:0:b0:7c1:3a0:e48d with SMTP id
 x194-20020a25cecb000000b007c103a0e48dmr388967ybe.183.1673462050697; Wed, 11
 Jan 2023 10:34:10 -0800 (PST)
Date:   Wed, 11 Jan 2023 10:34:08 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230111183408.104491-1-vipinsh@google.com>
Subject: [Patch v2] KVM: selftests: Make reclaim_period_ms input always be positive
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

reclaim_period_ms use to be positive only but the commit 0001725d0f9b
("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
validation") incorrectly changed it to non-negative validation.

Change validation to allow only positive input.

Fixes: 0001725d0f9b ("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input validation")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reported-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---

v2:
- Added Fixes and Reviewed-by tags

v1: https://lore.kernel.org/lkml/20230110215203.4144627-1-vipinsh@google.com/

 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index ea0978f22db8..251794f83719 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -241,7 +241,7 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
 		switch (opt) {
 		case 'p':
-			reclaim_period_ms = atoi_non_negative("Reclaim period", optarg);
+			reclaim_period_ms = atoi_positive("Reclaim period", optarg);
 			break;
 		case 't':
 			token = atoi_paranoid(optarg);
-- 
2.39.0.314.g84b9a713c41-goog

