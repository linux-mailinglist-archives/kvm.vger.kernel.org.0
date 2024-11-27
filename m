Return-Path: <kvm+bounces-32602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A819DAE92
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B0C28226F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4373202F93;
	Wed, 27 Nov 2024 20:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nCqViHCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3BA14AD29
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732739902; cv=none; b=thQWEs3srlZGG5cGCpubBxg7gDcSnhYNOOTre4NZFcXySv0cwLq0V1YMGsqEiHXAXDNFyLExzFA8P0ISqQzbt4STUAuJGe8H8y1vYE6fcS4GczAyn3Ja9jBK4t3+bdoSYn4Lku4N7p8waHCPwMY7cT4Z2d5VPu0f7W2gRcfqgfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732739902; c=relaxed/simple;
	bh=6+mD4C+g/jqLY+L6PYN3oewQBZ/DIn6Y99OIxtb2QA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kMVIZBDHiH/gSmB6yC8VackKw4Hhq/y3nN/kHqm7yKtQmaOKG1kVp/rQ5ZmsRfi5rUQ0K6UU5Tn4pH0SwgEllOOuiriLf4aLjqI9gZNXfQUKdbFxMHLoCbhqW3NKflm1k9QV0VE5G1dOeHa+e0gm73hhDWg+ouBlYOc/cHPUr8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nCqViHCY; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-724e2c587b1so146545b3a.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732739900; x=1733344700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6+mD4C+g/jqLY+L6PYN3oewQBZ/DIn6Y99OIxtb2QA0=;
        b=nCqViHCY9SMaqfDrmCGX8on+Pv96Ojd6HNF1A127wpPudLgLKIH/hjasaVrsUTwrfo
         CnhvUqQaGiF+x2c76XxlLtTY9LT51qUyrupsVKZflR9mKq0oIopOZ3AGbY1i4dcoeE9m
         jhLnXMVRIG1JeuGs7j73NDFoNqsXnTmZUgKFEiUf5I/4/ue6eZAkXBKS5VBrjrbvZmaV
         jQSuuA5BMxBEHk5Fk9FUCGINWF89v8KAk2JJyuUJUfde780hgZDvc12KzGbkyYKP/b4M
         h6xWevHvb/21dl8yfbK+89nPvcn7h3CGrRH7cfJKYmN4t1mOYrMkJOKxIvCqHWSob3Bz
         kG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732739900; x=1733344700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+mD4C+g/jqLY+L6PYN3oewQBZ/DIn6Y99OIxtb2QA0=;
        b=urFbqG6xXfZ2CpQtiyFD6je69Th78lYxwhe35Ow67WuoSoGA0DSWZ+KJveHPtvoTQS
         uTlc+PyZ8fQ11tBbbRB2VI5p+Ji3kXRv4/fNHFaOzAW66Vgm0pD4lXdgcNtXT47eIhnl
         mtCtF06T0JjwjMFU0x07tMTjbVTGb6+qkfP53yFOSQZMKkiQdvzr2cZ65tDReIGkKZ37
         xgufeU+PEGM54PQPZZ0c2LrpVRyJQnBVtN+DQHF5SwDjGP2R7lZp9Y7OcUJl/tVF69TX
         4g+3uTHaq6nYC5fxzqSHkGJMEIz+qrtKqLDa9c6XuS9JgI37L1thCnOCQIv954FgA2cg
         ifEA==
X-Gm-Message-State: AOJu0YxQYk9qct+Nx+ClZzldfvoge228JwIQEKkdN47MFYPQmvxsNBxX
	VUy5PVftLB7gUSANkd+Af+BSg0N9LWqb3pfvqTmiourx6yYN8wSbprO/dGquZ3m3e6Vy7B2HxjK
	f2Q==
X-Google-Smtp-Source: AGHT+IHs1FEx/7+FjamL+0qR+KqFyw6ZyxN2MV7OKfVFrKcm7kQPcBt+qazj19d6Rt7iVrcs9eNkv9U5948=
X-Received: from ploh14.prod.google.com ([2002:a17:902:f70e:b0:212:4e78:e2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e549:b0:212:c9d:5f62
 with SMTP id d9443c01a7336-21501e5c1f4mr53005205ad.52.1732739899994; Wed, 27
 Nov 2024 12:38:19 -0800 (PST)
Date: Wed, 27 Nov 2024 12:38:18 -0800
In-Reply-To: <20241127201929.4005605-2-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com> <20241127201929.4005605-2-aaronlewis@google.com>
Message-ID: <Z0eDOnkkljPHhbJY@google.com>
Subject: Re: [PATCH 01/15] KVM: x86: Use non-atomic bit ops to manipulate
 "shadow" MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Aaron Lewis wrote:
> From: Sean Christopherson <seanjc@google.com>

Heh, I'll write changelogs for the patches I authored.

> Signed-off-by: Sean Christopherson <seanjc@google.com>

When sending patches authored by someone else, you need to provide your SoB.

