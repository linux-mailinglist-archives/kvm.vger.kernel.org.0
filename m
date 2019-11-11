Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337C1F7484
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKKNG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:06:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43051 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726887AbfKKNG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 08:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573477616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/nIfQxqLHF8WJH+rEaKW6Wt3dYLJAu1w6JfOqOMD8TI=;
        b=G5HXWn0puwcbO1bU2oFyWaXsxOo5mfp+fjX5RlFmwQ6PqfxbnAN440DEOWvSr8R0wlVLKI
        mYvW6H38iGF22xIWGshDWcOvVTvHUeUAIbvR2Z1HVN/HBOXRpMiHSk4CIn1ebTGNseA1R0
        7UcBu4A124IpAzwrh6zM4fYMpEbtQCQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-8EAj8uklPM-HH4xwcEQYqQ-1; Mon, 11 Nov 2019 08:06:56 -0500
Received: by mail-wm1-f70.google.com with SMTP id y133so6169249wmd.8
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 05:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=4OAS54iB143xVEPD/7rq6ekQ537whRG3Ob2iaMwvFJk=;
        b=VQr2RjotTVdXJ+8g8uxHzmnKofj/WD0ETMu5/qBbAzMe2VBb8JqqNe3GybC3NNnvTe
         G1MscfBovZwh81v+aH91HSnCUHrqccyhxXB6EWHocB6yZVQbbwD8eEdaiKUiDouLQXld
         0X5fIjbikbQUJ0vY+gL6UrFH87BL8gMDPYRN5bwh9oz+uE7Im2eCaVtmDwImBnx5OlmA
         JKlhNSQg4ow/6zPMMQSlBOzzmB/ecjapQPWBPIm4aSo1nYk89R+dhAhH4b4zolhzRzFN
         momQOP/T+D7wBP9A/coGpk9uUz/2s8H32zKy87CVXCNqi0f1JJmkFBtZ4QFYxMIzudZx
         MHbw==
X-Gm-Message-State: APjAAAWs+LeKQEcv/soM1GmCkj3NddEsPkALHlj91L5TcJzkNYBKizls
        lcSEiXNC0BBE3/zPsBmDoetGdy4ThLTBZ+WM1ilk/lXKpKhgodd6ywcR8JtDTpuvh6DsZgaQuRb
        wA36Dhpambrdm
X-Received: by 2002:a5d:6585:: with SMTP id q5mr19749278wru.158.1573477614479;
        Mon, 11 Nov 2019 05:06:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqwK2Cvl8KVfnsUhyxsRzcj2clNeIUa936ISnpCpoXkcJmOTBt3FjGd2Dp3SQ4hPmqtyC6A7zA==
X-Received: by 2002:a5d:6585:: with SMTP id q5mr19749257wru.158.1573477614262;
        Mon, 11 Nov 2019 05:06:54 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w10sm13512097wmd.26.2019.11.11.05.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 05:06:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: X86: Single target IPI fastpath
In-Reply-To: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 11 Nov 2019 14:06:52 +0100
Message-ID: <87mud2sgsz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: 8EAj8uklPM-HH4xwcEQYqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

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

I have to admit this looks too much to me :-( Yes, I see the benefits of
taking a shortcut (by actualy penalizing all other MSR writes) but the
question I have is: where do we stop?

Also, this 'shortcut' creates an imbalance in tracing: you don't go down
to kvm_emulate_wrmsr() so handle_ipi_fastpath() should probably gain a
tracepoint.

Looking at 'fast_vmexit' name makes me think this is something
generic. Is this so? Maybe we can create some sort of an infrastructure
for fast vmexit handling and make it easy to hook things up to it?

(Maybe it's just me who thinks the codebase is already too complex,
let's see what Paolo and other reviewers have to say).

--=20
Vitaly

