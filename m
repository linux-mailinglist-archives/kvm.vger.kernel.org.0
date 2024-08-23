Return-Path: <kvm+bounces-24982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B5795DA00
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73835B22586
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601151CDFCE;
	Fri, 23 Aug 2024 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lZm4++i0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342F41CDA35
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457425; cv=none; b=pEuk2GAQyE/O7iaXtpe8h4n7MBPeJBQ3V3+5RSufr6Qn95ED+KZjoKkaUE/lw7WY39guQ2jOgWHgWRGPIXsS2HvAMK7bnLnlcUgiwR95PetirahIWug1k0GjgaKhufaA76hz1Pl5/FbGq3Iu2vb8w8p60DXtYE4w4bJRqrpZo2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457425; c=relaxed/simple;
	bh=3TBDR7RHCVUWQzyGhzzytr0Lj+8frShpKy/vkdlRFo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AmuFN+K5zYugGCYzD58YHCMITzXqN9BLJjeu3+vBjNRdtAkELticRLlrgJ2lvi+kPHbuvsKjxOk1zvAkOBEJxw/ncN1mfQkSmBPTJnDRc9Ht1sTbXoPoZuuIpmIj3d7CMVu1LczeBA65K8EmRq7rRgb4D5wRHGStCikQ9gTRc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lZm4++i0; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e163641feb9so4926144276.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457423; x=1725062223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HX2W5FE6FWjJbEMUv+O+IBpK22SAzsnBpYrjXp/CXhU=;
        b=lZm4++i0t+KeC2AlfKDbEqkdawfxCws42RBD190tn9Ogy/crebdte9JRXkK2TMhO8G
         bdFmFV97hfc+LiKEchuAUMVez/Mahmy5EXl9pySZ8KYg9Yqj08ZK+PX3ZVZ2XLkZoeJN
         xU+Ep1m9ygL7Z/i49reczvhc90ymbaqgf1v6sat+YCnSz4toaSDPrwIi55mZNhDja6NQ
         5/FDrVIGu2GscGKW//ARszgdONJ3Z76aaHNziHiCbrwcuXspdl2YAOUro3rTLTRVWOzy
         Je9/jcC2NJbQ0lljnOPZ+aGbE+BAYrD1SMzMqi+K42b46VExECCb7VhYytdycqO5joOi
         FZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457423; x=1725062223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HX2W5FE6FWjJbEMUv+O+IBpK22SAzsnBpYrjXp/CXhU=;
        b=a58R/ZNL6W8e2fcLgpZhKLNxaRXkaaC8ea7o6xPWMdODoPUPLa7gdiKzDXn75PlEZc
         3vvAJqBSqP+l30b10IPY0MvE/aX3ZppIShfJCCnys3bo4jXM8CZ/3oZ91/t301CaxWyK
         85tN4i/hmnxskTpHCtKYtOF2oyOkOYu5A5cIN2HDQBpebotSoGlxJtaRDctEj04ap6OS
         nhFX/GM0AEmrWPk+UHtNh/QX0p/H9d8nZ/+ucJ+Hl7AYkj+r0nHDbDKal32/VszbCxYb
         uyQp97YL0JZltU0vTR89gA2/AzePCrsjUUnhJVKYjCzN7VTH1UFk5gosTGa+PqMnYonY
         CIDA==
X-Forwarded-Encrypted: i=1; AJvYcCVHHiF7387/JvpG/z9rS4k/ONTTEW3CVtELKv/mgoilh+wdZzFfBXL67vh80vxhF325Wc0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlc0aqWckzhjIqsVKdM0L3N6y/rlbjNRANXFjQp5/mVTuCMqXJ
	EP0Yo3UODuIzFB4OmWSv9rds1+9yo2PgGmG2m8KocexvPGj/6+SysBHjyu054IsNwZt9zFFmzck
	j9Q==
X-Google-Smtp-Source: AGHT+IF6JIS4ez1aIQ8nOslueiOxeGv+PCTulk7JEKtYxYZVfduMNdjKQcZHAQD+HV2bqB18HwxBJevmfmw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b310:0:b0:e11:5da7:33d with SMTP id
 3f1490d57ef6-e17a78b6f66mr65811276.2.1724457423171; Fri, 23 Aug 2024 16:57:03
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:57 -0700
In-Reply-To: <20240816130139.286246-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240816130139.286246-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443899216.4130363.4073350525612402734.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Re-enable hyperv_evmcs/hyperv_svm_test
 on bare metal
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 16 Aug 2024 15:01:37 +0200, Vitaly Kuznetsov wrote:
> Commit 6dac1195181c ("KVM: selftests: Make Hyper-V tests explicitly require
> KVM Hyper-V support") wrongfully added KVM_CAP_HYPERV_DIRECT_TLBFLUSH
> requirement to hyperv_evmcs/hyperv_svm_test tests. The capability is only set
> when KVM runs on top of Hyper-V. The result is that both tests just skip when
> launched on bare metal. Add the required infrastructure and check for the
> correct CPUID bit in KVM_GET_SUPPORTED_HV_CPUID instead.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Move Hyper-V specific functions out of processor.c
      https://github.com/kvm-x86/linux/commit/24a7e944966c
[2/2] KVM: selftests: Re-enable hyperv_evmcs/hyperv_svm_test on bare metal
      https://github.com/kvm-x86/linux/commit/d8414067cc17

--
https://github.com/kvm-x86/linux/tree/next

