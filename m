Return-Path: <kvm+bounces-13331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80CC8894A44
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:07:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B15971C21EDC
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 04:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2D317732;
	Tue,  2 Apr 2024 04:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zbTJ4iUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000C92CA4
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 04:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030857; cv=none; b=QwW9wNWHktqqcR0iZF95Q1x30UmgEcSu40Vb3Mj2p2tjlIbjQzoVrdEtBtbGA9jEnQgyt2sZsig/DyFqiztYRC4MZvzbXKk7/UQFOShio0FXippIwhmyBOmSSQrVsYI5mTfan4SBWS+hP8Z9zqL2EaDLe/MLOCcpjFFpK+uMZgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030857; c=relaxed/simple;
	bh=S5pOtFaXWTZ9drUl1IGdeRTY03Dh2DX28whh4K9thQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aX6FhHmNayLLckWE1bdnJByDwXSlfty3tD/VaPvhe313qmZYFOfmERSgYhFdahvvKXy3OglKKiQTXXoBV0sd4b0NuDvpdp21h4nR6uwjGBIahnC5on1SU9nNKHhBZz9w0uOTr5D93SNFhtDsTpFFv1Hw5qExEbmvEpGZfQEIBg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zbTJ4iUs; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4156ae9db55so97735e9.1
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 21:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712030854; x=1712635654; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZBWjXNV+ukFYBM6SnOc07suCYCDWH2HqRzY2rUjBLg=;
        b=zbTJ4iUsMslgn7kTVDeCmGYoEMExnO3fe49V/ZFe7gRydnyOUQciy2V8IjO9PQHiAo
         f7FSJsHfZAbClhaP4dZ8cubPGcVZ+PQi7xIzcRgyOiqK+Vm0QMrYWV/S0K0EguH+IBLo
         r0OwIs7l+2aM/XbqTzY3A8p+mpvzeMPspw2OgKSO0hFdi08LWtGJtiVlfNOYZuslTFjs
         mIXu0F/qIk5Jwr2ZODX+IXcSSMIYEr3otrvztyZwaegwp8dZq3BkSjhWnCE2kB1uaquS
         4mGYEWbJ9WU5bkPvG9UZWD01jjXrdCpgJjgOhf5mteWn2ti2JuRzzawTCdR8wBOUw/li
         KtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712030854; x=1712635654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZBWjXNV+ukFYBM6SnOc07suCYCDWH2HqRzY2rUjBLg=;
        b=SRZzTDvDe/ivT5SueOJ5qJNgcYDT+MU0IcMH/9lN5zZRTVEJSFcgRl1n15q/1/6JMg
         9zwjePh6P5wfZwoZ7QxauLyhyKbGeMzYFLmOyv6huFbODdUGyflpQi8yulPAvjVk3L1Z
         Ga8CYAkJqeerYwwAkc04sp9KGkoU2erx9/Wffm17ZGKUSIXQ1Zil069aKbIVuh3tQ4Hs
         OEqO9vTA+a8JgEES08kd94qYB+0UMIv2Mv++Cg69G2BfT4nQ3b+kGM+FDi8GuQoNkKZ8
         jS6s5znXlgHDDmqa/H0zE+ypMh1aTtq9JOikJAJr8lLoN87yeYbuEbkmYJiRLypIEkqQ
         IkcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEWvdU+MamNd8CKIIMqgksXM6SSihvN78SoA+XrGT661/M+lGmjh57MkbLjlrfu3LUsmw+YRDbnehreH4HShq+tA7K
X-Gm-Message-State: AOJu0Yx4u1zmWVm86m2ZzPV6Sne28BeIz2IJ5VuEwU9Hg2NxZd2JAR82
	+dW1+iyk+KvqCx2TXERgUAwAKWkgMYQ0v5TYVPFSqdQ2ZCdPGdWv0RhaS6CYACPJcTfA1juoEV/
	GeaPdurJzQ8Uu7qUV8SC6iHPYI6jZOe6A5IXQ
X-Google-Smtp-Source: AGHT+IFySGf8Ru8vCkM5wQVTeOgNnN+X2acwQrfk019Ub2hqyb57NNeXzO4CL4BJZpMyCPNeydNs/OxpDN34ONprOII=
X-Received: by 2002:a05:600c:358d:b0:414:1ee:f375 with SMTP id
 p13-20020a05600c358d00b0041401eef375mr713615wmq.0.1712030854163; Mon, 01 Apr
 2024 21:07:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com> <20240401232946.1837665-7-jthoughton@google.com>
In-Reply-To: <20240401232946.1837665-7-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 2 Apr 2024 00:06:56 -0400
Message-ID: <CAOUHufaQ-g6L5roB-3K0GamuS3p9ACpPj9XM-NF67GgrjoTj_A@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: Participate in bitmap-based PTE aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 7:30=E2=80=AFPM James Houghton <jthoughton@google.co=
m> wrote:
>
> Participate in bitmap-based aging while grabbing the KVM MMU lock for
> reading. Ideally we wouldn't need to grab this lock at all, but that
> would require a more intrustive and risky change.
                       ^^^^^^^^^^ intrusive
This sounds subjective -- I'd just present the challenges and let
reviewers make their own judgements.

> Also pass
> KVM_PGTABLE_WALK_SHARED, as this software walker is safe to run in
> parallel with other walkers.
>
> It is safe only to grab the KVM MMU lock for reading as the kvm_pgtable
> is destroyed while holding the lock for writing, and freeing of the page
> table pages is either done while holding the MMU lock for writing or
> after an RCU grace period.
>
> When mkold =3D=3D false, record the young pages in the passed-in bitmap.
>
> When mkold =3D=3D true, only age the pages that need aging according to t=
he
> passed-in bitmap.
>
> Suggested-by: Yu Zhao <yuzhao@google.com>

Thanks but I did not suggest this.

What I have in v2 is RCU based. I hope Oliver or someone else can help
make that work. Otherwise we can just drop this for now and revisit
later.

(I have no problems with this patch if the Arm folks think the
RCU-based version doesn't have a good ROI.)

