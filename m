Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6693A48A9
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 20:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFKSbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 14:31:47 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:41258
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229753AbhFKSbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 14:31:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioEE9RrpwGIEFYeDrCxv0f/sUb6Zswub8JF7CxEBjpTIZe49dpPyqs9ykCJx2fhzz+RoJkmXHsK4y0Tv9Bc0KnT2zrx6qRNjMSQdDX08RfKGJivuoP5wyWmWewy7swjgGAqaNc35lUcEyJvZRp7zqwJl/Qvw+O/oGWtO50mqMyvmqyB7gG3M1h/N2LMOc6LcuiD/QxVbhmLPDKbBqtH+K6Y/vNX/ZrFbWvaeTUF62ccINPB5lz5w5xPuDYF/QPmY94Bdbg2N8yQ301C6urhXxF8GQUzBJibSnVhRA16P7wcX1oa6/8SKIgfdW6GPWcFaDRzPOpYfAMabmPXzgvKXSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/ulIxeGa73Z22xX+t7QCI8g2zMvqp+5FJCH6bgLt1Y=;
 b=eAUcbA031PDDSqO6UOeB9k3FiqMBHuuBMbcHsCUcGfjm7gxA7lqtQLdcsXgBMMset4SloI0HMPLHa0ReTc42dWcHjPNH2fpsPwX9HVeb7awPTcrrdRJ9psgSmacGnZMH4lpVkQoiTaFTWT2IUYMTauBeGPjufaT94m++46TWQiZoJeMV0HEfjotdxsTlmS+gPouGaAIQzJro0fXPzyeGiRDLp9W1sCr4eUb2E8uWCB6hyRJZHpvqN+Mjn1w/luk3rKc3wNJPeD5zlm5FJcV3PglzzHrZWBckX+GgjgB7dpAlxCLK1O84X2V2swbUxiOawueYDJtFyyCqlVU5Q9YwEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/ulIxeGa73Z22xX+t7QCI8g2zMvqp+5FJCH6bgLt1Y=;
 b=ORztE+NWPYMmh9ZyjxVr2bYQdP0CnBRHucM1zLGJHf0sQasEfLw4FeQ/46g8LUoxmN350/3IS9nrbo3gSQtcgJTcXTUQdI1IlWHCvvcx7uojGBOMyawohNjWRromUzS0FNWUBaTuyHw+jm3ANK4+ygYF7GOHac1lQCOcWpQRkbN7Zj+DdrH9ffMp3H30mpyd8K4E1/KeH03Ysui9M3ZCz9rosr0m8wqJoJagID4pS88JDWVTg2aLMXzxuVG0x+3J8Kcc/bCWDqmguQ5Bq0Ojrmun/KlOHQ1v9QRPjdarz+YcB9Gb2mXdvfqTLlWo8uk/pdrZoRLP2vkMdVNSAwxo+Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Fri, 11 Jun
 2021 18:29:46 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Fri, 11 Jun 2021
 18:29:46 +0000
