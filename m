Return-Path: <kvm+bounces-55202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FFBB2E478
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 19:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D05F9A245D7
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7537274661;
	Wed, 20 Aug 2025 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q7hx7feY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675E12701CE
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755712579; cv=none; b=AWF18cR2s//YI6XxEZGxnX5JSzMz5CizkwqfZdSy9dkq3oiH+ua7ZwJTmI6T1N8Ns3b6ohOFmdTFXTKx2Nc/7obKF4fTBZ1ppJvnKipopQvA9iMt5Nz44xH0ge+NSTQY4ejn7gibe6n8z0kWSyKqaBEKP0hEQv21t9Uj0ATGwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755712579; c=relaxed/simple;
	bh=uX5nB8Zhl41q5XsHaSQVSbbKsZeTCt0ByQ4HIAfpz6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M2hkSUVsS9QX5Rl/xa0j1lrXYNCEwGO4T1UfEp2w2WmNkWHeG66Q5ny0EgX604e1uSTGsUtjUSYILNpYRezAZcYAKdMuyUEL+n/2NxeHxrDfCpGTaKXPN8xbMxgrnwsreLj7vCg/T5kNVLuqZ8u0ekLP6DrYmXRDujmjcPMYed4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q7hx7feY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47538030bfso53582a12.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755712578; x=1756317378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbHZQZRdLVaSrm6kxqey0KUiG4g0BmK/F9FrnNnAWOw=;
        b=Q7hx7feYeePep3/LRHU6MhA42hABGFCUjHMhzNJ/qEnmavJwLZFYjL0s8ZlB1NOs3P
         L4I8WuBhak9it5zt+2M5w+N76AIOrKcZq+UIHqF3jhILgtnokvccQdAAa7rcttRhNqzi
         cb/eV18OxQCA7PwnTOV3LeaREG9Qbz0axS1DDZo36fvv8FCxaIH2CczsXFImk9t7M6Fv
         rZXWpRp9L8083U3/sJGNCS1bpAri4irQhMOW4OgO2DAaCUOvzkEjhlgmIKHpefCaRB7W
         xWqJjlwWvsYg+P09W4zsP4wv+DFx0zsx7qkHG8IiZLjsFUBimM+kwMv4cRiK52xytqMo
         uvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755712578; x=1756317378;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XbHZQZRdLVaSrm6kxqey0KUiG4g0BmK/F9FrnNnAWOw=;
        b=YDD0qwlXGgl5IpkPlKyueWcv6Io8imKUsYmMt9UxHe6H3Q9SyYB8pHsn200iIaj8bK
         jdZpu06IUoceaEutqQwNCuFoJoQPAsq2nQWau0Xj040NUR6V06g0Cz2qJ4CHse6Bs7CE
         r/xtIq2pcDumKAu65hpEKei/eDhZwwGWN6QD+Z7c31KT5NL7WWFyW4MdGnIGZNx7a6tt
         J+IYp7ZCPqtHCVcN2/yD24IKOukomMNyu8PH3YPWVOCFsloWdwEtwZtIbNiGmU0Hfetm
         GMLjT6Pkm9rGuVgNmNCWrvBhbW6V6c921Cah40Fli5YQxnZy/8T/38VvRJkycAzx701R
         R7/A==
X-Forwarded-Encrypted: i=1; AJvYcCUINy8I6ikU2cobRf5Ihgq98GXFy3ZT+0Dbm762YkjV8XGgzt4FHso/UVxOIEr7LuF3Tj4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Kac/tOEz3brCMmSNnEIwmycpfZFaMlAcJWzqwaAUQk/cBwOL
	b6jClwYtgu7dXHFYIrkcuDi2xVDtQvMszt6jBE01Zde+mCFp2CrNYHJ8vQ7u76+Oj350Lf3yXnz
	/pWd5Ww==
