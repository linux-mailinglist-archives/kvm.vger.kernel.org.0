Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6858805A
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbiHBQfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiHBQfH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:35:07 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141914B0F7;
        Tue,  2 Aug 2022 09:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTzu9kE1yTG9rWpxg6HXx15jtnSMC57GsdCaBux6IJJIYBz4bWAr0Cb7xukvjV/pT8Z9iYMmfElAfDnp2j1qMiT5U3X9GUoVR+tgAyY3M8A8obAqO3+3zRBF1tMLqMaim+z/IMeWUw13n7Rc9AdqepoJWe6q/zkIMVeuSxAFBDKvED4mg9yghFzSFpjotvuOUS8zap6hfmFw0LtgLwMYXYAxazkredZgng4+a4SCm0q2Ozs/fTdm60KvYMBUtxS5DFrOIpcCK9jkInrjzxKMWfey/9EmbW3tlnofogAq7V1hUQHAIc6Yfhw4nC7xqEUVDA636IhmHWXEln7TSZmRDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrMAzaQWGC1E/LeUoeymVAaQsVoLc2YAwavjL+Rw6EY=;
 b=O/IpTU6CmJIFkO58QVV5UsBEipxUmbhbqZneDefTJH5pDaHNANwcryJp0LKMlirzEvYXAtzEaKdbldY03QxvSuEr8uESZ9suas7GVdQSIWsdVsz+LAgP7MLSlhcmEg29sHUDXmeh160JdZ5Q/yYwSGPxRDISg0BXMqLM1PI+FgVeBWfrhne190emk8WymgQk9aG3wmNPYGBdixikUZB13+j0QKLzcrTXX7ZG1mPeNhRCG5zrp7AGMViUK7LFExFFLL0/vgAyDcJD6PBCWG4hfnLXypkcIC3yFe1FgIw9Nzw1hvnn/llX7sNmmTus/KkobXCHpDPxhuOu7KH8VlgINA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrMAzaQWGC1E/LeUoeymVAaQsVoLc2YAwavjL+Rw6EY=;
 b=HXF1YQwwuBY/eYjC+irHQbQKFh+b/ZlHtgK5aXoDTgsDRQJAnwcNFcAmhC9u8jI0pErVo8NGuF8cTw+OEn2nLiqPGuNdekyQZtulwKUxbwtbfnXHgdihEGaLAR//Tb3ZZEavYwQPhY4fRE4jlnvJ9AdnirqMRZ2uZZ6n9hI+cx7r7O/9cbjGbubKGLYGwNl8dD1h1CUG6S78llXOoQLe8qL76pqfboxA38svHnEL6IF+rOFLX49sf2Jf9T0fWxlQAxZE7efHvAYCFxHAm8uPpAMmOiSCPKUzQIhpmuO5+RPearWrJxYHwLuS/FAr1QVLUEjN3WvnGZd6qmt9EEq2Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Tue, 2 Aug
 2022 16:35:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 16:35:05 +0000
Date:   Tue, 2 Aug 2022 13:35:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <YulSOK+YKjV2634b@nvidia.com>
References: <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
 <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
 <20220726172356.GH4438@nvidia.com>
 <f903e2b9-f85b-a4c8-4706-f463919723a3@nvidia.com>
 <20220801124253.11c24d91.alex.williamson@redhat.com>
 <YukvBBClrbCbIitm@nvidia.com>
 <20220802094128.38fba103.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802094128.38fba103.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca652ef4-c87d-4267-bf60-08da74a4f46b
