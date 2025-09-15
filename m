Return-Path: <kvm+bounces-57609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79FBBB58428
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B43C57ACB61
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FBE2BD016;
	Mon, 15 Sep 2025 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IswcfCo/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2621627442
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757959061; cv=none; b=YG4q540dNeRJBwAKKW9Fe89mqlzInaQINoiD10P6zPTWJtMVkPyn0fXb1pjHz6n/asxR8mo1IGMVURpGBRF66XFEQUDZ7fjR7O3rzsyMS68Ooxhl+fQWKhPym75rkh3+l/FwkJavtOJ2IQW3MtWDBtUVxP7ToeUrjgDI7yjKC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757959061; c=relaxed/simple;
	bh=e8KM16YH2muI1EfRuct8dQc9N+MXODzWZiWrNVYNekw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxCq5Q2iZY0R3v3oaehheuKsGR8xpzDzaDG/0RjThJV34uLhESaKoWtY2rS5U5CQyw/igHC9BTi1lIvaIMbQancWtgdWY69VxPG+9cjIWuVD3AsDj93C27ldJl8PQ9oJ5ehcgVOcQme7gfoCjxyQrFRBY6jj5SgqqVPyKaDfPN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IswcfCo/; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55f6f434c96so5079529e87.2
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 10:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757959058; x=1758563858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4g5EqZH2g7Gd2bpnH6sjBqOWSmyCjDfXt5XJiq7SJuE=;
        b=IswcfCo/5CP2HoqUHgUpBMfRNWCla+5spKh19BH7FfTlpBrc0kpWxtDWO0rq/sz6kK
         J8tjHU4BSBf5R+tDsPKDN78slYuq9d+kkQA/YbzurxTVU6dnipLQrfLtq5JJn219pabp
         ZtMDzuRfbJiL226330u9AwJJqoOI6xbUjebeS+6ewulpslXmvPqbNEvmtTZNxkqutEN6
         wkSXTqi6FBHzipEQ9MVBP5638i8lLppqOh6pQbi/2KT6zg7FjxWLztY7PPJ0w8toyXd4
         w6xFz9i/f8hckAi4TqanjKNspi1YGEGHaSka4t/IHpgrTqN+7IUwV1h2zVhtmVDXfnIa
         6xVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757959058; x=1758563858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4g5EqZH2g7Gd2bpnH6sjBqOWSmyCjDfXt5XJiq7SJuE=;
        b=RzbE0OzGddMnZB+U4CtZq5/6bwgDeKrMPVdJmPScaOce1/1jTOcG/NCJx+I+KnzWqi
         hndZzVXrlTpE1vf2pidTobfZIRUGLF/YAuI+1xZApHfK9AjZowvf8u7c89RUzSmmu1Ra
         /XvtJ9EPgr7/jMwjS0L5rannQQdRCeGbUSdvL/oRwKCZAqK3KAoEFr/9Zt97DReX1hKE
         8we4BK8DeiztYAJXIEv6Dh0zuyxP6jClDIBJgmwiWwtx26KJW4QkU93M8O0WjqrIcEw7
         gJ9868ThyyH+KsS23a7Hdz4U7HXyPoz67j/cH9/ABcKQhtgnulsTcgwAuyBgFbKqsmji
         4CHA==
X-Forwarded-Encrypted: i=1; AJvYcCXHWm1JxugbLTCvdiPjtqVBih3aQkbJEgULVsHdb5q2YYZFFc7lhXP5SKPWQ/804nr3Thk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyXYOHvxX78lUGf63Ot0YytNlZScNwGqlNRnHSzq0Wz/dDWF3O
	3CmNHiBiT1Ecffm9pDIwqmlSdq27B2YPNKwvTzLO8OHmwK8bF2Gv3Mp3RXYic4JUsT/br2qfHPo
	SB4IsOfRuBfZ4BMUlezV/49Qqcn9UEeaZlUBrhq/n
X-Gm-Gg: ASbGncueSGBmNAuis1MLy8fuPVbVoiBPuuDlPAM3fUQ8GicdzLvQljsZGaFTl4SAzPo
	8I6KxGaiNd3MAReugtO0TJ8olrHcPQOo5e2tsm3CD3dxt86YXS4iiyfdGut+JbXLK300ZWWxmvu
	sGbG3wby9pHdOxKRFn5s+1WIvvStEN8XT9oEaxWvA4xQUS4enSU48PVT37MSwq8J+orHrzCluob
	c0J/PVDEooYjA==
X-Google-Smtp-Source: AGHT+IG7XuBOUF99pOsMzTEmuY+onO9zVaYoMU8lx7aRfbHGZI3ou7Ry7xA6KJQtNMG/3bvg8VLvzDwKkW7TyUfprHM=
X-Received: by 2002:a05:651c:2112:b0:336:80e3:b1aa with SMTP id
 38308e7fff4ca-35140ba5748mr38215271fa.40.1757959057855; Mon, 15 Sep 2025
 10:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724213130.3374922-1-dmatlack@google.com>
In-Reply-To: <20250724213130.3374922-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 15 Sep 2025 10:57:10 -0700
X-Gm-Features: Ac12FXz0ngQllsFkcY9Lb9qtH-WfMt8gI_Pux-WPgE-EKqIoqUpZI15M5XAT0NU
Message-ID: <CALzav=c0Wgcc60_dGJuYffS3f3vD9mpdSjFguaE00L1Zr-YcbA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Use $(SRCARCH) and share
 definition with top-level Makefile
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 2:31=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> This series switches the KVM selftests Makefile to use $(SRCARCH)
> instead of $(ARCH) to fix a build issue when ARCH=3Dx86_64 is specified o=
n
> the command line.
>
> v1: https://lore.kernel.org/kvm/20250430224720.1882145-1-dmatlack@google.=
com/
>  - Split out the revert of commit 9af04539d474 ("KVM: selftests:
>    Override ARCH for x86_64 instead of using ARCH_DIR") from the rename
>    to SRCARCH
>
> David Matlack (2):
>   Revert "KVM: selftests: Override ARCH for x86_64 instead of using
>     ARCH_DIR"
>   KVM: selftests: Rename $(ARCH_DIR) to $(SRCARCH)

Gentle ping. Paolo and Sean do you think this could get merged
upstream at some point?

Google's kernel build tools unconditionally set ARCH=3Dx86_64 when
building selftests, which causes the KVM selftests to fail to build.

