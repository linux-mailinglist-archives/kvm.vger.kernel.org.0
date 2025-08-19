Return-Path: <kvm+bounces-55065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4617DB2CFC3
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F65585F6B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3732F2620C3;
	Tue, 19 Aug 2025 23:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t4sisD16"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2847F236451
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645494; cv=none; b=AjXUQbNgX5hGr9mVbWzJpsc8nlhvD/QmVL/S0zV/rH15xq4gUpV9PKbHzGROI1Yj656plx1gt0zxPwN4cfqHdtt2uWjLbRe4hEdtb33LY1YF7mQYuZxlRHfhpyaNwGac7DDd4Mu426IvfxdCXUltOlfM3BkvlTXiSx/p2eEOnAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645494; c=relaxed/simple;
	bh=GxQ3bI32BWUEQbQQr2ztR7iscpZBTjInSD7DrhOawt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=C1Gkygz7vljugxGB90tZGFJtmqM8E3aQaeQ9SQbY+8x1I42C7RIGtPH2zKo6VBWtpOZcuFuQETydJo8h0P1OrXXqwC5Z1xCCPPL7Mnl3Y7TvJdFJedmDpHksA6Tzrii4XsjYTtNezb7z5Cigdg51uAKisRXi00fZ2R4c8d7vHlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t4sisD16; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47158d6efbso264724a12.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645492; x=1756250292; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sDr1ilphEHq13aUEE3jJLkUxtKv+xNh38Lb2+aXAA/4=;
        b=t4sisD16gaali2sNlbBAi4+C5KLrXRwK0f/1ot3beW7O7GnjsTWwzROTnEbbCoNtcM
         v3YY9CFuZsUQhIy7g+0nsm2x1fs5KcAuKjqQBZ3iSkUjg3zGQEBNVm+eHGvjSB10bSnI
         dWVM5601koxGhBeWhT8Z4YBfOVBvzMAxjl0jIcQd5gZH8HkqYXgAfZh6plZ+Susk0uNs
         +OHjfCZfIuEWfXgAdujFa8AJzqa5nSYXXuGH4Ba4KC5Bc6BjDqzV94cblW+OZEOaGhMX
         d7aMfk8Regk1DMIjkhQ4yyp0BhcUByMZlXQoFts/FMOJhuR7otuhwEP1D7jE3lm7WnEl
         4Z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645492; x=1756250292;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sDr1ilphEHq13aUEE3jJLkUxtKv+xNh38Lb2+aXAA/4=;
        b=aIZJBcuUE4POTUPgx/jlMYT5akLHL75TYua4bvESXhOSzJP+BOT6swLJ5/Z0pSuKxt
         ExjBjCaZTNRZWA/xQ6m86xJotBeZzc77IbbqM95DnXwNpfKNKeEJMrHs0GyCAu9cNTDM
         8RY3/FbXqQjEZkOyxGDZ0uvOBtC5KAT73qXB5Gtjgtdvqtotya/vx5FkpOe7qKuIZZeG
         eMuW2qSqgazBnxi1QsriH84MRHxWWPLvOwg70FXzuZEmEnbTBJ1O0vAhhJiaWBATsToy
         hc5jmNjhYFCJH5nev5MarJmJwfainUMkSv6mAmeRt84h2AoEZRSU/CnVf2EcVHlTNa1o
         URHQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1UncI+x0mquEvBsLUhz9ASH5NJbcsn5okjBYHoGlyuu0O0W0Eu99S9OO62VMPoM+wdtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcagfJU/Q3fXr+MOn51wu2sDYpSL88XWRfnpiEvRD9I9/HRFyA
	iOTsYlx4iKsTYFsCpm1I7NZQMLW+7yI2SZ7wJzkwWyDLSRfpYrTl/lWEVN5yFPjVx3+ea6BbZqQ
	dKTAsDA==
X-Google-Smtp-Source: AGHT+IFDxnpwzMVt1NN+yUWtyyyahHTDf5WVJVXVoBbADQGx4NrJypC4B971/ZM/ZXkrYBiA56ui6MOkVfI=
X-Received: from plpc14.prod.google.com ([2002:a17:903:1b4e:b0:242:fe10:6c5f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aad:b0:231:d0da:5e1f
 with SMTP id d9443c01a7336-245ee14e028mr11522745ad.21.1755645492331; Tue, 19
 Aug 2025 16:18:12 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:12:19 -0700
In-Reply-To: <20250808074532.215098-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250808074532.215098-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564424895.3062965.10260628110611509312.b4-ty@google.com>
Subject: Re: [PATCH] KVM: TDX: Remove redundant __GFP_ZERO
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Qianfeng Rong <rongqianfeng@vivo.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 08 Aug 2025 15:45:32 +0800, Qianfeng Rong wrote:
> Remove the redundant __GFP_ZERO flag from kcalloc() since kcalloc()
> inherently zeroes memory.

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: TDX: Remove redundant __GFP_ZERO
      https://github.com/kvm-x86/linux/commit/7cbb14d361bd

--
https://github.com/kvm-x86/linux/tree/next

