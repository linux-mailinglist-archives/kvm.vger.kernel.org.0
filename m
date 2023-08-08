Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6199774F49
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjHHXbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjHHXbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:31:35 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4361BC9
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:31:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bc0577257bso48334325ad.3
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691537495; x=1692142295;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCWDiaOK6oBwC1N/JsFyjgQDQveeX0EIpcqjh3sU/K4=;
        b=Inx83viYix2Se7Jb1ETomI+W1Zw6vezUhCgHSmdSAr8poGqBpfWExnh5zNfCaAJqXx
         Y0JBaPAPbfQLVyRAdZfMDAQ/y4UvdjF6bt0IlXWo5+AdxOZ17Mn4ODYEL4gKctWoF/iy
         rj9ApP11OCYcfsub/g94LJVrRjTnyl2LCnM2B+PJ9XviM5EWnO5fz0UAOBGGiZYek0SJ
         ZPJCjyNePTJiz2bnoiyUDkEYdeGPRraYeewj9cXixHHQlniuajeh4PF6gO03hIZQ4+9U
         APYuojQpT0AOdjAdd+GveUVCw3KTcfjkfTJ6+1777gSre8pX/ZW2MJ4pw7k4M3uEbfCK
         uqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691537495; x=1692142295;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCWDiaOK6oBwC1N/JsFyjgQDQveeX0EIpcqjh3sU/K4=;
        b=QI2yEz5jWfTIOWwJdc2Bpu0ziGphhDlDOjR0KMzvxdLnqVhuUX3Fa+trCoe+1uB6vg
         NZXnvUGPns9fYA1BClSiddriq5b2svjs73ziwPVX0hy3SPyyqYxMcCQ7Jko2q0U57FyE
         bT4pzged+RNuiJz2n0XSkKv1CfPZ3yToXF7wGDPb8kOewiTOJNmGXIHe7QfDC/iyYYhx
         DEaAXzNkQHtmwW35F+hORXbPTYmS4m9SU2kM2TpzHDvzZlgukS6k8osKQrbmjhW265mo
         sCnC8uUaD28kBUVuQDPVOc9IAfZfjAoxkgnCV7Vxh12VhyyruTIVN/fPTHxUibLZn1UA
         +eLg==
X-Gm-Message-State: AOJu0YzDh2FwEz3H7isakdPIaDYnXdwiPaVQqW3qnlzzlMPuQJW6Mllo
        FpH+upZRzETxaDkRH70LsdKAQC8keug=
X-Google-Smtp-Source: AGHT+IEYe9W78Lc1aySWyAogv3NS62l9pcCMEZluKPWhZv6PBdp2VIj2SJrkcEpHJjSQrmepgKOEmtnBLTI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d485:b0:1b7:c803:4818 with SMTP id
 c5-20020a170902d48500b001b7c8034818mr22359plg.0.1691537494674; Tue, 08 Aug
 2023 16:31:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  8 Aug 2023 16:31:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808233132.2499764-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Set pCPU during IRTE update if vCPU is running
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dengqiao . joey" <dengqiao.joey@bytedance.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug where KVM doesn't set the pCPU affinity for running vCPUs when
updating IRTE routing.  Not setting the pCPU means the IOMMU will signal
the wrong pCPU's doorbell until the vCPU goes through a put+load cycle.

I waffled for far too long between making this one patch or two.  Moving
the lock doesn't make all that much sense as a standalone patch, but in the
end, I decided that isolating the locking change would be useful in the
unlikely event that it breaks something.  If anyone feels strongly about
making this a single patch, I have no objection to squashing these together.

Sean Christopherson (2):
  KVM: SVM: Take and hold ir_list_lock when updating vCPU's Physical ID
    entry
  KVM: SVM: Set target pCPU during IRTE update if target vCPU is running

 arch/x86/kvm/svm/avic.c | 59 +++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 8 deletions(-)


base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.41.0.640.ga95def55d0-goog

