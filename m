Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECACA4F0540
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 19:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244429AbiDBRms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 13:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbiDBRmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 13:42:43 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398B2DF82
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 10:40:51 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id b15-20020a05660214cf00b00648a910b964so3599515iow.19
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 10:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EDhTuekQtNdm8MWzZ4rgwl9Zuy6sown5y5t0K60oNeM=;
        b=B8kXE1B9TLeU0fkKkRjLEwnu0j64XSm51isipBSezaI+aW4AtZHnIwm8TGZj11qhjH
         fZQIml2v0tbIQEfE+Rdi8YKENmjgZx3JLnbDQpunt+Lhb02W6Vt4aMuEdjjmWuAMIpU/
         qpWP9KDaobTe+W3uOxEt+HSwNp7VpmQMyoKm+GSu+CZFLH6hjzjaKFfyU2AcF0kukXvm
         QDYThdKrd3I540B7S51JbBoxsphYIIH++HAYKwcqXN8Ak3NZOiSQbOk768apsr0G4RTv
         RVSLI2Pn5gd7HrzXW15CZPCcJCKrOG3MkeCDtxEhDwRuVNo6aCWkbdOKa9xeJ/7BVvad
         afww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EDhTuekQtNdm8MWzZ4rgwl9Zuy6sown5y5t0K60oNeM=;
        b=l8/1yluI3PbNXk4EHMUpXiHEahKFa536G1XyTGBK75b0D3fyPHXR1YGbMRAoMJeyae
         GQorn8pe3wmbwpwqH4j3AudySpq3WwFbDheOlpfN5DoSzBj67hf6wifCLZPGQv2wxSw/
         BWMnsKXyl6qhXCaks3+uQ0vOoaeE/2ZRhMUeMerBfMW31ZvhckoteeIPxofwE2/1JvB9
         0dmWoJISCdvXeiA1dFxCvc0jV91GM7tqS89ST+VooDOwndh9tTExi0ns717OzReLCanp
         2R9Qfw7NJdLe6PZCkPq4fsxDkNVvkllEYXvf4o7OUjT6c5ABp3BfD3YQetpiP+DUfcyZ
         IPMg==
X-Gm-Message-State: AOAM5301fAXtgk8MED6VCymaaEVwivzevJPHwNr1epnqjAExVsY+ruYG
        tChmKje1481vW0zUE4o33eR/SPORGPQ=
X-Google-Smtp-Source: ABdhPJwx6B48zoyhRzOI+UWoY4wiun1eWGRgsGjvJOKksNdUx4f7qTvuv/CNaHpOREGjQo9q8Bk2CyZ29n4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2c8b:b0:649:e67c:9202 with SMTP id
 i11-20020a0566022c8b00b00649e67c9202mr2148843iow.75.1648921250592; Sat, 02
 Apr 2022 10:40:50 -0700 (PDT)
Date:   Sat,  2 Apr 2022 17:40:42 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-3-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 2/4] KVM: Only log about debugfs directory collision once
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, stable@kernel.org
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

In all likelihood, a debugfs directory name collision is the result of a
userspace bug. If userspace closes the VM fd without releasing all
references to said VM then the debugfs directory is never cleaned.

Even a ratelimited print statement can fill up dmesg, making it
particularly annoying for the person debugging what exactly went wrong.
Furthermore, a userspace that wants to be a nuisance could clog up the
logs by deliberately holding a VM reference after closing the VM fd.

Dial back logging to print at most once, given that userspace is most
likely to blame. Leave the statement in place for the small chance that
KVM actually got it wrong.

Cc: stable@kernel.org
Fixes: 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs directories")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69c318fdff61..38b30bd60f34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -959,7 +959,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	mutex_lock(&kvm_debugfs_lock);
 	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
 	if (dent) {
-		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
+		pr_warn_once("KVM: debugfs: duplicate directory %s\n", dir_name);
 		dput(dent);
 		mutex_unlock(&kvm_debugfs_lock);
 		return 0;
-- 
2.35.1.1094.g7c7d902a7c-goog

