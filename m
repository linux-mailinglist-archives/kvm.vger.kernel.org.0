Return-Path: <kvm+bounces-13788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 068D789A95E
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 08:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5718AB2231A
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 06:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B294A22EFB;
	Sat,  6 Apr 2024 06:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeKzMyNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78296125C1;
	Sat,  6 Apr 2024 06:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712385273; cv=none; b=VjdxLUiRPST6Lc/y4rkEFOGZj3WrqIiA3V2URpIvd6Ady9suMtNjt0nfH7fK2M2mQdhfzQ9l3L5auEiu7pV0LP3AAHCKkAkwQcw2ybObTqSC4VmogRn/7k6DkupyoMKUQXRoxLL25Umhbjm6FXo/GPxCdYWhoWVOqsCysXcLHs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712385273; c=relaxed/simple;
	bh=w0zV6S/jtqpepUyL351B1h1ISsvSQFBhmHF+adO8uiQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ZUbooAnz7tML/YFlc/uI4+he1olnbZXpvlma/jvcp5LRergPUBjCnP9ehsJmzayyzFi6hRIDXYD1RIAeaHVQag4QQmlhP2v9NIvW2Dx7Gt1Vflsx0O0hgG9AwoWiTSqFo4FzZD/G5X0PEw5r3eI0rnoTmKpDLAcFA1hiHMSQ2ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeKzMyNQ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e2987e9d06so24564535ad.2;
        Fri, 05 Apr 2024 23:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712385272; x=1712990072; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JStnzUCrjKVc2+vxyRcSCMDwH6+PypfgeZAMMPE/SY=;
        b=LeKzMyNQWYMIHDatCmWm//joR/Roa+W2uOnKAc3Qm5o2H/s1cBE2eMTuVAYp6vuiii
         OFkZpDk5Q6RV32ueVYGKeZK+4TwzNItvIWTd66TRU7zcwnf8gyTI9mIcn0l08oTfmvyC
         XgkXTkiArvrDo3wu6i+7qNGxu3hLSd2H9B2RGyyCEieEjSUQblMauZDHqnXEp4hZ+SuY
         2tnjCHpHvIYXof4iuTSjmL9olCAsK6cILffNAF43ssimal5aOQU0q89gwalYQznZ2kV+
         UUdlTUiROQamj4asGpBjb+FEAkz31RZv2mcwEHsX+YXV3GXiiCzD5sKjJibqiqYtNdNe
         aNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712385272; x=1712990072;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9JStnzUCrjKVc2+vxyRcSCMDwH6+PypfgeZAMMPE/SY=;
        b=ncoHZKHcH4D8cUbyBxbIn1JvfCtq/ZKOyl34XF7pNGMXOTenNg3yJJ7LvJS7ixlOtr
         OVJe7VCWPt9CDER4VMJDOqkMC7RmowqfhfFa9K8VPuZCH5X0AqCwcCMsWZ36F1yt3818
         JYaSfZ38WvEU4FTsi4g6ghwtRfMTjNuzWWc/H4VEDAsINIak9cJ4Oc+qV6isPak2cZxW
         KsTzENF3/gVTys29bTrQF5T3qWDFiUD7ZMRyU6cyA1BO4nVdWGUxIPmVXI+BFmq2HdpS
         fyM8smKF320yaXqmaOIwUIcKZYxDcR0f4HQAkD+r+AiA+ovzL0YvYjC8NpetoxZ8iZa1
         ObCA==
X-Forwarded-Encrypted: i=1; AJvYcCUG+xmUjJjoOFY9mUsi+wxYKVaYD9KyUHLQWKxsYR3N1wSRLwkDhrAIG2UiHB+PYISUfTsOQ8pSRaF3w/kaw4vQJ2b0sDmBkhybiVsDo/Gmt72bIP/4eUwPhkRwjHELMg==
X-Gm-Message-State: AOJu0YxRZjoUWbYIUxJe0IVyBen3LVSP48i3JWq/mtdIhvw5IwWz5uD9
	UmydPS4n14LVUfAjPcKmPDLSwcXw3ihbhZNnpAPgsox8I5QMfkAtTypQWOOp
X-Google-Smtp-Source: AGHT+IFZ1bnBFNa/f7mj9nWkwUcDhM7BYoeBvC8x+4h61aPwpJPSnjywqYCopFigwQM3malM/wYOgQ==
X-Received: by 2002:a17:902:f085:b0:1de:fbc3:8e4a with SMTP id p5-20020a170902f08500b001defbc38e4amr2782558pla.52.1712385271781;
        Fri, 05 Apr 2024 23:34:31 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id kj8-20020a17090306c800b001dd69aca213sm2677034plb.270.2024.04.05.23.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:34:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:34:21 +1000
Message-Id: <D0CTWX0N023S.3U58HCNRJDC1R@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 00/17] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405-20fbe979a00acc8b9d161936@orel>
In-Reply-To: <20240405-20fbe979a00acc8b9d161936@orel>

On Fri Apr 5, 2024 at 11:59 PM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:32PM +1000, Nicholas Piggin wrote:
> > I foolishly promised Andrew I would look into shellcheck, so here
> > it is.
>
> Thanks! I hope you only felt foolish since it was recently April
> Fool's day, though.

Hah, no it was fine, it was a good idea and I've been mucking with
a lot of the bash so, no worries.

>
> >=20
> > https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=3Dhea=
ds
> >=20
> > This is on top of the "v8 migration, powerpc improvements" series. For
> > now the patches are a bit raw but it does get down to zero[*] shellchec=
k
> > warnings while still passing gitlab CI.
> >=20
> > [*] Modulo the relatively few cases where they're disabled or
> > suppressed.
> >=20
> > I'd like comments about what should be enabled and disabled? There are
> > quite a lot of options. Lots of changes don't fix real bugs AFAIKS, so
> > there's some taste involved.
>
> Yes, Bash is like that. We should probably eventually have a Bash style
> guide as well as shellcheck and then tune shellcheck to the guide as
> best we can.

+1

>
> >=20
> > Could possibly be a couple of bugs, including in s390x specific. Any
> > review of those to confirm or deny bug is appreciated. I haven't tried
> > to create reproducers for them.
> >=20
> > I added a quick comment on each one whether it looks like a bug or
> > harmless but I'm not a bash guru so could easily be wrong. I would
> > possibly pull any real bug fixes to the front of the series and describ=
e
> > them as proper fix patches, and leave the other style / non-bugfixes in
> > the brief format.  shellcheck has a very good wiki explaining each issu=
e
> > so there is not much point in rehashing that in the changelog.
> >=20
> > One big thing kept disabled for now is the double-quoting to prevent
> > globbing and splitting warning that is disabled. That touches a lot of
> > code and we're very inconsistent about quoting variables today, but it'=
s
> > not completely trivial because there are quite a lot of places that doe=
s
> > rely on splitting for invoking commands with arguments. That would need
> > some rework to avoid sprinkling a lot of warning suppressions around.
> > Possibly consistently using arrays for argument lists would be the best
> > solution?
>
> Yes, switching to arrays and using double-quoting would be good, but we
> can leave it for follow-on work after a first round of shellcheck
> integration.

Okay good, thanks for all the review on it.

Thanks,
Nick

