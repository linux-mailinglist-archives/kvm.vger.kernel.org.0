Return-Path: <kvm+bounces-45260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B17AA7B90
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 341154A8340
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8563A215193;
	Fri,  2 May 2025 21:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bsh0rRN2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E1214228
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222682; cv=none; b=E2DAurkAEmLgWH0Dcc4+cGsxcfjR+27sVVy9cj2hQH2kGysR8udwq/9pipOQJ2zhOG5OBolFp432dDkiAl1R0RaRGCr1D8jwyVfk3jHedodSLaPjZE0zIlIInIF5XE19W93vrt+iiqfxo2WL9E9NGQNCB2df3Mdxc/YMSdZj9Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222682; c=relaxed/simple;
	bh=JXSPMNU2F6PIX0FUsPuhRSrAfg0l7mo2VPCcc/ccc6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uDSow7+xW+lfFFMlrrkNkZprUjdAiywpaS4sxMlnE3E0WoSojnj8zvcQaMUpJKorp59Bq3J8yp2zvU2sEhNQyxBJo1kEII4iVLiAjQjHukrWcMA0LtrRIxTzSdt0zI5q9OlxGisCcm/mdRVT5AStt9DHItCJmlI6U91r7LcPY0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bsh0rRN2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3087a704c6bso2597202a91.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222680; x=1746827480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJvfYawPyN0V8zmHL1OuCkkneTy6JZ4iVJIh4vfswsI=;
        b=bsh0rRN2G6PgXZhWV+cbjlm7RduYRGD/JOG0+hFzP9z1oGcIWAjwVImttSYFNJohtj
         rhIw1HzHZWkZt3mzttKwzFUc3VLYUpiH6Zee2G5cbA7C+jzDe4UcjZSgdiN0uQJnJJij
         kixvLUq4IJvD0EVhPl6KcluFeHj9ncaE1vpQcExnu6J/0glYVrl45bzJCGJPq+RjYhLR
         7ufwd8fLTRcB3SuJQEnwmgqcey1grFZ/Ub2cRXr/C/ZlbkM1QUpncEUWb+A2XDMIMmy/
         pNcdetmYZNxmePVqeL2TwCxXCiwE9uWL/bL+ynTANQziSw5452QXJX2JB96r2+N7A0L1
         +eIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222680; x=1746827480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJvfYawPyN0V8zmHL1OuCkkneTy6JZ4iVJIh4vfswsI=;
        b=I8SSXC2lLFcBJOaOlyM5NlsWs2RZyOD7H2+4lHi8aTtAjWVgW15f/jR7Fbz0Gz2gEw
         VQLbMhzGp1OnyMZ8dT0ynl+SkVQ3Kzbe3HCiIl32du6qYmKut9c7QGoRUPCuPrIqBOJ9
         gE1XWwY0heLitmLGgsfshitmY9BpHMJQL+M6r4WdZSlmPxDAQQQQvu4kRGR/0f0tUSU/
         edkO4ZlWebaWBGLe9h8+/HcJnIwzLlpxFL+mgRmGaZWVpXTbnXVll5E5+6TsWbaWxw6A
         wOSy4Bvz45+1ru4kXr/1ASxf2EVVnFWIJMM56E0eSxhTe5GYcJ4mNe6UYBMBd0WTCz91
         crrw==
X-Forwarded-Encrypted: i=1; AJvYcCXhsxianIIdMSmJuhPO+jgPMKgxG5Vuj7TBFE4ZMkCygvNxHaoVSmoDJfNpSl1485oyulw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh8dxTqAQeQPkis1fS/sP+AHL8uZ1KId4ET2oy+ZIvZygV4DVZ
	TmReS3rQZmDBhjvwszQDNHwY+Mc1UCR0GU2VWGGmYBIqhq/mR8h8M32bvA/z+iyR20lxWiZGYHh
	XZQ==
X-Google-Smtp-Source: AGHT+IFfvB5BYcCkUy0HSKU1ftZqpv237388LVDliX9NyOGYbIIAII1ebAC4Dj75mncu2D7rWaPQcZunEDw=
X-Received: from pjbpd12.prod.google.com ([2002:a17:90b:1dcc:b0:308:87dc:aa52])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57e5:b0:2ee:f076:20f1
 with SMTP id 98e67ed59e1d1-30a4e395cf1mr8976249a91.0.1746222680316; Fri, 02
 May 2025 14:51:20 -0700 (PDT)
Date: Fri,  2 May 2025 14:50:53 -0700
In-Reply-To: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622231823.882065.2543559051221676218.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Unify cross-vCPU IBPB
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 20 Mar 2025 01:37:59 +0000, Yosry Ahmed wrote:
> Both SVM and VMX have similar implementation for executing an IBPB
> between running different vCPUs on the same CPU to create separate
> prediction domains for different vCPUs.
> 
> For VMX, when the currently loaded VMCS is changed in
> vmx_vcpu_load_vmcs(), an IBPB is executed if there is no 'buddy', which
> is the case on vCPU load. The intention is to execute an IBPB when
> switching vCPUs, but not when switching the VMCS within the same vCPU.
> Executing an IBPB on nested transitions within the same vCPU is handled
> separately and conditionally in nested_vmx_vmexit().
> 
> [...]

Applied to kvm-x86 misc, with the online=>possible change split out to its own
patch.  Thanks!

[1/2] KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs
      https://github.com/kvm-x86/linux/commit/1bee4838eb3a
[2/2] KVM: x86: Unify cross-vCPU IBPB
      https://github.com/kvm-x86/linux/commit/54a1a24fea19

--
https://github.com/kvm-x86/linux/tree/next

