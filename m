Return-Path: <kvm+bounces-18976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BABE8FDA60
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:23:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C0321F24FE2
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CE716C6B0;
	Wed,  5 Jun 2024 23:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lppFQfrK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EC216D301
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629719; cv=none; b=Y+HUNMf0y2kJczOWp/nnuzv0PR5a3fuy+VJdmkBqSs59F6xaAOe8jypfsTL8//2j9VPNwWbbvPwAz6rPylYxaJHfEBkF/NBhFrfaUofQAFBdAPpGECzt0n1eDiPw4Nb2UBQBB8bG+dZlYjoK6Iz4X6ZyEq2O2djlnOQLiWYmO2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629719; c=relaxed/simple;
	bh=x1ju+c70twUJM2IKO9KHFGxA7yELLu2dADyPYSmSNnE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e95WXxr3OQJ/JvBtPK1Fmdg3ekYZo2Y4h+myxWiDOEa2SDc+9DGqb2y3D0svDJUewECipvVNeS3NYlK5WQuMnj+nqLLyk7kH9n2kdduI72uCDVS2b5IEmxf0WllcuzKXCVWvsDLUZdBZLZu4nUPrCEiAF34FKOInAx/6cNi9f6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lppFQfrK; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso180951276.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629717; x=1718234517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=boJtbx5ylUojjomO5fklsYlCNWafC6t3PjoJY0hF3eA=;
        b=lppFQfrKaTNgKzXmFGy99dx1LM2KTCNxCG6XsbPIKfp7hHxvOGFn1JowjjsxnstjFa
         esGJbpj7WA8HeVx262hgljW6mojFoD2GHgmymPgmzbfAYYMIFPItGPT/+KqjWgTI6OKP
         xkac7xJu/MNmDe2m7g50rduFzoPSscKNkf2gEa6kB46xkQ+NwGJR8mHGK+nrtgUHqtwz
         T8GiiixZF60f9FbGSwgx4wXART3+J2KrIOaEuSSUFpCdBd1pYwZGCbqSJiZFQcZN0xRQ
         SXTGl8i1WJt3excszdFDH4kHwIVVAHKQZD/hWiotuSysXiUBoGPw1UaumwSGYNNjU35L
         E5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629717; x=1718234517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=boJtbx5ylUojjomO5fklsYlCNWafC6t3PjoJY0hF3eA=;
        b=XFGasdufckJTEiP9Yij+dGHLQYfIZEJawckfcfl3EjNvAKl79fnAwhTgfHJQtlbV70
         9kDbgltPo5DI/GjOMxSs+8281TNInRgzwx3W6XL8SNGnw1finaxK5N4lxQ5M5Q016GZl
         jAzRN11bddNMh6kxayHz/AxPndk1x1kySIRnh/y55iWf/agexxvx3jSvcEtxfsjhrMB4
         bX+ZTnguQjcoMqeevNq3g7oPtGrKqeoUsk6bDclMQu7Bx8WlU6qT6cKW22CdHY9/1X1c
         yFcwxeI3YIgo8XUHhRYhwmlC7ZmjoUgNuGXo1wR9aGEmggq8nfsXdpYeGuz2JQsRfCT+
         y3GQ==
X-Gm-Message-State: AOJu0YxSrITvZa8R/yJAKv3H8EZXLxm/vJi60VqWUiqGaWDgmh4j22Ks
	+Euhap7E5ZwZwMKFGnP+wDPYhwlVYJ3IzQ5mJKnEGJrbEVT2bDjI3xxuSdcMsMhu0j8+j6HiWib
	2zA==
X-Google-Smtp-Source: AGHT+IHaTzPTSWwJ6XAsQxLzBR1WAmSLnq60rP60bTBu8T0FedcUu3fpubPy2E7nkghN2gMI83ASlBQXvtk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b02:b0:de5:9ecc:46b6 with SMTP id
 3f1490d57ef6-dfadeba2a13mr324471276.6.1717629716752; Wed, 05 Jun 2024
 16:21:56 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:46 -0700
In-Reply-To: <20230927225441.871050-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230927225441.871050-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762885857.2914537.15650018921645532797.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Clear mask in PMI handler to
 allow delivering subsequent PMIs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Sep 2023 22:54:41 +0000, Mingwei Zhang wrote:
> Clear mask in PMI handler to allow subsequent PMI delivered. SDM 11.5.1
> Local Vector Table mentions: "When the local APIC handles a
> performance-monitoring counters interrupt, it automatically sets the mask
> flag in the LVT performance counter register. This flag is set to 1 on
> reset.  It can be cleared only by software."
> 
> Previously KVM vPMU does not set the mask when injecting the PMI, so there
> is no issue for this test to work correctly. To ensure the test still works
> after the KVM fix merges, add the mask clearing behavior to PMI handler.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86/pmu: Clear mask in PMI handler to allow delivering subsequent PMIs
      https://github.com/kvm-x86/kvm-unit-tests/commit/c595c36114e1

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

