Return-Path: <kvm+bounces-56192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD86B3ACE0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7989E567C06
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BCF82D23B6;
	Thu, 28 Aug 2025 21:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CVpa1Ybv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F822D12E4
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 21:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756417490; cv=none; b=ovaZVAf5wrlaQqnn2GOiGGdZdK6d1ezEmzYi70XznpInsJPzY/nfbXkimM7SjyP7puiLFYnUfWOodHjpABciyoqO3fG0csfb2YbJ61Bw2Ij57sfGQFZuwPx/AOihLtnhcww0dI9EL4PQtYflzVAoQiU6Ai577D8tD2/y0P4td/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756417490; c=relaxed/simple;
	bh=C/NpCg6q+vxXwOPCq6cYFuoORDyx7dzEq5rtn+awqfg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JEjdtyAMa57pnROtzEaO/WZJaRtVjNyStiCOUvufrC0aIQ6ZqE+uhB+UtvJZ/QF7Zaf9B6OlBWm5MHcJSSe0YxfVnmbB6iwW7uJvEdRT4NqVE/zdklm7FDOwG/zkkfUXYksYE7US5+fBHO+MQagVn/U8qdaAHNeMMrHX9NnIdsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CVpa1Ybv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244581c62faso19353915ad.2
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 14:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756417488; x=1757022288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vrxdZgxba4gYN2q1LfvvmxDmvnNjBkbi5Nna+w3+iic=;
        b=CVpa1YbvGlAOJAZoUCUPXiK5C5LRzsBF8HxPJm+nnqRFC5QVTDD8cl7VCghmaT35JP
         AP3S7JitcBsosLq4asuJNk2XEDa2cPdIcB7jhpJ7mPmGP0ZMKtslhEcbd02zLVhAeK80
         RlR7qets1pWx62cfNK3h40uAYrw4a0etiNXZW98N3ypMbd50+Tqh4cnSjPD80yrEhMNx
         n3c0Mig7s87UNkNMHjHR3J8yVr5KIViSEYjxrVrYz5pej7CuNzpv3k+lkuO019wvuSHR
         MQgwhmeq0p3TvbSQsBEJaJRnjs3w9CQJJ3RefEOxnuGtG6xZOOriuq+6NgDoKTiAMyJW
         g4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756417488; x=1757022288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrxdZgxba4gYN2q1LfvvmxDmvnNjBkbi5Nna+w3+iic=;
        b=S6a0wbSIIvI0Nj/floIotNYsEViJguZLbIq5TvoPARd7Nsn6fj3fwOnAxAC/EL8GzQ
         QHBUMqwKeIrCa4aGHVoG2wiIccQCalC2X4zpg4udpqkwcgJYs8ABxNQ3VXBHTlj9a3nV
         8cwJpZjn9LVBV7DaaGL/ntojfrPi3MU4rSHxj42n9duF1GKBBrPkEi9XvVvJAKB7LdM9
         cYaTvIFBKj4XsU1AZRz4vA6icgNOS+/W7weTBj+kv4ZRbemFK3rJx9dsTC6bdnsBtN1s
         Na57pPmbg0XgGjGyMiLbmwcmvJXadwCjdcJXR77geKdg3CI+dU7iJun9loa5dWG6vXwf
         Dn2g==
X-Forwarded-Encrypted: i=1; AJvYcCXlxqnGfGYSwrbrcxflWIOzpM7t1U6PnPj3mr0GuwjXpmYVAcGSB+/mhWF7iRhAR3ZUJMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YybiYvFHcQ7SGhzgeg1b9VwlyI8jilFj41LgJJG8uw0x3Va/pzJ
	/JooJCyAcDoj1qTwR0RmoffHwRBz3CRwzmzsqnu0dYuXbwdl06BgxUCWYADwfS7pkWL2T306jEs
	qaWqxgQ==
X-Google-Smtp-Source: AGHT+IE8RKoOo7e7EmVuEAWOQVAwVrB5fsqejrtInrkSfOjrEAAlIzUAzdG3kcZqamJyLYTzumlKG+S7FHE=
X-Received: from plqs24.prod.google.com ([2002:a17:902:a518:b0:248:a265:c642])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1acc:b0:246:6442:19e4
 with SMTP id d9443c01a7336-246644231c4mr266145675ad.58.1756417488033; Thu, 28
 Aug 2025 14:44:48 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:44:46 -0700
In-Reply-To: <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com> <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com> <aLCJ0UfuuvedxCcU@google.com> <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
Message-ID: <aLDNzk-QaAlfff0C@google.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 28, 2025, Rick P Edgecombe wrote:
> It's unfortunate we didn't have the gmem mmap() support then. Otherwise we could
> have just encrypted it in place.

Yeah, hindsight is definitely 20/20 on that front.  Though I suspect that we'd
never have landed anything if we tried to go straight to support mmap().

> Otherwise, I'm really glad to see these cleanups/scrutiny. I kind of got the
> impression that you wanted to see less TDX churn for a bit.

Heh, believe me, I'm not exactly ecstatic to dive into this.  But, I don't want
to just ignore it, because some of these quirks/warts are already getting in the
way of new development, and if I/we delay such clean ups, the pain is only going
to get worse (and the total cost will be much higher).

Fatigue is a bit of a problem for me, but the biggest issue really is just lack
of cycles (the quick feedback and testing y'all are providing helps tremendously
on that front).  And lack of cycles should be mitigated to some extent as I
(re)familiarize myself with the code; I recognized most of the concepts, but
there are definitely a few places where I'm completely lost, and that makes
reviewing things like dynamic PAMT and hugepage support excrutiatingly slow.

> The fact is, the TDX base support still needs more work like this.

IMO, the most important things to address are cases where the design choices we
made turned out to be suboptimal, i.e. where the behavior itself is problematic.
Code cleanups are definitely welcome too, but my priority is polishing the core
design.

