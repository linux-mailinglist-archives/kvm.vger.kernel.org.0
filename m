Return-Path: <kvm+bounces-43668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B74FA93A8A
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 18:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CA069212CD
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 16:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46D521ABDE;
	Fri, 18 Apr 2025 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OFoSb3o4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DFE2153FE
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744992825; cv=none; b=V1dXQG73eyVp9a8QFVn4Gkfl3vfKrygTxUpjMatmy+N8eNFEsJ86eolCipt5D0phtMdXOcotinn+ABPKYDXVMu1qgCajTCMG+ltngH0SudTq8EJz22+Fb8YJgQKkYauIVqz5AufK2HWzA6PxMl4Y2L0uEEyaBFbroAcjVZExknY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744992825; c=relaxed/simple;
	bh=PFsVeDzfjNXpckvVtRZ9aDuOFct7fDdGwwko3GzCdks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iO+A2Gyr/3VlGdCd6yWfuIR2oMaqcF+kwCb3wWuchrYm1EDnOxbCx8m/wS0PyC322/+ABRz+60U0/t3+ieEj6bUWI2VyAPBTBW/cqcTJ7L+10LthoCzfHxPaYNkYYUDFO4bFzAvWuWSYmrZp0KXvbjb8vEcVfw9xlSM7FG2JWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OFoSb3o4; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e61da95244so3407662a12.2
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1744992820; x=1745597620; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DjKOuF0LawJr9MXck81w1cjBR7uD0wLAWY1r0WgV90U=;
        b=OFoSb3o4Ve0ofXZ7S8YE2AZpJaQzcYrhAZyVdzdPunXhobOO/QGZcNsRV1vzAMHW/0
         wHkqnyZ8so13DRb9B/zOkLszMhomswobeEY/v6lc0AHaL9pUZojoq+EQ56t+mfvcuF0i
         zKy+wfIgAor/exJSWeSlhz0Wqfs/OgFIKSp2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744992820; x=1745597620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DjKOuF0LawJr9MXck81w1cjBR7uD0wLAWY1r0WgV90U=;
        b=qncYwTL8u4CU6HI9rFvqMFBpLUfIJKj0SH0TEQzytOZLh0Z1ckSayJlLWx0TqOzm1q
         gOgYE8coIXTKH6KvnKLAFeQX4g0GUbPOROn6j+JaQcgGAQrHkS8CbyBImo+pfNy1Elvv
         K/tB89bxswalnVuZsq5jJrAy+SeGFHYsqG0XcMHDL0WAeyZArjKoV4xWbZiySWMUBKgS
         AR3TjH7UKeL4lc6AVybBbFggNh2CLqzD0HhRQOkp20/iz/4iKsqoVz6BMiOBLR/LWn6U
         wGB+P6jpFW/2/5y1yK26Yui+NCT8pRa8C70jGDrLFidbfNapkdA3eWvwQh+BSg9l5GKF
         VDaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhIcbcc3b5Av9YuNB8JnARYw3IzzFLrgBhxLcNwWDn8iJlqFNF+b5aRk+jjp9jSRZ4FTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFROLKiZpvZ8mYUGOHIf1kB3Mba8NVYc4jjgwlZ4hzedWgRY9i
	cE+WsROBkud/Vvfs7EIcoOXxp9spKxMVCagVwdv9lemXTq5fk6xgX9i2UOEBXr5wztU33BxeHOh
	yDm8=
X-Gm-Gg: ASbGncumVSou4SkHuKZ9jkbrQPEygKLf43bwv8i8+ewOc9Y8qDVLkxfWRuI3wA8nWrW
	tsBFELiNsuCSDvvppMzjSZRMXdNshC8KC5wkA8y6Fyl8CxGbJy3bV/nu+LUl2pRHYBpdAW4KrBZ
	7d8sgRkotvJ+2v0DV+MakiDxCO7Bj6PulY19Cjk2yT2XxU7AYsvAl2rMU7JZaVV54SASIyBmcQX
	JR7vHwRJDMM4+0TrpEFVbuV6PPBoQM08yeCWYDoW3Y06KM4E28okl3gUR8r7Fe1gARSPLdWvkFR
	zPvWGrIgCB1dvVJbgzd/SUz55KNWlZ+3fNTeTwhHIXvOMEM4omxsOBBsrQiYpMj8vyOIvYraTbz
	Ez/m42S666Dp9GQg=
X-Google-Smtp-Source: AGHT+IG8p2BNzG5CKC0TBgpfycdvEPhCv6X9Oc2beSP0ETvHqoZ3dvzjw/KQm2Dm0s0WFlbO6JxbZA==
X-Received: by 2002:a05:6402:84c:b0:5ed:4181:b03e with SMTP id 4fb4d7f45d1cf-5f628535045mr2401446a12.14.1744992820478;
        Fri, 18 Apr 2025 09:13:40 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625596138sm1180763a12.45.2025.04.18.09.13.39
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 09:13:40 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abbd96bef64so325454766b.3
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 09:13:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVdsKTC8e0kPnFDkctt7Hcec8MADH2lCBj2huL28Tk6QisvO4psbsmdqDg4SwZ8WNbwHuc=@vger.kernel.org
X-Received: by 2002:a17:906:c10b:b0:acb:6081:14ec with SMTP id
 a640c23a62f3a-acb74e8da8amr303015066b.61.1744992819058; Fri, 18 Apr 2025
 09:13:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250418130644.227320-1-pbonzini@redhat.com>
In-Reply-To: <20250418130644.227320-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Apr 2025 09:13:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg8VBjy=yrDUmFnvBKdo6eKNab6C=+FNjNZhX=z25QBpw@mail.gmail.com>
X-Gm-Features: ATxdqUERjeqMmefrjujlpH9FygUlViVaOKvtbBM9Be9kRonBwkP0R52Gxhjg25A
Message-ID: <CAHk-=wg8VBjy=yrDUmFnvBKdo6eKNab6C=+FNjNZhX=z25QBpw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.15-rc3
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Apr 2025 at 06:06, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

I pulled this, but then I unpulled it, because this doesn't work for
me AT ALL. I get

   ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko]
undefined!

when building it. I assume it's due to the change in commit
73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is
disabled") but didn't check any closer.

I think it's literally just because that symbol isn't exported, but I
also suspect that the *right* fix is to make that function be an
inline function that doesn't *need* to be exported.

So I'm not going to add the trivial EXPORT_SYMBOL_GPL() line, since I
suspect the real fix is different.

               Linus