X-Google-Smtp-Source: AGHT+IHAp7LTmShl4SOL4D3wXxkD4J6E4TLwbi07ZD6KKT45A8spNH/9ts5tmmYsaGwkfiR2Ly0PGDdmaS0=
X-Received: from pjbsy7.prod.google.com ([2002:a17:90b:2d07:b0:321:cc91:ad5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e0b:b0:31e:3bbc:e9e6
 with SMTP id 98e67ed59e1d1-324e1423f77mr5344153a91.19.1755712577632; Wed, 20
 Aug 2025 10:56:17 -0700 (PDT)
Date: Wed, 20 Aug 2025 10:56:16 -0700
In-Reply-To: <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAMGD6P1Q9tK89AjaPXAVvVNKtD77-zkDr0Kmrm29+e=i+R+33w@mail.gmail.com>
 <0dc2b8d2-6e1d-4530-898b-3cb4220b5d42@linux.intel.com> <4acfa729-e0ad-4dc7-8958-ececfae8ab80@suse.com>
 <aIDzBOmjzveLjhmk@google.com> <550a730d-07db-46d7-ac1a-b5b7a09042a6@linux.intel.com>
 <aIeX0GQh1Q_4N597@google.com> <ad616489-1546-4f6a-9242-a719952e19b6@linux.intel.com>
 <CAGtprH9EL0=Cxu7f8tD6rEvnpC7uLAw6jKijHdFUQYvbyJgkzA@mail.gmail.com>
 <20641696-242d-4fb6-a3c1-1a8e7cf83b18@linux.intel.com> <697aa804-b321-4dba-9060-7ac17e0a489f@linux.intel.com>
Message-ID: <aKYMQP5AEC2RkOvi@google.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Nikolay Borisov <nik.borisov@suse.com>, 
	Jianxiong Gao <jxgao@google.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dionna Glaze <dionnaglaze@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, jgross@suse.com, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, pbonzini@redhat.com, 
	Peter Gonda <pgonda@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, jiewen.yao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025, Binbin Wu wrote:
> On 8/20/2025 6:03 PM, Binbin Wu wrote:
> > > > > Presumably this an EDK2 bug?=C2=A0 If it's not an EDK2 bug, then =
how is the kernel's
> > > > > ACPI driver supposed to know that some ranges of SystemMemory mus=
t be mapped UC?
> >=20
> > Checked with Jiewen offline.
> >=20
> > He didn't think there was an existing interface to tell the OS to map a
> > OperationRegion of SystemMemory as UC via the ACPI table. He thought th=
e
> > OS/ACPI driver still needed to rely on MTRRs for the hint before there =
was an
> > alternative way.
> >=20
> > > > According to the ACPI spec 6.6, an operation region of SystemMemory=
 has no
> > > > interface to specify the cacheable attribute.
> > > >=20
> > > > One solution could be using MTRRs to communicate the memory attribu=
te of legacy
> > > > PCI hole to the kernel.

So IIUC, there are no bugs anywhere, just a gap in specs that has been hidd=
en
until now :-(

> > > > But during the PUCK meeting last week, Sean mentioned
> > > > that "long-term, firmware should not be using MTRRs to communicate =
anything to
> > > > the kernel." So this solution is not preferred.
> > > >=20
> > > > If not MTRRs, there should be an alternative way to do the job.
> > > > 1. ACPI table
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 According to the ACPI spec, neither operat=
ion region nor 32-Bit Fixed Memory
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 Range Descriptor can specify the cacheable=
 attribute.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 "Address Space Resource Descriptors" could=
 be used to describe a memory range
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 and the they can specify the cacheable att=
ribute via "Type Specific Flags".
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 One of the Address Space Resource Descript=
ors could be added to the ACPI
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 table as a hint when the kernel do the map=
ping for operation region.
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 (There is "System Physical Address (SPA) R=
ange Structure", which also can
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 specify the cacheable attribute. But it's =
should be used for NVDIMMs.)
> > > > 2. EFI memory map descriptor
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 EFI memory descriptor can specify the cach=
eable attribute. Firmware can add
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 a EFI memory descriptor for the TPM TIS de=
vice as a hint when the kernel do
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 the mapping for operation region.
> > > >=20
> > > > Operation region of SystemMemory is still needed if a "Control Meth=
od" of APCI
> > > > needs to access a field, e.g., the method _STA. Checking another de=
scriptor for
> > > > cacheable attribute, either "Address Space Resource Descriptor" or =
"EFI memory
> > > > map descriptor" during the ACPI code doing the mapping for operatio=
n region
> > > > makes the code complicated.
> > > >=20
> > > > Another thing is if long-term firmware should not be using MTRRs to=
 to
> > > > communicate anything to the kernel. It seems it's safer to use iore=
map() instead
> > > > of ioremap_cache() for MMIO resource when the kernel do the mapping=
 for the
> > > > operation region access?
> > > >=20
> > > Would it work if instead of doubling down on declaring the low memory
> > > above TOLUD as WB, guest kernel reserves the range as uncacheable by
> > > default i.e. effectively simulating a ioremap before ACPI tries to ma=
p
> > > the memory as WB?
> >=20
> > It seems as hacky as this patch set?
> >=20
> >=20
> Hi Sean,
>=20
> Since guest_force_mtrr_state() also supports to force MTRR variable range=
s,
> I am wondering if we could use guest_force_mtrr_state() to set the legacy=
 PCI
> hole range as UC?
>=20
> Is it less hacky?

Oh!  That's a way better idea than my hack.  I missed that the kernel would=
 still
consult MTRRs.

Compile tested only, but something like this?

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8ae750cde0c6..45c8871cdda1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -933,6 +933,13 @@ static void kvm_sev_hc_page_enc_status(unsigned long p=
fn, int npages, bool enc)
=20
 static void __init kvm_init_platform(void)
 {
+       u64 tolud =3D e820__end_of_low_ram_pfn() << PAGE_SHIFT;
+       struct mtrr_var_range pci_hole =3D {
+               .base_lo =3D tolud | X86_MEMTYPE_UC,
+               .mask_lo =3D (u32)(~(SZ_4G - tolud - 1)) | BIT(11),
+               .mask_hi =3D (BIT_ULL(boot_cpu_data.x86_phys_bits) - 1) >> =
32,
+       };
+
        if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) &&
            kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
                unsigned long nr_pages;
@@ -982,8 +989,12 @@ static void __init kvm_init_platform(void)
        kvmclock_init();
        x86_platform.apic_post_init =3D kvm_apic_init;
=20
-       /* Set WB as the default cache mode for SEV-SNP and TDX */
-       guest_force_mtrr_state(NULL, 0, MTRR_TYPE_WRBACK);
+       /*
+        * Set WB as the default cache mode for SEV-SNP and TDX, with a sin=
gle
+        * UC range for the legacy PCI hole, e.g. so that devices that expe=
ct
+        * to get UC/WC mappings don't get surprised with WB.
+        */
+       guest_force_mtrr_state(&pci_hole, 1, MTRR_TYPE_WRBACK);
 }
=20
 #if defined(CONFIG_AMD_MEM_ENCRYPT)

