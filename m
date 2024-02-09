Return-Path: <kvm+bounces-8381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9814684EE5A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F226E281BA2
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 00:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA2545240;
	Fri,  9 Feb 2024 00:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fn5CfAtj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AE34C90
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 00:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438196; cv=none; b=TjeFSK+iqvIh30TOkVUDNWbEC2VxNKCGsoKZ/NR5DeeKNw2u9gwI0C4S+ENHLSCJGz3idbZHQiQi7E3jbkUKiiHIEvCbxjKdW5H3nWO9sYPLMg1/MCeWwkkmZNAhBlg3gcYPOSeJ3n+ncATtoBywRMspPp8hDaDyBml1w1gNJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438196; c=relaxed/simple;
	bh=xkTklGp53zx1m1tp8jWxzC4/9oXnUMIBr3b3Rh+WAIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p4lgJiZZReCZsj3a7R5dB0gK4K9WUW3+yudlkbUw2dBzlMhx7gXpG6gujiie8K2B6Pu/b+ztoaJaPANAA+gU+O9xIR0IM8k5loWGWEzf4LnuIniskFQb3QVMCcSdCcDJg0vHkxFzWgC5kHAqlt/vKOWLJxHVD2n1jRinTpUO+SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fn5CfAtj; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so637749276.1
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 16:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707438194; x=1708042994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hwOkpyP6W/7ynV7I7J8PdfC/B3dL8reU+AU+Vto6N68=;
        b=Fn5CfAtjF7ih9MkZFnHdtDeEhNIpCArISfXIdugFaODVjZmom/M5bEq4wZrw8t8sG+
         jyfRpqiPcn0AsZTC3it9kIPRKf5MnUHuRr1BtvTUNCxqCscJCPPfkDxjjunNJKDAvuM2
         0evyCex2YPMTH5cbvzvkUulB2F7cHTfF58S0tXqdrhEyJue8SBpMBkK5fmxE3hNMF+Y3
         U5xlav3Whfo+jZz2DJQViNH/HrFDledZFPFrijpE4BSgLdCqWzGiX0CLshhYeR2fCGoi
         mZzjPa74caHnavI+gENpwgzbKDuXNJEdG93+K8QHBt4IjYJodiKc/k7EpKjS+QKxUhcI
         62+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707438194; x=1708042994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hwOkpyP6W/7ynV7I7J8PdfC/B3dL8reU+AU+Vto6N68=;
        b=pxmsJdmbRGePV6U536GvWF9dWZar+VoaPJBHgpQdHz0McZ4w2gUxQqntoORNVXCSss
         FyreBZOMLZnzVGAaK7kyk5cwY1mj05+JvT5s0fORFwcQL4tmJChwkYakoSmlwRdoYg1u
         0Xqya0VfXYzdvkQw9HjkXx1Nn+17Gm5N3nfULNHsC5HJPwDZqp+MNJ1UBAGqdwHoVmbI
         1ifpWjI47/ZmG7CNTa847o08ChP05Vat8iJioQsKrtgXfFjWDjGclK+GzRQiJu2Q5rXC
         1EYn2Z7n7WXwyzVFzCQxQX+DW9JTMjB7PTNm4Ot9ket2v7LnDw8Ou3hJAZbyLq+sQXUJ
         5DBQ==
X-Gm-Message-State: AOJu0YwPw4l1Bb6ThbVhqbbHdo3Ae2M9kv3snLiwclHq4qiUB88/3E4T
	EQCHhYOMLZlzVSmtmX0a6VLfVjupsBVF9A0H8cYavakbphud7uRhjjqeAkpt14HQmY2A7fxAS5o
	GxQ==
X-Google-Smtp-Source: AGHT+IH2jEv0xvmNwNKY7NSzPtcu2AopznEru+5a1fCkn8YpTE1L36JuE4FUv9KVY/rj+IjcaH33R/9E1Dw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18c5:b0:dc6:de8c:f4fb with SMTP id
 ck5-20020a05690218c500b00dc6de8cf4fbmr277074ybb.9.1707438194347; Thu, 08 Feb
 2024 16:23:14 -0800 (PST)
Date: Thu,  8 Feb 2024 16:22:47 -0800
In-Reply-To: <20231229022652.300095-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231229022652.300095-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <170743816317.201922.997319442265850341.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Report up-to-date exit qualification to userspace
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 29 Dec 2023 10:26:52 +0800, Chao Gao wrote:
> Use vmx_get_exit_qual() to read the exit qualification.
> 
> vcpu->arch.exit_qualification is cached for EPT violation only and even
> for EPT violation, it is stale at this point because the up-to-date
> value is cached later in handle_ept_violation().
> 
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Report up-to-date exit qualification to userspace
      https://github.com/kvm-x86/linux/commit/d7f0a00e438d

--
https://github.com/kvm-x86/linux/tree/next

