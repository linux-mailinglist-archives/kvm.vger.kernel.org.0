Return-Path: <kvm+bounces-15694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4CC8AF4DB
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54AED286E03
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6035C13DBA7;
	Tue, 23 Apr 2024 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F9A9Z/82"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246FF13D8BA
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713891816; cv=none; b=cZXq5tqcdqhuJ9i2luC1IJjbkRasNHtjpEyndyWzQNmm2RJKJK7DIqLgROLK10r6bkXCfPQmqk40a0s1WdpPE4Nph144bauwpsBaPRRpxZb9JJkSRvM/JKJyQGGHAHalJ8q4/eWxe6wDLsX1NH6iyX+vh9Vop30HJ4hgMf9kmIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713891816; c=relaxed/simple;
	bh=o9xoixdzamHVwV+JAQwhz22rzk+JkW3wBRWHkz/cgYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DBRroVd9rp6ZKMrzlQzRlPDInROUu5w13y8i6/svRUv6EIxwaf0KrZK+xBSGY4RPZwAwy9XkK5e6eJw3sn6DgbYc0M69giXGQ1bdelr5XwPIe/9CnSe4meGLB4pyoFpPFvZwU1xT8NDehSz38LAeOOBbGGlqkPQs3K7No53oU9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F9A9Z/82; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3499f1bed15so28475f8f.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 10:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713891813; x=1714496613; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9xoixdzamHVwV+JAQwhz22rzk+JkW3wBRWHkz/cgYY=;
        b=F9A9Z/82E+grWEq1Nbf+8OMZjwQPTDJz/AYZNtK+RcIGQn5NWlKChbu/dP+1y0MDCA
         09n1XTTjTKQHJ7XWfhG0MQN2HcCXwZZVtudRzNUQ/VWrBLoIMGY3n9sCYTZ+/HoBf9t7
         NsZbJcaD9ze4giTdDqgikcFjMZxAOXRvtcsNb81WEQJO/3dipBhwTOh0jBTMK/hj6lBH
         A6Ipe9F2hBtepfYsG5MCoCjSRONxPkTz5eeT7QTC1RyyGtCigStC2wMcnw4gnxm6KJuf
         oV5nOXK1TpSf/7svQ5y3cpA5ZD2H4N9qPfAUNv5+FDX13IWLbUIn+rx52FBIJm1TRvpg
         kOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713891813; x=1714496613;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o9xoixdzamHVwV+JAQwhz22rzk+JkW3wBRWHkz/cgYY=;
        b=XKazWsTj8/uU0GmrVBGW/cRlYUutwWF3wlwkhy0jnRrE5JKoV4O8Qh89cTi/QR3jzE
         bZAFj+pWsgI7NYHyW7m48p/eECHkzBV95ENk5Te/UCHKtZKc8EhsSSkg7m7IfaOzR4PF
         lOgikfzFCec7cEN6Adzw2hs9O6I3wUMlHkCaG5uVxI8SYe8ACAi/tlT+UNm6g5bEKzB6
         nu1xAGhj5Vc4VKY+LU8ZWhLhNbbbWmZieVgP+hA9tb0ucI9Td3dwFbIYO89hV1oR8Zag
         Rqc11CTm158n0d0HfV6n7bwj3oNOqLx2BXIwXSfdcoZbCTDCvTn32cumCqWVf7jnfzT6
         6BEw==
X-Forwarded-Encrypted: i=1; AJvYcCWbUSMR3ajhmRhXolOEF5p7VI0vNtcau3PQ/XKrzQQ7iIzSJ6esHa8c/+y1SNcJh23PzS5yofUuyCvpk7iGNELRZDzP
X-Gm-Message-State: AOJu0YwlgVVDiZuAAlN50VYR7KEQfq0vRCkx6GqK4+MrDzsLZpJUipu2
	m4pNYJQUYd1pFvFIAlzRAjBVngLfBvw3kayuN3BcwvS2KQUdek0mGfTIRbP+jxx/toWcUtvcnmJ
	mlXzglFjRhpHTC+En/g2PP/k3e9YUVUqQ8MRl
X-Google-Smtp-Source: AGHT+IHkNk+eRVsCXG1cexWzRfPbNYzRNhOHlM1lYyYp2XznI9Zqbvc/UpodHOa8Ojb+grhpOphL2W5/WWE9y6NnIyA=
X-Received: by 2002:a5d:5188:0:b0:34b:3e51:fe38 with SMTP id
 k8-20020a5d5188000000b0034b3e51fe38mr33455wrv.23.1713891813220; Tue, 23 Apr
 2024 10:03:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com> <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com> <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com> <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com> <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
 <ZiaX3H3YfrVh50cs@google.com> <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com> <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com> <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com> <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
In-Reply-To: <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 23 Apr 2024 10:02:55 -0700
Message-ID: <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: maobibo <maobibo@loongson.cn>
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"

> >
> > Maybe, (just maybe), it is possible to do PMU context switch at vcpu
> > boundary normally, but doing it at VM Enter/Exit boundary when host is
> > profiling KVM kernel module. So, dynamically adjusting PMU context
> > switch location could be an option.
> If there are two VMs with pmu enabled both, however host PMU is not
> enabled. PMU context switch should be done in vcpu thread sched-out path.
>
> If host pmu is used also, we can choose whether PMU switch should be
> done in vm exit path or vcpu thread sched-out path.
>

host PMU is always enabled, ie., Linux currently does not support KVM
PMU running standalone. I guess what you mean is there are no active
perf_events on the host side. Allowing a PMU context switch drifting
from vm-enter/exit boundary to vcpu loop boundary by checking host
side events might be a good option. We can keep the discussion, but I
won't propose that in v2.

I guess we are off topic. Sean's suggestion is that we should put
"perf" and "kvm" together while doing the context switch. I think this
is quite reasonable regardless of the PMU context switch location.

To execute this, I am thinking about adding a parameter or return
value to perf_guest_enter() so that once it returns back to KVM, KVM
gets to know which counters are active/inactive/cleared from the host
side. Knowing that, KVM can do the context switch more efficiently.

Thanks.
-Mingwei

