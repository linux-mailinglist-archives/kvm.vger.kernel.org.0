Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F0B730ECC
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 07:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjFOFuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 01:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbjFOFtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 01:49:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC13126AD
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 22:49:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5193c97ecbbso1682975a12.1
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 22:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1686808188; x=1689400188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R30ZzlGN0VDeQnCpBNeh1UWt38VgrmhzqyCw6OkmtCg=;
        b=M/pRoyyvWn5vLsPUbjRS6K0mtQ0WZOZ1nSvhcMuviz+Q9un9TDudaESBFWpvdjkm6b
         u8S9KWzu63klxB2Jhik0hYkrxXH6XGaHRbY3Lm6ffzwN2ytpFjbcubwlYzT2w5Zh2KN+
         C1uK1fBiocrKC7d6w2z7AE10EJd8jypXmckUY0JFv4ecDTCte2eJoQXdU7CSzKyKgDli
         gHwoCEcvrBYlIENjFMXowg7frkDL1TGndDsbKMET0/3lSfNieRMmH7SjEqaKV/d59mBw
         9e6FakXvIBLDaKRquhsu6KkEPkuzxPY3AvtJlnqzOw16TXB0K9yWT5hlfh8sHkEpdnzi
         +TjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686808188; x=1689400188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R30ZzlGN0VDeQnCpBNeh1UWt38VgrmhzqyCw6OkmtCg=;
        b=WtOpe0zd5s1wNjqlLGf/RoNH0oMuLQYAQxlrh4jdmNdzQZ+qZo46VzVfGO/kYC6sMU
         BarVuNEL1V2GDok1D7VyTuLR0IcbgE2mcQgCbANn1ZfP4DnV1pElBlWdB4W7G8ospxHq
         gH4agfTMKMISTz6D9FmnPqvOPoKv0ursesBijDnEnN2tOgDJefZZX4tUseUaZGcyDUES
         XfkUWEbI9i4rqZEfIzSd86tr/gp5d068RJk1rfSLLDwXzQdNN72S95CNK2gNPNYDnlh/
         GGaISwa4TBfKfg+3XSJNbQImeeOSq+YqjxXjyiPHBAl4sOQ+ZkQSrCnTjQwQ62qem89S
         Bovw==
X-Gm-Message-State: AC+VfDxu+9rLY/4F6fTgzfdJulOoGGRzu5JpF+LJWUIyYJ1+VPROEnSV
        9MkDl7tbAQAjwNI4dYXvhcqXLTxNUu952Xckppgo3pFxP9tX4ASa
X-Google-Smtp-Source: ACHHUZ48dUT8JCtQf7+YAA0qvyZAGLhfYbopgB1p7VZRLCbpr1tGR9JDAihONmpnx45ALUU79k6wWn539M/nkceO/Co=
X-Received: by 2002:a05:6402:1842:b0:514:9904:c8fe with SMTP id
 v2-20020a056402184200b005149904c8femr8673507edy.39.1686808187712; Wed, 14 Jun
 2023 22:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230315101606.10636-1-wei.w.wang@intel.com>
In-Reply-To: <20230315101606.10636-1-wei.w.wang@intel.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 15 Jun 2023 11:19:34 +0530
Message-ID: <CAAhSdy0H0jGrEdCdrVBRr5f0SzLhfyk5Yayf2C_6UaFndv3dFw@mail.gmail.com>
Subject: Re: [PATCH RESEND v2] KVM: move KVM_CAP_DEVICE_CTRL to the generic check
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 3:47=E2=80=AFPM Wei Wang <wei.w.wang@intel.com> wro=
te:
>
> KVM_CAP_DEVICE_CTRL allows userspace to check if the kvm_device
> framework (e.g. KVM_CREATE_DEVICE) is supported by KVM. Move
> KVM_CAP_DEVICE_CTRL to the generic check for the two reasons:
> 1) it already supports arch agnostic usages (i.e. KVM_DEV_TYPE_VFIO).
> For example, userspace VFIO implementation may needs to create
> KVM_DEV_TYPE_VFIO on x86, riscv, or arm etc. It is simpler to have it
> checked at the generic code than at each arch's code.
> 2) KVM_CREATE_DEVICE has been added to the generic code.
>
> Link: https://lore.kernel.org/all/20221215115207.14784-1-wei.w.wang@intel=
.com
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Acked-by: Anup Patel <anup@brainfault.org> (riscv)

Thanks,
Anup

> ---
>  arch/arm64/kvm/arm.c       | 1 -
>  arch/powerpc/kvm/powerpc.c | 1 -
>  arch/riscv/kvm/vm.c        | 1 -
>  arch/s390/kvm/kvm-s390.c   | 1 -
>  virt/kvm/kvm_main.c        | 1 +
>  5 files changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf087..96329e675771 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -202,7 +202,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>                 r =3D vgic_present;
>                 break;
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_USER_MEMORY:
>         case KVM_CAP_SYNC_MMU:
>         case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 4c5405fc5538..185efed23896 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -526,7 +526,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>         case KVM_CAP_ENABLE_CAP:
>         case KVM_CAP_ONE_REG:
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_IMMEDIATE_EXIT:
>         case KVM_CAP_SET_GUEST_DEBUG:
>                 r =3D 1;
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 65a964d7e70d..6efe93b282e1 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -57,7 +57,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long =
ext)
>
>         switch (ext) {
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_USER_MEMORY:
>         case KVM_CAP_SYNC_MMU:
>         case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 39b36562c043..7b097b5253ca 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -556,7 +556,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
>         case KVM_CAP_ENABLE_CAP:
>         case KVM_CAP_S390_CSS_SUPPORT:
>         case KVM_CAP_IOEVENTFD:
> -       case KVM_CAP_DEVICE_CTRL:
>         case KVM_CAP_S390_IRQCHIP:
>         case KVM_CAP_VM_ATTRIBUTES:
>         case KVM_CAP_MP_STATE:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331..71cc63640173 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4523,6 +4523,7 @@ static long kvm_vm_ioctl_check_extension_generic(st=
ruct kvm *kvm, long arg)
>  #endif
>         case KVM_CAP_BINARY_STATS_FD:
>         case KVM_CAP_SYSTEM_EVENT_DATA:
> +       case KVM_CAP_DEVICE_CTRL:
>                 return 1;
>         default:
>                 break;
> --
> 2.27.0
>
