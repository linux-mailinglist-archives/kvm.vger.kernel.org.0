Return-Path: <kvm+bounces-44789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D36DAA0F81
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E962E1894BF1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63D8213E67;
	Tue, 29 Apr 2025 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zWLAEv8P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6393215073
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745938189; cv=none; b=cH3JoDfW0+vLqTujH9O3KD5mdy3SuJ1WfbCUtrdKWVyboskpvFKEGHjjwa40fwVvY+GcZs0cERf6CVAmhcZl9PbNsZhK881t3EFIIKtm4K213T3Anx1Pd3hQsvJZ+aAaqRQPm7LNopVbfjWRYcqSAGFv5fZb180PuwXa9D0Ortw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745938189; c=relaxed/simple;
	bh=zPKqDubqGQlbbZ0ERGazpJ4D1rDz8spLOm/r4Uz2J70=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=raS78pIlUbhcLhRbU1wlOhDuFhypaDQq/rikPdz5shHsr5JOuCJ753bAOtIxzlU74gZ/4bW+das2CCs61rdvWLDXd7y7BNexMmK0jRYgcEoStSUz8ggRt/mbuFvvBznSbdpxYgsWgx5467KX+EkUZK64ZauxixgAxH8yIdkWLxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zWLAEv8P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-73917303082so4096497b3a.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 07:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745938187; x=1746542987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zPKqDubqGQlbbZ0ERGazpJ4D1rDz8spLOm/r4Uz2J70=;
        b=zWLAEv8PmUgMnNAstxttD1v9ti2O1GDd2QoqMajXyXJu2P+ERV9ieuSacdw6X5LgZp
         4TD4cgZGiiovQx/K0qrz4CyzAMRcxAzoNQw9rJYUIbd0amXyJ8tv87ybBjicYh16XryP
         Kb8yNa1+xn/kPMwy030Lsj97k6bb+V6rBP8vMbMnjeHKWNjgHlJBKnaFpEy7DRFDTseY
         7dR87hHSHtqR4x7DksTE+fIQy6gjI4RogOioUW7O8MNooEDO/uPbvf2HxhvNkBfvi14w
         p0GkD75U37F7NxSarfYrQ9tuJeAF79QxrhN3Tnjd8nxZW/ubWBh4utWfQkXUebeEhiAF
         o3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745938187; x=1746542987;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPKqDubqGQlbbZ0ERGazpJ4D1rDz8spLOm/r4Uz2J70=;
        b=f2ojrUuM9fF592HYrSDr15CLGQB1D18BkiMPCj1ZzkInvG/cIBPMxefLNa8oo8jhON
         EUIqo3N6qg1GWo6eSsOmMHJlTkASPBX1YW0drnbbl3hSTrdk3MvIKboMmGAV43+u1c5r
         CN9in1bDdx1eoD5PfGiLrwFIorAuWSjfR2iN6jcxk/A1q0y4BpsBwevkG4ajv53Ht9dB
         puc3Vn7525JlAo8dt6rRUrs2QvO7u5n5gf36kG4SS5MK+ttNad7nkRxIiYoaBQaJvfVR
         GB6MItNYrQAl/8wfAhnCMoOTr5c9DFY9m3eT3VEXA56cs3QPDwPwkpcQLzDhRP4iryWz
         xmkA==
X-Forwarded-Encrypted: i=1; AJvYcCUcMYWwYN+P223hJziu2o1ymjtRawPf1eAayWCtKYOiG7Zbu2cTKWqRqIP3+iz5IaMAE8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YytwGlv2L9utDW70nc0bHUI4tCQ4dnkBYyr7MW1SP+nzHm4w95S
	4mTiP6xFq/uwHCAkxGlTF/4hncSkJRyvEBNdkSvwmwlQsdKg2+r8/3eR7be9z+AcjKFBScmBV1G
	ebkPrh4+VbehTEdX9Ccg7nA==
X-Google-Smtp-Source: AGHT+IEzQrNdrD5XZ5oQkHZCt1a4CsXs91g+AUEFyHlMqs7LdvOItt0h12zoq6RDItWNFBq3wzeuMH6n8vWHqqoYsA==
X-Received: from pfbbj22.prod.google.com ([2002:a05:6a00:3196:b0:736:b315:f15e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2286:b0:739:4a93:a5db with SMTP id d2e1a72fcca58-73ff7396ad8mr16428620b3a.22.1745938186941;
 Tue, 29 Apr 2025 07:49:46 -0700 (PDT)
Date: Tue, 29 Apr 2025 07:49:45 -0700
In-Reply-To: <20250402002936.960678-1-seanjc@google.com> (message from Sean
 Christopherson on Tue,  1 Apr 2025 17:29:36 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzplgvxbsm.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2025.04.02 - No Topic
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	roypat@amazon.co.uk, kalyazin@amazon.com, Fuad Tabba <tabba@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, david@redhat.com
Content-Type: text/plain; charset="UTF-8"


Would like to add an agenda item for 2025-04-30's PUCK meeting: KVM
memory attributes vs guest_memfd shareability.

guest_memfd tracks shareability to determine whether a page can be
faulted by the host into userspace.

pKVM does not use kvm->mem_attr_array for tracking private/shared status
of a page, and for Coco VMs like TDX, there seems to be duplicate
tracking of private/shared status in guest_memfd's shareability and in
KVM's memory attributes.

I would like to discuss a proposal for shared/private conversions to be
performed through a guest_memfd (not KVM) ioctl instead of using
KVM_SET_MEMORY_ATTRIBUTES, where Coco VMs using guest_memfd for both
shared and private memory can be able to (with some other changes around
KVM memory attributes) skip tracking private/shared in KVM's memory
attributes.


Thank you!

