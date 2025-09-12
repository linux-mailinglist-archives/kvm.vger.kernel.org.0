Return-Path: <kvm+bounces-57409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BF8B55207
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BD55169CA2
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF1630E0D3;
	Fri, 12 Sep 2025 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fnOXnWi8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA231DACA1
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757688172; cv=none; b=DTvXvpw+Avlp3teQsiTMw/0+FVYwy09/EFF7vkePs6LUe8WbizkO/1OV4eCHKaCCwtQOWVRWxT/nHT/uKKliDteAEAKJYCxpWL3WbpRjLNET0X+Q6CT193M8P3G9bSa+H+RhLMbuk7k9K/aSe7ZDCFdGgTIt8fSDHt8HLBHOFMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757688172; c=relaxed/simple;
	bh=KTadnoVs1L6tK95w6iygbd6p3+n0bYUtRrTsFoZ4CAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k7mCjohUW/2oLmGRGE9gxjuRQfnYzT02sxtIwKCS3FlwCKxNF/js6lgqEhz7RIlfQKjIdGK0iis3XSWZALhzOeMSqAOt74JagmYr6AoF3UAf7eJYnvOlzzYqe/HvktXlFj943qQYrQ4b80sDv0BU467ilSX93wvzy4hcLVCSfS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fnOXnWi8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2507ae2fb0fso15925595ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 07:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757688170; x=1758292970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yF0zfvMhee/gZd9MiBKDEInbBjcZAk4MGGOi4+ZB0UM=;
        b=fnOXnWi8xVvbjxMd33BuMxu6M/qtZULvNN75Eb/a+TQq8jPjt8scUFWtGCgOIIyxe2
         1UIMmZSsx1lMjskDRd6QU716UDCLu/wSm+ztEam2o53i0Bin+c3m9MuIap9TppYS8RVn
         YkcKayFUz5NKQX3jZw+P+c5cX6LfF7NuZPniQsdDpUohmbNCVqdzet901wqPkPEsZqxE
         0/8n2HtXtuno7+t2tO1X+yWxHHmgKvHZ7MQYIT6SjiTMNx8pd552wZaN2HF69I2yA4oU
         Lf7/naSkaYOYB7XDMnYRf6SmSt+TEetOiB30w35YDqAvQODf1pG0TYxurv2lfhZxSlQD
         hqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757688170; x=1758292970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yF0zfvMhee/gZd9MiBKDEInbBjcZAk4MGGOi4+ZB0UM=;
        b=ivd7DPbGhwgKbWTzAC3hzBk+GNcCGOK3Bi+uNLo3X0n1Fn3O139swui9ZKiw1omziC
         lkiEjD3ownlER4QndjCcMlMp+42BWY1vMsaM6Jk8rAupY9vc8HyOqCBE0/XuIEJJP7W4
         XfhRZNF0b/uJnuS4/klHF1VUDdEjc7vQ8g+P8FoHTtdZSNk5JvgkjV/i0XnhzPWBP2W4
         JiMhosW/BaqqE7T1y0PU5qQeKocj85bpzJ282y6WaNeiASKJwCcvsIbubI4Ar7b3sOvY
         05kqYquzc51+hlPI/nqP3SIhE30FLgF2+xsxrxWiunaBWxcNPetVr4KIE+FlGRL04JG6
         xTEQ==
X-Gm-Message-State: AOJu0YybYF0r8OD9d9PqYWCxGoTn7LuCyMS5RhdxOo/lheeLn42AMd3s
	iWxfeOKl+YwFl7uDAqfFcUdKOWPmnh0r702mx5H+FrHGos8hKS8rBqZQBvXU5waxQ0Zf992a3yA
	vAvdqog==
X-Google-Smtp-Source: AGHT+IHuWddlIKYwLsPDO46b/KLE6cD3JB+tatHKJT4EdyfraYehwgzt5OK7QnPmkojgvWHkl0xgI31PLXg=
X-Received: from pjbsn5.prod.google.com ([2002:a17:90b:2e85:b0:32b:80cc:6439])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ab8e:b0:25c:e2c:6653
 with SMTP id d9443c01a7336-25d271344a4mr24620975ad.48.1757688170547; Fri, 12
 Sep 2025 07:42:50 -0700 (PDT)
Date: Fri, 12 Sep 2025 07:42:49 -0700
In-Reply-To: <20250909093953.202028-16-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909093953.202028-1-chao.gao@intel.com> <20250909093953.202028-16-chao.gao@intel.com>
Message-ID: <aMQxaf6SwMz-RJ0I@google.com>
Subject: Re: [PATCH v14 15/22] KVM: x86: Don't emulate instructions guarded by CET
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, john.allen@amd.com, 
	mingo@kernel.org, mingo@redhat.com, minipli@grsecurity.net, 
	mlevitsk@redhat.com, namhyung@kernel.org, pbonzini@redhat.com, 
	prsampat@amd.com, rick.p.edgecombe@intel.com, shuah@kernel.org, 
	tglx@linutronix.de, weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 09, 2025, Chao Gao wrote:
> @@ -4068,9 +4070,11 @@ static const struct opcode group4[] = {
>  static const struct opcode group5[] = {
>  	F(DstMem | SrcNone | Lock,		em_inc),
>  	F(DstMem | SrcNone | Lock,		em_dec),
> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> +	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk,
> +	em_call_near_abs),

Argh, these wraps are killing me.  I spent a good 20 seconds staring at the code
trying to figure out which instructions are affected.  There's definitely a bit
of -ENOCOFFEE going on, but there's also zero reason to wrap.

> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk,
> +	em_call_far),
> +	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
>  	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
>  	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
>  };

