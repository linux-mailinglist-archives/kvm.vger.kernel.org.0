Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844B07C0002
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbjJJPK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjJJPK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:10:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6AEC4
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:10:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZjxFtahkri3NCmK3NPc+labASxoURrAzyfGBF47xwpCClnMIkKSNIYxHcxATiMW8tZIqNSontRLx8s6BaIMQTPLpu5MSwd2aPKU2H1B2yCySgRz414L0ZiUB0FLD9r+d1Mn0kVtHS8OagMUyF3ytu/k2EjWwpVIiHjegpPrgxTzobs8efuzDF0x33Du3cBsFygLpc54I4OAHcP7AraAFWsd8IkQ+Z5EHRdqslbiIML6CiSI7iez9i2oWTQZ+MHkZnHBOlbuUuhAM1YG0eibdEQkk1n6mEK+zoCOlla2lopfk3EwxZs1X/a8fbIHGslMtZRSmSdC0jYdmLhHuSE+cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFea1RlY3J2gpKigDFeb7X33uxMgSzAo3OUBDYkrL24=;
 b=hQP1dUvO2/T2giOhuNkPSIiJCPtPODEGtZNJkPbnSAaKwPBZsYwDMZ8VUR2WuBOUaJ+/er09o9izTtq6+mMfKlpFEY2xreFGbfDNsOCguAQtWqcxZS4zummj7x25biia06XjXFDGXSa7Mm/1jxR6kSievRObXc4hSO6x6c4tSPexu06+ILjw/EGlzV/rmZJhesXdZQWM4CMxVqCr8mp0gkBt9kxREJFLbUwTscSTsu9H0EHed/9Q5KKa7n6RqxGo+537i8LOV0qDNgnELeStNc8Ab7zBzUzTk2C8Lm0s75KIqLwZO6QG5gy5FnkMLrbtdK0coUB6qQI11N5On8O+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFea1RlY3J2gpKigDFeb7X33uxMgSzAo3OUBDYkrL24=;
 b=Xmz05/LaUO9JoyFjLtFo32EdjHpCHi9Hq8yEEFe+MaSGMdTz6WeSqRNtSFKeEssQlfx3UrJ32FQRbelhWIe2MR9QZ7PKWFIp49dFTv8c4pu4NFDEiwXqd4ZRiLzxvk2+aEnx4DFwh//qsxkEzZ5jFr8MEmcE20APCOP/mhb1knLCaHp0BWbF9+QE9KK1gc1OnN/wPdSvsX2Qkz/Bdmwa631UWsKMsjNaBojtOi7rmGxlbXwSEY92zGcsDCou3PEva/nlvl4EJkzfmBvuMIaxEAarTwtxJODZ34aadD/+xZnFrdn2Vl8lv+dVo8ZHTMXbXaRILCBu/PXILBGbdmBoxw==
