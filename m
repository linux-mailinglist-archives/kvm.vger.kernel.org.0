Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD0458922C
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 20:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbiHCSXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 14:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbiHCSXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 14:23:34 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F80C6402
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 11:23:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q6-20020a17090a1b0600b001f558bbb924so387006pjq.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 11:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=YQIObxgEKoiOHzKfKo2AOIGfQ9Eupxnu81toWwxoZR4=;
        b=QeMfWWZncT1VWOX8Gvcg1x8qqYdPHVwfF2K5uiXxur+fewrj/KVIsLcAxh8mMB+IH2
         DxXBrmpwbAXNhoGQ4KhITnOjleIbwpvfPmRng4XexmbU9Of4oQ1vWFdHT+cl7KtDqvu2
         GK7opw+mxhaYJxS4CmtiMTkmZItZoNLl2MNDYCCmt3qVg1qRNpM12fi6h57SJVUhRiYb
         2EsjGEmEFdKRaFfCdoxnq39ob05gSGCqzg55xwoCSevdUuVC/4P1BWu/H+ZWxMuzT4cq
         SeX99TTrEEBFtsd1Qtg8FhLIY6P0rtCgmrQjlaQH9PzVaYtQwuc8FVLbvvOzdf3y1rIv
         7QCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=YQIObxgEKoiOHzKfKo2AOIGfQ9Eupxnu81toWwxoZR4=;
        b=gf2ksiAxCKo+t6I4ghAvQvcdFGmk5DqqYtLeNhSuawWdT/jo+Gmy8J6kXEUpkwrokx
         AMsXjMz5r9VTDGHsRAuuYLUVbIXPaFZO+qLxBwAHhbBCSD7U9Wz6HAVdM58wbiyFkrv4
         2OyIJdHxaTkOMyAPzguhCWPgnWIDpibI0BowJx1qnT1uxynL6DQd30joJB5a7y40AYSL
         rGY4EFnUmIlRmevBMx4D7ZmvldVu6+CPxK0cocm9zm2ZryO+x763SwT3D0+cAkf+bxfP
         cgaWOcLY/htGL5cizVd0cUrkzH8tZLDYQ9qi0PbGu3lqupMmlE4LyxPmVl7qwhVM0SDA
         NXxw==
X-Gm-Message-State: ACgBeo0lT5738E5gm7RLStC4uzgp52rh43ZJtipK6BCXEhjSyyaTIjNO
        YgMvz1Ti8rLqTofY41DdDZpdOgpq1GkeYuW5ez1Hm/8U+YiIbZ8OqPOVWMBd1RZp/aEKIQoDlbS
        BO0fD7Yv2H+l7WIod1Yg77tnI7HgbpXQ6SNRWd0IxUd27VJfvUrrE2rde4xXhPlc=
X-Google-Smtp-Source: AA6agR4FwE9hS4KohCiAsjYwbvYrx4JkPYgmajmF2QzZT1bykc75fpeD1HwhmcfUtOiW9J97fyaVFCpay2hpxQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7e47:b0:16c:7115:84d6 with SMTP
 id a7-20020a1709027e4700b0016c711584d6mr27971478pln.93.1659551011679; Wed, 03
 Aug 2022 11:23:31 -0700 (PDT)
Date:   Wed,  3 Aug 2022 11:23:25 -0700
Message-Id: <20220803182328.2438598-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [kvm-unit-tests PATCH v2 0/3] arm: pmu: Fixes for bare metal
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
- added some isb()'s as suggested by Alexandru.
- fixed a couple of confusing comments (Alexandru).
- check for overflow in the low counter in the interrupt_overflow test (Marc).

Thanks!
Ricardo

Ricardo Koller (3):
  arm: pmu: Add missing isb()'s after sys register writing
  arm: pmu: Reset the pmu registers before starting some tests
  arm: pmu: Check for overflow in the low counter in chained counters
    tests

 arm/pmu.c | 55 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 17 deletions(-)

-- 
2.37.1.455.g008518b4e5-goog

