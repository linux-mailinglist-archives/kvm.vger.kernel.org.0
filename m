Return-Path: <kvm+bounces-38228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86130A36A86
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8766F1893D3B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1942201010;
	Sat, 15 Feb 2025 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eJAEfnto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AAA13AD1C
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581019; cv=none; b=pEcViUvJ8/8DZhNT9ZUYa3guECUWQyeKMAG1RqH+Nj1TYZNDEZ/Cg3z79SBzmCFrRoVMkuPTZ2iq7ZZJK3mk0vlBKUBtuF8lvixldeE0xVAdVdQWFG5PSfc0x+MMAmloZeGAeQik4BAYjg1jIBzG8pioVvaC4JvzbNhJwFkuUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581019; c=relaxed/simple;
	bh=+KR+FPyiWdY6nzi5E/xfi5ZIbXs6yttfbKTh2BzTWUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HuwVzv6ZzhHu0UDGEeV0+ostPdMmyEbYDCyaHhIL4K0MIpufWUOVQRJ4oPp67CN9pDqfYVbhq6FWaEmaK/0fiq1NNXZv+k4khntT5igg+8GRBdA0yMZkKCFS9QGzEENPyRo1C/EPJ25XSM04R6B4OBWAZYNBRHSlI5gfmyf5PrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eJAEfnto; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05afdso5222127a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581017; x=1740185817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYdp5KEOM09jg9p9N6DLn1QBn6Otq5JJd2KkgOh4RdE=;
        b=eJAEfntoM5S7pFhA8vMKB2H7G2qIcnGiPNWXo9/+Sln0so7OC9g0UG1j9RNCrBO6AM
         gjL+F2RmurdArV+u5GUUEQsdGDfxrIyUdSTVYOCkZYNlXiKAtblppNCBt3ByvgGqeDnC
         3AufWoNpIDXXYNDRjnbnSlTohQLfcIv6qVLbt+j+gIttQjZzauV7NU0EoaMMblkWG91r
         RECLEeRmh3JmHDbLE9IzCnrs+13du4SEnhkoa7G0HuuATq7uWC7fqgx2sFE9LsPhB0HE
         TtHj0jgiuO35KV3B5ftz/oD852t3st3tbaF3gNGrR0qs01tjrm9McOuC+39df5H7AQQ9
         DiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581017; x=1740185817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYdp5KEOM09jg9p9N6DLn1QBn6Otq5JJd2KkgOh4RdE=;
        b=qCDUqvjwG8DP4fhc0IUvayY9Z3SKBMedJ8YJWaFBCJTUc9aQ5sNjw7AO3mhJJhB2bT
         lWu7MMfg1fyf7kf+tWNzDbIKECBRTwXmHXInwTd3+Ow6DBxydDy8NmxFckQM4gq1IHAP
         3/3Tmt1YIBd7Tzuffxqt5l4T8hSz98/rThQwigzcuj81TrzL0bQKuqnHhsEdq0GrGapG
         z/un683rU+GLjVsoUoOBpmOcnHFWDgPAQOksvGeaXKDmCUKnFvhCMCeBfHqgUCgwh7gO
         YAMq/kkaOGpuwH4yNr3484xmVKGgFsvMTgURJ5PTpfanAtBtL5XoAHeSsV8Fd8vJxIYM
         XZFA==
X-Gm-Message-State: AOJu0YwWDNOR/coTyKDhn0dPcdAKSSjN8CCp8LE3qzf1qXYizfDtZ5f8
	MVEBAxkZWrdMbHH7hdaaIwuHtMh8merrCQ95CPGrcUNbHLGbxFQMaXIRjrzOjEH8RCMsAIm+tph
	rpw==
X-Google-Smtp-Source: AGHT+IFyXn/jnfPe9MBamhPWud5uhVvBM7H05Zvnq/KLsngCiWW3jisWRrlgNP9Gm+ydmlhJ/vnEjK2DQMw=
X-Received: from pjboh15.prod.google.com ([2002:a17:90b:3a4f:b0:2fc:3022:36b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d8d:b0:2f7:4cce:ae37
 with SMTP id 98e67ed59e1d1-2fc40f22cd2mr2192939a91.18.1739581017169; Fri, 14
 Feb 2025 16:56:57 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:41 -0800
In-Reply-To: <de0437379dfab11e431a23c8ce41a29234c06cbf.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201011400.669483-1-seanjc@google.com> <de0437379dfab11e431a23c8ce41a29234c06cbf.camel@infradead.org>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958006311.1187438.11536700176929455.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/xen: Only write Xen hypercall page for guest
 writes to MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, 
	David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com, 
	Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 06 Feb 2025 19:14:19 +0000, David Woodhouse wrote:
> The Xen hypercall page MSR is write-only. When the guest writes an address
> to the MSR, the hypervisor populates the referenced page with hypercall
> functions.
> 
> There is no reason for the host ever to write to the MSR, and it isn't
> even readable.
> 
> [...]

Applied to kvm-x86 xen, thanks!  I'll post v2 of my series on top.

[1/1] KVM: x86/xen: Only write Xen hypercall page for guest writes to MSR
      https://github.com/kvm-x86/linux/commit/3617c0ee7dec

--
https://github.com/kvm-x86/linux/tree/next

