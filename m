Return-Path: <kvm+bounces-39019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8966DA4299B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ED0B188CAED
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8658B265CC5;
	Mon, 24 Feb 2025 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fee+uuYW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A986263F5E
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417932; cv=none; b=s1x6oy1//xlqaUx9qeJC2Oj1cl0ppg8YXeLMPVbZ0mxHtHFRe0i5TfDcgH60pi0dBCKz40uDUREV+s4hlM6D8hjoUmg/s9I3gfXQisbJ9+XE6j0gOw3SSLvxMIXUlvPgFTwRs+XiESw0cWs6u2tY4Es/WLLJz0fcmf1nWlvAuZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417932; c=relaxed/simple;
	bh=48i/OWjf+tl05HU9/gPSmnhTSHsAR5GSbVzc0xf3uec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Stvi2VBUMZ8VSOP4HG0XjeGRcHyJ9A0w0szP+UtgsTfNo4qf6x9TMgYGny9RbTTwxv9mP0LmDFPzOIF9+gpsUGAj5x74Z+FMliYEF0DooPMIN3KpmzBc6hdMVEcdBq7ZGiNh6KhWSGDIC8nQCBMLUSJcbnFUz8fdIjpIPC8Qj2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fee+uuYW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a70935fso9706492a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417930; x=1741022730; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S/rq07jdx+U5ZBovY8VVsd42WhNP7AQXFGUmrtyMkFY=;
        b=fee+uuYWGHTTENZHrRa1bMbwHy/3hyLCqzLr0CnaYh1G0H9csuENXKLFplfR30hug/
         UYJlJlVmsiLHNH6axkZ4WyIHc8fFqFCmTpN76xrIsANL2QyTCbhJ9ym9IVFtMbUbYZFJ
         SWVN+YpmJUgC0/SaN56XcR0Mgt96pR/5tLHsdaUDgSfgzbgGLMVNmzDfmkOU5wzSG1Bh
         FkhLSMruc+9o+M0QraUdZ+aGyS8mjMpsPiArDgFDmBSWYy7U5BwobKnoc1fsqdPqRPge
         JRzU2biqHWs3AN73ZNGhf7fb/FU0dMBortV0eZYjZOWb4ezoVNmAv0df3t0NJYDG1Pc2
         13dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417930; x=1741022730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/rq07jdx+U5ZBovY8VVsd42WhNP7AQXFGUmrtyMkFY=;
        b=MzW6Kb8jAsZibvIG2s0JeSnthlBB79GncWIPOFepeAcbXLCtVmCt2tR0ADfopIzpvC
         Elp5ziaebIWiW2v/WfVCOEW43LLbWY77uxXbTP6Ya81zHue75ArRXd6HXdLTLyGKuX8J
         KgrIdfnXL4Xvl2eyWAYFWhBCtJKVTr9QyMCjho1GlgOZ/KYbOEnm1L8x/m2em3DO4uwi
         0JWyV8O79Kh6BhY2aZSnCKUaESmMnf1F3pTKmJPZ6dmubQKWRi/S++6wV0MCyViMN2ZZ
         G+xqyG96LUROfQT0zNPWhRPK+0S+PLq5OHxdzRZqXjIZfcT6qJXFfO0dqf89oh5TLsHk
         tf7Q==
X-Gm-Message-State: AOJu0YwwQAUNMsuem7c/Nxcev6UebQR9u99KdHP1gxqU/Y3gyrjqe5q8
	iaUSaDu57GLV3oSXNWa1LVqJKpqEUrhdQ9kV+qGeBgdmms+OCa0iz417k/kjsVrnQOHg7bw7duj
	PLw==
X-Google-Smtp-Source: AGHT+IGFyjuJFKPp1AxmSMxd/pc2HtR149W9jP/duA/KXYtOh3YRIInJSxruYfNLMOPSuLL6W7NJCyjx1u4=
X-Received: from pjbov6.prod.google.com ([2002:a17:90b:2586:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c05:b0:2f4:434d:c7f0
 with SMTP id 98e67ed59e1d1-2fce78aec63mr26854671a91.12.1740417930706; Mon, 24
 Feb 2025 09:25:30 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:59 -0800
In-Reply-To: <20250215012032.1206409-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215012032.1206409-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041742469.2350615.11134832610092487562.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] x86: Bump per-CPU stack/data to 12KiB
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 17:20:29 -0800, Sean Christopherson wrote:
> Make the stacks and per-CPU data page aligned, and bump the total size to
> 12KiB to reduce the probability having to debug stack overflow insanity in
> the future.
> 
> Sean Christopherson (3):
>   x86: Make per-CPU stacks page-aligned
>   x86: Add a macro for the size of the per-CPU stack/data area
>   x86: Increase per-CPU stack/data area to 12KiB
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/3] x86: Make per-CPU stacks page-aligned
      https://github.com/kvm-x86/kvm-unit-tests/commit/a95dd6beeeb4
[2/3] x86: Add a macro for the size of the per-CPU stack/data area
      https://github.com/kvm-x86/kvm-unit-tests/commit/2821b32d627d
[3/3] x86: Increase per-CPU stack/data area to 12KiB
      https://github.com/kvm-x86/kvm-unit-tests/commit/b94ace2edb58

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

