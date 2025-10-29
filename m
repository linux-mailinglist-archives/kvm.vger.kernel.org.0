Return-Path: <kvm+bounces-61396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3054BC1B30C
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 15:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E9E31B2537E
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073F52BE62B;
	Wed, 29 Oct 2025 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="drVzyY8o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FD02BD5AD
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746309; cv=none; b=trj5jdAcPZvCpH598sZgk5pi/btLLoM1zjJ3zLWcUAjeVxxhGK3ehP5TFinvZnaLzVK3zQan+7s/3wUdp9OX6wmac0tpe71OdvlJNnJhX+G2tjmJ8Jl8sea8vdW3lrEOD7HzPncZ+MzUhivMhtBtxfw8vnV1+MySk+2YhGwBYFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746309; c=relaxed/simple;
	bh=R/lq99j+ak5lsZi4yIRf6mAh+n/OLHtTnfr7HlraIYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VSFjPCjsZzjuNq5G89fffulFOl1AZ65vYb8N7mbaYWIjJoShna1vZzst/V0yVRb7IrXX8FkDH0QgVRri1oEmrpRDKEoep6Ld+epRP8OEFCA8XFZtAVYiMVG/vTO3v0FBBBI/zn5YzCv/n/BRLWlOr0XbGj5usLwz7ISmYWe/crk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=drVzyY8o; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3403e994649so1170819a91.3
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 06:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761746307; x=1762351107; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/lq99j+ak5lsZi4yIRf6mAh+n/OLHtTnfr7HlraIYY=;
        b=drVzyY8olY+FNvS+4XWTwFBZTxfSUV6+VebOANp1aZMZefxUfl+Iv5tG1sh92/HQ/u
         21Kh+NrHe9AOJHeGHmvhg6dvNBm+C/S/FKbt03Z9tCMf9AFm4KhhPxbs0KlG6gT1zGsg
         xhB8gbh4g6PkIxhIGtPmbOZAqH4L4RxI8MyzGlmutNddyww/HKcsgr9ibfDT5LGDAV1F
         4AfEKExxue1LiK5MTp8spWXxfbNZfoNmCO1DZmwxA5ERENCfHEx2nwa+iQCSohQf9yMY
         UEyMOszx30uYes0tp87ZSJEINHwZbRNakd1UWHJTCnmKxZEleQcQv4g8EyDsXD7f4TN8
         YBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761746307; x=1762351107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/lq99j+ak5lsZi4yIRf6mAh+n/OLHtTnfr7HlraIYY=;
        b=edTeUsEeTQv9hjESQcKCoTUm9w7Gh4EhKK6l5XMsuNKUpGb4ZRdX7TSHbQnXMSicdg
         OGP0TvNvCLx8BErzm9bu8mwzD7LPM5R1T8IZTpKe31kuN04C9+tpaNhkmkgsQ+yujjoP
         zwT2EaqeFtdZg2R9usSli5umTDTQg22ALvQ/h/NeBK/K7lEbrcFF3ZmYo1zHt7dHGrKC
         AsYofeyRivR//OeolUwJrzQShQJEHGlsRaAO120qpk53cMrZnEo7gb+LHpmSb/eTNuUK
         5w0RjYWuBtvhRfplYrYQOv7BHcnKNbLicpLifS/irck6y7bd1QKQCt9HvEsV1ZREwJqT
         EqXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv4izp4bDHze3jtA2XFqZyFXLBHpQC0U+FHBAORCMmbsa/BgfQ7u12Vjhe3H4ZlyOcNLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7P04iY4qMHy1G65IJfEbKgJbM1SmbP8hz8DF9LqPdOhjP3Pvf
	OuZAroVOD9fHjYbm4HtsgmjjTYI/j2a6K+7TT94y442Ont8yo2btVjnGyUJBSWuTivtEF5qHG3x
	3RIEJdw==
X-Google-Smtp-Source: AGHT+IE4ksY6pWur34UQ3eqUueNMRdeUrWX1+T1bYF+4IbiUvAKUN7lFBP4zbkvFlAcsEQ+loPHbjQhy8Xo=
X-Received: from pjrv13.prod.google.com ([2002:a17:90a:bb8d:b0:33b:51fe:1a81])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:33e:1acc:1799
 with SMTP id 98e67ed59e1d1-3403a26606bmr3695621a91.14.1761746307070; Wed, 29
 Oct 2025 06:58:27 -0700 (PDT)
Date: Wed, 29 Oct 2025 06:58:25 -0700
In-Reply-To: <20251029055753.5742-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029055753.5742-1-nikunj@amd.com>
Message-ID: <aQIdgeaeQ0wzGUz7@google.com>
Subject: Re: [PATCH] KVM: SVM: Add module parameter to control SEV-SNP Secure
 TSC feature
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Nikunj A Dadhania wrote:
> Add a module parameter secure_tsc to allow control of the SEV-SNP Secure
> TSC feature at module load time, providing administrators with the ability
> to disable Secure TSC support even when the hardware and kernel support it.

Why?

