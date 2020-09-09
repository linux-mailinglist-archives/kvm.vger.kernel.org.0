Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2601D2632C0
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 18:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbgIIQto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 12:49:44 -0400
Received: from mail-co1nam11on2048.outbound.protection.outlook.com ([40.107.220.48]:18128
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730770AbgIIQGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 12:06:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeErEqhTPGP4Y8011W7EP7fynbTgAycRHafFKWP5DIvgLdmm//jGm4SmgTGqF7U/1RubfMEExC5Eq2FT4hPfa8Odu3hSDJiu22D4j+3v+8tRO6WgfIs10+Enp5uJTwzqnX3Cl4CVTgVVwxW5Q0FsWvGEl7gLcs5hcyokLljBzEFDvgFu+wNewVr6FWaMHOP4M906fINCR4TaK2iT29Yd+2kd+8gZoONWR6AEqlZzy2pZ44OseZ9KL27nAODw4HAKrYLuBx4Z23Sc6/cGGgZIH6C46sVkSlW8jB8ZdtOKjqVcvTzTkj8/Iour2H6WuJ/gMNkruzlM28pYv/eI2fP3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRQF+/5AfGyrtJWZAPS3XPROzdBCQi64QCs0uhXV0NU=;
 b=C6dIIAIFlZZ9z+gkb8AfqzatArfsQrgtkr0CeVm1EGcrvYYafolapvvLOPllqQWqM65LHda0mxbLtXthUSasnCuMVPQ4uMvoO6+P6Wc88EyemS3cafeLyr1wxT7CIZBPT1nDxpRZkoDag6Y8kNfBIcGzfKK5xepLUze7Vhhm7/lrimgiLbecm7VMtS4mbe5nUsyLRKJGPfLRrpIq4x/NIDZZah8xMPNcmsKwdxzgDm0Pvm1VIZnD6vvU/5fZBGporJTgZKHDyqt99gVi8jjiMnh/QGhwkRQQ/K4j3e2Uqcy8HY8J4m6fwAyhDquB2cXQFtsqsqPcziwihf6FW2PrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRQF+/5AfGyrtJWZAPS3XPROzdBCQi64QCs0uhXV0NU=;
 b=ZdcXk3heIys/PHJl0omWZfcYu/KXhiJb4yz2/T99d3iBDKWjXj7fmH6PkTJGOgdJbOIFYc7sXSEpz7ZXnTAEAi5IHwI6GvrWYYAQ+ZsgCWb3vuBVcjft4jsta1JmBwHVusRcRZMPuMCRQN6WRUokYz5TzK4Iorcn+xv71HaSIyg=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2892.namprd12.prod.outlook.com (2603:10b6:5:182::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 9 Sep 2020 13:49:39 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 13:49:39 +0000
Subject: Re: [PATCH v7 71/72] x86/efi: Add GHCB mappings when SEV-ES is active
To:     Laszlo Ersek <lersek@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, brijesh.singh@amd.com
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-72-joro@8bytes.org> <20200908174616.GJ25236@zn.tnic>
 <CAMj1kXHbePrDYXGbVG0fHfH5=M19ZpCLm9YVTs-yKTuR_jFLDg@mail.gmail.com>
 <e3911fe6-84e8-cb50-d95d-e33f8ae005f8@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c31d889b-c0e8-8b3c-74da-40a73f82b09b@amd.com>
Date:   Wed, 9 Sep 2020 08:49:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <e3911fe6-84e8-cb50-d95d-e33f8ae005f8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0061.namprd05.prod.outlook.com
 (2603:10b6:803:41::38) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0061.namprd05.prod.outlook.com (2603:10b6:803:41::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.11 via Frontend Transport; Wed, 9 Sep 2020 13:49:37 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c903d06d-406b-4bba-89a8-08d854c731f9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2892362FD716BD2B9AC117ADEC260@DM6PR12MB2892.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZXT064yKYXtremv322srydE/DY9NzmIDk5Ia+AUp12aUuhZxMdBbhfIWffiCy5gEs2mqPXAK6KxtqGNyVGq0/8RDEAavMcgBroZ70iSqq4F1xDDB9AKwcle755nOjPRCcgqUKZEc5k4ZJtN4e7vzUF5fK0Yvp5vMc8qzsch0B8nukUOT3NOy68MlMvOxHeYp91OTZTpYFfHPn5QZB/lXP032X1z1zfyiZH8Q/tK8h13w+12qezwSudkQn7q4FAT9qT/Cbs0E3+0tJpk7Q0xLRiveX/USLB878jgA+MMCq1Ff+llSI5ov/BZqGJzLdLyHrxseRpthwe0ZlF0B8/allIT5wGVPh3eCV9Uk4JA+vvTpRxeHpkN8PtQe0fjexnbm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(52116002)(83380400001)(53546011)(6486002)(6506007)(31686004)(956004)(2616005)(86362001)(7416002)(8936002)(186003)(66946007)(66556008)(478600001)(2906002)(66476007)(26005)(4326008)(16526019)(8676002)(6512007)(6636002)(316002)(31696002)(110136005)(36756003)(5660300002)(30864003)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TiaHpuCFEdB3hHNrCiWM31B+GJ4MVQvqU3pypq4izWrASXDbQYqRTrDeGprsL3/d96XRLPA+ISIaK2d2ZCuBPO3qXTV7WJni14ykjt+7ZgtjXyA1w9E2WG4obGRVUuFv/pWcxeZGGAfjq9FArW7io0VIU8KMCRpnCVTUSs3r77fl04xYjugH4VdkPNdsDDwdffidyoBcq98VkbYGbs86vtkA7njj0BnjL4MZs74mIhHn9fFdFfo9rwnuLzZlpewG+uG9wWCy9TW0aofYUw75M/s5/1lHGEgN1YN8D7phUR59O6bGEnUP7M+lV6JLDj3wnxdaKt1DGvkV+pjITCsm5Rkck9ufGcFHb8ZE983hLIXOr21i8mLQYRzn9UMtnx/QmLSPvIxLk6hn0MZcuzsfV1qzh33NR9CsbQ0G1J5dlDFvpYbYC2z5cB0i+0bqbYhtR0G/ZvvTxE4/91DpMIdAvWvDk8nIUkhj6hQBYcW9u5H2ceMAx279cvdvwQNdKEsurUFvCCAjpwVJ4/dxJcjUCCn2trirnO2oeGvDS1TvSzD/Gd9leeo3AwlufQ7sONVE3IftopDxZoQUPFbb5ur2+CJH6WxVra+i7eXwtLM9BEaFidwGEfFw1bgW6JqpN6YDzDyS047ywSSZGPfo1jdb7g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c903d06d-406b-4bba-89a8-08d854c731f9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 13:49:39.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0n/8pShLoAakiOE8TAab9bI8th3oDmxPf91Bc/npAI1ihjkxxkWD9gX2txjjh3LU9ewkaPQKDP103B1mQmfyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2892
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/20 7:44 AM, Laszlo Ersek wrote:
> On 09/09/20 10:27, Ard Biesheuvel wrote:
>> (adding Laszlo and Brijesh)
>>
>> On Tue, 8 Sep 2020 at 20:46, Borislav Petkov <bp@alien8.de> wrote:
>>>
>>> + Ard so that he can ack the efi bits.
>>>
>>> On Mon, Sep 07, 2020 at 03:16:12PM +0200, Joerg Roedel wrote:
>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>
>>>> Calling down to EFI runtime services can result in the firmware
>>>> performing VMGEXIT calls. The firmware is likely to use the GHCB of
>>>> the OS (e.g., for setting EFI variables),
> 
> I've had to stare at this for a while.
> 
> Because, normally a VMGEXIT is supposed to occur like this:
> 
> - guest does something privileged
> - resultant non-automatic exit (NAE) injects a #VC exception
> - exception handler figures out what that privileged thing was
> - exception handler submits request to hypervisor via GHCB contents plus
>    VMGEXIT instruction
> 
> Point being, the agent that "owns" the exception handler is supposed to
> pre-allocate or otherwise provide the GHCB too, for information passing.
> 
> So... what is the particular NAE that occurs during the execution of
> UEFI runtime services (at OS runtime)?
> 
> And assuming it occurs, I'm unsure if the exception handler (IDT) at
> that point is owned (temporarily?) by the firmware.
> 
> - If the #VC handler comes from the firmware, then I don't know why it
> would use the OS's GHCB.
> 
> - If the #VC handler comes from the OS, then I don't understand why the
> commit message says "firmware performing VMGEXIT", given that in this
> case it would be the OS's #VC handler executing VMGEXIT.
> 
> So, I think the above commit message implies a VMGEXIT *without* a NAE /
> #VC context. (Because, I fail to interpret the commit message in a NAE /
> #VC context in any way; see above.)

Correct.

> 
> OK, so let's see where the firmware performs a VMGEXIT *outside* of an
> exception handler, *while* at OS runtime. There seems to be one, in file
> "OvmfPkg/QemuFlashFvbServicesRuntimeDxe/QemuFlashDxe.c":

Again, correct. Basically this is what is invoked when setting UEFI variables.

> 
>> VOID
>> QemuFlashPtrWrite (
>>    IN        volatile UINT8    *Ptr,
>>    IN        UINT8             Value
>>    )
>> {
>>    if (MemEncryptSevEsIsEnabled ()) {
>>      MSR_SEV_ES_GHCB_REGISTER  Msr;
>>      GHCB                      *Ghcb;
>>
>>      Msr.GhcbPhysicalAddress = AsmReadMsr64 (MSR_SEV_ES_GHCB);
>>      Ghcb = Msr.Ghcb;
>>
>>      //
>>      // Writing to flash is emulated by the hypervisor through the use of write
>>      // protection. This won't work for an SEV-ES guest because the write won't
>>      // be recognized as a true MMIO write, which would result in the required
>>      // #VC exception. Instead, use the the VMGEXIT MMIO write support directly
>>      // to perform the update.
>>      //
>>      VmgInit (Ghcb);
>>      Ghcb->SharedBuffer[0] = Value;
>>      Ghcb->SaveArea.SwScratch = (UINT64) (UINTN) Ghcb->SharedBuffer;
>>      VmgExit (Ghcb, SVM_EXIT_MMIO_WRITE, (UINT64) (UINTN) Ptr, 1);
>>      VmgDone (Ghcb);
>>    } else {
>>      *Ptr = Value;
>>    }
>> }
> 
> This function *does* run at OS runtime (as a part of non-volatile UEFI
> variable writes).
> 
> And note that, wherever MSR_SEV_ES_GHCB points to at the moment, is used
> as GHCB.
> 
> If the guest kernel allocates its own GHCB and writes the allocation
> address to MSR_SEV_ES_GHCB, then indeed the firmware will use the GHCB
> of the OS.
> 
> I reviewed edk2 commit 437eb3f7a8db
> ("OvmfPkg/QemuFlashFvbServicesRuntimeDxe: Bypass flash detection with
> SEV-ES", 2020-08-17), but I admit I never thought of the guest OS
> changing MSR_SEV_ES_GHCB. I'm sorry about that.
> 
> As long as this driver is running before OS runtime (i.e., during the
> DXE and BDS phases), MSR_SEV_ES_GHCB is supposed to carry the value we
> set in "OvmfPkg/PlatformPei/AmdSev.c":
> 
>> STATIC
>> VOID
>> AmdSevEsInitialize (
>>    VOID
>>    )
>> {
>>    VOID              *GhcbBase;
>>    PHYSICAL_ADDRESS  GhcbBasePa;
>>    UINTN             GhcbPageCount, PageCount;
>>    RETURN_STATUS     PcdStatus, DecryptStatus;
>>    IA32_DESCRIPTOR   Gdtr;
>>    VOID              *Gdt;
>>
>>    if (!MemEncryptSevEsIsEnabled ()) {
>>      return;
>>    }
>>
>>    PcdStatus = PcdSetBoolS (PcdSevEsIsEnabled, TRUE);
>>    ASSERT_RETURN_ERROR (PcdStatus);
>>
>>    //
>>    // Allocate GHCB and per-CPU variable pages.
>>    //   Since the pages must survive across the UEFI to OS transition
>>    //   make them reserved.
>>    //
>>    GhcbPageCount = mMaxCpuCount * 2;
>>    GhcbBase = AllocateReservedPages (GhcbPageCount);
>>    ASSERT (GhcbBase != NULL);
>>
>>    GhcbBasePa = (PHYSICAL_ADDRESS)(UINTN) GhcbBase;
>>
>>    //
>>    // Each vCPU gets two consecutive pages, the first is the GHCB and the
>>    // second is the per-CPU variable page. Loop through the allocation and
>>    // only clear the encryption mask for the GHCB pages.
>>    //
>>    for (PageCount = 0; PageCount < GhcbPageCount; PageCount += 2) {
>>      DecryptStatus = MemEncryptSevClearPageEncMask (
>>        0,
>>        GhcbBasePa + EFI_PAGES_TO_SIZE (PageCount),
>>        1,
>>        TRUE
>>        );
>>      ASSERT_RETURN_ERROR (DecryptStatus);
>>    }
>>
>>    ZeroMem (GhcbBase, EFI_PAGES_TO_SIZE (GhcbPageCount));
>>
>>    PcdStatus = PcdSet64S (PcdGhcbBase, GhcbBasePa);
>>    ASSERT_RETURN_ERROR (PcdStatus);
>>    PcdStatus = PcdSet64S (PcdGhcbSize, EFI_PAGES_TO_SIZE (GhcbPageCount));
>>    ASSERT_RETURN_ERROR (PcdStatus);
>>
>>    DEBUG ((DEBUG_INFO,
>>      "SEV-ES is enabled, %lu GHCB pages allocated starting at 0x%p\n",
>>      (UINT64)GhcbPageCount, GhcbBase));
>>
>>    AsmWriteMsr64 (MSR_SEV_ES_GHCB, GhcbBasePa);
> 
> So what is the *actual* problem at OS runtime:
> 
> - Is it that MSR_SEV_ES_GHCB still points at this PEI-phase *reserved*
>    memory allocation (and so when QemuFlashPtrWrite() tries to access it
>    during OS runtime, it doesn't have a runtime mapping for it)?

At this point the GHCB MSR points to the OS GHCB, which isn't mapped by 
the page tables supplied by the OS and used by UEFI.

> 
> - Or is it that the OS actively changes MSR_SEV_ES_GHCB, pointing to a
>    memory area that the OS owns -- and *that* area is what
>    QemuFlashPtrWrite() cannot access at OS runtime?

Correct.

> 
> The first problem statement does *not* seem to apply, given -- again --
> that the commit message says, "firmware is likely to use the GHCB of the
> OS".
> 
> So I think the second problem statement must apply.
> 
> (I think the "reserved allocation" above is "reserved" only because we
> want to keep the OS out of it around the ExitBootServices() transition.)
> 
> Back to the email:
> 
> On 09/09/20 10:27, Ard Biesheuvel wrote:
>> On Tue, 8 Sep 2020 at 20:46, Borislav Petkov <bp@alien8.de> wrote:
>>> On Mon, Sep 07, 2020 at 03:16:12PM +0200, Joerg Roedel wrote:
>>>> so each GHCB in the system needs to be identity
>>>> mapped in the EFI page tables, as unencrypted, to avoid page faults.
> 
> Not sure I agree about this, but at least it seems to confirm my
> understanding -- apparently the idea is, for the OS, to satisfy
> QemuFlashPtrWrite() in the firmware, by putting the "expected" mapping
> -- for wherever MSR_SEV_ES_GHCB is going to point to -- in place.
> 
>>>>
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> [ jroedel@suse.de: Moved GHCB mapping loop to sev-es.c ]
>>>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>>
>>
>> This looks like it is papering over a more fundamental issue: any
>> memory region that the firmware itself needs to access during the
>> execution of runtime services needs to be described in the UEFI memory
>> map, with the appropriate annotations so that the OS knows it should
>> include these in the EFI runtime page tables. So why has this been
>> omitted in this case?
> 
> So yeah, the issue seems to be that the QemuFlashFvbServicesRuntimeDxe
> driver does not *own* the GHCB that it attempts to use at OS runtime. It
> doesn't know where MSR_SEV_ES_GHCB is going to point.
> 
> Is QemuFlashFvbServicesRuntimeDxe permitted to change MSR_SEV_ES_GHCB
> *temporarily* at OS runtime?
> 
> Because, in that case:
> 
> - QemuFlashFvbServicesRuntimeDxe should allocate a Runtime Services Data
>    block for GHCB when it starts up (if SEV-ES is active),
> 
> - QemuFlashFvbServicesRuntimeDxe should register a SetVirtualAddressMap
>    handler, and use EfiConvertPointer() from UefiRuntimeLib to convert
>    the "runtime GHCB" address to virtual address, in that handler,
> 
> - QemuFlashPtrWrite() should call EfiAtRuntime() from UefiRuntimeLib,
>    and if the latter returns TRUE, then (a) use the runtime-converted
>    address for populating the GHCB, and (b) temporarily swap
>    MSR_SEV_ES_GHCB with the address of the self-allocated GHCB. (The MSR
>    needs a *physical* address, so QemuFlashFvbServicesRuntimeDxe would
>    have to remember / retain the original (physical) allocation address
>    too.)
> 
> If QemuFlashFvbServicesRuntimeDxe is not permitted to change
> MSR_SEV_ES_GHCB even temporarily (at OS runtime), then I think the
> approach proposed in this (guest kernel) patch is valid.
> 
> Let me skim the code below...
> 
>>
>>
>>
>>>> ---
>>>>   arch/x86/boot/compressed/sev-es.c |  1 +
>>>>   arch/x86/include/asm/sev-es.h     |  2 ++
>>>>   arch/x86/kernel/sev-es.c          | 30 ++++++++++++++++++++++++++++++
>>>>   arch/x86/platform/efi/efi_64.c    | 10 ++++++++++
>>>>   4 files changed, 43 insertions(+)
>>>>
>>>> diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
>>>> index 45702b866c33..0a9a248ca33d 100644
>>>> --- a/arch/x86/boot/compressed/sev-es.c
>>>> +++ b/arch/x86/boot/compressed/sev-es.c
>>>> @@ -12,6 +12,7 @@
>>>>    */
>>>>   #include "misc.h"
>>>>
>>>> +#include <asm/pgtable_types.h>
>>>>   #include <asm/sev-es.h>
>>>>   #include <asm/trapnr.h>
>>>>   #include <asm/trap_pf.h>
>>>> diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
>>>> index e919f09ae33c..cf1d957c7091 100644
>>>> --- a/arch/x86/include/asm/sev-es.h
>>>> +++ b/arch/x86/include/asm/sev-es.h
>>>> @@ -102,11 +102,13 @@ static __always_inline void sev_es_nmi_complete(void)
>>>>        if (static_branch_unlikely(&sev_es_enable_key))
>>>>                __sev_es_nmi_complete();
>>>>   }
>>>> +extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
>>>>   #else
>>>>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>>>>   static inline void sev_es_ist_exit(void) { }
>>>>   static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
>>>>   static inline void sev_es_nmi_complete(void) { }
>>>> +static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
>>>>   #endif
>>>>
>>>>   #endif
>>>> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
>>>> index 9ab3a4dfecd8..4e2b7e4d9b87 100644
>>>> --- a/arch/x86/kernel/sev-es.c
>>>> +++ b/arch/x86/kernel/sev-es.c
>>>> @@ -491,6 +491,36 @@ int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
>>>>        return 0;
>>>>   }
>>>>
>>>> +/*
>>>> + * This is needed by the OVMF UEFI firmware which will use whatever it finds in
>>>> + * the GHCB MSR as its GHCB to talk to the hypervisor. So make sure the per-cpu
>>>> + * runtime GHCBs used by the kernel are also mapped in the EFI page-table.
> 
> Yup, this pretty much confirms my suspicion that QemuFlashPtrWrite() is
> at the center of this.
> 
> (BTW, I don't think that the runtime services data allocation, in
> QemuFlashFvbServicesRuntimeDxe, for OS runtime GHCB purposes, would have
> to be "per CPU". Refer to "Table 35. Rules for Reentry Into Runtime
> Services" in the UEFI spec -- if one processor is executing
> SetVariable(), then no other processor must enter SetVariable(). And so
> we'll have *at most* one VCPU in QemuFlashPtrWrite(), at any time.)
> 
>>>> + */
>>>> +int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
>>>> +{
>>>> +     struct sev_es_runtime_data *data;
>>>> +     unsigned long address, pflags;
>>>> +     int cpu;
>>>> +     u64 pfn;
>>>> +
>>>> +     if (!sev_es_active())
>>>> +             return 0;
>>>> +
>>>> +     pflags = _PAGE_NX | _PAGE_RW;
>>>> +
>>>> +     for_each_possible_cpu(cpu) {
>>>> +             data = per_cpu(runtime_data, cpu);
>>>> +
>>>> +             address = __pa(&data->ghcb_page);
>>>> +             pfn = address >> PAGE_SHIFT;
>>>> +
>>>> +             if (kernel_map_pages_in_pgd(pgd, pfn, address, 1, pflags))
>>>> +                     return 1;
>>>> +     }
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>>   static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>>>   {
>>>>        struct pt_regs *regs = ctxt->regs;
>>>> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
>>>> index 6af4da1149ba..8f5759df7776 100644
>>>> --- a/arch/x86/platform/efi/efi_64.c
>>>> +++ b/arch/x86/platform/efi/efi_64.c
>>>> @@ -47,6 +47,7 @@
>>>>   #include <asm/realmode.h>
>>>>   #include <asm/time.h>
>>>>   #include <asm/pgalloc.h>
>>>> +#include <asm/sev-es.h>
>>>>
>>>>   /*
>>>>    * We allocate runtime services regions top-down, starting from -4G, i.e.
>>>> @@ -229,6 +230,15 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>>>>                return 1;
>>>>        }
>>>>
>>>> +     /*
>>>> +      * When SEV-ES is active, the GHCB as set by the kernel will be used
>>>> +      * by firmware. Create a 1:1 unencrypted mapping for each GHCB.
>>>> +      */
>>>> +     if (sev_es_efi_map_ghcbs(pgd)) {
>>>> +             pr_err("Failed to create 1:1 mapping for the GHCBs!\n");
>>>> +             return 1;
>>>> +     }
>>>> +
>>>>        /*
>>>>         * When making calls to the firmware everything needs to be 1:1
>>>>         * mapped and addressable with 32-bit pointers. Map the kernel
> 
> Good point!
> 
> And it even makes me wonder if the QemuFlashFvbServicesRuntimeDxe
> approach, with the runtime services data type memory allocation, is
> feasible at all. Namely, a page's encryption status, under SEV, is
> controlled through the PTE.
> 
> And for this particular UEFI runtime area, it would *not* suffice for
> the OS to just virt-map it. The OS would also have to *decrypt* the area
> (mark the PTE as "plaintext").
> 
> In other words, it would be an "unprecedented" PTE for the OS to set up:
> the PTE would not only map the GVA to GPA, but also mark the area as
> "plaintext".
> 
> Otherwise -- if the OS covers *just* the virt-mapping --,
> QemuFlashFvbServicesRuntimeDxe would populate its own "runtime GHCB"
> area just fine, but the actual data hitting the host RAM would be
> encrypted. And so the hypervisor could not interpret the GHCB.
> 
> *If* QemuFlashFvbServicesRuntimeDxe should not change the kernel-owned
> PTE at runtime, even temporarily, for marking the GHCB as "plaintext",
> then the problem is indeed only solvable in the guest kernel, in my
> opinion.
> 
> There simply isn't an "architected annotation" for telling the kernel,
> "virt-map this runtime services data type memory range, *and* mark it as
> plaintext at the same time".
> 
> This would be necessary, as both actions affect the exact same PTE, and
> the firmware is not really allowed to touch the PTE at runtime. But we
> don't have such a hint.
> 
> 
> To summarize: for QemuFlashFvbServicesRuntimeDxe to allocate UEFI
> Runtime Services Data type memory, for its own runtime GHCB, two
> permissions are necessary (together), at OS runtime:
> 
> - QemuFlashFvbServicesRuntimeDxe must be allowed to swap MSR_SEV_ES_GHCB
>    temporarily (before executing VMGEXIT),
> 
> - QemuFlashFvbServicesRuntimeDxe must be allowed to change the OS-owned
>    PTE temporarily (for remapping the GHCB as plaintext, before writing
>    to it).
> 

Amazing summarization Laszlo!

Thanks,
Tom

> Thanks
> Laszlo
> 
