Return-Path: <kvm+bounces-56997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A3CEB4983A
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8543D7AFCE2
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 18:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A5131B83D;
	Mon,  8 Sep 2025 18:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jLts+UE6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEAD31B100
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355833; cv=none; b=kBymcd2TqG5xKHeDTyHQQzXoIl53f6d4g9PvDs9T0M8JJxlFgyofRBxcf+9Rp8AVcyi3Ycd72I3XcdNf0SpLH+9TgYssAfKCdt3csceGBBr1H2wtzP6PwbxCgV2a4BZ2h3TyxXsSFTpTQFM1t9SFHw9ZIkkkyA1NVdsVLEXy0SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355833; c=relaxed/simple;
	bh=Plw9JR/aMqfPdB27PDwUiGPqBgnuI2/PGE1uxMuCVwM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p021XSIwxoYXBSmMc+T32ey9/YSQcEhRFFUqghW0hUoiojm29Sx8WN5TbsYuK4PEGAMD8uu/zrn3YtDlTcboQ0d6vK8dxjDaqz933M0HQtvii77sQY8RBzn8M8coWuOKF4k1DoD+J85dgPyKB9A13iVm8tRZsMKpqSw9wk/OM9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jLts+UE6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-329b750757aso4299633a91.1
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 11:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757355831; x=1757960631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1nSQsxLZOUXb7Htk3aEKe3ifM6QfGlXxpSgXrbf3nV4=;
        b=jLts+UE6wUAUSXj6FIHzwd81OI5W41rTTiDnkiGbbg6gUbPVYMeeVaRAYjRaSndsdu
         OcVp4NMs9SP222OnFkdYChEVh4xLWg9jX3sZeT0kaVez9l+yp6OhZjvTFRxbFeAyVfwl
         8ENqX7go0qWutV9fSLAfu26L5C4/2EQD3414Xk7/ThY4ECVqPTAVr20SyVBJV+WEriLv
         TP61+VRSfao6UY/RZW5GL9AiJVbRUIYUp+deK+0WJSXf1uvwyR4cP36O99Tx2dIRxOG2
         MHEEydn4wyOqocoZlVL4UA26MQa2SrMOmN3qp0aClnkS1zcZSqXrFe4ntP7P2KIs18mK
         Q4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757355831; x=1757960631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1nSQsxLZOUXb7Htk3aEKe3ifM6QfGlXxpSgXrbf3nV4=;
        b=hhlh2LcMM8dTm5thcCN0fcJWzj7zl64qnMqQhOKc+Br4w1w8uJyTYn5rOUt57KDhOp
         Rn735n6I0aMlYdFlb/omTlgAijVhNQOVnJatmOjxw/0OitD2LqmSQHwkkfEDqA/qLgVb
         U1YqQPLsGy7WGp8zLI5UB6yBYsW65uH6Ndn1K5rfWiZ8UaWje8wCY8wVQ6aX81ZnBCHR
         ZkANyAZ5H7aPGOvvGSNpAh2LA4JuyTkAoiGIl4P2on33TIwMDsNockKAl6otnSqxq8BN
         O4YnbTUSpGB7KoPIHNbaAfEQHorHWJJ91Na5TN5MU94r4HDBZFQKVqtbmVnutLI3S1pg
         +B8w==
X-Forwarded-Encrypted: i=1; AJvYcCXUzBcgRWpneUtK3uFaBBAJaTAXfm6ikK6v10/Yq6T2LAc6Y2wB7JAMksDt65YHWVX4Dw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMmpbqsguO4nQ4LZH7M6Cv2XeFxe54nSQKMxJi4hWM47qzYhUP
	Yniqxb52//6XchW32Y6FJYuTzNA64Ix4j6GhupiqZ6o/ua4JQCtv5Rb2NDf4RUfCb68E8le2wIu
	iZAFhYg==
X-Google-Smtp-Source: AGHT+IF78R1uV7x1ogjmInLr/cHkHlP92Oatdcz/yCLS1lFHwz0g8eoZ45c4cQIVzgzl4K7+nwozoFhZcTk=
X-Received: from pjbtd12.prod.google.com ([2002:a17:90b:544c:b0:329:7289:8bdb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fcb:b0:32b:b8d2:29e0
 with SMTP id 98e67ed59e1d1-32d43f82685mr10534524a91.29.1757355831249; Mon, 08
 Sep 2025 11:23:51 -0700 (PDT)
Date: Mon, 8 Sep 2025 11:23:49 -0700
In-Reply-To: <d378c6b6-68ba-49c0-b480-5d3dec9dc902@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756139678.git.maciej.szmigiero@oracle.com> <d378c6b6-68ba-49c0-b480-5d3dec9dc902@maciej.szmigiero.name>
Message-ID: <aL8fNdpoEuSERs-G@google.com>
Subject: Re: [PATCH v2 0/2] KVM: SVM: Fix missing LAPIC TPR sync into
 VMCB::V_TPR with AVIC on
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Naveen N Rao <naveen@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 08, 2025, Maciej S. Szmigiero wrote:
> On 25.08.2025 18:44, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > 
> > This is an updated v2 patch series of the v1 series located at:
> > https://lore.kernel.org/kvm/cover.1755609446.git.maciej.szmigiero@oracle.com/
> > 
> > 
> > Changes from v1:
> > Fix this issue by doing unconditional LAPIC -> V_TPR sync at each VMRUN
> > rather than by just patching the KVM_SET_LAPIC ioctl() code path
> > (and similar ones).
> > 
> > 
> Any further comments there?
> 
> The fix itself is trivial, would be nice to have it merged even
> if the reproducer/selftest is still under discussion.

I'll get the fix queued for 6.17 this, I didn't get much of anything done last
week due to KVM Forum.

