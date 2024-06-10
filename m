Return-Path: <kvm+bounces-19267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3B1902C86
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 01:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A69C6284CD5
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 23:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE50315253B;
	Mon, 10 Jun 2024 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xEqyr6GH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B041414F9F4
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 23:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718062577; cv=none; b=hoC3V5fvysjMn2OEZ1oR6It6hVi5dBtdTNc7J6pKknhkOIzSA7BkBchjX9RYR4+Im3ywdwxTZZR0uYn1BqcXaY/aQyQolqCv+JbJWvf/tlQlOGZdqPlrMG3LBJHdXM8GDs3qXOl1SJ3Mxm0xhfnVnfXNmHRE5C/YTXmZtWwfuog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718062577; c=relaxed/simple;
	bh=RaFo9p2vr0yi6PvWY5taq73VQiLHnMofL6lua0rlctA=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=kryMeBybQgLAxg5dHKTawhVmUZUoLEuciAVYIpQu59Fdd8c2BhPjQ2VkKZsrvt0+tgSFOfkh3+8L+GlZIsvKX/ZzUb/4ebc73oJ2tSD44nbtlmlFxWxoWiyJ2kEbRlsjBjdnHsZJ+hfAUu3/s+C7Hu7dfZnSk7ast3/Nbg9fPZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xEqyr6GH; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7ead7796052so572319239f.0
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 16:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718062575; x=1718667375; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n6RIv5Wk00aelTMjAMoL6h8M+vMWiQfB3B1hJLzK2nI=;
        b=xEqyr6GH16icJM6rYyj/Csyccs1fBWQR8XVYrdIQDHVVVFOxefHdT3PcB31cR3KmUt
         ybR0v6lMl/qnyj5YxHf15pmFil52uMjaMYq+MKFSApYKEGHRKF8qxX9KCIz7bRroVl7+
         ZQ9DimmI8bGaNQ4U10oQDpyR2i8nd3oVmJ5CPtoEesWlF2d0QySFeM4m23pgFDK1K262
         CGqGbt9vX4shoqDxRrQa+aakXaWqUz18TINTlYA6dbVsqglOkutBqXTyrcboqFE/ggIt
         XnvHcpwHbqt8FmqcloCHpvCNVJrB1LoHfTiMoAWdBziPMo20mEMzKjO2Cp3Fcg2OU25g
         ux4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718062575; x=1718667375;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6RIv5Wk00aelTMjAMoL6h8M+vMWiQfB3B1hJLzK2nI=;
        b=AFZyG5rourSh8xHKQs39RCXFQCPT0z26y3UmVCK31g+8ml+c3UmFs83e+oyEO5NgFd
         cmWmPyzmgEzYXMIehDuaEuWKVkxh6/3oqHFEt1HnSNFGL6hy9RPej7rZHKkw1AgdFyvr
         Gvk+WNDOIeh6hrqvoAc5dE3UXi5FZLaKn+RJiMaVTStY/KBcpHGx4p/KiCdZiVKEICPF
         hmT7rV7NhPdXpGVELmhVxjuXg+zNQw8BgGk/l/NHXAANqyNVjErJgkERQpuEhTlVXT7r
         Ww+kP7SVSho9tl4J/4HNtLsMvnR9Q63ZVa5rpQkQysiYxyKjEK4A9qCCTidKmi1flRMu
         ZSnw==
X-Forwarded-Encrypted: i=1; AJvYcCUpw1ojKd18msE5VbreqK+6MMm+X+XOxKJl2/ESB+glFJRWQXLItIfNnVIvYskndHslYklNd1FtoD65cktKJsdn8KHg
X-Gm-Message-State: AOJu0YwqZynjR5CEmNsDJk1KWfCiatBr62mwG/FY8MPYSyZ8fR/ecAnh
	IDAz/dFbXvKDoOCzSBfZlfO277xd4k/yC5n4M/D+cbvcCy1ijzFL7pjJJLwpd0jD2UoedmKikso
	Jzm1WnGR4/iSNXk0jWagvWQ==
X-Google-Smtp-Source: AGHT+IFaWG97newKoPARMJJXkqNHX3EvcvQU27HHiDPa9QcNLP4f0dZdBbdhInvH4XEh3wXFnqEcoohV1SKPGZXXVg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:6d17:b0:7eb:7e0c:d172 with
 SMTP id ca18e2360f4ac-7eb7e0cd4fbmr32583039f.3.1718062574945; Mon, 10 Jun
 2024 16:36:14 -0700 (PDT)
Date: Mon, 10 Jun 2024 23:36:14 +0000
In-Reply-To: <20231121115457.76269-1-cloudliang@tencent.com> (message from
 Jinrong Liang on Tue, 21 Nov 2023 19:54:48 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntzfrs9xqp.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 0/9] Test the consistency of AMD PMU counters and their features
From: Colton Lewis <coltonlewis@google.com>
To: Jinrong Liang <ljr.kernel@gmail.com>
Cc: seanjc@google.com, pbonzini@redhat.com, likexu@tencent.com, 
	jmattson@google.com, aaronlewis@google.com, wanpengli@tencent.com, 
	cloudliang@tencent.com, ljr.kernel@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Jinrong,

