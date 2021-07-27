Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B773D842F
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 01:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhG0XmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 19:42:24 -0400
Received: from mail-dm6nam08on2068.outbound.protection.outlook.com ([40.107.102.68]:44384
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232766AbhG0XmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 19:42:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kw+8F3PZYqSD386x+GFMH1r84OL47iS3ADD88YddXqbTiK8YZt1lPfhUCGz7SLk9ni3pJr17bZ4G+L/umRAAUHxczbvKxHYEsy5Jj33S3niP+kohm5XN1TAOXPJAVigST0SleAy63CMQz+ttU92Zpz5xBm0xzbOx4MLnLbH7VbyoEzfDKvljOkp8cNxERg8+RaXLqboj6SJSa6TxmAWLs9eieEDLg1sCllh37TSbHqg1pNXQwTjPC4EkG7qCB850y4FkRPi++6Kx3XDEMqxrWKg+Zwvz0p4WXH+aQV+JMn8SgYaVXCx/mgAp8JqBjOOGU5o0HZcx/ONF9+RcMPHxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PukaoL8Diq9TUA2HdQlW5pKIfFZzuScPHdROAC48xFA=;
 b=QMYVrOHXd+Fna8JjYiO1AeCtdA3wT3gNyX8SQxX/TlKr01oWIULbJO1RuhANicZMXD8u5uTBKK4nKbpO1FltzZ+924wmLyjqbSgIXq5A/ZnpcVLlRLAtClYO3BG88v1Ow/GqTQMuI213pyiBuDdZkB6YfX/4U2ENT86Ndde9eR4XSnkO3qPM8aH8+OAWFKWBYwjsA9knGx37wupR0uXTcuB9AEMVoGqV3Ojpvlu4G9lrr/XqQQwnh8FCGsRYcBKDhX6RMgVEQMQxXQxGkpSZfyWDZ4DzaOpvBx7FpcL/+XLGXIGE9evrr591uFOlTdNHFQuzcjeHul0LLvjuzawlJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PukaoL8Diq9TUA2HdQlW5pKIfFZzuScPHdROAC48xFA=;
 b=UziSXuav80fd+JvPoPkB4RXLXZCR+SrYFny7hlkpzEQq4tP/+RUunCZXG44YeRHnGdJYph7wL1a467QlVXC+tNp6VB/O+gML6VTQH1hqSQBef3CJZADhOKm3vHS149YQasLs+7VN2aoLgeHKKRfMD2+easLnfEQ4RZIlbi33wkPV6J+RfuXYJq5EzXt6bDba6mQ8rA0GvnpJu62SJ+Ruw1fITEDfqYk93RNfTcudxzA71Sz+M6b3z5UVIud7CaWS6T+iwooGOVYu0nujSc/7/SL9YTCffTtnwvpVlTQoi3YhEdUJFT9cAfGQc5XN08TbkBJtseVyLDR9IXv1NyJ26g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 23:42:21 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 23:42:21 +0000
Date:   Tue, 27 Jul 2021 20:42:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210727234219.GM1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-10-yishaih@nvidia.com>
 <20210727103418.2d059863.alex.williamson@redhat.com>
 <20210727171458.GE1721383@nvidia.com>
 <20210727170202.45c72da0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727170202.45c72da0.alex.williamson@redhat.com>
X-ClientProxiedBy: YT1PR01CA0103.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0103.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 27 Jul 2021 23:42:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8WiJ-009Fbo-UF; Tue, 27 Jul 2021 20:42:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c0ae718-eb25-41cb-12a8-08d951582d9c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB520826C8C5C2033A412C3E86C2E99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xe9FI3f3T29FZXvzC61bgJEzBwvCWsgXPRF99JTa97w6+TpTt/3NAzD5IjNZPDu0nrSjU8XCdGreGBDxM0DTOfUVZCXoN9R4q8JNWaSuXfKrlJiqpCITQwi+0IhupyB9qalAuxVqNIMfJxnNPFpAjgerXAtAS1hVZB0xBU/R4UL5dKm3g/ePW6Et9VYehb2azrg0JbqzxLDRJqbFNSgBKHtOiQNsWk1DpeXh61KyACIGH/L89h7NV4L/d2dDUS+xZvpeSmfUOrkowyVwG6Ae6gEtnxYMCHy7xGGRLK7ITkBMvs2+o/Ekxy/aS2h7OEf6V9I1wRMN5p0WbM5hjisfFlcc09yezgm3neyDFs2l1NKf9iJl8F/fByT4XeG81Rr0/KGIdMD/t4K/iI3mpNhRydFw50wT3csOthqGpsOCKvwnPizDt5F6sMWEGvJaxkAk0dH9C+hUg/+Ribqtp9qjyp+RXGONoM1pbgPyjuryFtTpUPssfzJaQs9EugUNIXR9NcsOQx4sv8WTEAdIpu9mshy35yyHUBDEAuZKGSlycwII44Obz2vfVFlYS4wHZFlrXbD8RDWN02QOBBuRGOsObMQpZOKW0NOuz3xSTFVVFTRxuk6pELKYgc6EKSHINbKQoPZMBCmt0FULeZFOWbcfHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(426003)(86362001)(5660300002)(186003)(107886003)(38100700002)(316002)(4326008)(1076003)(6916009)(66476007)(8676002)(66556008)(26005)(36756003)(45080400002)(83380400001)(8936002)(66946007)(9786002)(9746002)(7416002)(2906002)(478600001)(2616005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qWHYL/t36yntAst+9qBY7QpngA2o7oQ5gdtZYcxWCpoFjSZhF2TD9h2q4Wa5?=
 =?us-ascii?Q?QQFmpAn7MzvCn3/E3x904SW+TQhb303v0TcSxmQ9XmRdApLjmMqzGADySlpN?=
 =?us-ascii?Q?7TrNHb3I/mqiowGfmeKAbx9ImDN3hL04KxTGjjyx9f/xNIEuJUuZEiHAEhC7?=
 =?us-ascii?Q?eyQ09f04u1D3Pt+corE6R9T3b48XqeloYXHGJWxpHrRzzpy+tbc4QLaOhqhY?=
 =?us-ascii?Q?1uDITnvO86PUylRq9yBVRIhrDJ00f1ts9LGIQdI/9FKIt5/RA+E+IT66NjpI?=
 =?us-ascii?Q?t7GeLGZPUHFSIb58XJgS+thZICAgpe34uox+BT7apFPxskrMqbwQ6BWM4ZVm?=
 =?us-ascii?Q?vM0TQhJrJsOCZz7c2jhudeMZuicR39Jin90xPGyd1Pk3eVAUDeC/HQofSwNi?=
 =?us-ascii?Q?YTLMfGRrtMBL0x3TDX5GDpDjTwGe6AN9nuoGIy3MuseKpklKKMavRuDdUXrd?=
 =?us-ascii?Q?DYYgWCqef2001kJJlxariDA96xeQjQXp2hU3bI+Y4A9T8wynt/NEiZRHdaYm?=
 =?us-ascii?Q?4+Wm4vbVWfYTbsobEwD/622lBt0ROepnymIaONNIMnw1dyQ0BaNcUdWeNpm5?=
 =?us-ascii?Q?zD3jIRyGwt0q9Fzy30VoHngRYoIXtcFRuvfyBBVzW6OTdLMeefXL8hGWgkrD?=
 =?us-ascii?Q?VMSnMvN01naoDW1viBtp21/DvvN//pXlA3S7zFymXWcRnUcmBxxKkA1Id+NK?=
 =?us-ascii?Q?o7eRYQ5JsPqNvtvTupV+kyMnswBxnKDxXtrfID2xsCCc7KXhNzF+QE5oR9OX?=
 =?us-ascii?Q?u3buV0XWGYvUPAseNcy269ltW97LlXq/FNfKXFH+rkf+DVmQtTUpm8aJoqz8?=
 =?us-ascii?Q?DII/V3m/wceu6G3r/ucJlQ5y1o4oKGJgq2LDF3e/XldgklPSXamhy7TVgY/I?=
 =?us-ascii?Q?TjNju8u9P90zk2O+f5vxuXy9Sp7SPvbif+tznyApZZb851DOD2A799OFuMxc?=
 =?us-ascii?Q?oSQZjj0WwpkPiXvTfhVgHcFj9D4yxJVsjlxBBruUmj1zKdFGgy0Z339C4SlO?=
 =?us-ascii?Q?sGZL8Hmgod6yKXJE8NvljrbWCAdBdORd9jvI7Gg2CroP2+aqX4VTH5Ps5N22?=
 =?us-ascii?Q?BFUbqZqNy2XfN/J9FaE9Jw5H05EiiH/2kxWpGp48X1KQ6H3YKVUCmqzxe9hM?=
 =?us-ascii?Q?wq3o+dyHL8YtyC1LJpw0+HkHuGranMJpavo58oASu7Q8WOMRZxxcq05BRh+I?=
 =?us-ascii?Q?8Rx3iAViGQN40zgHZNZfbWgQhqGeEsFXOPepwFliZlQpuUCVfYBwiIZdrrT+?=
 =?us-ascii?Q?yLCCrkP0zOJRsazw5rfdliavu/ALnrxhjIm3HSKs52BrfW7qaQt/hcjOt29t?=
 =?us-ascii?Q?1fxDgsB3WhzdjHPdYq/OasaH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0ae718-eb25-41cb-12a8-08d951582d9c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 23:42:21.5851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ra4NIEQkUi1C5cmoac1xrPGWGJvDJTMuyl3UE41Zl+j1pXWRrKFoTQ3npIPIvaL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 05:02:02PM -0600, Alex Williamson wrote:

> In general I think my confusion is lack of documentation and examples.
> There's good information here and in the cover letter, but reviewing
> the patch itself I'm not sure if vfio_pci: is meant to indicate the
> vfio_pci driver or the vfio_pci device api or as I've finally decided,
> just prepending "vfio_" to the modalias for a device to indicate the
> class of stuff, ie. no automatic binding but discoverable by userspace
> as a "vfio" driver suitable for this device.

Yes, the "vfio_" prefix is ment to be a generic prefix that any bus
type could use to signify the modalias entry is for the vfio flavour
of driver_override devices.

The userspace algorihtm is pretty simple.

1) Identify the sysfs path to the device:
  /sys/bus/pci/devices/0000:01:00.0/modalias

2) Get the modalias string from the kernel:
 $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
