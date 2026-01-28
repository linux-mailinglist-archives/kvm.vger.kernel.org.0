Return-Path: <kvm+bounces-69409-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6EegMvJhemlN5gEAu9opvQ
	(envelope-from <kvm+bounces-69409-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:22:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 782CAA8226
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BA82A300827F
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57012374191;
	Wed, 28 Jan 2026 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g20JaKHk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB5E1D5CC9
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769628143; cv=pass; b=UDLH3eIFsChqK6F+edCK6CLRT6+iUOshsQOmcZgpShHCsJJHlKPL5VVOi/xiN0pIkE6VmiiQaokn+/aC6FUJKUllyqLAqptVcmV0opi4yFGK+7TGq2+0YHODqm+hLViKPqOYeUOVckV6aGpn27jOG8BvF/uR600nPwZkKU5TjbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769628143; c=relaxed/simple;
	bh=muM66N/w6WMow/K5blj/8GJE8PANhztwu4Gao3MXNL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l/jq4KYIDanT1YEijvWBsE8mfFioSg/NYHynGCcT0Sj67Cc83PCAjRxY8mX3Iqql/j2G2+wpcVvU6vSgcmHxP4YsrAzh0InbncHSAg5sK7esZXyHzQn4Rl5OVjR1TdFDcEpnjDdZi30nPnVoUgYojXsF+Kxi4yqqBynqXyIxq3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g20JaKHk; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59dcd9b89ecso267103e87.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 11:22:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769628140; cv=none;
        d=google.com; s=arc-20240605;
        b=HX5vvuL2ZGg72IDGL/uSGikzfi7AgyQ9X33KREQ8xQEAatdfQRO9yvpmhRG1zooCvs
         ClszA6MyJ3SBDN5RML/GlxI1vpkN1zq2vpnM0MIpehlMKBTgxW007zXPWkmv265MoxR0
         0yplfRFpiqT3JhjSEllf1tatS1d2yuS3sTlt04noxR6QzIQLTPZ9EifUcVYivAmNvs8V
         DIjr1Vm+KvdJN49V3P4SlkUZjJLfnjvFJgVhTS456ZdTOLSUaDvCKgdiXb+u7UvewaAG
         o7F+VVZcxrYDSZnlFTHXp+8Lgxa0V4IjYjd0I6btGwBmCWkt491hGIT81SJxsfL4J++x
         2RXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=muM66N/w6WMow/K5blj/8GJE8PANhztwu4Gao3MXNL0=;
        fh=r7LjH27EbDAXAkPu5ul/dye9L5YSrYgjprH61e/8l3k=;
        b=bAFhmctjjuf3I7s34LpX5H0vk02lYTodmEvf3+GhdYA4K6TvpZAlQSbdNHxqaZCUyo
         tKZnwwwjvgHI4+XGHa//yOOu1g5EZOrllDsD8bv/SkYVwmc3YgGd1auUQJXc17q9oGKy
         HLTcNFXtRVDg406UBKhbWVF8IsY6EO3KOe/1T0gVA4zjEflCoLe8aMx5ycbVnTxzC6+9
         BPABMc9wqmyx8d4hCE9pglIFuwqnsgSH50zz/ra5kCLJusjFZaFCF/rhW7xGnQqgRoAI
         rmvV+ivKKYzAadnv2pQ9uDkwu+Zb6NS7MpQAat7ZUkoa5Pd1U3bnZMwAQuV/fMcLca7B
         o49g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769628140; x=1770232940; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muM66N/w6WMow/K5blj/8GJE8PANhztwu4Gao3MXNL0=;
        b=g20JaKHkG5DIJyuD5PsbLEKitIgXuQ7qgxNVeS/3JjpIWL75cl7BGG+OvNzXYlf7zJ
         sUMl0zY5ujj/BdsFj/PifyTRCUSBeVxDpkvDgkJHvFxGm6SscXpTBWjEVJBEtlV0ScsH
         QphfEkoMOKlPkb2VZc8sjCaRF1w8Qll6HQm67GbuvAI8zRHZ6fJqjvKZYQQHz/RUH/W4
         euNJI70cbVV/ndYa9U0vEezzNFIX3xEecuKnW3ptSbpnmDNLkVBmzkRoQ1vx/Ew7BR0S
         YgmvOe7CUxAp1X5pRLmJslUX4X+9EhqR9LQczrqAnOlCCejyhqQbVASPnuYUed0YrJIG
         2z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769628140; x=1770232940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=muM66N/w6WMow/K5blj/8GJE8PANhztwu4Gao3MXNL0=;
        b=LZ5k6EJVVsgS8tAgi04APAwhsie10LNHe/Q/Iv+hCs8pIp/vLVbyrvdXBnf8bo94qq
         63c1QB9n2bcbcbgL/d/8h18TTCsYl2NiX16L8R/ykAD34hlmkQAJ/eIhXvhmtOZdXAUM
         PzPAeB8vAS/dpZcHxtH2sr+UYrk5dzdPHSS3zRpa3OeBrSEVXQwucCnESdQK4R0T22+a
         m8KTeR0hyLWdMT4UABjoZvdkti5IeWEwWCWOEniwebLVxscrC5tVAwVlt9e97ZtEb3Cs
         ASPTIaroz60nD1E7TZyqbVvWn1hKilRUE4fcK67lTbdEvKS4KYLS+poU2vtzu8AQ67db
         y1iA==
X-Forwarded-Encrypted: i=1; AJvYcCXXgIQbL7Y55Dec+fAgcdpEzMaAXTEkiaPavihbbLlJdAexbx1/HLqagfwPKYq01a+EQMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSbi5up/VmnJc9BLAB8gPEbqL6lXWnXHPTO9n0alU1hCZ1NznC
	TtdI0q3CZzHADDnN8UgHX5QUUezGFpu30dIjeg+1M8vxGWoWJSgjQsfOdTb+6InY4mj0JTndAVz
	0Ip7kDjiUckeXW9IjneyRyQ70k2lV4GEZB1D4S6YY8vNQocE68kXwdaBB
X-Gm-Gg: AZuq6aK2CX2AvKrbg6vZguueffJ+G+5YmuYywV18ZXV5o6pGEdSPH/oiIXLJzlq1ZU3
	9NRzAn881zTGdLVCHgOecPp0mpsUmZf7eTtRKMvue6umyKUMKVLgT/pwiBuQx6NfwOLcRyHoHnv
	NGdnw/E0uFiGWcT22Hd11i/yARbfvyrZx2/keL2aKg9BfpMAhP1a6Iz6qrCjltQtkwLyBmP8rMz
	DaKwgLr+nHCXZac85F5yp6NE+suEUevefel3b/94AumuRHYtQZWyup0ay01fYwsLMlMVw==
X-Received: by 2002:a05:6512:3ba8:b0:59d:4a12:5e9 with SMTP id
 2adb3069b0e04-59e0d89dd1bmr203716e87.14.1769628140094; Wed, 28 Jan 2026
 11:22:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128183750.1240176-1-tedlogan@fb.com> <CALzav=dMhycS2iBxkhPCz3tMUKxkfgr1dCLFGYzGuXZCeYhijw@mail.gmail.com>
 <9d992d4a-1aea-42a7-aa79-4ede80293f9b@infradead.org>
In-Reply-To: <9d992d4a-1aea-42a7-aa79-4ede80293f9b@infradead.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 28 Jan 2026 11:21:52 -0800
X-Gm-Features: AZwV_QiIycZYlMzR9c8qjKHTfTE9zLaHWTJ8OVCHhljFei9sVjKoLDHMigoIZpI
Message-ID: <CALzav=cWEoydGBpf4j5gPWy0TzLoAPP3YeG3VocbeEzytHTFrw@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: fix format conversion compiler warning
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ted Logan <tedlogan@fb.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Alex Mastro <amastro@fb.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69409-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 782CAA8226
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 11:12=E2=80=AFAM Randy Dunlap <rdunlap@infradead.or=
g> wrote:
> On 1/28/26 11:06 AM, David Matlack wrote:
> > On Wed, Jan 28, 2026 at 10:38=E2=80=AFAM Ted Logan <tedlogan@fb.com> wr=
ote:
> >>
> >> Use the standard format conversion macro PRIx64 to generate the
> >> appropriate format conversion for 64-bit integers. Fixes a compiler
> >> warning with -Wformat on i386.
> >>
> >> Signed-off-by: Ted Logan <tedlogan@fb.com>
> >> Reported-by: kernel test robot <lkp@intel.com>
> >> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lk=
p@intel.com/
> >
> > Thanks for the patch.
> >
> > I've been seeing these i386 reports as well. I find the PRIx64, etc.
> > format specifiers make format strings very hard to read. And I think
> > there were some other issues when building VFIO selftests with i386
> > the last time I tried.
> >
> > I was thinking instead we should just not support i386 builds of VFIO
> > selftests. But I hadn't gotten around to figuring out the right
> > Makefile magic to make that happen.
>
> There are other 32-bit CPUs besides i386.
> Or do only support X86?

At this point I would only call x86_64 and arm64 as supported. At
least that is all I have access to and tested.

If there is legitimate desire to run these tests on 32-bit CPUs, then
we can support it.

Alex, do you test on 32-bit CPUs?

