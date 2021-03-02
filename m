Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B78632A795
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839355AbhCBQRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:17:25 -0500
Received: from mail-eopbgr680056.outbound.protection.outlook.com ([40.107.68.56]:50243
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1578439AbhCBPQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 10:16:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tvf+3AxIvptx4MucC5IY67XUtnK2mEPIRYzbi7aPOgPZaA3EopXSuwT/wja8FzOT8Y7Pi4u9GruT0LK2BSDUgfVpRIFSHNc0wkjOqEOxa0J94FYgY0lIVfZBVQUqpPcNW5hxiqmpLBEJaB0NJThzMI+vob7KxwImHbBzXQ8UrfUyLzOjmA3QOWtIRET1YoJI9IFCZgT0eBA6CiwBP4WgLExczXHR0/ex1pWMksflyEq9KiKQRr3yYS1JymvRGTkDEixJ2fkupDyJXu3yHkKJEVgciG/W5/urMWWfuKNUQdvu9LJJSzsqOk+m6C4magyE4bRKksTPBX83TCvKfcRb6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnszKSukUfkgo/hk2aQ5K5ZgWsdJRO0wAhhPq9eWX8I=;
 b=QKiQ9an5Sb9YgqvgX/M6EsBrMTAXPrRSbaQEXlrixE7wH0SXy5K4MwzDlHggcTv+LBVSRRpqQ+S8uWUYuyQUkRTO3oZSnBgSxtXTQQXD+oQlSpodTWSS9YfXXPHkeJl8F9yDazwBJMHypJL0+4ALiuiVFn7/mFlfduI0eb8mppLvwB0ShUtvsBqkvTBRMUJRsllJgV53xmyQSCs5FNeFSE6evd6aMRJMtTJK5UjudiB2AkpwnvowDAlqXmzOsM93akSS3zNTaX+Yijg556jLRRQ3VMkzPLVZM3xQJjSVrzPaKIad+HcFgaSnnzIUYpa4VHushViIfWSAemWadLLmXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnszKSukUfkgo/hk2aQ5K5ZgWsdJRO0wAhhPq9eWX8I=;
 b=2tjikd47wgpbnYRVBU9TRz7KJL6r+pVy7B1DvqfT7d0Tkyoq2qy+UB1CrH7RyxJxgyLDOQY7Oo6GGyt1aeK/YKfBEZKepAlpZJ7TbVJksggsqAKkqNOLFO5UUv2xv9Maym69uFpsaGAgU4+FX7tBII37ob3vq7Ig1iyWmEUv1wA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 2 Mar
 2021 14:55:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 14:55:49 +0000
Date:   Tue, 2 Mar 2021 14:55:43 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210302145543.GA29994@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDkzibkC7tAYbfFQ@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:805:66::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN6PR08CA0005.namprd08.prod.outlook.com (2603:10b6:805:66::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 2 Mar 2021 14:55:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ba907ea-e773-4eec-c5a5-08d8dd8b4465
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2415060F1E0BFA1D12BD5F0D8E999@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWA0dJGEDya4bEx6zW+Tx3oP/CkMV90B5W2Nij1EaZh/1OmHcBLjNPfzq6geTiTs7aqV2vE8c1ohFCIRmAFdHUhQjHIzVJSbdWIxk6MP1bmVeG6YFqV5EeyuYLdFBC0AbyTV6TVnD9vZwouJuKC5K5Sq3T567KSx+gQ1fN+0VTGEN3F/W4tVYJsb5+F7tpeMeonpu8/r8w/Ru2uMABio77ZEu7kbR4TYwQBhEhqvTZMhaWeN+EG7DinqAcEIjo/5WSFgaKAYOKKZepIOmmHUiLA9eFVc300fwMHRwW7A1KlLnThTUaP14zAZuxFmmYbh1xXaOXWNomOiMekZQC211gJuYnPWTDDiJ1fGy6tXfxqn4t4Gbs43vpgIkpHGbW7ZUEvpu1gIfnfmBx0xH4tgu//tNb0Rw8yfe7/5iFgsugGE+Z/VmdGscE3h5zH9EcmWMuoRvwB9svUHkRp13+JydYuGoG6B6OeVyU0aJ9UZyOSglFaWZtt5juYAGC2PPXLppEMVXqEJgLxVpfzCMEwwlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(5660300002)(66946007)(66556008)(66476007)(6496006)(83380400001)(956004)(478600001)(4326008)(44832011)(33656002)(2906002)(186003)(16526019)(316002)(52116002)(8936002)(26005)(53546011)(86362001)(8676002)(9686003)(6916009)(1076003)(6666004)(55016002)(33716001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uPFsna+wNDZ/yaloIozUUElLnX8pBIq9Ez5DWpT1yVLXzn5eqZ3ZUf7YyidX?=
 =?us-ascii?Q?JTrB8GdfSZhBjH3qSiA5rkj9Egv+KimEuKdyq6aj4tlyrHNuiwTSnU0LcTx/?=
 =?us-ascii?Q?Or5CQA4MHWKCM7I0Llm0QITPKtD0KptzolFnhFBFcDi3/wdIlkrDq+mw5RpD?=
 =?us-ascii?Q?LZsiADGe8QnF2TSNGpS9QP5LWndy8dh73SPsianPCulKHQPGTOgvhzk5ZsrZ?=
 =?us-ascii?Q?bBpQBPossr/QK0xw/vFdhCzARRYBiWjrJ7o39Gw5wM5aRR1IN3HMlEWtVbBV?=
 =?us-ascii?Q?1Z2BHhiEDeYn+maMyV4h0srKC9fqelCdMx1Mkpe4UR8xidAU3wREqlYuIyJT?=
 =?us-ascii?Q?bpRBw+EJxoWZ5tIG2fuI6egoMoxcOwxUCAUpdyCMP8k1gbL8KdB2jsVKQhc1?=
 =?us-ascii?Q?KaAEZ66YJP4UGoPQ0+FZixmaGN7lYYE5BUqvQtLDyP6Pq9EQdb0TJYIaWeXh?=
 =?us-ascii?Q?jYAm1W+Eojx2HR+4NcOCDRfP647HjqfOoFdDDenfy3vmfYnTAHjBDr0CxOai?=
 =?us-ascii?Q?ke0mIpIhthYBp3WSy4klCl5cupuVt4bEIA3MPyQw1Y/8FWmxg+HNWBxkZ/2+?=
 =?us-ascii?Q?z2hsVeKrfLhrPHIDkjdDrnBVl5GbiHboPInWkqAdFBmtLFNJisV2Lb6haVvR?=
 =?us-ascii?Q?lgOW9BUz0dREerQ0cNcx29+7ChcchdH9FkMo2KqEO+1J4oRB79PgJKpN36Dl?=
 =?us-ascii?Q?rUTxbSbqm4bI4K1NZCpuYrzxCRVRVCxKwV7beiDEstrX/Q4P31pY59v5TkVr?=
 =?us-ascii?Q?ZLhTXQzHkdCKiSTOBW82ig9YAchb8ZQTv/4eM3px47kbX7ADQ6uZJeUwM15G?=
 =?us-ascii?Q?1jy5Fa3TIHkfOJkXcBPyeGSOVkzzvYoGy9/7oUCk/VRuVv4W6vyT0S8KpJQq?=
 =?us-ascii?Q?IJELtXp9hD6LmH2LJj9FaRTRLDcr7/eikaUyuAglyU2L7SeM+QU336csa38f?=
 =?us-ascii?Q?ZsOWPV67zwmHxooxgVoX/ks/KxswpSj912PUeMjiG8q+OPud1D2F7E58MYyZ?=
 =?us-ascii?Q?rlcOAv9BZtA9eRbPKxghFY1AGI40YfseKrip5PG6NkkPOUik5yTaiiRvLuum?=
 =?us-ascii?Q?c+hlaoagah7edYvUWYxWg3HwmcJAKR7tJlU5iQKD8w3Gjh5yKIu9gjhkIosB?=
 =?us-ascii?Q?OlxK8unABJYE5jrke9wNys/P6vCwbb33bhGesACsk5KF1jenvV/67W2UTbZ7?=
 =?us-ascii?Q?kgL1yqZLcYEb5fV62DWpToL5wg2b5r93SU8j/iIbpAwIsq+gf69n4wbNVr/V?=
 =?us-ascii?Q?PrBKbIVqIppaDiMIHjm3s8hBslw3qAVdP0ps/bADBijU7dLHSep3Y6CVLzui?=
 =?us-ascii?Q?aEooAwQphedLYm7Knag7OfTx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba907ea-e773-4eec-c5a5-08d8dd8b4465
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 14:55:49.2956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /V+H1Mb8gENjM8AB6whaoPhy8isc1J4hyFfATfVRyJo1KxDuNDjlHaX7QOuawL5mRdbrf9l15tznbXJC4qY63g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> +Will and Quentin (arm64)
> 
> Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> point.
> 
> On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > Thanks for grabbing the data!
> > > 
> > > I am fine with both paths. Sean has stated an explicit desire for
> > > hypercall exiting, so I think that would be the current consensus.
> 
> Yep, though it'd be good to get Paolo's input, too.
> 
> > > If we want to do hypercall exiting, this should be in a follow-up
> > > series where we implement something more generic, e.g. a hypercall
> > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > exit route, we can drop the kvm side of the hypercall.
> 
> I don't think this is a good candidate for arbitrary hypercall interception.  Or
> rather, I think hypercall interception should be an orthogonal implementation.
> 
> The guest, including guest firmware, needs to be aware that the hypercall is
> supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> implement a common ABI is an unnecessary risk.
> 
> We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> require further VMM intervention.  But, I just don't see the point, it would
> save only a few lines of code.  It would also limit what KVM could do in the
> future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> then mandatory interception would essentially make it impossible for KVM to do
> bookkeeping while still honoring the interception request.
> 
> However, I do think it would make sense to have the userspace exit be a generic
> exit type.  But hey, we already have the necessary ABI defined for that!  It's
> just not used anywhere.
> 
> 	/* KVM_EXIT_HYPERCALL */
> 	struct {
> 		__u64 nr;
> 		__u64 args[6];
> 		__u64 ret;
> 		__u32 longmode;
> 		__u32 pad;
> 	} hypercall;
> 
> 
> > > Userspace could also handle the MSR using MSR filters (would need to
> > > confirm that).  Then userspace could also be in control of the cpuid bit.
> 
> An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> The data limitation could be fudged by shoving data into non-standard GPRs, but
> that will result in truly heinous guest code, and extensibility issues.
> 
> The data limitation is a moot point, because the x86-only thing is a deal
> breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> memory with a host.  I can't think of a clever way to avoid having to support
> TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> multiple KVM variants.

Looking at arm64's pKVM work, i see that it is a recently introduced RFC
patch-set and probably relevant to arm64 nVHE hypervisor
mode/implementation, and potentially makes sense as it adds guest
memory protection as both host and guest kernels are running on the same
privilege level ?

Though i do see that the pKVM stuff adds two hypercalls, specifically :

pkvm_create_mappings() ( I assume this is for setting shared memory
regions between host and guest) &
pkvm_create_private_mappings().

And the use-cases are quite similar to memory protection architectues
use cases, for example, use with virtio devices, guest DMA I/O, etc.

But, isn't this patch set still RFC, and though i agree that it adds
an infrastructure for standardised communication between the host and
it's guests for mutually controlled shared memory regions and
surely adds some kind of portability between hypervisor
implementations, but nothing is standardised still, right ?

Thanks,
Ashish
