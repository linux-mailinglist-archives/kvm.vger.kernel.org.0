Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE0350E8EC
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiDYS6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244718AbiDYS6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:58:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B391A12A8F
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b6-20020a170902d50600b0015d1eb8c82eso2011890plg.12
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9uTx7aTaC/NLaRkZRYuxSBWgFNaFafQzTssLeV88+wE=;
        b=Vi135yAFeO7udOCeaAa8g8PncqQD2Ti8D7eIsZ9O8PAJC26ERr+D4WKGvoixtnbZ2L
         dS/iSNj7XHFYkqFy8Up8eXFm+y0Vo2GhK8LiEqFwVmQ477NM8lLnuXifuwtpL0QP/XXG
         SzNIiUEB1BdR+K/o5y5QHPjTqjl5BoqbnrmC5CcG+ZZJ/Myi9hPqtJdr0iYNQWvP/QCA
         n3Ssf09NH9HuWxTyV+oBoDu7wA1mzHvbyq6fKKnncF9StIwEtFO43Ni5HD8NkkLpyWjg
         FSTGxuZcQ7GCPGA/GOHjKIBWWf20DAtfZOTBBIxRK/a1cdrWcUXsuxwzCkI2qwKNHRj8
         i64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9uTx7aTaC/NLaRkZRYuxSBWgFNaFafQzTssLeV88+wE=;
        b=QoceZT4UWR+plWY/q7STR3ATcU1tGMjqITvmr67Rw/czXvr5B9g+8Pl4NbfSX5dnfL
         I1mfJ0wbw8owatyww2ApAYGVfjysiZl9rIQm0NlUslCu/81XSesdCFBAZK5JulvKyLQV
         2FbWs7BCGjs2T1z06JiZ4Z29q7J2d4AF+4ZoQsQOCNUlc5whZibjuJmm8ZHmMRn36Z5v
         YT+o9OXMTQ83EvT6xCybKKfAazkyrNmVKbmI1wx9mHc64K3WcKgx1FsnKBxXpbzWZc7r
         ZybBbnby55sDirbtbhm3WO6Ooi1mQWv9Kd7AIMvHd/1XbpJVOn+fUvFw7GDuFZtnUXCv
         v1Qg==
X-Gm-Message-State: AOAM530N45Ehluk8iAdl8FgchfD+cQYEkV0ef1vZeoKl/YQVi4MekL+f
        W/P5iYvp2GLBXqb+h9XROLdLRy/lwXQeY5ghOUcgZ9+OT+ESBPToKVvAoC/pr7mlmTi3y8sGYua
        t1vTJSyPDw4CttjMuVBw6Bdj0hGzSQ8cQ+gBHmB9bRqQwLlhATn8kAD0UmJqu97k=
X-Google-Smtp-Source: ABdhPJzOSq9KMsDtiV7Cd14lQTX8+JymxLFUZW8dIG/X1TgjjURDXo3mDbViGv4RE7oF9qVFy4VQIL1bAyTxdw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP
 id w6-20020a17090ac98600b001d956e74e83mr692123pjt.1.1650912936913; Mon, 25
 Apr 2022 11:55:36 -0700 (PDT)
Date:   Mon, 25 Apr 2022 11:55:30 -0700
Message-Id: <20220425185534.57011-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 0/4] KVM: arm64: vgic: Misc ITS fixes
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
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

Tested with kvm-unit-tests ITS tests.

Ricardo Koller (4):
  KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
  KVM: arm64: vgic: Add more checks when restoring ITS tables
  KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
  KVM: arm64: vgic: Undo work in failed ITS restores

 arch/arm64/kvm/vgic/vgic-its.c | 91 ++++++++++++++++++++++++++++++----
 1 file changed, 80 insertions(+), 11 deletions(-)

-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

