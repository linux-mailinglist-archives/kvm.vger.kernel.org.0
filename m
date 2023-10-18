Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE817CD1B6
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 03:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjJRBQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 21:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbjJRBQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 21:16:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C661FE
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:16:26 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9e994fd94so40111965ad.3
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697591786; x=1698196586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7k0xzkmoVmgI5iZUMhKj8EPCWyonuSbt0ZRt+nUFtB8=;
        b=0GTuvidf8HtQXkclA59POYTVTHiXzOExYS0Y7/cUSrA3cbp3tcJuVs/2uL/DKPGATr
         lNWYsVEXUuDS+WsH2ldPAcJGvK/ESupl7PS9nBnCZfXUPzotv+TnMwHZ6aym53dlAXaP
         9MUwlJTilybk5jxDhA3/BhO8ZOP0k5crhYpY+upw2yfxWLe1+ZYt/hshtCz7w0Aoe8La
         l1cVEK3rQoXTQdQDXfT7cGk7rEFE+NXovpMbu9vmZqHJiQJK+W9GEhN3vhswWFvXW+sk
         wdwlxsLeyXV0CP0HCjteyxp/24hazU+0X07M0QMtC+QWKL7WoEUPdcSSQAjKPnMPZJM3
         6pBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697591786; x=1698196586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7k0xzkmoVmgI5iZUMhKj8EPCWyonuSbt0ZRt+nUFtB8=;
        b=RTXHLsES8Nzkpiekp1yQ0eFnB7xuJliJPboe9OuOENBe/Kzi0z5bl5B4Bqv9DN/iCw
         Q7t0j31OpZekvRGUbJOlzgBQsb+oycrQj2OxyIzQVgfTHXYlIx5vk7Z/7SZs2lXOOpq0
         dOD2hpahW1PQdDQzqSRXdlZ34Dlw/zL9CGWK3zOwNZOQU1elcYIo0QO/4rLyZlAIUGXr
         iTWk1ZoErXdbCiIifErGb5H/rc9QliQumGAUTKwxANbKnim19JFAO3BDba14dqzINw/m
         /3Pi9nH9b1vSMqOONDcEDUBOnbIXiY8nbBBUxm7jmXWXFXo/2q/u2PBK3kKAxhFJsCwt
         TfOw==
X-Gm-Message-State: AOJu0Yy3CjPFse8LKXZCZX1IJKUdPQMGSOjVO7aetQARfphHRWYNfDVB
        BQD4qJM+XacLGGU9irZDrGgRsVnxqYA=
X-Google-Smtp-Source: AGHT+IFvNkQtwQudPuy/QTTh37mXDnKWONdHW1L6eS1kGxoH5feFAAtx8l25f2F93HPkYNoG/sjJEiZcvnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab0d:b0:1ca:a382:7fc1 with SMTP id
 ik13-20020a170902ab0d00b001caa3827fc1mr26619plb.12.1697591785795; Tue, 17 Oct
 2023 18:16:25 -0700 (PDT)
Date:   Tue, 17 Oct 2023 18:16:14 -0700
In-Reply-To: <20231016221228.1348318-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20231016221228.1348318-1-dmatlack@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169759163968.1787364.11002021849267256699.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Stop kicking vCPUs to sync the dirty log
 when PML is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Oct 2023 15:12:28 -0700, David Matlack wrote:
> Stop kicking vCPUs in kvm_arch_sync_dirty_log() when PML is disabled.
> Kicking vCPUs when PML is disabled serves no purpose and could
> negatively impact guest performance.
> 
> This restores KVM's behavior to prior to 5.12 commit a018eba53870 ("KVM:
> x86: Move MMU's PML logic to common code"), which replaced a
> static_call_cond(kvm_x86_flush_log_dirty) with unconditional calls to
> kvm_vcpu_kick().
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86/mmu: Stop kicking vCPUs to sync the dirty log when PML is disabled
      https://github.com/kvm-x86/linux/commit/3d30bfcbdc26

--
https://github.com/kvm-x86/linux/tree/next
