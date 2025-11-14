Return-Path: <kvm+bounces-63159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3651CC5AD21
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 54F6835889A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5101725228C;
	Fri, 14 Nov 2025 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IwQQnJfc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A86221254B
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080856; cv=none; b=EaPHhQckTzGoh9+zaL5f0dpDfPglhNLaD3enmDUGBNyYyLCDbz+Kq1iYYkINexJTM7tKF5peo9x6ZsHhNo8czVRqmOhT16FS/9EpN0qAQOPk4F1+jaNM5k3wVyFR1WZdostinVtXePM0wgMbNZ0UWBtNAGFCaI7GMJD9GSN/k68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080856; c=relaxed/simple;
	bh=2YSs4MLwUk/rsqGdZYzQwWPYKJEJsk/2KWRIaQG6MZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UNdHWDlQORAZtL/ayJAboX6wq0V2nfQrPv5T6GqanRVU7NYL1sJliObSmukBme8pqVQ3x0afWGXlu7FuiSYP1pjhT4VcGk7sVClhzfiMIFQ3CNni3vEzoYgSiWaFJjcPGntdApsLT9YqgVROS2mRNeY+j8s5Wi5Dvlje1/TA68Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IwQQnJfc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2955555f73dso12232465ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763080854; x=1763685654; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YSs4MLwUk/rsqGdZYzQwWPYKJEJsk/2KWRIaQG6MZc=;
        b=IwQQnJfcvcCc7tHN3DrLIReJaM/GgluW3th5jLmK9+IehVTp2R1n8YMVWzg6IDML48
         SF5/XGegoR7lSlJShzZfZMhO2gbQOcDvYVOOgRVDBDet+hx5eWPitj9dL7P1x4NdZDVw
         ORu6qXNVINCHAlOeAk++ivi2St8IZV7hkqRcKzhpE0CTwr7O2Dp6H8Z/Z/1FkOqTMEkw
         g6gUKNayERRugf/e4IbhJosspir4yTcC3WJuAYsU37MohSbBnnAkBXfRM+SBfwd2Lq5D
         pP90+QBUj1x12TjLlXmKu5SLm+g2dM7Xj7ERs+LmitHSM1KmRGa+Wu74Uf+ogeTfMQ/e
         0Onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763080854; x=1763685654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2YSs4MLwUk/rsqGdZYzQwWPYKJEJsk/2KWRIaQG6MZc=;
        b=HSSr5erVusZDmZftu9lDORUN9Ob93QV/PJXX1qvTPx0PqbvyjIiPhmpCE0Mwuz6l8a
         JOPWHzKn9zap7sUihcwEaY5VFVtpo+UP5CdrxmCcV5jUbAEFymLItJmYqEB0fwvJEICr
         8LZl7yP+wSk/5ynTMN9+QSnpg9qcFaLAAtBjdMYgVWmU//Awoxqyz9ht3yJrOO5BHDP4
         xlUkioc5FesmowQeVhPgRMmBMmOvMUGvlKO4ix/8MA/o/kqZja9q/d2HJvn7xQoBZUEv
         Pj/nN6yNVsvMCTWFyQo0Ze1FivnjNZppwYgl8FONOZU4/LeD3fRNORvlkt50CtsZ2Y4x
         ofAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX392braToUtypkpnzEcp/csxBAQIPZF7Ju/Hi0XzHa0tNqHiFatip17SS5sdrtHcj9xm4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybx0bG/4gTmpd8/KAuuecSNHWhI/H0Vnof6MSV8zN73muZ76I9
	PGYuEDchNXkt/qjOcb0sNJ7/8pmXbEamrgVW553K9QTOcWakEMssV3BuPat8Y8YdoYa5w8Y+YA4
	oyU20Mw==
X-Google-Smtp-Source: AGHT+IHCvUenQfCT03oPtx9CLy/qkuISRk2kX5MCsViIWpd5bUXQ1bMEoLL+fPDszUZX0tL2kN+juDo3FIk=
X-Received: from pjzc12.prod.google.com ([2002:a17:90a:e10c:b0:330:7dd8:2dc2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e848:b0:294:def6:5961
 with SMTP id d9443c01a7336-2986a752bccmr10183245ad.45.1763080854549; Thu, 13
 Nov 2025 16:40:54 -0800 (PST)
Date: Thu, 13 Nov 2025 16:40:53 -0800
In-Reply-To: <20251110232642.633672-15-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110232642.633672-1-yosry.ahmed@linux.dev> <20251110232642.633672-15-yosry.ahmed@linux.dev>
Message-ID: <aRZ6lerEC-alUEiD@google.com>
Subject: Re: [PATCH v3 14/14] x86/svm: Rename VMCB fields to match KVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> Rename nested_ctl and virt_ext to misc_ctl and misc_ctl2, respectively,
> to match new names in KVM code.

I like the change, but I'm going to hold off on this patch until the KVM changes
land, e.g. so that we don't end up going in two different directions.

