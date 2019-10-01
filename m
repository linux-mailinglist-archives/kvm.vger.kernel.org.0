Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B71C3E31
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfJARJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 13:09:50 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45864 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfJARJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 13:09:49 -0400
Received: by mail-io1-f66.google.com with SMTP id c25so49818679iot.12
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 10:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m0MgQ5ppurdMXfi+V2kEZtMUpkmon2gEcNILAJgpTX4=;
        b=HPDV3m0dgin1IfpbLLHsIc9K3EwoVG02de0uMssHZYpt4pYJtWZbNPesMaLgf02QvX
         2Io6c+Sgc0vVpCgkY/ytQjLj4zAI9YkBdibY3hqYYhi5poyYHEZd1tX7Gq1f3LN5M4jx
         3LaD6GAQxaO4rv32DCfOEezOLrBXK87XX9U2mEuKvVnCqmOuG8vkb5W33tJMVHYgSRH2
         7xXLWqUYNMScpDOA044B3+4Jy6jt6yNW3AeQEaXH9MadAUsQpOvVITYtJiVWv8X2hRcX
         ej5+C4XM8hr2PMM+iWIe+Dr+apKInQTzJ0jrYgwTOiOqb2Lfn9zrXuChtBP6s0vRUVPE
         CHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m0MgQ5ppurdMXfi+V2kEZtMUpkmon2gEcNILAJgpTX4=;
        b=uPws0ZHVwLwlAsXro3Itx2YZ2VLjIe8dX9B1jTTLDWxkIJ9yjd3lutOXaznOR2fkec
         1IaFSzPZP0pJixu3Sb9WtLf4dap00jp9mSESqexrn8lSUwwq79mNwd5Qs0DeGDy4Yz//
         RtdPxh62zH5BQXJNWSKO/XLmvVJ0O6V/oB1giOX3xILROQvheKyMjZtyPonF5gEEob1m
         iATDsYZIzxGf2Z3gOFxD2aq3vVPc1e+XnodeP69E/0v0BJymqx8UngYAsXUsHkfgFMRi
         Ig7oFHZM9tZSHQ/Rm7+ufcu5bnJ2YKrgaVcT0u8Av7XsEGGbEsQskEkPIhzn+Q3ZOJYI
         907g==
X-Gm-Message-State: APjAAAWh5H0ACVLYFwllL24jXzOQ/cIC2irsEumlnUPuwjqJySmVH10J
        JLywR3BGfPlei8Wz+gSqDecfhwHBoJ7erhHj1uWUDyZbA+QArQ==
X-Google-Smtp-Source: APXvYqzix/540/lY+fm0MA3r9GXjK7ZY/iCLIAuHUxABAMOL+U5GKfx8i4XN7RmiFNugUAH8yo7ajqWxaMnXIt6PFYw=
X-Received: by 2002:a92:8e4f:: with SMTP id k15mr29184783ilh.108.1569949782557;
 Tue, 01 Oct 2019 10:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190930233626.22852-1-krish.sadhukhan@oracle.com> <20190930233626.22852-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20190930233626.22852-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 1 Oct 2019 10:09:31 -0700
Message-ID: <CALMp9eRq+oib=S5X8rxJNxwqQUYRnLrSYcxKxWaxSKid69WJ=w@mail.gmail.com>
Subject: Re: [PATCH] nVMX: Defer error from VM-entry MSR-load area to until
 after hardware verifies VMCS guest state-area
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 5:12 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section =E2=80=9CVM Entries=E2=80=9D in Intel SDM vol 3C, VM=
-entry checks are
> performed in a certain order. Checks on MSRs that are loaded on VM-entry
> from VM-entry MSR-load area, should be done after verifying VMCS controls=
,
> host-state area and guest-state area. As KVM relies on CPU hardware to
> perform some of these checks, we need to defer VM-exit due to invalid
> VM-entry MSR-load area to until after CPU hardware completes the earlier
> checks and is ready to do VMLAUNCH/VMRESUME.
>
> In order to defer errors arising from invalid VM-entry MSR-load area in
> vmcs12, we set up a single invalid entry, which is illegal according to
> section "Loading MSRs in Intel SDM vol 3C, in VM-entry MSR-load area of
> vmcs02. This will cause the CPU hardware to VM-exit with "VM-entry failur=
e
> due to MSR loading" after it completes checks on VMCS controls, host-stat=
e
> area and guest-state area. We reflect a synthesized Exit Qualification to
> our guest.

