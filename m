Return-Path: <kvm+bounces-17477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 349588C6F26
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33C991C214F8
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790545025A;
	Wed, 15 May 2024 23:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bxqb4oyn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74814101C8
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 23:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715815579; cv=none; b=GHONTdHj/sohKt4hrAHhg5S8xmk0fPn/q6to+/7p47urmmtc1fyMR+1QSk9oYwzXQZJ1NvrrPLZzYXPyrP33edR7Y3opTY5dFr+taWP7vtmX+4JzCj+mKqT2RmT8QFoXK3hYNFg9ukONrNkWFP/prmbCyc0kIxlEMBCrpTts264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715815579; c=relaxed/simple;
	bh=2Y9HYnVAi1MX2b83pHesfVOmcysatjNtN2ksEqhG4Gg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CEaq5REocVbRiMkaiCd4NKsJDX3uBbo4v/1czG9Pcs+1WRnAxwZA2WcSC8885E4onjRfkq33kCfL7+oayeATC9E92nJvhVcIZ4sQlZo7H0IUPR4X1eFHKldnYkzF4JuIjrTHrIB+xXDkOfYfIhwwcq/wYtwQ3WeUxbJ5cAPptP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bxqb4oyn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ee0caec57fso69084755ad.3
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 16:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715815578; x=1716420378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Y9HYnVAi1MX2b83pHesfVOmcysatjNtN2ksEqhG4Gg=;
        b=Bxqb4oynMQqIRcuj5r880CXfuw2YOillXM1xLTybMhvy25wQt+LPrBnXL7hevpfy3/
         zxTTbbCFHb4O7RBMsuI0qutXWs6WmbZspApLkzEa/KyBsoYKjzrII0U/7WHu8yywXk0E
         EoqZ1EbjRS7EMPO5R5PKk3h+FTegwJXGF8SYltL65GOwwm4LAQO7jZBJDn7FfdnUKesh
         zwxN/Pis0VhrjHWDOkESZ5x8YJ1RcG5kKIMESa/yKjWMlFAK0qoqtCqDyYJ78ZrnAM9y
         VN+KMdt+F6t7ZdivsMfAaFa6dF5owq4ma1AjgfpazCOSeDUd2I5rPO0pAjfMUbt0ukZj
         OCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715815578; x=1716420378;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2Y9HYnVAi1MX2b83pHesfVOmcysatjNtN2ksEqhG4Gg=;
        b=fO4rinVTm9HYK5QloAMJlonF52DoYSSdBvKWbejJQJBWdOXTcCxzisANRpoIocVZ0q
         Wi8lmHPOZExABdqympOXz8YnR0Y7+TIzNPTj4k1I1OoifYdKpbjurbzJ9/OA0Pnw9mlU
         UsSRkKrn88aaJebfYM2/OVi9xOHnvcLY3p/uzzD59FJO7t39+OM0lXj4kHZgQEUZf1gz
         O2n0jeFst/TGkLi26vz3F2E8nPAVzXLCoOT1Av6oHtPl9Om/R3T0uQGW9ed5FD6STWfs
         6wkyKXZvcRAJUEZdhwblAnmqVOiYD5RrPcOyibV+XbTyFIWU6Ol+iC2plmOCHCoRQ68o
         svNw==
X-Forwarded-Encrypted: i=1; AJvYcCXpDcbquvTztFIosn/+SkmPx8MyAINrih5fueBelRErbZT0uoWNeuQIuJKagj8MHTLD2TWYadPm5+eUAOdTug1BoRzS
X-Gm-Message-State: AOJu0YwVliMzdK7kgpCLIF5aNfrw/h5HN6LCkJyvZs8ljacFkCUkjVup
	YfU3sXcR1xX3qDxD0N1Xx3jkG2Vv89KdZJBblNi2VJnpOmRQF1EOqnv9Xei0fN33WLRyPx+NXgZ
	Hxw==
X-Google-Smtp-Source: AGHT+IGtoOQokIuMOtZ7I+wsyi2BzCuze/GDRj0Nh5Z//Qxk8bO9FH7B0H10f4cquEg9Kl6dt9ebJ91/CRQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c8:b0:1eb:d72e:82aa with SMTP id
 d9443c01a7336-1ef43d2eb43mr3260165ad.7.1715815577568; Wed, 15 May 2024
 16:26:17 -0700 (PDT)
Date: Wed, 15 May 2024 16:26:16 -0700
In-Reply-To: <72a18e11e09e949e730d01a084ee9f1a94c452ad.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <ZkTWDfuYD-ThdYe6@google.com> <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
 <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
 <ZkTcbPowDSLVgGft@google.com> <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
 <ZkT4RC_l_F_9Rk-M@google.com> <77ae4629139784e7239ce7c03db2c2db730ab4e9.camel@intel.com>
 <ZkURaxF57kybgMm0@google.com> <72a18e11e09e949e730d01a084ee9f1a94c452ad.camel@intel.com>
Message-ID: <ZkVDnUhMafRox9rw@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-05-15 at 12:48 -0700, Sean Christopherson wrote:
> > > It's just another little quirk in an already complicated solution. Th=
ey
> > > third
> > > thing we discussed was somehow rejecting or not supporting non-cohere=
nt DMA.
> > > This seemed simpler than that.
> >=20
> > Again, huh?=C2=A0 This has _nothing_ to do with non-coherent DMA.=C2=A0=
 Devices can't
> > DMA
> > into TDX private memory.
>=20
> Hmm... I'm confused how you are confused... :)
>=20
> For normal VMs (after that change you linked), guests will honor guest PA=
T on
> newer HW. On older HW it will only honor guest PAT if non-coherent DMA is
> attached.
>=20
> For TDX we can't honor guest PAT for private memory. So we can either hav=
e:
> 1. Have shared honor PAT and private not.
> 2. Have private and shared both not honor PAT and be consistent. Unless n=
on-
> coherent DMA is attached. In that case KVM could zap shared only and swit=
ch to
> 1.

Oh good gravy, hell no :-)

