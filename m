Return-Path: <kvm+bounces-48861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CD6AD4311
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FB2D188363E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B3426463B;
	Tue, 10 Jun 2025 19:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZHw1dE3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFC8242D7F
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584621; cv=none; b=jnu9eOSR1HT8eYwZ0mY04aEIVsvoMgFVPl/FycKHwl2QjxrhkJTdJ/rgVqhe8qvg5XS30BkxkOm/GCP0XdakmPDJ8dFTfPlNksJzXMENkzMqzGD+TfsWv3flqAGv1pPqJ2gsCRKEyTEsRXT4Sxvze7dNR9ptCU9U0qnflTotfpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584621; c=relaxed/simple;
	bh=tLGqZNJqXA1InS/eVCLMXMClCwZ/38FB1N6PgBgqMoo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LHudVsXK5knNPtNT3I3W6Gsk9YvCScpQTp0Vn1FPwcMDdSSfs7RzrDIUQdXIZ2pzkX/VdJ2dgtwr7Xk6pfR0LKG9eIONcLm8paT7RQwOYilOUv4EY5yRlE86202Qoq48ZwWFS2qhNcFvXZRKZ0NoksBz1SMEckG8RVKcrcXmFjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZHw1dE3h; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747d143117eso4559235b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584619; x=1750189419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I/StOI/6+oLmX4Wo159nJOEwG1qYBTIOX7x+ECLQLbA=;
        b=ZHw1dE3h2Ezhtlk72rBOT9IQV/kjvkrxki8oioSgbsXbXEVvyCodFK0Sg3pE/sqefT
         UqfIriuRueaqWxPXFZmDRI09/Nb51qlY1dtzbvWujxJSCixiV8GxjxnR2lvevh6G/hCp
         QS5hIBABuccXF1zwJ2qHhuwJpePxDz5Qv1PE8nwd+tK2wTBq1G8tmSazqX0fvXVWyVXS
         7y13CsexGGgsQvraN4YBN9RIB0rf7GYEQwPEIWUWVrp5a4t3ZamLFcGWa2j+uu0iJlB9
         FZsMsmwi+tzWg8XQj8ZzNuhwuhmnMrVYJG4RiPA3xDpXAoBbEi9pBleC2ZphZLcx7PE0
         9ZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584619; x=1750189419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I/StOI/6+oLmX4Wo159nJOEwG1qYBTIOX7x+ECLQLbA=;
        b=kCD1yX1yaTrqdZbuhrHiCm/ArxcwdGkkD2wlss3gxlRkFGNYfmuuealTUIYL+2k+rW
         ZN6cX0V0RrJ1PO9UV82hOkDm+nx3BZKfZpVsheHztlGQaDJ4jsU/G97xM7JvDT9/1p6t
         T45v7lPzZKniSOvb+zTGgxD0myM/AqX7m+eAuFbwJP9DTMJRrX3ctJ3q5tmQkQqZW07i
         3Lzt0MGuBh8ij2csURLATczfBeedS0owW/0UV+6r0Xjs2hA1q/05umoVPkgH56BvDzsS
         bKJ9tzltoXe9FnLWGe2USPC8OXmBzYgkbePI05DJlYh823PVMBwZ6/QMKb0So1MDbKHN
         AiMA==
X-Gm-Message-State: AOJu0YyVveIYk6IPWR6AUE1eSe0EhsMDk+j5LR3sYVcrRwV2dOnNPScx
	zr4ml3AoyCHmt3zHvvRVwdDNwHZeSVa8L93WYhFh+H8PYr2iGsndVqbhyyOcN2ZfXGdsfrwBnRc
	8hznz7w==
X-Google-Smtp-Source: AGHT+IHruNgVIOqJ6KqW6wIoA/IZH6d2p5DN9CSj/RtBs3lOcTiCjyrLQxzEvYvtrqRhFrPYKwWbr8kbrpw=
X-Received: from pfbfn21.prod.google.com ([2002:a05:6a00:2fd5:b0:746:270f:79c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e11:b0:748:2ebf:7418
 with SMTP id d2e1a72fcca58-7486ce162c9mr1095620b3a.24.1749584619448; Tue, 10
 Jun 2025 12:43:39 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:30 -0700
In-Reply-To: <20250603235433.196211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250603235433.196211-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958174606.104034.2917910552002276153.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Disable PIT re-injection for all
 tests to play nice with (x2)AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Tue, 03 Jun 2025 16:54:33 -0700, Sean Christopherson wrote:
> Disable PIT re-injection via "-global kvm-pit.lost_tick_policy=discard"
> for all x86 tests, as KVM inhibits (x2)AVIC when the PIT is in re-injection
> mode (AVIC doesn't allow KVM to intercept EOIs to do re-injection).  Drop
> the various unittests.cfg hacks which disable the PIT entirely to effect
> the same outcome.
> 
> Disable re-injection instead of killing off the PIT entirely as the
> realmode test uses the PIT (but doesn't rely on re-injection).
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86: Disable PIT re-injection for all tests to play nice with (x2)AVIC
      https://github.com/kvm-x86/kvm-unit-tests/commit/3dab6993cdc5

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

