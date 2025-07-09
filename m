Return-Path: <kvm+bounces-51937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E519AFEB84
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0931560D62
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB8F2E6134;
	Wed,  9 Jul 2025 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FInAPt6P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43F2E5B0E
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069932; cv=none; b=WY1W66+71b/6E35yaCdbhEcLJCovAY4eLfMfdKeUF5/6j+3EthO02iAG22Xq6WC90X+2NwdWaCdGzTUp6i918k1iKjRO8I3t6sNO8SJA2CZlXmXtHY9DhKgnnnYAQbYxH9RZZtoYek+27c6o/xRafB1SAVqeBtUqrPd1nlQ6nd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069932; c=relaxed/simple;
	bh=eq2R43olCt0mKXS/nYv3DiTFOYuZYuJTp2jSSttHiUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KdUGexudAP2kX8dA0jS5qNq7T/sXlxRVgI6ucoIQICiWAjW+6oIu5hLe6rxri4+Pl7X4MKHL/pRiy20b44aQs7UwCOsyCkghS21DL+jPylzjE7Wch2O0Yawb+4E74KdnSXloB1Smf3mrvnTwUqfprxOJi1oG2+C6w88I3TpEl1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FInAPt6P; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313f702d37fso5080531a91.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069930; x=1752674730; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wsCibf9ZiHjq4Pe5rKeumNvzDYZj4QPD/ApNA1NCOCw=;
        b=FInAPt6PebqJ9ef8vABkOy5Xeg58J2xs9Q+Sd1dUGn+PtqJ3s2m8cPeqoj7mTer7Eg
         ws3Fn/G+KDFBU4b1umz+UBh1hmV+jz049/nqK+MK9J8JpEgKeC/wbv/aFgO3mFIoUjg1
         cTGcByueOBpQybsTOn7cobfGuZz6xJUdKrwXIne8KmtHuVUGJiXTowUAsUQVHG5CYohv
         Pa0XZ5GlD7rx2SX72bOJJkpHOBCZxwy2uD7zu7Isikxs6TZBQ0/c+WDYr7aHByMCB7a4
         Xm6nlShDEGsgIdzQq1/wJNr4lgWfoFBWk0QbQmbtiKdKUXQT5JdoI3MEATM8iiKsLM96
         GLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069930; x=1752674730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wsCibf9ZiHjq4Pe5rKeumNvzDYZj4QPD/ApNA1NCOCw=;
        b=DwAHRJmj6ezuLpy+VxOWYckcLXOZKK8PwYzkdkIcfd4OAjgDpk/6Nzyoy9Hlhet8E4
         TsmrUsxBMZ7u9/VN8f0CuLdO5mkCa17xcgLEmyBf409ULzcr4hMbouFW8E5zmKoLhhVt
         JVIAF5u97D/EtGDpfvpyfCAgLowJs/eSEVzTWqUsJ+9fBvGqnkInPlGuAafuTVaM/+uR
         rChjQHy5wF2DJz8ysVOVddrWKKQs/olSDZuA+dAotsw5gslDZ9SXjKQXNFdnk6yClI7C
         tenYcaPzwhFqtaGvPFtjOsC5WtJeBDXC2EvRddt6/V9M+vCAFZVOAfv4i+NUKCDkAR4D
         FyiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD3Qp77uFDWrhJP8FQv6FN/2pU6vb+wzmI3xhM3C6NZxCHuixrLOkWUTuEe4QOECWzfQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwemJcbL5nIE5wjlftEyEvt6dXMv1X/sBrw4lJCWyD3CWJBYt3r
	kPQCUTRCdu74XKc/MXuZrkgAXp7NeTdRkpF6I3dXCltOIPCMdTZ7LC8IcLe0iJWwLYxQWI1VnEC
	Uf63dYw==
X-Google-Smtp-Source: AGHT+IGQ5D/KnPA32Q6AFPnHQBathUdZ+hZBD+fS7a2lhu/QJjnqKpQX+yGZ6G3vlqm2nNTZxCg0N7ZaVFc=
X-Received: from pjbsd3.prod.google.com ([2002:a17:90b:5143:b0:311:c5d3:c7d0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3811:b0:313:287c:74bd
 with SMTP id 98e67ed59e1d1-31c2fdfe649mr4678804a91.33.1752069929821; Wed, 09
 Jul 2025 07:05:29 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:05:28 -0700
In-Reply-To: <20250709033242.267892-5-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-5-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53KGcx4gq45SRA@google.com>
Subject: Re: [RFC PATCH v8 04/35] KVM: x86: Rename VEC_POS/REG_POS macro usages
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> In preparation for moving most of the KVM's lapic helpers which
> use VEC_POS/REG_POS macros to common APIC header for use in Secure
> AVIC APIC driver, rename all VEC_POS/REG_POS macro usages to
> APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET and remove
> VEC_POS/REG_POS.
> 
> While at it, clean up line wrap in find_highest_vector().
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