Sorry if this is repeating myself, but I only replied to you before
when I should have included the list.

Sean may have something useful to add as well.

Jinrong Liang <ljr.kernel@gmail.com> writes:

> Hi,

> This series is an addition to below patch set:
> KVM: x86/pmu: selftests: Fixes and new tests
> https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com/

Since this is a few months old and v10 of Sean's patch has been applied
here [1], have you done any further work on this series? No pressure if
not, but Mingwei and I are interested in covering AMD for some PMU
testing we are working on and we want to make sure we know the latest
work.

> Add selftests for AMD PMU counters, including tests for basic  
> functionality
> of AMD PMU counters, numbers of counters, AMD PMU versions, PerfCtrExtCore
> and AMD PerfMonV2 features. Also adds PMI tests for Intel gp and fixed  
> counters.

> All patches have been tested on both Intel and AMD machines, with one  
> exception
> AMD Guest PerfMonV2 has not been tested on my AMD machine, as does not  
> support
> PerfMonV2.

> If Sean fixed the issue of not enabling forced emulation to generate #UD  
> when
> applying the "KVM: x86/pmu: selftests: Fixes and new tests" patch set,  
> then the
> patch "KVM: selftests: Add forced emulation check to fix #UD" can be  
> dropped.

> Any feedback or suggestions are greatly appreciated.

I'll happily review once my question above is answered.

> Sincerely,

> Jinrong

> Jinrong Liang (9):
>    KVM: selftests: Add forced emulation check to fix #UD
>    KVM: selftests: Test gp counters overflow interrupt handling
>    KVM: selftests: Test fixed counters overflow interrupt handling
>    KVM: selftests: Add x86 feature and properties for AMD PMU in
>      processor.h
>    KVM: selftests: Test AMD PMU performance counters basic functions
>    KVM: selftests: Test consistency of AMD PMU counters num
>    KVM: selftests: Test consistency of PMU MSRs with AMD PMU version
>    KVM: selftests: Test AMD Guest PerfCtrExtCore
>    KVM: selftests: Test AMD Guest PerfMonV2

>   .../selftests/kvm/include/x86_64/processor.h  |   3 +
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 446 ++++++++++++++++--
>   2 files changed, 400 insertions(+), 49 deletions(-)


> base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4
> prerequisite-patch-id: e33e3cd1ff495ffdccfeca5c8247dc8af9996b08
> prerequisite-patch-id: a46a885c36e440f09701b553d5b27cb53f6b660f
> prerequisite-patch-id: a9ac79bbf777b3824f0c61c45a68f1308574ab79
> prerequisite-patch-id: cd7b82618866160b5ac77199b681148dfb96e341
> prerequisite-patch-id: df5d1c23dd98d83ba3606e84eb5f0a4cd834f52c
> prerequisite-patch-id: e374d7ce66c66650f23c066690ab816f81e6c3e3
> prerequisite-patch-id: 11f133be9680787fe69173777ef1ae448b23168c
> prerequisite-patch-id: eea75162480ca828fb70395d5c224003ea5ae246
> prerequisite-patch-id: 6b7b22b6b56dd28bd80404e1a295abef60ecfa9a
> prerequisite-patch-id: 2a078271ce109bb526ded7d6eec12b4adbe26cff
> prerequisite-patch-id: e51c5c2f34fc9fe587ce0eea6f11dc84af89a946
> prerequisite-patch-id: 8c1c276fc6571a99301d18aa00ad8280d5a29faf
> prerequisite-patch-id: 37d2f2895e22bae420401e8620410cd628e4fb39
> prerequisite-patch-id: 1abba01ee49d71c38386afa9abf1794130e32a2c
> prerequisite-patch-id: a7486fd15be405a864527090d473609d44a99c3b
> prerequisite-patch-id: 41993b2eef8d1e2286ec04b3c1aa1a757792bafe
> prerequisite-patch-id: 9442b1b4c370b1a68c32eaa6ce3ee4c5d549efd0
> prerequisite-patch-id: 89b2e89917a89713d6a63cbd594f6979f4d06578
> prerequisite-patch-id: 1e9fe564790f41cfd52ebafc412434608187d8db
> prerequisite-patch-id: 7d0b2b4af888fe09eae85ebfe56b4daed71aa08c
> prerequisite-patch-id: 4e6910c90ae769b7556f6aec40f5d600285fe4d0
> prerequisite-patch-id: 5248bc19b00c94188b803a4f41fa19172701d7b0
> prerequisite-patch-id: f9310c716dbdcbe9e3672e29d9e576064845d917
> prerequisite-patch-id: 21b2c6b4878d2ce5a315627efa247240335ede1e
> prerequisite-patch-id: e01570f8ff40aacba38f86454572803bd68a1d59
> prerequisite-patch-id: 65eea4f11ce5e8f9836651c593b7e563b0404459

[1]  
https://lore.kernel.org/kvm/170666267480.3861961.1911322891711579495.b4-ty@google.com/

