Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB10470174
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhLJN0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:26:53 -0500
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:7520
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233522AbhLJN0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:26:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjE7sOQSbpQjQczQemZMOF3gDGy9MP56Gp8qFB0FyZmqAaMPucX9u1fl/8DBB0daejTRD1vD7kXn7WGvPvCfDVHyLfhdreLFPQifTw2+Z4zX/K7MzZT0RQ/RpgGQ74zvT//AXdMtsg3PnYRuvR5jeC3hVkXTwC1vA77/+MwdYaDnpkFJ8iFT091N9ca/mrSBusYCObcyZkQruyORW7fi3q/3pvxq0h0wgE56IwscLFbvJZ5pTbleWIcnUg0wmDhTcTr+4kpGwjYvgIVhAB9WZOEbkm1kYSTz6uKAJNeAdG8T9tg1+zgkVKcNU2sQEAupHTdssLej7YwyEpK0ekKmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urqHdnT3tN4MsdUDnhi8OuJ2b70wSdyl94R1N2kLvY0=;
 b=fNI2NS4H7cVRK5ZBL2FAG11mY22ae4rRj/DyHBMf9VLU3+IH0kGkPKU0mBJgoB0Nf9h2UdY4iaweVwdxa47jnvkZLIj1WDCKeIdmduNn5w4dv5uoT364jc4pIOF6oydhA1+bmKh+fQvEnM9sTY/5Q0KU3iIdv+w/GX6R4xhQynaYgPAvGDsSQEDLz20FD00kuF38fl9ce63fZCEYBbzc7cHcECYqivDlLNMWF6011cqggVjNN3GingL/J1lHdNhOf/S+3m3kJw33jgchUprbFBjMEsAvPQVni5cDBnmRc+N3pxXNLgVj1BDelO73HaiM2dt4WULVaVAuKclv6BUQ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urqHdnT3tN4MsdUDnhi8OuJ2b70wSdyl94R1N2kLvY0=;
 b=SGcOGck2CXXpW5NIqd/qXgCPs52U2yWLG6eDmjDG4glF0s9QSklOu6Hwq61b7XiM+O3Y/WrA6oJ03gBRA0WXIKPH9SXpWoosd9SWSVMfMvQ02FXOmQb+F7m/lSYj2dZHiIBgoM2LdRUGIQm73b+HPGFsyl5KjJ+N2KP0DVlYx997MKBIqUMJL1N1y2L31DD5X23rvYBDMK7uTRGPaX/5UWulRduQPLDmI/cCc8HJmg2LnQLEFMLbFQ1DAZVkuvXZDcwvdNzQ7GIU3v+FXEJkYM4XaKs7yt2UiF5nGC4S4db1yFZaoR2gxr67IP8buDv9Glkkj6ZfZBRru8fw8Vc4Ew==
Received: from BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Fri, 10 Dec
 2021 13:23:16 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Fri, 10 Dec
 2021 13:23:15 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%7]) with mapi id 15.20.4778.015; Fri, 10 Dec 2021
 13:23:15 +0000
