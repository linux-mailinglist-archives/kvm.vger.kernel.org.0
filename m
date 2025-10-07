Return-Path: <kvm+bounces-59588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8ADDBC222F
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6519819A5391
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78CEC2E62C7;
	Tue,  7 Oct 2025 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b8pT/Jky"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406532DAFC1
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759855259; cv=none; b=WoRKbCvhmeOcpaMh2jdoh32on87ndR3aCD57S7eG/40vJfdFBiJTJmB8H+lNDJVS+fce7DBpMLdB5WHdrSI/JKn2sefgRDdTASsTYijJAoAPhe9Y2VkJ+Uy4pPGoQ8JKEFMuQCXj2m91QZRb76Y7m2Pl8B5i8DVIkTFWPnJwD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759855259; c=relaxed/simple;
	bh=gGseg6S2na5huycdWiv/gSRtsXIxHoJvyekwjBUlu8Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dJuVxaeeSfUPeLL6lApS31CdNoowfKl2jbcrhhrowI7rZenmQJkYKsgsOpa3dQZsR1gVc40tK0JNQ2spwqAV+wczTq2iaF0Mu+cXgYlGiiy0APQryarQs3Pxa7NyJFv6ikgjlwcZglPS7EBdPTTAYbt8UP4R4dfR50QW5p+JrDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b8pT/Jky; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b630753cc38so4157494a12.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 09:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759855257; x=1760460057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoBAQi7/iDgrxmceyXloAA7pXpj9vi7ah0opPUSIfJI=;
        b=b8pT/JkySShJ9O78LXQgBYhopF3QPTekfWoPGhofMGAvlcLCaZ0wvZ+8ccerXsflss
         CQax8vU+jAwfqdXAijOdAqxVe6h5kITj7P4JexxbGvLH3+n12zfTRrs7H4DRMj46F/So
         1a8cRhHVM1Baq362M9YsRTM9POwKjJA/xnuFaHW11u0t0wedrI+u7Gy5cFcBDSq/OxyG
         1X91BQZhMSgRAWo3Zv9H2TpoVW+hEeV/5AfT5oIh2AV8gF4my3rgJ5lDgNLlh45mJLqL
         7zKft4O8gdt/ZWraG/8TQiHbAZEkklWSdLGzhCpC2tZmchRqyShqqNn1h/uIkGZdWR3b
         kM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759855257; x=1760460057;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YoBAQi7/iDgrxmceyXloAA7pXpj9vi7ah0opPUSIfJI=;
        b=CEv8edcR1ecq0TGPbb+474ukipArxz0F60usYYVo6T+QZtSqDeiu1YXodmMse44kte
         4YsS77MDRvisRHxpAJUWYRMDH7MzkQbsumANxiD0Jbjih35senVB4Ve2Y5219EQdsC7q
         idhD/ubyXyX9ilR/GK11hws9PweQeRjbHZa9SgvZcG6t9Bin666lktG+ujnbhS4ZUuGH
         5UNUC0askyj23Dr5oPytaybWfgAPpEZ+QeGq0KbzaNN7xaOkr5yfmwUAmRFAle0pSA6K
         1dpl8imHXKU3z78RLwS1SeXmq0CexG0rLn09BaohBnCqP1MFqjCIjwcJjiFMPg9nxnTz
         BVng==
X-Forwarded-Encrypted: i=1; AJvYcCXO5gFqhUTJ7hlZz7A3my9jak2enMb7hnjrTL8VeBf1/PCyhoOeXKFBNptuUgRfpYB2qcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLSsLwHMs3Cz2D95up4WIQ4Jp2XdUsSP81qRQhph5mnlKqHneX
	KeBoQO/fNe8kbN00K3D2u9PGDtTQsSnvPiXOhPD/2odNXLwm88iAc0ugZBqTSuQFiqPGetCT2DJ
	D/l20IQ==
X-Google-Smtp-Source: AGHT+IHArrUZ80t/eXJZKroHHqkbiALvVHQS5BBBYEYiCZs7tGJ4Cghzk8R/zMpAhn4GHHOEFd8u4hse3Ng=
X-Received: from pjbos15.prod.google.com ([2002:a17:90b:1ccf:b0:32e:b34b:92e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350e:b0:329:ca48:7090
 with SMTP id 98e67ed59e1d1-33b513ebc36mr139267a91.37.1759855257571; Tue, 07
 Oct 2025 09:40:57 -0700 (PDT)
Date: Tue, 7 Oct 2025 09:40:56 -0700
In-Reply-To: <CALzav=c0Wgcc60_dGJuYffS3f3vD9mpdSjFguaE00L1Zr-YcbA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724213130.3374922-1-dmatlack@google.com> <CALzav=c0Wgcc60_dGJuYffS3f3vD9mpdSjFguaE00L1Zr-YcbA@mail.gmail.com>
Message-ID: <aOVCmIu0Dv7vJ0M5@google.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Use $(SRCARCH) and share
 definition with top-level Makefile
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025, David Matlack wrote:
> On Thu, Jul 24, 2025 at 2:31=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > This series switches the KVM selftests Makefile to use $(SRCARCH)
> > instead of $(ARCH) to fix a build issue when ARCH=3Dx86_64 is specified=
 on
> > the command line.
> >
> > v1: https://lore.kernel.org/kvm/20250430224720.1882145-1-dmatlack@googl=
e.com/
> >  - Split out the revert of commit 9af04539d474 ("KVM: selftests:
> >    Override ARCH for x86_64 instead of using ARCH_DIR") from the rename
> >    to SRCARCH
> >
> > David Matlack (2):
> >   Revert "KVM: selftests: Override ARCH for x86_64 instead of using
> >     ARCH_DIR"
> >   KVM: selftests: Rename $(ARCH_DIR) to $(SRCARCH)
>=20
> Gentle ping. Paolo and Sean do you think this could get merged
> upstream at some point?
>=20
> Google's kernel build tools unconditionally set ARCH=3Dx86_64 when
> building selftests, which causes the KVM selftests to fail to build.

I'm pretty sure we can simply override the user.  Does this fix things on y=
our
end?

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index d9fffe06d3ea..f2b223072b62 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -6,7 +6,7 @@ ARCH            ?=3D $(SUBARCH)
 ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64 loongarch))
 # Top-level selftests allows ARCH=3Dx86_64 :-(
 ifeq ($(ARCH),x86_64)
-       ARCH :=3D x86
+       override ARCH :=3D x86
 endif
 include Makefile.kvm
 else

