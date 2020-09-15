Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59BD26B8E4
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIPAvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:51:54 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:23650 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgIOLeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 07:34:19 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60a69f0001>; Tue, 15 Sep 2020 19:33:51 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 04:33:51 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Tue, 15 Sep 2020 04:33:51 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 11:33:46 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Sep 2020 11:33:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1Egy823R5QKf7lG2WDrPNP6llY9u3/BOB9cT8R91WeXk4eke/HeW1VM8fHMG+6MUHtP3m8lok8xY72uDgUsjMK9pmekaZ7QF6Iu2PYOXGU+ssw8CP8guyrNWM4rpi2ssyXnRvT25DqLrjWsSdBayvbgmUhNH2bX7Nksyi1bP1uZvZAbWEdnMRhXDHB7kEjvPYf+jgLyi2ulwIGuX/jhgc3WMkl84pnzjFlxsflPEcdbEMshgsu6l8/+c0bRlf3LZyTXVsU0LXjAg6gDv46sTXeqX4BY41k18FsLaMTLhn6qwdbX6tAQuxdhauLtxmpCBR1za1xWzIMoMEzd0GA6Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lt+prTqc5B+XBf6OgVj3Xkfjo/yTNnSF1EJzMbT7XEY=;
 b=eizNYhlkDRs9k6b5OgtKGkw11xVxVWASfnFfBpLW5SjxQeUssHOHW4rQOdyN3ul52nz6PSB+MGwWFkTty4sVLRGpGhCL09nFG98+m9jJirz8NAutatQhvXRkQoRuUmYt7TbQA4pBNl+QDwNLAozLSy5xcq9m7vWWWG60KVj/s/C5V8jmcHqSkY+nz2h5g1sztd0TJoPZExMUHDAPLWJT9rlTgfBnK0X5f9z8RIZyaXUVPCrYLKSYUExB/4TqYdNFhx6ZgGIS7S2qXV9PNRqCi5FMmteVxDWIkborYKECydlKP/05547XvwxIF8YRIZ7Q7fadK23F1MYl2XFaSgmxoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4500.namprd12.prod.outlook.com (2603:10b6:5:28f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 11:33:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 11:33:44 +0000
Date:   Tue, 15 Sep 2020 08:33:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jacob.jun.pan@linux.intel.com>,
        <jun.j.tian@intel.com>, <yi.y.sun@intel.com>, <peterx@redhat.com>,
        <hao.wu@intel.com>, <stefanha@gmail.com>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200915113341.GW904879@nvidia.com>
References: <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <20200914133113.GB1375106@myrica> <20200914134738.GX904879@nvidia.com>
 <20200914162247.GA63399@otc-nc-03> <20200914163354.GG904879@nvidia.com>
 <20200914105857.3f88a271@x1.home> <20200914174121.GI904879@nvidia.com>
 <20200914122328.0a262a7b@x1.home> <20200914190057.GM904879@nvidia.com>
 <20200914224438.GA65940@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200914224438.GA65940@otc-nc-03>
X-ClientProxiedBy: YQBPR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::40) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YQBPR01CA0140.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 11:33:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kI9DR-006QFY-Jo; Tue, 15 Sep 2020 08:33:41 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac39f148-f004-45e7-a68f-08d8596b33bc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4500:
X-Microsoft-Antispam-PRVS: <DM6PR12MB45000CBA001049B768983291C2200@DM6PR12MB4500.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h1PtBACJ8caC50Aw/9OenZ42GMrZ7pORDSrgFLbRgQSrP+p1wJR8yZhxJm/hBEm9QMfAyU43WCNDBX3xMB80LGylHQnH11sb74Axib+fYa0Cw4iQWSDSK3OCKY7wDVBUwk/o5qJy51J+9CDq7ov54RktmiK/X8TylIXWGwVGHk4yUZq6A2CxgMIRsth7At2if122mRbRLVHoqOS/jmQGi2UvgpWoX8bzyi9RQQ2IseghARH3zMMHoaMqGEB3uA+INEehwPa9H+z/Qd7BnJwmca3tzdqZRtbzdI7mWgxKkpIeOsDcYaS4OPuAzF4wmIPm16q0gqY6iwy8pZtVVZQlz5cx68oH+JhC0cSJbIMa1vNjoa0aQ6QzziR7VXef3bgbHd7ahc80qeHY1F8Xz/mYUvVvtLi61ZZvqLbVtk2tYvE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(9746002)(7416002)(316002)(426003)(66556008)(66476007)(5660300002)(66946007)(86362001)(1076003)(9786002)(36756003)(186003)(4744005)(54906003)(4326008)(2616005)(33656002)(8936002)(26005)(8676002)(6916009)(478600001)(83380400001)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LInDfIxwJ6f4sICQT5BsDXq0q3WoJmTwlV7wo13KLYtzoJBymjzhRRQWVToOm1DiPKBETn7tQPKs4ALARkBl+meIpJQH9+LIOrXgQ0FPeZcZoAjcvT8zu/ydn/lStUFr9WHzOQQMCSiiJPWc1QMwY6j67BKmaonnwB9RArRPSnLgEBlcEGVECz/EJ7L9FW/YbEwshq0mP/RniW/jJWHk1IwFKrWg2syPvsL0ESPg6hxkJkggwWi8Ufry5X6EUTf4lreNBwV26p3JgAe6b3PupJJK/AxuEAnM8SnVMy9jC5TwE7aKrcC+dDuncK5JqSAvGitr6GSx+bPKwn1CJPoSjUmRhS22ndRqUvFFGcSlLcyu/BIWsjlBpcbAJLc8pFLc98gns0Y08vjAPB4FRYzXkDZ3d8QKW4HytiBPNMdqY1vF1vFoA1msv1TYPwG5UA9tqQpQZBfJwjYqNiVp+xZBj5OmX7dprE47p6nrcLrDLfWtK+/k6LFps/SK8rowBcWBEkfnpPHdy9mSHgBfwklk6KWDQmJYH4waWgDXQOH9AGBfXie8rRVhGXP0Gb25/tpC3soGrGPKmtyG9wpRZacAk/OBxMQbmc7t2qyp1/gFBCbdgLPgBt7eAVxNMVa5YIsGTgUy5KvWVW0qHkw/1ulSOg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ac39f148-f004-45e7-a68f-08d8596b33bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 11:33:44.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mAXs/moCWbTzTMfAhY9vBYCUeBmQO6sn+nf3ricrI0ts3dNu14d6aOabVvgmIjG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4500
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600169631; bh=Lt+prTqc5B+XBf6OgVj3Xkfjo/yTNnSF1EJzMbT7XEY=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=lEMEVSfhqCIQFoXjtyQ0hsPki5kWG+DHwdAWoSQn157hpFuMRPLA7SSecIWDrbL7c
         Ow5Z2hXORxzJ+Aih1lglvUr14bfILlhC9hw6aeJxVyiy2d0UIb9zSc1xon8d18tTSq
         KO4VHE8ObRgXRK17QI83mphx+OoiHk3T299Er8ybqciO7yAFlje0MeBkAkIWN9JuxB
         xPuuBYjvZvGfvQD2/ED3CYTF00Nqju4LisqAIoJe4UW5FFmh8vExP0Ujgj+IJ1BlU5
         X3EYjU25qUVU23I8SzcawfJ3BvCdKSUVdo7ZfFeUm40bfwN0dP+o6EQfpFqBeSz76M
         ZqLdDv9alsIug==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 03:44:38PM -0700, Raj, Ashok wrote:
> Hi Jason,
> 
> I thought we discussed this at LPC, but still seems to be going in
> circles :-(.

We discused mdev at LPC, not PASID.

PASID applies widely to many device and needs to be introduced with a
wide community agreement so all scenarios will be supportable.

> As you had suggested earlier in the mail thread could Jason Wang maybe
> build out what it takes to have a full fledged /dev/sva interface for vDPA
> and figure out how the interfaces should emerge? otherwise it appears
> everyone is talking very high level and with that limited understanding of
> how things work at the moment. 

You want Jason Wang to do the work to get Intel PASID support merged?
Seems a bit of strange request.

> This has to move ahead of these email discussions, hoping somone with the
> right ideas would help move this forward.

Why not try yourself to come up with a proposal?

Jason 
