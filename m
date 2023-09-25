Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF3F7AD826
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 14:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjIYMhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 08:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjIYMg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 08:36:56 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157F6196;
        Mon, 25 Sep 2023 05:36:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJ81iAmVM9zK2cBR1UBSXMcoXwch6p+HnWEXT/1h3GqWwuzOseHSxcyYxZ1YNVaf49A3K3Coq2Lrsj+UnwwGaHrTe7DOIfYYpmDwN6vfz9TYeE/AtvNpZzCVO7AY8iSdKqa5S4J7KVzXQSZBFV3qfGV1AoZjkmvRzr/P+/0c+ZWgNX3tTyz42DiZmoab9v2iS3f3fwDoHdcW7Agk/lqKmzNji2z6AdkQXvpICXZNhTHhCR6kUR16RL2AHTkinL2HNTXZk54Ap3BiatRLzcf+KovlVWl3aM4W/Y0z5PZTi/ONrQvy84yo/5sHpjy7ZeFV4ltopo2mYqQnuQcnP538BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fwe2msUXZKiapJQgvhzmeZFyXeal5jRNVuzAo7FCQ6g=;
 b=S3pGf2RO+IzXVHAiAmM8ufgV9CGgqI9vkisxTMef9Yv7mCrwHxCahBqpQRbrN7Nm712tPKRzdwfWUTO0mCWYbiqjzPZf3dlvnZfaRE7zo+YWfB+HWmuTiwG5Idz/ZUEieQytI6e/I4IWjguK9Cgr0sIQxb9CwmxG1X41KVx0n6hsqTCBD4PtZ1RGaS8dloaL6rUbPpnQ7///R/Z1G4afAG2NSj2nxFDwEhwCKoKYOWLvAhSzswFr9Wjo2wYxTwXbpq+j+udJ2UB1/cJOWnxgmJ/bayC4p33gn4J3GgWsHpbAH9v33OLJDWtz77Z/EOzB2mulXBwQIexz7x3T2+3fVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fwe2msUXZKiapJQgvhzmeZFyXeal5jRNVuzAo7FCQ6g=;
 b=Jcry3DQxkZi0kAeiGscpIRSy8bV/1teeMCQ6k3yX9DRzR16JcfI+s0Slpnx8BxuK4Ne/5dULNXZE2H0MU8u0H/CglHySu8fhvs8WF75ZP8kYOP1FVlLzLEExY1/6IZ/4GCQslr4zGo8J/AOhjzE3ax4fAo2NNN06xVNd0LNiOjPwaYAGRxzExK7xtbfUQRgf2k5j5PGZylLZaM6B1JAa4kAdzqOrCKepKSqro5XMOQjvV/WKtIPw8e7/H9U7P2Q4/y38FCpnF9suahQXVX4KHUR8jtNbdM13xP2w1CELLkVqvbyDvW1DeWbTLJMsZanMKtkZeWknI916mFt60jp7hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4276.namprd12.prod.outlook.com (2603:10b6:a03:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 12:36:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Mon, 25 Sep 2023
 12:36:42 +0000
Date:   Mon, 25 Sep 2023 09:36:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, anuaggarwal@nvidia.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, akpm@linux-foundation.org,
        tony.luck@intel.com, bp@alien8.de, naoya.horiguchi@nec.com
Subject: Re: [PATCH v1 1/4] mm: handle poisoning of pfn without struct pages
Message-ID: <20230925123641.GX13733@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
 <20230920140210.12663-2-ankita@nvidia.com>
 <878264ae-f6f6-04d9-2d52-fb7ae29dca85@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878264ae-f6f6-04d9-2d52-fb7ae29dca85@huawei.com>
X-ClientProxiedBy: BL0PR0102CA0060.prod.exchangelabs.com
 (2603:10b6:208:25::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4276:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc7a267-591d-45ab-3ee9-08dbbdc4127a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bFR9peb8PE0v2XjEx01yoPXRbXXXTrMRLC2Dk99RQeZYFjd3O+TiKMrh4r8gKtU+PsCOpnBHotxANBY38Abj0v6TnE+I3ENvS6ux7jbvlprHIWu8kyHB0FOLNbcGx2TEJ07aXQOm+t4/SwTCqsYMco9JL11xeEiW1qFBN2v7DjFWL0UMVhLhUPNbduq2bjLUD2yxdGjItgwwdJKrpo/csBHlXyzeNpuDnyPssCA67A0vIsMSOh/TA7YIFxK/aPc08GTic2/MC5zZGEZQBh1ON6/JlgdLlQlNOJS2W0X3mcB+9gmwqNh1ZmV/5nyFxZEz9OCXPvlYSuEk04QiOuSM3NRIAIa/AkUsTOfKgCnKN4MKYVMkpBk3WoFGB1xlWjMG5+BWVQR8ytkmP+WoIJk7xcaYGLOTqEfhBILCC5H+orXEWyD56hUz7hl9p1tPcwEZSpoKZ90zSfIOHer6aPcWy7eCwMDFZJCFTxsXeR84YvF6mSUlrPqYPsbLpCA5j5Vs3B9/85pIl61Hed30+qDGCUFLEGvngdsWmRnnhkvH4pFt/ZT8FJVHAeSqRaxTIu2j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39850400004)(396003)(376002)(346002)(366004)(230922051799003)(451199024)(1800799009)(186009)(7416002)(26005)(83380400001)(4744005)(2906002)(5660300002)(316002)(6916009)(41300700001)(8676002)(8936002)(36756003)(4326008)(2616005)(66476007)(66556008)(66946007)(33656002)(1076003)(86362001)(6486002)(6512007)(6506007)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kAJkv1iUAWXbRU+GcSdIJgWjiftCX4DneZgjN9D0bBwz2IP1XdGr4YtleY7A?=
 =?us-ascii?Q?afVO6erBAJnE46fhL9on885ep+ulKTeGmf0P6ByGKWyL+ZOSbxHRLVDheppz?=
 =?us-ascii?Q?46P8cW6PRvaoZ0OBrUpxCrwAqzyKFfapJY1+u3uJDDYs5MBe0JwxDHLMJRW6?=
 =?us-ascii?Q?JNlc5jSpfogAvI2J0ZQsIMmGW8PDr4GkxQcyYJpFp+Rg0p/kb6lCsvFnQTfD?=
 =?us-ascii?Q?AnkVUybC7Bg75W2JRxb8bzVXbFWCVwwr4xTFJMJmXYOtsFlWou4EbJb6tSZq?=
 =?us-ascii?Q?IhaMMsugvrYdti00Uq+Y2WeBrNqUvMxHjRqPVfGjxCg93utIfl5Uy4Q5pB52?=
 =?us-ascii?Q?McQPBbiJoevgKI3QjH+4Dqcw+GsUaFPHhJPOIMtGDuCJQI/i0LaHhIN3rj+/?=
 =?us-ascii?Q?DosqFjyQNqyLtTTZJwkLR7XOSB3Vtm6YlTlvmG0BZtDJW6fWqaLzDz1pkFl+?=
 =?us-ascii?Q?NHkNGRXacZWvXCXar2eRBPk4UDlgpVvSsRpVWLQhqK64fIKr+hcsyACbO+kh?=
 =?us-ascii?Q?v1dw+OfLXj5iiu08WejqntzHKxiem6hG5DWAwYcb4lwAfMkakMhAasi05ryg?=
 =?us-ascii?Q?B0koTXX3taWc5FbWc38CT+2reCihAiRk8j1A+nFbzCEebFmXw5C6hL1qPcDv?=
 =?us-ascii?Q?1PThtlrL9NRpcKSDZDq1uL1evAXTx3h4Uf76el1oj8QGjRBHj2dp/yqyCd7b?=
 =?us-ascii?Q?2mDdQtPF6xH9anZROH/oNKKCtV5/EyUlCrDMJXoC0hqkccUZ885UUJaGqbp3?=
 =?us-ascii?Q?EvJndIg0To4qA4mCTR5FWEOOL4mdNX9JAIjAUEghgQ5eisKKPQzcwyARsgGE?=
 =?us-ascii?Q?Y5JPsNU3A8+zclpHcgP03EXTgasFNlD2UKkC2fzp9OlfpRprJRV7Ld2lt9jS?=
 =?us-ascii?Q?jCz/OouDYDFUgb3ut5yMf4/a87AwMBRNRsYn+oYw8Gy1iNw7T2BP6Qzwracw?=
 =?us-ascii?Q?IiUa31bc4PpuOwHzqy0RAAnxQMl805o6zuE9NSXoA1iGCIJzHZUKbnCdkiCq?=
 =?us-ascii?Q?HPJeues0z8Si+Y0Uqx0lW72UfP1KQrgC6NmpRwSR41VmHBHLoAR57aozRI1R?=
 =?us-ascii?Q?6gqVyVKqIiAayh+SQDuFdquprR4AMuUscGdLSWo9OC+NPhZBuK0qyRBMlRgi?=
 =?us-ascii?Q?PieeVaQr45Dlo+Kox/8pRY68KBegHPMFtX7N0e7p+NSaJJ0hNEckmOmphfcO?=
 =?us-ascii?Q?6Bl0vCw2ZhQWZ53c8InPtKEaAD7aox6d82J3/98/4INXwLgI5Lt/BAsTfr1a?=
 =?us-ascii?Q?FesdsaiEHctKHFu0isSVsrBFV4F+/Z2fibHIWToVHk2CSsRXAmxqWKKvqOyQ?=
 =?us-ascii?Q?nUi1AS5Ns1DY6xZb5UkffxWB2GWuju7ZQuJI4XwxEXAQgnoMvGHWpLRkxG2c?=
 =?us-ascii?Q?DfjK3w7oGD/u8zvrvumo5LYXRZqgUpy6gdCR3FQp7i9nD/SP2d4GyJBXj3V0?=
 =?us-ascii?Q?ogwuW9SLzSeT4MQui2C2sLdcqimHVz3ELQnZH+e0IhsbynXeIAQmmNrKU+42?=
 =?us-ascii?Q?PyzE79M8DOegvbE3oye/b+o+p6hgwq+KjXGMXC1eRGRUFr+WhWv44wAtGppd?=
 =?us-ascii?Q?fl7VtHlAq4M9cpgnPfE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc7a267-591d-45ab-3ee9-08dbbdc4127a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 12:36:42.6785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHXSUcOaMPoHQaoeDEDvZAGOYksj7Oz0+nRYVhwF2Doqktcj1fVxaLi9sgAGn4pA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4276
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 11:20:19AM +0800, Miaohe Lin wrote:

> >  /**
> >   * memory_failure - Handle memory failure of a page.
> >   * @pfn: Page Number of the corrupted page
> > @@ -2183,6 +2271,11 @@ int memory_failure(unsigned long pfn, int flags)
> >  	if (!(flags & MF_SW_SIMULATED))
> >  		hw_memory_failure = true;
> >  
> > +	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
> 
> Could it be better to add a helper here to detect the pfns without
> struct page?

pfn_valid is supposed to do that.

This arch_is_platform_page stuff is actually detecting Intel SGX
memory and routing it to arch_memory_failure()

It would have been more accurately named
arch_is_arch_memory_failure_pfn() or something

Actually that SGX stuff could probably be changed over to use the
interval tree of this series. Modify sgx_setup_epc_section() to
register tree nodes per-section and remove all this arch stuff
entirely.

Jason
