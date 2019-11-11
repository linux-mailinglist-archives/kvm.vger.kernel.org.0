Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B28F7535
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKKNkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:40:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51250 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726832AbfKKNkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573479606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ff9ECgjPHGz7wG+iMyiY+/SCFDtmoWSTMld7VReaXoM=;
        b=HOqO96mPxASOkdHg00mrepH36BnFZ21cRPUe4CnIAFGUWxaOwZG1aQzu5ddkmwy4bby66Q
        yEdS1PdIrA/7wV0/L32dok68V+itOnOxDeZ1tV8cXRnv47ujnTkiQ2z+foclbRnX8cHqQI
        zGjbvTuMaiTzIt3jKS0fy4dTH7unuSk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-d2AhVGKWNHefi9FPkiweSg-1; Mon, 11 Nov 2019 08:40:03 -0500
Received: by mail-wr1-f72.google.com with SMTP id p4so4092020wrw.15
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FenIi8WLpskbHTiZNuueQlllK+40g3t9+0j2jGLUoM8=;
        b=NbdUnKEGkAqJZ7ZZLt6aqXMo45xHD78BGSfnkCNTDgyNhdj/BgYKYfszcSWX5T1TYu
         tZROPQ2SaX1wTzFO7gWH2TQ4mQeW7U0/BvKlSSKbMW5oT14nIfsyyTknOKFDiw2mqKsz
         BiV+Q+v2r9CaOLbJ2ezqC/IcY0gNCv+1BBvuCVtehUPPJox/ePc8onNm0wwgm6nKfD65
         JzQbF5Eb3r8btU7cepWdeJkb58YdMykTSDjT7Nbwn0kVLa4NFoSxr0Pv8y7nfmPAcsso
         V4pI7mhjNyXgVh6zVek7oPZwx62ikqJFBZg/6guuWMcJIjZGBzo/+5cqbFecKkvvbcjA
         gBoA==
X-Gm-Message-State: APjAAAUcMB26VjCc7qvAbGWnx921OWPWH9GdakfPSsTKPt9UkANOk53h
        z7BbVLSTSckExDINIaFpsz5PxEp8o0kK++CgXYxi6YEi5utGeJ55Oo7tkiz/rudkyA+A6ilfQ4h
        zj0ox5zpaxRF5
X-Received: by 2002:a5d:6585:: with SMTP id q5mr19865682wru.158.1573479601934;
        Mon, 11 Nov 2019 05:40:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqyU1GIx2EgI/jEqh7nJpYft0vSFG6OBadHqk3cP8N847KtIq/Fv33+o7no7N95wOBt4fC6IrA==
X-Received: by 2002:a5d:6585:: with SMTP id q5mr19865659wru.158.1573479601647;
        Mon, 11 Nov 2019 05:40:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id h8sm33480282wrc.73.2019.11.11.05.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 05:40:01 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: Prevent set vCPU into INIT/SIPI_RECEIVED
 state when INIT are latched
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Mihai Carabas <mihai.carabas@oracle.com>
References: <20191111091640.92660-1-liran.alon@oracle.com>
 <20191111091640.92660-3-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cff559e6-7cc4-64f3-bebf-e72dd2a5a3ea@redhat.com>
Date:   Mon, 11 Nov 2019 14:40:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111091640.92660-3-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: d2AhVGKWNHefi9FPkiweSg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 10:16, Liran Alon wrote:
> -=09/* INITs are latched while in SMM */
> -=09if ((is_smm(vcpu) || vcpu->arch.smi_pending) &&
> +=09/* INITs are latched while CPU is in specific states */
> +=09if ((kvm_vcpu_latch_init(vcpu) || vcpu->arch.smi_pending) &&
>  =09    (mp_state->mp_state =3D=3D KVM_MP_STATE_SIPI_RECEIVED ||
>  =09     mp_state->mp_state =3D=3D KVM_MP_STATE_INIT_RECEIVED))
>  =09=09goto out;

Just a small doc clarification:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 318046647fda..cacfe14717d6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2707,7 +2707,8 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 =09=09return;
=20
 =09/*
-=09 * INITs are latched while CPU is in specific states.
+=09 * INITs are latched while CPU is in specific states
+=09 * (SMM, VMX non-root mode, SVM with GIF=3D0).
 =09 * Because a CPU cannot be in these states immediately
 =09 * after it has processed an INIT signal (and thus in
 =09 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 681544f8db31..11746534e209 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8706,7 +8706,11 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
*vcpu,
 =09    mp_state->mp_state !=3D KVM_MP_STATE_RUNNABLE)
 =09=09goto out;
=20
-=09/* INITs are latched while CPU is in specific states */
+=09/*
+=09 * KVM_MP_STATE_INIT_RECEIVED means the processor is in
+=09 * INIT state; latched init should be reported using
+=09 * KVM_SET_VCPU_EVENTS, so reject it here.
+=09 */
 =09if ((kvm_vcpu_latch_init(vcpu) || vcpu->arch.smi_pending) &&
 =09    (mp_state->mp_state =3D=3D KVM_MP_STATE_SIPI_RECEIVED ||
 =09     mp_state->mp_state =3D=3D KVM_MP_STATE_INIT_RECEIVED))


I'm not sure why you're removing the first hunk, it's just meant to
explain why it needs to be a kvm_x86_ops in case the reader is not
thinking about nested virtualization.

Paolo

