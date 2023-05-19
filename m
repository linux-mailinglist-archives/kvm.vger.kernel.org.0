Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54CC709866
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjESNfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjESNfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:35:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0CFC2
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:35:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOHmnypktN+zIeePCWImGEiRCG32dFHffxuAAi9fXZ25hJN7PViSO/AuqMsWcJuaSMqcn8hNn5o/As6OCIlm4UktTmrZoL8eRiMNP4/VuR6WZ1DDqMpW72edr23eVRETR0i9ThHzWpX1CmKyiVjHzxSfjRVWNNNQ3+er9ha9Te/KaBy7L7eq7F4Au/9CplNosyf+ZuZwmTWm5qKIwltwicEn2bX/DeQqPLRDjU6EZr07SB667I3yEhhv5YOGRnw8MPXakazfS/KKdvfMlpGdb/r5LypA6oExlV0AvRzQ/BDlzGRcm5MrDBypleCANuGJ6lS3yMbJEaedaEaNBL5d4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ke+LvuHzabqK4zb4ztz99OMOfgTfSSSL3yKSKXEZR6U=;
 b=T48u5hnct6IwDw2YsJWKw88uZGvsVkMIulUMOSnXBUOc70QdVPDC7GXWAR5+RpniQAY/+vG9HNtM6ACqPlnyeUbxyDKjJ1ikO5SQP5J4Raa51YdQEXP1R6e/QL0DPWvRiZ0Kq3BQOqzKF7bevgdkRU3z95BCW9biXQaUUPeFfTAnTasEqRIdvl3MV8wxbGeW7d4nqqON6w74Pxi4CyeQCIHd1zzhXzE7Eulk6H0AWI17z0uprQZYcx3XEkJ1laBBLDaTXV/QsMS8yX00MS5oVvPA9a83skyBBPY6uN9IGOWyiPTn8KnrsjcIuDjRjKzBpP9KjZCSsPOYRSjsHJKQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ke+LvuHzabqK4zb4ztz99OMOfgTfSSSL3yKSKXEZR6U=;
 b=Cl3HbzW+8E3tphHwU2s+s/XAzQ6hsTLtP4rcnprjAxVXu0UMhDDxf6uMPe+/RoBAHQMVZkKjQpoC7R+WeclxiR4yVi9bEp6pYmcauYRN/S3qVVOBUkcoKCbz3TVgdEn1O+mh4GfHEYuYbr+1DXaDW4jdMv0hXhHNb8oYpxSjnmKuEhdivVBIH5fMBIKMr4UOH7m/Z9ldOzUA0qQA6bcl7j0yZoaOyD94rKWZHr7qH0EzAtDqyblmFPfCyLJikwBniiMhecNslvqipXx7QAY6tqncdq83knDukzSfgjD9kPz/ZcPCzALS/p2141uBBJ0BgnmD4z2smcnd/AEPST1fIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 13:35:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:35:49 +0000
Date:   Fri, 19 May 2023 10:35:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 07/24] iommufd/selftest: Test
 IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
