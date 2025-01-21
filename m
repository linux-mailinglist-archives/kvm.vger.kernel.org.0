Return-Path: <kvm+bounces-36129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA55A1814F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BF363AB666
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634B81F472E;
	Tue, 21 Jan 2025 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0pc9V/aL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3036B1F3FFD
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737474303; cv=none; b=IQk11uZgxkLHYI1AwFvJn20WYZbblfPwBgIWa3UwCY76TUEhVd4kuAc+8HH3XOvjvIPEZqnIDhfRP3KKVr2lBQGSqu51FNrlJx2U2Giy+V/e+Sc8ruqUnRKaSCC8un7j9DFESZpIeA6FmSlzd1//v7LOFHFM2Usm1v/oVce24lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737474303; c=relaxed/simple;
	bh=kpKpehp88AbU7D1AyYaN2ObF8LjHfnVskQuGC9gtFZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cV1T3W1sMh6t0VivYoknnnNAuewN0BQr4ijgIYYqcDMwg+VaM1/w08fF3LMJD2wnu2M+ijJ+LqVLCGfmZ39g1pJYZU7itDfo7jsTWCRtPVKcy8cP6enfaTLor0LDruLK5l66yLb0IoCBQ/Z6Uh0DiqY9pbsDergcJIJGhwzsyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0pc9V/aL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso10725993a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737474301; x=1738079101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c3phGslG29clX9cUAWXx97epVX221R4JGa9tU4fOwIk=;
        b=0pc9V/aLoVaaLjR2w7EdVWp5P1yTNuDCr40g4fwXsiBkklKIGCTPBhgEb1I98WKHsG
         PBC515kXg7P+31euGqVaMaDVsndCxOPkjPSPo2uqc63ltbE69x9nhLYYyRBcEyHPGFaz
         VEtZrJl4NYRBc52pjJLklCoDipbrEZttt+ecWPZ6zTsO48kmt2HXxB+qnB8dy0KpWy+i
         x+JLwZpSrOncVFfPJfLRXL5sewiLLMJQCzI/eEUgzm/1bWWV0w5HoG/Tuypq5d+aIvN/
         7mwje/aM9h4WHrdn+tRfDpDsd8NDpKlLALvVIsWjhP8PxgMtJPFrBDNQicuL9IckOtt3
         lNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737474301; x=1738079101;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c3phGslG29clX9cUAWXx97epVX221R4JGa9tU4fOwIk=;
        b=GDqicK6j81g5I8j6RhHSBgX8FgVo4vof7Jj69b8kuiSIOXDCQDftt/1jl/x5A9AxFw
         DnM3l3b9FVbJctxTPL8rCD3yjLdh6xpS6+QHX7FaWIJdr/Td5YMHy0hiaGBex2NsTc/D
         o5Zw/KPBUazdtaJOVnr7UxC2LoAnXEh9AJ959jEyzc5GDhj/r0FhDbVrzeC8WPzW0DwA
         eXh/952d2CGofYLBLZ2F9YtkjZ7GFx1a3eJ0ZW3v/IJbVqxdbxqCHU+MmOQk+7V0k+mH
         AwpzcIC47yvlYeXJWshb0UhululSFVat5ErEAL2SQfYODAsOO7vSiI//ARwmzt3Fr/tY
         Eciw==
X-Gm-Message-State: AOJu0Yzo0jfFJ2BLHdZ/ZUM37+SJ2AKOig4Xv8LPcSN356XmcTEdNQgS
	JtcQscMTmi+fU+a8WsMA714u1kVWG3vGj43dlbTcLHM3GI3YKBMy94yR4NnkYvKm15Rav7H0bic
	Zhg==
X-Google-Smtp-Source: AGHT+IHvW4HTf/DhQJXnXIO41tnX2TqgaXjtxopPZgCR9CbRglgRNVhhPUwuhLdpIqUMS7r8z/FsVqV+hvw=
X-Received: from pfbbw15.prod.google.com ([2002:a05:6a00:408f:b0:725:f324:ad1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a11:b0:728:e52b:1cc9
 with SMTP id d2e1a72fcca58-72dafb35f9amr28995588b3a.18.1737474301535; Tue, 21
 Jan 2025 07:45:01 -0800 (PST)
Date: Tue, 21 Jan 2025 07:45:00 -0800
In-Reply-To: <CABgObfZkQ_r_QY=xREKN+EdoaMRqRjVmk5Fz7UgdDrj=kmU9tQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com> <20250117010718.2328467-5-seanjc@google.com>
 <CABgObfZkQ_r_QY=xREKN+EdoaMRqRjVmk5Fz7UgdDrj=kmU9tQ@mail.gmail.com>
Message-ID: <Z4_A_N0-DMPsT4Uq@google.com>
Subject: Re: [GIT PULL] KVM: Selftests changes for 6.14
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025, Paolo Bonzini wrote:
> On Fri, Jan 17, 2025 at 2:07=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > FYI, the "LLC references/misses" patch exposed a latent failure on SKX/=
CLX/CPL[*]
> > (who's brilliant idea was it to use "CPL" for a CPU code name on x86?).=
  Dapeng
> > is following up with the uarch folks to understand what's going on.  If=
 -rc1 is
> > immiment and we don't have a fix, my plan is to have the test only asse=
rt that
> > the count is non-zero, and then go with a more precise fix if one arise=
s.
>=20
> So based on the thread there is a root cause and fix---the test is
> just counting on an unrelated event.

Oh, yeah.  Sorry, forgot to follow-up here.

