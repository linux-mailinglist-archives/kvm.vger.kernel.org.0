Return-Path: <kvm+bounces-63402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48232C65948
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A44DF4E5482
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 17:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC23A30AAD4;
	Mon, 17 Nov 2025 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j0qGRv2n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D37F26F46F
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401297; cv=none; b=ua6bOwaNxT1WJYg130MjiNHqaDfP5F2oLh2Qwapfy5PFXKCQbNDPrS+YdF9c1ZifSDzPB6AlXlXmgfpLLNFtOweiT/Li6USmxMRvqZei6rNBioButumLU8Ekc6WZUz/TmQPEdMvt+UNpopokqAn4NBIi1HjTeXt2YJu7JmfRFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401297; c=relaxed/simple;
	bh=JSrFjAm2X9O7/FnmG4/kYtbZnibi5Bf18Pm4QJXz7sI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KTSB4MHQMkMahRy6NNKk+vtrjwWRGsSqJ7uP+3UOuXT48l1kuMwm4xlThdyUueAQ6Slt26P4g97bdnoRgGI9h2FWqvN/2yqll5Dre0EYC+szS0jFcLP4gNfSs3ry8e7zXsHBObbPbXQyeJVn3eNr+qMYHn6LTuOAN9B7xC3hFtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j0qGRv2n; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c261fb38so9282025a91.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 09:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763401295; x=1764006095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pqUWVJBl+gE0Et3dBiQwwEVGgXHkUnd572mRvHvD8ig=;
        b=j0qGRv2nZvISyQlTcr+qW4YecFodP7k9eXItK9c8C5syata3d2X+pdBFgskPfvuA4M
         wjw1DRK9azY+g5KQ/QpnDuJEI+FMucGjoSqyRi6UJ0MtQ6v5dttjX7p1mW5c2Q1DSip8
         gYKRCUUalfJhYNHJ55t4eyHDLMd/3As4zFoBQcXhuSDsZ6hQE80MUrxziOjlwwGLK3G/
         hernB7Sno8d5frsTJZMA3kZLXDEXYqZcUCTnn7b2lhLbfr/ImaGgiDgI7+OptJiCtDcH
         MmmyvXzajHf1Lrs3sGj9Sf1naimC1yGbIhGr7n4zgADT/zvbDlhXt1jNaaQTFIoqmpj2
         BaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401295; x=1764006095;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pqUWVJBl+gE0Et3dBiQwwEVGgXHkUnd572mRvHvD8ig=;
        b=bpd009iyFEha+SzT+HYWPD67JmWNTQfE2LfnGGCSmAcXeXf0scwYh37r67b2+NsxM5
         WdE7eOBIPtgr6B0UurRuVZQzAn9DbIhdBFFboyeJK+qsAHBclVCeZMONUnqdV95w3F9N
         rfLjJUZqWX2r9FWB42p69yj5eefKTU4MED2ytPIcKYAGJR0bRxkFtVh/onivDJ7zhRpl
         c46fDvF2w2VXBTsF8KcCTRJifW5b129+PWInDkE6O+9dx4p08qIZBvac3AWF34C7d3lt
         JwnnO+eYMdeRSZBOyzowFt3rha2aBeCSzjuyl9Lu1GTj3R5Gt5sSZ0ezSQjdxH9J1J0x
         wtwg==
X-Forwarded-Encrypted: i=1; AJvYcCXuHaczOTVf+iitelEGbr4SpEQl0d+6yNwpafAwMV6hLLRcJ1qyiVHacNhxTIwZY8yjcws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv382Dd+RMtSppOIQCzI9PtGae2Za6jIQNdnjMbgERO4STMy/j
	f53OJv5rbP+1FI99xDnbwJGgDbJlJGIh5WEN3owwhM+4zWPTnjNoAHfiZ39ZlGSxevbM8Bvmb73
	yNZFLVQ==
