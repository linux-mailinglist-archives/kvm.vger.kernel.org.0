Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7466C1D9E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjCTRU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjCTRTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:19:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A621422E;
        Mon, 20 Mar 2023 10:15:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljjUiONW8vrA98b9Ayi+vfRWAK0bN22TDloeKBlwxbT5r1B/BdE4wCmDiJjlZIY/7COruwEa0LSUlYouhAY1UFoivSz5YdPfoNhydU7ynn9tuGipTdr9vvsQfX8qe41wXDnfmPvWoSJglnMz6IScIR5cuprG1XsJh5+/Mu6HlRdEajjYjcYVXq7N7BUJxAEr4hogZFLLW8Scz9929p29INY9cXzxedOe12D+MdEt1USVkgtF8FnS7E6XgEAsYgi9doqwyKA6mjtIU2ZpZaGPoaNrmf4BrROCOdABuPw4Ov5SututlyQXj/AEB2P53+ebAq5TCH8R681xa5+++gZBxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9loZ4nggrQb1BSTDJMwnhxDAHDyWAI2hqAUQI1LX+M=;
 b=OtbDA1vSYwGDQyuYebcu/SmJ5kg2u5XL0XpZ1auIB72ixmRNw62FasUXE/wlbznuje8iaUXpMC0vxcxaGgSBp8IqlKBxPH9x52CwPo0j90LNqtAEcXA0UgNwa3ZNgYVpUK8kPv1LQNqgTwto7an2uJa2dEfziPLXkx2r9gK6KgrO2dZb7C5r7DiPbMDbqWvv+FPGg3KkSjvMpaZtEUM5fD8cbVB3AI1hgFXG9yBxOvMUkICOI3daJOc3MPgCjzG9zgXypMaG0ItKP3JhqJS6oMp/aXnqUlFqxHgsKzQnO8xeoFSB4UMvylPlZNmiyGf0fX+mnp2ZyOL7GawlcnYpvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9loZ4nggrQb1BSTDJMwnhxDAHDyWAI2hqAUQI1LX+M=;
 b=obzCLIwJC1n/isW562R2AqN0x8MgfEGs2WBOHFvysB8zMsNraMQuSXlcm4+0UoGod9OuM2SIlyMEXmcViHWsn2GtIZqJ6KbLgdUJB02LhZdRFRxfGSGFDM3w4M8on1SP6/2Q69cfsuO4JN/spNoHpwtoLjoG06QMJBhMz8UqPA6+vUItQ3/BkmKLmhu18ciAqwEUQ3RB3NkHojNY86bg/9YcW7d7qUp++lD/J5zwbaeDHQMQQatuS/W0fJebDY80BQhz4ca6A7BGm6KyLXbAfaWrzrQZRKwWbjBVhGM1Y7ZaH/BRAgi9VnPX/OoGjKcFwAMX/Y5shOHh1VB4yPYMow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:14:49 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:14:49 +0000
