Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2B03D8D69
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhG1MDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:03:35 -0400
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:14625
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234647AbhG1MDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:03:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4kXpmbJv/u4M+KMFMvvDH1VAG5MklMY8NeSS7lLYrlmGz4Nb3h1mauiuSrPmcYGrHnBClMU0QQRgNWBzIQy+/9grrWPu+l1wPfdemZ4MYPDx275uySLz27IREhtROdiMBvyV8yZWJau5hcQJt0qG0Q+bxUnwLq/kF3t0JAnEWAqpecvRDb1+1pK5ngjx/X18xEWvjXEhLEC632AtqOcSDRuxv031Js8/dqg57UMEdayBwbLBYBqvxDJL6OJBzqwv/ySCTQXUf8NVjsSjI1P7Z2YDSCjWar01PYCB5jWzLq7x2AuszJevLb1bP3mn2qQJVKQAqsYIFXxLrUX4D92BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd3x/0m2J/y2lkbIJAtvK2MxbvJGblRr6LuJ0BlJ0+s=;
 b=cLkx1mM5P0sV1ryva1uf5+W96fPgMz7OFqXoXpEYwXjuBccCh27rZR8XnDm4iVaW4OpjTicOZ0czMUTQD5N6twjmv5RvM3OYGnZ8dWMD/J3fQi+9bid2qANRvqEKKjC2OjOrwZcAetHa2ybzPcMXGNuQYAgaoaNiDr15GyvU65c/W4IPIhXUJYmItSZ0SDtfhnJQnvWzrVbbOrpBE/Qu5LTuZbDWO+h59wZaDRqhe5Ooz3HtJa5sh9c/X01RtNH+MSARhdqmtkBaSsvDs0FLIhG0aIoo5Vqn49XsgpVE3flotamN240hqE4xNNsA30wZCRRBp2SOI4j7c0DEmTPssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd3x/0m2J/y2lkbIJAtvK2MxbvJGblRr6LuJ0BlJ0+s=;
 b=Mk8yCrKRnI1TV0IWxEn8YkM4RqlC3e5S1t1flNHf73lXxnLExnLm092TPNuWjR46YnstW9Qw2aTM0Lcf69ARD6uA3symailchfbZWp45Tj2qHwtUzZTJ935Bq2v9eotwjz8OLKlbpyAvkdQSQr/j37FNGMXcFo5L6LMuUHdyzBB1AJbDjdsj7a9n+vd/iEND6h1e7lfEMRgtKhgfCraD9+ExHN3cY2WEpTb34SxGbBc6Bjp0bl+R4FH0zaoH69ECoc052Kan7BiwgicSrmZ6biNCG7Mbsz7IRDNSj2s0B+R6mig9RRiVWsY1p8FycMK4GifTHaO5r/HFebxzhvviVg==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Wed, 28 Jul
 2021 12:03:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 12:03:28 +0000
Date:   Wed, 28 Jul 2021 09:03:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <20210728120326.GQ1721383@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
 <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728054306.GA3421@lst.de>
