Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4C787ED5
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 05:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbjHYD6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 23:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbjHYD6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 23:58:35 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F341FE9
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 20:58:29 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-68a3082c771so405912b3a.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 20:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1692935908; x=1693540708;
        h=in-reply-to:references:message-id:cc:to:from:subject:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xG/xCEAP8IAw74/ICcE6ZSR4JlZdUKD92OEH0HENaY=;
        b=sf/9920Yi7miPc8ryn7bc1IXjHRT1p6O4SkIb0M3hDRMnOdnEvTX0HkfZw6f0JQKHW
         CSv701bGhHD4tY4/ZADN12S8Xn648FucPUKjCjHOY+R3zE3XCtrF6Dp3zwY77iFIWWFz
         DwBkjhxMOM+uqmBFvfjkzK1YV6kQ/StAjf7+GRQg6SI+ByiwUGE7PzyiLmdSZlpOXdX3
         i7IYjjvzJ1hPsp7tLy3xpFj3nopss2303/eRQNY+2XCgULXLtcCMSZ+3CV6rhn5/qtt/
         pAW73afvSATIg2NP/QflNgESD7Gry//HxOyWB54FE9Bp691ztr7ryykON4iMsWnwlo0y
         T+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692935908; x=1693540708;
        h=in-reply-to:references:message-id:cc:to:from:subject:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3xG/xCEAP8IAw74/ICcE6ZSR4JlZdUKD92OEH0HENaY=;
        b=ZJ4M5w++4REqBV2K+LjYMMu4BGf7hCVk5xyEycKgf2EfxlfPziH2Ut12Mms3X6DeV/
         zVytlY7AUWY1QR5JCFLdvQ6uQYzi2p+cqrlt5JFabg6UlUhLucLjumIafvAOQN4o64b2
         ogeehOJpx1gGq0GUQky1v8p+3uGeVGrbU1RwZYr+etGiIIQcZcaSPwJ9clbgo0ufYIJM
         mfzsWIlO493VuQ0gBFpfyThsEOtaibOAojpvJqOXIRC1Dkf4JljuOyFV/JiwOGfB0MbU
         LZNuSx8CYAhlNAt8/ZB0GdVx1plNRCFF7Bzo+ARBeP3MwExI4uhsQFZ/pWValQbq40LS
         rvzw==
X-Gm-Message-State: AOJu0YzOzlyRjbkZn/d8a1Otfp2Rxe0AarZAn1uk7/KWWcdAZjA3xK/U
        vl3Ml6ge37xQWjy9hxgFIISlkw==
X-Google-Smtp-Source: AGHT+IEXG9ZF9iZ8ehDcHXYP49TReYAfPJxdjkuIFAB5pzPcudO88kfZv1pGcKquNaowuV5Soe38bg==
X-Received: by 2002:a05:6a00:134a:b0:68a:582b:6b62 with SMTP id k10-20020a056a00134a00b0068a582b6b62mr19777243pfu.7.1692935908399;
        Thu, 24 Aug 2023 20:58:28 -0700 (PDT)
Received: from localhost (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79156000000b00666b012baedsm507924pfi.158.2023.08.24.20.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 20:58:27 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 25 Aug 2023 12:58:22 +0900
Subject: Re: [RFC PATCH] KVM: x86: inhibit APICv upon detecting direct APIC
 access from L2
From:   "Ake Koomsin" <ake@igel.co.jp>
To:     "Sean Christopherson" <seanjc@google.com>
Cc:     "Maxim Levitsky" <mlevitsk@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Message-Id: <CV1BMBF456FC.2DQLVV84L6TAP@localhost.localdomain>
X-Mailer: aerc 0.15.2
References: <20230807062611.12596-1-ake@igel.co.jp>
 <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
 <20230808164532.09337d49@ake-x260> <ZNLUQ6ZtugOjmlZR@google.com>
In-Reply-To: <ZNLUQ6ZtugOjmlZR@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed Aug 9, 2023 at 8:48 AM JST, Sean Christopherson wrote:
> Thank you for the detailed repro steps!  However, it's likely going to be=
 O(weeks)
> before anyone is able to look at this in detail given the extensive repro=
 steps.
> If you have bandwidth, it's probably worth trying to reproduce the proble=
m in a
> KVM selftest (or a KVM-Unit-Test), e.g. create a nested VM, send an IPI f=
rom L2,
> and see if it gets routed correctly.  This purely a suggestion to try and=
 get a
> faster fix, it's by no means necessary.

Hi

I have tried KVM Unit Test and want to report back the result.

Note 1: BitVisor does not let L2 guest see any KVM features in CPUID. It ai=
ms
to run on real hardware. The L2 guest will not be aware that it runs on a
hypervisor.

Note 2: BitVisor stops monitoring APIC access once it detects INIT in APIC
ICR write. bringup_aps() in lib/x86/smp.c unconditionally does INIT and SIP=
I
even though SMP=3D1. This is actually good to test direct physical APIC acc=
ess
from L2 guest I think. BitVisor stops monitoring APIC access after
bringup_aps() is called. No APIC access goes to L1 BitVisor after this.

=3D=3D=3D Procedure to chain-loading BitVisor and apic.efi from the unit te=
st =3D=3D=3D

1) 'hg clone http://hg.code.sf.net/p/bitvisor/code bitvisor'

