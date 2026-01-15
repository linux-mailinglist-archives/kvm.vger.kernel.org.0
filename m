Return-Path: <kvm+bounces-68224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E025D27944
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F5A8310649D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11983D3327;
	Thu, 15 Jan 2026 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b7qloKh6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F563D524B
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500390; cv=none; b=pUjE5dDXCjFw6gpt/X63XrXiAzymLgJFq/TR2zJjPIMyCiuzVc2J9pb9+QZCtk2hZ/qU7OySEJzQvueP288Y/8WNDAaOJNGYSTClHkFqelgeyuja+2o5MvfNJZaaRS9IdtWfPDz5wAzrxYhKKv+21dLdJ/LP0KEN3ow/yLqUMnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500390; c=relaxed/simple;
	bh=bKtZqbraOx9dOngd5gOc23pxRjp5UbEEE52HxF7tfJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VBR5llMq/6KOfvjrrEvBtcQCoMG9FqItFx64Rm20l6w2ygizOr6vh9AFk0duSzE0Y6G35ExWUho9kqL5NhLSSaOSZaa+CwVBM3iovV+90s+8Z21WDTLKw7cofv2JgClaIxHTLlhh5NQR+753rMgoqTAndxoNkfb0co4GrtOVqn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b7qloKh6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c55434c3b09so746952a12.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500389; x=1769105189; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Rw/FsQk5S1IECPUe/MKwS3msaeY/HykWtIUhFiY/8I=;
        b=b7qloKh6BS5TP8jDrdVqJMihBkHFf//zeCaNvlmp8n0B7VtTgwBLUYDp6D5H+cQHIw
         DAB2uTkzHNVBQHFjVZVvQZn/mHs90COA3bGl+ODUtKR504ifWSstDssp8rhj80HNLXk1
         6WtCVLHwvb1SLRb4/PpsRiKy0ZKb/FF96kc5qSEIPlLeGP+Vhs2zK6Wh6giCPKxEe0aX
         sBMeL8y1BeLrmxgcJ3uSuE69z2LdeZivikynPFcHfSFt6uMD+GGrJgRuNUYOpYxGgTp8
         hAVpZe1kpnF3Hy9trZGqWPZoc/VOXJSzNu2Zo4uZ1HxNX9l8jVlT8DJfwczIR48qUrHo
         lwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500389; x=1769105189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Rw/FsQk5S1IECPUe/MKwS3msaeY/HykWtIUhFiY/8I=;
        b=VpUMNW8tIzMTt7FooWEeMXsWLMhUxP7oTAYqg4tiBMPmJxHFuWG6OAFY4LPQB624pE
         DggVEcD2ogeFB4TwJPKFHEEMCNL2fArqfyGipV6qUVscevfc6ew3iQ9I8mew+oex0mzF
         OLQUhCbS9u9SBklYb4s2diMGEaQExZ8f7JTCKq0EwGCOVMCDGyinyMD6Yw8mZ1Jyhh2U
         YfUs/o9lP7FntGr4+EYFrXDZPfXmklpZIBEYE3jGRnJww3jWAdJ1YA+NfRrSyaY+hbki
         +XiAvXRWF+PlZmwF3utlTQz2hjVJVjWm9dso78RCO31A4apFqMDwwthpd9//j/G4uj3A
         uvJw==
X-Gm-Message-State: AOJu0Yz9tDJXlVIMFeqnoyEjqgzUf6DJpUYTqZ95Sa3ysRwIMH6zc5c0
	tbHf7+jPIRL6MAC6kgQxslyknhXSYE/WjaKQJDrfQGqA2SsBtIVuQoEW0Ln10EboXvrl5h5CP2c
	TlYTU4g==
X-Received: from pja5.prod.google.com ([2002:a17:90b:5485:b0:34c:4074:d7ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c105:b0:343:edb0:1012
 with SMTP id 98e67ed59e1d1-35272f6cf04mr202952a91.21.1768500388957; Thu, 15
 Jan 2026 10:06:28 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:28 -0800
In-Reply-To: <20260109030657.994759-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109030657.994759-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849900220.720093.4821232985877290250.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alessandro Ratti <alessandro@0x65c.net>, 
	syzbot+1522459a74d26b0ac33a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="utf-8"

On Thu, 08 Jan 2026 19:06:57 -0800, Sean Christopherson wrote:
> Ignore -EBUSY when checking nested events after exiting a blocking state
> while L2 is active, as exiting to userspace will generate a spurious
> userspace exit, usually with KVM_EXIT_UNKNOWN, and likely lead to the VM's
> demise.  Continuing with the wakeup isn't perfect either, as *something*
> has gone sideways if a vCPU is awakened in L2 with an injected event (or
> worse, a nested run pending), but continuing on gives the VM a decent
> chance of surviving without any major side effects.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()
      https://github.com/kvm-x86/linux/commit/ead63640d4e7

--
https://github.com/kvm-x86/linux/tree/next

