Return-Path: <kvm+bounces-67803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2056D14710
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0F653038F47
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:40:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAB837E303;
	Mon, 12 Jan 2026 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PUuTF0Qa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2130A37A4BA
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239648; cv=none; b=QOfOvh0mI0wLFtgJulfr0uY6Ltiive0I0BTxNGvTDCPPvBtGmJERJ2FMKjc65PF/vkLJo5AM9AGS6be+qCdIzTU2TX6rHAAFeomsTJWVDiwBnV78CToiMobi95Id5XYVzsVbtT8aYLTKe7p2R9FpKRUVhqH6qKZAe8CFUSAKN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239648; c=relaxed/simple;
	bh=vrYNBHxKnoPzWWLZ8lvkI0TfD+5T2/DdJn4uNF8lo8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nvptc5Wx4UPFmlwpOKBB3P9brwHo/+wN06LWMLlCuHGQhXCJlQyKaGItMyitimFRcDvtP2S1VbhdXIAbdbDHidsnL1euGLGjLW9iwbGce1/7fJJyXTprPLYZH3qfEOYot74DXYYNkCAOJR+59Bugzh9GaNLGkno5JTBSqyWAMww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PUuTF0Qa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so6044507a91.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239646; x=1768844446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jDkM0vwMYAJxr5qVmDDyJdH+s2n7dAxAGuLwKRzlUY=;
        b=PUuTF0QajwlXUMjEHKJVaIP9CljINl8v+OIuO95sBMlslgHzYb/nrt6r1QekLq/Ayr
         h7AT1Tx5rfnhoenKoG6yBCZyUC+AOIuahsd9VYGfG9i6pGDru5YYAaM7srmePjwua/ah
         YiEaE4OpEsEQvr1uMNpfENbwYryqaBmVpb7W+QetqIQdVYpcSOLlwfCZt7w9lgwLdJBW
         C7gvas/z7H1Jved05Qz4ekK4FMm8Z1AsZy5bOPB2W9pOuLH5JESwhlBQA0DLx7pSiGr/
         K/aNEF29CaWgvsKY1p+zZnv4xckTo8AeK8Mp9P7aDiFK7XOaP9k8SKlUf8AmL5K1i1d8
         TuZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239646; x=1768844446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jDkM0vwMYAJxr5qVmDDyJdH+s2n7dAxAGuLwKRzlUY=;
        b=vCNYxrzzVzv2QSw/TQ43rY/dfG9C2BDFak4qgcEcDr+x3OPwz0yfByMAJ1WiKbD+wk
         1Nd79nlXPvwT0HnfoBVH+ThLFgH4raJobvRXYgSdKfc3oGELTpLtMfagcIq3uOtLictf
         axnawOro5CgrMdESTf5jOTjbsr/+mm/6S+nKHKlI1BxPPfHxPGyrPI45VkbrNosIoQKh
         iIa89m1iWJMHWNha9HjuVQUVT4L9ZlMrsiicsyQXL7R+prN9tNk/pY40tpPYS9tzBWxM
         T+vnuoGiWKjJF0JOEUPUuW7X9Vx6kBMwoik4PN/utN0kuEeRrs1g5kgJQN4MorKUJTOj
         feBw==
X-Forwarded-Encrypted: i=1; AJvYcCV7uP77fQJqQnYv01EgHY5xAcfxUUx6pHMlZnui5JZGkNHMCqJL7C29WbbN8LYnitEpvIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu0Hmx6Y9tgnP3oIXniXMQ5J1T5G0JWBTeLiuQnZgkSL5jNSpY
	3ZrSktR8eFf8FPPwzcKu5lqnpE7VQItCT15mf/SKzr/39h86eZOn0eZwz/Mr/qkq4gye7Iajm26
	kzm4Dyg==
X-Google-Smtp-Source: AGHT+IH3h3rJhAHY5xfMO036+pWuKcAVXUYBzJYhJlAUmpzFFCEhiFdWqmRTrMpagSAUGZrYBhWYrPHnNBI=
X-Received: from pjki11.prod.google.com ([2002:a17:90a:718b:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e83:b0:32e:3829:a71c
 with SMTP id 98e67ed59e1d1-34f68b68daamr17980702a91.16.1768239646308; Mon, 12
 Jan 2026 09:40:46 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:46 -0800
In-Reply-To: <20251212135051.2155280-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251212135051.2155280-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823876692.1368504.7601311763496367502.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Don't read guest CR3 when doing async pf
 while the MMU is direct
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, farrah.chen@intel.com
Content-Type: text/plain; charset="utf-8"

On Fri, 12 Dec 2025 21:50:51 +0800, Xiaoyao Li wrote:
> Don't read guest CR3 in kvm_arch_setup_async_pf() if the MMU is direct
> and use INVALID_GPA instead.
> 
> When KVM tries to perform the host-only async page fault for the shared
> memory of TDX guests, the following WARNING is triggered:
> 
>   WARNING: CPU: 1 PID: 90922 at arch/x86/kvm/vmx/main.c:483 vt_cache_reg+0x16/0x20
>   Call Trace:
>   __kvm_mmu_faultin_pfn
>   kvm_mmu_faultin_pfn
>   kvm_tdp_page_fault
>   kvm_mmu_do_page_fault
>   kvm_mmu_page_fault
>   tdx_handle_ept_violation
> 
> [...]

Applied to kvm-x86 misc, with the explicit cast to make 32-bit builds happy.
Thanks!

[1/1] KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct
      https://github.com/kvm-x86/linux/commit/57a7b47ab30f

--
https://github.com/kvm-x86/linux/tree/next

