Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D584E2780
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347849AbiCUNc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 09:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347840AbiCUNcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:32:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DD2396B5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 06:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxGQwI2DqYLop6ze5ag5K7W8C8EHlveg1alzFfRig8AWcWLkTMiMBGfwkhV/+UiDwTCi+3bv8CYlQAPwmXUkzS9ORCcgYVLFhWZvGEY68jvUFYViiy1XYCKuhv08U/JiGoop3OlMOujU43yR/Wx7Eku8kmWTSBCP0NwNXw/6rKgcPvidx19KfE4afze1snvTgSqXmKOsSFJ8Legrl8gMw8o78Y9NNVtZfMPlEvz4QoGIhC8IP2KqLJDemi9j8J1sleOE6PMXWFaykzGylfN79tKd3p0xVX2BMhKPsdTH3cUKBM7stOd+aEHBNzdVK7RwHlK+eT0LyBi6J/bJgXTNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EMI7gqmKUrX76c0JuLPSlv1fFItPYAMTkXzQcL2+Nz4=;
 b=HtgdHts7nRn3ia2bJtF1NbsQhtW/vEtyjrZarxHL7BCFfmIqa800KawJtf1IQjAyeqmYSvvQQ4IZW3iwlykYanTqBU2aw1g8whXC480XXSSr4CVnj+LMrUmIa5ORsvxiRPfKcYCR1CQLsK6PIGadXmJGERnzbcR4pcAYFuMHyWeMPSEIcZn5dUxQ9JIhbKVmLXHOgmxjZhdhmTqC9l38zl3t3cItH/9ismYooXrPTDEZqhsyTMgSgNQFCE9rj2YU74GJS76SPu+15Icmt4QbRkaNZIgGyaoS60aDosFuoxT1ub9w9+VozR3DCmpcgj5GqrG7hQNgqt0GX9jBL26FBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMI7gqmKUrX76c0JuLPSlv1fFItPYAMTkXzQcL2+Nz4=;
 b=f+c+0VW9ODoFGvql0wtMpAOw7RMOSJhlTC/asjbL+j+VABbuOiSCr9TV188qWSnN2GVK0MPVsAQiay+OWA9rColAE0E4S6EhxIT20aRqYaBwVjzwJqtiw+1LUmLISWlDfcgpWNThuSOorgLtqK0ZS4GXI+lWq6jZ7AegQ4Ft3XBmcOyIla4O8Reh+VThggEZsyHj0Ucce317KhG3a58oDndKjxC3DSZp1QYBM/cXXlyuq6CFTxXSFGr063eFNFnhQdt8Y5bHphjU8b7YI45c63gm5NdqPOevC8SiYA8WdLGFJYUCEvMLGu2lQVA7mUNW4r5ULdev7maeiXssqdbm0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2904.namprd12.prod.outlook.com (2603:10b6:a03:137::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 13:30:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 13:30:57 +0000
Date:   Mon, 21 Mar 2022 10:30:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: iommufd dirty page logging overview
Message-ID: <20220321133055.GT11336@nvidia.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318124108.GF11336@nvidia.com>
 <BN9PR11MB5276CF40E2B50782FC20275F8C159@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CF40E2B50782FC20275F8C159@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR01CA0033.prod.exchangelabs.com (2603:10b6:208:71::46)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fbe3819-8178-402a-0bb5-08da0b3f07e7
X-MS-TrafficTypeDiagnostic: BYAPR12MB2904:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB290409ECF06686F2D2E039D5C2169@BYAPR12MB2904.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Kt3nsG46YsaXvqBFCLp9X3D0yLfaqKku9/bdpT1t8uaadzu/bMhAAY5EcDGZzFDNW5Y6H+NegxoGiiDPIBCHs8jtH9JejwDQKgNCvYw0uW7nD6vGDoXnfT4jy7NGy9H7w/lFgMdEcYAzjVNhH51XLIT/3x8uxru0GzYUmGF+ObEL79TzJVV8Y0ymrVIB+RRLr1KDIFSJl94e0fjlF3qvH2kh8HDKMZEoFZy90YNAaSpYZPKmQbqhZFLYbFVGfcnthDl5v90qHpX2iUEyzlnYBK7m4VVjgK6yys9POhuxqFNsk08Oq/cCfgfrpez2ym3SC5Gur65WvrnIU2LnBb2rw3muz4Jlu2idJROI5ANM9jLP3xBuAAv2Xk4hD8TVtf4P2AmBMY9KGJDMHZiRPZFBTwmlmgm6It+FQF6xuC2anO2xRlyGI7zSId1FMUkeTTPX7Fh8cvUZPzQujQ1tqiz/Qap5vNSlkfWGMTiFsDZJ/I91L6Ho75Lv9RcilKU6ZbYTYhUpwjT6FfBdqpsGrfJqhvuFa+0ksfGvgde6RXjnFtcYyWCHn1raHN5hPPbrkGRrPRfr1Nz6SzHGhFBb8cQeFViKKJylw1hBCbnjF4l+jWquMsNs6g9fwx6g7nZl3Xen54nVTRJ9ioJLsgja9vCE2o5J1mjDWoMJssmHW30mKvZUg2nM/HyaMNsUZkMkxT3UTtKtJkUUgLhfcd1XwUcFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(6486002)(6916009)(5660300002)(8936002)(33656002)(508600001)(7416002)(54906003)(1076003)(316002)(6506007)(36756003)(6512007)(26005)(186003)(2616005)(4326008)(8676002)(86362001)(66556008)(66476007)(66946007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pNHgdW/Y1GBkppbJ4tgdnQoE8D1Nc/Emw59r9Fq79KCKP1gxZqwqOLXAzPgB?=
 =?us-ascii?Q?qqoAtOwgOwSFO2gVu689JHvHSVG2sSPqnSimEyEz1xcvWeAhojTIRm9oPf3M?=
 =?us-ascii?Q?yppbBvjP0YreXr9Y+hXzclCkM+hG4859gqDD/s5K1rF9LhQ1XDwpkVpVopeW?=
 =?us-ascii?Q?FzG9KYbSDv/VmmJX/3G5lUJiMTsJqS9F4sq/fDtPgN7Yt6UhXuCKYGYdWgNx?=
 =?us-ascii?Q?Ed0fta4UELUZp+fWp9CgkSI//01l81AnjL74dB6ukdOMOAKB5y1Eie9fnUJK?=
 =?us-ascii?Q?T+W/BJ0jv1WTujYUaj44V02o8rTWA9oS6uBAkR/UJ6JyfRqJpmTu/EKCDNZ6?=
 =?us-ascii?Q?YaeDt3VXOZL0t6VrDuaih0xIUNZuDv8tspFYlIIgPNBIqpCUkAABZ1+7k3jV?=
 =?us-ascii?Q?bC3lEDqlN3DWvmyoSi8ifxLWXWE7eKzCskjwOQ4XH4Wuud3CfMxZDxyyh6nX?=
 =?us-ascii?Q?sXnsEOmRSDKGzZC+5igQ6sh+Ibam8SyNvXFXbkqKv0bizwQY7amvD4JeC5XD?=
 =?us-ascii?Q?1vZJXTS+lApPymwwkAVVH3l9J/uqZvL3KKOwAGLu739+P7RZU6Z8wGSFBUpr?=
 =?us-ascii?Q?YAWCgLLSnGL0dC8B551dq8CpxfR0maF+J7fm8q0dqJZ2S8Z2GJpsPeIN4/k/?=
 =?us-ascii?Q?YBGCWhtNpDZTyRSKiULgby+DnYYfAf/Knp9WW+1GLGpBze4CAQVLQrLj4g//?=
 =?us-ascii?Q?AFLQ4MW4UJBZEkt1Zl0OmJ9GUhnMhD9i8BM4Wv+0D3tIJ6NkYdYHKuy9Q2GF?=
 =?us-ascii?Q?LKc6wrUr1dsTgW9/JpBIIVnJqzl5Lh9XApVRXVEBow6DvprSe//X9/8/87wx?=
 =?us-ascii?Q?DAHBnAjcCG8OGk7LYuKeD0h7TljEfu+xlee4XNAkESA+XsdjifKwzc+kH/xH?=
 =?us-ascii?Q?neHYHCKms/+RvkjlalCaOfxgVzWo8tp6sf2jZWnrKCMlRSCE26pVmtD5yMFZ?=
 =?us-ascii?Q?FozlerzWl/coxwtuJS3ypc5/PKdQ95KNwO8qi2RHIx2uAoqLlmDZ7PjE1h78?=
 =?us-ascii?Q?X7HiCobCGlQfudm75gzhboxoxJ+hmg3LGk2ZlWI0qL048qONjJAK9yASabGm?=
 =?us-ascii?Q?qNFcEmH3c5vBf6Cn7/t6wyPWf9Ija6/oOM0u8/GLYlSOSeYjypHLfEnDwlkj?=
 =?us-ascii?Q?q0E35B6JqSjXCikZLN4tZZQv2Jg5/ZPc/yPJo8xG4y6E/vtPEpk0ltHju3iL?=
 =?us-ascii?Q?2Zs/wPyOq2lq3/u30HesSeTkWuI2i19c0GMHgCgFXyeCPICL2e/AQ1ccx63H?=
 =?us-ascii?Q?90WvuyQJuVE/PnfqQdkDtHIoXxLq249xQsiMYi53X8Uc7uURXzNrVBnciFYS?=
 =?us-ascii?Q?Y5tac2LOTfnRkxfegi30PYTaQ+fjE/Gtafa2ExHJy8+dF+hFlr11pe5LtcNR?=
 =?us-ascii?Q?zdD11Z2Un1d9U5Y6JC21SLi7gqO39SFCDR1BEQwiEv/IrnwhI/6ASTNy9O3I?=
 =?us-ascii?Q?nLOcakmQl3d8VeXI0OHyPKnbXQoD8ihG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbe3819-8178-402a-0bb5-08da0b3f07e7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 13:30:57.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ke817H7SSES8jrR3GeKs4Fs2ggvgVm2IEJ7zyM6X97X1Gr+GrZGuK04jwTmhDiKe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2904
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 20, 2022 at 03:34:30AM +0000, Tian, Kevin wrote:

> Thinking more the real problem is not related to *before* vs. *after*
> thing. :/ If Qemu itself doesn't maintain a virtual iotlb

It has to be after because only unmap guarentees that DMA is
completely stopped.

qemu must ensure it doesn't change the user VA to GPA mapping between
unmap and device fetch dirty, or install something else into that
IOVA.

Yes the physical PFNs can be shuffled around by the kernel due to the
lost page pin, but the logical dirty is really attached to qemu's
process VA (HVA), not the physical PFN.

It has to do this in all cases regardless of device or not - when it
unmaps the IOVA it must know what HVA it put there and translate the
dirties to that bitmap.

> given guest mappings for dirtied GIOVAs in the unmapped range
> already disappear at that point thus the path to find GIOVA->GPA->HVA
> is just broken.

qemu has to keep track of how IOVAs translate to HVAs - maybe we could
have the kernel return the HVA during unmap as well, it already stores
it, but this has some complications..

Fundamentally from a qemu perspective it is translating everything to
UVA because UVA is what the live migration machinery uses.

But this is all qemu problems and doesn't really help inform the
kernel API..

Jason
