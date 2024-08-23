Return-Path: <kvm+bounces-24984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 880D795DA06
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 311551F245C5
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136D81C93B7;
	Fri, 23 Aug 2024 23:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eYapxf1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039591CB142
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457500; cv=none; b=B1us3kASfkdW3UMGnsBoJzyArGOw7CDQqAeifizFbVx89RtPzRRJAkbwgQXHD9WEe3J8T/+bGtPy06/L7Ztk8v4XCFpg4x+k0ElPZz1TYKmv6qDbJHAGR5T+5PlU8eWWKUAx3HL9dpbbOBYRhimPo2+C1ZozVMFBmTaJ0mviEU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457500; c=relaxed/simple;
	bh=iwDzKRZnG4hlMNX5TjZTWIkoP7zyKuWwHE6qz8B9Lng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ano+kw7B/sqUwnL79lRCM5GCsYvWmuzc1DhGQWoZyf2yIogv8+Ajr0gkwL9kgy84PVvgSG0ubXAzAGVvuM9Qw2SGetZTyXSq0TwlgwszugXGuynNjD9pr0G36McIrrpok1zrmXSSumWvknU+G23aQqIEjX69B343gI+TftQdzYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eYapxf1F; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71429090d44so2535467b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457498; x=1725062298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qgSapDmp4NaCPBPiiI85f5G2uulp/d8xCq2rC1N7MJc=;
        b=eYapxf1FOIyPKhM4rQyxfSXkySrzEwuv2oW2b7Od3s8O4rbrhbqvU7TNi20arLXVpl
         N5wUFQVdqcMeg9Z++nOHPYROED+NPrRtmTTtlTn5oiUk0Lu9w5wVjQns8EmkYpJanqKN
         8MNPQr/sWhzRY0qd6GDP80KfNo4G1cA7gtppgC1/skAlSzH2rNWD5QyCwolCFJHgpvs2
         Hecnj+Q8bKeBjVvKV6cNs9p3ZUyGutRNvMn2RKgx2AO6+qhBAMIat4aXTlPiGCQ/mog5
         +HZla9V6gqVHHMkiIgQN06zWc7S3VqpgQj7YUxJ+z+q7QRiq7ZTVV9WCzYAIwBuV+C44
         0jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457498; x=1725062298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qgSapDmp4NaCPBPiiI85f5G2uulp/d8xCq2rC1N7MJc=;
        b=oQHe/luGsYz3TJJezEiMTykitfZvvhfuFIY3oZfTbFAnrZ6nDpiDEKmR/O15/c6qeg
         L/UVkrlkIJBHAMuF8SpSLxFucV9STeBRqJfxmeHXPWUgizwsv2urB+KgqJOvtAEpLu8e
         bAI+HmjLQYHCQphIQFGYlA0G2BSGPLCUs8sGysyf7cIMX6BU1gyU9Lyt9As/rmuudzWt
         eTgIaePgl6TPGMXVLyGLQ+I8yUIQ+h+S/ZztxlzOQkJ1I3QroBfikFt8vZmyT7V0A8OP
         qAnH7u1kboI4C/IqQVl0A44vnzhRnwKJ3XuB+SBcB7EtRDeTExGjpXa2gymMKGtHwXll
         qN7g==
X-Forwarded-Encrypted: i=1; AJvYcCXZ+cKOdSO/3tN5Kcw/j218ZEqgLSy1M4KlEiwn4gLRfcBd7KqmGyRGW3cEy86gcdAA99g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRf30i7fr/C2TwfCiw2pJwv7UYgY0FCQsp0CG0YxZ+3NfhXkUi
	iMYWuxn9B/I6unrqtoEHE7CB9jku7Y/Q383vCR9pmLZGQ7gzdzC9tkf3fSV9hw59qLGPY6lID5G
	Kgg==
X-Google-Smtp-Source: AGHT+IE1d8TBDLwGkrW5nVVxwcQCpspHPcAe8LCG0VEYVFwXoAKUvaGGZvcSC3fjR0y0NNZOKfUsm/QJkaU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2f57:b0:706:3421:7406 with SMTP id
 d2e1a72fcca58-714457d564amr23733b3a.1.1724457498052; Fri, 23 Aug 2024
 16:58:18 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:48:01 -0700
In-Reply-To: <20240715101224.90958-1-kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240715101224.90958-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172442194175.3956558.4839132385632552650.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Do not account for temporary memory allocation
 in ECREATE emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 15 Jul 2024 22:12:24 +1200, Kai Huang wrote:
> In handle_encls_ecreate(), a page is allocated to store a copy of SECS
> structure used by the ENCLS[ECREATE] leaf from the guest.  This page is
> only used temporarily and is freed after use in handle_encls_ecreate().
> 
> Don't account for the memory allocation of this page per [1].
> 
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Do not account for temporary memory allocation in ECREATE emulation
      https://github.com/kvm-x86/linux/commit/d9aa56edad35

--
https://github.com/kvm-x86/linux/tree/next

