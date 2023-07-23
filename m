Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069FE75E3F1
	for <lists+kvm@lfdr.de>; Sun, 23 Jul 2023 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjGWQyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 12:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGWQyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 12:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED0CE50
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 09:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690131199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7Q6jB5+JjJCoMhkXTEgRxsVxQLYVK7nw0Y30rzdcso=;
        b=bgX3hPY2mN4xFNL7OYRFvzVAhL6aMI/Y6l1FsGpRlk+rnAj8dW4M+FOJzeIdv/esYeh6XH
        YaN53B02ywuKSpC46jbJLAy5I4JXRwMK5onVWmn1mDVdb5f502DFisxLAliOsYEotiKuxh
        aPu4zxEgAykfiWIxcjzJi22A2Jp7AVI=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-k1WR_FPnOTGWqcSigRTNzg-1; Sun, 23 Jul 2023 12:53:18 -0400
X-MC-Unique: k1WR_FPnOTGWqcSigRTNzg-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-799728678ecso958688241.3
        for <kvm@vger.kernel.org>; Sun, 23 Jul 2023 09:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690131197; x=1690735997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7Q6jB5+JjJCoMhkXTEgRxsVxQLYVK7nw0Y30rzdcso=;
        b=N1C7lVAgCFAC4pYXTjOTAjSPFyp2S4lLVPzml334DyzoRFICSLUw5TAtLmztB/xkLa
         mjMorx0ll+KeBH2hBv4jemioDCsDK+XUDomeGJJU2pGSCN7t0z4eh4M2TqfiouWcfEXW
         futpMOw/yrz0CmcgrVYZhq5szK5TUDOhzcbstKRWwImSk0QnYByGkbiY/1n0AqrgpHGy
         RQuZpO/gg9hl5jvAcfjfz/OjBUR/hBAnwnfR9gk2lSllV13CPqDowVfVza53tpOlOoA/
         6VD8yP0Pq/VuTNH8ov0Dk8FbfnWVBpdXD35KUx269B9JpIemBAOrqPedLmkGLpRrTJsR
         kGbw==
X-Gm-Message-State: ABy/qLYkY9INPbgwc+7UIcSaIy9E0IS925pSbD1ip2yuUrw9LAAS+DYc
        sEz/lgspCO/QcmC9L82Jx++JIkibBlReUYpz0w0HLm3Y8OBox/KSKkwf1NbO+RSiEfPiCy0v59m
        kgoaA/MU3TIEeWvIhciDhY3ktU1SG
X-Received: by 2002:a05:6102:3d6:b0:444:c2cb:d525 with SMTP id n22-20020a05610203d600b00444c2cbd525mr2140237vsq.31.1690131197548;
        Sun, 23 Jul 2023 09:53:17 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHE7PFTbUUGsD4fJxXrXa4KpCiAW59I3ahU68nmE+/HLCmOCRZ11smJOZnJGNMvvyP98i3mAp5k/Co+1iNu4PY=
X-Received: by 2002:a05:6102:3d6:b0:444:c2cb:d525 with SMTP id
 n22-20020a05610203d600b00444c2cbd525mr2140234vsq.31.1690131197316; Sun, 23
 Jul 2023 09:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <ZLYnolPWJubKLZY8@thinky-boi> <ZLYn/RAovUs+U0r+@thinky-boi>
In-Reply-To: <ZLYn/RAovUs+U0r+@thinky-boi>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 23 Jul 2023 18:53:05 +0200
Message-ID: <CABgObfYC9UmCdnDryryPGPp_BOdOjH8bRK=e7f-R5CJXJ-Ae_Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.5, part #1
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
        Mostafa Saleh <smostafa@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 7:49=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> +cc lists, because I'm an idiot.
