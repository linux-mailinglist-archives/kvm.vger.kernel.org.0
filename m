Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46A7A4BAB
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbjIRPUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjIRPUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:20:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDFE1A6;
        Mon, 18 Sep 2023 08:18:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPgzibipDRQAxAXLb2/xTIEZz5XR/yiTnvAMd/BQ/AIpmLailGvaMNtMbFU6e/9gXTpgFdAHyZ+Q5LO10/urGRisPaThoL8nyEHUFtIvIu5qYtNpVk6fxor96zIk2XJMnhnOXcTJJNp6aruk0xOBjNU07sKoCNjzuKy9BNxmcWD1PR5gMuIL+zhRW2Iu20q9eEHVTDXcYCKI1stfivO4flR3sz/9ZL0/OgbHKKxIFqy6T3AyRSHin8919Jcj2S0HiKxrSo3OKRjeXkQehMzRlUUqq9X1r8IOVF7Or+MqE9bHGiYk63Nby3Jge6cGu9zSTSkOUPZ4Bf9iyiQCcYMJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1QXsSCqTjeUmb/ayOP22JMSVRGDB5g2Oe20VEmMZHs=;
 b=CidkoajLQAmO++SoC4iSZDl/OTuaA03xMGrTBSyskebE+1SQR1J5IrsIftazIS5UQI63lYNwgNMbnOBaJYLUPpaMLMyEtaUTlcZu3tGubPm8krNU2A+gaJ3YoFdneuG1otUCSifMp5L1hh1LZXS2ry3iguRGwn9w6L74Qtu37sOmXthBsgr8QirammWk3jpUh1HHltx63PQLhCEDt76fXxsBmNqq8E5tCDrRHuM6beK0EpqUNkEmbiFBwKbmjHr4ru2mYEgrILfI6CZcy84u0u0zahFJrz/1rUkNYLdarwyjUCLVH579MpTn1X0UKQYkO0qgOY5bh8S2YBoSqwMNCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1QXsSCqTjeUmb/ayOP22JMSVRGDB5g2Oe20VEmMZHs=;
 b=o7C62ZbxZZctqAZs2XXOPbS2cJuRqJRqupgQ2NWWh1KG5sTQucf/yUOys2dSRa0XvlMbyWeH/JVTzB62pGz1lToCbAhkE4rwY0tIQHKZgWWcaAo+rjeG2A8SMwYs6Ph167atOCqX0Fy6jjO/6G9PjAerH8BkXxSZR4AD6iFWRc1aYV3rYYXKp2nb/rlOqBguKgUegqE0aFr+RhOx6zHjFafHOde0nW8x4P+kR2TTnJbLuZvruq3S7M0Vmo38esYM5oY/SFYB8z/XmDd+Au+j4jiFdjA3BZ3/eQKCkzkmIdGVQ8AxiNBHAKGA4L/M+GNnkyLZlwerV0aOtPEukHYxkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV8PR12MB9357.namprd12.prod.outlook.com (2603:10b6:408:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.24; Mon, 18 Sep
 2023 14:49:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 14:49:24 +0000
Date:   Mon, 18 Sep 2023 11:49:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230918144923.GH13733@nvidia.com>
References: <20230915025415.6762-1-ankita@nvidia.com>
 <20230915082430.11096aa3.alex.williamson@redhat.com>
 <20230918130256.GE13733@nvidia.com>
 <20230918082748.631e9fd9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918082748.631e9fd9.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:208:329::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV8PR12MB9357:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a1f7219-3d1e-4991-ffc3-08dbb8567342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOKR4An1j7aGPeaumm0bEPCSirf1dPjn/ZXAM7jmumBa0AhQ4Y5uVXSZLy7OSx6V0qqLfPJzhfpJuiZtoKQZpQHNvKQI35Lj1ZJwSnU00+jpEj/sTWb+RU5r0/2xewm+ecvXMccBIbAjufrO0/dtUl2pa6qumC06IQqHjNHEXTmghYU2XNK6cKyD53dAixun/XKaL3H5AK2HlKybA2y/aD5ENiwwrdkA/ailDXxnXUHlwgmRh2DWsl2tEE9xcNHAGFIEiCKEfdTLJsyo6qWI9eMwGzhcWZdTogdNdUWnzkA8kggNFQVZn585iU6vOO2nsTC0eaM8zpbTU95SOJ+kJFTbcWcfdXR/ezBf6cyB0YbUQCUmkv3FXLEdw/2EAAUM2OW3EItscAEAfPeo/UKFpXBioyowXfWNtDLlx0E7o83uLRaDIspYSw6CUV2lKIsb8R2baO2eHhU451PbMCCRdfyE1dvPrKVec4+7Of+8HMVnZNwSWxpZmegCgDzMT+A0838nyObjQ3aSD8EEHu5asGxWC4AKfcBhg+xQNXeuP5VWZqACSqUI38/KmCkuPGb1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(376002)(346002)(1800799009)(186009)(451199024)(83380400001)(6506007)(6486002)(36756003)(86362001)(38100700002)(33656002)(1076003)(26005)(2906002)(6512007)(2616005)(478600001)(41300700001)(8676002)(4326008)(5660300002)(8936002)(66946007)(6916009)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AaZjKIP2/YURX5Xee9o+235ea9LWSOzWgt5vV+IT9dwJIP1uNfryuIOzVs8N?=
 =?us-ascii?Q?6kT5W2M4o2Q3vWYfYnjpEnKbIkDcPAAzmO14Uocy9D1uwDuLY4YrhoK9F6ls?=
 =?us-ascii?Q?3yNk1Mc2z3YfxG1y+t5hbBwYoc9WGFqJAlqhlTSiCgSdPPVLxMXgcVXdsPM7?=
 =?us-ascii?Q?9Iiv0Nf7SvkvxlVmWQDTZPmd7GdiniaQvcKaXmhEd0tWZyYGou6xkQByQ7sv?=
 =?us-ascii?Q?Cc14lExsITyNUf7512T1Spb+9/yfl2rNBxDRDkbqxiFF/oapgNY238DSfTVS?=
 =?us-ascii?Q?9MHju1PhYZKFD/nmWg60n7iGkzXe0Y/da914yJKnZX9CkXNmcZP47A6nBHYV?=
 =?us-ascii?Q?uJvD8BhtV18KsJoQqNgfLEKnks/hVsLL/6Edr88os3qou+Nv8RHmW6o1pzdM?=
 =?us-ascii?Q?P2AmJh8Os46IJIkIw7Vvw9DsJ6MmhUKnTdIMMMgXKlvxinmzFVrNXq8jXDO/?=
 =?us-ascii?Q?N5uJJtveQHGcTcgKPZJMT9Qmj0kkPXDXhkJsicPcJth23piHI10J4JWl1ECQ?=
 =?us-ascii?Q?Jk5LfxEJVjD/hx61oKjraNxM38sA/YGeFGKUeHTCYovvmuUWe1+4REW/RBgd?=
 =?us-ascii?Q?/JFu+PSA1dEhN9ejIkJi/k0SRxoNCzM+cjXsVG/q//JTcD0wA4uNrDruUl3S?=
 =?us-ascii?Q?t0/w8qSau9eVw4fVy3f6NTTMDfYCQqTltEMu3Z0YuHMNh/3bdRfpxqfzrVOj?=
 =?us-ascii?Q?ptF0oiBxTsf9Fs+6tCVsKkM0ZJ4o8x9WqXcjMX9HHRJmZMGf9eYrDdMi8Y8N?=
 =?us-ascii?Q?OtF+8pF6rFGxSUmS0emgcDPT7h6asvLyWddbFupPJ6CbESk00zgMvJMOCcck?=
 =?us-ascii?Q?ib7b5WgVomRcNBqjvs+n+yeEUKmDAn6FoG0NVDZhd26q2BvTIpmnYVgF6Gn1?=
 =?us-ascii?Q?T0Pbkw1ILPm6dTMjFKVnJA8sT4ABKkXcMPxgBc5sTcrMPcfXmICRSq18tyct?=
 =?us-ascii?Q?bMTasT8p7E6AwEKPSyFs+sh7Yz9MUQpj7Y6adSgSjhxvJUzrA+bo3J+GtmXY?=
 =?us-ascii?Q?btZHvDBN+/DkSRan33saVx9Gkr4u4l29RpoUTXkNXdTCvL2B5Gm90PZqRQza?=
 =?us-ascii?Q?FYlkegoIHVF1+akOIBa7zyaXboi9rA7ytT2at826PKuyVdNvS5UR+6k7UYQY?=
 =?us-ascii?Q?KClN4YYMZn7q5YT44sgJrxMyklUjvPlrvSXUDKOgqTojNh6ffH/+01KQUQCu?=
 =?us-ascii?Q?Zttc6BuNPhGjWbyQONJxh4EJIopqiNoV7An1Shmspk8ZkG9cAZuhWrVW9o62?=
 =?us-ascii?Q?9npTvCw2AJJTHMWlG1p1sTjs8xoU7NiaNaKyCUMxKJKxiZXIuWmQwNAEkRNX?=
 =?us-ascii?Q?7CgW629e5RamXQB5x8lRL9sydfKSd0HH25I6+Kj4Hgn5rw8JXqyO7q1ZxG6x?=
 =?us-ascii?Q?deP5+Vpm5r40N3xXnGUi+QTCK2ivrTfyBmwZJ3tfEpJge9hrsc9h81BGPuik?=
 =?us-ascii?Q?y9y50gaqsRH6cjxISh/5NBTW2rk+cbmJS9yL9wxuf6jGUkHtv3pnn4L5b2eC?=
 =?us-ascii?Q?GE4rnD44pIU1Gr19+khH1nNtb0adUkqsUraq/Mkuskpxs5Zbr4IyVAhO3gXc?=
 =?us-ascii?Q?jBKXJ2aQKfzskY0IAcecB0BW/sWjSoJ1s1/IBVDh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1f7219-3d1e-4991-ffc3-08dbb8567342
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 14:49:24.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: me4mUtKHJMzD28WJAe/gP8urccus0LBOwXKONXjfjWqqQCEIeGn/czqkt+/QYZF4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9357
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 08:27:48AM -0600, Alex Williamson wrote:

> > > This looks like a giant red flag that this approach of masquerading the
> > > coherent memory as a PCI BAR is the wrong way to go.  If the VMM needs
> > > to know about this coherent memory, it needs to get that information
> > > in-band.   
> > 
> > The VMM part doesn't need this flag, nor does the VM. The
> > orchestration needs to know when to setup the pxm stuff.
> 
> Subject: [PATCH v1 1/4] vfio: new command line params for device memory NUMA nodes
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> ...
> +static bool vfio_pci_read_cohmem_support_sysfs(VFIODevice *vdev)
> +{
> +    gchar *contents = NULL;
> +    gsize length;
> +    char *path;
> +    bool ret = false;
> +    uint32_t supported;
> +
> +    path = g_strdup_printf("%s/coherent_mem", vdev->sysfsdev);
> +    if (g_file_get_contents(path, &contents, &length, NULL) && length > 0) {
> +        if ((sscanf(contents, "%u", &supported) == 1) && supported) {
> +            ret = true;
> +        }
> +    }

Yes, but it drives the ACPI pxm auto configuration stuff, not really
vfio stuff.

> > I think we should drop the sysfs for now until the qemu thread about
> > the pxm stuff settles into an idea.
> > 
> > When the qemu API is clear we can have a discussion on what component
> > should detect this driver and setup the pxm things, then answer the
> > how should the detection work from the kernel side.
> > 
> > > be reaching out to arbitrary sysfs attributes.  Minimally this
> > > information should be provided via a capability on the region info
> > > chain,   
> > 
> > That definitely isn't suitable, eg libvirt won't have access to inband
> > information if it turns out libvirt is supposed to setup the pxm qemu
> > arguments?
> 
> Why would libvirt look for a "coherent_mem" attribute in sysfs when it
> can just look at the driver used by the device.  

Sure, if that is consensus. Also I think coherent_mem is a terrible
sysfs name for this, it should be more like 'num_pxm_nodes' or
something.

> Part of the QEMU series is also trying to invoke the VM
> configuration based only on this
> device being attached to avoid libvirt orchestration changes:

Right, that is where it gets confusing - it mixes the vfio world in
qemu with the pxm world. That should be cleaned up somehow.

> > > A "coherent_mem" attribute on the device provides a very weak
> > > association to the memory region it's trying to describe.  
> > 
> > That's because it's use has nothing to do with the memory region :)
> 
> So we're creating a very generic sysfs attribute, which is meant to be
> used by orchestration to invoke device specific configuration, but is
> currently only proposed for use by the VMM.  The orchestration problem
> doesn't really exist, libvirt could know simply by the driver name that
> the device requires this configuration.  

Yep

> And the VMM usage is self inflicted because we insist on
> masquerading the coherent memory as a nondescript PCI BAR rather
> than providing a device specific region to enlighten the VMM to this
> unique feature.

I see it as two completely seperate things.

1) VFIO and qemu creating a vPCI device. Here we don't need this
   information.

2) This ACPI pxm stuff to emulate the bare metal FW.
   Including a proposal for auto-detection what kind of bare metal FW
   is being used.

This being a poor idea for #2 doesn't jump to problems with #1, it
just says more work is needed on the ACPI PXM stuff.

So lets remove the sysfs, reach a conclusion with the qemu folks on
how the pxm is supposed to be modeled and then Ankit can come back
with some suggestion how to do auto configure. If it needs a sysfs or
not we can see.

Jason
