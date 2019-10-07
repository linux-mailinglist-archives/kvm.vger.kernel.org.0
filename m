Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38248CDEB2
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 12:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfJGKHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 06:07:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29245 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbfJGKHH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Oct 2019 06:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570442825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oom53FE9A6mdwGqsiLY5WAzQzRP9/8f6FQm6/+Cn4i0=;
        b=FEHd61eFoayVHWmWBNcLTyxf+c1YgabjxZ9ZkZNnFCoj1WOtYaF/07HYp7+JR7HNWLkEgt
        OaTCn0L/om7CdrA7L5rXxfq8b4kOe9mUyBoEiBDlWXWR5A9ms5heFKGX00kbPsUX18mnUm
        +Hfpk78Ps+C0RPD2wKmN3LCRrerJLo0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-wD38Pe_vP2SXSiSKfi3V0w-1; Mon, 07 Oct 2019 06:07:01 -0400
Received: by mail-wr1-f72.google.com with SMTP id m14so7277816wru.17
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 03:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RfDzyrGs+LQND+k2V+eGtZAWoK0sdlPn6cZQKjiFyrQ=;
        b=fkVIsrnXgCSpIwLICZWLJrZo9cHx8O5iajpQPLAU0qktWtL9X7Uxtnrf16eHPoK66T
         ntXYNLBhqseYa2GvOdg1ol/N0se1kTgwDX4EvQsMj8nVf3mR9SuWFCom57gK3+7IpCM6
         53ZH1LD7pWfjRtToPvsDStGVtb8yUyGBN2EmAJ/iSMrBtQsk9UyIfIe8MSuK3RxMMxm/
         A7ASkEMFdMIqnettBhgCBhXZ2es2x5iU+Nu83D6ZlwGb7OrDrTLMy7+n75rS9PJZcPV6
         uV7zu61DGPV5B+Syk4vfwchL1GKIUdxz5Y0Jp6SN67isqQNdpu7X+Mr2Ul/08kTTILpd
         HcHA==
X-Gm-Message-State: APjAAAUoBqH5kFIbqKQj3nhixG45NCkVCaRKLj8Eh37Ve7q2KT0V2pyr
        hojRswlWwlvWOjJBHqZIHdZcSXbT2xpVWt5etia1HC3JWeKybYAo0zkeWyT9RggzJDGUGApPsCL
        y99li5PaMNfXI
X-Received: by 2002:a1c:2388:: with SMTP id j130mr18999510wmj.107.1570442820659;
        Mon, 07 Oct 2019 03:07:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqykCVDvEaD9dB97xqiTqVJi/og1RfroEc7kJI0ZcQovNe0OEiv+JMRvXEM+Vg2PJbLXYP9clg==
X-Received: by 2002:a1c:2388:: with SMTP id j130mr18999486wmj.107.1570442820331;
        Mon, 07 Oct 2019 03:07:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dd9:ce92:89b5:d1f2? ([2001:b07:6468:f312:9dd9:ce92:89b5:d1f2])
        by smtp.gmail.com with ESMTPSA id h7sm14696578wrs.15.2019.10.07.03.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 03:06:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Dan Cross <dcross@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20191004175203.145954-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4570ffc-fa77-bc18-66cb-b08205c237b1@redhat.com>
Date:   Mon, 7 Oct 2019 12:07:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191004175203.145954-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: wD38Pe_vP2SXSiSKfi3V0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As usual, nothing to say about the behavior, just about the code...

On 04/10/19 19:52, Jim Mattson wrote:
> + * Returns:
> + *   0 - success, i.e. proceed with actual VMEnter
> + *  -EFAULT - consistency check VMExit
> + *  -EINVAL - consistency check VMFail
> + *  -ENOTSUPP - kvm internal error
>   */

... the error codes do not mean much here.  Can you define an enum instead?