Message-ID: <ZGd7MzUiESbzeLeg@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-8-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518204650.14541-8-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR15CA0066.namprd15.prod.outlook.com
 (2603:10b6:208:237::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4057:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eda373f-dfef-449b-9830-08db586df542
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fJ7n8cYq5RTDB4WZq0ZI74C+NZ3Bxt+lPt4QCMz9G8n7jMMor8xo4CdknvosNzw+qKa3oRDAuaaYMVj7NYMpv1hgjMs8Ndo69Vs/kUNexRJ8hyw0dSMa549xBRAHgQfsjryES+nFfEbiPxRSZ7fgokNdsH1BZpuhkl0T9s4FFp8WwMa824HL94xxuRZZyb0Ss1p7kIFiEwnnmRYcEyCYpoJj+mEWVpJqEIzdf1zir/phSYjzyogNZt2OaC/bTyljUHJgk8Rbuy1ucQ7YijmBQn6//M4pf7HvbA6f9rWFbz6GmvZ50xQyWBv6GsxaG6dpmDyUzzPMT4lt2YaMp5XG/W7Lc6qgl0u0tw/0uGxj+Vto010WfZf6AdwREB9/4FKJl/exEqP6+nrvXSu9tt2Ftuk6v+oUdz4igC9A+AAQKs6GgEtOkmaYVg2ja2Bl5rfyuaw4sD/ZNtJm6P9fnvqnqR4AMERFXu2n1wbixUynCc1X4KZY5rxmYpD40+uQ1kw/5CmNV2c1K4bf3MLtOiW0RaDZPzFVD3LnakJR/Hi4mocopJV9Rpp9MI6zS96AvZDhEPsKN0BC7Qnl8EOQtVgBH8vWRAq8YjMZ/Dj7wls3AuU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(2906002)(8676002)(41300700001)(316002)(8936002)(478600001)(54906003)(7416002)(6486002)(6916009)(66946007)(66556008)(66476007)(5660300002)(4326008)(6512007)(86362001)(26005)(6506007)(186003)(2616005)(38100700002)(36756003)(558084003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LH2EnovbqOrvuMVjz2qZb/5W2eL8mPhJVPC8EcUrtfKw1mlqejF9rRjXlpHW?=
 =?us-ascii?Q?Ad39SLxos5H/8frJJbL0yXFklNgoRXEJQRdxGDtU5z2X9GbKOHT+pjkGSrRp?=
 =?us-ascii?Q?oo5ktK0jJfZ9uzRgWSJq0q3rcYQ3Szxneg3/UY17vw8OUXC/Dk25blttjJfq?=
 =?us-ascii?Q?IDyZO3dYnS5dOtNhR8is5SrFylSbLFXF7kdj+xfv+iulz2nB3d7+tbQgfIuQ?=
 =?us-ascii?Q?ptzUXL/6Se/oLtjdk61iKSsqa0Vn5MyW15ZuR8dZ3UGA/s8o2MMhZ9SiGrLT?=
 =?us-ascii?Q?+2AalRQ0D/KgKyr5zgOlxIvJpO9Dp+pCfjVsfn2FWaBczX6GYWgJHZsW9Laz?=
 =?us-ascii?Q?fbK2ixHIth6JGkMOGMi8xa0RIFk2ucyKBkE9oGsvhlVzte1FhxMGo+ZWqAX8?=
 =?us-ascii?Q?FdXn3+wiNNSHGXPJP/AQqym65t9zjpjYLxal3xcotBgof18bOsq/5VEX/Sl0?=
 =?us-ascii?Q?wrD7o5oTx6n7PPzbnDDw+ub9zE8XLRprTIzE1IA7LcKahE9fqn98xvHUf/78?=
 =?us-ascii?Q?oz+t0mafXJ/QaZBMATX6RirlN1YocWI7JlfsVSpUGTNhMXd47sF7OsaaJ8kq?=
 =?us-ascii?Q?DNfk3AOJpdYPZSDixIbCQr8hbUICJQpPEQPK0clZguiDlrJmInJLVjygJULX?=
 =?us-ascii?Q?5wJo7aYUxiCaNLwozMASYv4PAdlBYxrTpLGPX67zRKREZY03IOSocAnCazCx?=
 =?us-ascii?Q?yPkw8GRQjMJLmnzBUrUssoRJG6EEDPQz+3txVblUyJ/SKb+w5m1z0dwv3OAC?=
 =?us-ascii?Q?LEJ3pbpq3W4Pltl3E/l3V67rSyB567G+oIXMitNAuOjFVmSuIW/M9B9GQoTA?=
 =?us-ascii?Q?H93E9jAMnnMtPxGpMnkebg6Wb+tHvC+yxqXueNFQykCkiyVWrvKa4CbTnneO?=
 =?us-ascii?Q?Uqt4CrtZXDWYZjUYk9vMEbcfFFZKRcG3LqZLYo0Un77To9GSAB1UY1uuA7jY?=
 =?us-ascii?Q?Po/6K40QOl6A3T7UUUhsf1nwsyv8RD7iOViVAdkzzIdUL3YZi5B+BbZHzCo/?=
 =?us-ascii?Q?/hmjMvas9GS3dk23bb0Emq+r3JTtiNJIViCjX3EzR+ORbuMcm7/Pi/xWeiAi?=
 =?us-ascii?Q?RQOpUHzCP3qv8wSxFEBa5VLVp+7nC+efhs6G3068y1X/c/6GheuREzXOfq/j?=
 =?us-ascii?Q?Vpl4MHluzB4U86UB5AawwJe42+5F8Nq1EAm48+H/GrFa9L6RmlrRHrXFdheE?=
 =?us-ascii?Q?8PmMKgyxTX5ZJ3Dpoe4JHByrWemXw+5GrroQC4FRrOcBuZkTjGknbE1mRSVv?=
 =?us-ascii?Q?upIIWslDM4BAwo3JYMHd8lqmXt3+0qJrzujcQigDQ1T31SiUCBOPbp9sEbau?=
 =?us-ascii?Q?nAZfm3wpOqWUG1B2kLfV0+gXEpqdsU/2veSv72e3tu7RUXZ7k2sDJyBU3q7+?=
 =?us-ascii?Q?2UmVUuI2OuEIwL+W+2z2bFe1a9bR6/VVgZsIxCxtLNmn4Nf9HIrEvQESztb7?=
 =?us-ascii?Q?NAqfkfPD8448RXH0RUqT7OdwNntkjOdeMfPc5Ier/BMPKIxL7yflvzi42ako?=
 =?us-ascii?Q?1rQv0u4LLVPk/hPBYxlWxzGl5hXna0WiwTC98wKs3/TeVdRHPNX8XKhXR9TJ?=
 =?us-ascii?Q?dwVLyBMG36pGNpWtCK1TffH6QYr6HCj59logz4UD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eda373f-dfef-449b-9830-08db586df542
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:35:49.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVOSsH9vyTDp60nGh/27GCK/vDY88JUd6muubZcFT83wQRzYDMWjhoV9kusnKiUw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 09:46:33PM +0100, Joao Martins wrote:

> @@ -50,6 +54,7 @@ struct iommu_test_cmd {
>  			__aligned_u64 length;
>  		} add_reserved;
>  		struct {
> +			__u32 dev_flags;
>  			__u32 out_stdev_id;
>  			__u32 out_hwpt_id;

Don't break the ABI needlessly, syzkaller relies on this
