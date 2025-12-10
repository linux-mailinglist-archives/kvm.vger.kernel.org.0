Return-Path: <kvm+bounces-65634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36BEDCB17AE
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:26:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 86DD2302049C
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 00:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0053519E97F;
	Wed, 10 Dec 2025 00:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="17Lsq0qK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29FF322A
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765326371; cv=none; b=bY4DapofCVG6+7Z17vVmRbcINOI9WBdNOsQnkhe4yjlVFfozJdU7n+TfEPXWBbi66Ykqt6WRSoH7k+gBVACspmLizCjM9yZpFdK7R/dtV4xyGrfsy/5O5iNSysB/QtiSRchP7R6C3VaEEwE+gQFYORRaa/nM/qgFZPigxZyAvRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765326371; c=relaxed/simple;
	bh=Az9r28FZPDYGfsLg12y1z4wzJDBZZXqDR+vqRTGMcMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dlJq3jjWQdlPa5r/cqWFa4YNPZ0yNlxfWO066GK5u3UTuW8N62WYAyUrrS2WjPAtyYhcLNs0z0KVSaylohIQ0/yVtbiU8iUE9BXAfxIa46BIunaVHinTiJdEvCMmptaayMgN1uhsOnP2CaMJJK12yqLmSSO9jRDjQalJHNVFgTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=17Lsq0qK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso11059580b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 16:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765326369; x=1765931169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z1rDThiUpVF42bHU2XqPkFJob9xm9Fm0SqdIKrDe+qI=;
        b=17Lsq0qKO3KnZTz6ipMwBsJPtVowilsoEh8evbACN8uogOjfKywxhJfDn1cOZ89Lsl
         pi0pvQzyBjre987MRM04oah/C014YofXCf+g+BgSGy/rKheNBvFjOD4Drg8F3twzw7Ko
         jGPpFhmWfIkbSqucMk3yLHeu/508EtC+ueY4in3/QY3nlzwUWku1Sxg0TBAl0Q0Usw0X
         +zWo2ztp82G21w9JmAj2uMLuMtYBPJ7BQpWaW6SWpylFuA22Le1NNN98u8Y8E3v+Ssuc
         bisgLiO7w+7+c88H3QRjD/c9V+xHZ4Ez//u3H3odlsfsHNWlfXuIKe/mrwzAlXrpZcWR
         Ohmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765326369; x=1765931169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z1rDThiUpVF42bHU2XqPkFJob9xm9Fm0SqdIKrDe+qI=;
        b=PuHxlBAxf+jIJT2oZfYGOTXkMEKUzP+L3WrARFH66GKbqzmqB2Hc6igdtc89QtJlFE
         Icp+VL6SvNTCUjWsg8+HBbKrvbLJI/nahe4sBk/Cjjeq/0xiMMCerqsjz5JsmsEZh7rF
         OEdYHFvbP7XjpTB5/7N+LxOApP2S//pdQ7XsSqaQqQvGmHboF5jXZVsi0JAkHJruUUxt
         mJXCoPZIxX6Z8lmOrTdTfKXmzNusZia3Y0SGlzCH9K9TkexPuCvzRvTfg6cnO0KGtzr2
         v1nc+pUkrYi0IVrt+Ol66zexAbMnhWv2w1CXaOsNdb1wr/UtkuPvP2TmhTDEIgVasRU0
         xMsg==
X-Gm-Message-State: AOJu0YyxlPA8RtZ1NpkUlYGcQa49EJ+M7arzA50q/aLSKpH/RyA9mnhU
	KIjVIqKCD7pFMEjwXdunb+XiAWld/3z/g5c3rSyU7EQuBeAspcGwXXANJCl0YP0dlj35kEC07JW
	DuK4BlQ==
X-Google-Smtp-Source: AGHT+IHhIkNedu3nKd6+GEOCCYCLfqpCcfOvviS9z0KFi1ArlNh7wf8aiK4ljby5MpY5LKfKgeovdIiYMnc=
X-Received: from pfbcn11.prod.google.com ([2002:a05:6a00:340b:b0:7ae:973b:9f29])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d0d:b0:7e8:4398:b36f
 with SMTP id d2e1a72fcca58-7f22fde1f5amr475396b3a.66.1765326368914; Tue, 09
 Dec 2025 16:26:08 -0800 (PST)
Date: Tue,  9 Dec 2025 16:25:54 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <176532631966.885296.9645749172580580884.b4-ty@google.com>
Subject: Re: [PATCH v3 00/10] KVM: VMX: Fix APICv activation bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Dec 2025 15:19:03 -0800, Sean Christopherson wrote:
> Fix two bugs related to updating APICv state, add a regression test, and
> then rip out the "defer updates until nested VM-Exit" that contributed to
> bug #2, and eliminated a number ideas for fixing bug #1 (ignoring that my
> ideas weren't all that great).
> 
> The only thing that gives me pause is the TLB flushing logic in
> vmx_set_virtual_apic_mode(), mainly because I don't love open coding things
> like that.  But for me, it's a much lesser evil than the mounting pile of
> booleans related to tracking deferred updates, and the mental gymnastics
> needed to understanding the interactions and ordering.
> 
> [...]

Applied 1 and 2 to kvm-x86 fixes.

[01/10] KVM: VMX: Update SVI during runtime APICv activation
        https://github.com/kvm-x86/linux/commit/b2849bec936b
[02/10] KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit
        https://github.com/kvm-x86/linux/commit/297631388309

--
https://github.com/kvm-x86/linux/tree/next

