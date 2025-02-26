Return-Path: <kvm+bounces-39216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D85A452FD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB871189A4F4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1765121A430;
	Wed, 26 Feb 2025 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zMHw9PEH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E360C218ADD
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 02:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536406; cv=none; b=gy+pHfDItMXRNyVpyZm4t/OuThG5nEAgd+tGpmvef2WYGyFQSTUxZ858vkH6N2sl8WArn9X4dVMQ8C+fjl3PTOOwy6mb38AYa/NHNscWwGy8CVnwLLVbhz6SaLDTVy9/l/4Vj1pXXc4SyYajfGjMZlQjZHM5Qr21PC5rClQUIE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536406; c=relaxed/simple;
	bh=8FH5pIuvy1Jac6/lG3x6E2PJ8f8DqbB/+e+//FMv740=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sjxT6j90zmJlzqOtdqhQAFa/uRvbxXTh+G+KxeHXL3qlfznHJ9eGPsADWwdXPBI4eXYEOg70ePOsQbvONPlkfjsxmgMaiGcIOn4sNDWi9+n9ljwFGzqL0iYU82za4mYefe8A1doQ7IAZS42UVNpjnmQKuI+tlUnnCYX2tzoJbts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zMHw9PEH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe862ea448so393543a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 18:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740536404; x=1741141204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U+U3kxkwkHHzAe5cXbK7f0ULstgU63GdnX7RFz40oJY=;
        b=zMHw9PEHQu+hs+z7irRop0MvCnmM20rZkSxANkjqd4+mzO/jzXgx+eEQ4bKewLyYa7
         Xf1m8An14BKFjFFbAQ/lxwhoU0j3vAeQRoiA0si8XrKO+CMx9MLMm90uOU1qOOFSMdDa
         m3QsFDb2+GgBN3D6XuJ/ES/TQyOO0LUdaY1Yc5nVOGNEpyHSuNBx1IQsVo8sPPaZ4IRh
         pldFZzUVXm4iw4RwGI45QkpGbk/wgjrE5w6jYKSXOXhv7GE8K3Z1AJyQ7Wykp6tITdUi
         ZMs4a89ec5do7ktNti3YtNJUeqOfaRCOvW7ovHSFKKYqrHdnUdQm9BBnuf3DCHL6iHpg
         0zMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740536404; x=1741141204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+U3kxkwkHHzAe5cXbK7f0ULstgU63GdnX7RFz40oJY=;
        b=O2NzZBrqdhDU5kNu9N/PePc/j/6XD+KYpcQIHFvbfRg/f2s6PrGIjb+1Rm0NqaJ72B
         +bZYoF61eWneVZm5bwspSGXz8tAhEaLcQDtVf9Up27cfCObdJuhI5dPR6Ok9sb+ZiwDA
         EsnIxGyTlj+qRs3Zeg8oF4ACZVyJiwwt5RZwYtAPEEAENnQbpW3Sy0nFxSODG15Uayj3
         6gwKMSZZ9lBl9orvjMWgMJcmxHUklJW8F4ievaAvH6q7G6+iraPU5XzizMqA2RFx8bKp
         43R1693brSLYTahHWO8eseYi2wbhQ+LUPkrh5yi4iPjBwan6ya6wjVCFCwuIy46wgZ/C
         LXRg==
X-Forwarded-Encrypted: i=1; AJvYcCVWPKkhRIWO9HQdXj5XyEFWRbubWZVh+0AAGBbHytHpB/aZCQ5/F9wR+GqNsPcNP7OgQwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbyNOv+AxSgsNEbCWY8swPCoxBrvMoHjrDpk+ZpH2C+pSPg1vM
	1geF9Py52QFHEPf9kvCdZQum3yS2yDRq56DhP4Lv/VlxWJRmpJJfIWO2qlmFXj9bqt7ogA6ZI/J
	6zg==
X-Google-Smtp-Source: AGHT+IHv0DOH83fHjVuw42bSimWjWgTNGc2uJt+qXrf5Xmz4kGUc9ioLEA4EM3FcRkNofpV39I+3+EFaEg0=
X-Received: from pjbeu5.prod.google.com ([2002:a17:90a:f945:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6cc:b0:2ee:ad18:b309
 with SMTP id 98e67ed59e1d1-2fe68accf77mr8037822a91.3.1740536404233; Tue, 25
 Feb 2025 18:20:04 -0800 (PST)
Date: Tue, 25 Feb 2025 18:20:02 -0800
In-Reply-To: <Z753eenv5NKkw2j/@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250208105318.16861-1-yan.y.zhao@intel.com> <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
 <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com> <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
 <Z750LaPTDS6z6DAK@google.com> <Z753eenv5NKkw2j/@yzhao56-desk.sh.intel.com>
Message-ID: <Z756Usy6JNkf43PP@google.com>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Yan Zhao wrote:
> On Tue, Feb 25, 2025 at 05:53:49PM -0800, Sean Christopherson wrote:
> > On Tue, Feb 11, 2025, Rick P Edgecombe wrote:
> > > On Tue, 2025-02-11 at 09:42 +0800, Yan Zhao wrote:
> > > > > On the fix though, doesn't this remove the coverage of writing to a
> > > > > region that is in the process of being made RO? I'm thinking about
> > > > > warnings, etc that may trigger intermittently based on bugs with a race
> > > > > component. I don't know if we could fix the test and still leave the
> > > > > write while the "mprotect(PROT_READ) is underway". It seems to be
> > > > > deliberate.
> > > > Write before "mprotect(PROT_READ)" has been tested in stage 0.
> > > > Not sure it's deliberate to test write in the process of being made RO.
> > 
> > Writing while VMAs are being made RO is 100% intended.  The goal is to stress
> > KVM's interactions with the mmu_notifier, and to verify KVM delivers -EFAULT to
> > userspace.
> > 
> > Something isn't quite right in the original analysis.  We need to drill down on
> > that before change anything.
> > 
> > FWIW, I run this test frequently on large systems and have never observed failures.
> Could you try adding CONFIG_LOCK_STAT=y?

Will do, though it'll probably be a few days before I can take a look.

> With this config, the failure rate is more than 90% in my SPR non-TDX machine,
> and 20%~80% in my TDX machine.