This change addresses the priority inversion, but it still potentially
leaves guest MSRs incorrectly loaded with values from the VMCS12
VM-entry MSR-load area when a higher priority error condition would
have precluded any processing of the VM-entry MSR-load area.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++---
>  arch/x86/kvm/vmx/nested.h | 14 ++++++++++++--
>  arch/x86/kvm/vmx/vmcs.h   |  6 ++++++
>  3 files changed, 49 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..b74491c04090 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3054,12 +3054,40 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcp=
u *vcpu, bool from_vmentry)
>                 goto vmentry_fail_vmexit_guest_mode;
>
>         if (from_vmentry) {
> -               exit_reason =3D EXIT_REASON_MSR_LOAD_FAIL;
>                 exit_qual =3D nested_vmx_load_msr(vcpu,
>                                                 vmcs12->vm_entry_msr_load=
_addr,
>                                                 vmcs12->vm_entry_msr_load=
_count);
> -               if (exit_qual)
> -                       goto vmentry_fail_vmexit_guest_mode;
> +               if (exit_qual) {
> +                       /*
> +                        * According to section =E2=80=9CVM Entries=E2=80=
=9D in Intel SDM
> +                        * vol 3C, VM-entry checks are performed in a cer=
tain
> +                        * order. Checks on MSRs that are loaded on VM-en=
try
> +                        * from VM-entry MSR-load area, should be done af=
ter
> +                        * verifying VMCS controls, host-state area and
> +                        * guest-state area. As KVM relies on CPU hardwar=
e to
> +                        * perform some of these checks, we need to defer
> +                        * VM-exit due to invalid VM-entry MSR-load area =
to
> +                        * until after CPU hardware completes the earlier
> +                        * checks and is ready to do VMLAUNCH/VMRESUME.
> +                        *
> +                        * In order to defer errors arising from invalid
> +                        * VM-entry MSR-load area in vmcs12, we set up a
> +                        * single invalid entry, which is illegal accordi=
ng
> +                        * to section "Loading MSRs in Intel SDM vol 3C, =
in
> +                        * VM-entry MSR-load area of vmcs02. This will ca=
use
> +                        * the CPU hardware to VM-exit with "VM-entry
> +                        * failure due to MSR loading" after it completes
> +                        * checks on VMCS controls, host-state area and
> +                        * guest-state area.
> +                        */
> +                       vmx->loaded_vmcs->invalid_msr_load_area.index =3D
> +                           MSR_FS_BASE;

Can this field be statically populated during initialization?

> +                       vmx->loaded_vmcs->invalid_msr_load_area.value =3D
> +                           exit_qual;

This seems awkward. Why not save 16 bytes per loaded_vmcs by
allocating one invalid_msr_load_area system-wide and just add a 4 byte
field to struct nested_vmx to store this value?

> +                       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 1);
> +                       vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR,
> +                           __pa(&(vmx->loaded_vmcs->invalid_msr_load_are=
a)));
> +               }

Do you need to set vmx->nested.dirty_vmcs12 to ensure that
prepare_vmcs02_constant_state() will be called at the next emulated
VM-entry, to undo this change to VM_ENTRY_MSR_LOAD_ADDR?

>         } else {
>                 /*
>                  * The MMU is not initialized to point at the right entit=
ies yet and
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 187d39bf0bf1..f3a384235b68 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -64,7 +64,9 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcp=
u *vcpu)
>  static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
>                                             u32 exit_reason)
>  {
> +       u32 exit_qual;
>         u32 exit_intr_info =3D vmcs_read32(VM_EXIT_INTR_INFO);
> +       struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>
>         /*
>          * At this point, the exit interruption info in exit_intr_info
> @@ -81,8 +83,16 @@ static inline int nested_vmx_reflect_vmexit(struct kvm=
_vcpu *vcpu,
>                         vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
>         }
>
> -       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
> -                         vmcs_readl(EXIT_QUALIFICATION));
> +       exit_qual =3D vmcs_readl(EXIT_QUALIFICATION);
> +
> +       if (vmx->loaded_vmcs->invalid_msr_load_area.index =3D=3D MSR_FS_B=
ASE &&
> +           (exit_reason =3D=3D (VMX_EXIT_REASONS_FAILED_VMENTRY |
> +                           EXIT_REASON_MSR_LOAD_FAIL))) {

Is the second conjunct sufficient? i.e. Isn't there a bug in kvm if
the second conjunct is true and the first is not?

> +               exit_qual =3D vmx->loaded_vmcs->invalid_msr_load_area.val=
ue;
> +       }
> +
> +       nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
> +
>         return 1;
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 481ad879197b..e272788bd4b8 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -70,6 +70,12 @@ struct loaded_vmcs {
>         struct list_head loaded_vmcss_on_cpu_link;
>         struct vmcs_host_state host_state;
>         struct vmcs_controls_shadow controls_shadow;
> +       /*
> +        * This field is used to set up an invalid VM-entry MSR-load area
> +        * for vmcs02 if an error is detected while processing the entrie=
s
> +        * in VM-entry MSR-load area of vmcs12.
> +        */
> +       struct vmx_msr_entry invalid_msr_load_area;
>  };

I'd suggest allocating just one invalid_msr_load_area system-wide, as
mentioned above.

>  static inline bool is_exception_n(u32 intr_info, u8 vector)
> --
> 2.20.1
>
