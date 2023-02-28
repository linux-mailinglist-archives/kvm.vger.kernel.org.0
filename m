Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADAA6A4FFF
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 01:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjB1AJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 19:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjB1AJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 19:09:12 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973F8206B3
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536c8bcae3bso174357257b3.2
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ThRlyK2TRciFJpwoRh/Qw221U35tcYFxOt/mGeu712I=;
        b=b1lAFnPEY8k0R+AOgYBQweBewiLrd/hpsxo3uJClmTxQ/zgqoDy+nKAWbOvaCuVrWl
         JRSqtFmRfknyJZuddBHxLHXR6e49nwO4nGOvP3lPmj6Z7+sh3HIwuSETehAbfyi7gTQj
         ssITcbNjFfyv/XdAPbxDUI663oWyr9LJjK5ClreOdQbR+W32WBc96js23Ljs6BY6aYJM
         vZJKBeBVhGia01vNngZwzNht573ICdahoa2HGeNrxNDXB6VWlr35EK0eIeuai2DK/7Rc
         THEHHaHn2D5/ZZp2TwLmhkP0Z9ExkR5clk03I6ub0pGv8wOm/p9tUlcwQxpxlXs2SSxX
         jY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ThRlyK2TRciFJpwoRh/Qw221U35tcYFxOt/mGeu712I=;
        b=KPgaDmj8lXIMf2h90gu4IsVjajy9fMZOSlojUmS73LV3qpt6zcvjHUBN4jUyy6qQZa
         esBLhjXTrCnSClYg3AGraNhNLYqMvRGGQCAbflhkSY1F66naHAan5NO1OfAIQ4+Rn13L
         mIJuy3cSanI795Sgw2bu8A5c2qX5VmSliadHRRetJWxGqHc0qM2HiUhwNNBGP4VNGeXM
         zCJYCNdqtZfrEvpUzZ5x/Z3otWzqFww6E8YK3Ze5VDZaYnwb+H++SfKswa/gyTxJScvN
         GMdUnwPRWG/ZIbNXfJNpM1R5W5jnFSvPQW/OULx4mw0qy+oN1+bqu3FXBCCXMjaughk/
         5T9w==
X-Gm-Message-State: AO0yUKXSVNOevcXu71A+ce/RbI/lygk28P4L0ETfXrEDvC5T6cgA75KD
        gLe8IDLscRYxhIERx7d6sHXR0bexwubol5ZysM9rsBzeqf+NB8xVPv/FywRQWLZkH3uhnuaymhd
        NYcTuGILQcIFr8mznZOtUUkuAGzzY6c6rpg89Y5e82416XzDm8K35wdLZrXY87med4bzt
X-Google-Smtp-Source: AK7set9jWws/aKQ9/5TcNFB4W5X+lNVJnQ1fpwlItiDwx357sNhZkceynH+Bn5XVToeFYTROEFolUSDgl/h9Mpvf
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a5b:a10:0:b0:87a:957b:fd67 with SMTP id
 k16-20020a5b0a10000000b0087a957bfd67mr295202ybq.10.1677542927529; Mon, 27 Feb
 2023 16:08:47 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:06:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228000644.3204402-1-aaronlewis@google.com>
Subject: [PATCH v2 0/5] Fix "Instructions Retired" from incorrectly counting
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

This series fixes an issue with the PMU event "Instructions Retired"
(0xc0), then tests the fix to verify it works.  Running the test
updates without the fix will result in a failed test.

v1 -> v2:
 - Add pmc_is_allowed() as common helper [Sean]
 - Split test into multiple commits [Sean]
 - Add macros for counting and not counting [Sean]
 - Removed un-needed pr_info [Sean]

Aaron Lewis (5):
  KVM: x86/pmu: Prevent the PMU from counting disallowed events
  KVM: selftests: Add a common helper to the guest
  KVM: selftests: Add helpers for PMC asserts
  KVM: selftests: Fixup test asserts
  KVM: selftests: Test the PMU event "Instructions retired"

 arch/x86/kvm/pmu.c                            |  13 +-
 .../kvm/x86_64/pmu_event_filter_test.c        | 146 ++++++++++++------
 2 files changed, 108 insertions(+), 51 deletions(-)

-- 
2.39.2.722.g9855ee24e9-goog

