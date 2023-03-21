Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6296C3775
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjCUQy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjCUQyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:54:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9B619118;
        Tue, 21 Mar 2023 09:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efzzH1zH/z3J9aZIYPZHISOihCZy33noTOyYFQVcD16IxL0I2KfS8x7eE6Tdj64aQOrz0ehMxxCfnms+s+Hg2/LrMuAmW+VYlzw0rUmesbChRSjaMN1Fv4DY0zj2nzA81upLSNZNQ+JA+f3jiLNu6BDot/1pLSZPaDs3/HyamvEJ6YGeSWWNBJQqV4cMhskGmgHMtktebniM7bUA5LKYwcuDkkW+10VPt9xzOuCjMEyPtKrNeYmwxkdEr/E56sCkHiVVIf+4xXTiHVdMgI2ba0rshrB2YO3JCD6wr4nOqHmEx/VmG2ed3J97BOxwAI0G4iQ5zz9A9QFGy2n8vLlXCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAhg3amIvrYTxU5QlQ04IEmjo8vKGh5GOM1JBxcJuo0=;
 b=KwX6WHxkkix3rj0RjjJQ9IdhhzE73z5VIFqjMU8sy5yx9m5IcqVjWT9xt+SaTl8pvKC2TFXFNah+IH+0XcH/uoRHvhxKmvEWicpJ3FxNbTVjtMaR394R0n30hzOQT4p3VcMqPbBF8TaT4XlcrjDKJafg8TaCTu+CYy5DjFAz+b1dUvpQ1FSLr0CRo2H0fDsYoTsUklyunIpkIsZUYiAottOjmCqoXM3VUsB5lMQNvNrkxHuTV7m/VxVpjdLWAKmaYuXi9cn99lKaAF0DEWAapxORF/mJ56psXq5q4TZCBGb3tQL3T/O7my8nj+APeE5FHefdT6RhU59K9bsjO1Ftgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAhg3amIvrYTxU5QlQ04IEmjo8vKGh5GOM1JBxcJuo0=;
 b=pVT+lqDiEJWyrjetuqASBOZazS5075JotOzDdSqu3HKm9cDUzYICUkdtoY9R8mTVatdbH2a80ysnwl6/n7MIQFngNYcbtEcPAxjYVhiRxHHO/UzUCegzskgpyv1eb+K5KBaXwatWTt76hQ245Wi7V7Lzbhcs5vxawehpLzc9B3Q8Yu90FKIJb2zQDl8fnBOUugcvCcWaKzEDEv9wP+J19pKVjpXAEXrwn8qk99dxCLBVTCi8qC9y8bIUodebWkMMH6cQ+9wapeSJGjB2a5c+tr2T4T2v8FYeTsCUMLBfcucWFt61myf1EpQ7BKZJTUIIdplBflWZBa4ozDqsXv/T2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 16:54:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 16:54:46 +0000
