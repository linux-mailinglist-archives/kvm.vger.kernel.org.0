Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EAD388D85
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 14:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353333AbhESMIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 08:08:13 -0400
Received: from mail-mw2nam08on2044.outbound.protection.outlook.com ([40.107.101.44]:15617
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353329AbhESMIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 08:08:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6+ty8lV0YMmhCgnLEi+3O1CUy0lTPgqBRqO3zP89NbfFe5ixzhn6b/fBmKuNu3H7RVl520GOmxyUjsuinqQA2nei5Uz/BPva+gBudhET1BnzE7UMCqKajBDBNw4Gk89d2tEXYSdc9hFHQ5NARkjfqCBIfRByd1ioduAeA7Da2KH1SaLhA1ElPRNGsQCg8Vb8qlb1XABMyQTlc6LfGtAsW2f9EAWcEDkAmszuGsp8XpYGgQYiyrasOptMpOtImvWo1nhDPNz8Ait2Ez17Rk5THu4jQk953cLbVld0j0G1QhE/BNJW5isScdtY/jvilCOoTLoCwE/yjNJzlpQKiVrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZK9Hl2siVA/bUxqCDb9P9rB6wmqQ+9VoU9guY8aBzE=;
 b=NUzGNRDRC6bG9zYJ/wj+S9iBxbtmg+BnBYkPKGjEKvHpwbLGOkUBxPeVqcZAqe6+kclJwtorsXvKhSPaJ3IZMrELPNZOYkFIbXt4SdHMvtdE7cqLQviL/Q14CSV32FilWkpd4dD8EaTA4qFMZGHnenuDwwZst6Dew9C03B+j9uFrDyS+66nfSj7qhGw5cepMY/1+Fgupi/hjAZtv1yPHLwrvcUlOS3P9tx2rQZeKUJXIg/sYLz58hT8HPl5eG7sHZBCeCFTi1UG5CxAgocCXa1Nkr7C2DRvg5qvgAm4Wz1UOmoSsUmeX90eDT3XD1DcB3/m/AGO+uYt7jVMe4LzURQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZK9Hl2siVA/bUxqCDb9P9rB6wmqQ+9VoU9guY8aBzE=;
 b=TiuP0lYuC0+HEdRonTqJUNTzY2dvfeDIynVioao6c1qGWqUcMfOaWiFYnqBN6yWitx499unvOsLYWUoSU3jkDR0k0/49ltj+/rEnh68UMbBRAUtEbZ80zNVMURNEofNAn4GWiYLWLuI9vMKpfD4IMjLX1PLvb/9A26GFHm9lm/s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4525.namprd12.prod.outlook.com (2603:10b6:806:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Wed, 19 May
 2021 12:06:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 12:06:48 +0000
Date:   Wed, 19 May 2021 12:06:42 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210519120642.GA19235@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <20210514090523.GA21627@ashkalra_ubuntu_server>
 <YJ5EKPLA9WluUdFG@zn.tnic>
 <20210514100519.GA21705@ashkalra_ubuntu_server>
 <CABayD+e9NHytm5RA7MakRq5EqPJ+U11jWkEFpJKSqm0otBidaQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+e9NHytm5RA7MakRq5EqPJ+U11jWkEFpJKSqm0otBidaQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:806:23::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0076.namprd13.prod.outlook.com (2603:10b6:806:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Wed, 19 May 2021 12:06:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c804d271-7153-4f72-21ff-08d91abe9431
X-MS-TrafficTypeDiagnostic: SA0PR12MB4525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4525845AE3537A16BB9898008E2B9@SA0PR12MB4525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXxWNUYLOgLjw3xZCDhnwqs6UwG4ZgIu0TbJxOHKc01A2/RHvZozL/EPf5ZKPLzHrdipFThMlmrPJfsbgO0ybIluIBXwdF5FhK1qiKrbdYkPOwh36eSHTQeY6fkhL56MttFR80LA7HCXp7uiU8EedFvU33oliAuME++BeQ9dgI4gpCQd0ZRhaix6ED32dR1bFk6H0N+Ae6OuUAauwz5KD9vRZLC8Dve8BkjniuVByfE13QMv2LRhb7ovMsc4eRNFBWN9wP3FeI5FUxzgxxHYhPU+6pVqpIPrjEOruNzPXIn5O0oQRcs1q6EySdU7JzEaPxafORrz0NVSNKA05pjRkuHgsC8jEdtljnSCopwxGFjoBT+QO6y5/xKClQBYzQge1ssorkB2dABs56d0hctTbIooF8jVz2qur2B5AwU2SvLA9wsYV5GZI25aZFfQzAlgEW5rWed+hqapLaMs1ZM6/17pTJpamAV1XTV79RgZ0xuCw+RWfxr+t7ZbGAxPNhi65UA4ru1q0KqlK5IO/Z2vF26UpV5pV6L+hJy6ID87sVGgNT1XiXwisULZrvdIJIDHhLJw15QtZ5fmeCLZlx1c7O3p3fZq75UysO0MBCviGX5Hwse7Ds2g/m9DbBjx4wtlTR8xiQUiIOL0oUBfXMBibw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(6916009)(66556008)(66476007)(66946007)(38350700002)(38100700002)(1076003)(9686003)(2906002)(83380400001)(44832011)(6666004)(7416002)(26005)(186003)(956004)(8936002)(16526019)(52116002)(33716001)(478600001)(8676002)(86362001)(4326008)(316002)(53546011)(5660300002)(6496006)(33656002)(55016002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?++SOOJELOuYWfeiKkphtHyg4upBX+bkDh28BX7OUIXSgIIYokBhltmqilO7p?=
 =?us-ascii?Q?X5Z018Ti8DhB3FVnH/w/6DCqUMdcrZ3H/95MMUJR7XpLh37cYxCYvV7FcLTK?=
 =?us-ascii?Q?Eo/6sQcGCZ3NmPydIwJ3OY8V38Q59TCA+WW0VUxpIxA87V0r7T8kIRTQ/RVp?=
 =?us-ascii?Q?P3mfRttG4yCkQKOkm45Ot8Du9WJS1Vu54skgHnYOCJmCfrMOG+yGqHqbG60k?=
 =?us-ascii?Q?GmUIGdQz4hbQ4QGizvGyLf1q3VTX+CccHNkrhun+nJeRauckNrA9o2vUAdwz?=
 =?us-ascii?Q?Ekdetu/dvUZvJHxZ0P8ywZWT0wedJRGjyKkQLgeeAgYBYPDv5Wq7PUMsS79S?=
 =?us-ascii?Q?drkQT36Lm1XBCE/O2SYUZgcHzFMCd36MVG4oBj/yFr2UHDsyWSeNRmdSxmV4?=
 =?us-ascii?Q?6ehKedrKGksPTT6iLIe7BKlQrUZY7hPbVm3pgB0sYrZC8hIx2MG297zaJUXr?=
 =?us-ascii?Q?wHUq+AVuQdDkHdsYDucjEnWUbknKFOvkEzABGbEgtkmBTfneLN6zT3oYlYwG?=
 =?us-ascii?Q?FJ5b/J5TPl5A630LC9Yl9uW5U0OGEdWZJtDtZLa8osw67/EXpR8akHH+QZm5?=
 =?us-ascii?Q?qVsJVNJ46DyguCTiEu3O9C4aGM2A3Gmjejr5Wb6+r9Z3IKgk6Il9nuzAugbE?=
 =?us-ascii?Q?ozJQzb0Kvvvrf7jmwuKlNSS/4qq33GY6qQylAW/8sfisPVe7nvoYm8PH0X9b?=
 =?us-ascii?Q?MWxo4XRb3GP27BWx3Y8ISAHteDklO0riiK7LyZ7j9QwsMYlutvTYfk8a1DpP?=
 =?us-ascii?Q?zSkWhsPY8nwTNV23HCwXb0JAlePh+quEmLbgeiA7Pb/SnSyK/AgpY3kS2PX/?=
 =?us-ascii?Q?v5Nwq3xMgfAJUe7cJVARsRhy4UOhlX5DaljeRjT3tgv4TTGa3b/CYnxPcetp?=
 =?us-ascii?Q?3IVPQCti9vDstC14cCwHGGQL4zaEs4qSRSQLiQj3cj/nGUzzPMOU32nyt288?=
 =?us-ascii?Q?EYhZEFOm6GDuVur9nqO4OdJ/wDlsB/nXe9MyeF2cGu2F8FtqUgjrAIutTeRQ?=
 =?us-ascii?Q?FMRq2THdYGwYNgBTFENo9dJfhx4mk9oQN/cZYBiuHRTWusH825u81gCAoeNO?=
 =?us-ascii?Q?ilZUktnQlYPAZELVum1TsInRtvTYpDJwoitt0OypNRvSKwwxPz1l2U5sccrG?=
 =?us-ascii?Q?SO6mVk2cDDv3fUMxx3zRJtqS1y1tPuqtBhxYvbn9a1g+H6oIiRjfvnqpe75M?=
 =?us-ascii?Q?RFK8Nm4rDiQlt+ni3tmwOMWpL11uwtkDCPbm4+2i3oGZRPk/aSP2/I4ubLJ2?=
 =?us-ascii?Q?mq3E1jisk7NvxtP07zkW8VmfWB0DtRw1f2jfYteQHdHHh8Ujl3JlEm3zk5gd?=
 =?us-ascii?Q?XLYVmmefs6JAPOgc1ebkPt8T?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c804d271-7153-4f72-21ff-08d91abe9431
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 12:06:48.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3pCjAHDfnybGLYkfJAFd054lU5OZWPIxaCvOLDsm/pRluSOM882ceL3MKPrG6TWhrvH2XIAuJxUldBu5zOdXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4525
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 07:01:09PM -0700, Steve Rutherford wrote:
> On Fri, May 14, 2021 at 3:05 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >
> > On Fri, May 14, 2021 at 11:34:32AM +0200, Borislav Petkov wrote:
> > > On Fri, May 14, 2021 at 09:05:23AM +0000, Ashish Kalra wrote:
> > > > Ideally we should fail/stop migration even if a single guest page
> > > > encryption status cannot be notified and that should be the way to
> > > > proceed in this case, the guest kernel should notify the source
> > > > userspace VMM to block/stop migration in this case.
> > >
> > > Yap, and what I'm trying to point out here is that if the low level
> > > machinery fails for whatever reason and it cannot recover, we should
> > > propagate that error up the chain so that the user is aware as to why it
> > > failed.
> > >
> >
> > I totally agree.
> >
> > > WARN is a good first start but in some configurations those splats don't
> > > even get shown as people don't look at dmesg, etc.
> > >
> > > And I think it is very important to propagate those errors properly
> > > because there's a *lot* of moving parts involved in a guest migration
> > > and you have encrypted memory which makes debugging this probably even
> > > harder, etc, etc.
> > >
> > > I hope this makes more sense.
> > >
> > > > From a practical side, i do see Qemu's migrate_add_blocker() interface
> > > > but that looks to be a static interface and also i don't think it will
> > > > force stop an ongoing migration, is there an existing mechanism
> > > > to inform userspace VMM from kernel about blocking/stopping migration ?
> > >
> > > Hmm, so __set_memory_enc_dec() which calls
> > > notify_addr_enc_status_changed() is called by the guest, right, when it
> > > starts migrating.
> > >
> >
> > No, actually notify_addr_enc_status_changed() is called whenever a range
> > of memory is marked as encrypted or decrypted, so it has nothing to do
> > with migration as such.
> >
> > This is basically modifying the encryption attributes on the page tables
> > and correspondingly also making the hypercall to inform the hypervisor about
> > page status encryption changes. The hypervisor will use this information
> > during an ongoing or future migration, so this information is maintained
> > even though migration might never be initiated here.
> >
> > > Can an error value from it be propagated up the callchain so it can be
> > > turned into an error messsage for the guest owner to see?
> > >
> >
> > The error value cannot be propogated up the callchain directly
> > here, but one possibility is to leverage the hypercall and use Sean's
> > proposed hypercall interface to notify the host/hypervisor to block/stop
> > any future/ongoing migration.
> >
> > Or as from Paolo's response, writing 0 to MIGRATION_CONTROL MSR seems
> > more ideal.
> >
> > Thanks,
> > Ashish
> 
> How realistic is this type of failure? If you've gotten this deep, it
> seems like something has gone very wrong if the memory you are about
> to mark as shared (or encrypted) doesn't exist and isn't mapped. In
> particular, is the kernel going to page fault when it tries to
> reinitialize the page it's currently changing the c-bit of? From what
> I recall, most paths that do either set_memory_encrypted or
> set_memory_decrypted memset the region being toggled. Note: dma_pool
> doesn't immediately memset, but the VA it's providing to set_decrypted
> is freshly fetched from a recently allocated region (something has to
> have gone pretty wrong if this is invalid if I'm not mistaken. No one
> would think twice if you wrote to that freshly allocated page).
> 
> The reason I mention this is that SEV migration is going to be the
> least of your concerns if you are already on a one-way train towards a
> Kernel oops. I'm not certain I would go so far as to say this should
> BUG() instead (I think the page fault on access might be easier to
> debug a BUG here), but I'm pretty skeptical that the kernel is going
> to do too well if it doesn't know if its kernel VAs are valid.
> 
> If, despite the above, we expect to infrequently-but-not-never disable
> migration with no intention of reenabling it, we should signal it
> differently than we currently signal migration enablement. Currently,
> if you toggle migration from on to off there is an implication that
> you are about to reboot, and you are only ephemerally unable to
> migrate. Having permanent disablement be indistinguishable from a
> really long reboot is a recipe for a really sad long timeout in
> userspace.

Also looking at set_memory_encrypted and set_memory_decrypted usage
patterns, the persistent decrypted regions like the dma pool,
bss_decrypted, etc., will be setup at boot time. Later the unused
bss_decrypted section will be freed and set_memory_encrypted called on
the freed memory at end of kernel boot.

Most of the runtime set_memory_encrypted and set_memory_decrypted calls
will be on dynamically allocated dma buffers via dma_alloc_coherent()
and dma_free_coherent().

For example, A dma_alloc_coherent() request will allocate pages and then call
set_memory_decrypted() against them. When dma_free_coherent() is called,
set_memory_encrypted() is called against the pages about to be freed 
before they are actually freed.

Now these buffers have very short life and only used for immediate I/O
and then freed, so they may not be of major concern for SEV
migration ?

So disabling migration for failure of address lookup or mapping failures
on such pages will really be an overkill. 

Might be in favor of Steve's thoughts above of doing a BUG() here
instead.

Thanks,
Ashish
