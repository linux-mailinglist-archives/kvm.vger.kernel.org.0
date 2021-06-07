Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C13039E744
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 21:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFGTNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 15:13:23 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:49760
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230282AbhFGTNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 15:13:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIhKKL7OCTvi4yvO7597cyJkYX98XXC3iawZmxZVgrpsKXJS3zOcye+SpFPDBweBDIT9b4z/GqAbSjX+bJyDsAWZK2OAlJjDcMteJChHg5BTA80qVPk/tvO5ADnTfcIb2XvB5Xh5ZiI5LzK6145PDuK/oQGATTODCegQL+tZIVfdV68ahuiyEQG8lkwYIdqhAM2kh8jhEgfunKIvxq4oL/VhBL5685AgUu7fdD+5lQJdZB+ie8ZOWcGbuG9M0mvhTrZpXW+1y96aRi8XawypPlwhKg356ySSxdX5ZBW1IdxltA6BgrxFr6XqEu2NUbugTXrllQ0FbvX8wD36sx7Png==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h8wj8mNXPYwdiL3l2AzYwr2+R24eegWP8y1fqEWRZw=;
 b=IhThRsW8rtQzthnbB62B5YpB6XfmlyLOO5izgNaZ4fQu+DOClJbouUOax89ognqg/T+LCIWaZ8dsfEjdSiV0CwSuScjmqIaALMYqxMv4ucccL3iA4PQf1N9cE9LmG96zPSwzKptHYtQVD4mr8wMTbEESBqGvWtszCW0z9N1oGCNRtUW1vs8PBUrZb2EvY7M4ii7469CHDk7YJ0XCNuJSHDELterODKaxb6AVsbECjcs09zy1cukEVYy6bmQb2oFwv4deBlI0A/7m50j4HIZifPYp/FspBRn98UAjjCEajY/QMeZz5BQpb6eciCLgcT+AwxMlSKJVPXa0clhLXF+9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h8wj8mNXPYwdiL3l2AzYwr2+R24eegWP8y1fqEWRZw=;
 b=qszZcXbgTjY45AB82p9WiI1JADdD3MpFtQyrjq7X3YYaj7kyjj3swuYyUXnvVhIwvy4j3Q3ndOH/E0U/kwEXFi+LLapn2l9M7JjhIF+fgxPMM69MWIl7xJY6G0Vzy0VxL+f4wARWxTegHoD3pA03Rpy31ceTL/AuCxcnS4ia8UlBmM708SBEO5FA5aiB32t3mW/47SRElcgCCOWsCBFS7guiUChntx9ZtWKhXIDmebrbZ+iIHPJQfbagx4VezjQc4ePoNVIca9gzXlJGXKiP6TcEjqriJzdwZII7ARqPhlsFhlqfr2nubeDaKUw7M80Y5t0Psh+oEt8EZJdQrmVddw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Mon, 7 Jun
 2021 19:11:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 19:11:28 +0000
