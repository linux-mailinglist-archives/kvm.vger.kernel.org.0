Return-Path: <kvm+bounces-24550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE039574AC
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 21:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 380F0283FBF
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 19:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EFA1DC48F;
	Mon, 19 Aug 2024 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kyg//etU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489201DC47F
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 19:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724096655; cv=none; b=Inx7Kdn7FakA3BSGMpN9CEPBlduC4qPT6PhzdkEIyzLK6PNBjAM/C1HGou4vGH0laWVbqywpwlWwXtMbU8omDP/0/cU/GTgOP6F3f3/afb167DLMqb99tGVG/4ddjpmHgdOi/V5LNtJpLLMrOIcOC+0X0LHd8n9/pjrzCbTma3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724096655; c=relaxed/simple;
	bh=w83ocErDZIzCw8c8O7vL+g1+VP5ZM2OU81Qz7bqaBRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iugCILvFOhDOBGL7M8EgsMWUlonfe9q0OX9h+rGzVNrmG/OzdYr+qRIHsty6H+AMRgvrGG6KNYskx45ujchyoZX86YSWH41g+pPSAe3fKul9TeX3T1JnKyNmofQcF9hqUJqc1pf2GEvoyhrHzyBBFetIG7pkzQ1L7VLCx0Sg+iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kyg//etU; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-530d0882370so4878423e87.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 12:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724096652; x=1724701452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDiz02fpJ0BHDvVXU18To+N8ajErks/Wn/P49vHS5RA=;
        b=Kyg//etUfl0pXEFI1K5vRdrvtTNHadCSLXJdcUhGYYklIkB3SEOX27TfADQDnjqA31
         2F1OSgLeTj6+o0oP1pQ5/o5ejkhHZn/84gGwE5lVGIMaaBfDGm+UmLV5sl/ThQbcfWBj
         sZtjiWZnsZKFm7wLZo1NjrCmKiSzF5tb9xct9I3jjiEJB1KRT/lJsibZg3ZXEv8ZXGzk
         f3OnplQE7LS2ec0qLtp/7UNc9c+5L6w7tOJYA275+5HBOqi5ax5ECZMA9Gg3GMZw39GM
         W7dK+5JXiyjPIq4Koxt0cFwKdz+HfEYHBrYDpoqLm8TBHrWlj9Zk4NYE0m86/x+gzHUx
         dSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724096652; x=1724701452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sDiz02fpJ0BHDvVXU18To+N8ajErks/Wn/P49vHS5RA=;
        b=iJ93iYejpNVfzdyL/+iaWcmmRzur7kSBT7QGp8+sMqZPbkuIfrR/Dofo4Vs6609y5v
         CXZya0npitXNT3AWQ1ka6Pyd92uvl0X7gSb5dP/lt8P2AiCdvWOL2WOf1ou3+J7v2X3r
         Irj4UNhfhCLifPNRuMIIFG8Jzp9veUSr28+kwA0ZTG2R7+KkqKCXmCHUmFGnF/6ZCqoO
         h0akgwaFbbVClEJWYoU8F/DbaZOom7yiETCnbWJNuXIG5sRpPlvB+WTLwJBZWy6LK0Ne
         Qqdk/biUrCxjQhk1mG5doc0ZgjtqqiQUq1ASI7nQWv5rbt8oZTu7gsWWNy/YZ1Ncxm9s
         DU8g==
X-Gm-Message-State: AOJu0YzY2ib7KcEP/ZMpoI1MdeQnshQfSCUWSVsegW70YxB/Drqwn96i
	4geIVhdzd1dEyfEYXOjV6ktXpq0Us/sfhxSqA+/8RhsxEq8BvnqMeKfk7JjeGvLxd48eCjyLY3g
	sYEooVUg6LadtyITsRgwCAhidYJ0NO7zs0MuG
X-Google-Smtp-Source: AGHT+IG1BaOgHVZEdvbKaXGctP//pb7CyT3HJWWrHjhhlPOcCZVibicxUbUt9KdvzqmsEwfys0s9oPhOXTmbq0LTH3Q=
X-Received: by 2002:a05:6512:33d5:b0:530:e228:276f with SMTP id
 2adb3069b0e04-5331c6ba93dmr8709338e87.36.1724096652012; Mon, 19 Aug 2024
 12:44:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816192310.117456-1-pratikrajesh.sampat@amd.com>
In-Reply-To: <20240816192310.117456-1-pratikrajesh.sampat@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Mon, 19 Aug 2024 13:43:59 -0600
Message-ID: <CAMkAt6o1KZH=fTWWOoPf+Z0j12xUYrbqj=Qob4E1LxJBtivo4w@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] SEV Kernel Selftests
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 1:23=E2=80=AFPM Pratik R. Sampat
<pratikrajesh.sampat@amd.com> wrote:
>
> This series primarily introduces SEV-SNP test for the kernel selftest
> framework. It tests boot, ioctl, pre fault, and fallocate in various
> combinations to exercise both positive and negative launch flow paths.
>
> Patch 1 - Adds a wrapper for the ioctl calls that decouple ioctl and
> asserts which enables the use of negative test cases. No functional
> change intended.
> Patch 2 - Extend the sev smoke tests to use the SNP specific ioctl
> calls and sets up memory to boot a SNP guest VM
> Patch 3 - Adds SNP to shutdown testing
> Patch 4, 5 - Tests the ioctl path for SEV, SEV-ES and SNP
> Patch 6 - Adds support for SNP in KVM_SEV_INIT2 tests
> Patch 7,8,9 - Enable Prefault tests for SEV, SEV-ES and SNP
>
> The patchset is rebased on top of kvm/queue and and over the
> "KVM: selftests: Add SEV-ES shutdown test" patch.
> https://lore.kernel.org/kvm/20240709182936.146487-1-pgonda@google.com/
>
> v2:
> 1. Add SMT parsing check to populate SNP policy flags
> 2. Extend Peter Gonda's shutdown test to include SNP

Thanks for this.

> 3. Introduce new tests for prefault which include exercising prefault,
>    fallocate, hole-punch in various combinations.
> 4. Decouple ioctl patch reworked to introduce private variants of the
>    the functions that call into the ioctl. Also reordered the patch for
>    it to arrive first so that new APIs are not written right after
>    their introduction.
> 5. General cleanups - adding comments, avoiding local booleans, better
>    error message. Suggestions incorporated from Peter, Tom, and Sean.
>

Tested the entire series

Tested-by: Peter Gonda <pgonda@google.com>

