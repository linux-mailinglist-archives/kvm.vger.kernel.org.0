Return-Path: <kvm+bounces-49871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F31FADEBFC
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E51D516B72D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990252E2651;
	Wed, 18 Jun 2025 12:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UxCUBE1m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD31285CA2
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750249179; cv=none; b=mhQh6s2moSQYbRcDJ82WQdUrSpSY4IIcX2bA1BSvQZ0/yIU/QiRLIDteJ25WbfZABR34dTUrcMZsqPCRh7ATIzAh5LNU4CcEky+vEqhNhyjT3WJlwBis6tkxK8o598o/RM2/one9HvSnAgqDW3bokcHshniCYLBrcJBsFNnSsNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750249179; c=relaxed/simple;
	bh=NzOG8U8UNN3wPSVZoMWk+hdXQQdqSuFIxJQ5ghdut+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K76t4C458r3NLydsU0/9QSdeHUIqCG6O9Jvgh6rvhs0xpB6cOhbgoaaU3D+HwEdgVb7qG+K0Gb21Y6w3p+aYRIxoU2o0uRm0dkh2x6vPL5IycPokRkDsGoXyN3l0TtKNmzAv7DLKxWF0Lo3A2ESu1Iu0QE1oqjNhXQxNf7HH3tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UxCUBE1m; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23526264386so67841985ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 05:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750249175; x=1750853975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPxLnb07w2EJ8LEoe+9pqi7EbyUsRwD+FfXs2j0g29o=;
        b=UxCUBE1mWIvFNPVKdXfdoZCh8mtk1FaeZyzJmkkObTjlcM7dLVvWFlV5deohWW/0+O
         bsl3unp07DQI+lS4orFutuSym8IuRld/IqlRfepsWcHclmVeLaztfSRVvYpw/Vh7Yg2v
         g+YQlRJSvMAv+Fnps3ygcT2Ki077trKzWzbVebYLWfasQYZ6gVxq3Zjuw2WZZZGPvEQ+
         Tx5tbYb+C67iWpfGmuO1ybDLqXbB+f4bs9q9Ehl9CGE0Oitv9Kp4k4bDRT2M2PfvHDiT
         VDystkZ2Lqn68tr6j/iPe9AXKtFk5E/UUl7IK3xyX5HUT15eQ4bXueUJJaAGE0AeKQmx
         W0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750249175; x=1750853975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPxLnb07w2EJ8LEoe+9pqi7EbyUsRwD+FfXs2j0g29o=;
        b=ebji5tYgsuNXTbW0TuoZUPVbuSDYL2ivmA/GaA7F2EzVmoKW/Fj8IkDOuv3Y7os7t6
         a2mrbaE8N7Oo0V4x2o4UDrrH6kSSsbTN7+/FxzT5U/dI7ppcrkTd7t2wtiYX7fK4p0f9
         zVESPXr1AcSiupJkXZqlvFEyUvEML4rzZpdh9rxRs+n0SR/6hQwRiVYHi324TJQMrzKz
         ZrriUZVB5OOsElDRhupQXbOGFhMacRckgeCnpS0Zm8cNGAYaZ9lvuPqo2xyvt9KsdIja
         S390oyHGBsKPJOcOGVGDhyy1RWr2OyO1anEhmZ+EaoYdx6lF0m2rLf+ZHnYJ/36KTyWv
         b3NA==
X-Forwarded-Encrypted: i=1; AJvYcCUZYEFkB0Yn6ZKikdF7PsTtrQhXALxOcPr1khYblYy6qau9EIzvy+kAWDyb0Gx3AD0+dDI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP8GHER7NhVIFaiFLvPNS8jHwQT7lklnIJOE/h3nllDenSburF
	47SWRh3StiQrVy+ZLJ36gkSvU3kHk2N2on2bGl7dMXUhT9ZyZSutww+bYlFiBsLBV72b5rWhJLZ
	4PGcH
X-Gm-Gg: ASbGncv4HyFdl4d5oY8KRil44ZsImlHDVTJ2a8kHw68wVfYzG5eavD5aHRQBzvYNVAL
	/UWyhaHnBGqvQ5PE0IsAhe1daLCaVcRhUqUm7V05304vmlYhRhtuIgAKd0PprCCkYpZGTUXw27Q
	kEdMOV72zf4wltWzoO7pwtAXZ6vFFTle2KK3ClKoyluMZgf5qgi4ZCC0+ObzeFRGJB5HVh0q0MN
	puHacShsN24hJmXJHJmuJMAgxasSMslXTI5px8LTO0ZbJbwepUd7E/8dYSLFI7e1LHAj0C3Tg0P
	DgXYSzaOWCvUao8+ejCa0pSJ8Kv0QUBN139fCT75KCzbhdb9xRYh8mVRWLPJjZz6/9wUDOoEd+/
	AW4niss8/yTJo
X-Google-Smtp-Source: AGHT+IHr2BtBXka0zKs63iqb8e9v9bkQ4+Bw5VuVkckVQQXkUyrc9aYneUo5DkOGQbDxvEFfQuAk4g==
X-Received: by 2002:a17:902:f652:b0:22e:3c2:d477 with SMTP id d9443c01a7336-2366b3ac524mr289851425ad.25.1750249175033;
        Wed, 18 Jun 2025 05:19:35 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88bf61sm98240975ad.22.2025.06.18.05.19.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Jun 2025 05:19:34 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@ziepe.ca,
	david@redhat.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Date: Wed, 18 Jun 2025 20:19:28 +0800
Message-ID: <20250618121928.36287-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250618115622.GM1376515@ziepe.ca>
References: <20250618115622.GM1376515@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Jun 2025 08:56:22 -0300, jgg@ziepe.ca wrote:
 
> On Wed, Jun 18, 2025 at 01:52:37PM +0200, David Hildenbrand wrote:
> 
> > I thought we also wanted to optimize out the
> > is_invalid_reserved_pfn() check for each subpage of a folio.

Yes, that is an important aspect of our optimization.

> VFIO keeps a tracking structure for the ranges, you can record there
> if a reserved PFN was ever placed into this range and skip the check
> entirely.
> 
> It would be very rare for reserved PFNs and non reserved will to be
> mixed within the same range, userspace could cause this but nothing
> should.

Yes, but it seems we don't have a very straightforward interface to
obtain the reserved attribute of this large range of pfns. Moreover,
this implies that we need to move the logic of the
is_invalid_reserved_pfn() check to another process. I'm not sure if
this is necessary.

Thanks,
Zhe

