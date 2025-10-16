Return-Path: <kvm+bounces-60126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B45BE1EBE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 09:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2BBA4872B9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 07:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BEEE2FF65D;
	Thu, 16 Oct 2025 07:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZEvjNos+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1D52FDC54
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 07:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760599628; cv=none; b=tOskHy0dh5M5GWxNW6/L4TBqU9r1ClBUUp+1V5fC2t0b3vO8+FtUQga+Txqcu5CPzunsSyimzE7LXyotecfEMQt5aGAZdBnSNanXnHAWl+gmL/CgR9D082WuUkQqifyDHjMHswCpUHrzStNJfzrY3br3amLgQh3YFaod3x60JV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760599628; c=relaxed/simple;
	bh=m8f4zg6xeLykgRE/o/fcAo7BMndyvXR2pwRMu1iNPYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dkkNimaTeuUFeXJDX6nbnd2TutBL7mHVkcUQ4ASIvlDZBcvPOTFUPa74uX17dMvwF27ZefUp2N9i8hmRrNEsz2jPTsexWMHLwsgkHSEifh8omYtCt1jciCacRNXWHv+vHftclWU5ZP/zwo7cj0uzClvVVH1stDNLLUMZD9/axpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZEvjNos+; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-36a6a39752bso3199171fa.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 00:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760599623; x=1761204423; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQq6/C1Pq6mJ4glqaLVTk3qrn5Q0fPYc2F8kgQWkSeE=;
        b=ZEvjNos+VzpxgPgkgpMLaBOvAHFoI85SCbyqkzIOyHzCPAjaIP5DjwdL/XDtp+F1bw
         RWUMCvjHqwYdQlQSeCf2WM7dxTekKRuphfJFQd6lW9uDb8cQjIJpAAF03+r7xiW51QWP
         S93hlU5F/NrH77YHeJ4xt5l7rwzM7CJ5M59BBPQKdakciC8irCCPomAcOZyoOdevzIVH
         lkCP7jSpInP9eGpPLIL4HVHycqRdR+ld2CXs3iYXktUQTP/j4fVWzL52cj7EltwyZKu0
         QvUY2SbSlQz/Zy4uT/IRVRu9Etw0UrzeM1DehCFlnLLijjQG4TDVb/WgkGA70nL5zxX4
         EfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760599623; x=1761204423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQq6/C1Pq6mJ4glqaLVTk3qrn5Q0fPYc2F8kgQWkSeE=;
        b=Rfps8gIC2EY84+fjSALzbG61wqpJZXQbhrea8kgmMvArwJJyDWlS3dSbRJTQeWLTUY
         O7IhMRJ4gAjT5Foqj+X36uAeFPomARTw+C3wSd/TEW2guiKSd0Jj/Wrw3GqEZFro5PVo
         VeOuJl9ImyrqdQlEup0dnRUthGxcWcSCCIoMjKx/82tFFtBjHK/ysDu8GlGHdtNplCtW
         tV46AqvM3bpvBSEAscvcu1EQtcKsjVWtIY4Zf/3cEnbzpigIWk0s5ru5CSp605xvd7m0
         wH91/oZl/0/jDFfCAEEiPkGlnukRyq9BCWuRyv1A8DsbotD4Z0QN7SNpayE0QFXHMg7E
         FreQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmaT/xr/JwSPrVf2Hq6lt5X0eA2TrT+npFcolXn88R7uvwlZoLNh7R+gqW9B8T37PrjQw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyii5e5n4hKFEoNbqT08hbFM4TeDn9XME0FH2HLY5TT9pbCkdIO
	Ieb3VN6m4w47oDZ4SWPGOoU1tL82YFQO9o1HQt64CxpX0sGwbUxKx0GnnCzxuTmggpNtBDYa71l
	UL8YTheB42VZTuOcf50skKlFvvx0YVohxbnIrUyxf4w==
X-Gm-Gg: ASbGncviEoK8M9kZizGL1YEVq0DP6opinWT0OlScVFP5gZwbJ9/Zi+n6PdqoZMvOi5d
	ImkAIEqOhwYjShOeRhMJklUlnnqTQPZEvgEmf9HD99zP2j5R/mqOtwykmVrS5o72mfPOUh/cn8A
	qA/7uEh8PKq5NZln2acy7W4hjAsBXPnFVLhas6uvAACI8IyBbgEZibbhmpc5O1QI31ooJ/N8nsg
	9N3o69h2E4lpAw2N4wIAzstivJBWwWbGToYAzgWg9ikcJUb4kr6ldKtAaZhInMx47PqKsuXeCYn
	wHnWzq78f46mP/extDriSF8lADt5
X-Google-Smtp-Source: AGHT+IFxVEtUUpG11oNuraoctZ6Hp9toOBZQ5cSCf6CoGhF26DBIDaJNAFHhYr6c+OhY2yFTtyl5cf+NwcVMvMDm3ZY=
X-Received: by 2002:a05:651c:150f:b0:372:4814:3021 with SMTP id
 38308e7fff4ca-37609cf7ce8mr82493341fa.15.1760599622974; Thu, 16 Oct 2025
 00:27:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905091139.110677-1-marco.crivellari@suse.com> <176055121712.1529254.17045515819433949532.b4-ty@google.com>
In-Reply-To: <176055121712.1529254.17045515819433949532.b4-ty@google.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 16 Oct 2025 09:26:52 +0200
X-Gm-Features: AS18NWB1N-m1AMT2106s1Zy205G2WITDT4RPCudOvUSqKgVI3x-P6_PBd_gcbJ4
Message-ID: <CAAofZF6hoDXVj_aSxkOwnPnxAOE1z8CsqokJWMrxwGd+RaOU7Q@mail.gmail.com>
Subject: Re: [PATCH 0/1] KVM: replace wq users and add WQ_PERCPU to
 alloc_workqueue() users
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 8:02=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> [...]
>
> Applied to kvm-x86 generic, with a rewritten changelog to tailor it to KV=
M.
>
> Thanks!
>
> [1/1] KVM: Explicitly allocate/setup irqfd cleanup as per-CPU workqueue
>       https://github.com/kvm-x86/linux/commit/9259607ec710


Many thanks!

--=20

Marco Crivellari

L3 Support Engineer, Technology & Product

