Return-Path: <kvm+bounces-17645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A06C28C8A36
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3BDC1C21B3D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13AB913D8A8;
	Fri, 17 May 2024 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pU5YeO8H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF5C12FB28
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715963893; cv=none; b=iVLa3bxzIA+ufuleKMB2rYo4s5/48sNsydtaePpxvheIGryu1NYfohvI42JC3Lfzer44z6cg70pPJ5Ktxm+/xNp2P6xJieBJubqTUvUruKVMUxxVfhj5JvGNmyyNYQ1Lxcu6kxXRYk9n+ItqHhEWJFc/S+PzLmJ4OXTJXCOCuBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715963893; c=relaxed/simple;
	bh=BZ1BDAxsb+ELKe8160sLktY1ER4EDr9oqSJLPNna2NQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UgFrtJMXldaNll5Eno1cDVTbqc0Hfr6LXkh/CQBZ9vI7UV7ihSgi9LcWZNQcRD/quZsv11hwl8V42lCsNkX4YM9TBQq2YVmNU/0kmArByl5VkZN+3lWujydgDo9cQJ1P96wO/MQMzuLN6p/x/4Yz2b//NbWsCv61Dw2Lu9nrrUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pU5YeO8H; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de603db5d6aso16882377276.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 09:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715963891; x=1716568691; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Rmi2OkZMH5QZdYYuvCphZHTTfn19TkxZp9MFoDCGOE=;
        b=pU5YeO8HBmmq2U9vMvOghGJOaIv/d4XyZQZIOvKUiBjt0BqM7u7AAeQFlYVbFxQtqq
         fTe3n9T2jbMya3C1Ucxg2yT1JMsB0AeBGyrS4aY4k7GCSkUcH9NIrRPj9KNR4GFCvKz5
         bo/VzHBUeuRgUDlQpDAARIGlV1pJbwdTpz/hK+VgsvGticz7qCXjbNt2wxcI1s9s2TXF
         S3Ip9qCpzcHf46DcBB3h0Ccr4xGIg1sjJV9If01InXcpmSF/nkSn1Re+r83mPrLjHA6r
         cwuSgzWHh61G+tepkws/gNbpAlvtlpkBpxM2qRUVLLOWQfJQLY/KUl7nVXJLFwHxMMVs
         KNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715963891; x=1716568691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Rmi2OkZMH5QZdYYuvCphZHTTfn19TkxZp9MFoDCGOE=;
        b=otK4F4Bp6YejeKKwAXLZPbYI4QgwkDBq4lC6c1PSsjX8trePzb3RZ+WcQJDZTZLMlb
         Qcs9O8htkYz15p6YD4m6HFH/jG982G+OWYGU6CArAr+q2DXt9/Do9XXSvarkemT5Ek+K
         imI645+oqBtbhJb7iCkI2Po/s/9ZxnjMFfLNKrDJdOS8ocAqL0W6bTeJYznfBfSL7EVA
         nGuXaLPEK+qT6A/iZfmqhH4FWXp5QeZIeqbJXr4kSAz1/RVxYbFh9gckUM8Yw3lpxWxZ
         VGywVYCZ6v2OHjxc48gorEkJpPXb4Zlvw7W5N5CkODK8KVHWD2Lo7nbxISVXZc72+6SN
         S6rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOSw15qW/UQ0kNIgzB2A9q7ERtiuwGPOzDKQQNyTPP2xOhlo1BknNnRXqEU731JqtC6o7SWheWBGD4aEKpsCVfXTcT
X-Gm-Message-State: AOJu0YyOmRqoGkelXK4Fc/tPhVkspMS8/VJCJ6el4uxgkS/Kk4a5dz11
	kgQpzBIK9ZepSiD6EGb9gA6cic8lITJs5ZZJ9Cxv+t6pc1Qd0buJgtSoOVE2hVwB6A9zplq16VR
	Nng==
X-Google-Smtp-Source: AGHT+IF/9Aa72Ydb5eP7L+GfU+usv8RTuvVFoLdOPlX0aPRURze+Lq0YYeF5kTUSbmO7ywgdiRN2J9qpQoI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d3:b0:de6:16d6:2f34 with SMTP id
 3f1490d57ef6-dee4f2cf908mr5519340276.1.1715963890888; Fri, 17 May 2024
 09:38:10 -0700 (PDT)
Date: Fri, 17 May 2024 09:38:09 -0700
In-Reply-To: <7c0bbec7-fa5c-4f55-9c08-ca0e94e68f7c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240507154459.3950778-1-pbonzini@redhat.com> <20240507154459.3950778-8-pbonzini@redhat.com>
 <ZkVHh49Hn8gB3_9o@google.com> <7c0bbec7-fa5c-4f55-9c08-ca0e94e68f7c@redhat.com>
Message-ID: <ZkeH8agqiHzay5r9@google.com>
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 17, 2024, Paolo Bonzini wrote:
> On 5/16/24 01:38, Sean Christopherson wrote:
> > On Tue, May 07, 2024, Paolo Bonzini wrote:
> > > @@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> > >   	if (is_invalid_opcode(intr_info))
> > >   		return handle_ud(vcpu);
> > > +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
> > > +		return -EIO;
> > 
> > I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
> > the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
> > still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.
> > 
> > I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
> > there's another bug lurking.
> > 
> > https://lore.kernel.org/all/20240515173209.GD168153@ls.amr.corp.intel.com
> 
> I cannot reproduce it on a Skylake (Xeon Gold 5120), with or without Isaku's
> fix, with either ./runtests.sh or your reproducer line.
> 
> However I can reproduce it only if eptad=0 and with the following line:
> 
> ./x86/run x86/vmx.flat -smp 1 -cpu max,host-phys-bits,+vmx -m 2560 \
>   -append 'ept_access_test_not_present ept_access_test_read_only'

FWIW, I tried that on RPL, still no failure.

