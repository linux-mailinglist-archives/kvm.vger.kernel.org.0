Return-Path: <kvm+bounces-17936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA2A8CBCAF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 10:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B67241F21CCB
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AD47F484;
	Wed, 22 May 2024 08:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgseVKqi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D8676056
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 08:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716365405; cv=none; b=ds6ATe0ifNMKxqFCd/bZ6xfGXLeWuXvF1I/0+2389GoYXhhufncV6wTMAqi35rMdSLoWhmub8dOceTp5PacWBNSkxJI0mKbnl5Um7J4FH/Q3FP5F6uu63Hz11cg6htBskET9YwZV33aYg6n8dXrkkBeVBm0hTV2N5HrINHVOWFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716365405; c=relaxed/simple;
	bh=zoBhkj0M1tl/VH3w++vytNO/kHH6JAySc7ds3DgwG/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C0KHi4/6bfp6GvfoH6ndyOD7K2Fo62ry9kbz6I2jYS5giyTEYMNe4WiqTpdBQEkCR4F4p3MBQRpJlVVLpJYLBECyaewvM6i7BWhqA8vEJz7CqdrHa2C+47kqGZpuYIhVN6GiqANYFgo1CuGDWL7VkFR9ZBRYmazj/eegalpoHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XgseVKqi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716365402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=otRYgCVJq92Yfm4kUIiopkxd1yl6k4G597cBFQJGQUs=;
	b=XgseVKqi8B4k70+JYaWZc7ROZ4guQ4iSFPcWiYhrec32af4q9nS0HQPgePfKvsYA9/WWt6
	KXybRQLB7mkW6VbPJhQ8OZSBKHs5TSOtvuXS89kwmzlP+mTDN7Fh7FmlJN4BPVNYhTkdUI
	sQZevA+aTeY2XH9zoqGZ/0xizeynHco=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-1X-i70BTMBSyf23AIOOTPA-1; Wed, 22 May 2024 04:10:00 -0400
X-MC-Unique: 1X-i70BTMBSyf23AIOOTPA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-354c43b4b7fso2455431f8f.0
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 01:10:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716365399; x=1716970199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otRYgCVJq92Yfm4kUIiopkxd1yl6k4G597cBFQJGQUs=;
        b=hlRKpwMF3oo2aqfPKqH5PD7P6pUtJzS0zwAmq8JMeqLnr65O+y7RmoSjf6HICieKrz
         lm+JeMw8KTXS9TCr7m+Mu/tSZwH4Lt2ALfO8FgYUFYwJKzyicmIJkA1a2GaAIPWNRiK/
         +A32WAqqHoIsK3hhqHKNg45UBsJuNohPr/CIXISkzUi1px+SdsCzELcwVcvn85Nl0Lt5
         ghaWMbFOlhIX3B2jXw0OAzXMebiB1rZdQ4Lj23eLjZOFp8giC3velPhgEoQw437LWqCc
         +hVtTD8+GpMj4o6zRMNYU3BB0FGt2XYLtDEFCinHYoN49S4Lnj9UIFTeN/AKEowvsfU3
         ePAA==
X-Forwarded-Encrypted: i=1; AJvYcCWD0IBtskszw8dJSgSeWoRkBPcf4UyeAjS+9kaUsD17Ggf5zu2S6kCqp8KdCIUvOCKnlMWXItxgWokoEFuYCCkNGJsw
X-Gm-Message-State: AOJu0YxdqCrnyOKmAZBDeMsppVfmkdaWo4f8b03/EV6J2LTNVHWBSWZ7
	x+Wg2jLozmwVimPO8DvaASRALI68r4M/EdTeh0hteRbpq2W9tm9/rCiAS2SOqGVNIwhB45v4dR0
	frYqt9I999zbXgdLl4BKfgmzkczCgtNufBbXwItpU1qDtl92y/4fMxNfvZ+WQowFtG3VIXEfpP4
	YSfpB2J6fJTkbA3C0IGuidSgGN
X-Received: by 2002:adf:f2c6:0:b0:354:cc58:7af9 with SMTP id ffacd0b85a97d-354d8d957a6mr867161f8f.50.1716365399677;
        Wed, 22 May 2024 01:09:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYZBYweqSpzhVIi5/ML5GYyo4XnBFBMEWZWo5UVwE6v2E2Gk1I/ozaiDWRy6Q2pBOBbwPfOn4UcSnQaZ2DjDI=
X-Received: by 2002:adf:f2c6:0:b0:354:cc58:7af9 with SMTP id
 ffacd0b85a97d-354d8d957a6mr867137f8f.50.1716365399303; Wed, 22 May 2024
 01:09:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240416050338.517-1-ravi.bangoria@amd.com> <ZjQnFO9Pf4OLZdLU@google.com>
 <9252b68e-2b6a-6173-2e13-20154903097d@amd.com> <Zjp8AIorXJ-TEZP0@google.com>
 <305b84aa-3897-40f4-873b-dc512a2da61f@amd.com> <ZkdqW8JGCrUUO3RA@google.com>
 <b66ea07a-f57e-014c-68b4-729f893c2fbd@amd.com> <Zk0ErRQt3XH7xK6O@google.com>
 <CABgObfaXAERePMQrrpWg8PqM1TOq8TJT65i3WgU0n0-vePDGNg@mail.gmail.com> <d543ac68-346a-4439-8f29-ceb7aa1b3b50@amd.com>
In-Reply-To: <d543ac68-346a-4439-8f29-ceb7aa1b3b50@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 22 May 2024 10:09:46 +0200
Message-ID: <CABgObfZL7dfczyeY=7Xh1YGqEZEzVsdMnM+D6yumFSNfLO7cfA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 8:11=E2=80=AFAM Ravi Bangoria <ravi.bangoria@amd.co=
m> wrote:
> >>> LBR Virtualization overhead for guest entry + exit roundtrip is ~450 =
cycles* on
> >>
> >> Ouch.  Just to clearify, that's for LBR Stack Virtualization, correct?
> >
> > And they are all in the VMSA, triggered by LBR_CTL_ENABLE_MASK, for
> > non SEV-ES guests?
>
> Not sure I follow. LBR_CTL_ENABLE_MASK works same for all types of guests=
.
> Just that, it's mandatory for SEV-ES guests and optional for SVM and SEV
> guests.

I think you confirmed I mean: when you set LBR_CTL_ENABLE_MASK, you
get the 450 cycle penalty because the whole set of LBR Stack MSRs is
in the VMSA for both SVM/SEV guests (optional) and SEV-ES guests
(mandatory).

Paolo


