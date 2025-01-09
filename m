Return-Path: <kvm+bounces-34946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58AD7A080D7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EFEC16555C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C16520551F;
	Thu,  9 Jan 2025 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fYMUD417"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0E1FF7B9
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452131; cv=none; b=KYmIu7PiahCBHZtmRdZKt0BEuFLFQnnWwMmJXEO4//Z1tiLPBV8kyt/aqnNnNjjAomp7KLwBLkQU/QHDE/wtCdYVGz73aGEN7Ho0qZzq82BaryHzGb4QJeasWHpXt7A+kugUbcCJjCDa/EcOAG3SmKZPJlx/MlrdWrEHQWDqVRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452131; c=relaxed/simple;
	bh=x+aGqnYGYrAnMNzckS0sHoevLoT3Wj9mM/77mbCGXwg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WbZVDFiNUKCahZVeJpJ85qzsjz+OwZJINoskyJ+tUBMH0iIySgq+hBxiGIwOKIQ4/XW6K7NSEdKjvlGOv5Hr3Atpq0FAOlqlg7k9E7xIqibsyB2bhLiV47rffUwkDygiU/hyr3JWC08jXeL5fLqnp6ku+UBMwKwI2VEUG6wpF/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fYMUD417; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef7fbd99a6so2249599a91.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452129; x=1737056929; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r5nqibBzTG/NMQ3ms6I9/y5I8xNGqcmfWxi8diJq040=;
        b=fYMUD417q8DJ5F9Axe64B3YTvNzj1Op05vv5tbl3SCo5hnJ0F+e+tQ0navQRIuCibr
         SsGaHbYgKajx86JNY+HJ9zTigxbjkHsImkoRV7+gO3hbO1IoxRaSRZddcEWmSO4NxZu8
         ZWZaDkxvBNTFI6R+ZCsvKInc/4ceMpPLIMzsE+XHi/ILUeMARf9PYADid42jMl1l1rr2
         sS9CdJ3Ca7veGu5NJPzI5Fl81FQPBGiKMCAQKqGHpAvhRhkSMoxZMJQ1uybMZLeqM7fv
         I5J1AS8LkKHp+FHWSv+d+eu+pPZiacMQFJ7J9zgrg7AAl3gARvkvYFeGnXZvFh9zSkCZ
         oeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452129; x=1737056929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r5nqibBzTG/NMQ3ms6I9/y5I8xNGqcmfWxi8diJq040=;
        b=sh1ndzdJx4tAEtPYOK45ZZOMBbMMSAgrq/6Jy6kxPOgoIdOuVlMc6TAqkmb/cBfz2B
         hh93pdLpdlxElFPH0tfU/fH5Ww9xYigGJV8sP9kvUcFbnKv8Uy2MkCZwnnBXIGUFei1g
         9fO1t31UUrs18Ph0nBi4IbUSKmw5SIfLTs8IpVliaAJwz1x9nz5LDoe0ib6kWKV+/0Ey
         6fpQIryytUns+v8s1lxY1T9oVKQtq79B4ymo2/Ff4KvkeXZr4+2XWFI9tO/oOUdwzoEZ
         IPabvxvEHqP8jmmm6g6h9328nhJR/ZTjxpK3C0x6pV56HFMzXkvmotVrSZ1sOdAlcUst
         sSPA==
X-Gm-Message-State: AOJu0YxqQDkCusxXfprjfSuZ0i9bDgfZC1nazdo7LVXlih9uPBKAUki9
	wX4Y9TD9wx1USoWQ86dHJYxtk0N4hABXJ8zAza+eH8cH9hPu3kmD/DRUwsoTsD6j53p4m/At572
	Rcw==
X-Google-Smtp-Source: AGHT+IGMWiTQ/DdybpX80GuXSzrWHWU7Q91+GEMnfAcYDVkHTpDHIIXVp9N4YF7t2LPOvNwwFEKx/WgUP4c=
X-Received: from pjbse8.prod.google.com ([2002:a17:90b:5188:b0:2e2:8d64:6213])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520e:b0:2ee:9d65:65a7
 with SMTP id 98e67ed59e1d1-2f548f447b8mr11874232a91.29.1736452129673; Thu, 09
 Jan 2025 11:48:49 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:15 -0800
In-Reply-To: <20241220012617.3513898-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220012617.3513898-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645120539.885681.9004596567911167052.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add helpers for locally (un)blocking IRQs
 on x86
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 19 Dec 2024 17:26:17 -0800, Sean Christopherson wrote:
> Copy KVM-Unit-Tests' x86 helpers for emitting STI and CLI, comments and
> all, and use them throughout x86 selftests.  The safe_halt() and sti_nop()
> logic in particular benefits from centralized comments, as the behavior
> isn't obvious unless the reader is already aware of the STI shadow.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Add helpers for locally (un)blocking IRQs on x86
      https://github.com/kvm-x86/linux/commit/983820cb53c0

--
https://github.com/kvm-x86/linux/tree/next

