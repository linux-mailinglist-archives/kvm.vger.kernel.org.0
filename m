Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD3A32A793
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839345AbhCBQRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:17:21 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:24869
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1578437AbhCBPQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 10:16:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eejji+A721cdF2ql7OAr1tYoHuKFROI3COZcDqv/KtlGdCTfanAR4C5KtWaJYkRiidzfL+dHQog4ykV4/IrM3IwSxDxPKGTMVCnheDbH8OALtKtK9mBgrU7areECvG3lajEJxhjunV3A4dnhl46nHK6qL7Fr/MWeQzAUCbuCHNEQVnuGDHrwadOtV2uZ897bjxpBn0Ml2/7epV24TvicWNWa6GV6IjOSu3cgWYwmY5n8XFFqN94nKSCQBlnP3SWEASTq7e/EDnSysWsUicoC3Xu8jV/hb5LPabjweChDXnkNo1LpOZBTOMpqA7rFPAh9g5haSa/DFGOOsYCg0UsW8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu5ir93lfLnc5rhIgOvqqcRJxkoPRN5UHxTwT3LVEU8=;
 b=GSadVlBxPvuaZdi5ZrG6gNZBD/ZLq44D9pXjuR8c+D7zmK+N7+4JzpjyAgxEo7fpptWhmq3BFaa3z0XmPXCz+uvJKkorpSE/RBKEliIug+xqicoyk7Y4/as1m5ow0F9JOYGBjYuxWhJAwuTNG2dheXg/TMc1Wge+wBMvWjzVk12Yo3RKA3518fFKwpoQmbgfMlEdkwpjy5VsWGS9tizz5PIOvoFFOXJP4UEhy5n9h4OOXIOyBb9Y2KehxYrcub8Go+iwHjtrK2rzapGbCbTMJ4S/q1Fpc30fwKiuhwDXISBB/eQMhI1ahgzvpEhY85NnzGXFhybZtynyOLe6XYxXFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu5ir93lfLnc5rhIgOvqqcRJxkoPRN5UHxTwT3LVEU8=;
 b=BgpRJHvdxF4uM9x+T1O6AIdk9WGfOlfWloIDVG+LmCnG5vyjcEGq5A6pNBIOY/ZXPEE2UrvqRPlkf1NNlS8vapLhMFyael2Mv1nffsmxlBzIHrNfkoUURovdv38Qfrid2wCaao9yyuSX+HYDdyQEJwLdf3dqKxi/TK/y5cufAIQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 2 Mar
 2021 15:15:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 15:15:22 +0000
