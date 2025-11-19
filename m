Return-Path: <kvm+bounces-63743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3FEC7093B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 9C63A29A58
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 18:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF272312820;
	Wed, 19 Nov 2025 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPpqe5Cp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nucims+N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7FD27AC57
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763575745; cv=none; b=KlU3ikmj2x9UP5CR3iZo4nfeGMBMyA1aOImFdGJJCcCE//k4MOpFTLQcxCYT56g5f/YY7F3YmhnRZSQJL0rBBlP7+CMk/GfEsb7UKE7smK8Q/SvOpKLsS2W3N4l9affMy4TwTtdjP1+BLFyK2Ufkz5sJwBu0sCiaHnSfqlFwzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763575745; c=relaxed/simple;
	bh=fakVuUczLsWTKheID6RKVRmFqwS2jFCzku8DHlFVRQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLmmNUi+8HQ/CNZe99EblSmC2WzHTcb7n5Z3cHVNWJXVkvxZn39M3ka/5iB7aY73kdUq0ISyLB85CH/xROEJg4MyTr6LcgY6VMJVK7V8IlOC1fJS2ismj3Dt5k5qN0ieKEXPGvCgpH87songC5LpZXEgNyX8f4S+mGQqA5jTPwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZPpqe5Cp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nucims+N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763575736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e4w9qUfBPNqlHWR761GYigXjDzqbKAXHlPl3evsHnXw=;
	b=ZPpqe5Cp+ilyNyVb28RmMJpdlqufkFq+1XIcGO+hu9m85X38XttRhSE/YcEYFJmAJH3Csk
	GU6AopdczfMwvKkMjPA85E3n5bTDWMZTtGfnW1LDgCD3Oqp9UgSDzXqj999c1bowmIJz1Q
	DOpZpcGPf5h1YgaU3uhe1RgDc5cvZu8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-opABesN7P5Osr_UXzVJkRQ-1; Wed, 19 Nov 2025 13:08:52 -0500
X-MC-Unique: opABesN7P5Osr_UXzVJkRQ-1
X-Mimecast-MFC-AGG-ID: opABesN7P5Osr_UXzVJkRQ_1763575732
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429cd1d0d98so10097f8f.3
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 10:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763575731; x=1764180531; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4w9qUfBPNqlHWR761GYigXjDzqbKAXHlPl3evsHnXw=;
        b=nucims+NI6oAalOrHGc9tL2Cba1Kt4yMGk3JwTdOxkw8QWPe5jNRmGT4UEy8kchqCW
         PH5VO5JOrBDIIzq+tgMo7vHTycoPqU24Eo8kCDF5SXbE/g4/h9IFGSl/0MnECLVzAtY/
         susTucHqV6Yka9hWWSjSKm352oowE0TXggs6MFB0wsmc+EP5PiYnxNEwQzk0XxpXvNyb
         +nBzC9ySKHBbuGCbQJ8cZlP0XbjAK9lSJU0lAX+ljrn/TGH04MpeX3hUjj04ZVPvmooE
         GkZk/+TIe7Od2Qod/jga10er/LlDGRClMntxdAFiTtUf86lV0fKz3V/BoQT7KYE9qp+G
         hTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763575731; x=1764180531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e4w9qUfBPNqlHWR761GYigXjDzqbKAXHlPl3evsHnXw=;
        b=YVMSrdDYDhFK3YRy02Q+QOKrb2A9C23QdkWcrCSvKQn11gpXlyzE5LlHhSK2sHv6sR
         F0EwLQa9OW+268kFfj4V7RjoG3kGFQnmTkkQKlIRpBvaYtbobO0LyipmlecHKGM/b94Z
         JsGzWyZgobZgPvGx2SDVCQUe8HU6Zcxm3UDshwu095cAeMWWexevJt7qy+oJRqBvn1T1
         KiRIA5lVWU4wA7D+vm2FbMmAlVbvFny2ib4tUPNEI5oKYmxwLkhCSRz3yZGw+hDdWOR/
         oB7lFWGLmkvNIJRDtFpZaff6UhANjIEB1wds74PAtp/sZcd2gAw9xiWp7J3j3QDBeX/j
         p3PA==
