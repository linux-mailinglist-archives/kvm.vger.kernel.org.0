Return-Path: <kvm+bounces-28932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BA399F466
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 19:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B96221F24FD0
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EC51FAF19;
	Tue, 15 Oct 2024 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dIkSlvNh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CAA1F76C4
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729014682; cv=none; b=kQzZaNGGlHhe2/WqT6cqNRq4Q36B0I/X5FxJDQvOVOZRBBhXcrkPEItECpBVgiV7GFo53O82zLUNVAVjii4ybB9PvbmrWHlarWGeW+y7NzvdIO4/nlWsmnptUBuanGpHB1Tvg9TdOb6rHeHToJb5FlWWvW4SjdJdz5/NnuK7mD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729014682; c=relaxed/simple;
	bh=1YKM3CH5jEHgkpkOmJ9NdqwqHxCL6rD+RoUeOu+M0Zs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kHkLbYudfUtrPTzkgnC42/L3hSYIilH83hoerNuNXMHWe/OkDP7VxWB/K8toK+72f7mAdjfiUOZx6mZzUdCFmH1AQU6avLWlHDBwejKx+G70ZG7ENKKbFpgESrUFTSGkNBnUy1F6r7AWu7dG1PggL8ZouwXjW7qxsYu0OvMpZj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dIkSlvNh; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290b8b69f8so9213256276.2
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 10:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729014680; x=1729619480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LzVsLhNxP8WDtuKH9p/BsiCdMHgFRqj/PD3WiEFxpvI=;
        b=dIkSlvNhbL9+4j+XcSeWRI+T83+mZc6CPPOglRW5LITA2rObSZNswhNjESLOlzcn5N
         deSv6fgAaYu8M+V35Vpc4hwCabyOLQG4pZ7FboKtT3xldJQpiKpwjI72Ye60KEzU9IYn
         HYSITN7ea6wfwaGX0ssvJLJo8tIfeTNOAAnZzjYJNtflx9vp1d47Igy3gqynBGENiabE
         mpV5BOFtdhodpiZIXiWKV8aFuEbaTQyPafCWs20qvrezH0kAbdzcML6CzG5lNa57sOZq
         762MEzqOo7kq9UD31SrjYUJUpdg6jjRNPPh81Px4hFe7YO51vdSKEtT5RZsVRM/VJTxh
         mRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729014680; x=1729619480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LzVsLhNxP8WDtuKH9p/BsiCdMHgFRqj/PD3WiEFxpvI=;
        b=Q/Z1yvJIGX49bwkhpnx2A3Z831pUdwGeZCU+/muvxxnECECHeDHcErvTMNN8slA3dq
         XP4PKXH238zahe2ijJ64nNoRYLsaX/0flXYgaWbKFnrAM/Uf6cVARCNybNPQzNqtXENr
         yiyqPJylj0Qnqzk2uP8xN/pikLc6PvyUgYiBOBzjy0t1heCTzYhxmVq0wDGBuYZJKIQW
         pbeqaVpXhx4RXaUrQDFGJvnlFYlfNjHWQNOgFCKcyzRjlaT/Q3yiX9/BsahCWqZXftkx
         rXmrYcNK/eYuQUYTpiWBYRwBWVpDpRLSDSvGhPFOunPymvm4Tw797rSmUdqH0g77za7z
         5iWg==
X-Forwarded-Encrypted: i=1; AJvYcCXunwHTX/3t/nj9iKQh6dp3MsXPkWvpTCMR3Vm0aHZVU7Vhgys1LGKJxLZQta54FdrYUj0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk3W+XujziafVYNotVDrG1bcpcXieffFb6Euqmk2S27CYBE8jH
	8LReBZ7LoFHyO+/DiwsziafCQZy/K17PG3vt/DTB4UhkU8oZLfWpkgfnstDceMmJrqkxkxDKfcu
	YOw==
X-Google-Smtp-Source: AGHT+IEfLUVkB/Zw/tV3P8pzNf5N7b8EpBCnlhsG/pzHxZYrAeEXSX/92lSxXYtVIs6Hmgm0nACho5IQsWI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:505:0:b0:e28:8f00:896a with SMTP id
 3f1490d57ef6-e2978594c30mr546276.8.1729014680360; Tue, 15 Oct 2024 10:51:20
 -0700 (PDT)
Date: Tue, 15 Oct 2024 10:51:19 -0700
In-Reply-To: <D4WJTFFVQ5XN.13Z7NABE3IRSM@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241004140810.34231-1-nikwip@amazon.de> <20241004140810.34231-3-nikwip@amazon.de>
 <875xq0gws8.fsf@redhat.com> <9ef935db-459a-4738-ab9a-4bd08828cb60@gmx.de>
 <87h69dg4og.fsf@redhat.com> <Zw6PlAv4H5rNZsBf@google.com> <D4WJTFFVQ5XN.13Z7NABE3IRSM@amazon.com>
Message-ID: <Zw6rlxWc7UCxJFpi@google.com>
Subject: Re: [PATCH 2/7] KVM: x86: Implement Hyper-V's vCPU suspended state
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Nikolas Wipper <nik.wipper@gmx.de>, 
	Nikolas Wipper <nikwip@amazon.de>, Alexander Graf <graf@amazon.de>, James Gowans <jgowans@amazon.com>, 
	nh-open-source@amazon.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 15, 2024, Nicolas Saenz Julienne wrote:
> Hi Sean,
> 
> On Tue Oct 15, 2024 at 3:58 PM UTC, Sean Christopherson wrote:
> > Before we spend too much time cleaning things up, I want to first settle on the
> > overall design, because it's not clear to me that punting HvTranslateVirtualAddress
> > to userspace is a net positive.  We agreed that VTLs should be modeled primarily
> > in userspace, but that doesn't automatically make punting everything to userspace
> > the best option, especially given the discussion at KVM Forum with respect to
> > mplementing VTLs, VMPLs, TD partitions, etc.
> 
> Since you mention it, Paolo said he was going to prep a doc with an
> overview of the design we discussed there. Was it published? Did I miss
> it?

Nope, we're all hitting F5 mercilessly :-)

