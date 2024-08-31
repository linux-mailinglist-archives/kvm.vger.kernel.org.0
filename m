Return-Path: <kvm+bounces-25607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 639B9966D6D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB256B22C1D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C76175AE;
	Sat, 31 Aug 2024 00:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sGQGbDT5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2486FD53C
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063667; cv=none; b=p+s52MzTW6yP4Z1ObSwN9rIRZofOdVGCyOXEIL5UeUsHUBEiNX0FzJFa3di/VXt58PjZmGBi0RVS1z8wxKvhc9tq7vgwoxJgBOw1S3AJH0v/iqFXut59VAFJMSj/mL6gggSIg45OrUqZDs2QPwzIi4ERBMp8Z/WbqeXd81ZqjaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063667; c=relaxed/simple;
	bh=9G1z4sH2OSDHjXFamwV8U66Bam9TMlrU5ZP36XcmlrE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e29bz6oEJknnJMaK+4DFMX/fWwKsCcnHxYitVRue7UPDRtZsAOmR428Qx1WHxLJZMMdJbuWNXLHR11MjUaPz1O5kIu+TUvFfKgB40d9khLEXZhCTyHRivy0FE8GRoQtnj8S/hAljn8rbAdJBRGXqU9XabAlgeH1Mt/w+MrZNm6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sGQGbDT5; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1159fb161fso4029677276.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063665; x=1725668465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ROMGhI2S5B8hz0nt/FZlp1shWOeqrpq3QawCSf09lA=;
        b=sGQGbDT5auxZ5I7HWCFsJm4jXlS4KnDxLNhatyDwMwanNNHbFUlpGUqQtflgndntBY
         +6ha7Gob/XC3KH8hGUcOE2NGy53DLu6TazxIMGIXq7zwMy/xOHVT3sCvNvIzrj39svUv
         cgC0fg7x/U1+whFvOZCmOe5pYLN+dhspp7zSJxMAwEZ8iL2p/PKAxcPU2I05yosdTvok
         8AJFCXxIAUI2hzw9nvBR5pUrL+bsCJrvw/h8Z2CYOk1SNLzpRfnNE+VR0BacbjBwALdJ
         Ihn7ZuKbVFswIyfFRe9BfNMZ+9O+pSoCoCGElYPIWCpuBkO4YrAAziWTVglpY7LHZSBN
         Mz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063665; x=1725668465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ROMGhI2S5B8hz0nt/FZlp1shWOeqrpq3QawCSf09lA=;
        b=EVoruS/G2i5AEpKfHkWtuGtOa+FU+fVr0SmTetdbW+WU2DHQFgJy28QwKq/6RRkupV
         ysVXL5on+sfKfxMaoL+Pd9R8fOY7xiD12xmZn8tPwPXexUAPIzxOQzAC5j1lZKTB6WNj
         sNcbtELLXqNIyxssexOh7vxqSBFCn34XEzmbR8YEgdlUduCUjfmEqKIKU6bjlfmdA2/W
         VZGVyHnyUd8CJ1jNURZRxJJGx34ndX1jpe3Gkr6CulcaCfIqkRzaO4ZJ1fhI24sRq/pi
         bEkd7z3tduAH39OSZS7X3bnvI63ObqJbgTZc8aP41BnN+wPFseKuclQils1D25Xe8i2R
         gJrA==
X-Forwarded-Encrypted: i=1; AJvYcCWOFU6ECCYBJ6KGhM4mUz+3ndYOB6P18/muzrlZJIuEoWvBrLo8OoS8dlPEVuBjQStGSRs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVXObx3uUprdJz0+JZ8qXwiCsDTj/1HrRdpFHoNidEdXYWuk8m
	G7LaSkS+okzjK5LaXay1FChbjA39kpJ1Lk+ktykMlYdS4mwoatPYNsYGsFEM1KKZuDL5p/UzpTe
	neQ==
X-Google-Smtp-Source: AGHT+IEBQNrI9fW88MMAKjdjeh7jML7gesVxzCD4yOuhLp637G514xzbVeLwV1tuZjCFA2Nj5pEYWF+I23g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3006:0:b0:e16:67c4:5cd4 with SMTP id
 3f1490d57ef6-e1a79fd505amr5367276.4.1725063664961; Fri, 30 Aug 2024 17:21:04
 -0700 (PDT)
Date: Fri, 30 Aug 2024 17:20:49 -0700
In-Reply-To: <20240828122111.160273-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828122111.160273-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <172506342656.337369.11895591400865078868.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SEV: Update KVM_AMD_SEV Kconfig entry and mention SEV-SNP
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 28 Aug 2024 14:21:11 +0200, Vitaly Kuznetsov wrote:
> SEV-SNP support is present since commit 1dfe571c12cf ("KVM: SEV: Add
> initial SEV-SNP support") but Kconfig entry wasn't updated and still
> mentions SEV and SEV-ES only. Add SEV-SNP there and, while on it, expand
> 'SEV' in the description as 'Encrypted VMs' is not what 'SEV' stands for.
> 
> No functional change.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: SEV: Update KVM_AMD_SEV Kconfig entry and mention SEV-SNP
      https://github.com/kvm-x86/linux/commit/5fa9f0480c79

--
https://github.com/kvm-x86/linux/tree/next

