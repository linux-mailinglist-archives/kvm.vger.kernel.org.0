Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6058A43D
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiHEAlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiHEAln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:41:43 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620F76FA02
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 17:41:42 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id n12-20020a634d4c000000b0041af8261e17so561827pgl.20
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 17:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=5EKWHCPcKyvB2oDUDYMnnI0e2YJH8ovBxDk66tsMekY=;
        b=RHtDQc8t2PlDEd10Af/hrqN3NkkFIZdVdAdRZAlzWPtEBOLrY0w9Zrntn+wo1iePNZ
         UOGW4olAVudsicWpDuyaHt5Wrhy5d8y1PmAVvEoaGxlU5Bt+Ug7QRxeG6QuGHm6vFbKS
         2/SS76WA9jAsRp/+wCmQdOPkitqTMIsUASzqhuy3FeHC/sRuQClGYJ1PUg627q4Fv81z
         NxZJNCPtaWAhw8pD7nXQhdODDAc3DRP4aJqZjhi+SdAttXMLUxBESRQ65dGTn3tJjbsC
         hWet9Xqd3rrDLXVa+C7WpNc/3NA25HPHc0luCbR9KE+dr9wisQG1kW+CkEBVr8NQu3Un
         NDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=5EKWHCPcKyvB2oDUDYMnnI0e2YJH8ovBxDk66tsMekY=;
        b=ypNojHNS8tTeIiXIjYr1Egb1C10G0pG3vx7+uyCikxAGhcg1ai1A7XGGREYVGvMeNG
         PmuTAFRNx9kxkFodDKphPDRA8dEe7RhBsjZuqSMXq6lmaP3Fows4m/YxZfaipyP6weM8
         CpzY1TTPOudGNn35JjLtXJR1dOSZHLfvUEKOoUKkTJfsGFmD6VLw6kltR5MwzM+EirkF
         VXqSLKUqQJBlh3nsW2JWx5bbaQ/LWMcNYYlTHaRujGedUHp8//LLNxKY+2RUIIDlsw1N
         nRRL07/+USwjuQlLJVZTcDpDoGc87mxC0z8C68e8pSjn+A2k0MDWBNIE9gS9y828NmIr
         XE5A==
X-Gm-Message-State: ACgBeo29c266rVOEtFKEWBBgLVNqBW9hIri0+9Jm2q4JSRk59jgzjWbd
        pl6ZgPsUT5GLO0tjCAqklqnSxQgcJgSfZbYmML8XhRhMrDvhwcc6x7q8ztYc+p3XUNmFoBv/xWt
        nhtw5zqEMRrX2GxpavALN+AnJjw3yxWduq0H12nrDPjG9nyRpNBbTLQhk5c8oGWo=
X-Google-Smtp-Source: AA6agR6h3dEWT9aFoo84cpRjtu2lZnpAGw3llM2UEFtFeHEEzpJtybi6cBjqn2qCSJla6v7dKPIYdo9p/lxvBw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:2449:b0:528:3a29:e79d with SMTP
 id d9-20020a056a00244900b005283a29e79dmr4497987pfj.39.1659660101707; Thu, 04
 Aug 2022 17:41:41 -0700 (PDT)
Date:   Thu,  4 Aug 2022 17:41:36 -0700
Message-Id: <20220805004139.990531-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
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

There are some tests that fail when running on bare metal (including a
passthrough prototype).  There are three issues with the tests.  The
first one is that there are some missing isb()'s between enabling event
counting and the actual counting. This wasn't an issue on KVM as
trapping on registers served as context synchronization events. The
second issue is that some tests assume that registers reset to 0.  And
finally, the third issue is that overflowing the low counter of a
chained event sets the overflow flag in PMVOS and some tests fail by
checking for it not being set.

Addressed all comments from the previous version:
https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
- adding missing isb() and fixed the commit message (Alexandru).
- fixed wording of a report() check (Andrew).

Thanks!
Ricardo

Ricardo Koller (3):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Check for overflow in the low counter in chained counters
    tests

 arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 17 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

