Return-Path: <kvm+bounces-43673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1276FA93C5A
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 19:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F13E4A1200
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 17:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363E521CC62;
	Fri, 18 Apr 2025 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yPnsI8AF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1166A21A92F
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744998704; cv=none; b=hIblCVglyZdNj1xRjIBCqb5YQU4fnhwfhLMrFmiLsyLArfu9RYiloSxRi4dA8jW3sh1gcbbWQO9idBWTsp8a0s7zFUuXCdGmluVsaeNLb0TqpuPGRzSXh7w+gnsRWP0sPqJanLuqI4SvwvZBmGQfhHF8kXzK3I03X7uJfW/IobI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744998704; c=relaxed/simple;
	bh=6W+OGcFxI1DS0aqJG6ibEBuiROo06ExhWAkrujlWANU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=umQlBpdC4McbpxnDV3B0jAnQ0KOVVohjfb+UxQFKB34UWUD2VPB1b1EAjQiHwGmPSsLJwWVC702LQU96YnHe8S05DLgaVmZpj1fztygmL9+jkfEbP/nc85j2ITfPQwOfDtxloFvz6B0Vf7frVBefW4u84S10Bsod5T9rOZ3EqnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yPnsI8AF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736d30d2570so1742763b3a.1
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 10:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744998702; x=1745603502; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zYnYOmTALuTZaDDp7zB0k1mzpNniYAqzF9fCSP3qhAw=;
        b=yPnsI8AFLa1qOl+77HU+Q5eKdDtwiDzGSivmx4766ByjDikV0lPppXlRNfRqE6inbp
         hzzeCEaPqTY6TXZ2KON5T6Qer7n7JRHTkq2PGvBKAN5aAWNo2L39ZmSbti/s7qbpawOW
         TbVsDl6RMSFRoalx/uoJzS27rdlIFnAH3awL9weG9FIy1u5XpfEpfnw4aZaaImRG6Dvm
         mVcdCWS6143Kogv+ENklWj94kSLCtEd3ffpBPf67fehEU+4l960oxCy/G4DOjHw8votE
         rEcdlr5jFrdGk//g79hMkzIDonS3Eg2U7m4w/dIQblOsWhswolOYkEheDYnZTnGTXhU0
         o7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744998702; x=1745603502;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zYnYOmTALuTZaDDp7zB0k1mzpNniYAqzF9fCSP3qhAw=;
        b=GULnOw2zv2eFvnnzziEJhmxtBfVj0zU8sdAflWkcaV2i0fn+rh/TsMn5uVXg3vyWOY
         G/obUF3ajZ7VLoHXrSSOFumrlM4a3i+jFL9dSeCcrXlXaV14mQe5z6owfQ+K2ewXYgIf
         XvOMozoS6R+izMPKpYk/B7q17pJXKegY2RRppziCKilsFyqNUQpzZs9VO63LQrmJsWRs
         Tgv79Tt24qm99yZudlc3GL+E2zQHVrKxetDVEZRoIBIAQNjdE1lhdk30vGMk62k8+5Kr
         302f9F9DkXmAv8HcurI7HHOfLkeGyM+Rr2cJHwqCBdIXpkbuVo1+9wUcBkjfPni9Z/Ob
         orNg==
X-Forwarded-Encrypted: i=1; AJvYcCVww1GJcPw8c3s3G6Bq/Ujku4Cgl7pmfQP7tk88nsXrwZkT3XFAkgwC6YI7JTtuDtHJ0lc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybr3eL+qy+hnmZd9kDoZBv1QqxMXE4Ute+qPVuU1w4Y130kIkp
	7SJFXSnOrSAF8t9l3q9cPdjPekzbr1hlDSLzIU2NJSip34cbz81yWyUchtWoutwXPoTBMgo2kCw
	FPg==
X-Google-Smtp-Source: AGHT+IEjytYkIRTk2QN3rHgDKBDCYzzDu9yiVMpU9uRWqwQWvZ1b3SNQlrgoBUpZQvtRiqohVDHw7aYasHE=
X-Received: from pfbkx23.prod.google.com ([2002:a05:6a00:6f17:b0:730:848d:a5a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4409:b0:732:535d:bb55
 with SMTP id d2e1a72fcca58-73dc147bd25mr4766073b3a.4.1744998702381; Fri, 18
 Apr 2025 10:51:42 -0700 (PDT)
Date: Fri, 18 Apr 2025 10:51:40 -0700
In-Reply-To: <CABgObfYzbWspmaEsvSZYkBr1UQ7C5rD0NQ+=UsnSU3OG5tkcDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250418130644.227320-1-pbonzini@redhat.com> <CAHk-=wg8VBjy=yrDUmFnvBKdo6eKNab6C=+FNjNZhX=z25QBpw@mail.gmail.com>
 <CABgObfYzbWspmaEsvSZYkBr1UQ7C5rD0NQ+=UsnSU3OG5tkcDQ@mail.gmail.com>
Message-ID: <aAKRLEiiy9pyHcKB@google.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.15-rc3
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025, Paolo Bonzini wrote:
> On Fri, Apr 18, 2025 at 6:13=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, 18 Apr 2025 at 06:06, Paolo Bonzini <pbonzini@redhat.com> wrote=
:
> > >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> >
> > I pulled this, but then I unpulled it, because this doesn't work for
> > me AT ALL. I get
> >
> >    ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko]
> > undefined!
> >
> > when building it. I assume it's due to the change in commit
> > 73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is
> > disabled") but didn't check any closer.
>=20
> Yep.
>=20
> > I think it's literally just because that symbol isn't exported, but I
> > also suspect that the *right* fix is to make that function be an
> > inline function that doesn't *need* to be exported.
>=20
> Yes, that's possible since enable_apicv is already exported. Sorry for
> the screwup.

FWIW, the fixes here came from a big series that was dependent on a much (m=
uch)
smaller series that did export kvm_arch_has_irq_bypass(), and that got miss=
ed
when these fixes were grabbed early.

But I agree that inlining the thing is a better solution.

https://lore.kernel.org/all/20250401161804.842968-2-seanjc@google.com

