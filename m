Return-Path: <kvm+bounces-26195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D05D9728BC
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 07:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD4A6283132
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 05:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13FF1684AE;
	Tue, 10 Sep 2024 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D67x91aO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8544A01
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725944419; cv=none; b=Y60tWK2OjBvyp4RbYhk+WWnYD2OZNL9CHHO/aUZDbmt3CJ7QgHraJH8cqhVllPvKFZOro3n1+41RBCmAi3HUZ+gD1krr5nycV3QAZmav0qnZkKxHwxazPWRK7oJ9uhxAmEYuLzagVbUIEoCzgz5Q4gdrEMXS6FIYMP4SI1bx5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725944419; c=relaxed/simple;
	bh=+mPkBYdlkTALZ5eam5h7JwhqrC5Q65xme4gr4dPabEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GeYG45tdJced8zS7H6daEOznEX5goWswDW4cNeM8xddetmhTbjrJVAL9jhq+Wq3zTLd3yMaVTIWS8WehryrZg3WAwLz4nXHyqpqp8l+YcBHHyYwoUEBG9KJ54z7YSjNLMbLhP3PP1Y7Wu2loAWFcK7pM6KqqUB8MiNBlWGK1OfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D67x91aO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e165fc5d94fso11239548276.2
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 22:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725944417; x=1726549217; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WyVHeazKKBSYbddGbsspYAJ9K5Cl0g2D2L02ZZx4czY=;
        b=D67x91aOrcQR6eGkVo8bCuyOGfHLFI8SgzonkxZMG9oUmN3CM3ag2oFPN3ddEzz3MZ
         C7Wq3za96fM5DiGyUE0DyGHQpu87BLdjrmWmbhJOYuM+7eiC10vONwg/2EIRejV27J3N
         VmB1Hjo8bLIkTMxQ9ZMIAVJqzf+hHeOVdqngdjs1IPb1u4TdzPI5rHf0STAFRJThwvQd
         W2br7tZGjisLWr3Q6hZ1iyr4cUhhYPbUUPYnVN1LrqXidoNnjy+ax1bUz24vWyQnLUb5
         IBux0kQKwcTeODAum3kMPyGN+2nlVsKi9vQ0vcAG45Iwpj1hgrK7lzdvTIpe+ZDtn7pS
         OVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725944417; x=1726549217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WyVHeazKKBSYbddGbsspYAJ9K5Cl0g2D2L02ZZx4czY=;
        b=C/qq/66Oyd85F5PuICwO9mxwhkUpzqXAs6zVzexLF7MpWV4DqOiWZSJ/vK85Kufs6t
         NHMz50z/hCE/ZU1qgIhWpHfPk7MmsKi5DlSCI8/2Lz04QkwbJgvA/JuKPODSsLHi6v3q
         leBvcg74tT8BgSpbXfDfNJrGcH2xVx6mmn7g/WWQsFQg264qLtNqapPMbSNIm2GLD3RC
         hruqY36VHHZstyUTvtiUo3nvKah4dwg17H+GOHfiW+XJ4H1YXMmZvau15ICZYT7dhI9q
         eAaSEm14vyTVd/qLTNdtn3Y1od/M7YcuIvyO9oY1B+ub6JVH5CPRzjSdaW7VmrKwDTzD
         xD2Q==
X-Gm-Message-State: AOJu0Yzyro/owLepMQiCPDpXDXIPB1v/GivBMHa5/z37B3Dw6MqNlAl7
	XuXtJX1nusRgp4N5t3WbS+otevaLYAtZNjsyzip8NDU1m7MprhnheiM+tFvnCAycOLyd6D+Xo/v
	YGQ==
X-Google-Smtp-Source: AGHT+IF3O82VpOCGfr/hN3AaMQnAQc8/5Gn5YhrJTUu0VunPz6vJ899PJVQG0rhjs/Y3qNyv0ML043MSz1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1810:b0:e1a:7808:c409 with SMTP id
 3f1490d57ef6-e1d34a49449mr30023276.7.1725944417375; Mon, 09 Sep 2024 22:00:17
 -0700 (PDT)
Date: Mon,  9 Sep 2024 21:56:42 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <172594254948.1553040.1513231357668918094.b4-ty@google.com>
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fix IPIv vs. nested posted interrupts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 05 Sep 2024 21:34:06 -0700, Sean Christopherson wrote:
> Fix a bug where KVM injects L2's nested posted interrupt into L1 as a
> nested VM-Exit instead of triggering PI processing.  The actual bug is
> technically a generic nested posted interrupts problem, but due to the
> way that KVM handles interrupt delivery, the issue is mostly limited to
> to IPI virtualization being enabled.
> 
> Found by the nested posted interrupt KUT test on SPR.
> 
> [...]

Trying this again, hopefully with less awful testing this time...

Applied to kvm-x86 vmx.

[1/7] KVM: x86: Move "ack" phase of local APIC IRQ delivery to separate API
      https://github.com/kvm-x86/linux/commit/a194a3a13ce0
[2/7] KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection site
      https://github.com/kvm-x86/linux/commit/363010e1dd0e
[3/7] KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no IRQ
      https://github.com/kvm-x86/linux/commit/8c23670f2b00
[4/7] KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit injection
      https://github.com/kvm-x86/linux/commit/6e0b456547f4
[5/7] KVM: x86: Fold kvm_get_apic_interrupt() into kvm_cpu_get_interrupt()
      https://github.com/kvm-x86/linux/commit/aa9477966aab
[6/7] KVM: nVMX: Explicitly invalidate posted_intr_nv if PI is disabled at VM-Enter
      https://github.com/kvm-x86/linux/commit/1ed0f119c5ff
[7/7] KVM: nVMX: Assert that vcpu->mutex is held when accessing secondary VMCSes
      https://github.com/kvm-x86/linux/commit/3dde46a21aa7

--
https://github.com/kvm-x86/linux/tree/next

