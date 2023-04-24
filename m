Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDA06ED3C2
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjDXRj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjDXRjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:39:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3378682;
        Mon, 24 Apr 2023 10:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbsbSUYtiSSkOLW0LPOqYDS7ucdmfw5q+Ke+GLygs6pD9qNfONStblQ5UEor67m65dTVDGs2gqNPrI2jK41tFcaU4UDWv+JnLK+y9zMmCwpKVUnzkuumbF+PPQKyu4jqLE3DfobixkXDKbLYVfSbi2U25DPIxPy4CcBzE+sjABzfyJhV5RsUV4ORrntgTfpSKTwevLUtVYWweZUjdFLVgVRFokCj8bslg2YVMLgqGvUWDkIqXKeRYsMmDXFafvxHcxtDvTUnKtitGwUuwli4CQVt5dqyp2X0PC/5KimfOI3sT6OgnjogXwZczZ35XiyEoVFFhm8bN7a9zKM7vDlW9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=It4Ocn384aQak4gpwS7SlFvM0tSM+D3rf0pIiu6RmxA=;
 b=DDRneBMB4jqQwLGWYV3A7qFXF3Bp7ALUNE+uZ6NUlifdQA35M6YX+gnrDYtBZHCRO2c3X3gp3Xc9oFzrn3UASmOGTrDoRRGOn/ENhzVu3WATwz+veDIEvslECN3wq8OBORDV2zB6DFlt5zwd/03m25loEpnhxk1Q0iPISNwbzsOCLu509Pgv9NJwYRcmSnjZqsQUHMmY9snyC0dbpiBa0Vx0RIlKB7RKJygpd+ZAmmkxzjAZe9KkwyVYMkUwsqfut4HMjfia03zjdOcPSn6iQKRKmvZwzCO+Yr0eJZACiTQCyma5Gjvk5m0ERhwmF5pRauCfiKtfKYjMoemeoi5wQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=It4Ocn384aQak4gpwS7SlFvM0tSM+D3rf0pIiu6RmxA=;
 b=TI1MlW4MB4McaU6/zedFYiujHIJ1K9Rdq8CPYDo9eBrtTERbLjONRF56LPy2ofFkq5omxOYehxWn6W2/ecK63KhLDMw0Y3uXICWvd60OQnWAOutg/H80cm1zdWZM1AARWQi/jzNQctwFbJ7Hb78DBr+TbUOapX/l7rhrLLSPInA9YX1/autyp7evRTgtgqIU7nGsyHOtYheBLFizgmpgdevJqYT2x5ty2f9vUt541NPhkO9J6hd0eaBVgsTtZW1AS7AAI52AfDGLu2jJ5XbIVZj3wmxCfvMKiQVXzVTjAAI1lKZP734MGJHz2ZF5wAOXsVNor+y2SscpSmbxQqPFrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7932.namprd12.prod.outlook.com (2603:10b6:510:280::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 17:38:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 17:38:28 +0000
Date:   Mon, 24 Apr 2023 14:38:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZEa+khH0tUFStRMW@nvidia.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZD1MCc6fD+oisjki@nvidia.com>
 <DS0PR11MB7529F4A41783CA033365C163C39D9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZD6U5Tf1xseDawPE@nvidia.com>
 <DS0PR11MB7529BC457408E5816DC3E313C3669@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529BC457408E5816DC3E313C3669@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH2PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:610:50::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 3132b54a-763e-4732-246e-08db44eab6aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2z9X5OFTZjLrBIQvQxD3Glm+vGs2M1xsP9K4O26qPlp5KNQpKqe0i9f/l72ohaef6/leh+4ZXbKsvNQMFPus/HXAWRRqRva8W647Z4gzFvMKdyw8eugy0IYTNIxjh1PGFDZ3JADcCXFtdF70cY86GnZngxE8QEBdeWyErRn1bL3PxxLugZiW/hYnbUk3HEXNbYAPjhCkJcwHKbS6yyocIWx7zcuME0pNK9O8eg6WLmQXQCDfVAV6KBP67gnIPGIe1FL7Qq9mOCirSbrRZJsxrvShtkoj+pibSr81mjQ7cAVT902+eMmrxlYD9Nj+ECu5C4htWjO6k/33GH3rFJjm8VDOsRKXNHpdswpQxZaZ+fNcq/3bk+YdVMLO+641/0MAMYX3CoLS724jXTqVf583qVbkUHbOJfCp0wzbXNZEthqKNFXt5yVPHeJesco41fDsTERiYHvDd89aQ6/JzQPX8wWFAd7lRFCZzto0Xl1d0qzMP29SHQ6sKW5AZ0J4/GA3/aVkcSyzbS5+WnXtQR31yk/M2gs9N5KXy3QBZAjzq35ZDejqT7eVjJp5gcPODUwp6F6rB3AyexKTvY8874dDEXPtpNGD9c5i+Er6qJqVpuk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(4744005)(2906002)(66476007)(66556008)(66946007)(6916009)(316002)(4326008)(7416002)(8676002)(8936002)(5660300002)(41300700001)(36756003)(86362001)(6512007)(26005)(186003)(38100700002)(478600001)(6486002)(83380400001)(2616005)(6506007)(54906003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uSinEAKfPfhMqriRDzetYt5bsUbln8/Ae4ov5mJUm7TjRIuKR75isLKeizZ4?=
 =?us-ascii?Q?3xVDoCJfcx506aJy4QYnrkL+86IKIlb4YJMB0FP+ccnT4bA+D8GXAX+KMLC+?=
 =?us-ascii?Q?TXJAVH9pGzAx8/jNGGk6BmRD6p2ReLSuh+NV0R6tu4cA4w/M2m4OTa7x7T+l?=
 =?us-ascii?Q?0J+WcV8tJVubtPh6Qftwt7/eHrggFpv2U+lECqMekdUsxByLmt/WJRXBDcMY?=
 =?us-ascii?Q?NWjwNTdUxB2CmF/mNtRCCukrSBPiOPoCbzAHAHAxOPCcFwF3fulW94BsS+ZQ?=
 =?us-ascii?Q?N2KNpJjde3UGKM9EesFmr0ZYLMV8AIWvLE/RxWJu2sgIVe0hb4lYDA2un+kU?=
 =?us-ascii?Q?nLIJfxlMORzNdRDN/V524RArxcwH3EsEue43fREtBg3e736CgR8n5kK2iDdI?=
 =?us-ascii?Q?XgfIh73oQVXoyvG4Tw5Dz332wisiT9JRyIrvI8qLjeTYhWT+OvIT/Gbd0yR3?=
 =?us-ascii?Q?ivpTatZKBzgJksYa9iih73S1pKAxqR3FWnhgarMwnI4Q5N7PhT5IvPuF0T05?=
 =?us-ascii?Q?Zyxkf8h00giwT1Z7/j0Yldu6JDSYSZiRo1xTGES/+O4LrHWi4N8qnHLzyjRl?=
 =?us-ascii?Q?lHb69uWulMZyGxJZmGptxP0+4T1+WTG4tpCVTKcHoTylr5pB3fa3nQA/51U8?=
 =?us-ascii?Q?xireOmSAKitfy/VVzEU5S8Z0MpCOi1r5WtT3uNUtnog6wuYAMvFPfHKSI9db?=
 =?us-ascii?Q?87lehZZshWg5LlNaHYffz+svp1dbwQ6/YO7jelQT68I1yUK5x2SDEA3xNwDU?=
 =?us-ascii?Q?a8zpHeis1zsFkiK97JHkVVhH7d2Dve9QW2wsjKAzw0mrEoGvU763XJDTi7Y+?=
 =?us-ascii?Q?DXpzy9Kb8h7u/pm5hr0i+l/hFFd+ZAftQfUeVqnVz9jGLR7U9bPncIHS5rjb?=
 =?us-ascii?Q?RnLZ+XWDndAuLbh4PFWPLXfawdeVPlxMRC1ZxfC/Bq/vUtlS8PZ3ePOO2/HQ?=
 =?us-ascii?Q?H6Skt8aJ3f9T2Wj75wg3xVIe9Ews+NzxQOqj/+/qza3kwogV+ezflmygJrs+?=
 =?us-ascii?Q?jBcM3G4on3muFCnP/O5DWM7gczU4xCEwIm1NqWuONep2Jrj4RV0CT2htTqOj?=
 =?us-ascii?Q?xsROYRAx6iCnGAy3MLbPJUoEGr3s3NfMWskMOyNvwG6eN5xrcTzt6Lqjm3iB?=
 =?us-ascii?Q?dlk0eW/89SE0MEy05KiqH7KBHXdo4iZjVs68VzS5ahM0jLVt+6lN2vGqb9CY?=
 =?us-ascii?Q?vfrNE75kOSpSJPKVWn8/RrCP3G61p2nGw4znaQ5UlGIOT9PwlRqY53F62lHh?=
 =?us-ascii?Q?Z96gefFzPwbadv7gQKBlQp08pU41W0QZhPUu1TgYZV0Eyd1Wl2jOPVbyE0Rv?=
 =?us-ascii?Q?a3y7+juZci/LwK+dba+5nxHI+IgTXh7bBmht7Sx5uZ38at9Ad8MfrTi20Sjk?=
 =?us-ascii?Q?sq72BvxMWfLB0Esll4pilta5DcX5BOURU7/DH0npQk6oIeCMKXB0w55hM5uM?=
 =?us-ascii?Q?30ilHetjXr+6P5tgtsY7vkcRDrp/LmjYqa44nbHyL+QrUPYbGrxTvVngapuD?=
 =?us-ascii?Q?5rugNZNvM96JXgDq5YdF21uN8dsN5UPPR4S1EFJk1R8jZpooDoouIzyP1ovM?=
 =?us-ascii?Q?lSDRynxKaJBJ4ee7LDqDz6wf91OJXC1QHh3+tKlU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3132b54a-763e-4732-246e-08db44eab6aa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 17:38:28.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQTeGxTkzv0IqJYQon+WoHm0YxM962wcjmgaxu1rE1eXyEx+i0Ep+PC0P6JmAeqD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7932
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 23, 2023 at 10:28:58AM +0000, Liu, Yi L wrote:

> This noiommu improvement shall allow user to attach ioas to noiommu devices.
> is it? This may be done by calling iommufd_access_attach(). So there is a
> quick question. In the cdev series, shall we allow the attachment
> for noiommu?

Yes, I think we need to undo the decision we talked about earlier
where no-iommu would be asked for with a -1 iommufd.

All vfio_devices should have an iommufd_ctx when container is compiled
out.

You don't need to do anything with the ctx for no-iommu beyond demand
that userspace provide it.

Jason
