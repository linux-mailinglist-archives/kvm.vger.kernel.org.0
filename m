Return-Path: <kvm+bounces-39017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E67A4298C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B54C6179FD2
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFF7264607;
	Mon, 24 Feb 2025 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qzp3pmut"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6053263F5E
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417923; cv=none; b=MKcxZjus8MeJbvZXGp4ndLUg9a7CZy643NxTeAbkDJ9NtRxBwOJfWttpsttU1YRwLJMbnQ6cDXMaOOlHDWH8VN3yUxPBC23Ng8gDw2C/X59tvcRzMyxKsR/22oqJrVLL7SWfjuBep/jYTDARQHW73bbThqJHZ/UEc35DDLMVDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417923; c=relaxed/simple;
	bh=J5acRm3fyQ5aHGAlZK0JJqF6A2Evv7snGDFau4Dbi3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y0IFZE+Sp3vtXoK95AdZgJbQ5hzyUnSUi1KkDz5gEv8JubxHEe+8WcxWOiO7M2L7M+qe2a/UNo/qfZBBx6ox2wua15I1X4Q465pH4o/KSbpAHNdY2XroBJPGyKNDbh5yP2miCFZvgKyKvTY6nQloba/YOheh8/2xyhRoZ6du4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qzp3pmut; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2210305535bso151986055ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417921; x=1741022721; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YOGQSKZuiI5e2Qtxzp8TdmwWvbL5BvWYrlpmjTTfc9w=;
        b=qzp3pmutrySWvFjiu+vrPI18cjc+EMgmzXkd/Zez7HMByxhrWBkz9l4lDg4Zdhaz5S
         E9sEP8WEiP4OA/mQtkgWI6h5RLTkzIQCoi9irhSN98j2PCWv+Jx4f3aySFMm1ghbZxjD
         Q3EA5KNFcfDXCRS3fGOn6dtenHI171JsA/0aqOC8R2s/AoYFjNk92vdVD9Y3TCuPklLi
         MzO4M+AS/02raTpAWPB1ACSoMru61yNVMewp4ZAmkUDcGV83phwk8KrjS/3d1vUzbvdG
         xkU77wJhR8vTO0JkAVz0BwfrVsCo/JESf/+WLwGD5MzgpHicmPRgNHzCj3c4pWYT1P3A
         8BcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417921; x=1741022721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOGQSKZuiI5e2Qtxzp8TdmwWvbL5BvWYrlpmjTTfc9w=;
        b=S56cjQF/vEYOMdJ77FXFRUnPM1QcNuPvEwQAWTYMr/6RHKEzswPV7PxeTMrydPaiIG
         yiorr6Muui0mgOtD+Z+rLU3CwiACRpj4YUNpzSsWOVJhcinKzAm70OgcZsgmCd6vD7d5
         rMWB0TNo5RmRK5MsspWG4yFod+yPGafLVduv7pcQAnbrWR3kW+3A4aQyyFOwOP39PGuC
         dALoxxdZjxHWao5qqJDMAXTbdG8exlP34ThKbP3pEMED0jP+Og63/4j5UaxLN+pdF0w9
         LoGgIucpQ7CMu4QBM84Bx7oFlK+jvvLfDHoODIin5u6K5uvfbN3c/ctcCJgKBqS8wlZC
         +JWw==
X-Gm-Message-State: AOJu0YxbNWdBvnXFirbvQx+xcoEjFsCJYv7TzZNpPY22dAi1R7YxSATI
	K+5R78LwHurGREyb1yvYxNJYftVtnfig+swRvB18JhZKAIyPVJ0yW6R5AcJeX4AptwhM++rm6q7
	nkA==
X-Google-Smtp-Source: AGHT+IEcUdIFeM7R6rYniYDz4cAsA19kPzcdphscX4SIuu7oMYbL3ogELdKsXAs9Fsywutu6PpMOxHlWVlw=
X-Received: from pfbki13.prod.google.com ([2002:a05:6a00:948d:b0:732:547c:d674])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c2:b0:216:281f:820d
 with SMTP id d9443c01a7336-221a0ec3321mr200426225ad.11.1740417921121; Mon, 24
 Feb 2025 09:25:21 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:55 -0800
In-Reply-To: <20250214173644.22895-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250214173644.22895-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041741933.2350477.692602307281764091.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Make set/clear_bit() atomic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: kvm@vger.kernel.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 17:36:44 +0000, Nicolas Saenz Julienne wrote:
> x86 is the only architecture that defines set/clear_bit() as non-atomic.
> This makes it incompatible with arch-agnostic code that might implicitly
> require atomicity. And it was observed to corrupt the 'online_cpus'
> bitmap, as non BSP CPUs perform RmWs on the bitmap concurrently during
> bring up. See:
> 
> ap_start64()
>   save_id()
>     set_bit(apic_id(), online_cpus)
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/1] x86: Make set/clear_bit() atomic
      https://github.com/kvm-x86/kvm-unit-tests/commit/2f3c02862e03

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

