Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B26F2ED6D5
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbhAGSm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:42:26 -0500
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:63521
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbhAGSmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 13:42:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQbZXy9ty0SIYfLmMongobqDlF223sbiSrFrVBl9YoVaoUHzUSbUYp1oiwCkttjHlmryL2009+gsvFfC5FRTi2TJL4J9WGwkYxwl2w7kjJ3SpOE2OKpaeZkyHMCqaKdsVldF6Y9akkqqWXfrGuzhELwH/u5QM7W0JsjZRcVhE5kG7Voew1CMarcp6asFCpUfU8jK0ZxOZthFDNz/uGpPqRoqAWMbonbMdRV+BuAJPB/b42xvSgq5q2KCXs40EXoy4/fRBKBZmoaYPWVOCjIiY/j8uFldDf2x6FkS/cp5l9qDwJkJIxzTb3lkIq7gXsUtHFkLS8PivgtiLGWq1WauRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwwFcGDm7ZhPqDs0YrIYY0rbCMEI0s2L1kdjlXWQ24I=;
 b=e82BAf2DeTnl09QLJHNulCybcdK4ePg4Sx+GnrCMH68a3geSFHcee7tfp+9CTuf8DoO97Ggdw/NV7JyKVNmPd9a1/pdqhv57HwlwovjUu/N7uU6JSxZ99jU6DcMUCTBI8NkPCAwNy4XqlRPBbL+oWfJWDaxKIRoLRM08ZO2GvVXc7mjSsd4rCkxwPXDTuDvbuW7EfX7Z+4xTJAZJRQFSOs0HG6L+zJr46+MMPblOWWDbs9icVN5sN3z3VtH5R42+LyYA7UpqRD1inGkTJKErA5GrEh3kL0JWKA81ke4Y6aGLrzUYmR3B1DGO+Q+7InzliMCuNicqxTBICXEsUYAzQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwwFcGDm7ZhPqDs0YrIYY0rbCMEI0s2L1kdjlXWQ24I=;
 b=YjjcUQmRDPklgpC2aWXIwniCBXfug+ZJqCtuVj96waSA7HhIsNxB8mPLafgLTPdByB+y437RAmGOJ7lUhJcHTB/3yDghb51pwowsHKSMe2smNbmVZzvievJ1oiWqaohBxHs7wyJZlseRboJwiEvtdcrlhCkeSfm+AAvcGM1yT9A=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 18:41:32 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726%6]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 18:41:31 +0000
