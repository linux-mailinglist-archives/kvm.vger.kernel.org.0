Return-Path: <kvm+bounces-72400-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uAiwAo26pWmoFQAAu9opvQ
	(envelope-from <kvm+bounces-72400-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:27:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1571DCC89
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 17:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2509A307E401
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 16:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7296F30B53E;
	Mon,  2 Mar 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLeAJ/QH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F1C30148B
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772468513; cv=none; b=XFoJ02TNT8EgXTsJ4PYiJ6obFXJTk0a0JWkA+DJBE45T/S0U3AJPO0UzKTRvmB6yI9pQchgxcrudtvY0+BtSMbLImtnhjt+6ae2iPuTEZpl8h06FN4o56J/mfLo/6JbPh1UOQxraCZLbg+sSjG11QONRq2K4zVu+zjtb7UTS4TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772468513; c=relaxed/simple;
	bh=ixtmi1sOKDzMdGYBHXwuHWHA2dkIBibp399Wn7IQN2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GPP/6wtl4OlVt1eW5w6Ozi0HS421mZbEDaLkHT6vaadfZCJCnNTYape7FRdfrebvqg2F8vM0dsGlpavXD7ufcACmpJ3Tel4VuOEGWNgkbLr2/TgJloFbC0j10F+iKHI8+Cagf5h+ZFHK33kblpXKFGFDeilihXnLEFXPCVUL3fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLeAJ/QH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5953FC4AF09
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772468513;
	bh=ixtmi1sOKDzMdGYBHXwuHWHA2dkIBibp399Wn7IQN2M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mLeAJ/QHXM6jHrV4tSbxcnyx53Gom/g7zhC6mSB+B2hh+BOl+tRlUpznV+HNENWlX
	 6VulmuUg2e30qpIsuPpQS9sCt2hVYNYUhU/xSxBvJMjsluRSjxhPk+8lg8tkZ6ivyz
	 0C/nJHtt505VDrAF4B0BuVI1J9rhVRykwU+DNLghhXFZZ/lW9nRDiS05oJIWDBRqtz
	 AzttkI/v2UNKWMsgWJDNWkKo0Q/xsIF9r93kfkRlyPmDVZpzDqC9/fRWmERttxDP50
	 jBBtstaMEgkL+47o82LOUmJiOoMvNkS80XexN3jZu+1dRF0bFDHVrC4xF+wXoWgCtL
	 6pBTuEvLf7WeA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so693754766b.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 08:21:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXgjNUtdXaogYu0Rwp4SqPA6R/pr3R1Y3v25JIUcCzMGQYKoXkvl8giPnAMRo9wCKdevvI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyin62zVmS0WL5oqXsD3F/Y1gXxBFopF7NuAAn0WOKNGr/0SDRb
	Ki7P+qCX+GwJ4yWpWTWY8lHzG9JCbXx3ZitT3USm6zdX6A/7jSDfSg/8w/Trd9dwECtZfhmZqdR
	JotWQgM2DE9fq/h/wcVlvQQCAS2qFdII=
X-Received: by 2002:a17:906:f815:b0:b86:ef1f:6d19 with SMTP id
 a640c23a62f3a-b937658299emr663725466b.59.1772468512099; Mon, 02 Mar 2026
 08:21:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com>
In-Reply-To: <20260228033328.2285047-1-chengkev@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Mar 2026 08:21:40 -0800
X-Gmail-Original-Message-ID: <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
X-Gm-Features: AaiRm53VNkGaRUQbMSdG_qyksdWla4_VTg7R6yN9aIYfiWKy5ld_4_e5YnOEgcQ
Message-ID: <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BF1571DCC89
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72400-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 7:33=E2=80=AFPM Kevin Cheng <chengkev@google.com> w=
rote:
>
> The APM lists the following behaviors
>   - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
>     can be used when the EFER.SVME is set to 1; otherwise, these
>     instructions generate a #UD exception.
>   - If VMMCALL instruction is not intercepted, the instruction raises a
>     #UD exception.
>
> The patches in this series fix current SVM bugs that do not adhere to
> the APM listed behaviors.
>
> v3 -> v4:
>   - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=3D0 and SVM Lock
>     and DEV are not available" as per Sean
>   - Added back STGI and CLGI intercept clearing in init_vmcb to maintain
>     previous behavior on intel guests. Previously intel guests always
>     had STGI and CLGI intercepts cleared if vgif was enabled. In V3,
>     because the clearing of the intercepts was moved from init_vmcb() to
>     the !guest_cpuid_is_intel_compatible() case in
>     svm_recalc_instruction_intercepts(), the CLGI intercept would be
>     indefinitely set on intel guests. I added back the clearing to
>     init_vmcb() to retain intel guest behavior before this patch.

I am a bit confused by this. v4 kept initializing the intercepts as
cleared for all guests, but we still set the CLGI/STGI intercepts for
Intel-compatible guests in svm_recalc_instruction_intercepts() patch
3. So what difference did this make?

Also taking a step back, I am not really sure what's the right thing
to do for Intel-compatible guests here. It also seems like even if we
set the intercept, svm_set_gif() will clear the STGI intercept, even
on Intel-compatible guests.

Maybe we should leave that can of worms alone, go back to removing
initializing the CLGI/STGI intercepts in init_vmcb(), and in
svm_recalc_instruction_intercepts() set/clear these intercepts based
on EFER.SVME alone, irrespective of Intel-compatibility?



>   - In "Raise #UD if VMMCALL instruction is not intercepted" patch:
>       - Exempt Hyper-V L2 TLB flush hypercalls from the #UD injection,
>         as L0 intentionally intercepts these VMMCALLs on behalf of L1
>         via the direct hypercall enlightenment.
>       - Added nested_svm_is_l2_tlb_flush_hcall() which just returns true
>         if the hypercall was a Hyper-V L2 TLB flush hypercall.
>
> v3: https://lore.kernel.org/kvm/20260122045755.205203-1-chengkev@google.c=
om/
>
> v2 -> v3:
>   - Elaborated on 'Move STGI and CLGI intercept handling' commit message
>     as per Sean
>   - Fixed bug due to interaction with svm_enable_nmi_window() and 'Move
>     STGI and CLGI intercept handling' as pointed out by Yosry. Code
>     changes suggested by Sean/Yosry.
>   - Removed open-coded nested_svm_check_permissions() in STGI
>     interception function as per Yosry
>
> v2: https://lore.kernel.org/all/20260112174535.3132800-1-chengkev@google.=
com/
>
> v1 -> v2:
>   - Split up the series into smaller more logical changes as suggested
>     by Sean
>   - Added patch for injecting #UD for STGI under APM defined conditions
>     as suggested by Sean
>   - Combined EFER.SVME=3D0 conditional with intel CPU logic in
>     svm_recalc_instruction_intercepts
>
> Kevin Cheng (4):
>   KVM: SVM: Move STGI and CLGI intercept handling
>   KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=3D0
>   KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
>   KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
>
>  arch/x86/kvm/svm/hyperv.h | 11 ++++++++
>  arch/x86/kvm/svm/nested.c |  4 +--
>  arch/x86/kvm/svm/svm.c    | 59 +++++++++++++++++++++++++++++++++++----
>  3 files changed, 65 insertions(+), 9 deletions(-)
>
> --
> 2.53.0.473.g4a7958ca14-goog
>

