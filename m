Return-Path: <kvm+bounces-8491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 401B684FF1B
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C346BB274A9
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 21:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3BA210E7;
	Fri,  9 Feb 2024 21:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bgObKC5d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE9018C27
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707515216; cv=none; b=rlibkJ/Gyh6n/47+tAb7iq5IWukhMtGrY+H0bQgSlkMNlbDA/2ecz2FUewX6jUe/bvV2LbCMJ8NNASM9kNynOBlpGwSEZ5CeGlY6NUhfo1yOhiFLh4zpLlp2SMZytcTtoF7x1Kjkty6fRT1hYfJloVZlBszAyQXpoCmstc7tYNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707515216; c=relaxed/simple;
	bh=E9RmYNvl+KP6ZoWmKcRICoo2zuZ2p0BRZ6TGm1vclWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VSV6/rnMWM9yLFraJ1J2f3f8f5BCZ88Dqx3PpP3JEb71E8dnFR7aZ31RAFQBM8u9jZ5vQrR2jfRKXl1PH5iEEGktqim5zuczmZswvZ/3SfPtFctL8uJZ0/6L1gwQNEyCmo2CxoO7txmeiNC+4sYAEbCvVOGUvtX3ttKWXLQ78mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bgObKC5d; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso2310496276.0
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 13:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707515213; x=1708120013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GL+pH50a20qqS3C4DJIFftY5VDxfmSdvc8SiM1uAYxI=;
        b=bgObKC5dU+HxZNEKGVV5a2b0EV8Ey4AOAs8Y9eMgSqd6tLJLBrFwKW8jOdTuREerml
         KmCl13MJNxd1nU0dIypu3NImilHftQjypOoGTAcOfY8Nb6Ogl68UlrgcUSIZiM74xT16
         fH5lglZhAmkrIcmd+LaFwC7W4PkhWOMLre/ZzTyGvvcnVS6BXT2UkruoxPxUrovuaTIS
         JFI2Xow2+G8rLSEnEHcW+0wfN1z2bDqOYwHs1WC0Z3Nrh6iBCeqrBrCs8vbQ1bWy/cI4
         V8D1Xt7ja8hrGmXJ1NkmPwrAv45HL3kcM9mW1kwGZFkGCVXOd23jS6fZOUyrngjF7t5S
         +lPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707515213; x=1708120013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GL+pH50a20qqS3C4DJIFftY5VDxfmSdvc8SiM1uAYxI=;
        b=e8qprZzxLcFfIzGZ1lujIWYr9KNGYeoTLIdO68PL66Hi/VBn52a0Z2C2v2YtNuso+Q
         x/HdY1/5b9EK8qRk1BQKO1r0Aep0B5GmS7Yq0XfiMot66JH3GV0bb+kClJI6XdaUUa/K
         JmVJHRJ5Vb7LjSS0Vy3O5G84WS2ya27Qv5f2jwh5BRke48WJGMClQC/VrLyQdrwSNb2d
         db0POwD2fw/mt5hTJTZX8/N6W6b50Onq69q7Xl2dXMI8EwaEOPSReqx74Olijwulk0+U
         DKSFFP3Ul4nV4aUCzgj8C5El+vvEaSyySuHr2LrAwH2R7i4oepfZJ9FpAEHGbLgCmQ2o
         RxfQ==
X-Gm-Message-State: AOJu0YyNhaAXtrR0enEOlNQXMUar7oWTeE/y5xaWDHa+uIau0KiuDR3o
	uurAT6sQSZ6tFghSF/DRclAn9jK6X9Hse8zUHk3FT0HZozufpj5M2b4GUrscp9t/PoJCzMdr78Q
	v/w==
X-Google-Smtp-Source: AGHT+IHZrpvVEOXi6Dk7Xe7SLPmmmmxXWbzbmKhX4ZyvV8jkQs/9u4eI8K/UypS9QLyMLVxothRIaLWQdi0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8387:0:b0:dc6:db9b:7a6d with SMTP id
 t7-20020a258387000000b00dc6db9b7a6dmr16955ybk.13.1707515213670; Fri, 09 Feb
 2024 13:46:53 -0800 (PST)
Date: Fri, 9 Feb 2024 13:46:52 -0800
In-Reply-To: <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com> <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
Message-ID: <ZcadTKwaSvvywNA9@google.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
From: Sean Christopherson <seanjc@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Uros Bizjak <ubizjak@gmail.com>, 
	Jakub Jelinek <jakub@redhat.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 09, 2024, Linus Torvalds wrote:
> Sean? Does this work for the case you noticed?

Yep.  You can quite literally see the effect of the asm("").  A "good" sequence
directly propagates the result from the VMREAD's destination register to its
final destination

  <+1756>:  mov    $0x280e,%r13d
  <+1762>:  vmread %r13,%r13
  <+1766>:  jbe    0x209fa <sync_vmcs02_to_vmcs12+1834>
  <+1768>:  mov    %r13,0xe8(%rbx)

whereas the "bad" sequence bounces through a different register.

  <+1780>:  mov    $0x2810,%eax
  <+1785>:  vmread %rax,%rax
  <+1788>:  jbe    0x209e4 <sync_vmcs02_to_vmcs12+1812>
  <+1790>:  mov    %rax,%r12
  <+1793>:  mov    %r12,0xf0(%rbx)

> That (b) is very much voodoo programming, but it matches the old magic
> barrier thing that Jakub Jelinek suggested for the really *old* gcc
> bug wrt plain (non-output) "asm goto". The underlying bug for _that_
> was fixed long ago:
> 
>     http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
> 
> We removed that for plain "asm goto" workaround a couple of years ago,
> so "asm_volatile_goto()" has been a no-op since June 2022, but this
> now resurrects that hack for the output case.
> 
> I'm not loving it, but Sean seemed to confirm that it fixes the code
> generation problem, so ...

Yeah, I'm in the same boat.