pci:v000015B3d00001017sv000015B3sd00000001bc02sc00i00

3) Prefix it with vfio_:
vfio_pci:v000015B3d00001017sv000015B3sd00000001bc02sc00i00

4) Search modules.alias for the above string, select the entry that
   has the fewest *'s. See Max's sample script.

5) modprobe the matched module name

6) cat the matched modules.alias module name to
   /sys/bus/pci/devices/0000\:01\:00.0/driver_override

Further patches can make this work universally for all the current and
future vfio bus types, eg platform, fsl, etc.

Something like driverctl or libvirt can implement this algorithm and
remove all the hardwired behavior of load vfio_fsl for this or
vfio_pci for that.

I'll add the above sequence to the commit message of this patch, since
I think it makes it really clear.

> I think we need libvirt folks onboard and maybe a clearer idea what
> userspace helpers might be available.  For example would driverctl have
> an option to choose a vfio class driver for a device?

Max wrote a demo script that shows how this can work, it is linked in
the cover letter.

At the end of the day there are only two ideas that survived scrutiny:

1) This patch which makes everything dynamic and driven by
   modules.alias,

2) We continue to hardwire the driver and module names into
   libvirt/etc and just add mlx, hns, etc.

> I can also imagine that if the flag only covered the
> matching/driver_override aspect and pci_device_id further included an
> optional modalias prefix, we could do this without littering pci-core
> with vfio eccentricities.  I'll be interest to see Bjorn's thoughts on
> this.  Thanks,

This is more elegant, but we didn't do this because the pci match
struct is widely used in the kernel and bloating it further doesn't
seem to make a lot of sense at this point. Due to the macros it would
be easy to change to this scheme if was appropriate.

Jason
