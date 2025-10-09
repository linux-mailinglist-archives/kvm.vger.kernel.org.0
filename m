Return-Path: <kvm+bounces-59742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D06BCB262
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B3CA04FB131
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2B428751A;
	Thu,  9 Oct 2025 22:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jAy7spK8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21D924113D
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760050288; cv=none; b=cnyYwqYinaQLUNqqNu0Zjtaj9lvT9ybopVs+ftqaaNp5ifSDKe/OcXwwAJd1/lvX5+9TpgWQH6H76TwBmwevlCYH6mq1Oi21Yh3JyRtf9ixsm1VaUlXPVuvacZvh9yJIz8BunHeDuDv5DpVXg3Ce8UlMUJMdNXXpJQGWHpBD0uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760050288; c=relaxed/simple;
	bh=7aZKJbyybiA6GRKTswtBPQVXNPD6r86d4HvmzSEnrPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UuOqqQSSZQPOeVcN3vKIjUor7xLcUNeRIT6pJkNeJqu0L9KW2Lwd5XGABN9LMDJXISTbDU3FVIeQhv9t890UP6UAcnw2YqBEnP4cPGbQXwqs0vT3FhStvK+/+6Z4s4/ICMeI1pfaLPc7wZoxSQPpju+ue3AyhRIkzBFmcLAZ85k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jAy7spK8; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso2032a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760050285; x=1760655085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRquNDSkjReozwM8w5z9laIwoCO0GSB+Y0DqaHKkPdY=;
        b=jAy7spK8fWh4ZQkArg/QJCsghOetPY4Kv17098hHEgcyLsK/hTnYlaE0ULWqAO6Onu
         8le0SA6beDpyVSu4agjRQlij9lUJeAAdioFiA86VvU3F2mLRlqx805cXpHVvnq7aMXeC
         F6tWW7RRzSO/F+7eHIR77R20LrDvcdoCONkWVxJb0WcX1jOXsulaqs3hSzxQBY+waLRs
         2tqNzKOkUULgSOygxrQ4sVrXUozJaZ7pkzNTcrJ7jOEqx82A+g9GO+P/36UIGkadxX0Z
         8V2k6KfiqvNlC041j256H9O7wYcsbqyi1FlD1E3cM2rXKx5cwJvBql76IBuE3pQ4flfq
         SAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760050285; x=1760655085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRquNDSkjReozwM8w5z9laIwoCO0GSB+Y0DqaHKkPdY=;
        b=dzbPFNUutpMrcnky20jBCDd7Tau7lkygCVR8wN92Iqc3o0jvFh2mbzeWAfFAic5rEm
         xApU8GMtzts0O9xgdKB/BtBNba/LiUEo42+zAAqqLEMgx66+wKt1jE04L7cz0na01wbJ
         oFMEN3yx+XGbVyi4rVwkjGPa0nM0oY53VLSl/2rBq2AJaGiMdEkimZHoZjuZZSs7pmPY
         jmne/Cf/BmeDhy1h+5k5Nz8QNk8PGSo35b82AjRutLoNM2Yem7lbkyIQjuhjC45PqU8o
         Oj6uPybzSUvgSHcG4CKk48n7mnt0bvaZmD+tRTlwunEnnE9G+Mw+787u1jr4aJ7amnwB
         0sYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAM13Jtetw3PZrAG6CEXsfL1Xe5yMqR7P/lvN7qZ2X7mkgApkdfh23I9PQLNZeDJ9gRcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNPjyGlZwypEj8u7SXT9TP9vp0WNu9R8FjaXOILQkW5fiYqPNM
	rnxazc+1/c753vMnSFl7eo5vMoc05yevw1AwagUkQIpj3InI5Fw9rWjNWYPvdr7tlGcExtrTClh
	wxebvTvGI5fRBRxojpggNRH8IqwnNRvb5H7RxmSHS
X-Gm-Gg: ASbGnctWPmVlFb09YWtviFLDMMFEf3fUjtFUWN/wXXSWV8APMTh9pOGNjFqo0jkBkH3
	+fr5LQNsWnAj5E93EFfSO59q45WRjmJoG695ru7rQrqf7HgrH2pfLuVLIYhHV3he+lz1gWVj7yO
	KY29JKHfwSFC6y9ao9Sc/xNBetN0QM9FAfQFAXjJhi2/lScFHx/eBKHaTQkKFRZUTppiELgoJIc
	nvE6glcsGjluUQEXFe4T2dEegEUvGi6juygK5ZfVc07FD8d
X-Google-Smtp-Source: AGHT+IEHFLnEHNywvEzNEtdVs3WgWikpHRuWCajMSODPTnzUEkgN4GSZMuBA01mgfqW2pcRrsssSZOK47nb0K27gWYc=
X-Received: by 2002:aa7:c397:0:b0:634:38d4:410a with SMTP id
 4fb4d7f45d1cf-639d51d0407mr299985a12.2.1760050284823; Thu, 09 Oct 2025
 15:51:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-5-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-5-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Oct 2025 15:51:13 -0700
X-Gm-Features: AS18NWDEHkKkDPLd9VdqQ9FPOQ1ms29elU0IRxQLarOI1HmjuFRwGgjzCWZ8Dlc
Message-ID: <CALMp9eRv3nraPfKLExX=cxhqSrShg=74gMkYh9R0jerhG4tt-A@mail.gmail.com>
Subject: Re: [PATCH 04/12] KVM: selftests: Extend vmx_nested_tsc_scaling_test
 to cover SVM
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:03=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Add SVM L1 code to run the nested guest, and allow the test to run with
> SVM as well as VMX.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
> ...
> +       /* enable TSC scaling for L2 */
> +       wrmsr(MSR_AMD64_TSC_RATIO, (L2_SCALE_FACTOR << 32) | 1);

Why set bit 0 here?

