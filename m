Return-Path: <kvm+bounces-55089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BA4B2D246
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 05:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AEFA7AFE76
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D85253F21;
	Wed, 20 Aug 2025 03:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IMciItmB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B32264D5
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 03:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755659293; cv=none; b=NqgohnyH+SBZLxIwyQdbJLJcNeRvCIaK6Vobgu5Gebl6Ylk/gHMhgVQt6uJTGRkVoUW8dpZ6JmZq/QrDVcJDir8oV2FeaLtxYuKa0ZXXVQRFa2SzmM6r1d2eJ63QTO3MQv2rBQjAnprJz7LicusBjEnNQKqPl54PPn/rV1mAMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755659293; c=relaxed/simple;
	bh=SrDo3l6tDAI3xcpbuaeNpSYX3OYgbsb2SvsjCJKZ8vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZribMq1U63WyIxbnuZbtqjfvIHjUrvKzHS7h+FvSkURZgTEuy8oPPDg6VVCttpKVyWAIgn7aUxc0k1I9rqWBJSn0pSb3QQS65r0HEmoUE/RD0QDZTZIY5ZECnzvdEtE+IItpM9v/hkmucHknmizynrpi9TPfV8nBpA7tYPbexvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IMciItmB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-242d1e947feso114195ad.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 20:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755659291; x=1756264091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFgari3SJ6Zv3aVho4cCxh1qrxAz56Z6UuPaB3I9a+c=;
        b=IMciItmBgVynJAtmq7AnaXtltl0aLQ43S6X7+JfTrOJQT8gBtCiD86Gq1CiBkAy9J3
         GMCzwo7hhA6nXjzPufiQYcbRe7nP3hCgvwf2dtAsGRXBep1O1Db4EIrm5txwMqnzSb8R
         e69QgR/08mqI+b2sE1VfLgL9qH/s7B1bxxv/c4+7OjOSgp+6AZPo4RSxLuo0f7PT/SSW
         TBf7JBKn+Dh1TPnx2Ke3QDFv9pSzpxOJ7YP//xiGdEe79KuLdZl41FjlXp1y+K8bDyl2
         20PmYSFkYnxRGWa/ENxDKf4+aLBkP/xwjLxMqfZn9djCMMOPEEMf0GGo3GHa/p7n/ZiN
         gxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755659291; x=1756264091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFgari3SJ6Zv3aVho4cCxh1qrxAz56Z6UuPaB3I9a+c=;
        b=kFr87W98ysBMrfShuvzXXiSXiRHdmebMz4HqLuzZz5JUWIcClOTs3ZiP2+hvxtH52W
         3lMA32A05lbqyoYo3w0aYOpzjVrnR4RDDQwZZd1ZmiCLRcF/fksxNEIeMSMgppJQlflT
         jbluzsT1zCavenyG0EHKib3bvnpmEpW9qs+q9ZIeFm/JP1Rbpmk+Cq4PLNhICv8NG4Qz
         yEpGnsQm67pJyIR8PwJpcCPL7EEq+7kIsozznJ29wSAU4J9aRNwNdBHdvd0GpzqpQhO4
         c/JM4murqTYEcaasYwmLMr2Mr7eLlpJ1euKswVZC+oJe7Hek6ajCecPHdXfIIniaew+a
         6uNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWs+8XTqqYbwrlq2pU44tTzNDDq2VgMr1lyT/5hUHes9Jay98lRcljRbn58bgOxsDrUK48=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxktxx1hTBEjhu3Zb/NzLy4O5b7Wg7+OlZNROdHLtYd0HNUuqX
	8qGSAUQTjdgYVcM0OKbzzDGntic7k1ZfdjHNWnMUF8pbaz2iPv1IYVEgEv1gdw7R0cAxaC+3Ccz
	Ja3UZrd4CqpLJYsbWw+qilSUXDsiCQetDLebAfJya
X-Gm-Gg: ASbGncvirBh8G42vxD5PQzB2cJRQMNJriqZVfZUKFNiDzeowDoDYoBho5mTtfLpQ7p0
	X08KxM9Ttgc0PBW+UeC8aHXxZYDQ5r6PYVAph/0gnZPk5EXS99q45YMPtWQ6t40D72Pr8ZPAZHB
	R+QgeBaTeadsqOZJRA/j6STH1+0UMpUETHaVrmSdWvn9goVswSK16/Kyj6G224PgtE/lZJINRU1
	ZSOoLcTD70pFWqLxNWiQ33dOWseXTk7FWnRmvHKOrTDhmNxbqEceVJ4
X-Google-Smtp-Source: AGHT+IHbe1HzXl8UoH+zB1dMhZd24Q0x4xZkhxr+JG0B2a1qDHiFP8KmZ60IvW+WHlqgHc0mMe95c66v2Bok0dXuMLc=
X-Received: by 2002:a17:902:e551:b0:237:e45b:4f45 with SMTP id
 d9443c01a7336-245eff59781mr1974835ad.1.1755659290889; Tue, 19 Aug 2025
 20:08:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com> <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com>
 <aIDzBOmjzveLjhmk@google.com> <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com> <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
