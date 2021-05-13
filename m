Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C691737F348
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 08:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhEMG6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 02:58:22 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:64452
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230246AbhEMG6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 02:58:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGQAlPNQwbsE5rDCHVC/2q1nJ38o4+m1E+2eahgtKqvhSVfIdhPPGJNlYrmR8Cefk/V1x0b40U8qmZY0CjKJEfcJZxJHltE3gb5nU7bDlcCDxtTRx8bae8+20RJGLR6lfxOsXvSfb0MpsGS6dn+jafJ0A+ooXwVF8apJ87WdiRZtrRX7KiZM1L6HgdNVVMGG1DP/MJt2plLUQW/MfIrKxhjhEKSkH7BsztB/ubbvKQ2IoqCZYfZRhTiKsyc1h1hE4M7RNCuV/t0GqM4g7/t06oMEoqtI/PcpbAI5m7FqtDWJ+vekYAvGSHXhKAtuw36Ck3vVIfAaAi4SYphPPTrNWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttS+eyB8bhWFjkaoSi9nIszdM9nLH+znD9tP0BZpwGE=;
 b=eiLpHKNU7G4aDLR4d0bJD7LuPo1qZb8AaQwqoaFagisLi9Z8Ii2R6oE75rTm7vfL5HMRvvp9lUh8jTi/Mp22SGWpSr2YNP8J9zJV0J0gX87EnMVMZsmehtrR6BeUEVqfGzCilyc8U1ePA1/9QQsSsROu7GJkAIjUPir+GdGrucCT76jFA7ewylNP5C3i6lns/210uvvbueDTsI5hWwQWqVFoCRe+p1IvzaRindprmxRAn9DRJGo2oYmCYII3TbSdHUn60Yme3Psi8RxTuoX5dtTTO/7w6eMF+xaMgMYUcJzuDYlHHLe0qHKJ9NBIcyy4XEcZ3YNsL0D0WE4w98F29A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttS+eyB8bhWFjkaoSi9nIszdM9nLH+znD9tP0BZpwGE=;
 b=H6elv9Bu2IKgF19lTxgXh9jxha87fEGf5q7uZEH7cUn/B20r8p4I8R1Wyo8ZaDaUJF2L3AIOV3yEkUk1YovF5IYwuX40xRviVghfxK9+hVyQYv4El0mt06u7JBSU9Ub6vkpBHOdnWiA7dqDH0C4x25xg/KuABOU39FXbzNCJiko=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 06:57:09 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 06:57:09 +0000
