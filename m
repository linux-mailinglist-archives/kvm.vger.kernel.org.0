Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6DA3ACE64
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhFRPRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 11:17:20 -0400
Received: from mail-bn1nam07on2070.outbound.protection.outlook.com ([40.107.212.70]:23627
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231461AbhFRPRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 11:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sbx9R5FWs3scrMdV7UR/uO/WO3abvOM4HYKYK/r62korNq9jx70HI0VhEc3ySmMPN3vCNn6r+uuBPPGVs4I4kywkuKgJMt0C/tulrbVdr4wKD+hAz7cbweLD39aVeD9/K5fmFTLEIAwW4bFIXfraJsnI14WN96fP74Khnft36N/VFoHWTOZ4AL1R2QDIY+y8/UR5UlpOfDQMvqaXIA+4Tx+0K0Pdb+ac6G2MwZ1l14gSnAUjNb4Azxb5mIYAYrGeeCvB0ZO0GCAii6DvXKRr50dghXWchclgqZ8f8Z0+sNIHfSnjl5DRMvFKjk3Z69L9C7Go+/KqwcK5VtI2tlTGLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NbhCEGP8yxQ69xMq5e8yTlPlW5SzuA8RDyyCg/KWVY=;
 b=C0FVjIXJFqJKI2xyl0v2TOvr55HvY74Qd0EnbxuXNoot1RP6j2ai1fdZG8qrX0OvnlDIc5oOCsiNWt5eantdnXHFtKBQGNQeaOegIPnVFoevJ0DwKlRFv4GXTWR/vu7UUTY64ds2xvEje1MB3BFlRK6kDXkT4VPmMvDGiCmaS65A53nPw6ZSKiyiTt8TKB41yYLDytc4H+RrprgO9tYIc9nivo/DA++jxELT/W2F/LwboxiZ/VYI7QFTIPmHthlXn1q9pUFL9jF9G4jNe0mAU8nCT9hDP9kTaqfNjDZjKEWSMjOXt0oSQsfAx2tmReqFkxgnmjFHqY8bhvT797h5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NbhCEGP8yxQ69xMq5e8yTlPlW5SzuA8RDyyCg/KWVY=;
 b=au4ieZn0gV3VVogWfkqgFXLoOqPyyjJ3JRJcp2WpvwKnIYzf7b9PrDz2Srf2IJtPH8JKDVkib+5lHhMtQMsPx1sEiA+uhmBIXIJ76urdR61/kNRxIgW/SuDGles5sTdSKDbaUf2xJDPJYQmM14tK1WOrr9Xvc6G15A/cchTeidRQUq26gzE4f4XT2m5o43OMkD7JdDg9oF6mzMW4UKhrxhCc1b0rh4ai/3ah4NyN1uXq4oaUE1bvpuIPqtlBG8UkoDSyIgOuVpl7hdr02zK6ByWr4yPPLv4kb0tgrkj6rhxPY2OnqJjyEtBni8x6JxYB1IP2gVtGUIcCpt/8cpyTyA==
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 18 Jun
 2021 15:15:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 15:15:08 +0000
Date:   Fri, 18 Jun 2021 12:15:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210618151506.GG1002214@nvidia.com>
References: <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMykBzUHmATPbmdV@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMykBzUHmATPbmdV@8bytes.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0087.namprd02.prod.outlook.com
 (2603:10b6:208:51::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0087.namprd02.prod.outlook.com (2603:10b6:208:51::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 18 Jun 2021 15:15:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1luGD4-008Yx3-Rg; Fri, 18 Jun 2021 12:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7926c17-48ae-4305-13d8-08d9326bdb96
X-MS-TrafficTypeDiagnostic: BL1PR12MB5159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB515915778C85DD0717186BCDC20D9@BL1PR12MB5159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrMf6lsFRMqmCdSyKEM4iA0H/przTPmXn4oIYSqp0E8tNUcyPbxXR5srITREBjLliQRSBv6hVrhw00YyalTqd2vUZeAfl2qtXfRJb2YwSEr5+2y3WmRfK0Uq6Hgh7CXujHPTFkyC4fPcshYZcsMmSYVnVMMH1A387/zbEBIADBcQT7ICfYVfm1pLm5umSm1wrV7sj7WKqSYO7OMv3f8IuG0Zk1bToZaewH2DBvWdcn8POThLCGCDEhLQVaT1iDobxFm7El0nVOIC8uEnLMCxvDX0Kojwz1L9abO0zGp6n/VgnRQ3d3WMmACFAP357Fl//1QgPdYTAP4UVIc1lJL6U+knRB+Nrrc+rxMOWvxtau/Jj5IhmuqTcL3djC2YKvfwcCOfUVEQxVcjIwHcm+a6/d9BGgDH0r2PTWUVip6UpnIbBvmyLbNmBBhFqchBlurqgqDYqndSucz+G+Ze+29/T1/HwobvdaLqAdyhbmH5PbWC+F3Vp1WVm228NcJ5Ilo8SI2n1B3jAemP/Ge2zQfAdhOA8M96pwsfjKQEBviDNxQWPgARvKrb50ZTvBPpWGDJs2dyuoWRSIvPEi1A4/6x0YDDjU8Mtus6VMdiwU6GNkc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(478600001)(83380400001)(36756003)(6916009)(2906002)(8936002)(8676002)(9746002)(26005)(66946007)(4326008)(186003)(2616005)(86362001)(33656002)(54906003)(426003)(7416002)(1076003)(5660300002)(316002)(38100700002)(66556008)(66476007)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MHPEVTsMe8iXifQqvM4ODoFdc2NzcS5zgzeJZ7GV3AktPajS+gjb8RfT7afZ?=
 =?us-ascii?Q?UWYur0sNlZu54J7UPDmitvGY6zHVyWOX6H+WlRqHAOgO+ydBO+aYti6ianEQ?=
 =?us-ascii?Q?guBBjPu+tdtv9IlLqaP1bktY6ZV+lvcPnbZVYA8VvRbJvfAZLxiyLQARlARD?=
 =?us-ascii?Q?Ok4s3Pm7Cm+HTBmmM/E50KPbfma0UnKlHHy3sG36leFohdst3PRRg0S84OD/?=
 =?us-ascii?Q?ZWyl/+rOXE8swZfCJap2IqeYK+ywyVAsIsCIMbZaMJKmgcO/ST2Sq8yuEkSw?=
 =?us-ascii?Q?lrFAA+1pFlkKqv6FHa3rpeZVLa8Iqxh35ch3jpnDNXA1IXmLvqG6ugo0C0FU?=
 =?us-ascii?Q?OHW3FdvYAkM7DO6AjqXp6cqG4Kkg+8U+kT92/vxNLRkBG4dfIGWgxK/rKlnO?=
 =?us-ascii?Q?0j/UH7iSy+joA+T3V3VDPBySvWTBZJRTb1S7cFqlf/T6WI0Zb378Y2yc22o8?=
 =?us-ascii?Q?wDTlqlk5H2/hNPgSe7x43H1AZdyVaTuLcxQpukJZuej41GvDHX4B2oZgPvMu?=
 =?us-ascii?Q?/1ed3QEgVd4Fc6WH4nKaEAMmEKjgV3RluHK/aLI5hV4aFW6EDqcs6N0w8F2D?=
 =?us-ascii?Q?7Y1PbCcF8WaviPHMu/x9kspLu52EcVAJxnW2eTf6FZIi3+oLvrXTlQjy7Nqp?=
 =?us-ascii?Q?L5r7QZTT84c4RDSo30nLsWq3xKPIe5oui/SYhp4yZM2WzHWIV/8OTBuGW+g+?=
 =?us-ascii?Q?A+zwDtcx79M+KTDzgeqTTwxHYhmgmzWN8ZQQuNSh/y03FS2ySErXz/Hkatyd?=
 =?us-ascii?Q?nOkZD2uEp5OKQhUNbiP6E2fDhVahbJKVhH02u98zCz7ylGQRa3JyZYT6VvZS?=
 =?us-ascii?Q?G9Obpb/Csa9Ac+lQEFk1liAmDlRS7GitJL7eVIHE4/27Y8OWTLY9RewIX3Ra?=
 =?us-ascii?Q?je3XjnQr1VOHhPHcNf9qc3jLYDnll58Ap/Vcisl5RTjDz4THVvdDAaiA3pez?=
 =?us-ascii?Q?c+/Cw2Je/yaBPwLBm1Bv+FaG/fdlow33WhaaNZHIzhN8bmBZzDquYALMS6XP?=
 =?us-ascii?Q?P6lHxH5t1/c7x0uKu86aKT+hEesczte1v5/3Yy55LN/eTz+newfdZSonH/Oa?=
 =?us-ascii?Q?ATCK3+UHbCTt3mb6npr/jZXr7xQcQFct/jHfjtnRyKH4ompgkFJEN9d9tv2A?=
 =?us-ascii?Q?2Dqvn/hwsRW5990IaOKvsXR6d5b4dFMDeaulA+3gWhEmUNs2EaIIonL/psGr?=
 =?us-ascii?Q?EZhSYGLNmyOTco9/843UeERM//yEavecx7qJ/ujSiWAj4LUSB1IW/TbnX4EQ?=
 =?us-ascii?Q?d09rqmre26Wh58exKg2ha7MS8HJ6VjlWkvHVshYGOWtVM3+Qcbl+mz+IrUDj?=
 =?us-ascii?Q?gobCvSjyqdsDzXdkbHLxN4b1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7926c17-48ae-4305-13d8-08d9326bdb96
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 15:15:08.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znsTRUs8LM6dvU6dxOAq6JtM/vfvtSMdbFx3C1dLkwU1yqfsW9bRncDTT7LkgOkh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 03:47:51PM +0200, Joerg Roedel wrote:
> Hi Kevin,
> 
> On Thu, Jun 17, 2021 at 07:31:03AM +0000, Tian, Kevin wrote:
> > Now let's talk about the new IOMMU behavior:
> > 
> > -   A device is blocked from doing DMA to any resource outside of
> >     its group when it's probed by the IOMMU driver. This could be a
> >     special state w/o attaching to any domain, or a new special domain
> >     type which differentiates it from existing domain types (identity, 
> >     dma, or unmanged). Actually existing code already includes a
> >     IOMMU_DOMAIN_BLOCKED type but nobody uses it.
> 
> There is a reason for the default domain to exist: Devices which require
> RMRR mappings to be present. You can't just block all DMA from devices
> until a driver takes over, we put much effort into making sure there is
> not even a small window in time where RMRR regions (unity mapped regions
> on AMD) are not mapped.

Yes, I think the DMA blocking can only start around/after a VFIO type
driver has probed() and bound to a device in the group, not much
different from today.

Jason