2) Compile BitVisor by running 'make' command. The default config is ok.
   'bitvisor.elf' is created at the project root directory after compilatio=
n
   is done.

3) Apply the following patch to BitVisor. This is to make loadvmm.efi load
   BitVisor following by apic.efi

---------------------------------------------------------------------------=
----
diff --git a/boot/uefi-loader/loadvmm.c b/boot/uefi-loader/loadvmm.c
--- a/boot/uefi-loader/loadvmm.c
+++ b/boot/uefi-loader/loadvmm.c
@@ -212,5 +212,47 @@ efi_main (EFI_HANDLE image, EFI_SYSTEM_T
 	file->Close (file);
 	if (!boot_error)
 		return EFI_LOAD_ERROR;
+
+	static CHAR16 apic_path[4096];
+	EFI_HANDLE apic_image;
+	UINT32 npages;
+	create_file_path (loaded_image->FilePath, L"apic.efi", apic_path,
+			  sizeof apic_path / sizeof apic_path[0]);
+	status =3D fileio->OpenVolume (fileio, &file);
+	if (EFI_ERROR (status)) {
+		print (systab, L"OpenVolume ", status);
+		return status;
+	}
+	status =3D file->Open (file, &file2, apic_path, EFI_FILE_MODE_READ, 0);
+	if (EFI_ERROR (status)) {
+		print (systab, L"Open ", status);
+		return status;
+	}
+	/* apic.efi is about 1.2MB at the time of test, ~300 pages */
+	npages =3D 300;
+	status =3D systab->BootServices->AllocatePages (AllocateMaxAddress,
+						      EfiLoaderData, npages,
+						      &paddr);
+	if (EFI_ERROR (status)) {
+		print (systab, L"AllocatePages ", status);
+		return status;
+	}
+	readsize =3D npages * 4096;
+	status =3D file2->Read (file2, &readsize, (void *)paddr);
+	if (EFI_ERROR (status)) {
+		print (systab, L"Read ", status);
+		return status;
+	}
+	status =3D systab->BootServices->LoadImage (TRUE, image, NULL, (void *)pa=
ddr, readsize, &apic_image);
+	if (EFI_ERROR (status)) {
+		print (systab, L"LoadImage ", status);
+		return status;
+	}
+	status =3D systab->BootServices->StartImage (apic_image, NULL, NULL);
+	if (EFI_ERROR (status)) {
+		print (systab, L"StartImage ", status);
+		return status;
+	}
+
 	return EFI_SUCCESS;
 }
---------------------------------------------------------------------------=
----

4) Change directory to /path/to/bitvsor/boot/uefi-loader. Compile 'loadvmm.=
efi'
   by running 'make' command. Mingw64 is required to compiled the loader.
   Modify loadvmm.efi's Makefile to set your 'EXE_CC' if necessary.

5) Apply the following patch to KVM Unit Test code to copy the above
   loadvmm.efi as BOOTX64.EFI and make sure that bitvisor.elf and apic.efi =
are
   in the same folder as loadvmm.efi. The patch is dirty but it gets the jo=
b
   done. Replace '/path/to/loadvmm.efi' and '/path/to/bitvisor.elf' to matc=
h
   your testing environment.

---------------------------------------------------------------------------=
----
diff --git a/x86/efi/run b/x86/efi/run
index 85aeb94..fefb3cc 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -42,6 +42,10 @@ fi
=20
 mkdir -p "$EFI_CASE_DIR"
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
+cp "/path/to/loadvmm.efi" "$EFI_CASE_BINARY"
+cp "/path/to/bitvisor.elf" "$EFI_CASE_DIR/"
+cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/$EFI_CASE.efi"
=20
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128Mi=
B.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
---------------------------------------------------------------------------=
----

