Return-Path: <kvm+bounces-68231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB523D27979
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 980603091BDC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D663D6486;
	Thu, 15 Jan 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VbBr5nRG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A34B3BBA1A
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500489; cv=none; b=s/T2pzEub0/y+SJLQWZ96G+tWVOAk6ym/Qmk3nvzT3w/9mfc9XH12qGgp8MMqTYGk6kJHxLg0zrP9Do3FAgkxI8RyzqJrVjdFWdHS8s2hGXDlKaHT8Wj9pG0Qc95Ze81Ro9muqx70dek3E0Xar9+ysivZRJBwUf2t1yJLj4iUmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500489; c=relaxed/simple;
	bh=xPXXhuXPv93J5fzi7tnX/BE1hwnLL7qJNzUhWD8DyHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K3ONnCWgSCW5D/UQFovnbtvz+dlDelv/60ScMPXDYqR7vQgnpCNXlRxOEZZJ3d7O8W2sZ1auWBh7SPuX9dkv0AhAr58EzI3LGlXx9ZS2gk+KoyZLv/tP0treTF/ovhBNZ5uD8vV7Y19SE7rmPTNHGmxFbxemCRHDq6wTw6A4Fs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VbBr5nRG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c48a76e75so1116588a91.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500488; x=1769105288; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LDSK5PKNZwNBgOT0e2dtKPu3VeGMjCRmozdo6hjLVzQ=;
        b=VbBr5nRGCGcYRY6BoXPC/YGo+LNsBWRpy2aYzEQHUqwfO20jYFAbUklHvuTpfUmWdz
         em6cGnwL+12OGtEnDXDDWtebktBpqTP3H/q8szIC4atdnK0DQB69Hm6i0kE9yFxxuiZw
         jQ/UpQJQYVZi2z0ZjhabeXzwMfws9gP41qG57SkFrXV+BbUChdvx2g4nn5rBa/JJwv0D
         mkAE4vH79mxW0hlRSM4IVI5Jqkr1VPO4RYXgXpLMCSHJwzoMrsj1bEck8GUZqrniwedZ
         izQ4Wk4UMMJ8bl9R129EJZ1Qai5NUhVo0vAkgnCuk+RhABowGwDWOOQXH/BkR7pKv6YM
         Jkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500488; x=1769105288;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LDSK5PKNZwNBgOT0e2dtKPu3VeGMjCRmozdo6hjLVzQ=;
        b=vPqdxaYa7kQjoTGTaU/xhWHc7msjQcWqxbxDL/IZz0vKUZLx5Dqom64iLm6J1pz/7T
         uiztqr9DHYSNQsMIxQmHRDKUR49CWm5qBORoswgCBz+RV0IH4QsbTX/Mi4awtCDAFKm6
         Ht4GvhQX9pTZO2MLAH3YIhBliuYqIvSdgcYhwP8sOCLEvQRSyY98DyCz3hzlZVOULcoj
         z/CUD7pyd+9wKxLZCFY2Zu6nm9pJw8FPwPfMY13oHigN5MWuHd2JJKUdPSzZmT2uFx7p
         KoGS+OOFyg9Rx9mZzZ5adcijsX4uavKEnyxYcwI/GzIoj1fgSgRXdkiBiVAClQyzrdJj
         CGJA==
X-Forwarded-Encrypted: i=1; AJvYcCUa2gCcV9NIK69j02RN/Ld7++vWf15EgUqndhiKFSjRlgHLGbIfhTrirHlcYdDM1wia8RM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2uOXKMCnvvBTlQp8g93jA1D7kAdGCVbdfAfddB6lqHKWz8sCZ
	3XO9rF2Zb+e2pS2ejioF5KQrNwjEWz1SqQNsshcK1vx4XQ6552+CzpwAmm+xw+tyRTDGQxYrcRb
	7zDoi7Q==
X-Received: from pjvb3.prod.google.com ([2002:a17:90a:d883:b0:34a:b3a0:78b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40d:b0:34c:60dd:1bdd
 with SMTP id 98e67ed59e1d1-35272fa575dmr191239a91.22.1768500487881; Thu, 15
 Jan 2026 10:08:07 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:42 -0800
In-Reply-To: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0ac6908b608cf80eab7437004334fedd0f5f5317.1768304590.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849670779.699755.8210773201872100237.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Don't register posted interrupt wakeup handler
 if alloc_kvm_area() fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 13 Jan 2026 19:56:50 +0800, Hou Wenlong wrote:
> Unregistering the posted interrupt wakeup handler only happens during
> hardware unsetup. Therefore, if alloc_kvm_area() fails and continue to
> register the posted interrupt wakeup handler, this will leave the global
> posted interrupt wakeup handler pointer in an incorrect state. Although
> it should not be an issue, it's still better to change it.
> 
> 
> [...]

Applied to kvm-x86 vmx, with the goto approach.  Thanks!

[1/1] KVM: VMX: Don't register posted interrupt wakeup handler if alloc_kvm_area() fails
      https://github.com/kvm-x86/linux/commit/6c8512a5b7f4

--
https://github.com/kvm-x86/linux/tree/next

