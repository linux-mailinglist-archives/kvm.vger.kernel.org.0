Return-Path: <kvm+bounces-39778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E706A4A6B1
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D38E189C3F9
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF8A1E130F;
	Fri, 28 Feb 2025 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ivm9Ihjw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E311DF733
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740786084; cv=none; b=fQTp5LocU6ImjnQiIMTtSD7ogwOUCevSq8Q0ho1I/wX710ZAtpj7S9cKCnuMszDjWh760mFONo6HdpBNgF5e49lsD4nZ2G/m2SobNn3cmSPUeD0ur04QCFFQ8HTQkfZSe+gl3k7jXOnuskTWl16uMy5ptvlXBvrJ8Lc52BnTdzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740786084; c=relaxed/simple;
	bh=QENiV6uJu3bB8hqG+D80jQNvN6gBBlGloxAvMhM4jks=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XAoPmD5OmM9m3FvhlUjvq1McL/3oLM5VnVGJ4pC91MOIg3/+D0BIdQjcAurMiS8O6xfbh+ZnSLhiXTyIdEZMuXerSBz7MQKTvMNbT1alsC1UN7sJxmLhcPZk2/2faOQxlwFettJmZQolQ0wz2+C5L/FMIvbc1KcizMWU2zxC6jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ivm9Ihjw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso8946632a91.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 15:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740786082; x=1741390882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AwvW0pYFe7VhV+MrYDyqY+sCQ8qL3/J9vUbBaNF7s4A=;
        b=ivm9IhjwhDlaLcvGeJq0IJvs4DUumwvdLRHVOgF2uUXp2YFFj0QkuHCuta9g3CfkwP
         HdTpEgd5bVCJfXJK3tshK2wvUbNeWKjLHAkNv2lIDIp7m6O/R0BwQbf2YhUQBWQpy/Kb
         RBW6V+mZsoWsnPK3WabrawEomCWlaeGjSn6YwCA6F6aXCiKEwY+tw6r9lTE7Xp6Mv5us
         ipbOTlGYr+yR5+B9EF4hN/A0KJ2+qTzSwWhD8tx2oxqWPO/Dmjh69edJHlPcMhiwfQFz
         xsbLPu4OnNVLSJ8V/V9EPb+fyOL4rNPJ0nLhG+Syzg7PMQGk6+5YG0WrVLEUSfqTsOUE
         vQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740786082; x=1741390882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AwvW0pYFe7VhV+MrYDyqY+sCQ8qL3/J9vUbBaNF7s4A=;
        b=BSeAfZjCHlJbglPbY6aMtu/Nq23LvCfjvo9Quu+3ecm28voELmXEKbT1dFvE4dOjsq
         L9Wi/UKxJZOCwVitszTjrl7aAFZYiDhYE5PCdnRmE6gVkd4d3mmklDbJeNq0CO/4aCao
         kDgVtei/vMlS28Z7jdifHDJNGv5KFYnlvIiIUuTCam+EEVztWnv/i85ZOnXSfAmOG57i
         zNEBkj8X6fgg4NHndRw8VNwfuTSUGgfEfYhfuo8MxGGg6p5kqxOyX18wHTOFYglv93ba
         C5SquXp9MTknVLHF9reHLUUBai+7bUJqlXLAoctHtZETtpmSmbPq8tDpZSxZt2rps1Gg
         KOVQ==
X-Gm-Message-State: AOJu0YzMS21UOGDBR/TuUVZrLFUjAHMR6lH5AkTbcZloMdDW0Gh3K7tQ
	+xbEz9vqYI8wI9440s5lwLtV9+YqYY8/vVjkQUMmNWVeKgQ2J0W2mq76FN9K/Q5nhG5/8tJOQ4p
	+1A==
X-Google-Smtp-Source: AGHT+IGeEvuYcudRjehe/5NlNRZtexUVlBrm2eArt4lglUI3UvicdV6S0d0UrxLJPGNGhfkh6MWcmALP0kA=
X-Received: from pjbsu3.prod.google.com ([2002:a17:90b:5343:b0:2fa:284f:adb2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37cb:b0:2ee:dcf6:1c8f
 with SMTP id 98e67ed59e1d1-2febab75c98mr9732628a91.16.1740786082172; Fri, 28
 Feb 2025 15:41:22 -0800 (PST)
Date: Fri, 28 Feb 2025 15:40:36 -0800
In-Reply-To: <20250227000705.3199706-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227000705.3199706-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174076284903.3736676.15512557789337547717.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: VMX: Clean up EPT_VIOLATIONS_xxx #defines
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nikolay Borisov <nik.borisov@suse.com>, Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 26 Feb 2025 16:07:03 -0800, Sean Christopherson wrote:
> Nikolay's patch[v1] to drop the ACC_*_BIT defines, plus another patch to
> add proper defines for the protection bits instead of piggybacking the
> RWX EPT entry defines.
> 
> v1: https://lore.kernel.org/all/20250226074151.312588-1-nik.borisov@suse.com
> 
> Nikolay Borisov (1):
>   KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/2] KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
      https://github.com/kvm-x86/linux/commit/fa6c8fc2d267
[2/2] KVM: nVMX: Decouple EPT RWX bits from EPT Violation protection bits
      https://github.com/kvm-x86/linux/commit/61146f67e4cb

--
https://github.com/kvm-x86/linux/tree/next

