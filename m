Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81544413101
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 11:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhIUKAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 06:00:17 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:21903
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231450AbhIUKAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 06:00:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoWpLJ5IFUFPHJbGnlnjSfizi2e5guHf/gSsNY22tQvofDmr32Um6ubOTw7KoWUk8Cd8NvIm99LvQp4TrOegWt68rUG6rcC8GhmTQzuAPfY3/jmzkeHh7+PGuGLY8AE43Uf4qWrQGHEUNe5+3u6MC5bhcABc0IWTdux4D7KW8FLu8fI8/rCgBXmmZvYYr7agF5s7FLNc+MPquQfTSbW52lN0xQobcUbVA0SeQ+mZpVSpoD23QwHneAo0Fmi9zCFFMlbQM4aKv39HcBA+zj/Zrlvt+ar6ZCQ2TkIqLfpj0x9sTIQNH9ftJMIOARFfoQ/55/IBmel6Qzzu9Blxwo5EdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KA/KPM1BOeujtu38yN10TI/qgYoaf07meLkaK+8MjeY=;
 b=HAeWQ7HaE0EHwiesZLjmDrgCd35/0pGC4dLWUU+W/E0/9a/iFOPxbAhBEIQkN5vaGyBaO1UzMbAAjy+S9VPSvxG5qq2ZBRQQGA1sT5owhAfBWmjpGmXFg0yxaa1Y8VWiwn5uBZRprlKdsUiJR34U0nMZnhzJO+55cJ1GWEKGVIJesk7+48xoOiHmAC5ZXFRINVRQXNJQlsoXlBJGuV88OiG+n3UockvcVlYCFLqvGOAjTEPsNiaQ8ADV4w/wPlZ80HweTjpIDnpOXZjJ9UCxrMbEOxeuBoxUkwjgshe290DHo/Pd4se9Ik/Y97TXyxcLu40uEQMaxZYaEhsMa5Lgdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KA/KPM1BOeujtu38yN10TI/qgYoaf07meLkaK+8MjeY=;
 b=Id718gMqI68tMR5JxhpKRFLlncM37bJBGwDLChTofhQobTwHpLsdLN8Fyww5yFptGS/LWzVSk7j0lmZ0QV0ZTCP9Ubj0TL/Oa3x3blHCNm+Ius6SWqPm8RPDQH2XWceItJY5trNtrF+c0kAtN/LHJmt0VjeJQjoWDVCAq94G7QY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Tue, 21 Sep
 2021 09:58:45 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 09:58:45 +0000
