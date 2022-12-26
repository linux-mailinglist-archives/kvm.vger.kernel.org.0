Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC3D6560F8
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 08:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiLZHyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 02:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiLZHyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 02:54:33 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB8D132
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 23:54:31 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 17so10218351pll.0
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 23:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w8zH1fR9Stg0Yi/nA8lQcAgTB4aNXmQ0BHpixBovr9c=;
        b=f2tlDMpmsPea0qvWqYYTkIx/tF3mgqvnlKM6X/EzlHn0Nc7bbeivHpcyJex/3aNDW2
         HKovvdj76IA9OqqoJqdM6Q2v4Hh/ZoTQQMFlpMc6LXILyXMWDTG8pCaabOTk97WE6K6f
         sxrzvu63Sqqm0YEy3XA6O1PRoGui4tkKWMIC7Cz1qmofiE5jDzG2UZv8fBrGIcu6UCfv
         aPmZEJatvMtlr9xw8cQWsEElAl5Tf9J1UJLswypwjxL9FycFnDlNfd5r/pNOjqahSFSm
         PCCkxmxY1wA5v/JXAW7+0Ji09MMnACKe/buxLujb5jLtgQlxzi8Hvr1zyoiWHzmgK+aY
         x3hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w8zH1fR9Stg0Yi/nA8lQcAgTB4aNXmQ0BHpixBovr9c=;
        b=3hiy8LCOfgoFQzadFeoAtqrlO3K69XScFiatJtn9d/bjP1PbvtinI91Yhn6Yev5z2w
         ScyZ1xMJlEZRnfqpEvfesJ66ntg1t8dwuwx1wyaBmJtwBzv8yGydmVSTPkeye+6VRhUZ
         XrI0VEAf0p8LphxhWEDtrLWwK6JtJ6xNzJ23cyrMlymi2o2kSS9zeKWhNvU7cH+dJyQQ
         48Mikrh4hP0De2mieoU4e6XYDoVLJX2NwnDGrKHCMKoA8S83yJ0L4M/ka6ltFxasIX+6
         9anhIRTO9TeX0dmJx+bU5MI07KBdte69mg30ZOoZs0QP8SBxNBEQisRyFksWHTeHBqoh
         v7Cw==
X-Gm-Message-State: AFqh2koE47+oEt8K2GITzBgugd7zTrct4AzyOllJiMmgkXDOW9b5UREx
        PMjYYzub1fYsfv9mEdDJi64=
X-Google-Smtp-Source: AMrXdXvUjCsLcBQieJWGCThb1pXYTLIoDg2h21Oc5tuV8RuZvfKX/2lzzt/wOBKwmhTk64GtaT+ENg==
X-Received: by 2002:a05:6a20:4b1e:b0:a3:dc4e:74f9 with SMTP id fp30-20020a056a204b1e00b000a3dc4e74f9mr21557911pzb.19.1672041271222;
        Sun, 25 Dec 2022 23:54:31 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a125-20020a621a83000000b00575467891besm6289271pfa.136.2022.12.25.23.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Dec 2022 23:54:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] x86/pmu: Add TSX testcase and fix force_emulation_prefix
Date:   Mon, 26 Dec 2022 15:54:10 +0800
Message-Id: <20221226075412.61167-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have adopted a test-driven development approach for vPMU's features,
and these two fixes below cover the paths for at least two corner use cases.

Like Xu (2):
  x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
  x86/pmu: Wrap the written counter value with gp_counter_width

 x86/pmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

-- 
2.39.0

