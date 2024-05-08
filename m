Return-Path: <kvm+bounces-16969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3951B8BF5FE
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CB381C21559
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4238A1803A;
	Wed,  8 May 2024 06:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aEUQouJS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C031758E
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715149165; cv=none; b=Gfe2AtLZM7R1zqsPvk/py4kxmlPj1Mt6OXA2M6IoY/DEs2+Wx9gAKl5mF9IkVsYWF0sV2CIpeo25JGkRMujgdB8axqtLv5TRfqRChZzXjcWoP4n9LfbHhGWAPzW7GMMz2pKtpcucxXwQTB8LoGZkqdN2lpR7+Jj31Y66fpErJms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715149165; c=relaxed/simple;
	bh=DymN4p2A+Vsge2z/Iye6njrMgcg+Mh7xY36mVnu2GZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Eq9cCgmX7b48p2ng9DeBMMsBs0CSb1lI1jav51c3obwEVeY83qqk9PThrXRzzFlJy9Zr3miPKZsTlXDA06bjyCLCHQ8u84yFAZsuTj28K3nuxTYS/PVbgJjh1Xl8GbiEtgj3+jh/ihbpY77dfC3pT3I+9X8jGKJ/a/PUzFdM0jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aEUQouJS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715149162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vBdAW+sq1bhL2ar45eOYIKwIreP2ij4Hd9fZNz+NXM8=;
	b=aEUQouJSvpJv211UhZxcm5CTynKC76k6W1BFZGkLZ4sfGJVIa3NkDQGEHVEnnMIvK15QuM
	jwVhv21o2w6ZmIoDtcEiYgMdztcvHaZB0tWaaG1khAOdvGLN5Pf3V7t4kLw71jXKvTRHb/
	YE/GKC2KqLJ6oFkFfsIAwtRhg/sQ3qg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-OJqt5CM5P72HL7GiqAM24Q-1; Wed, 08 May 2024 02:19:21 -0400
X-MC-Unique: OJqt5CM5P72HL7GiqAM24Q-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ece562f2afso4314155ad.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 23:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715149160; x=1715753960;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vBdAW+sq1bhL2ar45eOYIKwIreP2ij4Hd9fZNz+NXM8=;
        b=qR0Krq7e+QOkSA/LBLN3oG2URbsggAbP0H6NJQdsaTjoCVkdW1CIkUydmS4OabWPnj
         9DFG/W9Fw7pBW5hNfSMX9EA8Ut+vS872esMAB1RYTRZQ0Af70HBltFCJCuSgLr8kKlsj
         V3ixsoGL6SzAUgDEIBSmetrKH1tQyC4LZLi0pHo8AM+klurLI7oX52O/P5u2Vu7MOSH0
         mIS6sQA/Q4UUGxr6OnKjnF/uHc/ys5VUWfJgwxeTPwDh9Ml4uvp5CZmKZdxGTHr0xd02
         o2kaog/eGNH73ir7JEuMQQOPWJwjNa88HeBt4QkjyyiHhr96y8FaUdp/7G8uRHjzzofY
         qCdw==
X-Forwarded-Encrypted: i=1; AJvYcCUL8TCbALVR0cvU/8Gp2cDP1FJrOxUrihbkk9dd34mdUQqAMACHFFQo5f8Nms/exQsITtTHpqpYOiv50xPc7eDxvEZP
X-Gm-Message-State: AOJu0Yy9SCoObSiCawhXzDSS4H/Dwuam2J1YEkdMzYcW3jsYvhCSEl6D
	rYhMpL8Q3c4odG3g19qgsoy9+E7imFiF7WGKUOSahWf2xE9c/0FirGPzeQ6wUmSKzIQwXa0GHL6
	kN3VeufBJDqUdXihoO//APCGJa8WE3WMhWaS89Nib0HRGw1jBRA==
X-Received: by 2002:a17:902:d4d0:b0:1e2:c350:b46a with SMTP id d9443c01a7336-1eeabea279cmr32410225ad.27.1715149159991;
        Tue, 07 May 2024 23:19:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtl1BMIXs3xkD1ba/7xv/mpVang9p6KrOLPt7qYZ+54pR3izGDMTZWZji2krpwzlhX/nbo+Q==
