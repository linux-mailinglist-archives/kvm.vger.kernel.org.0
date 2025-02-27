Return-Path: <kvm+bounces-39625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 832E9A48917
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 551FF3B206D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085D426F465;
	Thu, 27 Feb 2025 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3yEKuo4f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787D234979
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740684866; cv=none; b=Npv6SqvQUKw6GwWVT8TqoxFcz/snuOJPDmymLglzK/2cGrGBUQFeicd4UFZlNFpLRhxqaKUs/h+OPmdN4ctwKEMb0YQ1gN5Io4SSlD0JVS0FDRuZEKpFYeEg6ot3XrD0+UAJYk6XO3tsq4FWDAqMvdZrb4Gl6jErbXSkbg8n8jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740684866; c=relaxed/simple;
	bh=iqMFOWoLHPzEE2F7btnovEmgqjRXPhaMKoi0v82VKo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AjAtGTREdO35o+loT/QvZh9NZrM9rtrUq8P3i1k0XF1vmcVnlwdJSlaTuy4Eyejmae//A1Z7652V3owK63Dnr7D0UGJVV/q3tdddJlmO+6uwnzOKEmJCiXwZjRQv4e8FoUfLzq5bWwwV+PWc56WtNekQXwzUyhxHtAgqdMHJnm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3yEKuo4f; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1cb0c2cbso4194261a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 11:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740684862; x=1741289662; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a17KzYivCQNainroozlTYNEBao153DxG5A3TbD1B1BQ=;
        b=3yEKuo4f/teswu2As+3lw0lv5gQhsJJufpp9x9e7MvRtpLNrOtlBkIvUrkNXTgdvZ2
         xeNLH5hOCtY3wbvJr+LzCSCttMV2qRR7sHAC92Ks3Hmc3YOf23fS2nllS3gqwvLpTf/i
         3A5+0FZsvxoOZE9eTC4iRXLHx3kZsaSUTDKRg15xa8PP5g/JB3tCFb9EWn6uxI5O530K
         o7xZkCYweNtvEnZJbR1eccJ3w9ARwHUBtPf+hHcbDSJcmVEeIjyMiK7h1BnuaO9zN8wi
         Xoxqah/370wMTEzVEumLM8XsjFFIT1tKbEEPf505/unuwD7QYQAaBqyzGTaulBPDtSTw
         AlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740684862; x=1741289662;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a17KzYivCQNainroozlTYNEBao153DxG5A3TbD1B1BQ=;
        b=iQa++W+g4BwR35rQbQCvq8DbhC3eGPYPBhS9MCsmBVw5XOh0h2wh64DMLp63Y+GHxj
         sMx4bb/rIuR5fS7LekgJ9+DlaubiLJZHzPDrq1tMTX+F5lbsuXuhUuC3q+SSyy/g/1p7
         CqJvucGGdQGtk/GqZAxnVkImhN7E5TYYWb4bFtgsHXhS1MtJ3hJEiUNQRYxr6r9+JvBh
         Xf58p8aILTEOQRtPnQwG+iC5S7P68ePfgJvHnv7nMDGsu61SVcmfhXGsb/H9/B0MQvN0
         AvZv3aD8pNMBugrJhY0mE6f4cs/5trtxEI12a6FXDayx+HGZ8oDwCarITD5wDWKx44RZ
         z5vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGtYURGvj5OAmgm+/v0lKBL6K8XBNeb61jvYclTQ/kqRSWQIoz2ZBmJvE8gk+IOAKoOy0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOYwWWsihNVrs2S4cKh/cnWrkeqZU1gfLI0yowGGQg/q1J6JcJ
	Px5Vn+gX3yu4GBwFfB9UZnRD5VGcZWgJNgQqV4LUpgjTz+SDyB4MFu/kja5l9wrC6U9DNq82k0+
	2cA==
