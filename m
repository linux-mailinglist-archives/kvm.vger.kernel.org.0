Return-Path: <kvm+bounces-68219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D65BD278CC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 926663159003
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADD13D1CDC;
	Thu, 15 Jan 2026 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZO7/zFsb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96E42D5C9B
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500257; cv=none; b=T006mkNyy5VAsux46wchaHiGk7MXZ+d4oyO7ht1ZSrH+UoQM+M7QwtI0unfZuuErsyIxTZLg9Umc3BG3uPgZ7A2VURAYLboDWW/9flsrtdya1Whi0fPw2xHr5+o11NNK6SlxwIIvQGJ+lJT86kN9tSO7MLAWImkbcT6C1PDvvEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500257; c=relaxed/simple;
	bh=3h1wHbwbivUh1a4FHfMHIB29fWkrU1oML1OeXskfr40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YnhiQY7nDOzTH/kAcG2jyIdYzlxYEDAOjPVZwKPMEXZonHk0EF3ZLzZEH+bGW5ffWCkZEexbk6DL/onRtk9WhX2/zurPIdptZhBN6lzzicxylSzAVACV6FHja5b/1taiKaY/V2nyPmrZE6+3rBMcxOmRFeLvO4Qv7mfaqMVqPAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZO7/zFsb; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c54e81eeab9so812555a12.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500256; x=1769105056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FWPa2edH23MO18gbaoDEce948cEhwYgwvTfYsQIAt8s=;
        b=ZO7/zFsb9/oCHYM0tMdEM8Do2NZBZ5ksSdiGnZsUdeiyjOFc2sopI5NPZ7G3OKnpLV
         jYhLhpVZvlNONQEreEXQrcB0ypuMJbpCy9+IiGVxNpJOz6NPWNm0WS53tOAbc3pBZuWu
         YoQM9WjsiNb4uKwe4VdghNXl2BI3kxgW9sQH+0MV9ADsIjMibOVRRhNJriI6O9bffYIQ
         nyLHhDjqRmQTpZOiDszPHMwOJzx84pIfsCEup6EhJFw6XC5e5zOpF/VI3NN6YI6ezHag
         u6DlKyGsLvfR7w1J7l05U9WIdu9ZIgcevWF5Jl9XaCrJyaJ3mbwC7fAN7qbWNd1zF1hB
         kY+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500256; x=1769105056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWPa2edH23MO18gbaoDEce948cEhwYgwvTfYsQIAt8s=;
        b=qAgRkJBOtLtN33dLaGCGdV7KXEUyveYLAhcOST9C7BVTefvWwx31N2SgzDx1jKXdXs
         VQ8cr3eMVrkLqNnDeiMlysQlLc+UAL6gFOu1au5PasggyNrGY46+kLj5AyQWn6k6Z5jO
         B2Jr1VbqhpPbudEPjr9haSggp6cBuah+ZE54TxvcsGi/UdZVBz3gV7N/aOqBBd6qaoRz
         8RCGtwg40+G5a0aF8U9gihCBBDOL1hWFPUHcDO/hsO5FjjjMzrLfHltprw3B0kHPjUL3
         a8Wz17KShy+9hWVp3EXFE4PF0Dgau8eAMF0MJxSpWKz7cq4hZBFBIZ3kixMYoQwD+3EC
         Gsxg==
X-Gm-Message-State: AOJu0YyjPzOhVMYWM0NfmqRxjwUSAGHDdQT5JI8NMPV+ncvMCWtK14mf
	nwngqNYQpEybuI3iGiLIuZL4BGYESI0QhebDQwa7kB0gnxeoOcGdjO+7oClwRwVKApvkEx8YGmt
	QQdTP6Q==
X-Received: from pjyw19.prod.google.com ([2002:a17:90a:ea13:b0:340:bd8e:458f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d08:b0:38d:fc34:c88d
 with SMTP id adf61e73a8af0-38dfe7b6e2dmr610183637.55.1768500255930; Thu, 15
 Jan 2026 10:04:15 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:16 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849901874.720432.9876385140637326056.b4-ty@google.com>
Subject: Re: [PATCH v4 0/8] KVM: VMX: Rip out "deferred nested VM-Exit updates"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 08 Jan 2026 19:45:24 -0800, Sean Christopherson wrote:
> v4 of what was "KVM: VMX: Fix APICv activation bugs", but the two bug fixes
> were already merged and so that name doesn't fit.
> 
> Rip out the "defer updates until nested VM-Exit" that contributed to the
> APICv bugs and made them harder to fix.
> 
> v4:
>  - Collect reviews. [Chao]
>  - Use the existing vmcall() in the selftest. [Chao]
>  - Use GUEST_FAIL() instead of TEST_FAIL() in the guest. [Chao]
>  - Correct the number of args passed to the guest in the test. [Chao]
>  - Remove the redundant hwapic_isr_update() call in kvm_lapic_reset()
>  - Use the local "vmx" variable in vmx_set_virtual_apic_mode(). [Chao]
>  - Relocate the "update SVI" comment from __kvm_vcpu_update_apicv()
>    to kvm_apic_update_apicv().
> 
> [...]

Applied to kvm-x86 apic, thanks!

[1/8] KVM: selftests: Add a test to verify APICv updates (while L2 is active)
      https://github.com/kvm-x86/linux/commit/c3a9a27c79e4
[2/8] KVM: nVMX: Switch to vmcs01 to update PML controls on-demand if L2 is active
      https://github.com/kvm-x86/linux/commit/3e013d0a7099
[3/8] KVM: nVMX: Switch to vmcs01 to update TPR threshold on-demand if L2 is active
      https://github.com/kvm-x86/linux/commit/51ca2746078e
[4/8] KVM: nVMX: Switch to vmcs01 to update SVI on-demand if L2 is active
      https://github.com/kvm-x86/linux/commit/f0044429b257
[5/8] KVM: nVMX: Switch to vmcs01 to refresh APICv controls on-demand if L2 is active
      https://github.com/kvm-x86/linux/commit/2bf889a68fba
[6/8] KVM: nVMX: Switch to vmcs01 to update APIC page on-demand if L2 is active
      https://github.com/kvm-x86/linux/commit/51c821d6d0ba
[7/8] KVM: nVMX: Switch to vmcs01 to set virtual APICv mode on-demand if L2 is active
      https://github.com/kvm-x86/linux/commit/249cc1ab4b9a
[8/8] KVM: x86: Update APICv ISR (a.k.a. SVI) as part of kvm_apic_update_apicv()
      https://github.com/kvm-x86/linux/commit/000d75b0b186

--
https://github.com/kvm-x86/linux/tree/next