Date:   Thu, 7 Jan 2021 18:41:25 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dovmurik@linux.vnet.ibm.com" <dovmurik@linux.vnet.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "frankeh@us.ibm.com" <frankeh@us.ibm.com>, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <20210107184125.GA17388@ashkalra_ubuntu_server>
References: <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
 <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
 <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
 <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107170728.GA16965@ashkalra_ubuntu_server>
 <X/dEQRZpSb+oQloX@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/dEQRZpSb+oQloX@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:805:de::30) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN6PR05CA0017.namprd05.prod.outlook.com (2603:10b6:805:de::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.3 via Frontend Transport; Thu, 7 Jan 2021 18:41:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6515e4d-d948-49ce-e0f0-08d8b33bda4a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2446BAE4A6ED84C9A9F21F518EAF0@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OaiP5S5XcEpd89lGOTrCZqvZBValW2kRR7gf04TtRB2/qmbm3hgA5geJ9s+SSzI5ZxOaS9gHJjBTfvfBmSWswoalIOWY4Ls4kfxEz4a7jYM1xr7FQQrZtK7MnAhO0nHEsaNiVnv3D4B3ZoQw9WyetlTH77f3H85H4nFbQEkBVo2+YXvCFYlBS/prP6gnaWrpclcJmUDnPdKN+si0If02+HN6Pd662s4pEaT4kHIRb6HaqTkhKZiviqPKY3Z61VVqD3jAzR37+QzGo79DgaetAoRQB+LW6F7fxANS7bnDrRzLVLCRD85aXx1u/vadn0aDYRv7iw5ZJ+bRiA2pvTLkuxH+n0bdBdX7pONFavMHeLi6H+vk/Eb7jA+W8UnUNsoR7/kJJGt9DAQTFrdjA0i7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(66556008)(66476007)(66946007)(956004)(33656002)(186003)(26005)(16526019)(5660300002)(44832011)(1076003)(8676002)(4326008)(316002)(54906003)(33716001)(52116002)(6916009)(6496006)(8936002)(86362001)(55016002)(7416002)(6666004)(9686003)(83380400001)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dTxvlDpC/Vx1Qg2Zt6/zUidcW31sc6IHVkLRRWofHODF1Z0aDYcovmvjKDeu?=
 =?us-ascii?Q?HVtx8UGqTxO9hMq0KfzOa+2s/QvQpm1WktVk/3cWSFIeAS0aR9qdUfLTtDem?=
 =?us-ascii?Q?sge0G7TJ2iCzA/fvhr4N/Uy9u8+5yZ8sP7U9S/tYBreFhadR+Ky7cq2uNFcW?=
 =?us-ascii?Q?jFrhsyZzHr5NocVDslV4L36Peuerm9xrSwppFOxWjOJsJ4yk1OCauLLZcTwj?=
 =?us-ascii?Q?XgjBLt/TVsl/tE6ISS0p9zhTdp+5k9fKzN+kdjBLjBrBFX+/wf3mUv+Pc+zo?=
 =?us-ascii?Q?3M9z91WpftTIVSkvfDZG5o/rW6kqgYzKylZjbdLia9a79f+Wfk6WH1syeGzf?=
 =?us-ascii?Q?AGAP1tyJFxynF7fBJSZpwCBWVTqB/MluKNF29PkmFWN538mszl3/tRd5Zb6+?=
 =?us-ascii?Q?ECoqEbLfdSxq5a+3NXnvbvACxrHwDnr8pGKnsrEZsXo/KjLF/gLO4frDO93G?=
 =?us-ascii?Q?/nXWgwrzjEbJP2Ctf8CoeKPuKeqBw0u/Yvg4B8xAM24dowMYiKxTh2DH6IOb?=
 =?us-ascii?Q?whaYV20C8RO8VV/vU2UMB30UOS23xCW9ypoUMRS9kbkw3f4WvecYxohN8bL2?=
 =?us-ascii?Q?LQMeYObTMFSIhUV4LQgX7dY74Fza5xfayTpEgTgvmS8n8wOoyfs0y9zcLMwS?=
 =?us-ascii?Q?UBViKnSzxCFcHynUdT8xAfqU+/EG7IMgvhtnCphXUNxfq2YlRN3rRC4M8B3Q?=
 =?us-ascii?Q?Lo3eZLmZVE9NRZuR54OD1aHLVE0zhSj3qiaxic7RVXsxKbsgd7xZrQMbgX5i?=
 =?us-ascii?Q?uWdNosXWtnxMqpJxskrfN5M1zjMnQhGIijJ5KMLdEj26t/bHoNz0MucGO5VU?=
 =?us-ascii?Q?EpsUYxxQ3KAMsevHCJxe59J4ay9/uuAQEnV81DwhpRn+sk9pVUUxpsBtQznx?=
 =?us-ascii?Q?LZFnk9OKehkT6wAndqWthfZ4wQ4fYAinLYk7Eg1VqDV0jw5M5Zdphaqq1Fy5?=
 =?us-ascii?Q?mH6ZT1O/n9NAciE5knb7ekEp81vG0wg6yFzgLH+IQR0=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 18:41:31.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: a6515e4d-d948-49ce-e0f0-08d8b33bda4a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWKxAQJDnBub0RALQrjD/yvJkcQ4ywUct9SN7ZgbQk8GYN3HtXc5E1wat507LhMr4q+fjP8aeFERZw7zCDXtiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021 at 09:26:25AM -0800, Sean Christopherson wrote:
> On Thu, Jan 07, 2021, Ashish Kalra wrote:
> > Hello Steve,
> > 
> > On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> > > Avoiding an rbtree for such a small (but unstable) list seems correct.
> > > 
> > > For the unencrypted region list strategy, the only questions that I
> > > have are fairly secondary.
> > > - How should the kernel upper bound the size of the list in the face
> > > of malicious guests, but still support large guests? (Something
> > > similar to the size provided in the bitmap API would work).
> > 
> > I am thinking of another scenario, where a malicious guest can make
> > infinite/repetetive hypercalls and DOS attack the host. 
> > 
> > But probably this is a more generic issue, this can be done by any guest
> > and under any hypervisor, i don't know what kind of mitigations exist
> > for such a scenario ?
> > 
> > Potentially, the guest memory donation model can handle such an attack,
> > because in this model, the hypervisor will expect only one hypercall,
> > any repetetive hypercalls can make the hypervisor disable the guest ?
> 
> KVM doesn't need to explicitly bound its tracking structures, it just needs to
> use GFP_KERNEL_ACCOUNT when allocating kernel memory for the structures so that
> the memory will be accounted to the task/process/VM.  Shadow MMU pages are the
> only exception that comes to mind; they're still accounted properly, but KVM
> also explicitly limits them for a variety of reasons.
> 
> The size of the list will naturally be bounded by the size of the guest; and
> assuming KVM proactively merges adjancent regions, that upper bound is probably
> reasonably low compared to other allocations, e.g. the aforementioned MMU pages.
> 
> And, using a list means a malicious guest will get automatically throttled as
> the latency of walking the list (to merge/delete existing entries) will increase
> with the size of the list.

Just to add here, potentially there won't be any proactive
merging/deletion of existing entries, as the only static entries will be
initial guest MMIO regions, which are contigious guest PA ranges but not
necessarily adjacent. 

After that, as discussed before, almost all entries will be due to 
DMA I/O with respect to dma_alloc_coherent/dma_free_coherent, and all
these entries will be temporary as these DMA buffers are marked
un-encrypted and immediately marked encrypted as soon as DMA I/O is
completed, so it makes no sense to do merging of temporary entries
that will be deleted from the list immediately after being added to it.

Thanks,
Ashish