6) The following bad hack is probably needed to avoid stall when testing wi=
th
   EFI_SMP > 1

---------------------------------------------------------------------------=
----
diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index b9b91c7..ba74321 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -279,6 +279,9 @@ void bringup_aps(void)
 	/* INIT */
 	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | API=
C_INT_ASSERT, 0);
=20
+	for(int i =3D 0; i < 30000000; i++)
+		cpu_relax();
+
 	/* SIPI */
 	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0=
);
=20
---------------------------------------------------------------------------=
----

7) Compile KVM Unit Test with EFI enabled and run KVM Unit Test with the
   following command:

   ./x86/efi/run apic.efi -cpu host -m 2048M

The following section is the report from testing on my machine

CPU: 13th Gen Intel i5-13600K (20) @ 5.100GHz
Kernel: Latest kvm.git, default config
QEMU Version: 8.0.4

=3D=3D=3D enable_apicv=3DN and EFI_SMP=3D1 report =3D=3D=3D

BdsDxe: loading Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
BdsDxe: starting Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
Loading ...............................................................
Starting BitVisor...
Copyright (c) 2007, 2008 University of Tsukuba
All rights reserved.
ACPI DMAR not found.
FACS address 0x7FBDD000
Module not found.
Processor 0 (BSP)
oooooooooooooooooooooooooooooooooooooooooooooooooo
Disable ACPI S3
Using VMX.
Processor 0 3494489584 Hz
Loading drivers.
AES/AES-XTS Encryption Engine initialized (AES=3Dopenssl)
Copyright (c) 1998-2002 The OpenSSL Project.  All rights reserved.
Generic ATA/ATAPI para pass-through driver 0.4 registered
Generic AHCI para pass-through driver registered
Generic RAID para pass-through driver registered
Generic IEEE1394 para pass-through driver 0.1 registered
Aquantia AQC107 Ethernet Driver registered
Broadcom NetXtreme Gigabit Ethernet Driver registered
VPN for Intel PRO/100 registered
Intel PRO/1000 driver registered
Realtek Ethernet Driver registered
virtio-net virtual driver registered
NVMe para pass-through driver registered
NVMe para pass-through driver registered
PCI device concealer registered
PCI device monitor registered
Generic EHCI para pass-through driver 0.9 registered
Generic EHCI para pass-through driver 0.9 registered
Generic UHCI para pass-through driver 1.0 registered
xHCI para pass-through driver 0.1 registered
Intel Corporation Ethernet Controller 10 Gigabit X540 Driver registered
PCI: finding devices...
PCI: 6 devices found
Starting a virtual machine.
enabling apic
smp: waiting for 0 APs
Address of image is: 0x7e6b7000
paging enabled
cr0 =3D 80010021
cr3 =3D 153f000
BdsDxe: loading Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
BdsDxe: starting Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
Loading ...............................................................
Starting BitVisor...
Copyright (c) 2007, 2008 University of Tsukuba
All rights reserved.
ACPI DMAR not found.
FACS address 0x7FBDD000
Module not found.
Processor 0 (BSP)
oooooooooooooooooooooooooooooooooooooooooooooooooo
Disable ACPI S3
Using VMX.
Processor 0 3494527968 Hz
Loading drivers.
AES/AES-XTS Encryption Engine initialized (AES=3Dopenssl)
Copyright (c) 1998-2002 The OpenSSL Project.  All rights reserved.
Generic ATA/ATAPI para pass-through driver 0.4 registered
Generic AHCI para pass-through driver registered
Generic RAID para pass-through driver registered
Generic IEEE1394 para pass-through driver 0.1 registered
Aquantia AQC107 Ethernet Driver registered
Broadcom NetXtreme Gigabit Ethernet Driver registered
VPN for Intel PRO/100 registered
Intel PRO/1000 driver registered
Realtek Ethernet Driver registered
virtio-net virtual driver registered
NVMe para pass-through driver registered
NVMe para pass-through driver registered
PCI device concealer registered
PCI device monitor registered
Generic EHCI para pass-through driver 0.9 registered
Generic EHCI para pass-through driver 0.9 registered
Generic UHCI para pass-through driver 1.0 registered
xHCI para pass-through driver 0.1 registered
Intel Corporation Ethernet Controller 10 Gigabit X540 Driver registered
PCI: finding devices...
PCI: 6 devices found
Starting a virtual machine.
enabling apic
smp: waiting for 0 APs
Address of image is: 0x7e6b7000
paging enabled
cr0 =3D 80010021
cr3 =3D 153f000
cr4 =3D 628
apic version: 14
PASS: apic existence
PASS: apic_disable: Local apic disabled
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is clear
PASS: apic_disable: *0xfee00030: ffffffff
PASS: apic_disable: CR8: 0
PASS: apic_disable: CR8: f
PASS: apic_disable: *0xfee00080: ffffffff
PASS: apic_disable: Local apic enabled in xAPIC mode
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is set
PASS: apic_disable: *0xfee00030: 50014
PASS: apic_disable: *0xfee00080: 0
PASS: apic_disable: *0xfee00080: f0
PASS: apic_disable: Local apic enabled in x2APIC mode
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is set
PASS: apic_disable: *0xfee00030: ffffffff
PASS: apic_disable: CR8: 0
PASS: apic_disable: CR8: f
PASS: apic_disable: *0xfee00080: ffffffff
x2apic enabled
PASS: x2apic enabled to invalid state
PASS: x2apic enabled to apic enabled
PASS: x2apic enabled to disabled state
PASS: disabled to invalid state
PASS: disabled to x2apic enabled
PASS: apic disabled to apic enabled
PASS: apic enabled to invalid state
PASS: self_ipi_xapic: Local apic enabled in xAPIC mode
PASS: self_ipi_xapic: self ipi
PASS: self_ipi_x2apic: Local apic enabled in x2APIC mode
PASS: self_ipi_x2apic: self ipi
starting broadcast (x2apic)
PASS: APIC physical broadcast address
PASS: APIC physical broadcast shorthand
PASS: PV IPIs testing
PASS: pending nmi
PASS: APIC LVT timer one shot
starting apic change mode
PASS: TMICT value reset
PASS: TMCCT should have a non-zero value
PASS: TMCCT should have reached 0
PASS: TMCCT should have a non-zero value
PASS: TMCCT should not be reset to TMICT value
PASS: TMCCT should be reset to the initial-count
PASS: TMCCT should not be reset to init
PASS: TMCCT should have reach zero
PASS: TMCCT should stay at zero
PASS: tsc deadline timer
PASS: tsc deadline timer clearing
PASS: apicbase: relocate apic
PASS: apicbase: reserved physaddr bits
PASS: apicbase: reserved low bits
SUMMARY: 48 tests

