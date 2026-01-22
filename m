Return-Path: <kvm+bounces-68890-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OGxAJRYgcmmPdQAAu9opvQ
	(envelope-from <kvm+bounces-68890-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:03:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B22566FD7
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 44C5B3AB3D8
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6833346B5;
	Thu, 22 Jan 2026 12:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHbf3qG6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WEaCPpHr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D5033985D
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 12:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769083245; cv=pass; b=pkEUfy1QiiHqDvck32VssrRq1/OuNw7pNgk2DiLDA6y6qGMrd8Hv/fIc6XS8SoKKzrX2Ou3mke+GxZA+odRhI7mrE+K0PyMPikcKDblMR8JwTvhs0HePb6SqcOssS57eWvySWFaUmJd+0dHNtEvf8Pjr5PHVfyuMLdrQPs/8gXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769083245; c=relaxed/simple;
	bh=I6whjuqj5XiASgtN3558GqMsYKBhA7HmS2xMEbbOEXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uk2/yhyKwD8cDvWzAo2c3YdaTX9UJ4PsKHqnVnLJG8jkM5nlgskKqg3k4bNSAfntrP0FNcdG5AsOqBtvuoQc1rZmS4A6W1U4pGh1YIbBPLe1zDN1vcHPu72tTrZIhZHGuDJFNC/L0j3DAJm1mZAPDZ/ve3Eus3ooJW+bhdJfNFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHbf3qG6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WEaCPpHr; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769083242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I6whjuqj5XiASgtN3558GqMsYKBhA7HmS2xMEbbOEXU=;
	b=dHbf3qG6PgLPnRBeqVU2QAQR5kE7FAoccacrJlBKOIEJPy2q8QukJPX2ZP+Ar5Q+lVBhcB
	NVNL1/EsmjztD7rtxDXt6DFUSdJBrNXc2WQOr4BMLc2uYQiY5WCPyIW6iVztBPQWu/01az
	zCxJooCA5rkIOHuDWw4qKhgx6ZjHIto=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-cNk5baL7MpOxi7Mh5YHEhw-1; Thu, 22 Jan 2026 07:00:41 -0500
X-MC-Unique: cNk5baL7MpOxi7Mh5YHEhw-1
X-Mimecast-MFC-AGG-ID: cNk5baL7MpOxi7Mh5YHEhw_1769083240
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435a0fb0c9cso874067f8f.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:00:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769083240; cv=none;
        d=google.com; s=arc-20240605;
        b=HdMc7i2tmTgNpMHVNJ8Rax51OmGOmDvOna4FmOwMbaLnhuMBaQ09StAAgJ1v+d4Mcm
         8jE0QkfP3A7VGRsPNWswpJSO0rM+aDudZXi6YGB8tkTBF1hm4TNbftB4OObYxfLm3coU
         n85o5BY/i1kjg+v/SLFlXkXc+w1CW5GctxBgtP6XES6epYQYG8QSYPdoS683X5aIsgUJ
         JWN7b2PCX1njI3PFahV1NXMbLUDJycvR8tiGnaFxKFUX8ZTHep9FiiONadPCE0nnet1o
         DMbBtSOt07cwUQYX8+n4xdZMZ3hxzpcyg6dq1C5fneCrMkqTDlofEDAPlwNFzTNdNvLO
         UA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I6whjuqj5XiASgtN3558GqMsYKBhA7HmS2xMEbbOEXU=;
        fh=UeBN3E7lo4hYJZxV4f2vbbcd2NSliLyuhBFNEKi9wn8=;
        b=hQsKdJ1lZctifVprb3mT5dbXuoB9gv9A+/BHkD1lP04W5DXGjMS9uYuIlljarB9dQE
         OEQKEhX7EcOe6w0TcDfd1BSdV8wvGaC8DBjfyljRd+72zgZMO8kqu8M6SWlXAYUyttuB
         1NFchCQ9155a5bnnBOB8gXG01hflkrig4b+S8j1HAhcR4nUCaQF1kFg0YJk41g7xRV0u
         9vIKCz+0RqFzMWHFMMAYIdWBAczHZVERYJGIUa3+2EyNtdhSm5rItc6e8P/W5nO0sxyo
         F8Q3vLMEqEFpiNQPvoibaLpaeJsfuO1fbMbG0Ag0myxIxWmfTaya5M3FPVpkgcVkhnqL
         RCaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769083240; x=1769688040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6whjuqj5XiASgtN3558GqMsYKBhA7HmS2xMEbbOEXU=;
        b=WEaCPpHrJwz0EL6X1caRaqCjF/lJU8pmiEWlfxCuU6KQIkVQLgDdEYib5TwFkXNUom
         p90jFozsyG7+FtH5I/dOoZap9A+UYVeHycJbE6giB1zr1DCBb9PjANlD4fbxa+xtRLFW
         Cq2IyABoAhJpeNSII1sRv4lY5nblyPBAQ9NWMqHFugGRosFASTVcRC5SAGYXkaJCgKOp
         KeKQc+uIMY9GaD6e7uSqw5YmqoVjnmYTlXMjsDccSKZ4tF+E2ckJ8hzvPZ2Pplzz0mEr
         IBG0CQX00uBQHh2MTVAgdrwK9ygqfi0KXRBMZP11Acd/h77iCz5bqIy3HXN0idVmnGwQ
         I4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769083240; x=1769688040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I6whjuqj5XiASgtN3558GqMsYKBhA7HmS2xMEbbOEXU=;
        b=IqxoyZkTWENRHslT2pq3nlaUTSLaNJabmgj/n+i0SoW01wGeuTulH6gbm5DQnd9pLU
         BATSLBjBTUF7P29CkqeIG5n4rRtjLBBvvPJ2GX5aH8vOBFxzBTCLszf57Fj7jdXRl33h
         L0EeXVZgtyLoW0DfbpWwJ6rtcoJVK/iEjHxyN6+Bkgkyg2qkZR83qAFh6gTLbXoKTPP8
         jJ7KLpm9yEa3yGRedGfZiBNtZRRCWicltNJEYg2ZYJ2fwGv2HXB40hOTyrcKzCgczsJl
         06PF7bn5nT1+Rp98XWUdyEnD5uOUGc38dzF4aZ55nEa9X+eWDIKLWKtK8Eo27qGCWBtU
         iFiw==
X-Forwarded-Encrypted: i=1; AJvYcCXxKgP0Z/c3lVqRrTbjVP4KGRqegt1X2rEmyWS2onOF/bDiAsTw/G5OtnxeUetQ4R/VXq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YziBn8wzR00ghWLIuXkILk982TgUHwNUQVN/VhkH81so9GW9sqL
	D9T7JBy3djXoMhZH5VKsETVC/pAzwyJhWOaIzSOFlSzWPEzQuJAd0icvJzggRFC8cDQXxA+VZhT
	blWqnuE11Oj6nFWIm91PHwFtQ7lZr/xHPOts++inh54PZdV9Qu1SQlXf7KuIinK1UmGitTxzpNc
	P2oLus8b5nRCrlrNuo6tN39gJzRxEb
X-Gm-Gg: AZuq6aK+4DdlhqiBAIv9sSKsycb5WuPFeBH+L/0MoErv+tB+77VzuOA4X7sGI8DSbYE
	XcQ9igJyPs3mGyZVRqQZpiDK4JOPRdM/y4B8S6OC3DRlgL0N0I05TqOxQ7x7gZub4ehlNIaibyW
	njm7vut0M+If3XPmXDA5Z67wAGQlQhUa46vVB6nV3cG/YkJ3CMRQAZcOAZJ2h69+poLBlfYZIjQ
	VLtZUS01852CE+12sPMmFIhld8FjaJdFaHTcpxXv+cplTsPJnVMLpANy6erjp+RyJxL4Q==
X-Received: by 2002:a5d:5f90:0:b0:42f:bc61:d1bd with SMTP id ffacd0b85a97d-4358ff62652mr14792142f8f.45.1769083239832;
        Thu, 22 Jan 2026 04:00:39 -0800 (PST)
X-Received: by 2002:a5d:5f90:0:b0:42f:bc61:d1bd with SMTP id
 ffacd0b85a97d-4358ff62652mr14792078f8f.45.1769083239300; Thu, 22 Jan 2026
 04:00:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260116122246.GBaWotlmNRCkKFA-MU@fat_crate.local>
 <CABgObfaxsOA301j1hb1jSEZie3v3bzsW=03PcjqQ5RWynSN1aQ@mail.gmail.com> <20260122111257.GAaXIGORy84Y1IedxR@fat_crate.local>
In-Reply-To: <20260122111257.GAaXIGORy84Y1IedxR@fat_crate.local>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 22 Jan 2026 13:00:27 +0100
X-Gm-Features: AZwV_QifqfAsz9fVczb3t8dXqgnd8CLyJm52d53xGBUut3P8oMwpw7ffZuM7LwI
Message-ID: <CABgObfZcCNyYxX+_VHhfCkYqvWyDcsJd85qpEAQCWOME6kjivg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
To: Borislav Petkov <bp@alien8.de>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68890-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,mail.gmail.com:mid,alien8.de:email]
X-Rspamd-Queue-Id: 4B22566FD7
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 12:13=E2=80=AFPM Borislav Petkov <bp@alien8.de> wro=
te:
>
> On Wed, Jan 21, 2026 at 12:35:50PM +0100, Paolo Bonzini wrote:
> > It's a fix for a host crash that literally adds a single AND to a
> > function that's called fpu_update_*guest*_xfd. The patch doesn't have
> > any effect unless KVM is in use,
>
> No Paolo, *exactly* *because* arch/x86/ and KVM are so closely intertwine=
d in
> some areas, we should sync on changes there. And judging by our questions
> on this thread, one of the aspects were whether the handling of the guest
> state is adequate enough. And if it is not then we have to rethink it and
> accomodate it.
>
> What we definitely should NOT do is solo efforts without even an ACK.

