Return-Path: <kvm+bounces-71056-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yL+XF7dCj2k5OgEAu9opvQ
	(envelope-from <kvm+bounces-71056-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:26:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3716137820
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61F5330459E4
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8894C363C59;
	Fri, 13 Feb 2026 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yT6C+EOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1607356A2B
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770996397; cv=none; b=gRwzGT6KGrpC643Ich8ab2VP3H7tN6tX6m/KEV0TJzkGhKpG2z8+/wwv2mRF2Tqrkkdu8Q8MA2mXSrQeNBRUqygb6Bu6VGr4m+RdyUFrIfZt1Lo+evzoGg7Gnn0JdpE9jVIHQGVaz4cQsaXKF752winT5SQ1zV3xUXzhZ0oO/10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770996397; c=relaxed/simple;
	bh=pi30Pkn9PzCg21hY3eOknzX2n23fwwsolli8HC/B4fs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ivSbi2zIYVEaTyumbO5uBrDLip6BdwmSIcJjOIQuudejOhX972fZIlvkDcVYjlq4UV3UNp4K+ZmrSBpcNbtF5v2ojovNSzLN3DSf+elQ6FupMY9nAN1dkW9b8I3L9/YgD56WXysskIC8xspPRC7C7YiSjEnU8ZWV8QswdMvRDDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yT6C+EOv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso3951175a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 07:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770996396; x=1771601196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4NZ9EGPtUS+7RRQiNTrvozs7Ig+vPBqmlPOteC+yYic=;
        b=yT6C+EOvEMKLYtMSVsK0xda8I99aVSiS6HlrJlYxo02SMBeU273Hm80fn6lZDGk13p
         aYQ65emOT8i8EvHzoNI1XY/MD+0yKeD5dBdnuiNTfu0Z3JT6dSV7Ae5m6vk6QCsCE1G7
         y+6xUn9CD7AJxGK7KEFgIiecU8ry2WwCCT+HrWxUJtp4JA2ThKVZRCR6X7yszcrsVBHe
         jihlvzIkIAQPOZaswKj1THEgF3KK4CWoxEo+romZwP8r7i+WcGTgixl9rIxu9sdBsk/y
         Yr3uyizCxyEu7r+5yZPcV18lIECCtbMhgrKAugD7QL4NXyEIOJk7nwNgKQkCdRhvOYzB
         eo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770996396; x=1771601196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4NZ9EGPtUS+7RRQiNTrvozs7Ig+vPBqmlPOteC+yYic=;
        b=f+1qz4/3rgQ+/+8Sj1EGwqBe6tM/eecTiByKl+Ko6yzrCafIG130Ees9OGXNbHprSA
         3NTJ3JBK48lhaXzp6MKCAC6DjW+kaBpKbUc5UxgCY2stsrjfF59arG6gHNzEPOmEGLhi
         IKnpUJ+GRVidYbCjCy5PzcgJ7EnO6gwoHKO61xOsQwLfldfqjraVeezwaGf+WIT6/J2o
         Vs1eJLyjETmpt3ZQhwsO/Z46WYyG7NeB4WoldOt0f+4uh+KRXfnoqX6VKi9IjU5moc3z
         m9srM1LiQEA80jN29r+vY/vUlZf0wL9tgobmkIJHhVivnXivyT+E9Jgd+H23F5W89tz0
         EipA==
X-Forwarded-Encrypted: i=1; AJvYcCWTavs0AguUqa3UPIRiMdeptFaOpmp4nHW4afjiXNLVKqNyWbmh/ZhpPpm8DWrorP0WJac=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOFIyqTNeFjpBwMXAegOgkr6J55l78dvtmiIw11+54lggX3zzU
	KQAEp1z+wvCdZVU1wJuifNXcnZtjrL1yYbmJB0YnZO3ewHYlU0JOEWjOB4ErRuDFzXB0pdG10EH
	v80VJeg==
X-Received: from pjbqb7.prod.google.com ([2002:a17:90b:2807:b0:356:1edc:b2a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc7:b0:354:9b26:cdf8
 with SMTP id 98e67ed59e1d1-356aab9a321mr1928853a91.10.1770996395984; Fri, 13
 Feb 2026 07:26:35 -0800 (PST)
Date: Fri, 13 Feb 2026 07:26:34 -0800
In-Reply-To: <f72gve6ia3aqcpkqxzuwnleaxzxmesapzmoaus6bwaibsq5f2g@hgq4z5mqxykh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-2-jmattson@google.com>
 <f72gve6ia3aqcpkqxzuwnleaxzxmesapzmoaus6bwaibsq5f2g@hgq4z5mqxykh>
Message-ID: <aY9CqmlpZb2Unh0y@google.com>
Subject: Re: [PATCH v4 1/8] KVM: x86: nSVM: Clear VMCB_NPT clean bit when
 updating hPAT from guest mode
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71056-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F3716137820
X-Rspamd-Action: no action

On Fri, Feb 13, 2026, Yosry Ahmed wrote:
> On Thu, Feb 12, 2026 at 07:58:49AM -0800, Jim Mattson wrote:
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 0bb93879abfe..9850ed01e16e 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -434,14 +434,15 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
> >  	vmcb->control.clean &= ~(1 << bit);
> >  }
> >  
> > -static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
> 
> Huh, I assume the removed of vmcb_is_dirty() was not intentional?

Regardless of whether or not it was intentional, IMO it's a good change.  KVM
should never check vmcb12 directly, and I can't think of a legitimate case where
KVM should condition its behavior on vmcb0{1,2} being clean/dirty.

Unless a v5 is needed, I'll split it to a separate patch when applying.

