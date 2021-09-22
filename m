Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA1C41487F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhIVMLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:11:47 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:30560
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235848AbhIVMLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:11:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnvjNG1m9VpABHSLQRNyL4br+5ONeB7bNwSfd/5BkLOqqeAK5db4YHpgG63DsjOr+iY2ncErK7Ytr5heK/evz7nIlUpkLIJEBlWJN05qKOwuhh7ert/8S29KtF3jjKmOHTr08qe1WzuEcgLiF8RYzwssCXAmoB8jhtfnWBj8Q8MoJmC8uyK/QNRWEOtYVEDHMVqCcHvRDBQBnTU07SqC04xtg6hchZQlUzKZehxYim1JHYdJyjRkz2+EYbkiH3N9yLMP5816d6vjbn3XF8+2vaz9KHKCvNtOs2Gq2So0/C2BaC9czQFjr/cTN6G5k+B3aitX+gCtI0KOg7vDXdBnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PzgGEKw/RHJQG8oW5H5Z1U3ASxWw1N1BYgg6qc8Y+xo=;
 b=RctB3wbGk0MD+OFcpEv73BKCfxWsCk7CirS1tGf7Ade0vmk1Oi3o+rY+R4mQ+SOzv6IlU9LJ3AYpaaPecHNE2b9MJX/PdgO4n9X5WpfHgLwKlwmSFLOKuwRkAZA37f6n9fEykwEiTFx/UTxg2zMuglXjkO0lIQNyDVwcKuASB13FezM05/j58XDN8YRmKFIvA07EHxZ02rhaXhvKPbHaWn67VWSQzrxPSVsGXGRu907a3/rEhA3HKlwdQibYfaK3EV33dKMKC/bK5dMzefwn/gehNP202TTzEP+QUW65SmerG4MykbDN1CnadPxOu4hOfoCQRs0sSOBeZaNLYdlOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzgGEKw/RHJQG8oW5H5Z1U3ASxWw1N1BYgg6qc8Y+xo=;
 b=l/LoF4oD8pma7te0JlG+++wJr27ee+UEYN6oFm3BgMREjtpet5aTmJmXxBvTy0HWc1oCBMzbMIhhFpsZpz542SI0nQwgJIgZo7L066hlgiUvilJT8q3+Y65DTaf06OtqXWmFAAUHWPWGj6Uhr8Qk905j986gO8GFip650RPEmbo=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 12:10:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 12:10:14 +0000
