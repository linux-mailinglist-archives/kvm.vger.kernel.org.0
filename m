Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3936639F6A3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhFHMcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:32:32 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:59008
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232611AbhFHMcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:32:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Td6rdUdGbb/rAEFhcMA2qhtNFwn339mm76IlyqvxqmTOxukIiNHtA4pzDNKjDsR4kc+4PU1nkWykocpYb2uLgblppOxAsesdEQqX+kLj9eLjNEV++ulLvjq5oyH9KFHIaqqx3mpNjCRz9wbilYCCDZQmFUEUfgec5lkiWUTDMqgx4/V2j4ISTgTKu8Ex2cRu2BoXHiCT9vsNqSTAeAIka0lEvJ+f6ZKIHPjuNO+lPMJFDy4i0i8XxdMPqIzCmH0k6f3eIlu1QjKD0geG65KyiNamfFSlNVyHPphoFczVeAEsoejFItd9V/EEFjo2i543+Zo7yyD9W6kmwCNq2aef/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAfC78oeJCIjjjXGDDYF1H/I7MGkCfUPXf6i+ieDMSc=;
 b=L5+R7eNYhMEI+6AUBOij33a3ZAmkmV1BTFJ05s2+k+XJwjRbqQzLuxTsC2LkFgTZgzFcDwniWKJWklgdBXdu/ZQHGNJ49x80lNiLS4weSnKlgthubLRTm5SU5q9z6hMy/3ftnonsv5OsRp2mSG8Zqk3JO0qGZAb7B4syAX4/0DEqnZqjOGF8NPtoUOi/znztmUPoCHnRcjJvXAX7xXIDaAIZ/dPvVRF4GwxJYJpu3/gLj5EpOb2DI+zDgRoU3uUo4kcm82MUAYzeMAsLpJqvskI7rE8EDFFBWdLX0kSvoJLRcUYdrV6OMgkN7xtrbCoktCmbmzsmf25PvPu54Joo5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAfC78oeJCIjjjXGDDYF1H/I7MGkCfUPXf6i+ieDMSc=;
 b=IFtEea+RNT0AfCE+A17evHVfVEzVB5GqaaPmlvSzHS4c6GENu+MP3raHBOqWQfeM4NndO5MM37TmCDkyaITjM5O1CRaIeZFlLpy9F5c86XO8AHWQqgBmUi+C+Rj3Q+LOafQ+/QuLj8qqUOkqKXYfLgll5iSARXofycra3HqWV5B8hwg4kxH8hJ8g/pboKoQXdl0lgqzqAl4WhxpIFuaiU6HABHooHZzAEKCmc/iOy9jEUOn+3uNCB3omr9C0EdCKQCwWFIuA10t8Z3eeRdGdWl3KW0W36EQtRTa100HCspz4mn6bxceF9PT16yC+b8iu8M4c5lu5i+Up7JCNUh40tw==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Tue, 8 Jun
 2021 12:30:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 12:30:25 +0000
