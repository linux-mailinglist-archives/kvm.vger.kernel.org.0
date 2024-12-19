Return-Path: <kvm+bounces-34105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC319F72DB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0236E188B1E9
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069C619D070;
	Thu, 19 Dec 2024 02:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSUMewXS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D326919C578
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576166; cv=none; b=LT+VEybGamPfBORjkOWz6q36f0kqFDNfZhZJ1iv6VRnFsnPghUv6fLrFXSgjTuoky7bPp+3HLaXesAoxoz2/Dn5YpX2S6fenQbNUo4P0bBeYHatukq4jJqtXLb7KSyn8q7uVwha6i3sWLiQ9egA7Vgc6xsyElczamF5JE9Pbg/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576166; c=relaxed/simple;
	bh=Ow+XQIFONE++dFaRdXSVqCnFN+5Ly/hPoUmrK42qwQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XKg8HWVodNZfjgDRaJ5ols7INfOw6WD+YdOtY+wFkeyxrJ3IJmHXMUgi02awVA24CilgcliHpJV4J+3Pdmx2pJqiWhGe4zB3HzTXqmEr3K6KvGF/RB5MBtxC5spIu7HJBF+fL/MpC10gbFbg5qtM+ZmDNVyDptbY/lkLkYkVreQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSUMewXS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso438959a91.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576164; x=1735180964; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpgQ7c/gh9pTvPo1fv6avyHn2AMQRIWRGPo+ny66dNA=;
        b=cSUMewXShGTPV/u5zYZGNSRWvpb9GHgfYWj+9YBRwvWyKdjUbWh7Ecs+KI7KPNVfTA
         8/ZJl3KIvEmDPfWC7zLBqLCUZaHdmpM6CooXZGNP77hFYa3RKzfxIfbeFfrLKe0mEMKq
         iAvEJWZkB1UMlgmqdqKhyvEYK6lQBIUHq9+cB30y+M9PX6EiTw+5PeIsNv1BUiNP+9qV
         Pm7zbenkVlzpqx5tQ/53gukeFAmqxQR25DmCsB3SkkADagK8nyqFmN95xa0WohfFgU2J
         CKjAPowfVXU8YvCNC6l71lvkaKa4pyGdH36n5T7vWmUHP0M3OYxJuUbugcqOy5GSLJsq
         G5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576164; x=1735180964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpgQ7c/gh9pTvPo1fv6avyHn2AMQRIWRGPo+ny66dNA=;
        b=ANzwGjqTEM1VRACjO0tt3PVYZs3tU7uhaB3c1fXB++hA9DOhCaDXdmdVTik2PjdiME
         jBspvIPfN/m9ryMPLyIKMYN31nfsCQEBRtFUoTUg3gt6rDqs1FHvNnRBPPPEzMXSoO12
         2qlaVNX1NM9rS5Nlh2GSBxiAiUjQe8/ldi9zUyKWWaxGaGtYYUlpOYLfTNtJ9DEuMGOR
         kmGScDrmDnP70SUQsYBE99Zwb4xaGm4DkVEHRxV7dgfpfL5uYiCSxCpSM2cLXOomqjEX
         2Fbfs2ZSuJYEAP7EqBAzkc3Gob2pEwTq59hZK236K5lTjWVKWOsY4LbRTAphOYwf2OF0
         YZQg==
X-Gm-Message-State: AOJu0YzBMriXhsM7920F4m+IE+DlnIMYwAlQquVjHG9dqQ/naoytP84D
	+XYN3kRdma8IfHfV+Gb5Ch9o+AknJiU3NMaXh4UKdW9jGqTLXLqV+6UdC2WLYi2HQ/osGS66of1
	rIg==
X-Google-Smtp-Source: AGHT+IFZeQS1NSGNlM06VusjOeMOEVgvUbj/YdOLiMA/d7yhaud9CJY++nh9sZ9f2BQkJqhxkv+HyxqKa4w=
X-Received: from pjch10.prod.google.com ([2002:a17:90a:3d0a:b0:2f2:e933:8ba6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540d:b0:2ee:c9b6:c266
 with SMTP id 98e67ed59e1d1-2f2e91d6a12mr7103266a91.13.1734576164230; Wed, 18
 Dec 2024 18:42:44 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:54 -0800
In-Reply-To: <20241127234659.4046347-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127234659.4046347-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457545920.3294890.15735431566312816303.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Macrofy SEV=n versions of sev_xxx_guest()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Nov 2024 15:46:59 -0800, Sean Christopherson wrote:
> Define sev_{,es_,snp_}guest() as "false" when SEV is disabled via Kconfig,
> i.e. when CONFIG_KVM_AMD_SEV=n.  Despite the helpers being __always_inline,
> gcc-12 is somehow incapable of realizing that the return value is a
> compile-time constant and generates sub-optimal code.
> 
> Opportunistically clump the paths together to reduce the amount of
> ifdeffery.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Macrofy SEV=n versions of sev_xxx_guest()
      https://github.com/kvm-x86/linux/commit/45d522d3ee9c

--
https://github.com/kvm-x86/linux/tree/next

