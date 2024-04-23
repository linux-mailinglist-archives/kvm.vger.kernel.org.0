Return-Path: <kvm+bounces-15732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDD68AFC6A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 01:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8058DB23F0A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 23:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948683D3BD;
	Tue, 23 Apr 2024 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oYav0RG9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77E2E85E
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 23:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713913671; cv=none; b=RrH7KHQwnJcLvadqriiE1isadtjPCrFpiiT+j9jb5jNcxjBfs7sl8/0fuS3/NjopSlokl1DbZUVJ6Vo64mjUMGuoxV6Nfe0MokvME3KsAV6IkqNckNjbsPk6cT2w47Lw2hluOBzpFIyLYiESGk+jzuMT/niGgwBEcmoR0unPDMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713913671; c=relaxed/simple;
	bh=MSNOE7gPgC9Ud0f301TpFHsZv/rQ4tE4+iv+cPiWSf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NmoY1zba7t7f94SSZ1zQz3NwV49uXzAljbi0DUV2Cvqx7QE0hJ89DV4xGrwaqk3FrMwlZoBW/ZtlK0Z0ZHfQvCcSBCWY0r2Jw4oHG1TurIzR+AZH0cRwcmNpkcbQcU1Nc9L9wAfRvgeRGj/oq6ZNOc6LZkrs/eU6khljoC9SdkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oYav0RG9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so8898538276.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 16:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713913669; x=1714518469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g5GByxvwHzR1ChJVzqHhXcXNtT/rzjAkoACUPb7chQc=;
        b=oYav0RG9af/+LyP59JH2Se8lWyi0ph/PE0gJoi+WdlA9CPZj3l0Iejv6V7JZMOv4T7
         OKFClmm+pPsHUu/RcAq6naq8hGpUz5KPWZqN8ZWBCQ7TYHzqT5DVwiaLBREc7QFi/Up5
         jlhIct9HQfIOblL4qESYOm65lhkKyO6gcujbENw+KxtTFfBFX5pJ5N0XjduHnThD46m0
         OKi+ZlV4tZ/3sIKLkD1GQwqE48BOKOCaCCzI2o7lUG5RlULGJd3ZC2x7erm8A9nu6qfO
         m/oPp6AB9Nc2nYvaleChMW7uLGcUNzKJiyuYsXnEDDBgsm3D8P1NcQCC4pXoZi41OGXl
         QfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713913669; x=1714518469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g5GByxvwHzR1ChJVzqHhXcXNtT/rzjAkoACUPb7chQc=;
        b=wY106xL2RWD0hS3qiVaOm0r77yxvSiN65z1TkBL/C5ku5sBaZfiKlgelYtnmWXpmO/
         BeQioRbReBmxJQ84zZcg2xXcgiVBDsGP5odO6Ya0koTur0qDisqWaxwT4Ha/r4x4ZHnr
         xqPJM8R/rgKNYmz9/gzm8ReU9RD8CTYry8bkk4j7iqYz46exMpJNk5SRqhckgTIOioL8
         VOMjDunRoWDvQmv20y/YEGNUYg5bWs8lhMzKJmuMJhGlLcnQq081d7iQEsv8Ijm7RmeX
         1xy1lB3W0sLKfORpIO7KN25drJB0WMgSl+uMsI0+AYnb3om2znmPiWu+uVJbNTEZTWSs
         u/Xg==
X-Forwarded-Encrypted: i=1; AJvYcCV/PcVSLfkWpB0VJeU6UUTtunXCMNFlxxUW1G/CW4LxKuHEwYwwTm3Zr6WOJ0/WtHG2KDlwhfCttPRCoPjwZGtexJVx
X-Gm-Message-State: AOJu0YyX9fIZTvM3D4fdr74H1+DBrbZG2vh525/NI5muEDulHU9/q36J
	kjmD7ZntoTaXW3VLI2rS4BVy0IRBWUepY+Suaji14a9Z00Wquw+Co9KBVm5pmY34whxhK22UzKm
	FnA==
X-Google-Smtp-Source: AGHT+IEMzQ5NpZ9F7fh5S/dQMiJZwtjwYDCo8RyHNY9ZyHZEScorWkQY/Nqb5hbhSVQqm/AUDrQqxaYh3/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:706:b0:dbe:30cd:8fcb with SMTP id
 k6-20020a056902070600b00dbe30cd8fcbmr134539ybt.0.1713913669469; Tue, 23 Apr
 2024 16:07:49 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:07:47 -0700
In-Reply-To: <20240409133959.2888018-2-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240409133959.2888018-1-pgonda@google.com> <20240409133959.2888018-2-pgonda@google.com>
Message-ID: <Zig_QyOeB3I70E2Q@google.com>
Subject: Re: [PATCH 1/6] Add GHCB with setters and getters
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 09, 2024, Peter Gonda wrote:
> Move the GHCB definitions from svm.h to the tools/ copy. This allows the
> SEV-ES selftest to use GHCBs which are required for non-trival VMs to
> paravirtualize NonAutomaticExits (NAEs) when SEV-ES is enabled. GHCB
> getters/setters have a warning with address-of-packed-member, so removed
> this using the CFLAGS.

Just for paranoia, I would put the -Wno-address-of-packed-member in a separate
patch.  And to make life easier for us paranoid folks, call out that the kernel
builds with -Wno-address-of-packed-member by default for *all* architectures,
thanks to this line in scripts/Makefile.extrawarn:

  KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)

And for good reason, that's a darn stupid warning for the kernel.

