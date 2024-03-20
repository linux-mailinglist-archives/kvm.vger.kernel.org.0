Return-Path: <kvm+bounces-12315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D0E8815CC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00BE81C225A1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 16:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0C21FC8;
	Wed, 20 Mar 2024 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B2TYOo+T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886EA15C3
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710952847; cv=none; b=nb9URU6qBUyGWmhlcryhTFdzNG/sm4KnHwtqRaMuvE0D/lhQi7VQQmlQUZxNtFbvDB9bmIX1os3u0FMlR1MXYy6TT/YU4+ot57Tq9XNOkltFOpu1fILPSWCzm3bxZ1BdMm3dd7y37aFRpAK4mAFjOnVK4CSzPWA9DilXkt6Ebx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710952847; c=relaxed/simple;
	bh=IPFJcENiCyzyUJ0Rcq2tI05Ded+kvu7vtcAY8HhSnFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sHtF3rTDbyFvRwnbysEXilqWJHiMni+LJWpA1a8eZapZIdxRxqk/Bt4Uuc7WRgGSDkod1tDEsOSSxbLqVP3RXtcN30WQSVzlH3SV3ux0Ai90SdKANPgcSfyveKSzXCd/yXziwQZxhJC/T/sKEG9KS586gHVhjBRsa8NVEtxSQow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B2TYOo+T; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-428405a0205so377541cf.1
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710952844; x=1711557644; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E2Iioua2lyhsilXiJJfaF8CCrcEUXRoDq4VH/C+Uq1U=;
        b=B2TYOo+TB5/IzVY/NQHHP+S2PCrjCrzwDxoydNWzbz2sb+34SjrB7/daM35F6KKQYy
         m3rXSqNHJwuhvrZTTsxTjgYWeY48+ZH2w2Ei+aD5cc14UGb3xO0b8j2VYspZkL3TpR4N
         0jcwlzSer/4G/BcU5KrR2JbOxGFY5aw6v0FnNIJLNx8M8pD4SstnQ2GaoQd6BINXbgVB
         bd6O7AkiMWZNWwAdRHrJZwLLjsKzHqEVNqqOMfOtuTFUI27iopl3M7tDe/IrKqU+4rE3
         s4rhHP2rzauXe148UmHDNxonq/GTnUtM8XyvLbN//vNImbwPe8FKa5lPYMvF3VvrT0Cg
         3e+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710952844; x=1711557644;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E2Iioua2lyhsilXiJJfaF8CCrcEUXRoDq4VH/C+Uq1U=;
        b=lfquhxt5X1Qxg1bPVslfGh9qswIG+xPtDukCQBMxBrgofWb3r7A6ajSlAJWxHxOxIi
         7whVk/3XLC0Qeu8eMYQ3XC7oKmuKwL1a72/Pqytz/lg+1kheTQ2NOs1yzf1yZpR2DuSL
         XaGDc/WisGk1O+rKr9x5GH7qcudAyxTZIxaKGai6ki4b89P6mtDUw5cCs+dzBanKPb01
         0zI39WimD9G1dzveCqhXu4ZYi3/V3Qs/fG+GlS8gtDtRkMyZXOy+ApwhqUpqaeXirhUl
         NmdJG6Gh1aJ6JhlKnO8PQebRKfD5GMQwGRfRuU2oqHyRoITrNiyKg+LTj38orZT/0ey6
         HJhg==
X-Forwarded-Encrypted: i=1; AJvYcCV0eyG4usNk9Tl0xlFtWcBzcwvom+Z+sExxvh2sIZR7cCzar5h2ZYEp6MGRtDQN7rSLZ1YkKo9XsEugZ+7/67rup7v8
X-Gm-Message-State: AOJu0YzWDfk+B7h+1BQDxn7atbyaUFneQd+wYLPzCXuGIQ7iTcFeF+HC
	GzywowSo4YcW2pXtg1QgI8ovGKonLc4feLw8VuM102OR3uL57jkXo8Hf/rVa3Y98dpjV1Vsd1xK
	757oHc7quna9JJLlz5URdxqeBRhBF421G4s44
X-Google-Smtp-Source: AGHT+IGiVjjeu/I+qCPN7/5tTyBw/r40GN/5VRWHH4Ks7bnzHDezQwHcKs4lD6F55rSEQaRGRR9F3BFwXms+THBnfjA=
X-Received: by 2002:a05:622a:1904:b0:431:55a:57fa with SMTP id
 w4-20020a05622a190400b00431055a57famr221576qtc.16.1710952844403; Wed, 20 Mar
 2024 09:40:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
In-Reply-To: <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 20 Mar 2024 09:40:31 -0700
Message-ID: <CAJHc60ww7cOhtbWNp9WP7bxWKXCZtcT=6e4Fk2TaB63YqWMWbw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org, 
	mizhang@google.com, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	dapeng1.mi@linux.intel.com, jmattson@google.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com, 
	Kan Liang <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Hi Kan,

>
> +static void __perf_force_exclude_guest_pmu(struct perf_event_pmu_context *pmu_ctx,
> +                                          struct perf_event *event)
> +{
> +       struct perf_event_context *ctx = pmu_ctx->ctx;
> +       struct perf_event *sibling;
> +       bool include_guest = false;
> +
> +       event_sched_out(event, ctx);
> +       if (!event->attr.exclude_guest)
> +               include_guest = true;
> +       for_each_sibling_event(sibling, event) {
> +               event_sched_out(sibling, ctx);
> +               if (!sibling->attr.exclude_guest)
> +                       include_guest = true;
> +       }
> +       if (include_guest) {
> +               perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
> +               for_each_sibling_event(sibling, event)
> +                       perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
> +       }
Does the perf core revert the PERF_EVENT_STATE_ERROR state somewhere
from the perf_guest_exit() path, or is it expected to remain in this
state?
IIUC, in the perf_guest_exit() path, when we land into
merge_sched_in(), we never schedule the event back if event->state <=
PERF_EVENT_STATE_OFF.

Thank you.
Raghavendra

