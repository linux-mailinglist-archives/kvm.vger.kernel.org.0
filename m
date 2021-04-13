Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00C35DE02
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 13:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245725AbhDMLrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 07:47:41 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:37088
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238852AbhDMLrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 07:47:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mxt96c2ZM0UMn8+8uxxkqYuZmgWcthWSyOphRGjw4TKdWYMzvZCVT3r70GtD/F3ljvqGclN+tnNfTCrfpQ9cNQncEJb1s9by4ysXvNKXM/cf+0rnYvTrMYCCcR9bKjPUVfqzELlyOBAmkBFah6Mx6OXNePPkdwYrcMDVXTxupUQvg/8uHUFzsqJXAllxs260TjRiPDDlUdiOAGycB2jAzUUhjcpg3hdWGnaru0UrMRgTmxxWUtIbgs+/4X1JrbqeZkTXHvaa/neBnxpNCYD6w5V6AP5/6ej7IGonbLmEFZuTGHpYCjulnWzvE0mx+50PvlhWBexTzURuoeul8/YcDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ap6mpQ/sKwZ40/xBDq5rcvQ87e6uJFL15wvUGayrlQ4=;
 b=RYQBhwOYOC4DTB8iVGCRWpxAZGOvtILAuSo1VDW8DKCtGJ3J+MhmiFI59pbFKv8MaY3cKedKYl2oXs/mVG71680lg+6ON2ZDkPKSggOTcf5hgdowz7lKdWacNxJ3bvLOM9b6tBLyj+u2ovr8HyT6hC3NIXg2pERYp29GlFeiW9pEBS7omjf0epNlzt5Yvl+Fz0HyOnInFOcim4ekDcicFZbXggg7JBbZeebVWybbrLUweOGOnOeHO1VIzwEvccCNkollmd53xlrtFpIQkTsTZilyFfruIDEOUhlIgkAGi5C6FKpFLrxtVQMU8RVOSRIu6Ma8u8a79Y4cCGY11GNOCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ap6mpQ/sKwZ40/xBDq5rcvQ87e6uJFL15wvUGayrlQ4=;
 b=ePIFZOoVRH1BT/OoqhwxSAyWr/pQXyTHeCskxIb5zeJWFASaDIvA7yV+HGdVriDoNfhzWGUo8mdAx0a3vBedXKc2KeDmts2bCUJV+aaXa/gCdgVfj8AFwwCE5p+cGjcgPAqc08IfcITAJheL3ouiT4aq9LMiH5zFa5xseh1hHrc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 11:47:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 11:47:18 +0000
