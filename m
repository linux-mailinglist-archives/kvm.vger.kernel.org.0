Return-Path: <kvm+bounces-37994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 707AAA333D3
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 01:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 354331671AC
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 00:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232AACA5A;
	Thu, 13 Feb 2025 00:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEItY9ox"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0E1372
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 00:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739405335; cv=none; b=bXHahvZQsQmB2eEPZNFAa4IUc8JjZZV+JyiK9VlCQBGuX30l4PNWExhmqXsDAe5Ic5FKHah8g05ge2lCLXb+TbP/rvU6v3Mh1QX3p+i1SWfkrk16dv1XMu1i81jnS6R1vXt51t2HqauobBI5aGcuv1s/AAalxRuCBbflL/gCRrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739405335; c=relaxed/simple;
	bh=AqW9HL556ZI4lEeWCrLkz/cIG/PgLNaIjzYEZQLp6FY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O3bNP9b+YRgVmQgODSsTxiBz+AebmJRIGvkeh5efxiAK+2mIqafQdbhXMkRvmiy8s59fy854gsp4Pv+oTKiRHZRNkzPYjursxjJasX3dVhjas8o46Z/A4kmRkpq9AuxjS5HpijK44ZWb9XJiADcEpBHlHlY/rRb/gPaJogNRP9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AEItY9ox; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6f9c6d147edso3030047b3.3
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 16:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739405331; x=1740010131; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ckylkc1mRMPJAxaTTlddOkQMiHbF9c9F2xl9Y8jmnfA=;
        b=AEItY9oxqM3Rj7/h5yARi+yFe/DW/xjwm4BmjfcXy9+zPbL/lj2Yrqpiz8zSuHlrre
         5mt9FSBwsI46P/VCEkBONtXgzHqb95kyLafNYggCUZMnbgA8tM5c/Qzu6mx4Y/vrI8JK
         RtYb13PKplhTMwMhnOjcBvDPWUgGatXBXOAqrqpBoISeCJTKv+B7KiqDy+VigysD0txS
         wF8vzZHQinfRN0kme7xE+Utf7FMREsIAmWctZ17WDeyR1BeXi9an/vdM1T29IW5BV1uF
         MSKjwpCQzD3fm/0SuTCXJiZJlBNc74M4tJZxpe8NzYONjwlp53csCfIM6cQ0Hys6yly4
         Vd2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739405331; x=1740010131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ckylkc1mRMPJAxaTTlddOkQMiHbF9c9F2xl9Y8jmnfA=;
        b=U9czPfTir/TpGH+0ff2UPDpMhKnKUmJyef8kAWHhpjBNKLVR2gPzb64Ve/6exhvQqm
         dPwZnlngVutOP9qW6uRYq9ZQbG78J7HnuAFxfFLEUJIH/vd6ODp2QcWOv7tpXR43qHe6
         UHbx1+vdAF8wa7hy2uW65joUiKNYzQkkQxNQ9KyuS8l3hQBjLW36LNkgJcnvLTIT4QZo
         RL7tKzhpOlA1SEe1LA1xcwHn5yW2Dgxa+1hIbBeEFo7b3n5sVN5DKsvX+1B6vNaO1LNH
         hg50mlzmQog7Fl0CajQ/SPo+TJaPm3gdT0awARyn70x93Vc5wh5nbinTskk3s5UtZq+1
         ngMg==
X-Forwarded-Encrypted: i=1; AJvYcCX4uBxVKbgwx79U5r+tbv6PhEgF/lLjdpOBc9jWXUTwfNKgyKp++ghfFQKoGfzQ0LN1uhk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8PWU4BLLMPDj5/HcT5J2fwpTNL3y9Wdj2tbWrEES6/AjfhwKX
	NDOH+dniZojGLwq0LYFqd7ixz2ysy9kMuLC0HGY5ErslJfLfxY//jy6cs4vomo475F42HCxlzSW
	AxTQKSs/BRgmUhqn4PiVng7ZN5Bz9cKIA5nQ9
X-Gm-Gg: ASbGncut0hTwIghuWUwM/x6hW8b66uQxdiSwl8UHjjZEM0OemwQ4fNmqdQaIY7LlDXa
	a3V/++wNx8Y3PR1q7kOjBQY+0Lf8Lhach6VRyRkVwFJgSkVFmQokBWl/Btb4KvT58/25T9cq12i
	mnKjK2JadumT435+e1gVwDeRLWzA==
X-Google-Smtp-Source: AGHT+IESrPreFpgp6e19fu3YrWUdZmPloykIK3Btk02O6+02tP8XN3roPsVyPNUUmsn2kvRJNtuJ9JsHcnUTNqnGwEo=
X-Received: by 2002:a05:690c:3687:b0:6f9:aecf:ab34 with SMTP id
 00721157ae682-6fb1f2d5ad0mr57353587b3.38.1739405331362; Wed, 12 Feb 2025
 16:08:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67689c62.050a0220.2f3838.000d.GAE@google.com> <20250212221217.161222-1-jthoughton@google.com>
 <Z60lxSqV1r257yW8@google.com>
In-Reply-To: <Z60lxSqV1r257yW8@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 12 Feb 2025 16:08:15 -0800
X-Gm-Features: AWEUYZlI2bRB94Zjwo44LypQugi03x5L8sjFcH2ILC3VhqEUbvLU2tkjbi5Gl-I
Message-ID: <CADrL8HXZed987KOehV7-OroPqm8tQZ0WH0MCpfDzaSs-g_2-ag@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] WARNING in vmx_handle_exit (2)
To: Sean Christopherson <seanjc@google.com>
Cc: syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 2:50=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Feb 12, 2025, James Houghton wrote:
> > Here's what I think is going on (with the C repro anyway):
> >
> > 1. KVM_RUN a nested VM, and eventually we end up with
> >    nested_run_pending=3D1.
> > 2. Exit KVM_RUN with EINTR (or any reason really, but I see EINTR in
> >    repro attempts).
> > 3. KVM_SET_REGS to set rflags to 0x1ac585, which has X86_EFLAGS_VM,
> >    flipping it and setting vmx->emulation_required =3D true.
> > 3. KVM_RUN again. vmx->emulation_required will stop KVM from clearing
> >    nested_run_pending, and then we hit the
> >    KVM_BUG_ON(nested_run_pending) in __vmx_handle_exit().
> >
> > So I guess the KVM_BUG_ON() is a little bit too conservative, but this
> > is nonsensical VMM behavior. So I'm not really sure what the best
> > solution is. Sean, any thoughts?
>
> Heh, deja vu.  This is essentially the same thing that was fixed by commi=
t
> fc4fad79fc3d ("KVM: VMX: Reject KVM_RUN if emulation is required with pen=
ding
> exception"), just with a different WARN.
>
> This should fix it.  Checking nested_run_pending in handle_invalid_guest_=
state()
> is overkill, but it can't possibly do any harm, and the weirdness can be =
addressed
> with a comment.

Thanks Sean! This works, feel free to add:

Tested-by: James Houghton <jthoughton@google.com>

I understand this fix as "KVM cannot emulate a nested vm-enter, so if
emulation is required and we have a pending vm-enter, exit to
userspace." (This doesn't seem overkill to me... perhaps this
explanation is wrong.)