Date:   Fri, 10 Dec 2021 09:23:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <20211210132313.GG6385@nvidia.com>
References: <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
 <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB5276D3B4B181F73A1D62361C8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211209160803.GR6385@nvidia.com>
 <BN9PR11MB527612D1B4E0DC85A442D87D8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527612D1B4E0DC85A442D87D8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 850eeda8-daa0-4d22-0ef8-08d9bbe0390d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:EE_|BL1PR12MB5189:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB512784F113A0AC3A4DC6B167C2719@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gL5HA+JKvkorAe/DUIyg3kM10lIX3xqwzAfb21/gJIS3XeBWy4lj7WAdu+aYEq32J+ZSUalWRxMJczr1dde9d7NlrEcZ34TUIHyDeBrlT7FzCtPbOUztP5MMgYS2V/WqRFRuWaGCFQ/uCTm2WT6B6ytskk8d+17inVrtUjSz7r8F5rtU2eT/imWZf6+DiEOQEngFQhDg2Lf+j50eYOUMJ8zkBxhfa87GAq8dV7Ku2249tKhQW8uoNIZnVWGtiIQfZrrgIFfX0C4T5YGu/W4uasxBWWJMxSxEHv3O+6HfC/3aENzPFcJZlo9dFzUzrhL3KS+W/wuPZVSYoAcKrXAgorlQYKwRG/2BWjyIsEHkX1Zw34WYQvI7VmLbuOtEv7gLgvDva4/bYa9ATq6jad2OKuh5Lhg0/ZOIY9pR49dytDMHJn2BATU5+2bnxnPH4cqCFQPEBhHhGR5WPckj3RHQ8HYQZAERw6HAk7sqi8XHiW3auAyC0nYmcKp7fMOfhV9tf9unXS52bnZK5GNTv9bFZJTY8kGWJ0XxqfvkMAc+9mOyruD5fZmxI7bvtBF2YPPe8Q73p7DufxWKLQ/oseSZ5Lz7u85PAaK7PnqkgzwSGcxLhyPtcKbXKuNWgUQDDKuWjRsN2ln3USGgX7vFumArcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6916009)(2616005)(5660300002)(2906002)(316002)(8936002)(54906003)(7416002)(83380400001)(508600001)(186003)(66556008)(66946007)(66476007)(26005)(6506007)(1076003)(36756003)(86362001)(6512007)(4326008)(8676002)(33656002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qot544u0S9hwNqH6aVZKsMPwjdNQ9o/Sg9efrdWs+QI98jLVKS1UCQVIZ2CM?=
 =?us-ascii?Q?Fr1zbUbrt1NJDkFTCR42gfVLqBRQe/dTPz3ix7gMyqPjwnm7WuN9nVPoBQGe?=
 =?us-ascii?Q?fUI9hGXbbXKmb8S6XmzFnfIVdSHrKYEysJY5nnAAAdk8UVlI8fZInjJJUY3T?=
 =?us-ascii?Q?rZ+KxCzUkh53i51lNG9p/YBdccOkylTySLVLIfQzmoJEXypQEH0Gx/0a1U6r?=
 =?us-ascii?Q?0c+Bm223MkYmjtcxRDP9y/LYILHXejIUAqtx0iqCo3XrEbRABcpt+qnRC93m?=
 =?us-ascii?Q?Hr6jtCOTlOxNYDXvru687wiQ+8NdrxrnlEuHsHfHwT9DtXB/KCBouNjrbyN6?=
 =?us-ascii?Q?XPHO5hJ6JrkKF5D9tckt4zYLd3fd4eeSNjCg1A9Gnr9bY/3W+3gTH25+S2wl?=
 =?us-ascii?Q?DG9Kknxb2ikqAxiqir8hSssLQNTkNPhNJo6Fxhva8Md1/QcPcSNO3fZmQ2Qb?=
 =?us-ascii?Q?gSSu9+69mOJDfoqJKEXkalCJWYfJKVl34wz02XVhGfjpn2OMPoZP3fNMXtah?=
 =?us-ascii?Q?5OZ3YGpMi7bLqDwNhjmQFy+9qKGYBzfUac+93U8WQefSHp/2d4JYRcEmZYU1?=
 =?us-ascii?Q?7zA7T21ju9gDMDyGtl7dc8h3m4rPIYLDbHlyuLb1J6G4lvmy+yMRYE/9uzo4?=
 =?us-ascii?Q?Z+24+k2RaO4LzXJ3RsPanDvi96vcumIMwdbG251yOgt+Qay186wSDss5pQFp?=
 =?us-ascii?Q?9LUIBpLY4efX62Lkc+CzhMJwy7A5NgPXzhRU7Kqi04AQlHSg3vCyrW2/XS4p?=
 =?us-ascii?Q?19+8INKe31W0EiHAlprGtDeW3c1rAdeWjE4ZmtVd9OCE6fA9TYsbFcNOlFK4?=
 =?us-ascii?Q?CR11c6mJ1ZPG2W6RcZsJAr9J1dhHcFC8a8O81MgCs/DwQ6JC1uPkOnu0K3H8?=
 =?us-ascii?Q?UdHsVW/U7Zd/jdnLvE4xpIiNX4r84SnANxENKY5FRy2yRShsKC0SIkiIV01D?=
 =?us-ascii?Q?vSHQ+5EaHiDwjWzrIHbzEY57YaYBGFNlI4eV2WTWbFrkHhPPnu91k2HJoupX?=
 =?us-ascii?Q?tgN4EloRJXVWttmLwjL+TT7zXIqKIT9flm1YVlL8gxstyo/firHEJRnlmDZf?=
 =?us-ascii?Q?HwXuQvSgCKIPEtqBpT72/SYE2CFjkxmggOrAnIFdKsjYF5NiikMF2F6Vk40m?=
 =?us-ascii?Q?YJb/kjUfgQ0U6WQ9AF2FNZWohc50CtlYiyuMhArfkefXE46q/gVZ0EMrgXTt?=
 =?us-ascii?Q?T5E29r1FtHU/jn3RZBnQoMo25HxLRHi5aJ/gPjQt8UPVBYWrqHxiQvKuH8Mc?=
 =?us-ascii?Q?Mw+2SvbKIwNiguzdU0CftpY0DjTDvfTmy1UET/D6dfOORB8bBY70VrSDHWbf?=
 =?us-ascii?Q?vsZLYNlAUeq3mOnC7wSMXEXX+vx7BXSJ8AK/yEk9Q3O6J+u7owzf812kmJSc?=
 =?us-ascii?Q?Vk2epy4t7KFIOmWdt2gxdzFQxKGEntKQKa8yHrxpRZKmgDRJDX6HFUacSrL5?=
 =?us-ascii?Q?qop3EMDnQPl24z+3F6cJVnbWvrJH2Rd2GIc7hvBqWC9AsP88vEPQLq9pQxnt?=
 =?us-ascii?Q?BkBAN8M8dhbb2bjZ4/IuFwTH4VPYg0XPEci1t1rbEoC5UdUEew2O/4wLrzpx?=
 =?us-ascii?Q?YOdbVsV+nRbM6N/U6Zw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 850eeda8-daa0-4d22-0ef8-08d9bbe0390d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 13:23:15.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGy5x8UOI37o/zpv9AARike91CCXYM5lLFPs29dT7C1/yKMigujSt1NxYN/QMIIf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 08:56:56AM +0000, Tian, Kevin wrote:
> > So, something like vfio pci would implement three uAPI operations:
> >  - Attach page table to RID
> >  - Attach page table to PASID
> >  - Attach page table to RID and all PASIDs
> >    And here 'page table' is everything below the STE in SMMUv3
> > 
> > While mdev can only support:
> >  - Access emulated page table
> >  - Attach page table to PASID
> 
> mdev is a pci device from user p.o.v, having its vRID and vPASID. From
> this angle the uAPI is no different from vfio-pci (except the ARM one):

No, it isn't. The internal operation is completely different, and it
must call different iommufd APIs than vfio-pci does.

This is user visible - mdev can never be attached to an ARM user page
table, for instance.

For iommufd there is no vRID, vPASID or any confusing stuff like
that. You'll have an easier time if you stop thinking in these terms.

We probably end up with three iommufd calls:
 int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id, unsigned int flags)
 int iommufd_device_attach_pasid(struct iommufd_device *idev, u32 *pt_id, unsigned int flags, ioasid_t *pasid)
 int iommufd_device_attach_sw_iommu(struct iommufd_device *idev, u32 pt_id);

