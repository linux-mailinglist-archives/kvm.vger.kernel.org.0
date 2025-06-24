Return-Path: <kvm+bounces-50555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B50AE7038
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A896B17C12A
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5E92E7F3C;
	Tue, 24 Jun 2025 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zyDortGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22F26CE11
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795037; cv=none; b=ADbSC9nwtGpyfLwN2oLYUwWuFOV+uXaiVyhrdmzIb3FOWbMbb6aVCnhYI2nt9H1dqJPCzVSP2Si7CUejh7eV45Vo/XP8qQMU8Nw6xApcQXpqqCQai87fdlyK93NOXN+nro567vrLHUo7Ir6j+mChE0KLvkVEDU0ieBksGyHbTHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795037; c=relaxed/simple;
	bh=c/xR1210WNkMjaEddRyUd3VIYNyGW7UT6fUIt9VWbHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PMEIJRSeItllh9hzPok5Y0c5jUmrR3CFhvfG7Kd8s7/iN5ZEIVttNnvqIJuDhG4SoV+pipcssopsFV2be6mJZs/CtZ7h84nIJlT5uVJmTTU2j5QN4tPEw51ombOUkyl63hpcWeYFWIJs7eg7gkASPowig03CVyIDBoWRZ8F5nv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zyDortGZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-236725af87fso10751615ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750795036; x=1751399836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BENYVyjj2zucOOe4fuLRvkzQyNfHSRq657VEghHqQ9U=;
        b=zyDortGZ3sJQvCsVrr4z/nBzJ/l4HfYNOVE1n4BrNa4VDHL1elXxOXFTxZ2lPIZYQs
         MY4/zZqBmE5mEpbgJiGIClAvxJ9S+faLNchXsIYRvSYXt5qkG7eeBGVkxSDAckJfClCk
         ydPyzY92SmfySe9HB5AsFcIKvfgOjU2Iubrvt/pBwYT118JXy5u/yfZv68yqojqvuPfd
         DiqDTDt1M1otE0omTGv7YeV2rL8xP5PZ/mLrpXnjT3ensuhq3cH+Mc0gjYPTqtbb6EUU
         nDjZ9Hhc3JaVcH7Abv9FgHAkUp6BxQ9LLN98Ewm6LkH/eRVLxnKRlou6R/4IdcXfEfNL
         AD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750795036; x=1751399836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BENYVyjj2zucOOe4fuLRvkzQyNfHSRq657VEghHqQ9U=;
        b=ZoiY/QDYWcKC9Dk4wlj0fWH8GKpf4Jf4kKsfLUuUxRRcyDrHxaBuDK0vEtTTNXQJIQ
         AzEhh7z51+iNOCWXWjePbIaUfhZAckbbIGGCePh/rP8Nc8aRy2kPjyLZR2TBoqMrYrbh
         T90ZpAfWWBDHNnYDqH427xCeTxj6KAtnEZRHL1X+yO+kir396HlmnSbvAJS0fwSKjCmp
         i1kFPDB5o1B27Ec3NhvuzLqdUlGga27dXECAhcnuFj426Ad1XamKNIXVmhU28h2BOcRT
         fikBwjUSvS51x3ZnxKEGuoZfXATOAQvZshfp0u0r6AtqqtujlbTqD5zoh+j/w2nxKJqf
         cvEA==
X-Forwarded-Encrypted: i=1; AJvYcCVE4k7+ICvlWsMKu99tZ8eVVbelG8i5Tj7v4zCImZivGXsBmbOUGsrTVXOicYeqvuC0uJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvXvhvGg1UosmjsDd70ES9lXKOIeKNp5ur+oG5VrDizyTCNlMt
	hfehholh8qo9zoGFMED2fQyMJ5mC8bzS+QgfyBoSVJO96OQK+YhKF9g6nTOQPt8F6eEs06lM803
	xTjsPqQ==
X-Google-Smtp-Source: AGHT+IFVpnsXXGmHpzDvt07TImcej4CtxG1K5AUbuX4pJYUSHacGai39W7FIKq2088irF9CIPs9QCTN8XOs=
X-Received: from plbix22.prod.google.com ([2002:a17:902:f816:b0:234:46ed:43f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2bcc:b0:235:5a9:976f
 with SMTP id d9443c01a7336-23824030ccdmr12589825ad.24.1750795035894; Tue, 24
 Jun 2025 12:57:15 -0700 (PDT)
Date: Tue, 24 Jun 2025 19:57:14 +0000
In-Reply-To: <diqzv7pdq5lc.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250602172317.10601-1-shivankg@amd.com> <diqzv7pdq5lc.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aFsDGvK98BRXOu1h@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Remove redundant kvm_gmem_getattr implementation
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Shivank Garg <shivankg@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bharata@amd.com, tabba@google.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 02, 2025, Ackerley Tng wrote:
> 
> Reviewed-By: Ackerley Tng <ackerleytng@google.com>

Ackerley,

FYI, your mail doesn't appear to have made it to the lists, e.g. isn't available
on lore.  I don't see anything obviously wrong (though that means almost nothing).
Hopefully it's just a one-off glitch?

