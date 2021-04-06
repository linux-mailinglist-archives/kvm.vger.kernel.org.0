Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CFD3555E3
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 16:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344820AbhDFOAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 10:00:06 -0400
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:9185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233153AbhDFOAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 10:00:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CC+RXmX8yATcZrXRoV+so0hx/G2L2JanaaAizFCM1ydQXQ7xrSRFETalvexHK1LBujIoe3bzcXACMlg9Z7jDrvq6Dj/ceQ4UcADVFL8ODuFi3PxwHXFH+DrMR7SzZPI/XWaXLVkYB7i3zQhlTB4kkTxZ0Z3DFByqbvmIm4wLhVEq3/LJQyaZtlZabn1JEfqpuB6g521HgKWdTGrSmyuxCYFzxnngZ6QC7z+2PFVFeGllwkR0HpT8kTaYXuHGBWSlQUuL3kdbUzOgWx5rs09z6I/Dy6B50W2M6jbcKjcSH3KltfbIXnkWNYPh2vjAT1VAaodPJ6FmrClb91TSuy75YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTGudQDwJxcslDpKnI6NnJm6+4dcoG4nYfEPNr6+qAY=;
 b=TjIaYmeGAzATdw+K3wwk4bdACVVLp3RRIumhjruVn4sTHl5gfBUfEBGuEYb/oq5eHoW3kyH2V/vUZPuUXW5SL8T7Cr4fEWIcNY9uiJh0HVkH++zf+guEnyCs7yvTLn/pz0FFXg3yKtlOVQy3/9e3aJMnXckqs+7WwVU4RwTi6zSx3C0Nzr90gP9ap4rD22UKUZnxON5LsI6mRaU7FUe+mTLYGCytO/OpQ2Glx1qndIS42BSA+2ePZq+MrqT12pBvaAH0unz6E1fAKdL6A8K9oSPxgS7ThP2nUjRORFEgYdqKJOLgNyMsqa11LC+eZce6pnTu4QxvkMOzKa3TjDuTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTGudQDwJxcslDpKnI6NnJm6+4dcoG4nYfEPNr6+qAY=;
 b=MZ0hrlSkjBh1is2A1qK3Vl0OVqnuhQZtXuJY8tuQ0+Mn7gFcglfogBAcqtqp1HjIJ0OpxabdpF8oojnbrB5YShGLvWMrf3QNfl2yJ3rVa8YMUu3l924VZEvseXm/dsKbhd/K0BH4tJSY7GNfnlLx02+1h27vexIWAngZ+JvWbo4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2719.namprd12.prod.outlook.com (2603:10b6:805:6c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 13:59:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 13:59:56 +0000
Date:   Tue, 6 Apr 2021 13:59:50 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Steve Rutherford <srutherford@google.com>,
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
Subject: Re: [PATCH v11 10/13] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <20210406135950.GA23358@ashkalra_ubuntu_server>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <69dd6d5c4f467e6c8a0f4f1065f7f2a3d25f37f8.1617302792.git.ashish.kalra@amd.com>
 <CABayD+f3RhXUTnsGRYEnkiJ7Ncr0whqowqujvU+VJiSJx0xrtg@mail.gmail.com>
 <20210406132658.GA23267@ashkalra_ubuntu_server>
 <a59b2a76-dada-866d-ff2b-2d730b70d070@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a59b2a76-dada-866d-ff2b-2d730b70d070@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:806:d3::34) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0029.namprd11.prod.outlook.com (2603:10b6:806:d3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32 via Frontend Transport; Tue, 6 Apr 2021 13:59:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1505c07b-fa49-4ad0-818f-08d8f9044268
X-MS-TrafficTypeDiagnostic: SN6PR12MB2719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2719D24529FD92DAD7E66D5E8E769@SN6PR12MB2719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raOn8zT15DmBLbLlRf94Ls98aAl5vsLimpKOn5SJrZci+3fMr+R1ZLXuvKpd6WhaIlOYZoK4Ou+OW6aLswrex3Buht/2YNb/rex15Ky/liBG03BwNbZb9GAsgZUx/9y8W7Gprc7mVbYzob0m8NVs1MIUir7AKUp8xkmNKRpL2v24PsAMOylJvn9Y4wGrlrMbOImQUphwu/PFwMdG5/kgltcSf5Si22i8Y6zf+fuxCmcxYSUih1/9GR5NzkiF9KFNem2lgE9vNmdYLYNGFjMK7pWVwAGxhWAwM04pxLYy+OihhdsEpdHD/j0QHmLz1VIxqnxKUpalf4S82KDa6dlRnRHJonHsceZcrlhXOQ1bwtH5chnXlJVyH0kBB9WVXz1mbncKwmikz8vfUz1Nh0dTJc2zcNWeElvRPnOxKZPkPguoUvuSqJEbWGTGdWfkAv4dAtfByCWSuXFM2nxuSXUjOpQHpzG28ykR8pn9h8oEs0C00WKJoymaPOtV2nD/tdzCLejn2BvXwCgMKhCRGN+ojDpmQnZrer9GXKPZ0i3vJRU5ayIh68i4txjolZEtVH9I/AVUiXRieJtlJOOplZYZCfsq9NABP8piT2kC6+W5klYmm7/ozFRXsYfpoxC9bPWk15sOERdx55cXvpi/i1C8/0WNUNyGAJOtI1EBRjS61/LsNPUcFZylBDwwg/F3HnUm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(33716001)(54906003)(53546011)(8676002)(956004)(186003)(16526019)(478600001)(86362001)(316002)(6916009)(4326008)(33656002)(52116002)(26005)(38100700001)(8936002)(66556008)(66476007)(6666004)(6496006)(2906002)(7416002)(1076003)(5660300002)(66946007)(44832011)(9686003)(55016002)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+DXz0yVHOlm5kr6NmebgHoGquIfPP/6ZcNJjr7RtmzkcZeoOMDnipKmGJMKP?=
 =?us-ascii?Q?hcyhTbHKvRWwkT439vDmyjTjJWwgv1dbx7c6Vpi6z3TEqkFF/fE8RPf3EBVS?=
 =?us-ascii?Q?B3eVXEupbO60fPLnGld0Q0AFt+0KTGXXH/hARSEHYv0pNpop6VckCoVYZStv?=
 =?us-ascii?Q?GS9l9J3xtu0CpdT+S8PKc+idCo+pf0oNxCMuDwKmTgLrNxyHqGJt+RSsGco4?=
 =?us-ascii?Q?f7hu2QTTjMbowMB+FJ20mnj9Fg9UOl5T9Gm7a4OapDkwzswB8g4oQQlqE8Go?=
 =?us-ascii?Q?bxb0a6ZHBRLNLtNW5B1XUVWSLXIgq8rtwg0u6gVyi56rNxut3yAO7/fEavMW?=
 =?us-ascii?Q?i/8wgimF3m+JViZPLTyl3VThX8LLMJ5cjUlTj6p/GtZS+WJ29cOpmpm5Is/Q?=
 =?us-ascii?Q?EWuGEOkdx3rbY9ByWHncKxCdG5btT29qlhBvuwEFgIEt8TSfGwr6jA9CxPz6?=
 =?us-ascii?Q?TuZGARzB9n9f03ABaWLZTQuSGoRM+HtKHvBtKEzECS5L+RBV98t9bl2tChDq?=
 =?us-ascii?Q?5+upPLhRya33mTJlALJcKmGZK7k+wcholepjpZ0trN3n1DLHPrcds11m7qQV?=
 =?us-ascii?Q?u/AFUhYVG1tisNO4dO9g0G7oc+iXusLSQVa0JUeFCT9WQz2CV25252RcdACk?=
 =?us-ascii?Q?T4/lHFIjEuCVc9RskTnFK/jipSPzclj9cUF2TcHja4fts1Ur6s0CKF4tQHNf?=
 =?us-ascii?Q?OyDrPOvnWF1BrpVakmgiKH6GlIXEnwM989HEy0M7P9ZSlcVOl9hG59JpXR1k?=
 =?us-ascii?Q?+ldf5wfi2eD3Yfd8vmIHSEuaGCJfVdrPV4JiK21qhphS0D7uMbUGH65qC5OJ?=
 =?us-ascii?Q?QlDEH3QhcG3zcg964t+N8ISFkJ6+rYuYrQJ6+OscBZWQtW91Vr4hm9DKKQDY?=
 =?us-ascii?Q?ZOyNTfFHm3//SUulLvb+fyjviHBNv/Tn0hXU53VEGwdelcZtIez4TDWyvo4f?=
 =?us-ascii?Q?D3o07hPu8zIRJjwatoii3aJcvwBiP3YVQP25kAOjJalMBvKqOfhlxHKmiBBR?=
 =?us-ascii?Q?VurbKRMJ8O23FPF2nedxVwoq8xHq9ed0frt5oabWMLCWH+7SKckBL9BPUqZv?=
 =?us-ascii?Q?nBqx52w9SjJ/p4lozNOyPDL49Y71OAMovUB9GLO3uGXUB6xYxZjnA0Vukgrl?=
 =?us-ascii?Q?XSeeoDXxHwhRZlQDw8tgl+8BmsmEEtwvSybzIdLieMZNC3xBOdGkmUeIjHxR?=
 =?us-ascii?Q?3N5+uDr6421Zp9pf0w9C7IJtSs3+OxftSY/sU9Ci+8KTZB2KkPk5tHZtrNu+?=
 =?us-ascii?Q?bPV26+p3C7UYtJYdAWl1Jd4nukazklquhgbL3moNFpqOsCK23r+ANvG2S5q9?=
 =?us-ascii?Q?JsILpEXg3KirTrPJuouAc4Ow?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1505c07b-fa49-4ad0-818f-08d8f9044268
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 13:59:56.3195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVAoL4e2Hnhckc3d2mru52HGMVKiDLyvWoFqL4eTYASEckctXGvOlmP+ZWadg0m1hamB2YFMHv5v+eFqePEd9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2719
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Tue, Apr 06, 2021 at 03:47:59PM +0200, Paolo Bonzini wrote:
> On 06/04/21 15:26, Ashish Kalra wrote:
> > > It's a little unintuitive to see KVM_MSR_RET_FILTERED here, since
> > > userspace can make this happen on its own without having an entry in
> > > this switch statement (by setting it in the msr filter bitmaps). When
> > > using MSR filters, I would only expect to get MSR filter exits for
> > > MSRs I specifically asked for.
> > > 
> > > Not a huge deal, just a little unintuitive. I'm not sure other options
> > > are much better (you could put KVM_MSR_RET_INVALID, or you could just
> > > not have these entries in svm_{get,set}_msr).
> > > 
> > Actually KVM_MSR_RET_FILTERED seems more logical to use, especially in
> > comparison with KVM_MSR_RET_INVALID.
> > 
> > Also, hooking this msr in svm_{get,set}_msr allows some in-kernel error
> > pre-processsing before doing the pass-through to userspace.
> 
> I agree that it should be up to userspace to set up the filter since we now
> have that functionality.
> 

The userspace is still setting up the filter and handling this MSR, it
is only some basic error pre-processing being done in-kernel here.

Thanks,
Ashish

> Let me read the whole threads for the past versions to see what the
> objections were...
> 
> Paolo
> 