Date:   Tue, 21 Sep 2021 09:58:38 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@alien8.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <20210921095838.GA17357@ashkalra_ubuntu_server>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUixqL+SRVaVNF07@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN7PR04CA0120.namprd04.prod.outlook.com
 (2603:10b6:806:122::35) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0120.namprd04.prod.outlook.com (2603:10b6:806:122::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 09:58:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fca91d0-2973-4f1b-9b8d-08d97ce6663d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2415943A2A1E6B8927832C0F8EA19@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +tCko58C2Gd6VURP03ZM1ABpYyGUllK7P6hx7+ITCHbD4GFwQHLiWT11xDItZV22UqWh1dRqcaHbXid6ggWK009m1f96JN7MPkXS4tPm9iBagzrzhjmN+DBLn+r6Mjv39gHXE8zmH5um/TSZAuh4bMKnU+fcaR3AUQct57tWTxC4wagYkqpy32jq7o20B4TwByqJDxY767vJmnyhfU8MOdEKWZfLu+A88MztV02XEbxcl9R8Bsmz5oqS/YRiN2sr4LYHb4kh+mIxwXpyst0TgBp9I2Xxh6yMaHkXTayskBLNfo/aCH1TVLqyt1qItIQ/xgF906fzbQjME5JWoxk5uZlPQR+E0AoyRETZT04+D27OuUW9TikUYWG6hSWkpLb/AK1f4AIBmmYOKsd1duaPxC/U9fP6SViWBPPv6vyeG6oreDnHeiygyxl0vQkn/NRE+5+ArBPKwl60aeAGNbOaF8QfXklML8wO844G09MsINx9Y8TpZLoCMXkwzycPpeOvWKseJ1L8hvbdVXudglFC0GIT2KyhjVKBsfBYu4vX98mWX0yBmculVDI+ZlrDCGd1ICuDNS5UNa3yjGco8hiPSrXHnzCrVYQQqa6a0Rdab0D+G+Hawdxjgorj8S8gaI3+oaj1L08un6GMQFhKMXZBeJN8YEE4oFbVgsxW1TYZkBtR7SIC/DyYWFySs4vBOV7zHs3mON3LsPYOwXI90QPPqKA6jSN6xtWQ9vlT9ACmcdY5FvuHwTbw8NiyoYaBofqFg/7UYlm2rbmcBVUtyZBp2qWg+ogyQcZs/05AjS+I9C4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(186003)(26005)(45080400002)(956004)(6496006)(52116002)(1076003)(38350700002)(8676002)(38100700002)(53546011)(33716001)(44832011)(86362001)(55016002)(33656002)(4326008)(5660300002)(2906002)(66946007)(66556008)(66476007)(7416002)(316002)(9686003)(8936002)(6666004)(508600001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PxshcJixFImKZwtZ9yvfAREun+jFreMIcz1rCCCxZ6qOXWmq8Mq/P8Oblfsj?=
 =?us-ascii?Q?R9mB7uwDFZzSwpvRVpx4jrOv+cH0sLJXBcj11aYVdtTP1qFhfhbwQjti5Lcg?=
 =?us-ascii?Q?Xo03dlAwSmS1TWA/hkYqkBcQdj0U+To1tfynMK2oH4HlJaBVvFXlll19kOmA?=
 =?us-ascii?Q?WcElXoPyREKt2HrUm9HOhNeVSgpwSiZuLa21v6IhTZOfrWJjdDCJprZriQri?=
 =?us-ascii?Q?1EzNmhAAEf2QEwis9+B5bwLNZ2BAK/zEG0+DoLM8lsHxlwiSAAGfXH1naF43?=
 =?us-ascii?Q?ZFM1KUjPWNMkwEnMrm+Ig2qCy41QLqplJaXKSaX9LszO0WwYeH4/HLhYs39A?=
 =?us-ascii?Q?cDHSlxUBjr68BQXZBF5hz+I6qkOsjLCjP5oF9I7X4y3dfvG1WfGezLYfJQl/?=
 =?us-ascii?Q?cxpY6xCWxDHZyCUYCxvs41U9jz3OIBGTa1T2Rq42xE1g+Q5XGkzjJI4b6jpU?=
 =?us-ascii?Q?bl/w0wRHa1jEOH8e5e3huUkndr49onTOWsNqxu0KEwcoZgNizJZLfkxU6roa?=
 =?us-ascii?Q?9UxOhLWrAZwoLEjwDWL6DZwzk1iO2X4rQO8UAutKHvhI0JctXKP7mBtPUg7h?=
 =?us-ascii?Q?d8navL7auvV5a5rHAWSVFfFFdMrDUu5qh0bg7D9HkZuuiMATAyQAL43gCrmT?=
 =?us-ascii?Q?kVa7kvY6/EdsU+PvPI/d94bOyhknxrfFV0EJgT1pLdMUUJl75uqUnU0B13PN?=
 =?us-ascii?Q?4JfsaThENehnu+AhDnrNEjY9wXAxo2XrRn0Tcfa2VHRK4QkoNdgK6p4ZYNoq?=
 =?us-ascii?Q?IHtp0X7fdnHQpgDwcUO5+a0SeQiWjmYUFzXprah6R/ptzwnyWqUvdc/MWDLo?=
 =?us-ascii?Q?v9YoOxfARKjx9IJTJ0U7cY2SYSRzHI7ZaRbmrj3xRuDnkvpJr0bAqPypD2xO?=
 =?us-ascii?Q?LvWXfhafSVTSlwvZnO21R/6mD0vIA4pL6PfYDwq6i3GyjGOqQgCxDI6A9+u2?=
 =?us-ascii?Q?Z4M1QRWktnSQXEY8yvxSZypjP5Pak5VTDDhHd2ql4y/T7JKjH5halK2A/jkz?=
 =?us-ascii?Q?YSydhwiaGdbto/ow+6XLq5hZSD8n78wIx5C6lbakgVwxxHB6ii6cJfv0GdOf?=
 =?us-ascii?Q?My7dqgt5UBjg+cxQRl5JbmZtF814JB5NRYpDbH4KeAdtjF2IHWZi0JP2W9hZ?=
 =?us-ascii?Q?YJMBaGLIeezUo3c6GqGufJm6/GKN+UGf9xZpnB0DxUj3ltEFL+/dCcXM/ib7?=
 =?us-ascii?Q?u8dhNYnabTEZNFlctcPryhLuyTSbLpvJIA193/Ys/OqqCo0FVbdkrq7y1PXp?=
 =?us-ascii?Q?xhXtjnKtcXTRRNiGDFWC8QlisSMpaDz092fWNnLRmwTBMf37WskxS0Djve3E?=
 =?us-ascii?Q?eXFGK2Xp36aOWwHTZhHP0Ecc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fca91d0-2973-4f1b-9b8d-08d97ce6663d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 09:58:45.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQcJGwg5R+Y+wUPkWdO6fPG2zzhaq+iQfi2zSJo5+FRAIUJZaMK0okCuFPNuSAQrkcoKfrMaw5DBYIUhO2xNFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean, Steve,

On Mon, Sep 20, 2021 at 04:07:04PM +0000, Sean Christopherson wrote:
> On Wed, Sep 15, 2021, Steve Rutherford wrote:
> > Looking at these threads, this patch either:
> > 1) Needs review/approval from a maintainer that is interested or
> > 2) Should flip back to using alternative (as suggested by Sean). In
> > particular: `ALTERNATIVE("vmmcall", "vmcall",
> > ALT_NOT(X86_FEATURE_VMMCALL))`. My understanding is that the advantage
> > of this is that (after calling apply alternatives) you get exactly the
> > same behavior as before. But before apply alternatives, you get the
> > desired flipped behavior. The previous patch changed the behavior
> > after apply alternatives in a very slight manner (if feature flags
> > were not set, you'd get a different instruction).
> > 

This is simply a Hack, i don't think this is a good approach to take forward.

> > I personally don't have strong feelings on this decision, but this
> > decision does need to be made for this patch series to move forward.
> > 
> > I'd also be curious to hear Sean's opinion on this since he was vocal
> > about this previously.
> 
> Pulling in Ashish's last email from the previous thread, which I failed to respond
> to.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20210820133223.GA28059%40ashkalra_ubuntu_server%2FT%2F%23u&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7C14e66eb4c505448175ae08d97c50b3c1%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637677508322702274%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=STJ6ze6iE7Uu7U3XPwWhMxwB%2BoYYcbZ7JcnIdlZ41rY%3D&amp;reserved=0
> 
> On Fri, Aug 20, 2021, Ashish Kalra wrote:
> > On Thu, Aug 19, 2021 at 11:15:26PM +0000, Sean Christopherson wrote:
> > > On Thu, Aug 19, 2021, Kalra, Ashish wrote:
> > > >
> > > > > On Aug 20, 2021, at 3:38 AM, Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
> > > > > I think it makes more sense to stick to the original approach/patch, i.e.,
> > > > > introducing a new private hypercall interface like kvm_sev_hypercall3() and
> > > > > let early paravirtualized kernel code invoke this private hypercall
> > > > > interface wherever required.
> > >
> > > I don't like the idea of duplicating code just because the problem is tricky to
> > > solve.  Right now it's just one function, but it could balloon to multiple in
> > > the future.  Plus there's always the possibility of a new, pre-alternatives
> > > kvm_hypercall() being added in generic code, at which point using an SEV-specific
> > > variant gets even uglier.
> 
> ...
> 
> > Now, apply_alternatives() is called much later when setup_arch() calls
> > check_bugs(), so we do need some kind of an early, pre-alternatives
> > hypercall interface.
> >
> > Other cases of pre-alternatives hypercalls include marking per-cpu GHCB
> > pages as decrypted on SEV-ES and per-cpu apf_reason, steal_time and
> > kvm_apic_eoi as decrypted for SEV generally.
> >
> > Actually using this kvm_sev_hypercall3() function may be abstracted
> > quite nicely. All these early hypercalls are made through
> > early_set_memory_XX() interfaces, which in turn invoke pv_ops.
> >
> > Now, pv_ops can have this SEV/TDX specific abstractions.
> >
> > Currently, pv_ops.mmu.notify_page_enc_status_changed() callback is setup
> > to kvm_sev_hypercall3() in case of SEV.
> >
> > Similarly, in case of TDX, pv_ops.mmu.notify_page_enc_status_changed() can
> > be setup to a TDX specific callback.
> >
> > Therefore, this early_set_memory_XX() -> pv_ops.mmu.notify_page_enc_status_changed()
> > is a generic interface and can easily have SEV, TDX and any other future platform
> > specific abstractions added to it.
> 
> Unless there's some fundamental technical hurdle I'm overlooking, if pv_ops can
> be configured early enough to handle this, then so can alternatives.  
> 

Now, as i mentioned earlier, apply_alternatives() is only called boot
CPU identification has been done which is a lot of support code which
may be dependent on earlier setup_arch() code and then it does CPU
mitigtion selections before patching alternatives, again which may have
dependencies on previous code paths in setup_arch(), so i am not sure if
we can call apply_alternatives() earlier. 

Maybe for a guest kernel and virtualized boot enviroment, CPU
identification may not be as complicated as for a physical host, but
still it may have dependencies on earlier architecture specific boot
code.

> Adding notify_page_enc_status_changed() may be necessary in the future, e.g. for TDX
> or SNP, but IMO that is orthogonal to adding a generic, 100% redundant helper.

If we have to do this in the future and as Sean mentioned ealier that
vmcall needs to be fixed for TDX (as it will cause a #VE), then why not
add this abstraction right now ?

Thanks,
Ashish

> I appreciate that simply swapping the default from VMCALL->VMMCALL is a bit dirty
> since it gives special meaning to the default value, but if that's the argument
> against reusing kvm_hypercall3() then we should solve the early alternatives
> problem, not fudge around it.