Date:   Tue, 13 Apr 2021 11:47:12 +0000
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
Message-ID: <20210413114712.GA3996@ashkalra_ubuntu_server>
References: <cover.1618254007.git.ashish.kalra@amd.com>
 <c349516d85d9e3fc7404d564ff81d7ebecc1162c.1618254007.git.ashish.kalra@amd.com>
 <CABayD+cNLdoPHYvw0ZAXZS2wRg4cCFGTMvON0Ja2cWJ4juHNbA@mail.gmail.com>
 <CABayD+c2P9miY2pKG=k1Ey3cj6RZG98WgssLCnBJgoW9Fng7gg@mail.gmail.com>
 <20210413014821.GA3276@ashkalra_ubuntu_server>
 <CABayD+dqg+CYm4hAc6gRY6ygpbgpm-a7jo6ZGotbcA3arq9yQg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+dqg+CYm4hAc6gRY6ygpbgpm-a7jo6ZGotbcA3arq9yQg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:806:f2::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0021.namprd04.prod.outlook.com (2603:10b6:806:f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 11:47:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 844e2800-c4dc-49bf-1333-08d8fe71e3ca
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368F57BEAFFDBE05C053E368E4F9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /yJkJTruXT/ZkocNpGrH9viZm3qAxgiCLt8Jd1HY1pA+gK8M5OK8+NqtI2txTcntbBXPTz/ZzkaxL8s5ZJLy25UE1OHuF3m58imtkBJ4Yq/6b2Os4kfkMZkUZP/nkp9k0crPZp6A/0hYS/znzuscx1co6tFHBw0fYcprgrQqSSutiks8d/8iTcB9eVrRQsNQAP2sWEf8/ppALYiOa/fi2CP7SKA5SUnGRetj19qXswrFt41bcODOuzTqyvyViVnLZ4FMyvsaR+qPZHP6ABIgRX1cSX0GXdC+RhmYBcLKo0ybNRVDMNmXuG8owb/MiCbvsqvsmTgcdxY097htmKm7J9GIGLnNz8uf9n6rjAPizBj0jscJU2031QKT3pXYvuk4OqrxYIf69lFM3Tk1Licbqn2WkZOHCtEwVOVLSD+gj/1Iw896j/LMBVCv745jtERuuSLpSrZkdK2o60BQLQ7MLbUeuRnEAN/8/Tt0nDqieDgegtmRah5MNjAku/pYIIWxijwl9SB6WqdhRbhNqyeG+iW6dQ82yUOwJ5cVrbj1GnT0dEokYaRFvk8xNK3fdnLCdjeX5wJuo2uGzWH+qLb7pyWYoLatokVFjWkmlXGeCxRIBL9SzlJxbDHwu0O6lOji7kN/xNmEUssTHcyGOOx/x7lC8sIhnwVSzJdkKODh1bo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(8936002)(6666004)(33656002)(478600001)(86362001)(66476007)(38100700002)(9686003)(55016002)(8676002)(186003)(66556008)(4326008)(44832011)(38350700002)(316002)(2906002)(1076003)(33716001)(66946007)(7416002)(5660300002)(6916009)(83380400001)(956004)(6496006)(16526019)(54906003)(52116002)(26005)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8UXtn0OJYkppJ/Vs7tfOxzCphTCt/bMXWLElmcqSjpwjWz6TRVEa53ATdclT?=
 =?us-ascii?Q?9wTuN/CzxgR3blQZGhqD0N3K2FxIX/f6krHq09eLF4bwNG4SOOQpY3waB42U?=
 =?us-ascii?Q?X8/k1UfoR9a/H88G5dDt5ITdcAmsrb3QIh9iNhs0BAh95zvgoPONQl2tXTXD?=
 =?us-ascii?Q?HopJenDj7pvDM+lq/sBCbC/4MiMJAmoMt9+WCoHISE6KZnTTA/3cPf+IM+nO?=
 =?us-ascii?Q?o2nFDBbqs2ZkjaVtPseEIxNnBLb5RKpHxiN/BI0RzwvJTDeAwXtQa345QSum?=
 =?us-ascii?Q?dgdJ6b1Xg+QT+L+mlUPonGsxMoCz50jqKiOK9v68CEKC9h4MbsvT9DLSNuUR?=
 =?us-ascii?Q?Lg96nshYejyuut8bqma7h+c12VAUj1wJdW/I0fiN7VjWh3J53aZYFYnd6ENn?=
 =?us-ascii?Q?wfD/NZgeU+bZoWGT5+dRqxPwq3RZOp0D6KDah/1fQW+89VM2mpCndelDN2n6?=
 =?us-ascii?Q?vzQdOU+nCwX2mtEqMA7tK1E51a7xG4mFrnIxsTAKG+SdO1lclAUZYdEB6dJP?=
 =?us-ascii?Q?64/LucEQr17NlM5Ts7CiQ7xC9lQyTrpjUPdf6dm9AgOYnfX+iDqHSvYmfBqZ?=
 =?us-ascii?Q?OLxjrH3Kpcohlwii3Ky2JG8JD9dyifujJhfuzyoePJTbiG4VyfymgylUMmtd?=
 =?us-ascii?Q?PHVFfWdlOrjQ/MTP/8FrojYr3hEF6oaTpbLCpQOiKKQzoy65oSZi6lZeoQAb?=
 =?us-ascii?Q?fJOrd1tNY1YXa7veEUcZphYuBJlj/PWXOybOHk5dEoKFYiY7g7QugjjzFZay?=
 =?us-ascii?Q?gEU8W8ztBFysfZjeJWfMf2eHvaaIurr8QTFzl+v3RYfklqcg7y1vN5l6/XNJ?=
 =?us-ascii?Q?UHtSwzf/OrHEWCcqDr9FF/O8HNJ3u7ZYIepVSKyZswxQ5imHpHtkYBdH1dFP?=
 =?us-ascii?Q?6+iuUJnPzXTkRKFuNoM9da2HGyijQD8+VDmVOBXgGkrxUcyT3OghOlrF9Xsm?=
 =?us-ascii?Q?vfuo9pBlD4Q+1SiV3rqv6WnPN48EU8hwFCgtqy6gMLjfErTinctevqZj8Rf1?=
 =?us-ascii?Q?4+y2zT9erDE+9x8y/8v7iPUNNiYY+UBi9k3fokU7p4/iFKi2/Jq0+tchH/g4?=
 =?us-ascii?Q?ibzFdkY2Jg9Yg0R9zYiICVe2kgmonSDVU0BUyOh+wEAdR6fcLd587l7JbUFZ?=
 =?us-ascii?Q?Xf8atwGLOPdpgz95WW+P/X0dzDtX4ZwDaL76c4GWyvupUKumackZmt3HBk9W?=
 =?us-ascii?Q?2azrFy9fSsntHfzQbml5G4XuqpqX8/VDnEuoZJqRVXx/IJSQcbYUPKux4fU2?=
 =?us-ascii?Q?tNw7HglOk8BGi7V8ETLmBtIZkBOqyG/y+IOdmSXrtW4FD1qRpjbShRtur10y?=
 =?us-ascii?Q?iD3QFp4u5JRUCRKDtWzQsUDp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 844e2800-c4dc-49bf-1333-08d8fe71e3ca
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 11:47:18.3033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgLdrk4XTGKH02jV0Lmgprc49SAehiOYx2Sx2cO4bWX0D9k6CpVHplE/00B/EPW0Q8CSQzmMQT2BGzrpehFjkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 07:25:03PM -0700, Steve Rutherford wrote:
> On Mon, Apr 12, 2021 at 6:48 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Mon, Apr 12, 2021 at 06:23:32PM -0700, Steve Rutherford wrote:
> > > On Mon, Apr 12, 2021 at 5:22 PM Steve Rutherford <srutherford@google.com> wrote:
> > > >
> > > > On Mon, Apr 12, 2021 at 12:48 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > > >
> > > > > From: Ashish Kalra <ashish.kalra@amd.com>
> > > > >
> > > > > Reset the host's shared pages list related to kernel
> > > > > specific page encryption status settings before we load a
> > > > > new kernel by kexec. We cannot reset the complete
> > > > > shared pages list here as we need to retain the
> > > > > UEFI/OVMF firmware specific settings.
> > > > >
> > > > > The host's shared pages list is maintained for the
> > > > > guest to keep track of all unencrypted guest memory regions,
> > > > > therefore we need to explicitly mark all shared pages as
> > > > > encrypted again before rebooting into the new guest kernel.
> > > > >
> > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > ---
> > > > >  arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++++++
> > > > >  1 file changed, 24 insertions(+)
> > > > >
> > > > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > > > index bcc82e0c9779..4ad3ed547ff1 100644
> > > > > --- a/arch/x86/kernel/kvm.c
> > > > > +++ b/arch/x86/kernel/kvm.c
> > > > > @@ -39,6 +39,7 @@
> > > > >  #include <asm/cpuidle_haltpoll.h>
> > > > >  #include <asm/ptrace.h>
> > > > >  #include <asm/svm.h>
> > > > > +#include <asm/e820/api.h>
> > > > >
> > > > >  DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
> > > > >
> > > > > @@ -384,6 +385,29 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
> > > > >          */
> > > > >         if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> > > > >                 wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> > > > > +       /*
> > > > > +        * Reset the host's shared pages list related to kernel
> > > > > +        * specific page encryption status settings before we load a
> > > > > +        * new kernel by kexec. NOTE: We cannot reset the complete
> > > > > +        * shared pages list here as we need to retain the
> > > > > +        * UEFI/OVMF firmware specific settings.
> > > > > +        */
> > > > > +       if (sev_live_migration_enabled & (smp_processor_id() == 0)) {
> > > > What happens if the reboot of CPU0 races with another CPU servicing a
> > > > device request (while the reboot is pending for that CPU)?
> > > > Seems like you could run into a scenario where you have hypercalls racing.
> > > >
> > > > Calling this on every core isn't free, but it is an easy way to avoid this race.
> > > > You could also count cores, and have only last core do the job, but
> > > > that seems more complicated.
> > > On second thought, I think this may be insufficient as a fix, since my
> > > read of kernel/reboot.c seems to imply that devices aren't shutdown
> > > until after these notifiers occur. As such, a single thread might be
> > > able to race with itself. I could be wrong here though.
> > >
> > > The heavy hammer would be to disable migration through the MSR (which
> > > the subsequent boot will re-enable).
> > >
> > > I'm curious if there is a less "blocking" way of handling kexecs (that
> > > strategy would block LM while the guest booted).
> > >
> > > One option that comes to mind would be for the guest to "mute" the
> > > encryption status hypercall after the call to reset the encryption
> > > status. The problem would be that the encryption status for pages
> > > would be very temporarily inaccurate in the window between that call
> > > and the start of the next boot. That isn't ideal, but, on the other
> > > hand, the VM was about to reboot anyway, so a corrupted shared page
> > > for device communication probably isn't super important. Still, I'm
> > > not really a fan of that. This would avoid corrupting the next boot,
> > > which is clearly an improvement.
> > >
> > > Each time the kernel boots it could also choose something like a
> > > generation ID, and pass that down each time it calls the hypercall.
> > > This would then let userspace identify which requests were coming from
> > > the subsequent boot.
> > >
> > > Everything here (except, perhaps, disabling migration through the MSR)
> > > seems kind of complicated. I somewhat hope my interpretation of
> > > kernel/reboot.c is wrong and this race just is not possible in the
> > > first place.
> > >
> >
> > Disabling migration through the MSR after resetting the page encryption
> > status is a reasonable approach. There is a similar window existing for
> > normal VM boot during which LM is disabled, from the point where OVMF
> > checks and adds support for SEV LM and the kernel boot checks for the
> > same and enables LM using the MSR.
> 
> I'm not totally confident that disabling LM through the MSR is
> sufficient. I also think the newly booted kernel needs to reset the
> state itself, since nothing stops the hypercalls after the disable
> goes through. The host won't know the difference between early boot
> (pre-enablement) hypercalls and racy just-before-restart hypercalls.
> You might disable migration through the hypercall, get a late status
> change hypercall, reboot, then re-enable migration, but still have
> stale state.
> 
> I _believe_ that the kernel doesn't mark it's RAM as private on boot
> as an optimization (might be wrong about this), since it would have
> been expensive to mark all of ram as encrypted previously. I believe
> that is no longer a limitation given the KVM_EXIT, so we can reset
> this during early boot instead of just before the kexec.
> 

I was wondering if disabling both migration (via the MSR) and "muting"
the hypercall using the "sev_live_migration_enabled" variable after the
page encryption status has been reset, will reset the page encryption
status of the guest to the (last known/good) configuration available to
the guest at boot time (i.e, all RAM pages marked as private and UEFI
setup shared MMIO/device regions, etc). 

But disabling migration and muting hypercalls after page encryption
status reset is still "racy" with hypercalls on other vCPUS, and that
can potentially mess-up the page encryption status available to guest
after kexec.

So probably, as you mentioned above, resetting the page encryption
status during early boot (immediately after detecting host support for
migration and enabling the hypercalls) instead of just before the kexec
is a good fix.

Thanks,
Ashish

> > > > > +               int i;
> > > > > +               unsigned long nr_pages;
> > > > > +
> > > > > +               for (i = 0; i < e820_table->nr_entries; i++) {
> > > > > +                       struct e820_entry *entry = &e820_table->entries[i];
> > > > > +
> > > > > +                       if (entry->type != E820_TYPE_RAM)
> > > > > +                               continue;
> > > > > +
> > > > > +                       nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> > > > > +
> > > > > +                       kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> > > > > +                                          entry->addr, nr_pages, 1);
> > > > > +               }
> > > > > +       }
> > > > >         kvm_pv_disable_apf();
> > > > >         kvm_disable_steal_time();
> > > > >  }
> > > > > --
> > > > > 2.17.1
> > > > >
