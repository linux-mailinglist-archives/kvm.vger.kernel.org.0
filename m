Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33165F7B21
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 18:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJGQC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJGQCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 12:02:25 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25514356F3;
        Fri,  7 Oct 2022 09:02:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r13so7923299wrj.11;
        Fri, 07 Oct 2022 09:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=po/oN5HFpqnBdAJFURXFvTa4T51++kEb3bw93327DOg=;
        b=VhUskPVRTblLyWlpoS+ZID4TvpdluyglWYv31hMnzAA++21UVOjddsr6eyb2DG4fVV
         jcpu76zifZfXTRu34hpjk9D6yzjvtBWlQYhFXK5OrMcdlDiGoezJKZqqf/TFn1nI6V+7
         EIEtCuQRVn1TcwF+Dr2WN/utDuSA+LCgrOCleqe5KtRhf+fg6WpFYIayhEl86NqDyFSk
         MmyudGCkY8i6s1UBRvTAq8HN48OoK+BCGU9SNQzvs1opQnbvNO3ioxwKksjz1XSdnpBs
         X8S+FadySdYAo6x0bxA+zOxqj9cxvTn4swIe4dGyZPYi0HrlaLBpIEgIt7H6/4AMWzNe
         guVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=po/oN5HFpqnBdAJFURXFvTa4T51++kEb3bw93327DOg=;
        b=NZyyaskhKSft1LAdMrlz/qI8Wpk6uhO9/eMkjC21qfSOS7+84trbWjQ4L2GSMsjUX1
         Z4U2muyBVBbMTnK08m2ISWQbuweQEjk2B5WSWAbuDEnbd54OAeMaSWoSAYFLxZYopcBC
         wi8UIlQRnS5x4AvMsVKCgDWybE05lzf5CHA3vPba68WQIqOfpODgnGvEBh01Cij+b9gU
         B6I3sR4GztCysMpwoGsTIKprbgM3UZU80KrI3SKDsfh2BsqoWpNKfBx3owBPgsIW/HB0
         CRQPcnJMCjzHD57avVgICluEycU5vsEpas4ckv9mbxjtbv0mgl5SfnbOlaKprVOt/HHp
         UqgA==
X-Gm-Message-State: ACrzQf08h53NVynK5h+l9KQnCPyL8Atw9XUAGoCmUt4jsOpHXVQHsvmr
        YDtvxTMPz8tGLx4qlSNywjTWImqUuWYhy8JphE0=
X-Google-Smtp-Source: AMsMyM6mz1ONPhCHIkBRD9h6UegH5WOyFSdZp8vaXbryG6d7uSFqeWSoHH8ou3qFLctLd2jtzFVH0BK5wrE+oGVqE1I=
X-Received: by 2002:a5d:6181:0:b0:22e:3db0:67a2 with SMTP id
 j1-20020a5d6181000000b0022e3db067a2mr3841262wru.257.1665158542588; Fri, 07
 Oct 2022 09:02:22 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Fri, 7 Oct 2022 23:58:53 +0800
Message-ID: <CAPm50aK9oe-m5QWfrFjzGx_vvNveA+U6-Fs3KD5+Zq5RZ+UhDg@mail.gmail.com>
Subject: [PATCH ] kvm: x86: Reduce unnecessary function call
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

kvm->lock is held very close to mutex_is_locked(kvm->lock).
Do not need to call mutex_is_locked.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..8a7dbe2c469a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -601,8 +601,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm
*kvm, void __user *argp)
        sort(&filter->events, filter->nevents, sizeof(__u64), cmp_u64, NULL);

        mutex_lock(&kvm->lock);
-       filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter,
-                                    mutex_is_locked(&kvm->lock));
+       filter = rcu_replace_pointer(kvm->arch.pmu_event_filter, filter, 1);
        mutex_unlock(&kvm->lock);

        synchronize_srcu_expedited(&kvm->srcu);
--
2.27.0
