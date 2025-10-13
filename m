Return-Path: <kvm+bounces-59953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FCABD6BDE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F9E718A817A
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7EC2BEFE3;
	Mon, 13 Oct 2025 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mrfvr61U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC412E1E9
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398245; cv=none; b=A81iMAvk9EO3ex37ABZ/BNscISrlRCmRDh7HGpBbbUBnjcN3noKO66n10kGZawcDkxq/FalabBqMMInciu+rwcIZ1B6Hc+dbAAA57UNxvs2a5N7UU80NicUiy6NDdX0DCxFvYnQJUehGON4tgKmnMOGsF1X7Pub79dDwheImW9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398245; c=relaxed/simple;
	bh=f1t956JBV+YwJMh+YwrrZfOciYvg7blVAnIMvPKNYWY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6k8655Vs6VHNTsdzSwYQRAggJmD1z8D/WpVTLaLRAFF2g6oreNsUkUTZtTBQvopYaeqzmwlG9e3JocX1BwdNgUFJScHN8VJM0yfogDvEBAzkcyY7tDJjVT4b7DjbgW6Cqm/5u3RFKqNoL9DzNFi7fhs+Xq22mVrukRQJ5xxZS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mrfvr61U; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befb83so11771885a91.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760398244; x=1761003044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=08aB01K3QlDxNQ6Di+ZC0Fy9ecw0hHQXKJJoqFOXoow=;
        b=mrfvr61Ugf4rpjGO8UXGuha8lRWdgkY/sLtMnr78KwaMUOdM6uKKzGfzesQl8+iPBq
         EtQHDsofTHP1JyBmqv6alF/edo4ODjyB9lipAMXSINBvUKBEZ+h6jgfNyF4my5fladVC
         quiE6ipsSnyfeEDyqPqTsGpkmvZg2wRpLtPy6hX9GPyK/2hrA128SeddJ0o5ER28d1VU
         CnjIwzyhCVd2aX32rcwjdLqZ7ah8e5pCR6WT/0LApLOAQj0DICy1mwXoYq+lTDR0Qd7Z
         JYX+ewFLTz/Mp4YF+8gU5EB9nFVWrMkzdt1/Ov+rTgjxnb7u1lEtcW08LGSdEM/dD8wZ
         B6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760398244; x=1761003044;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=08aB01K3QlDxNQ6Di+ZC0Fy9ecw0hHQXKJJoqFOXoow=;
        b=k7LdqBQbeNAg4D1BeARm907YYZj+oeiq98eiWa1dZaBPQ193Z+r2DtvqnDReeVS6eC
         Hc0g9Vex2qO/VpiCpwliFhAZ8V0+0KviEhcuw3dXIfQMO91/dRd0tt+xsu6kvJ1/7yKb
         24qyaanQ930iTx8DqOklMjABNAEHo7OUKX1Het+RuKOa2HRbGxqYXuwzHkI0oDDwvx/l
         y2F2ISelj1TkGj7ECkS4DyKBWsvWYVwsd+mPhfnO3p3Hu3RFUID+eOSZkx8t0iXUycUA
         0vB+agnUp9J2VNMCyZe3Fc7Pg3z+BqcUE5QxLTHI0cnNqTaAaoytXeh9nvBSYbQwaopV
         jaMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLjTunihBpY5KnWgRBB5Ftjo9036AfGc8nQkZsB5qGcZO/etHXz+7iQH3ORfKtKDYbFb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxcrVh7QZ4W+iMZ+p/T9zdiKA8nJVRzL0YJ+bws/c/7qmNh0vi
	eVrAFG6Kkra56VRB7QkgQYQxEKoHhMhc+ccCw9P3llV5Ns7hPsAquH5G2rGPEGRhPJfMqiGHRQn
	aww926w==
X-Google-Smtp-Source: AGHT+IHs68Jiesyq8CVwopkosF1NFYrZ8tVJ5yK1fRCuny9H+M0GlqQ+GEI/HXfswBxaNk8YEghSh7Wv9pM=
X-Received: from pjbgl20.prod.google.com ([2002:a17:90b:1214:b0:330:acc9:302c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a87:b0:339:f09b:d36f
 with SMTP id 98e67ed59e1d1-33b513a1e0fmr28253894a91.28.1760398243550; Mon, 13
 Oct 2025 16:30:43 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:30:42 -0700
In-Reply-To: <CALMp9eQN9b-EkysBHDj127p2s4m9jnicjMd+9GKWdFfaxBToQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250922162935.621409-1-jmattson@google.com> <aO11A4mzwqLzeXN9@google.com>
 <CALMp9eQN9b-EkysBHDj127p2s4m9jnicjMd+9GKWdFfaxBToQg@mail.gmail.com>
Message-ID: <aO2LomPuqvvRF5l-@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Aggressively clear vmcb02 clean bits
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025, Jim Mattson wrote:
> On Mon, Oct 13, 2025 at 2:54=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Sep 22, 2025, Jim Mattson wrote:
> > > It is unlikely that L1 will toggle the MSR intercept bit in vmcb02,
> > > or that L1 will change its own IA32_PAT MSR. However, if it does,
> > > the affected fields in vmcb02 should not be marked clean.
> > >
> > > An alternative approach would be to implement a set of mutators for
> > > vmcb02 fields, and to clear the associated clean bit whenever a field
> > > is modified.
> >
> > Any reason not to tag these for stable@?  I can't think of any meaningf=
ul
> > downsides, so erring on the side of caution seems prudent.
>=20
> SGTM. Do you want a new version?

Good gravy, no.  :-)

