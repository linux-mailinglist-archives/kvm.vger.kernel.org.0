Return-Path: <kvm+bounces-11679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A348798F0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 17:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27DCA1F21DB2
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 16:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D4F7D41F;
	Tue, 12 Mar 2024 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oeofcgo2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464D77D406
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710260861; cv=none; b=OJdcbE3mCMTpGTRK4h0AZdYBrFIg5UcbrdX40ZY5hWwI5fnKBhxYIq60QVu/gYEkxp2Au6EfPV+oASZvoTfe5rYeUcEHyLaRuPL5tC7C1QH7Ig+l+Sx4j4aSN/9nsAcUAMQEM4/tWwMYEiVsJ1dIOmVsQlA06PpYzPzHzyTGeHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710260861; c=relaxed/simple;
	bh=lVQgW37lzj2erLnZIUJzNpd+5a0lsBoPl4ny9lJeZjI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCJHbsQ/4KjCZhqK94Lb+GxKL56AdlQMwA9aZAjaf86EFhr3vDBcWYwMNCPD90+HhEAG1XKbFcnYeHRIx5+v//nzZcHp3ro6Rfc7fcvQ0sVUxdYMXEx7HMjKuTajYjZuwxUeiT5ftnBYQsrF7fQ0h7fl8iOtfamz/s2N3iJr+YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oeofcgo2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a55cd262aso20769887b3.2
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710260859; x=1710865659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=saWJRyeeUwuF4qd0dIPrZrvXZDMemh0MvZOPFsaqVyI=;
        b=oeofcgo2NWb+czLwmTNSbLL/hU2i87C4P03tez9XPV1z/9KOjQ0hHnvKyMCvxP9DwZ
         LLg8/4K7gDpZ7mm2C+9FKIBlSpBIujMxcC6/JptMGSLgsKaAyjAJxSiSEroCzTNHxotp
         BfliacXPyDRrx7imhFmdgx6yW+xhts/jUK8ZJFYXYBw3YzgPg6iEEZSIgynzKye9sNmR
         +xtZzvKXa4eP54mFvXmGUIfgBbxmtSSH9tjhvak2nMDV6pYBXvacPrzFsE6bHI/IZhpu
         AeXp0Mb70QTDzf6JL07pnrq0dPqTESzSsneJQPWI39dTxntMZLAY1iAAHXQSl20I+0nF
         8idA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710260859; x=1710865659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=saWJRyeeUwuF4qd0dIPrZrvXZDMemh0MvZOPFsaqVyI=;
        b=ZVXU/peWBAxbEIoFZX2N4C8TtX93BTHO0B73Nc9J6EFdyvTBAkYZQHF+ziNiW3x1o3
         Hxp2ffy/60kZfgHQvoYFdrlGEoWl6z4PHqB0y3aQIGO1ZggqxBT+6FOuQf1bRvyyj/Ze
         uPqgNgzYgpeKIXWrFr/8nZ8Wv1/7lI7LXxtZTRJZgGsZTOhhh21W1VQKJti30NmjWF6U
         mZ+GRtm4EJmq869zxcp2ixYKROhNyko5rnsE3cZcke7HvBzrxOG8k7WCvjb/Tu3/QCIB
         rD5GUSy03LQbvOALfbSgGXoyty3sk/qJFEQMeGWbdX7juqNo0B9mJZ0dZLIATob71FB3
         ug4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU45381U8H3LVc+nI3tInBMOTqMsr/wY1e1kJi9fOtkTODpLmhTFtbKDTMrKLy72S5PI79s8Nqw7coC8qiPsot+GgjO
X-Gm-Message-State: AOJu0YxlrbjpmKc3zSVhrTEHzWRZWX8LZROOh29bDTBUHdXuRQLsiyUS
	AimutUoplD0v9cdOl4tYtKE8C5PX8LfDme+E3qhMgzzf+kSG5MBX+ZVQIpiM5gYI754nvvpmpcq
	bsw==
X-Google-Smtp-Source: AGHT+IEvNqUaUJBlWS7SOO+5ifizSYXMErTQDuWBmebOu7ltgX/lzZWc9zAGvheP8PZ+HeITHDqWN/fjXZk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a108:0:b0:609:50fb:c2cf with SMTP id
 y8-20020a81a108000000b0060950fbc2cfmr2653020ywg.1.1710260859272; Tue, 12 Mar
 2024 09:27:39 -0700 (PDT)
Date: Tue, 12 Mar 2024 09:27:37 -0700
In-Reply-To: <20240312-0334bd56a139b40ffec19772@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f39788063fc3e63edb8ba0490ff17ed8cb6598da.camel@redhat.com>
 <Ze-cPqZDXnF-FEXj@google.com> <20240312-0334bd56a139b40ffec19772@orel>
Message-ID: <ZfCCeQS6crEM0nqk@google.com>
Subject: Re: kernel selftest max_guest_memory_test fails when using more that
 256 vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: mlevitsk@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 12, 2024, Andrew Jones wrote:
> On Mon, Mar 11, 2024 at 05:05:18PM -0700, Sean Christopherson wrote:
> > On Mon, Mar 11, 2024, mlevitsk@redhat.com wrote:
> > diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > index 6628dc4dda89..5f9950f41313 100644
> > --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> > +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > @@ -22,10 +22,12 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
> >  {
> >         uint64_t gpa;
> >  
> > -       for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> > -               *((volatile uint64_t *)gpa) = gpa;
> > +       for (;;) {
> > +               for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> > +                       *((volatile uint64_t *)gpa) = gpa;
> >  
> > -       GUEST_DONE();
> > +               GUEST_DONE();
> 
> I'd change this to a GUEST_SYNC(0), since the infinite loop otherwise
> contradicts the "done-ness".

Eh, the guest is "done" with an iteration/run.  :-)

I don't have a strong preference, I'm just biased against GUEST_SYNC() in general,
as tests that heavily use GUEST_SYNC() tend to be ridiculously hard to follow/debug.

