Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98A502FAA
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343608AbiDOUST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242982AbiDOUSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:18:18 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1194E3B034
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:49 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id i2-20020a056e021d0200b002cac9b3b46cso5334926ila.5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9FEtUWKx+jphKdai+Rp2uioW/ZHVheKLPC89q22tzsc=;
        b=Ia2prrOuMo8E4ej+5ebM8MCOcw2khDI0xymxCXYNulU85xTjQT9/ZYEFzJbSRVtIGN
         VOmeAi7QgzWaBxcAZHTE+upqyjwb1z3VUydvWbtsaLu5j5n1T9bb6bi+y7bdgML91prA
         RAZuaEdMHkyD0ZuQunuLtPzLVhy2z92TX3w1AHc/cIqlCGxvpgKUbXAl80GnMOJ+6Mti
         JkFw1BdsigCLagwzDnUf+qtvgeXKU81aHyMHyILrL7WBYKgN1Fw1lTcST1aeq6dz9i1W
         SYTcc4qI3GyhUS3z+GDkDtUTLj53gEpXrLP6G0PFkyZ5fYYIcYEko2G+eFviY1rl4OK6
         ItqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9FEtUWKx+jphKdai+Rp2uioW/ZHVheKLPC89q22tzsc=;
        b=rV1mmLAMY1CGBJurYAUhje/+USPQ8vmER1h4vfDCIniCiv+I+JdilS0JYyTtM3KD4V
         rIRXdtILQp43f/qwl2TvO1dYFtJbFNcj89IWmtNusn4CbOMrvHyaX3a3hDEdJKU6Or4Z
         assGrgV/fEUAQ/du1whCBSdWhO+7W356xwZf+O8JBBO5mCYVTOLXiaNToGAAJKgiPIi5
         bWbFuIAWDZitZpqX4tfnFgarf3rcEcHPjBBHvrT5qfo+HZ/78TJDdP2jpnll45CTMg3e
         tnPBO5ji2NkWdPz0gB8sD8FusuBv6X4xC7CwutmuO1Vteax7hrsis2BZ3lBBr7CgfAXS
         Gz0A==
X-Gm-Message-State: AOAM532Fshqfe7yn/fBmZ42qiJhWD9lmFzqkSTF+oSPrqn9zwZS513+/
        468p56DGssOXxjSek2eKBfBveJ11XspR9jx9sxkrl+wcDBGRNfI+FYHOsRnSR6KWvQLStDf7orL
        4DxlghTOivU9I6Ock6ibfQgKDzYe9X1vzIf4v1lTq93MwurS6jqKpGkOB3w==
X-Google-Smtp-Source: ABdhPJzx/4hwblQAR749ExzODOxK0dX/HxA+qya+X0VJSnHK5uaWEvVwq7oFwO5VZCQROLOHizOkjc8mM28=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:1490:b0:323:6863:fd0f with SMTP id
 j16-20020a056638149000b003236863fd0fmr320995jak.20.1650053748331; Fri, 15 Apr
 2022 13:15:48 -0700 (PDT)
Date:   Fri, 15 Apr 2022 20:15:37 +0000
Message-Id: <20220415201542.1496582-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 0/5] KVM: Clean up debugfs+stats init/destroy
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The way KVM handles debugfs initialization and destruction is somewhat
sloppy. Although the debugfs + stats bits get initialized *after*
kvm_create_vm(), they are torn down from kvm_destroy_vm(). And yes,
there is a window where we could theoretically destroy a VM before
debugfs is ever instantiated.

This series does away with the mess by coupling debugfs+stats to the
overall VM create/destroy pattern. We already fail the VM creation if
kvm_create_vm_debugfs() fails, so there really isn't a need to do these
separately in the first place.

The first two patches hoist some unrelated tidbits of stats state into
the debugfs constructors just so its all handled under one roof.

The second two patches realize the the intention of the series, changing
the initialization order so we can get an FD for the vm early.

Lastly, patch 5 is essentially a revert of Sean's proposed fix [1], but
I deliberately am not proposing a revert outright, in case alarm bells
go off that a stable patch got reverted (it is correct).

Applies to the following commit w/ the addition of Sean's patch:

  fb649bda6f56 ("Merge tag 'block-5.18-2022-04-15' of git://git.kernel.dk/linux-block")

Tested (I promise) on an Intel Skylake machine with KVM selftests. I
poked around in debugfs to make sure there were no stragglers, and I ran
the reproducer for [1] to confirm the null ptr deref wasn't introduced
yet again.

Oliver Upton (5):
  KVM: Shove vm stats_id init into kvm_create_vm_debugfs()
  KVM: Shove vcpu stats_id init into kvm_vcpu_create_debugfs()
  KVM: Get an fd before creating the VM
  KVM: Actually create debugfs in kvm_create_vm()
  KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs() (again)

 virt/kvm/kvm_main.c | 92 ++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

-- 
2.36.0.rc0.470.gd361397f0d-goog