Date:   Thu, 13 May 2021 06:57:03 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210513065703.GA8173@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <YJv5bjd0xThIahaa@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJv5bjd0xThIahaa@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0068.namprd02.prod.outlook.com
 (2603:10b6:803:20::30) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0201CA0068.namprd02.prod.outlook.com (2603:10b6:803:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 06:57:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 643dc8e4-efc7-4469-f59c-08d915dc5366
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368000B753970660751C5418E519@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2Jhe/05e7WT0lCrr+V0xNlMa0t/lJJiixEW+eC/GE5dcm4UAn2y6Wb2VqPHqxQf3GcG0tv0np1wZ2iSivDpv2nA1usCB7IRndSD62QuQDF4tsSCS7qBaaIuoT1fQHoj8gpOjyK48cbli4MFVZuMYRWlUSUuXdgAcorvNyCx3AC/Vl9mNEc19oFX0XG84Nyfv9dxyVDz8yzZNRPlM7pyzDztqak9pcqcSiVwYrWfOpyFN828Gdj/MyrLM4PyovPxXozUKDutQSvhsd6s8dHqTcdVCqPkYG7LaqBBZGKVzn/ZvtOhX/grte9kwCEsyiW2bW4v6KWfCPzfcaKka/dzWz5JnhkPNBJSZWxcGdZCe6Bu6PIQXtOOARzU3aJktLxc9vP23et06IbG8vlwzSqoS6FPeCT04Gq6RWt1ElhFlu/oT6yyj1VbZCdB9ZPBDXgTUYfCWNlRZvEtBS3/f2/pzJYtExVSJAZBGIe0yU3yJOMYvikuipWUNSi/umVxILGBMPCe80NBExwNeg3S9UAvYuZ3VbCUOc2TsvFPjJTkN2Qq7QtisbQb3CCYFP9s9He88yQrl9ekGdvlV3Fur6hGf/+HjPtxjjUAr0oMDXBPWkdweTiMqCfe2LIMeHPDlDXaEuIxUs3mQd7KjhoP1eF/eoiHwl10Mn7VihCkjKX1ofE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(9686003)(478600001)(38350700002)(16526019)(55016002)(33656002)(44832011)(316002)(38100700002)(956004)(26005)(66556008)(66476007)(33716001)(8936002)(186003)(1076003)(8676002)(4326008)(6496006)(2906002)(66946007)(6666004)(5660300002)(6916009)(86362001)(52116002)(7416002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?147x+E0wzVWbzvpnYCpidfeKelmLkQV27+9rKT2LYWOet61hLYgG2q/JPBhJ?=
 =?us-ascii?Q?eEvn+bM9TO5YHb52Eha2XjVgdrOdyudOaT5YhYikrOPNz+4g3UbbWaaaWsCZ?=
 =?us-ascii?Q?cNOzCIEU1lf8+CQyfsPcunwfhACz94ng1Hd2I4R/aHmzCAeCm/T/pgMRwys1?=
 =?us-ascii?Q?NWTOK8QLHitIoKqEgSWCpydi52xkjaN4I36w0Inh4+6C55LlsAlWR+9OYO6N?=
 =?us-ascii?Q?ut8e85Fhn0U1yUZRyg0QqDi3DcyOwSE9fUWYbYdPDxxUjOAW3MxqmTQ3R1jb?=
 =?us-ascii?Q?w8f44pl6JfEL96SNCawcYa3GWgus4DoF5vpdH+Va/Kdhl3OQ5nhQh82tiioi?=
 =?us-ascii?Q?R4C9gcSxctIFmFTQiCGgt/+I7tZGoKfPTokFlES8Y4/3pjvpzCCPmxYFvHTs?=
 =?us-ascii?Q?yVw2U4RIMRGupkykuL7MJCoe2B950p9MVad05G+5ENPlLuBREmDdNTW8UbY5?=
 =?us-ascii?Q?Hy0ZYOCZrVbCZPHCWs45aku1bsypak8jUQqMjPq6lhianaNl5GnCXsKsJ36s?=
 =?us-ascii?Q?K5+Z8GPsL/4cDcpJxIDeeMSbjEq+KL1QOK75aDhKIXSiOZYnp12uRR1CBkj4?=
 =?us-ascii?Q?1VdggGdsxKvQX1okJaP/VQaA/7NoAkSEyWQaLkgcuKe8p+hM5/mSR98s2itx?=
 =?us-ascii?Q?PCLPbeOn5MRv9klmvo/6bvxOLVonWOMhNB0aL4uZF9/xJQETNsJdHT32o1UY?=
 =?us-ascii?Q?TlL5OBrFv13SickHUxeriqusr0KIxH7a0nH+KVTApWI1qz1evb/BKoDghmEG?=
 =?us-ascii?Q?yVJWeNYqfP/yjJWvNU9GPreF+oMe50OJe9vJutbe6t38+infGins8IrvV+mJ?=
 =?us-ascii?Q?qEhkFzEBGOxRq+gGqtm07RgSJN3eCiEMm/seR4bqcrpkjgCUr/SY2cW9VI6Z?=
 =?us-ascii?Q?2vrlrXZyRhj/jucnu6weJD13B45AuznyhpVuRmt0tlhGjjsG+Yqsa7bKSKfm?=
 =?us-ascii?Q?RQRkUi7xyqppkh5eHKKlqmHL5jBZTxKVWJFHV+k7kQ9TrhBnjwcPvsB1vhnJ?=
 =?us-ascii?Q?vhSNT0V6ugOJGH2vTmFxs+SXDdh8x9oob5rfvPuEoAbc6TEL8/uEseGerStq?=
 =?us-ascii?Q?31sBmuZ4WoiIfgPkQVXZpnA2l4oUjNmyN8xYlKFzJhls8Ag4WUsi0lhEKzlR?=
 =?us-ascii?Q?z1LMaEjH9EHropX7hSxBBjAF1z7cgUPHIqxYqjlvTXduTDDCZO1JqTmsenvy?=
 =?us-ascii?Q?bNsw0DCLSxDiyJaGB3mV4pOm912WAIsEvkZg2key3B7fifTThsWDTW8kyVOF?=
 =?us-ascii?Q?XEZJAZW4dwIfMwZfuOTuqHzEQMVlBm3vVEk0zqB/hTRo/XtdLPstVyyan1t1?=
 =?us-ascii?Q?1DCckwaxDmXc4oxknbi2wrzX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 643dc8e4-efc7-4469-f59c-08d915dc5366
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 06:57:09.0318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUBXS2jXtrxI3Th4cdKI2JylaOT4cnAPrdQFJEk9Gqv7zOU5hSooJDjJVHmZJ93qLJ3sh6tB3Dl9DHp8T2XlCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

On Wed, May 12, 2021 at 03:51:10PM +0000, Sean Christopherson wrote:
> On Wed, May 12, 2021, Borislav Petkov wrote:
> > On Fri, Apr 23, 2021 at 03:58:43PM +0000, Ashish Kalra wrote:
> > > +static inline void notify_page_enc_status_changed(unsigned long pfn,
> > > +						  int npages, bool enc)
> > > +{
> > > +	PVOP_VCALL3(mmu.notify_page_enc_status_changed, pfn, npages, enc);
> > > +}
> > 
> > Now the question is whether something like that is needed for TDX, and,
> > if so, could it be shared by both.
> 
> Yes, TDX needs this same hook, but "can't" reuse the hypercall verbatime.  Ditto
> for SEV-SNP.  I wanted to squish everything into a single common hypercall, but
> that didn't pan out.
> 
> The problem is that both TDX and SNP define their own versions of this so that
> any guest kernel that complies with the TDX|SNP specification will run cleanly
> on a hypervisor that also complies with the spec.  This KVM-specific hook doesn't
> meet those requires because non-Linux guest support will be sketchy at best, and
> non-KVM hypervisor support will be non-existent.
> 
> The best we can do, short of refusing to support TDX or SNP, is to make this
> KVM-specific hypercall compatible with TDX and SNP so that the bulk of the
> control logic is identical.  The mechanics of actually invoking the hypercall
> will differ, but if done right, everything else should be reusable without
> modification.
> 
> I had an in-depth analysis of this, but it was all off-list.  Pasted below. 
> 
>   TDX uses GPRs to communicate with the host, so it can tunnel "legacy" hypercalls
>   from time zero.  SNP could technically do the same (with a revised GHCB spec),
>   but it'd be butt ugly.  And of course trying to go that route for either TDX or
>   SNP would run into the problem of having to coordinate the ABI for the "legacy"
>   hypercall across all guests and hosts.  So yeah, trying to remove any of the
>   three (KVM vs. SNP vs. TDX) interfaces is sadly just wishful thinking.
> 
>   That being said, I do think we can reuse the KVM specific hypercall for TDX and
>   SNP.  Both will still need a {TDX,SNP}-specific GCH{I,B} protocol so that cross-
>   vendor compatibility is guaranteed, but that shouldn't preclude a guest that is
>   KVM enlightened from switching to the KVM specific hypercall once it can do so.
>   More thoughts later on.
> 
>   > I guess a common structure could be used along the lines of what is in the
>   > GHCB spec today, but that seems like overkill for SEV/SEV-ES, which will
>   > only ever really do a single page range at a time (through
>   > set_memory_encrypted() and set_memory_decrypted()). The reason for the
>   > expanded form for SEV-SNP is that the OS can (proactively) adjust multiple
>   > page ranges in advance. Will TDX need to do something similar?
> 
>   Yes, TDX needs the exact same thing.  All three (SEV, SNP, and TDX) have more or
>   less the exact same hook in the guest (Linux, obviously) kernel.
> 
>   > If so, the only real common piece in KVM is a function to track what pages
>   > are shared vs private, which would only require a simple interface.
> 
>   It's not just KVM, it's also the relevant code in the guest kernel(s) and other
>   hypervisors.  And the MMU side of KVM will likely be able to share code, e.g. to
>   act on the page size hint.
> 
>   > So for SEV/SEV-ES, a simpler hypercall interface to specify a single page
>   > range is really all that is needed, but it must be common across
>   > hypervisors. I think that was one Sean's points originally, we don't want
>   > one hypercall for KVM, one for Hyper-V, one for VMware, one for Xen, etc.
> 
>   For the KVM defined interface (required for SEV/SEV-ES), I think it makes sense
>   to make it a superset of the SNP and TDX protocols so that it _can_ be used in
>   lieu of the SNP/TDX specific protocol.  I don't know for sure whether or not
>   that will actually yield better code and/or performance, but it costs us almost
>   nothing and at least gives us the option of further optimizing the Linux+KVM
>   combination.
> 
>   It probably shouldn't be a strict superset, as in practice I don't think SNP
>   approach of having individual entries when batching multiple pages will yield
>   the best performance.  E.g. the vast majority (maybe all?) of conversions for a
>   Linux guest will be physically contiguous and will have the same preferred page
>   size, at which point there will be less overhead if the guest specifies a
>   massive range as opposed to having to santize and fill a large buffer.
> 
>   TL;DR: I think the KVM hypercall should be something like this, so that it can
>   be used for SNP and TDX, and possibly for other purposes, e.g. for paravirt
>   performance enhancements or something.
> 
>     8. KVM_HC_MAP_GPA_RANGE
>     -----------------------
>     :Architecture: x86
>     :Status: active
>     :Purpose: Request KVM to map a GPA range with the specified attributes.
> 
>     a0: the guest physical address of the start page
>     a1: the number of (4kb) pages (must be contiguous in GPA space)
>     a2: attributes
> 
>   where 'attributes' could be something like:
> 
>     bits  3:0 - preferred page size encoding 0 = 4kb, 1 = 2mb, 2 = 1gb, etc...
>     bit     4 - plaintext = 0, encrypted = 1
>     bits 63:5 - reserved (must be zero)
> 

Ok. Will modify page encryption status hypercall to be compatible with
the above defined interface.

Thanks,
Ashish
