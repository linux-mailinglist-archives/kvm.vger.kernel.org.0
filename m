Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D99E52C1C0
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241167AbiERR7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiERR7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:59:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650EF8BD29
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o7-20020a256b47000000b0064ddc3bea70so2363771ybm.4
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6El377MID7rCecykOPvAUGyvktASztEGQkNHsDo4H6Q=;
        b=JTvJ+pKPh0OV0kWy/CMIAehzpxr1kPLAluvEkkiTGTqb1w3iky98vPxfy4JpyAv15m
         hpxjGgsQiB3GvVjAm2TgBwam4CVhDSrwQ83XeJZEsIaezBOop/ufsUEHi3MUstSEowXA
         nlIp6Q9DzIKMYFWsUvAHwXZAVSfh4ZSyiSCf0SO774QCnOv3HzA+hprAWYzNDIRkl2VI
         LDJIZS2zYibH6SEjLL+5kqd2ZlG+yUswJ9ouj3uz5Vhn8rDaGN1bUgUyr84KmL3tVD1s
         Wu4qOkO54Wa27tIlq61/c86VJrQ83vfObBXPz/M2gfi+URn+b/Uaj/Mss7uq9WlLTpS4
         tJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6El377MID7rCecykOPvAUGyvktASztEGQkNHsDo4H6Q=;
        b=pdzy3hJyiTz1fHBEpHCwIy/wHWg8MA/2XgubsOfan+rZYsp/P8WTeB7D6A2djEcGDY
         5RzTAjYoTONn9uVg7e6gs/5blM6SQ0ByZXuDB/+kSCnHoD64D4BfugSPMspql+Hd2kzm
         2xjQyBEk8Y0FcKJ4K2XOIF8S3nYzW1SKthFMXptjDfFEsso6PGWlXS1qdd+vE2VYwFap
         YI+W8jZ7/z29oTjRKszok5xbuYKMZACPKYueIZPivgeJjmpoDiYIbnQ9yLg62dxYpbrC
         amLRgsFGVpYKGh8kP6ReRNJHmpseYAcIUXQruFw4WJUiqa+AzRqLcRQiAGGUd95MwEDC
         ezhg==
X-Gm-Message-State: AOAM532WcF6MGibFqgUhMDdV4Czp0ysucqT8CfJCkoBUk14lprU8E2Yh
        W5kYwIqusCLeGbY21+W+bqevnltukYkrdAl0jbvxrbOX8ifrld3X85YbQxk7SgrXd7mk9NQfbP0
        IKPgE50quGeKbfl5kz7D895WHSviz1hOKm7f+zL7gpGeFCyP1FcnDqeEAXg==
X-Google-Smtp-Source: ABdhPJzd/VIgYtDzCdo352e3DSjBzZ/3yJ+2/AXyM2iOJppq/zMlcRJgTF3VMNpFU0YSI03GqRoyktT5vNs=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:8387:0:b0:64d:ddc8:b481 with SMTP id
 t7-20020a258387000000b0064dddc8b481mr847547ybk.644.1652896748601; Wed, 18 May
 2022 10:59:08 -0700 (PDT)
Date:   Wed, 18 May 2022 17:58:06 +0000
Message-Id: <20220518175811.2758661-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 0/5] KVM: Clean up debugfs+stats init/destroy
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
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

The way that KVM handles debugfs init/destroy is somewhat sloppy. Even
though debugfs is stood up after kvm_create_vm(), it is torn down from
kvm_destroy_vm(). There exists a window where we need to tear down a VM
before debugfs is created, requiring delicate handling.

This series cleans up the debugfs lifecycle by fully tying it to the
VM's init/destroy pattern.

First two patches hoist some unrelated stats initialization to a more
appropriate place for kvm and kvm_vcpu.

Second two patches are the meat of the series, changing around the
initialization order to get an FD early and wiring in debugfs
initialization to kvm_create_vm().

Lastly, patch 5 is essentially a revert of Sean's fix [1] for a NULL deref
in debugfs, though I stopped short of an outright revert since that one
went to stable and is still entirely correct.

Applies cleanly to v5.18-rc5, since [1] is currently missing from
kvm/queue or kvm/next. Tested with KVM selftests and the reproducer
mentioned in [1] on an Intel Skylake machine.

[1] 5c697c367a66 ("KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref")

v1: http://lore.kernel.org/r/20220415201542.1496582-1-oupton@google.com

v1 -> v2:
 - Don't conflate debugfs+stats. Initialize stats_id outside of the
   context of debugfs (Sean)
 - Pass around the FD as a string to avoid subsequent KVM changes
   inappropriately using the FD (Sean)

Oliver Upton (5):
  KVM: Shove vm stats_id init into kvm_create_vm()
  KVM: Shove vcpu stats_id init into kvm_vcpu_init()
  KVM: Get an fd before creating the VM
  KVM: Actually create debugfs in kvm_create_vm()
  KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)

 virt/kvm/kvm_main.c | 96 +++++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 47 deletions(-)

-- 
2.36.1.124.g0e6072fb45-goog

