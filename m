Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0241730848
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbjFNTcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236006AbjFNTct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:32:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D102D2;
        Wed, 14 Jun 2023 12:32:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqdQty2uGf2j+kWk7fP2D3YpDfcbgg878UeHQ5uSbyAqhTnXYhh4bNA+cqf7zPYIMZEBJdyxZYc225oIgrjrRRM2rWPmePYJogvpGBlTTlthz93ZrLZt5BQigUloe8vW/7tXIDKk0tHEZHwSDitWi6XwwvbMrMBZn8cKd//sq+FrG7g/fIxs5UOWySUnTiBqWGpd4ya3PXGguMr+VrTpEz5xj0xKb0BqNJbmflFem5jY0qtTA8rPxTN3rpTML++wXoPHvZpsdB8pbKGxuxvqr5cTYNHQEBSKRjJSSK7yrbLkKfmNnAjOUmQ3hZJNNxvo8g7bwco5CVnadJMqNtuAIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvrZD/ZBlQxeLymw3iiLAhLKBKOrJw8bnW0s0Mw+4bA=;
 b=O/hx/Fjv5GliJ0/hIXdcaSIhqiiYNNkBzZWyAbi1eJKJ4DpD15+875CT+ObtF5da5SPdLm0sGakNrhTslHRdHmCu7cWbV1jAKRJhqM8alzoKYSPq9sVsOVzq4KdMi9IVPd5Fh9pP5spFPd29c3ZvcDUuGmqftA0reyNXM8ruCu43URAi46fqDQwPJG3Z+ywI995oWkwSZ67IcMfoJUKRB4uKa4dVsxSEnBlya56C03OUDCJRGXlzK7HJ2Rj4JOAWfEALvcLzhcT4idegL4z+FZpKt4VbbGwXHIQ7CAuaBVhM26ujIUzoI7ja+fCvciGoc1zoql3iK5tFmesfDJgs5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvrZD/ZBlQxeLymw3iiLAhLKBKOrJw8bnW0s0Mw+4bA=;
 b=l7OOKyFXpEXzj4cb2VDlQXLEaD64O3FJij0UvaaAe4RwLiCnANcRVPaFZyBaKe6+tNyyThJemHYkTSpKy16dSdFphT2jI/YqWHA9tdDc4nG3NEz+gwarSKCqR0khu+N0/9Tlz9jpDqlIB2yc8rNLgRgm+w5Ppx0FJ4jjtvRZOH9HxTvKSEosYCFUH12D7gDSQzOeuKOfQNa4lrNTPFxcVCCFBw/u4AdAz/ogNP6czXHWrVtnzz7Tm5gQA/C6BVtZRfRYsRNeaWuJQSnfKDpVZkFzo9gnGoEVI8JtyWnLX7dJaA22UsKEngSCv07KJOv472rhqBMsoMc+67NcdVl2dQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8352.namprd12.prod.outlook.com (2603:10b6:208:3dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 19:32:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 19:32:44 +0000
Date:   Wed, 14 Jun 2023 16:32:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZIoV2UyZ71cwXroD@nvidia.com>
References: <ZH9p+giEs6bCYfw8@nvidia.com>
 <20230606121348.670229ff.alex.williamson@redhat.com>
 <ZH+DdVIyZ6hHCDaK@nvidia.com>
 <20230606153057.4cbc36a0.alex.williamson@redhat.com>
 <ZH/LzyF/uttviRnQ@nvidia.com>
 <20230607122303.5d25c973.alex.williamson@redhat.com>
 <ZIh+wXFrls7StWzc@nvidia.com>
 <20230613132402.2765b6cb.alex.williamson@redhat.com>
 <ZIn/EHnCg444LJ3i@nvidia.com>
 <20230614132047.519abe95.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614132047.519abe95.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8352:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c266937-0433-45f7-9c24-08db6d0e200e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /k6U+R7+eKo4QUf2hfEgaacGVfSmpOyS8vBIHlsPRVG0dIDfdQfeH/SCOrz3u2hblx+5DHqUweKC6A2W5EmngRPOWzGRAWNR7Gd9E/GiMMfKSxLHyagCcNC3hLY//eRpjYzR17thBL7qtr0l/FjQpOoiHpVfRXSlLRKtGl52PUK1p4X+b8cFI2lv533r26IN84QYYQDaQkXpGEY4umx8rgzWso+0Nb2etWluYaY6OrlLSRBFWACxeG1xni5REN8busSgTaLbxcjt+hARlTpBlipk/F5LvWBR60lvIxjnhWK5jsfOpy7fXzeGaZKozPMzBgJQKTCcbapVYNsKILMOODjuM2oDyk8tqCHFWLcb8Q9M1kd6FUHE4ceUv2bO7/Ev3zJQuFtn+Uz5ypFD+fcLJxiQc5fT7dfICFgiEkU3oHZAMdXodzXg/i/q/QuzaM/OpJfQ89OQWNWXxLVtu0uMcfoo1RrYJ9K9GYsxIB4ZwlWTMMe1ex9PRAQZSLRLqc9SOUOuAzJCv765eZO5mdtlkoWaz85UzKbGFOxTY6ZwF310pijc727Ye2uZpAE0S3qI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199021)(8936002)(6486002)(26005)(8676002)(6512007)(41300700001)(38100700002)(478600001)(36756003)(66946007)(6916009)(4326008)(66556008)(66476007)(86362001)(316002)(6666004)(6506007)(5660300002)(83380400001)(186003)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?osDUHYhHmMidBrYAOGJ1BemfBE1HFRQNFVFpr/cQWuWHKeGj00pM80NaVcRR?=
 =?us-ascii?Q?jQJGV1rwiTtHWODf6ZH6aCTqVReMiTrmTvUBodcGh8UoFpYdm19glz7yJthn?=
 =?us-ascii?Q?dCTg0PcCQDJVo+P5EhBYeTbk8YdY0t+661k4Jn6/SKVMGof5yYIywuIce2Ww?=
 =?us-ascii?Q?wLPg5tJc1aFcaU11BE8FUIMPoXz6KUBlt4ZrpNVj5fkr+Kxtk11nn1IaRrAw?=
 =?us-ascii?Q?MMgt9kAbqJIJp71PvHdcqhgJyhFUdX4fpUgcm0P0tQdJV3usE6K0aUCXo6vS?=
 =?us-ascii?Q?spHXJ/N9yri8IiwsuHv0dgEWgJMe7d5Nuocn5H1WJuO5zvkcAjbniyyxJAld?=
 =?us-ascii?Q?Zq2T3gc6spEV3SDtpUgd5O/Frd9+EL1t1GvPf6I2Wlh+FFgFqXAvnVS20o5J?=
 =?us-ascii?Q?fde2fm8o6CuTwTKbBcNyQI1z7bXin1KN5Viu56CiOahhXzTAFBrDbk4/KxBE?=
 =?us-ascii?Q?r8zz73F61n0S9vPKsbDjDpgbVaZXQ5NuCJ2YHH1h+cK0hMdIYcnz9VxCYB4S?=
 =?us-ascii?Q?8JiT4v55X1HKXIqi4pKkWqjFNEbJDr6ASQhDsUqs4DXeU6wwEFDcSlKezBaw?=
 =?us-ascii?Q?/rh2kG3gKg3CwHY3G9Qkea6hlcxqiMxkmT98618tZHendGkW0oIqKTIHERyg?=
 =?us-ascii?Q?W4ZdiQ+cuKwTVWI8Ok28X55zxT4aFRm5ujYVxBeMIM+QPIVp72j5f71YMuFQ?=
 =?us-ascii?Q?/NEiHmL4aMzdutaajp8pBvNdQkCZ+dq5Cu6Mxqla3P3MBSi0V/TdlNeMrygi?=
 =?us-ascii?Q?IbvN9JAH6QyczK/cDCFy6C4fWDc3tJWhbtV+63OmRFyjI1c0I45Sa+HDDySJ?=
 =?us-ascii?Q?D+QDphVnXV4jC5dCQOfha3ZO+bw5ODNltK0wcD8iYvo/CbwaeT+Fn909wR5b?=
 =?us-ascii?Q?dgS/o41oUht5VjLYdT2uH1GDE4peWjDvvgiOP1BxdpDFM6MVcYrBOo/iGQd5?=
 =?us-ascii?Q?SB9sxkMCNHuutXYGkZad+g5L+VselLhzGE1LmAokBR0PQZLUdMnOgx0X9R/B?=
 =?us-ascii?Q?Dr+VppmV4lu+3eiHypBX6BLjb1oAGVzwmVbimN5BmEdznJ2DcYaiogJtbOlR?=
 =?us-ascii?Q?qyH6Dps2xNcqVltTYx8ZFztjEHLBIN+brxbQwJ54YQXA07wwhtCmWl+qKmDy?=
 =?us-ascii?Q?CI2DIXWUtQh0AzDYjJAs1M1AYXjVSWhC+SAp6dEpIYg1cKdUgzWn68MtaTmf?=
 =?us-ascii?Q?dk8DimRJbQHQffR17MbRFkghPbiESfISkC0xd/Yh24LnUYj2tv9uBr6NYtQY?=
 =?us-ascii?Q?rdW8rkBd2TG5xmBM5/voE8XgZMOTKJkgk9l59gqU342Qnng8e+MwfdyP/Cfi?=
 =?us-ascii?Q?vPtLgrPhfvJlUQNd9TbDQpjNweV1+h9d+dDdzs8ENoGVAv6dYZmjYet+nZzQ?=
 =?us-ascii?Q?iizKeYSjEJyYGFuR4Vd0l4RL1UbDIzj80Rwwv0VznpdZGTTpCMzYJ+JT0kCt?=
 =?us-ascii?Q?0mE1lyyPKjO99uvZ3RIOyHEinssc/HHAOxK8SPbCHqcm+KPCOeFKDvqYblPP?=
 =?us-ascii?Q?rgzmGrjTCqECyQX/quwO35jZoVuZQlc6cOLsWIrkN1bFEO+7vWfzBjJC+/dL?=
 =?us-ascii?Q?uxcj4XdhwymmPdgwqkFyrzXjpHoJNf6nVjzONKOu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c266937-0433-45f7-9c24-08db6d0e200e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 19:32:43.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHM+cq6RHop75EcqQHjV1TMh7sJwJymWxZKJJtSgkvasntNgyjvC7yqpZoxA4pl2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8352
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

On Wed, Jun 14, 2023 at 01:20:47PM -0600, Alex Williamson wrote:

> Regarding relaxed ordering, are we talking about the 'No RO-enabled
> PR-PR Passing' bit in the devcap2 register?  

I don't think so.. The RO problem is that the RO bit in the config
space is only defined for a SRIOV PF not a SRIOV VF. The VF wires 0 to
that config space.

So if you stick a VF into a VM as a vPCI then it appears to have a 0
RO bit in the config space. A VM driver that relies on it will think
it is not enabled.

I suppose atomic will have the same issue?

> In general, I think we put driver writers in an awkward place if they
> start trying things that are clearly not supported as reported by
> hardware capability bits.  

If you start down this path then IMHO it all has to work the same for
a VF and the VF has to inherent any relevant PF capability bits. This
also means the vPCI emulated bits don't actually work correctly which
is a different mess..

This is why the answer of "don't trust the config space" is appealing
for driver writers because the VMMs are not able to emulate bare metal
very well in these details.

Jason
