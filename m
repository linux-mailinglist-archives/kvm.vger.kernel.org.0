Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E42DC2DA
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 16:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgLPPNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 10:13:04 -0500
Received: from mail-eopbgr750081.outbound.protection.outlook.com ([40.107.75.81]:22549
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726031AbgLPPNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 10:13:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzYTvyl/ErgG4oTT69HC+5uk5Ev1Lf6AEV94PzHZPkDpVQhpemXo613XfKuTXTRp27qm3N0Kuo8AM7giOZwn+zskyc0Kpy3BOrwE1+7Xf6J2bdXwex6rut5h4/R/KhkDaBQNR1C5Ip+3jWadAZL14QIi5yya2M3vm7GYA7qHY9pBOa6MWQe68ZxZreiWaf4toIdnOVPL0gg+u+gPofk2UWAb6UuU0wdiD4tl5Bf0BAJmiACkAImHITi7TSiz26vKiEBWb+QYX+weRs7vSegkzSLMvJOePnsmaMLeNxWUGO/8eonVVMAN/RlRBnkxQpPTwDi9V3tV/v1F7mCLVUqjxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNT4dylDZwFT80MBTy+7a1yo/cOADCEaSmJbR0tLyas=;
 b=QP8VRxQT6icWlzFqfTUCZrZ9JDwdjlDCdPYwEC49X/gsww9hNSCA27sf5/Pemy+n3vGm89i+eM9aGQGuv3aCgXZtHBhkce02aXMRm+3d6A5cBe6xMj2gKEWLHkbNm1nq47xx+Qw9MTZfkgB2EDW4xCB/D0LwqfhkfKFdGdk//HC0z46h2m/EOWkYaw6u3ucHvxz9vJgJsA7KaYJPW5bSRtqKkve/Gt6b2XTbEyuBwBbqlHfQSFvrABuc+y/pxmNCjbpIEkicl8Umr2KGdwe+C/eR3CAuSlrFCmIfe0MDPnChrGAohlak0omaCvn6vrWg/qZwaBQoLTepcTa2eUal8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNT4dylDZwFT80MBTy+7a1yo/cOADCEaSmJbR0tLyas=;
 b=iK/h+1KtMESGu0+pqArYF77hv+CPPxjdbCzvC2im50BMKhejW1+a40WzIvs3gb/AriGbeMLjLHxKF8vv1ea7QbCyQiZFTq5XmHuCZOcesTiTUf38EAnjuHG1pHIz+MxJGQZ92D9Vjvv/FBKyblilhJAuZTS3uFWOkbFFGwyxfXg=
Authentication-Results: amacapital.net; dkim=none (message not signed)
 header.d=none;amacapital.net; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4954.namprd12.prod.outlook.com (2603:10b6:610:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 15:12:14 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%6]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 15:12:13 +0000
Date:   Wed, 16 Dec 2020 09:12:03 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <20201216151203.utpaitooaer7mdfa@amd.com>
References: <20201214220213.np7ytcxmm6xcyllm@amd.com>
 <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
 <20201215181747.jhozec5gpa4ud5qt@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201215181747.jhozec5gpa4ud5qt@amd.com>
X-Originating-IP: [165.204.11.250]
X-ClientProxiedBy: BL1PR13CA0252.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::17) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.11.250) by BL1PR13CA0252.namprd13.prod.outlook.com (2603:10b6:208:2ba::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.12 via Frontend Transport; Wed, 16 Dec 2020 15:12:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 313d23b4-2936-4443-f1b9-08d8a1d4f7fc
X-MS-TrafficTypeDiagnostic: CH2PR12MB4954:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB49540441E532A553AE95C45595C50@CH2PR12MB4954.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PHyFAxTcCAwj2C5rVQGN8m87n2GbNKHS2+QrowEISQi0fqccxQ1en/JYsyfrid0RX37/Bsw8/EcxMjOSX4gsaZkfw8riHfw3uwoN5vJ8I+fYJaOMvh73Kz/bXZk85cWxKdvRxxEcB1gBAwKt2MvGeCQ4on4wbvuiMP8IPlT8kHNqK7D+m8t4GngIaKvvqcsI48moCcxcW2EgeNjH8g5Cq+TgHf7m7Qf5bRe6NN7Dpv7fNerBHiFunSTqA5X9Mduf4VH5T+evTqc84WGn3xYak2iCFhzr+452I8OjUbZwG3nTg9gUNNGOzb7Qxhp+pZiIE3kLsl4+HctzpLGBMjqJ1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(8676002)(478600001)(8936002)(86362001)(83380400001)(316002)(44832011)(6486002)(66476007)(66946007)(5660300002)(54906003)(2616005)(1076003)(7416002)(956004)(6666004)(6496006)(66556008)(52116002)(36756003)(4326008)(6916009)(16526019)(53546011)(186003)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eXpLUzl4L3FCdGZLSHprZnFpbEpJMktEQ2xsVHVpT1N6UXp5L3RJQm4vN3Uv?=
 =?utf-8?B?bFR1R1MvaFNPSlBIcUlWTXNSNENMM0pvMTE4WXAzYlhlalJjT3ZtcGh4WXR1?=
 =?utf-8?B?QTlFaUlLWGx3T0R4UmhNVzNKL0g4SVR4SHNtSXV3cWR5TTJmSzhVVmQ3bU9x?=
 =?utf-8?B?b1F3elhJbkJ0azJQU2lVQTNKYTJYWmdhcEZPaU5majNvS0ZyOHFHSWdkdGFt?=
 =?utf-8?B?Ym5LOGVUYU5hcE5Na3pSV1QwRVZ2R0tGaytBdUdQY2Z2U2ora2dJb1hObnpx?=
 =?utf-8?B?bGpKNGxvazZIM0JnVUtUOHpWTTJsYXlSOVlnQ2kvc1FzelNqTG0ybkc4UE5U?=
 =?utf-8?B?QlFlUVlQODFyZW96Vi9ZK0lmVzdkMFFSR0ZiWkpUTXRRbWJjSXBCWXlXb2Vn?=
 =?utf-8?B?TFFvTXY1TzFiMTEzR1NUdU9BMXE3czZ0NmhiOTk4RTFyMko0ZEMxQW9JVklW?=
 =?utf-8?B?em5TSHFuQWhMWm1ic3lLSytsRG1KMTlEdVEwc1JlT29VOTYxR0pkaE1CbG12?=
 =?utf-8?B?TlNuVzFKTUlNN1R2MjdibytjMnhuQkhJUTk2cEJ1L01jaHh0N25BZVhYRjI2?=
 =?utf-8?B?d1NnVlVqU3JvTnVwTWFoMmdtbXJqYUlnMVZZWGJ6d3o3RThqVEpoU3ZzU3kv?=
 =?utf-8?B?d1Y1TURuWTRKWThvWTlTQUpwS2VlNUp3dFErd2dvZmE5NTVEVFBQWW5CU3BD?=
 =?utf-8?B?Qk8rc0M1RUMvdlpOSUZ1NTdPZWdLanRCcTdhcUVMMU4ySytlNlJ5OXdqMUtp?=
 =?utf-8?B?MnVQdWJQNFdOTDRCaStSNHM5dENqdkNad0RvM2t4MUVzSVp6dDdadVRISW1j?=
 =?utf-8?B?NFYvTktvbHNIdVkzdlgrRFN6anppUUpiV3I3bnY5S2R6ak00dk5LWll4YXVo?=
 =?utf-8?B?dENKVTNEdEtxbzV3VFVTL25wR2lpRkZCb3BLeW1za0EwTCtZUVZWNTlKWG03?=
 =?utf-8?B?eWxKNndMWXhQK1M0bzlITml4WG0rT2dTWm5vQ0pEbEhySHVPeW1jSS9wckY2?=
 =?utf-8?B?NGhnU1pWT3Q3MmpVTWxNVmVSajhwdzJaUjlUMU0wRFcrMXZ6Mi9IWFZReTJU?=
 =?utf-8?B?VnVDR0pnMFI3SnRBRll6ZGtWcWdDUmQ3bmdiREZCOEtIK0crZEFhQVJMR211?=
 =?utf-8?B?RjM1WlBXZy9HWjRjNktkTGcvTjVPSXA1TDJYUno2ZzJoZXlnTjFBSWdCa21O?=
 =?utf-8?B?Wmt0Umd1ei9aV0xJZ0k4WjlVMUNUVXd6d0pra29FU2crSzB5bXc2WC9yTEZm?=
 =?utf-8?B?bEp5YWo0aU1MSzJWcXFnVGFCL1N5eXRJUnBrb3daL1JwaFhPbmpBa3hMLzFG?=
 =?utf-8?Q?XOj5ob2QMCzOjV+oaTF18wQE+2QNvz8sfW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 15:12:13.7149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 313d23b4-2936-4443-f1b9-08d8a1d4f7fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auSTJsjb0QuRCQEkyW59OZW2CZ/Tz291r3BD0ye2okpE4RZ1IxqQGIEt/D7w/G+iti1qmMPdUDL3dLSaz/BfrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4954
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 12:17:47PM -0600, Michael Roth wrote:
> On Mon, Dec 14, 2020 at 02:29:46PM -0800, Andy Lutomirski wrote:
> > 
> > 
> > > On Dec 14, 2020, at 2:02 PM, Michael Roth <michael.roth@amd.com> wrote:
> > > 
> > > ﻿On Mon, Dec 14, 2020 at 11:38:23AM -0800, Sean Christopherson wrote:
> > >> +Andy, who provided a lot of feedback on v1.
> > >> On Mon, Dec 14, 2020, Michael Roth wrote:
> > >> Cc: Andy Lutomirski <luto@kernel.org>
> > >>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> > >>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> > >>> ---
> > >>> v2:
> > >>> * rebase on latest kvm/next
> > >>> * move VMLOAD to just after vmexit so we can use it to handle all FS/GS
> > >>> host state restoration and rather than relying on loadsegment() and
> > >>> explicit write to MSR_GS_BASE (Andy)
> > >>> * drop 'host' field from struct vcpu_svm since it is no longer needed
> > >>> for storing FS/GS/LDT state (Andy)
> > >>> ---
> > >>> arch/x86/kvm/svm/svm.c | 44 ++++++++++++++++--------------------------
> > >>> arch/x86/kvm/svm/svm.h | 14 +++-----------
> > >>> 2 files changed, 20 insertions(+), 38 deletions(-)
> > >>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > >>> index 0e52fac4f5ae..fb15b7bd461f 100644
> > >>> --- a/arch/x86/kvm/svm/svm.c
> > >>> +++ b/arch/x86/kvm/svm/svm.c
> > >>> @@ -1367,15 +1367,19 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > >>>       vmcb_mark_all_dirty(svm->vmcb);
> > >>>   }
> > >>> -#ifdef CONFIG_X86_64
> > >>> -    rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
> > >>> -#endif
> > >>> -    savesegment(fs, svm->host.fs);
> > >>> -    savesegment(gs, svm->host.gs);
> > >>> -    svm->host.ldt = kvm_read_ldt();
> > >>> -
> > >>> -    for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> > >>> +    for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> > >>>       rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> > >>> +    }
> > > 
> > > Hi Sean,
> > > 
> > > Hopefully I've got my email situation sorted out now...
> > > 
> > >> Unnecessary change that violates preferred coding style.  Checkpatch explicitly
> > >> complains about this.
> > >> WARNING: braces {} are not necessary for single statement blocks
> > >> #132: FILE: arch/x86/kvm/svm/svm.c:1370:
> > >> +    for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> > >>       rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> > >> +
> > > 
> > > Sorry, that was an artifact from an earlier version of the patch that I
> > > failed to notice. I'll make sure to run everything through checkpatch
> > > going forward.
> > > 
> > >>> +
> > >>> +    asm volatile(__ex("vmsave")
> > >>> +             : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
> > >> I'm pretty sure this can be page_to_phys().
> > >>> +             : "memory");
> > >> I think we can defer this until we're actually planning on running the guest,
> > >> i.e. put this in svm_prepare_guest_switch().
> > > 
> > > One downside to that is that we'd need to do the VMSAVE on every
> > > iteration of vcpu_run(), as opposed to just once when we enter from
> > > userspace via KVM_RUN. It ends up being a similar situation to Andy's
> > > earlier suggestion of moving VMLOAD just after vmexit, but in that case
> > > we were able to remove an MSR write to MSR_GS_BASE, which cancelled out
> > > the overhead, but in this case I think it could only cost us extra.
> > 
> > If you want to micro-optimize, there is a trick you could play: use WRGSBASE if available.  If X86_FEATURE_GSBASE is available, you could use WRGSBASE to restore GSBASE and defer VMLOAD to vcpu_put().  This would need benchmarking on Zen 3 to see if it’s worthwhile.
> 
> I'll give this a try. The vmsave only seems to be 100-200 in and of itself so
> I'm not sure there's much to be gained, but would be good to know either
> way.

