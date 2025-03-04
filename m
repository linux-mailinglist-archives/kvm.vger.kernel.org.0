Return-Path: <kvm+bounces-40077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D1EA4EE73
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BF4818905BE
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 20:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2324425290A;
	Tue,  4 Mar 2025 20:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JujmKx8S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056711F7561
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741120423; cv=none; b=fSr1dSf9Q9Dn1C6UK3U3bzqm7mX3I7EcITCcRoBXoOIer94n884Y3b68Eb/sFDOLj9rYFO1WIz97E/KnoCM9oil5t6XZsvV+hRPLGjvpO1s6RfSA+CSdEF11+QAmHoR6UrEl8/jc0OXb50lqOUGgE3bp0vcmh4FIrClQJJoar+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741120423; c=relaxed/simple;
	bh=hNebqbCE2yqbI2osTfkgAzvemKMHxfuWslQEhGVpKdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ly6xbvZijc/5aj1yl+YpxjAvhTbL1S+oAbAOzkuiAv4RePqEBexh4tE3HJgOyOpcqG3Ygqft4P1r5e8kUbtMTeCpOBdo+lmf+J9jVFrd9v9LoWN/ZwS+WitfC09Orvt/7HBaenAP/68hxerIul0Ch+M2MVMK0pqDf2ZGFPGiD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JujmKx8S; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe8de1297eso306150a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 12:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741120421; x=1741725221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aR/mtojvVD4MOofnNj5lekhpmEopZbM3vAwRwI8M1kw=;
        b=JujmKx8SpeVdTirk6al4iTm7cobh+a5VnI5gLg00kagbT0Nsyn+sksmS8R21bUC+Om
         2duD/7gbrj7c+2waHe+XRgQdDD3VHFbZ++db0Scx30tDO57oIpv+iGqr9ootyZVgOCFA
         KwhsVLRWWdoVWnnG+ICTqn3SLeB4TVKQYIfGKpn1JAEcmz7AIXa/0cvmW8/erUFV24P5
         TCTT8Kp0vOA+payK4dqK4PPO/vZc1YQpSMCiq9Ul87hlKwLU48VEBYg1zpHwlKhSv0A5
         G8OT8a2RTaxm8/cp7c4leBAe1bpl6Yw0j8Y/WniudA8YJtlPyBbx+WNhY8TBFMd/U7Gd
         UKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741120421; x=1741725221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aR/mtojvVD4MOofnNj5lekhpmEopZbM3vAwRwI8M1kw=;
        b=h/oDBBRdsnEFmjBCg9A4HEl1bmoM/snyq0+49y4UFON+lgURSw1f/nZeQQYIGBf7fG
         z/k2HjTRJDPfVYd0RBqwLAe3GB+0J/QpDp3fJQ4+UEyl91XEz6EBg9nHmkXboKW5NG7I
         HKBQO5LHOAm0aV5jaQb4huVSjQTLgPfF0Itmjd49QUUUKAmQvYNDcj7BoF81HELnqrjj
         BT7ZydaNi6D31de+H7JFBSYA2YkJHOMt5UZznIr0AnRqew6EO5KkmnTJrJ/dSuyxWI40
         KLjCeQ1BoMv57fzL8y+/FIWbzhrU9U04kf8FGkyiY3Un7gTgx0Nj86MNLMt2LxzXCIl9
         14Pg==
X-Gm-Message-State: AOJu0YxjCF+lXAzVRbLDhA7lnIuGqhNRjEG3avM/oAY4gMFq9NlUf1mF
	cBuWOuVoRgiTB2qVIZMchdzb7DodOXWnsHwNq1gZOcO2DsayoWKvPvuNr//3IFO7JszuAMB4Zn3
	p8w==
X-Google-Smtp-Source: AGHT+IHp1rLM9l3GN6LHS8mT2Yp0gsJ9spM1otODrubQReDL89eKryR2+OL5FrHR9AW18Vuyc/xceNObn7A=
X-Received: from pjre20.prod.google.com ([2002:a17:90a:b394:b0:2ff:4a39:c208])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d64e:b0:2ee:9661:eafb
 with SMTP id 98e67ed59e1d1-2ff49ad68fdmr863352a91.12.1741120421226; Tue, 04
 Mar 2025 12:33:41 -0800 (PST)
Date: Tue, 4 Mar 2025 12:33:39 -0800
In-Reply-To: <c13882ced3c713058c9a1ccf425f396319832b5d.1740479886.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1740479886.git.naveen@kernel.org> <c13882ced3c713058c9a1ccf425f396319832b5d.1740479886.git.naveen@kernel.org>
Message-ID: <Z8djo1eN4q0mqhT8@google.com>
Subject: Re: [RFC kvm-unit-tests PATCH 4/4] x86/apic: Add test for xapic-split
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Naveen N Rao (AMD) wrote:
> The current apic-split test actually uses x2apic. Rename the same, and
> add a separate test for xapic in split irqchip mode.

I would actually prefer we go in the opposite direction and rip out the testcases
that explicitly specify kernel_irqchip=split, not add more.  And instead either
defer to the user via ACCEL=, or make it a top-level switch.

While it would be nice for unittests.cfg to cover more scenarios by "default",
the flip side of doing so is that makes it annoying for an end user to do more,
and gives the false impression that the configurations in unittests.cfg are the
only ones that are worth testing.

E.g. svm_npt fails with kernel_irqchip=split on x2AVIC hardware due to test bugs
(patches incoming), hyperv_connections fails due to what is effectively a
QEMU bug that also got hoisted into KVM[1], and vmx_apic_passthrough_tpr_threshold_test
also fails with kernel_irqchip=split due to a KVM bug that happened to be masked
by another KVM bug with the in-kernel PIT emulation.

[1] https://lore.kernel.org/all/Z8ZBzEJ7--VWKdWd@google.com
[2] https://lore.kernel.org/all/202502271500.28201544-lkp@intel.com

