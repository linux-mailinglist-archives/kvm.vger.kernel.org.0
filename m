Return-Path: <kvm+bounces-13953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3B089D030
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DD6DB21A5A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBFC5025A;
	Tue,  9 Apr 2024 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BS4J70+C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7A24EB2B
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628186; cv=none; b=Bm4j79Kd5R1eKvgLITAuSE+ubKGVQ1acIfiyEVTlGyUyX+QW8BPqmWzWaCXsONlhLY3OiVll+2tg/CIVzaYvFB+clX5U1hH6a6prWV0JA/0PCJyyyolGQjE2fTz6LuATijT8U07BCSIzQHGYeaMV8vfNRMiQkKxQHiExt6fh6cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628186; c=relaxed/simple;
	bh=qCxsp8SAqEQsOO/VjNk8qCx0QXpPt4rQikrTsZg9+xA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lah82Y2Gx0ILoyx97EtxQkjjti7r83H+itnZ6TWGHyVDsgfVhDbRrpKTxT/RfmO5qbUHaNfE3P7pY/fdQU1ebEFYSQwM7msh0LKBxICX3nV6GaAViJzX0jIY7XRw96Q13Qzuy87/xoKebRdGeiXFqLRSi0R54pEgHI5AirU7qqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BS4J70+C; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a48f935627so2873131a91.2
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628184; x=1713232984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8GVOlOj+4YK1L00ovQaCd8DbzZ1g6reGeHogrlpu4C8=;
        b=BS4J70+CGKcphwfomT72ca1+tu0q3EXF/c38WCmvqand2WKbnYRF7QWJFuh1Z//QV0
         c4CWsvBPy9V0J2gwMBG/EeO+uQhT1NIVvG9MD+dlAo9gC85EA+/qvEDTAvobME/w2tOt
         qY1rNuijmsn3TKun73ziMJOAYthwW59NYlGv07Hz2bjdRMDjtXHVNNybD0iWOsmbmNtM
         CzfbCyGNqV+gemhrY5Ya2RcjbeBYBlD46G8zT4/bZr5PDi+v3/1TGw9FDMjjWX9Z9Lvu
         YrEZzCHZ6TwZF/KN38J05RHcirsHpC9WB3zoTgVgBzcSpK26hflPTuKRXD4wFyPDucM5
         hz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628184; x=1713232984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GVOlOj+4YK1L00ovQaCd8DbzZ1g6reGeHogrlpu4C8=;
        b=c0OSsD0IWhxR2QRJpbefCF9V3CRasuSLx0bxgaHw5CsV4qB8pXPQtd+g8noOgqBjow
         AjPEDmu8GOHa7b0P36WhWUFYx/wKB1ZjAJRLo5NafjgM5cUPmu7hd6t2kIV4CdNQUAJd
         JnW7+a73a9VEs9pPZlKTd1v1FJzX18+CD8w83iPptlTJExKKnLJVRCTTbBMoxWt7oxHt
         eiBj2frUyDZ5IH/N0B/WukGuRWuqJb2CFuEXx/bLQlqhBVk9xvqlllva1RnXpvpIUcSs
         DY9t8QOq3wIYPRYrOnoH/KuC9Won/lJHGd/UDiLqJ90TiCZBMKDj5hQbGQPLH5utdb+K
         k/hA==
X-Gm-Message-State: AOJu0YyN+oBZkGNeZU3klzPWzAzwxNGY7m1DEemHrEjlWbUY+y4YAN1X
	4X8+kBK/GX676Vj9cvSeAfkGLeywJSq+81Y0164uxn3gu2S70cYWowZnm0q8gze0lDJzDxvIsf8
	zEg==
X-Google-Smtp-Source: AGHT+IFM0XM0y1o2qC6JdyhHhlh+lf38aueLKvSDHJ88kguHBC6pNJlhhhSNzjmIxNpIyYpU0LRP//0aIFc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b383:b0:2a4:70d5:2dd9 with SMTP id
 e3-20020a17090ab38300b002a470d52dd9mr32437pjr.7.1712628183835; Mon, 08 Apr
 2024 19:03:03 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:35 -0700
In-Reply-To: <20240408231115.1387279-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240408231115.1387279-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262750553.1420874.9114935191255728552.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Precisely invalidate MMU root_role during
 CPUID update
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com, 
	Phi Nguyen <phind.uet@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 08 Apr 2024 16:11:15 -0700, Sean Christopherson wrote:
> Set kvm_mmu_page_role.invalid to mark the various MMU root_roles invalid
> during CPUID update in order to force a refresh, instead of zeroing out
> the entire role.  This fixes a bug where kvm_mmu_free_roots() incorrectly
> thinks a root is indirect, i.e. not a TDP MMU, due to "direct" being
> zeroed, which in turn causes KVM to take mmu_lock for write instead of
> read.
> 
> [...]

Applied super quickly to kvm-x86 fixes, so that it gets time in -next before I
pass it on to Paolo.  This is the last commit in "fixes", so it's easy to drop
and/or modify if there's an issue.

[1/1] KVM: x86/mmu: Precisely invalidate MMU root_role during CPUID update
      https://github.com/kvm-x86/linux/commit/4fa96da3e6fe

--
https://github.com/kvm-x86/linux/tree/next

