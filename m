Return-Path: <kvm+bounces-18978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C72138FDA64
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:24:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5408B280CAE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F076216E89D;
	Wed,  5 Jun 2024 23:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QBbJK0QR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC58316D336
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629736; cv=none; b=it3JWXNA8krh7Vd0wDF1OIRMHedrQEHEItMdEoyY0QRf8728mmTrg8s0G87rz4Ojp5L6yDEHadWupT1hYYCS7ymjtcqaYdK8B8k1kvIzmzabOIlY/SFcVqiXBj687VlMhjC8aF2BnnQ0DHl4aP74Y446LSyNCHXLtAgSDhS1tDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629736; c=relaxed/simple;
	bh=bMK9q4b8xR0kyrfnvf3uFf7I/oVL/pOUcUHaMF03KVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HGuknZFs/PX4CQfGnXbbCz0zkhccP0kLQ4pPXf+7JnKKyAyZxk1aUpfX6ZRyZtI3NCZ3sN9BHR5/aD2ZWP9UGoyT2WojSI1fdT4giSVbHjtYetiw7gMMW1fOIdQqrRkuQdDOLJhXOG0Ax8L0fhfKYdZdS+ui6rjdawwUPCfPkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QBbJK0QR; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df79945652eso631697276.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629734; x=1718234534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LXCMTW8sKXWQBQLucWTrB+JIeb0JZWZ+CSwNZobDZNs=;
        b=QBbJK0QR8aF97+oXMIT7BPvm5WpnK85y9goX+1UzsWH5+nrqi6HCkps9Sq2hVGP1Iz
         y/if9U9OOT10AvlDnIa2tE1dhl7wbzqxrv79hqv9Mh976TpF+vZPXdLGWAX6hDmeguoC
         tR3Bb5++S4wxWpMMmQdIqFEXC2qv/VJ83ZM67AsSTNRbOTLd3+H5vNm0KzWpPTQFVmSj
         MIfydd2ty9Z/X9ZFiDK5fNJG68kWdFj+E4FNBL4Ht1Olo2fP9IzqUiu/Fk9xm8v3A5C5
         NxaBUcMRHCWNspPp5juhE6RmQzz/I1tpHMtscqQfgOoGCCJtyEF0dfEs8Thor5JlytdP
         yCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629734; x=1718234534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXCMTW8sKXWQBQLucWTrB+JIeb0JZWZ+CSwNZobDZNs=;
        b=w4YrLVvyvAHD3UmQwLPzNs+JbkGKJhidQLD6q9Oj29vK7pjZnMCSON5B3pxBzuWaug
         lCqhvpnGbmdPmYb4+rSd73HsNddMBIL2uOrcCPJUd7e553haE0dcwzw3C1Dh3etEVnUz
         eES/FLOKcIMckazHnbmk7xAuSdkw38NflKLwOIwrOVrc4YB/NhFp1LhyqdZ13DHDymBv
         SKJLukfPuJZTAAK1eVGALoYsnPymaoq5RAmi7H1wqpooOi7qqwaf+h0Perhyc0DTwN1K
         WgKC23KPyRNlxzCIpJ6I5hda5h5UsCenl8GBSnsN4ioT8XbwOhmEERQDl+JrZWBfMNgB
         6Ziw==
X-Gm-Message-State: AOJu0Yxv0f2BUZWgGtlw0/Wfe9yi4R16bEJjYnkqYWuLkWGOdQ6Q+biL
	T6doe6NK0wlGxMo+IbSNPRY821skBvvq3vpLO036em9rcaDfPdNzRgoDLSSQdzaWFAiNIWLRQKy
	Jjg==
X-Google-Smtp-Source: AGHT+IE3StXN2CX3Jrf0dFydn1LF3C9Is722F+3PYgud3oW1erlYE41pVyj8ljOZ+slf4FXpB2qLPhO6wfQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6b0b:0:b0:dfa:6ea7:88f8 with SMTP id
 3f1490d57ef6-dfacad0f53dmr895616276.12.1717629733917; Wed, 05 Jun 2024
 16:22:13 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:50 -0700
In-Reply-To: <20240306230153.786365-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306230153.786365-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762865345.2913907.8007283655193550688.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] x86/pmu: PEBS fixes and new testcases
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>, 
	Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Mar 2024 15:01:49 -0800, Sean Christopherson wrote:
> One bug fix where pmu_pebs attempts to enable PEBS for fixed counter on
> CPUs without Extended PEBS, and two new testcases to verify adaptive
> PEBS functionality.
> 
> The new testcases are intended both to demonstrate that adaptive PEBS
> virtualization is currently broken, and to serve as a gatekeeper for
> re-enabling adapative PEBS in the future.
> 
> [...]

Applied to kvm-x86 next.  Dapeng, I didn't address your feedback about adding
finer grained message prefixes.  I'm not opposed to doing so, I'm just extremely
short on cycles and want to get the fixes landed.

[1/4] x86/pmu: Enable PEBS on fixed counters iff baseline PEBS is support
      https://github.com/kvm-x86/kvm-unit-tests/commit/79aa106cd427
[2/4] x86/pmu: Iterate over adaptive PEBS flag combinations
      https://github.com/kvm-x86/kvm-unit-tests/commit/fc17d5276b38
[3/4] x86/pmu: Test adaptive PEBS without any adaptive counters
      https://github.com/kvm-x86/kvm-unit-tests/commit/2cb2af7f53db
[4/4] x86/pmu: Add a PEBS test to verify the host LBRs aren't leaked to the guest
      https://github.com/kvm-x86/kvm-unit-tests/commit/8d0f574f4e4d

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

