Return-Path: <kvm+bounces-60835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC26BFCC9F
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C628582204
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB2E34C985;
	Wed, 22 Oct 2025 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iZjB6egw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CE734B697
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145480; cv=none; b=LpFsnn9xNDzkrM72f7NAVXKf+lS4Hcs3uWrWCAZxxlYakkLEY/39J986qHZmQO34xSZPKuqhidqdOXdnpiQR9rUuXu6eoIU7ux4L0YHMwaXcxdY8CQknqm7vxqg0e6p97aOV4Uj+Bf6lvUUM4TdfJAfIMg+rsMDaaYNGPP4rkf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145480; c=relaxed/simple;
	bh=nZQfmaq7moybwbWzm06XV/8/By6UQtVLqwmofRufDnI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UXDAjfXFVlx7+WWNPkOGnK4WYwy/abkyAG/I8DYsP3Cpu2TusTOqXwXMWL56ZeJR7MIS8x5/3RjXX6Pct1GwNvLHXy414blv2bYKvtA0fT4Okgf/II/vvUSRRhRT9wZukY6eqr0jnlTA50ZMl/F8WzBYsLguzY3Ts+9khCCU7G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iZjB6egw; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28973df6a90so68723445ad.2
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 08:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761145478; x=1761750278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeDoTHxRwcTS0U/KOB71AKaMICpadOQ/ESmZ45ZtCPU=;
        b=iZjB6egwfkGRQW7asm1yvaNn79dpx8H2GCe5grmgzEUmJED4jl41MeTrCx/8JrAaS+
         67Z7o20X9u3jPgoOIExf33r9nih7ylWjcTdRmJOhRYQftxsnj4FoiBJ39XJSfhkMpInm
         SQLnPMMUtl6o008CaZZsSesp4hjiM7S0c/4saT3kjGfP9BOzo+Wy+b7xEtPTywZyhNPK
         HvlnEGQRAdl37M7i0niCrUUpPSXhfNlu7oJdONff3vUr/75WkiLf9ZEsdOufQl4H+L3Q
         ZNf4H/FWLc5vOOZ9NBIVvV4OqCzUoOQ8ffNHbFOkJYjB84qckOHPVcR9pfH6cQI9yACz
         Os2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145478; x=1761750278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeDoTHxRwcTS0U/KOB71AKaMICpadOQ/ESmZ45ZtCPU=;
        b=xHWp7dqyr2ZwvXu0NchU0Fh4vWPJE9uL/bcNeG8YQEJnDmMGxqQyvEkGNIw3yK3+z0
         H+z8f+iJIMvGgLHyq23PASgpvZNPfyAYFUn6bdeeVeZ4+zkcOPyQ+uEcYYrnR7gA1le6
         MYab65Vh2MiWDZg4EjQ3lq5U/qF9F/uwEG+rlH8SmmWJBYP0+/8I1BS0+cr0+JwfVanQ
         cVHM3sTDJhfn7hQPzOFm1k1IZRKIzBQaa6BVqHiAnwXJfdSCmxzn7rj/DmLGWapt2BJ1
         Fzodpxmdip50MS5jJxMRljc0ho9eYqCQfMIfoboAbFg/YU7DcbnOEo6v/QI4ej/5DXpn
         UFlg==
X-Forwarded-Encrypted: i=1; AJvYcCVPcodvmO2TO+m5cI5j/gictsO9KhmlwCIta5zndkDy1u7baP/NbHcPGH4lO/8us4ku4I0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHdSkqgD0o+aUlAcovFE7Sg6y+zrrB8MexFJ6UmdA4HwXfxqWd
	UQ4pNiTcX3p/c2qkxezWwbfcPtz5eGf/30oy1QHVx65cCqaGMOfrS93Gt7b9NrMUzFZdOAHu9B8
	H2oHE8A==
X-Google-Smtp-Source: AGHT+IE1dZw0eGxjpS+GgO8lvLCozsqVIb14AspJ8xG436SZwB7we6zJwtkw1VmC+yZCSr85pE3qdf5/kZE=
X-Received: from pjbrr12.prod.google.com ([2002:a17:90b:2b4c:b0:33d:b520:bb61])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b30:b0:27e:e55f:c6c3
 with SMTP id d9443c01a7336-290ccaca5cemr259712015ad.55.1761145478495; Wed, 22
 Oct 2025 08:04:38 -0700 (PDT)
Date: Wed, 22 Oct 2025 08:04:37 -0700
In-Reply-To: <DDOH9JW22RZ9.3BMRT1XHHJAVL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-2-seanjc@google.com>
 <20251021231831.lofzy6frinusrd5s@desk> <DDOH9JW22RZ9.3BMRT1XHHJAVL@google.com>
Message-ID: <aPjyhYS-jZxtx4zr@google.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 22, 2025, Brendan Jackman wrote:
> On Tue Oct 21, 2025 at 11:18 PM UTC, Pawan Gupta wrote:
> > On Thu, Oct 16, 2025 at 01:04:14PM -0700, Sean Christopherson wrote:
> >> If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
> >> mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
> >> because none of the "heavy" paths that trigger an L1D flush were tripped
> >> since the last VM-Enter.
> >>
> >> Note, the flaw goes back to the introduction of the MDS mitigation.
> >
> > I don't think it is a flaw. If L1D flush was skipped because VMexit did not
> > touch any interested data, then there shouldn't be any need to flush CPU
> > buffers.

But as Brendan alludes to below, that assumes certain aspects of L1TF and MDS are
equal.  Obliterating the L1D is far more costly than flushing CPU buffers, as
evidenced by the much more conditional flushing for L1TF.  My read of the L1TF
mitigation is that the conditional flushing is that it's a compromise between
performance and security.  Skipping the flush doesn't necessarily mean nothing
interesting was accessed, it just means that KVM didn't hit any of the flows
where a large amount of interesting data was guaranteed to have been accessed.

> > Secondly, when L1D flush is skipped, flushing MDS affected buffers is of no
> > use, because the data could still be extracted from L1D cache using L1TF.
> > Isn't it?
> 
> This is assuming an equivalence between what L1TF and MMIO Stale Data
> exploits can do, that isn't really captured in the code/documentation
> IMO.

And again, the cost.  To fully mitigate L1TF, KVM would need to flush on every
entry, but that completely tanks performance.  But that doesn't 

> This probably felt much more obvious when the vulns were new...
> 
> I dunno, in the end this definitely doesn't seem like a terrifying big
> deal, I'm not saying the current behaviour is crazy or anything, it's
> just slightly surprising and people with sophisticated opinions about
> this might not be getting what they think they are out of the default
> setup.

Ya.  I highly doubt this particular combination matters in practice, but I don't
like surprises.  And I find it surprising that the behavior of KVM's mitigation
for MMIO Stale Data changes based on whether or not the L1TF mitigation is enabled.

> But I have no evidence that these sophisticated dissidents actually
> exist, maybe just adding commentary about this rationale is more than
> good enough here.

