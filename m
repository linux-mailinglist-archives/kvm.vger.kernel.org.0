Return-Path: <kvm+bounces-33489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9569ED330
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B729B16239A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 17:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0264A1DE4EF;
	Wed, 11 Dec 2024 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i3Vavoyo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCF31B6CE5
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733937375; cv=none; b=huOicXR7bOC07h+lAU71dcu1ixOfQgM0u+7tXW8wkVbLyG63ZioSTjmqQ8NkvNRv26zq7moVcFjwvprBzEVyMLBCMMutUzANy3NbZW0YC76gUlCq8vKscp1fCUVP/D3yOQOwTK7BBgb2iDEGC4LLZPq/UMHw7F1tWh6qP32474w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733937375; c=relaxed/simple;
	bh=1Bg0HDDd5hVUmeMPKSQhA2BtiP2IlH/WhffcTIdExEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o82ufIieYiB4cp7jWsjW17uD5AmgIWMqO/lEZGjduZaIrk7+egtJKrLLHfaUI9ot6f+Jud75+ek8vZcks4acJ7bllXmI0E8MXK4ZenigQf6H4mzA/Nrz1QhDnFJO3aFyCeUnjqkXD7cPSUFfa5/iLK+63+Pep3/OgZaxunJ1oDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i3Vavoyo; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21638389f63so35657935ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 09:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733937373; x=1734542173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xUR2R0+d6GPq8zNxl/hIEW1v8ce76QMjMCSjL4//p7E=;
        b=i3Vavoyob/1/BpYZ3dJteFkr+UFghkXGofparyo1Oo99rmLIU3Ybu60gIA/hVgIGDd
         SDZFuKEIMnAgrYWQu9EPXJIrA93wZW3Z5eHeXg9XAfQS1ZtGuHzb+RSbg91aknW26dG8
         8Z/YaB5TOK8MSDyq/KSg4rqPVNletvita+2+cld8LffpkRL8STchgcgrXg+gCSZJBsxn
         IySiBVpX6OEmKUIp/EEUiRlHXnfcn9hdEOAEqOLpYHxAcm71qF6JhMnXFew3oxav/dWQ
         INQ9YAi3cSjUL+C/ERtGvntCxUm4OfprmiIZZm2JuVyipyDyM7TLlEHv6FKSWb/0rPE3
         HZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733937373; x=1734542173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xUR2R0+d6GPq8zNxl/hIEW1v8ce76QMjMCSjL4//p7E=;
        b=bsR7SCn2H9r3aLfQXcovBiDOjvJbpT8BEjW/SA5iTzMj2MuqVdaieupHNwsz0VhIiO
         uu5VtwCnXfyztgpHrFsrFq7Y3Fv+BfRLiFEusDMmCuCzhRYvKV4m+vPrhePfv22QTbFc
         s/TvEZPP2LoPEVh94PkZElxZEKJ9DPO5d2DApF4gUEkyhm9Sp6NnnxXAcvbmQMEce5W/
         OOW6iI80twDXe+fWPAPo/ufLDkkWg3lJ83/jQYR+SSpoy3qaxtZVVL7qvm5iIf9bvRag
         2YtA8pgtjaEHsfXIfgPUWWTslIB+M7Di3HQpHwhEQfF7Mz8dUA5smrkE7+F7eId3nKOE
         dvWQ==
X-Gm-Message-State: AOJu0YzpTK5fweFAGIQgYw8P2Xhuz/2dcF+7X+xqxp2epyBcu7TAUhXO
	SbBQq/obZRtt6usupm72ygxQmCL2de4QsW0/8OrB3zlSLu7TG/7aNqpjW9eR9is1U+aJCzbiqf/
	64g==
X-Google-Smtp-Source: AGHT+IFBtIeYJdkR22NZ5ASv6ASwV4raWSJ+tXh8VB96W82jWALagdmwEAK0M4NjB+BUjr2P+ZDpSskkAok=
X-Received: from pjbst14.prod.google.com ([2002:a17:90b:1fce:b0:2ef:8eb8:e4eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b0f:b0:2ee:863e:9ffc
 with SMTP id 98e67ed59e1d1-2f1392b7986mr943416a91.21.1733937373080; Wed, 11
 Dec 2024 09:16:13 -0800 (PST)
Date: Wed, 11 Dec 2024 09:16:11 -0800
In-Reply-To: <Z1f45XzpgDMC2cvI@mias.mediconcil.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241021102321.665060-1-bk@alpico.io> <Z1eXyv2VVsFiw_0i@google.com>
 <Z1ecILHBlpkiAThl@google.com> <Z1f45XzpgDMC2cvI@mias.mediconcil.de>
Message-ID: <Z1nI22dBe01m3_k6@google.com>
Subject: Re: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 10, 2024, Bernhard Kauer wrote:
> On Mon, Dec 09, 2024 at 05:40:48PM -0800, Sean Christopherson wrote:
> > > With a single vCPU pinned to a single pCPU, the average latency for a CPUID exit
> > > goes from 1018 => 1027 cycles, plus or minus a few.  With 8 vCPUs, no pinning
> > > (mostly laziness), the average latency goes from 1034 => 1053.
> 
> Are these kind of benchmarks tracked somewhere automatically?

I'm not sure what you're asking.  The benchmark is KVM-Unit-Test's[*] CPUID test,
e.g. "./x86/run x86/vmexit.flat -smp 1 -append 'cpuid'".

git@gitlab.com:kvm-unit-tests/kvm-unit-tests.git[*]

