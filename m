Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3058E4B7296
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbiBOQVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:21:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiBOQVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:21:50 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712B025EB6;
        Tue, 15 Feb 2022 08:21:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOhMHzCqex5ZcO5fCJmirqAh3+VYNRFCEQjCpQTuilblLhNkczt2KMjNNYItasOsMsb++0K2ijrmWmgbpHX2wl0Z+vcCeamjXsXXy8sywjYnA8G+M8W+2OXZ1b7x3msIay/yta7Zgcf/BDGDhDj0TC/ObqIN0sZpUbS3R10X1qYmilBUGuUaMpxuJM1YfxRnrLjXdtgPb40xFWqWOxUTEiOTyH8wApBzOO4kwuUIeJT3W18W7nYDX8l2f5FarX55XgxKOG95AH5JNZYKoyEfBtN+EhfxViHXJOHxmTRxT/Uwqwy2GuRrG+6mz+w2H+25PlplemjZSIYoHGoiNxGE0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tyb302EBjqLu/BtEJZ97gD9geFRYhJmUAmyBi7zw7b8=;
 b=VWHkfqxjBcelFeesRyQyWU3qevgagCsSwGTVQeG0W5BFc7Gz3Zum9lR3oqcMAWw7nqUJrbo3ONUuEvRB0vV6zqQmf+FbzyPKnb5xs8L0pdUoWj88Q8XYK7lTtLb5rNzzujb/tNsAMdvBeV5hLaRWaPEfXZP0fA7/YyaeJb+r2WqhFzeelcM5fZ5HETlVxb2SsI+vOx+OMElIzb5HP/Ym5AcsouyzXlN8vxL/PrxOYy7u+R3C0XzH+WWZVICOlb9iaS9+lQIp8tro6Fsr8etXXaGjyCWoE9hcepxYSkZZQSNU8GgYfvb5h48Uu0r3uaWxkESge/tSRarGOn+mhQCoiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyb302EBjqLu/BtEJZ97gD9geFRYhJmUAmyBi7zw7b8=;
 b=Is3UgLqM3m5ej1BRMqUCdahEC0/PrdxZRNV4psbeLtQCTyjX+kQS4YIXDI1MedF9WwlGTGXY+gfoseLN8RRiNvuE1G0cE5p5YzZQTdDg/pupqMVvmp23oOxYEdBpB2JPspGaJ+O2hmBydkXG0i3WCtYINrYBAuI4WTbJaann5BjPcpgBnX4IzjnXIE/QQIWQE1ol1qePKPCbws994g6dBFCueUhSCzVeEgLWjim9ZME7kHsXtzW2E678C5l6YnSNG6f/mg0gfChg9ucjilQYsJf7X10zxkdR9GcoKx+4I/iJMctgp8lx2fKp/Dn1/p8JDJSp6iX1FaysC3cFFu31Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by DM6PR12MB3084.namprd12.prod.outlook.com (2603:10b6:5:117::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 16:21:35 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 16:21:35 +0000
Date:   Tue, 15 Feb 2022 12:21:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220215162133.GV4160@nvidia.com>
References: <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
X-ClientProxiedBy: BL1PR13CA0266.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::31) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bba753ab-36d3-48ed-df81-08d9f09f3c2e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3084:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3084E0284A3845E8CF6EA293C2349@DM6PR12MB3084.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8FuvM1fhQ4OA0Geu6DayWWOXj560GudKY8R0OCcuwLILDZzR1RAZ3fHljQTbSyI8Jshd6/AUKAg8LE3zXJuiMbgPRJ2dYYp8KxTNX/Enkh3PcWoiXr+CWPJVqntA9QsF/QAQHvJQCe0ymR1at9pV1FHOxZ6pT/ioTLMkddeoEle8J8a5Kk3APmvySt3ocitMzvZ+9SFJQYq81RMllETPl7dP3PMFrd8MpTrao9ruqqN3KMLRhFzIQGjVBDITvzM+DWxpykr+v6DUGrqiq9/kHbKn6LegpycWrY0Wxm5hKTACcM4faNDI7YSlFFH3YIYkoQQlOOzEW82H749sB03Ko1AoclOFM3f/dCX56a79KrLu8VbiexIqktK67E19jAl8peproKfFrXTJjn9N/7WQhKmlq4ppmN1T8rtIBokoW2R2I3qaslxeYei3nXraFgtGWu2FLRTPOShrEzfRZDZlberib7XJV4NUYnyUIxU1wBtnaUSxSrmtu4X9eZpPnGdVqUtxCNWkovh/xuid5cjWTYzoNqYjgW9xdn9D3YcdMghekUgtUmqiIlDUiXICJIIUuQDDBR4EC683eosCBKO4ncTJY5zZAr24rPObAkcg7RrSHCttTc/1Dcsmv2GSlAVfcqtPTSkO1afvtxsUqJ1zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(8676002)(6486002)(6916009)(4326008)(54906003)(36756003)(5660300002)(38100700002)(66556008)(316002)(66476007)(66946007)(8936002)(7416002)(2616005)(83380400001)(6506007)(2906002)(6512007)(53546011)(508600001)(33656002)(26005)(186003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cdD5xiTDg/zg3/c+pmQiMGgVOW7GbfeS39VKxtbZMXN5CY3sJV5d9eGjSbhC?=
 =?us-ascii?Q?1qGODQ4XYGG0y8Cp0AprY/W/Pj8O2fdrE9lliWL9KWzHWAn55yJb92e7tTvF?=
 =?us-ascii?Q?GPq+SLtpM6Bx4WXyEZGGed/dVl51MSCRbRKwA60tGCRt8a93MaV9+9WBlMnh?=
 =?us-ascii?Q?CrEki2u/g0GmNQvLTt9mXR2A51SA+/lB4DSILerwsg9uq8UK1DRAkv75rVtW?=
 =?us-ascii?Q?YQ6xHeV2YIyzp02ElB9fRf8a+DVX1BFmA4pOSfWqT/Z0EiNdi+7uCLa5JHrA?=
 =?us-ascii?Q?Opy3cz76Eed20qh/6l9sRMTGbAqXckA6lu4udreUz6jiPDA++kS0UeBbpAsC?=
 =?us-ascii?Q?XCmmGmieZ6+jXpWeGMCRMKfUWtARgbZon130+OwT2acvluNIYg40SP7fjPUN?=
 =?us-ascii?Q?KiCeg5zJfXFF0x7ICvJHNmBr0paBLAek7J8Sc8ZgloTc4Db6M3NDO9H0Kwmq?=
 =?us-ascii?Q?GnZ+UGYOsLYi/IOmtguuoIV9VDSek6cIqxIyiQjXjA5FdT//chabuaz0Wz7g?=
 =?us-ascii?Q?bKXpzlmwTnjv9QCeIV937pQtYJ7Fzixsk50lC2kRC32HxGd7uF5JadWGVZtw?=
 =?us-ascii?Q?A/LfqAUqT+nfaH8ZEa+Oto9Fa3pwSCffRGo8Vj7zDnzGXL8EArxlSgH2CLFc?=
 =?us-ascii?Q?T5zY7ZCsCP4iSMB8KAGonS6wtHtR9h+xC8he6mAIFVH7d1TeWsVXqlO6hv0d?=
 =?us-ascii?Q?IrZHNLxyVGvbjlr8HlVQebFUc7z1VrY4TdNt+re9ogzR9fMxkN2pZGrFCjfW?=
 =?us-ascii?Q?+P7OVSrF0rF8TJsFWOMoPAjUG3Ia/7YtgySK1zZV7kbwAgu8yqeH3iAiIAhF?=
 =?us-ascii?Q?EulVVsn4gmSS0OPsD9SaFWEpLpSOO5LpGYTaDoyiJfHxuRYIeF1WMWtQa64A?=
 =?us-ascii?Q?VRoTCKq2jo3F6IPMgbjvm4fz6HFRSOZg4/QIkTDTTfatNSWDn4AIyF4XSAJ/?=
 =?us-ascii?Q?OyHULs8CiCxA2XWzdUADX1T3u8DdN5KzNALkqNmE6vWO9OIw/QbNI06mrl/2?=
 =?us-ascii?Q?IgxsctIuZiyTb3gKxtifaiTwYl9pltR+PRWcjQK3sBAGNP8I4YtUKVSzWOaX?=
 =?us-ascii?Q?f2WSsm4ztPIaWbKduoRmsEWqlr4g48CmsDjepm0jCrCzSA5voFKiCG2XiMNT?=
 =?us-ascii?Q?hRtadGGr53MhIrdEwEFEKJAlLSXSYluisboNdVbKniB4t0mXEYdfEQL5Px/a?=
 =?us-ascii?Q?NCz+HalqAvrh5Evb6MqQQcE67j97rcjLPbEos6ncI7labjnoIoEWj8IlTTVR?=
 =?us-ascii?Q?Ivww+Cj11rEpNeFsOeq/3dW4QwlASRPW+ALrLjXmzIrq/ybk08mwMDWjRpND?=
 =?us-ascii?Q?DGGcwvxx/vg4dFXQjkD7tbTXW88rbstT2j0LPUHYIiNz3FaA85YtoqUbIxSN?=
 =?us-ascii?Q?28GAulJyto2mL9i5mjUAd7TJnxG38CKt0B46hTQWs331sMbVFfvD6/FPPSzV?=
 =?us-ascii?Q?Zosv8/88FZz6mIgk9ChuQYTbXH3gF28tdHlGSqr3wt7HDQcmdZJTFczjl9wf?=
 =?us-ascii?Q?lPi6nij5vueEk9NpXYjpjhN+t1IqePNGSWNUzvb+NWBc/LcEh2tewlxWt7JT?=
 =?us-ascii?Q?x7UHWU0rT0VqPfs/+yA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba753ab-36d3-48ed-df81-08d9f09f3c2e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 16:21:35.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tp58SWWfkin49g8lj985PjSiIRy2nQ0h+2V9M9BaiKxDsYO/7WlXU3qailNu8Jh+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3084
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 15, 2022 at 04:00:35PM +0000, Joao Martins wrote:
> On 2/14/22 14:06, Jason Gunthorpe wrote:
> > On Mon, Feb 14, 2022 at 01:34:15PM +0000, Joao Martins wrote:
> > 
> >> [*] apparently we need to write an invalid entry first, invalidate the {IO}TLB
> >> and then write the new valid entry. Not sure I understood correctly that this
> >> is the 'break-before-make' thingie.
> > 
> > Doesn't that explode if the invalid entry is DMA'd to?
> > 
> Yes, IIUC. Also, the manual has this note:

Heh, sounds like "this doesn't work" to me :)

