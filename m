Return-Path: <kvm+bounces-43172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43745A863E1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 19:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A91D8C1B5D
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 16:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E983221FB2;
	Fri, 11 Apr 2025 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X4mxsts/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4588022068A
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744390678; cv=none; b=ZwYeBSrZ/K/i4f8pcoRHQbXspbPKaYTZOyOfKgRzu4yFgD0n/od6PbCQlFM3n7pa9x9F/k8HnaUAY/e3A7tyDHFwfYSlwiUPbW5GceEYGOQ6yc0c5arJFK344BBI3tJsbFVg4Qpz3FRbp7DR8Mn1uGRhysgFpr2hvIWs5KxQfHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744390678; c=relaxed/simple;
	bh=Wq5KqapYo4ta0Kf3SzH8rl9nvBIyxMOu1jOx/ourByQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uQioAaFiemjRLegL3f8Iib8k1ds0S1Zv3mbDFlnP993DQun/vUpf9ezJwdHh3oC+fZu3Rh3GiYTYZCvtvMO9I6fmmnU0qh7z10BXNDzO0neLd1Df+7o3bj/DL92tGxHvrUaC7gfj5vQtrTSrlHFD5fj9O8QurUN6KIgW5NdVf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X4mxsts/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6aaa18e8so2037470a91.1
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 09:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744390676; x=1744995476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZY/jMeoynkulV9w2VO4rS3YKDi7eh13ppuhNm2nxw78=;
        b=X4mxsts/z6aVObQStd6HXjbJJSrjaMI9+HotGWlK3DwRM6aSyskBfdSjSN2CsfxyRr
         dEMikZ/TFhNT1bKGtUvle4TfMMNNwf8W/Xd6QSXN3HCSmW9yiblKm3Hfqg/LW6euO9Lb
         7vDmZvLqAvltxci25WkagkK9HPu4DvY7Q+hYFdVZy58SzEPCekXldTuW+G1Ryh0RBtwq
         laX/tvEnevPKX/ooJd2AJ9KeJT+YhgZ4zFPuR0emxMX7WjFpw9MuwIgGiYZFR/b2+nao
         L26Pk29RaZsao2kezZiEnV5W8CPp+E0GzvP96QQ0cMAlluRU0a6qlbHx1oYUzGIwNj0X
         U3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744390676; x=1744995476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZY/jMeoynkulV9w2VO4rS3YKDi7eh13ppuhNm2nxw78=;
        b=ZrM1vCDBrLqlq4SdKHg87LwgEIrm4GcAhAvWOVDMGHboRxq/zOKYibtLTaB0E2qAzs
         sZAVq2uSB0wcKPTomx7l4Bxg9m/Tvk+ra6iH6cEwJrY8g7WF9/9oKQhuA81XgFidCTMz
         G03aNH/5VXEMDOKhCvx78KF/sVcq8NnBcJxKLfvKoAEN0hrhtVN45XiSikTDFWJi4W2x
         50YxEszJIBpcX/YRbTCMEIgQ9zQ8D/851lnKn2nGP99h7shQ4qY771W/ZyU6TLXLsyt+
         hL3U44B0xHeeMS0NVvESFhy1e2ye+yQQW0UjdEWqpDPflEtz+k15sBzcGTuftghDJ6Ex
         8duw==
X-Gm-Message-State: AOJu0YzvHfGkW2hz0XBcNsiP4jfjZ4czXYN18kzVed7d4hpGYvn7aAwR
	b67svvIbgmjZ1eRpf7/12cSy5KUjRqlfgSE4qYfq9/BETUPYGfaJ72OzLZtEWl0reFtHdztrVwF
	bmA==
X-Google-Smtp-Source: AGHT+IH7xZv5EhQslB3sVvC8MHBA+ksc9N0ZAT4JjBSUIcaU8OkwCFM8Neynlk483kpgONrQjY94qfhmJPE=
X-Received: from pjbsp7.prod.google.com ([2002:a17:90b:52c7:b0:2fa:210c:d068])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:274e:b0:2f9:c139:b61f
 with SMTP id 98e67ed59e1d1-30823670d71mr5839681a91.14.1744390676557; Fri, 11
 Apr 2025 09:57:56 -0700 (PDT)
