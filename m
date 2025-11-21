Return-Path: <kvm+bounces-64234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B71AC7B692
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0938A4EAB16
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533C02FCC17;
	Fri, 21 Nov 2025 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GhNzOAZC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE852FD67C
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751405; cv=none; b=Wa5PE/Ur6AIWEwp5wOFXNsFGMcJWPW7PdjXwXiMMG0MTmSHA9zvWIrKp1blP5rbMLlr9s7KZ8xwl32CqJAl3PmCXQYnup3Wkfm2gu5c7AMnKUUvRXLkIw8NdTwPIWHqYVt6WR96M7K2JPn1DYi0OX8fBUS1hNV2UI3wKmQGRTM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751405; c=relaxed/simple;
	bh=NuBF5ENbl+bXo2WYVgT9d/UQPTBU/zQ6Z2Vv6/QMa20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=fAEKNGMdDO8bvOGNdOhmzqzHoKrGxdNtsGLIrnsfzWlFL1xW8lk1mINW/ooF70LvU6Ls1ls/qfPelyG6pIBk9U53IZjSG2rprJ+rj/HAY70u6LobEtkWaOEo+SKOlU/hbSacwkYYfVG2BQ6yxTmr2tmWIYFiB1HZfDhHhTZRfEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GhNzOAZC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956f09f382so16928425ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751403; x=1764356203; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gf/8Pk7Wi+5ZKHSgJ1cayHET+i6n5m5sIz+x1glR7jY=;
        b=GhNzOAZCp99htaW4CshAHWJ9e99fYU4xCux4WynwdQfmzp0nhnNt2wkAKjWRNS1yA7
         igdHG2sMP47G0TeKVbE99V0drRtFX2ffUzizcH7ITVBvViXbgMqy/GUNpf+OMAdwP9vH
         ux142NPbw9cm34guZN+3jTwMJmZujCytwPng3ft6iU+gi6L1XCwySfvCpzBsJ37rHp2o
         EjiPeEBXfUU2bQLlVY658f5uaJpjLh4JMVBIrUyM6vqfnbhijRtZZ63WAmj8LOyTDsng
         h4NoBs8HGvWOkfMONSbiy7zp3LhmFEPLJ4xi/x0R3DzPGCV9p/BhhPc42QjOkxFX+lKU
         NBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751403; x=1764356203;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gf/8Pk7Wi+5ZKHSgJ1cayHET+i6n5m5sIz+x1glR7jY=;
        b=IJ6Qr513gnfSFCd2lnJfASZf9uavS90QyQMIT1kVT9WRdsQgrElhgiM6C1lB00ambG
         Iy4XXx3WlZQ2Mw300t6W+i+8KiZjYVbWn6dv6+IHk6Uw2HqBoQxFm3c+N/2Qwgp1rduj
         Fwtb3nGIbWOsfTDF6zTxEaWRTHuMThh39doiE36S7xf4NtUpF/yRXF+lBGzsIIrWq1XZ
         UNGsYJ1klZ6+2WmpHVbQILmgnYT2+Xyl3PXupYL8kW+LjAKHKieXkkcuvYfW1lpaY3ZK
         k1xRxMmNvtr3TmFL8Q0XjRIC8Ta5S/m5WR6OKdmPUs3PgCwWF3bxmzsZBoCSZ+RrtO95
         rIaA==
X-Forwarded-Encrypted: i=1; AJvYcCVJHqVqkvdnfqpeVaHr9M5m3zAIMXO+fWYkF1V22HnC6sTyiFEhA76XiW8b9PzFwqqkG40=@vger.kernel.org
X-Gm-Message-State: AOJu0YytTd5tLQadCDb9vPu0+EIuNLBzz9YJvisWOYOmo0LjqBjfDqLv
	CNKh3L4q2Lz/ZORF+tuYBfVNc9C4K4J4Pn3GY3GcDEBxCfL9E68Mz72VFaGeLxd0xg4KlE/Crc4
	F5uhWYw==
X-Google-Smtp-Source: AGHT+IGl6lVP4k6Ffz1FVATVkFbVRdK/+fQjLr4mrrmG1VOjxZCvjJw3L3ZKENAl8ILCy7qu+uQ9S2crdpg=
X-Received: from plhv10.prod.google.com ([2002:a17:903:238a:b0:298:3543:5212])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11cd:b0:298:639b:a64f
 with SMTP id d9443c01a7336-29b6beee840mr49422585ad.6.1763751403034; Fri, 21
 Nov 2025 10:56:43 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:37 -0800
In-Reply-To: <20251028225827.2269128-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028225827.2269128-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375118181.288827.8430542805047208308.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: selftests: Test SET_NESTED_STATE with 48-bit
 L2 on 57-bit L1
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 28 Oct 2025 15:30:38 -0700, Jim Mattson wrote:
> Prior to commit 9245fd6b8531 ("KVM: x86: model canonical checks more
> precisely"), KVM_SET_NESTED_STATE would fail if the state was captured
> with L2 active, L1 had CR4.LA57 set, L2 did not, and the
> VMCS12.HOST_GSBASE (or other host-state field checked for canonicality)
> had an address greater than 48 bits wide.
> 
> Add a regression test that reproduces the KVM_SET_NESTED_STATE failure
> conditions. To do so, the first three patches add support for 5-level
> paging in the selftest L1 VM.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/4] KVM: selftests: Use a loop to create guest page tables
      https://github.com/kvm-x86/linux/commit/ae5b498b8da9
[2/4] KVM: selftests: Use a loop to walk guest page tables
      https://github.com/kvm-x86/linux/commit/2103a8baf5cb
[3/4] KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
      https://github.com/kvm-x86/linux/commit/ec5806639e39
[4/4] KVM: selftests: Add a VMX test for LA57 nested state
      https://github.com/kvm-x86/linux/commit/6a8818de21d2

--
https://github.com/kvm-x86/linux/tree/next

