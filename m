Return-Path: <kvm+bounces-48181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16661ACB9FE
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31465188A38A
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27A7223DD1;
	Mon,  2 Jun 2025 17:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eob+SzUP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60D31DF25C
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884086; cv=none; b=fwLEKo/VDzJCAbPsazOlmix5aFSxwwRXIAI1W2F4iNv9RPApzS8gPDhuNPvu7kq2Y5LFgDlSwg8OoMRIKVQxtDcvmzIjrJM37QBaQ5p/ogMyo6fEkqxE8iih6OBjKV1YFs4zuNqtenxQL1cYZDuX7C5o2xiKp5vhviq7fhqYdPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884086; c=relaxed/simple;
	bh=+WvDBTQGgVcJ4+48hvjRRqUcYgzGsQGUF27/OrTHv5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sJ2CQ+WMlpMk5cOl/omKhSfkPnxvhQbLYNMaDLAKvs1P2G+c84LKrIZ8ZaVskfm5hgujHCGWEvmdUDjmnlwGnV7uFGR/+x2jt0QT3DXwGT1NGSZ7yrXDt4iLgw6f8GuOoMXC3hsPHmEC0sURlfbCe8I9hQxRpxfhAjeR/78t3Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eob+SzUP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747ddba7c90so1256393b3a.0
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 10:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748884084; x=1749488884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ydlOhEkRopFxTeDK5Q649uIqLSzngVdlEEZytCet2UU=;
        b=eob+SzUPtE3ImVsCeAyZg6ziFCJNEJxczLkKMgOLoizfQLj1/2GwEuwsrwloJNo1eD
         EB4FwpVPCeGUVecMIQ7SDOy/sLKxZfVpDepv8JUlLwzKBpkwTTL4ZRfMf5Mdjyx+vmBq
         nfunpXzFuql1p3hrAS8RVx9cW1cuKwW71tYqzYiEnISBkRr1hxhaoVBsUPJuzE9zY5hw
         v9tAhVH2Oe6tlnW24zbWe5Fw01yZJTZf/XlNIRNSDtWRA9BmN7oVMJti1vIPl6gASew2
         V5ERA0LAsGtuntjWSLlk3CvT8S3yQUngo1AxRBYuNwCvlGd21I/4zGblkuOa4FF4z/FG
         OnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884084; x=1749488884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ydlOhEkRopFxTeDK5Q649uIqLSzngVdlEEZytCet2UU=;
        b=SJ0VbaZS8bggol2U+cQ5cpK81fN/k9CAqYuiEWYfdZDbMAxzDG7jsolubzW00RvPC3
         IBpszgruqw7rUQ5e5HDCDNUETkc+WXKYKO2xOW5K5gMJ6qofHEqcuPtbRY4+uwtplYVN
         t0EymIRfX2g1rHGRHBx8A+4KHBDiy6aPu9kR6Mfj35m12dUr9GmXi2GTSzvJzHOjZ0Qt
         sn1pWTEoFBzmm7ATtjuwGFSSVGXXpc/17KkXVOSp264hwnIjEgQpAv+lZjHBBUzVbEca
         T9C/WCyE2gH+zRe5+vh83Ah+LDwMKZ9/aSmB7mOEUPkzXjxEHMYln1shGnznda0gWexB
         Bd1g==
X-Forwarded-Encrypted: i=1; AJvYcCVVuGTKw/UjJ4MyxafuxDn1tIq1PSjVkd279NdKWDSddRF7DiW8qI/HyMcajVirNDuV5ZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxNKOxm7Y4JQ/WVpMKXBR4s01/5YvyGNdZ7OiyOaPCWDQkyiXH
	POVQpUiOisAK997leQX0ASj58NfiwZ9p6Cu545cPjLe0u2L/n37RJus/wtgNYCZwoq68Vm9aAGa
	9dPhFMA==
X-Google-Smtp-Source: AGHT+IF5TZWeKQm22/4S72UXWjGujgvsZqXcKchu15yQOBD2jnBt1xngILSWHoW56WuJMyOtVuiL0dTcYe0=
X-Received: from pgbfq4.prod.google.com ([2002:a05:6a02:2984:b0:b29:bc7a:8aa2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:339f:b0:1f5:8e33:c417
 with SMTP id adf61e73a8af0-21adff48c6cmr20699816637.2.1748884084082; Mon, 02
 Jun 2025 10:08:04 -0700 (PDT)
Date: Mon, 2 Jun 2025 10:08:02 -0700
In-Reply-To: <e5e1fb2715a98f24ba69cc4da5c30777633f6f62.camel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-18-seanjc@google.com> <e5e1fb2715a98f24ba69cc4da5c30777633f6f62.camel@gmail.com>
Message-ID: <aD3acnURwE7am7gf@google.com>
Subject: Re: [PATCH 17/28] KVM: SVM: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Sean Christopherson <seanjc@google.com>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: bp@alien8.de, chao.gao@intel.com, dapeng1.mi@linux.intel.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Sat, May 31, 2025, Francesco Lavra wrote:
> On 2025-05-29 at 23:40, Sean Christopherson wrote:
> > -static_assert(ARRAY_SIZE(direct_access_msrs) ==
> > -	      MAX_DIRECT_ACCESS_MSRS - 6 * !IS_ENABLED(CONFIG_X86_64));
> > -#undef MAX_DIRECT_ACCESS_MSRS
> 
> The MAX_DIRECT_ACCESS_MSRS define should now be removed from
> arch/x86/kvm/svm/svm.harch/x86/kvm/svm/svm.h, since it's no longer used.

/facepalm

All that work to get rid of the darn thing, and then I forget to actually get rid
of it.

I also failed to remove the msrpm_offset declaration (and its size macro)

  #define MSRPM_OFFSETS	32
  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;

which are dead code as of "KVM: SVM: Manually recalc all MSR intercepts on userspace
MSR filter change".

Nice catch, and thank you!

