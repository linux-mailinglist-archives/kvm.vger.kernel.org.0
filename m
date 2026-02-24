Return-Path: <kvm+bounces-71627-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNaOF6HZnWk0SQQAu9opvQ
	(envelope-from <kvm+bounces-71627-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:02:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A4018A3EC
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F199A30A846A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFD093A962E;
	Tue, 24 Feb 2026 16:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1ozOKkeH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5AE3A9014
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771952043; cv=none; b=LrDDsatMYo3t9DNW5r2Sg+OFva/TWJa+myEmikTtPyofDC1g8Q4VHrDymYw0edJuFeluopaiMF3HxUX8RnjiObGJrNXm4wg2AdXr4Gn7TXkdPQYp7X/9x7Mnwvzc38zFKNJPHKtxiAWBICbETUKWtxnwrDluuEmhJSM6JGA7JVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771952043; c=relaxed/simple;
	bh=dxdLkEr9HO1lfK5ZRmtSdayjHPORyjOrNXj4iGn7ucQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gs6JsohbFvzgTOBg3TxmGBW605EXRRev8wyUZcCcwhVkgllYYC4TNrvfpBkrt0TpQiIJDWWh+DCCAhvB1EtWp5hgq49pRoK4JSCWsp7CYAjd1Jm+YOW0iCWk6fk7VbBrtteGWUZJuiz2r307GgCWTldt4tPd4enit7A9T0siiXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1ozOKkeH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ad147cdf07so61627655ad.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771952040; x=1772556840; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fx3rYBrGAPp95i6QwzqVGUinfO1R1iWt+5aDys+G0f8=;
        b=1ozOKkeHN+HBO484h3+L7AzU4+G/4TKIknVeSss5doNbOlzeVC4zmttGL0cbTRL7pb
         8PFRYMt2IgZt9/1RULB0fAFWycENfFEhRlzM3IDTLgaamQrrMmIUVhIba+i2f2pSYkqw
         rlPIVh37/8gdUkUHbF4y1ZzLRcOFQzU741TAK7yW8rxENA672ESsVyAcjxK3ZDWSbTrN
         NcqsFir9vgsMnukXo0+IjAsWMdMYErktEntn4aItCCchLOYaDFEYd6lmTtT32biYifSm
         JxaHG85w8J3PL7GHGwby0DcKHFNS51h4+frj5InuNNzARj+T6XsvVS1RXuwjAiJnE47x
         x2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771952040; x=1772556840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fx3rYBrGAPp95i6QwzqVGUinfO1R1iWt+5aDys+G0f8=;
        b=cVqPZn6yh3Q9u8M9m+nRh8o0d/i1YLK4N1gf6A8noWXMDU1Jo7QBiR8YUefUJpFv41
         D49r7xpaJwJT+L6OXNWUSNTibjgiWTUCaZCMKx+95VyC9yf9zjILny3rY6bajqWkfFja
         MsoqjKf79c+4MFJcAOwWiV+EGIFcuySWfgxcQPXhjkOTIVplmG2pOk2zGMX2t/yCO15G
         dMiD4d8YUFWBWKLGmmofLgPUuxNLEmj+5O589iJIkDd+zzGwmeueAv/3ONN2aTMTc2/D
         PY7l+Se9iaWOlX3+AqHU/mIsFsWlMcYRprSiTK5RAirwGAvX6RZw+PrqvaiaAEQC17Nl
         0ggA==
X-Forwarded-Encrypted: i=1; AJvYcCVAP5jK69A2JPbUyFTcsy4mMYEBmuRa93kP3k9hwcVMWHwi2RHzXw2dzaZ2rgqTK8O8bE4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi3/Lz+IfULqQAbPaFxFV3hVsMRdE7Odjp1RJwapWARRnAlvQP
	LRXANlkcrr2Jcax6JsNkYic/hlb9q1DQ9lDQ0AzjunfNvBUC6AIVxAZUsRElaZmUMbZO7Eq2vwx
	BLumuRQ==
X-Received: from plil12.prod.google.com ([2002:a17:903:17cc:b0:2a0:96e9:38e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e542:b0:2aa:ecec:a43d
 with SMTP id d9443c01a7336-2ad744a0062mr148401575ad.21.1771952040020; Tue, 24
 Feb 2026 08:54:00 -0800 (PST)
Date: Tue, 24 Feb 2026 08:53:58 -0800
In-Reply-To: <aZ3VCq4s7l9f4JTw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-3-chengkev@google.com>
 <aZ3VCq4s7l9f4JTw@google.com>
Message-ID: <aZ3Xpq_v4q8bpGrJ@google.com>
Subject: Re: [PATCH V2 2/4] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-71627-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B7A4018A3EC
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 37eba7dafd14f..f148c92b606ba 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -385,18 +385,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >  		real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(table_gfn),
> >  					     nested_access, &walker->fault);
> >  
> > -		/*
> > -		 * FIXME: This can happen if emulation (for of an INS/OUTS
> > -		 * instruction) triggers a nested page fault.  The exit
> > -		 * qualification / exit info field will incorrectly have
> > -		 * "guest page access" as the nested page fault's cause,
> > -		 * instead of "guest page structure access".  To fix this,
> > -		 * the x86_exception struct should be augmented with enough
> > -		 * information to fix the exit_qualification or exit_info_1
> > -		 * fields.
> > -		 */
> > -		if (unlikely(real_gpa == INVALID_GPA))
> > +		if (unlikely(real_gpa == INVALID_GPA)) {
> > +#if PTTYPE != PTTYPE_EPT
> 
> I would rather swap the order of patches two and three, so that we end up with
> a "positive" if-statement.  I.e. add EPT first so that we get (spoiler alert):
> 
> #if PTTYPE == PTTYPE_EPT
> 			walker->fault.exit_qualification |= EPT_VIOLATION_GVA_IS_VALID;
> #else
> 			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
> #endif

Scratch this comment, I got my walkers confused.

