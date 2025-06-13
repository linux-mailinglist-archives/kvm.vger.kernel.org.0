Return-Path: <kvm+bounces-49342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 946B9AD7FBD
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D353F7AF8B1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7851A2391;
	Fri, 13 Jun 2025 00:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x6W/DK1P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A608F66
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 00:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749775776; cv=none; b=sTRDdZ2Sc8L1JMW3SzQD7M0zx4GYGTNEXnhh0sq5ruETjW0dLcC9/p7R5Cx+o+Yjl5kh9hCPROxiQw0g2HpDodj0TC3db5X4gI/vj211Kk7j7xxaGU9QkbD9EGXKaFNdR+e5aDJCJzIljTfuRD0t+PT5hHxDpumk5IZeupccWKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749775776; c=relaxed/simple;
	bh=DAqvbA0hS+o5KtM7opWCVp6MBsUfRtbBNRaWQZd+uVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BVu6OSBDDnUhhXxr5UXQj2RrjEVBjYuequ+z4TaLtgcvQnIOMc3YdHDlm+E/pQP1MgIyvhH0Kgv5uc8xZ6PWHa9HHsInYsQMHdTDm6R253a4Gs4TpMFt1ds6LRsTUQkq0L03Ucr8AKffFhWSpJBZHFyl+DcXUVXQ6f2lDr80rYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x6W/DK1P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747ddba7c90so1390234b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 17:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749775774; x=1750380574; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4FvmDiCBlAa5zfliAxjVzhpZvlPI0T0u5Y5VHGSwwmo=;
        b=x6W/DK1PYQlPxFNP9mCpMVQWy+G2qIonCWtLQwQD8Snq3FEfJd4BYYXCjd0kLYz1fQ
         Uqoz7KA9JnXXcJTGW1EMNuYAAnGl7GVkZM1SvgIWTsnbryFAKxG75ppoTSKC1CMq4Lzt
         RutGWX6Sz3jaxeAAmW6uZ9N8c0M67coCZ1brVpkBnxbBFZv/tnEpoqENULlJvQ3/+D4g
         xWwRqaQMD4fO1XbHnB7BN1KaIbZZje/DgFaMNnlCfxOOkkKppxsm3VukY8taO4RGgkTI
         ecWEo4lLvJOnv0FxDhGhhsK3AUkuJS9Ckz8lApk5GXeLgE3gHKC+SB3yWf4dBlXclpIp
         UKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749775774; x=1750380574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FvmDiCBlAa5zfliAxjVzhpZvlPI0T0u5Y5VHGSwwmo=;
        b=Z69GfSZ2NAY05uhMUZVYWrz4rpa/QF7/LHP7Lp2NB6Q3ZXe9vQ3Ie+XvwwTO3pHWL9
         vUb/+wtGigw/b29TD7oLHNfvDn3ZFfYJnhMg0EhcKgDfAMSF3aFnsqW3ZRoIBmU0HoPB
         Ca8i0gwBbLUVxShjMhf/Srl++r8DnPR11bD8MkOhCJk7YEL8fBRU8iBgF0jA/lgvd+le
         bpWHB8vr6sZKmDp1Me7Qx3zQs4gDbtq1krJ2unrA+bqKOIA2gbISna6c87pBvEne9nXR
         gok6frbPUl+NPNmkwt65IX3ORXDoma6wIwI8skD9UXBRyxycKGH1TvVx7bS3h2uL+hVD
         f69g==
X-Forwarded-Encrypted: i=1; AJvYcCWMxYXmHrFiqyMHYK79THDD8OkqTz505VZg4vtGpEpj8QjyjJWbjyYpE7nD7HJP0LFyOm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YztKPCsr6GrkwdszzX1xn2rXe2rF3NAif8DebeYJjr3hTjzTK3k
	DpzKJF4B7R2YZC8zqannTmRYrBFYLjyexFxyqinQKOnpqNz40fqlRU/PIe3xYntRb0371Ll1TCH
	a2GHbdA==
X-Google-Smtp-Source: AGHT+IGCP/N0twmUMa5/oxWlMNDiWLm2BmTdK3OLsZcM14ETDa111hrsNNaEPSG7f+8WEkfL1n5NXpqhx2Q=
X-Received: from pgbda5.prod.google.com ([2002:a05:6a02:2385:b0:b2e:c3bd:cf90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c781:b0:1f5:8cc8:9cbe
 with SMTP id adf61e73a8af0-21facbaed3amr1149706637.5.1749775774647; Thu, 12
 Jun 2025 17:49:34 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:49:33 -0700
In-Reply-To: <c90e3ceba8a47b2139e3393c44e582c5a7b7d151.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com> <20250611213557.294358-6-seanjc@google.com>
 <c90e3ceba8a47b2139e3393c44e582c5a7b7d151.camel@intel.com>
Message-ID: <aEt1nbNvQrL4xrkn@google.com>
Subject: Re: [PATCH v2 05/18] KVM: x86: Move PIT ioctl helpers to i8254.c
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 12, 2025, Kai Huang wrote:
> On Wed, 2025-06-11 at 14:35 -0700, Sean Christopherson wrote:
> > Move the PIT ioctl helpers to i8254.c, i.e. to the file that implements
> > PIT emulation.  Eliminating PIT code in x86.c will allow adding a Kconfig
> > to control support for in-kernel I/O APIC, PIC, and PIT emulation with
> > minimal #ifdefs.
> 
> And it matches the other (existing) ioctl helpers which are under
> CONFIG_KVM_HYPERV [*] and CONFIG_KVM_XEN too.
> 
> [*]:  The kvm_ioctl_get_supported_hv_cpuid() seems to be the only one that
> still remains in kvm/x86.c but not in kvm/hyperv.c.

Ooh, yeah, that'd be a good one to move out of x86.c.

