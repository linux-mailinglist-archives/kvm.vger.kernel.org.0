Return-Path: <kvm+bounces-8383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3DD84EE8A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 02:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3529283F7D
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3E04C65;
	Fri,  9 Feb 2024 01:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xFpp+r++"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5D4C80
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 01:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707441260; cv=none; b=eECLfYLOjKA6nq+R5Q5RiEBpZqfDOTUDShld13zdSTnOY1XoysTGg2D9ew8H9qU88l0D4PDjTwLbH3t9E7mHOFNPAjIfbA72LaKbExX0s4ILDV00EDBnoJXKzrVgyz3/9BdC3e8LWqrBMedLG/DY523v8UONDrLmU6xF0U11B0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707441260; c=relaxed/simple;
	bh=w91A96XWL7bXEU1Sy7yi4pPndExcXO8TcSfVJwXM5fw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TvjZ00zluXrfaAQfVgeT41w4aQ72aQ7Ladjg5nHXkRYw6bf9qRkwdwr2FVRsi9ejljdc8Fmgxz2qZsLzXsYE74RbFW3BMGk4jVaSU4cTEFVI60t0lU+3XKbRrYgFqBgZzttuXdi7GGUO6kAP4lu3FI/X+8pATtRxRsFKPfivnUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xFpp+r++; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-59502aa878aso180462eaf.1
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 17:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707441258; x=1708046058; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w91A96XWL7bXEU1Sy7yi4pPndExcXO8TcSfVJwXM5fw=;
        b=xFpp+r++oU+AfuEhROJoYNXTT4bbHGVmoXJvLRQe26Us8aOoCyj/vODwVqy/dXANmq
         mIVygkXXjUy3Mthw1l9HuJkFERqaSHE3/ETlsfiGZup9JBzhLZlQRBemqYh1pu48vfp4
         ciY/k4Ej/qBUZf8aGulO7G1xpNfIHNqOIAEiqz3H1hXbNgMFrUdmKsoX124xNHZWO2WL
         2wHGxMjpQhPx70sCnlY5LyIKVbw8x1tekeUu809RaZekoE3g5c3kCh7w88hvsCpBaFkZ
         3SdelvRpSTTscdUQT01HGsA2ESqlAAUxX10oeBQFWJpZ/IQ40n+Cg6HObX+LEz0AKJpB
         LVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707441258; x=1708046058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w91A96XWL7bXEU1Sy7yi4pPndExcXO8TcSfVJwXM5fw=;
        b=HLsFpeis9jn77iq5J4V2iNownhC0yIh/8CrY+3toE9B1aM3jnFwhSNr5263nt5/hlG
         r0X+kuK9SUeJYOaxYmGWmJlVVfF4/DtzzZSr0k4TZfTt8VuA+dlyB+ooiArU37O5qzGc
         OceBN4MFP0IaoQU/5C3/CAZm5RjApcWwaVotLEFBNyn+BBL7MFeeYK1kl6yvmjBg4Sjv
         fmo1F5w19/GNwaUdSTk3cHuniPhOUhyy6dzrxQKHIYr1w4AbgR0sKWb70ZgwJBJCk8uL
         RaQPKgugmAWQarp6EeTXXxQ+zOW3yOuDFjzZU4KY08nsWuXNrabyhmPFBVQaxwh/c//S
         qcgA==
X-Gm-Message-State: AOJu0Yz4e5Xj558yVRpTlVbLG8hn3Io9c5hJl9Z1F8fvKnfrq5p9MjyS
	kpHbEr8xrl/eA4UyJdy7N0jCLJ1UYGJ+rU1ZGkFWY3W3WO2kQH5ITLrd+8gqfYiKJhLi8nsxVGQ
	hE7pCg8+9aAvxfAewmaEUvaPDq38eEpSUlSQQ
X-Google-Smtp-Source: AGHT+IF/dPQomLThdGkmMsZvizB3rgBhDo4q1hHHTNNlblZJaZhwg5OYQa91iqPD6DBwWLCvN0ZuA8WlvV4pvd2O164=
X-Received: by 2002:a4a:dfa7:0:b0:599:5575:bdaf with SMTP id
 k7-20020a4adfa7000000b005995575bdafmr222017ook.9.1707441257960; Thu, 08 Feb
 2024 17:14:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com> <ZcOysZC2TI7hZBPA@linux.dev>
 <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com> <ZcP_JHsMJUlvjAs1@linux.dev>
In-Reply-To: <ZcP_JHsMJUlvjAs1@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 8 Feb 2024 17:13:40 -0800
Message-ID: <CAF7b7mqvAMR3G9Y6nq8SV+DBQ8oz9te0fdg40J97mOw_t3=fhg@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Ah, I finally see what I'm being beaten over the head with- the
kvm_prepare_memory_fault_exit() is a feature of
KVM_CAP_MEMORY_FAULT_INFO, not EXIT_ON_MISSING. You're right of course

Ok, so for this commit in the next version of the series I'm thinking
the following description

> KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in the
> stage-2 fault handler
>
> At the moment the only intended use case for KVM_CAP_MEMORY_FAULT_INFO
> on arm64 is to annotate EFAULTs from the stage-2 fault handler, so
> add that annotation now.

