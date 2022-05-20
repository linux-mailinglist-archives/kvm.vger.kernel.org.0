Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C094A52EE4B
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348416AbiETOhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiETOhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:37:12 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DC7170663
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:37:12 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id q128-20020a1c4386000000b003942fe15835so3226026wma.6
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ISCd8fERgz8UfcDL3ihSnOmimKD5sKsVTzAP8+00j/A=;
        b=VxQs5wpUjdFrPKDNdRzXLu5IaONkOCO5s20kjz2yqQ37jFlsEsETO2D+HDUgO4rgz4
         8HYTeTOUFdi/m0LtHgcVVHfAwci6HT9dCVPyF0BwomD+GxkeAFMEMMGX90GAN5nqn7tQ
         111vbojOBJSWLh5ni5YJVwDyFWsfbYH3Vh2CndX8cl72B9q0yK2egW+15GelBrFoyG0O
         RNB2gszVcASPBM17wCEPAoxqIhZRFcV8sulb6STb/bM6xShVhI30sxx2FLYda9C8NwFN
         0tf6X3MPZr4g5VH7SzmA2Q0XaoraM0xZefuorEmwjiGQSQcHp5YKlKoPqJkPbAv0BG+V
         WgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ISCd8fERgz8UfcDL3ihSnOmimKD5sKsVTzAP8+00j/A=;
        b=ZqT2/eDk0RdF13k607lihRZIED06TvDPQJ0WTuK4h3fykCzW+gIA3qViuSOLfUK4ah
         r0XuR5MfDSD8Ka4MB/Tniddc/HZu309Gn3B/LeF9C+2h4q3sX//zBZ/XudmBifdpVaKT
         4OmP184IUSgn4JqwiaPShTNn30gy0bHuDUw+VYzzFWvVRGWOx0Dc3tiQaD6XmtsyTV7p
         ctQCEUoCaNhsolMM8xOyGVtl0gf6Oqk7DFItIBPIaor2T1TkpjiW2nvZKpCNFWAXuo3d
         +lBOJQfE8o3NrVTqrW3JpqM4t5MtdIewtfdTEl63jgOQmYiS+QLRy//tyUI694rcLahm
         SyRg==
X-Gm-Message-State: AOAM530ksZ4qiRD9UrwMlRLahVkLcUYscpZMY1Gvz5C9zLsoc9v0VMUa
        ayE/i7D1h/wzEOfRla2f6bID48O/bMCNtd7+NrTTAEyO8/0B4V/yiGsHOTssauoYZTNDNcpemOz
        Wd1rcUK5BUwsjt/uwACGTP7p7SydEksSQT/MopI5RmECraB/KL34/7P4=
X-Google-Smtp-Source: ABdhPJyLxp4DCmYdgZ375rmdTJFT4PtT2oKZ2wbQYidD9mkyqmgBT4dhYEFN3vdiHXVuUYh7dhws3RnIdA==
X-Received: from keirf.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:29e7])
 (user=keirf job=sendgmr) by 2002:a5d:5952:0:b0:20d:9f7:ff5b with SMTP id
 e18-20020a5d5952000000b0020d09f7ff5bmr8530506wri.11.1653057430384; Fri, 20
 May 2022 07:37:10 -0700 (PDT)
Date:   Fri, 20 May 2022 14:37:04 +0000
Message-Id: <20220520143706.550169-1-keirf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH kvmtool 0/2] Fixes for virtio_balloon stats printing
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, Keir Fraser <keirf@google.com>
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

While playing with kvmtool's virtio_balloon device I found a couple of
niggling issues with the printing of memory stats. Please consider
these fairly trivial fixes.

Keir Fraser (2):
  virtio/balloon: Fix a crash when collecting stats
  stat: Add descriptions for new virtio_balloon stat types

 builtin-stat.c   | 17 ++++++++++++++++-
 virtio/balloon.c |  7 ++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

-- 
2.36.1.124.g0e6072fb45-goog

