Return-Path: <kvm+bounces-22072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC432939736
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 01:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8860F2822F0
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 23:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC2F7345F;
	Mon, 22 Jul 2024 23:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gbeTtmJT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9AA6E5ED
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 23:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692690; cv=none; b=RRPk1gECyoBrrjWgxTCjmHRZ2w48ivU7rWhk8kqfEYPY4LjrLshK7stlOU5O2yDN2WSFzFz9tMNtMduaJRpFx3soSo4cEWqSNza3oyhxTZHrRtNMPC+trGtBP/UlqI2GoPTvbInICXgSdid+Vr9IODdGxejhwM/awALKVAWJU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692690; c=relaxed/simple;
	bh=DkseDYfGNcDzvbqyqU0DKg6iWql0jky4zKQP/8CT7IQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oXTmxk48L+8j7u3cNudjTyUSuttyaBHi6rcI/EAGNFQgT8N2At794RHSCvCJHTqem89L0ZBQRHa2XvlNPwuVD5wGgUAXYrVzw+KP0THq6TjQPl8Yw7nQRRdcMsE2wCEYerIKakZq3G/9iGtDFDHqJG4qLmrh2MuTNaioIzWx4qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gbeTtmJT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fca868b53cso883955ad.1
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 16:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721692688; x=1722297488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NiszAb6OEqq/qypn9MCSLFVFctQpfQJGPfYT/lahHTw=;
        b=gbeTtmJTKeWPlkVg5mJMEotFpEDrEIaK5+/qOiljBBUXFd0ByApQBtBohLGwDuED5t
         te+4SmnXdrQyh7iGL47rZhvxcpZqyNe307EllKUcPWn2kLOAFXlj1WWIDtarMI2gJoiR
         X8Fyr9qIN+jin5fxyDeAbiNVEZKzMB1vdn35frvMfZ/BIwLJHr85PamnBa/0Dk31Hy/l
         kzEfG+O5EVH2UCp/7fb8hhwm9jffCKS3l9T0j/VWZ7SNmjsQCkSSlXzo9ItkQNugATUt
         FqaW5eqYtW++IsvXnChWfELHHaKSaw3PAF+C4DO7R5FqkCWkAelgefIJgmcbxEvn7saj
         KT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721692688; x=1722297488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NiszAb6OEqq/qypn9MCSLFVFctQpfQJGPfYT/lahHTw=;
        b=iHz220GsLxjwZH0lrfTS+AM0mWGcU6kp+RTAB617bmI4IuckmM2GsgFDdHEkNUk9rx
         53AoXNIMYBKBRujd3WuKxgeuIfWzJXp6xFN1Yj4jD+JdZ9XkkhLu7VxL5I+t+AOS7k6A
         FSE+uHmf96NjUYMkhcrLVXcOXlvq16JqDdbi1608juXQWNaYbG7kgV/QWHn8DYZeF6ce
         Wnq4ZyjDxkoIIKsq1WORIKass0p8DXytPylBp7wJkg9R9tL7pmnl/tnllx04UKPNaC57
         ncUC//UAL2WFasrZj8xBzxRUXbp2rKRHLPhwzR0hEjJIEhiJiQRPbiiT5eOJPu/OL+iO
         HZ/g==
X-Forwarded-Encrypted: i=1; AJvYcCVADUV5cR0Tw9JE1rZ6cx9K3J7F5RxYgda3sUkqBlw462oHydauFxVahcTvJoRHMd5sg2pocNhLzDnqZbKOHRVp3TWH
X-Gm-Message-State: AOJu0YyGxTCh8/8SLqoe4QanZyRpSMARuvTzU67a3icgqnfRCwpuhidr
	JBdnJj3SO9VelyTvHTFf7p1/1f1flxG/FQDcUzBZ3SV4yeu3wMnxoc/dR5mFBO2jj4r0wdj6awW
	D4g==
X-Google-Smtp-Source: AGHT+IGMCIJ7k/wO1EtyoCI8S2HbGG8sVrIvZRS9cKnBzdCHGWdrefCpopFvU1Qotp33npJMX/2I7gM4+Os=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e887:b0:1fb:1ae6:6aab with SMTP id
 d9443c01a7336-1fd74513c53mr8074635ad.2.1721692688226; Mon, 22 Jul 2024
 16:58:08 -0700 (PDT)
Date: Mon, 22 Jul 2024 16:58:06 -0700
In-Reply-To: <Zp5Wq1h40JMSYL5a@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com> <Zp5Wq1h40JMSYL5a@chao-email>
Message-ID: <Zp7yDvcwfPtgED0j@google.com>
Subject: Re: [PATCH 0/6] KVM: nVMX: Fix IPIv vs. nested posted interrupts
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 22, 2024, Chao Gao wrote:
> On Fri, Jul 19, 2024 at 05:01:32PM -0700, Sean Christopherson wrote:
> >Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
> >nested VM-Exit instead of triggering PI processing.  The actual bug is
> >technically a generic nested posted interrupts problem, but due to the
> >way that KVM handles interrupt delivery, I'm 99.9% certain the issue is
> >limited to IPI virtualization being enabled.
> 
> Theoretically VT-d posted interrupt can also trigger this issue.

Hmm, yeah, I think you're right.  L1 could program an assigned device to _post_
an interrupt to L2's vector, via L1's PID.PIR.  Which would let the interrupt
into vIRR without KVM checking vmcs12's NV.  It seems unlikely L1 would do that,
but it definitely seems possible.

Unless I'm missing something (else), I'll update the changelog and Fixes: to make
it clear that IPI virtualization just makes the bug easier to hit, but that the
issue exists with nested assigned devices, too.

