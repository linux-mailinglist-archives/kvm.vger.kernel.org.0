Return-Path: <kvm+bounces-62522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8277CC47AD3
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:51:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AE4A94EF8CB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840C631D38F;
	Mon, 10 Nov 2025 15:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nEjLSv7p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A8725A340
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789141; cv=none; b=LGb25UJN0t7kIqCqSN9zrnqyXW/VXSclcSxk1SN9qa7x7Oimzs7CpZWjZrjmkNhaQW0k+AnWTcXr+Msdfmnx91JpDJjYmngjBQpVpuKqjr+2tl8s9/t/VpEfNWBksmnarAOLAliiuvVbY1rV86KZTpYXqCpf7GDRXSXSpXZbigM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789141; c=relaxed/simple;
	bh=cDyMaHDdkuq+asAIgegu+SPgoFRi3jHo3jco+i8TKbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nJVb9bh9iOHqU05Rg+wqDsVX04CN7zmKFuP1jvvXhKCRq89fdbhsSTK1QhLPyK8TW5u2dZqHQXoQccWv03hNvf4saVwLzGqnVyF/kW1xpfyxDegSAdWZquVIlB3/x7uApi/CCqryQoO/PHmXjBb3RXamcDEmXmLF06Grkaf8rZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nEjLSv7p; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c261fb38so7295611a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789140; x=1763393940; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=laNhRLQX0XMVmOMwAG0d7wv5H+B5etUz5b1epi6/2Eg=;
        b=nEjLSv7pjCr1TH1JMOTuH91+ZyYG8++i0Nh4ru9CKxJcKTFidSFZdgcOW0/KVFKjiR
         rCnnVELe76tb0n3pa8+gJcu5wsZf3dem7Ox+OwiLpwx+Km+HhwD+tSzRqgXLXNg4Ro1r
         VGjgIAf0MEXd3nr8rxF24cryaNNUJw2jIevAK45zR/QVa65dRXZYDeD1JVrR+daqVM9A
         4PYObrD2O1SsejqO4q/DWUQ/mznQBz+b1YHM5ewbA3pSAytl7OL+j+51mSCgZ1fclPbS
         9AK1b1PzZ/ie9AhpKfV6MAQ8JEjA055bM7lsp+LRkV7f6gdKmuH3KwqG1JYOcSOdLgJX
         mfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789140; x=1763393940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=laNhRLQX0XMVmOMwAG0d7wv5H+B5etUz5b1epi6/2Eg=;
        b=j9L6gq/VMFcFt+3EzPThqWZBibDmXi5uNYNUTH6NrNaCoIUTTsw28JG5KRpzxlnGMK
         EIt/Bc4FUH5YTGm1Tlxw9sTro8yLqctRgrw0swICkc/KKfg5quM+mXx0uY91yu2aqxkA
         1rY1wrwKyuTRXgfJLUQxe4c21LXbEaC3N1KTzj+WV7o+cqiNfEUkZLdg6gDjkQUHZRiW
         xPZB1ReO5d+hpLaDiC3ydNCsDK1qHYJVHKWMKe3j5GV9nZXhVUorxPVgOMeSJC2amiRe
         PNQpPN1UhdjeD1MoJXm5P7lTJUijChS/M/8ARRemxCn0WPG2QpdAEbIe2z63Bnbv6LSN
         oAsw==
X-Gm-Message-State: AOJu0YzeWU32jUiLRPKSeJygOYO4bvoY9kGo/irDP+b/jEtSbfcQELrH
	dKfbWpK1qC69iCVp9FEKrgLIOt6jJ5ZcPm9rmMJJsT/IGGV/RGb5B/jtpqMcx9sSWdGA2vJIaMh
	iPfrA0g==
X-Google-Smtp-Source: AGHT+IHZTL6lBepPCG1wa5BSSf8eoaJ1ttmPlXua2WSmSSk5CeBLMKSmijCYjH2CcNBTA0SMfZe8CXJqtak=
X-Received: from pjtv19.prod.google.com ([2002:a17:90a:c913:b0:33e:3612:2208])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388e:b0:343:6c71:6d31
 with SMTP id 98e67ed59e1d1-3436cb29ad3mr11615416a91.11.1762789139688; Mon, 10
 Nov 2025 07:38:59 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:21 -0800
In-Reply-To: <20251030191528.3380553-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030191528.3380553-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176278796784.917175.10578129282144167896.b4-ty@google.com>
Subject: Re: [PATCH v5 0/4] KVM: x86: User-return MSR fix+cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 30 Oct 2025 12:15:24 -0700, Sean Christopherson wrote:
> Fix a bug in TDX where KVM will incorrectly update the current user-return
> MSR values when the TDX-Module doesn't actually clobber the relevant MSRs,
> and then cleanup and harden the user-return MSR code, e.g. against forced
> reboots.
> 
> v5:
>  - Set TDX MSRs to their expected post-run value during
>    tdx_prepare_switch_to_guest() instead of trying to predict what value
>    is in hardware after the SEAMCALL. [Yan]
>  - Free user_return_msrs at kvm_x86_vendor_exit(), not kvm_x86_exit(). [Chao]
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: TDX: Explicitly set user-return MSRs that *may* be clobbered by the TDX-Module
      https://github.com/kvm-x86/linux/commit/c0711f8c610e
[2/4] KVM: x86: WARN if user-return MSR notifier is registered on exit
      https://github.com/kvm-x86/linux/commit/b371174d2fa6
[3/4] KVM: x86: Leave user-return notifier registered on reboot/shutdown
      https://github.com/kvm-x86/linux/commit/2baa33a8ddd6
[4/4] KVM: x86: Don't disable IRQs when unregistering user-return notifier
      https://github.com/kvm-x86/linux/commit/995d504100cf

--
https://github.com/kvm-x86/linux/tree/next

