Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F6F35D49C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 03:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbhDMBBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 21:01:37 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:39168
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237775AbhDMBBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 21:01:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gzs81+zuzYf3QbC9DxNVninCzVY/ib+VkLDvlrJ+kATNBs28y0C8H2uXxTVwXJ5J95DkIFzJPIJFgP67Vt0klvOxXQ0nkz4HmUW3bZSR8Jn8PsXybe9RPfI6MMtCfc4M0x/b8qFamvIKj5FXSsxV+dEUatw9gvhC6A+F9xW7gMOHQMLdJ5vR4uimmtCYcFhBb5BN+d46VV9ppaZ5RRC6T2rKoI2lVKR2D/+dVYg7SEx5ignUvXo/7tva1pk1u+gcP/rWVLYJPooIaK6T61LaZ/cL2RrVg331CbVh/cvvVbMP5C+PX0mUnRZmFmYbvhjAYVmaHVuTyMjaBfQyoFPTWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Fr8ASfB4liEczSabyBWk4JX2V2fCwIIaUgAFffmzNE=;
 b=JU0Sya3c7WHZR9J+bqM5Vd1ql1yucrmLbfcDScd3ixq5Q4D/0Z1Rl5ogrOrGpnPYLxc9AHbJXuKpTrwqVBu0g7c5F84MUMTJRIgtFEotCkPOzlYzh1NWFaaL2ZWeDamD859V4C4C3cm/8wib8aeDiBu2rSJP0ql3mlnEiHVTdhGo2I24SplsE3/+En3hvxJYTURLtxZsfh67E9PHr4//Xt2GZ11N9lYshItdIMQiWFI19ZLPZiLXhPfRcOOytGBEFVo/fSPDA8RUOb++sek71QmwJM0rRoaD+QjkUWnyUrqvRJapV61MWRPHR0yk0seeH4pZBlqrUNCl0cLX5NxGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Fr8ASfB4liEczSabyBWk4JX2V2fCwIIaUgAFffmzNE=;
 b=5Ht9hjTOB2gmnYbvT1xQzWcmhWfDn1YhOnX6FNXtsn5dHOlu4i9XOH1ExP5oiX8o5vVc+JVGCaCVNBtrV2KYH1szSkRBkMiT72G9tZcwzdCYrHQ40tXEbTNVE+xi3Vy6Qrzjf0yxk08a3couBT2N1DI406PT1e208JQZ38NqozM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 01:01:10 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 01:01:10 +0000
