Return-Path: <kvm+bounces-14332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 394C48A207E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A2451C20FA3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9450A2BD00;
	Thu, 11 Apr 2024 20:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TY8ZXoB7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989412941E
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868883; cv=none; b=ZsIeqk9wqS89GSV0cD1MUkAkFHDKITHDUZ/ybgMmr1mepAbnpiXqyct1etgoTzpc3NQ+e3dTJ3jyiTCtOWoT0wKSi1ky3UhB2adzdXFWXv/SVoxlXLGK2UvNwqHqqlYU9UhOjpeO1oOwwWB+cyvIfr0pNeEPfOFl5ePKI8bYD7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868883; c=relaxed/simple;
	bh=JbJc9VH1XYlYqPYhzkvludIa59RiQ4mtT6cP44sILfc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YRPIUxeuKOtmQU2aGetP2E8ckylVEqTgEmeXkRLtNwT5hPTlK2ZTL8PUc1gDtVyipP3Z6zoUb0jxlxHMdXHuA2oC/KscUtwuyRwOf6zAB+nvWC0KES6vzhcSJIwhDADUunDXaihmABFWjPjcZ4OvpxVYzy6YuZ+qGYgR4cjOjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TY8ZXoB7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61807bac417so3356537b3.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 13:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712868881; x=1713473681; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KWFlaNq/9xtFUk/XAtkp7IqcVqI76yT0LdFHfnH2DTU=;
        b=TY8ZXoB7UDPLSpRj0U9jgPIoZEP8aEUCiaZrLA5NQ4N3mvg+XZx9x7dlIb3QBhtCDu
         MwN8/0s+MOXXstK9M/luRxlbWw822BGVECCVEkghqNfsKs3QcOFfbRCPHGnjD+IrZmQV
         6kmWRivkQiesOYw2/4SOCfF8M+TIJ76Y90OyRRYw3RkgIOGiXJvpKF4I6W9O03NgaoMI
         POLO19sDz0pKYBklK3+ZV7H540JM98d4kc3zwzkEiCeH+eLM4dMnLZ7RtX6wFYS9zIGt
         xMOHquxlLD1Pmni0KielNscDQHEc/rReakRyIq9wTBOvYzNoDxlzn+3Bu7OkHAdO0xFe
         Lmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712868881; x=1713473681;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWFlaNq/9xtFUk/XAtkp7IqcVqI76yT0LdFHfnH2DTU=;
        b=H15WLN+WKSApZ3CvrSj98LKVRgs1yS3V2fdzY8sLSiKoPx8FiUeC7kYWYIuDHyuRB1
         r2cspFEX+HK71ecvY8XSmqMil+Hr/Z47zn1MkV01qnM88PvKc2xNsWCQ7pd+PGoalNtz
         AJQp4vxK0II+L63vMLnh5KJ+JYX4L7zg9DJFxqkdx2c7rwxMgVkCwtf53bWIDyc5YddP
         2XuIWzxrqOof0z3PLbBXAPf4WTCtrMY3Y4NdKwRmxN/iBknDCg8aYfZQzbJoEcW/+oS3
         6i4dDJkauTHlNtF3ojYtqfYi3P1NWsjuwHmLvHnRYb2BCh9VQXFDNXSVzOOJzaz2ph1V
         TXpw==
X-Forwarded-Encrypted: i=1; AJvYcCU/TX1Mr1ZZPPSVKq3C+e1cs3oEmVsHVFU2itu51sctSTNp0k9cL2F0y5Jd4ckP74lly08fUSgQ4dfiHKRZsSh+G4NZ
X-Gm-Message-State: AOJu0Yzs6YECu1IkZeguWjzF6hWgvDbYz1A1+A24YAuXKE3sJ1E2j29x
	pywwHpsp54y68wSIsJu5FzYPaNsMb8uNqEWYL2Yjj2H1Z/ACYq4sK7pmrKSnoeYsxAAXaE17cd1
	/kw==
X-Google-Smtp-Source: AGHT+IG1z2bEzQy/U6i5K1RFHB6KQPvvtHyO8vGFX+thv3pSwymv/fnCDFqZ1oiTbGlRzVj5Jj0n+Oa+oPY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c01:b0:dc6:cd85:bcd7 with SMTP id
 fs1-20020a0569020c0100b00dc6cd85bcd7mr199706ybb.3.1712868881704; Thu, 11 Apr
 2024 13:54:41 -0700 (PDT)
Date: Thu, 11 Apr 2024 13:54:40 -0700
In-Reply-To: <20240126085444.324918-12-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-12-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhhOEDAl6k-NzOkM@google.com>
Subject: Re: [RFC PATCH 11/41] KVM: x86/pmu: Introduce enable_passthrough_pmu
 module parameter and propage to KVM instance
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> Finally, always propagate enable_passthrough_pmu and perf_capabilities into
> kvm->arch for each KVM instance.

Why?

arch.enable_passthrough_pmu is simply "arch.enable_pmu && enable_passthrough_pmu",
I don't see any reason to cache that information on a per-VM basis.  Blech, it's
also cached in vcpu->pmu.passthrough, which is even more compexity that doesn't
add any value.

E.g. code that is reachable iff the VM/vCPU has a PMU can simply check the module
param.  And if we commit to that model (all or nothing), then we can probably
end up with cleaner code overall because we bifurcate everything at a module
level, e.g. even use static_call() if we had reason to.

