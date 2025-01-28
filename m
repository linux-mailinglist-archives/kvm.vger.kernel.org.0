Return-Path: <kvm+bounces-36810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 077B5A21429
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 23:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFB011885AE4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 22:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF851E1A28;
	Tue, 28 Jan 2025 22:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUlUVNzH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D84A194A7C
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738103410; cv=none; b=TXpIZPb6zEUc0IcIDtbZuKx/RzB6PbPENfqH+vH6D9yhGtOjjcU7s+Yh3VLPocRdNazTp5ryU2w0B1LzKuDG8ACDqFzuqF6Kr/U/DhJYLqM03Fsevd2swo9PziZQ5CGIS9K12HbMksDPkR6ImkT0Lj/u4D9rWTohH9dosrwVbhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738103410; c=relaxed/simple;
	bh=czbiir5pfHlcVyxdIwc1ZdOJadwEL2taxGiP/GViFzo=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dOtALwi1MV3NY1+LbVVo/ihOz2xMqyGCTO9tXkMdOTo2ZLpOBJnufW7OSe61wwRadbELOhrxe/CCbhqx3vRKq/ZFsuKdsvOOQUjWz9Q12Zh0GJGJUR0kP13F7+WXeqx5NSOEnCQs5LVVFnnJOsbikmiEzsuBS70m6Avt/G1qJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUlUVNzH; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84f543c55dcso924789339f.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738103407; x=1738708207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PJyyD6VmEYWxcK330MV1aDFyCcL0XkNUkxzA2EFgIdQ=;
        b=KUlUVNzHvF+C8Hkm8nG9b8hdsRMYNoWtyHl0RV34Y+vhq5FqUsXpbNbyP3y58GitZp
         tI8hSW93hWj5WYcLKclKv5DU18KGCJvtyCoGCvw73A453Ay7SFiuHn033PDtSE7jFT0O
         pSpDbmOaWpNH0oyLrDbbAjIJagr7Dg+Y0dTvBwN0d9ZnwNs04ExRY9ElswO/3q+U1i07
         fHrs686GTm5M61EiD5EzvggzYoba53h+TwW0orVl2Y9wJub7/Q2IDj4uwVGGl+aJxTo3
         sZ0GF3/fwBVb6H6jEkmoNWgDSqf/M8FslnZnZweAIm+D2kWr6lvg7zLT3xrk723AFH6B
         7LNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738103407; x=1738708207;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJyyD6VmEYWxcK330MV1aDFyCcL0XkNUkxzA2EFgIdQ=;
        b=eOITCQQbvu8QtpsFwlHtArP/+77Akx6zW+RWy90uC4SNiP/QPqBmeJohUHfunf+E1F
         IAMbYDR/2xCtQMnHEM547KeVQCP55roqNob2NH2R55budQ/pHPxYmMEnoiXgiO/S/hrk
         AuVFxo+/Wjzx2LdFlYqleOovQ6d9VAD8e0+cqnq0RhdkCUuO8dGuQbmYf3Fw9OtU0oLB
         LJYpok+ibwo7kVMVjZoTdeOFN8PzFfp0VB8DtGKWHAtxaFCapN/cZb0JY0V6x4R1Q8JD
         mRRwYwFDktPfTBjeStoMGe2PIBOtAkAHHGLQkOwBF0RcFYhM70QDft5LjvgldztyXSXH
         bZsw==
X-Gm-Message-State: AOJu0YxycuSfLY5h2avm5qTqVuXMgdYxOIYHqW0lQK1lCT45uHkkfr+L
	iFfv1oP4/ZQbPtNXvZLBzmgRyx/NLcXlk2xkc8fq8JTpGFIFAGdzcZPwWsYbkxqPf7312caZJSL
	1X2bxR83Fqzj/oj8xTA6HhQ==
X-Google-Smtp-Source: AGHT+IEzKUN81fJKc8eE6WAbDE6ZVYHJOboxJYYulvMty+JLLQCGAA/P2PHrSwX2t2Fmqv3l22wjepYmRho8Tz2r6Q==
X-Received: from ilbby2.prod.google.com ([2002:a05:6e02:2602:b0:3a7:cfdb:57d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fc2:b0:3ce:78ab:dcd1 with SMTP id e9e14a558f8ab-3cffe4a7bf1mr8589345ab.19.1738103407532;
 Tue, 28 Jan 2025 14:30:07 -0800 (PST)
Date: Tue, 28 Jan 2025 22:30:06 +0000
In-Reply-To: <a6152acf-67e1-4800-857f-cffb35a5d738@arm.com> (message from
 Suzuki K Poulose on Tue, 28 Jan 2025 15:55:00 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt5xly372p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 4/4] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 27/01/2025 22:20, Colton Lewis wrote:
>>    	/* Disable all counters */
>> -	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
>> +	if (cpu_pmu->partitioned)
>> +		armv8pmu_mdcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_MDCR_HPME);

> typo: s/armv8pmu_pmcr_read/armv8pmu_mdcr_read

Good catch. Thanks

