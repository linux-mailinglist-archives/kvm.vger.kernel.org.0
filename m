Return-Path: <kvm+bounces-49427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7322AAD8F63
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 107323B2CB9
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E711017A30A;
	Fri, 13 Jun 2025 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eYBzLmHA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC342111BF
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749824327; cv=none; b=eSJi2fufCDbMC6pPfTroJlIvIhSSHBegAwezhwKgRFkywjCxt06PaNUIF/FtwHazFmA5AkDuiG1jdE4VkorKkijXfQSGfoCLchbHw+/zFjWtEI3OfLzd01VqYxHr6ocaHxCBWNuN6ShLwnHT7lO/Ylafh29rCx0d4c4vYu9HcuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749824327; c=relaxed/simple;
	bh=KZCx30388jexSHnEs8GEE9SQPiUitBEN+gkUoK/zuJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H55eRtswD1SBZoB0EnIHyIBOJotsamP6Yjpltrh54mJBg6xhwMMOcT3PD1XVEtukdD3AkRnXwd1+A4EuhPN/sVcJ0KXWUBzizaWL1f1Cq1taGD4m4AixRwQN4Y/UFST/ocSKnedZkrpifdGPvkyFfA1oHe4SmetXe6BTvoeoTvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eYBzLmHA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so2307433a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 07:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749824325; x=1750429125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yuln+M51ZqtA7GXdWLmA1eKBEgUSVLYqYN5wEG+nUNM=;
        b=eYBzLmHAgqQ0wPA7GNypjAQb/+5K5uZ4ZqVR3955piHDYiau05dQwE4i240KMZ2UWb
         AEKxEAaxjI8oykWZs9AOvCod5qAce4OtV0xFEy1BOnqXKH6C9Ka43HVG/f0Lsv3MXV5X
         xv9DnfTHpQsDtbc7l7tLQnL2ifG5eDFgPZQl5/0IpWb29QGZZJyoD29h1Jr1P5r+gSwD
         8V4JcS753r77yh9dFGhXd6qs+FzGGXdDKfbwZHEQGpCcexDUAhKXJHCFzav5/yYWj9+X
         V9pTY9sDIwAp7yqgca1pkztL1YOw0MluVWxPWiMJDctor0iOgP4OXn4vrRHYKt0ho6LY
         Hk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749824325; x=1750429125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuln+M51ZqtA7GXdWLmA1eKBEgUSVLYqYN5wEG+nUNM=;
        b=DdqKD5oZY8Ao5ElUt2xYMAcYdhjmaiP65o7rFsT8g/ukdWY8p6CmsyUBWoWv3rRV/h
         WevtBbYLU2Qh7oVIE23Yoa4tXJkBsLwYAMeZohcr2DQSonsNNlNMeqBi7RDJncEkjvju
         eKpyEBKdzKFzIR3rjEwoI3WJr7dD6wYMdU91LKymwm0bpVZNV5DFCWxqzPAprzWSTfb5
         FZlVolOM9dsDtDoooBV9MeJzXxsKxq9Rmsmc1Dkiw3RUYFiz4nVwo0EmntrBnGI8HFBH
         oetbCFb4wlsS793xFl54faMr5W13VIhIqUd9zE4iK1wlYbOKB6NQxrHjozVe4zofonZc
         JpCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxZb2nSCflYfulYSoG1+gcYQkIehqPp3YL9nKV9u3Rv6W64HDRbLctB+Pxtrpd255jYiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx34kxZb1CJY7ixFXsUaxARMDREjKDuu6IdrCVHNMSxVdUbsZ6A
	D/gM6sA6dVGxymFdZpxYcbxq/jZXxMudDfmQFfDh8N+MOdd8vxg+K92qa2C5gMMyjELjA0X0LtW
	SW7Gl6A==
X-Google-Smtp-Source: AGHT+IGTmdWWhZ7LS8l723oDJ8C756m21ujYIzKHiZTqy0btcanVKUMN3Mr1M6X4Q2ZV1ZJJV9/F4bxywe8=
X-Received: from pgbcu5.prod.google.com ([2002:a05:6a02:2185:b0:b2e:c00e:65f0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:43a1:b0:1f5:709d:e0c6
 with SMTP id adf61e73a8af0-21facf13519mr4722004637.42.1749824324957; Fri, 13
 Jun 2025 07:18:44 -0700 (PDT)
Date: Fri, 13 Jun 2025 07:18:43 -0700
In-Reply-To: <20250613070118.3694407-2-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613070118.3694407-1-xin@zytor.com> <20250613070118.3694407-2-xin@zytor.com>
Message-ID: <aEwzQ9vIcaZPtDsw@google.com>
Subject: Re: [PATCH v1 1/3] x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg.h>
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, pbonzini@redhat.com, peterz@infradead.org, brgerst@gmail.com, 
	tony.luck@intel.com, fenghuay@nvidia.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Xin Li (Intel) wrote:
> Move DR7_RESET_VALUE to <uapi/asm/debugreg.h> to prepare to write DR7
> with DR7_RESET_VALUE at boot time.

Alternatively, what about dropping DR7_RESET_VALUE,  moving KVM's DR6 and DR7
#defines out of arch/x86/include/asm/kvm_host.h, and then using DR7_FIXED_1?

Arguably, that'd be an improvement for 2 of the 3 uses of DR7_RESET_VALUE in SEV
code:

	/* Early non-zero writes to DR7 are not supported */
	if (!data && (val & ~DR7_RESET_VALUE))
		return ES_UNSUPPORTED;

vs.

	/* Early non-zero writes to DR7 are not supported */
	if (!data && (val & ~DR7_FIXED_1))
		return ES_UNSUPPORTED;

And in vc_handle_dr7_read():

	if (data)
		*reg = data->dr7;
	else
		*reg = DR7_RESET_VALUE;

vs.

	if (data)
		*reg = data->dr7;
	else
		*reg = DR7_FIXED_1;

In both of those cases, it isn't the RESET value that's interesting, it's that
architecturally bit 10 is fixed to '1'.

I haven't looked at the kernel code, but I suspect DR6_ACTIVE_LOW, DR6_VOLATILE,
and/or DR6_FIXED_1 could also come in handy. 