Date: Fri, 11 Apr 2025 09:57:55 -0700
In-Reply-To: <Z/jWytoXdiGdCeXz@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324140849.2099723-1-chao.gao@intel.com> <Z_g-UQoZ8fQhVD_2@google.com>
 <Z/jWytoXdiGdCeXz@intel.com>
Message-ID: <Z_lKE-GjP3WQrdkR@google.com>
Subject: Re: [PATCH] KVM: VMX: Flush shadow VMCS on emergency reboot
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 11, 2025, Chao Gao wrote:
> On Thu, Apr 10, 2025 at 02:55:29PM -0700, Sean Christopherson wrote:
> >On Mon, Mar 24, 2025, Chao Gao wrote:
> >> Ensure the shadow VMCS cache is evicted during an emergency reboot to
> >> prevent potential memory corruption if the cache is evicted after reboot.
> >
> >I don't suppose Intel would want to go on record and state what CPUs would actually
> >be affected by this bug.  My understanding is that Intel has never shipped a CPU
> >that caches shadow VMCS state.
> 
> I am not sure. Would you like me to check internally?

Eh, if it's easy, it'd be nice to have, but don't put much effort into it.  I'm
probably being too cute in hesitating about sending this to stable@.  The risk
really shouldn't be high.

> However, SDM Chapter 26.11 includes a footnote stating:
> "
> As noted in Section 26.1, execution of the VMPTRLD instruction makes a VMCS is
> active. In addition, VM entry makes active any shadow VMCS referenced by the
> VMCS link pointer in the current VMCS. If a shadow VMCS is made active by VM
> entry, it is necessary to execute VMCLEAR for that VMCS before allowing that
> VMCS to become active on another logical processor.
> "
> 
> To me, this suggests that shadow VMCS may be cached, and software shouldn't
> assume the CPU won't cache it. But, I don't know if this is the reality or
> if the statement is merely for hardware implementation flexibility.
> 
> >
> >On a very related topic, doesn't SPR+ now flush the VMCS caches on VMXOFF?  If
> 
> Actually this behavior is not publicly documented.

Well shoot.  That should probably be remedied.  Even if the behavior is guaranteed
only on CPUs that support SEAM, _that_ detail should be documented.  I'm not
holding my breath on Intel allowing third party code in SEAM, but the mode _is_
documented in the SDM, and so IMO, the SDM should also document how things like
clearing the VMCS cache are supposed to work when there are VMCSes that "untrusted"
software may not be able to access.

> >that's going to be the architectural behavior going forward, will that behavior
> >be enumerated to software?  Regardless of whether there's software enumeration,
> >I would like to have the emergency disable path depend on that behavior.  In part
> >to gain confidence that SEAM VMCSes won't screw over kdump, but also in light of
> >this bug.
> 
> I don't understand how we can gain confidence that SEAM VMCSes won't screw
> over kdump.

If KVM relies on VMXOFF to purge the VMCS cache, then it gives a measure of
confidence that running TDX VMs won't leave behind SEAM VMCSes in the cache.  KVM
can't easily clear SEAM VMCSs, but IIRC, the memory can be "forcefully" reclaimed
by paving over it with MOVDIR64B, at which point having VMCS cache entries for
the memory would be problematic.

> If a VMM wants to leverage the VMXOFF behavior, software enumeration
> might be needed for nested virtualization. Using CPU F/M/S (SPR+) to
> enumerate a behavior could be problematic for virtualization. Right?

Yeah, F/M/S is a bad idea.  Architecturally, I think the behavior needs to be
tied to support for SEAM.  Is there a safe-ish way to probe for SEAM support,
without having to glean it from MSR_IA32_MKTME_KEYID_PARTITIONING?

> >If all past CPUs never cache shadow VMCS state, and all future CPUs flush the
> >caches on VMXOFF, then this is a glorified NOP, and thus probably shouldn't be
> >tagged for stable.
> 
> Agreed.
> 
> Sean, I am not clear whether you intend to fix this issue and, if so, how.
> Could you clarify?

Oh, I definitely plan on taking this patch, I'm just undecided on whether or not
to tag it for stable@.