Received: from MN2PR10CA0028.namprd10.prod.outlook.com (2603:10b6:208:120::41)
 by MW6PR12MB8866.namprd12.prod.outlook.com (2603:10b6:303:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.43; Tue, 10 Oct
 2023 15:10:19 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:208:120:cafe::9b) by MN2PR10CA0028.outlook.office365.com
 (2603:10b6:208:120::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.27 via Frontend
 Transport; Tue, 10 Oct 2023 15:10:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 15:10:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 10 Oct
 2023 08:09:54 -0700
Received: from [172.27.14.100] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 10 Oct
 2023 08:09:50 -0700
Message-ID: <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
Date:   Tue, 10 Oct 2023 18:09:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        <alex.williamson@redhat.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>
References: <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org> <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org> <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org> <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231010105339-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|MW6PR12MB8866:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c66530-e87b-45ba-ed3b-08dbc9a303ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQQfnvkh5xrsKZfdZckVPgYWSoTm5FvwqzjrpcDlM6pr8lLGhKOXY/sk5EG8PWn+QqE4d9QJ5RFpT0XX9Wggqbj55+MbWKHcf1F59dXNRcGVf4fyerHDzWy5Qy1+u6u/shfK8jPjGekcSmnI5X55nICbpPG+R9HIVcudCUtFZPw8WEdYXp3fgJQlqQJJLZXTp+q2VeBnhDRFpxr6nDsg3IxlI+InjJChOtXYSHpaxsPBSO18nuso9noBfmmTaSAtqXdBpqNuAz73MJ98u0gqfjdksAlM8+kFdZoQx30cFvgXRMTJanVbBJbQSTWj9c8E5rgxHjpoSg+5QI4UZK+mYObcR5Dxfh+LmWexFpcjqxzgeljm19GqrIPGrNGq3ArKbsDgRtbqHDDxSbHdpsWraFVLacsCZ4o/2JWaWvItDnt7cCZsXOSHW3jKZ2vraixfbgn4bhjt0jg21MMP6r3eTx34xfHO2RsKjNzcQ749LjxXzXaJiB8CKWYIM/vXect+gijXOu7dw6/xLq8OMIdDZBGTP4wcWB39GguaIK+g6MU4k6seGzIrJGcklxYGSHQwxhme6ZsNbmwLRfvgL8g/CnqGiE4tlOp/tL4EYxIuK0+Y9R2SLgX6R7hgcEBsYjdNpZafON35yOV+4lda0taA7fiaPELTVWoXIquYFF1R6k/I+CPhm4T4clKd8pzfJ4nf+NEz0pWrR3oyvanXAt3xFMUdSGE6upI2yRHpFGswKbHYcglCzt3ZfARj/0CiKhqV1asx/XMCRdqmngRaVSTl0A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(82310400011)(36840700001)(46966006)(40470700004)(107886003)(31686004)(26005)(2616005)(426003)(16526019)(336012)(53546011)(40460700003)(86362001)(7636003)(82740400003)(36756003)(31696002)(40480700001)(356005)(83380400001)(2906002)(4326008)(36860700001)(6666004)(8936002)(47076005)(478600001)(8676002)(5660300002)(316002)(6636002)(16576012)(54906003)(110136005)(70586007)(70206006)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 15:10:18.3399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c66530-e87b-45ba-ed3b-08dbc9a303ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8866
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 17:54, Michael S. Tsirkin wrote:
> On Tue, Oct 10, 2023 at 11:08:49AM -0300, Jason Gunthorpe wrote:
>> On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:
>>
>>>> However - the Intel GPU VFIO driver is such a bad experiance I don't
>>>> want to encourage people to make VFIO drivers, or code that is only
>>>> used by VFIO drivers, that are not under drivers/vfio review.
>>> So if Alex feels it makes sense to add some virtio functionality
>>> to vfio and is happy to maintain or let you maintain the UAPI
>>> then why would I say no? But we never expected devices to have
>>> two drivers like this does, so just exposing device pointer
>>> and saying "use regular virtio APIs for the rest" does not
>>> cut it, the new APIs have to make sense
>>> so virtio drivers can develop normally without fear of stepping
>>> on the toes of this admin driver.
>> Please work with Yishai to get something that make sense to you. He
>> can post a v2 with the accumulated comments addressed so far and then
>> go over what the API between the drivers is.
>>
>> Thanks,
>> Jason
> /me shrugs. I pretty much posted suggestions already. Should not be hard.
> Anything unclear - post on list.
>
Yes, this is the plan.

We are working to address the comments that we got so far in both VFIO & 
VIRTIO, retest and send the next version.

Re the API between the modules, It looks like we have the below 
alternatives.

1) Proceed with current approach where we exposed a generic API to 
execute any admin command, however, make it much more solid inside VIRTIO.
2) Expose extra APIs from VIRTIO for commands that we can consider 
future client usage of them as of LIST_QUERY/LIST_USE, however still 
have the generic execute admin command for others.
3) Expose API per command from VIRTIO and fully drop the generic execute 
admin command.

Few notes:
Option #1 looks the most generic one, it drops the need to expose 
multiple symbols / APIs per command and for now we have a single client 
for them (i.e. VFIO).
Options #2 & #3, may still require to expose the 
virtio_pci_vf_get_pf_dev() API to let VFIO get the VIRTIO PF (struct 
virtio_device *) from its PCI device, each command will get it as its 
first argument.

Michael,
What do you suggest here ?

Thanks,
Yishai

