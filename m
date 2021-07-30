Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66C43DB81C
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 13:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhG3Lzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 07:55:32 -0400
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:31616
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238222AbhG3Lzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 07:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9adAxqmta1jgKN/JXAe2L53ZG5v+pZR4k+iNPdHtNBjmsmLYARmiizgIp9gso38GIYfzqDukOIMw4lRuSV+fdCR7P4X7nhldLRK3ZsE5y4twBSpTp97blnyRat6n2kccBfCX6akBUrr+P6Kp154yK9+NR8ZChk2HqF4/CgU/MOWSDnwut6QGd2myueXpTNYergc0vmocDgSJC6b827WXRvlaoeFCeVlrDCnOSnIsLxLoV+qfvZfozyoniDUWPiLTI5PaGIcPyBpEo7vxOGixeZnvUaduWoFLisv/T03YX8KI/ZM66rKpOzLnZDftzE3ali9hfXgYfiopBBgNthrvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=135e5s5iWEcEoyiM7VPcpLx9QNtZtzKolKeJZt2zgpQ=;
 b=Zo4gmtp++F2P9Jrd1tNqaDGwytocn1mpxysI4P8frPVAiQRBurKULIjeifofVo1Nxj0DQB8FDJ9UE8C2udiWtHQnMR1zkvQebHGJIMxAfYhWOrXh0/mP5TBX3hWpJW0BV7byJOLv6KWlRU8CgyMaQ1QZE7w5yZwJ/HelJaZNtSpNrPRbnpdo/pTW/mZ35mCncA3MrqtmAXkdgrpXYC3n9hJIPhaWSgnHRDgRPZPo+kDQG0iVuC/rEj5oH35+nMoZLwKGsGFscKKTw5uwsgdOI8QdyjyQ//TyR5z6jrfGP02YEww3lGjIOR0ApxJMzm2U6vSulfHchhXsLaJ5w30+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=135e5s5iWEcEoyiM7VPcpLx9QNtZtzKolKeJZt2zgpQ=;
 b=i2xkvfbEoo87cjK5XbwzBVtrqIV0PiHW40GEdPNVKuySprju7rpNX4/d+5DnLTYlZX/7uBNdc/rlA9jZ4svssfx+D5AwlZDQ+Vhk3vRanw0nsGbmqJ7KJe7pRBLZ3KJE0NHArgBT2KN5VrnBL/4LmImRr6dM5NQPu1vA3hJ/PtRD8wSp+mFXjO/rk2kNHtxMswNYHuFPJ4n4Pwc/eGrGh5fopdEVhRqZelj1z5Tygwow80SDwdvNbVdktqncRRfM7xJmEFctUMJZ1RCg9Vvvm9ctLyaIg2/fX9bP9hBkWd5BoylIWryZBX12UrT07nFl6sfvX+Ppu6Kc/TzJLFWHnQ==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 11:55:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 11:55:25 +0000
Date:   Fri, 30 Jul 2021 08:55:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "aviadye@nvidia.com" <aviadye@nvidia.com>,
        "oren@nvidia.com" <oren@nvidia.com>,
        "shahafs@nvidia.com" <shahafs@nvidia.com>,
        "parav@nvidia.com" <parav@nvidia.com>,
        "artemp@nvidia.com" <artemp@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "ACurrid@nvidia.com" <ACurrid@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "yan.y.zhao@intel.com" <yan.y.zhao@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v4 00/11] Introduce vfio-pci-core subsystem