And the uAPI from VFIO must map onto them.

vfio-pci:
  - 'VFIO_SET_CONTAINER' does
    iommufd_device_attach(idev, &pt_id, IOMMUFD_FULL_DEVICE);
    # IOMMU specific if this captures PASIDs or cause them to fail,
    # but IOMMUFD_FULL_DEVICE will prevent attaching any PASID
    # later on all iommu's.

vfio-mdev:
  - 'VFIO_SET_CONTAINER' does one of:
    iommufd_device_attach_pasid(idev, &pt_id, IOMMUFD_ASSIGN_PASID, &pasid);
    iommufd_device_attach_sw_iommu(idev, pt_id);

That is three of the cases.

Then we have new ioctls for the other cases:

vfio-pci:
  - 'bind only the RID, so we can use PASID'
    iommufd_device_attach(idev, &pt_id, 0);
  - 'bind to a specific PASID'
    iommufd_device_attach_pasid(idev, &pt_id, 0, &pasid);

vfio-mdev:
  - 'like VFIO_SET_CONTAINER but bind to a specific PASID'
    iommufd_device_attach_pasid(idev, &pt_id, 0, &pasid);

The iommu driver will block attachments that are incompatible, ie ARM
user page tables only work with:
 iommufd_device_attach(idev, &pt_id, IOMMUFD_FULL_DEVICE)
all other calls fail.

How exactly we put all of this into new ioctls, I'm not sure, but it
does seem pretty clear this is what the iommufd kAPI will need to look
like to cover the cases we know about already.

As you can see, userpace needs to understand what mode it is operating
in. If it does IOMMUFD_FULL_DEVICE and manages PASID somehow in
userspace, or it doesn't and can use the iommufd_device_attach_pasid()
paths.

> Is modeling like above considered ambiguous?

You've skipped straight to the ioctls without designing the kernel API
to meet all the requirements  :)

Jason
