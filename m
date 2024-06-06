Return-Path: <kvm+bounces-19041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B828FF84D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 01:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6F3A1C233A3
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 23:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCCC13E8BE;
	Thu,  6 Jun 2024 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fn4GN8lV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349AB482F6
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 23:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717717796; cv=none; b=c1kxwlYObOUfmHh6JQrnBdyzRRa6KStpdnIZ+gvsh/5uVtylD4F/OBIqp3DfUK+dR6V8gZI80qhX6TJOTcxVbXFqZulRTELX4+K2oObeAa2OIXXeXZQ+7IUvwyYElqbnF/HF167QD/s+CTDSby+ZFsFYTCXH8VKMG/ghrMypwjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717717796; c=relaxed/simple;
	bh=ZljjN9wuR6CJEjNmzsWnAaBTawhkrbJYoHlcDuATJNk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i71wb7R0tde5a0pYyfERKuljbCZSQejfRTtZmqDh8hiQ3rM93sblK9qZXMqyB5lErYylyTyXfw0L0Q2cijar/NqcNEyjGoIsJMK78Y69xjd81f8rkJZsKW9Swiw8mDrWmTd7dJydJ8/Ak8VEK97J/Cwzbp7iqCwK6yj2+D6PDcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fn4GN8lV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-703fddc1c93so962115b3a.0
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2024 16:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717717794; x=1718322594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IqRPUj4joXrQrzlXQIVIMJyf4O7ZE/30I9lexPs5qMM=;
        b=fn4GN8lV/4Z2FBdIsi8ypd45kHVNYxbNRUV06ZU0aaPuwgdRYiY0AlL0/BxpooBQnn
         ai5Tx/zj1hOyiGeWcxEmcwFP6/OGlnKg9KN0LqmQIv1Cz9hAgLE69gK4EEAqkPVfWplB
         fEVd5qesl/WAWSasMSLIuhfuFCwZjeUoHsDha/NwQcJz52NOpOrbORTMIHhtkOqo3eaH
         1gwTcob7+ZOOqmWiUYCBTL5ov4QISGzj778j2nTI9jnPwWmeznTMEs9DixDZdU7RZpGC
         PuOBzZYLaOG4I2A4HBPZD6HtOmmQDh+LrZ8xFU20XN6pztQ7DuyW0XldUYr4sAWlURHm
         NPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717717794; x=1718322594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IqRPUj4joXrQrzlXQIVIMJyf4O7ZE/30I9lexPs5qMM=;
        b=vogWVuqvAFSNejSHJwVepTMHCe2NNl9DjC7s3s7r9YYbtHSTmt+wu4VOBmdJPzfh8Q
         BpQgqDDJFXHDL6v6tFdyPT/g/EW3eXZIu8fEMwALOZQpvZxU/wBuKbb5GNeRvqDzXigQ
         FDzc+y86uFloLFzvhMenyp8tF62iDrwk2t98RrD1z0zHjre4Gf929NHS5af/8SLJ+2CF
         pE/2YRo5JB16VeN64zE1dEvIQSjrE8+Inha5PbuyPC3yqzokIsYOABFgWH4quZGESHij
         8A7vA8zMz10OO7JssH6itqMwuuKjnLvqAqgku7b5Qpq+6b5DAqccX77eOE2XHdsi5vgS
         Auzw==
X-Forwarded-Encrypted: i=1; AJvYcCWGfRqHkUVMnzMngRDPvvAk422TXNf6hz4c+RrWuLK97giwwsgH2h+PaFX2GfLSyMzTiKoFiV765Y6Iol5VLBnmQwI2
X-Gm-Message-State: AOJu0YyJHTbmINPcgwMw/x3ZRDDqSNJ0shdxoU5B+5Z251nd04m7JQmd
	P2QxP2ejzJ84uIMwRG5/PqZ1kJyn98+JEb/P9x/R+iS/AepoxBji4k9u8FCG823I8rZJmshPg++
	fBQ==
X-Google-Smtp-Source: AGHT+IEdAC6sfO2hT5QfIeWauQJabkyf/UL85lFF0uuZ5zvwLDx63A+nDYVyJk8UJuSelqq2dqKTR+wxewU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1389:b0:6f8:b5b6:3065 with SMTP id
 d2e1a72fcca58-7040c3ae18bmr49083b3a.0.1717717794360; Thu, 06 Jun 2024
 16:49:54 -0700 (PDT)
Date: Thu, 6 Jun 2024 16:49:47 -0700
In-Reply-To: <ZmIG3sNYe0C1jsXx@vasant-suse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419161623.45842-1-vsntk18@gmail.com> <20240419161623.45842-8-vsntk18@gmail.com>
 <ZmCMdLNkhusHSS1Q@google.com> <ZmIG3sNYe0C1jsXx@vasant-suse>
Message-ID: <ZmJLG4zMq3KbHwPi@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 07/11] lib/x86: Move xsave helpers to lib/
From: Sean Christopherson <seanjc@google.com>
To: Vasant Karasulli <vkarasulli@suse.de>
Cc: vsntk18@gmail.com, kvm@vger.kernel.org, pbonzini@redhat.com, 
	jroedel@suse.de, papaluri@amd.com, andrew.jones@linux.dev, 
	Varad Gautam <varad.gautam@suse.com>, Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 06, 2024, Vasant Karasulli wrote:
> On Mi 05-06-24 09:04:04, Sean Christopherson wrote:
> > On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> > > From: Vasant Karasulli <vkarasulli@suse.de>
> > >
> > > Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
> > > Move the xsave read/write helpers used by xsave testcase to lib/x86
> > > to share as common code.
> >
> > This doesn't make any sense, processor.h _is_ common code.  And using
> > get_supported_xcr0(), which does CPUID, in a #VC handler is even more nonsensical.
> > Indeed, it's still used only by test_xsave() at the end of this series.
> >
> 
> The idea was to have xcr0 related declarations and definitions in the same place
> which were distributed across files. Does that make sense to you?  If not
> I will move back get_supported_xcr0() to where it was.

I don't necessarily disagree with that approach, but I don't think we need a
dedicated xsave.h, e.g. just move get_supported_xcr0() to processor.h.

