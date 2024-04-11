Return-Path: <kvm+bounces-14357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 937698A21BC
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 00:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EDA0284F15
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13A346BA0;
	Thu, 11 Apr 2024 22:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oLg0DMph"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915A11DFE3
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 22:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712874648; cv=none; b=lWRezyp7U8CVU6+WVwANt09s8Mrd3Vz6sx66jxGkG8QRmC43gzHx+vc8rNVRYSwCBSGbWQ0SnP4QzosZ73ufwGwHEKuBgy0bCV3whZl6DV2q5bVkqGDhr+JXq7VFOmXgP3hAlW8gzH/R6cbB22ljqJaxJqRJTwEzsnwabjB4TCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712874648; c=relaxed/simple;
	bh=FPP0pGTTQJ9w/af1qSi4/wrO18+xLS21UrdlmCqaGCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vDf/Hpm6EtUS/45Vk6MeQASmCvlRjCg25BJ5J/jb/0OqIeK13ROwpPD6IV/GxudVPIuT2tyZ1U0Bz8j6NuzrrQS9gl0N39E9Xkmc8RetPnQqSe0RyF1lP/ywX/PbOEOzlaoaPrl4+DZZHqDy4+rVKfI4mvLlIRx4cXHy72+9nNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oLg0DMph; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-56e2e851794so2136a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 15:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712874644; x=1713479444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TC6twZx6RBXTw+ooEGShhOHtZOxQHkfNzLmy0BDBQz0=;
        b=oLg0DMph3m0qvauDhxcZIx4zSylGeblkJ5IL3Xo81f6825vW/N+BVcZz/zH+CDo8KG
         lOVdkT2e5Jz+SMjL7sDiiDZt672RM3k9jKxfGyUZAZ9dyIPB6j9/tkQd/1Zq0x1oPty9
         tEEVrFdmUzfio3g1QoAdMxHArUMOI80jKukPDw7pODSlb9/io2CiU3Qk7nDv3XX8I4jo
         NuFFZGkYTsjB/CSFuuY/JAtFqBLyDtnZ/c3+1FJoufimMoebYEVwN8Pp29L7Uzt8H8qi
         om91vGAohv4WqU0gWyET7avdjHh3YAoD0ewZVQ+axll3SY+pLSHF4yNG8gaOQR7KeIgm
         r3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712874644; x=1713479444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TC6twZx6RBXTw+ooEGShhOHtZOxQHkfNzLmy0BDBQz0=;
        b=vqF/KU8rqJdlaWYHGj0Y7qa8e4Tm2MQt7Q+NGnT8S978f9RE3CDlfAAlGNaryT3xiB
         ooQESM7c78ERZqr7MjbJHT7gXqm9QozWLOocDr8IKMVHwhDUWjfAYesErFE5DfUNEXiq
         J/8SksUIuygloQMZtzJrRT7swIRurpXliLmjJL7PUD5AkSjVE0uamrxaPpCaPLrUhUR8
         NUl1zKrlzirJhJySbh9YRm5ouIMGnBPO4iJN5fPAeNwqrwtfI+vtAOt1YT6ad0YTW1Yn
         n/cZaSqgwaA9/hfXD5oCuSu8gUGr8yOTSghC9wkx+Qhm5wOZJXmqyA1hDLSxtRL4kT4N
         Flcw==
X-Forwarded-Encrypted: i=1; AJvYcCWWrq0oVHNlPYB+3OXiejocDQVZhX9iJBDknyTptR+yeNwJFaWT0+R27YylCij3PDiwYg6TMq4uLho59oGyBpPxOxU6
X-Gm-Message-State: AOJu0YxiSRyFrZe5qa4kwG90bvVx5a7BTXNPLKX9f0BVp8tZAnMWqNmQ
	RTfoR9KgDdwNQABw5c9+4xkFsOmx+L+dWKRP4moDvIzWymGbgtbo7NF5qGmFWJ00L0XbhfBbh4s
	vWm8RQCgvIbbWbyPIHLknFDCxs2n783DxNN2/
X-Google-Smtp-Source: AGHT+IH0fRw88jlF/PTTGp8JUv+i2sdboTHFQlUCx9qkS0imAB+RnQjF3l7GHprGg80gvoA8gFg+M99vrf6oV9rVo0k=
X-Received: by 2002:aa7:d889:0:b0:56e:5681:ff3e with SMTP id
 u9-20020aa7d889000000b0056e5681ff3emr59016edq.2.1712874644225; Thu, 11 Apr
 2024 15:30:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-16-xiong.y.zhang@linux.intel.com> <ZhhUZJ7rE0SbE6Vv@google.com>
In-Reply-To: <ZhhUZJ7rE0SbE6Vv@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 11 Apr 2024 15:30:32 -0700
Message-ID: <CALMp9eQ01NJZKKYt8XhTbnu8rNpuhpk388ocvyPqWJiO+sov5g@mail.gmail.com>
Subject: Re: [RFC PATCH 15/41] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, mizhang@google.com, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com, 
	Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 2:21=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > +     if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
> > +             /*
> > +              * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm en=
try.
> > +              */
> > +             if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
> > +                     vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
> > +             else {
> > +                     i =3D vmx_find_loadstore_msr_slot(&vmx->msr_autol=
oad.guest,
> > +                                                    MSR_CORE_PERF_GLOB=
AL_CTRL);
> > +                     if (i < 0) {
> > +                             i =3D vmx->msr_autoload.guest.nr++;
> > +                             vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT,
> > +                                          vmx->msr_autoload.guest.nr);
> > +                     }
> > +                     vmx->msr_autoload.guest.val[i].index =3D MSR_CORE=
_PERF_GLOBAL_CTRL;
> > +                     vmx->msr_autoload.guest.val[i].value =3D 0;
>
> Eww, no.   Just make cpu_has_load_perf_global_ctrl() and VM_EXIT_SAVE_IA3=
2_PERF_GLOBAL_CTRL
> hard requirements for enabling passthrough mode.  And then have clear_ato=
mic_switch_msr()
> yell if KVM tries to disable loading MSR_CORE_PERF_GLOBAL_CTRL.

Weren't you just complaining about the PMU version 4 constraint in
another patch? And here, you are saying, "Don't support anything older
than Sapphire Rapids."

Sapphire Rapids has PMU version 4, so if we require
VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, PMU version 4 is irrelevant.

