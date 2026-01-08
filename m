Return-Path: <kvm+bounces-67344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC356D00DC5
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 800AE3053BF0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927C228504D;
	Thu,  8 Jan 2026 03:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5BuMgMz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GGZ19Jsi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E861EBA14
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767842609; cv=none; b=YrS29bAFYrzqxfk55yT9fnV3EvElOcoZF2wlUam9g6rIYyUcCSfKwX8WGmyoQcQ1EJaP7C8Fg8KoZOoKswe/8EWtGjtvXau76ivA6gaz4rzvvjaauR4BlB3daH2d6y4Ma5KB6/WavX6Os5KQ48M141DjSOfpzjBLCuRzTJi72vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767842609; c=relaxed/simple;
	bh=oIv7VTewxFjssL2jhliOXXbBPd3GBbrqXH5sFUlQGGM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s1Cn+TaS58jqVMJgFvwDoSV9zSpXaxnqvGRr8Fc9ZqbQAOPJ/+3cNyvk1V3bWgIUYfvzgX20uRS+cPcC/lSvuGx+11tJULEy+nehvmYJOHtLsE/rHnHBET0YoHCblC739vpaafSKKR64O+txECBcxqykChqxxyxwsWpVD9J4JHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5BuMgMz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GGZ19Jsi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767842606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=53+r2N7iOHCghDUQ95LK593uOrK3zjiCULW2/UR+Mu0=;
	b=P5BuMgMz3qipG0lldGfymzYfiPt6pDlAz2P4d4lzx9KOwljN1uWqZbzlVCHprLA16DMgeD
	FZSSJmGukvX2yEVdQlddE52dXh+9fPno7EA/8HdL+MBc4MHKuVMyHFaQXP7QA5uH/id68x
	Ji6YahO7RiMrSaOnu5SzBGKRBYLPthc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-LVEx3u7COpmeON7IvdoA8Q-1; Wed, 07 Jan 2026 22:23:24 -0500
X-MC-Unique: LVEx3u7COpmeON7IvdoA8Q-1
X-Mimecast-MFC-AGG-ID: LVEx3u7COpmeON7IvdoA8Q_1767842604
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so2327583a91.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 19:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767842603; x=1768447403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53+r2N7iOHCghDUQ95LK593uOrK3zjiCULW2/UR+Mu0=;
        b=GGZ19Jsi6VxmGefZT5oxN764U7ZcOhbeaCBGnK+IkkCaFQ1+Uu1Dc9Agwrn9TZ94aw
         Aj5TsKdjzVdI9hX8qjOTUUB5HHC5XKoIJj2zL6y1cKGiDLFGWpLXHcTMJRzA5xR9PWFb
         lW6zkQnDOFsEFap/A+fT8q7q4r7Pzg162ZYwsoV5wuAcOICPWHULkN1Yvu8P2Z2LZrxa
         mYruQPjknQOYCaTkxjGExlA/oged10+vxpp8kR5TM5NMElTqNPk1+u4/IYKzAjwbPlHC
         f6t26/G6td6m9zqlU5vY08sstrb103l6ZgjivXVnh345d7U+xh1klUrET6wu1oChx65K
         8WIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767842603; x=1768447403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=53+r2N7iOHCghDUQ95LK593uOrK3zjiCULW2/UR+Mu0=;
        b=pfI5sOqn5ar0HDErem93+yoQEGuS0OOBk4PPoRmhrLlooFPFHITOCpmNlrfaovNQGN
         z10XBhvjBl7ctUS+LdgaxJ67xev+RgaYYT9H1bmP54lhl/fNLIfmyWsy75k0ApwvcsQc
         LPr/4I7ML3tXOjHr3pCp8yKDWaaMrvDOWxcBbe4ExgZADQgLvv2UAJ53dgYDnSweQldQ
         FVCR6zelUnjSilbhz9FWO9GtScB0rDMTyQBZeZXWtVm8TuJ28CFjoFzUcxEVh8qXXZ3n
         o8hI9Mv/G5hiSrB5hfaZqXV7L2Yp4UT/WmvkOY64pwXkSgZtgz7RL9MAxoTw0xt6MfMt
         lsng==
