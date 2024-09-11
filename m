Return-Path: <kvm+bounces-26563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4988697589F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 18:37:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FDF028213B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6652F1B2538;
	Wed, 11 Sep 2024 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JqLZfEei"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308011AF4D7
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072650; cv=none; b=Ae14gRKvYAkOyojTrO4qFgeNd350ZhL9gewZflduQpReDQd3T+TPx1vuDHgUaDbKcLivq277TPRoXfoyX272RDpvjl0AM9bCZRxonIbFIpqduL3FhOf27iJK7myqlQV5t+ou2S0cfVQAppnj8+aqIRpWY04ahNBk4hV2Mlwn62g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072650; c=relaxed/simple;
	bh=cfkxZOekWV4jZxn58KRROMExnrcMdsH4drR0ftC+roM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cuxzd42V54s+g/9QhK+ijBjAF3kenjbwkwT0bLwAjf+Va2+Bht1un8ZECuCUIww/pWDF8mEXi+IJ9vj+y3KO3KLNg0umxmVmGlClA7YLlaoW8nQLTor8hB7PA7qU5yq9JJuktKIb1tSDvD3/PiQuQFllM0mkEYMdDpPDVBV4tik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JqLZfEei; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4582fa01090so3271cf.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726072648; x=1726677448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfkxZOekWV4jZxn58KRROMExnrcMdsH4drR0ftC+roM=;
        b=JqLZfEeiJfMsYiKePHmsEv519/r0hxJ009RnI7ffBC3WRLm69VED5anmUtB18wOl9c
         tCpy8ddAhIukbgd46aMrUuc7UsCzIv93Wspk1t6CJzfg44zGjUqdTBvXCuVhXhTt/b3+
         s8Jlql5fwaKkLzyXQEMMuIWvHhha391JxHc3hCtj+ZTVaULG+ojANwzFSSOU21Y+TU+S
         1yFHfFwwleNWbPyfviGJYqfroz4MHp3zFXLi+YlPdBkVoimHP5ReB/5/5Xrey+EhLy00
         ak3+cYBU2piTElN3tQYkuDQDG9PTyluKx0DEIdi46lEMwTFTH7jGbDO/VTxEIBzVday7
         thaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072648; x=1726677448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfkxZOekWV4jZxn58KRROMExnrcMdsH4drR0ftC+roM=;
        b=jZkv/7OIy0R7jABJcwRMEA1NTwtLYSSZXkrlhT8OOmVOFqCB0+cLyTiHdTd3TnUoq2
         PCUbvldKrDYiW5EkvqWsuve/V8qcywXucZWaaxDBJGtKErU7HxFuY12KKZ54U8MTRSvI
         3ED51anbpfq9BbcX91S1EE6OeNCvZcB2W4UM1d1IxhaCulpUi8SxOAB0DxM6h27UVoE2
         o3XQV8e71y1y8/z6999jFvU0hVyIomQjCbUC5CgJnAuv/65L/6FfSEKlLwg2Mv1Cg2Wy
         TKdkRvQsiPdtcnUofOIXcubB6YW/SVtIyCTsNit6pSoriji2mpeopmrKZ6JJ/lApeeIV
         mnrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVg2QrnG0hIGHhWRYJ5nFhZL8KFHjMQ4ENqNzlTs4P7Yog4+qvUL2i88TF5fnzk8bn4pM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwozT6+GSPJYj0iEEGz14wa5FDZ/iARzNJQbBhkKVcefyWtF8lb
	6osUbPLeX58o6cHrebKqOpZSgdwbyMo8pnDMNX2G66niVWD5hY4tuWs2otXfObxRoqkFBg+Yf/Y
	XNQGVE5+TquxIZr9UuaYGVOUNvhuwS4VGzsfv
X-Google-Smtp-Source: AGHT+IGWDM0No7L9T1bmdVhR/4iUEK2u5FPOXPt7+B+CAlj5TEb2qkuq8388slXsveCQjDQ5cvuRcUyDaKbF/x8dMDY=
X-Received: by 2002:ac8:7d03:0:b0:453:5b5a:e77c with SMTP id
 d75a77b69052e-4584f3a4fc5mr4563931cf.10.1726072647546; Wed, 11 Sep 2024
 09:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Wed, 11 Sep 2024 18:37:14 +0200
Message-ID: <CA+i-1C1Gop4uva4dHv1gKtnS_8tvw8r50M7uf38Zbui07OoQwg@mail.gmail.com>
Subject: Re: [PATCH 00/26] Address Space Isolation (ASI) 2024
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
	kvm@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jul 2024 at 19:00, Brendan Jackman <jackmanb@google.com> wrote:
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
> This RFC demonstrates an implementation of Address Space Isolation
> (ASI), similar to Junaid Shahid=E2=80=99s proposal from 2022 [1].

Hi all,

I'll be discussing this series at the x86 MC at LPC next week. I
didn't get any high-level feedback so now would be a great time to
take a look and see if you have any thoughts about the basic
structure.

There are some bugs in this code but for an RFC it's basically
representative enough of what ASI will eventually look like.

In case it piques your interest here is some performance data I've
just gathered:

https://gist.github.com/bjackman/673415ee46fab01aa8d5f6ab1321b5b5

