Return-Path: <kvm+bounces-18914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 595758FD06A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5954F1C22728
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 14:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A221E1BDDF;
	Wed,  5 Jun 2024 14:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jR5JlSHx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D33517996
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717596409; cv=none; b=hsRIw1ADpMcFZwsopVvmf6f7ANEi0Tr+BSq8Y0dNEohF7PGX7T1Z2h2lRCI73kVHpyhCvYbHm9L2sPNRecR1/wI9dmDpinwax/KgtPgbIKV/CoRrmotKRciqtruQIGJQasNIlgDkEbGpWHkImMAkCgdzmUeZ8z8i9LPa+PBIVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717596409; c=relaxed/simple;
	bh=RLigTN6QlgfnN8MmaEOoLfcZ90fDVBpjgvMkiBaFCMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hiqUXnFaU1ffsiS+g4+7QOaCS9/ZS+r5N4/GTXB5g4axDeDJUcwJflP6o3E6b0g+nYePVlk2B35FJkiJfBqP6RZUuWsH9mrmiWLowSwPe/cOFIsdSKSclQG0m2UacL2H6riLL8APg+n903uo3jnmakkXfM0TBQSoBWWlNy6dJbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jR5JlSHx; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfadccd8831so163206276.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 07:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717596407; x=1718201207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BL138jN66e7d4oRS9LVO/0u1phYBQ+x8xQzsbL5QTlo=;
        b=jR5JlSHxwJBVnwKlYd2q3dAIa5VvoPsvGkmI7dq5336WqvGRPa64jtwoiKusLudxNJ
         wRo6BlVYYk/5rzubjsIrmZXk9ewEG5JJ8BCTLVgJyzNQVlxLFVx/Akc4vA8p8Scjkqje
         puvdvN1viiVX/5foJxJ/sxvUZJJBJfd0JjxM0U77CePNn9PXsNeYLXejZdc6FQWJXThA
         84V7lPg0nLvtcwdAv7S1eSLnmZgdT+BP/cKPuKUfXA4IbPibkh+ajfitxR1t0Mk9KKBb
         Oty/o87QsZbZiWrjRlx/5FMzvMkOP3s1ZAOVenNUNnCYIK+pDB1DRFHCMXxiIyTPrsca
         Nj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717596407; x=1718201207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BL138jN66e7d4oRS9LVO/0u1phYBQ+x8xQzsbL5QTlo=;
        b=GeDvHlDgqwa/F6xzdtIcL7RYITOROxJ54d046AMXDi8bIfL6+W91ycyUszf+ijCfEK
         V5WfpzMGRWPBojwrRKzWUBHIyJekEKFU/OwINCqelgiCzvIeDVup/CgFfqo4heXJ05wL
         DFLtAjr/cO3qnC3YMyhPIzi4eqEqNTDLrD3CIpTMODdOPHRAQwPIOCZv5KFkmxUqBQ/c
         GXJ6oKZcBRyGVwHC2mE3cpaq0X7b7lGRALrsfCipXqU0HdoTjWgdtPKehU0mDCYmZLfT
         DMQ4jRdSmiEosSiJkUFKrju2gg9uxuuPWkeEHLcqzT80XJCSzPlWJAkh1rf79YLg8SBN
         Bv2Q==
X-Gm-Message-State: AOJu0Yz/X6Bl5uP0Yxe5N3I12y5frv4zAuoDh7qks2NZqwu28rNpWoVa
	xdJ3bzr2rT5/M+SJklFt8CqqMyqnNWkLsh0pNQvSG+Mq/55Iv9McmRLR/jHbM+wQGbTZeMTSNhI
	nqg==
X-Google-Smtp-Source: AGHT+IG1hc4iMUkWuc2pTjAvNhhnxyv7afMIRBSIBUolkARKLQQrvnWjgIFzBdhrmfAcjl+qpvy1b4ZNUi0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2991:b0:dfa:4b20:bdaf with SMTP id
 3f1490d57ef6-dfacad0f465mr254997276.13.1717596407332; Wed, 05 Jun 2024
 07:06:47 -0700 (PDT)
Date: Wed, 5 Jun 2024 07:06:45 -0700
In-Reply-To: <171754361450.2780320.9936421038178572773.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1714081725.git.reinette.chatre@intel.com> <171754361450.2780320.9936421038178572773.b4-ty@google.com>
Message-ID: <ZmBw9R_jkNLYXkJh@google.com>
Subject: Re: [PATCH V5 0/4] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, Reinette Chatre <reinette.chatre@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 04, 2024, Sean Christopherson wrote:
> On Thu, 25 Apr 2024 15:06:58 -0700, Reinette Chatre wrote:
> > Changes from v4:
> > - v4: https://lore.kernel.org/lkml/cover.1711035400.git.reinette.chatre@intel.com/
> > - Rename capability from KVM_CAP_X86_APIC_BUS_FREQUENCY to
> >   KVM_CAP_X86_APIC_BUS_CYCLES_NS. (Xiaoyao Li).
> > - Include "Testing" section in cover letter.
> > - Add Rick's Reviewed-by tags.
> > - Rebased on latest of "next" branch of https://github.com/kvm-x86/linux.git
> > 
> > [...]
> 
> Applied the KVM changes to kvm-x86 misc (I'm feeling lucky).  Please prioritize
> refreshing the selftests patch, I'd like to get it applied sooner than later
> for obvious reasons (I'm not feeling _that_ lucky).
> 
> [1/4] KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
>       https://github.com/kvm-x86/linux/commit/41c7b1bb656c
> [2/4] KVM: x86: Make nsec per APIC bus cycle a VM variable
>       https://github.com/kvm-x86/linux/commit/01de6ce03b1e
> [3/4] KVM: x86: Add a capability to configure bus frequency for APIC timer
>       https://github.com/kvm-x86/linux/commit/937296fd3deb
> [4/4] KVM: selftests: Add test for configure of x86 APIC bus frequency
>       (not applied)

FYI, the hashes changed as I had to drop an unrelated commit.

[1/3] KVM: x86: hyper-v: Calculate APIC bus frequency for Hyper-V
      https://github.com/kvm-x86/linux/commit/f9e1cbf1805e
[2/3] KVM: x86: Make nanoseconds per APIC bus cycle a VM variable
      https://github.com/kvm-x86/linux/commit/b460256b162d
[3/3] KVM: x86: Add a capability to configure bus frequency for APIC timer
      https://github.com/kvm-x86/linux/commit/6fef518594bc

