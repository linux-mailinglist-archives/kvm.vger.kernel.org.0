Return-Path: <kvm+bounces-51943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6790AFEB8B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 895071C87864
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5ED28135D;
	Wed,  9 Jul 2025 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J3OokrYm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE262E7F20
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752070016; cv=none; b=l2KUJR1e+rQFkKa+571gmAp+FVsJnFucy2Q20hDIBS3LO8xf6xLOgb4dBIAyz95SKo8VobBZVUxQFtCWsiSY3Ui8C+m7Sl7lm9Y0k/hLpYDWLVmnsWTyvWLoozy0rWl/aIWNsNeymZpciAytKyQzYwdzkJfYww9fCKYgAX1mxCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752070016; c=relaxed/simple;
	bh=hkntFlFAHX/8LClrortGJsunMQhI9Rf+tcTEWjk0YoQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tGLYoGNASKWkdR/GEwhFrcrwrp9SfWFyf13Ie19mBv21YMoTs4iqzK46UAInKkM+GScij7AGyh96j1lTYYjMYswOGrYZL2LxKuL+IXBSW46xzjmHx3yl1nRbS3bjhL5L+uDP3CWaQ+pBkh9WF2At958Veb/Og/Mag5pto/+AIQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J3OokrYm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e671316so882950a91.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752070014; x=1752674814; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w8fWPt2BfkTPkJ9RpJOZFh1liGwFojbw+uk1VvqODzg=;
        b=J3OokrYmX6HWOzk9nRg/w+JEis1zh89IA6vQ0vjsG3C1JXQBLB8+V5vqVFp//q03DB
         6CFlmbWqfvVgiz7fwoFDkssgbM5LvzaFsLOdmlzKO1RQnQiSHrJJMNb6QgW5xauC7E0G
         KRGEWX2smoIWPYM0uxPYKsNY6gjEYjrpUeCAczZzGK9D8zYbram4J9Luzj0CZQbK1M0h
         ijAX7u4cON4dhGX4YQ/pW4BT9YplgHSnAdb74vrXgxIXdKCQyOmKY6Y0fXdabp6V8CBa
         UBcOICRQV0rDtgfm+PSNNCcJzhuo4y7FaFtz0oDW0U3GlJ4Hbp2+yrv1bq9eTplen0t1
         EifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752070014; x=1752674814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w8fWPt2BfkTPkJ9RpJOZFh1liGwFojbw+uk1VvqODzg=;
        b=oZJ71ujzA8NnY++2YhdkjMapbQ00OryFycV86ISlxUAGx8O98ZKDKnf93X3pbz2eWO
         KQSg7hu4eC0onGUSH9DBQ/bJC9hCTVr6eOThBprIXWMMwN3/1djzcl5NHAdNXS14vBfC
         ozNoXegBmuu58KzaY8EqMj5lh47SxigJEwh1+lBcnDtJ21es2hxLX/dBNly1u9FqF+oT
         vxbQSiZwVBSfOKHwaZWzXRc6ro1yNejMu7o9721m2WyylMw3jVteqNk6uqfZDGY7KUQA
         83tjS6XeodzNFEyXoRpajS/vHUfrOqeFMTFOYtLprimQUJERQaiFeOJM7SAxgvOkwi0M
         8Ddw==
X-Forwarded-Encrypted: i=1; AJvYcCUyJEPk3jTrpCfkHy0ohOU9ACDpgyrJRahK6846DVM/oFQ/iayBcoVfVo40tXs2hR7VQW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ9thNy8y1sFwFMvxe2rWfaZAo9xIMUm6ZI4NFZX85XpPioFxm
	TMGWZdWlZ+swKum5O0N9Eap9DCKpgkYctswUFCrFKvgnm0NQWQE5de5kjGN1ksJ2fpRCRBv8EKq
	+dDJuiQ==
X-Google-Smtp-Source: AGHT+IGIWsx7d/E56vX8/ELK8FvDCsCc7kZDsZlRa7N3LnxbBm/kaiz6qFgCJN+q7ZZTN94p0dGqXi8ZWKw=
X-Received: from pjbof13.prod.google.com ([2002:a17:90b:39cd:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec85:b0:302:fc48:4f0a
 with SMTP id 98e67ed59e1d1-31c3050462dmr4342914a91.0.1752070013937; Wed, 09
 Jul 2025 07:06:53 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:06:52 -0700
In-Reply-To: <20250709033242.267892-12-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-12-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53fJ9VlLxurnKW@google.com>
Subject: Re: [RFC PATCH v8 11/35] x86/apic: KVM: Move lapic get/set helpers to
 common code
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> Move the apic_get_reg(), apic_set_reg(), apic_get_reg64() and
> apic_set_reg64() helper functions to apic.h in order to reuse them in the
> Secure AVIC guest APIC driver in later patches to read/write registers
> from/to the APIC backing page.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

