Return-Path: <kvm+bounces-58701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB09B9B8FE
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:45:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4750C177CCD
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7DE3168E3;
	Wed, 24 Sep 2025 18:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E2glylU5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D4226F2A7
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758739549; cv=none; b=A64m6fMuo3LLuiTcr2AhZMFts+Pum0fxPO+zdqEApuyLqREDCax+7bZpGJQp5gpgDmMjhKP1VL9AoQuzORQtj3zw7tTN+ESARsF6nGzdJhk3i4LoXJvFY79TALJ1d7cUcMoncDUc/XH4Dcm+M4eJY/qeD41weYEdPH/0EPfTkjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758739549; c=relaxed/simple;
	bh=PWfTeSLf+2HYY50wutr9RRP/UGHo7bT95qCiPNUqoQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I+6ErZDQ5jHwgGDE0La8xVZx2xkGT7a3gEhmUBVDiP5U93f04xeqIwiFhtCl26AsR5zOCKbzPUyEWSexZ8rhk0ESt2XDUFfI+cFLvq427VOCki0vRAMEs6v2Ry4rOFHLzPnrvet1hVB1BHMQuTe9CQtA75WeCZtahLjEhA61CcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E2glylU5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befd39so324559a91.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758739548; x=1759344348; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M4wHTv4bMpNgnwT1HXSaG6WREZuTe5ICP1WtX87RWX0=;
        b=E2glylU5kxXw541g3sIQBJR89kpqTBZhsaJRkvoyPo64NXzhtzVV6qhWBOTU1ityRr
         wa3mn0F1H4FaYVU4BoJZpq7LNiLTT/MZTYsEQxSHg5HieyTy81h0Jx3A+2oEeMviwcuF
         rMVFAoWGiYkAu9sD+ir78ZOKfatS+oec1xiQ73EvtxlvoNDf1Fcc6A+wOa/QvEHtc76A
         YHNC86ODhuFMhcxpG5tVNb43OylfNWuucktjazb5iFqWLdgR/jbRkMbb13shL/voShj6
         Z+pBHnSBdpQOf3c9X4fyu/RwS7iPCLDsY6PaIC5uFl9k34KmL4xYIDPbIXdpWfieGJ7W
         xgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758739548; x=1759344348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4wHTv4bMpNgnwT1HXSaG6WREZuTe5ICP1WtX87RWX0=;
        b=OR4LXYMzvy8KrNJbrfLFOB7qI5jO9Ikd5gb81qCv9erVQ1qNQgftsuQFoM8YJwRb5o
         1exPKEauCQpvl3WAk14z3KM8xjHVftYmVANpmub+lDwgtOCf3lmcvHhBWNccPWnHaBsI
         dOyRPUhGbGox3tpUiNzmwCTEqkenzw5FngY1wpNp5ioUk/ThXfP5YL/6bn4TR8C4YTpU
         ac5f6+Xe3/4WnciJnVoy47sQputrCj6kQ/xTUW/YLeSAWFya4QseYmjyNoJMmi/sH6nn
         N9v+q2OP6v9UaQ3Oba3GektddISkTJBQirmveAEdS5RPTE+nJKxZchExfKFAjsNwjrtY
         Ekcw==
X-Forwarded-Encrypted: i=1; AJvYcCUdHhUkHVEYGTQIDkJTKnxodBAE7B8gxbFbRnCHdZtyZxasSCf+WvgBDeGF9sCpqD3vyN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyilswXr8Bg5OJVPC9Ywy6OS4eNx//9BuvrfPzV2n1N9zKUQO/v
	88efJ7mpICqqn5zeoYfJzPWYIKjkD+iVgSqXEuq7J8sfJM5GEfMONi2jkpAtgGTsUgc0xfG8CVv
	xM0y88g==
X-Google-Smtp-Source: AGHT+IEG8aSi75YQDHzxUBomstRHeueH28Cl63WV/C9TgRI9jC5QkK5dWBwEgfEZeN4oKVMfxJYGm50KfCc=
X-Received: from pjbfr15.prod.google.com ([2002:a17:90a:e2cf:b0:330:6eb8:6ae4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d08:b0:32e:6858:b503
 with SMTP id 98e67ed59e1d1-3342a300aa4mr775845a91.29.1758739547684; Wed, 24
 Sep 2025 11:45:47 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:47 -0700
In-Reply-To: <20250918053226.802204-1-tony.lindgren@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250918053226.802204-1-tony.lindgren@linux.intel.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873598621.2143487.17306258654175548917.b4-ty@google.com>
Subject: Re: [PATCH v2 1/1] KVM: TDX: Fix uninitialized error code for __tdx_bringup()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 18 Sep 2025 08:32:25 +0300, Tony Lindgren wrote:
> Fix a Smatch static checker warning reported by Dan:
> 
> 	arch/x86/kvm/vmx/tdx.c:3464 __tdx_bringup()
> 	warn: missing error code 'r'
> 
> Initialize r to -EINVAL before tdx_get_sysinfo() to simplify the code and
> to prevent similar issues from sneaking in later on as suggested by Kai.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: TDX: Fix uninitialized error code for __tdx_bringup()
      https://github.com/kvm-x86/linux/commit/510c47f165f0

--
https://github.com/kvm-x86/linux/tree/next

