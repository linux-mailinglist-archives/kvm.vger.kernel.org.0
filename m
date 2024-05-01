Return-Path: <kvm+bounces-16338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 469EF8B8B21
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 15:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAF2B1F238FE
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131CB12EBC2;
	Wed,  1 May 2024 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z4PSvnZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B9312E1D1
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 13:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714569880; cv=none; b=IgwPqRA0tGS0MkIwbPecEL4nDCz2+4bq8b65wE8OWUNGw9UbBWMg4DhwUAW09oliwJ75sE6LYgsWqIna4EXdPnrDVAsDSnbxLS4Y1KEEnBvUlZJH0LJEnjHxYoPkcVmNm84YKfyknO7yooX3iBi7xQIydDTZcdC7pZMP3nP/Tp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714569880; c=relaxed/simple;
	bh=krrfckqjbeQlFLb67v3IVek4EQvt8apnoVfcRYoUsg8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FdaJrMpq6NmKkHaxP2OKJwo+WSx6uThUoxQuBlmnvqOBxwYMgDEZOuJnzeul9LJ9xf3XkEPXUL78OyYSSc7Ra+5R/YGyG4harsSdblhrpeLhFgpr9xZZMaLvBTO9ivaMR1fTDCRfmhLHDg5630nNGUur59aeJbuymhzomFBbhNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z4PSvnZZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso5995757a12.3
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 06:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714569878; x=1715174678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4j6TmQ6ZgTGCAdIqQxwPqCx/nTzh+QyhXiuMiXZrc1A=;
        b=z4PSvnZZow+6cwPT+0ewrIkZ1zd7BDzLa+B4BwRbWfQeul8nzOsi19rm0gzFJB29a5
         X1qrmI4UmTxNrE8laFdrt5n0s1LOcdAQUyN8KlFjksLa19gdfLjN9rdxS7rkHH6wHmSx
         Dt6vno8vuOBbKIVaNd/ZSN209Qkb/aM/VBPR0OgIPrRnR7/vkHGp68RZbNptbw41mTFa
         3d043BKnXcNsJkhd/u6ytclKWj9RxAZpUPm0bNkT0+lSbw6W9UH6MMOoIsVtz9Jxpx/l
         0NrMuyLM5KyCds8FWf26I6GWndEOa1VsaXVD1/lqiTKKSTp/prHyQE9HYEcdSmd7GLiI
         2DfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714569878; x=1715174678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4j6TmQ6ZgTGCAdIqQxwPqCx/nTzh+QyhXiuMiXZrc1A=;
        b=RaerqdTeZcoDY2Oa6SWQb/DrTNzg0NrY0MJLjORllybDq2Ya9gmn0EjqQTogEbU/Qf
         40S23/64ypr9kSuxW/rGm7S8iHcUa+p+Ka4kroAPcd8Qgt/fCNB3dkV/dxT6eSCgV/QP
         Og+VmteKwNUKeSdFdRMTbymM88djdzvDC/5xkpNm1Z0cIVa1BYWuPJmqs174zXnjbZ2X
         kG2l2labhsqr8VidCpSDQNVFYQYoa9GQddpxOU5/tHhrDJuIgFINF+8ogWjlryb24cq3
         EA+BXkGpd4fHiay3cydcaK/R7KQVTPwEWnP5E3SBU1U1GP0q4P68tNKKJ/qP8Pwf/uQS
         HAxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi8EhcapVyyMSaFv+evx5grlpN8Mn2FwtZqX41Nu64Jb8/+HGyy1MFs4KgYfA+jFWth1rKnnPyya0JI3llvNez+e7t
X-Gm-Message-State: AOJu0YxwnOovyXKHibuqdF1sI2TWVX9ReZC0a921f1a/WIjiRcdlme+S
	A/OcX1CBgZC/zHKdKY7UW1RB+UHPhPoTZ2BOTF0XRa6vnFqDehWd+/Lcj1FXqju1ZNFOOFRp9Kz
	PTw==
X-Google-Smtp-Source: AGHT+IF3937EXGaxRuC2iwKEsqWkwYndGF2ruoyJWYYFvQeb8jNS6z1A7kQ93TL3uURuwu8bhUtDSRxNorw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:b0f:b0:2b0:14bf:3f45 with SMTP id
 bf15-20020a17090b0b0f00b002b014bf3f45mr7454pjb.0.1714569878155; Wed, 01 May
 2024 06:24:38 -0700 (PDT)
Date: Wed, 1 May 2024 06:24:36 -0700
In-Reply-To: <ZjGiGq-_kUVht63m@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com> <ZjGiGq-_kUVht63m@finisterre.sirena.org.uk>
Message-ID: <ZjJClMYEIyGEo37e@google.com>
Subject: Re: [PATCH v1 00/10] Define _GNU_SOURCE for sources using
From: Sean Christopherson <seanjc@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: Edward Liaw <edliaw@google.com>, shuah@kernel.org, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Bongsu Jeon <bongsu.jeon@samsung.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@android.com, 
	linux-sound@vger.kernel.org, linux-input@vger.kernel.org, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, May 01, 2024, Mark Brown wrote:
> On Tue, Apr 30, 2024 at 11:50:09PM +0000, Edward Liaw wrote:
> > 809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
> > asprintf into kselftest_harness.h, which is a GNU extension and needs
> > _GNU_SOURCE to either be defined prior to including headers or with the
> > -D_GNU_SOURCE flag passed to the compiler.
> 
> This seems like something that should be handled centrally rather than
> having to go round and audit the users every time some update is made.

+1.

And if for some reason unilaterally defining _GNU_SOURCE in
tools/testing/selftests/lib.mk isn't an option, we should at least have
kselftest_harness.h assert instead of making a futile attempt to provide its own
definition, e.g.

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 4fd735e48ee7..6741b4f20f25 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -51,7 +51,7 @@
 #define __KSELFTEST_HARNESS_H
 
 #ifndef _GNU_SOURCE
-#define _GNU_SOURCE
+static_assert(0, "Using the kselftests harness requires building with _GNU_SOURCE");
 #endif
 #include <asm/types.h>
 #include <ctype.h>

