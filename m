Return-Path: <kvm+bounces-25915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4472D96CA97
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 00:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE973B22D0E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 22:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCB517ADE7;
	Wed,  4 Sep 2024 22:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IC9N4otR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA8A149DE8
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725490167; cv=none; b=qTfO0xq2qxT6Yy61IYiKfgcVa/o1kA/8R2ZftUYxlgXnpPykRS2z5rivkTn1jICaE6OdAuxtz1r0crbzIcZwM1psjMmUxiDafmybBWIZq7tGfuRWw9c/g+rfp0vUQ21lSnjtm2UeQwrKjrvciTajbpMozALVC0reSHJwl/qhfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725490167; c=relaxed/simple;
	bh=jmw/WoF+sMtgKd5g54QLssILzP8E4zWxN4BoO369wQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c9y5WzclCBEvHc+JNXT8YOTwf0KM3U1aWLy7lMIf6TduU2OSLhnHgqD8mDIXyrZjRGcC5UrbJYriXMGi/8pxJKFwEGuVFtZeMDAxF6fGipUunR25fyTIzbIplD2aKcIRNerHU/Vi86ECfFfIDt1yBhx7ID1XRx/S++sokD0ACqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IC9N4otR; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cf603d9ffaso123480a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 15:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725490165; x=1726094965; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AfjMWL7qSHtmE1rmU7GUtTr0KNqRvj4ny0P55ZezMaI=;
        b=IC9N4otRLJ4DkodH0aTynZHECIIfv1gJMaPj6coIYulx5hQauFgqvvr/jUGhhOWTI9
         qWR0XLuHotxA+f5IgyyA78G/3DaQxwtErBsJYapZQJusK4nZ9eKNGo0EaDDljupVgygZ
         pca+rzhUnxrrS9y5qKnxq0a3AgfV5PTIBtDpmv/qeDuDFiT/Kb32+NrqFOIFQZzMON/z
         Xp16iGR5amMbLcae5uB1ZJ1bLJE58ecP/++b09iqAEdZQadqI+2L+inatg7n/ue1huop
         15cc+EN1wksLULKm14+8tMYN05hrVVLXZA2L64YFOuLExVZwXk2YA6yatdy5K8mmC8Ne
         Cz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725490165; x=1726094965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AfjMWL7qSHtmE1rmU7GUtTr0KNqRvj4ny0P55ZezMaI=;
        b=EO7osn6MmGUUdwKHmzvZMimnWLBW7EoP7Qh7w7HolD0jJ2fVude+Nlj7BE7nvY+bGZ
         J5WFBpzwtEN2OoB2NvoNQuwkqlzwgkQRdGdEQQGouLwnO6tCO/QRh4WQAJIEqj2Hiq6E
         YdQsoGGpYN7/cuImviVDDO2ZPnK+rxnF7TqKy2SfOhHAxsVkAkSb/1SBJ3iO6OBY2QC1
         qEvmINOCy770sd/DO/edv8e++8IC6HxPzsUtDv0p6qVhA3/CHkFWS3wgblFnSiBId0Cm
         wWduCPVxVxedVXbAZk7RVdjHrGSGEyc5M7pmZIUmJnf1TscxxshoAFA8Uc/H4LjSxD1L
         iNpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtVU3jwWjhcRsFb3zuCjz0vJxnzjyNUB24xkWS6jC938gJyh8kl0FN55cjA/zSs6ZHSXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCsdRAijqWQPB0FA+zGmXiIXE15UC5cftssfK33t8sbmEqA5//
	0KIFR4T9ehUu1C36wjcbpCCRvIhvEUbNMSsfsQrxgB9znbhNwFYop7rHzZgcxtI6NT289A/YPqF
	/tA==
X-Google-Smtp-Source: AGHT+IGxB0koQk+4DjbniMid//s+el+4YQz2SWzY87trrY9JIa/Nx1bMlTC4pMlfqu9yuRVU/vSNoPRCjB8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2352:b0:205:799f:124f with SMTP id
 d9443c01a7336-205799f1586mr8750175ad.5.1725490165129; Wed, 04 Sep 2024
 15:49:25 -0700 (PDT)
Date: Wed, 4 Sep 2024 15:49:23 -0700
In-Reply-To: <20240904210830.GA1229985@thelio-3990X>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com> <20240720000138.3027780-2-seanjc@google.com>
 <20240904210830.GA1229985@thelio-3990X>
Message-ID: <Ztjj8xrWMzzrlbtM@google.com>
Subject: Re: [PATCH 1/6] KVM: nVMX: Get to-be-acknowledge IRQ for nested
 VM-Exit at injection site
From: Sean Christopherson <seanjc@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 04, 2024, Nathan Chancellor wrote:
> I bisected (log below) an issue with starting a nested guest that
> appears on two of my newer Intel test machines (but not a somewhat old
> laptop) when this change as commit 6f373f4d941b ("KVM: nVMX: Get
> to-be-acknowledge IRQ for nested VM-Exit at injection site") in -next is
> present in the host kernel.
> 
> I start a virtual machine with a full distribution using QEMU then start
> a nested virtual machine using QEMU with the same kernel and a much
> simpler Buildroot initrd, just to test the ability to run a nested
> guest. After this change, starting a nested guest results in no output
> from the nested guest and eventually the first guest restarts, sometimes
> printing a lockup message that appears to be caused from qemu-system-x86

*sigh*

It's not you, it's me.

I just bisected hangs in my nested setup to this same commit.  Apparently, I
completely and utterly failed at testing.

There isn't that much going on here, so knock wood, getting a root cause shouldn't
be terribly difficult.

