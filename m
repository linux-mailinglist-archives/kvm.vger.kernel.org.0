Return-Path: <kvm+bounces-72511-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOl+JKyrpmn9SgAAu9opvQ
	(envelope-from <kvm+bounces-72511-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:36:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6EC1EBF7A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3B30301A687
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 09:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BFA38F623;
	Tue,  3 Mar 2026 09:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/GnIjwj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rQc+n0mt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FFC38CFEE
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 09:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772530590; cv=none; b=L1omhSguHZ3Y47wqqE4Cc1PiabIXwGUtSqDnH/HpYMtLG4Wtz957U3CxfWoNxA6ozNPwq78o2vaCi5JFWXy5PBChWkhnW2CBsnbOQ1/Cca20cMNL/702atKsAAIInicDfigo6KKsGrBpUtcnTq7R1jbizMOW8tU2OBRFdR9TWvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772530590; c=relaxed/simple;
	bh=6+oOwL5sXpavV8Fl1wAtLxgVtBUqV+1SjYNS3NMAzvE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tkUAirB0qUCdsIuGLNGCWmjd9ZqcWZehUkO+3/Yam5c5IcdU/g/YR0d2ApOhnGl4+H4mSfL5NyaqTXhFxPaoBKxA+6y38O73pXKyJQK9NbPo48SzEnQ3Q3XKadVsZgYb0RrMp9BJ7/gHS5gEU7o7pkvasxcczNsqfT+zJAkSW1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/GnIjwj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rQc+n0mt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772530587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eztC7kwBaVh7RmAMeNIOU9kxhU9EPtvAY7RolayfUyw=;
	b=W/GnIjwjrweMvz4Q9J4/mfk0MVDy73/DWsKFjwxygRMCCdV4/nXkKW0SzIEXB82AD23vwe
	gv7eNtg8qAEVvU5AO78/ag5276Zj7rkGDGnwfrXN/w/B9fNaRIlyfDVqNpWq/aDyIMrkSQ
	5jkUr0NeqqE7s4CAn6Ap6IJUZf7g4eM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388--iHBqPCgMYaP5asUb-CiPw-1; Tue, 03 Mar 2026 04:36:26 -0500
X-MC-Unique: -iHBqPCgMYaP5asUb-CiPw-1
X-Mimecast-MFC-AGG-ID: -iHBqPCgMYaP5asUb-CiPw_1772530585
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4836b7c302fso53863995e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 01:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772530585; x=1773135385; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eztC7kwBaVh7RmAMeNIOU9kxhU9EPtvAY7RolayfUyw=;
        b=rQc+n0mtlppnex1BGShRy3jfqUWUwxUEoWDC/6wXsxclvDWH9bDS+gMzx9npAV1pQn
         8Yi3S8dridJPVpdAV5PIQ+uo1UABTHzRK+Hx1Ai8at19/UyCf4HYvC/SbYginbTY+3bJ
         GoUlRQZ9MINP/CFEqZ0ubHdLFEzFzdBENWBVMR2tkBHm3FMBoJALBdFrU3Rd0aygQbkp
         FDL02JQJ4UtnJQvcm12dZLKk2T1Pbv42gSRGeqQuaLFjkDauP6YpEYWSLoSJ+WI4Yu5F
         R4Z2Qdb6CRO/yTYOwxGLE9tblL23TbSjDWnFY0RsNJDz4wzffy0ojmE7mn7T3GU0H0yT
         Gm/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772530585; x=1773135385;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eztC7kwBaVh7RmAMeNIOU9kxhU9EPtvAY7RolayfUyw=;
        b=VXhYIeVpRJPUazKjNfOyqQ87n/ePvt4BGH4D0v5Aq6HP6hWxPKB1MXXeyMIu7sSpog
         mwaqPgyU4ixIiOu130Ur9ahIITP5lKat4NxZ2aGje7kJGlqWsIn5FrCackx2D9ibH8bE
         3GEbpMsdnEkSdfrAu+0nbByygtLNpxL4I5ZVm5joxIhyCkzYjz9vNuWY+IuRe0dCEhEw
         98Nol2rseRONHo0farNrgqTxwGrH7wimGnZXuvMlFp7WxOrAw7745qMv27jjLqYv2vtC
         hJWr/bnHQrHM0lfbjrxkNeBj2aW3X11c9fNvoR/uMJbSc9S7lMM3G3/ZU86Inp2/fLAN
         zWdA==
X-Forwarded-Encrypted: i=1; AJvYcCWaNgJeHMCVSGp7NqQkr59ue13By4BWU6hm90vEJA+2ZZQWdJlQqqEeMHFPZLarwT1UbcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyptLaiQDEIxVm7oUxzOBErWAECUtOkthwchXAHQNg/bjONAmAv
	SNkNwgPozgok55zwlkX5HHRttnHyJP+It+0GNMkPnYx/DzfEy0sPAy6NmYl8voRp9F6CMiq4hUt
	9x22qXKwI1JQJTPy+p2dXSEIHmM6JmmvK1DBLCsAoFn8EhieoKWxtVQ==
X-Gm-Gg: ATEYQzwieHHHzG9kuA1LgzSY/dlpwXkDTgEIgpQchscrwhzopI8RNftg+EwJNIfwj67
	TgnbNGoXhTNydDyDk/mVr2bJUhlWd/nc/Ab1ep3QARyiGw0yagR9w8S6z7EgAd2A0ngj/mkrHiM
	CugLEBhWjBqZwg+HmUmlZhJzqvvqZA/UceYeNGbrJaYrPcNSQWzQMt/7T+XnQftj5RmBBPQBnls
	zKzfhyZ/BXd4RXoAJA0c5AXZvNRjHX4QuGLHaMOrWtgqI05R5rkmOsbcIs7wwKlUPdEbQ0MJL+l
	r/rhx24TYutugl8VmfHVRAm3FIfHBeoSg69m+xL65wvWtiKuGkearXvusfEFsYzGQD2icR23W2S
	lcdpnCxT1hogo585uxg==
X-Received: by 2002:a05:600c:548a:b0:47e:e20e:bb9c with SMTP id 5b1f17b1804b1-483c9bdb16emr241639995e9.8.1772530585421;
        Tue, 03 Mar 2026 01:36:25 -0800 (PST)
X-Received: by 2002:a05:600c:548a:b0:47e:e20e:bb9c with SMTP id 5b1f17b1804b1-483c9bdb16emr241639475e9.8.1772530584908;
        Tue, 03 Mar 2026 01:36:24 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48512692c14sm13526465e9.7.2026.03.03.01.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 01:36:24 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 yosry@kernel.org
Subject: Re: [PATCH V4 4/4] KVM: SVM: Raise #UD if VMMCALL instruction is
 not intercepted
In-Reply-To: <aaZF43PdvrZvIaXn@google.com>
References: <20260228033328.2285047-1-chengkev@google.com>
 <20260228033328.2285047-5-chengkev@google.com>
 <aaZF43PdvrZvIaXn@google.com>
Date: Tue, 03 Mar 2026 10:36:23 +0100
Message-ID: <87h5qxfe5k.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 8A6EC1EBF7A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72511-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[vkuznets@redhat.com,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[6];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> +Vitaly
>
> On Sat, Feb 28, 2026, Kevin Cheng wrote:
>> The AMD APM states that if VMMCALL instruction is not intercepted, the
>> instruction raises a #UD exception.
>> 
>> Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
>> from L2 is being handled by L0, which means that L1 did not intercept
>> the VMMCALL instruction. The exception to this is if the exiting
>> instruction was for Hyper-V L2 TLB flush hypercalls as they are handled
>> by L0.
>
> *sigh*
>
> Except this changelog doesn't capture *any* of the subtlety.  And were it not for
> an internal bug discussion, I would have literally no clue WTF is going on.
>
> There's not generic missed #UD bug, because this code in recalc_intercepts()
> effectively disables the VMMCALL intercept in vmcb02 if the intercept isn't set
> in vmcb12.
>
> 	/*
> 	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
> 	 * flush feature is enabled.
> 	 */
> 	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
> 		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
>
> I.e. the only bug *knowingly* being fixed, maybe, is an edge case where Hyper-V
> TLB flushes are enabled for L2 and the hypercall is something other than one of
> the blessed Hyper-V hypercalls.  But in that case, it's not at all clear to me
> that synthesizing a #UD into L2 is correct.  I can't find anything in the TLFS
> (not surprising), so I guess anything goes?
>
> Vitaly,
>
> The scenario in question is where HV_X64_NESTED_DIRECT_FLUSH is enabled, L1 doesn't
> intercept VMMCALL, and L2 executes VMMCALL with something other than one of the
> Hyper-V TLB flush hypercalls.  The proposed change is to synthesize #UD (which
> is what happens if HV_X64_NESTED_DIRECT_FLUSH isn't enable).  Does that sound
> sane?  Should KVM instead return an error.

I think this does sound sane. In the situation, when the hypercall
issued by L2 is not a TLB flush hypercall, I believe the behavior should
be exactly the same whether HV_X64_NESTED_DIRECT_FLUSH is enabled or
not.

Also, I'm tempted to say that L1 not intercepting VMMCALL and at the
same time using extended features like HV_X64_NESTED_DIRECT_FLUSH can be
an unsupported combo and we can just refuse to run L2 or crash L1 for
misbehaving but I'm afraid this can backfire. E.g. when Hyper-V is
shutting down or in some other 'special' situation.

>
> As for bugs that are *unknowingly* being fixed, intercepting VMMCALL and manually
> injecting a #UD effectively fixes a bad interaction with KVM's asinine
> KVM_X86_QUIRK_FIX_HYPERCALL_INSN.  If KVM doesn't intercept VMMCALL while L2
> is active (L1 doesn't wants to intercept VMMCALL and the Hyper-V L2 TLB flush
> hypercall is disabled), then L2 will hang on the VMMCALL as KVM will intercept
> the #UD, then "emulate" VMMCALL by trying to fixup the opcode and restarting the
> instruction.
>
> That can be "fixed" by disabling the quirk, or by hacking the fixup like so:
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index db3f393192d9..3f6d9950f8f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10506,17 +10506,22 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
>          * If the quirk is disabled, synthesize a #UD and let the guest pick up
>          * the pieces.
>          */
> -       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
> -               ctxt->exception.error_code_valid = false;
> -               ctxt->exception.vector = UD_VECTOR;
> -               ctxt->have_exception = true;
> -               return X86EMUL_PROPAGATE_FAULT;
> -       }
> +       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN))
> +               goto inject_ud;
>  
>         kvm_x86_call(patch_hypercall)(vcpu, instruction);
>  
> +       if (is_guest_mode(vcpu) && !memcmp(instruction, ctxt->fetch.data, 3))
> +               goto inject_ud;
> +
>         return emulator_write_emulated(ctxt, rip, instruction, 3,
>                 &ctxt->exception);
> +
> +inject_ud:
> +       ctxt->exception.error_code_valid = false;
> +       ctxt->exception.vector = UD_VECTOR;
> +       ctxt->have_exception = true;
> +       return X86EMUL_PROPAGATE_FAULT;
>  }
>  
>  static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
> --
>
> But that's extremely convoluted for no purpose that I can see.  Not intercepting
> VMMCALL requires _more_ code and is overall more complex.
>
> So unless I'm missing something, I'm going to tack on this to fix the L2 infinite
> loop, and then figure out what to do about Hyper-V, pending Vitaly's input.
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 45d1496031a7..a55af647649c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -156,13 +156,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
>                         vmcb_clr_intercept(c, INTERCEPT_VINTR);
>         }
>  
> -       /*
> -        * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
> -        * flush feature is enabled.
> -        */
> -       if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
> -               vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
> -
>         for (i = 0; i < MAX_INTERCEPT; i++)
>                 c->intercepts[i] |= g->intercepts[i];
>  
>

-- 
Vitaly


