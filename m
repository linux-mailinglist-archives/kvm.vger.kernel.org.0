Return-Path: <kvm+bounces-50689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DEBAE855E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0188A5A5DAF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B37A2641F9;
	Wed, 25 Jun 2025 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3K/bL6kQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DD125C837
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750859951; cv=none; b=rZqKYm9grZLvn1w6USRvjTWxHYRTi1oAQznvHBHT9Lxg8j9vL/S+GPePMYMFqxTJRUin0voiiIVz7JypqOyo3j5FfXA7/ZC3fpL2cc40Lzetp/+fYFmVFOFUObfEMRz80HfgWvNaWxPXvEKTjUGjvivGZ12h8QdRkn9DC7JymuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750859951; c=relaxed/simple;
	bh=wpziqr1yl0gTdvL6UwsuV5sbAVaoiPzYbMOhqZJwCD0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZUg80tQiWunSDFhDDrLQ+hWc7FjuTvMB0pzf5FPGE4SveF94wlT/NqH1QdymaH5jWDQxldOKfj4WgMQsD5CUG3ZlOyRYIoNPWGEBVleN/TRkunW4MMvDgSbHx8uxW8W5GoOZp3r0L/Mf4ii2QnMDhkm7anPaqIhQul5OggUf2i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3K/bL6kQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23692793178so15566075ad.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750859950; x=1751464750; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DTZm9QvxflsIUmAFZMEHRbPEwz6ipU1FHjjce2WDMM=;
        b=3K/bL6kQxJfM8VcTk4dzOGChiAontMiFFgFsxEcEc42KCr4ZnBcM0s8B3BQkAPNo5a
         4YLbNg0X7bWKYSu/7LKax/mtktaScnwF4u1mVKWsoNZgUZ3ADL436KAtTQO950a4jX5S
         k/L+AsfccQ20N7sBru5p1z+AwpRVwr1hRU4fTdpl+9D+aJjGxAhFFK/O2W96QK3xrB1C
         fztagvHM/ePl+0KqkQgE3HhB5QIgOcbaQAJyUkh3CvcirW3XKfcC5E2h2e9beMSc1kV7
         jVU9pgdVo9l1Ta4Y7zLeC7PV55rx97K1wiCtQ8vkN+wZxcLqjfkcVWoy0fOhmeY7357P
         E0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750859950; x=1751464750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DTZm9QvxflsIUmAFZMEHRbPEwz6ipU1FHjjce2WDMM=;
        b=Djy2CZejEOEVPP+/dWUa03vK1y2youZOJeD2z6gYNGU37SdrNp3YRMak3lAK6L0PdX
         p3spw++vKx+//WhoZle6mkmvpW4+sJemxjUqHP53+wqIyDFpEESe1Gz3FNiWrflp9SnV
         y2+VPIVHUdVvW27iXf6zXtAcnwRYwdmNjYTmVMOITR8EtljIkwqcUH0dcrVW0cQTL8oh
         2Kx/+4BNY3dtV0Oh3t7ZqB+J1QFALLsKaULk8cF7xsouRm7AZX/jHy/Wccln8EgdUOEy
         nMUj4b72cTqCM4rVSP2oylbK8V2jkqUP9Jj1nNwmbAw9lzuTkGJB7wtRqyWjxiDi2xxm
         xagQ==
X-Forwarded-Encrypted: i=1; AJvYcCXo+HpPYBHy8hZJ9lyuNoCaSGa6jQNpbcwGuWQr0ibou8el9mhQID6v4tS+QT5esEB/P+k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6A7S+CKipib4mMOfW5/zOT9ZSiz+piThqx4RabtjQFu7WNkWV
	hsaoWVQHsoW6RZu4HUHa+q3f/2+4dJ97QXd+vJ7pfc29LnnsisG3sqM6pEzPMYJ9fCDRBPTVVIy
	S5wZkhQ==
X-Google-Smtp-Source: AGHT+IGQe92huN8leXfbzYtwrE0iqie4lMiaTPyOttTMTlmm3UfkdJB79ObQOs2LE/JzEH9q+NLF70FDwf4=
X-Received: from plev19.prod.google.com ([2002:a17:903:31d3:b0:234:952b:35a2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e888:b0:235:2375:7ead
 with SMTP id d9443c01a7336-2382424b99fmr55012525ad.28.1750859949699; Wed, 25
 Jun 2025 06:59:09 -0700 (PDT)
Date: Wed, 25 Jun 2025 06:59:08 -0700
In-Reply-To: <20250610175424.209796-12-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com> <20250610175424.209796-12-Neeraj.Upadhyay@amd.com>
Message-ID: <aFwArAOF3e2hhEAn@google.com>
Subject: Re: [RFC PATCH v7 11/37] x86/apic: KVM: Move apic_find_highest_vector()
 to a common header
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> In preparation for using apic_find_highest_vector() in Secure AVIC
> guest APIC driver, move it and associated macros to apic.h.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