Date:   Tue, 2 Mar 2021 15:15:16 +0000
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
Message-ID: <20210302151516.GA30137@ashkalra_ubuntu_server>
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302145543.GA29994@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0047.prod.exchangelabs.com (2603:10b6:800::15) To
 SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0047.prod.exchangelabs.com (2603:10b6:800::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 2 Mar 2021 15:15:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 339e673a-2253-483e-bcf7-08d8dd8dff92
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268877B6831B0B1EAB5410CD8E999@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MuqazUq33GVkmPUE+TS/tsXBxoYM+/3Sw8I95sHS+5HWTboI4M5NhieL5reMnv/hOG/zGJO8m80yiUD/i8Xz8JC9f94lt243Zml2NgdDVB9aBi4oY7OJAtnXhCAqLi8nHHdxruyQjsisz+UGDdXI5Gn9JG/zJdGQuK2Z8zgD0KJAVlgib/PlkwA0Cs/xcYNwjGeewbnvyxiTWe1IMzAvoHF0e2E+5b+HohrEa/79cJEDdiN71EblNheZ/naga9eackxY0zNIoJQERHNJ3nOsyZ5jE5I2lXvkJAaAQ+jj6oQsUtk5eGn2PF8irOqU1X2ir3wBWi3gObtHFSbeosd5LJlAcymdNxIBdRa8ftVYkvAbBYPoYA+TQBNPKc2RqCcPZsGgHGBC+0BH4zJdToIWVS94Gp2+wnTqkzF5oPgMPFtUgoYtr5QpdVo+12j8NLBE7444M5YWG9YY16LTw1Ki67FectUf3b0O9Md/aDHHJUK9KKEtjqkYezVGXf9qNYN+6gLfW/oZ0NJgw8uFzE8DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(9686003)(8936002)(83380400001)(186003)(86362001)(6666004)(16526019)(6916009)(44832011)(316002)(956004)(55016002)(4326008)(1076003)(478600001)(54906003)(5660300002)(8676002)(33656002)(52116002)(66476007)(6496006)(66556008)(66946007)(26005)(33716001)(53546011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9EZd9GC57AZ0cX4g9lwASLkWTzrqpP5piqK8DMSXc7KrpvqcRcRr/iINSvNC?=
 =?us-ascii?Q?pZaGbSXuCmj3VidNZZWfPmH/OK697kE3oO5HsUqRdO960DpKEl1Ji1X+snQW?=
 =?us-ascii?Q?eEzqyWZyiHJUleR/bl1qkmc8Ag39zxeO8zmQd74MIkF0TO6zL/sgsmudoW97?=
 =?us-ascii?Q?qVYMtD/cC3o4N7uHSXABsOTutbN5BtXiEHV2Tla95meBfu2tRuPZxKurkSok?=
 =?us-ascii?Q?/OcwMlOH2frGs/fmI8rmy0lZ1qKwq8agnQ1F3V9GY8VpQiFzs6fCoHKcjxEe?=
 =?us-ascii?Q?N0N4XfjjjRez7mtCOfYQ/Hnbr84FgSssy/mFfGRZRZdciMixe7fLj45AxDvG?=
 =?us-ascii?Q?k4Va9c2OG8Vh8TKhBdhP4cECgPQLc0i+jH/6V6USPGUxHxlIRueL95RHyQvV?=
 =?us-ascii?Q?M/ji0eYWcdxKYsjjWHjvgwNu4tfbgwqqpbX7TbxQZefDpSUb6SmU740sQ3vu?=
 =?us-ascii?Q?McYJ7AM8paAsDOG9HywmFEq2UTPAfrpS6wcIT5xpO+KKE6K7O6XNhs1wplW7?=
 =?us-ascii?Q?NKXiX/rgWkTAq4R1RsYJCQwRog9SjOBpZwdmVsaLnjAkvvNVYUBG7XFGJaoc?=
 =?us-ascii?Q?Es2gjOinpgI3UWSsYR2BhCg9+Bps6ek5nRdlBDC1Ycrem1ocid2tDXIuh2om?=
 =?us-ascii?Q?OAw+pjq1gpVuxPuY7p6t9+PvyrmwsaYQHeQ0TT5hb1Q+8wyjcuViGwkVpAj2?=
 =?us-ascii?Q?5AQqO94jaU0P/efmtTgejTy12/YIGjwelFEHnXH5mpWBIIGoe8RCd7O0c8uU?=
 =?us-ascii?Q?NKnMAJxwlSI3Z6mKJv28HjhSUTZa12HIlwberGs6znaPyal1dZGe6L6Kqyi4?=
 =?us-ascii?Q?11zhnRKo2v+VjA6z7G7yWENfQHAL/zO5FsBddC0fjTDg7haFI0ysbF4qrq4H?=
 =?us-ascii?Q?Di5n8dPJ70iho0VMwrWLaMnRtd5UGDaioNQPEvUheXr9pFI+1nLrSWmz0obj?=
 =?us-ascii?Q?gOoB9O5xTJiL9ARcpSQcm4Yc382GvRW9yMlcIVSM7E1gnqbcdpxGkxeh04vK?=
 =?us-ascii?Q?ccmGxowJUxZeYELRlmvPRfM3k3J3C2GgAvhumKfykJsKkHDX4qkRIEwaALpy?=
 =?us-ascii?Q?gHrsFdQ+mxbfXmZ9z5tonbFS2wFfE0PqSD2SP7ABAO6/U1HEJZEfMTrRab0R?=
 =?us-ascii?Q?fBSRhcfV15XNtc2IyWUUw+iOsl4tLGSB3pdp8Steqc6nnir0h8dZP/QRxI81?=
 =?us-ascii?Q?zjvFf50JKDomaxPr6B6oWVmIXQJWEOHoxK2V8EnqXvsYezzH16cy+rhfGt7+?=
 =?us-ascii?Q?vGcTGewIZjZbKaPZH/HbC5th6EPqE4tEWTMtVa5+2NUEwb35o1K7tDX2M88Q?=
 =?us-ascii?Q?G/0JVi5yllcu4x0CPYrQWMc1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339e673a-2253-483e-bcf7-08d8dd8dff92
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 15:15:22.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JyKG2T1VdD4cgoCpv40EX+ja9YoxTd9e97iC4o5CRdhnwaWuiO8Wps0rDkRAzvh2qBga/1WoUcZQT4VEf9IQvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > +Will and Quentin (arm64)
> > 
> > Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> > point.
> > 
> > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> > > > Thanks for grabbing the data!
> > > > 
> > > > I am fine with both paths. Sean has stated an explicit desire for
> > > > hypercall exiting, so I think that would be the current consensus.
> > 
> > Yep, though it'd be good to get Paolo's input, too.
> > 
> > > > If we want to do hypercall exiting, this should be in a follow-up
> > > > series where we implement something more generic, e.g. a hypercall
> > > > exiting bitmap or hypercall exit list. If we are taking the hypercall
> > > > exit route, we can drop the kvm side of the hypercall.
> > 
> > I don't think this is a good candidate for arbitrary hypercall interception.  Or
> > rather, I think hypercall interception should be an orthogonal implementation.
> > 
> > The guest, including guest firmware, needs to be aware that the hypercall is
> > supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> > implement a common ABI is an unnecessary risk.
> > 
> > We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> > require further VMM intervention.  But, I just don't see the point, it would
> > save only a few lines of code.  It would also limit what KVM could do in the
> > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> > then mandatory interception would essentially make it impossible for KVM to do
> > bookkeeping while still honoring the interception request.
> > 
> > However, I do think it would make sense to have the userspace exit be a generic
> > exit type.  But hey, we already have the necessary ABI defined for that!  It's
> > just not used anywhere.
> > 
> > 	/* KVM_EXIT_HYPERCALL */
> > 	struct {
> > 		__u64 nr;
> > 		__u64 args[6];
> > 		__u64 ret;
> > 		__u32 longmode;
> > 		__u32 pad;
> > 	} hypercall;
> > 
> > 
> > > > Userspace could also handle the MSR using MSR filters (would need to
> > > > confirm that).  Then userspace could also be in control of the cpuid bit.
> > 
> > An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> > The data limitation could be fudged by shoving data into non-standard GPRs, but
> > that will result in truly heinous guest code, and extensibility issues.
> > 
> > The data limitation is a moot point, because the x86-only thing is a deal
> > breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> > memory with a host.  I can't think of a clever way to avoid having to support
> > TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> > multiple KVM variants.
> 
> Looking at arm64's pKVM work, i see that it is a recently introduced RFC
> patch-set and probably relevant to arm64 nVHE hypervisor
> mode/implementation, and potentially makes sense as it adds guest
> memory protection as both host and guest kernels are running on the same
> privilege level ?
> 
> Though i do see that the pKVM stuff adds two hypercalls, specifically :
> 
> pkvm_create_mappings() ( I assume this is for setting shared memory
> regions between host and guest) &
> pkvm_create_private_mappings().
> 
> And the use-cases are quite similar to memory protection architectues
> use cases, for example, use with virtio devices, guest DMA I/O, etc.
> 
> But, isn't this patch set still RFC, and though i agree that it adds
> an infrastructure for standardised communication between the host and
> it's guests for mutually controlled shared memory regions and
> surely adds some kind of portability between hypervisor
> implementations, but nothing is standardised still, right ?
> 

And to add here, the hypercall implementation is in-HYP mode,
there is no infrastructure as part of this patch-set to do
hypercall exiting and handling it in user-space. 

Though arguably, we may able to add a hypercall exiting code path on the
amd64 implementation for the same hypercall interfaces ?

Alternatively, we implement this in-kernel and then add SET/GET ioctl
interfaces to export the shared pages/regions list to user-space.

Thanks,
Ashish