X-ClientProxiedBy: YTXPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0043.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Wed, 28 Jul 2021 12:03:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m8iHW-009cRN-IT; Wed, 28 Jul 2021 09:03:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ba85cc3-bf0e-4334-ee57-08d951bfb5d4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5144:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5144180030BC041A3408428AC2EA9@BL1PR12MB5144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yC8nCAjT5Ld2oWD/as7fcDTNdPlhoPkYr2qegyjvXngqcQK3BiYt1Ftf/kx31c0tmmHpPJw8EIzXVuHwxf6k5+q/zXBN3uxRkn6KRnsEyOC5p0d0gZbXAJzX9EYT9U4bwlkqAkbV2iUecaAHwqI450Ht9FcK3f0o5TY/4VNAPDx3ewUVP5QcHb5gL3MWZLD227DSglyU3Ir2r9OVDVgK0K3cxHKMtnlUz5/8/Jq6N0mKVduCgNDXxarOJtu1pgIhxaWRIJ0KU7q56WuUPwHM8HJMP6pDTAWbOGo7i/jErAspxcvV2Ct0tbw77g2aSvQMUjmtZV4xU0xB0UODMkGYgwktbdCijH+FtOcVaDXrEWgeW8bL+ha9HUDjob0DPMnd/ENijrPUUM+ZdERXfioIrLStNp+3AThmbUeWUlDX81F4Aw5pN2Nn4i9sq8yJohL+e7s3ysjZ1B465cEq8fW5lBBxXBxeJqcZlvKcLkAYMao+iGF6F/p1EsTWlUykJWTKyHJy/cy7tUxs36rGytF4ZN/2NSGmBHxkekxO4yPwe6re7JR8/ZXBotss6Q3yAQkZQwieWSJnJrrNSyJXisxYmJX6W5aj9Dp/JzwXj/Av+UV9zcWWN42VHHzpSY7KwOLvK6/eGFeI6R2e4/kid5hJkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(426003)(478600001)(107886003)(2616005)(38100700002)(26005)(186003)(9786002)(9746002)(1076003)(8676002)(33656002)(5660300002)(7416002)(83380400001)(8936002)(54906003)(4326008)(66946007)(316002)(66556008)(66476007)(6916009)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ga67/cock+jQN3F1uJHFAYwcfa97L6tG8zzjgBvrhJj0pNKmvIHsscjZF9/e?=
 =?us-ascii?Q?D4frEgya5fG55UeYCT/uVkdGjFAf0mOZjYUgfcnRXsthWFBu9EELgi2O/dHm?=
 =?us-ascii?Q?b7etCo66HBIV+bzRidbjEAQIn43/8fsIX0bI53mQlo/95HdlFzEFLH/aczWz?=
 =?us-ascii?Q?+ieh1QCstS++vCcOZ+w1EY0wpH1H3zH+5okKfcTKqkCqR5AkKMlrkdQSubg5?=
 =?us-ascii?Q?NW43irf8MgtEzbmXbI/4wc7PwaSNwqwhVDxUt6nFJtClzfgnpQ4S6576lrw0?=
 =?us-ascii?Q?EQSaAyD2A0aGgFhGp/Vtem+9BRcmdUpQnX7IpmeujP+MPKfirCycdeQxAIvv?=
 =?us-ascii?Q?eARINmggfBQIBrWXfbqDrUxJrsdmgbM7qyUn76seJ4o3xIBI0v2yF8m7oe2x?=
 =?us-ascii?Q?SYENyGVMLLwZ5unENLzdDUbGyP7+ctVbeMqLtklbpOaE9peehv1uNJjbiTTK?=
 =?us-ascii?Q?IRl2gg7ANSi0wCt/ZZMONfrEkXJT8HMEHaBAXK7FhmpTjQru/cRQmB1Fy1tM?=
 =?us-ascii?Q?ntLMAlEokppe7ksrdUSStIIJXK0xm7glCmRs/pxC10FHMSLSAq8uBHEkv0Mu?=
 =?us-ascii?Q?jP012qEwPy1tPq3PCelBwxW4EhE4lgtzrRJlo2nkObSjyBzy+vRv2bjkpzBe?=
 =?us-ascii?Q?gxCL5xHNga7qk7g+9XOVQ3qCP5ei0k6f6VenjzZq4aFkGOvrNbEZWhEC0dii?=
 =?us-ascii?Q?WwVmaVpEfs60sRspxiNAjhFyNoThHIpnxQ8aQ+8ja5xZSwcncFNqWrY5t3JN?=
 =?us-ascii?Q?iunn4gtDn1EPRmnUj8KGfyjW9/nFLS64yvqngiqKz4jp8VI4UHbzU3dlf/9u?=
 =?us-ascii?Q?EoSD2c7ieSQbX0eHboErzwXQd8WrKIQ58+KzSdylJBjOD1m4q4Jzs+mcRMYN?=
 =?us-ascii?Q?fgUOgFjl+ZAMGFejtBKOuhS7jn1+erggSIjDNWKkr8YbgQhIt8m+Uyp6GnSW?=
 =?us-ascii?Q?jkfpIjouMBgzwGjrHVQ7TuSSW8/LogdWlLAbQufS8r0q72m65HDsB9v2bvBu?=
 =?us-ascii?Q?IToMGouUutNYzZ6j9hK0y7H27ii1RZNf2kBfUIZz4iUqnxVtgkCjNmSjMKen?=
 =?us-ascii?Q?ADqDfBbUzvPlfbkqKO8JkSyKMz16SC4b5we+DD4++h9xw6puY0RudZBBrG5z?=
 =?us-ascii?Q?OmD5eo5kDuN4AkWJi0dAMcBfwdhSFOCp6ouywRSvFEsffCvfEc+UViAhAkcU?=
 =?us-ascii?Q?JhWOpViML0jmIau1DSaB5qXFdy32yLTLAbDuQ+bARkEDx0ZWB0lG2Ih+g1gt?=
 =?us-ascii?Q?5UWMzjZ/I5b9BAgOmr2BkoKoUPsu6ra3y2zNjz7iTnrEGqTPQ0jleKgp8fMb?=
 =?us-ascii?Q?+sUTnIvpeWv29ttgVL3NwhFR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba85cc3-bf0e-4334-ee57-08d951bfb5d4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 12:03:28.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nnd9W0oWGHvn9ki7Nm4iPTTUdxyufG8z9bm4YFLVgqY/Slh7OUX0NNgk1KoBuMrM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 07:43:06AM +0200, Christoph Hellwig wrote:

> > Which might reasonably be from an old kernel. 'make oldconfig' prompts:
> > 
> > VFIO Non-Privileged userspace driver framework (VFIO) [Y/n/m/?] y
> >   VFIO No-IOMMU support (VFIO_NOIOMMU) [Y/n/?] y
> >   VFIO support for PCI devices (VFIO_PCI_CORE) [N/m/y/?] (NEW) 
> > 
> > Which is completely fine, IMHO.
> 
> Why do we need to have VFIO_PCI_CORE as a user visible option?
> I'd just select it.

I'm not great with kconfig, but AFAIK:

- It controls building a module so it needs to be a tristate

- tristates need to be exposed in the menu structure

- As it builds a module it also has depends on other things

- Select should not be used to target tristates

- Select should not be used to target options in the menu tree

- Select should not be used to target options that have depends

Which leaves us with this arrangement unless we delete the
vfio_pci_core.ko module - which seems like a bad direction just for
kconfig backwards compatibility.

Jason
