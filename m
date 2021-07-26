Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0D23D69EC
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 01:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhGZW0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 18:26:31 -0400
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:17772
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233491AbhGZW0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 18:26:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XE++IJC5ZEWcoSjjtSbBzF4Mlrn3UgjLzulhlgAdXaTTEeF2MEuK1/cqLIlIVIrWyuERYyITjhpwKieRaHBeoh8UHcHY1c5YDSXf+lIMaBSvXdeN/Sm3OoanGd4ERtbQuRKh3PxWbjXD+Gu+umOLGnJMRrQKG0fseiXpWfDoH6bmTp9zqYjEQd0bVDpaN9y/1BSlo/D+8ajqwoV8JwrxrLGWlH8xyLuPI3zW/CHFDNABqucAXUlIYIJNgO71MVMsHYKPEi6Vz9LXgPDu88nRFnMcj/Vxu0hmzA/UGaOEr2S7wbu6hnHVR3w5CebHpGeL/mfcHYBRUScdEFkn8jtw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16vsLKJACsqoDmi3Z+RMnp2JuJKDnguuLdwJ+CwEpvE=;
 b=jZDNK0InI+z4udzc+GpmZXi5zWOtJOt1M0DMetOCzZnGTTi/h8k3N4qVJ/iyAwzEeYPKx9bogq5CMWm4z7awvnfU4oIktattyWsNa+JcEbpANbUY7N1pzIakdnz7ZfbSFXZbxF2HrKT67S6YRauMZBP0h/vNXVPtEdiqZBPyqjfBgY6AQDB4kXbs10YprDuDcao4HuOD70i1qCjj/XPOxmCJRVeMx/SIUxJbqg9br6fuZbQTMju0/NtZIFgP2oVBPf+WTDp6xo7Wy0TusiasAN+FF4XenzPOHsoftSUHx+vcW7iylc1C7JUg/ep+cKOxPqrqj1+ZmwIHfxm6uRLfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16vsLKJACsqoDmi3Z+RMnp2JuJKDnguuLdwJ+CwEpvE=;
 b=t7QNYL0yMSr2WLkPPYTtQ7yQCu4I1zGjA4DeExrjZTLB7yzOLbOvnUbhMkFwdMkZj2iEnhToM9R1w1toJjqIvHcgfRpI0hmH37TfoGjUXJ7jImiA0qaBlX9ksfPLRocKPCTWcenn7g0C8t/MjQUzXeGsSkcTeH16eBEe5aTtbcuH1ArgSGOQmJp9eazQ3MJ5yKCUX9HjNfs9Eg+StN93dn27mfYcbonA6fq/MB+Tga8dAE8dlq0kOTT9Us/1HnXgxpYBo4ZIMwjaZEb/2VdbkTyqIu3hMDSIMIGLzaW6L3g1tcrf1xGYpCCf3sSsUuPo17L1VPk3i9HIeL+CDkoNww==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Mon, 26 Jul
 2021 23:06:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 23:06:57 +0000