(I also thought about passing the exit reason, where bit 31 could be
used to distinguish VMX instruction failure from an entry failure
VMexit, which sounds cleaner if you just look at the prototype but
becomes messy fairly quickly because you have to pass back the exit
qualification too.  The from_vmentry argument could become u32
*p_exit_qual and be NULL if not called from VMentry, but it doesn't seem
worthwhile at all).

Thanks,

Paolo

>  int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmen=
try)
>  {
> @@ -3045,6 +3044,7 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcpu =
*vcpu, bool from_vmentry)
>  =09bool evaluate_pending_interrupts;
>  =09u32 exit_reason =3D EXIT_REASON_INVALID_STATE;
>  =09u32 exit_qual;
> +=09int r;
> =20
>  =09evaluate_pending_interrupts =3D exec_controls_get(vmx) &
>  =09=09(CPU_BASED_VIRTUAL_INTR_PENDING | CPU_BASED_VIRTUAL_NMI_PENDING);
> @@ -3081,11 +3081,13 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcp=
u *vcpu, bool from_vmentry)
>  =09prepare_vmcs02_early(vmx, vmcs12);
> =20
>  =09if (from_vmentry) {
> -=09=09nested_get_vmcs12_pages(vcpu);
> +=09=09r =3D nested_get_vmcs12_pages(vcpu);
> +=09=09if (unlikely(r))
> +=09=09=09return r;
> =20
>  =09=09if (nested_vmx_check_vmentry_hw(vcpu)) {
>  =09=09=09vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> -=09=09=09return -1;
> +=09=09=09return -EINVAL;
>  =09=09}
> =20
>  =09=09if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
> @@ -3165,14 +3167,14 @@ int nested_vmx_enter_non_root_mode(struct kvm_vcp=
u *vcpu, bool from_vmentry)
>  =09vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> =20
>  =09if (!from_vmentry)
> -=09=09return 1;
> +=09=09return -EFAULT;
> =20
>  =09load_vmcs12_host_state(vcpu, vmcs12);
>  =09vmcs12->vm_exit_reason =3D exit_reason | VMX_EXIT_REASONS_FAILED_VMEN=
TRY;
>  =09vmcs12->exit_qualification =3D exit_qual;
>  =09if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
>  =09=09vmx->nested.need_vmcs12_to_shadow_sync =3D true;
> -=09return 1;
> +=09return -EFAULT;
>  }
> =20
>  /*
> @@ -3246,11 +3248,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, =
bool launch)
>  =09vmx->nested.nested_run_pending =3D 1;
>  =09ret =3D nested_vmx_enter_non_root_mode(vcpu, true);
>  =09vmx->nested.nested_run_pending =3D !ret;
> -=09if (ret > 0)
> -=09=09return 1;
> -=09else if (ret)
> +=09if (ret =3D=3D -EINVAL)
>  =09=09return nested_vmx_failValid(vcpu,
>  =09=09=09VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> +=09else if (ret =3D=3D -ENOTSUPP)
> +=09=09return 0;
> +=09else if (ret)
> +=09=09return 1;
> =20
>  =09/* Hide L1D cache contents from the nested guest.  */
>  =09vmx->vcpu.arch.l1tf_flush_l1d =3D true;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e6b5cfe3c345..e8b04560f064 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7931,8 +7931,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  =09bool req_immediate_exit =3D false;
> =20
>  =09if (kvm_request_pending(vcpu)) {
> -=09=09if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
> -=09=09=09kvm_x86_ops->get_vmcs12_pages(vcpu);
> +=09=09if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> +=09=09=09r =3D kvm_x86_ops->get_vmcs12_pages(vcpu);
> +=09=09=09if (unlikely(r)) {
> +=09=09=09=09r =3D 0;
> +=09=09=09=09goto out;
> +=09=09=09}
> +=09=09}
>  =09=09if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
>  =09=09=09kvm_mmu_unload(vcpu);
>  =09=09if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))

