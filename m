Return-Path: <kvm+bounces-37215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3927DA26E7C
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D1F13A41A5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE358207DE6;
	Tue,  4 Feb 2025 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RagYRsU9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D901AA786;
	Tue,  4 Feb 2025 09:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738661481; cv=none; b=gY0Jcsfu8DUNhO6Bj0Y7GZCna7GaEq6vJGurEl9qJCxdYdBu2G0zJDC40mt1Ql2iDBa+z1FM6rllmdLG4/CK9AP+x+zdEu247fYZN1aLz0s9WIM2crIwTlRwNV7DZT8Vml26mc4Dc7bwBIr7O+AzbxX608NM7vLa48Y7P4surqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738661481; c=relaxed/simple;
	bh=NQR7Ll+NekyiRmYB0dYQI7LlK8OJ+yHTgBGiynUw8jc=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=CNSUW/FMcfH7layuoLhF6nOiOj7fdkJL3x0MbGS9moPnlyQWDqqR0kJnwvQEO9x64lFJqOF//+6QkYR6tWMrWpv9bvDIcfCEWjOyhyOQiER3ONFXVQyKdVrz8rE9B8UnwsCfcyTdRXYrDi5WDrWulevUXZpLmM32SzPl8AZbNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RagYRsU9; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5db689a87cbso10603606a12.3;
        Tue, 04 Feb 2025 01:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738661478; x=1739266278; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OkZHG2ey6TpGUua65UBTciC20mI0hZJdW9qjfgIkfmQ=;
        b=RagYRsU9b1hEx+5geTeOgpOBNUuYwmocBSvZVlA/uZKMPhKI6h8kT2ph4RYsEi0gAM
         S047wqOigLZgJuC0fWrZURNsFKNWNF4chujY8LpXd5BnL73jz04GeSmk4RNMKbRoFEaa
         HUjbusLfIAeNTkUSSFb6u0Zq9W5gbRuo//6TVa8St3H1CFvNSletpZEjSiNwj+RW6h2m
         W3VxMEIPRxu5fwFerNTYzhkvsifR04AlvZb8D0pf1Mia+H4TdKFoLURwqF45nBFEiQlP
         +5/jUwgwe/P/HXo+w9R2pgKZGmeNsEwR8aroIz1Mvo8/2zYFVzgQVeym9PmusSZzacv9
         9Rmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738661478; x=1739266278;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkZHG2ey6TpGUua65UBTciC20mI0hZJdW9qjfgIkfmQ=;
        b=XQD4iEWLWiX3VxCPQB8RmBCSmOk7lQi2bgQdsyKMgzDZpiAuBGzSfy0Q3i0L9cVp6e
         4xKHehMJ4MpERtYTKrGBWjJCs1JSjRhiFrLxWtM/oLxi8Agm+63TRg+dnW6Z/zlgwSNi
         9qLpb5N1tUGjOfaOJJTXfRXGKE8Ywuz9uro0vKdtgS/oHuKMDO4Wo3z68/vpFaxCQYFl
         Ydjheasj8saemTyRC6LFN8ycxLzYbl0gV3eAqx0q8JPDtosJJKqgTTVz3hCyrS9n08kk
         ECG48Qf0ah7DNzMy2FFDsWyk29FAvj7x9XYU+jA08g/E3e4uDhUM2paONHbNlYYRRPya
         Oy7g==
X-Forwarded-Encrypted: i=1; AJvYcCWCa6aDT6jSQlYHVNQVWS/5oImmA/7LWX3Khke52+WIJHnSYHhi/gLYTrYPgDg/8bUbfSzxlqfINWejtlI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwu0CRHTYCwMcDmEjhzWRECgzRNttcJrT9RRD/WAL85HvcWnOm
	PIGBgQNgx0Tt4/Nx0W9sUU2Ln3c+5XH7JtvBNZQ9iUCwQjlgY7LT
X-Gm-Gg: ASbGnctapVzfW/o4j9I3UvNj2z0cIi4UQpxkQtEppPDtm2Fx0uZOPXxNoz0fnGKoquD
	Y+r7JT3R8mo8IwxPWq0uIkQp9QQyiBDs6nVpfUZwkIVscymNewzg7Nf11cncXtbW0lnm5PcQOwO
	BZIsZuuWyVH+oNDXPP1w99mtSQNOyI0REh44xYApv/bWUpNX7ypSRhyAJnghSSPtdteW7eNKbgk
	nVmHIXcRKYCKbPBbLuLZv665uwvE2aDfUwIYDPUkv+1SQVSRth1KXTlo59l6kwEJybFMOJWKtQD
	ocR+OunHsr8Kq9I4ZLfky4BcQBhJtHTGe5gOFvhwTigy6iY=
X-Google-Smtp-Source: AGHT+IH6ELlubR+Pez3MZgDaePcbFoAMCS4gU9kWQm4zbWh57l4L+uVB8wBwWUDUE3ZWjO6Xh9/20w==
X-Received: by 2002:a05:6402:5019:b0:5dc:7fbe:72ff with SMTP id 4fb4d7f45d1cf-5dc7fcdb6bemr18969610a12.2.1738661478029;
        Tue, 04 Feb 2025 01:31:18 -0800 (PST)
Received: from [192.168.20.51] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc7240487csm9012982a12.34.2025.02.04.01.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 01:31:17 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <8038e5c0-d0dc-4582-b076-3d514656af1e@xen.org>
Date: Tue, 4 Feb 2025 09:31:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 07/11] KVM: x86: Set PVCLOCK_GUEST_STOPPED only for
 kvmclock, not for Xen PV clock
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250201013827.680235-1-seanjc@google.com>
 <20250201013827.680235-8-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201013827.680235-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:38, Sean Christopherson wrote:
> Handle "guest stopped" propagation only for kvmclock, as the flag is set
> if and only if kvmclock is "active", i.e. can only be set for Xen PV clock
> if kvmclock *and* Xen PV clock are in-use by the guest, which creates very
> bizarre behavior for the guest.
> 
> Simply restrict the flag to kvmclock, e.g. instead of trying to handle
> Xen PV clock, as propagation of PVCLOCK_GUEST_STOPPED was unintentionally
> added during a refactoring, and while Xen proper defines
> XEN_PVCLOCK_GUEST_STOPPED, there's no evidence that Xen guests actually
> support the flag.
> 
> Check and clear pvclock_set_guest_stopped_request if and only if kvmclock
> is active to preserve the original behavior, i.e. keep the flag pending
> if kvmclock happens to be disabled when KVM processes the initial request.
> 
> Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
> Cc: Paul Durrant <pdurrant@amazon.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 19 ++++++++++---------
>   1 file changed, 10 insertions(+), 9 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