X-MS-TrafficTypeDiagnostic: DM4PR12MB6496:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 812IN+sQp/gd/y2/5escjHYaGsOQvtTr7eX1bPtlcKMrk9416txDmLh6wPMQIzQ6HFZemecZP2ms8FKHJhkfr2OZFxGhkeJqKm+q2w/d5vae7zYhlR4GC8DyOW4y0QzyPidTqyY89Wdk7XL5UPJkfN4r9vlVFUVmbhuVQH5euRgMIiR8HqIkv1+LP4vwM5RboMynhuRN7jBmBt7tWJ6CnQ1YgUxFHKQ9vgfJFXNgsO3DeSEl8wlj90wnyoD487B584Gd9zv4AHsfJ4i5hI1TqJQ0HX2IGdtIcUhPtNaxRHdXAkhmjRgIvDaVWPgxPt/6mfdk+2ve+k21GfUgA6Kh1gwMvYud7CwNF/9Bj4amHzhjLIHSzy+yWwB1cj1nesobbQVemc1Ioe0IUjtCFzPvfGy2V5ruTIzVN/qNMvzPjXivyC5XpwQOCYYZ2xaAJZMSl2F3+KzprVoXWsg+rSb4UiM7LcQ8BFbp+EeNM8ZhJN3PD4EyNUUbaS7Y8IMVKo6y1xr7kz7NupVlVXAEjMUUUSzOWuADLyih8bt/kCizM9xpxwHjWTcnkForMJc43EkquS6Rw/xZk68ti0Z/Af71vDjfBdXnB8mJbPlOHHy7FUHLrrBNwj8ILQ1Q8kCLNcFBPljWdiTGKgLHXQRKC5Tsq0pMwUrcxSVCKlBG7gtOMBaDsW3Fvk4x153/7xwRYn+OrfXA4hwIQ3pv2MPQJGWgv5Zsz8docHbSgkLCvalRCS1jLEWelnPpYuk9m5L+LYAd13wXH4j2HBhCZas84tlDFDcznkT15R5VJz0lgc/kYy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(86362001)(83380400001)(26005)(6506007)(2906002)(41300700001)(186003)(38100700002)(6512007)(66946007)(6916009)(316002)(6486002)(4326008)(8676002)(66476007)(66556008)(54906003)(478600001)(2616005)(8936002)(36756003)(5660300002)(7416002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIQcxWrUGrVl+N0b/ceNNGtFk8quMX2x9zVH1yE+wksZhKMSgmdxaPW/o6Ib?=
 =?us-ascii?Q?WnbMSV611dp85/CDlcTSJfJ9w3BFK1XACJB9aUlG1s6zlvBIdaOXeKeVdFi1?=
 =?us-ascii?Q?7la+4OyIvGPIyVrSzsLElmf5bcGS9Oimu/+DSUYJahSkJQDywSzIX9skLelC?=
 =?us-ascii?Q?NYsi1yOQjNrVgePCxbzti0lezjLGOlkZXlw3jIIsn+Mm17tqPrHA4XiyCbU+?=
 =?us-ascii?Q?Kv6wI1Kbn4RPf8OdS/C0TJ57xce5U3vI/0WxOHx9T6ohLzZ+tqS3ka01/E5Y?=
 =?us-ascii?Q?+XwqL9cCcSrtQLgg3lDrbs+tLwumPuiPgIcep8uX/Wq1YtF4Q6rDedxC6nDe?=
 =?us-ascii?Q?3WgmoTnJN29Di0tePabEzp3CcD6g72KIzrIDUAobtIlz+MmAEBf7g4Zzrwqt?=
 =?us-ascii?Q?CeGdzRveK5CZ9cpvyzC2eLq+9wBi4PliDJJVqcsdhG/lCXw97lSeKuORF6Ch?=
 =?us-ascii?Q?QqpkkhFSmnJaojuGbaMuCmrr7zopBZz26ZNlD4cqdlhFUA76e51A/aOPqcgm?=
 =?us-ascii?Q?uOadec970mBmWbfk4sURDt79UoixrNSEci37Z1Zh0PWRsNz5K1OFaM3OovzZ?=
 =?us-ascii?Q?OThhvtNhqFxsROqOWbY7PzjKnVU7nsTSTEMeY7bSVlG8t7nZq+zXMQdlgQ7L?=
 =?us-ascii?Q?dPMrhZCA+fz3IjvFsU6qBhZW+yRfg/VmALgLjqGR5HrIy3MyTkkOLXdA2P2u?=
 =?us-ascii?Q?1zeaizgynZh7mn2tryI7PUFtHwt3HMJZsaReNDg+7kwZucp5Bsdrx8KHtf+k?=
 =?us-ascii?Q?x6bXdjZqjYcQYVSHsfn2QvzJ34SOqmXY1dBKCmyShTHjsK/WrYRDJbMhpiQE?=
 =?us-ascii?Q?Jb3pvze6yBzQtIQ4J8UIdgzovbi9efsB9NZrpCWgcadTrGIfZWAJ258dggEq?=
 =?us-ascii?Q?nI6klSl4rbVsPTpmsvG6goqJFn9HLmTLH8EDu0tG2wIduEroTsMp93Kx/WjK?=
 =?us-ascii?Q?S7eECcZeqzyjsJXg0zvDEHnXEJbs6A652rp+J4chd9+KTvU19tkOAWVWWdkz?=
 =?us-ascii?Q?0dmGLX/9fQEmCpVuuLiwuuCq8zNsRnEM32ZQwLO3oh3AD9YQDZX49XQytHZ+?=
 =?us-ascii?Q?CfXiYXoiCMuDOE3v1t34b6uG+VNrH/Zkj8oxfn1PSkshKoXaZN5/SFNHrziV?=
 =?us-ascii?Q?HhuxLq7ML2MSTkvJqiLJbgL98Xv//M0rptAJ+Gssq3UqsizvijPIgAE+k+uE?=
 =?us-ascii?Q?KjFRPNBndaL8O+B1KM/W9RY+YJwqdcn0YdfmRjkEb9wlejygO6fLIkwX6bB+?=
 =?us-ascii?Q?LzoaEKDUcwbDNoRq7IIPPahy23+phDDy0qbkbPLwWyKg2ME6imb8gE1gMFUd?=
 =?us-ascii?Q?vD8oEnvUNDqlCqihR0wdY7vkNz8x4LeXEUuqK9K4ROpAoh0uu0e4dhn4jBDH?=
 =?us-ascii?Q?2m3AqVvya77tCQ77t7y9irdEN8alUo8tHrqOTzKVfCQW+0Y81DFwLbWDRQ2r?=
 =?us-ascii?Q?AabZeyTYK+0vnJ43CH1rP43GbQaxEEbkgd2Jajne+VhKUB0KqjP52fUdkYsK?=
 =?us-ascii?Q?cVk5CGCh0yaRzIcjCgIcmLegeb2miNir4xRLVAEe7029YFphvPoZV7ZV6UyE?=
 =?us-ascii?Q?fCc338D+2c8Ot7EqjKEEMiKcHSqVrV7LjJl4n9ri?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca652ef4-c87d-4267-bf60-08da74a4f46b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 16:35:05.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXvK0Vg8lFwlyPcp3SOkfSEAyOfLghG3JN1rmv+c4KQX7eEnOK9G9b2Ag35Zi1p1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 09:41:28AM -0600, Alex Williamson wrote:

> The subtlety is that there's a flag and a field and the flag can only
> be set if the field is set, the flag can only be clear if the field is
> clear, so we return -EINVAL for the other cases?  Why do we have both a
> flag and a field?  This isn't like we're adding a feature later and the
> flag needs to indicate that the field is present and valid.  It's just
> not a very clean interface, imo.  Thanks,

That isn't how I read Abhishek's proposal.. The eventfd should always
work and should always behave as described "The notification through
the provided eventfd will be generated only when the device has
entered and is resumed from a low power state"

If userspace provides it without LOW_POWER_REENTERY_DISABLE then it
still generates the events.

The linkage to LOW_POWER_REENTERY_DISABLE is only that userspace
probably needs to use both elements together to generate the
auto-reentry behavior. Kernel should not enforce it.

Two fields, orthogonal behaviors.

Jason
