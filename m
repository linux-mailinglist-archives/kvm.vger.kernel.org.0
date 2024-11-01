Return-Path: <kvm+bounces-30320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E89919B94E1
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93BD41F22B04
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F6D1C9B71;
	Fri,  1 Nov 2024 16:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cJq2VxGQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED01C82F1
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730476988; cv=none; b=pNqVzCXo/TerW0VTcM8RF3S80v6JkrS5NyJoHWFEI61FSpb8qlOBoIhoAmthAIfjWgxGXIiNDONA5ujsaOeZOfLW9liq+Wmpn4AFAals71eZ2kJtcgWrOvbB+PQP3XbMTqJeZuayzILCozikIG9ox2n1vyLGHnMKzf8iBTQyvgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730476988; c=relaxed/simple;
	bh=2zE4LIp6LzR/8lsxkCT8jRwkVycEXFB/gd4/b5EK4nY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kxvpHxWJMrNikKFZGvFXBtTIuTr/N9O3TYbNz39s4RWk8RqBe+rdiYL7yLJmTAHyCxOAq3M7lmkAxH0MIK2ZSXQmAW1GUrg485tREiqCpZpAPRHI+gg/MXoHBQpCBJvkzXOlOUhwJRm5U8VuW9KS4WJ3IALQRyaR3v7CZ6oAZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cJq2VxGQ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ed98536f95so1672867a12.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 09:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730476986; x=1731081786; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gkXDxrcKyT/EOUkmvsZDHOw/g7/SMGoUH3RV1Q0HQWI=;
        b=cJq2VxGQbngG3Wf1Fc+Bg8Zkcl1pUyUyVVsAQw2uTUPibidROIOcLgrPdLOY6DWjS5
         4D1DQgPbyV+vKNg8Sn9CWOy4cxTddjC3ZDjmJ7xrvOMSV6jLHQyQmCFmSbRG8s80BfRU
         nYyu2y7EOmk4D77+wM44EH3vo7jrmEMJZCNM1q08r0L4m3nImg3zqKracFdQZ4HpGqHB
         QNzMrLpMv1BJq7SJLkZQEMhOBlpMfmt0tWli5RAJb0NCul848Nbc1wG13NVnpjQyS+Tn
         sXApKbnZFxKxNJ/NITrYSqL669Kx4FbyABa9dIHlCxjnPh18D8jGaoM+PmjXvl5W/nGg
         aXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730476986; x=1731081786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gkXDxrcKyT/EOUkmvsZDHOw/g7/SMGoUH3RV1Q0HQWI=;
        b=I1gTVeC4ctUoPs9f1hdrLAsJfINLky4/lWm869LExNWl0Z0hxVm1t6uWj6og8OMnvy
         kl//S0f/bMSATCggcNdWp/lVpJVwd2CxiB6TvQCq600VLGCsQtxU7bOuAPneKWHQqSyz
         TNDruMwyvKXuiEyZ6i5B9l6Rbhg/35wzNSG4qqT6ZmlF9TRpRJ+RvgLPjS1xY5zV7A+V
         mXKcif5JjabGYyTyghylyZF8jQKzhEUq5+7qk6eoYGssUam6DBxKUrLmywJJv0Gj5QIY
         MBAB+iZ6ZwcAk2Ld+QmcImJkoxZ4GcFr1jfBmlxM1lWu4eQuTlZ4Q74M+FXild5nr0pO
         6LSw==
X-Gm-Message-State: AOJu0Yzq2izyQMZm9JI8StTWLQ0b7yc92vFKhLXBGKysLKmir+9ZI5iR
	9PT1ijTO6weff3PA3QQrNbn3rL6z8XD7ZBQJELY6tzVbUSJg6NKOqjB4ypP0KRiMsCGzuaVrKyD
	OMw==
X-Google-Smtp-Source: AGHT+IEemKwPqqW6XxcH0slJidqXg+owYm5xIFayZQAlONAYlNEAGYl8zydBRjdg5lQNNZ5zaylBfJa0YgY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:1c59:0:b0:7ea:67a0:965c with SMTP id
 41be03b00d2f7-7ee44b1bebcmr9287a12.1.1730476985617; Fri, 01 Nov 2024 09:03:05
 -0700 (PDT)
Date: Fri, 1 Nov 2024 09:03:04 -0700
In-Reply-To: <20241101153857.GAZyT2EdLXKs7ZmDFx@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011214353.1625057-1-jmattson@google.com> <173039500211.1507616.16831780895322741303.b4-ty@google.com>
 <20241101153857.GAZyT2EdLXKs7ZmDFx@fat_crate.local>
Message-ID: <ZyT7uDqK29J46a0P@google.com>
Subject: Re: [PATCH v5 0/4] Distinguish between variants of IBPB
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, dave.hansen@linux.intel.com, 
	hpa@zytor.com, jpoimboe@kernel.org, kai.huang@intel.com, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, sandipan.das@amd.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Borislav Petkov wrote:
> On Thu, Oct 31, 2024 at 12:51:33PM -0700, Sean Christopherson wrote:
> > [1/4] x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
> >       https://github.com/kvm-x86/linux/commit/43801a0dbb38
> > [2/4] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
> >       https://github.com/kvm-x86/linux/commit/99d252e3ae3e
> 
> ff898623af2e ("x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET")

Doh.  I think I'll rebase the entire misc branch onto rc5, realistically the only
downside is having to send updates for all of the hashes.

Thanks for catching this!

