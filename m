Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A361493AF9
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbiASNSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:18:22 -0500
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:41825
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354772AbiASNSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 08:18:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocexI33Qi1kiDYl9D2zsWBsoiY1OGPWYeQY2QYkAFBRl3vkKWROXoX2DDwmh5G83qZpTRIDjlPKYuMy+0hQcmqbsx/g+1wISgsxcrqH2RWoTWR0XHyMWA15l7tILxGrVCCUv86UOlhxx0riKqtXskR/mkaZBiVbKEWS6qWYju1phMU/014dMsV/m85QaX9t2LlIvRlRmNNZmkABn26klzhIO9q9pLfZDfVjF+TkAI4IDwN08ekBZod9JPFOV6Oo+A9mUQfTrkfpH5YwMDJqgrXEyhL7wYszRlK7REv0WMRbP7fXPjy3rGT4opU5BUL3kqiU0Fy9S10YsLy4m+cY1hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgvqFNu/OaNDZD1IWQcg7yNE8fFwUiafDKeOcshl2Pw=;
 b=GkN7gP9sc1uTliIU2PvxEW7m7mL5+V2upiKxaHfQyKmBL4Gt6IrWENXxe1K8Eqpy2KEkfTDRGG3yakKEN3WIU3aayEYT5rXqaYjDS2CaW3Oah3GyhuvXlVu4recIaBRcg32O4ARorcqwM7DrBdQxQLyBS3hkYT6lRufxl0/V5tD2s8OPoGbCLk5jGwl8h8bWEHGYh7sfLV43AB7168J/v32aCeZ/GIwmDWXdofuG1MEgIJGaFQKjeYDljrpT+th7/a60anN2JMhKgU5ItFD7iITiQKtBg2DIdDrFKDzu5akp39/G5ORjY1f3FLUtDGk27ZjQA9n6nfoQgj/LTSv/Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgvqFNu/OaNDZD1IWQcg7yNE8fFwUiafDKeOcshl2Pw=;
 b=kjKkj9vChjL6uWYrAy3FqvUDouuq0IRC8dUfP2oYpKxoBSF9AksOXAbjSmLMmwCc0fM4sZluTvLDE1o5/OH0ZXJ6KWLsFjqOxbHblqEq9LcCBpzeqBbre97yTOQD3Dg3GcG2SF8wK8m0Wq/gVFDrzGdVaGc37nOFthxXfJshfHfuI/m2HduhL3wKptlsLwoWmACCEOr9zQk56x2h3pJSbouIJC/UH4sDkIzyUjqM2YDysTfVV1oUj1vufjDeeHncejzPxWa2n3a74ak8y4r0gxCETF3RJXMVQtDrNRK+PU+cp24UE+Ma/Iyblwi+hQoN5aRoxYnDLFmITh3ZWLjkTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BYAPR12MB3095.namprd12.prod.outlook.com (2603:10b6:a03:a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 13:18:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 13:18:19 +0000
Date:   Wed, 19 Jan 2022 09:18:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119131817.GK84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a211644-de14-48d3-f234-08d9db4e28f9
X-MS-TrafficTypeDiagnostic: BYAPR12MB3095:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB309524142993C7686648112BC2599@BYAPR12MB3095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H2HkfHF0LHnedQ/t7Eoilyu25j4FCekkMl7goVFu5uUyRkcM2i2dJ+M2siGCNoFFtro/rQ7cf19tnrl1nDO+tbWLctdrfSZx/ibl4Q2tbap3toKkLwH3GCDNJ4oaG91183Wq95uzcMPbjvjoPHM/NHj7rkO7VLrxCaT6p1CETYAQFsR2nQuoHW+KH/TteLFB+tpAnjl4BmpGK5oKsppsRUtkJhbD2+yYvJF50YeH0jxXuBoDYHtXY87f5Mh7OFzGHvG/NfRcNBbR3pj9td4GZBeYFPwroyPi3gNJoT8vuX6rk7uSuLvOECF7RuPaHtvQ94kCUHX0SUOmeq4uTBp3Wekudzeea0bol2ldbpR7nt/eFeD8HAG9BudXVoYZueK/zmc3NgNwfMPzTZvQI9vuSycnKCwsefMX/nshTcAcmRbESNh15+fiHOuokgBiWE/RdckFDuXozakLLyeicmv4CXsPYDVzEY8ci7eXnG8PqxUxE6u92WI2qNvGZoKZMzvz1fUDeXPOZB4dYuP8QYGWBNmOqJCigy6frTEmryKZUhmr26XAUS1WSjA/SKliH0BnYyRzCH7FkXWon2N6oC4qyo4PR/kseQuRLfDtrJ7L72MRPqYOi132WyPcgePgz8+6kvyF68LMG3qPVPeunDYb4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(38100700002)(6506007)(6512007)(8936002)(6916009)(186003)(5660300002)(107886003)(1076003)(26005)(8676002)(508600001)(86362001)(6486002)(83380400001)(4744005)(2616005)(33656002)(66476007)(66556008)(2906002)(316002)(4326008)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UgjA5LPntdSH3l0R4lCZRdRSctZphYXoM7s8mDvP+Agw5D5gwgSAFRMTTK8M?=
 =?us-ascii?Q?QDoCtoryBCLmW8aoRjy4TE6gO2MEuQyMQrH/N1L10lyHL4wqvM/1Kkuwb2UA?=
 =?us-ascii?Q?/F2KtbtDtrIHJDjCz/D3DSinfrPYoqo1JvEinpV3pGq6i2vaVgOsq1oB1q4t?=
 =?us-ascii?Q?D5SHSZ+8Zsa9Z8BE9Nvte1kW6IWryazSvrO8KpXGuoatkhmqSGgZSIiKViRU?=
 =?us-ascii?Q?/HnaNVuC3+0eStxd2NBiCM3Y2qv3z0ygdDzVDVrG3CehDiUs1zjwkMEtNiTF?=
 =?us-ascii?Q?CP8Uq8d3MxT1TsaLTg+sw5UmAcpcKa3nnp/LI5CAcjDxRQ0yBms/BqsmQmJM?=
 =?us-ascii?Q?2T6c+t54GwzQHHvQQXVzrb5l0ZTEMcGmkNbWKtDQq7JV2rPeRJnTkZwAHUNT?=
 =?us-ascii?Q?k3Mhq6g0JiZ8fCYiLsqSunS5qODb0czcFNPOoyToVbhPncdC1hLl7dZHE29E?=
 =?us-ascii?Q?rs3Kme0HQqzQ/x4V9ejiDJ8BMNARzR2X0cpGcRPNhsFghvyadHkhJfTpq2h6?=
 =?us-ascii?Q?eqbiJTn7L0Lt0DuIKUl4drFstoNZZ8g0pRmHhxEAPDvdDDDaSBaTcrdjcAH8?=
 =?us-ascii?Q?HjFrgfo2wSfKn7DLH9W+brwrtFUcxq3c7sNIiLmQq8j1WsWaItDdoUklu4Bh?=
 =?us-ascii?Q?nsVXTY181tcWN1/5jmDHbHksYNzJXpKbT1RtogALG512cqn6c9TMFaWZEgVN?=
 =?us-ascii?Q?9vprt01bJ2S+eJGGfl9FktmGyfagsddR0sXuKGiSgCIYYjrXVI3/VUx8XEUI?=
 =?us-ascii?Q?vN8EwL1fgVge/ogIXcA9qRt7ykls7aL/Tl6jugeEvv7IaO2dxkTv3zrmbmzJ?=
 =?us-ascii?Q?lHWWvoY0aqu0Iq+gk6tmAjRqtYNXTcc8GP740+IFJzE/boUkkys5TmhwV1S1?=
 =?us-ascii?Q?wgXbgNnj6VRA6lMJ73UJODViHJNpdlYeVVxLdbiWmsbbOwX9TT+UhwvvjVuK?=
 =?us-ascii?Q?Pgjmu4mBVT0O9LMPIxQyHW2krDpBH35R4CkaRAUWdqH5AmtC1rawGkac1Ty3?=
 =?us-ascii?Q?SdcFgN2YK7eh8Y9iDCMv6uS0d1gQJvjwv8JtGyO7ICCUYJhmryKvPR3rUgNT?=
 =?us-ascii?Q?fyhINtFobs3civkTV8kABHJ5dZ7jCjUB3woYJEDflXdYHP+cRwYE/jmA0FEq?=
 =?us-ascii?Q?WFfQbfT20GNS6fxzB2/R48CQQSRb7uTN0sDyjo7+SGIa8IwCZJ6e36RPDf84?=
 =?us-ascii?Q?kTjJpHvYg+cPcgF2ERDtsMDdiFOcazq7pjf2VRG5dBOK2WiryYPE6z2Cvtyc?=
 =?us-ascii?Q?EYfj7Eymv8/9XIdHCs/IMGkVBL681KQn9yOir/A1mU+2OpG67lQnOUEr2yOY?=
 =?us-ascii?Q?PwaJzmY6dENaX+mrpxRotnFq7fasmFt/gqMjXunnt35xp8at5EnriKiiJKDj?=
 =?us-ascii?Q?ttBCSjXW45wmdHC2bbwoLnV3BvgW56pmjeNJ8L+BSamcly8gTMkk4MAJUgKR?=
 =?us-ascii?Q?EwiigjQqTNmxVebJvaNJHEkoUFu4fNj84DmC5bWJRQNLfB8PK2AfvQ9ko0XA?=
 =?us-ascii?Q?jFDojmwv63vSZm8081OBN36aZgOSKQibBMIo0EQ2ovfXJtwEpBARvEcXC0n1?=
 =?us-ascii?Q?+kxAAwMomJdr3CZHTEo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a211644-de14-48d3-f234-08d9db4e28f9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 13:18:19.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGfMRF76WDiS73GsX0A6k++tULNobX2+s42En21RXX1NIIwpnR3JZxNqoWXfqJVo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 12:55:22PM -0700, Alex Williamson wrote:

> be dead code.  The specification below doesn't propose the
> ARC_SUPPORTED ioctl and userspace is implemented with some vague notion
> that these states may not be implemented, but has no means to test.

BTW, to be clear, we are proposing to include the ARC_SUPPORTED ioctl
immediately, and adopt it in qemu when we implement the P2P support
there. It was just split into a seperate patch for review.

If qemu will attempt to support the optional non-P2P mode (without a
supporting driver yet existing) or simply fail to support migration if
P2P arcs are not supported is up to the qemu team.

It doesn't matter which choice qemu makes to the kernel series.

I also don't care if we write this patch with P2P described as
non-optional - so long as we all understand that when hns's driver
comes along and cannot implement the P2P stuff we have a fully
compatible upgrade path that does not change the migration region
version.

Jason
