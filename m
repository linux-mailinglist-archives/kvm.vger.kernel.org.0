Return-Path: <kvm+bounces-3894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F45E809918
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:19:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ACA2282111
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 02:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738091FA1;
	Fri,  8 Dec 2023 02:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cu40gsxW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E25910DF
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 18:19:10 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ddd64f83a4so14739857b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 18:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702001949; x=1702606749; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yxWoNxQ7Re4hEPxspP07a4pO5MrpwCF1ltmlTW1Q1tA=;
        b=cu40gsxWLQw2D/KR+vCrTQMieXnAqNYo6SvyYOuM0rOUwV5LDCekbYizw0hdtmnPfc
         Ii/dsfg+btFEhju9cHNQctQ0mP/b/v5ayN7f7lvWSwoocQ/S+o6A8MY3ZnV7i66yuOBk
         m41AtGH+XFlypqf0KhrV504v7/hFAXDDlSwSTMdAePgn3mR5YL2oy72WmwfkpO40WZ5r
         gzBA2khtVxL2tIrtngOEtiumxw3T+ZUvj3E5TSRsOKQyoRTpOqzBtfCLfpmrlhoSotW3
         NsFvy3GFa/xUyst3E8CCKKCw1nxAAYr+xUv77VJnTuAPH4zSxHtU0ZG8juCQidmb0M2i
         GpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702001949; x=1702606749;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxWoNxQ7Re4hEPxspP07a4pO5MrpwCF1ltmlTW1Q1tA=;
        b=RuKGMZ7a+5BM6C19mSwM3LgrwRV9ON2SuKI+GRkUHbcNmAWcp7kwWFJfOd6OKUdG6D
         k3x/wSHGEW6jIu1XZShyEsJjEubg2uPoe5P//kw+QJ8a/VoHULilkVQvNi7sMoFj6uHC
         LbvDIQyJZWZB03Tiv2aJGhJq2DH465r67D8CeG4ma+HVttNgXbfRyBwcu+f2PNzxNMgb
         yk5pVOXpS+k4flzOlIo683dpmtAt/fNVMnYZ/jHzeiIvc0dN5z73DHCfx0eTEfGxYZgJ
         ocJQMRKuuMmqFhhUFtcNh56gTdAP8xzKQ+3vZ22i7Y2zCvWsz/70lP4YliNUfhqjuifL
         Z8aw==
X-Gm-Message-State: AOJu0YzZTKE5tf1ykmOEQsQAvJOf/XR2W+iRuNme9KgK2yxcSLGuASMm
	1BJu4T5Z2Sm+wfyx32w5s3uJ/9HRXb0=
X-Google-Smtp-Source: AGHT+IGLAarIGot/mOxhybAJOqF5zuI2ZbCf7KZAbIPPAPtRn+CDvmhNB9rGKAeknxv5s/UJNTS1xhf9MMM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:844:b0:5d6:cb62:4793 with SMTP id
 bz4-20020a05690c084400b005d6cb624793mr51973ywb.0.1702001949309; Thu, 07 Dec
 2023 18:19:09 -0800 (PST)
Date: Thu,  7 Dec 2023 18:17:39 -0800
In-Reply-To: <20231102162128.2353459-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231102162128.2353459-1-paul@xen.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <170199319421.1675545.670609241239795412.b4-ty@google.com>
Subject: Re: [PATCH v5] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 02 Nov 2023 16:21:28 +0000, Paul Durrant wrote:
> Unless explicitly told to do so (by passing 'clocksource=tsc' and
> 'tsc=stable:socket', and then jumping through some hoops concerning
> potential CPU hotplug) Xen will never use TSC as its clocksource.
> Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
> in either the primary or secondary pvclock memory areas. This has
> led to bugs in some guest kernels which only become evident if
> PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
> such guests, give the VMM a new Xen HVM config flag to tell KVM to
> forcibly clear the bit in the Xen pvclocks.
> 
> [...]

Applied to kvm-x86 xen (and not on a Friday!), thanks!

[1/1] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
      https://github.com/kvm-x86/linux/commit/6d7228352609

--
https://github.com/kvm-x86/linux/tree/next