X-Received: by 2002:a17:902:d4d0:b0:1e2:c350:b46a with SMTP id d9443c01a7336-1eeabea279cmr32409945ad.27.1715149159537;
        Tue, 07 May 2024 23:19:19 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a800:4b0a:b7a4:5eb9:b8a9:508d])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902f68d00b001eb2fa0c577sm10999265plg.116.2024.05.07.23.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 23:19:18 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Date: Wed,  8 May 2024 03:19:01 -0300
Message-ID: <ZjsZVUdmDXZOn10l@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
References: <ZjVXVc2e_V8NiMy3@google.com> <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop> <ZjprKm5jG3JYsgGB@google.com> <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop> <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop> <Zjq9okodmvkywz82@google.com> <ZjrClk4Lqw_cLO5A@google.com> <Zjroo8OsYcVJLsYO@LeoBras> <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 07, 2024 at 08:22:42PM -0700, Paul E. McKenney wrote:
> On Tue, May 07, 2024 at 11:51:15PM -0300, Leonardo Bras wrote:
> > On Tue, May 07, 2024 at 05:08:54PM -0700, Sean Christopherson wrote:
> > > On Tue, May 07, 2024, Sean Christopherson wrote:
> > > > On Tue, May 07, 2024, Paul E. McKenney wrote:
> 
> [ . . . ]
> 
> > > > > But if we do need RCU to be more aggressive about treating guest execution as
> > > > > an RCU quiescent state within the host, that additional check would be an
> > > > > excellent way of making that happen.
> > > > 
> > > > It's not clear to me that being more agressive is warranted.  If my understanding
> > > > of the existing @user check is correct, we _could_ achieve similar functionality
> > > > for vCPU tasks by defining a rule that KVM must never enter an RCU critical section
> > > > with PF_VCPU set and IRQs enabled, and then rcu_pending() could check PF_VCPU.
> > > > On x86, this would be relatively straightforward (hack-a-patch below), but I've
> > > > no idea what it would look like on other architectures.
> > > > 
> > > > But the value added isn't entirely clear to me, probably because I'm still missing
> > > > something.  KVM will have *very* recently called __ct_user_exit(CONTEXT_GUEST) to
> > > > note the transition from guest to host kernel.  Why isn't that a sufficient hook
> > > > for RCU to infer grace period completion?
> > 
> > This is one of the solutions I tested when I was trying to solve the bug:
> > - Report quiescent state both in guest entry & guest exit.
> > 
> > It improves the bug, but has 2 issues compared to the timing alternative:
> > 1 - Saving jiffies to a per-cpu local variable is usually cheaper than 
> >     reporting a quiescent state
> > 2 - If we report it on guest_exit() and some other cpu requests a grace 
> >     period in the next few cpu cycles, there is chance a timer interrupt 
> >     can trigger rcu_core() before the next guest_entry, which would 
> >     introduce unnecessary latency, and cause be the issue we are trying to 
> >     fix.
> > 
> > I mean, it makes the bug reproduce less, but do not fix it.
> 
> OK, then it sounds like something might be needed, but again, I must
> defer to you guys on the need.
> 
> If there is a need, what are your thoughts on the approach that Sean
> suggested?

Something just hit me, and maybe I need to propose something more generic.

But I need some help with a question first:
- Let's forget about kvm for a few seconds, and focus in host userspace:
  If we have a high priority (user) task running on nohz_full cpu, and it 
  gets interrupted (IRQ, let's say). Is it possible that the interrupting task 
  gets interrupted by the timer interrupt which will check for 
  rcu_pending(), and return true ? (1)
  (or is there any protection for that kind of scenario?) (2)

1)
If there is any possibility of this happening, maybe we could consider 
fixing it by adding some kind of generic timeout in RCU code, to be used 
in nohz_full, so that it keeps track of the last time an quiescent state 
ran in this_cpu, and returns false on rcu_pending() if one happened in the 
last N jiffies.

In this case, we could also report a quiescent state in guest_exit, and 
make use of above generic RCU timeout to avoid having any rcu_core() 
running in those switching moments.

2)
On the other hand, if there are mechanisms in place for avoiding such 
scenario, it could justify adding some similar mechanism to KVM guest_exit 
/ guest_entry. In case adding such mechanism is hard, or expensive, we 
could use the KVM-only timeout previously suggested to avoid what we are 
currently hitting.

Could we use both a timeout & context tracking in this scenario? yes
But why do that, if the timeout would work just as well?

If I missed something, please let me know. :)

Thanks!
Leo


