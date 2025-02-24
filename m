Return-Path: <kvm+bounces-39022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A948A429B8
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BC243AE04D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E42265609;
	Mon, 24 Feb 2025 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hvQFTMoo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD512262805
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417954; cv=none; b=G8Ntcf5NspSIyxeRBM0O1H1X1S6I89oweIQrL+JaWN79WGtwxmrm/lpz/yCL3pW0hyWa2nBiHDtIzLCfbHi2HNoS36X6pKcwvCC4J8ZwzaGEOxqXgqF0uCNENhoO1Jpvk4loJEmrnqmm+n2fM8qW2zzTZPJYQzQ50ZbTXeR2Zs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417954; c=relaxed/simple;
	bh=T7K27VGd1lb148T6Pmj+AA0I6WEs2NXemTAsLAbOwEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D6iYjznjirVPBTgWu9gIK2c3A9sDHbaChp/kWCC1XbZvb9zdHS1XzTiFOVETW0V28YyX/shi31jPsFJz3l6lK0x65VXF+qG2NbP8xg9v8SGiVmZ4Q+FCdACcPm6e4WSBgCpHZ+fJnVyZJUerkx++r0QaSETu+1zO7hXeMDqkkQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hvQFTMoo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22101351b1dso92336135ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417952; x=1741022752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uRI9vq8kVnnZYl0dzkxBE1pBnz+DO6vIKV0XcOCSyYs=;
        b=hvQFTMoo2ByeCqIEtZ3ztnVoHad40BBg4OvG0rJIZMDa9W33qq/Vv2nz0qb8eCIo+5
         n2xot7v+mIqEV/yiXpSkJnrlNLeF8NM2k3EvlwvMf+bptQQ2NHvyQoVQT70+Hi9gYWVE
         WfgFlYn84Z5MayDE8fz0ZwidyJEULZypLiBFe2xE5zRl/oB//2UvbChrOAY0wawqf3Yr
         YdFjP7lC5j+ksx67K45vA0BuAo3TmPfsYeEchGuOtpg+amEOK7BTeBZaAPc4ZbUBHnma
         uaI4tKAOryfdE4juKQquvFutQxRX9PvYcH1BsN8HZYtEYH+qgm0ph8SqaOVUvnKAP3D8
         8LFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417952; x=1741022752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uRI9vq8kVnnZYl0dzkxBE1pBnz+DO6vIKV0XcOCSyYs=;
        b=nv/XbF562DV6UtAyesVRY1KBh1fJcVw5uncHcjNMUWMQ3qUGIv/mb7c/PHVh7SuvLU
         8wE0UIjxNzPsKQWqshAVsorg+ykEZ/Ea8QH/H3g7V7dxSpf6ZJ0KSDAIxIT5nzpXqzU7
         bedzFQ05bvsXdpAqyxTZRrKQ7zSr5+NAIEyWRABgrxgELyKyapNW1xI7nV8X9XXp6miG
         ykziBH54aGVQMiZPdKd6dKUsIY17Kb3zQs9Ej/XKxKn8bFjhQe+Gwq5CalmgPo09YqcL
         /P5StDA4mfYn7YiWNwVs6sqKG8IkAuI6FmMudwnUR/dN4LPN29aPAv1WRKa9mHsH0NmZ
         L2xg==
X-Gm-Message-State: AOJu0YwsQF0iXJCT64OaIHqF3+aeNB1OA6TfVUg96fr3sBeP0+hsNozb
	3B9gWvb3xX6XYH5l5Xp+hWyUCgKO2Z9Wk47ZeXkvpT3VAx3oeikZias8IAauxgpVlIOaiciuMJS
	ESA==
X-Google-Smtp-Source: AGHT+IGVAjRrD6fUVmBdIMDJz4xKNBbz/UUK+zfX1y4hWjE/tpUI/hiWCbgYq1CiwOFv2fcAIhWP3hGKCxw=
X-Received: from plbmi15.prod.google.com ([2002:a17:902:fccf:b0:220:d3d4:7a7c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1cd:b0:21f:93f8:ce16
 with SMTP id d9443c01a7336-2219ff6e424mr215486145ad.31.1740417952379; Mon, 24
 Feb 2025 09:25:52 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:05 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041742708.2350746.1350561080696052785.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/6] x86: LA57 canonical testcases
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 17:30:12 -0800, Sean Christopherson wrote:
> v2 of Maxim's series to add testcases for canonical checks of various MSRs,
> segment bases, and instructions that were found to ignore CR4.LA57 on CPUs
> that support 5 level paging.
> 
> v2:
>  - Fold into existing la57 test.
>  - Always skip SYSENTER tests (they fail when run in a VM).
>  - Lots of cosmetics cleanups (see v1 feedback for details).
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/6] x86: Add _safe() and _fep_safe() variants to segment base load instructions
      https://github.com/kvm-x86/kvm-unit-tests/commit/5047281ab3e1
[2/6] x86: Add a few functions for gdt manipulation
      https://github.com/kvm-x86/kvm-unit-tests/commit/b1f3eec1b59b
[3/6] x86: Move struct invpcid_desc descriptor to processor.h
      https://github.com/kvm-x86/kvm-unit-tests/commit/b88e90e64526
[4/6] x86: Expand LA57 test to 64-bit mode (to prep for canonical testing)
      https://github.com/kvm-x86/kvm-unit-tests/commit/81dcf3f7d568
[5/6] x86: Add testcases for writing (non)canonical LA57 values to MSRs and bases
      https://github.com/kvm-x86/kvm-unit-tests/commit/f6257e242a52
[6/6] nVMX: add a test for canonical checks of various host state vmcs12 fields.
      https://github.com/kvm-x86/kvm-unit-tests/commit/05fbb364b5b2

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

