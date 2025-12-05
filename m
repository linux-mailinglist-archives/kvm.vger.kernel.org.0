Return-Path: <kvm+bounces-65334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D40DCA6BB6
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 09:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 89205302F323
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6049F3090E1;
	Fri,  5 Dec 2025 08:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f/M9Wp9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9423195E7
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 08:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922472; cv=none; b=A0RN2YTtpLiI395Z+diOeQ20JGpXKzbkr8GQecxT/hxRnOYlhl/fRqPo3QBTxAOL0odmun7bVfBSZBXQtRoP8KfhAFaux26B0XLpUqnXb68YUXymNMQ8WILtpcUuVv0iArMjf1AbMBBEvm549TSe5KEX17EEfcaj3eYHB5ozxXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922472; c=relaxed/simple;
	bh=xTcYBJQxi0w4T+JDTmpVMvH5nLYXxAE9guuDCC948v0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thZHc+jAI1qieJij2Dg0xAUfQBwZxiyhCqQp/Kfe2MSKjN6efhbKVe3bW68W3MHQw4ZQam5kiwWhXya9vjIwrVxOXkUhTs5U9zudMDZgwO6RbqpBAdJFO4rMp4KDm3NT1UPcTDq9YnhYLH6JLJEUVtBTtacIa+3ZyLzvRgZa6gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f/M9Wp9l; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so18019615e9.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 00:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764922453; x=1765527253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Kx9Ltv1pcY5Hz+h8WP7H1C+6iHMhsoZw/NQyZvh7WI=;
        b=f/M9Wp9lRIpR7wu5nN85e/mgTB42z9BJaoqub/u4gRzRAt5zBKPIu+I+fXagaKnp5x
         ecyEC7fxYrx47pWeyuiusPaBvSxhKogSu0P67XyjnJumFb+pvVEG7sT2Upn13C9X6TAc
         oH/N9VyDQstkb6ywvs31POU7kNbhXZA7S6XKjhSw8tz+ZtW4MVaiX9m/aMY9f/UTFsuh
         DMOl04GsxVdL+qe0e0UIKvwNvIB7qoMvRPH7n/0lAJk5JOD5TPSS3pGOT+COCdhOyJsc
         9VrRsGCsQe3m9ZBT8SKkIiMBWn/xJBgkyroRZXqTQ9OoupBdI6Y4WmMYHxfncz3FlbX7
         F/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764922453; x=1765527253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Kx9Ltv1pcY5Hz+h8WP7H1C+6iHMhsoZw/NQyZvh7WI=;
        b=bT/enTxJBzZuU/FzH0q0/sgB/5yP84SO75NhKkVjDz5Ed/xPIkPDm8L2UNc943yYSP
         qOTGfuNfXfEDCx+RMc0wfc6CuipcIhfEjH+dHQokGH+pzdcv1puljVsPZ9eOtsht9g7Q
         aLShitPG1+hAtHL3hFcd9//1gFOUK68xCl9J+5wV04eDQSbtnD4BeM1oBsLivXEvrk+K
         rZOxTDykOYaNTKCx1Oj0vscV1/ba3DHx9KVuZauSnoRHBkNhpIxtUyA9QQwgAIJr/90Q
         xpB0yDPWwXeiqtRXZd2DnGlH5Q27ViYOF80495GmiwlQr2lKtL1+CjZ3pu9XFpWH4HJf
         lXdg==
X-Gm-Message-State: AOJu0Ywzt4dZV7V0knR4WDW02CsC/N9JZUN/cLpjOeqCNcyT7YnAtUIS
	81S9iC+QN95TxRjzsowOnVDtJbmIsJxVcTCkm0TA76NGS9jGvFUQ/azcW1OHo7MZfSJ2l8mlC9/
	4KJcaMq3AmSjy7sDurQDu7r+X/lQ6jNyzgFBDGsfIIOUyY2/rCRi0LH+V
X-Gm-Gg: ASbGncunXlnfZ2ZBlSM4F+LTELEOa9obouLq38k7/qURjWfpiiElBEADHxYyIq0TO81
	2TlQo2ZLuUItn+bmyFgyLPqMtDi/5Hgd/9I4VjtV2VnvsNt4aOpSxBAuzi4SifOr5ki68dFhlq0
	Oqucteeu+8MHI/4ptSmN83emHtgzHyqXxGH3sXOl+FbGQZpZ05rdXG2LdpeqA39nujRTCbJuNdU
	HGCW6oKyIbBZ/nBGdtg923wl4ilLDwoB7scK/LjZa9YxA+slBk/9EpYGRVCFjSykWejf68JoM+j
	ylyomsKty2+fIKdiX8XXyEnnewMs1Q==
X-Google-Smtp-Source: AGHT+IG1VFCCtdDGPeOm5vik58Q9CuPl8f7b1dT08ocRf8VcDf1ee+repW06lkqJ0Kz/JfrzL6vBq9hMgHjSfElCRXY=
X-Received: by 2002:a05:600c:1d0c:b0:471:131f:85aa with SMTP id
 5b1f17b1804b1-4792f24dbb2mr52134855e9.13.1764922452565; Fri, 05 Dec 2025
 00:14:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205080228.4055341-1-chengkev@google.com>
In-Reply-To: <20251205080228.4055341-1-chengkev@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Fri, 5 Dec 2025 03:14:01 -0500
X-Gm-Features: AQt7F2qWEEx9rgEIiy8eiSST5cuhwxxNvJFTshV1MbyPtURzqsWK_-OBwtvbppY
Message-ID: <CAE6NW_aDTVgFk1xv5CEjthQCXXDs8BQA3wQp6zmgpo_ug0iprg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86/svm: Add testing for L1 intercept bug
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry please ignore this!

On Fri, Dec 5, 2025 at 3:02=E2=80=AFAM Kevin Cheng <chengkev@google.com> wr=
ote:
>
> If a feature is not advertised to L1, L1 intercepts for instructions
> controlled by this feature should be ignored. Currently, the added test
> fails due to a bug in nested vm exit handling where vmcb12 intercepts
> are checked before vmcb02 intercepts, causing the #UD exception to never
> be injected into L2 if the L1 intercept is set. This is fixed in [0]
>
> The first patch just adds the missing intercepts needed for testing and
> restructures the vmcb_control_area struct to make adding the missing
> intercepts less ugly. The second patch adds the test which disables all
> relevant features that have available instruction intercepts, and checks
> that the #UD exception is correctly delivered despite the L1 intercept
> being set.
>
> [0] https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.=
com/
>
> Kevin Cheng (2):
>   x86/svm: Add missing svm intercepts
>   x86/svm: Add unsupported instruction intercept test
>
>  x86/svm.c         |   6 +-
>  x86/svm.h         |  87 ++++++++++++++++++---
>  x86/svm_tests.c   | 188 ++++++++++++++++++++++++++++++++--------------
>  x86/unittests.cfg |   9 ++-
>  4 files changed, 220 insertions(+), 70 deletions(-)
>
> --
> 2.52.0.223.gf5cc29aaa4-goog
>