X-Forwarded-Encrypted: i=1; AJvYcCXAJ3cyiJzTxw7sse+DIFvp61cMIQLTKMtR3oDmvn4+7BbmBat1BnJnoeMuykKbKeRQ+oU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfVxxHDz4+8VTiAqe8LM29Z7mwe60v4GvACspcXr09iaR7XqLH
	4tY6KuwWZqvwh3115DcQjC1IZ67Oc+VXflSA0rrObOI9sHN5qW9k+BI9WVu9bBGjgB4TmbP/m6U
	Q382WMXYJ2lhVifPnpiX2VscIy1ptHX2u6Ru2iJ/uBM/NG0XqUS/yIl17VZmN2RJNAoYqpz1bxj
	Rw9PaRXYRNW6K+Xld9x06lifIJFhcn
X-Gm-Gg: AY/fxX64HulNnwsSjkPGKMSdSo5q31mnK/b6DxPnDy9hhtr8d9QOE+uJ/M+wnMr3ctc
	O6Y+FSOHVGI46Gxnw7fhjFro9gHJqGDIuQXYcNE6BLn1B1pnBgbNm3OKgOfe6u8xtgljuOiTgEl
	fmF6oLCoVSVZ4Ep8cSMmGk+BXka2HtFe3xV3LGvYly2f0Jqzurd1+VcznqGojFvGk=
X-Received: by 2002:a17:903:41c9:b0:2a0:a33f:304c with SMTP id d9443c01a7336-2a3ee4c0025mr47651265ad.57.1767842603726;
        Wed, 07 Jan 2026 19:23:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRtayNY0uqqjM78CiVQw7mFTLxT/iYnZszpaOrmD2ynKaqKve+vos88ChoY6cZhopiJ0fw3kSZsdEyMLVdhzw=
X-Received: by 2002:a17:903:41c9:b0:2a0:a33f:304c with SMTP id
 d9443c01a7336-2a3ee4c0025mr47651025ad.57.1767842603302; Wed, 07 Jan 2026
 19:23:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de> <20260107210448.37851-3-simon.schippers@tu-dortmund.de>
In-Reply-To: <20260107210448.37851-3-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 8 Jan 2026 11:23:10 +0800
X-Gm-Features: AQt7F2oDKZ3eYcdC7fFyoqIzzMdHxzeD7csgTVUKHz7k-5CronqUpphVIiXmk98
Message-ID: <CACGkMEsHxu_iyL+MjJG834hBGNy9tY9f3mAEeZfDn5MMwtuz8Q@mail.gmail.com>
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

On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> This proposed function checks whether __ptr_ring_zero_tail() was invoked
> within the last n calls to __ptr_ring_consume(), which indicates that new
> free space was created. Since __ptr_ring_zero_tail() moves the tail to
> the head - and no other function modifies either the head or the tail,
> aside from the wrap-around case described below - detecting such a
> movement is sufficient to detect the invocation of
> __ptr_ring_zero_tail().
>
> The implementation detects this movement by checking whether the tail is
> at most n positions behind the head. If this condition holds, the shift
> of the tail to its current position must have occurred within the last n
> calls to __ptr_ring_consume(), indicating that __ptr_ring_zero_tail() was
> invoked and that new free space was created.
>
> This logic also correctly handles the wrap-around case in which
> __ptr_ring_zero_tail() is invoked and the head and the tail are reset
> to 0. Since this reset likewise moves the tail to the head, the same
> detection logic applies.
>
> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> ---
>  include/linux/ptr_ring.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index a5a3fa4916d3..7cdae6d1d400 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -438,6 +438,19 @@ static inline int ptr_ring_consume_batched_bh(struct=
 ptr_ring *r,
>         return ret;
>  }
>
> +/* Returns true if the consume of the last n elements has created space
> + * in the ring buffer (i.e., a new element can be produced).
> + *
> + * Note: Because of batching, a successful call to __ptr_ring_consume() =
/
> + * __ptr_ring_consume_batched() does not guarantee that the next call to
> + * __ptr_ring_produce() will succeed.

This sounds like a bug that needs to be fixed, as it requires the user
to know the implementation details. For example, even if
__ptr_ring_consume_created_space() returns true, __ptr_ring_produce()
may still fail?

Maybe revert fb9de9704775d?

> + */
> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r,
> +                                                   int n)
> +{
> +       return r->consumer_head - r->consumer_tail < n;
> +}
> +
>  /* Cast to structure type and call a function without discarding from FI=
FO.
>   * Function must return a value.
>   * Callers must take consumer_lock.
> --
> 2.43.0
>

Thanks


