Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B39B69729E
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 01:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjBOARy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 19:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjBOARw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 19:17:52 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE53F72AE;
        Tue, 14 Feb 2023 16:17:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBi8b4Dc5q0x8PyUD989dtyWljZO9f6cLPZyAO6nt2eqg4yUrcclpT0sitTKEjpJOeIa/SMll9gG1bezyaVG60fgFxyrGOJQ7B+Ky0g/sUTarUtN2kuSUQDICu4Xn4OcGbD/KT33GaXbtu41Bc9hDSu/GtfZHsgBZnDzwthUvkgOMIQMrJawydCquR/ssleKzjUJKvHE/A+Qh8bI6lM9oog/2UMr5Uxc40DCYRQG14NP/NxJ6q6ZXxj1D0AFRTDgV8nBsa5/LHpM5hUowOKYc7unVf9oXcjWxAN4v7JnHYmKKvAgsUTMGGIcOro0R+SGN0Z0V1oKLe9dabSE9FfyBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSEGuAejGfX5hhEN4DJT15Wgux68ktrx74S2S+awlng=;
 b=KpG0QMonPUR7UpEYM9c6z7fHaeo08maQDPkQ7WfXkguqP4+UrKkcH3duRbZP44n6d0Fn1CV3pIINNrlo8aQS2ch9LKDRqCvltF0rHZkqrc7R8LOXOdYzS+5COdwrkrPPCoTo4Xob2Wu06i7qxkYd0Tyi8+be4RVFjp7Ypk6IE6CZm5NJxKNYAVoHPf+LFsCbDRIfe842mVujMJqHKSIJ0xO+XXm1fc/CcCaxZF2q6IPQvl/O9cN5nuSXTLlf+y9gv83EeHMAZo5NMJe3AeGEuaHAo9oM2ff8/h6arF0SmRC+yKUmMYwBobC5KZpslK5uWGIsfnv1WR5/2q6uSF7ZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSEGuAejGfX5hhEN4DJT15Wgux68ktrx74S2S+awlng=;
 b=V5IB2U729nuarwjUsH6NeOO8WgkbARmcxOGFRBex6iIeJNhuPPsyX4nKbox3ZotsyXy1z2S9CinGIlGdHVI3Eh5iMt3BCiRmIe9lYX2Sb6ZVu0l0DOGXOsZZfKN0OqKRisRfQ42eTVtlwI+CytX6LTDGl7J0fCdUuM/zmhNAWlZ0GWoR6YUDoZNIk9v/0ITaRPareM8GwVxbD5sO9SksXpYqWBEJMvC2BnVXS0SQn8muodv0cmLfPnkqYkULG20YY76rwBsYhAT6hzSn0bYSy1fKbsRDJCwSkExXat2XLdhICwyM/ttUBRYmMCgjvTOMA4ROsGrKBtMJKqFKEsEBbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB8021.namprd12.prod.outlook.com (2603:10b6:806:305::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 00:17:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 00:17:48 +0000
Date:   Tue, 14 Feb 2023 20:17:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        Timothy Pearson <tpearson@raptorengineering.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 05/15] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y+wkqnCAe42Ogcof@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-6-yi.l.liu@intel.com>
 <20230214152627.3a399523.alex.williamson@redhat.com>
 <Y+wYX34sPvPQmGSr@nvidia.com>
 <20230214164235.64e2dccb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214164235.64e2dccb.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:2d::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB8021:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c2ff7b-24f7-4bbd-d6ce-08db0eea115b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E39d0DmgA/ovSCutLMenkc52MfT+Joz8f9u1t9bme1BalIwnkq/Rwaoao2h21/gLEKq+d85QAQuNEKgcb/UfAYW7g7qxcx9CGDIcu2csMag6q8edT2oU357lW73hXz3hqmmki2XWc9V+OuZ7Uc0muFO4+iWKvbc6ZCesJ/38a2qNXK96pgHwtrkk1BdUFt9Jvt1TyoK57Y3pLnTQIcg1HJKCRquX/dyfDq0eqRbRMz4ORuJ3Ey/yCfgPL0F2vd6jr3i2zkcvIVPtezwwBWQiNBkukBe7F+JSDrnwgNbYDc08jAB5Te0BBSl5yieuPWwgdrx+dA5PpFdOAXw0ge0SEAwwZbrbyWtkRshPgSIRiJK4O3Owi/gNI8jA95bRBUo9rGJNbz1vBDTU7h701s+aTGzXiFMROhXGjnuwgG3LrWYNu5RJL1yHopkUoltkC4bEP0w69Y8CVXvV+hk6Gl1gYitVOzO2V6AqTnCyk7Kn+GrTB3tm5RGj1/g8bAXn+V9M1NGUTZ/X2dl2rWLkvv+fcRYg+3bIHhEeDWUGKeVkJzZkwOA+uiHXk/9bQOHapaDsWO5Wm76rzBOMttOc/TyMU6UbusWDza2pZVHAwja9krY4UOMA1Ce9z1vPFxZ9dh3xzFjwIfR1z3Xc3yL55kx8Fb67jExKM3edXi8QQ3fSk98Uj0TFOt21uSjPaKVLM/dL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199018)(83380400001)(478600001)(6486002)(36756003)(86362001)(38100700002)(2616005)(26005)(6512007)(186003)(66476007)(8676002)(6506007)(41300700001)(66946007)(54906003)(7416002)(5660300002)(316002)(66556008)(6916009)(8936002)(2906002)(4326008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GCQZOwFBqq3dS2qO9yumD0r/AM7JDPHXeFQGUr/dQU/WxHy3uD/A1fD+ILvp?=
 =?us-ascii?Q?zbJ9VkMTF3rxrz2U6oL+c53iHgMktMelpkrwH6MqP1aRsQJe3vhzw7LV/0Wh?=
 =?us-ascii?Q?JJPlx99lQazA9rAc/edpZaZsS9zP37WxvmccRYoH59tEQoKNCzYU5jzCU7kO?=
 =?us-ascii?Q?xkablA2KfXDREi+BI7wTzgofVA8MbFwdt0Sgdv2jFMBsWhDaWJuzp2B9Ha9l?=
 =?us-ascii?Q?bYkP5BB8zb3aQluCmRvHyH4Vwsn6GxRJ5cHD8GOMd25OcYvOHcC6aGLDy5qn?=
 =?us-ascii?Q?OPvlgD4KIpZ6wfB5xuFhQkrjLLLIUiSHZq6oqnKF0OxWZjYdGzbF73lb3NQa?=
 =?us-ascii?Q?k601oso5frQhYJYXPmCmEZgqaPjqHZTaJY8dIJzUwYoiwgNBkIlSb6cOScrm?=
 =?us-ascii?Q?0u6avbOfTTGwfZQYgKh2RFr1mnWGWLJ6a2Bq5YLf8xqAECBp4/ut/Od94nQM?=
 =?us-ascii?Q?KlM3yIJEJh78+L/2hvxCB83uIPPzS57X63UOdy9gvnVrrqtE3CtR5hLh9NOt?=
 =?us-ascii?Q?H3NQqJMAck/zwRwVBDUO6R+WflmT6DjKzvLrnFIW9HK7Tgjt4uDc1rF7pG6K?=
 =?us-ascii?Q?l1loL7KC4iOXeXfc2f3/gBcGMPamjoqpDk9jvnfG3BhuId/bcoEGBsxS1yaY?=
 =?us-ascii?Q?9ze9+qtzIcBpuOXLQvl00OCYfJpUSWG90hzKgyyEOw6KejpPYNse2V7t8FLE?=
 =?us-ascii?Q?nwcaSumuPfM6iFjL2kL8SdB2DhMJu4ZMw9LRYFZCb5J288Z/bRlfbdcVuAOO?=
 =?us-ascii?Q?DEn0/yHcqfZXT1PjkgeEG9E18+D7Nu0WFjWN1iOdSv1c4sy4P/WCwho+SJ10?=
 =?us-ascii?Q?2OsB5RlvtophH95ixtUZkLzQzBdNBKinmEIQptJa2e9gFN5vvF44+dJSSWil?=
 =?us-ascii?Q?ig9vlJxtDv58xDkpWMNqPvcVr/d02A//8xo7vOzxDdAJKhfBYu2WIea6nH/x?=
 =?us-ascii?Q?ucjatNuf910huEUCvG7cPsUNZCErJyeXcYFAGFwwqP48j+/x8w01ukSvrQsS?=
 =?us-ascii?Q?ZWHPoFRjtt8ojcN4B2icBTqKooF0lNPfBoJ9X9c3+hZuCM5u2Ytn3rItaw7K?=
 =?us-ascii?Q?4SApt/Xys13isAaa8ZpQlk2ZWrpLKpxLH98J8sgT730wRT6z9HrFjs7po3pb?=
 =?us-ascii?Q?5+94iKcwX0clLRJXBem5ZEmBg9IYb31QXCoGAcBc/VotfvKIcyxDmRUkFyyY?=
 =?us-ascii?Q?yU+18LvYxNwW183MBDt4iskxWT0lPi3QDJ0Yp56FAoFBComgwQehR1sKM7pt?=
 =?us-ascii?Q?JmOXE2EcNtw69hLNQPqe7VqjO5wn9vsUbRj+9kMH3gGPUOYTI2JplmmR+3PO?=
 =?us-ascii?Q?flvvV0AZ5eAMhe+M/M8/+gBMrSdWEZfqtd1anZVHdMytVD7vjgVtSFSykkQU?=
 =?us-ascii?Q?II6srD7ytnMTl3asLjH5XmmNGivdSPQAUn8lIOix3VehSLGP31H1MjmWzY1l?=
 =?us-ascii?Q?0ZMSnTtO26pyzgPKZz8aKI0rHEe1rTXs27dmGnEG0LvygOsbgOFZqNa/9IBp?=
 =?us-ascii?Q?ivE5xr+BX3hBcjtfg827Hujn8G2veEU4LAK+k+DyUxHmtZD3K0FXPem/o6ub?=
 =?us-ascii?Q?D7XlPGuFgsMNyjpHbbhFxdOjDFjrCHQOvczffa8A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c2ff7b-24f7-4bbd-d6ce-08db0eea115b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 00:17:48.1456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnQs6dgTyyzS1DdVKY+efuhCyr/wgIhK2GpHHy5MXid/7a9lrfLtzw4BfVHqPt19
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8021
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 04:42:35PM -0700, Alex Williamson wrote:

> A device file opened through a group could be passed through this
> interface though, right?

Yes, I think so

> Do we just chalk that up to user error?  Maybe the SPAPR extension
> at least needs to be documented as relying on registering groups
> rather than devices.

The way these APIs work is you have to pass the same FD to all of
them. The SPAPR stuff is no different, if you used a cdev with
KVM_DEV_VFIO_GROUP_ADD then you have to use the same cdev fd with the
SPAPR group_fd. Yi just didn't rename it.

It is weird, but logically self consistent, I think.

> > I'm still thinking about proposing to just delete all this SPAPR
> > stuff. Power still hasn't had the patches applied to make it work
> > again so it seems to all be dead.
> 
> There's been some off-list discussion about at least fixing SPAPR
> support, but yes, it either needs to get some love or we ought to think
> about its future.  Thanks,

The patches exist, they just need to be applied AFAIK. If the people
responsible can't care enough about this to even do that then I find
it hard to care at all about the state of SPAPR.

Jason
