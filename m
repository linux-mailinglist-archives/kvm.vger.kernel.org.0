Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D263410FC
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 00:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhCRXZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 19:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbhCRXZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 19:25:08 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4461BC06174A
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 16:25:08 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so6838760otn.1
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 16:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TJHCMzvDoOOFLKNBK9gJ5aBbtoQqOTfITOWVCVPOp4E=;
        b=s+kAb3glI5ajffbYbYZhXXFPFsCR0bDlxUlpJXaw/gigN3KK3HxAe1lsRHdWlML+p1
         18dAfIuXNzQ/edKjdjcHinBFSabx+5im4v12u6xIMDiISY+VCDbwuC00a8PQlzkqSaHF
         vAEL5UYkssrGouKOxT6cvwMvvmG/5v0RkDEsuBw7ns1dpTP80zvOwnQY/n+jSgCHxYrV
         NLL/jwh6eqv77u5GAk4eMNlTmO1BRZ6GPkK27ar+QiUGhxW2KCOCfFjLbrT74hKi0i/W
         LanMHl01/o/+86j1/1hY4b+6GCW0OoC0yTj95g0jb9sz6Qw/d4uF3Lvh9hPHMK1CNG7k
         mDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TJHCMzvDoOOFLKNBK9gJ5aBbtoQqOTfITOWVCVPOp4E=;
        b=PMacfv0APkyv2if5Xt1n9UEuAjUesjvYrt8cp+IA7AVhlkqpxDyb/jViYDdZQ64Z9s
         GwNx1UeK3znqm6i4KeBp902hSpTG6hNP3yDnE53SpUxTZ+sXULYYNHOHIMZKoySe7x6v
         fioAC29N675cX3FZfQtKOmY81hwWwDLer+4nhFE1+PHCpS/Oj5XOoU5BRiG0LUa0L/L+
         OAS8pJtFy1GT53T7zW02q9W52Fc96uHKDQUK5PqvzDHVfRvHpebbWgjahSa3kbjTxaDP
         fQ/S950ls3ZSIKjERaTWsjFcTDyyeZsH63Bm3aYHXA+Nh/gc3PvX56GzvXlSvUPw1pbg
         p4YQ==
X-Gm-Message-State: AOAM532XVxNZKYlAlFKlTMP+yNQKZCN437OMz1PvgYvL6cKtzyvEoXDs
        DZhkhaEpDh7ZJeesFMs74Vl9Lb0TXz6NNbaPPPesUg==
X-Google-Smtp-Source: ABdhPJyj39gOA85ZUELpJM9blyYfb+mLUNNWmehmzXz7QqPoDgQZvRWXkXRECc6a5SvrNz0PFEGnLLjan7kzq085lPI=
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr9252681otc.56.1616109907375;
 Thu, 18 Mar 2021 16:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190123223925.7558-1-sean.j.christopherson@intel.com> <20190123223925.7558-4-sean.j.christopherson@intel.com>
In-Reply-To: <20190123223925.7558-4-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 18 Mar 2021 16:24:56 -0700
Message-ID: <CALMp9eTow8rdn2zerJgX+4XiVW0bZ=XGWCxJqCwr0wO_G9PTzg@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: nVMX: Ignore limit checks on VMX instructions
 using flat segments
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 23, 2019 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Regarding segments with a limit=3D=3D0xffffffff, the SDM officially state=
s:
>
>     When the effective limit is FFFFFFFFH (4 GBytes), these accesses may
>     or may not cause the indicated exceptions.  Behavior is
>     implementation-specific and may vary from one execution to another.
>
> In practice, all CPUs that support VMX ignore limit checks for "flat
> segments", i.e. an expand-up data or code segment with base=3D0 and
> limit=3D0xffffffff.  This is subtly different than wrapping the effective
> address calculation based on the address size, as the flat segment
> behavior also applies to accesses that would wrap the 4g boundary, e.g.
> a 4-byte access starting at 0xffffffff will access linear addresses
> 0xffffffff, 0x0, 0x1 and 0x2.
>
> Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS=
 exceptions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc8e3fc6724d..537c4899cf20 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4097,10 +4097,16 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, un=
signed long exit_qualification,
>                 /* Protected mode: #GP(0)/#SS(0) if the segment is unusab=
le.
>                  */
>                 exn =3D (s.unusable !=3D 0);
> -               /* Protected mode: #GP(0)/#SS(0) if the memory
> -                * operand is outside the segment limit.
> +
> +               /*
> +                * Protected mode: #GP(0)/#SS(0) if the memory operand is
> +                * outside the segment limit.  All CPUs that support VMX =
ignore
> +                * limit checks for flat segments, i.e. segments with bas=
e=3D=3D0,
> +                * limit=3D=3D0xffffffff and of type expand-up data or co=
de.
>                  */
> -               exn =3D exn || (off + sizeof(u64) > s.limit);
> +               if (!(s.base =3D=3D 0 && s.limit =3D=3D 0xffffffff &&
> +                    ((s.type & 8) || !(s.type & 4))))
> +                       exn =3D exn || (off + sizeof(u64) > s.limit);

I know I signed off on this, but looking at it again, I don't think
this is correct for expand-down segments.

From the SDM:

> For expand-down segments, the segment limit has the reverse function; the=
 offset can range from the segment limit plus 1 to FFFFFFFFH or FFFFH, depe=
nding on the setting of the B flag. Offsets less than or equal to the segme=
nt limit generate general-protection exceptions or stack-fault exceptions.