Date:   Wed, 22 Sep 2021 12:10:08 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <20210922121008.GA18744@ashkalra_ubuntu_server>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com>
 <YUnxa2gy4DzEI2uY@zn.tnic>
 <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUr5gCgNe7tT0U/+@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SA9P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 12:10:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cff8c890-5fc5-4c03-82a7-08d97dc1ef20
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574C9F0B96B74D0A139B7C48EA29@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /VAlgm4pNGWGXU7XN6vjOmEmrG8bgnWG5kvPA6Sfe7vArzutbtCNoSigMPFi3C4WPEjPRHGA0bC83wWDTWuQrX0/NhjGAWHoUcDkSyvJN7QHOGM2y1PRqTGuos1i7Cn9T9yR4yqw6nxSoModOljR9QUYh5/N2nw2aOPEmV7GTF2m0piYSQU8EwMKxJS2jb1m0DoqS4umwjihpKOuIoO70IxvQ39bYFSweU+BcnPCUb9xub12+D3LzKlTF5GWL9psqZD9xLUKmzHvXCChOv/gtLkeLwF1tI8SvHAxLhS8M4XYwZP50oIJZSJxeOjZSBsN5xd3EYApFbgOMuwTW9qJz4U7O/a8H0DjjIe7Rsngj9FIvy9zp4OjCfbPLFgzBLskJWUQQnP9Ownw3NtBw87gUuyKVHJaoSRP3QNeU2E1K6dmuLrvZ6TCz1pv2YuDEUEvA/ee7UMPA3DZYOCBm/2Mkwip5H7K04XwaikforIoLIMclkDaEdeo74sRMhsyWgrNjZLQFq5Z2Jbuh7dAFq5+VqeHVfD2+yCdHMkiRsAi/B89vQBHRDiVXZRThlfPOnhsUsLXXYLkG/iArYTvxpi9DXmNLNYS0mlokiNRx7xqPLd4AjADz3fPEnEV5MPZzuxo8mIGC9QXbuq63XKph2+I8Sjy9tO+Z8vCoVnBMLX/+p/Z0OMr/FUmg1HJpE/7e2u11OiMf1tjL88xTOcedtrjJ5Or2WaRPj3B3bAYXGGrsZLl0CxIuodPiQcLA6PkXi38GCQ6DyPgAAhEhpnDrM8XHsu51I/9mV3PzXlpNYQuI94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(9686003)(44832011)(38350700002)(8936002)(1076003)(45080400002)(38100700002)(33656002)(508600001)(33716001)(956004)(55016002)(66556008)(7416002)(2906002)(6666004)(66476007)(54906003)(186003)(6916009)(26005)(966005)(8676002)(5660300002)(52116002)(6496006)(66946007)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rQKrVSNnt1LogJoQwTfbDT2ni1PG4Gd9JQ+Qe48C0BCbuyalby0WQ0H1WMYo?=
 =?us-ascii?Q?jfS0gVYoCaZDDekRWtsfxjPTuh3fGsEMrPT5YTY8XTfUhr7GGzvXMTrj8TvV?=
 =?us-ascii?Q?D6BsaaFeCcuv6mRt+dtdLt+aoq1ubyiX/o0BOd5HwmEtUz1QYW6BtNT5hdEv?=
 =?us-ascii?Q?3jZd4QOkt3+bikBbloO4NSBIgZCQ4XeXVvd1CNwqSdDGsbdy42nEZ0dMMmHj?=
 =?us-ascii?Q?S+VdksF7ebtwScACFFR+6/NuBkrmLxnoWg7FK+nBejNGLkDxzO/DCAmnroeP?=
 =?us-ascii?Q?n96i4sP8NuPkyZ4k5mk5ZITs294GeMbrmoVmmiPjKKefCHoeiLKvR8Ha405O?=
 =?us-ascii?Q?NRp3MNI5z9+eJHeiPHYhhY+i/u0oZsKXrE3c3d7JYhsKYpzINopzPt2DxE2c?=
 =?us-ascii?Q?f4tuzPtwXSAvPDSt+9rLQQXxAcfQjoHGPdiN/jvzIaRkPYdBMTRu9jYciDvF?=
 =?us-ascii?Q?EGjhy8FCauue9YWyPC4lsIlp9pUKwnut/mfx0iF6L93VFjg4wmH2OB3MHaJk?=
 =?us-ascii?Q?Wk4GCWtdYB+gtLqwN14nvbvn0VoioTMc2GgvXxJVD9JntgUJBTIEcUf7qZqi?=
 =?us-ascii?Q?adajujvIAyoemkP0oFiLOl2VSVwQI02RHD6AmxYscHoPlZoi8Hz3LyjnhxLb?=
 =?us-ascii?Q?CrPQqby4xYu1P4zwleFPU5+Y2pUGymOmKqhLknhr33oRhhpLBpF1QstiGAhk?=
 =?us-ascii?Q?y6JesL54tspGbXX8qNYWe86/LKgDEgk1yWyae/SZ3FXuggRrnV7d47GioWSS?=
 =?us-ascii?Q?kuk4DwsDsU9aB9HkhYl6Sd7lE6qfjxbkaC7FKI9unpcY5SEDoQRWC+8QHCAv?=
 =?us-ascii?Q?nrHaCxNvIF98v0O+7KOp4Eiadq641YJ//sv/DIDidloqjBq1eT2B9/U4tulA?=
 =?us-ascii?Q?YHPUHrlKeqCPNkhwAIEqVQMXWmuJpqZLc40gALdzsh7BWZh6nWe4KtBaLHQh?=
 =?us-ascii?Q?xJK7v1S/Kv/H5K+3yo4cJFw+SwyGbr+ez0uiAqSgnIHDOFNMH+Da8THm1i+N?=
 =?us-ascii?Q?0CsDcSW3fdadxog998EXkY8MRJucN80CPVtcIcEKQo1MXEpkQUxerOct4iU7?=
 =?us-ascii?Q?uxHXxUv6Q//HMGdvtc7YFuETW/RUtd8EVbBS/dZfaL771538PrnjT179h3Aj?=
 =?us-ascii?Q?3EbuYwupmSyKkRXLx2RPyF2zhIaEaBf5gFsT4uQgwKT9h7t/RPZdrOlE2OO3?=
 =?us-ascii?Q?6UN6VASNL5ymcfwv4Q+doMV0oP7z95UvhO3wmwzeVwB8ejjmHIxsYUUqgPc6?=
 =?us-ascii?Q?iKb6ueY1mZZmfMBcXZwejequQIq6ufGMpIy7TkgKUhdZM0GjtUAd3Y1/JchV?=
 =?us-ascii?Q?LZ/k9PS0KbcShJ3lrxxLPz9i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff8c890-5fc5-4c03-82a7-08d97dc1ef20
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:10:14.7049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjzdPetAMc4vcad1V+CcVuqTgozhmuhF80UswHYJ+IylHChPDtSgNmX6gkos68htzvHGin8hU46sXd3oykLMCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On Wed, Sep 22, 2021 at 11:38:08AM +0200, Borislav Petkov wrote:
> On Tue, Sep 21, 2021 at 04:07:03PM +0000, Sean Christopherson wrote:
> > init_hypervisor_platform(), after x86_init.hyper.init_platform() so that the
> > PV support can set the desired feature flags.  Since kvm_hypercall*() is only
> > used by KVM guests, set_cpu_cap(c, X86_FEATURE_VMMCALL) can be moved out of
> > early_init_amd/hygon() and into kvm_init_platform().
> 
> See below.
> 
> > Another option would be to refactor apply_alternatives() to allow
> > the caller to provide a different feature check mechanism than
> > boot_cpu_has(), which I think would let us drop X86_FEATURE_VMMCALL,
> > X86_FEATURE_VMCALL, and X86_FEATURE_VMW_VMMCALL from cpufeatures. That
> > might get more than a bit gross though.
> 
> Uuuf.
> 
> So here's what I'm seeing (line numbers given to show when stuff
> happens):
> 
> start_kernel
> |-> 953: setup_arch
>     |-> 794: early_cpu_init
>     |-> 936: init_hypervisor_platform
> |
> |-> 1134: check_bugs
> 	  |-> alternative_instructions
> 
> at line 794 setup_arch() calls early_cpu_init() which would end up
> setting X86_FEATURE_VMMCALL on an AMD guest, based on CPUID information.
> 
> init_hypervisor_platform() happens after that.
> 
> The alternatives patching happens in check_bugs() at line 1134. Which
> means, if one would consider moving the patching up, one would have
> to audit all the code between line 953 and 1134, whether it does
> set_cpu_cap() or some of the other helpers to set or clear bits in
> boot_cpu_data which controls the patching.
> 
> So for that I have only one thing to say: can'o'worms. We tried to move
> the memblock allocations placement in the boot process and generated at
> least 4 regressions. I'm still testing the fix for the fix for the 4th
> regression.
> 
> So moving stuff in the fragile boot process makes my hair stand up.
> 
> Refactoring apply_alternatives() to patch only for X86_FEATURE_VMMCALL
> and then patch again, I dunno, this stuff is fragile and it might cause
> some other similarly nasty fallout. And those are hard to debug because
> one does not see immediately when boot_cpu_data features are missing and
> functionality is behaving differently because of that.
> 
> So what's wrong with:
> 
> kvm_hypercall3:
> 
> 	if (cpu_feature_enabled(X86_FEATURE_VMMCALL))
> 		return kvm_sev_hypercall3(...);
> 
> 	/* rest of code */
> 
> ?
> 
> Dunno we probably had that already in those old versions and maybe that
> was shot down for another reason but it should get you what you want
> without having to test the world and more for regressions possibly
> happening from disturbing the house of cards called x86 boot order.
> 
> IMHO, I'd say.
> 

Thanks for the above explanation.

If we have to do this:
 	if (cpu_feature_enabled(X86_FEATURE_VMMCALL))
 		return kvm_sev_hypercall3(...);

Then isn't it cleaner to simply do it via the paravirt_ops interface,
i.e, pv_ops.mmu.notify_page_enc_status_changed() where the callback
is only set when SEV and live migration feature are supported and
invoked through early_set_memory_decrypted()/encrypted().

Another memory encryption platform can set it's callback accordingly.

Thanks,
Ashish

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7Cashish.kalra%40amd.com%7C02217ac26c444833d50208d97dacb5f0%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637679003031781718%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=1oXxchRABGifVoLwnXwQxQ7%2F%2FZpwGLqpGdma4Yz5sjw%3D&amp;reserved=0
