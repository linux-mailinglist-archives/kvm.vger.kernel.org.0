Return-Path: <kvm+bounces-8806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97194856AAE
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8F181C23EC9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D23B13698F;
	Thu, 15 Feb 2024 17:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jqkhZqRB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C468A135A52
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708017231; cv=none; b=couXhNq3PeWY/1geiOqlhGl7g8fz1ZtOFpcV2Rqv/9alzR4uGXstjE34rh8VC2mZb9k4QkAEd0QrAu3N8EbZpQP+CV3gCVqHGpy44OIZFKma5ei+0MNsDTfcPFULeIAL1gP/dNFM5kXbfFjQs+K0qoCiti0Wy9rNAmPWTSh/d2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708017231; c=relaxed/simple;
	bh=4KfSgtAfZD37/FIJaRSDhjOsPagNqzXs4cq+YyiV67s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SmuPfqBYJMfqD1jgGjkQbvSkPUp6qE7WIB8lKtYFUA5CtHzXOJHXe3ogB8OK18IQb4TAKx7b8r7kbDpmo1E4Ur0OJCIHgJUzi+gWaoDh97nDsItqu/SDk41tUjMvXxinIkGd9V41RNfWuO3Bv0KBks6CakaHJcoH9o7bgL0AktQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jqkhZqRB; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-56037115bb8so11601a12.0
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 09:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708017228; x=1708622028; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iad/Zy2GjaaFx2a8li/jYlFETFryFlNntHsoRxU5KYM=;
        b=jqkhZqRBBaVdBA55C1Fq6rVhn++GE+mM9N54C11HatzK4ttfqKXJoEfYpUEJKxsWQI
         GWb+XK8X+rS60ZYa/4bMKW6V3/KQrK/4OAWRvGj3LqvYhDV491nyifCEKGYIjv8CK+ZU
         bi2FvvJeC9I7CxYxfa9TYgvqpD4KAWp0HLTSzJ805/Xzo8TM6ustSkzOg4nYaqjQUc5G
         XDs20ShDjDo2Rh8cHLy2GkbOosXOfDrgDbd2p5YVDfJ2y5qo4XmmVwHYU1ZQlW+AxJno
         9Cn9aatqPDm5wuQMasD2lm3jg4lQnOKhgF8zuDx1DWdFXOstkB2oCGE073McfnJhgkBV
         ytdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708017228; x=1708622028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iad/Zy2GjaaFx2a8li/jYlFETFryFlNntHsoRxU5KYM=;
        b=BLETwi687XaJrEDNBlUulp2aqN9lrZdnWSPzNOpK8fnkJwlOlAJVgLPx6jyEZLCwKY
         piX6m+9yg02CnMNYC7EVBQNKFHIBKrzfwojLj2ISnRexdxqvBkEnM64GBRt1tWFfTgvw
         bUrFbIn25iSqUwagvWlo8UAzGYwYT+ImVulHiKK6T4h66RuYJujt16w//4qqnWDuJ5ZR
         w1r4z0dss8v0vQJVJRmFFTDOwRxfOjbYdHd9XZdryn1S2DwXMCGCAB86vwep0f7IRbuR
         BJ0sh0s5t18YYcOtYMZjm4DpiPfxqaiecoBS9aFYQgo+TTloen3FpAprxcNACWw9r7+a
         1wZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF4ZkRo1Xe7FNmuidAWX71ofDA84FUe7Y4DM4ai6Q6BWDPMjNioUvU2zb2zdFxXNFyrtP3rFr7CHAwXkUpz5+fUZ3f
X-Gm-Message-State: AOJu0YzceS68W42mbji25MfOjDR4zcUfvJ6UzV9IT2loGq7qkfyv4awg
	6GTsA/4w53qnMpzwyqdApdtTF51dyy9P1+wN14dfAwA+pENOn6MPloCn4+S+LQagM8dyNK8exrC
	0v0wJXXTxhikmRlKyeoUj/8+28Lbebij7e21N
X-Google-Smtp-Source: AGHT+IGZNw7fc2kZJJpDXqC9iEc2obKjv5RjjbUoiLxpw1mSvwqdqqrem5zu7gKD2XqXNNmwDH4VTc78e12HGaid2y4=
X-Received: by 2002:a50:cd8c:0:b0:562:70d:758 with SMTP id p12-20020a50cd8c000000b00562070d0758mr1150edi.2.1708017227953;
 Thu, 15 Feb 2024 09:13:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-2-seanjc@google.com>
In-Reply-To: <20240215010004.1456078-2-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 15 Feb 2024 09:13:36 -0800
Message-ID: <CALMp9eSg5eDiraSMptLvyLkTXaH4DYX48xG_hKXEqzN_tHMUEw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: Mark target gfn of emulated atomic
 instruction as dirty
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2024 at 5:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> When emulating an atomic access on behalf of the guest, mark the target
> gfn dirty if the CMPXCHG by KVM is attempted and doesn't fault.  This
> fixes a bug where KVM effectively corrupts guest memory during live
> migration by writing to guest memory without informing userspace that the
> page is dirty.
>
> Marking the page dirty got unintentionally dropped when KVM's emulated
> CMPXCHG was converted to do a user access.  Before that, KVM explicitly
> mapped the guest page into kernel memory, and marked the page dirty durin=
g
> the unmap phase.
>
> Mark the page dirty even if the CMPXCHG fails, as the old data is written
> back on failure, i.e. the page is still written.  The value written is
> guaranteed to be the same because the operation is atomic, but KVM's ABI
> is that all writes are dirty logged regardless of the value written.  And
> more importantly, that's what KVM did before the buggy commit.
>
> Huge kudos to the folks on the Cc list (and many others), who did all the
> actual work of triaging and debugging.
>
> Fixes: 1c2361f667f3 ("KVM: x86: Use __try_cmpxchg_user() to emulate atomi=
c accesses")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Cc: Pasha Tatashin <tatashin@google.com>
> Cc: Michael Krebs <mkrebs@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Let's try this again, gmail...

Reviewed-by: Jim Mattson <jmattson@google.com>