Date:   Mon, 7 Jun 2021 16:11:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20210607191126.GP1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
 <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603214009.68fac0c4.alex.williamson@redhat.com>
 <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <168ee05a-faf4-3fce-e278-d783104fc442@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168ee05a-faf4-3fce-e278-d783104fc442@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0076.namprd03.prod.outlook.com (2603:10b6:208:329::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Mon, 7 Jun 2021 19:11:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqKek-003Q5O-8Y; Mon, 07 Jun 2021 16:11:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9537196d-fba7-4e77-e8c5-08d929e80cfb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB526909D9B2C66C9956F277A8C2389@BL1PR12MB5269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9/PGu1sVrTqfcykWw0i2Befm4sjZKyyz7TkuZsRZhOxo0wAnuFYfdxcFTJWleQFrS6T/Rle26CG6yOoXz+PI6axbBOKt+tQtOKj5sECdL5+vXcBHagQURV52RqijYRQI3qvLX5K5JOGMj4gWb4Xo+JdZhCTub+wjfrxRosM1SH0lg/1Ocv5CQbfgUTvbGVgeb5aaz7fXAQcyANU1/rF4WZp9XVGHLf6pTCT2sGNQlTao8KMYKpZxx7j9F177bQawKBKCvxlqn4ZV7VoLgfV73LKVcJ/3S9lcmufZ2/mQD41lBAsvbUu35O7R6R5oYlLN3PjzagLTLxs0ZYoRjY2ErEzo3b7dQ91/84xWhM96xFqs7Zv47rMt4MoOzrXT9YtfEt6kYg6cicfId2Anwc2fm9zBR7zU/zYXlyqef5qf+UGud5XI4NKrVSZUyBXewK7NwqneQj80kxKji+Kwy/6JhFLKgic5HbNBTU2ImcS6j2ED9AQsQSPrCmh+qlKIkaDLirSWwW9/oY8BKfUzjcRIMUmJczTEGGF7jWWk/msJ5+NwZ9NETbVslmU7IQttPR8ye3HtRpocQZZzg483h4wtdYCKMtouWZHqvSS+9JvS5wI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(54906003)(8676002)(33656002)(9786002)(1076003)(9746002)(4326008)(426003)(316002)(26005)(5660300002)(478600001)(36756003)(7416002)(38100700002)(86362001)(186003)(66946007)(8936002)(2906002)(66476007)(2616005)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hZihVjhkVQ0bitXq4J/uLLE4KJ4KVA02jPyDx00eu8ABfl0eQjp27ieT49bp?=
 =?us-ascii?Q?QjOyse/dGe8Ja7Hc1tm4iE/hGztGGw4T57cA/oRNlUmkIM43APcyt+ypFN0r?=
 =?us-ascii?Q?ustBphBbJKU0AWsYJbcPGHhHJD68jwsL89BnHSQTFHPjnwtUkKjyUUmBE9+b?=
 =?us-ascii?Q?avBtmA+j5TwYqHVjbR9qpIku1TNj9yyEcd7P4OJjCFaoAmdbHW8INgILFvG9?=
 =?us-ascii?Q?OcNMnsCrxFHD9J0tQYqHNvw5E0wKFTJBQK0CwUpsx1EB+zV7tiVj6rpne7vf?=
 =?us-ascii?Q?zKzYECgphbB8X5+4OyEDWi+2yZRDNwYQJJkyGv67F9dOGI0OEK4KrYx7venN?=
 =?us-ascii?Q?4hMU0txloCrl53lx0UoqZpdT/4Rfg9hcUO/ve8ApUhC1wFv12nvDghaHgWD3?=
 =?us-ascii?Q?ahrtD3qLKGHQYLcxS2vT/JzZnOEqgajEzO6ia69kK5jgTIbPDE6TRQTdx+Dk?=
 =?us-ascii?Q?So2qSap8G4YfCAu2KpW1XOWYxl3eZhEK3gSGYCQhQfb6RUJSo55cZ+88Q1nW?=
 =?us-ascii?Q?Bhkm4SXL6Sr1nzX5D+NmbaigVX82c7w2uFA5H/bAlnQ1Cq2cJ7s7ItvpukA2?=
 =?us-ascii?Q?WtKFMaBD5wXNls8zbcmrYzw3aM5wYkOytlarALjCl6V3xFOMK3cpJJL8oE3F?=
 =?us-ascii?Q?u3F6yvQ/KxjQR89NMVtdfg7yJseWeezBElTUfjv3B8RczKiNA+Uxs2RuMuzP?=
 =?us-ascii?Q?/eWfX0ihwF7oDIGT0kwVGAMjJrKqt9jhgKFBpmiCyAUYayJfcsefOjJVQNn8?=
 =?us-ascii?Q?AT3BShnSeZNTka3MA+r7hv4XGZcmfTnQLTzgV9+w8nZpo70TWSUa0C8QuUBT?=
 =?us-ascii?Q?+VrGqj7bcZm6JR94VKmZ9+efuP/PbQzHiUDkUlzNE9eacnjzB6ob1xUFGtvI?=
 =?us-ascii?Q?+FfKs8zu/EKNuvVwmFiUtLCnnO2O8kkHPumKQhCmvxCA2ZjwCNwgq2FCfQqz?=
 =?us-ascii?Q?Ygvprsu4j/PY74AHUNisMx2mLJKz99cMrmP3g6cFhKpGLV/qjphEuIK6bwW9?=
 =?us-ascii?Q?r23gSdXGvZZx8LccwgnyljsxZsrC5WyTyGT8jIaBb1/Fdlp18rHW2ufSHQoT?=
 =?us-ascii?Q?HkI+6Xc0xutVUsdHMDHsN4+9WLvmlZoEa7SmlPKKmpcrw5CNtIV2WdXqhuh8?=
 =?us-ascii?Q?q7l40cgBI/cZ0hHplk23byihKWAH9eiiE4NpsUGl+BIb61a8v3BGr77bxiR5?=
 =?us-ascii?Q?4xzqb7YQ+SLoU/3intWC+O5UsT071hXvlnvf7rt55//SzDGsA9CJ5i5ghihl?=
 =?us-ascii?Q?mVqG7Q+Co4djU/dDfpWTUDundLHZj8SIWngTEuePtYpcNIWJ70LcYiF0OpH+?=
 =?us-ascii?Q?UbI8OYt4DBuDCLhcY/pPL5aN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9537196d-fba7-4e77-e8c5-08d929e80cfb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 19:11:27.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SI7CCZua7KjmzJhzsazSBp/BJrKp+cBiGWkfH3YXDEuDSqDCdPF5qSRrxMuyiAD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 11:13:04AM -0700, Dave Jiang wrote:

> So in step 1, we 'tag' the wq to be dedicated to guest usage and put the
> hardware wq into enable state. For a dedicated mode wq, we can definitely
> just register directly and skip the mdev step. For a shared wq mode, we can
> have multiple mdev running on top of a single wq. So we need some way to
> create more mdevs. We can either go with the existing established creation
> path by mdev, or invent something custom for the driver as Jason suggested
> to accomodate additional virtual devices for guests. We implemented the mdev
> path originally with consideration of mdev is established and has a known
> interface already.

It sounds like you could just as easially have a 'create new vfio'
file under the idxd sysfs.. Especially since you already have a bus
and dynamic vfio specific things being created on this bus.

Have you gone over this with Dan?

> I think things become more complicated when we go from a dedicated wq to
> shared wq where the relationship of wq : mdev is 1 : 1 goes to 1 : N. Also
> needing to keep a consistent user config experience is desired, especially
> we already have such behavior since kernel 5.6 for host usages. So we really
> need try to avoid doing wq configuration differently just for "mdev" wqs. In
> the case suggested above, we basically just flipped the configuration steps.
> Mdev is first created through mdev sysfs interface. And then the device
> paramters are configured. Where for us, we configure the device parameter
> first, and then create the mdev. But in the end, it's still the hybrid mdev
> setup right?

So you don't even use mdev to configure anything? Yuk.

Jason