Date:   Mon, 26 Jul 2021 20:06:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/mdev: turn mdev_init into a subsys_initcall
Message-ID: <20210726230656.GB1721383@nvidia.com>
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726143524.155779-2-hch@lst.de>
X-ClientProxiedBy: BL1PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:208:257::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0041.namprd13.prod.outlook.com (2603:10b6:208:257::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.16 via Frontend Transport; Mon, 26 Jul 2021 23:06:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m89gW-008qch-OC; Mon, 26 Jul 2021 20:06:56 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb31d494-0be9-41db-b118-08d9508a1156
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51103CC38C93D455180C1803C2E89@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mxoJIfrA/JDY6WP1MsvvKfx6uGMLnbV17c5nBrW8yHmugqeH8P7HGiZ44jCd96floGP7/GEhzKAZovaNLVjVnbbwdvYCkRluW+WTV3mIcN5u6GO+cSDVIDQkSGZJnsL1dAtjkMzqUTTO4le+ma506cR7skvD/zgBFVZoSCNE6MSS7DzYSKjk0k5OapFS8IVt17SViGegfLCcwXH30BNVFW5fCtIPijcjRQwRy+OzFD+alGAY2MK/6LMjTuBws2JtJ9f8oJ9ifHQ7QJGvCsUxYZvzc9xRX2szKks9wyHWKKmqe3GKIp2wouJUvzzlpB43VpAmo6d37bfQVyjoY1nw55bJi5+HSFGE/aXXLpdc2NtOAS4W2BLPH7+RcORUegtgUl+KCxlhArFcC150T7tZFYdyg4WZwk4TOTIbFejJL5o/zAWrEPN8HFXDsoFjtZUzTAcs9OWCPJBLsFtMrHHW90wGbVM3lD5O7py6ZRnHU7c6bmiTP/Rv5Da9znBQ3+KlyiC6KkcKJd5fYXizlpJCDcgWMtE3n95dHvBRcDu1SUgSj6On9oizEk+LA1FnzdLv1KtZbBUPwutwVQJU+gQlFzuGDstaulN3A2Vrzs9/8woh10090AavQIJDzOfuZfTm3ePUYWX+6bxMhkNoPP7TjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(8676002)(38100700002)(33656002)(66574015)(1076003)(8936002)(426003)(86362001)(54906003)(66476007)(66556008)(66946007)(478600001)(83380400001)(9746002)(186003)(4326008)(4744005)(9786002)(26005)(6916009)(2616005)(36756003)(2906002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3JkZkl2VU1rKzBLVGRpNEpwSlAyaVJNRnhINXgxM29sdFg1SDZNVktyUTc5?=
 =?utf-8?B?dEJxMElVeE8wMkJRb1FRWFpIM0FrOFg4WmpGeFBzZFBQSzBaSVc2bkNpUzNQ?=
 =?utf-8?B?Sm9DK1REdkFHSCs0eWF0d1B6VVRmSlhhakNqaHl2K0Y0MTA2Mi9QTUErRWRY?=
 =?utf-8?B?ZXFIeldsYTREcUtwbzljL2IyM3Z4OTh6aS96aENOckdBSVBkWVJ3NXp5bGlU?=
 =?utf-8?B?a0RhdjY5UllLWG42R2ppR0d3ZFUzNFBUd2x3azNZQTNLSU04eG9adjh2Zi9M?=
 =?utf-8?B?MzZTYXlrWFg1R3dNRFJ0OE0yNDhDWEd0SGVaZGZ6KzMrbnh4NU9qY3dGMWg2?=
 =?utf-8?B?R2VTRktJVWYxdWdRdUU3M1l5NTlESHBaMmM1STZNUjVMK0U5VnlSRCswc0Vv?=
 =?utf-8?B?MVNDenNXYkNaZU9GNHFCMjNOTCtZNHdBMUpOOWFOK3lVTnhjcWE1Qk9tZXA2?=
 =?utf-8?B?VENKNUdoNUxyc2QvcEgzR0VSSW9ZRzZORDhjZzhINUVsVjBJakhSZkNzeWxY?=
 =?utf-8?B?REhoSkprNlp6YWpkTFJJSS84cE1RVE5KRVBySmhtQmhpaHc0OTl2SUJKRzdt?=
 =?utf-8?B?eDFCMmJJdm9WSHNiL2F1QmQzS1hZRkFxNDYxLzNid1FlQXBVN2RVV01pWVRt?=
 =?utf-8?B?ZnJ4dDlyRDVkTFdmb0NSNE5Ybzl0TmFyQkFxQVR0MmVCMnhUK1Z4N2hkOGQy?=
 =?utf-8?B?elUrdTJuSnpYTFhWSURFN2s3aGFmRDNsWjh1dE5oSW9qWEIrN1IxR2kveWF4?=
 =?utf-8?B?ZTdQS2wvWEFIN0VrUXBPcG5RWTQ3YlBoTnFsMzgzRWlDQXZLQmpwMkNoM1Y1?=
 =?utf-8?B?OXhtN1NLUkhPOFhVZUsySXNGZndySVJZYVFpWFlBa3UwNENvbVpTYVpXN2ZF?=
 =?utf-8?B?K2dHRjRaSUlBZHZlOWJLL29IUEJTelE2VHFRYTh2Q0RRTkM0aGkvejRsYXdu?=
 =?utf-8?B?bTkrQ0VHeWJLQXFMUnFtdVBxMUVaOXBrUThvRnEvUU5CVXNZSFJocWNRa0JK?=
 =?utf-8?B?c0paWG1RM2hTRk95aFZrUnJzYVB6R1FmRFdwY0RRNWZENzJMWnBaU2o3YmU1?=
 =?utf-8?B?cjFnMm5WMUlrQmRtZXR5QmVFMm1zUDg2WFZDNkcxYXRQVFBvbi9BVGZpZ2xJ?=
 =?utf-8?B?WjV6VDlVejhGcjBoS01DTnJVbTlrTGR3aEZFVGtnNERhaGFCaFZZYlp4ZXFT?=
 =?utf-8?B?V2VEVGo3ZWtZOEl4ZzgyYmVtU1YrcUp6UG9kaXIwakdFZ3J0SGVjZkxrN1lP?=
 =?utf-8?B?UGh5ZnNyd25vaGRIeThDbzJQYndXQm1OakpScDArN0Z2NkY1TXJpMTd0UTVs?=
 =?utf-8?B?czI3SDNqTCtldEZhekFVVDV3SmlZRG02aXhYaWppand3M2REUzdsZDFPbDMv?=
 =?utf-8?B?NndEQUM2ZDBFZWJNWjlLb2ZUamtuRVA0cWZtZVR5NCtJN3ZJUVJjRmVJWDd1?=
 =?utf-8?B?RGtENjFTcUkwSGlLQnV0OGYwazNhZjYwMlM0T0dsSDZuV2g3cmtHaWlGdUh0?=
 =?utf-8?B?QlRFUnQ2cUkxMjJDSVZiVmJubzBzREpZSnVzSHk5aGw1d3dzbndoYnRRbDBG?=
 =?utf-8?B?d2lLd2FJOVRWMzFiaHBRTktKU01WdUNaV2Y4QUZWU0w3U1Z1Q0RXUm9tSmtj?=
 =?utf-8?B?OG9ub2ZJZGxJdjArVGh4ZitmOGd0aXNUZEZ3VHd4THZsNUtSUlJoWEFTTEF1?=
 =?utf-8?B?VEdobUhTTDBFa3loU1Iwc0RqUG5yMmVPYVFlc2ZJak41aTVaYkwvTG9XRnpu?=
 =?utf-8?Q?oDsz+V8Y/nrf2PKCOQHIBkzMMp+xw0UDfrkqNzk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb31d494-0be9-41db-b118-08d9508a1156
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 23:06:57.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OFDlcwIGLdMjSAduYiKBjBnLDsH2QL0nTF4F73aRX7yFdKcWps3N1OHJVChcX7CC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 04:35:23PM +0200, Christoph Hellwig wrote:
> Without this setups with buіlt-in mdev and mdev-drivers fail to
> register like this:
> 
> [1.903149] Driver 'intel_vgpu_mdev' was unable to register with bus_type 'mdev' because the bus was not initialized.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
