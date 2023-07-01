Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979AC7448B1
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjGALJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGALJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:09:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1183C05
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688209731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1oGya+YaLUHTxEQGNGHc+25GCorVk4Vw1ywVo/ACKI=;
        b=EQJeicwHwgmnxMEE0yhLSKCUayPvDm0n+7TFYn+ru1SImVXBOCtHeuwRHy73rvArV6j2dE
        lpndHL5tmTaeS/mZz8y/FUn6i6g5fgQBVrhRATpxSRrTNFuUCpeIEuzhEhqNk09/LyzchI
        fk5z7ZeMJfEeSTd+tChUvJHBm/8XRXE=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-NoAErBAdPe6LalT5H3CNMQ-1; Sat, 01 Jul 2023 07:08:49 -0400
X-MC-Unique: NoAErBAdPe6LalT5H3CNMQ-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-440b5fc1749so265471137.1
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 04:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688209727; x=1690801727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1oGya+YaLUHTxEQGNGHc+25GCorVk4Vw1ywVo/ACKI=;
        b=ViCirReGXT4MeJaek8vKn+Mgx4JLzGflxOQcBhcm6dbjjnKg6rVbUr87iwi+rSWjBf
         lS1xSQZgj4rPYX1MR2/HerS6WRWQkyfJWq+dU1Vs+/KQjyKK1BD+2oQ4TKTIF+gp4TUw
         nKWmnnr2Kf49Auj/RnQaJdN2Et+Q+l5AMxMcQSBxUny+dsZSAu+hmpxauMHnSRviUSKt
         mtNdH/RHNwR1pkIoB58ErFSHOvGA5ZtzRzMJWodB7IqlJpc8M324r8uFqiahBKcgLOSo
         yO98FSyCegLnDWGvQK7+HfLmiSfwTH6nRgHSkOhW71WsbjrcQoGVLDTfcbFd7+0Kqr0s
         BCTg==
X-Gm-Message-State: ABy/qLZFOSQhxwJGtGKokjBnTddpwdU7PdHdiLKCSuC8dFhn4zCNoMwd
        4As12bo3hwsz96qtDupVjO65NTIhsRXobSSgp1MU3PitfYUFVLVcJkz1fcZonI5zQIF0y6GJLwA
        JvzT6EFFtO0tVXW+Fqb+lbUPkNWHkSJDu2FhY
X-Received: by 2002:a67:fe02:0:b0:443:81a7:63ee with SMTP id l2-20020a67fe02000000b0044381a763eemr2257755vsr.21.1688209727100;
        Sat, 01 Jul 2023 04:08:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHw2nLEMYAq97+/RJ6NdGreLWsA8f7nAvod5571ig9rLy/kd3P0BxOUFxnDtsk4CnQLXldrh31aXft+HJlWSbI=
X-Received: by 2002:a67:fe02:0:b0:443:81a7:63ee with SMTP id
 l2-20020a67fe02000000b0044381a763eemr2257751vsr.21.1688209726855; Sat, 01 Jul
 2023 04:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 1 Jul 2023 13:08:35 +0200
Message-ID: <CABgObfba1Jz9cJu8PhACT0peQoPTtCvBzGSfw6XcrZU0LSt9eA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Non-x86 changes for 6.5
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
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

On Tue, Jun 27, 2023 at 2:33=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Non-x86, a.k.a. generic, KVM changes for 6.5.  As will hopefully always b=
e
> the case for common changes from me, nothing particularly interesting.
>
> The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f3=
3f:
>
>   KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 =
-0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.5
>
> for you to fetch changes up to cc77b95acf3c7d9a24204b0555fed2014f300fd5:
>
>   kvm/eventfd: use list_for_each_entry when deassign ioeventfd (2023-06-1=
3 14:25:39 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> Common KVM changes for 6.5:
>
>  - Fix unprotected vcpu->pid dereference via debugfs
>
>  - Fix KVM_BUG() and KVM_BUG_ON() macros with 64-bit conditionals
>
>  - Refactor failure path in kvm_io_bus_unregister_dev() to simplify the c=
ode
>
>  - Misc cleanups
>
> ----------------------------------------------------------------
> Binbin Wu (1):
>       KVM: Fix comment for KVM_ENABLE_CAP
>
> Michal Luczaj (2):
>       KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd=
_idx()
>       KVM: Clean up kvm_vm_ioctl_create_vcpu()
>
> Sean Christopherson (1):
>       KVM: Protect vcpu->pid dereference via debugfs with RCU
>
> Wei Wang (3):
>       KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
>       KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
>       kvm/eventfd: use list_for_each_entry when deassign ioeventfd
>
>  include/kvm/iodev.h       |  6 ------
>  include/linux/kvm_host.h  |  4 ++--
>  include/uapi/linux/kvm.h  |  2 +-
>  virt/kvm/coalesced_mmio.c |  9 ++-------
>  virt/kvm/eventfd.c        |  8 +++-----
>  virt/kvm/kvm_main.c       | 30 ++++++++++++++++++++----------
>  6 files changed, 28 insertions(+), 31 deletions(-)
>

