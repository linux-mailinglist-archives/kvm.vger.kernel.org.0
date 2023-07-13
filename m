Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D587516B5
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 05:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbjGMDW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 23:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbjGMDW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 23:22:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535B31FD4;
        Wed, 12 Jul 2023 20:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689218545; x=1720754545;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2kvcb4+2z69g4NVCqkTN80h/KQfxAdgxTax+cJcRBJ0=;
  b=X8YPs+vDGUAKInBkGhJF53/qM6r6AZv+uDjQY8uIlUfl7rO0oImLStWX
   CpZCDqgi+8ymOezsuJCHmETLEt6eRYIWJB6Q+zWf7VX6VtsMewMvXudC7
   /hHeqrlGGbnuD2d8gejRltt/Gh00a/kpArnttkhufeyM+A/LZsr7BrCKB
   V4AZEhgxfhtjZ+pwMUk89t9tulib8n91w1rTEKo0GlB3wPAvZx0V4rTXA
   uOhp/UtFo7jVErMblVhM3kI+aRs2ookqztP1a2ztKe50pJBx+a7QFZUsg
   DakMM5EJnW+L3nZ+LpKIblSZelFkxQn2w4SY8+81GaQOzR0n85PZXJgsx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="428821606"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="428821606"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 20:22:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866381420"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="866381420"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jul 2023 20:22:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 20:22:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 12 Jul 2023 20:22:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 12 Jul 2023 20:22:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 12 Jul 2023 20:22:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emY/aLOhRXs0OvF0GMi2P89odyJR6EN636judYoQZCxd8qnCq7WFjftSvxzuTb17RaMcxhaswf0zlE3HlfXx1jHi5PX1JdlACxzHGrLIJnDJXRKpKt+3V/kFo1tmWVR+2QjJZf7PejUbTA1xI465R5c4pFdezo/81crFy6lJQ3kt5sYZM5lv/9URDPSXzPTdWOzlHSQbgDLR1Y77696Ebigpjstdms6D6KM0KUKh4g6KCDclHKzGmLPkicIggwC9kW/37Ezv/SaijNV85QyEkj2GPM2sA3P72LYMH3B4F3u44A2GKssnycTxAlwKR27+hOEbTykCkVye0ztz88qmIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxJ2bFNWbDZEcBLC4w8CaYVQHM335PfBO8xGabmpank=;
 b=LWohAub1GNMisIMHeUMkjFNz7BWTzS4KdnLYjAkOJrm9xsoJKxr/yrkCdnkZIJBrB9hqy7wJ8jGlnSMlpEvn655tOyVdj/0vxf86IaQw3jt7u9irFIj+lxvlFLymqFoSrZCgxWgxUIEPznM5StxKJDLhIrrxkawMb90K1q0mMEQgAVi3064moBvEDgxx+Bp6ptESEUVSIsRoj55YAxqygUZXDTxLQUCmevNpR87nwONZxQ5tGuzbf2toKM1VRLx33PhHvYR7VyfOjccqKzYOrHpNF8HxcfjJQ1ddfaJfSTV8OOmxbwDctMk0C5M6GWMYb3MkXVic0DDLIEi4EmiDQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB5876.namprd11.prod.outlook.com (2603:10b6:806:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Thu, 13 Jul
 2023 03:22:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6588.024; Thu, 13 Jul 2023
 03:22:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Baolu Lu <baolu.lu@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
Thread-Topic: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
Thread-Index: AQHZs5RFjSKO9r3Ol0q1EtvhMNZbRK+0EKaQgAFTYQCAAHy3AIABJTsA
Date:   Thu, 13 Jul 2023 03:22:20 +0000
Message-ID: <BN9PR11MB5276C09E743E99D92BB5C1B28C37A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276859ED6825C0A496C9C5E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <38c31fb0-1068-4855-c896-27d6a2bca747@linux.intel.com>
 <20230712093344.GA507884@myrica>
In-Reply-To: <20230712093344.GA507884@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB5876:EE_
x-ms-office365-filtering-correlation-id: 318f327f-b062-46a3-600f-08db83505e0f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1U1PeRp0Wnc0pnEweibTu6zTRlbJDRchkzEvjPGBztAcM2MHTrAYV75KC5rPd1Y76hGrfmUIklDCQcPvE1mLGXktyDfPDPL0HRGhCm6qvvzVQe5IbNJa1pOuLatm/j56XDJwaTVIq6XlwC6ghaKvep9u8GZZMnpKeXn+4Yt25qcmp2hDMhx7X1SP2q9qkyGTPYT9lBB9BM0WNCa6YtkB1AlcWSNytCYoOt5sDm+vhccB0KI/9hz0pk0PyJ0f6IbuoZ88QJKiysfEHw/OprOEyE3g5Sdkv9VdnLfOsKpPMGv4+IuZIqoECDBOmvQXYywbfWrCQB7POhvGrGQ3AQFFzhZOnM2ovvI7ElJUxhiTO5CaHC4lGYk1rbC0QKePHb80XYWOKW/LOoLOfJ83cKc/UV1P6e20iX6W1on+C5U4PPoh6BQ+qQwk9Hgs1QyNYMi+XcPcbDcuBz53u4aX28wFDH+ENJecp/FoJ+uwcWk7F/Gj7IqFZDUmiCjMIIH1bwFFf9rNMlKQQb9JLQXCJ+I0B2jq5Nz01S8M32F1hBieFuwo29baMrroLoRe6PiCQdcF+2+L9QrvxiABCBIpzGWRuHNSSp8t86RMrBDFuOaBEVQkbtUT8sWJBERs6BWTGEP8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(83380400001)(41300700001)(66556008)(8676002)(4326008)(8936002)(64756008)(6506007)(55016003)(66446008)(316002)(66476007)(86362001)(26005)(82960400001)(122000001)(5660300002)(33656002)(38100700002)(478600001)(9686003)(52536014)(7696005)(71200400001)(38070700005)(54906003)(66946007)(76116006)(186003)(2906002)(7416002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A5nJaSGnCxt8AvFjzHjA3QGN0yMbG6ahYoKr19KAkBOZ4XUhx9nRVhstlCuY?=
 =?us-ascii?Q?lv4oC+DlyJQI+0Jd395BX/A1ESD6VZgruJigGSDYqsxSjmgk8wUHcPqDp/Ak?=
 =?us-ascii?Q?qbn/IOszhi1rB5NBHuKLBLSUEa6JgW3llehojlwOhblyLT8pXv3arBdi9nH+?=
 =?us-ascii?Q?0MVa2EytCFhSovWOWmMOtSIO/A3XPMrPSqbuHRYn4dHMSq6hVtgG3vVv8JSz?=
 =?us-ascii?Q?DzfdP/H7b50F2UDpotmc/XdRB9F6iLug3gbU8F+rO95IDOX4Nlv0LM/zf4g+?=
 =?us-ascii?Q?0qL5iFr+0bz+wqQPcuRRKYkdIr6tGVHlbESsxVm4tJbumVUHb6ppwupzO9kc?=
 =?us-ascii?Q?x1ktheSQYr/ZLDKLNbE4JPD+aVpX3Q2FirYfadMD1x75vjBE0vNrr48veEX8?=
 =?us-ascii?Q?sKnrBzCWmZFZ//HObsbVG8XzcIyzyZXg1oIKkZTzJzRw2gwta6Bhmsbwf1+M?=
 =?us-ascii?Q?Gp/uh9bwAKsiHxdEUDWfJxIGZGmAFiz352I6Te31YrYsqvNqX4S0/FIMYXgz?=
 =?us-ascii?Q?cJPAyBkobbqzAXHXfd+IcnT6fIVjXb8hcjtMkx3yB/RsbvuAul5y5jcv5g6H?=
 =?us-ascii?Q?/mvfVXZWaRgttKs/rL3mQ7V7zLevmk9dZi6MDfNbw8JuYBnNJuiwJSumXspM?=
 =?us-ascii?Q?LAq2uLIHauSV658OzJx7WP0CMFR4ncT0H7RPJunari2KrylhI3fLZqCJcQu2?=
 =?us-ascii?Q?0Ftc/NhsuqRtZveaxxZsB2usZM1ecBMGzfzu/sTm6AGQM0c/6QLxJLR2UNT8?=
 =?us-ascii?Q?95dtPmN3RXZnujnmSeqMhy9MMlMvBqmVlBDusb/3xL2Y8zfAXvj7c7Yewkc3?=
 =?us-ascii?Q?uYEkWVGzESjLDR1mN/Q1u8UKWDmO1Yj+1RhQdE+tdDp4F8j0W5bkj7mw6iIu?=
 =?us-ascii?Q?HTOQ6dO+6EmO8KHsdmwUzYw64aB91zeXHYtuIzUah/ELS0bKuxhIJ9ir9Nov?=
 =?us-ascii?Q?Dj0NonW/X5l/iOCkACsIrMrD7iqrZoM+Fqjcz5BZaN29+ImGvV6Fg/4stB77?=
 =?us-ascii?Q?sEuiNv6/hrvCwvw7uT9mQfHmEVLlSjS7rx9UYBFvIzZz/imdNdXWYoFnIcKw?=
 =?us-ascii?Q?6pYKmxfr4F6WNEJTEIwE4j8nmripdua7bl2Dl0I4c10TYf8FRCbpHSiQfq4X?=
 =?us-ascii?Q?990Ipi/5sdL4S3aeMuvIH1L/HGSWMYZ3SXvlqe2GMDgQs8GARzDpDcN4IeCU?=
 =?us-ascii?Q?cwXeSU5nADZffUnCejAjAapaNH8cNkmpMVNUS4b7HTLrl+3er5KWfaNX/QML?=
 =?us-ascii?Q?47SfQc14ickTAc+zNkQ43n58GaVSk9fttoYlsW5suToU2Wf5C/KRme3CYAKj?=
 =?us-ascii?Q?7VQjKOloeOXCNzxCfWNefM1ja/b+vfBew0tQ5y8AMsGhfuLNAfmw2cFlvWOu?=
 =?us-ascii?Q?o8dYW6sAV5Y3Xh9X0d5T/Qf/IDmPX5QZcSDPWzK1Yf2eESkhD/az0aW3aKuD?=
 =?us-ascii?Q?GKS5lUuEJhThqmQ7DE634Mu2i3p/xV2lC39KvriQOqZPnLFEypw2mlT6/bhL?=
 =?us-ascii?Q?faJGO2wTnbMY5idl1yajcfoS706Qai8rHBEpAHSTa/eN/2HhoWalONdKDYK9?=
 =?us-ascii?Q?K+Caea1gX3UBg9v1XrYwGG/8eIlHVi0T5XxYTByt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318f327f-b062-46a3-600f-08db83505e0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 03:22:20.1258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2mNzpDHl8wLHuKAWk47ArkiSX+9CYsERf3UAKqYT2Vc9o016UuRxx6HFisO89c2NoLFuwfCrmt5VLhhFpQeebQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5876
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Wednesday, July 12, 2023 5:34 PM
>=20
> On Wed, Jul 12, 2023 at 10:07:22AM +0800, Baolu Lu wrote:
> > > > +/**
> > > > + * struct iommu_fault_unrecoverable - Unrecoverable fault data
> > > > + * @reason: reason of the fault, from &enum iommu_fault_reason
> > > > + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_*
> values)
> > > > + * @pasid: Process Address Space ID
> > > > + * @perm: requested permission access using by the incoming
> transaction
> > > > + *        (IOMMU_FAULT_PERM_* values)
> > > > + * @addr: offending page address
> > > > + * @fetch_addr: address that caused a fetch abort, if any
> > > > + */
> > > > +struct iommu_fault_unrecoverable {
> > > > +	__u32	reason;
> > > > +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 <<
> 0)
> > > > +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 <<
> 1)
> > > > +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 <<
> 2)
> > > > +	__u32	flags;
> > > > +	__u32	pasid;
> > > > +	__u32	perm;
> > > > +	__u64	addr;
> > > > +	__u64	fetch_addr;
> > > > +};
> > >
> > > Currently there is no handler for unrecoverable faults.
>=20
> Yes those were meant for guest injection. Another goal was to replace
> report_iommu_fault(), which also passes unrecoverable faults to host
> drivers. Three drivers use that API:
> * usnic just prints the error, which could be done by the IOMMU driver,
> * remoteproc attempts to recover from the crash,
> * msm attempts to handle the fault, or at least recover from the crash.

