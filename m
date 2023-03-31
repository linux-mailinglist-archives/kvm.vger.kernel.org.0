Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2AF6D21D8
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjCaN5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCaN5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:57:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8410D7AB1
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t10so89781260edd.12
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680271044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Dwt0l2FJYqA7xPsMrHS45HZJhQV6nI4mVTTR30QpYdw=;
        b=Z+Sp/AgjeMJ/pE/6ceFq6ZA4Tgm9jwnpftFtQAF4PfxBbZhECh9WOCql65nRbpJiST
         QdJPSTtJNkW4n8TXQWj4/PIkbyfkjHZY7Hqav3lXlThfqub1wVdtsJ5XUBnQihDTcpZV
         lYOzDm3i8SjvCd/cbDkDi60wbho/MJWxhyCluJWsRRZsUKL3SccU4Osh02adSi5XiQVH
         1aCEMtD4XxsNDEP6Llxd4fzWfxEotulrpLITZuT1tuS5TtqY/AuwR8kRWCaaARmDmcbm
         MqWZf1Aq1PHz/YjPdRt65RLb4VprpYEiaPZSA7Z0ZV1NyxzPWA5DQ9uu2icHsy2VCJd/
         AS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dwt0l2FJYqA7xPsMrHS45HZJhQV6nI4mVTTR30QpYdw=;
        b=EP8+X7Up3io62rdfh+VG08p5Yv/ps46iSE1AOgN+byj9nfomLpgoXKb6KCtk7+IabH
         0B4CAp4jqLa7oNdIbMcMfuL/m8qzMCHaoHH45l9yzm2VWUktMfpBUZ55Z2utcDS2e+CM
         OW7GLCvonyiel45QJn31aHk40s6vkSIdc8KPOXOZExv3gmMWDk4UnyUOS6wnYse2Osgy
         YWEaHAEzX+hxsSAA3XYy7lwWCqxqv4GantYTHB3/5E56qCXiI38XGAuMcHUS1a4cTdvT
         3etuUNe4VReiU+be6tvrKodfAr8yMkF746WSMfD6ceALwZF9hLXPJvlP1plU8GaYyK9G
         NZPA==
X-Gm-Message-State: AAQBX9eZ5ywCVMOu+2QuRQMPrPWNsRm6DvdoQSHgK8BxRaDweMbq7GBQ
        pwbng5LcZvvw+aU4J13wsuP96uUq0OUE2AXmwApkfQ==
X-Google-Smtp-Source: AKy350YbHocI0xNqdnVI8taKgnFS0AVuDGP/7g9HnNpnrgCSOaBWU9QTj4MfQbuMZofCUktnI1oS0g==
X-Received: by 2002:a17:907:d12:b0:8de:e66a:ece9 with SMTP id gn18-20020a1709070d1200b008dee66aece9mr33818753ejc.24.1680271043766;
        Fri, 31 Mar 2023 06:57:23 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af1a510052e55a748e5a73cd.dip0.t-ipconnect.de. [2003:f6:af1a:5100:52e5:5a74:8e5a:73cd])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00928de86245fsm996888ejb.135.2023.03.31.06.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:57:23 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 0/4] Tests for CR0.WP=0/1 r/o write access
Date:   Fri, 31 Mar 2023 15:57:05 +0200
Message-Id: <20230331135709.132713-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds explicit tests that verify a page fault will occur for
attempts to write to an r/o page while CR0.WP is 1 as well as access is
granted when CR0.WP is 0.

There are existing tests already, e.g. in pks.c, pku.c, smap.c or even
access.c that implicitly test this. However, they all either explicitly
(via INVLPG) or implicitly (via CR3 reload) flush the TLB before doing
the access which might lead to false positives if the access succeeded
before, e.g. because CR0.WP was 0 before.

Better to have an explicit test, especially to back up the changes of
[1] which were missing the emulator case, initially.

Please apply!

Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/

Mathias Krause (4):
  x86: Use existing CR0.WP / CR4.SMEP bit definitions
  x86/access: CR0.WP toggling write to r/o data test
  x86/access: Forced emulation support
  x86/access: Try emulation for CR0.WP test as well

 x86/access.c | 120 +++++++++++++++++++++++++++++++++++++++++++++------
 x86/pks.c    |   5 +--
 x86/pku.c    |   5 +--
 3 files changed, 110 insertions(+), 20 deletions(-)

-- 
2.39.2

