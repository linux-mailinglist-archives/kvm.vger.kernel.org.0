Return-Path: <kvm+bounces-30626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 531589BC518
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BA781F21ABD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655FF200125;
	Tue,  5 Nov 2024 05:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zQSvdEAL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF31FEFA2
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786135; cv=none; b=QAfrRXPtD/6f7pqOepRcMI3hyDIbShkvJ1EqYyT/zNRlFu6Fv1yD7+jJzrlDNnwAH9x5orfl/uMp37Q0rkIqRrp5xGpXdrWiF5BvDKAgnJArCYGUmx94z2oDM+yvj93RIBjO1GiHR63tGEHQFs3AjthJDmorhJmkiTzXs80tG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786135; c=relaxed/simple;
	bh=EM+nXUdvDCm6N3UmMRTXiFNomsft+6ngsfGryxa8oRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SjruTe76kZsonFTWtd4dRPkzZb15AuYWLKt7jaCjnZ5odqElNCF5XKJII85yVQsifUTJeNvbeP8tRWsGJrkiA6mOfvPqTw1XbdL45NF/mCFTJAhkbsFQGWPlv56v/oozlNCmbY4YOGQqgspwGH9Dq+9t6/kGt0llOrrkBj8cJfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zQSvdEAL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20c77c8352dso45123195ad.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 21:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786131; x=1731390931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IwQ41DxPwHg/LBZhq9U/e3vXFnxJog0O/oye+eR+OCc=;
        b=zQSvdEALJVVEodFzTR+avoITMzlbcJr4bL04TyrBVBxoIYKkh048TiKQl7PF/bFmkS
         z2RN4Srn0zAfMqTqg4bJCEWuMFGQxVsvvxoosev8b05YDALsP4F6Q+NVPeBUhqieu8f+
         sd0t2NXhaQ2zCKtM46pXDSMx13lu79jtloGbr6O7rbl46NjRI8tNyXwt/Kf3pFK7RLJs
         Tr+f3nDsw6CVb9GjTFyo1Nl89gOLbueNowgaAsNp+zUyE0yms2TOeoCpL1IWFNF6rbge
         eovpeBMFlrvGxwk0tLW3NDw0cl2H3Bjm/zPR69xBCF/vB/HmtohivQeVqkWV3jyoBm5G
         JHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786131; x=1731390931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IwQ41DxPwHg/LBZhq9U/e3vXFnxJog0O/oye+eR+OCc=;
        b=EFgy8fBjVJzroCiBOkitArZ4NwM/VFavhYci3NYoc4l3Pog0IJ4VG4IPLFbhMFQNSm
         YwWin8x8UeEjMpMA2sppBUdxqa3CbMyDWcZ3Y/YNUastCwHuL0k0P8IEEa6K8eX384sD
         0tVe+UGkALBPME/FGT2/qTv42LYyQKf8MckbNLxAFSIc9ZztbXALKe5LKb3bVnSKYmBI
         zeCV8jV83H00JFmSPaV9xEzxZ1lhOt6SgEBAEwmKKvn1hZCe4Hy+nK/sW0i/8q+R3oG4
         mAb6Na/Ru5Mz4KRYnZ45FQ/nl7sPRqHSbX151jPqzac1fxLMGMwj24TX0o35zWA9R0y8
         kiSw==
X-Gm-Message-State: AOJu0YxKQBlZypRy5R+sxz+aVsOlzBiGWkY2gqyecZLLaPna4/U3DnGn
	wbgaUKetPPmuWlzFpb9G30Jxf6AHEC0aB39AwajEUqoRmUIuiyWD4SgE6gTj4XHjNvmUL273AYq
	6mB32W69nC/b6VO7FZpqJdIKKJZvF86PgGDWoZI0yYC4pQmgcT11Y2ZfksJoOriw38x3YhBDZ4v
	gfpWm/jzsBuBXuU5CGxA0iKIByFhYu
X-Google-Smtp-Source: AGHT+IEuUBIfr0pmpR1vDVKnUKE8uRFFxdiJcuGz5MS7Q3zeXILMN/DoM1JZEMxM44JWZ8BW2DwV5M3g8tM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:f681:b0:20c:ce1f:13b6 with SMTP id
 d9443c01a7336-210c68cf3b0mr1015755ad.3.1730786130327; Mon, 04 Nov 2024
 21:55:30 -0800 (PST)
Date: Mon, 4 Nov 2024 21:55:28 -0800
In-Reply-To: <172848588854.1055233.16718265016131437325.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241004220153.287459-1-mlevitsk@redhat.com> <172848588854.1055233.16718265016131437325.b4-ty@google.com>
Message-ID: <ZymzUI3HnkYMxyjk@google.com>
Subject: Re: [PATCH] KVM: selftests: memslot_perf_test: increase guest sync timeout
From: Sean Christopherson <seanjc@google.com>
To: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kselftest@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 09, 2024, Sean Christopherson wrote:
> On Fri, 04 Oct 2024 18:01:53 -0400, Maxim Levitsky wrote:
> > When memslot_perf_test is run nested, first iteration of test_memslot_rw_loop
> > testcase, sometimes takes more than 2 seconds due to build of shadow page tables.
> > 
> > Following iterations are fast.
> > 
> > To be on the safe side, bump the timeout to 10 seconds.
> > 
> > [...]
> 
> Nice timing (lol), the alarm can also fire spuriously when running selftests
> on a loaded arm64 host.
> 
> Applied to kvm-x86 fixes, thanks!
> 
> [1/1] KVM: selftests: memslot_perf_test: increase guest sync timeout
>       https://github.com/kvm-x86/linux/commit/7d4e28327d7e

FYI, I rebased "fixes" onto 6.12-rc5 to avoid conflicts in other patches, new hash:

[1/1] KVM: selftests: memslot_perf_test: increase guest sync timeout
      https://github.com/kvm-x86/linux/commit/2d0f2a648147

FWIW, I am planning on getting this to Paolo in time for -rc7.

