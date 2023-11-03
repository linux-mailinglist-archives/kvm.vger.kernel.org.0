Return-Path: <kvm+bounces-465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D0647DFF61
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 08:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A26DEB21429
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 07:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803B379C6;
	Fri,  3 Nov 2023 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g6iURGze"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6927461
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 07:23:22 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE8D184;
	Fri,  3 Nov 2023 00:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698996197; x=1730532197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bml5oBs+/gTXJJkU5ltlRBrEjrLqVfj9S3NgKsnOxWs=;
  b=g6iURGzexSc5EvbxnnewtleSZ7I+782ZYtBfQTL2x2BFwcyYYiTYYFvf
   S/G6hn4lZz2VI1hXyVc9dV89k2Qv0pAkQIxy6VsKHDtbwKI5Dxzja+V8r
   GLFnic/DUbolULCTVN1kNEg1IU4qcdyKz9Qjl8JmnTBfkVJ+24PMlRZdz
   WqPpWEsi+XEZSVyzj5gNbncbquSTGOpfEaoNEwaWEdVyvdn8hvvdGGREF
   r8lEat6fdOS27a5aYKsCmpqaW6I7oQ1W3X6NNn1luuApOVfHRPh/jckha
   uqD33QtbjbUs8J5bATwXKcONMS5cFrlMRF8pF55/6ABvrBP71PL7OXl6/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="475134487"
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="475134487"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2023 00:23:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,273,1694761200"; 
   d="scan'208";a="2690114"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Nov 2023 00:23:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 3 Nov 2023 00:23:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 3 Nov 2023 00:23:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 3 Nov 2023 00:23:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CN5LPSIwiM1fcZbjOtfi98C048ydUBYLr1ZIZm65q6+9AuzKXAwZQgvSTcL27eGHx+YrlpoDou6Bh/uIZszefoySRaMUGNxeDWCtsT0MTL+VPG/hwjbfeszCnLx/UX9m2OErNlFj/f1HgJDN8MpsU7LZn7FnJhtDjfxbt0L4fkdjaZk3BKs7F8YReRzQrl+DM4ThT6TTW3GZFfYr0dFQE1Qz6ienJ+A8Jzum7w2tr7iok1cCyvLqQOOUIjcmUuTNrYpQXbQeMhgnrQi7a2Kwx6D+uPGM0XfuJWRw5g16f8un131vhcdG/kp7jc2WChR/vPcHM+Bq5z//eoUqBgdNxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B67ryyO8Ri9Wi2xHk++PQzb9qzmJnJggV4z6kOJjoEU=;
 b=OX/V/7bgntDa5uYbZ69uD1uT4U4JcxEgrsOlFIxYlMeCVCnZzBArhkAANVjL4BlC02Kn48iT33IRuyH3HSdNWZVBnMnDDiRT8gxFqJxw2riYrp+IbdHd+u9/MBsRM87Zg6WNwaT7pMtK3CWM/jGgOiMV4sZEyC7Hi+KQz5fWUEHnzt/pdmZYi4t/COiBqTDukIFvtztSl6X+MdOQW8Z5XtnvCkzYX0/H4qnAeiKzgUJIuo5NPwkgI3+QpyU2O6ipWNQIHGLhpAZgBGvCyW3zKrKKKR0Q+qZI/3YemrefB4g2ALKKdJ/y+IGI9aZhYQ1TLYapx5TYX/O98KlciuE3lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8704.namprd11.prod.outlook.com (2603:10b6:610:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Fri, 3 Nov
 2023 07:23:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.6954.021; Fri, 3 Nov 2023
 07:23:13 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Liu, Jing2"
	<jing2.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "tom.zanussi@linux.intel.com"
	<tom.zanussi@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Topic: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Thread-Index: AQHaCPdEtaV8qeHO6EmMpiKLQ58cQ7BjhMFwgAJFzACAAIkGYIAADu6QgAEuhgCAAKTv8A==
Date: Fri, 3 Nov 2023 07:23:13 +0000
Message-ID: <BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
	<BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
	<20231101120714.7763ed35.alex.williamson@redhat.com>
	<BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231102151352.1731de78.alex.williamson@redhat.com>
In-Reply-To: <20231102151352.1731de78.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8704:EE_
x-ms-office365-filtering-correlation-id: 9326f7f1-7296-4cef-8f2a-08dbdc3dbd79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P9QyO8+IdnI2Zb8Q4mtjk90yZG/RN5ygki/+FkMICfkCeHwV7wSTwDEOoBSvTuunWYt98g8vLIutjMw8t+/m6ZlISiE5prmOWMK5rGRcsR9GqQYDX5NPZdC7hU7gKDmQgERphjE63uEVAr4Xj8VKmRjtkrpJBPYNZ1UZMmxmYPLwVE2N7kkwev1Df5AlVV8ErMhmNXUraK0UQaws4hYhaqIQvO8DCLNJMhJiwIN2pQ4MqJMYpo0oitwT1R55/sq5Gj9hxKWB8YX9Jdp/me2P+SGcgC8NpHdDDzLOdGAk3PRj4fGNC39vtDYfKfuANNjRoRVflwpjJ++zqkhY1MKzUVfxSDdnXEFEKoxUs0dx1SJPyCQXAuCg2Dhj5Qf+5TRlq2CQuq5sGOp6/KqgJxN3XiHj7UYQoSuYM0nm8UtlW9hZue8Uwjgx1IOVuwqqKTRL9V754FCU4RxKcdJF2uoSZSxMCvxubQE+nHyD2PboibiolKqbBphnMMJDmBIW5szz0IV0jDSTOXjACIhwcszbAqpXX6zHDcw1U5rFySP/5KfU8RSQZlmXNBKA6AB+/le2U/QQmcjTKeclg3fN+svyFVlxmhFsNikVPE4zLMDDomSYBKfIaBXf0JISuAp1CjJ+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(366004)(136003)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(38070700009)(55016003)(2906002)(5660300002)(15650500001)(86362001)(9686003)(83380400001)(26005)(38100700002)(122000001)(82960400001)(6506007)(7696005)(71200400001)(478600001)(33656002)(41300700001)(54906003)(316002)(66446008)(66476007)(76116006)(66556008)(64756008)(66946007)(4326008)(8676002)(52536014)(8936002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zuoMe5GrDshVgEpzRT5xmMEns9Jupd/7WX4/HtDPgiBtFw7kP9D974IZ1t1x?=
 =?us-ascii?Q?YaAG7IqdJoyokMkrKrVCSwkjdoEXcUS/B+MP78cMRA49Kei5Uh5/9Ynq3lCc?=
 =?us-ascii?Q?d3/cRIm3CD1lXzNer55c7wl6BMarEqM6/x/I8ZRD2UeGKT6DnZOebh6GXaqR?=
 =?us-ascii?Q?ewOOCO63shdK+AWJoQ4X5faUjJncO2RTY3gDlFrNOZm1VmRwIQAWVx8rTR0o?=
 =?us-ascii?Q?WISTT78Db/n0X+pJht0a6jascsSBSl7b/N354xbpRJfI/VJrRGykw3HP/oq/?=
 =?us-ascii?Q?lwsHtlpj6hdSaufp0Et+d8MEJD970Z5cWQPreLh8xod+AituWIzId8DUxXj5?=
 =?us-ascii?Q?ln0UMjrqyio99Y00VhoT3SRHKh2YqUdPNZx9SMZlFl//KZS44m96sasqiaYp?=
 =?us-ascii?Q?Ynmic1gJjd9jqi8ZQRvHXudlUEXKQZ+BEC2ekOXxcJh17Db2Ku8CIX2L2eKy?=
 =?us-ascii?Q?gWEw6AgGuOycDtcYs41a1zl2sw5iAWXjxK/oclAGxta/JlIroV6MdlDjtYEF?=
 =?us-ascii?Q?zzgqcc+OFSVkkvNikPrCYzcYgPP8DWKLkSzSlkDYniMVu+mTL0ELr4X9tDI6?=
 =?us-ascii?Q?Jtt+pKq1HkhDhAyM7sGG0p/3JHRSvc9gptl5AT0kMsarx97aMHoKU2X9Z5L1?=
 =?us-ascii?Q?0mDZF3HjIvHBQFlwrM8hs20HbtdxJwHzOs6/TWu5f7im98Zujd+/h27RY/Ft?=
 =?us-ascii?Q?wOOXfL8sqvGqpagmrHJ0fJHV2UISAs+EZZZ+AyF5cMft7GBSaiq1k8+uKpD7?=
 =?us-ascii?Q?h8jZ/j/fp7lefXxn1e7oLAV0BwZcCuNjzhAzQhZXRBtGrN3OplPLYfCXcv++?=
 =?us-ascii?Q?h9kVQdm6yLWpfQRJ6O4/FqKS55QTwIqAq7zjrvUOainnTEIz1hhdqQySsit0?=
 =?us-ascii?Q?PWN/DYckW2DaSh+gqgQxbfM5tBEjtLkenBKVd7XkHcdmuR6pxkCWaoSB8fUo?=
 =?us-ascii?Q?fA3VmgSSf4H5RWo2ilhqBAyHkQZpvku8B2bR5eQ0BlTiFj1qDVzIa0P/N2OB?=
 =?us-ascii?Q?0JkPKq5s0FvMgRu9coJfBKbROw6ZDUhenMLPzkIjS9RxmvgmV2qCAdhwthfm?=
 =?us-ascii?Q?IlKzJ+jXAGpOD91oqLaOQPMRtCG5aVAivA7z/lcMr182ki6mHL6w3Qz0EXwC?=
 =?us-ascii?Q?c/0y3sXk5+Nkg++7aVyA+JNaURFu89dF2sAO22MqByfQIG/v+RLV43jC3aXR?=
 =?us-ascii?Q?6seDFe0d6F7j4m/J/uCOe9Iy69uJWu0TMujWUzGC5Pg5a1110NDwxt4Qtytn?=
 =?us-ascii?Q?iOjqEBvHW1+fJGUkGDORvFKVqEHAPs1KLoNAOjWhbdd8BXoq5XLc3OVUXJp4?=
 =?us-ascii?Q?JBkVaX8+j5AHlsvxDbDHHLL7cxgBJmteu7OkLoT7JyhHdMx5+md/5DUmMLR/?=
 =?us-ascii?Q?eHUGaDZ+3MXu5i7wNZvz1u7gMxmHk+qcORtQ3osbhniYQzy5XM8IAN6/UYgj?=
 =?us-ascii?Q?Lb28kSN+ElAJzXtofREH9goIZW4QfOIlGxzesI6HR4ofoSIKUCbulrS4bJtP?=
 =?us-ascii?Q?s/RdmBdB860EaCDee15yXCsiw0oBxokwQUny8IMDtSOZ63Zngr7YXZ0ayjsa?=
 =?us-ascii?Q?xpRQ9NqOc9UH3GKmQXaaEyKWCZ6zzEnoapKBL+Nj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9326f7f1-7296-4cef-8f2a-08dbdc3dbd79
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2023 07:23:13.2423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dmOlffm5o4j59bUZR4YCAsm3o9N86mIDTUCmKgLkK6C7bW+UL5UCYMYXoT94u46Xbz5ltwvD8Uin3SvT2DWX+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8704
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, November 3, 2023 5:14 AM
>=20
> On Thu, 2 Nov 2023 03:14:09 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Tian, Kevin
> > > Sent: Thursday, November 2, 2023 10:52 AM
> > >
> > > >
> > > > Without an in-tree user of this code, we're just chopping up code f=
or
> > > > no real purpose.  There's no reason that a variant driver requiring=
 IMS
> > > > couldn't initially implement their own SET_IRQS ioctl.  Doing that
> > >
> > > this is an interesting idea. We haven't seen a real usage which wants
> > > such MSI emulation on IMS for variant drivers. but if the code is
> > > simple enough to demonstrate the 1st user of IMS it might not be
> > > a bad choice. There are additional trap-emulation required in the
> > > device MMIO bar (mostly copying MSI permission entry which contains
> > > PASID info to the corresponding IMS entry). At a glance that area
> > > is 4k-aligned so should be doable.
> > >
> >
> > misread the spec. the MSI-X permission table which provides
> > auxiliary data to MSI-X table is not 4k-aligned. It sits in the 1st
> > 4k page together with many other registers. emulation of them
> > could be simple with a native read/write handler but not sure
> > whether any of them may sit in a hot path to affect perf due to
> > trap...
>=20
> I'm not sure if you're referring to a specific device spec or the PCI
> spec, but the PCI spec has long included an implementation note
> suggesting alignment of the MSI-X vector table and pba and separation
> from CSRs, and I see this is now even more strongly worded in the 6.0
> spec.
>=20
> Note though that for QEMU, these are emulated in the VMM and not
> written through to the device.  The result of writes to the vector
> table in the VMM are translated to vector use/unuse operations, which
> we see at the kernel level through SET_IRQS ioctl calls.  Are you
> expecting to get PASID information written by the guest through the
> emulated vector table?  That would entail something more than a simple
> IMS backend to MSI-X frontend.  Thanks,
>=20

I was referring to IDXD device spec. Basically it allows a process to
submit a descriptor which contains a completion interrupt handle.
The handle is the index of a MSI-X entry or IMS entry allocated by
the idxd driver. To mark the association between application and
related handles the driver records the PASID of the application
in an auxiliary structure for MSI-X (called MSI-X permission table)
or directly in the IMS entry. This additional info includes whether
an MSI-X/IMS entry has PASID enabled and if yes what is the PASID
value to be checked against the descriptor.

As you said virtualizing MSI-X table itself is via SET_IRQS and it's
4k aligned. Then we also need to capture guest updates to the MSI-X
permission table and copy the PASID information into the
corresponding IMS entry when using the IMS backend. It's MSI-X
permission table not 4k aligned then trapping it will affect adjacent
registers.

My quick check in idxd spec doesn't reveal an real impact in perf
critical path. Most registers are configuration/control registers
accessed at driver init time and a few interrupt registers related
to errors or administrative purpose.