Date:   Tue, 21 Mar 2023 13:54:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZBnhVdmts1BlAiH1@nvidia.com>
References: <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBmcbMuE4lyDIpT6@nvidia.com>
 <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBnB/mOIvzYEPdsj@nvidia.com>
 <DS0PR11MB752959B246705258EEC4109AC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBnF+6mestV2tCiQ@nvidia.com>
 <DS0PR11MB75292A7271BFF456B275B4DAC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75292A7271BFF456B275B4DAC3819@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0043.namprd02.prod.outlook.com
 (2603:10b6:207:3d::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 6162ed36-a471-4478-9f39-08db2a2cfa0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rc3Hnnn/ioLVXQwfP4BbXOo83iXDH7P6AgNIyHhWV4yBIQ8mkroJJKGqnrfV7ApSIqJ8AIL7Y4lBhZPztWaPKsLXBJsL9q9E6/1xuBCG43ZGe2K+ronkd/G9Q7vPB2b7jxaI6SmTzh1RUVEu4Hm+tB2bFjqWQLYgFVPQa+VA/8gJVOd2rQTuzo8z/ef39+RfUnhht4ja6LaHCH1/oXB6Ru4LzsZ1xuvHDQ7X7iSqG5uuqzywL/ETHsrZXxybudxb1TEPKolED1cCr1ctSpmAOVGrrI96+f8rgD/wrphbxUMoaImSKkJwU+l8lr5aZMIngmfFNEdZGlIlusP59FY/ie1syqPrKcRCBUq6BbRCqpVaWf5ckeWus6zJ8OeGAruwguSmmMMixcpnlahrEFFAjiuHxXP+JBHSOUKT4PokJWii+FXH27NmgUTqvH5YhSpcuKsBNtyqQzeRty/Y6G9DrxlVxfCLBYIbuaDAkil3QsjLy8SbU8X0uA0EOI4twXsXWAAdL6A1679y4W8p9AtCJux7toE3wknwupWYfiJZ6BX1w47PGfTlGs2B2Jykz/uJ0/cPc7nluz41BDNCCooZQUE9S161m8lBs2Dtqs9jom0GFXbUtbJwzhzx65pQ2lZwM9jaAsHaoL4mptEU8KAOyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199018)(2616005)(8936002)(6512007)(6506007)(7416002)(5660300002)(186003)(66946007)(478600001)(66556008)(2906002)(66476007)(86362001)(6916009)(4326008)(8676002)(41300700001)(36756003)(54906003)(38100700002)(26005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QdWC3h3Wjp+9qpDG0eLGEwlhMAHmbgKgA+dfHJHYzcmgCRlD9QxN6tXrJ3SS?=
 =?us-ascii?Q?h3iwqcVEJHZPlyb3+TY3YQ2d4xL4akpno/KEXsgL0bzhY3uNP/8Oba24BBGx?=
 =?us-ascii?Q?KLKlviQPU0EO1C02Co7RS2+Pgp5dVStftWsJKa8DPKWr1QdI1SWzWxCKaAPI?=
 =?us-ascii?Q?8EHmFRO8RTnQ6Rfb3ret7JGrnBggNNeGl9bPcf96Ohyaw0PlVMZKueNm086n?=
 =?us-ascii?Q?0WJR+HHZIFt8v0IG+vEvQ+0vqFOTlrlR5vL3k3wQ0tC40Nau4NG+MqReGJFl?=
 =?us-ascii?Q?9CQvZW6u4Lxsja4YEvShY4SHtnixwAbHIbsxyprXgqBa64Z+YjGnrvzzXKLD?=
 =?us-ascii?Q?nyAgxQS3/FOpDmuAeDgTQXQ+PsMMPCHAMss8aP0gTkjjkixb70FOgYrJOa5H?=
 =?us-ascii?Q?VToFX661QW/4pOh7w0D6KSQ996gdZFx9YvOnU7GnydMChan89+nShg4sNmwg?=
 =?us-ascii?Q?zl9V6Dk8k1mxeFg3YN2iXUquH70ztgSr816/qD28EYI1YwRstuVjYhaImKJm?=
 =?us-ascii?Q?/Kk8lWoV9cy5kbEToviDxJNWpsOYFQkbf75li4jlzNbagA3iITV/OcH9AeRs?=
 =?us-ascii?Q?FW8PBMoArw4eGDz2kAxn9PCECZaCJWatiYP0BxEA56UJ7PQRhcjUnU62jIs5?=
 =?us-ascii?Q?v6slT7RfiCHkWpfwNscqJ9oDMFxcTkg9AIMOYaGDCHUlSmtk7ymkzyw5hDq/?=
 =?us-ascii?Q?+VMXpUoCVyjaSVlxJ2+rU10vWtsPvlS6OPqNYmyxz+7UR1tBuUpoy7iVsxh3?=
 =?us-ascii?Q?XsOg0xxqoQaBQ+bPcnej+WbEGMGMQqzeWIEaq+HHlVz6Wq2JuxbRkWoHNHS6?=
 =?us-ascii?Q?/uqOjXehOn4rZ2/i7Yv79XZsgKyyziSSaktHI6jhmL0PoUNdOVmt3iBBe+/G?=
 =?us-ascii?Q?5baJM167p0anj8KlWUS9DNpudDSMlthpkYNpq03vNt9nzebqAjUcBRmc9clt?=
 =?us-ascii?Q?w5EcOVxyj+DJG/7odIZazzbxC4fEqfnOPOLImOGtpK0Or1AcpT4SG8xZitxK?=
 =?us-ascii?Q?EKfps4OgMsy9IfEYb6wz5AFGBDTjXLXpKwcxnJEzS4vstmvkD5y7A1Fi3+Ew?=
 =?us-ascii?Q?U9W0LmTbh4DujpsB18UR+jAi+ARugHd6qwmzknm4GiMBaPWFy7Dnhq4AkoiX?=
 =?us-ascii?Q?3XgOt/W78hOu/y+/WWsxpzsfJTtyuuitHWfmbrQGWAV9kibS7reICMSvlLPQ?=
 =?us-ascii?Q?Ej+NRwhJmvxKnk+QcNpTxzhED1y0DX6WSayLT6wmENubz2VX5tfkhIS679wg?=
 =?us-ascii?Q?cXu7PNDlrg3U+ms5ykZj1OmBQIFeaHF05OoopaX/7nQwK7iJLFgRYyuFHSAw?=
 =?us-ascii?Q?IdwSyOflySY9J3HHIF6QW6ZVQ9b3BgDz7CDc7A3bnQDloSK/QoHHUrucjnL5?=
 =?us-ascii?Q?VrqQajybPcWIQerurDAnAOXPlL8OgywIqs2GHe1I1UOXnEaZ3mzWVtrsQQi8?=
 =?us-ascii?Q?hhZQHKbHJHQlrmpTSklVz+yk+5gf0q+fMPOJQfr+BkxiPQaFBDgEfWRpROrF?=
 =?us-ascii?Q?49BuMWPNtMuhKafQocVmhjWoGdkhTD9CmWEAsLMHmnKB1uhoxMS40L2gnQJK?=
 =?us-ascii?Q?7Qhe4KOns91tJVHo1CEb29H30CwJ/gTNdzq7EPy6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6162ed36-a471-4478-9f39-08db2a2cfa0f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 16:54:46.7187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uqpZ5DTB0zVKq41F1/hKEbZJ0AqG54JgvlEUtQ6NrHDv/s8zrebEQwIXEv/HPPa5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 03:10:50PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, March 21, 2023 10:58 PM
> > 
> > On Tue, Mar 21, 2023 at 02:51:20PM +0000, Liu, Yi L wrote:
> > > > But still, this check should be done at device creation time just like
> > > > in group mode, not during each attach call.
> > >
> > > Seems like requiring a noiommu_capable flag in vfio_device. We
> > > set this flag only when the vfio_group->type==VFIO_NO_IOMMU
> > > or no real iommu_group (for the case in which vfio group code is
> > > compiled out). Perhaps the below check should be added as well.
> > > Then in the time of bind, just check the noiommu_capable flag
> > > and capable(CAP_SYS_RAWIO).
> > >
> > > if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> > 
> > Yes, and also only for physical devices
> 
> Sure. BTW. in the time of creation, there is no vfio group yet. So may
> just check if the device has a real iommu_group. Another alternative
> is to set this flag at the time of vfio_device registration. Physical
> device driver and emulated device driver uses different register APIs.
> Hence they can be distinguished easily.

Yes, at registration. In group mode it should copy the flag from the
vfio_group, in non-group mode it should query the iommu_group

Jason
