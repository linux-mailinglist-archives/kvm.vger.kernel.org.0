Return-Path: <kvm+bounces-23944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 073C694FDE8
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D9FA1C20E30
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F883D3BF;
	Tue, 13 Aug 2024 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LRKv5FnK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F3B17999;
	Tue, 13 Aug 2024 06:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723530969; cv=none; b=uGyfBq2vpUSm5SIEWJxjpl5GGHOTl5+MTiUalwpupLH7Vlzl7Yq+v5486xsfxcBLoQPjnLENrJZ/jjs2At8atR1vNDfqw29lAEUhgTnScBaaeopo5gX8Gt2oRV4kg9nn2USG16W2KmFH1ciQryD8qfXuwNGc+4lm5ZtlHKhFyVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723530969; c=relaxed/simple;
	bh=SvVhsbOOUIYErJb1YNYhS07bUgHJQyRWsAil6oOlP6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qVqGdn6AEOuaRkjO6oSDWbO6tSOqRcKC9ASaw4YpLPakTrSLEfLJhaWCFkvT2LxCIZdsLM/2hTO5jruHcqwWIkbQj777jjLThgQ13foEx0uLdr8QkuJdNLGTV3D2NHavThbqI+6tiWnUEFCPJLeYSuoK7aMxrEWmhrtCvg2arqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LRKv5FnK; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7a1c7857a49so2878860a12.1;
        Mon, 12 Aug 2024 23:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723530967; x=1724135767; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvVhsbOOUIYErJb1YNYhS07bUgHJQyRWsAil6oOlP6U=;
        b=LRKv5FnK7elYwBphX/nHRfs63goExDWpUavZDdOLh/c64Ky47MLzSoHphZaJCGQbCn
         X1pGbTOoETe76wUUMBqrDRaiTC3ncAQqPZoF63Bm/MJkpKBM4CAAvUUrvPKxJpxtu3kF
         KaMmca57qEF/e0HftpCAqR0z1wLEWMhXzhZA2dH/wuWUVNOdpJmBVBE6wJ3dzjxle5zx
         ORDHRAW55FO00Z/CoRoqHpPJDx4SGjZdrsF0EP1Xtfw3uentbjt62WXdKPoEVHLdr9X2
         5DgOYLMiFbHs3gH3hvLrKruCn927pVaQ6X6C1ocPNaDEq6I7pWDV56WvQ+ZW2Afxeqf0
         1BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723530967; x=1724135767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvVhsbOOUIYErJb1YNYhS07bUgHJQyRWsAil6oOlP6U=;
        b=U/HfGcLHG6ZcGb1vt+ZEHqIgOWsVOOw/kdOrwO8YSutjtHW2rSc4riKfdvzoCRtzyk
         9xJGhBfZ0M/1Ly7of8V5RSDcz4Nd3M/qiokhRdiA2KdufZLcsEwT9NsbV3tXE0uEXtel
         2EaZ8bZldPrTRB9TDf7DkfGqMQvFGPdXhk9VkN0uYFb2U+KtjALJFgP+MSyubYmLXCg8
         4o5/P5K+JiRMyP+ighX2KogKWzmH6UszAivk10cktBUilw3LsKLH0otxTlnGSiNE91AG
         z4rnRTlqxIJSBAner3j+JO6om33xUA1xO3mTod7Lf5cUu82k/dBwjyirTZ16J7ZhzPel
         7PUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVM/KW3CX3YWD5AX1xf2pys007YKlMwFlKbiIoaUSMhBt8XqTmAkPe3xW7RCVuGHjLOEQltYtiQ4TqlWQZx@vger.kernel.org, AJvYcCWVdRoAoDMD45Hq4YRFMZcNPIk8tEH3JqlHeYR0mCwLoJP76i4o5zitWUED+/bwFbV0+Mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxioHxGvUg7WaEzhaxgk47C/9NHqaA5CwJ2RaQ1HHdcHsDTWfcA
	LpiYgJQh0E7kkz3YoRiX1WoiSfqXK6nZnbIbWSNumKVRZRNGFNHxq9eizNEbnmQSafy/YfnM9MO
	nE1ftxdY3Q1gSMMxbG3g5LEQbz3A=
X-Google-Smtp-Source: AGHT+IGuUzO7t+ZODmV+ALrRmH+bAlkgxiFLKvCKZG54YZVdMIPIq7ShMlbvGg1y4sK/MXsTaHmMBiF5UEr91SL7158=
X-Received: by 2002:a17:90b:4c12:b0:2c9:5c7c:815d with SMTP id
 98e67ed59e1d1-2d392554fa2mr3015928a91.22.1723530967241; Mon, 12 Aug 2024
 23:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
 <CAJhGHyDjsmQOQQoU52vA95sddWtzg1wh139jpPYBT1miUAgj6Q@mail.gmail.com> <ZrooozABEWSnwzxh@google.com>
In-Reply-To: <ZrooozABEWSnwzxh@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Tue, 13 Aug 2024 14:35:54 +0800
Message-ID: <CAJhGHyDa+-ehMOeLGhZ9-y-ubB4fSXG83hBGUWMRmBOtJ-wSLg@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 12, 2024 at 11:22=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:

>
> Oh yeah, duh, re-read after PAUSE, not before.
>
> Definitely holler if you have any alternative ideas for walking rmaps
> without taking mmu_lock, I guarantee you've spent more time than me
> thinking about the shadow MMU :-)

We use the same bit and the same way for the rmap lock.

We just use bit_spin_lock() and the optimization for empty rmap_head is
handled out of kvm_rmap_lock().

bit_spin_lock() has the most-needed preempt_disable(). I'm not sure if the
new kvm_rmap_age_gfn_range_lockless() is called in a preempt disabled regio=
n.

Thanks
Lai

