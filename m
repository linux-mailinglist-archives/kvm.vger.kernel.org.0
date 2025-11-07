Return-Path: <kvm+bounces-62249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3402C3E03B
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 01:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F3AD188BB82
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 00:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B762EA743;
	Fri,  7 Nov 2025 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aRpekQGt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E352D9EE7
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 00:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762476535; cv=none; b=ZLhp1I8hnLysHqjBC1RhvGa11r9S2bM1SmVbWOIjGrpMu53fzmroQHz3OO93KbdW30nkqnbN1/mPR+2olSp1+tvIgu/j7uOZoozDrYH1lQkCY/1xCgk7DtrXONIqqzOR2HN8xSMNy6yaWWaEb2YtCUtNGshGeQeKO2Jb1Sxi8Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762476535; c=relaxed/simple;
	bh=sn6j/WP+bd+jqgBuRpz17xz8i5sjTIQyCJWXHeB0/S4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ol4qfuP5na/TEkUoXJ9GeGtu+vkuBstX1WN2WVtCmJgQJmKKp/i+ryo20U4bhU8dBLmTzTQSsf0mY6lBkevwQkNQMrCly5gXYgsRTP23xpFjippDU3GBWbcxWBvizChC+vBHlmAZLGmO79mNDAC99ikmZsHJhV6bUrp0R87mMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aRpekQGt; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so24434966b.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 16:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762476532; x=1763081332; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UJyXy2HPeNxeSWk8AJrSzQ9IAraFkis5RK31sTtcUcA=;
        b=aRpekQGttGudCzq5LccHPB4kOu4Q4PbMRRs3rlaVumgjMQodQEq8a456DSRQFeHt2B
         TC4FRMQAS6QCWNy6wC5mibVRDN6FKdn79PCJOcrkemNPrmOsZ7K2utmSIqZmEFAh1Xit
         wXDBh17RU2//P86WZM1Usd6rkknSM+00Ds2fI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762476532; x=1763081332;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJyXy2HPeNxeSWk8AJrSzQ9IAraFkis5RK31sTtcUcA=;
        b=XCaTmIk4tVKBy33ew8SBmi6UeX3l0DstFE+m+aEvpCjihOiIR1XOJefsg1QR73nV+L
         R3ng/qO0Lzq2kOyfy/HnZ8BLXxMEA0FkSCnldBysJRk4zCWC8WIwn0yUdZ6+CTTocMtR
         c9Y+YCsQ2w9TWtMFdOX/e8iTiB7zEOPgTX3B1GJ/ckMlMKHvZ/Q2Jqhb2CaaoCzyPl5q
         s8atw5BzQK2krZFGaUfvz5nv5RgF7WAVPwMki0n4+rRkZrYdF7+hEeoieLgZq2yGffkR
         6/2UBbLiJjoHxMknXSx7oUkwPJv1eoe1d8iIj2Zi7/7KbcFw+VxC7+uio2JGigz3abeZ
         HtLg==
X-Forwarded-Encrypted: i=1; AJvYcCWFGashnikuABZUTYMEO/OlLdok2ZK1s7sQo5uTLV+P6gjPmbZZd2HJiPpk/JbFuGSR+zY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+qJeAo5lUJXj7mTdONhNSjZh8CLLoALf/pcFAUGCPLV8LGJEh
	lg0ON46wmUGB/8mIc1382g/SqM4NATKMi2g25f1/+JIMdtvBU+XFenvyY+B7YHTj8Z7Sr23XLG9
	yzNYz+CA=
X-Gm-Gg: ASbGncu20fItGvV1PbB7sQ/tkm4lxymDcNyuX+bi3MxZA7eioQY4B4Zm3OrPEsJGfmK
	uRofq+HDoLMn8ak8y8L2KUrn3PACzms8zCAWpoflLHYPsKfMCS5GiPEaXAJRLwq+fZBGKOrq1mQ
	CvqM4Es86V5yD6DiGfNpbtf4Wjw5FdZ7OD6brOooX+WaxLuIf1QF8aPcmRR1iQLJavwv1tHy6p2
	Zei7LgQmWObru4dpu+hHQvzkBTXHakvxJEiV+/OpuhS9CYx9sEfUtgz/5K7J77DTqbQ3JttErHH
	JInLCOGUYvUhXdqaa2azxAtHEVBxgF3JXkbrf7p6/xDZJoKuFqdincc2AxRwKEaBBnjkdKU2oFj
	Cawk1XlVrw+H1TGPWPQdNVc/Zq+iJLNSpLgpmTZwKKBEEuygFGQanFOVDR0Ini91G4UjON4csBB
	xyFk0hRXUpiSQn2zDMgY1aIQX7lSyct6GkXqET1W2y68GUAmSm9g==
