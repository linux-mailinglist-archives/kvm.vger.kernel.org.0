Return-Path: <kvm+bounces-53554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 480F3B13EA7
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6CE718944EB
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0D2276027;
	Mon, 28 Jul 2025 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zchf3Cub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F42273D78
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716810; cv=none; b=dDmHp8qnAVOmPNEr+Pqh22TGNjMYgaBueYOMgxOw01lRojE5+ofFsKJLt52DjbF+8B5+kfAM4fAray9M2XNqA4sdk4v7/gplolYs1Y2R1H1yEFq1MUBP/JtD9yYRm+I7USWMB+dNmniSBhLV8pKt5pgHLW++u5EtZbpsFJ1aq8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716810; c=relaxed/simple;
	bh=HlMutSnP9e8kI3UBisc6n45rtpmULJ1pipqjo6vBQ2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ioE1QWTDvEzQDceIqmyHBuYwsuvkWHsqRQUHBvjUQfEdKAYyc3ucnUxxElYcpXt5goBnLuuMHKhbwnN7BbhWJ2IugtVN+4GOQtweNR0E+dMG4H5SNZPIaGVly7qlglNhLFC6utPeI2rt88qujw3oa5kEgGYnUpF00YdIMUY0Hrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zchf3Cub; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23824a9bc29so77008875ad.3
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753716808; x=1754321608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fOMNGsII1GWvnmWB7ZQ29FecIW9W/uww4YWlhfBQpMk=;
        b=Zchf3CubojkQRucDe0gd7dMTGpSKjDpeRdzDD+faBMnVpBr9F5qXGAdhuYxOX/CBcZ
         yjEZhOFz7Aif6vYvELD9NP7mRG+DSSrAWv1y+HicSAzxBB2pUzJkx/GR/ZRwfsfNYu1S
         LBo0EMZxaT2V2sGIV85KxL0n9Lu0XJEUZJScXkba14p/gAqJkvkr8Yg3BXWSzUU07FNZ
         tU+PIJGGpugql14BBmo+OKcSToVst/wOIj1OUllTFjClIXrSytECN47KBQ+6Xiw8D4m/
         q19yisf/Qb2nV8vxNE26T9y682vyP3iOjJDHZJ90Jb1Gy2u0hgjrBuZC/XSsU5Fubqen
         ieOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753716808; x=1754321608;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fOMNGsII1GWvnmWB7ZQ29FecIW9W/uww4YWlhfBQpMk=;
        b=Cg+wid6BN1ZOmqkC6UMYhX/+o3FA/iZAMiXtL+tYLzzdv9MmTPUuewpiJ1C1ChvdeG
         mkO6wt0j2nODjXOMpxnTb3ZwXQDi4NoGqH3FQ51YGJm087/AN5fOzQ587n9dIDHzL8vu
         dC9ok+lZOsqxfhHLNcTqMmUTKh9KDr5D9Jmkc4P3b6HNHYZlqilp8GwaBZQQV+m/1YK7
         Gn6pmQf/WwpRZDxmLTekurdylxVYHp0E/mSXxjrQfSBuGIojV1n/tEVDZXdzs2q0NBeO
         W3Cpzv0N2Cbehy+qU5BfyKqYhqzENE5P98vbCKantJ5RpBJLIeehAJlhuiPpNhVbD4hJ
         dimw==
X-Forwarded-Encrypted: i=1; AJvYcCWiODjzPFQZEXGju2JkE606wZ0Q6t0qDPA/fW8XLPVCW9Zkbi6VgbRulRr3Je+70OuGH1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMFyoYVIwWdrwVDFzmsZhrSox/3ZQagc045G2xn9meaysmqZCV
	F6Y9wLJAlojG14fXKyA7aozJdc50tQiAo5ASs0gshxWK3A27wtPVQQHNfj6HOW66x1BhETUobTM
	m+yce+w==
