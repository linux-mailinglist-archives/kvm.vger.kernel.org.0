Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C1D38DE03
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhEWXXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:23:51 -0400
Received: from mail-bn8nam08on2063.outbound.protection.outlook.com ([40.107.100.63]:14112
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231989AbhEWXXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:23:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTouFkCRjVx0mY/8NLEc76Vnrz5pAgLpWEgpDHye+CijUO5ZhhuqoUumKeFTSFGykAU5KfXvm7O0VYhd6D43lLx0e6qcgIaU5/6D58Q8qOLiCW+/khQV3HsHWF0LA62cUTAGJOanibAw+Zxs8I/TLf7CiBscfbhze4SwTOW0rPSKeTIwtxoYMQbFmalKtruDjdcA+SL6/nF/36i3taP09NPSB38OuUAH64tA5ByOLPzfIJ3NQS/lvLqRR1RMD5WY7K56B0sU61UFEQjEBerQOFH3cXUpfhAh4LB3x3IqsrlDSgLwHSsGoJW9E3sEHB+k+lkqiQfTLZLLTcxGE8j7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mDhnvb7HBXl/YiZUWg9OTfYYRoTTkKN4dVQiT+DBDk=;
 b=gTHdjyyo22r6a/FxS2lQEURL5hSTL4QXTJRMJwSrxq/cZ9l8lDsO4oonRuwG3jZZcFbBVyhMNFich+kSf5i1UH8ggMXVRo1E89IFB+39iArbXl8EWeS/JkpRgZEMsCKJNM/4jv77il+kRmm3te56r3FjePyYFAEecxlbAtnrGjeATcBiwhphoTz8gvQb8TD7EdE1f8D/nnc6+OX5Ko56dBL4aXxv+rrDLFqYssUZxTv5Q6kpejrKMkZ52lqpoty4bnrZrXqdIjCdkROy8rc8Y+p5mzC+S+PWnqvuyM9dnCdrIkXz0wcGtaWSdLUVDCe/FBoCkdjTEYZSP3DjDrxqBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mDhnvb7HBXl/YiZUWg9OTfYYRoTTkKN4dVQiT+DBDk=;
 b=Py6FzSXJf+BcRnXN6t3QUD//Tkt9yaPwiq7JBxdTmGCew1T1AoFkkcYKCJNUOHAM4QYg/yCzFeoUN/dw+YzysSc5Cs2/b+Fz1flvf3+dVAj6ctDpd7GwCYoUg57YU5Yes+/qziNBt4vIh52Yn0EYNzuqbqNV9Cy+1PbynmGnN5ZPYxA8Xegq2jQvYqDr5cxO8NL280NcCrh36upomwmqzy1waF0lY6HEDqrfOF1Cb6p95BWkHdXtWcFY1IoaCXwRse8kgw3z8QxzaDf2iuLTCUlYPourtczNcStamjq9ixGUBf93kRiwvHfBYYBvpjy03QbW+LqSIZEI3A0JXtfx1w==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 23:22:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:22:22 +0000
Date:   Sun, 23 May 2021 20:22:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20210523232219.GG1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTXPR0101CA0056.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0056.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sun, 23 May 2021 23:22:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxQJ-00DUbB-F1; Sun, 23 May 2021 20:22:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a753dec9-ca61-4ce7-45f7-08d91e419dc6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50614DAB5405B4056479C7A1C2279@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNweUgcW3iyYqGH9TczLib3ziLiOB51KWXagdgSTo25iC1csx1lCdsHawBdCDMJ9lETwWwZiqzw+Ly0lsWyW9SXVRcvrAn3CX7pf0FrPqnzKv6myCe4ZpiY/VNjjgRs0GKOiTJlTbj7OhmfmvezIoF8JzZoJMMK1V//Achz4eKX0SAjq1vGZJ2fnv5rRTKSOpDaQxmSAk02lhvon2t1MwvICIFtu8KWC8/kwdlk0VxbW4f6dNcW0UP+Q4qiaFRsHC3HNKPBWhOd8K83kRAd969y4PQfy0B6hwX0+YQZVpRQK/oMSuco8VD+Ksvu9TZ3azwPRnUxgvztKh05pgf9EApL/kkkbT4H0TMkAJedrxquBTPof5/55CT4D2E74RqKubYSTGOy6CdfWAMpJuANuaFd9y0w7P9MjykTB7Qa++aOMJKLhTX5lF5fO+/jodfWGKyCvPYC7pN89cpvLCnYyq42jilZrigVrW+z+3CWIZplZXNnKLfoCdS4ci54Ls3K2FdRMjv4Vbz2YfWCS7dDlHMDs3ufAKyaab8y7s4J8878SVjzLOoYNlZ8g0eHhLaxL0AfehUIWUnRgNXORRfh6yDpIyS0Vu5MtEtneFULu5LwAaXpDpWjAPrwa8/0pDyKzRjLZ8x+nXUJyzgD4QgHteAbLIyzOgOPPiVd5ypvm0BPSIcNi8nDXRpziYERb+8MjQtcO+PCW+28KmhSAOuoDg+jjqG2ce/vOBD4C3t7mgto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(33656002)(86362001)(2616005)(54906003)(38100700002)(426003)(8936002)(2906002)(186003)(4326008)(9746002)(9786002)(316002)(6916009)(66946007)(478600001)(966005)(66556008)(66476007)(8676002)(26005)(7416002)(5660300002)(83380400001)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?czNjWVlmdkZYQU9udDB6ZVpNemxOZCs1Q1dlNGh2TmhVcnl2VFRmbjd5ZWdK?=
 =?utf-8?B?OEhmYXYwSUdwU2x6V0phc0ZHNStoSWxxRmRtTk1NdENsNlhzK3QvVHh3WjBt?=
 =?utf-8?B?NEdjdC9ZTEVBZGg2TURycSt1YjJzNitBSGRqakhtdWNhL2R5empzWDZSd1BV?=
 =?utf-8?B?WFVMWDl1L2djSnp6MnFLYmU3aERuK1ZaM3VYemVjRFBzWGRnQWxIVC9lOHlZ?=
 =?utf-8?B?R3JpWUFMbFlnL2k5K1dybnZYZUY4TzdCMkl3MEZmZ0ZlWldaai9RZmhlTWdk?=
 =?utf-8?B?bG9lSG9HclBON1h0ZWFpVHlKVzhwOVU1TGJ5WG9BeHVuN3QxMThaTmdUczl0?=
 =?utf-8?B?aHJUN09QcW5MMUVmbnAvSFZBbkhCT1BuQm5tN2hLdWkyVHE0MUdDanNtckYz?=
 =?utf-8?B?WFQzQ210c0hmZ05PMGFSTXNpVDBOdktGdnh2SmhJRTVyKy8wU3ZHUzZxVE5N?=
 =?utf-8?B?dFcvcm52a0REZ2pwaVRGRjJMQUJ2QjRSWmpJR1YxV2lXKzJMUjRBNkxXRDlY?=
 =?utf-8?B?TG4vdjFubWFrRjV5T0Q4RkJrV2h5Tm9uOFRGTWR6YnJoZm4zbkdqQ3lpTXN3?=
 =?utf-8?B?QkVLQ1h4WHBUQ2ZmcGJVTGNmSHBnSVRTZ0FYbk5wOVpHQnp5bHpXNHErc1Vr?=
 =?utf-8?B?dzdVYW1EcXVKTHIwNkJGWmxqVlhHbmppeFZFOW42bXJLMmhGN0NBcDBnZEs1?=
 =?utf-8?B?eWtGcDU3Qlk5aTh5SGRjKzUrRmQrU0dTMFVwZ1RhaTBEUklpU1Jub2NRZkg5?=
 =?utf-8?B?UU5PR0FUWU14YVpaWHEwTlVHRmtVRzZhQXNVVGJxTWFOeE9zMFlGMU5XMUo0?=
 =?utf-8?B?bi9ZVENLMDRDeXJYWGpXdDhNYTA1MGVuQXp0elpWMEliMHo1OCtHUXJCNmk1?=
 =?utf-8?B?ZFdNVmg1cktwNE9ML3NuNnVVYW9mZWprL3J3T094enJXRXFuZFlKcTd2ZGcx?=
 =?utf-8?B?bnYrSUxycTBMWElLYk41M3ZsbXZQTWgxVHlGL05nV1Bid1ZjaGlQTUt2OWZU?=
 =?utf-8?B?Y1RNSk9RL0M2cnVNUlB1alFUSTNNd1ZxNVQxKzNYWVloN1k4QVFlak44a09o?=
 =?utf-8?B?Y0h1S2NGejd5d01qSHIvUlJyTzBZa0RDY2NnUEQrOHV6R3Q5akJqaCtNbmlL?=
 =?utf-8?B?eitXai9hMHQ4NldUVjZWN0RQL3p1NzJBZnZjZUZaOHZxMUo4N01ZQ0I1ZUty?=
 =?utf-8?B?THUwM1YxeGhyRFhPekpHaXNUM3ozWnh2WVU4eW00T09oTlhvcEhhVVZvcmFN?=
 =?utf-8?B?RmsxdUhyWnFOQm0wTXlQZjVicHBlNHRGdGdIMDRXMWEyN1VhNDl2TDBxRFpp?=
 =?utf-8?B?VGZ2Sk5adG9BaGxDbDVrY2UxOEcvVEQ2SW1KbUxva1RsM0xMdEdTc1NaRUtL?=
 =?utf-8?B?RFd2MVcvQ3ZDbXZKaVIzbTN0MnNkWmRqWGc5MklvcHRSQXN4REpRVUE3UnV2?=
 =?utf-8?B?dy9nMWNiRkNXdkxjS0VzQXlRcnRuLy9lM1hYelFqQmtJQnBRYmtkNG5wL1oz?=
 =?utf-8?B?OEhzbUNPYUNkZ2tERWFDOCtXL3IvT1hLWjR1dzl2NTYwYTQ4TXZVVVNVZGp5?=
 =?utf-8?B?a09QVFdudzFCbUVtcGhOUENHRzJzc3c0eW81UHJlRUhrWFMxWndMdHA4TTdF?=
 =?utf-8?B?T3FIcVpEVVR2dHhDR3FJajBqdktIektpejczREFPY3JMNWNhVzBpNEFnWEhr?=
 =?utf-8?B?UTNET2hZUGVTTXpLdFFRVlhwbXBpeVR3SHBqK0VuNFNRdGVrWS9XWEJodXcy?=
 =?utf-8?Q?2zidurG7TZpr2gtyAkxteh6Z7Z/s70n1ZbIUX19?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a753dec9-ca61-4ce7-45f7-08d91e419dc6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:22:21.9943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MEAxutEcUmbvzhTxJCbyWtLvEJKm4WvzIePTBffJHpfONdln+FaSSY4pgP3e5rf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:19:05PM -0700, Dave Jiang wrote:

> The code has dependency on DEV_MSI/IMS enabling code:
> https://lore.kernel.org/lkml/1614370277-23235-1-git-send-email-megha.dey@intel.com/
> 
> The code has dependency on idxd driver sub-driver cleanup series:
> https://lore.kernel.org/dmaengine/162163546245.260470.18336189072934823712.stgit@djiang5-desk3.ch.intel.com/T/#t
> 
> The code has dependency on Jason's VFIO refactoring:
> https://lore.kernel.org/kvm/0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com/

That is quite an inter-tangled list, do you have a submission plan??

> Introducing mdev types “1dwq-v1” type. This mdev type allows
> allocation of a single dedicated wq from available dedicated wqs. After
> a workqueue (wq) is enabled, the user will generate an uuid. On mdev
> creation, the mdev driver code will find a dwq depending on the mdev
> type. When the create operation is successful, the user generated uuid
> can be passed to qemu. When the guest boots up, it should discover a
> DSA device when doing PCI discovery.
> 
> For example of “1dwq-v1” type:
> 1. Enable wq with “mdev” wq type
> 2. A user generated uuid.
> 3. The uuid is written to the mdev class sysfs path:
> echo $UUID > /sys/class/mdev_bus/0000\:00\:0a.0/mdev_supported_types/idxd-1dwq-v1/create
> 4. Pass the following parameter to qemu:
> "-device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:0a.0/$UUID"

So the idxd core driver knows to create a "vfio" wq with its own much
machinery but you still want to involve the horrible mdev guid stuff?

Why??

Jason