X-Google-Smtp-Source: AGHT+IEgEt/5GAH+TwV82L6Mk09M/tcyOW3e0gLeAhbuGRsfUrRzyECkqb1/JsOkj0jbhg2BreN0lg==
X-Received: by 2002:a17:907:cd07:b0:b70:b7c2:abe9 with SMTP id a640c23a62f3a-b72c0cec571mr116399966b.38.1762476531799;
        Thu, 06 Nov 2025 16:48:51 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bfa11333sm88835366b.69.2025.11.06.16.48.50
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 16:48:50 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so24432566b.2
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 16:48:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVQB4mQL3dihuvPM3wdRp/DjWHxgj4KzwvuujHWVnL2fduu5EjOqDGKYV/O7yMYACmMMAQ=@vger.kernel.org
X-Received: by 2002:a17:907:d8e:b0:b71:fa4a:e16a with SMTP id
 a640c23a62f3a-b72c099753amr152181766b.28.1762476530309; Thu, 06 Nov 2025
 16:48:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251106210206.221558-1-seanjc@google.com>
In-Reply-To: <20251106210206.221558-1-seanjc@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Nov 2025 16:48:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiJiDSPZJTV7z3Q-u4DfLgQTNWqUqqrwSBHp0+Dh016FA@mail.gmail.com>
X-Gm-Features: AWmQ_blj82Vcahx3SOa6MtKIrMn8wu7jk2421gv57pbk7yInk5N0KSx4Ebh8Ack
Message-ID: <CAHk-=wiJiDSPZJTV7z3Q-u4DfLgQTNWqUqqrwSBHp0+Dh016FA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Use "checked" versions of get_user() and put_user()
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Nov 2025 at 13:02, Sean Christopherson <seanjc@google.com> wrote:
>
> Use the normal, checked versions for get_user() and put_user() instead of
> the double-underscore versions that omit range checks, as the checked
> versions are actually measurably faster on modern CPUs (12%+ on Intel,
> 25%+ on AMD).

Thanks. I'm assuming I'll see this from the regular kvm pull at some point.

We have a number of other cases of this in x86 signal handling, and
those probably should also be just replaced with plain get_user()
calls.

The x86 FPU context handling in particular is disgusting, and doesn't
have access_ok() close to the actual accesses.  The access_ok() is in
copy_fpstate_to_sigframe(), while the __get_user() calls are in a
different file entirely.

That's almost certainly also a pessimization, in *addition* to being
an unreadable mess with security implications if anybody ever gets
that code wrong. So I really think that should be fixed.

The perf events core similarly has some odd checking. For a moment I
thought it used __get_user() as a way to do both user and kernel
frames, but no, it actually has an alias for access_ok(), except it
calls it "valid_user_frame()" and for some reason uses "__access_ok()"
which lacks the compiler "likely()" marking.

Anyway, every single __get_user() call I looked at looked like
historical garbage.

Another example of complete horror: the PCI code uses
__get_user/__put_user in the /proc handling code.

Which didn't even make sense historically, when the actual data read
or written is then used with the pci_user_read/write_config_xyz()
functions.

I suspect it may go back to some *really* old code when the PCI writes
were also done as just raw inline asm, and while that has not been the
case for decades, the user accesses remained because they still
worked. That code predates not just git, but the BK tree too.

End result: I get the feeling that we should just do a global
search-and-replace of the __get_user/__put_user users, replace them
with plain get_user/put_user instead, and then fix up any fallout (eg
the coco code).

Because unlike the "start checking __{get,put}_user() addresses", such
a global search-and-replace could then be reverted one case at a time
as people notice "that was one of those horror-cases that actually
*wanted* to work with kernel addresses too".

Clearly it's much too late to do that for 6.18, but if somebody
reminds me during the 6.19 merge window, I think I'll do exactly that.

Or even better - some brave heroic soul that wants to deal with the
fallout do this in a branch for linux-next?

              Linus

