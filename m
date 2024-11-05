Return-Path: <kvm+bounces-30627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0F29BC528
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B96171C218AD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E22383;
	Tue,  5 Nov 2024 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PnIUvlqf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E7E1BE86E
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786223; cv=none; b=OusNVMKP4r9xAcgRV1/fd0zKPDrU3P57R2kFLWBt0uTLflh8ZqVFbGiP1pqD0t48vikNkW8Yd0CGX5JWICebPrYqhanBOis+bH8IMFtOde6QQ22/SX1m3Iu8DfP5jSj7SnXCOUd+64YzV9zofzW2g4clVZ7jVm9fD+zEu/cx5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786223; c=relaxed/simple;
	bh=KGs871fzX1EXE2qkazuNkjeNwAp4J3sb4bqjcPOPIj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oUi0kNtwxexr+qnReS1lCDCUHpa36Q1ZaKX1PzhZ1iil0QlMnYulu/xdHKsQy+lh74/G3MpNdL0O0k60lsIZ4hcII3hSsOsJe1y5Y3qTXVcHD55I9xB/1zYc9SuIPW/u6YEkhABUdhgpJfJK/YbmCE3qCR5pkFzSgJ5xYGPmYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PnIUvlqf; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e330f65bcd9so4635210276.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 21:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786221; x=1731391021; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tnJjG3ugyGSlqpe2tsDrKIvf+wNpMgv9bSmhDQwEX38=;
        b=PnIUvlqfqDMR8Io24xJrq3ZF1h1KAV3H0wNkAldzLQ+lW+RIckj8UJUk/hoFEC2kmh
         OdOqKf5j1WVn+6Ub79VNmwbs6Ks7Y5cXGue5Hy4mnuUSiy6IQK4kDU11qWNhXuYrtNuC
         c1fIo96s+Fag0G449zkquMsQ57FSn54miOpkW/YY0N39fs0/q/zkPgysDM+opzUgRT9u
         yFpRoIIjAY36ux1qqQlbOj5xM/jAeu76cOltGnx3ROyK9lBpsyNzkK4N4dngPVhdjtyp
         QMmRvy8XFTTj5JBGQK8HrIhQ4l6xhLNkWTE9RMm6Wx86wpFp8JdrcK6o5CvOBhLYwhwx
         BDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786221; x=1731391021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnJjG3ugyGSlqpe2tsDrKIvf+wNpMgv9bSmhDQwEX38=;
        b=Y3ChM4lnJk2zaIdT4/Mo1PZ1ITQTs1rTkwWGqXLng9qCiSqOS+MwnaBxZwgqpfZabE
         Ax+4LKTWoPxHtvNY7ksIRRRq3Xn6aWAbRuCtXjaN9k3Uagk3jpoqaBAQT4WHWksqSJyn
         A/Ucr9V5LSQifQFa36q66YS+cOfhNbaRWtLT2LwZueYop9HFmfJuo8GF54LcM2WKtbnj
         MGmrxPvkhZHJSWKAAtQ0Y0yoHGxI95x+1wo1CWriPsTm1offvYBwtQCRSiyoDLZloUyi
         BDz0u4xI1s45EMpMhm8hwXBst2Sse2ZiMaHDcT+bnIQY5vv5I41SFK2efVW2fWGF0q16
         myAw==
X-Gm-Message-State: AOJu0YxkknqzIYp8JJT6XNJsIGqsU879C/NCwYNUhCwf9KSNTCMLy0rq
	GTPbvdh54RqLKGSOVpXV5euiG+B8p9DjGuEadeA8wHBPJQ7ehNrPt0rc7J3qmBBbOnYh6SaxpuZ
	lNg==
X-Google-Smtp-Source: AGHT+IEf24ljD4sPhcD5TaDheSmL0780TLkVcJeewWVsyqKd7BentSSs76PQjbmT0ISyhOQ3O7kTONMrp6w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1801:b0:e30:b89f:e3d with SMTP id
 3f1490d57ef6-e3328a15f4emr25622276.1.1730786220286; Mon, 04 Nov 2024 21:57:00
 -0800 (PST)
Date: Mon,  4 Nov 2024 21:56:00 -0800
In-Reply-To: <20241031202011.1580522-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031202011.1580522-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173078282454.2039346.17723469953189171218.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nVMX: Treat vpid01 as current if L2 is active, but
 with VPID disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 31 Oct 2024 13:20:11 -0700, Sean Christopherson wrote:
> When getting the current VPID, e.g. to emulate a guest TLB flush, return
> vpid01 if L2 is running but with VPID disabled, i.e. if VPID is disabled
> in vmcs12.  Architecturally, if VPID is disabled, then the guest and host
> effectively share VPID=0.  KVM emulates this behavior by using vpid01 when
> running an L2 with VPID disabled (see prepare_vmcs02_early_rare()), and so
> KVM must also treat vpid01 as the current VPID while L2 is active.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: nVMX: Treat vpid01 as current if L2 is active, but with VPID disabled
      https://github.com/kvm-x86/linux/commit/2657b82a78f1

--
https://github.com/kvm-x86/linux/tree/next

