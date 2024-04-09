Return-Path: <kvm+bounces-13948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9219089D026
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03E572828F5
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D095025A;
	Tue,  9 Apr 2024 02:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZCUhcjb5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3C24F88E
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628105; cv=none; b=I3aHqSDOh+CEq2R/IioRT8J3nhnMFLt7HLOj3NnaSzv+3bPwbjx8y7I7PCHQ5KYo1JKB+oPRWJVnVi7qW6iNfb/Q1zVSPeBk3xibzmj9InJAhQIRUTa0bv4lcFe1Oot0leJKqDPvE3TAsruUVCSgy2XkGHiU+XJwtWqPhnEQu98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628105; c=relaxed/simple;
	bh=R6wBWyvbKby2JcJVzeeM1JrJCn8KU1dV5kM9O1XYv3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aRSMp86tlJdshjipng3dMJO3ErEtsV+8BV3goQflCBT3tm54mo67iWPHriI5Jh+UvJJrs56pgPFaMud+JuBMAsu8hpKJt1u4GPvR77uNao/NjhrtC6rmiTUmZAByvCUw6Iw6R/sSpyZxijqGbmWmfyARnEgxJqQgVCAadfZDQ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZCUhcjb5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e0b5e55778so38897005ad.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628103; x=1713232903; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0MyZK4MuxKPsN1IFuhdXaa5jTxGtBSl229mSO00MeI=;
        b=ZCUhcjb52QfkkFes1dMyrI8FuCUbanlJSdbQVHCMie14W5/7Db6S9zRI/EIw2a7bz7
         j9hllqEEIwbnw8WOOY0tYWyRtBqi1anNrq+QOqR95v++Xo+Z4TpIe8l6OldodNHduR6v
         aeOek1YYXVsGEA3F6QEG9r+eZ8gG86ydI/uS/uHndHxD4OG4Cn+En30dPrvjhbIT31Bc
         vJy7vMQVbwayovf/+ntEBQdSl3ehsixSlcPgaWSeEr5D75i9AbaYHxaS5OZnrp1wa6SN
         HOi8//TtyxdHvuLNO+IzYeYySs54xVJJG2Pi/SOnQJG0iyk4RZOsjS1IakklWCpylAD3
         RHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628103; x=1713232903;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0MyZK4MuxKPsN1IFuhdXaa5jTxGtBSl229mSO00MeI=;
        b=fvqb4RjKGm+W3jST0yLBnUeJ0GP+uI7vbZES8SRzo4z/3pNsrsqtdMbA8UOYfNNPAg
         AmSMLqDZgE5ydzEJPOPHWNQsCMyG7+ntDbONJXcHxXQdHC2BDT262QIGhjCZWiBvtNbO
         eZu1Lwn+XqjyRI9a/QF0x44/sBhjb+FfI2DK+mGtPkiCRY0dlGx8l1Gr30HUXy/B4dsh
         /qf8vkDh9cXjIdFn8wSAyMSi4y1QeeaZMpxDwbafSw/Bqcx+2Q1S+0dtu0c3eIwkwAuM
         G7VQKajVWnol6q4sqZP6vDIioWS+ymb2zmOp8m3aDK6CiyMuAiIefMd30UJwADFr+rdB
         1eAg==
X-Gm-Message-State: AOJu0YwHV8YTaUJ9pGyvVImb0O/4l1YeLfLSZO56A4FambcZ6YvzCUTB
	A7ODlHcD8AvhSwx7NKz3qr7Dh+M/rQaJEsjolqbCZJDBNsSTy4FjGV8FVllBJzDdS0sQD2aGhBa
	NLA==
X-Google-Smtp-Source: AGHT+IEIPayHK+UX+osTqfTWTO/3CwsU9ry/srH5ydOUG3vLHFJYt7lorcS1BHoOUKDu2QDorHh+mWnI7pc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50a:b0:1e4:881f:bed1 with SMTP id
 b10-20020a170902d50a00b001e4881fbed1mr92462plg.7.1712628102823; Mon, 08 Apr
 2024 19:01:42 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:25 -0700
In-Reply-To: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262711269.1419750.7343660666296265143.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, chao.p.peng@linux.intel.com, 
	isaku.yamahata@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 14 Mar 2024 14:29:02 -0700, Rick Edgecombe wrote:
> Fix KVM_SET_MEMORY_ATTRIBUTES to not overflow lpage_info array and trigger
> KASAN splat, as seen in the private_mem_conversions_test selftest.
> 
> When memory attributes are set on a GFN range, that range will have
> specific properties applied to the TDP. A huge page cannot be used when
> the attributes are inconsistent, so they are disabled for those the
> specific huge pages. For internal KVM reasons, huge pages are also not
> allowed to span adjacent memslots regardless of whether the backing memory
> could be mapped as huge.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/mmu: x86: Don't overflow lpage_info when checking attributes
      https://github.com/kvm-x86/linux/commit/992b54bd083c

--
https://github.com/kvm-x86/linux/tree/next

