Return-Path: <kvm+bounces-48856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1A7AD430A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E36B1897700
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617F226462E;
	Tue, 10 Jun 2025 19:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yZJF3kE4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4004C238C20
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584586; cv=none; b=Rt+6c006owGd1CNVjnIsdUdRzW81XxwJHzMHsY2kOJVvF7t/A53snCuAFXcEZ2NlXQ6YWq0R07b+phjNI0Sl2V2Sqv0djQPFEi+/WoO2vl4eqEQThlTGiM26XsOewA8j+xIRgIr/SFxIdvKbLdT+QrgXqHZ/dXbd0WcZZVFNCgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584586; c=relaxed/simple;
	bh=zq0Qh8zkzo1jzdUbo873NBgvMAstydaf+vgfjP+EMUE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XMuPONko3/FeHqV6nKetXE6Sl5htckb7NPONLPVEAGor7ov2ZFMNtrmdU/EbSyIXms/qagl9VvDRbQl6i4VGMZUQOG5T84RN/DmyiIBvH/RYguoOYPf+t6pgj7158IqFM/8SIQozzgnH9vokzcAzgIcJY/G6/bTam54j67TNDSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yZJF3kE4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74847a38e5eso1785432b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584584; x=1750189384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JN65pJvTnX9JvJJkYcaEVSosS7eRXOOBgHuJVpzpRAc=;
        b=yZJF3kE4fClcZfgMwuVyBr3y/1fktJqEta4N9LwT6cw68lh/YeDQyqSSrEI5KSnQ9h
         +6FCyuKcIXZbiLCdNXPwnWSDsnFiPqoHcfi7WK7/TdTm4C8EOSPvlqZu/UFrFnYAKV5B
         WDOK3utzE+oQmM2cwbgenlDUBlppfdYitrTHnG03wnkh8aJLQwmg3mmmtsShguwy/JbU
         l33oyJ3vmvD2hy/jmB8PBLrywdHZ1s1L8WpQYTfO+9bmHvbKJkf0z49rdvAADhzTC1A7
         cVBD76O7wZPpQWG0hL5yBE81kdo+v9bzI4/5tRme/McqwKsy2ziP/52etD+p42X++Nxj
         BV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584584; x=1750189384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JN65pJvTnX9JvJJkYcaEVSosS7eRXOOBgHuJVpzpRAc=;
        b=TBlLYGXskLghZgyZZ0qWL5Nlhmjh620K2Yxg8vb36d+HC74zwyvi3eeT6BSCRanMgT
         9D/Fo9rgVNFwxgadgbAgiKyb80ZEIB1IL+4IARJ+7QlI2HLqVfi0ZH4h4/s8MZ+WkUTI
         l4yNYQbl/vSxSDx2wcQy1A4AgDb82aqifEalQaV+r1wBJ/fSwdovfz3iMRR1MTrM5M7i
         bcfxnwJ5mOS3EUAdSJNZINa0hmmymm2pA6lwvKSxJ0Na0RscHsHECA7qTIywk/al8PpL
         0ojMFQrQgIsXW51bvYysPyTccIc9JfbQdluXTlSPT9EeVHnFH8/0dwgw+YM2AUjEwPuW
         pVrA==
X-Gm-Message-State: AOJu0YxtbLiM4oYinW1Azromn6JaeXjZ1ax9odSwczu9aSzg31kmDWlp
	if/VqxQNGMlDXozCOQvUmNnQWitbngNmfz+j5RiAAarOVdWpRwPKSKWz6ZESyTTtMUDcHpCM2Dw
	TkxWQOw==
X-Google-Smtp-Source: AGHT+IGOLcUSoEyzPXF35NV+TzfJ5fe2Tp8Pah9JFc02XRJPvt1yHuG9VgA91gNcl4QyVBoF9otqfyN5/EU=
X-Received: from pfsq11.prod.google.com ([2002:a05:6a00:2ab:b0:73b:bbec:17e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c88:b0:736:34a2:8a23
 with SMTP id d2e1a72fcca58-7486ce334cbmr937532b3a.15.1749584584641; Tue, 10
 Jun 2025 12:43:04 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:20 -0700
In-Reply-To: <20250304211223.124321-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304211223.124321-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958161204.102519.674416672614502229.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: nSVM: Fix a bug with nNPT+x2AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 04 Mar 2025 13:12:21 -0800, Sean Christopherson wrote:
> Fix a bug in the nNPT passthrough APIC (MMIO) test where it runs with
> x2APIC enabled.  The test currently passes because KVM provides consistent
> behavior when the APIC is accessed via MMIO in x2APIC mode (see
> KVM_X86_QUIRK_LAPIC_MMIO_HOLE), and because it runs with an in-kernel PIT,
> which inhibits x2AVIC.
> 
> But with a split IRQCHIP, i.e. no preconfigured PIT, x2AVIC gets enabled
> and the test fails because hardware doesn't provide the exact same behavior
> as KVM (returns 0s instead of FFs).
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/2] x86: apic: Move helpers for querying APIC state to library code
      https://github.com/kvm-x86/kvm-unit-tests/commit/d427851a1e91
[2/2] x86: nSVM: Ensure APIC MMIO tests run with APIC in xAPIC mode
      https://github.com/kvm-x86/kvm-unit-tests/commit/63a180cba760

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

