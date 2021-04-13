Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1272F35D4F2
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 03:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbhDMBst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 21:48:49 -0400
Received: from mail-eopbgr700040.outbound.protection.outlook.com ([40.107.70.40]:10945
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237718AbhDMBss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 21:48:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+G+BvEGtsSPJCmDdYcq9zO4rYsWpURTXUOmWnfKqxrqgfidSmxUzYVtptXNJCU4ZY+aLF7pLAJC0V/LaBCFidlLWgqlzjzo7e6snuDI9K2ibe6XwxncE2KpNwRbPaQl3s7WYChAQet/+wBEekC/hH8hQnREI9HKgo8INQ5ek9RR7NSxxlbLHL1CFIXcaeagecwLCf1dASejAgOU8VPi+7VKDI1C1PgbuwZSYViQzZfSNx42yo+3i3PerfTf8vlqx2RwClWjTQgmkRzSOgfqLCYBi65T0+6GPVWCQLb5SHYx2h0/c3Zq+jBIOT5TypX6HB9aphbd7I/S1MJVFpJKVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RhbCwoRhtnC3Rze7cGDr7HMSANYwh0v3StJixei+40=;
 b=mZx+eDN/ekjU+Ac/IprZSCGJw+eFcfcdvD4pbJFxXvEtMBhwieTcTKjjUwkm1lV8R06qjDY4Fir6m5sEq7A0OOvTnjHzge6MVgbmypYfCCoxJAhaJBeMdNUqC2fr/uGVy7VpIJL+U4LQcxXXfx/A700LE5ZA20oXP3uTRu+59f3vVYLOjgRMcuiRuNctwR6VW23sN3aDDEgNiwshlLpx/Di5vDjA0AXXuJSd1ea7PI7T/QFhrm0WD9DTXiy/eYNuGeg8gUndgFifXFj31pwxVp4HGMPJaeL0mTx6RAUTRmauCuKpmBo9AUMBdo/luL+tfIqKy80GKsHKreqf5r9xHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RhbCwoRhtnC3Rze7cGDr7HMSANYwh0v3StJixei+40=;
 b=h5H+i/1PoClzkmGKAH/52+Hh9GgK46oAlQGGzRBYWZK5nie5ob3j3CsC5AzM5ejglC8SaixxOlRogDtW83kxqmFGWZcKWYkn0huVmu+knQ1DbTaLI0p6STHLJj20tBxpNDEXxAfvcbye/+9CqydY31FQRZueE/0/JGO7KWh2nuY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 01:48:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 01:48:27 +0000
Date:   Tue, 13 Apr 2021 01:48:21 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>,
        kexec@lists.infradead.org
Subject: Re: [PATCH v12 13/13] x86/kvm: Add kexec support for SEV Live
 Migration.
Message-ID: <20210413014821.GA3276@ashkalra_ubuntu_server>
References: <cover.1618254007.git.ashish.kalra@amd.com>
 <c349516d85d9e3fc7404d564ff81d7ebecc1162c.1618254007.git.ashish.kalra@amd.com>
 <CABayD+cNLdoPHYvw0ZAXZS2wRg4cCFGTMvON0Ja2cWJ4juHNbA@mail.gmail.com>
 <CABayD+c2P9miY2pKG=k1Ey3cj6RZG98WgssLCnBJgoW9Fng7gg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+c2P9miY2pKG=k1Ey3cj6RZG98WgssLCnBJgoW9Fng7gg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0041.namprd05.prod.outlook.com
 (2603:10b6:803:41::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0041.namprd05.prod.outlook.com (2603:10b6:803:41::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Tue, 13 Apr 2021 01:48:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cb89a08-fa25-4382-a160-08d8fe1e3b1c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415176D3DDC0759670284108E4F9@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbDcDxzhBuWpowH05N8uWH5fHSJdVk9z1DL8UbO06COjx3PK6QV1eZhPdu3DFTNrDJUhGKw+8NCIuLatmtLvp21ar5DKkAn/Evq9RxY/S9scUCmyp2hvfd9xFWncfOvS1cICvQwrHUTC8mKBY5Er06dIH86d3VqoQ/Ge4bKE549xdmcRz3teUGvEvuC0WSXSnrV+hziIlOWldWdqozxYeIzLNVdYMpHZtId5Kyi0qf6ZCpAPl72KDyWWWE/pxTaJeIyB6mjnk6mYnsxlKNCXovETIN5Nr3NYmvRixvpXW7Ds5JtuyXgxPWdpDEhiA0i55cgH3f0CZqNeXN+63SDXnNOcZpy51ga66bC7W+R/oKQ92wZdOT3Xx3wq5Ip//QkwpcZsSYRV0soWpuOzE7ZVtATdbAcFJF9LsDxN766L79jaVKxBu6ZV1WZezROFsjYLMiWmK6v0B1Azv837jMmGQfpUCuBdmLQELk7oLdMHPHiwWv7/SFG0ugwf3wFxki8X9glODe6/wFY59hJFeQmq06NNCSl9xSChjan/yK5k/CncRTqxunqzJAXKLVA0ihuFRVJfcMKP/fneoMyrBeZ4k70B4i3Ob8R3xhAAeu+YXoJFB/9iRd3UOjPbxNF68HvqVo0jfvLwMurwN0ot0lYJ99s56J4A7XKPT+1NWEiqLTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(33656002)(66476007)(44832011)(33716001)(2906002)(7416002)(26005)(52116002)(6496006)(1076003)(53546011)(186003)(38350700002)(4326008)(6666004)(316002)(6916009)(8676002)(9686003)(86362001)(5660300002)(66556008)(38100700002)(54906003)(956004)(16526019)(8936002)(478600001)(66946007)(55016002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sahKqFCNKz3LaWCOkR9+2f/FX1WnGd8RrEdhgBtTT/lbNGoQtjZ28o1miPI0?=
 =?us-ascii?Q?FTgsdsAflgnAWXS+49KmOs5tLhtaxi4zBg//cALLJjHEH48H9SjlNzOB8j3f?=
 =?us-ascii?Q?ZyjOM3ye8L8mTsrCYTw1vDQnb5f1wQOlrUTXjf9kuMtObqSiUHOh7Ksiptir?=
 =?us-ascii?Q?4LJ5x/HvulK1ArpkvocWhJuGYijnayl50VPNA6QPuOSvSAxaftBaCk2SdCpY?=
 =?us-ascii?Q?fgqfT7rLJCXz81aH/BjXUeCuVNCj0jZnVrbpQ/gk2n2nQFhcFZ+KIGzW/YRG?=
 =?us-ascii?Q?mXYgWhSeapZ+saYenEzHP1+iRYnZ2KeYX7qZ7cb+w9HZa5NlFmXQ2BaKQ6ni?=
 =?us-ascii?Q?xl25UT7xI9wcdIZTGdTZtZz4vpieCH9ZRXvA/XzlDrvbzUNMVoCPp6hYOU0X?=
 =?us-ascii?Q?MGE77SwE7MQZwpf+dx7wxJ6BwJTyo+cDE0lVQlFDr2dLN6KWhlDMNgN1Rmy8?=
 =?us-ascii?Q?NoYwzuqXunvf9TeXB4H40a04lGLTexRxnNuZZOecREACnjU9K/bJASiJU74g?=
 =?us-ascii?Q?zQOiww5a9TdAX2cUEPC6Xu/mjbgNfnuCxpLmtP6EZ0fgGTl0y71jPHs1oSNN?=
 =?us-ascii?Q?j3Lgg4j00LgVUxe9aPAt/3lo6tYL/ueZJod6BybeQnwpOn3FenpbAOYZXK2U?=
 =?us-ascii?Q?2Zq2FbAnWmoI23Cl7apzrFerG+5kIgYIm4fBEhpMl5Z+YrAflWPVZ6Xwxdv8?=
 =?us-ascii?Q?m7a+0V7Dkr7en7ZuWz8+8W+GmloRmZgIJxWEFXjySnaIAU9yvnt3afmToP4A?=
 =?us-ascii?Q?wxHd64NceI3blGO+ChrIx733ylng8MFxc0HJlzoGfgkqnARB9REXoMJcZ4lO?=
 =?us-ascii?Q?hzop9jMuUPkv8xUqbdaMXvfgyrXvOU0n/eAuNsA8ZbUm9PwpQI0h7zWxW7Eo?=
 =?us-ascii?Q?AwbQASKsovcP+t3gc5cWyPnReQbSC2jc6VfQ7j44QlWZINAPa8jdduhwcE+V?=
 =?us-ascii?Q?3sa1adUfEu8ozpUlONWOpYb0DCTZLqBgIEK6KKow9tWIJiqSETuzjFV+NJd5?=
 =?us-ascii?Q?Q0ZC2ZhKsWbAmTly0o56Tr+H0NJZOYUWdrOTM8rbHsvuvOP0PcaOAEIY1JuW?=
 =?us-ascii?Q?97P9IghCKFXTF0HMpm6WCdXSvWTHSmnsMQ1UQjB838rTyFTqw9iR+grwIUU5?=
 =?us-ascii?Q?mY7B0Su3S+kaSAAy6OLKipZTPx9bNE2CJMIs9n49J9pdTn13HHrdudPGUHas?=
 =?us-ascii?Q?WiIyvtsHvQxiXfhIBvRwkZXOpDkXemny38WZFcgprCbnQ152qmc7iU5/LwGP?=
 =?us-ascii?Q?7QWNMUa0lTq6/Tt3UDGYYc7GbBiunOcitc5TxawaucNA5KH94rrlXh8qi0W6?=
 =?us-ascii?Q?0RKXaRdGXQW7eziKR0pbSsyG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb89a08-fa25-4382-a160-08d8fe1e3b1c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 01:48:26.9010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnEbtDQYC8FBpiJdL+uKhzc9i8GSRBoo6l2TMJz5rJtyUGXrtY0AKybXUcrMt8+5tW5exq7TdAPrNkVD8Admlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 06:23:32PM -0700, Steve Rutherford wrote:
> On Mon, Apr 12, 2021 at 5:22 PM Steve Rutherford <srutherford@google.com> wrote:
> >
> > On Mon, Apr 12, 2021 at 12:48 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > >
> > > From: Ashish Kalra <ashish.kalra@amd.com>
> > >
> > > Reset the host's shared pages list related to kernel
> > > specific page encryption status settings before we load a
> > > new kernel by kexec. We cannot reset the complete
> > > shared pages list here as we need to retain the
> > > UEFI/OVMF firmware specific settings.
> > >
> > > The host's shared pages list is maintained for the
> > > guest to keep track of all unencrypted guest memory regions,
> > > therefore we need to explicitly mark all shared pages as
> > > encrypted again before rebooting into the new guest kernel.
> > >
> > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > ---
> > >  arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index bcc82e0c9779..4ad3ed547ff1 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -39,6 +39,7 @@
> > >  #include <asm/cpuidle_haltpoll.h>
> > >  #include <asm/ptrace.h>
> > >  #include <asm/svm.h>
> > > +#include <asm/e820/api.h>
> > >
> > >  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
> > >
> > > @@ -384,6 +385,29 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
> > >          */
> > >         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > >                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> > > +       /*
> > > +        * Reset the host's shared pages list related to kernel
> > > +        * specific page encryption status settings before we load a
> > > +        * new kernel by kexec. NOTE: We cannot reset the complete
> > > +        * shared pages list here as we need to retain the
> > > +        * UEFI/OVMF firmware specific settings.
> > > +        */
> > > +       if (sev_live_migration_enabled & (smp_processor_id() == 0)) {
> > What happens if the reboot of CPU0 races with another CPU servicing a
> > device request (while the reboot is pending for that CPU)?
> > Seems like you could run into a scenario where you have hypercalls racing.
> >
> > Calling this on every core isn't free, but it is an easy way to avoid this race.
> > You could also count cores, and have only last core do the job, but
> > that seems more complicated.
> On second thought, I think this may be insufficient as a fix, since my
> read of kernel/reboot.c seems to imply that devices aren't shutdown
> until after these notifiers occur. As such, a single thread might be
> able to race with itself. I could be wrong here though.
> 
> The heavy hammer would be to disable migration through the MSR (which
> the subsequent boot will re-enable).
> 
> I'm curious if there is a less "blocking" way of handling kexecs (that
> strategy would block LM while the guest booted).
> 
> One option that comes to mind would be for the guest to "mute" the
> encryption status hypercall after the call to reset the encryption
> status. The problem would be that the encryption status for pages
> would be very temporarily inaccurate in the window between that call
> and the start of the next boot. That isn't ideal, but, on the other
> hand, the VM was about to reboot anyway, so a corrupted shared page
> for device communication probably isn't super important. Still, I'm
> not really a fan of that. This would avoid corrupting the next boot,
> which is clearly an improvement.
> 
> Each time the kernel boots it could also choose something like a
> generation ID, and pass that down each time it calls the hypercall.
> This would then let userspace identify which requests were coming from
> the subsequent boot.
> 
> Everything here (except, perhaps, disabling migration through the MSR)
> seems kind of complicated. I somewhat hope my interpretation of
> kernel/reboot.c is wrong and this race just is not possible in the
> first place.
> 

Disabling migration through the MSR after resetting the page encryption
status is a reasonable approach. There is a similar window existing for
normal VM boot during which LM is disabled, from the point where OVMF
checks and adds support for SEV LM and the kernel boot checks for the
same and enables LM using the MSR. 

Thanks,
Ashish

> > > +               int i;
> > > +               unsigned long nr_pages;
> > > +
> > > +               for (i = 0; i < e820_table->nr_entries; i++) {
> > > +                       struct e820_entry *entry = &e820_table->entries[i];
> > > +
> > > +                       if (entry->type != E820_TYPE_RAM)
> > > +                               continue;
> > > +
> > > +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> > > +
> > > +                       kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> > > +                                          entry->addr, nr_pages, 1);
> > > +               }
> > > +       }
> > >         kvm_pv_disable_apf();
> > >         kvm_disable_steal_time();
> > >  }
> > > --
> > > 2.17.1
> > >