=3D=3D=3D enable_apicv=3DN and EFI_SMP=3D2 report =3D=3D=3D

BdsDxe: loading Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
BdsDxe: starting Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
Loading ...............................................................
Starting BitVisor...
Copyright (c) 2007, 2008 University of Tsukuba
All rights reserved.
ACPI DMAR not found.
FACS address 0x7FBDD000
Module not found.
Processor 0 (BSP)
oooooooooooooooooooooooooooooooooooooooooooooooooo
Disable ACPI S3
Using VMX.
Processor 0 3494511056 Hz
Loading drivers.
AES/AES-XTS Encryption Engine initialized (AES=3Dopenssl)
Copyright (c) 1998-2002 The OpenSSL Project.  All rights reserved.
Generic ATA/ATAPI para pass-through driver 0.4 registered
Generic AHCI para pass-through driver registered
Generic RAID para pass-through driver registered
Generic IEEE1394 para pass-through driver 0.1 registered
Aquantia AQC107 Ethernet Driver registered
Broadcom NetXtreme Gigabit Ethernet Driver registered
VPN for Intel PRO/100 registered
Intel PRO/1000 driver registered
Realtek Ethernet Driver registered
virtio-net virtual driver registered
NVMe para pass-through driver registered
NVMe para pass-through driver registered
PCI device concealer registered
PCI device monitor registered
Generic EHCI para pass-through driver 0.9 registered
Generic EHCI para pass-through driver 0.9 registered
Generic UHCI para pass-through driver 1.0 registered
xHCI para pass-through driver 0.1 registered
Intel Corporation Ethernet Controller 10 Gigabit X540 Driver registered
PCI: finding devices...
PCI: 6 devices found
Starting a virtual machine.
enabling apic
smp: waiting for 1 APs
... Likely need bad hack in step 6 to continue ...
enabling apic
setup: CPU 1 online
Address of image is: 0x7e6b9000
paging enabled
cr0 =3D 80010021
cr3 =3D 153f000
cr4 =3D 628
apic version: 14
PASS: apic existence
PASS: apic_disable: Local apic disabled
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is clear
PASS: apic_disable: *0xfee00030: ffffffff
PASS: apic_disable: CR8: 0
PASS: apic_disable: CR8: f
PASS: apic_disable: *0xfee00080: ffffffff
PASS: apic_disable: Local apic enabled in xAPIC mode
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is set
PASS: apic_disable: *0xfee00030: 50014
PASS: apic_disable: *0xfee00080: 0
PASS: apic_disable: *0xfee00080: f0
PASS: apic_disable: Local apic enabled in x2APIC mode
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is set
PASS: apic_disable: *0xfee00030: ffffffff
PASS: apic_disable: CR8: 0
PASS: apic_disable: CR8: f
PASS: apic_disable: *0xfee00080: ffffffff
x2apic enabled
PASS: x2apic enabled to invalid state
PASS: x2apic enabled to apic enabled
PASS: x2apic enabled to disabled state
PASS: disabled to invalid state
PASS: disabled to x2apic enabled
PASS: apic disabled to apic enabled
PASS: apic enabled to invalid state
PASS: self_ipi_xapic: Local apic enabled in xAPIC mode
PASS: self_ipi_xapic: self ipi
PASS: self_ipi_x2apic: Local apic enabled in x2APIC mode
PASS: self_ipi_x2apic: self ipi
starting broadcast (x2apic)
PASS: APIC physical broadcast address
PASS: APIC physical broadcast shorthand
PASS: PV IPIs testing
PASS: nmi-after-sti
FAIL: multiple nmi
PASS: pending nmi
PASS: APIC LVT timer one shot
starting apic change mode
PASS: TMICT value reset
PASS: TMCCT should have a non-zero value
PASS: TMCCT should have reached 0
PASS: TMCCT should have a non-zero value
PASS: TMCCT should not be reset to TMICT value
PASS: TMCCT should be reset to the initial-count
PASS: TMCCT should not be reset to init
PASS: TMCCT should have reach zero
PASS: TMCCT should stay at zero
PASS: tsc deadline timer
PASS: tsc deadline timer clearing
PASS: xapic id matches cpuid
PASS: writeable xapic id
PASS: non-writeable x2apic id
PASS: sane x2apic id
PASS: x2apic id matches cpuid
PASS: correct xapic id after reset
PASS: apicbase: relocate apic
PASS: apicbase: reserved physaddr bits
PASS: apicbase: reserved low bits
SUMMARY: 56 tests, 1 unexpected failures