Date:   Tue, 13 Apr 2021 01:01:03 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v12 12/13] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <20210413010103.GA3214@ashkalra_ubuntu_server>
References: <cover.1618254007.git.ashish.kalra@amd.com>
 <4ca573363fb8fcd970add90fad4b51d43f1c5d84.1618254007.git.ashish.kalra@amd.com>
 <CABayD+duig2-H+K4PgoNtvy42PDgZTSDN84nAkF8hA-dUs=awQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+duig2-H+K4PgoNtvy42PDgZTSDN84nAkF8hA-dUs=awQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0107.namprd05.prod.outlook.com
 (2603:10b6:803:42::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0107.namprd05.prod.outlook.com (2603:10b6:803:42::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 01:01:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64797a30-6f2b-482f-ec08-08d8fe179fad
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592F76E7B11855E5CF720538E4F9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9EqumGXO8fAc/DRqOF6UB3c/9iMJ0aDOm84sN9Knmogptgzcl0TjmHNQocry6CpLGQP4VlofmdwOfC8QjGiVm64z+rNor6WliT6TDKzm9K7phoPqJt8kSdY0fN5VREQUTR/QaXJFkJIqTLKXeuksxwM6Co6vyD0igSddEG8SNlL3u48LsXIEd5hUdNJzQiU+vVgAomfc2S1i3mG4aGuKSRZgIjNiDoaJrKkxS8HKtjr4udmrxk5iCu/F3UN2QTNLcZtuDs+NOjTIJCo6/aR+8dqk+SyG5FSHLx/VJAILJ+VPYNv6LOsYaLJaDpd40OZaZ/Osb9W4NwdVSn6PpTkD/GZoh7u8XeSX6TqSInVRmnlwyOiGtRXHla26qAO/Y/dzySCqDWqjiaf7QASC8RDlCCu51eDZN2nEUuUQOTTUZmooBSCiqAdMVGnLr9uW/aBGmSP1xl17C2Nieb8j6f2UVkhSg0G9Ss9Nz2N/wH+jYNbzya/tOL+ANZFwQoGnCTOXo6tZe5AVCZG9OOGdLy4ocDNGGx4GAN/YGsH4vll+Jch3aQp9gYstVQ15vtvrbqVDZ5SXcSyIYcW7b9lV9VWfFcwFlMcm1u6+KpTW/TrgPOc7lJIJb+C1kT/WNgn4AhQ4G6TueqkZOLe7rXamAbA4bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(33656002)(16526019)(26005)(186003)(52116002)(5660300002)(53546011)(9686003)(66946007)(44832011)(66556008)(6916009)(7416002)(38100700002)(38350700002)(66476007)(6496006)(8936002)(2906002)(86362001)(33716001)(6666004)(83380400001)(956004)(8676002)(1076003)(55016002)(54906003)(316002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rIjJOOrfCh6WQRXRbImYKOJCLsWmh8K0mefiSZt7G/PddUFIPwL1/VB4ncx9?=
 =?us-ascii?Q?FHCh5r0CVgSrfT7PIxYSn+w5NAkvpRwQ4I3dQ6pdW07+iKciN8Ol1cUhryTr?=
 =?us-ascii?Q?nqdGfChHXpOfXR5JvQrLvUbMK8/QH9dxQbb0wnxhxXxVgVJxYue+iuoCV2IB?=
 =?us-ascii?Q?rU/CQsHGTEUWH0sb7VcIf84HSo6SWe+6ZY62/Xq4AwUyL2FC3hoqMZZQWpnN?=
 =?us-ascii?Q?NBKojS2OSnEoeKlQFIRsRfFIEMY8Jr/N2cSsdbVcNq07IEfiIy0RLy9c1Kam?=
 =?us-ascii?Q?/5kA8C31DQ/eOexTPLqUmZW5fpQBtc0Z9MKpeVbcqWxkmIbVBtWqP4nrEPDP?=
 =?us-ascii?Q?tmJhrRnEZ7T2SQIo6HycHOKi3p2uNnnqn0zWZiQuCT/5XD6Do5C67h8pgrGj?=
 =?us-ascii?Q?3b6y09DGZz8ZfsTKuS72tqzV4EcsHbZdn/qOSmgf9uz3UaZTDB8N7dPlfh56?=
 =?us-ascii?Q?ZDhnYItmD9odBxCBH+wnr2EMW8LENucy/TSD9rr25W4oGc/ArhQw1hLKLsIQ?=
 =?us-ascii?Q?dB3VogxWsdMUR78tw9GGFPSdbokR34CCFISXUDiy/jjLaLcanmXrQGr35XA8?=
 =?us-ascii?Q?9Cn+MD9kuq0Hpsl644wEBeqFrX0zddDBzABkxZQc7S20F3nbEXsc+I4w49Wx?=
 =?us-ascii?Q?ZpK6jI2rPsfU2RCEYQEvjZbBZDpUwqt8gNCdbx6ZTQokt1EgLftx738eu6uB?=
 =?us-ascii?Q?ulB0UEb5ucuB3IH7rGBxa/UjBqobDlprnVZf0o70nfBh+zsJtzMdpVk1uNW7?=
 =?us-ascii?Q?6ug60tkSoSZgdvz9JbUtQJ/XqlgmuObhRfhML7Eqe6H2TlfyhcrwbXQQLsv2?=
 =?us-ascii?Q?CaiYmOaGW3PsRJ3nxSGY5Wa+g7JcBdCWsbRb54NNAnODgS6nzz0rPWkilbM6?=
 =?us-ascii?Q?PdOU58WsEcGB/Sj47HiYDHTD4MzFogPAb5hTtnHjltU5k4g4drrD/hGYP9s2?=
 =?us-ascii?Q?VTtVs4vEq1G+zabqBsNl9yrx76HH79GFEJnPkBqv8J5tIVVEWsfasyIzfEtZ?=
 =?us-ascii?Q?5u4MMxzehvoAazlL7TBsNvRlCgz6Xv05aGMW/xAap3iK0+kygtpEevXo84UX?=
 =?us-ascii?Q?mMk5wULoBzc7bMMyoG0Lbp7EUxtVhKdWb1Ukl0p7LgW3fRaIw7H6o66qXsFa?=
 =?us-ascii?Q?VtUNUWww0+2QFaPxtrWoRSxkR+JitfVtlrk0OvEhT7PsjTGYRya06Q5Rzacw?=
 =?us-ascii?Q?W3zaPFKRrwn4h0RF/O5tJVGkQraR/Wujr1G1ulLcX4Hb/O4bR9dzwo4SSgRk?=
 =?us-ascii?Q?ZPCWqiFY2nVssQ9T+k/7uBpVdyUJSE950pV4H4g81r9vvvIBzOkTkjdTNQAn?=
 =?us-ascii?Q?LtOGBt6EWNue5DlKNgfPA2v/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64797a30-6f2b-482f-ec08-08d8fe179fad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 01:01:10.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSCmi8W9YsOhpDWwfs1blIChXPxhV+rhUXWlbGz5oo+8st7/LaK5WQaHJEN3mIju0zgpAO500PL1bGvotUtotA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 05:25:15PM -0700, Steve Rutherford wrote:
> On Mon, Apr 12, 2021 at 12:46 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > The guest support for detecting and enabling SEV Live migration
> > feature uses the following logic :
> >
> >  - kvm_init_plaform() invokes check_kvm_sev_migration() which
> >    checks if its booted under the EFI
> >
> >    - If not EFI,
> >
> >      i) check for the KVM_FEATURE_CPUID
> >
> >      ii) if CPUID reports that migration is supported, issue a wrmsrl()
> >          to enable the SEV live migration support
> >
> >    - If EFI,
> >
> >      i) check for the KVM_FEATURE_CPUID
> >
> >      ii) If CPUID reports that migration is supported, read the UEFI variable which
> >          indicates OVMF support for live migration
> >
> >      iii) the variable indicates live migration is supported, issue a wrmsrl() to
> >           enable the SEV live migration support
> >
> > The EFI live migration check is done using a late_initcall() callback.
> >
> > Also, ensure that _bss_decrypted section is marked as decrypted in the
> > shared pages list.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  arch/x86/include/asm/mem_encrypt.h |  8 +++++
> >  arch/x86/kernel/kvm.c              | 52 ++++++++++++++++++++++++++++++
> >  arch/x86/mm/mem_encrypt.c          | 41 +++++++++++++++++++++++
> >  3 files changed, 101 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> > index 31c4df123aa0..19b77f3a62dc 100644
> > --- a/arch/x86/include/asm/mem_encrypt.h
> > +++ b/arch/x86/include/asm/mem_encrypt.h
> > @@ -21,6 +21,7 @@
> >  extern u64 sme_me_mask;
> >  extern u64 sev_status;
> >  extern bool sev_enabled;
> > +extern bool sev_live_migration_enabled;
> >
> >  void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
> >                          unsigned long decrypted_kernel_vaddr,
> > @@ -44,8 +45,11 @@ void __init sme_enable(struct boot_params *bp);
> >
> >  int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
> >  int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
> > +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> > +                                           bool enc);
> >
> >  void __init mem_encrypt_free_decrypted_mem(void);
> > +void __init check_kvm_sev_migration(void);
> >
> >  /* Architecture __weak replacement functions */
> >  void __init mem_encrypt_init(void);
> > @@ -60,6 +64,7 @@ bool sev_es_active(void);
> >  #else  /* !CONFIG_AMD_MEM_ENCRYPT */
> >
> >  #define sme_me_mask    0ULL
> > +#define sev_live_migration_enabled     false
> >
> >  static inline void __init sme_early_encrypt(resource_size_t paddr,
> >                                             unsigned long size) { }
> > @@ -84,8 +89,11 @@ static inline int __init
> >  early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
> >  static inline int __init
> >  early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
> > +static inline void __init
> > +early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
> >
> >  static inline void mem_encrypt_free_decrypted_mem(void) { }
> > +static inline void check_kvm_sev_migration(void) { }
> >
> >  #define __bss_decrypted
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 78bb0fae3982..bcc82e0c9779 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/kprobes.h>
> >  #include <linux/nmi.h>
> >  #include <linux/swait.h>
> > +#include <linux/efi.h>
> >  #include <asm/timer.h>
> >  #include <asm/cpu.h>
> >  #include <asm/traps.h>
> > @@ -429,6 +430,56 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
> >         early_set_memory_decrypted((unsigned long) ptr, size);
> >  }
> >
> > +static int __init setup_kvm_sev_migration(void)
> > +{
> > +       efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
> > +       efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
> > +       efi_status_t status;
> > +       unsigned long size;
> > +       bool enabled;
> > +
> > +       /*
> > +        * check_kvm_sev_migration() invoked via kvm_init_platform() before
> > +        * this callback would have setup the indicator that live migration
> > +        * feature is supported/enabled.
> > +        */
> > +       if (!sev_live_migration_enabled)
> > +               return 0;
> > +
> > +       if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +               pr_info("%s : EFI runtime services are not enabled\n", __func__);
> > +               return 0;
> > +       }
> > +
> > +       size = sizeof(enabled);
> > +
> > +       /* Get variable contents into buffer */
> > +       status = efi.get_variable(efi_sev_live_migration_enabled,
> > +                                 &efi_variable_guid, NULL, &size, &enabled);
> > +
> > +       if (status == EFI_NOT_FOUND) {
> > +               pr_info("%s : EFI live migration variable not found\n", __func__);
> > +               return 0;
> > +       }
> > +
> > +       if (status != EFI_SUCCESS) {
> > +               pr_info("%s : EFI variable retrieval failed\n", __func__);
> > +               return 0;
> > +       }
> > +
> > +       if (enabled == 0) {
> > +               pr_info("%s: live migration disabled in EFI\n", __func__);
> > +               return 0;
> > +       }
> > +
> > +       pr_info("%s : live migration enabled in EFI\n", __func__);
> > +       wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION, KVM_SEV_LIVE_MIGRATION_ENABLED);
> > +
> > +       return true;
> > +}
> > +
> > +late_initcall(setup_kvm_sev_migration);
> > +
> >  /*
> >   * Iterate through all possible CPUs and map the memory region pointed
> >   * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
> > @@ -747,6 +798,7 @@ static bool __init kvm_msi_ext_dest_id(void)
> >
> >  static void __init kvm_init_platform(void)
> >  {
> > +       check_kvm_sev_migration();
> >         kvmclock_init();
> >         x86_platform.apic_post_init = kvm_apic_init;
> >  }
> > diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> > index fae9ccbd0da7..4de417333c09 100644
> > --- a/arch/x86/mm/mem_encrypt.c
> > +++ b/arch/x86/mm/mem_encrypt.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/bitops.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/kvm_para.h>
> > +#include <linux/efi.h>
> >
> >  #include <asm/tlbflush.h>
> >  #include <asm/fixmap.h>
> > @@ -48,6 +49,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
> >
> >  bool sev_enabled __section(".data");
> >
> > +bool sev_live_migration_enabled __section(".data");
> > +
> >  /* Buffer used for early in-place encryption by BSP, no locking needed */
> >  static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
> >
> > @@ -237,6 +240,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> >         unsigned long sz = npages << PAGE_SHIFT;
> >         unsigned long vaddr_end, vaddr_next;
> >
> > +       if (!sev_live_migration_enabled)
> > +               return;
> > +
> >         vaddr_end = vaddr + sz;
> >
> >         for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> > @@ -407,6 +413,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
> >         return early_set_memory_enc_dec(vaddr, size, true);
> >  }
> >
> > +void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
> > +                                       bool enc)
> > +{
> > +       set_memory_enc_dec_hypercall(vaddr, npages, enc);
> > +}
> > +
> >  /*
> >   * SME and SEV are very similar but they are not the same, so there are
> >   * times that the kernel will need to distinguish between SME and SEV. The
> > @@ -462,6 +474,35 @@ bool force_dma_unencrypted(struct device *dev)
> >         return false;
> >  }
> >
> > +void __init check_kvm_sev_migration(void)
> > +{
> > +       if (sev_active() &&
> > +           kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
> > +               unsigned long nr_pages;
> > +
> > +               pr_info("KVM enable live migration\n");
> > +               sev_live_migration_enabled = true;
> > +
> > +               /*
> > +                * Ensure that _bss_decrypted section is marked as decrypted in the
> > +                * shared pages list.
> > +                */
> > +               nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
> > +                                       PAGE_SIZE);
> > +               early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
> > +                                               nr_pages, 0);
> > +
> > +               /*
> > +                * If not booted using EFI, enable Live migration support.
> > +                */
> > +               if (!efi_enabled(EFI_BOOT))
> > +                       wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
> > +                              KVM_SEV_LIVE_MIGRATION_ENABLED);
> > +               } else {
> > +                       pr_info("KVM enable live migration feature unsupported\n");
> I might be misunderstanding this, but I'm not sure this log message is
> correct: isn't the intention that the late initcall will be the one to
> check if this should be enabled later in this case?
> 

Yes, you are right, this log message should be removed.

> I have a similar question above about the log message after
> "!efi_enabled(EFI_RUNTIME_SERVICES)": shouldn't that avoid logging if
> !efi_enabled(EFI_BOOT) (since the wrmsl call already had been made
> here?)

Yes, probably that check can be additionally added.

Thanks,
Ashish

> > +               }
> > +}
> > +
> >  void __init mem_encrypt_free_decrypted_mem(void)
> >  {
> >         unsigned long vaddr, vaddr_end, npages;
> > --
> > 2.17.1
> >
> 
> Other than these:
> Reviewed-by: Steve Rutherford <srutherford@google.com>
