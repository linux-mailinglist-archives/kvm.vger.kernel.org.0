Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD0070D042
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjEWBN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjEWBN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:13:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267B68E;
        Mon, 22 May 2023 18:13:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbHNQjAMmChJkvVgLS9PoW3/qaWCkionlKMpJOfxxUQOUOSE+vH94chEzjD4YKEYRCYxeC39JOeBFB84BA+/Ro4VT1C1O/RFbl3f+g7c+12iX8Gt475kghp6zXJwAmpYKcTIENNC9bT4bfuDNRewBnupngDXFo+R1G1IXTcbsnopLdwf7oIbGsPuk7GMBCTZmhT/sg+JR/fn5xpaoyNACp6EqIh/IYgeyac0uF9698ChlOvTl/ccpq8MJWT5HloZWNjqRc7LW5+s9wuI0Yoy7r+W0/MHdMSCrtdtJs9dR5sSe0cQVkDGagHk79QEA+phqxya8AwTo6aNf5EtgfjP5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaoZvZ7PcsODjM4YbsLX41nX5qKGCjGV/V1YgToBNFc=;
 b=a2F7Av761ATbD1W3cdi/9nGkJHxStAttqO1SLIw7xsEj0gtdcoLZ+Yjlo1aSZSez9PNNFs62S3D3yaRcacQ9MQXBOFvcRagyRjwsrk3V/Emiu7/dLAHaogkPMl09nweFuYpt9fp3vSclJfO4OPm59/KJvpHF9Xirxa2hzSAqlH+vds8YFlOK5Ey4b3df1M1x5avl2j/Zv6E36DGV/u1ZayJAEfE5B6nrCmwQ3P3zVt+ZMmL6CC9Nxqfld6+xtwVt9QJYLBs7YUP2D0fQDE7f1NYN+UyKeBB8zcSpegYkCkXLr+lIzldN5mb2m69z91gMRiE+12l4Ij9C9gMCfeQTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaoZvZ7PcsODjM4YbsLX41nX5qKGCjGV/V1YgToBNFc=;
 b=XZ4V3Eg/4F9hmGgHzkeozEmwLvG/RQRdgu96bpli/uqEWMYERs6T478w2hfJIYSD87lSrn/wBZbyV+zpA9U8kG4FkTdu7M8t7lZzRfHvecL8afrmBAGHRkR9CVtzlpm9gNn+REyXMBaGcR9b+9U1R0fJChq0e0H6Lg1VMSEKknsR0P+fZbtid6wBv7ERPCwJxtEVCSRpCqybph36Mer8NTVQTcmloxYLHRgBa9u0xu+FJM1Sa04Dl5wlTwsPZqXGF1kMfxY+qTOsZfqR0GQIEoqeNRqgCD2FW+/QDL6WF7dyzCM48hiZUaw7vyITMu/SBxRg99TsP/wA6ZNrf0Teyg==
