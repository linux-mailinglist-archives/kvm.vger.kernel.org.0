Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AA768CB03
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBGAWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBGAV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:21:59 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9FB30B33
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 16:21:58 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id g12-20020a656ccc000000b004ee62dadb95so5813007pgw.9
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 16:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fr3xqRzLNYPURQh7ZU8Jus7/FUthEiow4VKsPMI3ES0=;
        b=ltr7A+qkkRfn6cuKgarkC/VuDPyW+dOumVtox9JdiPUdd6tafcq4rEY3Rrzp7qzmSu
         +Q8k5Wi3bgRY8uWDhOiqSqMo1Ma61+0XF+f7SQjvzG6NSzv7zWmBYCDyxOatI/07aXGH
         6SmgO751zuI3wRhhP3KCK1Ysvtl1ADTXu8FMjsgfF+bo7MbXU7MvbLrW8KOMHfIud6Vw
         MSWquT/lej2eOINeW+RgMCatqZg41zX/6Ys2YbuFp5Z3An2hcxkJukob4MGypx18LJVY
         LFBI5LSGslWicDSZEwfq23/Vj8RHKJz4jyhOB5w04DQZklcasKmaSfTFTx79EbPnQ+ox
         wS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fr3xqRzLNYPURQh7ZU8Jus7/FUthEiow4VKsPMI3ES0=;
        b=vd7AEpTMqKXjePRzcFfo+s71FyAkV4Yxkuf40/OXoG9S1BxW+kuRH6G6YNr/ukZaXT
         28Gnk0YsZscbOGtupcP65DcVtfcjAj4G2pD3gEwLBFnQ6T+h1pFzPyTxBCNcvIRf9h0U
         KW18MBvadso5NUhTK+fddD7rmtNl0rBR/9ekEoCBWtXMLvrK2UHm8RNlBf+DmCIvTRWx
         /lYGD+jMLkfwyGtJQmM7KJRHuaXuSZiKYfgWle+9MXK6dg/KLhKLkH7R46S5JeFTiyeM
         BAw4hAD0fu6d+c3iWQasoMTjg846C0r7NveyiyVvoACDNa7Fvf/Ul+9cbbB1U+ZrR+6G
         4k8g==
X-Gm-Message-State: AO0yUKWYjq8zCFOIsgB78OVonGCSS53O2qJa9DXUTANpW+wiMn24/xOW
        UDewE3Jrn5i/nEYs8RgSaJQ95aepuaY=
X-Google-Smtp-Source: AK7set9hS11jcWFxMrOQ2zHtZTFpvc8yNYjTNnwn6YFKC/buhPRwKHcOQoJ2uqDn+IeCANfnP0hht0mvegA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:53c6:0:b0:58d:a84a:190b with SMTP id
 h189-20020a6253c6000000b0058da84a190bmr285757pfb.48.1675729318448; Mon, 06
 Feb 2023 16:21:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Feb 2023 00:21:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207002156.521736-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: SVM: Fix GATag bug for >256 vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
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

Fix a bug in KVM's use of the GATag where it unintentionally drops a bit
from vCPU IDs greater than 255 and as a result wakes the wrong vCPU.

Suravee and/or Alejandro, can you give this proper testing?  It's compile
tested only at this point.  I'll do basic testing before officially
applying, but AFAIK I don't have access to x2AVIC hardware, nor do I have
a ready-to-go configuration to properly exercise this code.

Thanks!

Sean Christopherson (2):
  KVM: SVM: Fix a benign off-by-one bug in AVIC physical table mask
  KVM: SVM: WARN if GATag generation drops VM or vCPU ID information

Suravee Suthikulpanit (1):
  KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs

 arch/x86/include/asm/svm.h | 12 +++++++-----
 arch/x86/kvm/svm/avic.c    | 37 ++++++++++++++++++++++++++++---------
 2 files changed, 35 insertions(+), 14 deletions(-)


base-commit: 32e69f232db4ca11f26e5961daeff93906ce232f
-- 
2.39.1.519.gcb327c4b5f-goog