X-Google-Smtp-Source: AGHT+IGxnvonRXYnaAMINBxjwtlZaos5vIwh4h6XxEER3SpElr4t8bWEkkoSwLEGYzccjdmp3ZH9ETxHVGg=
X-Received: from pjn16.prod.google.com ([2002:a17:90b:5710:b0:311:ff32:a85d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac7:b0:240:469d:beb0
 with SMTP id d9443c01a7336-240469dc081mr32575265ad.31.1753716807865; Mon, 28
 Jul 2025 08:33:27 -0700 (PDT)
Date: Mon, 28 Jul 2025 08:33:26 -0700
In-Reply-To: <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com> <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com>
 <aIDzBOmjzveLjhmk@google.com> <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
Message-ID: <aIeX0GQh1Q_4N597@google.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, Jianxiong Gao <jxgao@google.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dionna Glaze <dionnaglaze@google.com>, "H. Peter Anvin" <hpa@zytor.com>, jgross@suse.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com, 
	Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, jiewen.yao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+Jiewen

Summary, with the questions at the end.

Recent upstream kernels running in GCE SNP/TDX VMs fail to probe the TPM du=
e to
the TPM driver's ioremap (with UC) failing because the kernel has already m=
apped
the range using a cachaeable mapping (WB).

 ioremap error for 0xfed40000-0xfed45000, requested 0x2, got 0x0
 tpm_tis MSFT0101:00: probe with driver tpm_tis failed with error -12

The "guilty" commit is 8e690b817e38 ("x86/kvm: Override default caching mod=
e for
SEV-SNP and TDX"), which as the subject suggests, forces the kernel's MTRR =
memtype
to WB.  With SNP and TDX, the virtual MTRR state is (a) controlled by the V=
MM and
thus is untrusted, and (b) _should_ be irrelevant because no known hypervis=
or
actually honors the memtypes programmed into the virtual MTRRs.

It turns out that the kernel has been relying on the MTRRs to force the TPM=
 TIS
region (and potentially other regions) to be UC, so that the kernel ACPI dr=
iver's
attempts to map of SystemMemory entries as cacheable get forced to UC.  Wit=
h MTRRs
forced WB, x86_acpi_os_ioremap() succeeds in creating a WB mapping, which i=
n turn
causes the ioremap infrastructure to reject the TPM driver's UC mapping.

IIUC, the TPM entry(s) in the ACPI tables for GCE VMs are derived (built?) =
from
EDK2's TPM ASL.  And (again, IIUC), this code in SecurityPkg/Tcg/Tcg2Acpi/T=
pm.asl[1]

      //
      // Operational region for TPM access
      //
      OperationRegion (TPMR, SystemMemory, 0xfed40000, 0x5000)

generates the problematic SystemMemory entry that triggers the ACPI driver'=
s
auto-mapping logic.

QEMU-based VMs don't suffer the same fate, as QEMU intentionally[2] doesn't=
 use
EDK2's AML for the TPM, and QEMU doesn't define a SystemMemory entry, just =
a
Memory32Fixed entry.

Presumably this an EDK2 bug?  If it's not an EDK2 bug, then how is the kern=
el's
ACPI driver supposed to know that some ranges of SystemMemory must be mappe=
d UC?

[1] https://github.com/tianocore/edk2/blob/master/SecurityPkg/Tcg/Tcg2Acpi/=
Tpm.asl#L53
[2] https://lists.gnu.org/archive/html/qemu-devel/2018-02/msg03397.html

On Thu, Jul 24, 2025, Binbin Wu wrote:
> On 7/23/2025 10:34 PM, Sean Christopherson wrote:
> > On Mon, Jul 14, 2025, Nikolay Borisov wrote:
> > > On 14.07.25 =D0=B3. 12:06 =D1=87., Binbin Wu wrote:
> > > > On 7/10/2025 12:54 AM, Jianxiong Gao wrote:
> > > > > I tested this patch on top of commit 8e690b817e38, however we are
> > > > > still experiencing the same failure.
> > > > >=20
> > > > I didn't reproduce the issue with QEMU.
> > > > After some comparison on how QEMU building the ACPI tables for HPET=
 and
> > > > TPM,
> > > >=20
> > > > - For HPET, the HPET range is added as Operation Region:
> > > >   =C2=A0 =C2=A0 aml_append(dev,
> > > >   =C2=A0 =C2=A0 =C2=A0 =C2=A0 aml_operation_region("HPTM", AML_SYST=
EM_MEMORY,
> > > > aml_int(HPET_BASE),
> > > >   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0HPET_LEN));
> > > >=20
> > > > - For TPM, the range is added as 32-Bit Fixed Memory Range:
> > > >   =C2=A0 =C2=A0 if (TPM_IS_TIS_ISA(tpm_find())) {
> > > >   =C2=A0 =C2=A0 =C2=A0 =C2=A0 aml_append(crs, aml_memory32_fixed(TP=
M_TIS_ADDR_BASE,
> > > >   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0TPM_TIS_ADDR_SIZE, AML_READ_WRITE));
> > > >   =C2=A0 =C2=A0 }
> > > >=20
> > > > So, in KVM, the code patch of TPM is different from the trace for H=
PET in
> > > > the patch https://lore.kernel.org/kvm/20250201005048.657470-3-seanj=
c@google.com/,
> > > > HPET will trigger the code path acpi_os_map_iomem(), but TPM doesn'=
t.
> > Argh, I was looking at the wrong TPM resource when poking through QEMU.=
  I peeked
> > at TPM_PPI_ADDR_BASE, which gets an AML_SYSTEM_MEMORY entry, not TPM_TI=
S_ADDR_BASE.

...

> I guess google has defined a ACPI method to access the region for TPM TIS=
 during
> ACPI device probe.
>=20
> >=20
> > In the meantime, can someone who has reproduced the real issue get back=
traces to
> > confirm or disprove that acpi_os_map_iomem() is trying to map the TPM T=
IS range
> > as WB?  E.g. with something like so:

Got confirmation off-list that Google's ACPI tables due trigger the kernel'=
s
cachable mapping logic for SYSTEM_MEMORY.

 Mapping TPM TIS with req_type =3D 0
 WARNING: CPU: 22 PID: 1 at arch/x86/mm/pat/memtype.c:530 memtype_reserve+0=
x2ab/0x460
 Modules linked in:
 CPU: 22 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.16.0=
-rc7+ #2 VOLUNTARY=20
 Tainted: [W]=3DWARN
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Go=
ogle 05/29/2025
 RIP: 0010:memtype_reserve+0x2ab/0x460
  __ioremap_caller+0x16d/0x3d0
  ioremap_cache+0x17/0x30
  x86_acpi_os_ioremap+0xe/0x20
  acpi_os_map_iomem+0x1f3/0x240
  acpi_os_map_memory+0xe/0x20
  acpi_ex_system_memory_space_handler+0x273/0x440
  acpi_ev_address_space_dispatch+0x176/0x4c0
  acpi_ex_access_region+0x2ad/0x530
  acpi_ex_field_datum_io+0xa2/0x4f0
  acpi_ex_extract_from_field+0x296/0x3e0
  acpi_ex_read_data_from_field+0xd1/0x460
  acpi_ex_resolve_node_to_value+0x2ee/0x530
  acpi_ex_resolve_to_value+0x1f2/0x540
  acpi_ds_evaluate_name_path+0x11b/0x190
  acpi_ds_exec_end_op+0x456/0x960
  acpi_ps_parse_loop+0x27a/0xa50
  acpi_ps_parse_aml+0x226/0x600
  acpi_ps_execute_method+0x172/0x3e0
  acpi_ns_evaluate+0x175/0x5f0
  acpi_evaluate_object+0x213/0x490
  acpi_evaluate_integer+0x6d/0x140
  acpi_bus_get_status+0x93/0x150
  acpi_add_single_object+0x43a/0x7c0
  acpi_bus_check_add+0x149/0x3a0
  acpi_bus_check_add_1+0x16/0x30
  acpi_ns_walk_namespace+0x22c/0x360
  acpi_walk_namespace+0x15c/0x170
  acpi_bus_scan+0x1dd/0x200
  acpi_scan_init+0xe5/0x2b0
  acpi_init+0x264/0x5b0
  do_one_initcall+0x5a/0x310
  kernel_init_freeable+0x34f/0x4f0
  kernel_init+0x1b/0x200
  ret_from_fork+0x186/0x1b0
  ret_from_fork_asm+0x1a/0x30
  </TASK>

> I tried to add an AML_SYSTEM_MEMORY entry as operation region in the ACPI
> table and modify the _STA method to access the region for TPM TIS in QEMU=
, then
> the issue can be reproduced.
>=20
> diff --git a/hw/tpm/tpm_tis_isa.c b/hw/tpm/tpm_tis_isa.c
> index 876cb02cb5..aca2b2993f 100644
> --- a/hw/tpm/tpm_tis_isa.c
> +++ b/hw/tpm/tpm_tis_isa.c
> @@ -143,6 +143,9 @@ static void build_tpm_tis_isa_aml(AcpiDevAmlIf *adev,=
 Aml *scope)
> =C2=A0 =C2=A0 =C2=A0Aml *dev, *crs;
> =C2=A0 =C2=A0 =C2=A0TPMStateISA *isadev =3D TPM_TIS_ISA(adev);
> =C2=A0 =C2=A0 =C2=A0TPMIf *ti =3D TPM_IF(isadev);
> +=C2=A0 =C2=A0 Aml *field;
> +=C2=A0 =C2=A0 Aml *method;
> +=C2=A0 =C2=A0 Aml *test =3D aml_local(0);
>=20
> =C2=A0 =C2=A0 =C2=A0dev =3D aml_device("TPM");
> =C2=A0 =C2=A0 =C2=A0if (tpm_tis_isa_get_tpm_version(ti) =3D=3D TPM_VERSIO=
N_2_0) {
> @@ -152,7 +155,19 @@ static void build_tpm_tis_isa_aml(AcpiDevAmlIf *adev=
, Aml *scope)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0aml_append(dev, aml_name_decl("_HID", a=
ml_eisaid("PNP0C31")));
> =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0aml_append(dev, aml_name_decl("_UID", aml_int(1)));
> -=C2=A0 =C2=A0 aml_append(dev, aml_name_decl("_STA", aml_int(0xF)));
> +
> +=C2=A0 =C2=A0 aml_append(dev, aml_operation_region("TPMM", AML_SYSTEM_ME=
MORY, aml_int(TPM_TIS_ADDR_BASE),
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0TPM_TIS_ADDR_SIZE));
> +
> +=C2=A0 =C2=A0 field =3D aml_field("TPMM", AML_DWORD_ACC, AML_LOCK, AML_P=
RESERVE);
> +=C2=A0 =C2=A0 aml_append(field, aml_named_field("TEST", 32));
> +=C2=A0 =C2=A0 aml_append(dev, field);
> +
> +=C2=A0 =C2=A0 method =3D aml_method("_STA", 0, AML_NOTSERIALIZED);
> +=C2=A0 =C2=A0 aml_append(method, aml_store(aml_name("TEST"), test));
> +=C2=A0 =C2=A0 aml_append(method, aml_return(aml_int(0xF)));
> +=C2=A0 =C2=A0 aml_append(dev, method);



