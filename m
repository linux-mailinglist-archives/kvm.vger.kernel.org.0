Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A15209E9
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 02:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbiEJAUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiEJAUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:20:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B7C50054
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 17:16:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c13-20020a170903234d00b0015eee4c8ca3so5799449plh.6
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 17:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6oKSjCnrnaDJ0MjaoXbtw04iHzdq0yCq1lYPhCeQzvw=;
        b=BMg0uyyPoG1R2H7dLqoVSs50fr5+oYtt/E+68BORI5NJcBRDJVFWvQ3XVgro9rnlrn
         Kt97Wd64Hi/KrqXr/jXiBO9X2wkOW7QlNHSdz0CRoCs1STab9+grOz4Jh3vkrviWxe+Z
         3m1FqSTcIiEXs2I/kbzFnnY/g188Bf3oGlhunltmQ95crEA+A2LuzG+8ue7SKBcWHdKh
         3fpqwlNuh8y9SZvznMLH9iQkv4NQhFo551q8cHvUfEBewsnCp63qJzvN0OCM0XeX89uy
         rVWrMy8S16izRtzCzZWNtpXX7L0fgq2iIDUSYMVqqQzVVih5qc9yCLIVl3mo2UnHS9pA
         +cJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6oKSjCnrnaDJ0MjaoXbtw04iHzdq0yCq1lYPhCeQzvw=;
        b=Lwd5GjjjLmEJpD2gNv6wKOef6UD0mcKVP/jDxNyhlzbp7r1st0f1UWAtiIBiTXfKml
         WtNA1D8EkmkrnWt/1wdQFNrdNa+uEH0hi8v1kfW12mr68DEvsTgMCvjO/fLbb74Wv7qG
         Ms2tf5bE9jwFmMnl8yd4Zlm1TBWEpIAbM7e9SXr3hmGoJKCf4v6u4PZGMQbj1fWgmmy2
         bT162ijOijaR5aktpRHZWnKjCH5al5+ivX381C4sORDaWtg3GAbo/qP2g95bxt7Nyshu
         Qg0fzysh2f69P4mJcPs7aZRihDxQgCD96ADjf6tAGrcycPOtl6YYXIUQZ2RuZavpT6tM
         MFxQ==
X-Gm-Message-State: AOAM532qr+OUm3BBbDuPu7nmyCGEj0dFVT4J6QVbFpz4ktP2nm5TGaaG
        MtIgo0a5UEPb6uO1A/GYf9ybdKX0MfFwKI1rVpiCQ6O6Uibkk1GBPOfJ68A/2VLtg/9PCP7VKji
        4cEJRJwgqwD3UQ2uIN8q05fsSvfnxgpMsA9vUTJh+lxYA8zKFooW/7hQeNyhJ/Wc=
X-Google-Smtp-Source: ABdhPJwC/rHmJWgon7TLj+TannUN3z+nd6cTOgZdagu7p9mijBEZ7uf+GPz7Ci2qlDQpatMnYPdV1Cdn4wo9Mw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:ea0f:b0:15e:afcf:d1a4 with SMTP
 id s15-20020a170902ea0f00b0015eafcfd1a4mr18401436plg.96.1652141796314; Mon,
 09 May 2022 17:16:36 -0700 (PDT)
Date:   Mon,  9 May 2022 17:16:29 -0700
Message-Id: <20220510001633.552496-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 0/4] KVM: arm64: vgic: Misc ITS fixes
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
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

The purpose of this series is to help debugging failed ITS saves and
restores.  Failures can be due to misconfiguration on the guest side:
tables with bogus base addresses, or the guest overwriting L1 indirect
tables. KVM can't do much in these cases, but one thing it can do to help
is raising errors as soon as possible. Here are a couple of cases where
KVM could do more:

- A command that adds an entry into an ITS table that is not in guest
  memory should fail, as any command should be treated as if it was
  actually saving entries in guest memory (KVM doesn't until saving).  KVM
  does this check for collections and devices (using vgic_its_check_id),
  but it doesn't for the ITT (Interrupt Translation Table). Commit #1 adds
  the missing check.

- Restoring the ITS tables does some checks for corrupted tables, but not
  as many as in a save.  For example, a device ID overflowing the table
  will be detected on save but not on restore.  The consequence is that
  restoring a corrupted table won't be detected until the next save;
  including the ITS not working as expected after the restore. As an
  example, if the guest sets tables overlapping each other, this would most
  likely result in some corrupted table; and this is what we would see from
  the host point of view:

	guest sets bogus baser addresses
	save ioctl
	restore ioctl
	save ioctl (fails)

  This failed save could happen many days after the first operation, so it
  would be hard to track down. Commit #2 adds some checks into restore:
  like checking that the ITE entries are not repeated.

- Restoring a corrupted collection entry is being ignored. Commit #3 fixes
  this while trying to organize the code so to make the bug more obvious
  next time.

Finally, failed restores should clean up all intermediate state. Commit #4
takes care of cleaning up everything created until the restore was deemed a
failure.

v2: https://lore.kernel.org/kvmarm/20220427184814.2204513-1-ricarkol@google.com/
v2 -> v3:
- collect RBs from Eric (Thanks!)
- reorder check in vgic_its_cmd_handle_mapi (commit 1) [Eric]
- removed some checks in vgic_its_restore_ite and vgic_its_restore_dte. [Eric]
- not skipping dummy end elements when restoring collection tables. [Eric]

v1: https://lore.kernel.org/kvmarm/20220425185534.57011-1-ricarkol@google.com/
v1 -> v2:
- moved alloc_collection comment to its respective commit. [marc]
- refactored check_ite to reuse some code from check_id. [marc]
- rewrote all commit messages. [marc]

Tested with kvm-unit-tests ITS tests.

Ricardo Koller (4):
  KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
  KVM: arm64: vgic: Add more checks when restoring ITS tables
  KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
  KVM: arm64: vgic: Undo work in failed ITS restores

 arch/arm64/kvm/vgic/vgic-its.c | 96 +++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 18 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

