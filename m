Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5E6DDC22
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDKNdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjDKNdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:33:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4245D44B3;
        Tue, 11 Apr 2023 06:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1HT2AYFd4ea+OZg/RdduDFe6nCZyyMyRS+qBwhCPSaCmruq8r4rPpSZDxukYSsEWjs998v4XA1jUWMhU/dElGb7hK8CGlmCuWv9igXNGvPTuI60n3RKCMclxNuwMDj3aJuG7GDXsYJ7zeo39q0TvhEUt8krskfRE0k1cOZ5nU7b28dkaNm/kGKI+INqi+6qeQOQ/sv+IC6b9sD5yLEGJDFLEdyhYlBwFLLdF6lq9+F+S1PWNF7k9w6EZ2lxMesV2EEMbnLi8/U8Rqpylx2kq8SPaqiO2D4l5pi8w5+m4n37UBaJnBN7yjPtt0ctyvHqiMzVUiv4qAY3aSJfqsqT5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXyfytyz2gFeopUC4uwhtwP9WujhDzLLCvW8ZzvVw7k=;
 b=SS1IFjSkWdZCp8NnvelD3+4Iluv1KsvB+YP6siHIcom1b22P3mnmiPuFYex5hcrm3sjZaTbecLLmx15Z137+MS2m5WigmLYYu8r10lULDruRBwDg4HxS6u/amtIdA74wwKuNtS612u0riyv6wX3cSlyEiXeyh+Yz5ZWPaIj5aQvZmW9IRLgWt2qhTTydfOOJL6CFtcogGGBEgflJsUa9MAir9BC30aaBHq89hPcrlX/v5Vlv0uNcf81MEkFlN5lRQKqJXmn/jZmGNSqMkHqH5THSWYKhVxBYUncYpdRoOsH0E6FU10cYOWEf7+VCeBM/4RMIp7PCvHp/O03HGSNoZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXyfytyz2gFeopUC4uwhtwP9WujhDzLLCvW8ZzvVw7k=;
 b=gVU0/IvBt2WE8UCCB7oKJgturHXtlu7IftwBkVCfegbCTuPokEtKuatcBUDFLO/Cz33bXNu48p8cpRVNaBsZR3msW/CUc94jf2e2722IB+6cmjDjK4um27v6M8NzrFgtqCRmR/1d5Q/8GC6pYEfZ8jjDf9XqwgFKK0SgkNE2HtB7ryT6ng4Kmq29v+SGmn3V5PF3LKS4FBtL8dzmjUCyyuuHJeGSg3xtxC4kzsU5Jr5MOMtQSqN6qSWsBw/3xTlUTlKYe8pauwnDQ/D13hrHBGgeDZ9q/nB5Ou2Qq7tgxQASnznor/BkSyr6mKa+pXI8eibVTQFcatxf9tGrsZd7/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7840.namprd12.prod.outlook.com (2603:10b6:510:28a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 13:33:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 13:33:06 +0000
Date:   Tue, 11 Apr 2023 10:33:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZDVhkMt6G8jKtLjt@nvidia.com>
References: <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230403090151.4cb2158c.alex.williamson@redhat.com>
 <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407060335.7babfeb8.alex.williamson@redhat.com>
 <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407075155.3ad4c804.alex.williamson@redhat.com>
 <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407091401.1c847419.alex.williamson@redhat.com>
 <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407150721.395eabc4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407150721.395eabc4.alex.williamson@redhat.com>
X-ClientProxiedBy: CH2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:610:38::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: ec671bca-288c-4872-ca98-08db3a914842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Rf9kmvIBqDkD/t4TZBSav5ZYl9Hr/YACgT+2dZ77aX28nvaPqsO/6kla12ZclvIMIum+7mx1GJCKZr/8lsT9Euy+3p8sDIQLHuxlrntk0ctMvpyFTgoS4iIt9Pbuv1Kn8AVnrL3ohLTKTfijpc/t8t9d5/8ZOJPPlRRRZHeb4+FxYgO0IwjGPAbLPaSzq7N97jMmqRRtbCbeo7RQu1OybvqZsjWVkF6esNDbHWbQA4d5rxvAgu3l2drRmgF0UI8t2MEAQUO8PcGq7oBO3Lw8rCT8kSFVCuBm1KG8WFSFQbo3HvTRnHonQf25C4/JTc7QtQFWbA9crziK+oI4WeXXU2YwcW99UeG1pIzpSAFBXV9ItQAPrfizzruKuUJzCDxOW7h3O0kXxUd7/w75U7hIFOwKAlMvL9KT8KY5zv1ix16nCVonEVYeYbxVwkRSRAhWeQqj/vPUQVbB7kd3zUPJAh37rzsL/m4nsi2c1MarlqPJ7iIxtVrhFTgvcUynQuk2loXL3KCwaXhvaRv7hprgPSEOyjCDCoUc1ohJkUvVD4YtBUOG1o/MNwWcNu8uCfY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(6486002)(66556008)(6916009)(54906003)(66476007)(4326008)(66946007)(41300700001)(316002)(478600001)(36756003)(86362001)(2616005)(6512007)(26005)(6506007)(4744005)(8676002)(2906002)(7416002)(8936002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95MTZWq6rBxPPFFTabgCrNJZ5eXorUXSDU1Fep9r3mVwopJ9vbAVWY7t6tTe?=
 =?us-ascii?Q?jj9Wz886/Q9X+M3VciasY0VN88O0M/lK5/Q0sTvsHImC3P/RHkATUVOciDMx?=
 =?us-ascii?Q?hxggnGJxPdJm+bX3t8nz+yh+/okIZec2UgPT5uVhGY1FlNWJ2ICp3gBCbqEy?=
 =?us-ascii?Q?XotrwoesC8Ag0lpIhAJ7MjLLv/eInDLduFcJLaBEfMJuuV9QWtj2p+CYpcT1?=
 =?us-ascii?Q?IBrM9kKyhR6bjpmbb8IOm7B4j+dIN9dKAGAujI6wVXCYLc2Uh8uVudNI371S?=
 =?us-ascii?Q?4ZOxw2uiCCi+iwDqCQLrMHD8vcIOdDJdyW9HPnRgtcobjl25HDRowqaR9QEf?=
 =?us-ascii?Q?D05F0Gbzn7CJwTc0nIlzlwImi44jBLG+MzYxlz/3Namaer+mwRMnjz5YjgD2?=
 =?us-ascii?Q?hp7ca2L8jkLVkmgdc7mzgiR9RuW3beK6RYiEzKwwMEO6fGe6bcvZffLML457?=
 =?us-ascii?Q?2Qj8gFJw/Z9iKY1HelvD3wuRfPVhRPn6zyjAnxqdv3yOgCyaj1FmCGqct4/T?=
 =?us-ascii?Q?Poufs/3UM56xR7fQbGo3I6EX72TUgzRY9JoibH4ga7eoucCoeEFSTRbjn3A/?=
 =?us-ascii?Q?InV/dUklTejnOKMH9l+7Wav09bkrhS6Jt8sBt3GFo7RftAXd5JNRF7rKw/sC?=
 =?us-ascii?Q?x675ghwOaAv/l5WVtwQEZuk4KXfC/OvXT3y7zh3cqG44Fev+E7sqqWme+OPw?=
 =?us-ascii?Q?CDCE9VhxSerLDm4hdDn/1/wbpBXEbuIf579ouUMuio0O9O0YYM2cLo7Y0U6K?=
 =?us-ascii?Q?ddXeg2K86FnaZgMjGwpThFzSC7oZjg7NyRhZoSfEhklKApo2Yrs+OB/fEYWl?=
 =?us-ascii?Q?lUSQUP2X8kwA0TJQjGHYMecLeOej98qyCtrG0/f0yLqPk7tF+/EV4FlmdCP3?=
 =?us-ascii?Q?LtoR+oFORmKB5TLGi6/QkUa0+4WovBwX9g8D7eXYCWnkAZpel+4FmEA6E/4t?=
 =?us-ascii?Q?hmMCHinlXmn/sdeoxCbp39lhUiSbCq1qdIXU8HLCLd1GoJd1o5Wa3xjDQP95?=
 =?us-ascii?Q?dA532jXcwbYJw+zgG34xZLCIbENSVvvY8PFcEr0FIKVnni8lQvUfn5pqiRwP?=
 =?us-ascii?Q?hRr2n+SM6druBJyDM2Hgrjh3c/hXWFdJZUs95pP7D0x8EYiW2teHAN4zKPBJ?=
 =?us-ascii?Q?6QA5BIUsTOdbTnGdmEhDAl+ja+GtpSALSfKNsoVdwOPvZ1u3WhdN0kcoNJPv?=
 =?us-ascii?Q?CEcU9eAlpFd156nE2InElZRFYkE7UjavEh3HTz01Hwqo+uOfE7xt+OO52Cy/?=
 =?us-ascii?Q?zeX67zFKvbykFw7zfGe4vF5X/CDgeghLdqYED8qzqs5x2B/XtKPJUFl28Ecn?=
 =?us-ascii?Q?R23YkleTOxBofk4chkARP6lprEvFbDl7+MA8BaX8sDFvl6OYi7fnbXEynZkR?=
 =?us-ascii?Q?SDGGzdyeY+lVnA4YM+Fz4OBrCCYwd9J3cCJXzyejmgA+R6Z6p3AD6sMLwaeC?=
 =?us-ascii?Q?kjMvw+ayrsmaqHGCIi2IHB+BIQbtKv106gRxhwk1ldI8LBsoZr/HAj3I0ohg?=
 =?us-ascii?Q?gRiPdhWo425v2KRN+bx4ye056ejIG6LZ1HFrwwQ5fOj7sQdp+Eusgokap80W?=
 =?us-ascii?Q?nzauc0F+z3UzMFY5XVJ6ZndqTNPGAWkESUEqIoTu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec671bca-288c-4872-ca98-08db3a914842
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 13:33:06.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7cQ9wfyZbxNhChVifpO7R6Wx4GKk6fDQDr6k2P6EHTxfgNoBquatGAxBRBe2D7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7840
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 07, 2023 at 03:07:21PM -0600, Alex Williamson wrote:

> I think we need to revisit the question of why allocating an IOMMU
> group for a no-iommu device is exclusive to the vfio group support.

One of the points of this effort is to remove the co-mingling of iommu
and VFIO so much. We should not create the fake iommu groups for
no-iommu.

The _INFO API reporting the group is not a good reason to wreck this
clean separation.

Jason
