Return-Path: <kvm+bounces-51798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E5BAFD534
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 19:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E9953BA897
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 052DE2E6139;
	Tue,  8 Jul 2025 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cPiwJpbK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3EF9E8
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995253; cv=none; b=HjUQVdINAEKmpqi6+W6/rPTzS+8NSSn9cr/FGeaQIrGA+FGuQpiUbzBxa4FJO9cWf92CZefpSuXbbCERTStz6DmMnxV/hkd1OnuYf/Xj6dvZSO6h7ULdHavM4E1P9y87E7wpg5W1WdIe/TGflbGVIXsJde17CtSVv4q0lHznOyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995253; c=relaxed/simple;
	bh=PEpaMZrOpkG7Va1rGVgWSOOpdgGtAFW+p+MGS1bNMSE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fISnXl5oeD6m2qAlmVhsXg6vX2JRBOVCiA4IWgcN6JY6cXQ3Noef1LFBfXA9OBaSOiyezWPNVcOqcpMJUAKr15Y6Yfr4YlTun/QejFXpyOrOanZIKC0vW7EdUhFNndq2MjToOMwoxIAclnIY4WWvMV8Mdol5OrS93BFHpEIcBRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cPiwJpbK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748efefedb5so3234167b3a.2
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 10:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751995251; x=1752600051; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8w7LXf1XiNlfVCCy6ixD6LeK4hoxQFONQofhTBvQZhs=;
        b=cPiwJpbKDdbKX4FSZrZYAQ4FZp0giFbGLuF2x1+E0KwR6tGxPOB+KjLayTRMKKTPtz
         +9PPorH1NvPAYZRBdgr8adOP7JHq3TPqo5kI7I/U6+wB4OS3v6YGg0wm4TPc1F3TGWgr
         4TLuSVII8HP0oMSaAu2P93DBUdX99kktEOb7cngt+k+SvaZrVicEz8sbCtbvQbINXSDo
         znpaYU8bH2z0v6HSwh4Brsq84q5IXPO9PPm/H03IZHK4kasHxMvKNWdSvDQnTT5pSqE7
         M/aKLh1+pH0896zct7QRb25wNg3sU9qFLld9LQz+bHAZt6CnfWbWo8+l1u98mtE8C5Um
         O6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751995251; x=1752600051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8w7LXf1XiNlfVCCy6ixD6LeK4hoxQFONQofhTBvQZhs=;
        b=E01Ncz0jcUHdx7WWca4FFbSMnenPcEzIxcrvHkSO2m6xUwvGUxdHcZFJSXcs+4qPY7
         LAl+Oz/11oQfIHPrg/KUPcuNVAwOxLKX6Rth6wimnOQOJO/M/+3bSHvFwZVBN16iKqOD
         MRD5r7b1pyMelspx+E8hZbZ8kJiVenDWMY/WQc+poTKqHLD9hURwttNbFIWpZxF4K9UI
         GXRjDYHDFvduy36LWvMCp2W0hOpkuMT7k164AAipPKqhWVp8U7pX5rhy3OLX71iAkaC8
         ZSFsQGCjGW8k3G6FJP7vvnKdFLapWYN0Q14JNynYwg3GXqccZwE7t3Ru7L9DhrpfmZqy
         KGtQ==
X-Gm-Message-State: AOJu0Yyw4njkmPsqwVYkrF3VnUS/ZxABkocUmc1EYwz+x1QLcbDPJjcy
	59AHAOjbWKIYxd+kn0cn3Ga0CYl+WcuAkXGPMh/dKSbRLMVlYMfWiTodkhQ0QDxT98n9uJXiK5b
	cCComTQ==
X-Google-Smtp-Source: AGHT+IHsQPeGk5GigRoVwyV9X3DI4iDrgaj7U9Gfe2U4fYaTe0MLJQyrkS8JFNBOBdz1x5hINDaFbRID724=
X-Received: from pfbdi4.prod.google.com ([2002:a05:6a00:4804:b0:746:247f:7384])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d9b:b0:747:b043:41e5
 with SMTP id d2e1a72fcca58-74e417a8022mr246124b3a.16.1751995251221; Tue, 08
 Jul 2025 10:20:51 -0700 (PDT)
Date: Tue, 8 Jul 2025 10:20:49 -0700
In-Reply-To: <20250708150658.136533-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250708150658.136533-1-pbonzini@redhat.com>
Message-ID: <aG1TcRt8rHP3_JDG@google.com>
Subject: Re: [PATCH kvm-unit-tests] x86/run: Specify "-display none" instead
 of "-vnc none"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 08, 2025, Paolo Bonzini wrote:
> "-display none" is a more generic option that is always available,
> unlike "-vnc none", so use it instead of probing for the existence
> of -vnc.
> 
> This mostly reverts commit 0f982a8c1e2242483a9bf53b15f825d1ff0bccc6,
> "x86/run: Specify "-vnc none" for QEMU if and only if QEMU supports VNC",
> though without reintroducing the bug and with some conflicts that
> happened in the meanwhile.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>