X-Forwarded-Encrypted: i=1; AJvYcCX4MNZOE1fDO4Ttfw2YQQpRH1+1RJq37hSx8ryAN/I3w6Yaahy0gOz5c1MkYjLP18sdJGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRu9W8orkeGxiJQf8GLLfjZEqyNnqNAt15GkU3VqopRtPzu8Md
	d32k7SwLt5itK2/Yk751kxHvLWFEXdrBwcTsuzW0Em1udvUeBNe3W7ME9AyJgbiDqkgjTC9sIEg
	NK//9PGGTHT8doAy0oapS+YrBoy9R/APt8SaxRc/yns3sOb3LXH/4R06jJdgyPOsLAjV9ZIiwra
	u73yyhWsqif+0WLn90nLu3ppJMo0SV
X-Gm-Gg: ASbGnctfQ+9ZlmV38N3b6dl8sVq3Lmd9ul+Kbhm9CJvsJeDHn4JhqvX0NfYTRhJia+N
	uqD1OquKcbFSVUzeieF87ayOWRTsjeKBMl79KfKk4+5OByY7PDnNtsJZf3wGDIXV164qQnoAjt4
	8ce5YCWGh6oW7xNmQ3NJZ4zPR4saZWJcaqi2w7muQtnyFCwvvz5zDCOJlLX9w+/8mjqFu+f7lq6
	jG2fqrtdoPh+aNWftUBvZnGtHlFosHezU6+IfPq8kzM2rEZvExD7Zw1cOQun7o7Y0pR+IQ=
X-Received: by 2002:a05:6000:40de:b0:429:8daa:c6b4 with SMTP id ffacd0b85a97d-42b593497d8mr19539691f8f.21.1763575731485;
        Wed, 19 Nov 2025 10:08:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFM3+HiCKuo+MB8yCGXu3hopFkEu2pEqFtoOTpey/HAF3kWb7fs4h9KqgFD0kfB73wWdRQReAFNiiZ+raP7ac=
X-Received: by 2002:a05:6000:40de:b0:429:8daa:c6b4 with SMTP id
 ffacd0b85a97d-42b593497d8mr19539669f8f.21.1763575731072; Wed, 19 Nov 2025
 10:08:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118065817.835017-1-zhao1.liu@intel.com> <20251118065817.835017-5-zhao1.liu@intel.com>
 <CABgObfZfGrx3TvT7iR=JGDvMcLzkEDndj7jb5ZVV3G3rK54Feg@mail.gmail.com>
 <aR1zIb4GHh9FrK31@intel.com> <lhuh5upzyob.fsf@oldenburg.str.redhat.com>
In-Reply-To: <lhuh5upzyob.fsf@oldenburg.str.redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 19 Nov 2025 19:08:36 +0100
X-Gm-Features: AWmQ_bnP_jPIBa_pCEhGrRI1O_HVzZjEH7dyW6CfW-AYdWmRuTyzlIIDNIWUIl8
Message-ID: <CABgObfaXxJjOzJs_mhnq7_VnjgkMmirXhXXW7XDP=DindV6eLw@mail.gmail.com>
Subject: Re: [PATCH 4/5] i386/cpu: Support APX CPUIDs
To: Florian Weimer <fweimer@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	"Chang S . Bae" <chang.seok.bae@intel.com>, Zide Chen <zide.chen@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>, Peter Fang <peter.fang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 7:04=E2=80=AFPM Florian Weimer <fweimer@redhat.com>=
 wrote:
> This sentence (from APX spec rev.7) emphasizes the =E2=80=9CIntel=E2=80=
=9D vendor,
> > and its primary goal was to address and explain compatibility concern
> > for pre-enabling work based on APX spec v6. Prior to v7, APX included
> > NCI_NDD_NF by default, but this feature has now been separated from
> > basic APX and requires explicit checking CPUID bit.
> >
> > x86 ecosystem advisory group has aligned on APX so it may be possible
> > for other x86 vendors to implement APX without NCI_NDD_NF and this stil=
l
> > match with the APX spec.
>
> Well yes, but I doubt that the ecosystem will produce binaries
> specialized for APX *without* NDD.  It's fine to enumerate it
> separately, but that doesn't have any immediate consequences.  GCC makes
> it rather hard to build for APX without NDD, for example.  At least more
> difficult than building for AVX-512F without AVX-512VL.
>
> I just don't think software vendors are enthusiastic about having to
> create and support not one, but two builds for APX.  If NDD is optional
> in practice, it will not be possible to use it except for run-time
> generated code and perhaps very targeted optimizations because that
> single extra APX will just not use NDD.
>
> I feel like there has been a misunderstanding somewhere.

I totally agree and I think this addition to APX was very misguided,
no matter who proposed it.

However, for virtualization we probably should include this code no
matter how much I dislike it, because having to add the bit later
retroactively would be worse.

Paolo


