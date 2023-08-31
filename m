Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A2078F245
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346854AbjHaSED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 14:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245422AbjHaSEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 14:04:02 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D6E45
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:04:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqCJWn5Qd/0sKuPwVsxhc4mJKbWLAH4x9wX/TZ7VYeWUBqZ19Xdc9e/1A8Hwp+XaHL5H84cWFRW5DXvKlIW/sPxeLylEx/u7Owr3nY7vniLfJoICUYX/2i7dLexpi00Bphi6DZcIvcZBUpBBwStEH/bCcWINuB3qJm5YerPnVlwnAkZuIVKXfJkgc5nMVHB3Um+VAaEWe4Q1isr5XSjd3B3Qgrxivz5KEdap4qw5VhrKNMcS0Fy8tAoQgC0XEzGhAjhXoH7e39YsrYy40Dngz08ADllXTKlda0KMVGhvZEacgBcEnmyYsvSCvoyl/VTbWHHlGc95E0wX3F0EUrFkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fILcOJURw29+vX4/kZ077MGdt5BQJXNogaFSpQz5Pp8=;
 b=MPcZsc8+m2DXUSkg1EQazzx5vCmZT5pTYFKJgWlwtx2MKJudIN70kYrRivvl1W7bwo9XRR/qbjJ8ff57iRTjkkrLgh7BSFxejGW+IvePeKppGY1JkIZEsBeSim73zHih0H/pWd4nVqRjxOTMDGEPn0pbJOlX+XXRq169Sk+je8OzcSIxoQmcYsp9s/SjcuFmtBT5hbTnI8b60i/x7ezV/reqfHAGwviJPG/PS4Lz21Ce3sL4kw5OEcXzopSeYupHk4IDJaejIfE4rYH4TIBqY6VtHOz6cT0Q5ZUgPqhfmAII+lU9fivpxQhokdxrr6dPNA4+HjhQzHwkOPBkviXbHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lst.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fILcOJURw29+vX4/kZ077MGdt5BQJXNogaFSpQz5Pp8=;
 b=pG3vZwkzHOq7yweb2d4DPh72vfFtDe9u8MXLR/mS3snDOCZiKU4dq9sXM66o3T/8+D1gt/c0LG1Qq/1I1GakkctfMF0pgJkIb76JaKoc1YFJNF2PZxL1udtCILhqqmPEXyP4PU0aU8AerDYj1cklxnyL45Fq5tOWsBLuv462Mlg=
Received: from DS7PR03CA0158.namprd03.prod.outlook.com (2603:10b6:5:3b2::13)
 by MW4PR12MB7358.namprd12.prod.outlook.com (2603:10b6:303:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.22; Thu, 31 Aug
 2023 18:03:56 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:5:3b2:cafe::cf) by DS7PR03CA0158.outlook.office365.com
 (2603:10b6:5:3b2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.22 via Frontend
 Transport; Thu, 31 Aug 2023 18:03:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6745.20 via Frontend Transport; Thu, 31 Aug 2023 18:03:55 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 31 Aug
 2023 13:03:54 -0500
Message-ID: <d33f6abe-5de1-fdba-6a69-51bcbf568c81@amd.com>
Date:   Thu, 31 Aug 2023 13:03:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To:     Christoph Hellwig <hch@lst.de>, <joro@8bytes.org>
CC:     <suravee.suthikulpanit@amd.com>, <iommu@lists.linux.dev>,
        Michael Roth <michael.roth@amd.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        <linux-coco@lists.linux.dev>
References: <20230831123107.280998-1-hch@lst.de>
Content-Language: en-US
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH] iommu/amd: remove amd_iommu_snp_enable
In-Reply-To: <20230831123107.280998-1-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|MW4PR12MB7358:EE_
X-MS-Office365-Filtering-Correlation-Id: befd4d0b-ccc8-424b-8c02-08dbaa4ca46b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPImhrp+PUeq8I6F13KdiXimDUDJ07KjH/nIyfC2eDtckR4C9pkTFz5DAM6FxI2rLM5+9JymCngJO5mHfPeFFFeiy0XOj4CoDKr6ekC0S4VjgREP8AQDpUSTPE9ZD3CegsMDdFvEwzmLlRLRdjB4Vm+t2hQzo1pOkf9k16orUOmX5OR7cak1Dpm6ZRf/bF80BzPMiyfHZy6lE7RxX0Q+ZNyYJ3jtxr2gJJnqAXEUmhz1T5pevezPrmGEdPVheiD7CDOw/6LT1INJF34nxKIutEN/gRcZ+6uLoMnt/e+OqKEvnh5NW2B0iKJHSgmDO4P35aWTe7b8iFGaB7b9v1sGD5D1vbtnQ5O7JHmjg6MjLrbdg28O2f5N4nCol9at9Nr0rWI624ZcQuMsZtiy8SV1fwyRv5cn2ijf6MzK/ce+/NVm1UALcPBVxYJjc+WGJKJ6mc3MPit0pXGBfKQINTaClwddu1eB4RpBLYAoazXt4FijHG81LzO3JqRn2DOUvgslTwlpKfMLr6wpfMVGPVjb4nPhVKSWQuHYI/ydGfE8JUWAwY+Sli8zEwX9OfdWRdhHDN3g4gbSsIZqDlz2ibFNP9gydepJjGQAYXd4NulhVchriUOH5PgeQvruI4kTdbph17gS2iF87kYX+wLtQoPB2lvkP2Yzuwl9k3zG6Jsvwpj2dm2n6sBL5yFjCmrCwaeIcETcp9KOrX31ffI3WUPjlXNUO0UDdsmg6w37AqBppPRJexCqwOvngkpIxDiOh5BkkAVrvgh7ubHnSDPN4NChyIwU82IbnGSFllHbuFnSv+c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(136003)(39860400002)(346002)(82310400011)(186009)(1800799009)(451199024)(40470700004)(36840700001)(46966006)(40480700001)(82740400003)(36756003)(41300700001)(336012)(426003)(966005)(26005)(40460700003)(16526019)(356005)(54906003)(110136005)(70586007)(70206006)(81166007)(316002)(16576012)(478600001)(2906002)(4744005)(53546011)(86362001)(5660300002)(31696002)(44832011)(8936002)(2616005)(8676002)(31686004)(36860700001)(47076005)(4326008)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 18:03:55.5023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: befd4d0b-ccc8-424b-8c02-08dbaa4ca46b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7358
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Mike Roth, Ashish

On 8/31/23 7:31 AM, Christoph Hellwig wrote:
> amd_iommu_snp_enable is unused and has been since it was added in commit
> fb2accadaa94 ("iommu/amd: Introduce function to check and enable SNP").
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

It is used by the forthcoming host SNP support:

https://lore.kernel.org/lkml/20230612042559.375660-8-michael.roth@amd.com/

Thanks,

Kim
