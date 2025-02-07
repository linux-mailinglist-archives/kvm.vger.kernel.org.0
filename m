Return-Path: <kvm+bounces-37598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA2BA2C686
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 554703AC8AE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 15:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58B51EB194;
	Fri,  7 Feb 2025 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dQIHCRYt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C55CA6B
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 15:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738940830; cv=none; b=JKQS6yQ5doeBI3ReXA3nUo23qV7gpy23lWPjHWhqKNeUItOLLUrEIEEeExfzf3bBuUNe9W2hSfV+KcaNfJ7X1s4PXpc9y0hbKSzdlU1aIxbOcqaqMdR2gx4YmeOyJXw8lmQc8d0p4g9uqvLd2byYZJfttPQ8CUAvxAdBv2uJXbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738940830; c=relaxed/simple;
	bh=UXHwzN+hhqvpaB8oryjS8Z5As9+aId5qsxrzOd5xfyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gfH/OjfG80R4GIvX+1+03MoNJr8AK7H+pveLzVtelUujPMBIG3W3Mm4r10nZbkt8rkbO1k+auTZmlad2E1IJfcj/6pNzSqb/AQnWLpAG8IERl4nHky0WmmgTZ+2UGKU7Hz0rDj7jW92XzY/EHASF0WDE41wjkJMJv5tZkGPm8a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dQIHCRYt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216750b679eso35422245ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 07:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738940828; x=1739545628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JwkxBxZcQBcLsO8nPf0TC2IO5kxYAK/AMIwJYJnd5HQ=;
        b=dQIHCRYti9Lz9/0G0+BFs1iZ9u28nhGHHyzmx/Dya5CTR2S/8/8+sT62+psTucWtRs
         0jnA4LyOJwDmOxCIz5dmtIyfPayfZ6dDE6EH7i2v1e+i8iHLv2EfBWYdZtjFRbiO7lxZ
         B2z7fSHhJrxcAvpH16HAbfj7w0UI614wr0vb9IRt98lneQY+2t7BjrjwPsUv03S2JEas
         SE0bDaeD3o1BTcsHnzPe2Cqm8wgs8DiVvvlAmg9J64thd2B4GdKGDidMeqba5XKUC5bI
         lD2+2uuO1CXP0sDLHCLV8rbHOwOLau3r9XLye3iyiMe9EXIW1KjDcsNPD7GZ2xZTURMr
         Smpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738940828; x=1739545628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JwkxBxZcQBcLsO8nPf0TC2IO5kxYAK/AMIwJYJnd5HQ=;
        b=JdM4diJKGvKGtHKi+ob7KOIohyCnEO5Yl+p6DypEyGRTRKdvQP6wNbwKBmQEs1YTTa
         Zah01U9eU3Ifr9rA/LJhnIT92hKQZo6QPeuhxkqW0CLAN8bXe6q16Zparme5GNaKvXif
         GcnjxyGc4JggTi0i6cAudRdod7NqEOcsdT0kHbFaDjkV2HFpjsy0XuKjBkg1p6Symrh8
         xrgszuohK4tw2fxGlI+omKRqMXBtObSAuAjtesRMGOo4KAEn+HCBzLcU5Lla5r8GE2i7
         B3x3JOG2JUZoxN73r3L3vYdARrQyn2+9u1yscqZAg/LD+eUvdBCJD+wYNNKk551tz2RG
         BNlw==
X-Forwarded-Encrypted: i=1; AJvYcCU+rbc1V3/7zREzCDmZvBnpenY6AmzZJtxDy70xWdVUneAi2B+R/h6qQUz4eL+OPSL+lvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMvAuwGwmiSLNJeURySPQt9uqM3Y2svbBrnA9MHHe+T5tlkWYT
	UKxpSF5fn58bWkkwczqPwjRGjSbxVZWZqWFQogGZqXqL/m392Y8x044SQPcZEIUPOAwO1V4hrLF
	qJw==
X-Google-Smtp-Source: AGHT+IGGpDhL5qjOXjpc+tbAffWAMRWeGGRYB92uTPnhMOQHyur2dAnBw5Zz08W7peV+bs0ZmkT9+t2j174=
X-Received: from pjuj12.prod.google.com ([2002:a17:90a:d00c:b0:2e0:9fee:4b86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e889:b0:21f:10a0:ab5c
 with SMTP id d9443c01a7336-21f4e701118mr63403535ad.26.1738940827808; Fri, 07
 Feb 2025 07:07:07 -0800 (PST)
Date: Fri, 7 Feb 2025 07:07:06 -0800
In-Reply-To: <20250207030900.1808-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207030640.1585-1-yan.y.zhao@intel.com> <20250207030900.1808-1-yan.y.zhao@intel.com>
Message-ID: <Z6Yhmg2nmUAtp4yn@google.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Make sure pfn is not changed for
 spurious fault
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 07, 2025, Yan Zhao wrote:
> Make sure pfn is not changed for a spurious fault by warning in the TDP
> MMU. For shadow path, only treat a prefetch fault as spurious when pfn is
> not changed, since the rmap removal and add are required when pfn is
> changed.

I like sanity checks, but I don't like special casing "prefetch" faults like this.
KVM should _never_ change the PFN of a shadow-present SPTE.  The TDP MMU already
BUG()s on this, and mmu_spte_update() WARNs on the transition.

