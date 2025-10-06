Return-Path: <kvm+bounces-59539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 88086BBEF49
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 20:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F37DC4F1E86
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 18:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E32A2D9EFB;
	Mon,  6 Oct 2025 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S/mRPlbj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567B92D9493
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759775285; cv=none; b=ROT89SO78ICBo+Xw8iRw11QqoX5P1ejvkJunv/22rT/BwjqhBzpxXcjxUHxAoc+4vAyN0x/7Da0BgZp13UPKZppKlg/q8Me4e00iFuuvIJ1hYQQMI8Fg9OMP0pf3sYgvBOwX59NQnB4jgFPEvzOZBpbnemwihtZYLSs4Doubyvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759775285; c=relaxed/simple;
	bh=iByJ1fVscW5W4F+cs4ecy8OClDdYZUUN/XybSiZqT30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lAMnRQmXiFFnVNt4Rr2orwYemxnRuHaOQP+EsHT2yD/AXfkM3PcEc2xk6O+MQeQXkE4NKnKUsjaVsTB62uzCrM58aocg9u7/RSWZTVBCiUqFAKutyz67fCPSIFJpqChUsLHIt8Nv3mi3mHPePjAK5tdxAUxzxcAX3d/IKCw0nKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S/mRPlbj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339d5dbf58aso4958795a91.3
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 11:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759775284; x=1760380084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2O1LHrnLayz3jZMtWyP5NedHNDuE0QV5RRuTM+R5JU=;
        b=S/mRPlbj+bgh+ckLGmal2K7BHmfkKmsZYQGCHr6SCDZZSyY6ebG/Ri3lUBwWGHnIv9
         1wKF+gmRTs+XPgMSV8Ajq50bJEtzGFUuKTMcUF9aANpDFPmUBKzO7BhP4lLhFLS43tcY
         /MMT4Bm5o0mPVV0kwXSQGQCG7qMZnMJ9durzGKnTDwZD+Kod0DpNze/IirkK0oCpPmeK
         9cXu8LqLE/xDP1Z6qr/6pe7QkeDxf0Tq5LCjLpZduyT2R8l+DPM0LkCJicI6t8zVWbLu
         rBxTWBeH2dT3fEQZApeMMA2FITG0m6NC92FvXBSXZSvrGSc7QmHAy42rNX0H7+AnYwaE
         rTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759775284; x=1760380084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2O1LHrnLayz3jZMtWyP5NedHNDuE0QV5RRuTM+R5JU=;
        b=WOtjqF0cfIGn8fw8nHpcz3K4Zz71anaTqHkRv+cuXoauRgqSD0bykXssKmChEMurcO
         7hv5XCWtKECtxnPasjJRj1lWH7O5zqSgT9R+/+XVLEENI2qCxNf4Jb+Y03y6MyaJ1zan
         x4Dv5RzlcsACNU4Ggi4P12AH2EMvVifjJPz4tYzu3Xs0xIxEstM9yWFtzYUxxfSrr30/
         W81SCGyV3XARjWN+xUKd4vDo9W85v1dOcg2KWH96+fL79had4zQcXnHbvjK6hTHMmYfY
         RtIGPsY/lcZxhCSr0fmBJkDerCiGizNWL6ZlzT+n1QfWyvL3ll9qcQ+DPgX6q1r6mPre
         84bg==
X-Gm-Message-State: AOJu0Ywu33MU+5xKgAWzadWilkoO6rMTHojlPiKSyOvZGUdrVAM1QszO
	1TQZUFsqW2Hmc8f5f5VJBhtRYeWvaSsDkk/Ms5a51X630/22gMzv6nk4XVJTfh8ctT3vPNkJjZE
	26U6xbiUbNZ1JHaW96OZekc0egw==
X-Google-Smtp-Source: AGHT+IFMJwLBrp2rEMeLDG14yNkzmKPoVFGBhyV1fkq3ZMxYnmCJvU/RuM1xX87pM3P5FVvM9FTSiXQVKcBNV2mrfA==
X-Received: from pjis7.prod.google.com ([2002:a17:90a:5d07:b0:330:7dd8:2dc2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a91:b0:332:84c1:31de with SMTP id 98e67ed59e1d1-339c27b6a6emr16543901a91.25.1759775283663;
 Mon, 06 Oct 2025 11:28:03 -0700 (PDT)
Date: Mon, 06 Oct 2025 11:28:02 -0700
In-Reply-To: <20251003232606.4070510-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-11-seanjc@google.com>
Message-ID: <diqzzfa3evgt.fsf@google.com>
Subject: Re: [PATCH v2 10/13] KVM: selftests: Isolate the guest_memfd
 Copy-on-Write negative testcase
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Move the guest_memfd Copy-on-Write (CoW) testcase to its own function to
> better separate positive testcases from negative testcases.
>
> No functional change intended.
>
> Suggested-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/guest_memfd_test.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> 
> [...snip...]
> 

