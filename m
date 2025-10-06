Return-Path: <kvm+bounces-59541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3BFBBEFA0
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 20:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 521333C4DDE
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 18:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A646A2DEA97;
	Mon,  6 Oct 2025 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soRTtF/X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E3C2DCF7C
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759775446; cv=none; b=VsHQp4wxS+xfV68cpUgxUU796btO62WG2ovT5wKDfdvpDzJNUACMZJyw1MA3E/Tbw+t0pZY5HMTWno4sHx4jWWh0/XCouJUJqcuiVXylPNVfDaZsm7RlF5cn/B2uX3WyPuqVub21zx+4rPdJeHX5mhb2hWVNKY1uV/mSEZv2CPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759775446; c=relaxed/simple;
	bh=5vr/y5eOt1Q5zMH0KcLbl5o9ytN0rfxQ83BRS6U3onw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pz0gZssU0g20h3DXSzRhaKLIqR47plMU8g9MP2b2P2LO84TEk7xv3UBflzlSIQpLIGexNAMD/FzEjehw6EMePlZM8aNBGrGkplPG1RfPSWirliIG70hq/pDu+hFjSCiaYNzrUKSoPNzRXuElywArVAK2u3d7EJ0Rp4UZV0xBeWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soRTtF/X; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so7224566a91.1
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 11:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759775443; x=1760380243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6KhvJbDS1YxGKRb7Xf/09YfqKPPxIFctsq0cFP5ixw=;
        b=soRTtF/XgnSHcUi+x6/Thcd0R7dqjkXndJ2gTIn1YZpwrdlPP5g2MULd5iJoteUZJM
         KnmeL0Khhj1pMJ/QMrnvxLE4jrELc9wQW0tlf8zHYRgICx0W97GsLYDxxmz5eozyj5yy
         9BNsfYZpLCZqmsTHC4TUu6vCRbYIZb+y9q5ftpe5feIIk88ZbgtvZ1LuPvZwVyaG+1JE
         P3i7czcmCTL1YOHa/hgjnzE+jyjV6aLulVA1yslXyciFEtsqX+8spmW9KWM6n2Y/un9a
         DP5VZDN794SefPy8ojHl/UmCAXenZyinPst7KgACADZ/pNYD/ieLWGmMQAWZqFr8OxFK
         Vr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759775443; x=1760380243;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U6KhvJbDS1YxGKRb7Xf/09YfqKPPxIFctsq0cFP5ixw=;
        b=BvhQ75J1JLtXH9tmH3R8YyKXUsTj9GLBKF8E8+UHtWF+WkvE235q7jQiq7hKNPHkL3
         gTslbkf+iwof3ROkW/5CfNmWGtVu6OysCufqTg4vmPH3kwYF0Llww+3u0H52Xyf3k7cu
         RB7xlLp1ZGkCpT7CObYAEND8Xe2gR9sYDxFhpSMHDCoNHeswIdv8Z61BgsaOPVCHLLZ4
         FKmZ6yD3oGVBPwJlGDuIU7iQXh8AeObZK0DSvI3wGidzoJ9D6jAJEsulCOkn2WM/idqu
         eGZrc0L/wAxP4jbRBV3IPDy1SFOCO1d54IiFtKDNeIgSN6fVCDinF0sSJD0eV6mpBQYh
         VZGg==
X-Gm-Message-State: AOJu0YzMvbfmQNj2R44hcWaodCQ6E9yxH9Qgz0+jxIaNByp93FSpu/xl
	ueQ0jWT55om5flckbiDNQiapx8AB98hOEszOydDp/qlzWJ4rr+AaKpMoeUUhrmTVH3kX6JOewXY
	mBc0qIqacaFn4nFkL/JivTQVg1A==
X-Google-Smtp-Source: AGHT+IGPXLDZWdQ01xSF5vwVUEvM63Oa9VbzyN03sgreMMdlCA1lTf5W6fu5gBrFtOdKNhEXd57baollNGh6EzGAMw==
X-Received: from pjux3.prod.google.com ([2002:a17:90a:d683:b0:32e:d03b:ade9])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2fc5:b0:339:ec9c:b275 with SMTP id 98e67ed59e1d1-339ec9cb492mr1079186a91.6.1759775443313;
 Mon, 06 Oct 2025 11:30:43 -0700 (PDT)
Date: Mon, 06 Oct 2025 11:30:41 -0700
In-Reply-To: <20251003232606.4070510-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-7-seanjc@google.com>
Message-ID: <diqzsefvevce.fsf@google.com>
Subject: Re: [PATCH v2 06/13] KVM: selftests: Stash the host page size in a
 global in the guest_memfd test
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Use a global variable to track the host page size in the guest_memfd test
> so that the information doesn't need to be constantly passed around.  The
> state is purely a reflection of the underlying system, i.e. can't be set
> by the test and is constant for a given invocation of the test, and thus
> explicitly passing the host page size to individual testcases adds no
> value, e.g. doesn't allow testing different combinations.
>
> Making page_size a global will simplify an upcoming change to create a new
> guest_memfd instance per testcase.
>
> No functional change intended.
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>

Tested-by: Ackerley Tng <ackerleytng@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 37 +++++++++----------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> 
> [...snip...]
> 

