Return-Path: <kvm+bounces-31330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51ACF9C2758
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 23:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114E9283214
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 22:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A274E1F4712;
	Fri,  8 Nov 2024 22:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="psOU2zdM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A081E048A
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 22:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731103979; cv=none; b=DTj5a2MQcaMH3XSu60rATyFxhfZJLnDGAmkoFR/QCUX4eEay3I/yMTuvWz5aCVd/ZDP+uBBUAB66Q2xIvn8BC0HUVClOWr7CO73WUwUJJP7QmzoHWzozoXjPM5w9oTpA1Elad2vqmOR2YfH862BGvdwWk8fa9NysFAGgjz+gGYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731103979; c=relaxed/simple;
	bh=wX9PFZrFri2mQBSbP5XRWK2geD1Yy8QbqAS/pekxSzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c4Rj2bCK+s6IOhIqdWNSCzCm27e3NUvnqpBFKm+hE1PAekPWw8irG/Cj4AkVz49YDJHCdtCjdEMpmKYQpdLdBLw0y6qe+5+/mjXDdFu33K0vD0yNkkNfmWQUZEQKgMc3YLCAn8xAURGzZxfyk4LNj63aO7mGLJkSS9+UNU11new=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=psOU2zdM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2a9577037so2763147a91.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 14:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731103978; x=1731708778; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gq+e5c9WNI7tAMaDD0Dp/NV1TeMtTqKU6RqkXPTKVNw=;
        b=psOU2zdMnijXr5ns1GyebgILQSKWH9kqDDo4TaMfxyZlHDwLFZCtxN3fCL3PIvvqXH
         wx0v355uDy4+WKAlBpt4Xk0HQlaycEyo4FanMASpCdop94ffzRJqRX3Mr4UceJgoiple
         o8eKqPAn2Rao66n3+rpc/D0Js763vKL7bcj8Ngh7g3/mW7uRunpe53gn9j9lC0A4cqHp
         c3LGohfjrFV7eYMeYEWMmDjz0TBb0XbNodXlcXSBaytJn0l9ZPAaMFg4pVlvP3tRkyuX
         rTnNRhUeFUaqbZGRlEikROK3MWokKcrVg50zbPcYWiAMiAq/grJadZ4f44yFpwjYWn6c
         bG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731103978; x=1731708778;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gq+e5c9WNI7tAMaDD0Dp/NV1TeMtTqKU6RqkXPTKVNw=;
        b=ETmH1htOScrmEE30wYuDybc5h3wCXD0dnKUo4mcq+uWGsZgJlT+Hm6NrPnEqa5Nue0
         e5YPyZmpC57agKS29pbt8M/O3xHa1XsHnKB4XCYEgWNIbUslEW5agPLCnIwZYYLFg6XT
         KjmNp9bsJITo1oue8hzzR+NOpViyqEpwbavn99uxhePBNws6D6doaSCso4E7UVh9DZpe
         okEdh1e/xPM0cGp/KwDGN0ldjn5pqXblvlkOaIfvqpE4QOO9mscTeKrmy6Noe7GIByFy
         Rwm2lnbK2A24Y2W65P8gXT3STCjG3To5KUjQZqueLaGLEyo1OX2udbhcQu062L27M05c
         /8hA==
X-Forwarded-Encrypted: i=1; AJvYcCXf9Za5JkKDMA1jSzzjlqtvE0ktJUdlD2eAHbIQ9cJ0bwE8YhLKZAUQ1oCqv5LA+vvtYOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfO8QB8l8pWVzXpwhuKQy3pSR711dfs8EFtGfeErAF2iPFH5Ek
	HaMAJG8bjblho6Bk5EFxbwxLU89qBzTm2GT2Kx/jTm1o9LcysiFnwlRRfxiIqp1S1XTJ5gTP9Ru
	3YA==
X-Google-Smtp-Source: AGHT+IHgtaLUvI7/N2zY0q1dhGgTozHWw0DU026qVKNgKDV/PmJgTWrj8MNZ87/W0fuoZ5IkqV3PnW0gmg4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:230c:b0:2e9:b23d:16ff with SMTP id
 98e67ed59e1d1-2e9b23d1735mr24127a91.5.1731103976811; Fri, 08 Nov 2024
 14:12:56 -0800 (PST)
Date: Fri, 8 Nov 2024 14:12:55 -0800
In-Reply-To: <854e43f7-0eed-4a1b-8ede-37c538791396@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108161312.28365-1-jgross@suse.com> <20241108171304.377047-1-pbonzini@redhat.com>
 <Zy5b06JNYZFi871K@google.com> <854e43f7-0eed-4a1b-8ede-37c538791396@suse.com>
Message-ID: <Zy6M57VglxCSaZky@google.com>
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?B?SsO8cmdlbiBHcm/Dnw==?=" <jgross@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 08, 2024, J=C3=BCrgen Gro=C3=9F wrote:
> On 08.11.24 19:44, Sean Christopherson wrote:
> > On Fri, Nov 08, 2024, Paolo Bonzini wrote:
> > > Queued, thanks.
> >=20
> > Noooo!  Can you un-queue?
> >=20
> > The return from kvm_mmu_page_fault() is NOT RET_PF_xxx, it's KVM outer =
0/1/-errno.
> > I.e. '1' is saying "resume the guest", it has *nothing* to do with RET_=
PF_RETRY.
> > E.g. that path also handles RET_PF_FIXED, RET_PF_SPURIOUS, etc.
>=20
> And what about the existing "return RET_PF_RETRY" further up?

Oof.  Works by coincidence.  The intent in that case is to retry the fault,=
 but
the fact that RET_PF_RETRY happens to be '1' is mostly luck.  Returning a p=
ostive
value other than '1' should work, but as called out by the comments for the=
 enum,
using '0' for CONTINUE isn't a hard requirement.  E.g. if for some reason w=
e used
'0' for RET_PF_RETRY, this code would break.

 * Note, all values must be greater than or equal to zero so as not to encr=
oach
 * on -errno return values.  Somewhat arbitrarily use '0' for CONTINUE, whi=
ch
 * will allow for efficient machine code when checking for CONTINUE, e.g.
 * "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero.

FWIW, you are far from the first person to complain about KVM's mostly-undo=
cumented
0/1/-errno return encoding scheme.  The problems is that it's so pervasive
throughout KVM, that in some cases it's not easy to understand if a functio=
n is
actually using that scheme, or just happens to return similar values.  I.e.
converting to enums (or #defines) would require a lot of work and churn.

