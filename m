Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF28D3331F6
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 00:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhCIXlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 18:41:42 -0500
Received: from mail-eopbgr700083.outbound.protection.outlook.com ([40.107.70.83]:28993
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232199AbhCIXlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 18:41:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Smy2n0SgOi5PIMZbTe4ReZ6IDdunZDtfbOMx2uLN+RZp35WRXJgKj9IiaZT3inC0TUjajU9lwt5i7o92QLIbtRo+WSxFh6R2z8kH9j2l8o3Ply3D1hWIVcMLhN6XR1mhWer/Ru1mQN7vU/PSEPOpw6UW6FiwpytHJikbALycYBRTs1bMDp1GOJN3EKrprVRGihbqpbhZ1EFVcg/+31wHhfJUQGni26m25MjQO9NxqHDywmeWJkeZ0L4V++PPBWaYJQKfI7IapMtOpzNz/2+EAG6HshteiG80YcltsJNuN7opY8lWqkjGmhKhbUubBPWLGE6RjG7mjMoTuYknL88NCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6bnUY+ku26ox32oQ3uMH1eDXc7KuA7Xdc7QKA01ESU=;
 b=dzWoPOZYq1zeDvMhswc5LJy9xCkybYBBCOToC5S0JOkpBn7UfXn++kj4wg/qvXARhD9+aaQyxEzDtNo3AxeMpyeIMkRUd4ahj4cvBz8LQBHwKxYByuG6s5MaYj8y2q2n6Yu181gkD77Em4SEa0XZtBWrP3QaP1UzQ7RyCwWbGGkYH+/W2ojFNpVZwvvZ8XYTP8yxS8kCxRVSAp1ri8WBP6p6RffUggH1atRg48tjN8f6b1a9ZGmsSqOK5WZBUI1zjsxwuB43ilFfbuoy503j2HJ6t5jsIIubL0T0i+3TCDLh/EYJr1audQo5xu6HS5DYu2V4eu+AKk81/5Qp0d8f7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6bnUY+ku26ox32oQ3uMH1eDXc7KuA7Xdc7QKA01ESU=;
 b=eiF26lA0ItvMhzo9Li2GmSQbalPilETGvp4+LxR1CtPzW4XasQnXP2WJjibBmUS+BHGeO7sJ5g2VyspgAooTt1qUAunJrjstzQ1Y+7Z7Bnpm/NpT+rP7w8AJkxQpxaQKcXVIXoB5YEelidu5kafbR6SosDY4UpEEaiH8OjZQ2D38eF0p87ThxX0RHLLeHQx/1u+hzHLBejAiCmV4RYt/NwKJAhcEbe1BSJIm+BIXq5d2MXia52+edjafAvpct/2eLw19zbGMXMJ7KaVU35NktAgFQvD4ZLNM2SLe3ZXqq5RpjmuNoNESvW3Vr5CCEv/Nc6xxBW5VZscQ8K0pC0nnSA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2438.namprd12.prod.outlook.com (2603:10b6:4:b5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 9 Mar
 2021 23:41:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 23:41:29 +0000
Date:   Tue, 9 Mar 2021 19:41:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309234127.GM2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
 <20210308225626.GN397383@xz-x1>
 <6b98461600f74f2385b9096203fa3611@hisilicon.com>
 <20210309124609.GG2356281@nvidia.com>
 <20210309082951.75f0eb01@x1.home.shazbot.org>
 <20210309164004.GJ2356281@nvidia.com>
 <20210309184739.GD763132@xz-x1>
 <20210309122607.0b68fb9b@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309122607.0b68fb9b@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0065.prod.exchangelabs.com (2603:10b6:208:23f::34)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0065.prod.exchangelabs.com (2603:10b6:208:23f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 23:41:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJlyh-00AXCZ-Bn; Tue, 09 Mar 2021 19:41:27 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b92ad1e-b33d-429d-6e44-08d8e354dc74
X-MS-TrafficTypeDiagnostic: DM5PR12MB2438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2438BD28A0A1819DF0EF9890C2929@DM5PR12MB2438.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f1EgXJWZ4aJJ3Pu+MZchUVxlESjH3khVMG1FhVVPQnfFup+BBQILMlPPsNXypqBnr/iPI+1JGF6fYsdkc7cDq/E7ngSwhjVGF2LG7j9sfx+4bVqARaF9ZGK7FWl2qHCqshhczJNAzGVbRLPOt17crYA04lS+gvhl77HYypsbxrCr+Lrz2USRK5p5fECffMhp+TIOVCm/fWIAzR8DOiiT0zAkhCsnZ8zn83/aX2Yyy6UGSLGvF7F0qvXnBXPbSC//re5j4YRd5fKntoRx+4XvhWDOD5vZRT7y7pyEMDXpP6sEQqA9hRFimR257LertyndjKmH0SndBZDP4mwT7ev6oP5YUw8MwP5SsvPmz7pc3QOTXaaDThRn5kcQo/KYox+59fsx7+lM/DRCsmnvpeWj4zV9K7O5Cmw8d4uw8FpQh9+66tlEkicePGv33Z/OZzFwJ3v1uJlWDDkj/UJOcBH4QXKZ0JC0lgLSP92bDX5INdddWb6kYw3am2OLJ0AoZysPz0iLgncEonR3tyDU7pUmdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(478600001)(66946007)(9786002)(8676002)(186003)(7416002)(54906003)(426003)(2906002)(6916009)(316002)(2616005)(83380400001)(86362001)(4744005)(8936002)(66556008)(66476007)(36756003)(9746002)(5660300002)(1076003)(33656002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?t3LtbzilEisdPnakFGCLu3Ssa+0/Pitirg2Jr/+UqFhpqo5l4Oz944fuLymN?=
 =?us-ascii?Q?HiJjX7KrgtfjLAjJtbvQgilX9SHaLxHzZB/3FPQ2GcSPvAxtXPbYMIIIMaPp?=
 =?us-ascii?Q?5pPEVwQw3Z7EdzbzCcAukVY53lt/MP3TRQ+lRGSsoJOqck8F5bZ7RR+yNpkJ?=
 =?us-ascii?Q?PP04KxC9vN6md1L/k8LhUgFBVtulOt4XkDREYKSszitpqO+/PBnLbdKGtkbm?=
 =?us-ascii?Q?fJmDdlidy7FSrvBuAMZe3Ugk7BTV0g0mDPLPJ+iUMb1KLhwiaULOipZQ0vSi?=
 =?us-ascii?Q?/MyYWsAyktEYX20rqlivayVRjsttivJhuusv0Y/ivlro54JaU365xccOMCeU?=
 =?us-ascii?Q?6NtCDTjs7nQwOtoCUxn7gGXoXukr9tVzI4kRBjMJtNCaMrfOcny8ISJkxU1J?=
 =?us-ascii?Q?MS/b23tBG0DOVmXq+sHWXwp/QkytnLgMpfqDBfUz3MlZsAYitgOnqtBqczYX?=
 =?us-ascii?Q?WiBmdez3puj+zq0IKbXOAB5m+qMRrHRTEFhF+XyeRlpKxVIU/Lin53xpc29E?=
 =?us-ascii?Q?YsKCM+ayIOplCaGuZHChQB3Nou/Fqw3Hoc7GshvrolVXgNq2Ov6EW9K5jezt?=
 =?us-ascii?Q?0fD9OkZE2++Kr+FIbXSXvd9GbBGCQ16htqYuHrrz9y7WbBUNctzJ3aweJViJ?=
 =?us-ascii?Q?+WQVNnOljf+iv09c/6crW5XLkEQYR60qL/x/lzcjUFD7L/kCZwEL4wtauOX1?=
 =?us-ascii?Q?TmMm+74UTdVGu927jQkDVOXiGUwPPyQOyEsn3s5XY9Mbadpw1uSTOK/NzcNW?=
 =?us-ascii?Q?i/nCLVPMaR9HH3bBvjBSe4yiVX8gc8Oz760Ic/VvZLlHU/otCsvoZAKeKcDI?=
 =?us-ascii?Q?isSZ1iXtVma4IyNEgxZkbidlutxFgBUAXLe2Qa7qjitLfuEe07Me/s62J3nZ?=
 =?us-ascii?Q?J6kHRTgxvpCV8gbYaDq6GBZHRc3tgssx/ofLHo80Ac/lpSacu5l82LXYgoNs?=
 =?us-ascii?Q?uoVRkwSFeM8D3J4XtsL2kE7g9l3RYPy9OrpNKBBpbFs2TnX4zbQcJafZct37?=
 =?us-ascii?Q?C+mLsiu52YMX2G0ekPFRtbXhtK7alrHgz+H1is/awYNL4DNW141a5a72AsVi?=
 =?us-ascii?Q?nZ3badBBXEuINo49vO/tBjkIkPfK6T4kwJOSD9bxp4lCPyAZ+bmN2qvzxE7I?=
 =?us-ascii?Q?zzLmGLqap0F9hVzPLTWITgOLPW+M3Xo/M9xn37jhD3XkHiiMULQ7KJ2/hDCg?=
 =?us-ascii?Q?qiHufJekT1ZaKdiF86LkhektBCQjA+1MTAcWPm4biaAYTZ8xsptCSpP/UiBs?=
 =?us-ascii?Q?GDJ/jzdpAWE0CeOP8x97GEEaG+1UpBb06Ue5mxNEjw2GVVdk0udKqwM2/TDQ?=
 =?us-ascii?Q?CSVlpmcwtyOnQtuhGLY7MuV4B0K0+jVlfYeFhsAaS270LA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b92ad1e-b33d-429d-6e44-08d8e354dc74
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 23:41:29.0459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmwgMGuCVeGVOVSO5kkDqA8PHCxzKPkuGSjh1YOngl4py6FXRVHpcc10NSvjn9Nc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2438
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 12:26:07PM -0700, Alex Williamson wrote:

> In the new series, I think the fault handler becomes (untested):
> 
> static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> {
>         struct vm_area_struct *vma = vmf->vma;
>         struct vfio_pci_device *vdev = vma->vm_private_data;
>         unsigned long base_pfn, pgoff;
>         vm_fault_t ret = VM_FAULT_SIGBUS;
> 
>         if (vfio_pci_bar_vma_to_pfn(vma, &base_pfn))
>                 return ret;
> 
>         pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;

I don't think this math is completely safe, it needs to parse the
vm_pgoff..

I'm worried userspace could split/punch/mangle a VMA using
munmap/mremap/etc/etc in a way that does update the pg_off but is
incompatible with the above.

Jason
