Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4542EEA89
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 01:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbhAHAsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 19:48:55 -0500
Received: from mail-dm6nam12on2067.outbound.protection.outlook.com ([40.107.243.67]:40737
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727695AbhAHAsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 19:48:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0PtN8jsyNuSXGASRuiAp+9WlbKgAbEwAOqkit1A2igykiglBs2fBQfnXpTLKE22Wetwufx5fgES+9CHmzMWsLeGYZvL6l9bFuqlKb0EDiFCA00lbNtKRwTzedUvCBPValDfEmIPP4JMcbqNafd18n53lfFjIy2LFgqKxIau6cKjDMVSHrZIE3NOzM+0VjCxbUCRhSyuVjU8fkADp7NNGJXi31bFphoY/MnWmD9VzNrmMRrvO/bV+OQPw1vS8W87fRa5ciFLCUZnNDV9G4dHu9eADhcpwZ3rewfst3mMY5qSw6Cg2zlPbPR4OqeGSc/8OfqIj3Dll0FjDa/mi7J+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNx26IEDsNsmPhCjL3p7QVqCsAQNb0xxAw9cYej024s=;
 b=IMYbo95N92AKbBaRByGYKYQG5icPk0KqphVcoP2ptC+gmjNjbeD/b6NEpTNd3AoYMh0JZChf1gekFGJrkyWV2AvL47LD70xnpjP87pNZfS7RnrGUKcOJIBcIR/XGs68KPLaYTRZ2YifY9eKlpwWmZ2i7nTnnpHo5aEnVwRQEdYc3Wj3H3OzLagiNmr5bD3mVoMVQdq5elgt6UOM3pxMgDd91WVerClkVNjbO8cju36nJ7dQY6puD9p30q9y0MnmzAnjlP6VSCvw/EbDK+lr0CspscxS6j1tFxhnewbTd30zP3gFCmYwTqE+U0hHXCoNHiTrlLLUyIawrIYzWZxz9Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNx26IEDsNsmPhCjL3p7QVqCsAQNb0xxAw9cYej024s=;
 b=tkY8+KdsHj3B/npAHy5HV2FQni9mEMGkBBarVlTlbvZ0Dt97bkBNvDElAAxuEjvMoo6x7qnaf5tp5G8JiCwRV+Bl/WYFPD7YbZ8xOnNLSL0u71zuFTL/RVKGj7KMv1xOJ3oDor3eJAl14H9qDqNFMl0feWmxO+QLe/N3UUSDYIE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2541.namprd12.prod.outlook.com (2603:10b6:802:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23; Fri, 8 Jan
 2021 00:48:02 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::209d:4e20:fc9e:a726%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 00:48:02 +0000
Date:   Fri, 8 Jan 2021 00:47:56 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
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
Message-ID: <20210108004756.GA17895@ashkalra_ubuntu_server>
References: <765f86ae-7c68-6722-c6e0-c6150ce69e59@amd.com>
 <20201211225542.GA30409@ashkalra_ubuntu_server>
 <20201212045603.GA27415@ashkalra_ubuntu_server>
 <20201218193956.GJ2956@work-vm>
 <E79E09A2-F314-4B59-B7AE-07B1D422DF2B@amd.com>
 <20201218195641.GL2956@work-vm>
 <20210106230555.GA13999@ashkalra_ubuntu_server>
 <CABayD+dQwaeCnr5_+DUpvbQ42O6cZBMO79pEEzi5WXPO=NH3iA@mail.gmail.com>
 <20210107013414.GA14098@ashkalra_ubuntu_server>
 <20210107080513.GA16781@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107080513.GA16781@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0801CA0019.namprd08.prod.outlook.com
 (2603:10b6:803:29::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0801CA0019.namprd08.prod.outlook.com (2603:10b6:803:29::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 00:48:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bec0195b-5c60-40c4-f447-08d8b36f0dca
X-MS-TrafficTypeDiagnostic: SN1PR12MB2541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2541FCA143F3CEFD42E4B3088EAE0@SN1PR12MB2541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e4IjyP0g6FNEoPHG4yO50BE7tgLVTiKV3S/56Zz13NsyPxOXiCBpA7TmHPxygtABY5tzzdGybphjDX1Aj3Sze9OtWsq9ZViUWMnMMrKAqbnmkxsbf6bH1qicITRszvEKBOeyAuzGr0OBJJlz8Ep6TPUoVX2mFUvXgRvAt4OAoooJsc6DbBxy97nrgwkphPxHF1MHZ5aZW4lY9M/eqsDQisaePKETjEbQ1vrbYkIafCHP68KVvbF+HQr8p6msAm6PH9CKz/ooIdhC3xHBZ6jv80VgEUAYAXoH2rAZ0QyLjoJrBShIMlA35rpNk5m5JoaIBCEEWDX61eyal1E3vgyMHcpVmYIGYb/2r7z4Z4wGBOsSwi9QgIwW+6415fnCl+m6QzrKovRzYxaj3aM1DXOhgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(4326008)(6496006)(956004)(66556008)(1076003)(44832011)(54906003)(33716001)(33656002)(8936002)(7416002)(316002)(2906002)(186003)(5660300002)(6916009)(66946007)(86362001)(55016002)(83380400001)(66476007)(478600001)(16526019)(6666004)(9686003)(52116002)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2Vso2aBMPFUOAqtbQ2dUH8YV84KhvAMG2hpEng+eTsopF28xhXho4WaC1mUD?=
 =?us-ascii?Q?ZyvY9vFyX06r03UN90muzAaVKYaqUwNX6eloRBXb+0O5v/z0IX4jtZHRYvhO?=
 =?us-ascii?Q?xRPw3IanUfS5Kd4+PjjH0puYTH+OZWsFcnoYcV8MVF0PSLc6miTapdiDivDH?=
 =?us-ascii?Q?6DfeDtIps0uF8JB92ifs5kVhHuraMNNEeNtXHmL25znXyXMs4P6p6LYWtPUC?=
 =?us-ascii?Q?Rb/4EaI3rFNyGdDc89TQbm5ZHjnoZ6bihYUghvXgEYh8nokqJKCDeWeDCf6b?=
 =?us-ascii?Q?SEQEHVQmzF2FyA7DURz28FuAY7EnqSSVr5tLJrGKxgpXDM6kYJOjjiVeoea1?=
 =?us-ascii?Q?G+l6233tzugANjqrpnwex0uQLR0ZY7nZxNYzicSo5n5v9zos5JscRXWOb/HM?=
 =?us-ascii?Q?mX3y/Gz9ILfMZX12s3mSrQEtjd7FXtNGk1B6sFGzE4vVN4KxhZ+aT8kjhMQ2?=
 =?us-ascii?Q?J8juXyUEY2T5urJFZx9Nug2JSlenYGnit1HpgAOxZ9zgr0tP+RSUK6n+wTpJ?=
 =?us-ascii?Q?h46DN8KCYpBLZ4TQvG8EqueRdHEcsiIz7heyfDatVnroIedRgM4sdFaKX6nh?=
 =?us-ascii?Q?PI8tyMnTBoDBvwdYrNSbGhbmm60BgttAYne23AKjXTXGzn042i0qPcZkDG5S?=
 =?us-ascii?Q?AJYNk1JBD/BIlH3A5GMxr/U1IB+ppydSEgEYmcHdrGJIVDchddh3Q9+zi+4M?=
 =?us-ascii?Q?jd6UVcoJHep92+fA26jEJsqWu4BAbq1ZUN/W4XL+xm61un8s0pJKllaQqv0a?=
 =?us-ascii?Q?tPByTtziANgj97pFo1Fr72tV0+MnmxkVlmo4kMAzuovHTtJ81KNyTO/KwXVC?=
 =?us-ascii?Q?qQVL8YAVTGydGchLlaO4yclg4pGIqNGg3FQWEuAt6hTlLFtTgcV6sgH4wAYV?=
 =?us-ascii?Q?FZdiZ4L2h+hhFQ4mr43oHJSGfWUztEhPLNuYD9F/BBkq1qN6LRhBxK0BBGkm?=
 =?us-ascii?Q?WPuQUebXV0uM2OH7YOqFYT72O/YBEqLKNkrhiMx33YVLqCi7C3YOXsyGEjeN?=
 =?us-ascii?Q?hida?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 00:48:02.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: bec0195b-5c60-40c4-f447-08d8b36f0dca
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZpqWlP4J3CdDXb05UB5x0rtUMtXKWlHBX0PrzZImX7+cvEyf8pd21b2kyHaV4MdUJf3DuBXbTLriuJ+xtiJ/mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2541
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Thu, Jan 07, 2021 at 01:34:14AM +0000, Ashish Kalra wrote:
> > Hello Steve,
> > 
> > My thoughts here ...
> > 
> > On Wed, Jan 06, 2021 at 05:01:33PM -0800, Steve Rutherford wrote:
> > > Avoiding an rbtree for such a small (but unstable) list seems correct.
> > > 
> > 
> > I agree.
> > 
> > > For the unencrypted region list strategy, the only questions that I
> > > have are fairly secondary.
> > > - How should the kernel upper bound the size of the list in the face
> > > of malicious guests, but still support large guests? (Something
> > > similar to the size provided in the bitmap API would work).
> > > - What serialization format should be used for the ioctl API?
> > > (Usermode could send down a pointer to a user region and a size. The
> > > kernel could then populate that with an array of structs containing
> > > bases and limits for unencrypted regions.)
> > > - How will the kernel tag a guest as having exceeded its maximum list
> > > size, in order to indicate that the list is now incomplete? (Track a
> > > poison bit, and send it up when getting the serialized list of
> > > regions).
> > > 
> > > In my view, there are two main competitors to this strategy:
> > > - (Existing) Bitmap API
> > > - A guest memory donation based model
> > > 
> > > The existing bitmap API avoids any issues with growing too large,
> > > since it's size is predictable.
> > > 
> > > To elaborate on the memory donation based model, the guest could put
> > > an encryption status data structure into unencrypted guest memory, and
> > > then use a hypercall to inform the host where the base of that
> > > structure is located. The main advantage of this is that it side steps
> > > any issues around malicious guests causing large allocations.
> > > 
> > > The unencrypted region list seems very practical. It's biggest
> > > advantage over the bitmap is how cheap it will be to pass the
> > > structure up from the kernel. A memory donation based model could
> > > achieve similar performance, but with some additional complexity.
> > > 
> > > Does anyone view the memory donation model as worth the complexity?
> > > Does anyone think the simplicity of the bitmap is a better tradeoff
> > > compared to an unencrypted region list?
> > 
> > One advantage in sticking with the bitmap is that it maps very nicely to
> > the dirty bitmap page tracking logic in KVM/Qemu. The way Brijesh
> > designed and implemented it is very similar to dirty page bitmap tracking
> > and syncing between KVM and Qemu. The same logic is re-used for the page
> > encryption bitmap which means quite mininal changes and code resuse in
> > Qemu. 
> > 
> > Any changes to the backing data structure, will require additional
> > mapping logic to be added to Qemu.
> > 
> > This is one advantage in keeping the bitmap logic.
> > 

So if nobody is in favor of keeping the (current) bitmap logic, we will
move to the unencrypted region list approach.

Thanks,
Ashish
