Return-Path: <kvm+bounces-15037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9019B8A8FCC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4710E281CD4
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D295710E6;
	Thu, 18 Apr 2024 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVZ0DVsg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB08370
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 00:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713398823; cv=fail; b=uXtdCLVolaOf+OF+FfkRuo2pU42iUK0yVtvYI9cfgsxQNk5311RBoC5BAdZVhAtUgOGoivskfGzewNn1F6e96gc9FAHi+nvvjSTl0HqY9ws1kNLsWev4rkdr5dZ5/AIb2NqoWDVOrtMhowo0E1K/PXT7MqiZyuxCE4ugSTh3duw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713398823; c=relaxed/simple;
	bh=v4jaM4dsSZR8m84bx0XmaXxT4QuD03/Kwusib5Od0yY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NiAIBZQG7PHOFR9A1MPbjmd+FO5xAZdWSaDikFEd2X1qV9xXgDq7MkOKEMK9NIO0yoDtfmEMUgiBnktUqLwAdIylZsH8PY/Iz9WRDg9ndJPZzwbDkJRhd07pGv6Q+mr7OgrZ97LQiBtEiNB1I+DlkglgK+jGdaaF6Kj+cBUK9QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVZ0DVsg; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713398821; x=1744934821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v4jaM4dsSZR8m84bx0XmaXxT4QuD03/Kwusib5Od0yY=;
  b=XVZ0DVsgmAyVmveFOYrvX1Zwqf+ywz3+oXjEgkE/57OIPyTgMgCKexWD
   wlcYg1cNVF9peB68QOOBXTT2VEE/BRPRtswuGIU0cTuee/ZlFh9PuIN0b
   npPXCwOtrkTR/B0PA/B8Bci3WwHbmTejq2eAaPnDC3NbSfhmJmp5vTele
   qLwp2QnqrBKbAYV8m636Ed2kxPFSjUBXp34fbhl2xK8lTTcQIDAhVMp/i
   XFJhT7VNDqTlrQj68Qrzd/SCvX4NV5FJ9jkN8XvtF4mTJCrT/2a9E6bv9
   A5u7OAxDJo6bQ/yzDRXgfrhIIfkNE2O7GccRKHwEniTPNjm77Rh6OBZOi
   A==;