=3D=3D=3D enable_apicv=3DY and EFI_SMP=3D1 report =3D=3D=3D

BdsDxe: loading Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
BdsDxe: starting Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x3,0x0)
Loading ...............................................................
Starting BitVisor...
Copyright (c) 2007, 2008 University of Tsukuba
All rights reserved.
ACPI DMAR not found.
FACS address 0x7FBDD000
Module not found.
Processor 0 (BSP)
oooooooooooooooooooooooooooooooooooooooooooooooooo
Disable ACPI S3
Using VMX.
Processor 0 3494569088 Hz
Loading drivers.
AES/AES-XTS Encryption Engine initialized (AES=3Dopenssl)
Copyright (c) 1998-2002 The OpenSSL Project.  All rights reserved.
Generic ATA/ATAPI para pass-through driver 0.4 registered
Generic AHCI para pass-through driver registered
Generic RAID para pass-through driver registered
Generic IEEE1394 para pass-through driver 0.1 registered
Aquantia AQC107 Ethernet Driver registered
Broadcom NetXtreme Gigabit Ethernet Driver registered
VPN for Intel PRO/100 registered
Intel PRO/1000 driver registered
Realtek Ethernet Driver registered
virtio-net virtual driver registered
NVMe para pass-through driver registered
NVMe para pass-through driver registered
PCI device concealer registered
PCI device monitor registered
Generic EHCI para pass-through driver 0.9 registered
Generic EHCI para pass-through driver 0.9 registered
Generic UHCI para pass-through driver 1.0 registered
xHCI para pass-through driver 0.1 registered
Intel Corporation Ethernet Controller 10 Gigabit X540 Driver registered
PCI: finding devices...
PCI: 6 devices found
Starting a virtual machine.
enabling apic
smp: waiting for 0 APs
Address of image is: 0x7e6c0000
paging enabled
cr0 =3D 80010021
cr3 =3D 153f000
cr4 =3D 628
apic version: 14
PASS: apic existence
PASS: apic_disable: Local apic disabled
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is clear
PASS: apic_disable: *0xfee00030: ffffffff
PASS: apic_disable: CR8: 0
PASS: apic_disable: CR8: f
PASS: apic_disable: *0xfee00080: ffffffff
PASS: apic_disable: Local apic enabled in xAPIC mode
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is set
PASS: apic_disable: *0xfee00030: 50014
PASS: apic_disable: *0xfee00080: 0
PASS: apic_disable: *0xfee00080: f0
PASS: apic_disable: Local apic enabled in x2APIC mode
PASS: apic_disable: CPUID.1H:EDX.APIC[bit 9] is set
PASS: apic_disable: *0xfee00030: ffffffff
PASS: apic_disable: CR8: 0
PASS: apic_disable: CR8: f
PASS: apic_disable: *0xfee00080: ffffffff
x2apic enabled
PASS: x2apic enabled to invalid state
PASS: x2apic enabled to apic enabled
PASS: x2apic enabled to disabled state
PASS: disabled to invalid state
PASS: disabled to x2apic enabled
PASS: apic disabled to apic enabled
PASS: apic enabled to invalid state
PASS: self_ipi_xapic: Local apic enabled in xAPIC mode
PASS: self_ipi_xapic: self ipi
PASS: self_ipi_x2apic: Local apic enabled in x2APIC mode
FAIL: self_ipi_x2apic: self ipi
starting broadcast (x2apic)
FAIL: APIC physical broadcast address
FAIL: APIC physical broadcast shorthand
PASS: PV IPIs testing
PASS: pending nmi
...Stall...

