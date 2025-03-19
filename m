Return-Path: <kvm+bounces-41472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB87A682F4
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 02:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E94043B87D6
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 01:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD2424E4B2;
	Wed, 19 Mar 2025 01:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T7JstgnB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6592248B5
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 01:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742349403; cv=none; b=i8T9tMhWMOWYiyTMX2V8j5IXP5uD1yLvS9ORd+zLlnozCmAy86PqiRZF+IoXiT5af+pR79Ew1aC9Q1ukzWl2yhKox4RFQ/bIz+gFvCKukaTjVSCVONQ/RIsKsZX68CK2DginCQimEt2oW4abwsELel6QqJ81ROFJf/1ZumK9F8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742349403; c=relaxed/simple;
	bh=ouX3i3BlIK9xeWSAx5idopZ4sgifcAwYYnVE/GH5f9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HaocWgPYfqmDoYLvZP33Z/kCe3ydSCTGHWkSg0KiHFWIu6tLaKUzTIlqbaYgM0ZwBYzVeZrMDsh5aQwBJfWRkEYLMGZzcKNMgvjyYxgVBruHesoIg4OKf500zaY+1B5A0irkjIEUyHDJDAjwV2+NNVjtoGWAoHbSVA+YG3ZJ8pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T7JstgnB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2242ac37caeso49325ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742349401; x=1742954201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouX3i3BlIK9xeWSAx5idopZ4sgifcAwYYnVE/GH5f9c=;
        b=T7JstgnB/xRiX0DSrBp4AWsvGOqb8QhG+H8sQ6huA0RcTPOmTV+e6mm0XcSysUAi/6
         nhDA0YSjh4gki4xaPFzNBdW/WWD61/vUz+Q+wpApWQH3CVpGBJRBSsqV8iIGo6MIC8EI
         Grkw6cMDFFsd73zy7JwqI6gjBl/dkTqVv/blIDP+OhMvcZVPsRZc7SHHzzbBY6vwzlZW
         agZyvWTci/qvsIPfON0ftgY7dy6b+3plM1NG/taYYpBM7CgYR+D0c63wH/GB6n0/NDAz
         oJGamZUESLZQtmxwfqkXHcpoIHrk1DGJ6ZhgN98nBBr3SOgR/jhlG8qIHSmHKYoB8dnD
         lZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742349401; x=1742954201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ouX3i3BlIK9xeWSAx5idopZ4sgifcAwYYnVE/GH5f9c=;
        b=dq7at9UImFu0wBpymMCPL+b0qA7XE7dJvmbEHdbcRKE36diTjJcJcIk+pYHEV0bEFl
         7Ccic4bNMi2popoiK5XwHb6Q13pBPCx+X+t3aR8014OL1ee3hw/xcpBRwpDKDw/asKfp
         C4/Ckmug4NqmjmfUBjmsWG99ZsUCnSFT8bMtD2wX5P5SQNuTZtsdk+UljGYjQdUH6N5b
         FFK8pXGqWwjenvW+wv5sKMJ8RYPiWp83ahwtoSbrl5JnTfwZzs3/4BDJfh/0rijQ6LZG
         50Fs4lkfGJFaEdHYAvBvY3Skw5EGZCifxsg2sOeFxvAOyN2UmfrMFenPspZCgqL26GI3
         EnXA==
X-Gm-Message-State: AOJu0YwBuTkWjD2bveO4LqZoeIvy709bj+ONZatERrVKpHFEtIkg2aZl
	Z+ZtNpHXIMO2SBLZxWfbkDD0bGXm0Vr99VK4yylhuorUjTQrEZ5vvpGmzw5XoCJckXUsSj00yC9
	/Jp4VxramVbvJW74pZi17KLQh855oMEVyyT1r
X-Gm-Gg: ASbGncsynI2aXiRxY4lThYJ9lFfRFnRiau+8DMFV/UcOHekV0pgX6PSwJ6lTvgg3sdI
	/s/VjP60gHuTt4QY9nCkHvPE1o23s8sCx6aZuBMeRSReT2KvwczXxHzpNZ9z8oaQFODUvZ9dHc1
	mLRaH++envYDIO6727y2YtemOWng37fQsqCuZpShPFQwiziysVsCNLw2tGDp0=
X-Google-Smtp-Source: AGHT+IEJfip408CG6iLcuESpdEX6gT3O3jt9KVpROf4xrnd1IJWORoDLVoYajUjuvtz9nQ1FFnBPw2N1ZUl5Hrds5uA=
X-Received: by 2002:a17:903:94b:b0:217:8612:b690 with SMTP id
 d9443c01a7336-2264c5dcc70mr366545ad.8.1742349400754; Tue, 18 Mar 2025
 18:56:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319002334.423463-1-seanjc@google.com>
In-Reply-To: <20250319002334.423463-1-seanjc@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 18 Mar 2025 18:56:28 -0700
X-Gm-Features: AQ5f1JrOdUEH-YRODraRYAQAbzhFmnSc3WUD0U0BmIDaDjaSw7Ab2iN7Zw_Sbq8
Message-ID: <CAGtprH-HmtdyNZnRn3UjA-pBYaBBJgUS7UQSd07PDW94kdwufA@mail.gmail.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.03.19 - CANCELED
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 5:24=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> PUCK is canceled this week due to lack of topics/interest, DST difference=
s, and
> far too many meetings on my calendar.

We would like to discuss base TDX KVM support readiness for the 6.15
kernel merge window in the next available session.

Google is looking forward to having these patches merged soon.

Regards,
Vishal

>
> PUCK is canceled for next week as well (03.26) for similar reasons, in ca=
se I
> forget to send a notice next week.
>