Date:   Tue, 8 Jun 2021 09:30:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
Message-ID: <20210608123023.GA1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <3-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8SdymSgn9HHRcw@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL8SdymSgn9HHRcw@kroah.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR15CA0022.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR15CA0022.namprd15.prod.outlook.com (2603:10b6:208:1b4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 12:30:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqasB-003pOg-Nm; Tue, 08 Jun 2021 09:30:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89295ad3-7ef9-4117-9757-08d92a7930d7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5159:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5159DF3980A5DCD58F3B988DC2379@BL1PR12MB5159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcmqVMl43XiSoeo69o4w3nR7yQxs3eZs5MJz6Eg6DbvZj/lLa+4DiSOWJafA8XMKTyGAPF11Fn9yiyBJayLzGnf/gRa75jKlSXJq7RWstpw39bDqMYIGDANAaCZ8e8q9T1UbNyFabVdQXZGYI6i+PRGz0Se0csWFCte65GfNBc+Ya123mibUCJGny8XMIQibFagkqce3dBYrrHp/MIcP/whq7xPZ7ApNIjxfSrexT+55h2lJafTdHsEmWkOgI0PkxvmQI9ZpWRl7qDqjgoktnLHqCy6q8BpgPwSe46jbcm2rzxYc5ZjdltzfLKsKwGB8zolL75ILIOJLKTgFmxP2MfulO4HOqfix3lzGLEVUrgLuLPxPeNyYrVI1RLw4v+G3WeJ9VZOcLFLAI280dhv+f1KMFPzalEc1HPH8WVfFvpZi9zTIvt3ykYnsQYNG/+PRkWGkeXWIIoqa0Dy5zGqiXRnILbiWsXhUi1ikEpHgVoTtH76brN77EfaR1kbG6/VVJtWvTHvBIBR5KD13gNyViUW5+EJLnu+4TEJsiIQ7643ye78bXC092Uoh29pg0BUckfr16WSUH9Zekr7Bon4wak6c7rVhyNSqytBFklyWwT4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(478600001)(2616005)(36756003)(2906002)(426003)(26005)(4326008)(9746002)(9786002)(5660300002)(33656002)(86362001)(316002)(66476007)(38100700002)(66556008)(66946007)(8936002)(186003)(8676002)(1076003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X4RDbba4qhbvDc6XN7AFydl0pom2PuBxkrXco8XfuYgakO5I0X+rfnrBFFVu?=
 =?us-ascii?Q?7NMVk4Uo5nW6k7uGQRL9KRrqmB0sDCP+6mM4cec9Mhwo2LXidBT9VvT/fHI6?=
 =?us-ascii?Q?cQZIwkWM9Cxwwpy395oR3MyD1N5Doy2JhdLPvGZ1tSbV/Fb7CTPfaIlzMcKl?=
 =?us-ascii?Q?J8XfF9Stpu6fc4EZKu2H5+OdfzRD4eX9X7l87XI0xkeuGmx0lGzhDLYa9wz8?=
 =?us-ascii?Q?bmS94bT+Jr4Zwrm2CTwHFnGPw0lb8oE+1RQW4MxMjCjnzLZ859m/bZk5KCwX?=
 =?us-ascii?Q?QDrVUkAK2RwtCIe8q+QtFj3/xDpD2hht/auu0D503vwIZ7TWQoUcKL5FJq32?=
 =?us-ascii?Q?wVSQ+owB30FTzQPMeHr20eS9fLv0V5qrkp/bn1nNhVwc1wKR1QYMee5RoWNL?=
 =?us-ascii?Q?X6Ow/PWZ2yIMVCZeE3HQTwiLAev+NXcK9BYTAOYNsoq15Pgfwsl1osems7xg?=
 =?us-ascii?Q?DPAHapsXC2MGz2AK8qMVuqySbU79BSafEFUYl37qJm5gpCp0TySaIY3fW8PP?=
 =?us-ascii?Q?9VtTmGNDzKP9Gu8Xghf8wYJTwwcPSzublV0d9L6vhAQZjY3yziH5aWENeBwp?=
 =?us-ascii?Q?qlWh1pde80FbyKv0hBvZrtRlYe4jEILbzoN7AcrbzB4dos4R+IttEoCqSFlr?=
 =?us-ascii?Q?IR2f3lB/fq/ao9iul6rU/fmZg2+ljY6/zHQmoLZEnmMKmWcsqYZN0mnrjYS8?=
 =?us-ascii?Q?vD+fwX+vThuhSLzNjZdUfFHI/RRBpLGjLmVNQTuEvqGTP7G6v6H9jcRKtscz?=
 =?us-ascii?Q?4Wt3w4MvKw9acKmBGxFQkHn9YokEbou9dB5+lulxG0+ugcbXjYOjwCfI6E7v?=
 =?us-ascii?Q?pDmcMh/77iVblM0Mjw75qBmDshDUWNBXNRjqHpXaJBZzXIgmXHqoUcyiSC97?=
 =?us-ascii?Q?WMKS3kZ6gxzOfalvjPTEUmjWHQ2j0F9WhF2LUGc42nCad3dWzUYRdNvwPx1g?=
 =?us-ascii?Q?VoDP3KFWp/ZpmJ+mXQYzhS1ENED+0Z58p6e00OVB5TRneKAbp+9oToqTIklc?=
 =?us-ascii?Q?G8aJTYnB/calmWFRYjkRCsxSoTOG+LS16W9Um8DHCYeIcV9DEcSGyG0rp1LE?=
 =?us-ascii?Q?dCm00mZdQqLswhzjc9QT1gIgOWkFyTWbhsRSqGbvPZ4lAhrWiGbtf3NcxfHx?=
 =?us-ascii?Q?97zd013qH5IZGkzjhVXujJPNJ+o2dAx6Iq8t/mgzzoN/LsSiXZu7OKNuAnvS?=
 =?us-ascii?Q?KwO7v1cBX75aYIF8MzHwH1f/6QpgbuDhT2YREtZgbyC+nLkPrwdxBtii3odc?=
 =?us-ascii?Q?kN5ydcMw6xd1D7HhqX/nqPjXtfdAcY5tMSgc4nC0t0qTtqRE6VaQ9HUa14+K?=
 =?us-ascii?Q?cSPyfGuKvYfQCROa/jD5j7QM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89295ad3-7ef9-4117-9757-08d92a7930d7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 12:30:24.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZytVq7YqnQBRc6H3Q02s1LA0WdGNbWwOVaoZsADO80Hnvl7V/ngsTx+qpDGq5IT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 08:47:19AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 07, 2021 at 09:55:45PM -0300, Jason Gunthorpe wrote:
> > Currently really_probe() returns 1 on success and 0 if the probe() call
> > fails. This return code arrangement is designed to be useful for
> > __device_attach_driver() which is walking the device list and trying every
> > driver. 0 means to keep trying.
> > 
> > However, it is not useful for the other places that call through to
> > really_probe() that do actually want to see the probe() return code.
> > 
> > For instance bind_store() would be better to return the actual error code
> > from the driver's probe method, not discarding it and returning -ENODEV.
> 
> Why does that matter?  Why does it need to know this?

Proper return code to userspace are important. Knowing why the driver
probe() fails is certainly helpful for debugging. Is there are reason
to hide them? I think this is an improvement for sysfs bind.

Why this series needs it is because mdev has fixed sys uAPI at this point
that requires carring the return code from device driver probe() to
a mdev sysfs function.

> > -static int really_probe(struct device *dev, struct device_driver *drv)
> > +enum {
> > +	/* Set on output if the -ERR has come from a probe() function */
> > +	PROBEF_DRV_FAILED = 1 << 0,
> > +};
> > +
> > +static int really_probe(struct device *dev, struct device_driver *drv,
> > +			unsigned int *flags)
> 
> Ugh, no, please no functions with random "flags" in them, that way lies
> madness and unmaintainable code for decades to come.

The alternative to this something like this:

static int really_probe(struct device *dev, struct device_driver *drv,
			int *probe_err)

And since we still need the 'do not probe defer' in next patches then
it would have to be this:

static int really_probe(struct device *dev, struct device_driver *drv,
			int *probe_err, bool allow_probe_defer)

And the two new arguments flowed up through several function call
sites.

Do you prefer one of these more?

For your other question PROBEF_ means 'probe flag'.

Jason
