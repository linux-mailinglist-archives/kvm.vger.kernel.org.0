Return-Path: <kvm+bounces-25062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7199D95F658
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B3091F21C68
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 16:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FC019753F;
	Mon, 26 Aug 2024 16:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E/i50Epr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDB11957E2
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724689266; cv=none; b=LMVNV9gRKT4+Stp0FXiRwCy5VJXrVJL56+ScOnH+I4sv9/NzoZ+d3YG6of1hvwEcnTrzJzj5cSOgkboftpk2r156OlhewlyYs1JqRPFLRtXvRE+uJXqPgndi+o3Cl6WQasVXwk9T34ba28AIcwxzLYTQ1aZc7+HX8b0pMUtLy64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724689266; c=relaxed/simple;
	bh=a6zpBBN4JQg0KhcoF4b7pBScl+jiov7IK/jGwEtOvIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WYbAvQZKI11wbrkFfP1TuTJPZeOjI9HWlCJZPKlEwf1I99tTDk61+nzb61BEwlZl+RZ+bIRyh4xMCx4XJMsHkYlNbf3xz8Y/8v1cvdLTRcVvS255IF9ydFw/RWYzLiXKS3Q2l0K10St9LJC9EVLm4YRhUlwjtWo4e9V0G2DGXtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E/i50Epr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-201f89c6b21so54602505ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 09:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724689263; x=1725294063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nH4isUs+Ak6g9QeK5QSm8EdSPs1/4ASJGA312ynuDFY=;
        b=E/i50EprUH/qrl4o7hC3vCvjuGPItwBG4BJRrWkpBX94bxJinFbMSxrYFfk8byBTaq
         pGtmJryn6VWlO7jWqe38PP2vw3MQ0oSohI9terQNOihl9PC72uTidCGcdfjVJrFuuCjy
         JRaaNtChhBj8xmxZRBGQBAtirV3djL4Q+VpHnknZxIWG0CuqWzwHFaRQFKaCIM7VHVh7
         pSt1WCPwcvEmPjj7aqoWYaxrN1y18B/FMK1WEPospWzqMlaLSaxzWKEaEWMI0i/Eneag
         aPI9dLY0oBTYNkpRt0mLjgBTM0zgC+Hh34nSWFlFiUBA1hU4isywEe3E+6b8EU1hzyJl
         i5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724689263; x=1725294063;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nH4isUs+Ak6g9QeK5QSm8EdSPs1/4ASJGA312ynuDFY=;
        b=gQEjQ7Ea490ncDGgB7fk6AHEZ8loTZN4cJdOWgjgcmn52pxnSslJ7PUqFtH9nsRxRL
         Jf8rFZo1frBbImZWBWR0n6oq03rRMt+4+PBJSUeS2orEJK/RUxy2dcEahkidp9pRj0vr
         G+zn4O4obeC2dbX3dbSeryxIjeetSiCW5/QRIr1Yhh1lp2EsvqSmTaKnzsm5dLnwVMYS
         WuY4+IeFKgJsKjpV0SnFFYwu3Z+Me4Zb3Zebg8b4gmt4JgzJS/1R+Veo+k5jvFPmgH1t
         myrrnaqj/a7fMlzfTXAqORbEx1xsXS1xzMmXJVzscsU6pti/ZJ4kb9SaEIetDejmxzpu
         cjKg==
X-Forwarded-Encrypted: i=1; AJvYcCWbgErlN5vjLU/2coJyzUYoLeZ0yWy/EzxlG7H2FfeVgxuCtw1VhyRbhsQM6VWHewJhHKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlUm/QTFc4xvtAIGm+0GOmpizAfCZx6iLJjaMCXox8kEpysRDe
	0z3OQwNal2rHyd73v9sEgdKgayTdaDIchAbkTs1BqKij7VprbL0FIfrZBe33dIZzLahMOGKfPBi
	yPA==
X-Google-Smtp-Source: AGHT+IFZBf/JtJOpPDhFjcRpoVVRqE7Xm33ElNPbb1hk/PhhHYsdK4hJiGWeK9hyXOPimjecXAjJkEhXV7s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1cc:b0:1fa:d491:a4a0 with SMTP id
 d9443c01a7336-2039e444afcmr6365945ad.2.1724689262997; Mon, 26 Aug 2024
 09:21:02 -0700 (PDT)
Date: Mon, 26 Aug 2024 09:21:01 -0700
In-Reply-To: <7f15288693d0ebaa50e78e75e16548d709fe3dc5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com> <172442184664.3955932.5795532731351975524.b4-ty@google.com>
 <7f15288693d0ebaa50e78e75e16548d709fe3dc5.camel@intel.com>
Message-ID: <ZsyqZeTzhXk5UeSP@google.com>
Subject: Re: [PATCH v8 00/10] x86/cpu: KVM: Clean up PAT and VMX macros
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "luto@kernel.org" <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Shan Kang <shan.kang@intel.com>, "jmattson@google.com" <jmattson@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Zhao1 Liu <zhao1.liu@intel.com>, 
	Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 24, 2024, Kai Huang wrote:
> On Fri, 2024-08-23 at 16:47 -0700, Sean Christopherson wrote:
> > Applied to kvm-x86 pat_vmx_msrs.=C2=A0 I won't put anything else in thi=
s branch, on
> > the off chance someone needs to pull in the PAT changes for something e=
lse.
> >=20
> > [01/10] x86/cpu: KVM: Add common defines for architectural memory types=
 (PAT, MTRRs, etc.)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://github.com/kvm-x86/l=
inux/commit/e7e80b66fb24
>=20
> This one has both Acked-by and Reviewed-by tag from me.  You can remove t=
he
> former.

Eh, you get two for the price of one this time around.  I don't want to reb=
ase
this entire branch just to fix that goof.