=3D=3D=3D enable_apicv=3DY and EFI_SMP=3D2 report =3D=3D=3D

BdsDxe: loading Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x4,0x0)
BdsDxe: starting Boot0001 "UEFI Misc Device" from PciRoot(0x0)/Pci(0x4,0x0)
Loading ...............................................................
Starting BitVisor...
Copyright (c) 2007, 2008 University of Tsukuba
All rights reserved.
ACPI DMAR not found.
FACS address 0x7FBDD000
Module not found.
Processor 0 (BSP)
oooooooooooooooooooooooooooooooooooooooooooooooooo
Disable ACPI S3
Using VMX.
Processor 0 3494574368 Hz
Loading drivers.
AES/AES-XTS Encryption Engine initialized (AES=3Dopenssl)
Copyright (c) 1998-2002 The OpenSSL Project.  All rights reserved.
Generic ATA/ATAPI para pass-through driver 0.4 registered
Generic AHCI para pass-through driver registered
Generic RAID para pass-through driver registered
Generic IEEE1394 para pass-through driver 0.1 registered
Aquantia AQC107 Ethernet Driver registered
Broadcom NetXtreme Gigabit Ethernet Driver registered
VPN for Intel PRO/100 registered
Intel PRO/1000 driver registered
Realtek Ethernet Driver registered
virtio-net virtual driver registered
NVMe para pass-through driver registered
NVMe para pass-through driver registered
PCI device concealer registered
PCI device monitor registered
Generic EHCI para pass-through driver 0.9 registered
Generic EHCI para pass-through driver 0.9 registered
Generic UHCI para pass-through driver 1.0 registered
xHCI para pass-through driver 0.1 registered
Intel Corporation Ethernet Controller 10 Gigabit X540 Driver registered
PCI: finding devices...
PRO/1000 found.
MAC Address: 52:54:00:12:34:56
core_io_unregister_handler: port: c180-c19f
Uninstall 2 protocol(s) successfully
[0000:00:02.0] Disconnected PCI device drivers
Wait for PHY reset and link setup completion.
PCI: 7 devices found
Starting a virtual machine.
enabling apic
smp: waiting for 1 APs
... Likely need bad hack in step 6 to continue ...
enabling apic
setup: CPU 1 online
Address of image is: 0x7e461000
paging enabled
cr0 =3D 80010021
cr3 =3D 153f000
cr4 =3D 628
...Stall...

When enable_apicv=3DN, it can complete the test while with enable_apicv=3DY=
, it
cannot.

I am not sure if I violate any assumption KVM Unit Test made by doing this
experiment. However, I think it is worth reporting.

Feel free to ask me if there are problems when trying to reproduce the
experiment or you need more info.


Best Regards
Ake Koomsin
