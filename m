Return-Path: <kvm+bounces-8136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBBFD84BE00
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0DDA1C24741
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7212414003;
	Tue,  6 Feb 2024 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jlu42JCt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1356314006
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707247194; cv=none; b=AARVfbMQ7EzlHmVArnVabmQS0roRgYDqJz6kqfHzVvJf33b0ycwFd8gVbZvUnDwKOuez06YRsIM56sgOdtU26ct4vBCVdtIInz2jPgod4LOy6DAFf8iAtcg/XAs/EHwONNapNs1HxRY0LZObmVNoXZ2L1zjpCB8VTfD3t4j7hos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707247194; c=relaxed/simple;
	bh=b5AaRWp16WYZMnPHIUQKy2oqQqhXiAUDnj0Ew95SwhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uSWYwJ3ABlPDBELGw30gNVK0252MBiXajD8VH/OPjTf1erOjLFkD68W0i9fudPvwXLB92g7QuszDTDJu1owcyFA288P2zF4tn3EsL7x7YJ0zJrIeYtKztjuerpcAJ056H//2sCAMkSSF/K87wOzpcyK9KNa8DT1yKlUNGvFihUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jlu42JCt; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6047a047f4cso23869077b3.3
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 11:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707247192; x=1707851992; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FS0FOOAhA/f0JzSwKGkayXczNnKAVzHdLDizOf7Wif8=;
        b=Jlu42JCtYLokM0RlIf61V7AoYnDmUg7ZzfKDohQ93QYFfj4rrkv3QjAqkT+8A8QzNX
         pVMdf4yoLo1/hFkkgd8SbVGMZJ4HeCUiQkxoAoQPxSS90e+5VbGIULgpa0bgVtOD+tKV
         sRKlFak0vKzbu5RNW5Tjo2wV4Z1GVHL9+VPmmIQ9s9pcBScpKavesKPMNe2dy0n0CsTq
         z91bq926c/IkKKKL9b0PMVXqDMX7xQy11JYwuGyeLIfP9RV5Dkvbpijb6xRTe+wIBywj
         +zYNIjtJmRrgPlAIJY9UsnLKbwXVJMVaSFQLnHV7Ml8DIm46FNdEzuxQSBb41ZamydMc
         H/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707247192; x=1707851992;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FS0FOOAhA/f0JzSwKGkayXczNnKAVzHdLDizOf7Wif8=;
        b=DVZq5UYioYZveiCy6p60Ycc4CmBbT0APF9tmKTcJFuYNHLwWxILsT1WwZKQR/J5PCf
         AYfcICTpTnDkcNvkg8CH+z/QXHxSiX6DzFAbKsi932NzRu/pp4XVV5xbP2C+BjaTtxdE
         Nvzde/t1RUeviToMs/0ZTN5D8FIJ5jHkdc3oKOU9ou9ctOsTwQlRLIIKCv9JYoh/mx3j
         fvvC51muuUAfkgNmW7gzSLw0zD8ZgUD0SnVLQDVPgyfDWKkCP/eEwPt6bSHdmElTPdr9
         8ye6DwmYRZWzXyB2DFlyJ1kcxfTQUl4lbR2QQCp0WU1MCkmXhT5jCWCQAAnb7xnY5ihk
         d51g==
X-Gm-Message-State: AOJu0YyCzxpvUvlBYey6x0snXf8yFm01/++KRz5fi/qpdIYEZk8rpFD2
	cLh+j/icN6YVEw9DOOqikYiZ7TeszTUjcFEv2J60JKQYLMR9qWeKh04pp1f97hMp9cLBFueDXsU
	9nw==
X-Google-Smtp-Source: AGHT+IG+j3o7PnzaPhnqzocLPVZgQqSBBi/CwHVbOrfESWD6Tdx1b5y32KoTallM8N+Lp1XBrGVlbBWHvas=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b91:b0:dc6:e823:9edc with SMTP id
 ei17-20020a0569021b9100b00dc6e8239edcmr655147ybb.8.1707247192139; Tue, 06 Feb
 2024 11:19:52 -0800 (PST)
