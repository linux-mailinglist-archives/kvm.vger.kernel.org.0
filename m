Return-Path: <kvm+bounces-65889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D50CDCB9A1E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 20:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 232923092414
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 19:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CAD630B519;
	Fri, 12 Dec 2025 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JmmYAWCd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2403430B508
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765567325; cv=none; b=dBaX8zcePCIus9GW66QoAARHu3KA0uQumFClwLhnCePP+sB58otEd6Ix8oOAocyqiSFhIiE9WqXFpQN9wFX5dUagxjPJBYmTRgGt1J2YrUZSVzAtf7NQj7WFAetHwdAL3F2Xlj5Mt/5I188poeYEDU8SP2d4xP54UCbUYJsbLR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765567325; c=relaxed/simple;
	bh=d3xY+Tt5F2lAixFNz0erCGqfYwIxB2/c8x9QCfBSFMk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=MEuA2w8QV1b/15kb/Z7yTJJr348BLLENSVosbHF7lX9k7LyG2xizyNR8j2iAHggUraZvXRFlXd1miRaijhLgRS7r+GZ5q5mmEcXkavuEzjHJ9cuHlA8wk/zubb+LafiNAH/dyEfcxkKILeXz07sF4Il+joL6JXV4R/5tJz4gz2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JmmYAWCd; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65744e10b91so1251062eaf.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 11:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765567323; x=1766172123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d3xY+Tt5F2lAixFNz0erCGqfYwIxB2/c8x9QCfBSFMk=;
        b=JmmYAWCdFQD6/8IWEfycH1cp3NlAxj6pn4RMlvFzYLY+ifb+sgZpxAaXHaD36odD2J
         QahRxKnOdovz0UUzEezQO1nJZOUBXpaFUM+Ts1sL86RoOpnvjcUJJABUXB9l+F9un/ao
         TB/PoJw2zL0H9tZLNpLoUE/Q8fLic5Mu3FrWxGtpjZKa4sdwMHECCsXsb9ZT46lwJEuz
         5YxZLRcup96IBF5wt0UVghZs3zH5ewumbdC69rUCH6kynavZlvLbTN87bUr3859zYMZY
         yvmXz2ZV5uD9i1yDn08zAPuIG0X2s9JAD1OCOmfHNXEBtx2L6vYZx+eOVWJGZ7xF2kFv
         GjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765567323; x=1766172123;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d3xY+Tt5F2lAixFNz0erCGqfYwIxB2/c8x9QCfBSFMk=;
        b=wb/cjd1yxbao/TV9DD78DAzC0QUggjxGh/IjfQTo07oQeW00bec+Bv8Ref1qkbW/Ua
         5swkhwEAj3oApgWJpCzcWJL402SZm0oU/TOnockHL+wa5GmgU4gjMEnTJ9WoWjYWH6dL
         EUj6mHIjhgPXQA+r7pBzckBtPC5eMWpG/JGrNS0xpgzjZx9EeSXuKzdcfmxt78iFewjh
         7VyL/h2nl0/rXKYS5sxbT6fGQtxbHAvfCzJTxLYw/QdoJVj8AgNZQSkqopsVOIEb4n3r
         P+Pms/J8ahxgf2lkB1hIcJNwBlo/RP4tsfIG1ThqVF3Ou0xCyacRpvgXYMk6Mk8Y1AzS
         6snw==
X-Gm-Message-State: AOJu0Yz+BI3K2JixZ5WuUYbojlElIpEGYJ/XwKSbTAVN6a+1xGovRR/J
	o6Bd5Iec5rkGseQj40LbgyIHbfs9YYvNf0v/SUwnZnWLli836M9lMSV92T8bGM1/PxR19FzfCx+
	EtVJCQrJXjLgeH4E7KX6xScjYLA==
X-Google-Smtp-Source: AGHT+IHUbVv4Jy2gEZEkXkuyNos7MiNpoCrDqCxYPzir5lZi9qw+P8UnFJM3AYzANnUq+aZp9M70/ycADG43mzjJoA==
X-Received: from ilbeb21.prod.google.com ([2002:a05:6e02:4615:b0:438:317f:a956])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:290e:b0:659:9a49:90d4 with SMTP id 006d021491bc7-65b4523a33dmr1491761eaf.83.1765567323163;
 Fri, 12 Dec 2025 11:22:03 -0800 (PST)
Date: Fri, 12 Dec 2025 19:22:02 +0000
In-Reply-To: <d3e946ec-787a-424a-9a7a-f04aeb490ba6@arm.com> (message from
 Suzuki K Poulose on Wed, 10 Dec 2025 10:54:10 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt7bur4iat.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 01/24] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 09/12/2025 20:50, Colton Lewis wrote:
>> Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
>> counters reserved for the guest.

>> This required changing HPMN0 to an UnsignedEnum in tools/sysreg
>> because otherwise not all the appropriate macros are generated to add
>> it to arm64_cpu_capabilities_arm64_features.

>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks Suzuki!

