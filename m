Return-Path: <kvm+bounces-52947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 472C5B0B396
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 06:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E9B77AFB0A
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 04:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2471ADC83;
	Sun, 20 Jul 2025 04:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TI4u/DM9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888C72AD0F;
	Sun, 20 Jul 2025 04:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752987407; cv=none; b=vCAKj2Ugwfl5W9zkqvWvClE1intTRmGpanCbbm39h5i0OjW2g23yUIc6W7b46iH73eByaETitSdOzTVbQywdAYMaZ49K2D2TPacPXO4AtMXUIfmqf45/0QfiX8X1/HWRGEpdtC7WDnVx/twQ3NBFZTqiuKp7elgmhNQ5rTmu8Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752987407; c=relaxed/simple;
	bh=ClBFRA57T/KZnE1ZNleoEwHp7+SFKFJMO8CTQKMf3Uw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EJKItAot3oLHhx7XLLs/kfzPJ3mUieUdfi6yjKvQdalzDWjrSYvOwI9xlKyLrDavuXsyBUkZjYAM4pgKsKO21KSVcx6sNgSMkp12wHMahYzDhCKkjh8xQ6N7SUyuo+MT+w6tn7vq7wysRZaGhGCR/gZ3Cv4C/X0S1JvdgyCwceY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TI4u/DM9; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-313154270bbso3316427a91.2;
        Sat, 19 Jul 2025 21:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752987405; x=1753592205; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mW0IUs+Np9OOb6QOX9zGXOOzxQihHH7ZfL1khk0R84g=;
        b=TI4u/DM9NKsD+xsdjLFzGPfZJU1y+PZifI+hDrkDahxeWKkA/g3crnUPg3vN7bIec6
         YZLxw411g57yxSkZ+G+e92rLVilF1qSFiNXjmNr8Hbx3zZHn3OB6P9w34/0KScwgDEYK
         tzWvDef+vRFJnIw2La0C5pAIeAmKOEmNBnh7+DbuBnmz/N3KmVbTuOBvzCyVx/N13z3B
         w0L+qv57OI9eKLL2oZZ0Snyt1IBVwk5H78NVhKO+tUOWg8uFIYrCYjG9FRcodB4W56uf
         VRN3sA/InAbao+f2Pbg59EmSkzduN+2B+37gNqhnmjVfEdyPGDeigTOr2ECaeOLcINNS
         i6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752987405; x=1753592205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mW0IUs+Np9OOb6QOX9zGXOOzxQihHH7ZfL1khk0R84g=;
        b=a4FpTlS6kGgyEc8JK3RJUVTKtdMZCnmhS/pb7oa3bPIYyamPcN3DeCeS9L6fZFlxfR
         CuhWdAcZ7Ivn8lZdhqQF5LfGGoXizL4tlGndejkZyw1BPI6tYj73kfgh1RitpVDN/HK4
         4iv7JJymK8ETHoFVIwZjNYkpfp5SHQpsLpngLhEALLz5hgHKqzmpeUipQUpGBJ2d1aBD
         JSPrFQRWMl+fq52Art92Y5w6y2q7VhXPShjUcpdZE2xVBxOwVnkS0NIBfrQ+8kCq8GtU
         gzrKCjEyv3P+z5SgAs1uoCuIig3p4OzgiN/xfGfhCeOG/CRSxUcEL5ILmNdp7Wb12FnV
         SkBg==
X-Forwarded-Encrypted: i=1; AJvYcCUdw1u9sGsb342wkx+EYepAr8RvbhQ1qLNB5S74m2IGy5xhbkyJSfqO/I+2+WTkFuDu7QM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWkRTeQoR82ULK0wy+j6HPwJoAgi738FdKkHcve0EQczOEsedP
	KyYtGc8heSVHUan1KLFRNsjoZ35LioL8jCVXJfrM+u556YJhoZ734CiR05NCe19NwocJLJJEtJ9
	n/7WmBMQS6ild4+15s5MU3UM34zD+l5WwIvSB
X-Gm-Gg: ASbGncvfHwI0gBVNhZiM0WxF2ak7BZMT7uqnG3ZXDmZxOGuB0rRYeTZeYlL9ff3Oamh
	rY9xtoeqxMpqaXejNtcqo/Yca/LV6SgLngjU5hS617Y9FyRCf8VYbzrAAPeDCj+Uml/2duigApk
	rU5s8uVe1b3HAfndpDQt3d59ERU3fVBA0tWVFPFDeyoqgq/hcPeu+yXYhnV3GZyWDhek4s7qsSm
	hhP
X-Google-Smtp-Source: AGHT+IGxWiZyFqVw9AjSaPi2Sc23P03HcxDfZWTEN4Fqh0PO26H/7Rb+SssHnNAUtj1iD6VvHNzSQ5JDeZ9ZQpeQmaE=
X-Received: by 2002:a17:90b:5385:b0:312:e51c:af67 with SMTP id
 98e67ed59e1d1-31c9f3ef43cmr20305386a91.1.1752987404676; Sat, 19 Jul 2025
 21:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-32-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-32-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Sun, 20 Jul 2025 12:56:08 +0800
X-Gm-Features: Ac12FXxbBA4rbWTateJiA4BA_Ri5AI2fUNxGPr5R3jLnVzXFRH4t9QirRzJDtBY
Message-ID: <CAMvTesBVmDRf8j9BD12-_RK5eSELqX8z6_p8whq2rostMNM6JA@mail.gmail.com>
Subject: Re: [RFC PATCH v8 31/35] x86/apic: Handle EOI writes for Secure AVIC guests
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:44=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> Secure AVIC accelerates guest's EOI msr writes for edge-triggered
> interrupts.
>
> For level-triggered interrupts, EOI msr writes trigger VC exception
> with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. To complete EOI
> handling, the VC exception handler would need to trigger a GHCB protocol
> MSR write event to notify the hypervisor about completion of the
> level-triggered interrupt. Hypervisor notification is required for
> cases like emulated IOAPIC, to complete and clear interrupt in the
> IOAPIC's interrupt state.
>
> However, VC exception handling adds extra performance overhead for
> APIC register writes. In addition, for Secure AVIC, some unaccelerated
> APIC register msr writes are trapped, whereas others are faulted. This
> results in additional complexity in VC exception handling for unacclerate=
d
> APIC msr accesses. So, directly do a GHCB protocol based APIC EOI msr wri=
te
> from apic->eoi() callback for level-triggered interrupts.
>
> Use wrmsr for edge-triggered interrupts, so that hardware re-evaluates
> any pending interrupt which can be delivered to guest vCPU. For level-
> triggered interrupts, re-evaluation happens on return from VMGEXIT
> corresponding to the GHCB event for APIC EOI msr write.
>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

--=20
Thanks
Tianyu Lan

