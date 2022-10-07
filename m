Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318C05F7B28
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJGQEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 12:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJGQEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 12:04:13 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45167FC1DD;
        Fri,  7 Oct 2022 09:04:12 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so4846116wme.5;
        Fri, 07 Oct 2022 09:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OPtUSMEix+fRpwdYcElVRudxvg5GYZKwPqnAK4RycWo=;
        b=EbkhtOk0uGCccWrnpZYwHHgVi0tLhcEONZE/qbJwRhXISnPmkpxBWy0oGM6VUS1qmM
         ZL6ArcsekkfPFBjfZ5yN32IDEW7NvA/89iYFQjoxTNsWYnzo/937AOCfZUDgTeF/qnv/
         BcN1bgr2vnp1Rn1b0VKZvcL4caQe1Z0mxrGpo3btoP+N6v6LLPU8San5ohvdrat0DySu
         RvOzAPnIimLmBoi1ewYyyCX/sU8Hd+5/JmmIZINYnDBc3jk5SeKIUyOcEMxD0I7WxZ7U
         4/9tmeiE6xdnYMB3OI1UNej3auySKVWc+AbLZJBmDHHq9jN1WreuJTefoad1jqxNQerk
         4l4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OPtUSMEix+fRpwdYcElVRudxvg5GYZKwPqnAK4RycWo=;
        b=ORslrM97eCn15OGEPRzENW8QKzUlW3kSCCUDI9OMKPDTYpginXI0HFhlekLvCYrHvm
         1c9Wmp9G0Q6iBisA6gE8Zb84LjxT5jE1fe9UxzooU83TwCYXsoJEBvfUtEwIkX9Szyx0
         Xzk/j4Zd2hI8A3mD3SxdqT1AldNnt76vJ2tJqJRDouQ5WeAfBQjlJV3SVVKlGaPLViNu
         +0D0KX+PmjnsxAKCTeLHRK/q+mc6vTXni4fv6rrVNyhPUZ1tn+g4Qt48471TDA4/UPhZ
         xh6KEIPeQeMLc8wkbjBukiGsMa4TfvuuKeNl2DVvALNO/qbwjliqNcx8x3x6pxt2Z4T+
         7LmQ==
X-Gm-Message-State: ACrzQf396RiyseQqk+6oHpOBNYq3eAQMi7WrMgEx76IhjJGO3DLLbQNn
        hqnnQLdYPU860g+nEL4oa0fERFe033KVHu7yR9tBdCZM/Yoxqw==
X-Google-Smtp-Source: AMsMyM7q9n4UFbGcLxTFFLVHIkYH47xy9NbAi3uzFCQB2XlIyPcd99m3lcoHXcgmGHggFAmsLh7Edjj1oEGSYbeuApg=
X-Received: by 2002:a05:600c:3511:b0:3b4:bb85:f1dd with SMTP id
 h17-20020a05600c351100b003b4bb85f1ddmr3935035wmq.42.1665158650879; Fri, 07
 Oct 2022 09:04:10 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Sat, 8 Oct 2022 00:00:41 +0800
Message-ID: <CAPm50a+aygp3T1mNjzGXtL2nyNm-mHFZ3YO8F7eO0gCxZDuQsA@mail.gmail.com>
Subject: [PATCH] kvm: x86: keep srcu writer side operation mutually exclusive
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

Synchronization operations on the writer side of SRCU should be
invoked within the mutex.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 8a7dbe2c469a..619151849980 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -602,9 +602,9 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm
*kvm, void __user *argp)

        mutex_lock(&kvm->lock);
        filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter, 1);
+       synchronize_srcu_expedited(&kvm->srcu);
        mutex_unlock(&kvm->lock);

-       synchronize_srcu_expedited(&kvm->srcu);
        r = 0;
 cleanup:
        kfree(filter);
--
2.27.0
