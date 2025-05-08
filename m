Return-Path: <kvm+bounces-45898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F827AAFC9E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEB7C3BE0A3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BC9253B52;
	Thu,  8 May 2025 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zp704B47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF52F253345
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713524; cv=none; b=Wg3SO0tYewayTyAl0a5q1vbw/bLRHxdJnm5+u1S166G03IkZWHxlLpbS0WDQu4VDctaIPFtQlO5hYvo0AdNKKMv1U4cLe+pFoBF9XkoKTRpfdRNfDra/lemzgPhELb0UQdWUANz11ZkStlPTnsjHaLlzR8I9pvDLujsVgEV8WsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713524; c=relaxed/simple;
	bh=PlbaLP2T9N4iQF/W7BMyZJgCbkcEVYT7EYg35D1Lv00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aNAm2XIXfHmaQS/YE+OuyvB953jPc1FmVnw7vj9w8odJrQhieeyUPEXNDQ06hBMH6dcX8VVSK0LNZy83auVIfktL48qmMbe+pAAY9iwGqB2UD4gRvSJ5CO4tSg6KgH+zGAa6dsl+8xow/Sl9jFFjgobuHovcIa3iE37ZOpRq0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zp704B47; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-739515de999so1054869b3a.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713522; x=1747318322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgaNCnZNuwkRUDo4J1p26KpwcTten0pYWFPzOF6z51E=;
        b=Zp704B47Tdg6LCvX8GuROfeGbkfCwmYs92U0VrxZJ+qXlMQhug0WomOwh/sLYV1zPm
         5yttTap2KSavMFrMwfk8KA5of6XgaV66AahEKyBpzqkbBRmBF3vGRCY0Ud6uUYBq18Pk
         J79vlfeYMW6ySckd/2IxR0mXykV54vEQBdvO8Y+w3luMW1K+zlO57gWrJ9gqf7p/w12B
         cU+IhhIV5/emr9QGfQG1APwf3mAAbhH39uz5fPRPD/i5qTLGsmeDLzJy4lgBU+F5Y1YJ
         5AgMdBcOoOdrHmSXEVuvkOpGs76M3gQ1sCqk0/Eq52QZCoT9Zu5hJUBSggoyKPMrYzNN
         PViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713522; x=1747318322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZgaNCnZNuwkRUDo4J1p26KpwcTten0pYWFPzOF6z51E=;
        b=cQ/yajCvoBWOmtHfmVcgW0CEmx/aJYMu7pYqtQifnk7mwJLg06+u37Oi30BXSQalbD
         SnFvpabrefygJHjWJ8xtKefi0owMQDWD0h0VChU7x5VlmjD3X+e29AFlGB5L0SOAeSgP
         CNps1dGgLz5Bayt/5kQWGTLcuoG1ca2Q7D5E1GrFkE8bofGIdLZuhtqzDZ5tdSxajqZx
         IAGG6z2+qgdmDqV1ccHsXt8xmp2qXEy9QMPT7aMyct2nkNQd43StHuv/PPR07tOK8AfZ
         2vWnvuBQRtbyAs6u2jTsWtVqLxtxoEQEYC7PCfSnRBQmuNgY/C5MrjBKbgTeo7kb/cGc
         vlEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcmIriOsnh1j/vWv9iRtZdCEQr6Gxp97cb5yBsP9P9fMCVgrwwtQvpoKyVx9FJM37FokA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8uBfzw6BRUId3j55lKuzOoYVzqFPgX3gkDDo61z72+9oLpjri
	skhVDrfgvM/iR7AdBoARo6ZsazHMdTyciXY2VF+nbiIoqkoT6Cqyg9vUY3SH9fO/VugIZsx3bzT
	XIA==
X-Google-Smtp-Source: AGHT+IF71T/JgBcv+9pVVDvfD6Bh8QHnMVGHojYXE6GwevcOxLdiFS6jTOGkbQxj2jdTv+V8f5wxpjKby+s=
X-Received: from pffk15.prod.google.com ([2002:aa7:88cf:0:b0:730:90b2:dab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9085:b0:73e:2dca:f91b
 with SMTP id d2e1a72fcca58-740a9a6a78cmr5220026b3a.18.1746713521980; Thu, 08
 May 2025 07:12:01 -0700 (PDT)
Date: Thu, 8 May 2025 07:12:00 -0700
In-Reply-To: <diqzh61xqxfh.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com>
 <aBTxJvew1GvSczKY@google.com> <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com>
 <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com> <aBlCSGB86cp3B3zn@google.com>
 <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
 <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
 <aBoVbJZEcQ2OeXhG@google.com> <39ea3946-6683-462e-af5d-fe7d28ab7d00@redhat.com>
 <diqzh61xqxfh.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aBy7sE9ymKof7LeL@google.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, May 06, 2025, Ackerley Tng wrote:
> Sean, David, I'm circling back to make sure I'm following the discussion
> correctly before Fuad sends out the next revision of this series.

Honestly, just send the next version.  Try to review a description of code is an
exercise in frustration.  More versions of a series isn't inherently bad.

