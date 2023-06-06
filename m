Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB25724A6A
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 19:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbjFFRjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 13:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbjFFRjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 13:39:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF8E47;
        Tue,  6 Jun 2023 10:39:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHwfCpRzGIBEPRfR++qZzkTJb+pImlf/1o2L/i2JI5IxlSeqU/B020aR0Iy+2d7y0J6X/lTAlbkoLBvZ3ZriU8nFyx67JIbcGhWuTCVzPMDwjkrGRuouN/hmqHSIGqCTJrytFrwhcmH3SyswzloPBYTYy7qa2Dvp+xnSFUC1vbWS3jBRsMcf6YfTjWDI0s+LZ8q0Nk806paEcz+evn9PoUzsBW0KK+FyBNyuRxWT8UDmjw1o/r2w1n6e8XvYxfr5EG/cA4mgDFHFo2CYUCLsXTazB48XtZNNdYq7F+YIq8GjSTWytil6wJLtIe4WJK0TDbGD/0qCda2Mok1tmprCOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXE+GwIuVMTiNu+R/JalQk+nel2vw+eLcjLs6O2WMIU=;
 b=iroYgjSMKH8u1rdl2bVb7CVg0d9AZBaDP4JLjLlIJyGALDlpdDO4zRQeN+lMc2sbqpSO8VL2DOq3EBwLzAdXPHqfYH9lJd+cnlhS9kNms92CkhLMc+lqwMRyveSr1szAJMLfEwp8F6x2iOQRQJ7I6AAGf+hij/478D+KJmMD4/UmKOmVtPzrsean4aJFpOruCNDztPs67WqBCZjcBJz1cbpyssRVE+QO1Bwqx+RhKCQBPl3rxb6wLFbwR6UQkWr09qqGW6qAhrZhSFLXLHVEVwhzQMIfpN3ymBPHrAI+51MIpK6o3/2VV2ztXrwmEUGDfklifkJjGVrcfqooxnNmbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXE+GwIuVMTiNu+R/JalQk+nel2vw+eLcjLs6O2WMIU=;
 b=DcdCtTYTQRoGgfbt6dI4B+U6vPsHxLcPjQQ2JkK5ja93zWD9/u5UzNsHQ4k+SDHp0NKuXHyjQtdJBqKYy3n/Cpfw0QS+pOPpI4qefI7rwxZOePvsv7/cdlzxQa7rZECEqJL6JK0RfHG7+fta/dig80LKZGUGlaQTDF7jrdBwNnBBjhCOXonJKUy59sLAAd3m0GU57S9Qmp9e3OxvllfJbq45S7hukHVg1w0jDq5pHeZcsBWf/uBJN8og42rd2Fk/T1lWUC1Ox02Xxx59SqvLD67bhtRLBRCrxpiurOrZjgqLRVi3LtAx1pLmZ797fz+EHB8TcoeQ8YyM3tvNy9gZCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4082.namprd12.prod.outlook.com (2603:10b6:a03:212::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 17:39:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 17:39:13 +0000
Date:   Tue, 6 Jun 2023 14:39:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
Message-ID: <ZH9vP97MhY66Q1MC@nvidia.com>
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-2-seanjc@google.com>
 <87wn0hnxh7.fsf@nvidia.com>
 <ZH9rRnU8h+gDZZuB@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH9rRnU8h+gDZZuB@google.com>
X-ClientProxiedBy: CH2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:610:60::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4082:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dde1ceb-b753-4011-78e4-08db66b4f14c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qoxVsflvj94qYjoyX4CwYyYv4cHBUCvXyzVt15Hfzgdc4nIGDkiZKT/paOg2w6DYX3D8hS15XUsLki6OROqRDHUBdqo527jmO6Gma2++VFkkX+WvKv2+95LZkDZNdetoNf8vAVZquN/03kKODZpWYZ7R8VIWUySxjVis5Y6B7FL7gIFxyoWtTQ6JXj0OSLgOxDoHt6wvYdK9HHf5aOH++DhPcuq600D4UcM4avnmxinY/9+64xc3AOUf9RRehmbS5nN75pSbKChm5446NL2/CVZUgo+Fa7Ka64wlZY1f/GdnYiuSAWF8E3J73qnJZ84oGhqL4mNO+kaGySlIeRJTHxYZOg3VhuEr+kbd7JR2zlOmiu3K9QGQn9B1NDFbzDHEOETmgSg3KjgzWuPdBVcvmxipNoqc+BcuhAOiSf2o69xy9Dg4zCgzvgOBh3KCrjmnha0DWT0nNc0kX23X/CGp74KA+WlwaMEq1Hjdyn1gM4BoMm2QKIpE/Sf9+zMZypgOyHCfO+lUZnWFBh+2Zdqg3ulYy66im7VfMmJC5PJDiyAekyKWyqB2NFWxk46KC3+E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(26005)(66556008)(66946007)(66476007)(38100700002)(4326008)(6916009)(83380400001)(6486002)(478600001)(2616005)(36756003)(2906002)(6506007)(6512007)(41300700001)(316002)(8676002)(54906003)(8936002)(5660300002)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hp7A36AMCDk8BMW+TBZpgHXB0nga2Y27XpCYUB2TyWspBmwD6AFT2an7tyG8?=
 =?us-ascii?Q?6JXAxIjOJaJnHt2iWbKfylOQRoMkShHWxwf8sgC4AgZc5l+jnb2C4O//Aekk?=
 =?us-ascii?Q?KGNcnQzs+uGZMsGth7aC8vKKXHVXHo93fH8vP530iev73hlXFQ/Ec+IRzEqJ?=
 =?us-ascii?Q?SJKLHWNGZb9+f3JGEeSBAp5agLFFzWVMP+T16uutrISgqbD5U+AYaXhRbnsK?=
 =?us-ascii?Q?x0l5DE+/omMJmWqitXdrzYUOwpjG06oMKmBYz30S9+Kn6qd5SJbH/vbYycBV?=
 =?us-ascii?Q?LPlkU7P24PBeGPlHzEzE7FYtdiKBzvcgw5MlEVmenxdn+f8ypT4kWhKfpcdw?=
 =?us-ascii?Q?OXA1B5jF3akrzWhI2+V6j0ZqMf0kK2zeA5dBfKs5BOflfDDKSE2CJncbC3Tp?=
 =?us-ascii?Q?FBxl8JLog79zls6rATq12CPG48q504aHH4Sp+DpeWG4GS5bNMz+FfYr8b+gU?=
 =?us-ascii?Q?dq04pfjB/MnIAHHk26I7D/qOsOPfQCrzoGuXcxS01y5pTJw9aG0/yus8PujJ?=
 =?us-ascii?Q?HFxe4mHNhfPRDmmQjCwN4BwUfHzHT1wS5FAbcSwvlbX3KSEZ8eKTUlJLqyzt?=
 =?us-ascii?Q?jPpur7XJkXNcEChYxaDAXlJRhCuL1+FPjgQCPBB/kYeEExp3kjfVz3wHYttU?=
 =?us-ascii?Q?nkOs5Ak1jfzdUX0mZTuyzhx4aseJKCsaKd0vPYaKdqgW+g8rGwG5LB7qtIgj?=
 =?us-ascii?Q?6w88SmjG7wjLIfLkAA3rkAY/JSKCbOOJewL4wpt0mI0aQU/huapoReYqT+bY?=
 =?us-ascii?Q?BoeEvNU1+/UTOqQUbAqPY6yUop9nCXc2J1TmwDx7FyMIMXn+IxMypnrPhqTz?=
 =?us-ascii?Q?6acVaRwjqmwi4tIHNLEVgrBB2PAZUn08gWI6KuHhK2CUQzuI8+A55OUnOnLr?=
 =?us-ascii?Q?r6p6rEckcJGAAEC0kakwMrzE1nZTXE1U+Z0CwaQb646iJ6SHPbPU6yUx70BB?=
 =?us-ascii?Q?MDAIqMDqHQ2l3MshknjyYtbryrQTEpf+8vBKacadjOYhW7pED/Ql5pSO0ocp?=
 =?us-ascii?Q?6bY9r+elYB/m5Os1YzGDESpk77OASCDXoOxQK8APg/bo0du+gv3SzQrOf8+U?=
 =?us-ascii?Q?oS7B7p8zMH/pHS+kKRMa5rjrurXk1Kkd2I2QyOZp8f+Az4AzI3jyphb3KkkP?=
 =?us-ascii?Q?JeU2XtAABnSdJAwscZ1Yc6verot72Kdg1rMIDY/oZocMuM+ilKGlCyjW5Vvk?=
 =?us-ascii?Q?f5oUc/8SKMFKacK3vA6lxzSvDBnuRozDc5IwkrEsBBHGpmtQhhYqw7sS5d+m?=
 =?us-ascii?Q?E+4HZhe3h5S0TL24I8JDbkXmBRpIKSewloffg/hOrP765EmcFcoqXY5AgILV?=
 =?us-ascii?Q?khloozSnf676+HIstIyrsvdYztmrwcc7SB1q4Mp4FEU0ckzF5q2RnvmS4JIj?=
 =?us-ascii?Q?M1POwWNiRkOp9TmvLdXMktP6LGn8A12JKhBjTz99qBrXm+kj74W9ZFl3W20I?=
 =?us-ascii?Q?e0H5JBGA/ihShJSgen9BMSFcMe+RfEhEbp2k2Rxcz1fpn2UgKlxPsg4GLR7J?=
 =?us-ascii?Q?KXWFAAmYrmbqQbAAxEp22MLQS+lfazuzH6KSfwNA1cI9Puqt5pjYX3DWKV8H?=
 =?us-ascii?Q?o8JrIls07OkBKnK1expBIqn26DN60vg3WZLBWOny?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dde1ceb-b753-4011-78e4-08db66b4f14c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:39:13.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISyEunUF6yitILzYshD3sllzXVIxlWJ84q21uAeIuNwEVmak0SstTY9It6MDAvN7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4082
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

On Tue, Jun 06, 2023 at 10:22:14AM -0700, Sean Christopherson wrote:
> On Tue, Jun 06, 2023, Alistair Popple wrote:
> > 
> > Thanks for doing this. I'm not overly familiar with KVM implementation
> > but am familiar with mmu notifiers so read through the KVM usage. Looks
> > like KVM is sort of doing something similar to what mmu_interval_notifiers
> > do and I wonder if some of that could be shared.
> 
> They're very, very similar.  At a glance, KVM likely could be moved over to the
> common interval tree implementation, but it would require a substantial amount of
> work in KVM, and various extensions to the mmu notifiers too.  I definitely wouldn't
> be opposed to converging KVM if someone wants to put in the effort, but at the same
> time I wouldn't recommend that anyone actually do the work as the ROI is likely
> very low.

I looked at it lightly a long time ago and came to sort of the same
conclusion, it might even be a negative for KVM as it isn't quite as
tightly inlined and lock free.

Jason
