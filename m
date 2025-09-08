Return-Path: <kvm+bounces-57029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A3DB49D74
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 01:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE751B27CA7
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 23:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5202F7ADC;
	Mon,  8 Sep 2025 23:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emBlllOf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB731B87F2
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373830; cv=none; b=VvYrS3XFU3X8T+ET8yR1rzRzibFruhDb1tN3dfGp6ZxzFWwedNs1nOu+tOSFZtiYBLGWbZbFUbuSpXTSxJNFflU80s1ZDM5ma8yo8T562G31/6MS6TcSJ+BrLvjJcKPuU3am3vLasQTN4HGt5y1XJ3k7f+knMv1L6Edunqgpf54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373830; c=relaxed/simple;
	bh=rMdsxD78c5AGa8Wex3l5Hmbkrt5qXXCa5r1uDm/sEZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVCpsfAj3m9qEDqIB0cc1Otcsg6xGH4JcEvItBv6qkk+zLYQj7nDK+ExYPQUO/oZ/3nQthmQWCtPY3fXmx9EzQCUSXinGdlWZnfvMqW6jkY4QP6to4eyWmFwGZcKGxvAq2haVEq02oxxVKqX84PPoYykq5QxkKjRd5QhsQeAIq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emBlllOf; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32d6c194134so2736166a91.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757373828; x=1757978628; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMdsxD78c5AGa8Wex3l5Hmbkrt5qXXCa5r1uDm/sEZo=;
        b=emBlllOfOQUMAizWGSrPTuJdmhbT0AJZJasv3la6phEL7A3CZzCqHINfVPBGTO33zq
         8+wE7f4KX3bAjbtuwZQJmUmTaBuDKPCQ574rVfpcjYij3BbBjvmVwCj/obdZ7+rva0in
         XqTWJKm9hRAO4MjARjCEssOq9AgLfdbRPtKjsQPDw0tuI/e+5Jn//F/3BhEjNAispglb
         mQHEgGWzhFop2H+xtaAMTybwqpQjyghZhd1F3kINrzriFLWWCQGg5QVF2/BtSvEPfTPy
         1s/WML5/qPcVQs8VhW2BxzZSUF0gueR4NED/OcHYoubN8S1i2xAuraocKAoK7hsXQ3Ax
         mp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757373828; x=1757978628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMdsxD78c5AGa8Wex3l5Hmbkrt5qXXCa5r1uDm/sEZo=;
        b=YFYVtx00n3pddzf+AtGCg1+OQR4jbMX894W4zuaVWR8SAZHod1p2lGmXNscH3bIECG
         PIKVUrEOjJAxrGW0mCvjL2dYnGTwcly7gbyjdBqNxt93kIPntIF2jFJlodHuTXV4YheA
         G3y9uUJa7WatfJoSTAZ3Ls/dPwb60iaYNeZlzBDtntJRlwcv0rVs9aieR9b54x1oJlKl
         xRFIBnTqcDbwZ70HjHK1P7LBmN1IMnQOAB3nhCtO9KzUE99aS03VdLZSsXDEW+flPMGq
         B9yV9hSRXce/lqQt1tdka/E0LgARZkAPobdASrXHfzExvzYX/N6O5RCL2o2hxQwal93G
         b5ZQ==
X-Gm-Message-State: AOJu0YxVZxnphCspGEUBmycSeRAxaLtPBsSpJEjP/iy0VAOOu9/gh07T
	LPq4n9yHYq2GtTgRwWIUQU1HCKZk6ZhSpyD2MxCSo4msfP8yMjiQezcW
X-Gm-Gg: ASbGnctcYCFRNveeArW+1P1/NFbd33XFGTHqxNB/uuoApADGF9B09+575UA27C3Qe+7
	XWpaNIj4avDrjGgTOTQ+wOW2Oql0WqF1ighodQBJyHZuT4/jYiL91gDnWobwKyzM7SVkufkksfR
	nQGPRLX03zj3OzNszWeMe7KSsNjuwR6kgCiRyZ4WAGoXKFgg+EnHxefHjDOQQXobIZm4wtXe7GG
	hwjLacRrr0KzbRHinZOq2zriTCYJaD0aCAL2KLoEqLBP1gNqh24L0xJEsqNYqSB6VN+VuXbRVU4
	JVNeSq4GFIIzett+QRYqxhQOlXY9jv1hfkkE/WizrTrzH5x/vVOy4dEjfvSUp/v5ERpvEMmtLRr
	mzoLBhf+OTwjWq3Cd1q/8kbGImusw+h9sjYFujGvoeXyCG5addrwt4ncx5aIJEriotdnmZui/kP
	g=
X-Google-Smtp-Source: AGHT+IESUGdWe1Ee/nSWwGznnF2h0Olvcl9CCgYGvnoxn0qsqim4i4l3afIwjw/qsfBLtixFhzv5+A==
X-Received: by 2002:a17:90b:3f4c:b0:32b:6132:5f8c with SMTP id 98e67ed59e1d1-32d43f772c9mr11822967a91.18.1757373828398;
        Mon, 08 Sep 2025 16:23:48 -0700 (PDT)
Received: from localhost (123.253.189.97.qld.leaptel.network. [123.253.189.97])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-32b92a671afsm5474922a91.5.2025.09.08.16.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 16:23:48 -0700 (PDT)
Date: Tue, 9 Sep 2025 09:23:44 +1000
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, Shaoqin Huang <shahuang@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	kvm-riscv@lists.infradead.org, Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH 1/2] build: work around secondary expansion limitation
 with some Make versions
Message-ID: <c3itqe5wfydsn2euacwea7kogwomd46izempw6jyu5uhi7zbax@yjiobbuiembh>
References: <20250908010618.440178-1-npiggin@gmail.com>
 <20250908-8ebb10e1e917a5befd6b5f44@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908-8ebb10e1e917a5befd6b5f44@orel>

On Mon, Sep 08, 2025 at 01:22:01PM -0500, Andrew Jones wrote:
> Missing the kvm-unit-tests prefix and, for this patch, the riscv prefix.

Hey, sorry about that, been a while between kvm-unit-tests patches,
thanks for fixing it all up.

Thanks,
Nick

