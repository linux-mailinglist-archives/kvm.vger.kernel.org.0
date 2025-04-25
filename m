Return-Path: <kvm+bounces-44379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41528A9D639
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1571A4E4C9D
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A152973CF;
	Fri, 25 Apr 2025 23:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XDAIBDMG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444D42973CB
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623476; cv=none; b=Zaz7f3E/V/POKiKSp4MltKep1LJxyfuZS0dFLRsUqGFqKZdPa/NHskATYDulhaYmgugyu+maGfBQuox0PXKyvZB5Ts0mwN2n70F3ep+MOqABvRQe3Ger1clCD2i8kh5zdJLCFpr6/HnUB+FQ5JuBxzqNJsnZQunw/fh0rpYXudg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623476; c=relaxed/simple;
	bh=FoAbQggDlZk6oPFfaUShFKDc3QCpnBzKsvrqftDwZ7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u3IAbjG/R+z7bpW5nFy1bGbZ/UQjHn5WfGGiCMY2rUu6bCK9EWPrteWv/IxQeId6sC09lEq/nRf0TBoaYxshxa6SANyMMEu4AZbnWGKTwEyg/vO82Bcu9XsuEuh9MUl8ojmbtrZqu9sGkuFhxeM3TP3Mv9nobx8h37b4chI+hds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XDAIBDMG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30828f9af10so4948145a91.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745623474; x=1746228274; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MXuKjUhOB6q8zVZI80kru16CGANVa7szp5zNYT9Q4Ro=;
        b=XDAIBDMGXEJq1TDNWZ/thy/8NTfhqZqO4m+pvMP+RVSnuTggNiv16TM+s6gAPf6868
         CZexddR2EHwPUwcMZ4/mYaqq08ETItjoxg2pQSLmxlv8CX9YF56f7599iBuPKBGQdCCm
         gEHBLpTMqAdWZh2fg/+e8+hb03M/xFfX2v1I9UHmo8wojuSFH7rgV1NRzVpRCdAe2O/x
         eAFO290Z32fvw524Q3gErUJBh8B6+IQy5u88MFuR/5czJtBKCuTuz8NtO6pUJWBbZBIv
         zJsvSbBg9vE7A5sEhKt7LF3qIIgUhmgAHHZp7JTT9tpvwNsGuXGwXVz5lMfCTxeJFzRn
         +pzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745623474; x=1746228274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MXuKjUhOB6q8zVZI80kru16CGANVa7szp5zNYT9Q4Ro=;
        b=rVmTSMSji1+neA5Ba9AtLlMsf3yeqPS3AkuK3GB5/MtQVfUiC2bzfVorzHQc6TdT6K
         sIeYTyUwcWAVSAbyPCSys0wjw1Xb8/KYmjM6GQ0dAk1I01oFXvEPHm+1OFN4XbfO3lmE
         d0xb7sYmtRVdsirySfbiA787XExJ/Gs0Dr11L+/qGiyDw9E6EqoOVTpF9R//IGfzMI2n
         vxV6ScZ6IVzFtkaEguuU8BtDNxrbO8eQ1NuXAikvJGdXlbPW0WxkiQjIVcqALWHtftRr
         8DEISB3XT4LPDv5wUDw6cvIpSUXXM6UD4j7iX5HWQCXbunaROZdtxz9hQeyd95/XlrO6
         63bQ==
X-Gm-Message-State: AOJu0YzYwbQU/jUpX6/GvXK3odE6a59BMBb9V+asxaERIwKOXPYskPjz
	X9OQkdDfC2gq5JWmvBkrwMId14JIUUQP9dxvARr4ntgIbH7a1xb5myhBFveKc6kt8aNqGZPKIT8
	3jA==
X-Google-Smtp-Source: AGHT+IG5sYWknJkmp/py87FHHK7y2gSaM1Q1wcecaVMad6g+rRRiarQ0yYmn65Wf2kUB3ObkLrQFQ5u7V/Q=
X-Received: from pjbos8.prod.google.com ([2002:a17:90b:1cc8:b0:2fa:1fac:2695])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48:b0:2ee:b8ac:73b0
 with SMTP id 98e67ed59e1d1-30a01300dddmr2011375a91.2.1745623474463; Fri, 25
 Apr 2025 16:24:34 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:23:24 -0700
In-Reply-To: <20250315024402.2363098-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315024402.2363098-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174562141893.1001155.1831519361027922066.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nVMX: Check MSR load/store list counts during
 VM-Enter consistency checks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Mar 2025 19:44:02 -0700, Sean Christopherson wrote:
> Explicitly verify the MSR load/store list counts are below the advertised
> limit as part of the initial consistency checks on the lists, so that code
> that consumes the count doesn't need to worry about extreme edge cases.
> Enforcing the limit during the initial checks fixes a flaw on 32-bit KVM
> where a sufficiently high @count could lead to overflow:
> 
> 	arch/x86/kvm/vmx/nested.c:834 nested_vmx_check_msr_switch()
> 	warn: potential user controlled sizeof overflow 'addr + count * 16' '0-u64max + 16-68719476720'
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: nVMX: Check MSR load/store list counts during VM-Enter consistency checks
      https://github.com/kvm-x86/linux/commit/17a2c62fbf1e

--
https://github.com/kvm-x86/linux/tree/next