X-Google-Smtp-Source: AGHT+IEcsmUH9PIRUNHE9sQ8kqw6dSSkzaQkcJNKGEB2A+vOVIa43Yxot3SgVI3qTcVWr1fNTDoMmFy+nQU=
X-Received: from pjvc17.prod.google.com ([2002:a17:90a:d911:b0:341:7640:eb1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:586d:b0:340:e4fb:130b
 with SMTP id 98e67ed59e1d1-343f9eb6167mr13840284a91.14.1763401295493; Mon, 17
 Nov 2025 09:41:35 -0800 (PST)
Date: Mon, 17 Nov 2025 09:41:33 -0800
In-Reply-To: <E413E048-EA97-4386-8A88-B9552A823AE3@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250916172247.610021-1-jon@nutanix.com> <aRTZ4oqqIqDlMS6d@google.com>
 <E413E048-EA97-4386-8A88-B9552A823AE3@nutanix.com>
Message-ID: <aRteTRY2Z5Z3fL51@google.com>
Subject: Re: [kvm-unit-tests PATCH 00/17] x86/vmx: align with Linux kernel VMX definitions
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025, Jon Kohler wrote:
> > On Nov 12, 2025, at 2:02=E2=80=AFPM, Sean Christopherson <seanjc@google=
.com> wrote:
> > On Tue, Sep 16, 2025, Jon Kohler wrote:
> >> This series modernizes VMX definitions to align with the canonical one=
s
> >> within Linux kernel source. Currently, kvm-unit-tests uses custom VMX
> >> constant definitions that have grown organically and have diverged fro=
m
> >> the kernel, increasing the overhead to grok from one code base to
> >> another.
> >>=20
> >> This alignment provides several benefits:
> >> - Reduces maintenance overhead by using authoritative definitions
> >> - Eliminates potential bugs from definition mismatches
> >> - Makes the test suite more consistent with kernel code
> >> - Simplifies future updates when new VMX features are added
> >>=20
> >> Given the lines touched, I've broken this up into two groups within th=
e
> >> series:
> >>=20
> >> Group 1: Import various headers from Linux kernel 6.16 (P01-04)
> >=20
> > Hrm.  I'm definitely in favor of aligning names, and not opposed to pul=
ling
> > information from the kernel, but I don't think I like the idea of doing=
 a straight
> > copy+paste.  The arch/x86/include/asm/vmxfeatures.h insanity in particu=
lar is pure
> > overhead/noise in KUT.  E.g. the layer of indirection to find out the b=
it number is
> > _really_ annoying, and the shifting done for VMFUNC is downright gross,=
 but at
> > least in the kernel we get pretty printing in /proc/cpuinfo.
> >=20
> > Similarly, I don't want to pull in trapnr.h verbatim, because KVM alrea=
dy provides
> > <nr>_VECTOR in a uapi header, and I strongly prefer the <nr>_VECTOR mac=
ros
> > ("trap" is very misleading when considering fault-like vs. trap-like ex=
ceptions).
> >=20
> > This is also a good opportunity to align the third player: KVM selftest=
s.  Which
> > kinda sorta copy the kernel headers, but with stale and annoying differ=
ences.
> >=20
> > Lastly, if we're going to pull from the kernel, ideally we would have a=
 script to
> > semi-automate updating the KUT side of things.
> >=20
> > So, I think/hope we can kill a bunch of birds at once by creating a scr=
ipt to
> > parse the kernel's vmxfeatures.h, vmx.h, trapnr.h, msr-index.h (to repl=
ace lib/x86/msr.h),
> > and generate the pieces we want.  And if we do that for KVM selftests, =
then we
> > can commit the script to the kernel repo, i.e. we can make it the kerne=
l's
> > responsibility to keep the script up-to-date, e.g. if there's a big ren=
ame or
> > something.
>=20
> Thanks, Sean - Happy to take a swing at if you don=E2=80=99t already have=
 something
> cooked up to magic that into existence. Any chance any other subsystems d=
o
> something similar? Want to make sure we don=E2=80=99t re-invent the wheel=
 if so.

AFAIK, there's no prior art.  :-/

People do have scripts to manage headers, but they're for simple use cases =
of
copying kernel headers elsewhere.

