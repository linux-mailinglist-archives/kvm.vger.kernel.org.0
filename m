Return-Path: <kvm+bounces-39540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D088EA47615
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 07:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D25E188EDE1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 06:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A2321D580;
	Thu, 27 Feb 2025 06:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cSa0GA6n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989CA4A1A
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 06:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639172; cv=none; b=lj7xgT1p1WFAFZ7CC7issmOydcMZ3AAnkSGkUTUWIqWeovZXfW5LteYtCWNhYFHdYu/lY6z8f1hj4py+Eab2yqmjr9wyCN3sp2OwLMJoXj8bRwg2JL02u6YFT0d2CSaDBXPtmY9B44w6xT3cJvnhA6vkdG1QGeMC/rRYXkmxWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639172; c=relaxed/simple;
	bh=nCNzOzI0M08HDeRih4DcSzJJGnhcXPq2uXN+1l25rxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k+SYxougCkVvho7Xi6yEKLbXFeAuqSbBreoP+ichAZbEK8Tx1PzMW47grXSPvKjJ6jjuO/z6iqT4GojLGw7GXSaLadUo/RvOTr4DQx2BnsHRkS6uFWKAygActEMelDT1IKwo6sBYtKtNuSQDKf+Pz/baXZoP6iLWDEYqOF3Q6Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cSa0GA6n; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5ded6c31344so683522a12.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 22:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740639168; x=1741243968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g5gJzktVeCYVknQ0iZmn3IWaawV2VsWlJ2cRGNF8zFY=;
        b=cSa0GA6n5cfSYip+aCPvFUMZrdqOAuHS9rq5vR+9RqSeiGvKS3TN3G1Q33UeOm5T0s
         sibhIn5E5oTEN5QVj3LaD9QckGfuVKpZ446gU4wq0p8r02HrrxFIVPg+23dAN3kvJKwc
         lLAGrlfBqk09pkQT0Afe/NrViZiWfCM22U5PwDAyBJk8HaBeESJo/NPZ5pho6L2uvbzs
         O6nyd1s23kB6hn+5Kj0+Px1fltxzWg39i/BErCnZCAk/Og3J9vrPgAvhCsgP2Ebdv+K8
         9/djpTUphQMjp5ClXdXCeKBUSDjH4gTmWVfjiAmF1xooQu5DIythxIrWsHi6X5rSX6kl
         g+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740639168; x=1741243968;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g5gJzktVeCYVknQ0iZmn3IWaawV2VsWlJ2cRGNF8zFY=;
        b=ieM2Zd84GCcnGUWueXqnMEywFr1TRcXJ9nTiWCd23jLymu4HvUVdLFN54dDBF7GxFD
         o0fyq/zZ2QG4S/ko1WNPZKxnf1d2OEJn3sZnxepRD9HGvbumV1XCBc/CS12PQOBlGokM
         /K5uqIPKaX50u94V5TUia7aewgdcZd3aAX9KMYBRgyVLAD09VFpyJnyx0EltCRBIHQAb
         4/vwxMdRjulCbLwOtIoLo64T6LQFO2rC9/FuFxIqbMV70KrxsFxdXippJgDAXDDVP4A6
         LY7QyLOf4kr28Voj6h+4xoQlbZaopQcAHMVeXe8LXMEO9KU3F91YtuDyDK+KtW3ODiA9
         sQMA==
X-Gm-Message-State: AOJu0YzBSqtMw8OvpgtHcLc10jpFSnZg8f9WTRWc9UqTxR5JC/68zXuC
	G4hBwRmq/x2ZSjTeegbDWrTJAnNssPmzOhZfPR/phciaQ8c9pgT+GkN5nnFj6HpcFqA9j2D0ahg
	n
X-Gm-Gg: ASbGncvH0bQfbLwhyFiLDqFTmncR3dgNlWV03Tx09v5FVXqJgX25lxbkgdTejLxB4hm
	211wT5XlwepUlP7cpWfgoJWFdhNDbqO6HvvdI60q9t9eQIqnil31hzL9FzGORxEsIiAwEk/43hB
	EjITwLlyaQhC2c+5xFMPkGjSrkmba5eWhubK5SZVex9eKwaTbCnX0hiU3MHoMUfBLLkkW3+81Za
	BoKrrVLrTo+DZbvBW0/p2/PF7YrNI619jI9EarSUIsP9Sj1LT4WePx0ooI80qqoam8+iwcsE5xC
	XoSgDb1q+81j+6aCNJIg3v6XsnbtE5F+T5mh5imFAPtSo+ywmAav+A==
X-Google-Smtp-Source: AGHT+IFs3oTL57k8VMeDm6SW8NEkHfbS1D1KPyJTNe5tteokiINydQdw4BRZMV0DHNi4YHIy1ByIaw==
X-Received: by 2002:a05:6402:40ca:b0:5e0:922e:527a with SMTP id 4fb4d7f45d1cf-5e43c17fd68mr28243300a12.0.1740639167500;
        Wed, 26 Feb 2025 22:52:47 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [109.121.142.196])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0b9961sm74476966b.10.2025.02.26.22.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 22:52:47 -0800 (PST)
Message-ID: <73f00589-7d6d-489a-ae40-fefdf674ea42@suse.com>
Date: Thu, 27 Feb 2025 08:52:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jon Kohler <jon@nutanix.com>
References: <20250227000705.3199706-1-seanjc@google.com>
 <20250227000705.3199706-3-seanjc@google.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20250227000705.3199706-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 27.02.25 г. 2:07 ч., Sean Christopherson wrote:
> Define independent macros for the RWX protection bits that are enumerated
> via EXIT_QUALIFICATION for EPT Violations, and tie them to the RWX bits in
> EPT entries via compile-time asserts.  Piggybacking the EPTE defines works
> for now, but it creates holes in the EPT_VIOLATION_xxx macros and will
> cause headaches if/when KVM emulates Mode-Based Execution (MBEC), or any
> other features that introduces additional protection information.
> 
> Opportunistically rename EPT_VIOLATION_RWX_MASK to EPT_VIOLATION_PROT_MASK
> so that it doesn't become stale if/when MBEC support is added.
> 
> No functional change intended.
> 
> Cc: Jon Kohler <jon@nutanix.com>
> Cc: Nikolay Borisov <nik.borisov@suse.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