>
> On Mon, Jul 17, 2023 at 10:48:23PM -0700, Oliver Upton wrote:
> > Hi Paolo,
> >
> > Quite a pile of fixes for the first batch. The most noteworthy here is
> > the BTI + pKVM finalization fixes, which address an early boot failure
> > when using the split hypervisor on systems that support BTI and make th=
e
> > overall pKVM flow more robust to failures.
> >
> > Otherwise, we have a respectable collection of one-offs described in th=
e
> > tag message.
> >
> > Please pull.

Pulled, thanks. Should be in time for -rc3.

Paolo

> >
> > --
> > Thanks,
> > Oliver
> >
> > The following changes since commit 06c2afb862f9da8dc5efa4b6076a0e48c3fb=
aaa5:
> >
> >   Linux 6.5-rc1 (2023-07-09 13:53:13 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/=
kvmarm-fixes-6.5-1
> >
> > for you to fetch changes up to 9d2a55b403eea26cab7c831d8e1c00ef1e6a6850=
:
> >
> >   KVM: arm64: Fix the name of sys_reg_desc related to PMU (2023-07-14 2=
3:34:05 +0000)
> >
> > ----------------------------------------------------------------
> > KVM/arm64 fixes for 6.5, part #1
> >
> >  - Avoid pKVM finalization if KVM initialization fails
> >
> >  - Add missing BTI instructions in the hypervisor, fixing an early boot
> >    failure on BTI systems
> >
> >  - Handle MMU notifiers correctly for non hugepage-aligned memslots
> >
> >  - Work around a bug in the architecture where hypervisor timer control=
s
> >    have UNKNOWN behavior under nested virt.
> >
> >  - Disable preemption in kvm_arch_hardware_enable(), fixing a kernel BU=
G
> >    in cpu hotplug resulting from per-CPU accessor sanity checking.
> >
> >  - Make WFI emulation on GICv4 systems robust w.r.t. preemption,
> >    consistently requesting a doorbell interrupt on vcpu_put()
> >
> >  - Uphold RES0 sysreg behavior when emulating older PMU versions
> >
> >  - Avoid macro expansion when initializing PMU register names, ensuring
> >    the tracepoints pretty-print the sysreg.
> >
> > ----------------------------------------------------------------
> > Marc Zyngier (3):
> >       KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 =
bits
> >       KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
> >       KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preem=
ption
> >
> > Mostafa Saleh (1):
> >       KVM: arm64: Add missing BTI instructions
> >
> > Oliver Upton (2):
> >       KVM: arm64: Correctly handle page aging notifiers for unaligned m=
emslot
> >       KVM: arm64: Correctly handle RES0 bits PMEVTYPER<n>_EL0.evtCount
> >
> > Sudeep Holla (1):
> >       KVM: arm64: Handle kvm_arm_init failure correctly in finalize_pkv=
m
> >
> > Xiang Chen (1):
> >       KVM: arm64: Fix the name of sys_reg_desc related to PMU
> >
> >  arch/arm64/include/asm/kvm_host.h    |  2 ++
> >  arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++-------------
> >  arch/arm64/include/asm/virt.h        |  1 +
> >  arch/arm64/kvm/arch_timer.c          |  6 ++---
> >  arch/arm64/kvm/arm.c                 | 28 ++++++++++++++++++---
> >  arch/arm64/kvm/hyp/hyp-entry.S       |  8 ++++++
> >  arch/arm64/kvm/hyp/nvhe/host.S       | 10 ++++++++
> >  arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 +-
> >  arch/arm64/kvm/hyp/pgtable.c         | 47 ++++++++++++++++++++++++++++=
+-------
> >  arch/arm64/kvm/mmu.c                 | 18 ++++++--------
> >  arch/arm64/kvm/pkvm.c                |  2 +-
> >  arch/arm64/kvm/sys_regs.c            | 42 ++++++++++++++++------------=
----
> >  arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
> >  arch/arm64/kvm/vgic/vgic-v4.c        |  7 ++++--
> >  include/kvm/arm_vgic.h               |  2 +-
> >  15 files changed, 133 insertions(+), 70 deletions(-)
>

