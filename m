Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64DB5A2F3A
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbiHZStN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345299AbiHZSsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:48:32 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFEFE86BC
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:45:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z22-20020a630a56000000b0041b98176de9so1213220pgk.15
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=ybKUjgg6ch0GYw6EETwzWzCbbwkxj1dVORCeP7ssStQ=;
        b=bhdBMEDzmkep7dAIdCuBqStPdNwlsq4AV2zkIiFFXbPVDlm46CrTBdBALQLBVEhgtc
         g35/2jujy3+oZbNteXe+2HRA3wsitfCWoc9f3qMlgOr7RRJm9UsRtFhalkjq/1eTp0Sc
         +d8CmSax4UEaJWeCXHtFN3FFcgx8GklKf9T9yRr8nuyCUUIcsYdan/duqFkIYd1Jh9LH
         xeL5hBxRXYML7vrQk3v8TsgvgUdmKvv/0h3sWnrFdrQXptMlCY/fWBHfK6YJoIOqbj6I
         vGpVaXscpsFrK3stnZj8usGtgx8LbqcIsTYK/iwFLeJAg7kIG3x3opMd3o88b3zpNROg
         wkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ybKUjgg6ch0GYw6EETwzWzCbbwkxj1dVORCeP7ssStQ=;
        b=hYDjX4VwNL2WeXmgUJ3vgDlmf6mly4aMHf7g330zXHE7W9X1GoOVGDZzSvyT9Pyjiy
         PvUrA4Cy6QvMorfA8uhSyK0QGt3C36qIFqncfdB52Vop7QYIcrDKNUS//qKgsbpbZK2V
         UcScRjBtCFM6dZFjZX+3mI2Fu2eFl8xI0e09RBYNyjlH2QiQnXaipV56I7Ont75HkbvH
         dfPUyRg7cS+2JOioVtdAdftp5VCqpkVWmtc/DmpUwKRuREUKxwuNSU6rphtUQk/+qjl1
         rgfZtAx3VB/PaWleqt0STomZwlVYTDp/nZ7W/8AYqNh2ctXBzvSu30uwD5sQ07MMthxs
         gfXQ==
X-Gm-Message-State: ACgBeo2Qqs8n+nJsMLmmOBqWvwgjHvB8/k0q0sNByZzNZQubDQSALgMX
        Y1zN+dXOJPmNeQDWs2C1l6cgmSPQEzPB
X-Google-Smtp-Source: AA6agR40C4F/nP90aB06KBuicRVB8I2AEbMJTiexNJ65vSnFWjzRvwni2isMe6nRr7wWNlzAB4A19RsNV660
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:9ac5:0:b0:537:e34f:c09c with SMTP id
 x5-20020aa79ac5000000b00537e34fc09cmr897487pfp.63.1661539545151; Fri, 26 Aug
 2022 11:45:45 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:44:57 -0700
In-Reply-To: <20220826184500.1940077-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20220826184500.1940077-1-vipinsh@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826184500.1940077-2-vipinsh@google.com>
Subject: [PATCH v3 1/4] KVM: selftests: Explicitly set variables based on
 options in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Variable set via -g are also indirectly set by -e option by omitting
break statement. Set them explicitly so that movement of switch-case
statements does not unintentionally break features.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..a03db7f9f4c0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -411,6 +411,8 @@ int main(int argc, char *argv[])
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
+			dirty_log_manual_caps = 0;
+			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
 			break;
-- 
2.37.2.672.g94769d06f0-goog

