Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DD131039B
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhBEDdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 22:33:13 -0500
Received: from mail-eopbgr680059.outbound.protection.outlook.com ([40.107.68.59]:49153
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229841AbhBEDdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 22:33:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQQh60g53u/8MckAL5EO26UQKp3OuYQ+eHE6KdhUimY1Fq2iNdP1FiNcyJPyNxt4xrpqfbIOMezk5fTqSGgwHFU2MJ3aEb0kJYKvLUe8TGldFilQkm2pxrKc7r37FtxRpdUMIzrVHAGYK4HYa/uSzGyDt8aZDwXLgCx9GjuS38YRf7tLvwB3gPb277I/r/OGhPhLGhGj3usXPIJJD2ftUhkxcGKSObhCOxbkI8nOnq+xrb8jSlRy6HJsrhGfpQeMjtIn0SNY7k2yCEHpQ12WAoi8j+AfA3y1DDdRC02hUeV6qWOYMQ56J8ZAm8ZLxFit+ofKYhB0jEEUerpO0DKDiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up00/A1YGoRrfoSCxpqpBLp/ONr++2/d8SgppX7qZls=;
 b=brjAxerNY3q0JEcCE/5TqGjZzqMBLKGaZ7ksTSHFhmcIcaqp7UizL8/gj8N6Mv6NhQADJ12yrfKEklL/iv+BtosoATbUkAt8tCXizoXwNLC2Z2DxI0PuoQiAh2u0rN7VDLPEg53OuNxEHYcuYfC6fl8gEvOTmR9vMUDVv8loti0dW+rXXfWwSf6IC0oZp/9IuuxxQbcgJfqDPWcl7Z267di379+bIIKVhjbD1P2G8UgzXCbk3yYrdcui372vMWwlDFyCv3gb9sRg4gCcY5X0IRD6LsQCU059W4SWFz+3hZGaXRfwlODlNP1ceguoQy8cpSkhmbA9U/LkqBt6VHHoPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up00/A1YGoRrfoSCxpqpBLp/ONr++2/d8SgppX7qZls=;
 b=hsZRHpxr2ECYkohJtAVBfDnKfdqCUdAGhjS5eaxY7il08dNYm4OnfPCrKJp4+27z0vvdQCWGJUZCbrTxz1FPGePONpClnRZKDykIH7FHEJHxnHY2/YE2DlnDW/ynJBvmvfdx+b2Zw9fcmdq7kUU+FjSIg4OHm0TSWtzLbvr7cws=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2766.namprd12.prod.outlook.com (2603:10b6:805:78::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 03:32:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 03:32:22 +0000
Date:   Fri, 5 Feb 2021 03:32:19 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 08/16] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <20210205033219.GB26504@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <245f84cca80417b490e47da17e711432716e2e06.1612398155.git.ashish.kalra@amd.com>
 <CABayD+ecgZ-fn3kjf+W3dXsAEi6zDO-Pzv1Yvg0SB29C5EHdcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABayD+ecgZ-fn3kjf+W3dXsAEi6zDO-Pzv1Yvg0SB29C5EHdcw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:6e::22) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR11CA0017.namprd11.prod.outlook.com (2603:10b6:806:6e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23 via Frontend Transport; Fri, 5 Feb 2021 03:32:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b548b812-2575-45a5-113d-08d8c986a5d2
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB276671BA5DE108D019CF00C38EB29@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HZbwZRbEsqrb+5gXb16dB/zC9W9P0F54drO3KSd8qymn03VFgKZ8r2wyMtArOUxR6kaRnkxT9Y8uQHy0I9rZzqf2mfreXYbqIvGopsy9Eknu9uHXufIDi4nZDwsXJ2imzlyPyzZR5+mddXZQhbrZPBkFpOHXJ5Ww5DpsF/wwyES99FEuEHLMpqVD4A/V2r9mJZCTNNGLwrcXJwHyO+9y07qPkYUVv+CGdMKy+YT49frNLo1iFCNbBrBgeXLZzC37dhh93L2Ud32eS+BXPGBzfofByDO/05O1TJaCRZHE6ulHL+EGtSn264lw06Ac8/XpLDCQa4Y/g+w4bCdvdYqQh1aweQ5BLX/EOfizQdAKWz0js7AAqWgfo/T56fD++Aw5pERfzBtuyNWRFah/4g05jlq+livP8ZcCnRqaftqwaRlJK1WhMpsOwX94efXHapW8TeAzzGPKuEBOj/TxDP09TTzNrvODRoNdbYDiLzreuDYU1eKB9ht40s3iLd2NNqwCOctKZvWsZuGmvaT/Yb7llbAUgBAwcMkV/NGx1neV8hKjKGWD2RC49Xg5ViJ8Cyhv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(1076003)(26005)(55016002)(66574015)(44832011)(186003)(86362001)(6916009)(33656002)(33716001)(83380400001)(2906002)(66476007)(478600001)(7416002)(9686003)(16526019)(53546011)(6496006)(54906003)(5660300002)(4326008)(316002)(66556008)(8676002)(66946007)(956004)(8936002)(52116002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YUMyUXVZTW9tV2d3MUl6c0JPclhocjdzd2QyWVg0ZTBQUFUvWW53QjZCK3p3?=
 =?utf-8?B?ZTEyUnVxRS9UWVd6eHIvV1kwcWFGaHY3T215S0IxYmVtUEJFS0NMOFRZM1pL?=
 =?utf-8?B?dFBFa21jejZYS0ZSY3FuWjNoc2pZZm52SUFlc1RlUGp0S3NrR2lyWlZkRHlu?=
 =?utf-8?B?eUxISjFZQ3RsbkdndTl1WFdmOHRqUWh6SkR6Y3BDc3orcHpyaXh2U2c0citU?=
 =?utf-8?B?VEM4Tzc5K3FWTmlNWS9kaWNyckVzU25Icmg5aDR4dGNNQ1dBbVVkb1JPUTVm?=
 =?utf-8?B?S2U1b1liRzdNTGhFTlQ0Y2FERVNramEvbEtWU1FJaE9ucERjK0FFdUc0OVVm?=
 =?utf-8?B?WGdyU2NoajJZSm91M0NyQVUvR05wZm9mWGRqc1BGSjFkSWJlTnVIbW9qc0NH?=
 =?utf-8?B?Q0xYeCtsYVVjeHR2cEF2MVRJVkZRODVZYmVzWUtoM0VqdkRsd3l0WW9KeUlt?=
 =?utf-8?B?SjNpcXNxenJicHA4aGxpODdVYXZNVEQ3NUZ3N2JZZlVmbmZaZFMzVWg1VFdT?=
 =?utf-8?B?dXE2NG95anArYVNzYlhydWZJb2ZWdEVIUVZLOU93RkFkL3ZsNnpDdmtuc2Qr?=
 =?utf-8?B?VDlTRzNzY3pEU01BdjlUZFk1WU5yclZDQWVieEdZNTlmOWF3YjhZdm9IdFlz?=
 =?utf-8?B?V3Z6ZXAyc3E4NDdQNlZsbGtMTU0rUGpudXg1YUViTjFTbXVqMEp6UVdoWXI3?=
 =?utf-8?B?Y2hFY0tLN0xNWEl1eXV4WHk5RVRxZHMrbkpZVjZYY0h2a3phcU1uck51QU1X?=
 =?utf-8?B?a3JtSzFqVEhiZndBK0FKaFFwNjlFbWJTQ1lSSEdoVzBhRytNeDlxS3ptQkJa?=
 =?utf-8?B?R0RKa0JrREZFa2dwVTk0d3QxR2FzUDh1OFJwYnNtY0Z2ano2S0pRcmZhcm1y?=
 =?utf-8?B?OW5JQ2Q5b3FMVzZRQzlyYmhpU1IwelJtSGZKRnZRa09Sd01QN1AvTlM2R1ds?=
 =?utf-8?B?Mm9zTnNWZTZ2WDNCMEM5SVA1RVorcEJXWTlaR0tyekE3U2tyOTlmcVNVN0Y4?=
 =?utf-8?B?SVVBcWkwM0cyMXRacVAwTWs0eU5Kd0tCMk1IQ1pmV3kvMkNtTXJOZzFrZkhV?=
 =?utf-8?B?NlE1R3o4L0YwL0U4NHRtbHpUQmtIMVE5RnhrVk9jN0N5ZWlkWndwSGVZMElz?=
 =?utf-8?B?K1h1SVdVMnVkOUFnTDNzdlR6VXZ2TnZyVEduaUgvd0hFOThCVjV0dVJDVDV6?=
 =?utf-8?B?TnhCQ0xVWkRzaWszdmlDSGRYL1ZNaGVaRERhZG9qK1I4Z1MxbEcxSDVnZjJq?=
 =?utf-8?B?bG8rKzJkWmt6TTJwZDZSNldSdlEvRlZtM09pSkJ5YlV5YWdwSGJvclVDOWlj?=
 =?utf-8?B?RlV5T0NYM0NFMmYrU1ErWkpiWnZPYlFleEZ5RXRXcXhSbFh3T29nSyt4dlRT?=
 =?utf-8?B?aFhuaU5wYXZrOTNVTThZYmxyaExEZktkb2hZbU9RSEFuYkZ5bTVVTnBxTUww?=
 =?utf-8?B?SzNQcmovcGdRRnJZbVpDWmwzZ1VrUDBlSUp3ME96ZEpKRGdnMGpzU0s5TkRq?=
 =?utf-8?B?RHoxRDRRSmtqZXR2VDNZZVhGcnVJY3hFVk40Yi9oQ01ZQlJLVzFnSWorQ0hv?=
 =?utf-8?B?QlA5ZDdwdWgzWjJsVnBqcEExa0E1VDdsOFN6aXlneU5OVG4rbGQ5eENmdmxi?=
 =?utf-8?B?TjdndEF5dmF5WGpreXJ3bko0UXdDQkFiUDRvbisrQzJ6ek1EUUsrby9ldGpK?=
 =?utf-8?B?ZXJCb0pCbXFvRzhYeThNYkV4c1h5Q29OZWVXTlRxYzgxTFNHbkI5ekpHcElu?=
 =?utf-8?Q?CSicK/78/AF9bNT4IwMPfHVtxuhSSEtImTviRRx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b548b812-2575-45a5-113d-08d8c986a5d2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 03:32:22.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fyHJxNQi23Dg/Xw4f+mAs/YXugZ0OOBB4qqLvX9LTximoLum7tNTWpdqj9s3XtG6Nx01Db3KVE9de7m3KR9bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Thu, Feb 04, 2021 at 05:44:27PM -0800, Steve Rutherford wrote:
> On Wed, Feb 3, 2021 at 4:38 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Brijesh Singh <brijesh.singh@amd.com>
> >
> > This hypercall is used by the SEV guest to notify a change in the page
> > encryption status to the hypervisor. The hypercall should be invoked
> > only when the encryption attribute is changed from encrypted -> decrypted
> > and vice versa. By default all guest pages are considered encrypted.
> >
> > The patch introduces a new shared pages list implemented as a
> > sorted linked list to track the shared/unencrypted regions marked by the
> > guest hypercall.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/hypercalls.rst |  15 +++
> >  arch/x86/include/asm/kvm_host.h       |   2 +
> >  arch/x86/kvm/svm/sev.c                | 150 ++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c                |   2 +
> >  arch/x86/kvm/svm/svm.h                |   5 +
> >  arch/x86/kvm/vmx/vmx.c                |   1 +
> >  arch/x86/kvm/x86.c                    |   6 ++
> >  include/uapi/linux/kvm_para.h         |   1 +
> >  8 files changed, 182 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> > index ed4fddd364ea..7aff0cebab7c 100644
> > --- a/Documentation/virt/kvm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/hypercalls.rst
> > @@ -169,3 +169,18 @@ a0: destination APIC ID
> >
> >  :Usage example: When sending a call-function IPI-many to vCPUs, yield if
> >                 any of the IPI target vCPUs was preempted.
> > +
> > +
> > +8. KVM_HC_PAGE_ENC_STATUS
> > +-------------------------
> > +:Architecture: x86
> > +:Status: active
> > +:Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > +
> > +a0: the guest physical address of the start page
> > +a1: the number of pages
> > +a2: encryption attribute
> > +
> > +   Where:
> > +       * 1: Encryption attribute is set
> > +       * 0: Encryption attribute is cleared
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3d6616f6f6ef..2da5f5e2a10e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1301,6 +1301,8 @@ struct kvm_x86_ops {
> >         int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >
> >         void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > +       int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > +                                 unsigned long sz, unsigned long mode);
> >  };
> >
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 25eaf35ba51d..55c628df5155 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -45,6 +45,11 @@ struct enc_region {
> >         unsigned long size;
> >  };
> >
> > +struct shared_region {
> > +       struct list_head list;
> > +       unsigned long gfn_start, gfn_end;
> > +};
> > +
> >  static int sev_flush_asids(void)
> >  {
> >         int ret, error = 0;
> > @@ -196,6 +201,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >         sev->active = true;
> >         sev->asid = asid;
> >         INIT_LIST_HEAD(&sev->regions_list);
> > +       INIT_LIST_HEAD(&sev->shared_pages_list);
> > +       sev->shared_pages_list_count = 0;
> >
> >         return 0;
> >
> > @@ -1473,6 +1480,148 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >         return ret;
> >  }
> >
> > +static int remove_shared_region(unsigned long start, unsigned long end,
> > +                               struct list_head *head)
> > +{
> > +       struct shared_region *pos;
> > +
> > +       list_for_each_entry(pos, head, list) {
> > +               if (pos->gfn_start == start &&
> > +                   pos->gfn_end == end) {
> > +                       list_del(&pos->list);
> > +                       kfree(pos);
> > +                       return -1;
> > +               } else if (start >= pos->gfn_start && end <= pos->gfn_end) {
> > +                       if (start == pos->gfn_start)
> > +                               pos->gfn_start = end + 1;
> > +                       else if (end == pos->gfn_end)
> > +                               pos->gfn_end = start - 1;
> > +                       else {
> > +                               /* Do a de-merge -- split linked list nodes */
> > +                               unsigned long tmp;
> > +                               struct shared_region *shrd_region;
> > +
> > +                               tmp = pos->gfn_end;
> > +                               pos->gfn_end = start-1;
> > +                               shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
> > +                               if (!shrd_region)
> > +                                       return -ENOMEM;
> > +                               shrd_region->gfn_start = end + 1;
> > +                               shrd_region->gfn_end = tmp;
> > +                               list_add(&shrd_region->list, &pos->list);
> > +                               return 1;
> > +                       }
> > +                       return 0;
> > +               }
> > +       }
> 
> This doesn't handle the case where the region being marked as
> encrypted is larger than than the unencrypted region under
> consideration, which (I believe) can happen with the current kexec
> handling (since it is oblivious to the prior state).
> I would probably break this down into the "five cases": no
> intersection (skip), entry is completely contained (drop), entry
> completely contains the removed region (split), intersect start
> (chop), and intersect end (chop).
> 

I believe that the above is already handling these cases :

1). no intersection (skip) : handled
2). entry is completely contained (drop) : handled
3). entry completely contains the removed region (split) : handled
4). intersect start in case of #3 (chop) : handled
5). intersect end in case of #3 (chop) : handled.

