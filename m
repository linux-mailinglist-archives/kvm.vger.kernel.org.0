Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480E96AD384
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 01:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCGAzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 19:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjCGAzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 19:55:53 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090D34D625
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:55:53 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z19-20020a056a001d9300b005d8fe305d8bso6398198pfw.22
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 16:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678150552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwyOZObRLYb6tuk6PR7L2PNoNFObpjWwxfEZdLgVaPA=;
        b=dwJkE5pk0hfUG61DLaX2Y06PM4FQTc+Y4cdw51qunbNLfZhdqAHO7Fyu2C6o+XPlOI
         aESNyE6UJFFjj/+KFfh/f4+3LQ27fCyvSZdnPnndyV8AKLBoK2DUiqo/Hw9IruUouUvM
         ed5bEFe367h5UeMc21PhHDC/KSDfQ/zF5tT4h6L24iHS7BNsVJn8cUsC4t1Fx3f7OGfZ
         qUDgHxRcPWwa1p1EKnQFvSXGedVjTy4diSdd1wKWQpLcXo3w799e91PWWXLI2JRJec6B
         D4rCW2ASpqMwJj2Y2iipWRWzON81qX/91e7Ag9E1MPERzj46aMjsl31RWLSne2jTSWUm
         Y+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678150552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwyOZObRLYb6tuk6PR7L2PNoNFObpjWwxfEZdLgVaPA=;
        b=4kwj782qs2Aab/+vvQGTd1JvKwWkAFZEOKIkNLVS1NtdRDaCKg9S8WdzQji6CeCsIw
         X6w60gQmQi+cyochBBEXwSyb0Stmdv1vWzJ+LV3vXyYuoqfVwO1Rx6a4zCIops19wwDh
         QaHW7oPi0DD1kLhGMgfucgfnbIcR6NdOGJ7AYdsFH4MvoxdiWDhAroFVPYI8ZhSF/Grt
         3XyPwYgQkKwh8/P02E3RPoSB0yxHRuiXxQyxTgk0n8pRrsi1Bq4kSTr2E9zEvlty4FYE
         aWyZeHhtSXQa0xtQAMoVCJeqRJkmasqvdK6fKbhMnWJu5a8THf1HzA9ZyfnaUUkbRh1E
         X/qA==
X-Gm-Message-State: AO0yUKXw+tEz6mgAhpclZG+3qw9jX7Vzrdl0WRl2mcN0vl9O4PWYOvwy
        8BpRuAuzhGmXrY2gddwaynqwZ6r/ZQB8ag==
X-Google-Smtp-Source: AK7set8ZFaD5p31RQ9fgHeWlLtsjRWac0liLl8RdRdq54x2PW4vkp8f8v29azpwh3z4OgYrTnWn72WKrv5bn0g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:903:2606:b0:199:56f2:3fc4 with SMTP
 id jd6-20020a170903260600b0019956f23fc4mr5104205plb.8.1678150552522; Mon, 06
 Mar 2023 16:55:52 -0800 (PST)
Date:   Mon,  6 Mar 2023 16:55:46 -0800
In-Reply-To: <20230307005547.607353-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230307005547.607353-1-dmatlack@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307005547.607353-2-dmatlack@google.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: Run the tsc test with -cpu max
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Run the tsc test with -cpu max to enable RDPID testing. The current
configuration (-cpu kvm64,+rdtscp) does not include RDPID even if the
host supports. In effect, test_rdpid() never runs.

Use max instead of adding +rdpid to the existing configuration to avoid
this biting someone in the future if they add a test for a new feature.

Fixes: 10631a5bebd8 ("x86: tsc: add rdpid test")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f324e32d60ef..c4eaa8ef9bab 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -247,7 +247,7 @@ extra_params = -cpu Opteron_G1,vendor=AuthenticAMD
 
 [tsc]
 file = tsc.flat
-extra_params = -cpu kvm64,+rdtscp
+extra_params = -cpu max
 
 [tsc_adjust]
 file = tsc_adjust.flat
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

