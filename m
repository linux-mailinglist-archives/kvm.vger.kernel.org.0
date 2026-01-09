Return-Path: <kvm+bounces-67519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD29CD074C7
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 07:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 240BE3049F39
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 06:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C4D2773FC;
	Fri,  9 Jan 2026 06:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HX5e1SA3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j8XOHxdo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2AB1DDC1D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 06:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767938532; cv=none; b=BDbspL4yc5TPkIPjp5U/ygvUfkb24vktZISh3R9OmcIEsoHTBOgwbceFEHa1dTqmz0+JB4mwZO/PPwuopDY2Skt828wm4j+SsHvSG6ttU0My3d6GM7/SUPPE5fY6C2SFZpnlVYFbhAVX0RtkIO+dm6SIUgYmOdmbPskq5E5L0To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767938532; c=relaxed/simple;
	bh=LfbV3bIWDp4J9DPIWnoVpSzQ2fMzemhZ73PGMmrMWEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WiCCXAOqG/fiuYv/5qqZC6fNgYRzzvqNjsVWAbiu7wEOPYk65TokgUQ6LSBhTHLnjBkRtrXvt70DIA8bXjhPqtCjmMOcAlutzwMNipgypLSHNGYDj5/14hTRvVox3KCNJCJ2O//oJU+ppEwRjdrkj3Cxd/lYZ93HgXbFT/B6HeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HX5e1SA3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j8XOHxdo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767938529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=62L7uKK76qUdf8AcX+V8O9A8VaWvwOnCNJYaGsTTDE0=;
	b=HX5e1SA3jOH8bQz7r9V/8KiTSDfNhXOgmUHZDymbpGxrIWGvarxT0FsndacfTVju1lrody
	IRNSQADmnAJ1PJbDAxDEIGicuMMP0NBJBWPP7WR+H3e88Yp9tU10XzUn2+yKeJppzxqWLY
	U3XAdVW1107HnqeXu7rJokbdy29d+uE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-E5sKuI6NPOKHACIPJnd_gg-1; Fri, 09 Jan 2026 01:02:08 -0500
X-MC-Unique: E5sKuI6NPOKHACIPJnd_gg-1
X-Mimecast-MFC-AGG-ID: E5sKuI6NPOKHACIPJnd_gg_1767938527
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c52ebdd2d43so1034281a12.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 22:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767938527; x=1768543327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62L7uKK76qUdf8AcX+V8O9A8VaWvwOnCNJYaGsTTDE0=;
        b=j8XOHxdo5gGBxLHaChQ6shDF6LTPqvvWqbLzf8XgdgAOjxWw1fdOd2O7TndGlHtqEK
         XbF8hr1zmTTN/D6iEX2nEieRZtdysjVPQtAzwcEclLh2jcjkxC+kljVF2nP9o0m2vyFr
         Ei6OazK3DnpfRWAgUZGGzrw6Hlmor+pUAaAb+4oPfM2eQzW+W/lIJChMhwo1140fsXwE
         226jH060612FGSCAhHf/Gtx7CiFxVGjBzvIRR7kW/wS8QTnzOGG+/xRMfKv5lkopuG9G
         lWAKx9ThrGRGKl2UJZclXGj3kMQjEunnfewRWY5dSboRrwbRakjI8zrfoLoQuy7u6ArD
         hD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767938527; x=1768543327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=62L7uKK76qUdf8AcX+V8O9A8VaWvwOnCNJYaGsTTDE0=;
        b=C1zFkL98jMIF9/5R8TkXlHLWEA7itx+VtYf7xQ/QCtPOxH+OtvcuWohhsErBAH/hZ/
         lTGAxGSUfRWkvZ/bWZKSm372I88u1tX7Lw3cuCpwQFZsBUEVOqrXdGKATPfJAukbLn2F
         8MoEe0cFAifAZhtViiLHtihx4kBU5jd/pBT/J1JMw4TIbjvWaj7GkEo6Fqwi4cb5ANc/
         93efI9x1xUm6Qe2m0oi7tV0HNzYy5mfc9ujs9bpQxyiPdVZ0Qr5GuM5M2aYfM5h5Ytg1
         Q1m/TML4CXBtJZF0NowXSUdBTF/8w86X5XrC26h4tq4Id8DIF/5VAPD2jgQm1bbKlNlM
         VpHA==
X-Forwarded-Encrypted: i=1; AJvYcCXINtn8vFEbEXQ2DsHDhA+6IdMUW3Z3gj0ySif4e0RJ/U71OJdSKu5CnOX3ciT2M8V9TQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3q2cvBPhjNPqQ1f3SBwe4Mak19qONrD+zmin4W1+Ob6itE1JD
	feJ83kLULejwoholkZHchE2zminSkJMVDVbIJ6rIwEEQ3pL/tAVF8gTT20Zb6iYo/Q+QswKLTde
	6/ZFlvum9PoscI2vAQlnvsfB5WB2u0CFhWCOMBI64wet12FNWkz7e7paYCeLHtVBu49BC/ldPWE
	IG5hP9RazcbRU3BWtXbVw+y+Ao9a4i
X-Gm-Gg: AY/fxX5U6lvETKIwkX9n7goiIIuMIoA2Fm9xEgcbGi2iMcuDI5486/GFnasDux47RGQ
	COtnoiSW97x3GgBFEIycd+2EAHZcjXWpLZoZVJDPUKPoy8IZL712e8AHMii0Ik9KwRLEsA9aa2O
	sNbHiUmJ49CfHx0snGYu9qun9d+CPOvOH7kjCJXrfunanPrCsKYO9Wb4hFfhJXsB4=
