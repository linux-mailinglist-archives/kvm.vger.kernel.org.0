Return-Path: <kvm+bounces-62002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87115C326C7
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6D3A18977E9
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD2533C50C;
	Tue,  4 Nov 2025 17:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M2ZOYaro"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFDC2609FC
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278440; cv=none; b=f4BSi9VGORdxhIBq9Zy0qRwV5RXCXCk7ejbHB1kDyXplSbJyS6AbZ/MdjaJpUdJPN1QqGC4/qIkdttCDSk5MH8Rn29pp0E6sxx4sJ0EgmvpXGFNhbWHH1wNerUFZ7f1/19EXDy3zSVPPl14jmcVA/DaN5lLQlqOcVbLn2UczRes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278440; c=relaxed/simple;
	bh=S0sCVlzPR9eoPq14A+UacAFHD2yAA0EnzLZ//Vsu608=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gggdvfg2u8eC+mZnjzTN9v95Y6uzTZeO8mdUmeDHJqlTVLzOsQan9AsZo0dOSpIZJFqBRBqpo8JWWXvpmcqLf2JhW6+KqXF90eh+4avvdAt8D1n5RX+tdXAs5PMGhIiS9xCYj1UPg/x0Qy70ws4rKOya0K12tJ1uQwB4fHRE5Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M2ZOYaro; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso4533244a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278438; x=1762883238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w5AFabGERn/kq3CjV9TeBZIQ7PSk/vihUZYEXsUttjA=;
        b=M2ZOYarosRtn6GB23CwMOrmXWDCxgDN+SJ76YQ1C1cpLd6/cdOgwxBBlSz0JIC8f1b
         WDxvYcBqF9YYdUl6Ou31MrCU0tD6zvgxJvlMYyCoYsVsEvriB3xv0C2Xp+J7my+yqLk8
         9kHEkGuTYTXgp99Jw45mn1FasSBe/56hp6Hsx0+K4zFdvM4IHakXaWNdDvvqlgTDQHn2
         oh0GGImEEiiR5JT6oxnFmb12P4sfd39ElHxgjcqeEsnTlFV7c9AqkACDug+zBpLdLYTA
         Luj1O1m4tln02mohxtUSyTqcjzu6ISfYbhOELMCKcKzI7v4aZrAH+8EL61NcG9YDAnIN
         8vcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278438; x=1762883238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5AFabGERn/kq3CjV9TeBZIQ7PSk/vihUZYEXsUttjA=;
        b=KeRlWjnv8aoh5Zm+xcaxJg8F1/ntT4XV0t6GTO9E5cL+LusNNGUgXU4zSCiY36OWwX
         wsbidyzeDgHEjOJb1t/Z/uqVxaPPXJb7aOe5oR5C1l/O3sVG8hB7mDfdgjR/jO72UDtG
         nJJhYcqdF9bbbyxfEmZiQaU4E1YzL2bDyfh8lqmqsBDK6b0V6oiJMp46xG+sgyi/qDZX
         ufxFoU3eCk8mmOX8JEYNklaCdVdfIJTfgl3SQJ+sOFZzfkWVJ2bf5lP/z0025jKoAjJO
         PV0IxnzFKyBm4WMXvhqVfG9xi/thS4oSrYgZXbniBLovlYG4E8j+DjfGTq1SQI4g4uqy
         1QhQ==
X-Gm-Message-State: AOJu0YxVqA4Hd1QLW3k/9vbDXQ0IgPUL93qjoFeAbp/VqIS5MVYuyekB
	4ykdeHN0xBSKQJ7OjBRENSu9y23QfBRTBzgAyfoyJOpmThb1kPYjpRPMDgftartsFYaFb+NEmxV
	53hi4VQ==
X-Google-Smtp-Source: AGHT+IFg3NGUF9sujv8fjNyHVjuWkNk4Z7OyiLtDMvv9mtmpZ+fAOxYeJEYFoOh9SMnnZ0Ss5+pHdF1AuN4=
X-Received: from plmn12.prod.google.com ([2002:a17:903:188c:b0:290:28e2:ce57])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc7:b0:295:5a06:308d
 with SMTP id d9443c01a7336-2962add9ee4mr6212375ad.14.1762278438141; Tue, 04
 Nov 2025 09:47:18 -0800 (PST)
Date: Tue,  4 Nov 2025 09:45:10 -0800
In-Reply-To: <20251030185004.3372256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030185004.3372256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227778227.3933113.7943580154126405965.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 11:50:03 -0700, Sean Christopherson wrote:
> Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
> code that fills the exit reason and CPU when KVM encounters a VM-Exit that
> KVM doesn't know how to handle.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
      https://github.com/kvm-x86/linux/commit/65a70164aba7

--
https://github.com/kvm-x86/linux/tree/next

