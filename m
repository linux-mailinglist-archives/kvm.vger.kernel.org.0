Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7048521918
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbiEJNoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 09:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243098AbiEJNnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 09:43:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3E23A5D6;
        Tue, 10 May 2022 06:31:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExMI9FDIXNEvmmXkVYKrHD5COW4wiVnSbj8K77V3lu6aP3/pIVbhWcFBQ0Ctkihe5OpOMirjJG1jXizur3ysoFpGU1v1YcE8dMmkFcFZl0hDk2Dq/wk+OJ9yf2ErxEUiUZvKnqoLSMX0eEjz3pjlpSwLOEXDCTvCuzzBZDhfDBrb854XPxuMEqA77YpXIXUZ4g52by/0sRAc5NB2Kfi3SZzjiPBEx97GXDxgpYXh1JBOYmqD5+PEvnTE0XRhVeqfvBybpE4bxJS/YfnHzSyUeIZi7gkiTz/VqgYFYMuhsQ8hIJS4Tm3rHGC1d7Xhn1toN4SwSJThtNtoIM4GakPYng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeN//EX6l3QgePOCeRkLXJCeudH/73va1Jy13pKxrFc=;
 b=JaN8eCyENflqZftVgsAdGXdr7t9k7yJq5tNx1XUBJyzYa8KVYC/Xv9X8q4XW0AA2kvh9LIP/LWXENNuCYXCNe03wZW5gbrzDjAoca0cA3IT100Y1A6wcH8vwrpEdAHjClhoIuutSymmrIXnggfPI/AXFYFwoDxnRsRt7e818hd0tavNNKQ+QQlIv67AN8IhAbplmNCuCbPlI/N6AaBlJ5ytIFBvRlhIRbh3ZspGWEuB1g0YFjg6F1ilmEaTmG6YNGXCOp1tckBMzDXy5KrgZTrOuMmaIJ5xEhF4x7mcwkwckwN/ZbCoObGofjSqyjTF82OLo6kFdGoJLyZtNkCsLeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeN//EX6l3QgePOCeRkLXJCeudH/73va1Jy13pKxrFc=;
 b=hn34jNHjXgsKEg74I/KoMeKBJT7l6l1PM5wOZVPpc5WmdwDCAv8CWIZ4a/d0O+OukDy8PYcRuK94KDAt45fnfiMWfEUnNY3N5HI2StMrcM1CjNKUY1agFLDU4KL0HD35A2nc20r4b0LdzR0TZERKKxcWXtomO4sauHUlL4MNenb08+MWmEai1R7qDSP2yICIo1imZ1FdRcOZtinhH7V73iE6iIL1t8QQntmqRE0SIMl4odEALhJCoq3wXOZ3WSqa2HNzQYSHsQnXXORLgORd/3yS6btfpIYAqOPUh1MjoYCyscaINPyeghnIvTX5WZ0hT0XDwcM2NvsEEc+HrP/hXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6245.namprd12.prod.outlook.com (2603:10b6:208:3c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 13:30:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 13:30:42 +0000
Date:   Tue, 10 May 2022 10:30:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220510133041.GA49344@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc95b11d-2181-440d-d856-08da32894806
X-MS-TrafficTypeDiagnostic: MN0PR12MB6245:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB62455CFDA8B89F6F16A0D6FDC2C99@MN0PR12MB6245.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHR+NT8HomhOCdQ/HJFFbiOC57M0RGXMmbE4kbCGu8XuoQPQe1cIhHItMJeU4bNaIHASJQ2rWbB2d24BAz8Dp1edbMhXrgJHv2k4QCY1Bf3k48qOqJLZ7ihFncdT3+vmcVf5DDnq3B+Uf/jHq4h83FU9sfbPgX4ULEaFf997MpLuVY6zB+IxYhNV112bYyxn8QCVH0rPSNFjuOUld9gjg3p4rdxEDzoIdnqBxbm2t6Sopy4M7ZLnjkd2Qb/+dJEe1SP0P3aOveWhM0+XIv2HydvzaW5LGUzfbB3iEEezB5wqZbCcE02kRg4O1fXxO/HBVAUtQsLNt8ikfjV/4J06aqSrjdvHtWvnOyVAzzrHAgs06irPSIQe9iDdytS8XXq9YdNBT9zGufEyFjo8LeaKdz6hR+YGVna+d9M4duXoSwyL6wlDJQGF8R7uaMTsGbOaZVSEp6+FE0EFvERTftbkIjU4QPQdNtIq7G4JdCfLSpTkyac7IzkGsY/Dzd5ZqE2dj8VEmmVgTF2ZCRJBXK5cN0o4NEV7qmuBz++26cnMqZ5xx+Z5plKSklvko5YZLqpVmAQI/dRRKnQPg++W2y3losIIMR2l1i0w/OevHUFu1qRyNscSJ6oJ0TEpxWpstyrvgQEQuag//W5wcHDryB4x0mckNQhK1JBOuDsVTicame4YPwfVH/gocrOjcNwPLIRe+yGYHQ93nEPEfA2v8sT/HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(508600001)(7416002)(86362001)(6486002)(316002)(6506007)(54906003)(66476007)(37006003)(6636002)(66946007)(66556008)(8676002)(4326008)(6862004)(33656002)(186003)(36756003)(2616005)(26005)(2906002)(6512007)(1076003)(4744005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AuGJ/23HCpohWidzMHncnsJxqbyR81LNcfEpRCEWBfb9uSnaiaFdh8tWitbe?=
 =?us-ascii?Q?ALt3onwi4xuWZE51Gjq5z7zmxTAq//PEmzXIMgr4tHbUBm2BI9bw3oD3AvGB?=
 =?us-ascii?Q?+mVeczDZ2561sMR07MwlvWukGZ1zPlsMmmAQcRrk49npt4d3pMBvz6xK77BE?=
 =?us-ascii?Q?93zm4Yq9nnHgo6gl7zh99qLrM0NrtD6cra5WJhDw4XWUwYVtEj8m1n/eqjKP?=
 =?us-ascii?Q?isQo75zwnUklkZlpn2zhuzSYYvxdChqscaff3NJeJoaBZ7ymmIZz0WTUiNqZ?=
 =?us-ascii?Q?JSrL5/MggQtS3vVt+QrXH/zRNWYCjxgUWdFSLc9qmRphcpYfl4EZSdIq1kaO?=
 =?us-ascii?Q?8unZOHYpiWaOmB9E29WBLLli3GZ2/XEuStfBMo+sFGy9XXt+skdPypdYENlX?=
 =?us-ascii?Q?N3yVa7iLjuy9f8l9kLluHsE+pNU7mkjZlj/sFp5LGpev27pqCrlzCWZ4yP5B?=
 =?us-ascii?Q?pq9GTXKpyyxx9S3nyrU9CYpUdR9LSoh+XfT95KwsMW11aK7nynDjBC4uHAaP?=
 =?us-ascii?Q?CbPKBTALHMVWDczhc0nQm4yAjOxw/d0UnaZCL/DdimCvvWlTBrnCM0ntOLd8?=
 =?us-ascii?Q?qv48v349lsr7MXYbvajA63wU2NLTFleoKEyE8NV2GPmh49oX1BUY+GzzrHr8?=
 =?us-ascii?Q?igIPNfdPetg6wlZbXXlyDTWDw1UOKGUNPY3y39e/3u2KOnCYUgVtBkOVu8dC?=
 =?us-ascii?Q?taWrfDN3bZKZ2bgdQqnXxffUSvwqDAr6I/TGBe30ukYi/ugAQaeA1UJsrIzB?=
 =?us-ascii?Q?GwPfDBX8mmx75yUq0fa1yc3Zt/o2WTM41R8bF1Q3CVqLOUdQRv7Ko9pmWM+K?=
 =?us-ascii?Q?mmXn7EbwfZR0f7c5s42U6rVHBahYM89V1wAXkUdsBhKwfo1VLU/z1UCm8gpn?=
 =?us-ascii?Q?wiEry/6k5ZKbs3yvMAWz5UmVofx/zTrPACx8P3QvVp2OJFBDgPR7gSQIz6V5?=
 =?us-ascii?Q?GW38Slf/XNUWjIXl8/vS963/HmEjaD5p66ghkDoIghTLuAzOhnKszsR1AMns?=
 =?us-ascii?Q?ZTOkx3oUgrEe8oheHYwZx2RjXpoNk8d0AtkgsV0OYWspruvOqmST4VjwiHyE?=
 =?us-ascii?Q?v2+/Pefzhwq0iB9AodOM9lA3Ucw6U4cI/Our2zhfZc1IaXbmLZsUoR15mgpN?=
 =?us-ascii?Q?TdeHkOYtsduVjzbuYbANIYEKn/6hyhgQTBiDHspwzp9ExaJMygUoZ/GdCSqX?=
 =?us-ascii?Q?F8C2E6TNVqUetwyoXU0Zmij7eP7HhfPJI2zDjn9MizgBY+qB009R9AFAbTHj?=
 =?us-ascii?Q?SwRdsmkjE6u3xFBCHL/plDBeEyJx/TuwVJc4S+xVp9thj0UulPbidrRuknoj?=
 =?us-ascii?Q?5I07/jDoS9zvcGhKa1udGSe/iKRXl3Gl5r0kgJctDmRyNDWIxea2bJvUnWmh?=
 =?us-ascii?Q?4cDmNpcClDqzYlzD4oeQgutTZOvVv4ttnqOTWgmcry8zdJEVkQcuuAFblpMO?=
 =?us-ascii?Q?eqpAmqYdgEb3Oyss/YqgGd7zFzucvkyHPbTcpa+lPZ51Y4SdUc+vIZXjP1ij?=
 =?us-ascii?Q?Y3keN/9g5szF8BV9wy8zZlQIep356wYzMlesmwBLXhujfa1GkU91464aO4Bc?=
 =?us-ascii?Q?vrCqHdIDJahuCsnJs6ZhLIluGOVx93rEaqusIX8OVR1JIL5d9mTvK1DRDpnu?=
 =?us-ascii?Q?kpfFdqqNf3hcomBlrGNZeZQYr2Tvv7+TZh++ximZ4Z7CrXT+2ttA2mIOHtOC?=
 =?us-ascii?Q?ywUXtY+Je9lvr2BteADViCM46ASzQX/9SdaywZz1SEoD2vH8UZO4O1sl1L/9?=
 =?us-ascii?Q?oT5OfvUI+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc95b11d-2181-440d-d856-08da32894806
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 13:30:42.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7LIufmqahFC5OToVDctHsQTYkBgweYKBDdweZBSeJjbGswypm+XF62XeN85Rwon
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6245
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 06:56:02PM +0530, Abhishek Sahu wrote:
> > We can add a directive to enforce an alignment regardless of the field
> > size.  I believe the feature ioctl header is already going to be eight
> > byte aligned, so it's probably not strictly necessary, but Jason seems
> > to be adding more of these directives elsewhere, so probably a good
> > idea regardless.  Thanks,

> So, should I change it like
> 
> __u8    low_power_state __attribute__((aligned(8)));
> 
>  Or
> 
> __aligned_u64 low_power_state

You should be explicit about padding, add a reserved to cover the gap.

Jasno
