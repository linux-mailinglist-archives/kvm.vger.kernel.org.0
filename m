Return-Path: <kvm+bounces-18971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C2D8FDA5B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01D78B21F6C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA9B16ABCE;
	Wed,  5 Jun 2024 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zGdr6ar9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9498C16728F
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629668; cv=none; b=uqUFiYxlGSdSYgVq7lsZY898klOgUK0Sw7APdInNp/GTF9bcjFnSZZSdeW6nsaw+ZAZm4t/mWCZQU0LfJLvA0zitwNmmu5214pO+urhCSIgOSCpYunb5AXPFXu3z9q/9VLRsodjidraLT6Y3QmswhiKdMDgKoszh9cmqikwM33E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629668; c=relaxed/simple;
	bh=FGsE1BDYnIOyTrrug+VdGG6NDbC2RDrNJGAenpAI+MI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nhi2ECepEg+jmFvYvXtpAV9EWfZT78N9is3t7mPdSw/fURZtkfLhmdr9vBBeDZUM8Q8ZOMnmyGj1vsIRJkWGh15dnJ/n1NQz5X/X2mvUihXUIXW9oNs8c0PpVqT7xRaeBYb7w/a37yeOWbem53sHDOJY6waxXXD3CsGHXAmj7p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zGdr6ar9; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627e6fe0303so5504957b3.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629666; x=1718234466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWq+qxGdCgH2epmrSVmte/TTCuNAMIZX4bjjQp6uwxs=;
        b=zGdr6ar9mOUoMTqefzsjnJKvysRnpLWJv2TapCL4Ziba2vJOz0Qe9+lzKaq8b2QK5o
         ERGhDEQVjuIME8zduOWAv+7o3Ui4l9fD7qRPJXXh92aNzsFLfvt3cjhmG197Erc7VrVt
         4by8vh/GdXdhMew2u/oulet5IaGTCPMJlcCLDnSXpZwZIO+GwOXeg4uW8qSjIt61MnNf
         vF4uk7MXK2G00v22LxytMXBZ+iKGmQRkOswksskUeCgwxr3cG41KLLAB47JODh/y1KNA
         pvBiKN+PS0xAwiyb/DiMViSp/k5IR+02Cl7R9zGcLsP/ukoIgVX0u4hAsuPz00zsD6yt
         YNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629666; x=1718234466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWq+qxGdCgH2epmrSVmte/TTCuNAMIZX4bjjQp6uwxs=;
        b=WvigG0vSWM9Wx5wjs/NSO+PATNVqw57APhGo88si853+FHVPDYvr4klOTVVPmg0El+
         e2dav16xpMtkSUF8SZVJ2NABBjkGJ+a52gfcTC8G/WvohYDjZCa1hBx0hqu/b6QFZENu
         P0LpUANgLoet2x0cu+3baF/i/u2tzkb25b/jlp+UoGqeED4NHQT8XhGc53G033JX61PF
         vCxCKdTb8mVokoqONDOfbTytSOyQRUdt6A5Jj1jjlPLU2rz15c8JQLkNZ04+SdVkqp6t
         iBsFBa9qw2q1HrNPy1WBSuk0Hv4QIjE5VWH33lH+uVj/dqfhOztQ4iNL87SaNbv0UJiD
         ecCA==
X-Forwarded-Encrypted: i=1; AJvYcCWMxzJ8pRiYgddYVLQ/Fmlu8L/kjHJWjAbsluOG5sv/MYUdaOoIvTouuXkTthKF1zx+yIo1wvf5jUbpiidY7NGg1qKH
X-Gm-Message-State: AOJu0YwlGLNqh1nLW+/EY0+uV0rbTdvYUae5g4xXtRTyMY/KtAbUReI2
	RHeYaunj2lkqqt+NjUKvS8hoveiA51Altus0VmBfW4dk2hVQB0bKaFIQ1V6KBM9iIuvC6b9/Te5
	4zA==
X-Google-Smtp-Source: AGHT+IHmLyB52VdraTohL1ct46YnRIS/W1GcoH+QyDnxmhR9bq77viFe7TZu3MZcN3ULa4r8LlPqKNRd6Vk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4c12:0:b0:615:32e1:d82c with SMTP id
 00721157ae682-62cbb595497mr7718347b3.6.1717629666590; Wed, 05 Jun 2024
 16:21:06 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:36 -0700
In-Reply-To: <20240522215755.197363-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522215755.197363-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762856099.2913623.17445484731860138154.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/1] x86: vmexit: Allow IPI test to be
 accelerated by SVM AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: pbonzini@redhat.com, boris.ostrovsky@oracle.com
Content-Type: text/plain; charset="utf-8"

On Wed, 22 May 2024 21:57:55 +0000, Alejandro Jimenez wrote:
> The vmexit_ipi test can be used as a rough benchmark for IPI performance
> since commit 8a8c1fc3b1f8 ("vmexit: measure IPI and EOI cost") added
> reporting of the average number of cycles taken for IPI delivery. Avoid
> exposing a PIT to the guest so that SVM AVIC is not inhibited and IPI
> acceleration can be tested when available and enabled by the host.
> 
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86: vmexit: Allow IPI test to be accelerated by SVM AVIC
      https://github.com/kvm-x86/kvm-unit-tests/commit/354b6957994f

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

