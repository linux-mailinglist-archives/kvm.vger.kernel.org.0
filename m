Return-Path: <kvm+bounces-53574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4FCB141CC
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 20:17:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14D663A7EF0
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4F3275873;
	Mon, 28 Jul 2025 18:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKBLeMi/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C1213E85
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753726660; cv=none; b=HqMOYQ48z9MQPNklIGNcLLBTjtHyYO8bErvZx64MHnozJaZzTk+y7zmPHRB3FldCYCitOMzQkH3aCMq2CvrME34AmrIeo/m419jCLqw5JufoMmjn3N67wEhJkMNHj8h9t/HZMITk3LYq4aLl+zn0M2FRj2iLDs+p08UFHhq1F4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753726660; c=relaxed/simple;
	bh=VDlEiwovForUKX6glMaAfiqHDQdEgC9cj1h8O6kYSlM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VT+yABSh+oNbe6J6RNX2RDnddQ9HzWw9DD325UFaijCjydsJ3B5qgm9LSVxzsvEBfZjQa5hJ/unBcjQ2+UZAmE/QqUzhDlq3x5iXqeV8sgc67eIsV7yBMnoYTTuPEDRPYmw0taKcdE0S69Ovz9vPaK2HXH3DZYUnSQ5F8MERvzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKBLeMi/; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-32e14cf205cso46992901fa.1
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 11:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753726655; x=1754331455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abFGoaaLKyanJnlZpRo9hB7o79m3CiWoXYjYW1q8YQk=;
        b=OKBLeMi/ccC0b1loNQeMVtjw8/uQlxvqMTlA6IijIOXjrl9Aeqjvv8ZDmslOrLtK+B
         H8Re38ERV0cU/Kd8OSmQrl0Gr+fifUTvp/RSBtY7kNsMRvldvUs280PgesF7AaJ5yWrX
         TByzddGUFmEkFT9FRxxuTY3uFKz1wKUYhSkj8qBPNu+61ZAx4BXkIDmFntDFbwDElFzO
         S8AoIoQUSfsg/pLE/rwLm/c0dvI+QKZ0q8z+mKcXPYa7Ef3ppwsXFrK/0kDB2coAtSIz
         iyZQz09ZNH1PCkBmb8IF6iwrknppdWSK6f7OtcYxuPCWnPp6cmRkQAJTWM9CA8zWY3/H
         vtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753726655; x=1754331455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=abFGoaaLKyanJnlZpRo9hB7o79m3CiWoXYjYW1q8YQk=;
        b=gMsZfuYBf5Px5hqIlvEXvQMO5uDU6gt5mn8LGWdQUZ+W73S04oB2OheVmD7e1FVR5h
         vEmHErcGhQJc04pyiPd2oUTzEi7dj76NddO3dJDcaAcgCRtpUJFqo7qDwJF+ClUCYuBU
         TWUSAeAxLMMDljq4BR6XbKnUNQ8IqNr3gr6jSikSW/WCp+++993lj0FgHK0KchAAWeu9
         pOgH+mxR0P/vZ0wKb78W/Q5YNBLHUZ2nq7ls4Z657bHgKlNErtqHuLUFSwjlLJQvboNJ
         DDgg8cMIq746JMMyLcaLIui/2+0w2cT9N34ZHQfRymeE/azKheYm2LW7FaCCyYcOl/Pw
         CCOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkdygejUGGWHuJA82WhISihGmLZc1hyVyYXcLJj0p4rtTuLJr9oeYartBIfka0C3kaXH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXlJjgSpoXnc8DHKEQFK64F2PjKrQN5johAMBUOZdMhXBj073Z
	WkdWA41xcZymDEB73z+WxysiqAAY52a2CPxfrf/HWth1ViwWktpi1RGkUvGKtG7ktMmDKD7Fz1+
	XSFDWH4L2P69N4Kqm1TfuiHaQag8+ChhhdEd/wKseqOXBrZyj5Yf4NBaInfQ=
X-Gm-Gg: ASbGncuAX4ppLmtxSf256PITqiU6HFRIHH3I/z9KZu+kT5u8D4BLGbrtEyLJLCrtfyC
	ee952hUUtw0F8XkAd2c7QjS4yzj9O+tCRbGjXfgb2MqvzCNQv3lMzH6bVToEsMW8aJ4/4ZbHjvD
	z6eWeVUD9z/0azbJcCR3pmFi8E24vJPDMN0P5VCOalgw5W2AdwBARXmJPpO9yX3nlKDrgrttjFv
	x+Aawg=
X-Google-Smtp-Source: AGHT+IEJHS852UVpU5vL94onuZIrwp0eDPbW78u4HdyCQoNEd/oAvT0Y7thZ3sQ9bQLlq2pDNmOPdGs27+Yzee4LzYg=
X-Received: by 2002:a05:6512:3d2a:b0:554:f9c5:6b30 with SMTP id
 2adb3069b0e04-55b5f4df42dmr3074009e87.38.1753726655095; Mon, 28 Jul 2025
 11:17:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-4-jthoughton@google.com> <aIFHc83PtfB9fkKB@google.com>
 <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
In-Reply-To: <CADrL8HW46uQQKYUngYwomzfKWB0Vf4nG1WRjZu84hiXxtHN14Q@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 28 Jul 2025 11:17:08 -0700
X-Gm-Features: Ac12FXx3wVXlb41VNkshvgKpI33DjTt3OFbnSm8kispxP2pDqaX0TG1jBjkEzTs
Message-ID: <CALzav=e0cUTMzox7p3AU37wAFRrOXEDdU24eqe6DX+UZYt9FeQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 11:08=E2=80=AFAM James Houghton <jthoughton@google.=
com> wrote:
> On Wed, Jul 23, 2025 at 1:35=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > @@ -7559,8 +7590,17 @@ static void kvm_recover_nx_huge_pages(struct k=
vm *kvm,
> > >       rcu_read_lock();
> > >
> > >       for ( ; to_zap; --to_zap) {
> > > -             if (list_empty(nx_huge_pages))
> > > +#ifdef CONFIG_X86_64
> >
> > These #ifdefs still make me sad, but I also still think they're the lea=
st awful
> > solution.  And hopefully we will jettison 32-bit sooner than later :-)
>
> Yeah I couldn't come up with anything better. :(

Could we just move the definition of tdp_mmu_pages_lock outside of
CONFIG_X86_64? The only downside I can think of is slightly larger kvm
structs for 32-bit builds.

