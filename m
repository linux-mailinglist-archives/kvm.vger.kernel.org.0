Return-Path: <kvm+bounces-62954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B93C54B57
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 23:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E40484E127E
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 22:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8752EA498;
	Wed, 12 Nov 2025 22:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhaeVo4s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9735CBB2
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 22:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762986236; cv=none; b=YXJ4IYz7+Z2k+zmWPhIQRO284yfbV2ZXMcx7ccxKJSQA1TXxaKjD6Bor1tpuwxe6zUITIgpDmvr+dttAiKhvjaK5FFz1aQlw6RJBFNBkJUONtQFq8QGSgCIEP72UuofBJVyDO4EPkZlAmWY3j15QtBUlo1NfPHZU9/xRg9PgfXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762986236; c=relaxed/simple;
	bh=1dATqO0nEuFQDqeYmGHYSBBpQc0Dmbg+kkj7JSrXrEk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EJNIG5LJZiF1e3i51o2ahmdYWJw+7L4CvSuD3KJMuR9+6aj6n+gcxcjaDHjIsQfmhDPtoEkwaqJ6uHAFYyqwg6kMyAxGMroS6Gmxsi2xuvxr8sFQSljvCavQb0ojPgxJ2pXHEwqqLO/a/vgSWrn6LOTBA9yoMv1NfNfiGB0Wzhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhaeVo4s; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29557f43d56so1472455ad.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 14:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762986234; x=1763591034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kw4f1reWMcSIQ6pzE8/3VdwzTz8hfGSrFUGEZWPw50Q=;
        b=dhaeVo4sdrZmWEizhfBkN/beP9EMA73++SUoZn8Z+yUMeGZ0SCMoHgL9L9WUH3kVDp
         aRfUx38nexmowYLb2eFXtnUWYg4k62Ir6KJ+/ZuaPrNsX3PeUXCgc5RTjaseOMTMzt26
         Xv7WMEdFbgcw7EZTlOxS89JtvF3isVL1Uir/JwT08kxhoiOzncAwsqu5L2hA2rzVz85r
         rmatBg3HAJVGOFuw4OYEQFQZTSD72pzVneX1VlA3IYEKle2B0dg/p7bzPPgyXjAoKlna
         03N8I85OPGMe68BJ6FjwRWvQAG5ViACZpKJXOZ4+MEMFIAZY9iHJgdsVX2BhZDFwbqZk
         AZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762986234; x=1763591034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kw4f1reWMcSIQ6pzE8/3VdwzTz8hfGSrFUGEZWPw50Q=;
        b=GO7cAOclUJnvulzEQfy631phbBjNNZAoN12J35k2fqN5VZ1OYXIQuAqM37nSyE9pxO
         D3+zFuYB+9Eq71AfYKgYX1JMpku6tix9NKj1r2QqP7ulere6DjjxuJ0De0R8yvjLy+wT
         zJYb2+MgLkbt1uarDcuYy0R4fmcizL8jpxS97JOQfK9Xxh0uPvTNSww+S2SHK0S39yG+
         CFCAg1GPTweMZ9zNXW2eXRjvZ7s016aOAOsr4NrcFOK5k2PjuV143TfMuTESrKUux17D
         jrJY43HRQtK1NyQwmnle6wVpT1itCHBMPhPnHgAbWBi9L42BxS0iBPFgen1HH37wKPgE
         v4vA==
X-Forwarded-Encrypted: i=1; AJvYcCVd+yyobG4PoQFoDnaRQDfJViH4DEktBHOFByhEi65YFC8RVWkA3qfa+Mop45Iunkkm+XI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiBIZREHmWKiQSr7SPYj/qWMMs8ou6UsCQgeGN1Dt7yoPX4HF9
	qJVXQQANXjwuV4j2B1Q3L2C4lFbWA0Qo6T5srGhqX13eD0Le2np5400vCd7Cc4mD2XV1oF620x0
	bV14poA==
X-Google-Smtp-Source: AGHT+IFRDn0Up2tw4QzGoUgCS4Z+fQYxb0kDQeHkuY5hAI1bGwySPTsxvKjtMiE2+kGA10Lg7snsdkDpTmc=
X-Received: from plfh8.prod.google.com ([2002:a17:902:f548:b0:248:7327:44b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:15cc:b0:297:f0a8:e84c
 with SMTP id d9443c01a7336-2984edec330mr54153015ad.52.1762986234586; Wed, 12
 Nov 2025 14:23:54 -0800 (PST)
Date: Wed, 12 Nov 2025 14:23:53 -0800
In-Reply-To: <aRF5+3NW4V1z8oSi@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106202811.211002-1-seanjc@google.com> <aRF5+3NW4V1z8oSi@intel.com>
Message-ID: <aRUI-eHG2Bg1IOxR@google.com>
Subject: Re: [PATCH] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Chao Gao wrote:
> On Thu, Nov 06, 2025 at 12:28:11PM -0800, Sean Christopherson wrote:
> >+ifneq (0,$$(nr_kvm_exports))
> >+$$(error ERROR ***\
> >+$$(newline)found $$(nr_kvm_exports) unwanted occurrences of $(1):\
> >+$$(newline)  $(subst AAAA,$$(newline) ,$(call get_kvm_exports,$(1)))\
> >+$$(newline)in directories:\
> >+$$(newline)  $(srctree)/arch/x86/kvm\
> >+$$(newline)  $(srctree)/virt/kvm\
> 
> any reason to print directories here? the error message already has the file
> name and the line number.

I want to fully disambiguate the file, e.g. KVM has multiple versions of pmu.c.
And on the off chance someone unfamiliar with KVM breaks things, to provide a
more verbose hint on how to fix the issue.  We have a similar "rule" internally
related to mmu_lock, and the initial implementation of the rule simply failed
the build with no diagnostic information.  It was incredibly painful to debug,
and I want to avoid foisting that experience on others. :-)

