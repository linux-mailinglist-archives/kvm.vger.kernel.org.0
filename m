Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455417AE196
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 00:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjIYWPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 18:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjIYWPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 18:15:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DD0BC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-594e1154756so143891847b3.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695680116; x=1696284916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oyil3mE/xvuRRMfslZ2QiuyPcotmDhpwMTivlo6e+90=;
        b=DsuoFzUxFoibSqL00986DWRXzWqu0Qf1WJkr+Y5FDSAxLLr26XtWSUyLJKCLvo+ocF
         Kl74zh5SgcNbf5yvdK7anns3HSNMab1zHxTt+oAOwV58q90j9nw1z/kgtkSIHfuNBO9f
         m/ToeJOnlxJpLkl6CReOpbkXgG5ElD1XQhbv3XSYeFP7iP3r9/SK6YciqU5mUoR5/crH
         PTOX8r7rfIWMWy+l8LJ9dymyX4Rs9FwCjbNHQqtD7RoE3pIuMRxnu5WL0Oc+QWdKxBbA
         vziJQsEsNlvIqdrwF1KzjOpOoWN6MAN2Cn9Vo6/dFi1X9DsoGhb9PV+Z6tr2sV0HkTjK
         wOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695680116; x=1696284916;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oyil3mE/xvuRRMfslZ2QiuyPcotmDhpwMTivlo6e+90=;
        b=WLT5jRAiVd1h8NboQayNGUZYoHefPSoXILrLuyV/bEY3riR6F7Gol5Qmm2iTx603R9
         exRG0cY0+oFOrCKR31H/UBrjCDZsxVWJobuQTj22i+YrB/NeLfZXMGAfZK60zuCQ9yCp
         CPABsmUnkgO3MkxHqllFeBh8uGLMyA+OANBJgdkm22HuZuAYn1sF77ICyLbjHBCcF1Qy
         2z7IZSWmtDrxWOclhSRSh7B9+RA+r92m91Ty4sYNpdixkbK2sS3wbT1OHmH+Ag97RoXi
         bmapwqf0cyF8KKpJaGsI9yJyrVWa0FfAZ54h6AatcXqGnPRsjD14J5sv13wMqUDQLqVI
         arZg==
X-Gm-Message-State: AOJu0Yyk/q8vlyQremfI+BLyfdfkSpDHc6QxMxb2/uQODrLEd38BGjg+
        rZbESWoGe5Hc9vE2G3DRv/Q066CnKD6yZVfdMdfWbOqiUI2UHBTBy4RfSWwdZr0ji7qh/eR4lYS
        mqdd4N2c0q7+Z58t2lx1bxHX+i6egWeN6oySHJDLwjbxrbfs5HcmygB2IU0D52n4=
X-Google-Smtp-Source: AGHT+IE0gWM28ZXRnREcRbCUJrveXZXqWkoQ2n/QHfNcDTQYtdi0QZ+wJH/bxmCtYrZuwc1VWkXlTCckZQVc5Q==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:d78d:0:b0:d7a:6a4c:b657 with SMTP id
 o135-20020a25d78d000000b00d7a6a4cb657mr83823ybg.0.1695680116097; Mon, 25 Sep
 2023 15:15:16 -0700 (PDT)
Date:   Mon, 25 Sep 2023 15:15:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230925221512.3817538-1-jmattson@google.com>
Subject: [PATCH v2 0/3] KVM: x86: Update HWCR virtualization
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

Jim Mattson (3):
  KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
  KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
  KVM: selftests: Test behavior of HWCR

 arch/x86/kvm/x86.c                            | 23 ++++++--
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/hwcr_msr_test.c      | 52 +++++++++++++++++++
 3 files changed, 71 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
-- 
2.42.0.515.g380fc7ccd1-goog

