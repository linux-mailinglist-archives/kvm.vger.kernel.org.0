Return-Path: <kvm+bounces-63167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8134C5AD75
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15E333AE2F8
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6754D246335;
	Fri, 14 Nov 2025 00:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g+0aVsWJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADA61C28E
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081330; cv=none; b=V+A5S0gr2FNgGltThW5EmRVnhN6BRtBTm7r3ktc51unr8zMz/Kpiw9T3A1lhC7CG4FOCYv1cn6ZWvfRkTCdWJQlMkwjjLH2cIyeJwFVLeX16iupijcVwhStpELagkQ3DE8ikMLastW0brYP3tM/46j502Wxheg8X2H1U9FOqPbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081330; c=relaxed/simple;
	bh=/yxZzSCUr+WwcFJiPBAEvRAv6B+69x8f6/mrQo4lv3o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RAcbDgUjKfhMTdNnpPbMlaxEYZzQStHxP8OBXwvtfmbVqKv7S4rtarz1syqKDaW0rF3VQMio5LOI6mam98c2sGFBaT9peXMgQFBgEk2v1I52v6HUYelIEnKXPl/FzGlmS9bF9TDIXzL2KC1Kukglb94AbEcAOC3rw4q9uZWoono=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g+0aVsWJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3437f0760daso3607581a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081329; x=1763686129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OU3M65yfjgAgQasfUOmEFLutB5uFULte4qGqRuq7ngY=;
        b=g+0aVsWJAGa14ZpFkireedZkzknKebRiaXfxOYKuQQUobE+8zYLuTOlrlERBJlhjfq
         QDzhAiMJoAFgGfgT94EsKanNJUbNPVLGQw94uZLLxJnfssfcCsXzg/rbpNWFBmeSNvjO
         F89QkkCMoEMeZVHCYtBYyIHWE5p6ttZwLO6I5SvXWCPhBWC4BQ+Xwni/Yc54BnMr2RQ6
         A39Ku4l7JQg71X+hqjku00VSA2G0z3hWsQ767nSJWabLbx9s4DRH7hw1g4rZ5CpJOotM
         UaNlkiSYK9a/+d5vvPdVqGJzZRksDtrMnxOFzQ8EZQXVd9BTrDUMxmDOjwuTh43ZF8N3
         o0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081329; x=1763686129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OU3M65yfjgAgQasfUOmEFLutB5uFULte4qGqRuq7ngY=;
        b=dUE+KFpcHpgfIdcaRP+YPeO9LGMCegUFdMLmPpW2Mg4YX8Lgom3v4uDOocKlzNVTu0
         +bgVYm+CCCjIIbTHT82uiB0kKjNdh/cprG0MNS+aWQNiHvpNrH23myYJNPRf5yoRh1P+
         kVoLKk40kZG/T0uZxDftiPQ12fGvmdyyYYR+Ubsq5gYweh9Hi6IOuxc7iELakd4wkQed
         bDaG20eKWd+WJvo50NY56Z77K72JigtGtUOQ55Rw9QW4nCpUFMmCLBBc5tgLPLJi5E/o
         IBaX6zHDOa4x9DvoFy5/rJt6bxLuntEcn4VnHlVuhfIYkePofqu4tsG32mPt66ESFLOY
         h41g==
X-Gm-Message-State: AOJu0Yz6Lul9mx2rGUQNs/kdt4QEJtSVhDhBaM5nZ5rE/DoUBd1WNaQO
	E79dICIBDEzN7OV82AvuTeu/YaGU7FvLpZ6nd5nty+6lCUdapBsJy0X8yFbqWkO7qTlXU0zIvg3
	RgalD4g==
X-Google-Smtp-Source: AGHT+IEmAPQT/T7JzDVscIDI618GNw3PpC2N6GbhIE3cHYhn/zzHxtmhKTIewdI4dUzp/ZFrLjSmG34NgU0=
X-Received: from pjbgc20.prod.google.com ([2002:a17:90b:3114:b0:340:bb32:f5cf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a45:b0:340:d569:d295
 with SMTP id 98e67ed59e1d1-343fa62fbb3mr1416586a91.24.1763081328657; Thu, 13
 Nov 2025 16:48:48 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:17 -0800
In-Reply-To: <20251106205114.218226-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106205114.218226-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176305662913.1602433.2540496540311423211.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Make loaded_vmcs_clear() static in vmx.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 06 Nov 2025 12:51:14 -0800, Sean Christopherson wrote:
> Make loaded_vmcs_clear() local to vmx.c as there are no longer any
> external callers.
> 
> No functional change intended.

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Make loaded_vmcs_clear() static in vmx.c
      https://github.com/kvm-x86/linux/commit/dfd1572a64c9

--
https://github.com/kvm-x86/linux/tree/next