Received: from DM6PR06CA0010.namprd06.prod.outlook.com (2603:10b6:5:120::23)
 by SJ0PR12MB6943.namprd12.prod.outlook.com (2603:10b6:a03:44b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 01:13:22 +0000
Received: from DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::f) by DM6PR06CA0010.outlook.office365.com
 (2603:10b6:5:120::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 01:13:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT095.mail.protection.outlook.com (10.13.172.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28 via Frontend Transport; Tue, 23 May 2023 01:13:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 22 May 2023
 18:13:10 -0700
Received: from [10.110.48.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 22 May
 2023 18:13:09 -0700
Message-ID: <b99d20a4-ab1e-4e67-37ae-cb22777317ba@nvidia.com>
Date:   Mon, 22 May 2023 18:13:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <robin.murphy@arm.com>,
        <will@kernel.org>, <nicolinc@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <jgg@nvidia.com>
References: <20230522063725.284686-1-apopple@nvidia.com>
 <ZGu1vsbscdO48V6h@google.com> <875y8jappz.fsf@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <875y8jappz.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT095:EE_|SJ0PR12MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: 13fa6ebe-0428-4031-8866-08db5b2ae6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rczXf/qmpC7OWWSOaotbJDL0r9ucVIF+1pGzmDPZXXUW3JAfYIbVgzhXmFy2pJd+Ti/CJXma9LASIpAr66/qv14QHL56WkMF/X29MfTBNn0/eYKQqJ+G4o/NTReuUKE/bigLXFxvuH35dL4HsZ5mfCVV7FeLBWvU6sKrYDLkgjOtVQCXh55K6VPTbfXRMQsl6Gjy7fx4vELVW6uXgWNAHwEQXu+o/L5XwrWCTo5YGq2FG8Yyqi1Onj9dXSxy31GULRE9rKs7NL5wlcd59bpetw8hEkZnRCE5goy8kLGyhHSuhZSf3eFSlaNDS1SrXmMyPu56XTjdnyWIuYonuOKPLU2I72p4GMhMrJUeVGX6jJnZWy1zoL7sil7jPovBj4/kuzGD1MrJuZzif0Ao1aVzLisIeDoOdMibNxUl1yz0SyGc6hBJRATrpcVfXKqiIugDoZNOdM30Tqoskjf03KCVkFK+POOb1BLnasVyMdKOcnzQkSOW5PXuhNEJT3avd75ac3ms4x0pAK5z3DsM0PTCRxRLYU/7SsoSq/GaPQ00FuQDWtupDXmKvdmUUVMIlcT23fZMJr48U0znZhXKuGb2ZmoplQcbEhCFCUEiANPeO4mHFTYLLKtWL7nNVPhIYHbJ32Xr6b6pjhxRstz3KTegAISO7nDrRyFCcLouSaJv69UeqQjHaGtIZe3JIcC6lf+VWQSnX/Ep4EzH8qi2Pxf3KV6ZDNfCXBjmqe9aUGBdPsc3Ae3ywPkCnQ6unLElP3GM7YdpVh6Nu2NK2yzdmNj+uQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199021)(40470700004)(46966006)(36840700001)(31686004)(2906002)(16576012)(66899021)(5660300002)(83380400001)(47076005)(8676002)(8936002)(70206006)(41300700001)(4326008)(70586007)(316002)(54906003)(82310400005)(36756003)(110136005)(40480700001)(478600001)(426003)(336012)(2616005)(7636003)(356005)(86362001)(31696002)(26005)(186003)(107886003)(53546011)(16526019)(40460700003)(36860700001)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 01:13:22.1420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fa6ebe-0428-4031-8866-08db5b2ae6d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6943
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/22/23 16:50, Alistair Popple wrote:
...
>> Again from include/linux/mmu_notifier.h, not implementing the start()/end() hooks
>> is perfectly valid.  And AFAICT, the existing invalidate_range() hook is pretty
>> much a perfect fit for what you want to achieve.
> 
> Right, I didn't take that approach because it doesn't allow an event
> type to be passed which would allow them to be filtered on platforms
> which don't require this.
> 
> I had also assumed the invalidate_range() callbacks were allowed to
> sleep, hence couldn't be called under PTL. That's certainly true of mmu
> interval notifier callbacks, but Catalin reminded me that calls such as
> ptep_clear_flush_notify() already call invalidate_range() callback under
> PTL so I guess we already assume drivers don't sleep in their
> invalidate_range() callbacks. I will update the comments to reflect

This line of reasoning feels very fragile. The range notifiers generally
do allow sleeping. They are using srcu (sleepable RCU) protection, btw.

The fact that existing callers are calling these under PTL just means
that so far, that has sorta worked. And yes, we can probably make this
all work. That's not really the ideal way to deduce the API rules, though,
and it would be good to clarify what they really are.

Aside from those use cases, I don't see anything justifying a "not allowed
to sleep" rule for .invalidate_range(), right?

thanks,
-- 
John Hubbard
NVIDIA