Date:   Mon, 20 Mar 2023 14:14:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZBiUiEC8Xj9sOphr@nvidia.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316124532.30839a94.alex.williamson@redhat.com>
 <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317091557.196638a6.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0006.prod.exchangelabs.com
 (2603:10b6:207:18::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: ade8917f-fef2-4388-5839-08db29669c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0GnKh4ZzSZ8V2d6y2cazpil760eeOLCQ8xf4uZtvHeZq5h2X1XYQoSpOyS+RAWXulTTlyPiG0ReBaGprEcbV2y1HFNDzRVi7NgjBSWGAgWDxC/Clz2KttSD9gBwoWZo5M+y1w8yMtVmw4fxj/wuKEdACvvYIlj1No0fhvnxbmVkW+Q5zHDM/vgC3XbjDF0CJvhpj3U9WJbd1wWx39jccBNYVDq48bMqV9zpd5GfO3yG9ugGTzxDSLZWOSgRHFu4NVqF3htWOCuZ7Y+vw1i09avEDSoz9p/0uclRQpmvKEjtz821TcWnztPSymQAfYttfCtkTq3DlfO3LGGqPazMoskat2gSawnreNSgeTsp7+lfIww26jf+NQZuyxC90NzBig8Gd+cgB3b/DEmfesTIbLMqbDK+T4tsRDh7iKUwZrhUAXLNhkFlgiSG028YBcjSzkujXeHvzQWnlLeBsW5RZk6hlKrX5aDC3N9WLFogUaYXEOKOeHnXmbOlCk3YwUd7Jy3icONgD/efPSE+eDS5nfsDgbJp3c62umjhRSBmVFCOvw+tcTO6HMYUWbVPaqVLM+g+EGiMAvu03vUPhErfhh4nEa+JRlaF4twVfNDzf/OPFFbL+7haqIE3K6EfnnW4+ycjrEDNKT1k4f4AJxgIAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199018)(8676002)(36756003)(6916009)(4326008)(8936002)(66556008)(2906002)(66476007)(66946007)(7416002)(5660300002)(86362001)(38100700002)(6506007)(6486002)(26005)(6512007)(478600001)(316002)(54906003)(41300700001)(83380400001)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f+bqpHY//2T9JJMWvpxgAHH66CPYwgPiisGr1GFpKNBJABXcfJlwucqWKfwQ?=
 =?us-ascii?Q?NxmJvWbdiMXvm82iyZWwyl5Fqr1uuCpzFS02wvuxyZ7+yczY51lInujRH8Li?=
 =?us-ascii?Q?MBS5bxXmd9ShW1y32V2O12NoBnYpfVPRhehkd/v4ohUPGF6h9SkvaHirW1yw?=
 =?us-ascii?Q?ul0KmP6wN5l4XRxt3aM0URGnpZowpG3NCOiuWFsJFCWaRCq+iAmTf/yuwLfy?=
 =?us-ascii?Q?Flo3tRsTOzKpKKDX3Zbobp7qeqQ+wqLQ4heBCGtWugW7nlZ8q1xbw0QTFfCW?=
 =?us-ascii?Q?6xuF38/BBgDUOqmFY98hYL54K2shK+98ZAR344PtGOZ/+A++IqLpVDvHnJcT?=
 =?us-ascii?Q?TMI9bXUJl8drRP7kEBwwW/i/2lsTJwgKsdsqa17EcqXst/uolAbVAXYKPHc0?=
 =?us-ascii?Q?h6n8rzKLyQxaYa6Qkma8rUnHwPPhOcGah0vDIsH63Jr9lPB6i69aSKsmgBXd?=
 =?us-ascii?Q?m7vaYmgUiRB/Ck8nh4F7UY3lEmAZs/kMHKRT6MN01TNAH0ksjOfiaUEQBd9N?=
 =?us-ascii?Q?0JpWytObP2s2odcNI+r4KutGTXoum1AaTHAXl7jDgNJi5xqZwtOOkEInGRXT?=
 =?us-ascii?Q?3icfwvvMlk6ZdFvsqtKdj2pQ6FQRvh00eNGQxqL6IQ4lKhEA83VJ2hYrHBTN?=
 =?us-ascii?Q?WIjFcy7nqjn55rF7hjO3W4hbV13GsruDALbwu/cSA9lDScVVNcAAEwxOwUq8?=
 =?us-ascii?Q?s/IQd05R3WBGhZkxyDXcIsUX1zsUC3B3BWniTi2rUxwC8RHe26SRWo/xvrtg?=
 =?us-ascii?Q?0d2ITiPDSmQFnBfhJnNmy4ZWCHzJnZgjCgbRhLWEcGqemDF13ugAC/5L+izC?=
 =?us-ascii?Q?Agz85dMfhf7q1+0LR8hKCVFUcPjId0RlhDF6Duh4XYIEwN4zEBIUL4ppRUSp?=
 =?us-ascii?Q?++3MOf2SG4bTYLeANgIUsLP+S0Mt0KwUnkw1F8TK7+RLyKhhd8pQEoulxds+?=
 =?us-ascii?Q?QYEYF8J8S1mNrOUS/oaP9gybydKt7ez3+FYZlN/seQmP/OYffgUCJL8nHcuq?=
 =?us-ascii?Q?eKOk+BhaQayw0DPRyPk50UsGKgc5GiWapaAmMeBQKxydBPgAfwVTPx8Ze1+x?=
 =?us-ascii?Q?G3NNiYmErbE44mlfcBXmQlkKu1/Tvp7GJgH6OomMvfFouXtwFVhOTrhoAJ5w?=
 =?us-ascii?Q?1gS0ysahzAXayeO0XH/C/R9Rvl0J7iJK9IijpAvT0NffqWT+peofV0PUs6kR?=
 =?us-ascii?Q?xvaYvTmmxHA1O1TZDYMlGX03CcPFUNezIV0Pz7bSWD087nDroPPbkNbxweKY?=
 =?us-ascii?Q?6Fz4s1XCDgvl4L5rnCYqBNVhfkhs68n/NrEN81mLZD0aTtR2zfhHg6X2Yy8z?=
 =?us-ascii?Q?dkjYPsmQYhCprKk/S1H2onyYYDP8PxDp05wqwH3S1pqoF7jbvl+vclOhrnz3?=
 =?us-ascii?Q?h7xRBgCr5sKVx8RCy5hLuQK0cK6o/xaByOiOv+Daejl/2xGE0RBM6dpKZah2?=
 =?us-ascii?Q?ImUsjgDxsREgHGZtEOLizSmSWeJwIa01LAX/c3JLH3HL7VpN1Cvz0XiXbnrF?=
 =?us-ascii?Q?5wEaxXw//BYmSw3jWY+gH7fJF/0eDj/c1hJsaGKG7M0Z+L4oJNqZ3pEaO10L?=
 =?us-ascii?Q?kcXoauPOfWQCSkDsxnMqKpCDLr4za8Q7G4k8fxuX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade8917f-fef2-4388-5839-08db29669c65
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:14:49.2378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g69cPrTXI1SeF9pXdf/iMxlymiDdmnoj8ZBHCKbqym6cVShQU/mGwea8aXsonzlG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 09:15:57AM -0600, Alex Williamson wrote:
> > If that is the intended usage then I don't see why this proposal will
> > promote userspace to ignore the _INFO ioctl. It should be always
> > queried no matter how the reset ioctl itself is designed. The motivation
> > of calling _INFO is not from the reset ioctl asking for an array of fds.
> 
> The VFIO_DEVICE_PCI_HOT_RESET ioctl requires a set of group (or cdev)
> fds that encompass the set of affected devices reported by the
> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl, so I don't agree with the
> last sentence above.

There are two things going on - VFIO_DEVICE_PCI_HOT_RESET requires to
prove security that the userspace is not attempting to reset something
that it does not have ownership over. Eg a reset group that spans
multiple iommu groups.

The second is for userspace to discover the reset group so it can
understand what is happening.

IMHO it is perfectly fine for each API to be only concerned with its
own purpose.

VFIO_DEVICE_PCI_HOT_RESET needs to check security, which the
iommufd_ctx check does just fine

VFIO_DEVICE_GET_PCI_HOT_RESET_INFO needs to convey the reset group
span so userspace can do something with this.

I think confusing security and scope and "acknowledgment" is not a
good idea.

The APIs are well defined and userspace can always use them wrong. It
doesn't need to call RESET_INFO even today, it can just trivially pass
every group FD it owns to meet the security check.

It is much simpler if VFIO_DEVICE_PCI_HOT_RESET can pass the security
check without code marshalling fds, which is why we went this
direction.

Jason