The one case it does not handle currently is where the region being marked 
as encrypted is larger than the unencrypted region under consideration.

> >
> > +       return 0;
> > +}
> > +
> > +static int add_shared_region(unsigned long start, unsigned long end,
> > +                            struct list_head *shared_pages_list)
> > +{
> > +       struct list_head *head = shared_pages_list;
> > +       struct shared_region *shrd_region;
> > +       struct shared_region *pos;
> > +
> > +       if (list_empty(head)) { > > +               shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
> > +               if (!shrd_region)
> > +                       return -ENOMEM;
> > +               shrd_region->gfn_start = start;
> > +               shrd_region->gfn_end = end;
> > +               list_add_tail(&shrd_region->list, head);
> > +               return 1;
> > +       }
> > +
> > +       /*
> > +        * Shared pages list is a sorted list in ascending order of
> > +        * guest PA's and also merges consecutive range of guest PA's
> > +        */
> > +       list_for_each_entry(pos, head, list) {
> > +               if (pos->gfn_end < start)
> > +                       continue;
> > +               /* merge consecutive guest PA(s) */
> > +               if (pos->gfn_start <= start && pos->gfn_end >= start) {
> > +                       pos->gfn_end = end;
> 
> I'm not sure this correctly avoids having duplicate overlapping
> elements in the list. It also doesn't merge consecutive contiguous
> regions. Current guest implementation should never call the hypercall
> with C=0 for the same region twice, without calling with c=1 in
> between, but this API should be compatible with that model.

Yes it does not handle duplicate overlapping elements being added in
the list, i will fix that. 

And merging consecutive contigious regions is supported, 
the code is merging consecutive GPAs as the example below shows :

...
[   50.894254] marking as unencrypted, gfn_start = c0000, gfn_end = fc000
[   50.894255] inserting new node @guest PA = c0000
[   50.894259] marking as unencrypted, gfn_start = fc000, gfn_end = fec00
[   50.894260] merging consecutive GPA start = c0000, end = fc000
[   50.894267] marking as unencrypted, gfn_start = fec00, gfn_end = fec01
[   50.894267] merging consecutive GPA start = c0000, end = fec00
[   50.894274] marking as unencrypted, gfn_start = fec01, gfn_end = fed00
[   50.894274] merging consecutive GPA start = c0000, end = fec01
[   50.894278] marking as unencrypted, gfn_start = fed00, gfn_end = fed01
[   50.894279] merging consecutive GPA start = c0000, end = fed00
[   50.894283] marking as unencrypted, gfn_start = fed00, gfn_end = fed1c
[   50.894283] merging consecutive GPA start = c0000, end = fed01
[   50.894287] marking as unencrypted, gfn_start = fed1c, gfn_end = fed20
[   50.894288] merging consecutive GPA start = c0000, end = fed1c
[   50.894294] marking as unencrypted, gfn_start = fed20, gfn_end = fee00
[   50.894294] merging consecutive GPA start = c0000, end = fed20
[   50.894303] marking as unencrypted, gfn_start = fee00, gfn_end = fef00
[   50.894304] merging consecutive GPA start = c0000, end = fee00
[   50.894669] marking as unencrypted, gfn_start = fef00, gfn_end = 1000000
...

The above is merged into a single entry, as shown below:

qemu-system-x86_64: gfn start = c0000, gfn_end = 1000000

> 
> The easiest pattern would probably be to:
> 1) find (or insert) the node that will contain the added region.

Except the find part, the above is handled.

> 2) remove the contents of the added region from the tail (will
> typically do nothing).
> 3) merge the head of the tail into the current node, if the end of the
> current node matches the start of that head.

This is also being handled.

Thanks,
Ashish

> >
> > +                       return 0;
> > +               }
> > +               break;
> > +       }
> >
> > +       /*
> > +        * Add a new node, allocate nodes using GFP_KERNEL_ACCOUNT so that
> > +        * kernel memory can be tracked/throttled in case a
> > +        * malicious guest makes infinite number of hypercalls to
> > +        * exhaust host kernel memory and cause a DOS attack.
> > +        */
> > +       shrd_region = kzalloc(sizeof(*shrd_region), GFP_KERNEL_ACCOUNT);
> > +       if (!shrd_region)
> > +               return -ENOMEM;
> > +       shrd_region->gfn_start = start;
> > +       shrd_region->gfn_end = end;
> > +       list_add_tail(&shrd_region->list, &pos->list);
> > +       return 1;
> >
> > +}
> > +
> 
> Thanks!
> Steve
