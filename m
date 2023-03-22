Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEB46C4A33
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjCVMSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCVMST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:18:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59F9442CA;
        Wed, 22 Mar 2023 05:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CY0DElOamp8L9wlpzinF0lzas/AZAjy8sHB++U4ORXDjUIQO27Zljs8+0fdpYwqDaGfpZGwb/YrDv+cf9huiCf7hDnH5MapRMx/1i/Ey2QMT5UvMd4U6mbCiYi6huq5GhzQWPDlXWjO1zapRBAOOxmEfu0EIhsl52MVDLqcaSw6MEL/IL18xnS5UFkm7AQfOFBrjHV6ax1pMMkDcCSNPV23VPVMq2GfNNtruF/Byc0Emn4aoA3jc6mZclxwcET6kSedCKXgrZl4CNM2XwM+1ZQseo7/Y28m5Haw18gHXR5/4xoyUTcAog8RAIop8spCO702WiztaWHhfHgBiTXMLyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W17RT99oW4AltTfUDOZ2wl9KZ2h+4pYPTEpd/1aB838=;
 b=BSykMD+zgUB8rgNs0gre3dDnNECu5jMafn3E35fgAewVu0N5QB/K1hjw2xZyxpbFpZ4wjqiC91JTqy+Kmzp/3ND18xptnR93O2rwxe8d4egPPwJkazhQPLw+7fmoYQncC9DPqWrFJsvzv3qE4+Vns79SG1BfKd7VSSBO3abcs86l0j4oINzULlCQ0DlE03ZsQYO7zrjZkPMFRfRvsSKAqDHXW2yhV4KY9qRh3MhCUfLORQEAgUDoh0wQVtfmOfOCIQY+NyMa1dFPPVn3NF1hObDXegOZ488BOUUTTf+gCGDmPZM7unZPAZAB1rQPVPgoHUZWb8KQ1mXBhfY4IOcVVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W17RT99oW4AltTfUDOZ2wl9KZ2h+4pYPTEpd/1aB838=;
 b=nvDp+W64yQjq3hnpfyyaNxo/GdB3S75WHvB2fgvHdOEZo1mMW7FfJ81KKQTl7EyGfKoERnCpI6fgABIyvCooESUQZD0wtPW810R3BEQ8UQGgFRII3zABOObIrvSdpDXcBL0Mc78ULAbtwZR4C1Xr5WNwZIZcqK6r5wqTTLRnzH7fz0EqxTIaRxQ5JhFnbccwJl2m1LftgU8uKipuJcd7QfgJ021WTu3gcu+C4uUe0EK8Gylb4hM7BPHJJChslfat9nDY5fXzhpgERauw24U1+dHLyzP/O7eyNir9/sDmtqhI3K11SMOr93iFkVM3/ByIv6iJaUf2m/OsYgkZ+GwHbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5081.namprd12.prod.outlook.com (2603:10b6:408:132::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 12:18:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 12:18:01 +0000
Date:   Wed, 22 Mar 2023 09:17:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
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
Message-ID: <ZBrx98kqNZs3jeWO@nvidia.com>
References: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5081:EE_
X-MS-Office365-Filtering-Correlation-Id: 651c306c-5485-4511-4087-08db2acf7ada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UxlGkZOZc07Ge9ij8F5hVbV7DWyI5wcrZQDiUmx7mSUox2520Ykzzx3Tx00FK7d/NmDWHRifNimms5VD73R3E61cHmr0QAOF2lvBfNhaCHUoO9olQA8O/TAVuZqbRSFWeS+qvD2cn4O1BHQtbxoJPKASQ3iwlEz97/fkIMd3NPaZnIA9HAJXdBSDUvn8A9sOM7sMQwsMYfJcmNiFk8GUzFBLizOmsimCPkytyROZLwBtGn+7QfIW6Nk0qx66hscKLBlxHprP1BuW9x2iBqaTR7vxb/Ae4/r/ZzDkuPkcnLjvT6y5guJMPCFmY48pcvoqIp5v87otRmHWdCKq19hqoLE9kspeMOnDW/MUZA5MuTVGvL1xmN+6YbelTLL/evyVyVLk4er1Pf0SxwB/wDbetKWRJqrRIsgNUC9A2e0uTAd50y63JlyGAT5Kd4f9K1L9E9RP+xGqc3rs/R3dJ3gm0EjxBfn2OF86m//JMGZA82d7gkKOR+BSHgHes+B91unNzLt4LImvFuxxLrKKlXVR2IbU3WtzMnuFLNdrVbgCH9UNGPqnaQATnQVVXWrBP519UZnQe0+0GGr9ES7ny9uYiFvOB+9aEuKF07Q7fVhomEn0v6u+ycgkSjU7OQVWfmqRB0QXqx/IsXLSVu43/6sXjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199018)(38100700002)(6512007)(5660300002)(4326008)(6506007)(8936002)(54906003)(41300700001)(6486002)(86362001)(316002)(8676002)(478600001)(6916009)(66946007)(66556008)(36756003)(66476007)(26005)(186003)(2906002)(2616005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cjMXit2F7X/o/tnZC2sYtf/Cd+S40cjb1MS0gvWaXFtZ+BPbdaiwYRXK2rk2?=
 =?us-ascii?Q?KZYfaRnRX9ui03PtlWl2rgy7MrfsB+pBTz0jTBYp7GhqIqvjU20GmHQ7KJzs?=
 =?us-ascii?Q?m+ZqmGgCvZiuWScYIwWni7KTwNW/LM4Dc5tbqQr/Idr6FrdGpcYv9mXXapeh?=
 =?us-ascii?Q?rbXJJ1c9STBP2SIY17MwuxW+dsabY8t61FXA5ohfqPRReTjXCW2zJ3b3IWPg?=
 =?us-ascii?Q?bxFCZ5lnTJZrLspOreG9xVux5G73mh32XV2sj9UrDMyCGNO9CFV3VT0YEwrd?=
 =?us-ascii?Q?j7orX4IRjdAX6PHv5RbhSEHl0oP+NeUDT7u4GKgr8Ktni0K0WMN4ZKXnCAKt?=
 =?us-ascii?Q?KSFoyu3yNYRbUEkXWKe3N27Z8whj4ZG/NRsZJETbn13thU5dNf2FrbiIDW8g?=
 =?us-ascii?Q?+c3kw2zl2mDZDalu/2G5tV0GMJX53Sgr+omjhLAj41PSkyIx9wYx4oKa2nkz?=
 =?us-ascii?Q?nnZ8nsapRGf7dYM/t/UwhPjOCcmWMrrTYetdstwm2+cyH80Z+GPoMBzkwYru?=
 =?us-ascii?Q?MIK7ztLPqjmac/gql4LyMTQ8EzSV/LAd3AChUJ1JM//1ZUwgJYTExBpYfI9f?=
 =?us-ascii?Q?JUNS0/Kd5NCEXKuP9KeB7e1oME2oG0acj9STbCVIotapukzJq3Fc0VT+dbRI?=
 =?us-ascii?Q?1+LuDOZDb0PEKx8+AhVYkdfcJ8BtNlDRG22wAdhdS69fKunX6SvWDXkTALce?=
 =?us-ascii?Q?HIlsjjtx5QE9mKVCpZas3HXRWIvAezyi/fSaqTLPR6wYVex80R8JdB7Vq9eq?=
 =?us-ascii?Q?AL9do4pKG0u74ETQT91bSzazIbWMNGislYQSOSCbo0O9U23p8kii1hcZjutT?=
 =?us-ascii?Q?ScRw6ukbUWVUgieo5E5702R5W7k5iwvwGU2FWU218Y42+3o3IYWv/j2hg6Rk?=
 =?us-ascii?Q?9FLmbXoF64CznE6fVioFWA9WWSJ7i804EgpQAUO0HhMbrHoiQPlKdmL7kUPv?=
 =?us-ascii?Q?bRqlNiOGuamlFmWh1HdQZ5xQWfl2nInZHmx1ED699VrRvhB28wEJcB+qN9TP?=
 =?us-ascii?Q?kxMKziAzMGAHUQI3gMvVZGcJqZfGwFBQgbpVdyLcQMtiBEvWrPoYjUonzj84?=
 =?us-ascii?Q?6y/WuLAV38fZvbzGXgDeTWWk+bMsZVsuzORVDW3S5MWWiHMlPoCR0MJGU74j?=
 =?us-ascii?Q?IKIWUIBmHAOv+BD5l//sTnEQumg7IedR988BN+RmI+8Q9fJpXD0rww1Aa34T?=
 =?us-ascii?Q?feYqKDqtpYRzEuCfaYm/OKdVJ5KZxdWwa/d6tV8CSU9HNvMgEXnkUDU0Zb0r?=
 =?us-ascii?Q?lzbdwGNYv2utqav+7pKW6OpkND6yfNsBmaNTxglNKTqllTjXcBvAmpQIexQI?=
 =?us-ascii?Q?KCiyRtnBX23W7cAbPDIIC3qJOSATaYOFQEaEp0eIlp93ji4Y9HOJtJXbTKmd?=
 =?us-ascii?Q?1ZH7iAMyzH9t7Mb4IuYQcoNFFd7dR6UaNBt1I5UchKpgsaf0XHiIOn+DeJsL?=
 =?us-ascii?Q?6zIkFhyzue6F8cUk/7nPsX8OaGKIC96PVjb/zcQmKRlMg0YG2rrEaNgrCBhf?=
 =?us-ascii?Q?IjuCL9lPn4yHm3nDO4QA73RCEITOJXyoE9ccPTe53hrHsIbjOssBmeJvcH/i?=
 =?us-ascii?Q?ZRX7hJi+NDBJVaOw+HpbMilFRv8XvguLZbFW105v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651c306c-5485-4511-4087-08db2acf7ada
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 12:18:01.2808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hevn6DjFDrlpb0n+qqbe/rZ59Hey0KHyqOrYqkQql5ZYUkIhjIUsOmw8O8rqeWtg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5081
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 08:17:54AM +0000, Liu, Yi L wrote:

> Could you elaborate what is required with _INFO before libvirt can
> use a FD pass?

Make a new _INFO that returns an array of dev_ids within the cdev's
iommufd_ctx that are part of the reset group, eg the devset.

qemu will call this for each dev_id after it opens the cdev to
generate the groupings.

> > But for the current qemu setup it will open cdev directly and it will
> > know the BDF so it can still use the current _INFO.
> > 
> > Though it would be nice if qemu didn't need two implementations so Yi
> > I'd rather see a new info in this series as well and qemu can just
> > consistently use dev_id and never bdf in iommufd mode.
> 
> I have one concern here. iommufd dev_id is not a static info as much as
> bdf. It is generated when bound to iommufd. So if there are devices that
> are affected but not bound to iommufd yet at the time of invoking _INFO,
> then the _INFO ioctl just gets a subset of the affected devices. Is it enough?

I'd probably use similar logic as the reset path, if one of reset
group devices is open and on a different iommufd_ctx then fail the
IOCTL with EPERM.

Jason
