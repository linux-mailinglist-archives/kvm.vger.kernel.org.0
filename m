Return-Path: <kvm+bounces-24562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED935957B1C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 03:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 938271F22F26
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 01:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9F41BF58;
	Tue, 20 Aug 2024 01:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VBLER97S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167603D6A
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 01:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724118385; cv=none; b=X4xZjbn8dJtGJBX+Se9h7hO10siVHen17pS0JsupOYEkTK3Rh8fTd+8Vo2tMuv3ca1LMRbrVsrKq9hTtqx337dNAe3VPRHvoDH1g2ggElzTXAqxyaJum57Jeq1HpIjdFNkX9FoHlc8Fo+QnED5OBe6kf0q9w6NnZtbCykQJrUi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724118385; c=relaxed/simple;
	bh=NLGXyzyDRCMtFVsCX31SlmRX2OqGRUiNPEeUGshVGe4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjVTfGXV0FjCnqkOQjgw+rpdOeKLMu2v2IfqDMoqzrJw+V5c3LNMzbI1bbg7o5ZP/UlsevUNnNP9yCnPyUOdPXA+XwRmRiWvaycpoQ9oc77dVJ0k9xA/G1+AMatBFV7ZI5GGdYYuxLEjhubmccLiE3Q9T9DmE+VPvRlWUdZ/STY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VBLER97S; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-44ff7cc5432so38560911cf.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 18:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724118383; x=1724723183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLGXyzyDRCMtFVsCX31SlmRX2OqGRUiNPEeUGshVGe4=;
        b=VBLER97Sewr+qmrTUsVjbhJdDzMgAQNFmzwxJiV0g2LHP6+gHC47TuWFBEw8QFQ2Sd
         LjDz9bMPs+YEPv6Vo6ZMVjP74DFx+894rtCgqlrxO9TtkvFv5ZBqiaI3R9Ub9GhCLTCC
         3WHiEW4nVdMe9SHxul6dAbfy2yUwp83thwLcz7tafMfy/lWjqdEl06SrLA87J3DJ749/
         K8aEQCi/fV8H+nuzs/K2OXeEBE/tfty3I3OH2CxrENp7WFSffY8IiRkG96Ji/cndFSbq
         j3/VQ0mxP0REnbZMDtaLrfB0XG8x7MLhXj1hInuMrzNyo18GrBjAG8PJe1KkP3beEFN4
         XQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724118383; x=1724723183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NLGXyzyDRCMtFVsCX31SlmRX2OqGRUiNPEeUGshVGe4=;
        b=uNv4eq2ADbG631y+b16TpsbdAbwZHVxArAvjkYUTWCkgF7Dth2nWIBnPGly41iCD+o
         N4WX0WHpNsxfR7gRaWiplMpUxIXV3Ap+Nzfpkysr2/xR2KDy7tCzDQ3sOJ+qYfYf5dqX
         dTC7tEyhXVFmZkzXiz0BmqGHQt/dYwgC2ebQycPhLwh1Du4Ei7GZgBMPR8uUQEUEUwv3
         uO6PfU+Mmo3FSo9OcUbi26MhwcLX24HclOh8s4amW/PS5QfPG2YcCR5zqC9z75L8LgAv
         UICkyvkh8+NRhBl8npPBU+ogDV2wyFgHAVRT14cYTLF7TIZU8s4tVqZxevBPPFzggoew
         SyfA==
X-Forwarded-Encrypted: i=1; AJvYcCX088u9qSZwaMB61yJYTcD2uEF6WJQI1XbOW5eVAvJxJTv11/bcXIgQF7pH6l0hYxKoIv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUvoO5ukovoz98/V1cMrjqBvda1jcq/8eEudzioECrb/1oL3F9
	IH49L/8BjvcB0LEkr916q2PHuPMvK4KPWBH/Xov+TWq+9LuR0nbMmKPUSAADK7ejPMgEJz/aewv
	O4ag5zvt4rJhErgKIOuwvZvlC5DmuX7JK3evJ
X-Google-Smtp-Source: AGHT+IGPb3dLfD9raq+gJcco+vCZhESSKSc/TL2rumYK9styepg9BQ19KUfATIjpX/4u48oIpmni43L+UJMs61R8/As=
X-Received: by 2002:a05:622a:5c13:b0:447:ee02:220 with SMTP id
 d75a77b69052e-453742b9ee9mr166792741cf.30.1724118382851; Mon, 19 Aug 2024
 18:46:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806111157.1336532-1-suleiman@google.com>
In-Reply-To: <20240806111157.1336532-1-suleiman@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Tue, 20 Aug 2024 10:46:11 +0900
Message-ID: <CABCjUKA1nm+=eiHZu-0g5qstko9XdnwbJa3YgowV=L1t2Qa5mA@mail.gmail.com>
Subject: Re: [PATCH] sched: Don't try to catch up excess steal time.
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com, 
	vineethrp@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 8:13=E2=80=AFPM Suleiman Souhlal <suleiman@google.co=
m> wrote:
>
> When steal time exceeds the measured delta when updating clock_task, we
> currently try to catch up the excess in future updates.
> However, this results in inaccurate run times for the future clock_task
> measurements, as they end up getting additional steal time that did not
> actually happen, from the previous excess steal time being paid back.
>
> For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> time reported while it ran. clock_task rightly doesn't advance. Then, a
> different task runs on the same rq for 10ms without any time stolen.
> Because of the current catch up mechanism, clock_sched inaccurately ends
> up advancing by only 5ms instead of 10ms even though there wasn't any
> actual time stolen. The second task is getting charged for less time
> than it ran, even though it didn't deserve it.
> In other words, tasks can end up getting more run time than they should
> actually get.
>
> So, we instead don't make future updates pay back past excess stolen time=
.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Gentle ping.

-- Suleiman

