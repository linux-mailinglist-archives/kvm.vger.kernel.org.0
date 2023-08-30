Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FEF78D0EE
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbjH3AHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbjH3AGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:06:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB391BE
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-594e8207103so51416657b3.2
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693354011; x=1693958811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5vQWDWN9QjQwmRYIzABg1CIzIVHW8NaLWdBZKl8U/Q4=;
        b=AZuTU6WWYG/1eKsiMfDEMZ3N8v1aLWh7GKlSx4AFwdgj1D7xzsDPHZdnLHHO3TxCZ6
         gFqTVarp8VBZRsnr2fz2ITi7nmuHLt0ZUjq/NZHqNfgy8TU4lBqIXMwsAhLkrXBZ+7VF
         vQqAc3S+x/uNEh6GcjzID4nzeE+UgCSkcoH64T8UerD7GWxiA0Im9agbziI/+HeoxA5m
         fxit4XtCuVnb8DljWAytymTM4BHHdiJBj0kNfb1aO8VbpoANjfdbxAG3s99zP2ckA7J9
         nxKM75nYS4LXblEzmDMTgkZWnjkrlyAooihwsv88VewBocQB54/cKdv+gZzquHgIxZ08
         FKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693354011; x=1693958811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5vQWDWN9QjQwmRYIzABg1CIzIVHW8NaLWdBZKl8U/Q4=;
        b=ZrMpaDnE9Nwr/LPwBIvFEhvC5SWtdpNIPwTxBh+ZeTcQ9nKMPSh8Vck4xHzNMKbZs+
         LAQ6tpVpQCD3QcJNSiXFMXYZv9Rx6bgS22T825MgBgEBvOwo3zVh20ivT24e9OXop4Sg
         2Cw31VMtRpioItPQEMGSTJgaQpYuhKeOaVaJ9jfEBhrNPOFe2IethzI1TATcrmp9MzV3
         dGUZPd+DPSXXlGqffWpkmO0Hhl7EH8XKyZ0iMMHX12xsrSgTF5+buMVx+TaH4IcG6pdu
         v7LuDhrP5AdoDtmHMvaLQyI4UsvnWX2x1zbPvRqnzk6YRd1Ps0B8tSEzkInnN/xxRhlO
         BWhQ==
X-Gm-Message-State: AOJu0YywJtQqsp8sKKtz7FMRVXJY6uJrIE7pogEQKntROd0qEqf8jr0t
        o26ICGO/S4GBk7z8q8yoVxW6MHViBlY=
X-Google-Smtp-Source: AGHT+IHGR1128vmCMWLmYqOJ14jKzl9S/74xwIXVowUidZGNH6Z3+8/9wDX5R9FytvDrzfDNrwCx8e8zG/U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b3ca:0:b0:589:a5c6:4a8e with SMTP id
 r193-20020a81b3ca000000b00589a5c64a8emr16313ywh.1.1693354011726; Tue, 29 Aug
 2023 17:06:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Aug 2023 17:06:33 -0700
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230830000633.3158416-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX changes for 6.6.  Nothing mindblowing, by far the most interesting change
is the super late fix for NMI VM-Exits that you've already looked at.

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.6

for you to fetch changes up to 50011c2a245792993f2756e5b5b571512bfa409e:

  KVM: VMX: Refresh available regs and IDT vectoring info before NMI handling (2023-08-28 20:07:43 -0700)

----------------------------------------------------------------
KVM: x86: VMX changes for 6.6:

 - Misc cleanups

 - Fix a bug where KVM reads a stale vmcs.IDT_VECTORING_INFO_FIELD when trying
   to handle NMI VM-Exits

----------------------------------------------------------------
Sean Christopherson (3):
      KVM: VMX: Drop manual TLB flush when migrating vmcs.APIC_ACCESS_ADDR
      KVM: VMX: Delete ancient pr_warn() about KVM_SET_TSS_ADDR not being set
      KVM: VMX: Refresh available regs and IDT vectoring info before NMI handling

Shiyuan Gao (1):
      KVM: VMX: Rename vmx_get_max_tdp_level() to vmx_get_max_ept_level()

 arch/x86/kvm/vmx/vmx.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)