X-Google-Smtp-Source: AGHT+IF+7pMShNlkxX9Q3ftILKLxc4OcR65JsoK+DbBdUkSfdPP3enQqEnHoYWbV/VbGsPrN73yEXxb17ZE=
X-Received: from pjboi16.prod.google.com ([2002:a17:90b:3a10:b0:2fc:1eb0:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a89:b0:2ee:8ea0:6b9c
 with SMTP id 98e67ed59e1d1-2febab570b1mr1014148a91.12.1740684862557; Thu, 27
 Feb 2025 11:34:22 -0800 (PST)
Date: Thu, 27 Feb 2025 19:34:21 +0000
In-Reply-To: <88E181D6-323E-4352-8E4C-7B7191707611@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227000705.3199706-1-seanjc@google.com> <20250227000705.3199706-3-seanjc@google.com>
 <73f00589-7d6d-489a-ae40-fefdf674ea42@suse.com> <88E181D6-323E-4352-8E4C-7B7191707611@nutanix.com>
Message-ID: <Z8C-PRStaoikVlGx@google.com>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2025, Jon Kohler wrote:
> > On Feb 27, 2025, at 1:52=E2=80=AFAM, Nikolay Borisov <nik.borisov@suse.=
com> wrote:
> >=20
> > !-------------------------------------------------------------------|
> > CAUTION: External Email

Noted.  :-D

> > |-------------------------------------------------------------------!
> >=20
> > On 27.02.25 =D0=B3. 2:07 =D1=87., Sean Christopherson wrote:
> >> Define independent macros for the RWX protection bits that are enumera=
ted
> >> via EXIT_QUALIFICATION for EPT Violations, and tie them to the RWX bit=
s in
> >> EPT entries via compile-time asserts.  Piggybacking the EPTE defines w=
orks
> >> for now, but it creates holes in the EPT_VIOLATION_xxx macros and will
> >> cause headaches if/when KVM emulates Mode-Based Execution (MBEC), or a=
ny
> >> other features that introduces additional protection information.
> >> Opportunistically rename EPT_VIOLATION_RWX_MASK to EPT_VIOLATION_PROT_=
MASK
> >> so that it doesn't become stale if/when MBEC support is added.
> >> No functional change intended.
> >> Cc: Jon Kohler <jon@nutanix.com>
> >> Cc: Nikolay Borisov <nik.borisov@suse.com>
> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >=20
> > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
>=20
> LGTM, but any chance we could hold this until I get the MBEC RFC out?=20

No?  It's definitely landing before the MBEC support, and IOM it works quit=
e nicely
with the MBEC support (my diff at the bottom).  I don't see any reason to d=
elay
or change this cleanup.

> My apologies on the delay, I caught a terrible chest cold after we met ab=
out
> it, followed by a secondary case of strep!

Ow.  Don't rush on behalf of upstream, KVM has lived without MBEC for a lon=
g time,
it's not going anywhere.o

---
 arch/x86/include/asm/vmx.h     | 4 +++-
 arch/x86/kvm/mmu/paging_tmpl.h | 9 +++++++--
 arch/x86/kvm/vmx/vmx.c         | 7 +++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d7ab0ad63be6..61e31e915e46 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -587,9 +587,11 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_PROT_READ		BIT(3)
 #define EPT_VIOLATION_PROT_WRITE	BIT(4)
 #define EPT_VIOLATION_PROT_EXEC		BIT(5)
+#define EPT_VIOLATION_PROT_USER_EXEC	BIT(6)
 #define EPT_VIOLATION_PROT_MASK		(EPT_VIOLATION_PROT_READ  | \
 					 EPT_VIOLATION_PROT_WRITE | \
-					 EPT_VIOLATION_PROT_EXEC)
+					 EPT_VIOLATION_PROT_EXEC  | \
+					 EPT_VIOLATION_PROT_USER_EXEC)
 #define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
 #define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
=20
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 68e323568e95..ede8207bf4d7 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -181,8 +181,9 @@ static inline unsigned FNAME(gpte_access)(u64 gpte)
 	unsigned access;
 #if PTTYPE =3D=3D PTTYPE_EPT
 	access =3D ((gpte & VMX_EPT_WRITABLE_MASK) ? ACC_WRITE_MASK : 0) |
-		((gpte & VMX_EPT_EXECUTABLE_MASK) ? ACC_EXEC_MASK : 0) |
-		((gpte & VMX_EPT_READABLE_MASK) ? ACC_USER_MASK : 0);
+		 ((gpte & VMX_EPT_EXECUTABLE_MASK) ? ACC_EXEC_MASK : 0) |
+		 ((gpte & VMX_EPT_USER_EXECUTABLE_MASK) ? ACC_USER_EXEC_MASK : 0) |
+		 ((gpte & VMX_EPT_READABLE_MASK) ? ACC_USER_MASK : 0);
 #else
 	BUILD_BUG_ON(ACC_EXEC_MASK !=3D PT_PRESENT_MASK);
 	BUILD_BUG_ON(ACC_EXEC_MASK !=3D 1);
@@ -511,6 +512,10 @@ static int FNAME(walk_addr_generic)(struct guest_walke=
r *walker,
 		 * ACC_*_MASK flags!
 		 */
 		walker->fault.exit_qualification |=3D EPT_VIOLATION_RWX_TO_PROT(pte_acce=
ss);
+		/* This is also wrong.*/
+		if (vcpu->arch.pt_guest_exec_control &&
+		    (pte_access & VMX_EPT_USER_EXECUTABLE_MASK))
+			walker->fault.exit_qualification |=3D EPT_VIOLATION_PROT_USER_EXEC;
 	}
 #endif
 	walker->fault.address =3D addr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0db64f4adf2a..4684647ef063 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5806,6 +5806,13 @@ static int handle_ept_violation(struct kvm_vcpu *vcp=
u)
=20
 	exit_qualification =3D vmx_get_exit_qual(vcpu);
=20
+	/*
+	 * The USER_EXEC flag is undefined if MBEC is disabled.
+	 * Note, this is wrong, MBEC should be a property of the MMU.
+	 */
+	if (!vcpu->arch.pt_guest_exec_control)
+		exit_qualification &=3D ~EPT_VIOLATION_PROT_USER_EXEC;
+
 	/*
 	 * EPT violation happened while executing iret from NMI,
 	 * "blocked by NMI" bit has to be set before next VM entry.

base-commit: 67983df09fc3f96d0d6107fe1a99d29460bab481
--=20