X-CSE-ConnectionGUID: u7YDt/bfRNKuNX5TstMFWQ==
X-CSE-MsgGUID: 3oXVXXKPQFqme7YiU+fc5w==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8783758"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="8783758"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:07:00 -0700
X-CSE-ConnectionGUID: sqyXqa9rQjiLXHYDWUf0dA==
X-CSE-MsgGUID: JtqmYPLQSl+9QbI8JD6p/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="23225279"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:07:00 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:06:59 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:06:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:06:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksIoqg4lOL2yCr8KG6znh0Bxs/tl88KM2biLHHrX6HGdFQrWhHYyCEVixSjThsvYG24ynfe2Ju8YR7Fn4thLAM1/fJJJ6XFUppY4DiYDRE0SNiqe8qa9e3MHRC5HQbgsoGkt0Td09umQISvJxmbeJr1jOjPgegeF3WnwbjkPjfMhpKb77icLraJBf8SgWxcP/UaYZJK1baRfDSnbrAc70B0Ec4mAX5wLX0qf1BZZ57zc4dporMJEi84gMBBB8YMVltFb49p6DzuWdxOlK6LlhhU3slqOmID0lh07gxHItwH1tHPkh+o6DDJO2OnVTpYaMRPVEUnHQQOVo82t8vh0XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeJ37azg786q0OUeUAWYb5Pnn4tyMGjPHmpsNaUZPwk=;
 b=lVI1y+1bTAB7SywRwO4lgzw5f3yRsEWEsBZaJx3MA7IhAaCVQrLFjIz5Qcstc9wtvFcWISkfiJAu6fEJv4aIraKaOXEzF+6QqgJhGkeBpoQv7Tezs+C5k/jQ+k/y2d068PDkN5PfYcebbxCCX0vFvUZkh4B350QlMNmQ9F79RYHnyGUcFwnroV0XKNs4yePQwJpNs4AcDplCKDdAOhDgu95zZXhlarExkE7FvOY5iYArVwHbyxXyZCm1CjOLCJOyvmeLO3sDpfT6syjw/W5Ye6rCdLnk5ULF4rxAhRWq+8jGky3Jg9x4ptzo66uPI+UMVaoVZoXqZvfhB+yjdknbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6195.namprd11.prod.outlook.com (2603:10b6:208:3e9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 00:06:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Thu, 18 Apr 2024
 00:06:57 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMA==
Date: Thu, 18 Apr 2024 00:06:56 +0000
Message-ID: <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240416175018.GJ3637727@nvidia.com>
	<BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
In-Reply-To: <20240417170216.1db4334a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6195:EE_
x-ms-office365-filtering-correlation-id: 83df9408-adc2-4534-445e-08dc5f3b7631
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cg4VjfxZ7v2NRulzcQQH1Sn+Cos2COpPEH82IiQ58HV2k9bL2r/C2OpjxZV0K4FkLNF+dSYEET4Pe2hAJmwl6l+AArpPA6/ScoaZHDOrMXuSjYcpyli/Mzo3dklfnSKtAqNyR1iF0Rf4dWjruXvKDTSx6g4b4kxKK7hNKr3zzrdZTisyHG8bvYL/dbxbXgvwMNRsWntN54myaIKVMzbgMWnwpDC40thh4xBLKqJxhW/iCf0y+117o8LVlJqdJ6W4XusnUoDu/VFuZKiEqWLdWEOQyLhE8W6gQpX4r9CM2D3H/WUbVywpvx/7x3Sh3hF+XSdCGpj6a15fe77YDEL/ncQdqqIgKP7lFADdga4ySV5oql/NLvpKG3fdJ/o1y89sCyTTTvza3wQ+f/HS2SB8CqkLPhBNuLkxRY8Aku3Iu3Hcta7PPsHOB1wxNMl7Kx2SlY7HTxNn8jsHNuQFbcRvYQDscoMgJH1bizExgg1ELiYGVrtBkH8gITYD6k4qK6zBL1sfC5/q/6pAFKr1+tJIJIHUxwE/CCy+5mAFNFaOxn6vC3YwzBUzDWzCyH4Zo/ehPlgW5xY4apCEvxyYs8A31fz15uo30xWfq+wMDSgocJxRjulagAWK7KX1H3I9pFxR7G9w2bWjhPIRBwKPLJ5/uH/MZsdUDkWJC2jkij0nuEQgDHb/HmB+C9g6r1iMEhKj2hCK8CrM1QhQ9ms4UjDmz94WX/4OMHAMFsCprlgtJrY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4r6YoWP/YezrSQvkn0NAa+HoR6ubsYWbKEWMNNMzP2qHO5zLAQj8cFDu4ydV?=
 =?us-ascii?Q?IuR52blvL++tb68gX6B4nsPO0WZxD12ykXuNrHaWJw+lCCd/jEBTAswJ/GyC?=
 =?us-ascii?Q?hGtprqYNPxdbID4OGS4xij3YTnTFTKnZMzn2qj7Q29jbeIxR1UXR4zcByVno?=
 =?us-ascii?Q?bXZU1pv7uCieYN8icWuuxzU9SB5g4fne1bibEr9UgGjKgsMLsY0bX33rzgD0?=
 =?us-ascii?Q?wSH7NIMqLpivhXEU/Ol7DfNCHozsbRklYYFrvfgjKbt1zm/CjvKPGAqv93sm?=
 =?us-ascii?Q?cqYJVxKhlB7Wr5QfHKNlxwEA7/UbafqXCB8MKk4p8L+E47zIytA5zGRwHNSY?=
 =?us-ascii?Q?/3RdWYHaubwkFTg3zB1WOLEzvbyPIbm4rhm9867pjysvNX0pSFbbtzZzz3jS?=
 =?us-ascii?Q?WTqkoWVgv2cCkMKUZUHGpDad0LUBsXTcSzp4bupVbdhpHKCnJzMV7l5YmCQN?=
 =?us-ascii?Q?WEl/XsgQfrgMfCzpSc0EUWYOScVaqQGL4zUHbbbt1S3sgrUYbZ+fKv60jACa?=
 =?us-ascii?Q?vg1eT6AFTf4uh8jyT//Tt/wWvVLk4oU4epg172SEhATruuP/BKYPm1lLf+ZN?=
 =?us-ascii?Q?6NcehgLUuMExC85KKJg7pbphXXkH/ee6LiUq81rM1VxU0xoogyssQ2JHL/Qy?=
 =?us-ascii?Q?YUJzg71/jmrjYyWKxCsrQq+JxN0H+SkROxZvUiocIYZ4/4X/fqCQl8CkNPES?=
 =?us-ascii?Q?ZvXAiRJdrMDsr1+rv4gRBJl/4+NPxDmdd44dHDaEFlLgpZ+bihDE+Fx1EnW9?=
 =?us-ascii?Q?BU2ZFa/PNN9pUy2hi64/+eDQfRHaLu9fTEHTUBW5+zrMad6WSHc6pxOVDpff?=
 =?us-ascii?Q?7PMx3A9RSbZRmEDkehetO4uz4PXADPyUB2oUPVLvjDqMX26a8kI4EDZKqdXN?=
 =?us-ascii?Q?xRW1ZAylHCHR7vrBX924z41MyZyx5Zae6PK79Pr7atY5/ZN77GwLTgymYnZo?=
 =?us-ascii?Q?G5V/KJWyvoqN50I1Sy6EYItfpyfi8GaMUSIuvncqLSm0pZioTljM1ZzX37//?=
 =?us-ascii?Q?WCySWWe8vBbjPu/15HMLm9WMql9RiUH8crtGPdQKVXKc5+I4TUJAiCWxSVYj?=
 =?us-ascii?Q?h/QQp+h4wcI4T70QUf64jRS8SYJsHvuytdK6gGfEIRNS9XWI0IKgCi3xSkSd?=
 =?us-ascii?Q?GZgPjB0z+hx+aGZF4Zct5EtMoQz4Rnqbnkz9yiuf3JnUOIqe9tHEJZvNFZ6U?=
 =?us-ascii?Q?b1lJf79yZOZkvGqEuV/bYSdxdkPd73nXd3jd4ViZspvVLih4oe1FPIPHPfF9?=
 =?us-ascii?Q?2LjawaUtQqIcaCCyd/VL2mnVMcwcncboKIGW6fHMX1x5DJA+dCAL5EdRezFq?=
 =?us-ascii?Q?sDFpyTIk9HTxcyvnurNk7S7YPmfCDg5VBsH8oSX2nd8Ln3uSdstI1b1R9cH/?=
 =?us-ascii?Q?6FroSe7Q6MBbMc0Y5skQ370ZUsBeBx0onqH58yxwZHq1LDEWCcgEgYI5hwh+?=
 =?us-ascii?Q?Q/g5LY7H1O5yqt6wJgkRIvlXT9xl4W7xkhveEuDm5Duh7kfyD8xU3hKxMY3f?=
 =?us-ascii?Q?7VUQuVAwiCz/HbLRlZyIUQ7ny3G6gMasJAE6BnkQg4mubuMk/ftLBqp6E6+y?=
 =?us-ascii?Q?5votaL+7IuS5C8qzE3uIixmI/8melHnnN+Y6d+/G?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 83df9408-adc2-4534-445e-08dc5f3b7631
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 00:06:56.9837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SJwQmg7Lim4Im1WSQAbACxDYIg6YGID0a8j5OcQwd2R1c26GbaZlYkFO9tqbmFDN2/sh/JlmKubFSeetYSWTJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6195
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, April 18, 2024 7:02 AM
>=20
> On Wed, 17 Apr 2024 09:20:51 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Apr 17, 2024 at 07:16:05AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, April 17, 2024 1:50 AM
> > > >
> > > > On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:
> > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Sent: Friday, April 12, 2024 4:21 PM
> > > > > >
> > > > > > A userspace VMM is supposed to get the details of the device's
> PASID
> > > > > > capability
> > > > > > and assemble a virtual PASID capability in a proper offset in t=
he
> virtual
> > > > PCI
> > > > > > configuration space. While it is still an open on how to get th=
e
> available
> > > > > > offsets. Devices may have hidden bits that are not in the PCI c=
ap
> chain.
> > > > For
> > > > > > now, there are two options to get the available offsets.[2]
> > > > > >
> > > > > > - Report the available offsets via ioctl. This requires device-=
specific
> logic
> > > > > >   to provide available offsets. e.g., vfio-pci variant driver. =
Or may the
> > > > device
> > > > > >   provide the available offset by DVSEC.
> > > > > > - Store the available offsets in a static table in userspace VM=
M.
> VMM gets
> > > > the
> > > > > >   empty offsets from this table.
> > > > > >
> > > > >
> > > > > I'm not a fan of requesting a variant driver for every PASID-capa=
ble
> > > > > VF just for the purpose of reporting a free range in the PCI conf=
ig
> space.
> > > > >
> > > > > It's easier to do that quirk in userspace.
> > > > >
> > > > > But I like Alex's original comment that at least for PF there is =
no
> reason
> > > > > to hide the offset. there could be a flag+field to communicate it=
. or
> > > > > if there will be a new variant VF driver for other purposes e.g.
> migration
> > > > > it can certainly fill the field too.
> > > >
> > > > Yes, since this has been such a sticking point can we get a clean
> > > > series that just enables it for PF and then come with a solution fo=
r
> > > > VF?
> > > >
> > >
> > > sure but we at least need to reach consensus on a minimal required
> > > uapi covering both PF/VF to move forward so the user doesn't need
> > > to touch different contracts for PF vs. VF.
> >
> > Do we? The situation where the VMM needs to wholly make a up a PASID
> > capability seems completely new and seperate from just using an
> > existing PASID capability as in the PF case.
>=20
> But we don't actually expose the PASID capability on the PF and as
> argued in path 4/ we can't because it would break existing userspace.

Come back to this statement.

Does 'break' means that legacy Qemu will crash due to a guest write
to the read-only PASID capability, or just a conceptually functional
break i.e. non-faithful emulation due to writes being dropped?

If the latter it's probably not a bad idea to allow exposing the PASID
capability on the PF as a sane guest shouldn't enable the PASID
capability w/o seeing vIOMMU supporting PASID. And there is no
status bit defined in the PASID capability to check back so even
if an insane guest wants to blindly enable PASID it will naturally
write and done. The only niche case is that the enable bits are
defined as RW so ideally reading back those bits should get the
latest written value. But probably this can be tolerated?

With that then should we consider exposing the PASID capability
in PCI config space as the first option? For PF it's simple as how
other caps are exposed. For VF a variant driver can also fake the
PASID capability or emulate a DVSEC capability for unused space
(to motivate the physical implementation so no variant driver is
required in the future)

This allows a staging approach as Jason envisioned.=20