Date:   Fri, 11 Jun 2021 15:29:45 -0300
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
Message-ID: <20210611182945.GZ1002214@nvidia.com>
References: <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
 <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603214009.68fac0c4.alex.williamson@redhat.com>
 <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <168ee05a-faf4-3fce-e278-d783104fc442@intel.com>
 <20210607191126.GP1002214@nvidia.com>
 <bb39b5d4-093b-ded4-8ff1-73bbd472d905@intel.com>
 <46472732-e139-87b9-ca3d-e8c41fda83aa@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46472732-e139-87b9-ca3d-e8c41fda83aa@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0077.namprd02.prod.outlook.com
 (2603:10b6:208:51::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0077.namprd02.prod.outlook.com (2603:10b6:208:51::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 18:29:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lrlub-005iSK-3e; Fri, 11 Jun 2021 15:29:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e97dab9-feae-490a-b768-08d92d06e3af
X-MS-TrafficTypeDiagnostic: BL1PR12MB5142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51429F99B0DCA64403822345C2349@BL1PR12MB5142.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zV0XLDKGeDqm2uYIlEI6wXHJHp55Srp7jCqCKtnvv/olYc+P/FsNbFZ24Kxd6mrrCfLnxHND4i3+V09oDR90rq/yCnb6QYrg+znm20wu/2F7dLRA4dIiD6djzQNBKICG0+aUr1PHLeoV3PnxcU7xlcyAcdeo9xpMqsWTywbsIFqoCi3Xih1JEgJqSGXSSQOLcjpOOohFsEjpf/JPnPVNPQKV8dWONZpBLnBPgbC9QvF6Ey6162MFOmtIJ2mIBkG04m77Mwheq29+Ps7CG4h9E06m3sbbL/Pcd5pV/LbTon/0lxqG3uX+/lkku0whsW5JEbCasz5fst3/AGrbMB0DXGtymwLL4P/eyy4aiwsYr+0+8p4y8HkDkbJZkLCplDf2YmrgkTpsoDe2ZcPKTP2cPYDtotgwhTXmWvnFJRjMf+xLUz3lyOAX8wS8LTzQgalkBo4XzrpTYnHP4LkqPuLC69KWMif80w/WEWpCbrE/Q4p2mdhNvwqgj+3wftfLhy/Z4AvQLH5/RNjvKCijLuBXK5eN2oZzmeJK/PuWYHCRRf7DVQKQbJo3Xla79PgjMalj6gxIa6bDu+dr5jz5Ym+tcIFaNbbp1ICMO1P2FErGQHg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(26005)(36756003)(53546011)(6916009)(186003)(8676002)(7416002)(1076003)(5660300002)(2906002)(33656002)(38100700002)(9746002)(316002)(66946007)(66556008)(4326008)(66476007)(2616005)(478600001)(83380400001)(86362001)(8936002)(426003)(9786002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDBXOGpoWG5QTEZXRFYxSkxEOUhWbXlrOTZWUFY1YlR6UE5uamY2YzVxQitw?=
 =?utf-8?B?eUlXWTh2N1kwRUVvMWNkYnVKN3hFdUhMMW94c1lUU0w3Rm0reUdRTjAzT3M3?=
 =?utf-8?B?c1NWZUQyZWJ4bm5VaVNVSkdFYXppZS8wUVlMSEgrckxJR1pJdi9BV0JOSkFq?=
 =?utf-8?B?eE5DdUF5UVM0T3JEMHJLc25pRUxKeXoyTld1RE5MMUhreFBPTFBpWlNOWmJk?=
 =?utf-8?B?dXI4engxUUJCWVRaNEdieFg1NTJVWHFHKzMyM0FxdDZQaDZ0NnNYbHNvUVhw?=
 =?utf-8?B?TXd3UVRpaCtQNjY3UCtYektNS1BpOHh6dHRmdTFlVzJkR3VvdXE1T2F5UlVr?=
 =?utf-8?B?bEtmS2RuZGR4dHNPdEJPRStKV0psUHlFYWYxZUNlREVpTmVCaUhlNzNiSEZS?=
 =?utf-8?B?aWRPUzdkdVo4YWhDYWlLV1hxZVFRanRvejFQMGw1aEQ5UVpNZ2xkNHBPZFI2?=
 =?utf-8?B?REcya253MVkxMGowN0swVFRFNThvdFBHOTRWZHBmZXhVM2J1Y1EwYzFYUlZG?=
 =?utf-8?B?dWo5cVZNbGdYemdzT2VzeWhHRUpXbzRqWEFLSzUxSW85YnNtMDY0T0tCc0Q4?=
 =?utf-8?B?UFBiVTVkL1ZWU3MwUmhZMGVSV2NtbWNRcEhnRjdnSFNBRjIwVmx3eC9DYkww?=
 =?utf-8?B?WHBOVFJlSGovRHV3RHlOZUpLU0RpS21XNnFaVDF3TkVERk13RFo3V01mQ1ZZ?=
 =?utf-8?B?U1l4cmowZkEybVMzTkxoa05lUWxTR3huYU1DV1dGRWYwMTU2MEhwckR5cWEr?=
 =?utf-8?B?ZFVIazBFM0dSYWl6OVdVcEM1SStza2pDUm8yVEtIaDlvZDhHQVNPa0o2RVlu?=
 =?utf-8?B?V0VCU25ndjZUTHpVNE5NNFRObkZYL2lvRlJZeEpkV0NLc0Q4cFJ0TUN5L0NE?=
 =?utf-8?B?d3NlRDAxSDI5aTNoL3k3WWhVNE5KeVhtZnZwb0ZDdXk2aHMxKzl0WDhtNlY1?=
 =?utf-8?B?UGs4RkYxaWFVRURoZHJPeHB5TDE3Ny9ZbzcvSmFXS0QyMTdJcmI3Z0lMWG9n?=
 =?utf-8?B?MUMwMjVydEQzeEhScDFYRDFEOE1sVzFLNHNNMXg5S1VrcFh2aWY2eVduUldW?=
 =?utf-8?B?ZDJqL3ZrVHU1ZXdrWVRITGtsSXAzU2NDTklNQjI5U2FZRkd4aFZKYlI5andT?=
 =?utf-8?B?WmFIRmZGbWRWUGRwaldRamhudkR5MlZjeXpEM0NxVjRKajZqN1RjVXExUUpt?=
 =?utf-8?B?ZjNvWEpXWU1PWnVHc1VrbUs3bkNiQm10TUtkS2NLaWtOYWh5Q1RMRm9BcUx2?=
 =?utf-8?B?d3dsa3BhTEdYV3RzWkdoem1ldGdWQWxqRnRoVGk0dmRFZWZCTUo0MTYrSnpC?=
 =?utf-8?B?cTRqSlZSelY3SnlFVEpxWERVbWFNQ0VTWmo4Z3BxaEp1M2F0RXBwdDdEbmFl?=
 =?utf-8?B?NWsrdHRqNEd0d05oMmZ1N0VWdzVMbjZ1Z0h0L0c5eWROZnFvMzdKVnVuN3Vi?=
 =?utf-8?B?TGV2UU0xWVpPeWtZY2xCYVNHaDBLU0dzdkxVQ1gybG1hbEUwcFRPZ3pWbE9i?=
 =?utf-8?B?RzJMK2hmQ1Z0Q3A5amtSaG83U253cVg3bVFMYkhTTFQ2b3I2bXMzQjJJZk1H?=
 =?utf-8?B?c2tZcElUSmI3ekVSM3FGNlM2K3IzTGhibVo5dnRnWnJ0OU9LSjFqUFBPOWdi?=
 =?utf-8?B?Ym4rbkwyL25MaG5SbmMrN3BnMEQxM0k5bExUa0NUS1NtSmpvalNVWmlndTVm?=
 =?utf-8?B?cHRRK2kveE9ObkZuK0lLS2U1WVYrSVdLSnJaak1mUVhVTDNpRTZ6d3IyQzdv?=
 =?utf-8?Q?XApDw4zMhyOXsBd4Dp6PNOWJqRNSRtYrM0vEfsu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e97dab9-feae-490a-b768-08d92d06e3af
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 18:29:46.4305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sUNezrK05/KLfK/dtpcHmhVW7EoivmE5zyJSeXY/VSMwc0HWyP3Rlrrcmcxxbo2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 11:21:42AM -0700, Dave Jiang wrote:
> 
> On 6/8/2021 9:02 AM, Dave Jiang wrote:
> > 
> > On 6/7/2021 12:11 PM, Jason Gunthorpe wrote:
> > > On Mon, Jun 07, 2021 at 11:13:04AM -0700, Dave Jiang wrote:
> > > 
> > > > So in step 1, we 'tag' the wq to be dedicated to guest usage and
> > > > put the
> > > > hardware wq into enable state. For a dedicated mode wq, we can
> > > > definitely
> > > > just register directly and skip the mdev step. For a shared wq
> > > > mode, we can
> > > > have multiple mdev running on top of a single wq. So we need
> > > > some way to
> > > > create more mdevs. We can either go with the existing
> > > > established creation
> > > > path by mdev, or invent something custom for the driver as Jason
> > > > suggested
> > > > to accomodate additional virtual devices for guests. We
> > > > implemented the mdev
> > > > path originally with consideration of mdev is established and
> > > > has a known
> > > > interface already.
> > > It sounds like you could just as easially have a 'create new vfio'
> > > file under the idxd sysfs.. Especially since you already have a bus
> > > and dynamic vfio specific things being created on this bus.
> > 
> > Will explore this and using of 'struct vfio_device' without mdev.
> > 
> Hi Jason. I hacked the idxd driver to remove mdev association and use
> vfio_device directly. Ran into some issues. Specifically mdev does some
> special handling when it comes to iommu domain.

Yes, I know of this, it this needs fixing.

> effect of special handling for iommu_attach_group. And in addition, it ends
> up switching the bus to pci_bus_type before iommu_domain_alloc() is called. 
> Do we need to provide similar type of handling for vfio_device that are not
> backed by an entire PCI device like vfio_pci? Not sure it's the right thing
> to do to attach these devices to pci_bus_type directly.

Yes, type1 needs to be changed so it somehow knows that the struct
device is 'sw only', for instance because it has no direct HW IOMMU
connection, then all the mdev hackery should be deleted from type1.

I haven't investigated closely exactly how to do this.

Jason
