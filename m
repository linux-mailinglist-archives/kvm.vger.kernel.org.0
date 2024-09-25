Return-Path: <kvm+bounces-27415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3551985793
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 13:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B963D285CF9
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 11:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635701474CE;
	Wed, 25 Sep 2024 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnJS2904"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E0F335A5
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 11:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727262293; cv=none; b=pEG/e95rWBEMTIcyMnS8jy/ms0fulyzKILZeuTVaeLvoJ9itplR0Om5lRvg6rZTrh35H+r0UkspnmxABqUySqN7JsA2uE7/kSmF5+VstxK0/ERPbvL58y7hzdU4u+aPeM4+xjmpyRRzd1guOeim0FTMU1QS3l7F18hyXMeWeAKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727262293; c=relaxed/simple;
	bh=4mTSjNe+7yH5jk8z+uv1VxR1vgZ0gnWMbo2mKTCsPC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RhE0T0Y52SkHJ3YbQUTLbZY361OOQUa258Uy8aOiS+iHRQAObeo0J7kUslcHSwRFufYv+r6qzRlHfddvXbhp/pSUk0XWRu8lEikR6Pz+GOwf/6VFKPLkuG6XJLvedh5sj2Cyy107kp9h4EwiwMhK1yu3hwtGHLXou5Wmn5zhDfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnJS2904; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-45826431d4bso46203801cf.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 04:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727262291; x=1727867091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f3QwF2q/Skq7fz13dE6HLbzon2hB22ZQ3sW+CQbjSQU=;
        b=jnJS2904zaK6Ml1Qmtdqeb2M/l/LvlV0JW4icjqstUBAEV7/sp+9JRKgKetohhpqDi
         TBp4QM4bmnGWfhqryQXTk6QTYNZ3p3djRIdUUFW6M9QWRbskotIgcT0+uiL39iozUGP3
         ZmsE6A2koxoLyTcmLANNFh01sGEhow50ugVZbSxxp8+sNFUFj3gXRtnopfbe8B+g+2pH
         C0AXzMVFQL/Dz0CKCGf+qTW7TeT9uSfeylllsoI1ucc9m/2c2Y8srDSc5l6U0wwsCW3a
         hGZBVzyRH82x0yE5ly2Mme50nRRm1FXD6tqkIAwNQX8HfaXrrmzfg61bDp9+3AOcQysR
         rOBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727262291; x=1727867091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f3QwF2q/Skq7fz13dE6HLbzon2hB22ZQ3sW+CQbjSQU=;
        b=iD5/xHOGU/dZ6H6N27QjHF7eXsFpkWTm65eaVEB6IQlH5VqbsGnUa724qj/LFapj6E
         R75jca2KbkkSUBdEODP0E4hlhYUJHmNgPrboqHDdeFCwKnovqKm63Tvptj9MlV+eesjK
         WCVgAM3qTjK02UBsFhEwnSASJJQyxm42xtdZ5eWZPgHzR56cEwM8jcsir/GFg+ydvJ17
         VajYegjsPpdiR3CdkWH0xtz9mHJFGXctV3Z1W5rL7pL3+ys6hVnedwd040//mzCve0Z9
         ddV2SteuWx//H/be0OLWzLRv+VddRNkx6e0zRXUiPz7PhTmsFzKMmciK7ksDbRrkSqLJ
         Db8g==
X-Forwarded-Encrypted: i=1; AJvYcCVPV9tlBfulLXtiIrth4BsqK6KipqZyRIZrvz+fxcalQq7JCSD8KHyl9C0FeMcEBBonCrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCsK0YKDVccy3IBeB6unPX5EcG4cQaGf8xTV8niYIp54aA0heH
	HO10iNCHKRU7I/YCTlGWHDYaRRoBYEOQbDHd7am7jBilYPsQ97+Vf3gu1DVeRG5WFcvvBNasVy9
	51gRMU27ODZ1BjsWtPB9HVffiM0Dthvdge8gQ
X-Google-Smtp-Source: AGHT+IF8WiIvUTGbGx8K3g3Qj7TGWZHnCSivOTa2bmhXpPp3pdx24k+5JyMttKT924MJIdYsJvYxOOhs+xqkrhWZUkk=
X-Received: by 2002:ac8:5d4a:0:b0:458:2a05:6b66 with SMTP id
 d75a77b69052e-45b5e0af268mr36374701cf.55.1727262290665; Wed, 25 Sep 2024
 04:04:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240911111522.1110074-1-suleiman@google.com>
In-Reply-To: <20240911111522.1110074-1-suleiman@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 25 Sep 2024 20:04:37 +0900
Message-ID: <CABCjUKCbsm5xywfG-jvZcHssgNcPk2B2h7n3jbSY6_M8p3YxSA@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Don't try to catch up excess steal time.
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, joelaf@google.com, 
	vineethrp@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	ssouhlal@freebsd.org, Srikar Dronamraju <srikar@linux.ibm.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 8:16=E2=80=AFPM Suleiman Souhlal <suleiman@google.c=
om> wrote:
>
> When steal time exceeds the measured delta when updating clock_task, we
> currently try to catch up the excess in future updates.
> However, this results in inaccurate run times for the future things using
> clock_task, as they end up getting additional steal time that did not
> actually happen.
>
> For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> time reported while it ran. clock_task rightly doesn't advance. Then, a
> different taks runs on the same rq for 10ms without any time stolen in
> the host.
> Because of the current catch up mechanism, clock_sched inaccurately ends
> up advancing by only 5ms instead of 10ms even though there wasn't any
> actual time stolen. The second task is getting charged for less time
> than it ran, even though it didn't deserve it.
> This can result in tasks getting more run time than they should actually
> get.
>
> So, we instead don't make future updates pay back past excess stolen time=
.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
> v2:
> - Slightly changed to simply moving one line up instead of adding
>   new variable.
>
> v1: https://lore.kernel.org/lkml/20240806111157.1336532-1-suleiman@google=
.com
> ---
>  kernel/sched/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Friendly ping.

Thanks,
-- Suleiman

