Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0EAFC5C8
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 12:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfKNL7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 06:59:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44138 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726185AbfKNL7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 06:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573732742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4US+hVaXhjSiBbdSE96WD7Ru4CXdoh15YX5CrSFyPiQ=;
        b=Qwb5matFUaogQMtc2A6AQwxe24GIZfADhCJ2Kxf28/YyyEgpx8cZSY0zQR0buYHzDX8Mgt
        EewHIRscTI0PXvULHB63+S9kQ1K4+LJ4cQ8rZsjCs9HAtpOvw2reNc4SIyT4cQjMFxUU1i
        8FzoUn+uIx/cJawyefu4OuFKCJiRSf0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-DFzOrsSnP6WQG2hmqE2y7w-1; Thu, 14 Nov 2019 06:58:57 -0500
Received: by mail-wr1-f71.google.com with SMTP id p4so4242725wrw.15
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 03:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0g9kY8U3aDWmWJZUL7RMmE4YKOXbneFc8qmjFB/A0xY=;
        b=tEXOu3T7/N9gQ8Y2/EKc64E3Yhl2MoD6GGfdPNtUydMueyU/DnpF2oyPFQqvBhITDM
         NEZn72ejNRd3CvtOlhA9LzDJRHA+wKyb9F6LjBqufsURa7vbymKMU3hYZwRx1hgAtUbG
         ajcL2ZZL4wVFSbSxR17190wMxrtJ7v4jo7ppTF7kBciqebHjZelUgTfuI4leV2DmHvrG
         LYsbHUVJM6oMkbtpVGn1czxv1kb7qOvVCWfqIRPIxeXyL7x3ANs+PbNiUK2iM249ZVQR
         p4+F4sM9M7u19GEG6WShQy1WPPKu7JYVi51THFDrU+xGn9EuqocCNjIUz3wYU6FJmeIr
         iO7A==
X-Gm-Message-State: APjAAAVW54Zpu0n9otAvaFyudoWe0xBtJPVVbKxe20FoJ2rKjr0G2zKY
        xUWfwoBUr2icXvpr+CqOf/hwO1richQ7GteFnAoAOCcS9XOaS6NbJZEB0l9l+Qqx3O3+ai2at45
        yvwZjOMsal81E
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr7190771wmi.107.1573732736498;
        Thu, 14 Nov 2019 03:58:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqyylEnjoowHo+iG1a27HITqVo45Zcec78KDUK0v5xjWdnKee268qZqMdmqk0rsDKLg83svKyw==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr7190748wmi.107.1573732736192;
        Thu, 14 Nov 2019 03:58:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id z14sm6685230wrl.60.2019.11.14.03.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 03:58:55 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c2c7bbb-39f4-2a77-632e-7730e9887fc5@redhat.com>
Date:   Thu, 14 Nov 2019 12:58:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
Content-Language: en-US
X-MC-Unique: DFzOrsSnP6WQG2hmqE2y7w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ok, it's not _so_ ugly after all.

> ---
>  arch/x86/kvm/vmx/vmx.c   | 39 +++++++++++++++++++++++++++++++++++++--
>  include/linux/kvm_host.h |  1 +
>  2 files changed, 38 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5d21a4a..5c67061 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5924,7 +5924,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  =09=09}
>  =09}
> =20
> -=09if (exit_reason < kvm_vmx_max_exit_handlers
> +=09if (vcpu->fast_vmexit)
> +=09=09return 1;
> +=09else if (exit_reason < kvm_vmx_max_exit_handlers

Instead of a separate vcpu->fast_vmexit, perhaps you can set exit_reason
to vmx->exit_reason to -1 if the fast path succeeds.

> +=09=09=09if (ret =3D=3D 0)
> +=09=09=09=09ret =3D kvm_skip_emulated_instruction(vcpu);

Please move the "kvm_skip_emulated_instruction(vcpu)" to
vmx_handle_exit, so that this basically is

#define EXIT_REASON_NEED_SKIP_EMULATED_INSN -1

=09if (ret =3D=3D 0)
=09=09vcpu->exit_reason =3D EXIT_REASON_NEED_SKIP_EMULATED_INSN;

and handle_ipi_fastpath can return void.

Thanks,

Paolo

> +=09=09};
> +=09};
> +
> +=09return ret;
> +}
> +
>  static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>  =09struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> @@ -6615,6 +6645,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  =09=09=09=09  | (1 << VCPU_EXREG_CR3));
>  =09vcpu->arch.regs_dirty =3D 0;
> =20
> +=09vmx->exit_reason =3D vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON)=
;
> +=09vcpu->fast_vmexit =3D false;
> +=09if (!is_guest_mode(vcpu) &&
> +=09=09vmx->exit_reason =3D=3D EXIT_REASON_MSR_WRITE)
> +=09=09vcpu->fast_vmexit =3D handle_ipi_fastpath(vcpu);

This should be done later, at least after kvm_put_guest_xcr0, because
running with partially-loaded guest state is harder to audit.  The best
place to put it actually is right after the existing vmx->exit_reason
assignment, where we already handle EXIT_REASON_MCE_DURING_VMENTRY.

>  =09pt_guest_exit(vmx);
> =20
>  =09/*
> @@ -6634,7 +6670,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  =09vmx->nested.nested_run_pending =3D 0;
>  =09vmx->idt_vectoring_info =3D 0;
> =20
> -=09vmx->exit_reason =3D vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON)=
;
>  =09if ((u16)vmx->exit_reason =3D=3D EXIT_REASON_MCE_DURING_VMENTRY)
>  =09=09kvm_machine_check();
> =20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 719fc3e..7a7358b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -319,6 +319,7 @@ struct kvm_vcpu {
>  #endif
>  =09bool preempted;
>  =09bool ready;
> +=09bool fast_vmexit;
>  =09struct kvm_vcpu_arch arch;
>  =09struct dentry *debugfs_dentry;
>  };
>=20

