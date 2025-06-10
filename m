Return-Path: <kvm+bounces-48860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FBBAD4310
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080941659EB
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBD2264A60;
	Tue, 10 Jun 2025 19:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wzdwIla2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9637242D7F
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584614; cv=none; b=Yhn0aVAUjbyu+62GU9IymaWjgeXmoKFH3fYCmOPEU/cMqa4JrCtajJHW1eg/6ftqdh+mW/Me2ss6T4tN1fCukx33pcNdIh9SaWeEQ3TRqdVKrxSf5RXj16pGCCvM73eHw25TNP1CvDb+6ZC9X53KhlFWqEX+NAC2/FTmWeNHkFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584614; c=relaxed/simple;
	bh=MkTuENY1wVP9or+KsTS12DhuzDMBgmYjk4Khd8QXHA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HlKvvydiOJcOs46SWXWmn4+9xpe6QNW0lFoFuxd2505CPu9FRwWPYpwpYa49h7kIW7Cl7lTvNpBLUThuduE1y/JjZrmd+FJXNr5BpR2luSxrAvZbhTgCNxBwmCnuN+lZW50UTowSosTDEu3FG2xANWwCMCWITppWItYZ7+8/1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wzdwIla2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74299055c3dso8303335b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584612; x=1750189412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6CQorN76OIQj4osGntkYZy402/zfOfJf9GRPA4sgzY0=;
        b=wzdwIla2kIc5BNGeUe+B84CFrTQGQE/TtjDUFq61SDeE4Ojs4e6cPinCmorGjuI5/d
         G8rLW/SMr4pn4J6zHScDO4m7XpTm07aluAnJXhqggRkb+rsAEh4RjKmcJIP3rqOTqYOj
         hORPOX7why5axS9Ntzc5ULrZ4pIAfeGA6UmHNiJPSkkj4KIGTOzKEfLjqJMdw+KZu5ub
         uDfARS9cxBhlJ1UrfZf2WTx+fwDG3I/5fmZKICPkCvg7b7IeTbXo1wgYNrFj7TuMkGJn
         piDaDP8Cp7V2hgIi1dOOB+D55NuwXtf00lYAf/tJ+Q5PrCH/JXg5959iTaEv6jrSE2d+
         w35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584612; x=1750189412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6CQorN76OIQj4osGntkYZy402/zfOfJf9GRPA4sgzY0=;
        b=UP/+JfBukl0+uJBWYzsaogegc87t717l6VujxK87NVg/M6Xf7tfzAIINSG6poliYtI
         yfMi/fnnvbRe1RGyfnN9oyvyugHk78BXCsNS3Hf+s7bBe20VtPzYA72Lv/vQMPS9Mj/m
         zuzI5UgPWWlmbfTZzUDpuY1cXr8NP69G9AFrnfTXTkoLOjcL6aK7WXvXe82yvBG9Fw/b
         52pAou+yinPad/xq6OAk+auK/WJ6SiR1xKllPInVT57AupmFjeCCWMf2P9nCqClRSIgs
         YUMaDDWdZjnJL6BRhz8vXWGBYysZVQWpYVhaONu9pMtp4r0fO+aVAtR2AXHvNuH+lXW4
         gvDw==
X-Gm-Message-State: AOJu0Yw3wT80KMHTRyX9DgQHLkO5YG5m6GbKxJyu3BThJli+WMPtqiPP
	9c+ah7ni/R18RwzzYcwb7b0SwDid9CQ7X4UBJnmjNJMPoiMVEp7DtSwBwy9zAWGadw+d/C4J77C
	g/uyPSQ==
X-Google-Smtp-Source: AGHT+IGWnVTk3Ao0CDTpm9Z9sgV3XxvtAm+fdllv2SyvDzEnXTOeE4poONnlSmOWpcVz3So8+16nRYyomjQ=
X-Received: from pfoo19.prod.google.com ([2002:a05:6a00:1a13:b0:748:4f7c:c605])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f8b:b0:742:b3a6:db09
 with SMTP id d2e1a72fcca58-7486ce16070mr849276b3a.16.1749584612030; Tue, 10
 Jun 2025 12:43:32 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:28 -0700
In-Reply-To: <20250604000812.199087-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604000812.199087-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958176603.104273.16656461633654215133.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Delete split IRQ chip variants of
 apic and ioapic tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Tue, 03 Jun 2025 17:08:12 -0700, Sean Christopherson wrote:
> Remove the dedicated {io,}apic-split testcases and instead rely on users
> to run KVM-Unit-Tests with ACCEL="kvm,kernel_irqchip=split" to provide the
> desired coverage.
> 
> While providing more coverage by "default" is nice, the flip side of doing
> so is that makes it annoying for an end user to do more, and gives the
> false impression that the configurations in unittests.cfg are the only
> configurations worth testing.
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86: Delete split IRQ chip variants of apic and ioapic tests
      https://github.com/kvm-x86/kvm-unit-tests/commit/0293b912a7e7

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

