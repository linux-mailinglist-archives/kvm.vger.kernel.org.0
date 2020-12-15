Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA522DB418
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbgLOS4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:56:52 -0500
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:50489
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729637AbgLOS4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:56:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHebwUki7kMdzgNd2IXXlH79BNbB0BYg7/s+P6p0OpxCdwFoQvaoSw8sYM2dc1gsk9ZbVpTHR+1FXIYnO2iU6QjpIJKujlk48IH9TZWGuJhqsN+utCx4/r7cHlNZO9Qt5LgFcc9sm0jc7qUoGJpDZWpwPpOtlY6Ape8HhHY8YB0AgZeoSj4VIvFkapvEwtr9+iVv8fOt3CmC02hrqNXWYmxpusOoydfW4wuHH+rsVqXdarprfIF4haYc7ZSBHHXM3tCFi6jk3U83J5LqxSOQcAntwFZycqxcBE11CeX/uVzXLiI6uZdx57bcl07KMd3MJ2np3C9e92/Bpsj749wAEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMLGgthh7HN7tFjdMr5bWV/Xkobx61iNH2mygTOMjew=;
 b=PQ91IMVy5FvN8rujRSH9zeo/2qPbI/fLRQb4nZ8Sy3BpJ2bqMHo9Y/tdhEShLv8WQ+tRy6Pj2Ty3/f3k5P+i/kCkc+KfaF5TZwzFmi78f0SoyCH1HZ5gWo7/EUs5FwaJm0aqgRM1NpuIqdS0YmpKe8eMpuyeAIjndKnYLEsmrR/RosjB0vYGqW0k27G+ymM4XVe0AJarBY7SokLhGQ8njSlu/jhbivvEjcXVDRaFRH8G+XfS1rMRqYq0ZuHATTSte9Q0NIED79lGuPsBU0tEpVJJf3ZctCFnK5nC/lNzcDU1Qdgw73Z4D6ubqaysVmA3lqnQESsOzRslN9GvWZvxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMLGgthh7HN7tFjdMr5bWV/Xkobx61iNH2mygTOMjew=;
 b=UnXhBVJ63mjleaj/RnGLbaTYlZ3FBR0X2NSgvq+c2NrXh4KCf+1bhKpv4nTjWtI+OgSYQ+j7//WqyFnhJDLpEzf9G5uqzWUpf1Zmo8h0t4lLuQI0gjtPKvqzvdfkRMt8CeFhEW1KCq7KROO59PppvghUTOXIaoxb5befREk8Xlg=
Authentication-Results: amacapital.net; dkim=none (message not signed)
 header.d=none;amacapital.net; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Tue, 15 Dec
 2020 18:55:50 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%6]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 18:55:49 +0000
Date:   Tue, 15 Dec 2020 12:17:47 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <20201215181747.jhozec5gpa4ud5qt@amd.com>
References: <20201214220213.np7ytcxmm6xcyllm@amd.com>
 <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
