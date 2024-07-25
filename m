Return-Path: <kvm+bounces-22262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 937F493C822
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 20:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 451F8282DAA
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 18:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AE119DFA7;
	Thu, 25 Jul 2024 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYeIIYhy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399019DF6E
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721930877; cv=none; b=EqTzU4esl9G07dRjq0sG/dU0uq9mcKttpG5PMeUKzcBerZX/VNRpmLSvtALIHk5owFWlWP2DIiy/U8IJXDK6JDZvf7PeOltrfagDGEZkyKE8dZVt/mx3y6208C7i9ACBGdrlkTTWfcbrmN8xDHV/I0oelVDI/w69yi7yrxjcaZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721930877; c=relaxed/simple;
	bh=BWXy71ogJASeYD6YU2Jpukh49PfrQil0GPHkRalsh24=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EzNBoQOjlLokpPEtx18GUBzBGj8h6bvqRAN7tjI21YoLQ8ivJ2oJjzudkaKfcEUfLfrNqrCuY8Uy85PGRzNMpHR7EFo/MPAPV3NN3bfHTwmAYRMSKcREK+RqKasoxlaIa3Q/xGVdMCM5d71i7W/lb5nV4082A3aMGeiltfJ7dA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYeIIYhy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb512196c1so147264a91.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 11:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721930875; x=1722535675; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8LHpo7icgPXpVB/A3qaYa/kb3/He/pbNang3awxNWGA=;
        b=TYeIIYhyjcltni4hZtA+/k1slbtu9INJtNaBYJ6Os2vUzapD1d416nnmtN7A2us93k
         W1x63CL7eUVqB6Awcx3z5URFOvsNFRnk4YYxVmBh5BcsEfZTqIQEffloikLKeMK5yNUR
         4IbykZEDRnqIXPFBBFhal2IDrdjxCmAFJlP35p+tLfMSq2H+bgqv/mvnbt+r0U2wqru4
         fcZS1w2TYrKN0Coo7wZxkOWN1wLPBc8yShlnVYxBHzEDPjzGmfZtc4aaSsx/NAVzS3/Q
         h/bcbKmim0pPNvCQBeWM3socxK+cVp2lQG5P1bT/Z/9ai75RhaKAWNA+Z6W9zuzCtdmw
         HGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721930875; x=1722535675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8LHpo7icgPXpVB/A3qaYa/kb3/He/pbNang3awxNWGA=;
        b=hlhbEQ4PpSlnPDBBN7ZeXzQIecSYk0Og9r0npHQIdOlN4ik0yHntXM/gLX0pY69mk/
         2WUdBDqFmpsyf8MsyRqtTieXjxNn/QJjN20SJ5YZVIXHX82YJe5IKB8eRlXxZQvhTFQ7
         ka/ShzzNqsxNlQdlvlNu5/EMZi3VCEuVEGfBz2I0eSqz2vl7MnTA64k2LfrCB5MOfxnb
         waT9qD+HhDxQXIw3pxn1Qp8OkQV0zfCxEGq3MvZ6iZsLV1urCdkBkdRB0Ix3rKPJnIxo
         6OFp2DS2ejKlVauO8s3DYEJo5WlhEA/SsL5GMbdqraT2ons8crjIsgZ5CwUSp79hanrT
         8sBg==
X-Forwarded-Encrypted: i=1; AJvYcCWNR3RlLt9n4fVhPWQo54Haoi5fslurUbfpop3d2zT1uuCYGn4anNB+Gbl4wWy09hyDwsTxibClVWO9/G+trGOYSDwL
X-Gm-Message-State: AOJu0YyxUJzQkP9wr4rqLkjFdCiYVnesrI3wcl6BH42K6axjQOe4hTYZ
	ixIt/xhdmS0UP+0y4ZNJTv0SyQtOX2EhaArx75SLw3G4N/dmlBZrY0yOZSz62EuSj32kWwqBB4p
	EIw==
X-Google-Smtp-Source: AGHT+IF7zMLJuphWTLkC+nevqZK7ixm1Yql8ScY0ucZbb06AZigHjX0DHxi+uHSzp+K6lZveDOipKORXTpI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1786:b0:2c9:967d:94a4 with SMTP id
 98e67ed59e1d1-2cf2ede0296mr5153a91.5.1721930874905; Thu, 25 Jul 2024 11:07:54
 -0700 (PDT)
Date: Thu, 25 Jul 2024 11:07:53 -0700
In-Reply-To: <203755ada291a1366df78c75c57585aff06f30c6.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-12-seanjc@google.com>
 <dc19d74e25b9e7e42c693a13b6f98565fb799734.camel@redhat.com>
 <ZoxBV6Ihub8eaVAy@google.com> <203755ada291a1366df78c75c57585aff06f30c6.camel@redhat.com>
Message-ID: <ZqKUeUQ3BMYgBNUn@google.com>
Subject: Re: [PATCH v2 11/49] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS
 after vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 19:43 +0000, Sean Christopherson wrote:
> > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > > Reject KVM_CAP_X86_DISABLE_EXITS if vCPUs have been created, as disabling
> > > > PAUSE/MWAIT/HLT exits after vCPUs have been created is broken and useless,
> > > > e.g. except for PAUSE on SVM, the relevant intercepts aren't updated after
> > > > vCPU creation.  vCPUs may also end up with an inconsistent configuration
> > > > if exits are disabled between creation of multiple vCPUs.
> > > 
> > > Hi,
> > > 
> > > I am not sure that PAUSE intercepts are updated either, I wasn't able to find a code
> > > that does this.
> > > 
> > > I agree with this change, but note that there was some talk on the mailing
> > > list to allow to selectively disable VM exits (e.g PAUSE, MWAIT, ...) only on
> > > some vCPUs, based on the claim that some vCPUs might run RT tasks, while some
> > > might be housekeeping.  I haven't followed those discussions closely.
> > 
> > This change is actually pulled from that series[*].  IIRC, v1 of that series
> > didn't close the VM-scoped hole, and the overall code was much more complex as
> > a result.
> > 
> > [*] https://lore.kernel.org/all/20230121020738.2973-2-kechenl@nvidia.com
> > 
> 
> Hi,
> Thanks for the pointer, I searched for this patch series in many places but I
> couldn't find it.
> Any idea what happened with this patch series btw?

Nope.  IIRC, v6 was close to being ready and only had a few cosmetic issues, but
the author never posted a v7.

