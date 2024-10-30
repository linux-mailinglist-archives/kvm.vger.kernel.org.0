Return-Path: <kvm+bounces-30072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7289B6BA0
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 812221C23D58
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 18:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B79B41C460D;
	Wed, 30 Oct 2024 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NACy1icU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF951C3308
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311529; cv=none; b=VL65rbWCjYWhMuLZazqx1BuuHnOCDiZB/la86wEMoU2ybTXErNj+oCePTq57o5Z/j/tucgKGi0uTy3J6GuBrHkqmHGHW6EQIhZnod/UAuGdEswmXMN1bYwp2TmLyM3VZ6irkxbBp4lQsDDZdIMrtL7QP0ioDO71dziiJyVG4qDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311529; c=relaxed/simple;
	bh=RLqliAfR+UGshmcm/rvWnn4gb3e2hajQ9VrTmy21AS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O/Q3qky37W7U8zG5VDYHfHkyVAyNF75SrxPjvDnKcSNv1kMjDPtqT4X9PYHLa0itS8eDH4M68L4WhD+CqRUrkI5/cpqgiQJR98xwiCzdIVoJT8gUvr29tsU5i6a0gxm+7E4JoiKHjyjmKVRhSpXoFPc0b6/A3DCobaoond3KCuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NACy1icU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7eb0a32fc5aso127932a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 11:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730311527; x=1730916327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qsN+88z0+xTmi+w6uVBgNq1mMIkrfieQkUFjvlPFQfM=;
        b=NACy1icU6lwQ5Px4YEglKqcgTqpKim5vk8/mi3v1v0ZIbw/xLgRCboJcVLapMdi/X+
         TCvjcP7A20e7RWv0o7N9jmgc+JwIBB0Dh9gsXHfaVyLKz9ZHNjUZw0YnojHYqELpWfkk
         O578huqkJ5ghrztKvYsejqs5nXOjUV6IRvU6kKRNmX6iuAoKMeRFGTbGAA+UH6OflPb6
         Q8UWJaEloojSU58PBS9w/MLsLdVT4HGsa9PxmPJib54iKiEI+Qv7CNT7+wk8vfEE4cU+
         INSo7yhbsO2J8nxw6ck04jsU2JvuMW4V6CDUd24DwY1RBTUnp+k1IauhjhgkMdfBIS4k
         VenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730311527; x=1730916327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsN+88z0+xTmi+w6uVBgNq1mMIkrfieQkUFjvlPFQfM=;
        b=aBs9RoyhEp+Ce1BQ30Jhu6Se0CyiZ8SLE+ZR0PdyWWSgZgkLlshZ4G9yH5teKzyf5F
         srVsw2uZBxYno/Ig2Q3HZ52vtPkufPg4h22rqaz5enkVJdlAmfTBds8XhdOtmGYAuwna
         8lTIRsJjGse2dO1q0sTESfFQ1TQRlKkWRJb0QKxGhJt34hfPfZUd1GdJcQzQmOylve+p
         vb+DK27nc8BHyfIhEde8CgiJzZ+f5gPCwy2G4VOB6qxVu9X3BMlvC1Mt/86N2vzvjjpt
         YEpOjAl3g09pNSvzMflE1HPbRorfcYyCflRkwEo5CK1b69WN08pAFfXGOsOqmwYqcozN
         gbMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbqGyJw6I1ixwSkv9Ha78/6TNjwCRRURAtzfPCvZDMAHjYBmFYu2FFVLMfAceEtRR9JmI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSgztZeNIS8QxUzAsYT/W/awcFseKkHDuhjAMXnY7dlNLm1q7x
	Mry3RgZtnvCPqermFAh7vC/tF7rF+fEsfq2MsZ9w06Zg3gun3tXdoONWb2Dxnr2/l/SwtP79Iti
	GJw==
X-Google-Smtp-Source: AGHT+IEwpH94Knt5f0q0GCjhlJUDzsXFyX5obRCiBSHz/PN0wGXtDjYFudu4QwfLsjDgh1CzOxVnlDfj02A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:385c:0:b0:7ea:999a:7930 with SMTP id
 41be03b00d2f7-7edd7b6c7e8mr24481a12.1.1730311527208; Wed, 30 Oct 2024
 11:05:27 -0700 (PDT)
Date: Wed, 30 Oct 2024 11:05:26 -0700
In-Reply-To: <c8e184b7acf1e073c0d6cf489031bc7d2b6304b0.1729864615.git.namcao@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1729864615.git.namcao@linutronix.de> <c8e184b7acf1e073c0d6cf489031bc7d2b6304b0.1729864615.git.namcao@linutronix.de>
Message-ID: <ZyJ1ZrdxDhGTQ-JT@google.com>
Subject: Re: [PATCH 04/21] KVM: x86/xen: Initialize hrtimer in kvm_xen_init_vcpu()
From: Sean Christopherson <seanjc@google.com>
To: Nam Cao <namcao@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 28, 2024, Nam Cao wrote:
> The hrtimer is initialized in the KVM_XEN_VCPU_SET_ATTR ioctl. That caused
> problem in the past, because the hrtimer can be initialized multiple times,
> which was fixed by commit af735db31285 ("KVM: x86/xen: Initialize Xen timer
> only once"). This commit avoids initializing the timer multiple times by
> checking the field 'function' of struct hrtimer to determine if it has
> already been initialized.
> 
> Instead of "abusing" the 'function' field, move the hrtimer initialization
> into kvm_xen_init_vcpu() so that it will only be initialized once.
> 
> Signed-off-by: Nam Cao <namcao@linutronix.de>

With or without the helper dropped, which can easily go on top at our leisure:

Acked-by: Sean Christopherson <seanjc@google.com>

