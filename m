Return-Path: <kvm+bounces-57645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A66FB5882C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 01:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D84B1633CF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8173229BDA7;
	Mon, 15 Sep 2025 23:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t1P1rSEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573352566
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757978585; cv=none; b=kI+Pe2Q1ILeB/+HSrxEFNYdfeortEQM43cMOiEPYY2gewyFBzjdl7T7kn95KMRlNVdfTPc+3pFlILEyj+84HghFtn1caMntM5evWase27MeguE7PI6mPrd8Fel2TNALyHr/8aarENvXLBA991UKANwEhO7X92Z2g4co8E0gdZE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757978585; c=relaxed/simple;
	bh=Env/AntPKSkjLsebztGACuctIt0PCOEgMZGXvgjVkmw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kSGzMr6IY9yEwaYooC0R1ocL/G+vtW9eXvgL9pgt9HsRGSd+srH9TmJuwS6BwuLSSj7U2Ddde+kozEPgwutCyadrqhHgFkVztkpBBmehKs2ZV7sKQ1SXQg1UrgasH9kVqWPgQrFomhXHOgn84mSH3Rb+p4KhwS429Kc59+RvmfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t1P1rSEo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7724877cd7cso4826847b3a.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757978583; x=1758583383; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JY8IqBb0XZLGfYkw520FjcuWQsH8qA8f4RRPeAnCgnU=;
        b=t1P1rSEo6W5pZXXxBIHcUKQ+tHwAGRqHBnL5feM+jzDXAeMrzlU/56YiRgBVpDROYi
         3Bw0GoMIXFJbT1b2kQ6/2SuQT0/r5uR4PzdBAjxUKDLZPqOkh5i1c21h5OcR9VygPlql
         su1lfx0HB/pgSvgtXSUWpxf8FdIFYKBNrvNsb7kFnHnxC1MnXpyNssb1Y+jIEcIo4SK7
         ZaPoeQEEYh957UfYA1ArYgBNbhIWlCTuN0/9js15fHbhqhuN3NHGZKdsdHhG58lKIkqQ
         dX7trsuf+T2BjevJ00M3QFndAuzYZlxaAG6EQn8pLrynRI6DvU/O5pX2LIQqKNkQDaLC
         rPPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757978583; x=1758583383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JY8IqBb0XZLGfYkw520FjcuWQsH8qA8f4RRPeAnCgnU=;
        b=NeWLChVMEC1N9O+3SHnbQ8tohpIb2NRPYbk7S5jgc6Mo+2Hv7s8XUc0n0SvKCZmdr0
         J/9zTgvvkmkrB0w0GEExxSJZTBdqInKZDs+gxDZFFNk3EY7xZRBUlVI1ouVQvK+s0coR
         mOdf9Jrf0FrDwdNE5NDmDH7miEo4BTtSkTXgiPXM7dgs8+/mfslcYYdaceAp4QxJ+5Fy
         oGV9dmWVceHh6Gut9q3MQZvK3JA0YtDL9PaQ4eDSJiFG15V0LBhFGh+2RL4wARUvBi8A
         2EiPw/6r4rcVnxp5U1DlsiwawroDw18tGLraHqYumEqCHU96+8QYLVxHohYtMjp4yif0
         lEsg==
X-Forwarded-Encrypted: i=1; AJvYcCVYPblwnu4pfdgnZid1t3bDqW9poyJoTCah7vX3s9bU3cHAN74aT+EJaM7dZb9U+4WxZfU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/bq+XNwc/q6prH8ve/7b0nK0FjsAn0+tiMx1+/jU39a7FlsVE
	oe44MQLUw0aOTaOGxdu75+hHxivDonMGjgJ+3/u92CY3RdOzkXgq3b/Oil6rezsKZyr+iFfbLpV
	g0YrqNQ==
X-Google-Smtp-Source: AGHT+IFRFqH6g0w3QjPAH1ehnfeRlkl+mdRbz1OYdNdePQpnNDXe8z4qOmXeC/eqWFhBaEPWNG2ojmZNRf4=
X-Received: from pfbcb8.prod.google.com ([2002:a05:6a00:4308:b0:775:faff:e6f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:891:b0:772:f60:75b0
 with SMTP id d2e1a72fcca58-77612180270mr18051902b3a.24.1757978583508; Mon, 15
 Sep 2025 16:23:03 -0700 (PDT)
Date: Mon, 15 Sep 2025 16:23:01 -0700
In-Reply-To: <cover.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org>
Message-ID: <aMif1bI7dCUUBK4Z@google.com>
Subject: Re: [RFC PATCH v2 0/5] KVM: SVM: Enable AVIC by default on Zen 4+
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> This is v2 of the RFC posted here:
> http://lkml.kernel.org/r/20250626145122.2228258-1-naveen@kernel.org
> 
> I have split up the patches and incorporated feedback on the RFC. This 
> still depends on at least two other fixes:
> - Reducing SVM IRQ Window inhibit lock contention: 
>   http://lkml.kernel.org/r/cover.1752819570.git.naveen@kernel.org

Eh, I don't think this one in is a hard dependency.  Don't get me wrong, I want
to land that series, ideally at the same time that AVIC is (conditionally) enabled
by default, but I won't lose sleep if it lands a kernel or two later (tagged for
stable@ as appropriate).

Practically speaking, no feature the size of AVIC will ever be perfect.  At this
point, I'm comfortable enabling AVIC by default and fixing-forward any remaining
issues.  And I want to get AVIC enabled by default in 6.18 because I think that
enabling AVIC in an LTS will be a big net positive for the overall KVM community.
E.g. we'll likely get more exposure/coverage when distros/companies move to the
next LTS, it'll be easier to manage LTS backports for downstream frankenkernels,
etc.

> - Fixing TPR handling when AVIC is active: 
>   http://lkml.kernel.org/r/cover.1756139678.git.maciej.szmigiero@oracle.com

This is queued for 6.17, just need to send the "thank you" and the PULL request.

As for this series, I'll post a v3 as time is running short for 6.18 (one of those
situations where describing the changes I'm suggesting would take longer than just
making the changes :-/).