I agree - as I wrote below, I judged that this was _not_ solo
considering that (while not including any x86 maintainers) there were
multiple people intervening and building on each other's analysis.
Yes, there was no x86 maintainer, I obviously knew that, but my
judgment call was that all these people together had looked at the
code more than it deserved. In the previous mail I said the
probability of a disagreement was small, it was even practically
nonexistent.

I don't think you can say that this is routine, for example in commit
eb4441864e03 ("KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA
time", 2024-04-11) I explicitly sought an ack for just an
EXPORT_SYMBOL change. Knowing that x86 maintainers want to tightly
control the API boundary of arch/x86/kernel/fpu, I considered that to
require the attention of you guys *even more* than a code change!

> We've had this before with the X86_FEATURE gunk and we're back at it with=
 the
> FPU.

I agree that causing conflicts on X86_FEATURE (years ago?) was a
mistake, that said I don't think it's a great example. I still see
occasional changes to cpufeatures.h go in via Sean without ack---and
in fact I check them explicitly when I get his pull requests and look
at what tip is doing with cpufeatures.h in the same merge window. :)

> > If I really wanted to sneak something in, I could have written this
> > patch entirely in arch/x86/kvm. It would be possible, though the code
> > would be worse and inefficient. Sean wouldn't have let me :) but
>
> In my experience, syncing stuff with Sean who takes what and giving each =
other
> immutable branches to use, works wonderfully. Why can't we simply stick t=
o
> that workflow?

I think it's a perfectly fine workflow across releases i.e. to prepare
for the merge window; points of contact for -rc patches are rare and
using branches to sync is unlikely to be necessary.

I appreciate a lot the support that Thomas and other arch/x86/ people
put in to help Linux run well and without hacks as a hypervisor. At
the same time I think it's fine for both sides to acknowledge that in
extremely rare cases the lines can be blurred. So rare that I cannot
think of another case in the past and it's no problem for me to say
"never again", but then it would be like saying that the Earth is
spherical...

Paolo


