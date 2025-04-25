Return-Path: <kvm+bounces-44367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2955BA9D559
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA1019E0CE2
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D74290BB2;
	Fri, 25 Apr 2025 22:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CYjeMmdr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D928FFF9
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745619527; cv=none; b=WV+YaM37RgO4k1GD3rZ8sWddgvJfiXhQ5alf3o/Ejrq6yumVNvvlnqfv8NLIvci6Lppl66+U7JSYJBzJ36YCTP+aT+rxwEHKj1+BBTBpixhgw4S46K27RktZDgSRzV2kXw0kpiJo2q2CZwcrpIRANqMxprP8VeVjFE/mF5zvQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745619527; c=relaxed/simple;
	bh=79khmCilj28Bw9iPJB9I+5VFOyP4giXQADVnconMfmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=guF/kN0S8L0E4ZGg9Wj8s4oHAn4/ZDTLMriovmoqWjR0DWkUzPhDK5O5H9CCBcsRe12S1435tPG3l7NMKxjbI4HvuJqfrm5EH4GU6Clg/HnaM/sGMEieRpWqwAuG7BOad6yPi2P0p2qjWjEGJL+/JRkMNXxhPk0H4y4wQDSUmF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CYjeMmdr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff78dd28ecso3012606a91.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745619526; x=1746224326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c79mghSvLDh48/eN+ylfXjUf7C+oTHXfrsGjYdtgeRg=;
        b=CYjeMmdr8lehepE+fLbIZl0kNZ3l8QV5Yylym2ib8nZxTbGJVqs8MpCai/rR+6ohGK
         3wN/tJ/gmP5r3UoqPpEZs8Jz8YH1qojPr63k1d8DhV5uXJ/bzuQZVcjLB6gWwupn/V9T
         V9IGDPtRsFLzzv1cU811r7awOy8Puzby0muOMBm65ZGHGStpa1hhg7YkchKkf5mWijGE
         sJ7Oxr7KyJM+eKXnuuobWZUxD9QirYwAhRt+dztMes44Grd1403YlgHpBARD/3py9dwQ
         mS1uvcEZOJQ/yWcfSPPYVlYtuI3usT5NxSRTPtAvxM3xRE3doXvtFqEeDXldWNhGy2E1
         HjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745619526; x=1746224326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c79mghSvLDh48/eN+ylfXjUf7C+oTHXfrsGjYdtgeRg=;
        b=VX18j5qoSS0GwcXGb/6gnR5Hl74dbgi/fL73gt5EhqKK9E/3RTy+QvFJikbmllEF+A
         /WqbHsfS3bG8ajtQYhgS1v61YTBfuOZNCyVoFlz2+MD5+rpDFKK39pTW/xhnXwoVYT1/
         jvNLmQCU+Afwk0w0VE3uL7kft4nEJeGmFQ//FY8qlkQ1wsWkYykzlvFCqVsRi5Bbo5NE
         qRwqoiChLFsb2rK45Hmype6He6HZcRplNmIcdiL153Qnq7w3Dt0asuj80KzUOAs1egVg
         KfWIbxXJ1WkLb62e3mztS2gI5hjeuz53oHpn27fvzusv2eq3k52MK+vex74WWY+tYdfS
         fC2w==
X-Forwarded-Encrypted: i=1; AJvYcCWRKxe0Fipwla10Et5GGG8gLRM/knXswkq27DMfVeJfsX0n0h/nbvLMIz0Fu+p1cNPuBYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ77rMg87G5ydhKkEj89y2reoGYryjFelntdzK9Hju0op7gsuI
	HpskSnakFvL9S6u+wKQtX7v3KjuP90eSI2S5wTQc6XRzN9WSouqNtUWYtrkv10qHDDOm7eGN9Uy
	LSg==
X-Google-Smtp-Source: AGHT+IFAchsJLO7/uMp7rAAyJLviGsYQWW/6iJZ/bglJ7sMum2UgV5vjC+rx1FqdI0bNNfPq3hywGuT2vOo=
X-Received: from pjbee16.prod.google.com ([2002:a17:90a:fc50:b0:301:1ea9:63b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2705:b0:2f9:cf97:56a6
 with SMTP id 98e67ed59e1d1-30a01329418mr1651850a91.14.1745619525691; Fri, 25
 Apr 2025 15:18:45 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:09:04 -0700
In-Reply-To: <7604cbbf-15e6-45a8-afec-cf5be46c2924@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7604cbbf-15e6-45a8-afec-cf5be46c2924@stanley.mountain>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559676107.891772.3803946137571196074.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: clean up a return
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Dan Carpenter <dan.carpenter@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Mar 2025 13:53:39 +0300, Dan Carpenter wrote:
> Returning a literal X86EMUL_CONTINUE is slightly clearer than returning
> rc.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: clean up a return
      commit: f804dc6aa20f2ce504456ffbaafc95db646c211b

--
https://github.com/kvm-x86/linux/tree/next

