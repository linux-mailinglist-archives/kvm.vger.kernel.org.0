Return-Path: <kvm+bounces-3428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 958A9804417
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EB8C1F213B2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44031866;
	Tue,  5 Dec 2023 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X/Mkd9bH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62569A4;
	Mon,  4 Dec 2023 17:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701739951; x=1733275951;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dH0muhTZKBEc+Tk6TICUqU+OBnl2RYYKjW/v7YtSnRw=;
  b=X/Mkd9bHNZqYxeyDsEMp+OiPZl7EsPXSZIXZa8HnFklyVZa4ZuCWu8la
   9349Vo1k6/YQZ3U+c1f9gOxYUgT6rWix2ECOJStg3vsfYhEFUoJTr++Rn
   KYDVeMWy/ixzQ4CzGm82u0+PY2J6prhmoMw1jf3jbs9Zx1ZtLErdXxhHu
   fir2UONFjiYUYMsgby9R5dEkbYnKPJbqwMvrzKho8oGtF+CyJeOKZeW9q
   vHObEyrqtkFfscPiIokeJsqpOKVwxo2JmU+hB+LG0uhljQRiGabIzUEIy
   FInqW2k3jSfMtivMtmHm7eoecs7iVAVob+I6mOGUpzOzs+TfpPNOQSTQt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="458146850"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="458146850"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 17:32:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="764155780"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="764155780"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 17:32:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 17:32:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 17:32:29 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 17:32:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oqrscy18CsowVCAfR/uviGag8FeITOvZUGhoSdStTV+QrBQFFLlcWxGwtoY7KQZ1sawKS5eZmnTPxanWTSMmMhudD6s1qsMw6QKTomuSiJtKpDqlPimJvI5/aRpYGhEoaOc+QLU97yxo8+xaQt6Sup+qMV+wLOpQtuxSm1dz3fri4YnHo1TIdQNln9XUKf2DsX8X8I8BeUp3t2ejjY6UTF4La+cGrzc/5JzkrerBAOAzqSPV+AR40qQEJ+vf1v6BzwsWVI7VMXCT5vwtHfgjUOtJMLE+sXoaeNeQ2c2kT2ym/fytxTFYewQWCgbadieIXhfKB0J9YYUXrIF2jTlcTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dH0muhTZKBEc+Tk6TICUqU+OBnl2RYYKjW/v7YtSnRw=;
 b=TOd4CzOqFygyPiNSS3b3+lbZaeZDVYnIEeYjfyJnc1WfcJ5JDYnmCkjniXvnJgvcfrkhOI86gDlB6enq1eDcJuK542EnC2zt7hfHKFyEDgXt7VVAjiwApDa+kNGVuIkq7/YPENOAQcjhHceZNOzwAhWHszAkfC91tW8w1nykhzovTmcBNo6TEPabyK/sv0FYfvV4U/Wsfp829mrByxhylSBLRX1xbqcDOcWlVGVdSNo+wHJzV9f/r8305CKc8ZA69IdsciHEcnKU3ThzQeqJ2x2Y+xrYsoeVHfnOH0VdO+g2WK8VSA8D9Q9sd95TFfQ+01yuFzZZK17z6WQ8G63QNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Tue, 5 Dec
 2023 01:32:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 01:32:27 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Baolu Lu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Jean-Philippe
 Brucker <jean-philippe@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>, "Liu,
 Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Topic: [PATCH v7 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Index: AQHaF3Dgz31tJTFbWk6dNEVbu0BBIbCU/P4AgAJgZgCAAFm2AIAAvYqAgAA+r0CAAIhegIAAwnlg
Date: Tue, 5 Dec 2023 01:32:26 +0000
Message-ID: <BN9PR11MB5276908231BA164E4AF8806F8C85A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231115030226.16700-1-baolu.lu@linux.intel.com>
 <20231115030226.16700-13-baolu.lu@linux.intel.com>
 <20231201203536.GG1489931@ziepe.ca>
 <a0ef3a4f-88fc-40fe-9891-495d1b6b365b@linux.intel.com>
 <20231203141414.GJ1489931@ziepe.ca>
 <2354dd69-0179-4689-bc35-f4bf4ea5a886@linux.intel.com>
 <BN9PR11MB5276999D29A133F33C3C4FEA8C86A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231204132503.GL1489931@ziepe.ca>
In-Reply-To: <20231204132503.GL1489931@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5013:EE_
x-ms-office365-filtering-correlation-id: 73ce5c61-d75d-4449-5be5-08dbf5320a1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +hTSNUfrPH5z34eSer/8r8Bl93K69FU/+sE052yKggYTJzSX5zVuW4QWuWBXmNX/JCxYGkxveX0z17dz8AXSohS/ypCF3TfFqZTfdyLoG54pj8MwWqM97D6iGi4Jadj4S+LJ0mP+vBUHOS5zDSTO7oq9/NuQsCxUy8qQeGMP/4xVGVwmp+WYmibNktkB0+xaM7QrV3eWJN7JfNJ91donEsL9UzGKmqQG7RFkXGYSfN002BdAzTrWKKd8X4OpT4o0LmXSRXUHOOLaC5r7F37hLccqomUW604X2fFToJcQZACxgzLeWd4yhi62bMo+0+YoQaqmTUVV1iuKvzFoWSh574FDCMtEjZrqYvb3Y+DK9wQefTmu+1j7nbN6z2i8hOJRZZS/tSXtavBO3sRSxVjfLMEiB2BhBfe49hF4U7ovOPx+wz48ON0PNMRE0f6nqdf0l9+TXXvliNe7Aqkc72iYWWQIXVHL3ROt0aiZPNGGYhyGIY7QDIn1g/BLFWuDwUhSekBcLSockZQHjbTO/Dfp1FWzcxitygjRNBaVMCEbuNru+poJBr1jMAg+vIncM3pRtZLXAK6s/0YuSj4YrFA2/c6R4T2PQcJ+nOOa0LCbDdaiWv4UH1789ZemnbvDudzjiKBrwF1WbdEcCLz/Gxhnj0JjIE+9BxXWGStep8D6fZ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230273577357003)(230173577357003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(7416002)(6506007)(9686003)(53546011)(26005)(33656002)(7696005)(38070700009)(41300700001)(82960400001)(38100700002)(86362001)(83380400001)(122000001)(71200400001)(2906002)(478600001)(55016003)(316002)(66946007)(54906003)(6916009)(66476007)(66556008)(64756008)(66446008)(76116006)(8676002)(52536014)(4326008)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i1X7X0/7Jbz8rTXddlyWioBBqUSh4QpT4KEcJrN6bw+DEnOOpyQloD3C8Y+H?=
 =?us-ascii?Q?ic8j+E4k2uWGNDSGbA49L8AtQItp2fw3eUVLs2zLgC+QhOmNSCUbIILqzrQH?=
 =?us-ascii?Q?O1VsGMtlRlM4DmJvndv6fcQtCUfgjO4J/BhPJDJNtb/QO0jODPE2K6roZU9Z?=
 =?us-ascii?Q?Qb9lVf995RHXruHmdHAJyzJXNTo2vrW58+VYIhh1i7p9qx1vmtxciNIp4Rdh?=
 =?us-ascii?Q?ICb6UTImuVR/Rt5Sj5Go3g7v6smzYS6B2lzYZjvuytv0hWC8a2E5HvMpvjfQ?=
 =?us-ascii?Q?OX/JJk82/S5ToCvsidZfogEKzyZbfipbaNB1j3t4CcoN7+nbLJ67T3bus9Bp?=
 =?us-ascii?Q?4YdYbatR18R82f4WEhHMQ7rnzHAwU9yonohALP42AcVplU4XEY9q5f0nx1mM?=
 =?us-ascii?Q?c5UPJEX9lkgrXDPtiZf5KCA3uKeTPveeMUSGOpVqNO1/QQwg2kuY1lUkt/7Y?=
 =?us-ascii?Q?SDLlRYVP8Iq/tbs96ZOFUTxBhpoauw4a18NTLf8lXjddLCDSM4nmOTgPVZTd?=
 =?us-ascii?Q?K1JEWd4wnrR5OtYie1giuARdlKjBWLvxtTtmg/kjbmDHm3GYe/NBmq5aKx4Q?=
 =?us-ascii?Q?B/71fIBYAUxOoQsb8VDC20bNNYpjUlEVsOGtdcMOlo4Wzp846fUC0oDPMx4a?=
 =?us-ascii?Q?NhH/77lcTeqOK4X89LC80WBwh+KwOQ1khr1Dzf4boUpCHCsyYP3ftNxKH5/Q?=
 =?us-ascii?Q?zovC2mPnAnDvTlfUscDl5jJjUYHlCWSxbObdMLWiQhY8Rx/ncc60/PaKRcEv?=
 =?us-ascii?Q?16IjQaSextmUIsAooKjCSznl5ODJfNlowKMYwW3k9r5gn9bNmTVsuaBhycMd?=
 =?us-ascii?Q?y77zHIZSO76jdW2HhjNllbn6mUuPDPlRfCKnFJwsDwbD5Fib/BnT9BWLxYJz?=
 =?us-ascii?Q?ulNavI9FtF81Goz8QSnmm06xKz1DDADPDTxnQj6MU1w0VPXepxQ+0v62bKyd?=
 =?us-ascii?Q?az7b5xV9Dx1tg3myiUqBIWukDMGnB0Drola8N+TWepm6oMHNeF1HE1jgQW6c?=
 =?us-ascii?Q?tf+6na0pDYpmstqD3HWlYzLYBQsJLgAYH31SCMORdAF5AgwpSY9/j+7G51kp?=
 =?us-ascii?Q?Si8f9X+Hcx3df1s0tZlh8W1fDOSpVt0wg3krMXi0LeSBX9o84kUPPbSN4GOd?=
 =?us-ascii?Q?vXmHgp6dAjJ2izpSvTG4sev0BxXytrMyWuyNo3SLAJz+6vA75b49bSAw0s9K?=
 =?us-ascii?Q?J5RSRE7S1RfHsnZcDTI8+PR2ojtf1VHiILTiQH+4MknucoS9XED52E2C0Epy?=
 =?us-ascii?Q?99DJRIdG9IrudXirpTb369KEkxoBKUaNJ/StYPYhkY78WMnSg0Fc9ENVErDx?=
 =?us-ascii?Q?u4+v8+QVIUru3sQuzBeyTCSTepxsmgOI9X6s56ZvrEGaEKUNwRZKt0ej6+S4?=
 =?us-ascii?Q?p65S6SNX8kLmAEytof9IpOyEFDpF45qAE7ihaudEB/vhwOUU0ZiYha/RxjtF?=
 =?us-ascii?Q?EcX4QvNiUVuGaZ7nIBY9OFCmradzp82BLriDhUBX6+9KQo4V61w6ttkdqySB?=
 =?us-ascii?Q?wTzNggcgWhCaJhFHDpYDYvsfQdEt36niENvIa1Ev1XiWrWeDRrM3Bell4Oo9?=
 =?us-ascii?Q?Sfqu8F+N1f+xGPa4id71bDH9wJifLN84cu1f1hmc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ce5c61-d75d-4449-5be5-08dbf5320a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 01:32:26.9674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRLHZ99cMsd2xVb07eodei0qIbbAUTxxiEFkiOaGgCzNAwICFfW1Ftof27uOw/DMAGLDsUGAR4yJgFc6gtdeng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5013
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, December 4, 2023 9:25 PM
>=20
> On Mon, Dec 04, 2023 at 05:37:13AM +0000, Tian, Kevin wrote:
> > > From: Baolu Lu <baolu.lu@linux.intel.com>
> > > Sent: Monday, December 4, 2023 9:33 AM
> > >
> > > On 12/3/23 10:14 PM, Jason Gunthorpe wrote:
> > > > On Sun, Dec 03, 2023 at 04:53:08PM +0800, Baolu Lu wrote:
> > > >> Even if atomic replacement were to be implemented,
> > > >> it would be necessary to ensure that all translation requests,
> > > >> translated requests, page requests and responses for the old domai=
n
> are
> > > >> drained before switching to the new domain.
> > > >
> > > > Again, no it isn't required.
> > > >
> > > > Requests simply have to continue to be acked, it doesn't matter if
> > > > they are acked against the wrong domain because the device will sim=
ply
> > > > re-issue them..
> > >
> > > Ah! I start to get your point now.
> > >
> > > Even a page fault response is postponed to a new address space, which
> > > possibly be another address space or hardware blocking state, the
> > > hardware just retries.
> >
> > if blocking then the device shouldn't retry.
>=20
> It does retry.
>=20
> The device is waiting on a PRI, it gets back an completion. It issues
> a new ATS (this is the rety) and the new-domain responds back with a
> failure indication.

I'm not sure that is the standard behavior defined by PCIe spec.

According to "10.4.2 Page Request Group Response Message", function's
response to Page Request failure is implementation specific.

so a new ATS is optional and likely the device will instead abort the DMA
if PRI response already indicates a failure.

>=20
> If the new domain had a present page it would respond with a
> translation
>=20
> If the new domain has a non-present page then we get a new PRI.
>=20
> The point is from a device perspective it is always doing something
> correct.
>=20
> > btw if a stale request targets an virtual address which is outside of t=
he
> > valid VMA's of the new address space then visible side-effect will
> > be incurred in handle_mm_fault() on the new space. Is it desired?
>=20
> The whole thing is racy, if someone is radically changing the
> underlying mappings while DMA is ongoing then there is no way to
> synchronize 'before' and 'after' against a concurrent external device.
>=20
> So who cares?
>=20
> What we care about is that the ATC is coherent and never has stale
> data. The invalidation after changing the translation ensures this
> regardless of any outstanding un-acked PRI.
>=20
> > Or if a pending response carries an error code (Invalid Request) from
> > the old address space is received by the device when the new address
> > space is already activated, the hardware will report an error even
> > though there might be a valid mapping in the new space.
>=20
> Again, all racy. If a DMA is ongoing at the same instant things are
> changed there is no definitive way to say if it resolved before or
> after.
>=20
> The only thing we care about is that dmas that are completed before
> see the before translation and dmas that are started after see the
> after translation.
>=20
> DMAs that cross choose one at random.

Yes that makes sense for replacement.

But here we are talking about a draining requirement when disabling
a pasid entry, which is certainly not involved in replacement.

>=20
> > I don't think atomic replace is the main usage for this draining
> > requirement. Instead I'm more interested in the basic popular usage:
> > attach-detach-attach and not convinced that no draining is required
> > between iommu/device to avoid interference between activities
> > from old/new address space.
>=20
> Something like IDXD needs to halt DMAs on the PASID and flush all
> outstanding DMA to get to a state where the PASID is quiet from the
> device perspective. This is the only way to stop interference.

why is it IDXD specific behavior? I suppose all devices need to quiesce
the outstanding DMAs when tearing down the binding between the
PASID and previous address space.

and here what you described is the normal behavior. In this case
I agree that no draining is required in iommu side given the device
should have quiesced all outstanding DMAs including page requests.

but there are also terminal conditions e.g. when a workqueue is
reset after hang hence additional draining is required from the=20
iommu side to ensure all the outstanding page requests/responses
are properly handled.

vt-d spec defines a draining process to cope with those terminal
conditions (see 7.9 Pending Page Request Handling on Terminal
Conditions). intel-iommu driver just implements it by default for
simplicity (one may consider providing explicit API for drivers to
call but not sure of the necessity if such terminal conditions
apply to most devices). anyway this is not a fast path.

another example might be stop marker. A device using stop marker
doesn't need to wait for outstanding page requests. According to PCIe
spec (10.4.1.2 Managing PASID Usage on PRG Requests) the device
simply marks outstanding page request as stale and sends a stop
marker message to the IOMMU. Page responses for those stale
requests are ignored. But presumably the iommu driver still needs
to drain those requests until the stop marker message in unbind
to avoid them incorrectly routed to a new address space in case the
PASID is rebound to another process immediately.

>=20
> If the device is still issuing DMA after the domain changes then it is
> never going to work right.
>=20
> If *IDXD* needs some help to flush PRIs after it halts DMAs (because
> it can't do it on its own for some reason) then IDXD should have an
> explicit call to do that, after suspending new DMA.

as above I don't think IDXD itself has any special requirements. We
are discussing general device terminal conditions which are considered
by the iommu spec.

>=20
> We don't know what things devices will need to do here, devices that
> are able to wait for PRIs to complete may want a cancelling flush to
> speed that up, and that shouldn't be part of the translation change.
>=20
> IOW the act of halting DMA and the act of changing the translation
> really should be different things. Then we get into interesting
> questions like what sequence is required for a successful FLR. :\
>=20
> Jason


