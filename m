Return-Path: <kvm+bounces-24728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9C2959F28
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 15:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 191471F234FB
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2575A1AF4FD;
	Wed, 21 Aug 2024 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i86X+Ayl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017A18C348
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724248768; cv=none; b=C9QB6Ibb1nM4sd4pSP6kk8t87BPHgpLlplYYsQPJJkqum1J9U3cRimXocuF+bOwC5cVtjEh3TxCpBA/PfmPCK/Rffvwh2hGtgASo3lQYw9Xt7v/VCM3EUhXZZy7kFj3iCzsRLhPBrlUWxmw/YO8d7c/Dq2exsx7A71P/oOwehKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724248768; c=relaxed/simple;
	bh=Nxst5TEEm5z8iUl+TEBEPrc5FH7ZeLnW1hV84NEgvl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TUe9GIA/TFsush8Cix7FQNoMPopCHx24hjtOXPD+zVf3jqs10vfXyrOQkGaDJq0rWZ8RQtkMQTcjJ9cbVWfsBcU1nOaDwtUyu2WWOBav6dDXw9m0BpKryMCuuMjC9lwYuTvEXCb/GYIVdsM76pi1sODp/pq2Ulw7+MxXv1EDUe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i86X+Ayl; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-45029af1408so241281cf.1
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 06:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724248765; x=1724853565; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nxst5TEEm5z8iUl+TEBEPrc5FH7ZeLnW1hV84NEgvl0=;
        b=i86X+Aylb0s933AOrTcJV8KZtXwzjiiM5lKy9ec6d5v1mpCTQ/JMqAq05+jPkFXxDd
         sbbpXP8RfQIEtdY0zECddDGypd2PW8ztobhixSNhrgGpKhu0hrLekteGJ6boItk/Iu1k
         gILmkQnBtBXgwdcnWJvx96F3Z+dc2HNosVYQv3Lum37VfxrhnRZjCAiL/ILMVHdsQ4PI
         hPC21MQyF2pEpI+JjjoJnf9OSsQBGw/ZQ71IqKkwngwfW4JiM1tIDWPtRPTqlRnlwDVR
         Y8b4ZuNUVIeQBy0DHIwfSKkFuqIzATNL16aopFxzOK5WrMZ1+/vOYm5TVGskCNY0Iy/O
         YtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724248765; x=1724853565;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nxst5TEEm5z8iUl+TEBEPrc5FH7ZeLnW1hV84NEgvl0=;
        b=Urww7SU9a0SvTd/KaVjINwRFnJpvncFXCqkN1w+Cg54MObjj+MU51nlhLEjtO57wFo
         xLLyTWs9uWzNwDYlV1VycxlaP7GfM1uINJ2AN209XkQ+N92zuuNvbxH1g70F0L8bFkgW
         wT6wPVBtR01jooTjrI8LupghrSg5ibxla+wu4O5HxqPK/NAukokDvTVCNAmum3isM46f
         Vs2atCh1l5FkvI6roU12xdZ7KnYbJxIiJoDIAYwQ4GHTJQXbLD7D3e3TbuBP6ktIrg0H
         IkRIW8mq1MRoNhTpaZcNXdUj5LYdlJ2v/OJDqyGcr4D+E/f5Fwmn2S+/QMY+x/IDN811
         ZzKA==
X-Forwarded-Encrypted: i=1; AJvYcCUYY0YuFDCXqHlC0iyLKF4EGMy66f+C7kzaIjSegCVyipSSO475eseL5iJz/fCEY7o277w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8zXlkk1QtJ+lJWtGClAgT+JKugWf8u22KJIwTPEq7rmyh3CtI
	c0jJBnovohBt56xBmBwKs/AUTi2pO4WC1Rrl5v+TX7mnRHdBv4Mipt4AET3OCKPRVcPVGl9+Be/
	GCj4VPKZSeoCDEOgq7en5/bmDr4Y+A6WfmR79
X-Google-Smtp-Source: AGHT+IHaKAKAmTQrt0rYQ98cgg8gxXsJZuuysW+sK0/lYbbTiqQOpt7PedEDzP9OP5rgPDX4GKwW7os42UuaOOU5wak=
X-Received: by 2002:a05:622a:5b8b:b0:447:e8bd:2fbe with SMTP id
 d75a77b69052e-454e8530e2bmr6047001cf.1.1724248764541; Wed, 21 Aug 2024
 06:59:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com> <20240712-asi-rfc-24-v1-16-144b319a40d8@google.com>
In-Reply-To: <20240712-asi-rfc-24-v1-16-144b319a40d8@google.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Wed, 21 Aug 2024 15:59:11 +0200
Message-ID: <CA+i-1C31FuFUkCMZmZ7O7423f_e-0RAEcBiMMsO4daTACVZjiw@mail.gmail.com>
Subject: Re: [PATCH 16/26] mm: asi: Map non-user buddy allocations as nonsensitive
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> This solution is silly for at least the following reasons:
>
> - If the async queue gets long, we'll run out of allocatable memory.
> - We don't batch the TLB flushing or worker wakeups at all.
> - We drop FPI flags and skip the pcplists.

While fiddling with this code I just noticed that, in my enthusiasm
for stripping the logic to the bare functional minimum, I went
overboard and totally removed the logic to wake up the kworker.

Anyway, this patch is stupid regardless for the reasons above, but
just noting this down in case anyone does read it and wonder how it
can possibly work. It just leaks memory.

If anyone wants to try out this RFC and needs their system to stay
alive for a while, let me know and I'll prepare a branch with this
issue fixed.