Date: Tue, 6 Feb 2024 11:19:50 -0800
In-Reply-To: <6150a0a8c3d911c6c2ada23c0b9c8b35991bd235.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6150a0a8c3d911c6c2ada23c0b9c8b35991bd235.camel@infradead.org>
Message-ID: <ZcKGVoaituZPkNTU@google.com>
Subject: Re: [PATCH v4] KVM: x86/xen: Inject vCPU upcall vector when local
 APIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 16, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> Linux guests since commit b1c3497e604d ("x86/xen: Add support for
> HVMOP_set_evtchn_upcall_vector") in v6.0 onwards will use the per-vCPU
> upcall vector when it's advertised in the Xen CPUID leaves.
>=20
> This upcall is injected through the guest's local APIC as an MSI, unlike
> the older system vector which was merely injected by the hypervisor any
> time the CPU was able to receive an interrupt and the upcall_pending
> flags is set in its vcpu_info.
>=20
> Effectively, that makes the per-CPU upcall edge triggered instead of
> level triggered, which results in the upcall being lost if the MSI is
> delivered when the local APIC is *disabled*.
>=20
> Xen checks the vcpu_info->evtchn_upcall_pending flag when the local APIC
> for a vCPU is software enabled (in fact, on any write to the SPIV
> register which doesn't disable the APIC). Do the same in KVM since KVM
> doesn't provide a way for userspace to intervene and trap accesses to
> the SPIV register of a local APIC emulated by KVM.
>=20
> Astute reviewers may note that kvm_xen_inject_vcpu_vector() function has
> a WARN_ON_ONCE() in the case where kvm_irq_delivery_to_apic_fast() fails
> and returns false. In the case where the MSI is not delivered due to the
> local APIC being disabled, kvm_irq_delivery_to_apic_fast() still returns
> true but the value in *r is zero. So the WARN_ON_ONCE() remains correct,
> as that case should still never happen.
>=20
> Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcal=
l via local APIC")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Paul Durrant <paul@xen.org>
> Cc: stable@vger.kernel.org
> ---
>  v4: Reword commit message,
>      rename kvm_xen_enable_lapic() =E2=86=92 kvm_xen_sw_enable_lapic().
>  v3: Repost, add Cc:stable.
>  v2: Add Fixes: tag.
>=20
> =C2=A0arch/x86/kvm/lapic.c |=C2=A0 5 ++++-
> =C2=A0arch/x86/kvm/xen.c=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/x86/kvm/xen.h=C2=A0=C2=A0 | 18 ++++++++++++++++++
> =C2=A03 files changed, 23 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3242f3da2457..75bc7d3f0022 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -41,6 +41,7 @@
> =C2=A0#include "ioapic.h"
> =C2=A0#include "trace.h"
> =C2=A0#include "x86.h"
> +#include "xen.h"
> =C2=A0#include "cpuid.h"
> =C2=A0#include "hyperv.h"
> =C2=A0#include "smm.h"

Patch is corrupt.

git am /home/seanjc/patches/v4_20240116_dwmw2_kvm_x86_xen_inject_vcpu_upcal=
l_vector_when_local_apic_is_enabled.mbx
Applying: KVM: x86/xen: Inject vCPU upcall vector when local APIC is enable=
d
error: corrupt patch at line 17

cat ~/patches/v4_20240116_dwmw2_kvm_x86_xen_inject_vcpu_upcall_vector_when_=
local_apic_is_enabled.mbx | patch -p 1 --merge
patching file arch/x86/kvm/lapic.c
patch: **** malformed patch at line 59: =C2=A0#include "ioapic.h"

Based on what I see in a web view, I suspect something on your end is conve=
rting
whitespace to fancy unicode equivalents.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..75bc7d3f0022 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -41,6 +41,7 @@
=3DC2=3DA0#include "ioapic.h"
=3DC2=3DA0#include "trace.h"
=3DC2=3DA0#include "x86.h"
+#include "xen.h"
=3DC2=3DA0#include "cpuid.h"
=3DC2=3DA0#include "hyperv.h"
=3DC2=3DA0#include "smm.h"

