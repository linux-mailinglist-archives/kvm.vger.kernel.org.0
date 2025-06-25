Return-Path: <kvm+bounces-50757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6370AAE9107
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD6DB17FDD4
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308772F3C03;
	Wed, 25 Jun 2025 22:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zcL/OVtw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0128D2F3636
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890377; cv=none; b=aWcLoTCbBymVMVoohUwsbCy/KZARlO7qneKoJG+a7Wtag1VDLGXa4OjxJ0bkt70MBOaDu4MI2r7/4OLKIyxO3OrGmoG6JbCu8CL/RlJEEl67Q95muHzx5I+OtsQ5210VOFfdXh73HEyMgYLvqJEgrTEkOdfB9B2K0vZ4ziLp7Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890377; c=relaxed/simple;
	bh=+E8EpWppY5+z5Zzf48g8XA+vg9TjHKzBWwqNlo6Zjq0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MjcVLoXBiwNTtOtQeGnl6gFroFawBy/Y4pTmzMcoF+pVQ5US6/m7UMLT9SqfBLzMTxrAvfc5ZqSt3pKb57m8SZ3ZPtHZXG9sv2lLgmbMtVDajQzbCC01bhrr0sKpygYj5CCYVkIvgr+RZvmO5DsrkxeFCmIW2tGH5F0f2Y6ysLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zcL/OVtw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d346dc8dso291054a91.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890375; x=1751495175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5P0C0ay1sg6VzBmBVHnNwzZiHo9BP6seWcPK5go4PNI=;
        b=zcL/OVtw27M3cM+KpQ9SDGGPI1shnJz8YMXM9D4vdcKSjFyiJhdqR+bkg42y3g1uPa
         7oq8VBnXyrBR+3hjdeS0U+YfG+KCvoZJiNnmLwAvG97jfaYw44jpQOf+gE9PDZDsFDnD
         AbHkRNn/Zip+5KZhhkupaTdT9YDMVxMe9ghWNyfTsy+ED9f9ttEqV/iQ0Hba90d4JNt3
         j3UBYwjCUg6wczoaHmKwJLmpIwie5P5mT3Z6EZhzBz7bR+dRxtOsuALXZibVs2MWTt82
         59Ss2jwt1RS+bGG8w67QQCwQjyqj1RtBmIpFTfqsBX4it+hWo2zZEA9jXLCHkf8oEdYZ
         zKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890375; x=1751495175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5P0C0ay1sg6VzBmBVHnNwzZiHo9BP6seWcPK5go4PNI=;
        b=ChVqXajna+1xelB5Vuv3BJxL3KCrnm8bXrACsz9bsJYdCCcm59ddRitAilEPkgaXFq
         dm0lhfb4BE4/1qg8wKlWd3ghl8Ge9moug/ISOZ9UxW2UEQEMY9ssmOozOLyB623ReX5D
         rt218nYhAVRAPi7u5OkOw5RhEG7GTiX4TKCmXjC71wHWpvqfKVhBw0pKrpdlTV7krmkL
         uAT2YJvXgXi3Y0MX66lcTWYVGaPKzDmXjK35nwTg7SckA9Xucn/3fkIK6fTEFUWExWrm
         aLAIX4/q4BdLk+1E0Mwq3+gzsKT/2CpQPuFk4cZf2ngKz5/ytN0DtUKhMDCnsLq3SRB2
         q+RQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYfF6YSpHpi/MQ5AIPc4d7PncP4nTXAkp+bsFC5zeu0Ajgv/Zmm1itynQJIo8ZgAXrsMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDYyfp8o4xkHSrMZdJgG6PMqEmQrauBIIzUdr1F/x/YmaInf/d
	FhxpN69AFFq59ownfSReoQw0I59Yn0AhaFjmdQq8VJ5rbRDdgLrI/6UWva4AJZBtunm1syyc0Mg
	MqVoE/A==
X-Google-Smtp-Source: AGHT+IH1teFPxnZYyI+Zl9dnd3n0vbjMm6JT635LpkcUQ5aBNQq4BJwtfTJcGPRDPWWcdL2cdyw4AEW8xkI=
X-Received: from pjbta14.prod.google.com ([2002:a17:90b:4ece:b0:311:ea2a:3919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574e:b0:311:e8cc:4253
 with SMTP id 98e67ed59e1d1-315f25ce932mr6982074a91.2.1750890375324; Wed, 25
 Jun 2025 15:26:15 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:29 -0700
In-Reply-To: <c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088956523.720749.10160134537876951534.b4-ty@google.com>
Subject: Re: [PATCH] x86/hyper-v: Filter non-canonical addresses passed via HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST(_EX)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Manuel Andreas <manuel.andreas@tum.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"

On Wed, 25 Jun 2025 15:53:19 +0200, Manuel Andreas wrote:
> In KVM guests with Hyper-V hypercalls enabled, the hypercalls
> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX
> allow a guest to request invalidation of portions of a virtual TLB.
> For this, the hypercall parameter includes a list of GVAs that are supposed
> to be invalidated.
> 
> However, when non-canonical GVAs are passed, there is currently no
> filtering in place and they are eventually passed to checked invocations of
> INVVPID on Intel / INVLPGA on AMD.
> While the AMD variant (INVLPGA) will silently ignore the non-canonical
> address and perform a no-op, the Intel variant (INVVPID) will fail and end
> up in invvpid_error, where a WARN_ONCE is triggered:
> 
> [...]

Applied to kvm-x86 fixes, with a massaged changelog, e.g. to call out that
"real" Hyper-V behaves this way.  Thanks!

[1/1] x86/hyper-v: Filter non-canonical addresses passed via HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST(_EX)
      https://github.com/kvm-x86/linux/commit/fa787ac07b3c

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