Message-ID: <20210730115523.GV1721383@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <01765c3bb55f48cf866dc3732a483eff@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01765c3bb55f48cf866dc3732a483eff@huawei.com>
X-ClientProxiedBy: CH2PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:610:59::38) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR03CA0028.namprd03.prod.outlook.com (2603:10b6:610:59::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 11:55:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m9R6p-00AepH-BA; Fri, 30 Jul 2021 08:55:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 954a0fb1-3502-4f1b-2973-08d95350eaa6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53522013A165328753B75FF3C2EC9@BL1PR12MB5352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MU+ZIn15qW/cJDMl9e+HqMYCdaTX/0CD7zU4HMGtnj6X/LwCUEBnNU4oH2FNXfpdwCvRrLf/0GgexZ/TOE+y36vPag6UJeTMnGijuiAS3vmB37N+6DpN8iA4jQRvnbdAXSRVb1by1kPXNxYHzbfDAbvd+lCtxvAyoSE57/rZRtSGgTOKvOprafh5gdpdxVEYPnsSccH/thfiHmHBHLQP+A34K5XUcTiA9TNQyIFqeWsiVSgsTo4EKUuub+qD7XtGUJoYJSksw1YmYGedoVQ/f2J0swjlxAkkya5ssaMuAMibjyn0nP7rYD/8VDlIKB3/yJBzU5i0EutTXxQUV0lk9UaMt6wVbk73sufPgZaZUrMIg3JYH1Xhq8R6sAWB/KI95KpK0ywYKt3Kz4GSchIeqNC1tVnHMhdIC7VqaIiiuP+2ZP4lpvXfQi5UCXsJeVJFwRkjfR/ovHzupBs9KGVIrl5Vx+OPKbvd//1yLN/6LxT5f9cod8A7kmaRkobC3HpHCPh9lcL+2TzQagaA6XW4xXdtGqptsfJHsBW1d7KzolSvpGXlFHZFcTNorwYHXUUNWgwzd6CLH/yVPWZZtKuQUzvSiLp/JDAyVY+KOpGfKMusc2lXTWkSNQJ+2YBZWbpAeAmf7ZSTTmJy8ERvAO7GNK/J75bfS1e4s1RV/k7+5OQyg2wKCdZ8Uq6+tDlsrfCHgVRwDHsIRFa3oe0ixXq5n0iCl8z6GVUEL74WiZJMerk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(66556008)(6916009)(83380400001)(426003)(186003)(8936002)(54906003)(26005)(66476007)(8676002)(33656002)(2616005)(478600001)(5660300002)(9786002)(9746002)(66946007)(1076003)(4744005)(966005)(4326008)(86362001)(316002)(2906002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?351FPqBzd4iZMzJSbHsMgiUyFmynsHACWWWLxqWysyfEjcaq+NIHZbn1Mw+r?=
 =?us-ascii?Q?uRzE7HuUm1WfxSVRIvPwpexgcXkYC2Id82/A9lnsTg33Clbm9ZZbJUVLem9u?=
 =?us-ascii?Q?2LSiB7mwl23ut5yUzAXPN8DhK8nCLRUrdNAJa4cd6Xsw6pbEXf5Zg3k+G1xz?=
 =?us-ascii?Q?vRv3beKrkSpgtCCrHF0PpaTWh8mF+22f6mND6LFzbW/MFdaK1frDP3aaCLXZ?=
 =?us-ascii?Q?0qats/yUC0FgeD9e0o1WSYb4KaTxW4JeB0vf01qiWcO2W//DksWxf84VK77y?=
 =?us-ascii?Q?nU5PiS6KOWvgTlr7/sL1lAMYPFtb1uS+DP9mGO3F1lacp2GPb7nhYksujw/E?=
 =?us-ascii?Q?WYHKI7C748Tdw6BZWpC+r7FIlXiDOXVlX5PauneQTEWLUY3jZu1I8iFl9VgR?=
 =?us-ascii?Q?Yzyaj2VNTI8PaLs547RxRYUcmCOiHAuM3+pjMvmVqpxnay2zY9WSrUIZTRFj?=
 =?us-ascii?Q?hBPCZ5npNn1jNP6vE7OibTRT2Qfncl14hGsE2Ge1DmmHdmBQ8kjo6WZ6nsK5?=
 =?us-ascii?Q?Yfqvjs8SxsKNG6AzCbL5VDzWmLmbVmpFrqt4FYfV8RBvHQdMmKjbOPuCVH4h?=
 =?us-ascii?Q?QSgi9s3BCI20lf7OsNLQ8vHSASYo6bvi6jpP/F2a4IAWh3Ml5S3+Ew0/7oez?=
 =?us-ascii?Q?i4/csFwF3FbtQhSBeMyFu9+uCWmAkSJjZkV/Jr6Yun0D4v1B6ft7VwU1U9Yj?=
 =?us-ascii?Q?UpNSTy6WdaT4phOxTjRfuK1cH0Pu1tpH3WLccWDEH0Err6eAjilORkq4yS+h?=
 =?us-ascii?Q?2aBtSUJ0iC0Co10xQEgGa9cKEWq+Nbi2GPGFcYaoSZ7HMTUQgIBOWogweqWW?=
 =?us-ascii?Q?BtmAJtFNB36+CbPHHQ/uRqUjOlJSx6tVV+NGExvIVEwhQFNfdzTzt3QGRv0L?=
 =?us-ascii?Q?5sAsC2CNMd1MHXYMugDDwqlsBgfFqNuEy52DsrVLajXnEkNC9dE6CzNdo8/n?=
 =?us-ascii?Q?J5yxD2Gho/lYdRtlbWwVF1cqjNYqrj3iCkl7OVY11CI0nK1kU5VSqKHb/gDr?=
 =?us-ascii?Q?LEOdttmqiFbcdPw0zTDFwEWf6jDDAf1pJCJBmDrpTzSuYAlfR3ppNJrwpcAr?=
 =?us-ascii?Q?ehkIWsso4G/y6S/nCtgPcHF/cHLxh0ImQ+kPs6BS54hzfBPbHrsvfl/nnlMY?=
 =?us-ascii?Q?U+kAMy5ZIofxDeioN8MVQkPkwjdMrL/hzNjJsta1uE4Bh0q1mWgCULCnVOkQ?=
 =?us-ascii?Q?jTvmypaRTSfJ/QJE1cKturVnFWz3o5I9dMUUUS/ak10ObHjJ6mXnkWAzLi7V?=
 =?us-ascii?Q?ZSAOFIHlW5g0jolWeDn8IPTVHpzS2bRl+7+PxGBj+9a047QBv1AeJCsJZK1f?=
 =?us-ascii?Q?b9QGcxt+t06p2GwP09SEa9H9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954a0fb1-3502-4f1b-2973-08d95350eaa6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 11:55:25.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4+FcO6Nvuaxqdka3AOuseoE6djVDJdAoji9wwNN6gUkBYF3GjMGlRx8zTIXmhdl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 07:53:00AM +0000, Shameerali Kolothum Thodi wrote:
> Hi Max/ Yishai,
> 
> (Sorry I picked this thread instead of the [1] here as I don't have that
> in my mailbox)
> 
> I see that an update to this series has been posted by Yishai [1] and it mentions
> about a branch with all relevant patches,
> 
> " A preview of all the patches can be seen here:
> https://github.com/jgunthorpe/linux/commits/mlx5_vfio_pci"
> 
> But sorry I couldn't find the patches in the branch above. Could you
> please check and let me know.

I fixed it

Jason
