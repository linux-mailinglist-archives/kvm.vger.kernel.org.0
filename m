Return-Path: <kvm+bounces-67291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A3ED004C4
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 23:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8A36301462D
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 22:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB822868B2;
	Wed,  7 Jan 2026 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kerMViWi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BE51B4224
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 22:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767824474; cv=none; b=EWI3htK0YuQme+16O70+GEF1KsKH6Tqnqn8ZK4/2/rUV2TRTI9feqLVcwKiKE5cYW+yuZjMAwpE0mLQioZiPcwJSFgYrlbQmCWToO+XL7uvo0N+eg2nnZXI9t+5fIvLN1E2r8jVsJBi3nFOXO0DIshA1Akc4Yzme58dsklGtHeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767824474; c=relaxed/simple;
	bh=1jZL0N3BJELpYkCrSCSqxzHR9luyolScr8yPYAxfwuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHdlADPAGCBrsQ3mE5lA1yJQMR0njJdw858kiMwkoHcsTxhKWOxcCy5HS+kgMI7wCzDTnTVTIcM36Zn0py1WkmLkCOJ3VoKzwNlVNKm5kmWDW7w+b7jbPIT6zHVYTpMWyn1saG5TNMbKdcqgW/nHxWebHwoAIMy0BR2i7K6uwUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kerMViWi; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c525de78ebaso271517a12.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 14:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767824473; x=1768429273; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FBiiXzgRQjbS3yw6xrPsKKQHTsD3y0S4tVOENJQjYKI=;
        b=kerMViWi9whavOJprN8A0PzBPtpYZlYodoQOsg2/CX9xR4CE1TtdwlsWGhEMhxoCBV
         /tmNlzQzf9NneAKSA0ZL2Gk3KdTQkelDZkxjfJpZ85FE0NAR/F4YX4j92ptqhZSdvVHt
         c3vBghp8Ea3tlRE3kPT66b9UNf2Fd31fj9NKrunnz2u/FnVt6Ad7YErtFQI2BqRmyjwT
         1j4+p7BhmvN2JqR7Zbf3Z0AUksp+Jimg0WaX/ZAr2JXUO2RFG+hNdgrXphvLsgg9RKgC
         NGpw7KD373BtAR5qTmmiRqD7cYdnVBgX9txE4WOhkY4fvXm0HFCmqQ7xaCsjPqqK3Ujh
         jDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767824473; x=1768429273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FBiiXzgRQjbS3yw6xrPsKKQHTsD3y0S4tVOENJQjYKI=;
        b=cu6d4OQk7cfP224+2OU4gHiwm7zpOh1jo/zH5J+HVaMtC9HfkbQPqNr3DwrdcC3y5G
         w+KIJ9FPa5IyGIHO3+WWaLiKsuglFJPk/yagmuoHjd++PbeqFcApifB5OJsar+wY5RpM
         oKm3HflCxPYcl2LaVdHYP2jS7m7LSyssYIQGblpTCAGICVmyYWIRW/0lBw4iRA+ZIpV1
         meZ+6XUzCA/989L3U6uFXBAix7M9o38SgQZsFBzDARBghe82Qir2rijQXAUgKFZaqnQ/
         RTxw0UKOAc3uEU97vVf22WFVHS9NcXGtPiXJQt+mWAPgDmobL2ae2WBBos3wzJ6c3/59
         7bTw==
X-Forwarded-Encrypted: i=1; AJvYcCXUs5w2TrgBpPBxVA7Ld1naFZobKAsPqPdxPXoGy8qTMUypr2xhPx8tMA1H43k9vLokoQI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7IuocoI7tZi1PCYswt+8dPp83AiLQ/jIfIpKY3rAsFbWy0y2J
	foEo40totbkropbGwgzzc/dOJf20bnm3rTt4kWPzzs/NfPe5UozLTPzZ3BRX0QLRvw==
X-Gm-Gg: AY/fxX5ZOS4iRqV5PNJjkhoC4cskoArgnCJPL5Ot1u6hA/TXS/5VglBrwiWMGKdwita
	vLTT5QJ6PaZXQTwsIeXaI6ZoDn9Ud8x1WVISzjXONqupzMOd9/+teaI18K9pFMxcFMM8BbAatSc
	d06kM5A/ShZzr8KkGtDBI2tnT6XobhKIR0tVR6XMKDxJz6MIEd65Y6jGra4hbkeeywJ9CUTaH6y
	boT1nfyug6cB6pjf0JQcKI5SQX1O1U0xNFCsgfwUy9uO+s06rjgCNp5gDduusg1EogcLwUJLoGP
	54IWATOUUOAlR3tT8mhCQzHypA+oQqVL517rLQs0mxYLPSSsHuyHzw+yTZ7kE97ifbf2LSgpfYB
	50taVQE48KcnaWo1+IMC/T9NLcLVe9MGZ+vpKqO5jXnnSihHScZWQ6ncqq7/MJuJ7Cs66M1gR11
	lLq8NoDxakZgzDpArcCAriejYN3Sw+Xj8gWg/xjlhKysng
X-Google-Smtp-Source: AGHT+IGBa/AUV8erVLZIt1j1xT5w3ypJ65tm0PpGIipfyhNJFPRFgo7cPDnX8wBUUsAZDaxMNHKH6g==
X-Received: by 2002:a17:90b:1e0d:b0:33b:cbb2:31ed with SMTP id 98e67ed59e1d1-34f68a2bfadmr3307259a91.0.1767824472441;
        Wed, 07 Jan 2026 14:21:12 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5fb7442asm5897745a91.15.2026.01.07.14.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 14:21:10 -0800 (PST)
Date: Wed, 7 Jan 2026 22:21:06 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] vfio: selftests: Introduce snprintf_assert()
Message-ID: <aV7cUiNj7xr1NCgb@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-2-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-2-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> Introduce snprintf_assert() to protect the users of snprintf() to fail
> if the requested operation was truncated due to buffer limits. VFIO
> tests and libraries, including a new sysfs library that will be introduced
> by an upcoming patch, rely quite heavily on snprintf()s to build PCI
> sysfs paths. Having a protection against this will be helpful to prevent
> false test failures.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