X-Originating-IP: [165.204.11.250]
X-ClientProxiedBy: BL1PR13CA0275.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::10) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.11.250) by BL1PR13CA0275.namprd13.prod.outlook.com (2603:10b6:208:2bc::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Tue, 15 Dec 2020 18:55:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 55afd86a-445b-4481-4a8c-08d8a12b0a1e
X-MS-TrafficTypeDiagnostic: CH2PR12MB4326:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB43261838C5D6FE4E37035D2395C60@CH2PR12MB4326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jnNsIL8Mr96c5MUgu14xLwOWfdJejTz0SZH4DVxs6vI4O7LfS4qGLg92CARSFjjqH1LPySlQYd1KGJDlXAm2vYy5g1o2LhHplJyxLUtJcLrAfjo7dDHeaIxMMoNotR99N8jG1annWBdXmj5561Exj4QMbO06pmrfa/GndxkwkkUsU1CTgkWipbG1kMH7WVUqU2zwRSvdLj4hVBWvDw9xFvTBHK7y4klZpo7NkYeCFbAsiPC5Y2gR4zJWHXYle5aWVVO45AqdNr/zPGOasTUyFGtM9Ynz/oF0ddfLJ++J6FBKH8shesx+DxwR0qBW7EaonNa0OTfTiaJhiEKOh14tp9y7Mt0/BcAkTULlkQ11ybAKKXaKZi9FVaCCIjZRySm3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(6916009)(6496006)(66476007)(508600001)(6486002)(36756003)(5660300002)(66946007)(7416002)(66556008)(54906003)(8676002)(4326008)(34490700003)(52116002)(186003)(26005)(44832011)(956004)(2616005)(2906002)(83380400001)(53546011)(86362001)(16526019)(8936002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THRaU0FYS3NYZ1FWbm5YaFpKVXRuTlFPREFpY1JVYXYzYy91NVJyeE5icnRm?=
 =?utf-8?B?NTNaS0d6MTQ1MjBBUnhZNDVzeW9LYVZmcDBaSXJrNDViR2VWOHpGNzV1dWth?=
 =?utf-8?B?VmoxVzlSYkY5Y2Q1aUpCTWFndkJTMks5YU1MbG54SFJmTlRTS0U4S1Vlc1N2?=
 =?utf-8?B?TFh6STljUEJ6eUkvQ29tdzExVnNsdFlDQTlrM1lJcFlzdlNqM0JTdGxCTzhH?=
 =?utf-8?B?R28yYVFGdE9Wc2lUdVVaMkFZWmhNVmtEYTY2R2tlL0xvbDBSN3BrN0J0bzl6?=
 =?utf-8?B?NUx6VSs2Vm5aNVhORHc0ZC84V3BDd0t1bW9FM1pSOCtwbi9XZ0JxWCtUZmdH?=
 =?utf-8?B?L01pOGlGTmlRcE55Y3NOSzBkSmZFODE3cFlpNUwwcnVtMmFZQmRpd29oRFpR?=
 =?utf-8?B?bktXK3JOT3BZbThzZVNieEJwYWlRREhXNVBEUUV6OFl1M3FJa3ZYY1NIQTU4?=
 =?utf-8?B?cC82M09vL0xnQjRvUTRzWHcxMUV1cEt5VG8yaDhOelhXUnNqZTdwNmRkdlpn?=
 =?utf-8?B?Y3pabnhBN1B6ajR0RDF5Tkl5MEY1b1FJVGpnNUhhanZ2MHNOV3RFSzFQR1dC?=
 =?utf-8?B?dHpxNzVWKzl3Nmhpd3ZWeTNtV1FTdW9uUFprRWc0UUF6eGw1QWRUVmxHamg3?=
 =?utf-8?B?ekp1dU1pZThneDJhN1ZpRE1BYlZ4NWRSTVBBQisrNTg4Skc0SlFGUDdhbE9I?=
 =?utf-8?B?NGRLWEZSbEVZSzVkNzlUd3I3aVhsS1hlRUh3RVI2czRrWktQV1QxRUNpMHlC?=
 =?utf-8?B?YjFNYVhEeVdWNkV4LzVPUEdNb0J5aG4xOEFrRnlZVlRlWWRpTkRaczhTUWxo?=
 =?utf-8?B?OStJVHpsOGpqM2N5ZkRoYU10T2VId25MWHFUWUJ4SkRXWHZYRGxldjIxTitm?=
 =?utf-8?B?cDB5QTdodTczOG4zSXQ5QnpVYWtxSzJnWjBydmlmZnNIZGE5SUI4QUtwSEw5?=
 =?utf-8?B?cmxwVWptendXak9ZbjQ0cElXcTN3LzFWdXBTL2FmYUszcHd1czJxK055ekFU?=
 =?utf-8?B?bGl3VFFiRFMzbnlERWpBRWI2cWFQL1dsQ01ka3BPNjhHVU5BUnZva0RMci9S?=
 =?utf-8?B?TGxOTEFZUWxvZzA0UVJ6d05xREpBTlpkWkNpVS9Cc1pWSjRiN0xlRlY3aFFs?=
 =?utf-8?B?anlpNlNTTmdqMzFtS0hueW1NN2dOaS9HNk91NE1MczNPVnB5YnBNRmVhU1BU?=
 =?utf-8?B?TnIvN3JMajI1cWZPWnZkbEhHZUpUdHB3SVlDUnZmQWNZOFAvYzRoOU1wRjRD?=
 =?utf-8?B?SzVrMzRxTmJ0ZXpBYnh1TForZFl2cmtadkxEWk5GMjQ2L3hvSHpydkZMWThE?=
 =?utf-8?Q?OShceqfov5n/tjG8s563YcEaVdycHKDdq4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 18:55:49.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 55afd86a-445b-4481-4a8c-08d8a12b0a1e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xZ0OZpF7RfyamnUpMViS7mSeq+eFjMLQImHRK9Qc7Wpoea9qjYPhRsfF1Senl6xH7gsxTVxeIBNUGc+KhoVZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 14, 2020 at 02:29:46PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Dec 14, 2020, at 2:02 PM, Michael Roth <michael.roth@amd.com> wrote:
> > 
> > ﻿On Mon, Dec 14, 2020 at 11:38:23AM -0800, Sean Christopherson wrote:
> >> +Andy, who provided a lot of feedback on v1.
> >> On Mon, Dec 14, 2020, Michael Roth wrote:
> >> Cc: Andy Lutomirski <luto@kernel.org>
> >>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> >>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> >>> ---
> >>> v2:
> >>> * rebase on latest kvm/next
> >>> * move VMLOAD to just after vmexit so we can use it to handle all FS/GS
> >>> host state restoration and rather than relying on loadsegment() and
> >>> explicit write to MSR_GS_BASE (Andy)
> >>> * drop 'host' field from struct vcpu_svm since it is no longer needed
> >>> for storing FS/GS/LDT state (Andy)
> >>> ---
> >>> arch/x86/kvm/svm/svm.c | 44 ++++++++++++++++--------------------------
> >>> arch/x86/kvm/svm/svm.h | 14 +++-----------
> >>> 2 files changed, 20 insertions(+), 38 deletions(-)
> >>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >>> index 0e52fac4f5ae..fb15b7bd461f 100644
> >>> --- a/arch/x86/kvm/svm/svm.c
> >>> +++ b/arch/x86/kvm/svm/svm.c
> >>> @@ -1367,15 +1367,19 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >>>       vmcb_mark_all_dirty(svm->vmcb);
> >>>   }
> >>> -#ifdef CONFIG_X86_64
> >>> -    rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
> >>> -#endif
> >>> -    savesegment(fs, svm->host.fs);
> >>> -    savesegment(gs, svm->host.gs);
> >>> -    svm->host.ldt = kvm_read_ldt();
> >>> -
> >>> -    for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> >>> +    for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> >>>       rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> >>> +    }
> > 
> > Hi Sean,
> > 
> > Hopefully I've got my email situation sorted out now...
> > 
> >> Unnecessary change that violates preferred coding style.  Checkpatch explicitly
> >> complains about this.
> >> WARNING: braces {} are not necessary for single statement blocks
> >> #132: FILE: arch/x86/kvm/svm/svm.c:1370:
> >> +    for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> >>       rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> >> +
> > 
> > Sorry, that was an artifact from an earlier version of the patch that I
> > failed to notice. I'll make sure to run everything through checkpatch
> > going forward.
> > 
> >>> +
> >>> +    asm volatile(__ex("vmsave")
> >>> +             : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
> >> I'm pretty sure this can be page_to_phys().
> >>> +             : "memory");
> >> I think we can defer this until we're actually planning on running the guest,
> >> i.e. put this in svm_prepare_guest_switch().
> > 
> > One downside to that is that we'd need to do the VMSAVE on every
> > iteration of vcpu_run(), as opposed to just once when we enter from
> > userspace via KVM_RUN. It ends up being a similar situation to Andy's
> > earlier suggestion of moving VMLOAD just after vmexit, but in that case
> > we were able to remove an MSR write to MSR_GS_BASE, which cancelled out
> > the overhead, but in this case I think it could only cost us extra.
> 
> If you want to micro-optimize, there is a trick you could play: use WRGSBASE if available.  If X86_FEATURE_GSBASE is available, you could use WRGSBASE to restore GSBASE and defer VMLOAD to vcpu_put().  This would need benchmarking on Zen 3 to see if it’s worthwhile.

I'll give this a try. The vmsave only seems to be 100-200 in and of itself so
I'm not sure there's much to be gained, but would be good to know either
way.

> 
> 
