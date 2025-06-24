Return-Path: <kvm+bounces-50541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 108ABAE6FD5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3A6B7A9082
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FE32E92AC;
	Tue, 24 Jun 2025 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mrJCkeyY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289102E6D23
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750794056; cv=none; b=moGa+UO+UKgdMVOiax+SKFsSrOXNCSKdhQgA12IhW4VpFtC44m9Fysk8+6M2P7iFYWwsZc8CqFt4TmEzpSV6l8FClxB1wbJ9E4/FQXH3b/lEVthKPZSlz7CJGsQ0Vp4vqQwXg9NZq0axQ+CwI/Z4xRXS3bc9ifixyvZdHGT8tJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750794056; c=relaxed/simple;
	bh=QI51cwFq/YB5nOA5i5mKEQvmSHJYx7qPfrbiMFxEcIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t8GRkr0nX0e4UAeFOteYq00axSsa9WuoQPQXWtD6UG2nVXT6g3vfmwX5fAiZiL5gLe5OndnB+/lDxhj3YXI2tzypVbwt4KRhQc5ZSdFhv4mImLtoHz/msrk02QPWCBLVuT2jC6J/28gxTMg+NXoWSoWapOuclzca+CweoCiVmTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mrJCkeyY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3183193374so4077207a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750794053; x=1751398853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/vmX1c5Xt9887t/Wl5FntHs+0LsgfmpqsHqfvT5xmBc=;
        b=mrJCkeyYItwiHcOjidBNfbJrQXQIkXh9Dap/jT7mHXF/F/owWM3j3ROGSNdJ45Q/mU
         SUoNZ0RH5xNvxkesH6OCW/Gh7TE/XZQhPlI4+qZkW6tmZR61Uab4XyG/hCFgK8uSF7vL
         S+PFistXIgIqFCoYWqkpbDvNIGTSyd4eGR5/sUmZdz4d4zEebTqiR7qj2VnvE7fkhjTq
         39AOhoi53Tw4zBn0JSrJINmys5tGonG/Hh1Z00UfSe4VkFb9GkhDzdS12NlJforYvfmw
         7xK+qOlYRAtGh0lP+sqETxTya528H6fHKwVTzwQ/QPY9ar/DFJ7QBJzDi8GLTgy2D7eq
         8HyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750794053; x=1751398853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vmX1c5Xt9887t/Wl5FntHs+0LsgfmpqsHqfvT5xmBc=;
        b=qY61NonEMk9tVu7ggsYiPw2qxYRYNMqzSkqCnXwI5W8JF3wzhJ4QYChr2UuWJCOjFy
         ygKg7zCRqVKhSPeabht5c4NOx5HOEu3CBwOQTZa4PVIv5/UEXwRjdTh0+XeNNwQBxc5g
         JZ2uA+FTqrS5Xo1L707upKhcPek2dfVdR2kbpG83tTdsxOTN3qLKbm0Vi1tfQ32QSm44
         06cmRSOFbbx2aQsXCeHXG21Nsk5gtp8q7xzjKQF3Y68Dqu1PZmd7AhQGLlxenL7eGRBa
         /eGry/1h6ehzhYPmv49rQfJZaQEjLvKl86Al2qSnWXRjAI3jgcJk/ayPWCxXOm/qwpHx
         NaOw==
X-Gm-Message-State: AOJu0YxtarnIts77B+QC6BRDrTRgtbGwD22OhSrtVbQ+xAtcbwHUSPP+
	39sJpy/mRSB1UEmCC1mX26ua8d/94FLzJ0xri/UHSuoJOyskpvlPs8Uo20/3doYpddQ6eHAKsa3
	ZUMuuCg==
X-Google-Smtp-Source: AGHT+IEsEvO7d4CyVEj9g3vK+CPWlFNWO9cdjFglM/v2PD0Hi4/XwEOS0vLx5GXBYOLCXHETDH28pGATLhs=
X-Received: from pfjt8.prod.google.com ([2002:a05:6a00:21c8:b0:748:f54a:54d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1589:b0:21a:bdd2:c2f7
 with SMTP id adf61e73a8af0-2207f330579mr342217637.29.1750794053454; Tue, 24
 Jun 2025 12:40:53 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:38:20 -0700
In-Reply-To: <20250602224459.41505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250602224459.41505-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079269575.517785.12142408340158295471.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Fix a NULL VMSA deref with MOVE_ENC_CONTEXT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, James Houghton <jthoughton@google.com>, 
	Peter Gonda <pgonda@google.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 02 Jun 2025 15:44:57 -0700, Sean Christopherson wrote:
> Fix a NULL VMSA deref bug (which is probably the tip of the iceberg with
> respect to what all can go wrong) due to a race between KVM_CREATE_VCPU and
> KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM, where a non-SEV-ES vCPU can be created in
> an SEV-ES VM.
> 
> Found by running syzkaller on a bare metal SEV-ES host.  C repro below.
> 
> [...]

Applied to kvm-x86 fixes.  Paolo's "Queued, thanks!" seems to have been
premature (though Paolo's mail saved me; I completely forgot about swapping
EINVAL to EBUSY).

[1/2] KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is in-flight
      https://github.com/kvm-x86/linux/commit/ecf371f8b02d
[2/2] KVM: SVM: Initialize vmsa_pa in VMCB to INVALID_PAGE if VMSA page is NULL
      https://github.com/kvm-x86/linux/commit/48f15f62418

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