> > Like I said, I'd prefer we not build more on the VFIO type 1 code
> > until we have a conclusion for iommufd..
> > 
> 
> I didn't quite understand what you mean by conclusion.

If people are dead-set against doing iommufd, then lets abandon the
idea and go back to hacking up vfio.
 
> If by conclusion you mean the whole thing to be merged, how can the work be
> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
> in terms of direction...

I think go ahead and build it on top of iommufd, start working out the
API details, etc. I think once the direction is concluded the new APIs
will go forward.

> > While returning the dirty data looks straight forward, it is hard to
> > see an obvious path to enabling and controlling the system iommu the
> > way vfio is now.
> 
> It seems strange to have a whole UAPI for userspace [*] meant to
> return dirty data to userspace, when dirty right now means the whole
> pinned page set and so copying the whole guest ... 

Yes, the whole thing is only partially implemented, and doesn't have
any in-kernel user. It is another place holder for an implementation
to come someday.

> Hence my thinking was that the patches /if small/ would let us see how dirty
> tracking might work for iommu kAPI (and iommufd) too.

It could be tried, but I think if you go into there you will find it
quickly turns quite complicated to address all the edge cases. Eg what
do you do if you have a mdev present after you turn on system
tracking? What if the mdev is using a PASID? What about hotplug of new
VFIO devices?

Remember, dirty tracking for vfio is totally useless without also
having vfio device migration. Do you already have a migration capable
device to use with this?

> Would it be better to do more iterative steps (when possible) as opposed to
> scratch and rebuild VFIO type1 IOMMU handling?

Possibly, but every thing that gets added has to be carried over to
the new code too, and energy has to be expended trying to figure out
how the half implemented stuff should work while finishing it.

At the very least we must decide what to do with device-provided dirty
tracking before the VFIO type1 stuff can be altered to use the system
IOMMU.

This is very much like the migration FSM, the only appeal is the
existing qemu implementation of the protocol.

Jason