I was not aware of them. Thanks for pointing out.

>=20
> So the first one can be removed, and the others could move over to IOPF
> (which may need to indicate that the fault is not actually recoverable by
> the IOMMU) and return IOMMU_PAGE_RESP_INVALID.

Yep, presumably we should have just one interface to handle fault.

>=20
> > >
> > > Both Intel/ARM register iommu_queue_iopf() as the device fault handle=
r.
> > > It returns -EOPNOTSUPP for unrecoverable faults.
> > >
> > > In your series the common iommu_handle_io_pgfault() also only works
> > > for PRQ.
> > >
> > > It kinds of suggest above definitions are dead code, though arm-smmu-=
v3
> > > does attempt to set them.
> > >
> > > Probably it's right time to remove them.
> > >
> > > In the future even if there might be a need of forwarding unrecoverab=
le
> > > faults to the user via iommufd, fault reasons reported by the physica=
l
> > > IOMMU doesn't make any sense to the guest.
>=20
> I guess it depends on the architecture?  The SMMU driver can report only
> stage-1 faults through iommu_report_device_fault(), which are faults due
> to a guest misconfiguring the tables assigned to it. At the moment
> arm_smmu_handle_evt() only passes down stage-1 page table errors, the
> rest
> is printed by the host.

In that case the kernel just needs to notify the vIOMMU an error happened
along with access permissions (r/w/e/p). vIOMMU can figure out the reason
itself by walking the stage-1 page table. Likely it will find the same reas=
on
as host reports, but that sounds a clearer path in concept.

>=20
> > > Presumably the vIOMMU
> > > should walk guest configurations to set a fault reason which makes se=
nse
> > > from guest p.o.v.
> >
> > I am fine to remove unrecoverable faults data. But it was added by Jean=
,
> > so I'd like to know his opinion on this.
>=20
> Passing errors to the guest could be a useful diagnostics tool for
> debugging, once the guest gets more controls over the IOMMU hardware,
> but
> it doesn't have a purpose beyond that. It could be the only tool
> available, though: to avoid a guest voluntarily flooding the host logs by
> misconfiguring its tables, we may have to disable printing in the host
> errors that come from guest misconfiguration, in which case there won't b=
e
> any diagnostics available for guest bugs.
>=20
> For now I don't mind if they're removed, if there is an easy way to
> reintroduce them later.
>=20

We can keep whatever is required to satisfy the kernel drivers which
want to know the fault.

But for anything invented for old uAPI (e.g. fault_reason) let's remove
them and redefine later when introducing the support to the user.
