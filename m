Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C89774163E
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 18:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjF1QVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 12:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjF1QVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 12:21:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FBAE71
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 09:21:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bfee5fd909aso6534616276.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 09:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687969267; x=1690561267;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VA0pRMcfjxK3ORdF+r213k5bFHTTsu/0/56kw6z0Ptw=;
        b=iGav7SRTeFJ7XdQtG5foG6+u0G31IobRhpVHNPDfeTSIKxmy5k2nsOViE+B7zSKYQv
         41O4aIgxPUAkhpq/x9SQOzcVViXrYRPkKHYAPfXKiEXES7g6eFlYRo3NCIydmrZc9w6N
         cucMQAvZF2c9ycpMuKiAhT+TAA1hIlIbdml19j7dS6gHKebGQyiRUjqBsYsbO5eAPxHF
         gIXA5ifqTLkKxK/0urZz+pPxe4nH1FAUZ6IVMFF4/Oel1ePYcwtO6QQ/xFWMA299rxJQ
         GPFun6Wau3twwEp984y/2pDdcDnOuG3y2qlCyKiN/VnJ2gcCT2SaenkjaBhntVLUsjFh
         4nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687969267; x=1690561267;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VA0pRMcfjxK3ORdF+r213k5bFHTTsu/0/56kw6z0Ptw=;
        b=R7e4Y42rDMqH9x51VgeQF8HYUZD4zoRRc0WUQBFDDQQuF+yj/E3hE62AdnH9gsDUS1
         HYwzWERHedOdwJW+msAZm/7ASNMvRDjqoA1mMnDYjUt4+ZL/NMrO87qDTmL+7JDtzxkB
         Ug0gxCA68349XH2h5JPdrPT6W2X4FV90jnKvwwW+bjv+/Wnbo+Mgjgmr007Fup3bTwaL
         spEEr9zoz9i6sC3LLiOiujXBCLbgZmTPTk9tt8Q8qONULUL7KCxvNrWTsVQHliO8Ht5T
         wwI16JcmR6su6FR4VV8xjRhTNSTSjtD7c/u07vNtez2VnO9T1gUey/ELoAoQGLXuUABO
         rLog==
X-Gm-Message-State: AC+VfDzNT7+wafMUChlIq94q6vB1SUuNCBIo42/XD6lVSRYMmt8HoctH
        ja9dTKxQTY+gvQfG1L4YEuNWV9rsRGs=
X-Google-Smtp-Source: ACHHUZ530zHXMFEfVaXxCxrRiuqtEyB4XRIJHQKEzieB3uckHtOvwpWT5ljB9gVw11QcM5LOrzai2sED330=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:add7:0:b0:bcc:bc25:7296 with SMTP id
 d23-20020a25add7000000b00bccbc257296mr15213593ybe.9.1687969267690; Wed, 28
 Jun 2023 09:21:07 -0700 (PDT)
Date:   Wed, 28 Jun 2023 09:21:05 -0700
In-Reply-To: <f1afa6c0-cde2-ab8b-ea71-bfa62a45b956@tarent.de>
Mime-Version: 1.0
References: <5142D010.7060303@web.de> <f1afa6c0-cde2-ab8b-ea71-bfa62a45b956@tarent.de>
Message-ID: <ZJxd8StU25UJKBSk@google.com>
Subject: Re: [PATCH] KVM: VMX: Require KVM_SET_TSS_ADDR being called prior to
 running a VCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dropped all the old maintainers from Cc.  This is one of the more impressiv=
e
displays of thread necromancy I've seen :-)

On Wed, Jun 28, 2023, Thorsten Glaser wrote:
> Hi,
>=20
> I just saw a new message after reboot today and searched for it and got
> https://patchwork.kernel.org/project/kvm/patch/5142D010.7060303@web.de/
> and you might be interested that I ran into it.
>=20
> [   70.747068] kvm: KVM_SET_TSS_ADDR need to be called before entering vc=
pu
>=20
> Full dmesg attached. This is on reboot, no VMs are running yet.

Heh, there are no VMs that _you_ deliberately created, but that doesn't mea=
n there
aren't VMs in the system.  IIRC, libvirt (or maybe systemd?) probes KVM by =
doing
modprobe *and* creating a dummy VM.  If whatever is creating a VM also crea=
tes a
vCPU, then the "soft" warning about KVM_SET_TSS_ADDR will trigger.

Another possibility is that KVM sefltests are being run during boot.  KVM's=
 selftests
stuff register state to force the vCPU into 64-bit mode, and so they don't =
bother
setting KVM_SET_TSS_ADDR, e.g. the soft warning can be triggered by doing

  sudo modprobe kvm_intel unrestricted_guest=3D0

and running pretty much any KVM selftest.

> I don=E2=80=99t get any extra weird messages on VM start, and they come u=
p fine.

So long as the VMs you care about don't have issues, the message is complet=
ely
benign, and expected since you are running on Nehalem, which doesn't suppor=
t
unrestricted guest.

> [    0.000000] DMI: Gigabyte Technology Co., Ltd. X58-USB3/X58-USB3, BIOS=
 F5 09/07/2011

> [    0.330068] smpboot: CPU0: Intel(R) Core(TM) i7 CPU         950  @ 3.0=
7GHz (family: 0x6, model: 0x1a, stepping: 0x5)

> [   70.747068] kvm: KVM_SET_TSS_ADDR need to be called before entering vc=
pu