X-Received: by 2002:a05:6a20:6a11:b0:371:53a7:a48a with SMTP id adf61e73a8af0-3898f8f5552mr8820773637.1.1767938527027;
        Thu, 08 Jan 2026 22:02:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7U5gpSDRrYYCGHdnAQ2bq5uAgkTGfK+sH12YYJ68NVxDB/cGt7yVMQVT5cwc8QARma7YH0oByMp3T1kPE0Jw=
X-Received: by 2002:a05:6a20:6a11:b0:371:53a7:a48a with SMTP id
 adf61e73a8af0-3898f8f5552mr8820736637.1.1767938526583; Thu, 08 Jan 2026
 22:02:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-3-simon.schippers@tu-dortmund.de> <CACGkMEsHxu_iyL+MjJG834hBGNy9tY9f3mAEeZfDn5MMwtuz8Q@mail.gmail.com>
 <ba3cffe3-b514-435d-88a8-f20c91be722a@tu-dortmund.de>
In-Reply-To: <ba3cffe3-b514-435d-88a8-f20c91be722a@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 9 Jan 2026 14:01:54 +0800
X-Gm-Features: AQt7F2qhunhdhWvtDP-HjKQwCMpNXEKD9HAqlgqUpB6kCWfjauzXhQR7-f4zQJk
Message-ID: <CACGkMEv2m5q-4kuT5iyu_Z=5h0SMz0YYeKRBu8EtrxC_E-2zWw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/9] ptr_ring: add helper to detect newly
 freed space on consume
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 3:21=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/8/26 04:23, Jason Wang wrote:
> > On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> This proposed function checks whether __ptr_ring_zero_tail() was invok=
ed
> >> within the last n calls to __ptr_ring_consume(), which indicates that =
new
> >> free space was created. Since __ptr_ring_zero_tail() moves the tail to
> >> the head - and no other function modifies either the head or the tail,
> >> aside from the wrap-around case described below - detecting such a
> >> movement is sufficient to detect the invocation of
> >> __ptr_ring_zero_tail().
> >>
> >> The implementation detects this movement by checking whether the tail =
is
> >> at most n positions behind the head. If this condition holds, the shif=
t
> >> of the tail to its current position must have occurred within the last=
 n
> >> calls to __ptr_ring_consume(), indicating that __ptr_ring_zero_tail() =
was
> >> invoked and that new free space was created.
> >>
> >> This logic also correctly handles the wrap-around case in which
> >> __ptr_ring_zero_tail() is invoked and the head and the tail are reset
> >> to 0. Since this reset likewise moves the tail to the head, the same
> >> detection logic applies.
> >>
> >> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >> ---
> >>  include/linux/ptr_ring.h | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> >> index a5a3fa4916d3..7cdae6d1d400 100644
> >> --- a/include/linux/ptr_ring.h
> >> +++ b/include/linux/ptr_ring.h
> >> @@ -438,6 +438,19 @@ static inline int ptr_ring_consume_batched_bh(str=
uct ptr_ring *r,
> >>         return ret;
> >>  }
> >>
> >> +/* Returns true if the consume of the last n elements has created spa=
ce
> >> + * in the ring buffer (i.e., a new element can be produced).
> >> + *
> >> + * Note: Because of batching, a successful call to __ptr_ring_consume=
() /
> >> + * __ptr_ring_consume_batched() does not guarantee that the next call=
 to
> >> + * __ptr_ring_produce() will succeed.
> >
> > This sounds like a bug that needs to be fixed, as it requires the user
> > to know the implementation details. For example, even if
> > __ptr_ring_consume_created_space() returns true, __ptr_ring_produce()
> > may still fail?
>
> No, it should not fail in that case.
> If you only call consume and after that try to produce, *then* it is
> likely to fail because __ptr_ring_zero_tail() is only invoked once per
> batch.

Well, this makes the helper very hard for users.

So I think at least the documentation should specify the meaning of
'n' here. For example, is it the value returned by
ptr_ring_consume_batched()(), and is it required to be called
immediately after ptr_ring_consume_batched()? If it is, the API is
kind of tricky to be used, we should consider to merge two helpers
into a new single helper to ease the user.

What's more, there would be false positives. Considering there's not
many entries in the ring, just after the first zeroing,
__ptr_ring_consume_created_space() will return true, this will lead to
unnecessary wakeups.

And last, the function will always succeed if n is greater than the batch.

>
> >
> > Maybe revert fb9de9704775d?
>
> I disagree, as I consider this to be one of the key features of ptr_ring.

Nope, it's just an optimization and actually it changes the behaviour
that might be noticed by the user.

Before the patch, ptr_ring_produce() is guaranteed to succeed after a
ptr_ring_consume(). After that patch, it's not. We don't see complaint
because the implication is not obvious (e.g more packet dropping).

>
> That said, there are several other implementation details that users need
> to be aware of.
>
> For example, __ptr_ring_empty() must only be called by the consumer. This
> was for example the issue in dc82a33297fc ("veth: apply qdisc
> backpressure on full ptr_ring to reduce TX drops") and the reason why
> 5442a9da6978 ("veth: more robust handing of race to avoid txq getting
> stuck") exists.

At least the behaviour is documented. This is not the case for the
implications of fb9de9704775d.

Thanks


>
> >
> >> + */
> >> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *=
r,
> >> +                                                   int n)
> >> +{
> >> +       return r->consumer_head - r->consumer_tail < n;
> >> +}
> >> +
> >>  /* Cast to structure type and call a function without discarding from=
 FIFO.
> >>   * Function must return a value.
> >>   * Callers must take consumer_lock.
> >> --
> >> 2.43.0
> >>
> >
> > Thanks
> >
>


