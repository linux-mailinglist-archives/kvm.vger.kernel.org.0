Return-Path: <kvm+bounces-36681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2832CA1DCF3
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:52:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8768E16302C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E52194C75;
	Mon, 27 Jan 2025 19:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KJCGJjmf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3B5191493
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007545; cv=none; b=gJcfnkSlxprVlOX+kWUfLMmi/35J4EPg0fWsHn0wjczXIDFB5wCL3u9ShuZ9NEUiI2ltwcZbaoRku0kxwZ3t0DCaihFauOVCWMZEjfHHYzEZWWrMEHfltQhWIIZDfyDDrBjFlXk0wzo9gsk7yw+xir9IrmZ6qMvBUX1yq1yy00g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007545; c=relaxed/simple;
	bh=T/lDH8onXaTd4hE2T1c4b9BDZFr335e0GF/WactCQsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LHTzWCEcLHLtW2lduDQ3gJqSDcEK/c5jsw5YbwrJ0fTuB/GuYaYJ0Q1ho2I6AZhAdOkheyBsbFDqPWbyMtcu3KBO3waUME/20Z1WnbgIqKiyR1eF6/7+B/VpNMf4SyGgLLrMPvXevma7ez2YqjT/bTk+Cadul3Gk7ONpghq6C6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KJCGJjmf; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e3c9ec344efso6612482276.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007542; x=1738612342; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAlAWoS1eVtgpl/I4yrXq/l60p6VUiVXDguy9/Tsa/g=;
        b=KJCGJjmf2M8//GDNfMcEhKlJ4KBWNYntvAvnbxqDlrRjYRToX3e1nxbRc/ZHkAOjDW
         DlmUe3BRFf5olfkGp7v/rrATyo9+TSXtxc4WRFNH8iecdalo4BSoFWf61iLVT+bVCsFO
         WYMTNSkF0cBiKboFr2vWhLfQg2X4hT8xCw+E+0hezZ1H6Ks6FGW2TpsQUrZdfsk3cqUB
         f4InSmloVAOqd4p5PnztDSOpUTEmL39tik6U2VYJt9KWbERp/l/VsJ7PcH4R6P/ozrf5
         6uDhM4uSdgYAnMZK+iz30D21lopxa3miwOkZHAAaNsh55+4bmFuaEoYpSMIx2uDrk2mI
         O5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007542; x=1738612342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAlAWoS1eVtgpl/I4yrXq/l60p6VUiVXDguy9/Tsa/g=;
        b=nFmyvWM3XkOS5VP789eMNOq62rPjHIaDotYD0AN+Fy8CrZRdK0byFE/FzTT/OVgzeB
         EzHIK+Bi9OBhGk/TVT5JSiPUn9WRGQopZAoHgCjtBHMx85nViQ+JFlRniAN7F9OMYYLv
         1DIvXAVGXA1xpPryUVjWD5VIhLCodBd2K46hJcycgpNfvH9nlr5HYjJaSYkJtrUC91Rt
         6YnPhT/hyppxvubGhxugiQ7CKb7uuBOd2H6iajcrLh2z94EK06A7avQ0gpbGIspxaaeb
         qkiQvoOCu8NL5uATRIgMh8JldHpP/o8e2TYSi9LpmLPiMyKN6PXX9xWO8qQLiiFu6Mm1
         2HBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrskuQUvak0m85j7U8byEppiYcrkcWDIl9b27cBgrhDhGP9i+BmM6EHGLfu2m7dWyvjFo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztcfx3nQEWj6oDasUk99+/LQAv8LNXF7jjlAd6WQvBZuksEZkj
	cn45qO1N/Gqv29BKM/2mII5G0bWKKzDvYyY++BIApKukbUxlYeqL8aj4BBbzmIlN2013BB4jvfj
	KN0zztRJOksyRHbCaL7QFLRUThNXmnyqlwztT
X-Gm-Gg: ASbGncv+PBOIPlQZCoE4tVqpz6aWgZUduYKPlsc9bcq4zxyK9/eI1Xw2k9xECb2+DcE
	Fac3S60GzxP0YI1VXE1RqRyywXguoTEEbGwaqWT8HnlC/0U0N3tIq8eXQ1T4swo3tJwPcQJ9yG7
	gPUIWYMo/2isADVeqJ
X-Google-Smtp-Source: AGHT+IH+PAXvGz9qT1ltmFxlNybU5xS79sDI1GfpuNSf0wc37XJ/UQOkaSZ6t4n/IyNuV/QGrvCOzkK0plAZCCM/WXo=
X-Received: by 2002:a05:690c:4983:b0:6f6:d40a:5dfb with SMTP id
 00721157ae682-6f6eb942d37mr309490207b3.38.1738007542327; Mon, 27 Jan 2025
 11:52:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-4-jthoughton@google.com> <Z4GgXNRUi3Hxv0mq@google.com>
In-Reply-To: <Z4GgXNRUi3Hxv0mq@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:51:46 -0800
X-Gm-Features: AWEUYZkIoQLnU-qj6sj85NV-VQRE8VkasYEXEu5mlyAHtzVNaV6vNWbxI_zNobk
Message-ID: <CADrL8HUVD=0EZszqp4zzKXVCpm8tjTmy30+LiJR2nMcC-8PO9w@mail.gmail.com>
Subject: Re: [PATCH v8 03/11] KVM: x86/mmu: Factor out spte atomic bit
 clearing routine
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 2:34=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
> > follow-up patch to enable lockless Accessed and R/W/X bit clearing.
>
> This is a lie.  tdp_mmu_clear_spte_bits_atomic() can only be used to clea=
r the
> Accessed bit, clearing RWX bits for access-tracked SPTEs *must* be done w=
ith a
> CMPXCHG so that the original RWX protections are preserved.

I'm not sure why I wrote it like that. I've dropped the "and R/W/X" piece:

    This new function, tdp_mmu_clear_spte_bits_atomic(), will be used in a
    follow-up patch to enable lockless Accessed bit clearing.

