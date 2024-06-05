Return-Path: <kvm+bounces-18940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E988FD2AC
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5979428633E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D369A1527B5;
	Wed,  5 Jun 2024 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cKJyWgoD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16DB19D89C
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604259; cv=none; b=haNTSN8sZd67xY+4vXs9/v/oAOkqO2lEF/N+gcXqkJofo4zGF1qmNJp7nr8V0C2MQWGCtGfi292mmtz5+i7n8uMEQr00U5v15ahnnrCfUH6AtnPKYdLLltaoI5YIApqB+KzdogWU3iK3WWUiw8FhVpatqUQY0zKBeD9Bg3B2Ygk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604259; c=relaxed/simple;
	bh=APoGev0nW09RxwJC2pdDLuNGjct11xtSUt4xIrwIo3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GLZ4ABCRv8RhSS2EtCdWTAhIrxCgRGzgCIdwChfV6G+8Ex2oXloNppoBQe/ka24ExcX6IKVwbPIk9eba+7dehLrKB60/iOzZ/8FG221QKfXUqAXde0gJUV1AILdCwp6/jOntxVGTlcNy85lrc5sMRwKm6eCDU4jckConTGfJgr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cKJyWgoD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78ea30f83so1408080276.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717604256; x=1718209056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rP7+NLwCyAxamIt4OQXosT5XI/QyzyA1B+gDunq20XU=;
        b=cKJyWgoDUaugA0Iu68H+xEoqHcJxaEFzY2UWd1CVb1Cq4uYWLAY8WC5fTKQAhyeqDT
         MBhxU8Z2wbuBb70PB6odqNW2ej7VKclP6CS6Kqok0JSoT7o2STBqBifTn3uM7+oNYwLU
         blr8cjSulyijab+4Ugl4uLQss4kDrHx1tHIRbi2/fWpbXw6/bsaaJM1JSUo+3l5OtTlB
         uLG+HD7TxTYQgNmetuZDgpewn1i8m966IRR4ynw1ZtCaOukCU9A//HvkugJlh91JAuCu
         KoCVOtd4eXpe4odPWfaduI2GkTwXWBqTkhtJ1uFhvcrQY9Z88GAPH97HD8kmt1DKeuOY
         tPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717604256; x=1718209056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rP7+NLwCyAxamIt4OQXosT5XI/QyzyA1B+gDunq20XU=;
        b=gEoDE7Oqvr/GRa0268VZ9y6z6jmgWHoPoi38SIEw41Dzo8XpvXJbi1WwwDRxNETJdF
         0o1Nktl8pWK82G19NpddUc46xsGJThlwSOZFjUkzSVRvQ8c/DZmyFfaimg6CcvsrS/Lu
         +hGW7cFNDS+5Rm6+luL1zs8CT+jqrwZcDBAlqtZbGexg2ceHu4FPOk9ZLpNH2Fukq6qR
         gFWnvQ1FMbiYtkgIGcFO5LxcL8Y7zCSHRnMx80Wc/hWzmx2JucaZhqa1Kjy1OkJcjNVc
         DNydblcjvJ6qaHwGrGEIUyeM3vIiVbFhfbYuZVEbN/QCRCr5Sg+RW8It+Cf7UAswVy6f
         gCQA==
X-Forwarded-Encrypted: i=1; AJvYcCUW5SmU9MWlzaNp3cu0ftzu1YEkqAnraMQ/o4ka0V632Lm9kPhxxUGBuwWpMQJZUrFRURFGHSG97B2sCOqj+S0ZzU0Z
X-Gm-Message-State: AOJu0Yw2sUqrSwm2Uu/z6iMrFw3yhV2noPT4w3d7iexHkRKTW2vI4F6r
	DNAzoi2X4lbNU6Skaq6Aw5BJhrnUmsmiVPvORHFikpzmQtniWHip/YSJkDOmEtSTWj6GuzTCObf
	/Lg==
X-Google-Smtp-Source: AGHT+IFdPaFFhfehsfsrMvkAdiySplkBVHzVLW2YR7otci4Qavrup4sxBtK5LpxOpWE474YzXvPB94/TAn8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:dd9:20c1:85b6 with SMTP id
 3f1490d57ef6-dfade9f3525mr14114276.2.1717604256654; Wed, 05 Jun 2024 09:17:36
 -0700 (PDT)
Date: Wed, 5 Jun 2024 09:17:35 -0700
In-Reply-To: <0624663e-ea7c-470f-ab34-c934a9ab31be@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306230153.786365-1-seanjc@google.com> <20240306230153.786365-4-seanjc@google.com>
 <0624663e-ea7c-470f-ab34-c934a9ab31be@linux.intel.com>
Message-ID: <ZmCPn31tAFumFS4m@google.com>
Subject: Re: [kvm-unit-tests PATCH 3/4] x86/pmu: Test adaptive PEBS without
 any adaptive counters
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Dapeng Mi wrote:
> On 3/7/2024 7:01 AM, Sean Christopherson wrote:
> > @@ -293,12 +293,9 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
> >   	do {
> >   		pebs_rec = (struct pebs_basic *)cur_record;
> >   		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
> > -		pebs_idx_match =
> > -			pebs_rec->applicable_counters & bitmask;
> > -		pebs_size_match =
> > -			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
> > -		data_cfg_match =
> > -			(pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
> > +		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
> > +		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
> > +		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
> 
> Since there is already a macro RECORD_SIZE_OFFSET, we'd better use
> "RECORD_SIZE_OFFSET - 1" to replace the magic number 47.

Very belatedly, I disagree.  That the data configuration mask isn't derived from
record size.  The fact that the record size is the _only_ info that's excluded
is coincidental (sort of, that's not quite the right word), i.e. if we want to
use a #define, then we should add an explicit define, not abuse RECORD_SIZE_OFFSET.

