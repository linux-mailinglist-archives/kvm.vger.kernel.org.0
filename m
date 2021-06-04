Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C2139B8B4
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 14:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhFDMHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 08:07:45 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:32284
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229740AbhFDMHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 08:07:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W81WHP4w/b09sEJC1JWvBBVEDMMo3y88IADU4lQ3UVakOzmlbHW+mz0Or/eH5lQ6x4X8h+eW4KZiE98y8dpd7xvOiDCzrUbDuHhqTKKPT7KWrYAElmvbZUksy/F9pA3G6D90ynebNxpoIEUCd3SX+yYM0DMCVzjaMqcNBz+6Z/MKfleTXPGTsLIUgl0VRC/Fl2Uhfg0CAnI1/jSMO/Sh+W0ErV3DUDJE6D52GBS3jjw5TF0YxZXm4uL3LG0cEu8EvXNuX2FG/CE/Q2yoDR1UgxXlh0EiUHeKW756ZXk8cIYILTFZjZUoUgWoAS9EuI5C2++nWIvUur+xf7JTHne74w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FF2MCocW9dtVtSUUrVz5IlvJHHVJVvVFCOL6oZXSvy4=;
 b=mkEtPTmbwBICsq5GJFQFMnrriRl9OGh1huyEvdDEfjPx2GYFTD8SdjnZv3WhbfOyCpkexG/gUrZJF5dA0w+Gal+Jlelhs+uOEDfbdooW+36+JrnvNc/InShnOAVmyo+PdPsJYJRaN+6rLft52ILxEJykPg1k02WGpU92bA0IdyARXACyMSGlwxSKvStcpeuN0ompl8MZ45HsEoErWZ940PZYAm1xzIEhgfvo1e2tlWfnkqV6Xng0ZtOwhU0+IuSsFDkG8VwanJxgUGpwStpcE3iRav1f3iVSJ/vDnkYlZZpnJml/80Nw8jWlLKLnb40A9QiSSGDPKdoOc3qeWB26fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FF2MCocW9dtVtSUUrVz5IlvJHHVJVvVFCOL6oZXSvy4=;
 b=nx1r4RqFWGwoFHULzClCSRlnEWPZrxyIlQXWY6qdHGZp6OPC1RCXkYW1FhlHikkEpMHS3IGFqVEU6y2rXoMITBbZlb5CMFL3sAm8MvBt8gYYMkw7a7BjP8VL+wxPajmOtZZQyJJcLLt/lwbH7layzjoNhIGTqb+QMwNP9qkYPg6cCYa5Jti8UQ1Syfu7/WX3mm21z7K/dwitmLHasA7Q8oQ41NBodownlpO7VDx+4WH8GbeRq1+yJvjpYulYSsNQRmr0jSDFYpRvmZe9ImJMhlF0+RScRlFHqTr0CdTlcG/TODrvJlsF0a/PFJCaB24ioLER3bdISj6dDQ7gNuer7g==
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 12:05:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 12:05:56 +0000
Date:   Fri, 4 Jun 2021 09:05:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604120555.GH1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com>
 <YLhsZRc72aIMZajz@yekko>
 <YLn/SJtzuJopSO2x@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLn/SJtzuJopSO2x@myrica>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR10CA0033.namprd10.prod.outlook.com
 (2603:10b6:208:120::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR10CA0033.namprd10.prod.outlook.com (2603:10b6:208:120::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Fri, 4 Jun 2021 12:05:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lp8aJ-001dAn-DW; Fri, 04 Jun 2021 09:05:55 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d158c0f3-b6d4-4589-91f4-08d927511c16
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB533631E664A05BD76A25C27BC23B9@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ygUHGgs+VYkAe9AbpUc+Kie7ThWmnhTas9UuigDsv2TKIzucjE1CLjyQsQwBIsWNCTUr9/LAjaNNKJrlTbHjwamrSJyVGzL24Y/X66CGHj9QJEtvADLee1oQpn4VFvopIZtRlcBtWmr3aKAGVVxLSn3qE59WAE3xn6VwRbUCA3OX4XSibXN1hV6SIYYarifnM27AtOpaw8bWYlQWUtejP/4BPJG3CmRBT38CwcMgswj9xqyKCk0OLMGqTZZfm4MfB7N9pq7Lim0T4LMPRbAhzfAlxD8B/sii/shHCYWIU8gZ1+uLm1H64R/9VDkwL+4fDVbH9rXYhH5q9MpPhxhG6w3SOp6d4CU7pjRibD3vxDfPkUOzwWc9W8BZHzEoe2TQrjh0LIt+lNKm9bRTjj/fdSvizL/w4902/3jdjg+tUl1/rJzUfU+MnxiGTugMLJxrjOaB7JlhT7Tlr4ai4X9vRSUyJDWbeyWl96gvHa5ujoYVCkGMSmdlEbw8LHGiQp0GMmgA43fR80d4OvLBqxtl9OOyxSIknOCnMwsQbtMpioDGOLzlRZUYdXyBVSxI2FgoM6rmZ1AfoKA7ThubQ5xgkemdPSWWQ0fOPywdoZC6FI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(86362001)(38100700002)(7416002)(4744005)(54906003)(2906002)(2616005)(66556008)(5660300002)(8676002)(66946007)(426003)(9746002)(66476007)(9786002)(8936002)(498600001)(36756003)(4326008)(186003)(26005)(33656002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i575fRyeAsTstEf4fagGV1HoAsxoC+NnxgImGgvqpvKkSaIC9TuEJvMiRrTJ?=
 =?us-ascii?Q?veaiLG2Z17kFu1Ax+5miMMju+V3v7jiolA+kn6qbJsnp0xilYtyz+QXwEQz5?=
 =?us-ascii?Q?a/nKvWFSK8W+mEXdbypwRR6NMZX3KI5NO4dQxG4S1lLtVpHLkJHkSGF8cjUT?=
 =?us-ascii?Q?Xez6mlgAFxJH/Ly51aw/zdfI8ngAVZ/U3JGMOUKE+Utt3+e62Zp1XhMxDiQf?=
 =?us-ascii?Q?vzoouynN8ZCX+mxlgZmlWLmiTgMHT5LhuRQIc8g3ydGRTpdf6h15NTrcpPin?=
 =?us-ascii?Q?00Fn+6/71LPtEwECsnM47wTW1UqCKBrYtDVJNEp3ORm6JvGP2NHifY0q5+jP?=
 =?us-ascii?Q?Xf0kd1Q4gJSt6796PSvGsmW7pYYkFVbHy6asDQhtIGrKCvAGFAF09uwTdgaw?=
 =?us-ascii?Q?dpDsUPWLKNkOsAHfedQe5UhIFMFCeR3QYrmpgbG1bGxU8iJX+pYk1tJAM8FS?=
 =?us-ascii?Q?Eekjr0jzJJIiS9w7vAcBr/zRLjzeBByJsjn/uxQerHLOtdEhzEviGu4wITtR?=
 =?us-ascii?Q?6aGe6n4+CNGjKWdMrEPVJFobIqFZ5vq+xXNTf//LOlIri3tAZeqZBLdONCL8?=
 =?us-ascii?Q?ASNpAHQghv5gYpFUfqCVrxIpaDVFZ8zHBeOImVR25lw7vq7rbC95kGy0weUa?=
 =?us-ascii?Q?jPYmbW+NMQ6NjDSWlDKtsCylV+q3ujFJYNEBteZUEZFh/nbRSOdu4UApZBJQ?=
 =?us-ascii?Q?IKPIlWEd0JZf/1Wc5P34VY8874dGlxAouj4oTs9KQrcJ6XipY3PI/Bjy4LAw?=
 =?us-ascii?Q?vGVcYB92shq/oIhrwBzlmhlszcwWL8UDlyIJ/kFIikeAjq5Hy2IVVI1Pcyfg?=
 =?us-ascii?Q?EL2PCXAzF0f4pdZeUhR6ktYoecje1uva3WVIdikbSlxKcIvCX70wsQfnQiWZ?=
 =?us-ascii?Q?T82PgDDgpV5EeNaRW0pMyOfrtJY6PD7oD01Z8DZsOxGtfzNQl7MFoBO+GImN?=
 =?us-ascii?Q?E4BVRk9TS1i5w8WkkPfxbWDHq22hhtxdAV97FPJ72ZhqYyBBmSFq4plP5xsO?=
 =?us-ascii?Q?d5UaGDrrBKGuGveBAgtqrAycQ+RMGxUAjNc3JgRoyuDSY3P914bYQKIWdhBu?=
 =?us-ascii?Q?cyHJbx+8dfCYFZlzUn43n5Og0VM0hQsn9eEVHPZivflfE44tTxcZl/Uz+aDl?=
 =?us-ascii?Q?mh1zxy7tzPjMZBklT3U1piJy5Hce4YcILb+pVeW87pGmUZgz5E/e+DfbdYsG?=
 =?us-ascii?Q?YeZsKbSv4d4l/k3ixtxva0U94Vpkbzs6CWJ0D9AOSTKZVZi7R1qsRn6vq6ES?=
 =?us-ascii?Q?l1UDVlw66MpVoet/eftWoQ/IRPESeet9XiZjiaUOAZ3Tmb7ewulYHETQdzmE?=
 =?us-ascii?Q?G0t6WGgAx8y2pTnH1dRMLH8t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d158c0f3-b6d4-4589-91f4-08d927511c16
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 12:05:56.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQE06zu4PSirAe6/y9nkCNEgMvVh1aIff6Q4AZZPYb5fQQFaJiwSj2mcGBSuwtpf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 12:24:08PM +0200, Jean-Philippe Brucker wrote:

> I think once it binds a device to an IOASID fd, QEMU will want to probe
> what hardware features are available before going further with the vIOMMU
> setup (is there PASID, PRI, which page table formats are supported,

I think David's point was that qemu should be told what vIOMMU it is
emulating exactly (right down to what features it has) and then
the goal is simply to match what the vIOMMU needs with direct HW
support via /dev/ioasid and fall back to SW emulation when not
possible.

If qemu wants to have some auto-configuration: 'pass host IOMMU
capabilities' similar to the CPU flags then qemu should probe the
/dev/ioasid - and maybe we should just return some highly rolled up
"this is IOMMU HW ID ARM SMMU vXYZ" out of some query to guide qemu in
doing this.

Jason
