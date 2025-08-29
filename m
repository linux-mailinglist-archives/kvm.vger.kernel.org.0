Return-Path: <kvm+bounces-56378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E4A4B3C56C
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637A517BCC9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA102FF67A;
	Fri, 29 Aug 2025 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a2X9i7gK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0432C11F5
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756508312; cv=none; b=OFYE5CWf6S053g3sVR3L4DUo2oppGI6omxq2lke1zFj2WmyB4j0ZWeAUZq4sPhoXWdVD2RpwDK2DRVBRn8AOx/NlVQ86uJ+fHoxx6/p2Q1g2kiLNZ1Eo5IjO3AqRi8fX0VZ2EtQ0kQprcstSb+LEmnjzNTBM4rk5xwn6N087WWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756508312; c=relaxed/simple;
	bh=3/ST7t4tQZRsVo6zeq6ydfoXOSTFM6Bsy9Tcj8tIPr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YR2r5N/fCca/AEG1M/D+FX7hUibs4/0NBQpOnVSiAnZ1V6fSfbrRDJdSJ7Ng9KEOF+kLSVNK9S2ISUyOh+FitRa6yfEDp/lXAS42TW30+VjZMDi47/Y//3/N/KFO8H6NNAvDmxNPUGQCzBawiDWn0HI58GvtvLzBBts3Rd6cNeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a2X9i7gK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445805d386so29513275ad.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 15:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756508311; x=1757113111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sPHvBvb7e/NMtb8O6S8eBwp+HYMbAiBtxqtHlz3NzjA=;
        b=a2X9i7gKsglyEL8SAgWyrnCwtwRxzuZdiuCBLcZwmCNWuvdyUkfMWK5Hy/891cOZOJ
         Xl2NCVJElYlS/mD8iWgjDPwVBRfZHnDxQbA21e4cyAue69IstZvLPveNGHEf8s5brJvf
         qEP+ScL6BrtNdeNWqfdIFEBbKXYjAVGg0kMA9FGCnMoGGYIHWrXdu43vZAeNpf6v6Esq
         2sCxf7LG3TBFgzMB8xWmv4IXoifs/oTyZu98yzVcfJWJha0MFMFj4wLfLbLrupG2eOfP
         LHq/Uaq9BI7vTHhP6TR5LMw9cofluOz7EQlUT+P/RvGNf931E3XsNDQ51SaMFbTa0UET
         bp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756508311; x=1757113111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPHvBvb7e/NMtb8O6S8eBwp+HYMbAiBtxqtHlz3NzjA=;
        b=Csd5e69tGYm+DehOj0qP9DLYnKbJMDBWAbwHqDTTRHTXlZnumw8VBXNqWQKvGyu97V
         EMjDhY1Ry/0UDsMDhqdk7gUUGKHxuMwTKeJdnqr+gu9fM1ap7tVCHhKqehhdGVhBHnNY
         OkA0qXYyZ7LOPV00Hg/GlQUMoVaQHqTcIVheQW6v9ibfJKWozx9WfMhTYyYuAJOEY8Qg
         AmLldgrqAOWW1IUUYwrBYTDpVlFBbNIDpKNF597zluGFG2BcQb98UWzCjHG+EveLHvb9
         +iAGkJm6z6NbQ+S4QnzFyZy620xJAKJJbiSMZ+JPhomKtn3LFlH9fnhU7znIiEL2OMVX
         b0Kg==
X-Forwarded-Encrypted: i=1; AJvYcCV8XJpd/UkXNVXVi+OxRKQe7ifX9Kg8StpyrGcP73aX32AsqfjHY+/lp5Kvw5rh3/g2IzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyB/K/9xmbxpGzU1vGsnhQd19H1OQ5fhaqdRAsXjnd0FV/0CsE
	ejYC2J43QXNSRgf/TO136k+nWeQnHNrGN9JkuVNxfpgqYxuVrDE4JK0f8nZX+D/TuiaYOdqVmf+
	8AtdEZg==
X-Google-Smtp-Source: AGHT+IFrWrm26mJqi1On3LUbJFX6Ucok/wIXtShiGmEfrR5aNNTYlv3ibwLo7L4LreFylva3TCaJtXVADL0=
X-Received: from plnw7.prod.google.com ([2002:a17:902:da47:b0:246:b4c6:c174])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c946:b0:246:c0c9:13a2
 with SMTP id d9443c01a7336-249448e36a5mr3920455ad.16.1756508310757; Fri, 29
 Aug 2025 15:58:30 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:58:29 -0700
In-Reply-To: <26a0929e0c2ac697ad37d24ad6ef252cfc140289.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-6-seanjc@google.com>
 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
 <aLILRk6252a3-iKJ@google.com> <e3b1daca29f5a50bd1d01df1aa1a0403f36d596b.camel@intel.com>
 <aLIjelexDYa5dtkn@google.com> <26a0929e0c2ac697ad37d24ad6ef252cfc140289.camel@intel.com>
Message-ID: <aLIwlZWdyhBp6I0Z@google.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> On Fri, 2025-08-29 at 15:02 -0700, Sean Christopherson wrote:
> > On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> > > On Fri, 2025-08-29 at 13:19 -0700, Sean Christopherson wrote:
> > > > I'm happy to include more context in the changelog, but I really don't want
> > > > anyone to walk away from this thinking that pinning pages in random KVM code
> > > > is at all encouraged.
> > > 
> > > Sorry for going on a tangent. Defensive programming inside the kernel is a
> > > little more settled. But for defensive programming against the TDX module, there
> > > are various schools of thought internally. Currently we rely on some
> > > undocumented behavior of the TDX module (as in not in the spec) for correctness.
> > 
> > Examples?
> 
> I was thinking about the BUSY error code avoidance logic that is now called
> tdh_do_no_vcpus(). We assume no new conditions will appear that cause a
> TDX_OPERAND_BUSY. Like a guest opt-in or something.

Ah, gotcha.  If that happens, that's a TDX-Module ABI break.  Probably a good
idea to drill it into the TDX-Module authors/designers that ABI is established
when behavior is visible to the user, regardless of whether or not that behavior
is formally defined.

Note, breaking ABI _can_ be fine, e.g. if the behavior of some SEAMCALL changes,
but KVM doesn't care.  But if the TDX-Module suddenly starts failing a SEAMCALL
that previously succeeded, then we're going to have a problem.

> It's on our todo list to transition those assumptions to promises. We just need
> to formalize them.

