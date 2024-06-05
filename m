Return-Path: <kvm+bounces-18919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4CE8FD168
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D0EC1C20B53
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C70B481C4;
	Wed,  5 Jun 2024 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MOZBMGV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B813D548
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717600210; cv=none; b=rKzDjRinRsPBcEk2JXi5EONEJIwmITa7wXfTb5croLTd9Q2YCObq8+97e1W+H/DDRPolzEGGLyZIY7pyTm9SgJIo0y4TKLfPK6CbVY9MHl+PovrEBZa1N8XxmU216iogZBOhsyh1hU8ECJPnV9YfLFonG7VQApX5LyTlkZiKmbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717600210; c=relaxed/simple;
	bh=XIVQPDWD64eYeYQKjEF3OnoyWC3wyS3XLFk9t2rDyRY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ip6oNlo79nwVICmCZ1Wwh73ozQ/Y85GX4XB0PsHYISu74ILPm2SNi2/Qn5J+agC70NtuW/fIALkWV7gN2/3muu31kbDzTPt+LHfz1rNVv3Zx501sQBXW+mw+PAf3MAXWLPZzsL6HtZ2BH0WzL3rlX12C8N7xMxNKh/mLPr+8CS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MOZBMGV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6c380e03048so6205272a12.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 08:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717600208; x=1718205008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zMdlMnpu2rLutfBaZ7FjrKi42VwaFOFSjyMRzM4+P80=;
        b=4MOZBMGVu35L8cS5muRGkq2DamvgMxz6TbaR3N8vyDB+bdhXPZuvoJ2iFm6lCaWv5/
         EpbT20gJ1E8C2REEfztlObNNGaJZhoOd8tjMvtnuJysEJbRqE2qNetGFPUI82lIX/vas
         5UD56x5AB2bxeqs70WnRUf6R97t7oKwmuVsm/gHKygj6h/SQoARAkYi2KHkcvoPTrdv2
         TEdxD/4r8J1xhuKGI+KKh6s6KD7Nyls5iWFCAS3JEWvbGGbgtSbyrrcb7fjh82YxrBhg
         Z+wW+gGt/vOOEs2sFW5fPqO6UKelpTsv6E/fLvBVAzdFl1ruSIcoxbnOnwRjHKxSs7qR
         PaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717600208; x=1718205008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMdlMnpu2rLutfBaZ7FjrKi42VwaFOFSjyMRzM4+P80=;
        b=fxLfRDrQpeCFlD7A9bgevUWarCibLVpjZdr1Gz8ybMhjuIWfIECMPHA1aEW5oEobDQ
         xsrrZs0MNGdak+pUqYSmuo8n9MpIEQVR6Agw7mXbPuf5+j2wxHakR0XaE29pyOBPTJaV
         afXPIWOOsUERcWC5uay/em7wbsg3rWlyN72jP0U0rBe6o01b+aaTwGHFSfC32GEwR8t/
         Ys22GW+AAo8eoQSUQD4nNiqrpXnKlXI0TjZYe8S72foxV8GnheKK/gG2SCtOK8MZulio
         YMnrU+7mt+J74c3jRwyDomcanUuiDdoapHpEbsjtoDnJRFjsv2ZNMXWLsrsPyjJyIbdO
         1cGA==
X-Gm-Message-State: AOJu0YwF0CeKhXkCK0cRgY0HR+M3o8NceQnDqx2q/viziywcieOw/cU+
	P64ZivfZltFHdRx+MQ2BxYLSPj4/pEMERuk/iwoB6TM8d5JPH/m/HH9i9FdzgmDDtDAk+1JJGb9
	nzKJXJFTVs7zDrsfT4y8517aCKtSlbpzO/unJL7H48LZtU2u1JKxo/kN1z4spBsq6Daep6r41Ft
	PJT5lL/MyGocmVxMsbQ32ySYlb2he0
X-Google-Smtp-Source: AGHT+IEey3wmkUpf69Avkqmye51ogQqEPgRMRLIp2jlDpff17NiOASAUjHxDUtnJ8BIMPggZX5XlnZeHMo8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:452:b0:659:fa27:f2a7 with SMTP id
 41be03b00d2f7-6d952ec43ebmr7263a12.11.1717600206172; Wed, 05 Jun 2024
 08:10:06 -0700 (PDT)
Date: Wed, 5 Jun 2024 08:10:04 -0700
In-Reply-To: <171754374489.2780783.15684128983475310982.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com> <171754374489.2780783.15684128983475310982.b4-ty@google.com>
Message-ID: <ZmB_zGGqhwMh2jOH@google.com>
Subject: Re: [PATCH v2 0/2] Print names of apicv inhibit reasons in traces
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, vasant.hegde@amd.com, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 04, 2024, Sean Christopherson wrote:
> On Mon, 06 May 2024 22:53:19 +0000, Alejandro Jimenez wrote:
> > v2:
> > - Use Sean's implementation/patch from v1: https://lore.kernel.org/all/ZjVQOFLXWrZvoa-Y@google.com/
> > - Fix typo in commit message (s/inhbit/inhibit).
> > - Add patch renaming APICV_INHIBIT_REASON_DISABLE to APICV_INHIBIT_REASON_DISABLED.
> > - Drop Vasant's R-b from v1 since implementation was refined, even though the
> > general approach and behavior remains the same.
> > 
> > [...]
> 
> Applied to kvm-x86 misc, thanks!
> 
> [1/2] KVM: x86: Print names of apicv inhibit reasons in traces
>       https://github.com/kvm-x86/linux/commit/8b5bf6b80eb3
> [2/2] KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons
>       https://github.com/kvm-x86/linux/commit/f9979c52eb02

FYI, hashes changed due to dropping an unrelated commit.

[1/2] KVM: x86: Print names of apicv inhibit reasons in traces
      https://github.com/kvm-x86/linux/commit/69148ccec679
[2/2] KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons
      https://github.com/kvm-x86/linux/commit/f992572120fb

