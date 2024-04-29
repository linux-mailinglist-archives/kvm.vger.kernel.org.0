Return-Path: <kvm+bounces-16196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B492F8B6449
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 23:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A113AB219F0
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 21:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724021836E2;
	Mon, 29 Apr 2024 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bJCE/hbG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67376181B91
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 21:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714424555; cv=none; b=e73w4pNIhJ6UtugS+IguUj7eLW0mG4EGjUazRmpDlF9q7QuVA8kjErD/p7K7IrdKxNVULPgFINYdbFyTDb8f+YAZS9ErZLk7lDAQrvEAZ+cWG0MbY/rqzjuW25fD08fwgYed5SDKTw49EdIBDFrDb0N5CNiumZMBprwqW86NN98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714424555; c=relaxed/simple;
	bh=cs85e2r4NJuUFXJ/ldnOg8vnp9GecWksd3tK2JQDKYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qdIpSH9C3MuAbHjSow+ieCPvJjyKbhRts+lSgsi8PmrCwQDNmO9Loyrx3opZpbtUiTi9IO7dRe+YwRmx+5VmbApOm1PcGOLQZxMNeZHPLe8XvThVvpndbLSepi30FYSiDTsSXlNZCdPg8EQBsUxwu8kZPjrELSsc0yKnMaJc2Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bJCE/hbG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso4241573a12.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 14:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714424553; x=1715029353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SX25Rd2lbFP13Ouj4hjSpg1j1YlpURzrsvt1/pd7SEw=;
        b=bJCE/hbGf7LCkQvt6kZFmwcD5JhaYP+0i4oaXMbOFcfr0WSapye4XOt7+ySE5595nC
         atT+luuKncc1AtsHJiskqxa6bGzjUoJHyOFR2rigunpsitbB7x1FaXpyAU5JXv0zrY46
         UAZmajliXieFSHxnxLf7/5720sccRVlgOANE729LMcQi9NHJI57hgZFtSBWoZ0iLPy5V
         Qm1ZTlp0xPbtdkHm4FXPk4XgiZqURU3c6CrMOf3R8pJXrQsCx94stkn9RuJsaO8O+oYC
         1oGzzj2jiRlPjRLly5slP0JWXQqZo4BiLSFa7peldGRNLD0Ix94sp+3ZXNoFD3b8nszk
         EYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714424553; x=1715029353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SX25Rd2lbFP13Ouj4hjSpg1j1YlpURzrsvt1/pd7SEw=;
        b=HYsI8cnxch4KT8qo4NXQree3TKQyWnP66w7MQF1h+BONYZH0C1/FZKe0f82tQpPRiH
         TuFbW3AkBj2OFr2te+c0eOHduPy8It1CHtZQpy5Cp2gnYHCY8If8q8f6bq33iW4WHljJ
         tw39qtVVxKEKXJtB9YYGYkyIjgw2wjlFvltZ/hiKtlWQYDh7Lfyn7PNbnMgNOs4KG/7b
         ppeuIUQmVdThqVzptafmK+gmkqHI5Ta3PZ0ef+nrtVZEwMtwIvM3oevxC38lmhsl3RLK
         lNHuu1vUJcoDJo67R8+sbx6xbl8yWb8Dam+dxP2GNzzZQRnra0IIUB5dHAVjAET0p3Mc
         gTmw==
X-Gm-Message-State: AOJu0YxMvH0gLboh2NWqTIGnyKSR+6yUQ5G/cV3I633JLXH5uzWZWwZT
	6U1gKsT/b7D7I8KjFyFemMSLPBAUfvysEmmro3Vmfd5VJtmgysX4SRI2/LLvKLXE9qz2sDSjxRb
	0DQ==
X-Google-Smtp-Source: AGHT+IFMZmLPYd3OCdFQUIxyCcTMBThyalheYS1duqyNYxxDIfX1rQU6Ae0fjGk9raqmcxnsGbT5WX6Vz9g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:36c9:0:b0:5e8:65ae:1142 with SMTP id
 d192-20020a6336c9000000b005e865ae1142mr2278pga.4.1714424553453; Mon, 29 Apr
 2024 14:02:33 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:23 -0700
In-Reply-To: <20240314185459.2439072-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314185459.2439072-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171442342393.161664.6093030957550923677.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: selftests: Introduce vcpu_arch_put_guest()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 14 Mar 2024 11:54:53 -0700, Sean Christopherson wrote:
> The end goal of this series is to add a regression test for commit
> 910c57dfa4d1 ("KVM: x86: Mark target gfn of emulated atomic instruction
> as dirty"), *without* polluting the common dirty_log_test.c code with
> gory x86 details.
> 
> The regression test requires forcing KVM to emulate a guest atomic RMW
> access, which is done via a magic instruction prefix/opcode that is
> guarded by an off-by-default KVM module param.
> 
> [...]

Applied to kvm-x86 selftests_utils, thanks!

[1/5] KVM: selftests: Provide a global pseudo-RNG instance for all tests
      https://github.com/kvm-x86/linux/commit/cb6c6914788f
[2/5] KVM: selftests: Provide an API for getting a random bool from an RNG
      https://github.com/kvm-x86/linux/commit/73369acd9fbd
[3/5] KVM: selftests: Add global snapshot of kvm_is_forced_emulation_enabled()
      https://github.com/kvm-x86/linux/commit/e1ff11525d3c
[4/5] KVM: selftests: Add vcpu_arch_put_guest() to do writes from guest code
      https://github.com/kvm-x86/linux/commit/2f2bc6af6aa8
[5/5] KVM: selftests: Randomly force emulation on x86 writes from guest code
      https://github.com/kvm-x86/linux/commit/87aa264cd89d

--
https://github.com/kvm-x86/linux/tree/next