In-Reply-To: <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 19 Aug 2025 20:07:58 -0700
X-Gm-Features: Ac12FXwFIjaoMfyA4gRBWWBv-JFyesrY8os1KLWOTAQdkCuZ-XVXWvdu4NXLBgg
Message-ID: <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Jianxiong Gao <jxgao@google.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dionna Glaze <dionnaglaze@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, jgross@suse.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com, 
	Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, jiewen.yao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2025 at 12:34=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.c=
om> wrote:
>
>
>
> On 7/28/2025 11:33 PM, Sean Christopherson wrote:
> > +Jiewen
>
> Jiewen is out of the office until August 4th.

Hi Jiewen, can we get some help in deciding the next steps here?

>
> >
> > Summary, with the questions at the end.
> >
> > Recent upstream kernels running in GCE SNP/TDX VMs fail to probe the TP=
M due to
> > the TPM driver's ioremap (with UC) failing because the kernel has alrea=
dy mapped
> > the range using a cachaeable mapping (WB).
> >
> >   ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
> >   tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12
> >
> > The "guilty" commit is 8e690b817e38 ("x86/kvm: Override default caching=
 mode for
> > SEV-SNP and TDX"), which as the subject suggests, forces the kernel's M=
TRR memtype
> > to WB.  With SNP and TDX, the virtual MTRR state is (a) controlled by t=
he VMM and
> > thus is untrusted, and (b) _should_ be irrelevant because no known hype=
rvisor
> > actually honors the memtypes programmed into the virtual MTRRs.
> >
> > It turns out that the kernel has been relying on the MTRRs to force the=
 TPM TIS
> > region (and potentially other regions) to be UC, so that the kernel ACP=
I driver's
> > attempts to map of SystemMemory entries as cacheable get forced to UC. =
 With MTRRs
> > forced WB, x86_acpi_os_ioremap() succeeds in creating a WB mapping, whi=
ch in turn
> > causes the ioremap infrastructure to reject the TPM driver's UC mapping=
.
> >
> > IIUC, the TPM entry(s) in the ACPI tables for GCE VMs are derived (buil=
t?) from
> > EDK2's TPM ASL.  And (again, IIUC), this code in SecurityPkg/Tcg/Tcg2Ac=
pi/Tpm.asl[1]
> >
> >        //
> >        // Operational region for TPM access
> >        //
> >        OperationRegion (TPMR, SystemMemory, 0xfed40000, 0x5000)
> >
> > generates the problematic SystemMemory entry that triggers the ACPI dri=
ver's
> > auto-mapping logic.
> >
> > QEMU-based VMs don't suffer the same fate, as QEMU intentionally[2] doe=
sn't use
> > EDK2's AML for the TPM, and QEMU doesn't define a SystemMemory entry, j=
ust a
> > Memory32Fixed entry.
> >
> > Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the =
kernel's
> > ACPI driver supposed to know that some ranges of SystemMemory must be m=
apped UC?
> According to the ACPI spec 6.6, an operation region of SystemMemory has n=
o
> interface to specify the cacheable attribute.
>
> One solution could be using MTRRs to communicate the memory attribute of =
legacy
> PCI hole to the kernel. But during the PUCK meeting last week, Sean menti=
oned
> that "long-term, firmware should not be using MTRRs to communicate anythi=
ng to
> the kernel." So this solution is not preferred.
>
> If not MTRRs, there should be an alternative way to do the job.
> 1. ACPI table
>     According to the ACPI spec, neither operation region nor 32-Bit Fixed=
 Memory
>     Range Descriptor can specify the cacheable attribute.
>     "Address Space Resource Descriptors" could be used to describe a memo=
ry range
>     and the they can specify the cacheable attribute via "Type Specific F=
lags".
>     One of the Address Space Resource Descriptors could be added to the A=
CPI
>     table as a hint when the kernel do the mapping for operation region.
>     (There is "System Physical Address (SPA) Range Structure", which also=
 can
>     specify the cacheable attribute. But it's should be used for NVDIMMs.=
)
> 2. EFI memory map descriptor
>     EFI memory descriptor can specify the cacheable attribute. Firmware c=
an add
>     a EFI memory descriptor for the TPM TIS device as a hint when the ker=
nel do
>     the mapping for operation region.
>
> Operation region of SystemMemory is still needed if a "Control Method" of=
 APCI
> needs to access a field, e.g., the method _STA. Checking another descript=
or for
> cacheable attribute, either "Address Space Resource Descriptor" or "EFI m=
emory
> map descriptor" during the ACPI code doing the mapping for operation regi=
on
> makes the code complicated.
>
> Another thing is if long-term firmware should not be using MTRRs to to
> communicate anything to the kernel. It seems it's safer to use ioremap() =
instead
> of ioremap_cache() for MMIO resource when the kernel do the mapping for t=
he
> operation region access?
>

Would it work if instead of doubling down on declaring the low memory
above TOLUD as WB, guest kernel reserves the range as uncacheable by
default i.e. effectively simulating a ioremap before ACPI tries to map
the memory as WB?

