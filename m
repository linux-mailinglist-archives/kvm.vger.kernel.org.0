Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B367B2589
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjI1Sve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjI1Svd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:51:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37D7194
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c61aafab45so100067075ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 11:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695927091; x=1696531891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N8LynKKmEnAckUBXzlkQV+ARtJguVm/AuaVVOw51AIc=;
        b=GL8llhMEgp7nLyeuYn/Ta8/ixeNMnPvVo29CYxQrr74LjWCTVwUKKHqD6o0PpLnPJH
         fTHUMzmREnQQqIrdax6xL9425/do4H8yXGuzte88aYf7N6vxxO9dpUN6DJu/g/HMSZA2
         /hS1CqNDw73tOUxo6PtdhGC3eVceht45BcLLS1g/GwQ0vatrsVl4aVcWr+DpUZfBCAhq
         vxzyTT+MnVh6qmQ4/FepMiRn772A/mohCaUEO/oYwIo5T5QkJOpnIVF2e0WH4aIxkL0m
         CtDlTBQkYlgw7bRF32xcvII++izFEfWBhETpXS3BQUhn8CRcS62ywZS81OBy3OpfGgy7
         Xavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695927091; x=1696531891;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N8LynKKmEnAckUBXzlkQV+ARtJguVm/AuaVVOw51AIc=;
        b=ot2rScLsXCr4h5ivMf12XdxMizWSpBPc9foU1lu4yy758zRD8uo4/7+NSSG5MKmG4g
         JauUVp4aa7Ulv0V3ZHuXETpc4kLv2LrmBOTxAzu5X9qu5JcqvhNINc82nkAmBwHuo2im
         GfaSRS0BxD6EbVL01CWg5x+4IbWLKHDSq9eXyWGjFCt82J/hRdcC4CNyq49WgaejwIMS
         uL4ZFdDvsZPkomBoNLjSzi/jHGIdJDB6VPknc1VAPBZtirxdTcK3TZrCttBTLZVDhlNj
         tdX7FmxR4Hqs5A071bnfrpKlqnni0GUvQTNNCmXN2Gaovo7m73mm3scGvjs3hipZrv03
         0z6g==
X-Gm-Message-State: AOJu0YwL72FDdmqxU5KdKsuZL9CqY613YDbDPhZ7LJsc+OuRriSHxyof
        ombuvdDrMf/QXvM3k4prBUAogMDg4Js+cEUh3dZDSKbLB3vAVv11s01gh0OC7aM+K4Sg7Gwz0IZ
        4ImeUAIfuFf2GpzVGiVQqpkh3r0V+XCqbrIau63oJ3bkToAt2iRPpkPFpObV0xEc=
X-Google-Smtp-Source: AGHT+IFxuvdkRelTNNA5WG25Z6vKh5tt8t9z/73TvdSIGswy6fpiBzhdV2foeuAsBgfxI6p0v6n6Jg/hqQQHSw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:d4cd:b0:1c7:217c:3e4b with SMTP
 id o13-20020a170902d4cd00b001c7217c3e4bmr28320plg.5.1695927091300; Thu, 28
 Sep 2023 11:51:31 -0700 (PDT)
Date:   Thu, 28 Sep 2023 11:51:25 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230928185128.824140-1-jmattson@google.com>
Subject: KVM: x86: Update HWCR virtualization
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
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

Allow HWCR.McStatusWrEn to be cleared once set, and allow
HWCR.TscFreqSel to be set from userspace.

v1 -> v2: KVM no longer sets HWCR.TscFreqSel
          HWCR.TscFreqSel can be cleared from userspace
          Selftest modified accordingly
v2 -> v3: kvm_set_msr_common() changes simplified

Jim Mattson (3):
  KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
  KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
  KVM: selftests: Test behavior of HWCR

 arch/x86/kvm/x86.c                            | 22 ++++++--
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/hwcr_msr_test.c      | 52 +++++++++++++++++++
 3 files changed, 71 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c

-- 
2.42.0.582.g8ccd20d70d-goog

