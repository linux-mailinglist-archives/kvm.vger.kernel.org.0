Return-Path: <kvm+bounces-14053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CB689E6BF
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C47F11F2216D
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574F563E;
	Wed, 10 Apr 2024 00:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DN0zjnQu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A880621
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708571; cv=none; b=XNNMq2W4Scb90Sugt2NzWW13zEqkWeNdFWxDfR3Mz8Br7W4lVxfcRS+NIYSJP+rYClsuxGpOwPBjSXklsddowur9HXAMxMD0EeUAIglWm5Kxrro6CTRGIeJIO9G5Xp+wx1wFUL0c4i1NJPzydcy+QEyrKEhNGWm+ZMMI3mmwBUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708571; c=relaxed/simple;
	bh=voqQI7inVC9B9b5djCpx/mdYgts69DBt6IIk1PXaSiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WVI+DD3qo3lZkhy4pLkDvYGhO3I4lcfnMdnxng4qRli7xnmV8JnIXzJQwsHHR3RwrXNn7fDjw2GqYfwStHY8wreB7+c7ewTsZH4oUq/nKlDjPAdl/08vMRK0wN+dDDpnZoUmyG17b7jzSb5wi4z8ylngQAVbfkMIppRCbGCftrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DN0zjnQu; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-615138794f5so103062967b3.2
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708569; x=1713313369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vRvBmFNohOEI7WTS+rjTVduR6LvAZJUzOrjqdhZcWLQ=;
        b=DN0zjnQuND+nqEC35YgWuKHzJMwi9jytC9o/rENY0ocGpQcE05z4Wla53V0/XK9Gu9
         GUESXYVdBwcWXPs12LsPJ6/B1gfgyuBGNUns4cGSnliwjE28K2YQeve3lZuZtUapeJCE
         NIcQULT05hreMxN9AUeDN+o/PseWNBDFQ3nXuBBYxRRKNhv0UX5IxhSGSzk+/+eT/kKZ
         WR6awon7nbSEyE2nrNr5Gkbcjx/CLQZSIZ+UqStPW0SqDINcdwSqZSv6Q/1V1yA/+xeo
         EWuDGRpjClltzEAUY9Xl9i5IKacOfEj+LkyolYVt3Ol3ZkqYKRSMT/WGjpxrmajhxyT2
         q+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708569; x=1713313369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRvBmFNohOEI7WTS+rjTVduR6LvAZJUzOrjqdhZcWLQ=;
        b=D5bSxoPVi8q418nboswUcnES+GOjd+796H5cB6Inl5Xrfs+LyA0t+b21kcY5l0LqN3
         yfd3MiO7hN+IA2pG32KQVi5oIqL4LAOkUqfEtjR8m9ht2RdEKL6VWmN9NLTCbZclrsXW
         kHFabZuwOPmRHtKFea4ipgCVzZD2RLujT1+/yqWSrCamrQoNUlf/c9epNFU1YC0bgR0p
         73gZ8XoXnSu44US99I3WDAmd+vpjbHLeah2/9QaAGUzDaBeoOVrxA5mlE8gsuWUpKxT2
         7lW8JkZITRJd5TNbisdJ2YAdudUIQLePhsYyzvHlAYcq28E3G6jeVeEvp40IoT3OyzTB
         r+kA==
X-Forwarded-Encrypted: i=1; AJvYcCUQlmWF19z66p1nUYdOn8EBN2PLEd5R3FRlrvTjzTtA5bL1zckvapcHS8bYGdhllQbqXJ3d/ea4453WWFxUk9Rd1h94
X-Gm-Message-State: AOJu0YxHPDo+aMd6df/W/Pr0vkICpyE6q7d3Ci9Rz83UK1p0u6ZT2WyD
	C5u4aTtIPJnp3GFYaqthzPSFCqrk2hWPKwGOdlrXDPaHJTAuBeEp71pKBYm1MvPloyDdss51Img
	qPA==
X-Google-Smtp-Source: AGHT+IHbegGR54J1o5kSznP8/K+wIv8nxvK0bpOy4YYRnI5aUljiBt46Owb/2JIueGNRNrZTYmJ+AiK9cmI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6c58:0:b0:615:c92:d3ab with SMTP id
 h85-20020a816c58000000b006150c92d3abmr299023ywc.4.1712708569255; Tue, 09 Apr
 2024 17:22:49 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:55 -0700
In-Reply-To: <20231019095900.450467-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231019095900.450467-1-thuth@redhat.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270357031.1585380.3102016059954342629.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Use TAP in the steal_time test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Thomas Huth <thuth@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 19 Oct 2023 11:59:00 +0200, Thomas Huth wrote:
> For easier use of the tests in automation and for having some
> status information for the user while the test is running, let's
> provide some TAP output in this test.

Applied to kvm-x86 selftests, though I was mildly tempted to see how many
reviews it could accumulate before someone picked it up. ;-)  Thanks!

[1/1] KVM: selftests: Use TAP in the steal_time test
      https://github.com/kvm-x86/linux/commit/9f92c06e1840

--
https://github.com/kvm-x86/linux/tree/next

