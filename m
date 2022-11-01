Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2176C614245
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiKAAcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 20:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiKAAcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 20:32:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C430E13F20
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 17:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5P+cBrrmwxdQs3qIPRVXj8HSdB7FpK8k3MjC7DoBwIVjv0ZeT6W7hPXwt15UXFb9B8BeOjKfvPOqx6jw3pjB7hqsRQqsv23pUrNfdRhL1QB14E/xgbjhHPCEHknKXrHP+G96zkAy3MTsG9RKYN0CIoPtXYqv0daoCH9P8kIOndLKYszWl5tb0ymo+KRURPVB82iUG6zdiGvdKHjphvOIeG1Db6esSa4xIA7YH4ExK11ZXntRq9EXRi6Kb16fhnLkxCi0AEMsL9mJ5XUzGW2AVkITCXHl+OCgwumD6LQ7/e9EehnuIvb+OHb5pF2FbBlGQeTmNimQu/4tP9RQc7qlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TODF4lufjx6gLO2LT4xtPQ/28hyOWqJdQWuQtxW3dC8=;
 b=M2GljSy3oLVzhcvwBKPSVQtiPX1pYDaX+LeoSRO9jCI3UfdBvDIORzM/A4RmpsNJbYuV1LBvJLqsc1iuMQYTBls3SaGkOTo5JDMYFVWlvW9R2GO6Ow6pGoqVQKgwWoxYRyBFN7TKUr1fvzJhyRUIYrpPHCMlLJUc/jou7SsS0ZjxMFj5jQ2N8QqqKXBwIxRIOw1pxe4hg2Ej6gm/ErDuu8NDQsibTYKv2YUr2+2mndIwwrKvJHVaMrVYq2LBIDr0coqoyMotSOBlT1+iGw3z+fSQCqf91Sz+bM2pt3Y8MFnomUHqvdQcoguPYwzBVZrgygj+5gEZvD+bEzhgCanroA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TODF4lufjx6gLO2LT4xtPQ/28hyOWqJdQWuQtxW3dC8=;
 b=nfSngORTjPWHg6FPcH5J3DYXFX4HxXjitgNvCv/+iTfJZTvt0hpZaytUUB9wrKcnvXagj4+O0JHQEvSxA+Nxco7xFhtrxjB7olfK0PMjG72RytQikBZYMwOBYburaIWmtcZbNcx1hIwZcmcFusBbcYWp3HIT10GSykY+mC6CJw6gEfYjBbIBG2p/p/fREtGPEcKBPgj5QrmQyPAdsJVA6NFIgG63xawPypO70mMDcI54owIWbRgy8PPsG1gziqp0bILkwHe46FiQxe/9Ey/m+TBOJLUnOVayahl83wRXTMhrkxi4rSgEDguTDBvbQja+Jpyy0R+6zOzbjtQxip9Vnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5105.namprd12.prod.outlook.com (2603:10b6:610:bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 00:32:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5769.015; Tue, 1 Nov 2022
 00:32:16 +0000
Date:   Mon, 31 Oct 2022 21:32:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        iommu@lists.linux.dev
Subject: iommufd branch into linux-next
Message-ID: <Y2BpD9OuPOmUu6GJ@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: YT4PR01CA0015.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b43770-a19b-4341-589d-08dabba08776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ooBZQZPmBlyWS8n7McMzEjJ6C6AOj+x7615aaKA27DfbjRyGdneKg0lpSry5dh7X9DAEGcdyX53nFVLymbtFy6mi+LEXvyuaxMvSg8JwEEYsneLaudrqkMbhbRGC9KfPsgaZp8tfgyJ5+oRA85I0I3hu8E2EnyHR8QwHoskTc2wlH5c4G6ci8g2DBH8+gHdlU2MhkeSO7DTgBWWkQgdGHdur95EQwTCtSlKAVOWX0BOtcVQcfay+W2qlGTqEsyGN/ZYl/bN8qOspVd/ZJYpduv89D/VNPYfnH9EYUh+hVUcgnYW2c/FYi9ovPS1VC2b/b7znKpMeYYEvmZQpZqEJ2Bl2XQU8wh1zRxVO/FhgM0gF6MKa0SIIuIyBxEXHJPYeg54iPRRhKn+xrWMcIq0ukxKwuu6bqdYH4wsol6CEmE2R2JiJWMx8GiXlZce309szq4utdd9+DyYbycvfZSzH1Pj9u4hRD+EPHwyKLuNQyGnsAMwM3j75FuyyYTAat9Trdl82rpi1+s00juTfpUPvGZwGp1GI5U0n++t/Ihe4zLAh8B+AhQJgqqFNV9DOE+IgopBMcJPuda7Br1bfHuW/hYvmbYqVD7GCfUqxMlsIycOaowbpAlMQ/WwbNogSG01UaME/OFG2wRNfDabHg8p58BtBtET9syOFknkapKaw4HxXpBE3Hkdu25facFXdTocIU2nFejnl6NpMcXOdbdj/D0BjFjGS91NfT8Yb8kBTtO0q9trQOvqK9ZmuAspsijj1znteIJJZMcrWBkWe0PH0plXzWyIemY/o+VFafBgGO90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199015)(558084003)(966005)(6486002)(2906002)(66946007)(36756003)(86362001)(38100700002)(2616005)(26005)(186003)(6512007)(5660300002)(316002)(8676002)(66556008)(66476007)(6506007)(41300700001)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lxWcEUK0urM1HCISShhVz3sNgTmRhpM/5YD0kv6+HXvnR1mIuzJqfiLBdgr8?=
 =?us-ascii?Q?wQ5o0e/G7e9/ggf95M2pqiAXyK8Rn3FVanVxfdn1Xh68UwwAMLDXmrNLKeOI?=
 =?us-ascii?Q?1wUY9ur4aPIr+RsFVvf8Vs+/xJNnR3ukt3v5PeXirXPhRsFZlVKwaKqHybcV?=
 =?us-ascii?Q?DC9tYlrPDFbuTa7vV7N+67r5COtByYqUvNxiJa3p3ediSkKUZ7NjgCF/BHB2?=
 =?us-ascii?Q?UJUta9EwyTelYUfwrsKuQbc/l8XnMGrwtLGEIOhClcl9UKkmLHF151ziyoEx?=
 =?us-ascii?Q?tvXSMJB6U2Pq3QU/8E4ZFDF87IXt58yzHmQP4GBvNmiqh1AJg/p0OCsRQTc3?=
 =?us-ascii?Q?vCHUQokn2hT60SXcIJgDXssegxJcyioJK/ADmN0IdpOVxci7ea27D7cvG5ye?=
 =?us-ascii?Q?NT3dsGwmaC+Edac+CoQDmk1eYqmFqb4LACWVfvlJ8ABiFU6Re/8K9SBAbVKI?=
 =?us-ascii?Q?ACyhwewZQSU+mFSrtU45N5ctn5xddOgo0zcjsw00uGEBzM0rL6kiK+e+GCy1?=
 =?us-ascii?Q?crMVZxD/KWL/nCvIDqtDCgOJry91CrV0ZI2CHjFXgFkiYQiz4KZbU9/yH2Qv?=
 =?us-ascii?Q?vMDY2aajYfqRQvs4PQay7+H42vAnAEth225eaqFuQDWzqiozQoYlRUcCzZv5?=
 =?us-ascii?Q?eiNgAWSiQ6a/LY+M0loQ8rBP/R1ALbOaQVHbxf9+8C6yQXXjb7wL7ah550nY?=
 =?us-ascii?Q?sNAOHc0li8qPjaXkmhAZDyVg8FW+gzVmvA1JWvG/cKWSKjUaiCIPDdA9gK2d?=
 =?us-ascii?Q?S4fOlaphDw07TlflmKRjpoo4uJ7FEqR/+KW56zJRzO4J4gOxfqG4FwOnszQW?=
 =?us-ascii?Q?dctIpkwvDt/FeWtgHY3FSafkeJpEY/Kz5s59h9rKYVhEJdkVyV7S5U0vTabM?=
 =?us-ascii?Q?aY+l1cAT8+C7yHqtgveCwxvRAJyyzX6CoV+1zK8DJ20ktCmuIaQPFKHGS+ph?=
 =?us-ascii?Q?HKMsqrE1lTJ/UOBal349ud1ISBMK4uG9GazpdC8Q5Y3LAVbsQI71vMxYSOg/?=
 =?us-ascii?Q?V8B8mYyCI6OXPG2M3v4YZ9vIRMTaMUQNiSVTg09vZ4OoBftERhQZVblZyKQH?=
 =?us-ascii?Q?n764alaLMMSK5Pxk93Brcr7i6JDoqj1vb46Y4Ge/L+axGPsrocjt4PcSnaTP?=
 =?us-ascii?Q?Rt5aakSRi0KLDk63rbj2VrQzb+MuvzBQh3RByWW4RpXinzhWsEjz1VDjWQLW?=
 =?us-ascii?Q?XEYlYNr3IzKqrDeCElxQtJqkfROVkqu3KYoynCcBzqehcg6+dLSuQn/iIl42?=
 =?us-ascii?Q?/QcT+m6L+uCYNc0KCOsfLH8HCwX8fnCIp+Nu2FC211Kr1PVrYzWUADj9G9ba?=
 =?us-ascii?Q?5RN1RdeJqIGvq8LoAGliqZ79L2wCq1cLgJ04aAmb75Zdg6doYe6qQ7EXahBp?=
 =?us-ascii?Q?nfTELjGkC4HK4Gz5NMqHPfAecH2K32dTRbgW0uXsuuZkn9+Oq2Krwb/KzTSZ?=
 =?us-ascii?Q?JzpqiWtwVJH6wiacvIDkFFB5AFRbxpwDBQ1cBDI4dDPtvyVS3Cqrz1iY9ygR?=
 =?us-ascii?Q?BlSxhCxlJLEK0PYaNTcLdJGS+xZtndxkQUEhmidmFOeMCJxxbTN9GzIspf9P?=
 =?us-ascii?Q?DasuUL3B6cM0UQPxdEOqnnqBtJTf82BpPSOglxkA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b43770-a19b-4341-589d-08dabba08776
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 00:32:16.9125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vTdZxkLKfEleXNnIOH6uIlDkU8PmjAmW83i4BiwBVi9PXzFRM2uSLJqyQQVpK6N+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5105
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stephen,

Can you include the new iommufd tree into linux-next please?

git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git

Branches 'for-next' and 'for-rc'

You can read about what it is here:

https://lore.kernel.org/all/0-v3-402a7d6459de+24b-iommufd_jgg@nvidia.com/

Thanks,
Jason
