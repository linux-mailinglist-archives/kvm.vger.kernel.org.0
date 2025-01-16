Return-Path: <kvm+bounces-35680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 217BCA14064
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 18:11:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49ED616395C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 17:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE6022CBF0;
	Thu, 16 Jan 2025 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MrKSIaNk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC12AE96
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047477; cv=none; b=ZlcdVpgomJwEkd3gLqXwChZqqunfl2NlrkFiKcCvFq1+B8DXugKTkNIWcJ/txdjC3mTZ73cvnbQOwFfqowar46U9NC52KjiDnbVU1KDiAOrGVECcsCdD63TZWuM/jJ7+QyOLsdEYix1XauaZsH8ELl431vr3XqF4y3KswkXoOBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047477; c=relaxed/simple;
	bh=hsw4dmLDO0IRvHOt1ZB+Vq/4VCLyXIs5f3JuJx1+CWY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VXQYVbU+cI9WsI/jpVtnzQfjIY1aAtmUOhzykLtnomYayhVzNNFp9CJ8iMRfmEwHjI72gZRfy0wvgOTwjEe7nvwLrfAAdRq487aFUbU7wJ9V4Tq/LcOoGLYjuuzRz2FQS7NAZdtMZsgHWj43/N2vWhGaoaMnTbJFl6QTlDl7ymM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MrKSIaNk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef8c7ef51dso2463696a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 09:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737047475; x=1737652275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b6BdS1i1OZx1yzEmmWsGys/eOcXqAdRrl8TI77iS/98=;
        b=MrKSIaNkdLaNaFYlvAUQePrlncPIeRRPly/4E3ksoFdSv9xR73B3psd9pVLkiDG0Gs
         RSUmTUL0Xv46OuGkkxdqSoM9hHfvppSKq+Q509GWaWZFPvnDg48tEQ3NYi/D21OZ9gLH
         YXtQ3lPceX1T8mf4fmd/p9QVy6Z3ra8QpFp3D8bjW0XKQyycyJIN7IA1KdzDl1412k1g
         V82fNV+pd6Pybbqy7lbUDMrcCVcSUul3aZNKzmmIVxvgdnVNnl66/Ys/vGpCtqeuYzMx
         CGRKBvg7VXP2gSLcOx/H9BObKcwn9meqvInoPeeYgF3BeJnhgGLkKpVauTgUHbRTmfDe
         EBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737047475; x=1737652275;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b6BdS1i1OZx1yzEmmWsGys/eOcXqAdRrl8TI77iS/98=;
        b=ItblGZwlF1o06J3DXkiqxW41I/RgdUw4DbzJtuKtrLN9m42Rp7tlnN97TPG/6Zezc3
         D3zodcxmIPUdLxmTqmeDy22q/sc+sEgi4kKgNaHv8oO3a5sjEzdxrnHuvnawsF3asKjT
         UA/XrHI9iKmJUzWHywJnvV1GS/nj7WePMrz7GCbpBHrPtBdFCpHqFtp+Z2+YACeWZpqa
         yiFAox8H6YwxtS/hMtoV/cdEQ3Q3YaDAnBUWBFRu9DwVoBHka/K7iZbqb5UD6M/jWFTE
         J+xQ9K+21gV0Xuivna1B85IdNXWfW8eWZu3QIPcl1olGFPUAWsl9kvfUNHd/E4y8m4ts
         rujA==
X-Forwarded-Encrypted: i=1; AJvYcCVFYd5N4Z9+nr2clr/1sr1FZQiP7R5SyaDR0qYmmbON91xaj5kEGtont4qKv8aC+ryQ2M8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+lloPRfvGxDGOl+IFVnnQEBXuM35cpHY2fLlHCteIpfuIHF65
	kWhxqa+wANZ3yyrZNqdyfoYNojj6rNjoie5rb/wlKq2kNg9aOogWjGSu5rK5iKYMZVG+CaVF0qQ
	N6w==
X-Google-Smtp-Source: AGHT+IGGrY0DblEdfAuXF5Msofw6FAhNqcnM031T6uHpq9gjqTM3rQ/BI9bnUWqZxwquAoNfQ2S5FcE+qq4=
X-Received: from pjyr7.prod.google.com ([2002:a17:90a:e187:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ccb:b0:2ee:5c9b:35c0
 with SMTP id 98e67ed59e1d1-2f728e001damr10577562a91.9.1737047475004; Thu, 16
 Jan 2025 09:11:15 -0800 (PST)
Date: Thu, 16 Jan 2025 09:11:13 -0800
In-Reply-To: <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
Message-ID: <Z4k9seeAK09VAKiz@google.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> On Wed, Jan 15, 2025 at 9:27=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> > On Wed, Jan 15, 2025 at 7:50=E2=80=AFPM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > > Use KVM_REQ_TLB_FLUSH_GUEST in this case in
> > > nested_vmx_transition_tlb_flush() for consistency. This arguably make=
s
> > > more sense conceptually too -- L1 and L2 cannot share the TLB tag for
> > > guest-physical translations, so only flushing linear and combined
> > > translations (i.e. guest-generated translations) is needed.

No, using KVM_REQ_TLB_FLUSH_CURRENT is correct.  From *L1's* perspective, V=
PID
is enabled, and so VM-Entry/VM-Exit are NOT architecturally guaranteed to f=
lush
TLBs, and thus KVM is not required to FLUSH_GUEST.

E.g. if KVM is using shadow paging (no EPT whatsoever), and L1 has modified=
 the
PTEs used to map L2 but has not yet flushed TLBs for L2's VPID, then KVM is=
 allowed
to retain its old, "stale" SPTEs that map L2 because architecturally they a=
ren't
guaranteed to be visible to L2.

But because L1 and L2 share TLB entries *in hardware*, KVM needs to ensure =
the
hardware TLBs are flushed.  Without EPT, KVM will use different CR3s for L1=
 and
L2, but Intel's ASID tag doesn't include the CR3 address, only the PCID, wh=
ich
KVM always pulls from guest CR3, i.e. could be the same for L1 and L2.

Specifically, the synchronization of shadow roots in kvm_vcpu_flush_tlb_gue=
st()
is not required in this scenario.

  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
  {
	++vcpu->stat.tlb_flush;

	if (!tdp_enabled) {
		/*
		 * A TLB flush on behalf of the guest is equivalent to
		 * INVPCID(all), toggling CR4.PGE, etc., which requires
		 * a forced sync of the shadow page tables.  Ensure all the
		 * roots are synced and the guest TLB in hardware is clean.
		 */
		kvm_mmu_sync_roots(vcpu);
		kvm_mmu_sync_prev_roots(vcpu);
	}

	kvm_x86_call(flush_tlb_guest)(vcpu);

	/*
	 * Flushing all "guest" TLB is always a superset of Hyper-V's fine
	 * grained flushing.
	 */
	kvm_hv_vcpu_purge_flush_tlb(vcpu);
  }

