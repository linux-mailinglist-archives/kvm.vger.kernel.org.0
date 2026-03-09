Return-Path: <kvm+bounces-73353-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMHRB3oYr2nHNgIAu9opvQ
	(envelope-from <kvm+bounces-73353-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:59:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 749D423F07F
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDEBB3047410
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4575D3EDAAE;
	Mon,  9 Mar 2026 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0JkiFkar"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5D03ED11D
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773082658; cv=none; b=GbutdWA/1EJNRpXP4B1uR4V1B9eRKz9+cadEQwD3xyxVohDS8ffac/eaMsBhKqjnXfvA8Sk9CSc/u2/Nmdg0qVuQCqLIbBFKBXjQNCLYuUIlHSbSYVkSjBDSp2//PinJILrmw2rw6pnSD7uqNqPn7n3FprKNfzzi38F94rFqFUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773082658; c=relaxed/simple;
	bh=2sWkcshK8v9D9vZK4BwTmxDn77rNBZdLtVxpuqk0RrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZVnAbBX8Ipgv7otz8v7/z2v3q8pcVtIZa5wDiTX0OScb2TCOMgTqvt/VjnALrmR0EX1lrv2GltUgTY5RHEipp3KM6LkFLEjSpgVcVYZ7PCio9a0LjHUKRNrWJnn1Lt3youzgyuMO8Mcrp0cGW/4p04NwKf85vjkkSuWtAH7CYyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0JkiFkar; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e24ee93a6so7158106a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 11:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773082657; x=1773687457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cu18vwk9wqpfrSC1zqzF0tmbP6f6cCnfxRa9hLjD9hI=;
        b=0JkiFkar+FAJM1fwAtfw3odRTdVNlNnqPEr8NztkEJRZrxavVSxlIs6bMVew84gvzA
         WGOuFRZDYhegDkOGdc8+qlZIRr5LVQuuuVYJbIp1FEo6H1Fti9cJ8isRk5Bqwppg2oKu
         eh3yCv3kWq7Ez9NhYuWki4lTU+7aeybTYfKbVUJiwudnWoq22+UV+1cww8Bh4H/qoFz7
         KgGSD6tB0Nfhr6IWeo1Nm9UUXLd7KYtN3kUwRzLYeDrSYzNyfIGkmVMXcfl1nkV/JOI6
         aFvW53P0jfGSw5O7Sx4E9Ob8ro6+/N2bkTIwr8TPHFW7d+QZahwFHipWarfURn+pTvef
         wDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773082657; x=1773687457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cu18vwk9wqpfrSC1zqzF0tmbP6f6cCnfxRa9hLjD9hI=;
        b=U6VI+NJv2uzp9bvobfiouakDpF9+kvtSCjp+Pabn4ao7xzI5DzCB+yn+jDvyV0fGyz
         HNw5TzCZMU/+/7spYxFDn0/6F5KXdeG5KdtGOFLRGTNZxgPNS01e80azlNSSp7CSgBim
         RThyHmI3TyEONnT9cHySvKJSbEYbZEyWCqCXtSHhWTA61qt1hKVYx31WjfDaZzgYSuVw
         h5q2Tjp1XChKj0lGHpl4ItqTyaFuhvsZ7ZrcP0oAcDQ0zw+D7Hv/mFpaVArWKGVmCK0A
         rn46MCcK2+oBSFlGXcAVsol/NhZIkpkOIHAPoHj5oDhNqYM5evqXrgJ+BjrNNjASFgR2
         GkyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXClVL1lQC5KQWhM5+QDGdLhICYPQgTdi71pyPudbMyGKftXPU8hoQor4nEDeYlkfFP6so=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8f1Wq2+U+6TG1ylv1KVrWMfrD/HphctxiRIOIHwSLMOXkpjPY
	37SbImm1oL/jfNB/G9sR9wXtuJbWcscJasUZiIvhI/J2ulH3HbgSLKuQa1anVyj8p0C4j7ix5Xv
	MaOqTVg==
X-Received: from pgbdk2.prod.google.com ([2002:a05:6a02:c82:b0:c73:90cf:9638])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:164a:b0:398:5f66:bf59
 with SMTP id adf61e73a8af0-398ab4e40e9mr518308637.36.1773082656530; Mon, 09
 Mar 2026 11:57:36 -0700 (PDT)
Date: Mon, 9 Mar 2026 11:57:35 -0700
In-Reply-To: <7c5d0db9-5151-4edb-9b97-0f0b268cf36e@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-2-shivansh.dhiman@amd.com> <aauGTverUvkEJnPd@google.com>
 <7c5d0db9-5151-4edb-9b97-0f0b268cf36e@amd.com>
Message-ID: <aa8YH4yzXAXGiL4k@google.com>
Subject: Re: [PATCH 1/7] KVM: SVM: Initialize FRED VMCB fields
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 749D423F07F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73353-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:email]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026, Shivansh Dhiman wrote:
> Hey Sean,
> 
> On 07-03-2026 07:28, Sean Christopherson wrote:
> > On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
> >> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> >>
> >> The upcoming AMD FRED (Flexible Return and Event Delivery) feature
> >> introduces several new fields to the VMCB save area. These fields include
> >> FRED-specific stack pointers (fred_rsp[0-3], fred_ssp[1-3]), stack level
> >> tracking (fred_stklvls), and configuration (fred_config).
> >>
> >> Ensure that a vCPU starts with a clean and valid FRED state on
> >> capable hardware. Also update the size of save areas of VMCB.
> > 
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index f4ccb3e66635..5cec971a1f5a 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -1110,6 +1110,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
> >>  	save->idtr.base = 0;
> >>  	save->idtr.limit = 0xffff;
> >>  
> >> +	save->fred_rsp0 = 0;
> >> +	save->fred_rsp1 = 0;
> >> +	save->fred_rsp2 = 0;
> >> +	save->fred_rsp3 = 0;
> >> +	save->fred_stklvls = 0;
> >> +	save->fred_ssp1 = 0;
> >> +	save->fred_ssp2 = 0;
> >> +	save->fred_ssp3 = 0;
> >> +	save->fred_config = 0;
> > 
> > Is this architecturally correct?  I.e. are all the FRED MSRs zeroed on INIT?
> 
> Yes that's right, the FRED MSRs are zeroed on init.

Please use that as the basis for the changelog.  "Ensure that a vCPU starts with
a clean and valid FRED state on capable hardware" is largely meaningless because
vCPU structures are zero-allocated.

