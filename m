Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28038E80B
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhEXNvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:51:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232548AbhEXNv2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 09:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621864200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TsRJK9bUG+f7oAKkH7rO4U2x+my3f03n8SpUCLxXD34=;
        b=JKh7W7kVGVbJSYj8Hb6MzfbczK677Cu5k5KaJhSYyyhpcw0Z8MoCDmTrLSCzngJzuW23qq
        VFhe8o3wIQF4hXTCpm+IGgfk3SxT/K28jTTM9QfOgQRoaeor2IuK/cG/HHNX93h2eR9BOo
        AOFNPFFqi1KFOoxCecwHiMaE8JkDwmw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-onIkEdUKMzyM_ME6nU-DcA-1; Mon, 24 May 2021 09:49:58 -0400
X-MC-Unique: onIkEdUKMzyM_ME6nU-DcA-1
Received: by mail-wr1-f70.google.com with SMTP id 2-20020adf94020000b0290110481f75ddso13135644wrq.21
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:49:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TsRJK9bUG+f7oAKkH7rO4U2x+my3f03n8SpUCLxXD34=;
        b=OBzjstO+DTfNsyYCRELsO2hTeVjia3BeQuZv4b+37dDWQakAAPU3nV+rcs8V+efIGa
         BUQfOmcsQLAVFzMdL3n7MLvH6JOPHGBRBV1Q/MuXpkDaPpblOnNbYT6rOfXTqkUPYXpP
         oaEbbMLVeauEq/FF0ZlClvY/A0zuJh0DvVeqQl/mkHYwlAjD9UAygHJW93fgJeRodCE7
         L3OvRutm1vEdmNmTy8ku5facpMcoK/29ajuwA/LEjiXU9g+/bGfD8g07by/MfRfqiLAl
         PjFND9FrhsK+nrKUcH2rBTz4yryR+HitLDTUev5Ch4R84DRDuQit+kvEVmLiwVK74uyv
         zqlA==
X-Gm-Message-State: AOAM530drUE1geAueRPqFOP156zljbk1p4/GlbFz5t33GRrJ3Qni4AS9
        /QYgWv03O30dPKBcW3+4uin4YqcepZb5t0XsaBkrG/2DOe2h/icqBMYHrsCeh2Ay8hNmXLBG4WP
        CbBwDPPtXiSrn
X-Received: by 2002:a5d:6804:: with SMTP id w4mr22745186wru.363.1621864197372;
        Mon, 24 May 2021 06:49:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyj2Rnn0cptMYn76rN0R/AS1CMfHJoUzXNI4pJH3SU6c0zLWXv1j/w7RtZbBs6kgeC4K1KH8Q==
X-Received: by 2002:a5d:6804:: with SMTP id w4mr22745157wru.363.1621864197121;
        Mon, 24 May 2021 06:49:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q1sm8044605wmq.48.2021.05.24.06.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:49:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
In-Reply-To: <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
Date:   Mon, 24 May 2021 15:49:55 +0200
Message-ID: <87tums8cn0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 5/24/21 6:53 AM, Vitaly Kuznetsov wrote:
>> Tom Lendacky <thomas.lendacky@amd.com> writes:
>> 
>>> When processing a hypercall for a guest with protected state, currently
>>> SEV-ES guests, the guest CS segment register can't be checked to
>>> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
>>> expected that communication between the guest and the hypervisor is
>>> performed to shared memory using the GHCB. In order to use the GHCB, the
>>> guest must have been in long mode, otherwise writes by the guest to the
>>> GHCB would be encrypted and not be able to be comprehended by the
>>> hypervisor. Given that, assume that the guest is in 64-bit mode when
>>> processing a hypercall from a guest with protected state.
>>>
>>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
>>> Reported-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>  arch/x86/kvm/x86.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 9b6bca616929..e715c69bb882 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>  
>>>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>>>  
>>> -	op_64_bit = is_64_bit_mode(vcpu);
>>> +	/*
>>> +	 * If running with protected guest state, the CS register is not
>>> +	 * accessible. The hypercall register values will have had to been
>>> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
>>> +	 */
>>> +	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
>>>  	if (!op_64_bit) {
>>>  		nr &= 0xFFFFFFFF;
>>>  		a0 &= 0xFFFFFFFF;
>> 
>> While this is might be a very theoretical question, what about other
>> is_64_bit_mode() users? Namely, a very similar to the above check exists
>> in kvm_hv_hypercall() and kvm_xen_hypercall().
>
> Xen doesn't support SEV, so I think this one is ok until they do. Although
> I guess we could be preemptive and hit all those call sites. The other
> ones are in arch/x86/kvm/hyperv.c.
>
> Thoughts?

Would it hurt if we just move 'vcpu->arch.guest_state_protected' check
to is_64_bit_mode() itself? It seems to be too easy to miss this
peculiar detail about SEV in review if new is_64_bit_mode() users are to
be added.

-- 
Vitaly

