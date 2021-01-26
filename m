Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AC130314B
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 02:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbhAZBbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 20:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731933AbhAZB3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 20:29:16 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B56C0698D1;
        Mon, 25 Jan 2021 17:28:30 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id x23so3767383oop.1;
        Mon, 25 Jan 2021 17:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6paGRqZC+Saiy/OdOWQy9bDY2PXfN0YJkrt0vyVzmXI=;
        b=K8X6g49rPyw3kREv1Dn/1hTN6EaW4ZmiqeMy6udTvVa98GSl/D5Bt0XdI/lgNGTfFa
         hBLDiUayFfthZAQPdRjdsWL+GoF/k5MJ4XrtkG4r3ETy7E2HWwLt0z7SJvKdJVcmwQtW
         ON3dN+WZbnpPGuztW44h97cX/Y/HwPQdtHBphjc3ODW57/GDuFFAicTKS2xybAeTKiuv
         GrX0gUnTYE+YDAdlC+CpyHbKNbs/bbF6MBbI9DKNGZ0jKc0dmhxHT7D3E/hGHlgVgO4X
         Etz5ERO6XeksR1k22n3uFvC0EFQjqof1V/RO/Qr4UsgAlKJVvdb4/3UjYAOlXmKIK0fy
         o6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6paGRqZC+Saiy/OdOWQy9bDY2PXfN0YJkrt0vyVzmXI=;
        b=dElTSJZLxxmBk+DLdv009Ke92hEFCnjV/yz1zNmruggDzQ+6h79RS+bLPmxLchWWXX
         5zesqR8olUYCeFm0QOEdVOJ/6OU/BW8vu3JHERUBLgz0lVY1gy+yjdNjA8cXrwC26iwl
         ZNu+3Zkd5TbdvVh6A8hbpDfxpoYOtJap06tiqDIm3RK4SiWfuf4T6co6LwQufbnC3Igu
         ihZQw4HOsE9qwxqrF68onLRQPLQnlRkwzaa3npnq/DkBJ9cxyXoCr0lbPERtzJRs90Qv
         vMckJXitwBJfnKJJC753dX1BZ3gw9JJ/oAd10FRw72FrlxMpHVYSM+MW6Pk1KNFua6kb
         /PvA==
X-Gm-Message-State: AOAM530/L2mprmz2+owQIHdAXQIk0Uuf/2sAk+ggPKpGiK/qX4fmZPA7
        mX/SC5+VtPOac8vPbsYzIaiwh4s9nMpEG/AEq7sJr+tDKD8=
X-Google-Smtp-Source: ABdhPJzmkLV3iU8HhDDGcz85czAKO3NR4Cy9fFZK4aEWZplK3Mt2PZiGDbjZepscdMttmj0AiCMkoNL/st7iuznOHdE=
X-Received: by 2002:a4a:946d:: with SMTP id j42mr2261363ooi.39.1611624509049;
 Mon, 25 Jan 2021 17:28:29 -0800 (PST)
MIME-Version: 1.0
References: <1610960877-3110-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1610960877-3110-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 26 Jan 2021 09:28:17 +0800
Message-ID: <CANRm+Cx65UHSJA+S4qRR1wdZ=dhyM=U=KwZnbNUSN4XdM1nyQA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping=EF=BC=8C
On Mon, 18 Jan 2021 at 17:08, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> The per-cpu vsyscall pvclock data pointer assigns either an element of th=
e
> static array hv_clock_boot (#vCPU <=3D 64) or dynamically allocated memor=
y
> hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
> kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
> kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it by not
> assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode is no=
t
> VDSO_CLOCKMODE_PVCLOCK.
>
> Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared vari=
ables")
> Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: stable@vger.kernel.org#v4.19-rc5+
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * add code comments
>
>  arch/x86/kernel/kvmclock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index aa59374..01d4e55c 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -294,9 +294,11 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>         /*
>          * The per cpu area setup replicates CPU0 data to all cpu
>          * pointers. So carefully check. CPU0 has been set up in init
> -        * already.
> +        * already. Assign vsyscall pvclock data pointer iff kvmclock
> +        * vsyscall is enabled.
>          */
> -       if (!cpu || (p && p !=3D per_cpu(hv_clock_per_cpu, 0)))
> +       if (!cpu || (p && p !=3D per_cpu(hv_clock_per_cpu, 0)) ||
> +           (kvm_clock.vdso_clock_mode !=3D VDSO_CLOCKMODE_PVCLOCK))
>                 return 0;
>
>         /* Use the static page for the first CPUs, allocate otherwise */
> --
> 2.7.4
>
