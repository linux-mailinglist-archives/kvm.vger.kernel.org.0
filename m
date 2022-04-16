Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DCF5033C0
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiDPCGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 22:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiDPCFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 22:05:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2075.outbound.protection.outlook.com [40.107.102.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FBE0AA
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 18:55:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGTilUOHiHDB6iVJFR3U18RNBY2eaVsoybLM6eWlNXZOxIDGXmEmXm78eEz+FgHRejQ2WY9vI6q18SVdZEWL/C6iSNFAJdp2cEXp/7FDB/hmyDfRB3OeYaMtvOO3QL2yiVoeueCUqAoQhLrU7EdJgOzHdnfeybrgcaL7igskDI1tkIE1Gn5zlsuW7HC83//unEMUhMmw8TlTaMxpOEuo24Tnj803flkpFm9ENI+DOKLss4yPjxc1uV2jey+CT+uByIrUNk5/wGcOhiKgPvVS2l1eTDib5Xi0OJEk6ONGUjPaJfqJVrrEROnEwLMy3OnEykCkINWG+Tx0KSBXI0T/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RM7HY7PUpuCnEjwmRldBC5Ls8eGYnJ7Xcyo3ZvyFHRI=;
 b=oE9CVhSBvKwo0lkOxxPmaZXn6+t9q7MUJaVChX4y7m0V6LPAuOsThOMXTeWGMqWnKsc1sKexNQrQdvv1/9eRx7r3r4CH3UIu46Mwnu/29bQz4GdMyAf3a3ky/s/BjgMRz+GBfl8KAF6BpWFVKWqYQkN5GY5ap8H/n4UQEmPdIT+VHUbQOihE/Aqa+KV+hI5PTM0wiUezOnFumbKAcdKMeTKFll5CYqK78QlyA6/TWh30r+/xtt9QPO5mjk+JsGvuC7t/mZjEnKv1XjPpObK3DPg5pxyPjW6UX1Za5DGKdzHCKpmUm6SmRvRvhOz5+ExXNHAnBv3DBbXSU+tqSjGPAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RM7HY7PUpuCnEjwmRldBC5Ls8eGYnJ7Xcyo3ZvyFHRI=;
 b=jaY4iAhR4U/GfUQIEF3DdOhNnGtj7W3e5EotFrQyn6hTVZksNU1hCz09FjWiajspSZys1U6AXYmNtdswMdIlM1Lt0ex6HrWWt+EnTEqoHruv0LRbR3ReYDuaA7PfZ69IPC2wWrsaGATY7Cf/dbvOJl34v39G+rzl6RDpiCt48Mymq9sroBYsHMFWbusTOPE50fRVSxmPLSGnVZZcb1+fHgLuX7ngdzw2mwwvLCuK1jQXRlmCHw64GdRPKCs14S6ObkPDC2N1ek1FoILmHl6x7cGJ1GUCCN7IVjpE5qbdeBYNmJjeLO4/hKqlG8aTmtvSAUJWxSIVRV6RgeTJ5XIafQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1840.namprd12.prod.outlook.com (2603:10b6:300:114::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Sat, 16 Apr
 2022 01:33:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 01:33:12 +0000
Date:   Fri, 15 Apr 2022 22:33:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Message-ID: <20220416013311.GP2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215407.GM2120790@nvidia.com>
 <BN9PR11MB5276D64258C6C41C252C5C4F8CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D64258C6C41C252C5C4F8CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR22CA0024.namprd22.prod.outlook.com
 (2603:10b6:208:238::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 872594ab-1467-44c9-404c-08da1f49121e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1840:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB184065194DEDC22B2D0541C9C2F19@MWHPR12MB1840.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9Rzo2VQzcKD7d0GmavRRu1kViHnJtjIx2+Myc2QFRZ5s/dvzS4mai2v2X5Go9Dq10qxIv2dMtd3GVEm26x0uKHfuvRbCq/xuxu3VT5TncsysGF4hmDlqwTxFU05yAov6LRRMD1GuhuuOUaO373h+QnkAWVmIVMEqWvsop01tO4LTaU+Prn52ANyGsMqGsd+sOEVzTMOxUyNh2aGPDzbBTYXb5KtZCw49/ePXWYfi/lHIL8tUZB4fLiO1Do9VVJorK/gUf0V8plLZ4FgHv+IMIyvUBmNpqQj5Rt5ekwGM3FS/kL+7wUfhslbIL5eFZnXJWKMaQtVVdvoBWozLdXNBVdUo/sx9xOvqZvLUNIed/6xY+mqAIVRdE0L79OMgtucES6pFUugTVrVvI7UTWNH0/kjko69mz/EyjH9hyp7VoEXji9ma8PxCxLhvK+6qhfTjT93sk2QqHFb/q7Cd62dm8Alz7M3rCOWHOCiCmz7iQL9Z81Ap1cruVLTc5vAg1ZWweGvut6PnHYRXHyyGDNZyYyNCfYOTc0DspQ+hcolPyzIUIvPPntDDX10OjitWpcMRDsTXfFqfK3436oIb0KUTQVpKGXsIk4UOWLgRp68xpMP3c5SX+qwab73VLt+9/CVjKg19X5UrSmTU1UXiW1gTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(66476007)(6512007)(38100700002)(86362001)(6506007)(54906003)(66946007)(2906002)(6916009)(316002)(4326008)(8676002)(66556008)(26005)(8936002)(1076003)(2616005)(83380400001)(5660300002)(36756003)(6486002)(508600001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k957fTcWFyx17Yz4Zy88qveod2WItCekWn8yKijFAwiLKNXn9AJPd2UXQhHm?=
 =?us-ascii?Q?1Jra66YbgN6Nw5rAwDi6P3UuKLIQXaV84gxdjT9bh2dqqmPRTaL3PM4sn3sn?=
 =?us-ascii?Q?6AdTxD8UyOhdXjxcbAUz2Mro3iaXLjfib5UXxQX7nwzUfcZrqWUPru029XCC?=
 =?us-ascii?Q?Wrz2KmArGoeLPOgmZ0GSVWIVALeYNGMcNZe1qkhhVw/cVU5JO6WhywyIy58U?=
 =?us-ascii?Q?jVxcSClgBzfobpsOGAFuJJJf6El2w/1b2JXtyCvK+o2WuYhBte3FjKI4Ztfl?=
 =?us-ascii?Q?xpdequfgbtvPGLfYOjr1WKmoButbtfgeebV9lDg2f2epg71MC7W4k0Tgbnjt?=
 =?us-ascii?Q?GNglnpjhldxtX1rIQ8+FmmRk8IHwAaztIbIQWGJMHaJP/RxVj3o1/cX/5Ksu?=
 =?us-ascii?Q?UfuqMmBFwRhVQH8YQbU3yFdQoV3Pr17sVYUtMJNXDbdL9RQhpAI6xr7y47BZ?=
 =?us-ascii?Q?DJ4k5XhCqpP0mOZ1iy71dsvlPly2gUO0HCKr7+wHARYgmZxFdOD5jIiQVOlS?=
 =?us-ascii?Q?lC+Ex5dvDmkU+8SqRkXvlssG5ymNFxAyfSYc2XWF8TUgPPGfa5bTTNATprBV?=
 =?us-ascii?Q?2HEMy/wbSfIRrG4rE10sUC2RQ14JvEN1TR3nPoZeFktuGJJhBI02OeoLmDrt?=
 =?us-ascii?Q?ufkxy+0AyauejSViRmE2Q9Y3J9IaFs6i0bHbvx+5Qa7oghcxP2yMcdgHzy9C?=
 =?us-ascii?Q?pcB+yX6XZaY2/kkBxIQpb++MTmBZe58RdOG+3TchegKvO7fvdJWnUp/G3y0l?=
 =?us-ascii?Q?zXosR9OMrZHFUDGF0TZXouurs16NMGD43OInEHznI+iNrfPS1Z0Ho7iFPQcI?=
 =?us-ascii?Q?mPpF8iCYsXDTKUPoJpRRH6qiAxWOXemdC9qfCFf4/et6khr5bUzWcRvFcXiA?=
 =?us-ascii?Q?29w/+ISeT8Y65nHt8GWGOCQwk0S5LMTI1fBxYBY4oZp9TrHcRtaLndvaVdIZ?=
 =?us-ascii?Q?5Jo7WCruLSpI7w1evunDNz9OXrWger3zsf4qgLH6pRnHpRJP2GaVqB9FIoe1?=
 =?us-ascii?Q?S+eVK1MS/V1itBec21PQB2Q+b0lJ53/Y3DZn1SYG43c1mLkR4IQz/u+BKmYa?=
 =?us-ascii?Q?E/oMDtNDKMlftKe4Sd9aFpiv5r207Gaa/1J3IRzIcYRC865RTPfg+x9Lgyt6?=
 =?us-ascii?Q?LVQmCFEgI8F1G9n7548qcbY0VWBvMlpGuJvbdqhxXh+61QcOy3YFwgB4hUUv?=
 =?us-ascii?Q?VpsZZUHdqaIWU05a1XEJCSt4HDL4VHnsPAWredDRbIu9dl26B4nuOSPy+43e?=
 =?us-ascii?Q?NQYF7+Szn7O5Te4jbiaSKtqSvP7HC6lrqa/v09uPwi34K4e+M2SRjQo6g9R/?=
 =?us-ascii?Q?XW5Gkq+SWYWVG+6eQDlQz9XHWSrqhgoy7dSuBlzdnRh3Kb+3SpQOwZ0uUeQO?=
 =?us-ascii?Q?EKHp42/YzYfGxOKuMI8g8ns1b1B7SgyJZe+Q+GHzW3ixk4mlpEOhNlfd4IMZ?=
 =?us-ascii?Q?j4c8lUeMGwr5nolCLuv4Q7fXEakfb5n7PIbTnxIYYILvBY1qWkhDyOEa+SQj?=
 =?us-ascii?Q?4h0HuGQ36rmKgXi59+gnbyPZwKOI577EAO79DizVRemii+9CtS6S2hqkzBzs?=
 =?us-ascii?Q?xV9M2IK5sTNs9gHUPg+cGzzGnsefvHBS9RVr44edB/l6DJLvuseomyj7GxI0?=
 =?us-ascii?Q?3KyRXlrU4iCbFA9oEgrXRGZhpSNmH/x/Jm2BZ4aWEfHHsnZx2p9T5uBVFIb3?=
 =?us-ascii?Q?1ApBGC4YaoMamNknCtPc2f5UMxoWxSzD909ONE4h9w6fMfvmqL4wMvfXP5s5?=
 =?us-ascii?Q?oBQZzA0MUg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872594ab-1467-44c9-404c-08da1f49121e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2022 01:33:12.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5b8pNxcyRo32Z32Rbnq6+uoaXJ1l9r6PhsypsmHVESU85MpfMqkMVLYf2JUst9N7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1840
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 16, 2022 at 12:00:12AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, April 16, 2022 5:54 AM
> > 
> > On Fri, Apr 15, 2022 at 03:57:14AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Friday, April 15, 2022 2:46 AM
> > > >
> > > > kvm and VFIO need to be coupled together however neither is willing to
> > > > tolerate a direct module dependency. Instead when kvm is given a VFIO
> > FD
> > > > it uses many symbol_get()'s to access VFIO.
> > > >
> > > > Provide a single VFIO function vfio_file_get_ops() which validates the
> > > > given struct file * is a VFIO file and then returns a struct of ops.
> > >
> > > VFIO has multiple files (container, group, and device). Here and other
> > > places seems to assume a VFIO file is just a group file. While it is correct
> > > in this external facing context, probably calling it 'VFIO group file' is
> > > clearer in various code comments and patch descriptions.
> > >
> > > >
> > > > Following patches will redo each of the symbol_get() calls into an
> > > > indirection through this ops struct.
> > > >
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >
> > >
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > >
> > > Out of curiosity, how do you envision when iommufd is introduced?
> > > Will we need a generic ops abstraction so both vfio and iommufd
> > > register their own ops to keep kvm side generic or a new protocol
> > > will be introduced between iommufd and kvm?
> > 
> > I imagine using the vfio_device in all these context where the vfio
> > group is used, not iommufd. This keeps everything internal to vfio.
> > 
> 
> In this case although the uAPI is called KVM_DEV_VFIO_GROUP_ADD

Yes, down this path we'd probably alias it to KVM_DEV_VFIO_ADD_FD or
something.

> Qemu will pass in a device fd and with this series KVM doesn't care
> whether it's actually a device or group and just use struct file to call
> vfio_file_ops. correct?

Yes

> You probably remember there is one additional requirement when
> adding ENQCMD virtualization on Intel platform. KVM is required to
> setup a guest PASID to host PASID translation table in CPU vmcs
> structure to support ENQCMD in the guest. Following above direction
> I suppose KVM will provide a new interface to allow user pass in
>  [devfd, iommufd, guest_pasid] and then call a new vfio ops e.g.
> vfio_file_translate_guest_pasid(dev_file, iommufd, gpasid) to
> retrieve the host pasid. This sounds correct in concept as iommufd
> only knows host pasid and any g->h information is managed by
> vfio device driver.

I think there is no direct linkage of KVM to iommufd or VFIO for
ENQCMD.

The security nature of KVM is that the VM world should never have more
privilege than the hypervisor process running the KVM.

Therefore, when VM does a vENQCMD it must be equviliant to a physical
ENQCMD that the KVM process could already execute anyhow. Yes, Intel
wired ENQCMD to a single PASID, but we could imagine a system call
that allowed the process to change the PASID that ENQCMD uses from an
authorized list of PASIDs that the process has access to.

So, the linkage from iommufd is indirect. When iommufd does whatever
to install a PASID in the process's ENQCMD authorization table KVM can
be instructed to link that PASID inside the ENQCMD to a vPASID in the
VM.

As long as the PASID is in the process table KVM can allow the VM to
use it.

And it explains how userspace can actually use ENQCMD in a VFIO
scenario with iommufd, where obviously it needs to be in direct
control of what PASID ENQCMD generates and not be tied only to the
PASID associated with the mm_struct.

Jason