It looks like it does save us ~20-30 cycles vs. vmload, but maybe not
enough to justify the added complexity. Additionally, since we still
need to call vmload when we exit to userspace, it ends up being a bit
slower for this particular workload at least. So for now I'll plan on
sticking to vmload'ing after vmexit and moving that to the asm code
if there are no objections.

current v2 patch, sample 1
  ioctl entry: 1204722748832
  pre-run:     1204722749408 ( +576)
  post-run:    1204722750784 (+1376)
  ioctl exit:  1204722751360 ( +576)
  total cycles:         2528

current v2 patch, sample 2
  ioctl entry: 1204722754784
  pre-vmrun:   1204722755360 ( +576)
  post-vmrun:  1204722756720 (+1360)
  ioctl exit:  1204722757312 ( +592)
  total cycles          2528

wrgsbase, sample 1
  ioctl entry: 1346624880336
  pre-vmrun:   1346624880912 ( +576)
  post-vmrun:  1346624882256 (+1344)
  ioctl exit:  1346624882912 ( +656)
  total cycles          2576

wrgsbase, sample 2
  ioctl entry: 1346624886272
  pre-vmrun:   1346624886832 ( +560)
  post-vmrun:  1346624888176 (+1344)
  ioctl exit:  1346624888816 ( +640)
  total cycles:         2544

> 
> > 
> > 
