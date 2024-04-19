Return-Path: <kvm+bounces-15307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 427858AB16E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED8EE285A64
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029F112F5AE;
	Fri, 19 Apr 2024 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="artggHeX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC612F39A;
	Fri, 19 Apr 2024 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713539553; cv=fail; b=Ve9nLP1LK9kbvFA6aDTSEY0vC+HeOc2BTlypZLDGh7ftM23MLOBPkg0EoJKYLfwV4Wie8KkpYKnoiEXY/0M6FqeD1vts/mWRF1r4XK0Yn5eHmero3Sy34S9+NXi1uG6ttrDtnSUWZGOnuRixe5XkrNgX6jALbbDgn6F8D4XYsy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713539553; c=relaxed/simple;
	bh=NFzKyR6Ef39DNCwnXH8fy/8S+UpSMOMtNnShXN5cjpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SnDZQAdHdc231B4678TaPI22x+OUT4J76FRtKhPb2fafoVBeaApGzxvJ2UqdInoRbhYSQ8/0P+uQqgL6VwElTpb3t6cU1M/bb46UQ/VCxgd0FIiSMADWcbC+jcF/k5iX/jU/+NuuKY7AZcgshDgLc0mY7jPqg03fFSMd3GKOV34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=artggHeX; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713539551; x=1745075551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NFzKyR6Ef39DNCwnXH8fy/8S+UpSMOMtNnShXN5cjpg=;
  b=artggHeX/KF7anRNzDf/He5tBDY45NDCoPJFQDYJOUlCjkcULdqF6vOW
   z7hXNCST/SyrWR8zH+ofu5AOOm/fOqYY7rWpSnS898Qqw8fM5TCZ06Lez
   U3JW6lNtAdEHqPnrwGam6p9K8eR2uAkMzi6/5oczV8Zhhs9REUiaeBMXU
   Ow8lxtOn8Eu2ni/EemjtMHDk+d1StgUp/ThZiDWHfVtxZeJAanSTVnAN7
   Q0vGM4HWNJ/G0H2FtjDO1pj2fPz8p4wHZn4xWV9bpjFrJkAVV79GUgdBJ
   R62E3daplO6UhFhCuvkZglvUUKntAcydNhRN8ubTpXEDXvXTbVDPx19ZQ
   A==;
X-CSE-ConnectionGUID: QddPwMagQ5+HgaWs5PF8Gg==
X-CSE-MsgGUID: XlicRoJyQIOp/g2L6NHF/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="20536378"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="20536378"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 08:12:30 -0700
X-CSE-ConnectionGUID: g0/LVzlfRtmHMitSxH00tg==
X-CSE-MsgGUID: E4eFidYSTYOSLlIntv+Ncg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="23800879"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Apr 2024 08:12:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Apr 2024 08:12:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Apr 2024 08:12:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 08:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oI6uYWPkXIr5LVLACCPsbLukLA0GlLlPvd8FEx2vMTl7ngFIfm9Zv2qH9/cwuk3+mC2YrrFWUKQzI751XN5BTFKRZ/oH2cWdvsG+ZVJqIOr8GIr6ecNN0Jd2HEB1r+iXAAomDWYXhCNf9lf42ZibYMg6U4s82vqCWHIGu9N16qcL19I9JC3l172VHewVHnGUrRocHB2uU7SrhDxjG6tE+iZaclOkdxGiGhLAWmHd+jiiAQkjw3fKgr0/4iI1G9op1ZkWM5qyNFUg3qKpE4OiSMfq8CUOvSxr4DCtxJvqNuJP9XAkEr58dGtPoAdYsPsPgzpEPivYINTb+NChwZ9f6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMlMLhs+yzSvYJvkGb/7Wnekaktr+YNmsstLxPMG6Ww=;
 b=N412Y2kUoX9ri2VweyTQPpXObCxDwcTcm7vdzgQPAY99mJ6KVtgbDHnfe9wPEuj0NBh2iOD2m/t1SsC5QnAslM4AMp9O9Ydou2Se/fTAt4OxTJPxmHZhozsVP2OQ/MqeQ4Tpd0jUt2ZYZ3ubx518qCo5lTgOkqUex58Jtksm8FAPP6gv3oiLYArZKin0JoEw4krrGcwyUR4kXi2ibtRp6exYtZy/sfVg92cKBxQV40zP/MnwIOtNWABQF+Ni4JKws3scbhICIeh+sdpWoYrtkSJNYKyPua1q27ll30TAfOiXVGtvmOpQWbpDlFoCyG0T3ehxan54qi0AKhSeDNydww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB7593.namprd11.prod.outlook.com (2603:10b6:510:27f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.39; Fri, 19 Apr 2024 15:12:27 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.010; Fri, 19 Apr 2024
 15:12:27 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
Thread-Topic: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
Thread-Index: AQHakkz4v8XEzjLts0GEpU850B7z97FvmgoAgAAKIQA=
Date: Fri, 19 Apr 2024 15:12:27 +0000
Message-ID: <DS0PR11MB6373D059F2BB9F196AA9D503DC0D2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240419112952.15598-1-wei.w.wang@intel.com>
 <20240419112952.15598-5-wei.w.wang@intel.com> <ZiJ0mjZxlRsLwl3E@google.com>
In-Reply-To: <ZiJ0mjZxlRsLwl3E@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB7593:EE_
x-ms-office365-filtering-correlation-id: f4f4239f-42b5-4d5d-88cd-08dc60831fe1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PvXa32IfWMzJtWQ/p4uc+BZwobjGzCqJhSOlG8si7fq1fA0dMiwm38590s4q7a3iqCESBxL1l3fBSbF3VPYufeW3/2vGPGAUtJhOOF24Q/3q8OVx46A2grBTJaFd4OtM4fmnfJ4uLmXckyLOdYuU+I5DfjKVUWwCLCGzzYmt3LZMxY3fL2S3cS6T5rt6JjfjzMXI/A4w1bV4Mc0UTtpdVh5oLPUtPdWn0kA5j0p3Cxr7OasLrHiFI54INJlvXAZiDehGh0sow4kme7wxJq77rdkACugOuvUQJBe/OHZE0L3CYnkZf/0cEzc0GsnfiK3h+0UJqWZ963jX8MAgpfkIvFekhC45lFQSgNP9m4b80On6FmrKj7iWvNMyRDrTxLHVqnbWtsZ8MGBStfiZB2AcMUR8t9LCzWnp9rrCP4O+Us20UgvS3AF5dzK6Zrt6x1N00Hax9bEtmLfK+QzoPT5/S0seVnwxYB4f59Z5W5l3FAz6Q4QsjFOuynDO+nKiaaK5B9Ivjdv+/JTIxbwzV1CD184+LYeUkS66/FioqhwfZCNFHzAsonJl8vtYr7QqwBuWLnkO3KfdI6tsdYZRkxBxrwE/4dSDd3rEpgvlDyDKBWporBKXo2seJQWzWaDJShTLjD4nZdHzmyaDVxM9bKiycF8lkR6cAroMj2u43zl1fb0/8MySWbsPb51RDOJFCEkyC2k3xMKKQXPjMpGdD3hEZVS9mExAq1HqMOlHNBt0A6Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DhEFUuBnnu5qvvTSHsxndk8jMLSwAJ0NHZ25rmXx8YWWhkP0lc254Ng7ng1t?=
 =?us-ascii?Q?HLlWYo0u4YDBazxh5lPyI/irIN3LyUFG3Osj9Iz439IcfGu+zHlooNZhtbp0?=
 =?us-ascii?Q?tFQnq3fiNs0QeEvVOn4EP8MZMk3el49DYRB5GD4o/yHEh2LyIeVV1eBFUq1X?=
 =?us-ascii?Q?i11nVTdXJrlVVZuPB+ZW45jI85nW3HZvInvO3duMq7U/iprw67pQo8h7RUmJ?=
 =?us-ascii?Q?VtiRjK927TOQ5Bnptd+i7Z/VOuq4Y6IDuUhSCSJ5W8SxDrDw/jPt0i4EN2SV?=
 =?us-ascii?Q?/9aE0iv6X0LmMxv2e+aaS8VRFVXsFabs0BbBxNsh/YqZmc8yxrMoolC8Xu2k?=
 =?us-ascii?Q?A1iecE7LCld84srnsQSylZG3Hewv8KdkFfZ4LPExePL58mxpirK1UHxJmFHe?=
 =?us-ascii?Q?f5LuvN321nLr5gJceLinlU7hHPOvUzJYBEI16mQvylSFcYCr0aqSDOT3TMp/?=
 =?us-ascii?Q?lcK68jYSBmK6I3QsMhSaJq1B7wANKTwgcSnPH4bSN2/DzINBNJtaPqlqpCVe?=
 =?us-ascii?Q?hUJWlRoLkshC2AamBGIv8wT8hdSUd84tO4WHdEx4x5/bAakFNXiXaOvnFzYK?=
 =?us-ascii?Q?TecZI6+s1layACv0+xEOBepP/IVK/c/AcGf/7IvSAnaxlxBJlNbsWknXqlWh?=
 =?us-ascii?Q?bV4i2ioBGU3YHLH3Mg3NAIKxom1YQNT32PsnTgEFlVqBI+Q3iYErvBXTj3XO?=
 =?us-ascii?Q?nBn6ieXDYw0faNXIsTkIBVCmbx5vimogWMrml1wKYpvbBL7qSmJZHJSFkSxV?=
 =?us-ascii?Q?DJhoYZvqU0BpVmzZkg1pvjaXdJYl+lIfWxUqBq5aE7q6+pdmQSHKFW+ByXMB?=
 =?us-ascii?Q?jMEAxopUug7GGMPwD7Ho137n70/WFRve0WJTRNRDCb7lWZeYjbvAzqReybeJ?=
 =?us-ascii?Q?/BBJUkfP3yOkJ3xwc8nYJtukxdYMpRSJ8bgdo4WDvEaM8jsTadRn1jmB2vld?=
 =?us-ascii?Q?aDTTO/pto+mutBElaKUk2EujrGoj+5edIDloeXA+sBAhIZBXx45uC/W5pT1L?=
 =?us-ascii?Q?NOrHcEkomWJSGwhB8GY+IKDH2Ak+4T9pZY1zhNdKLQxR74uqDzARTTDiwbYw?=
 =?us-ascii?Q?chGITlPs4VLS++JCtNkOL9NOAxVcm6ywrHaiXiJ70b0++GLUXcPY5wV4arJ0?=
 =?us-ascii?Q?tm1Bd7sCgJxx5q0IpzXRqPCjdsujONn7iqUawBEbrryRVd6r6G8HIhXshzdW?=
 =?us-ascii?Q?4LU5Paw4PzMb5gNM0+PwqyUa1KfoRn8apa3N3186Jj7lkxnqsvFq7Y6I2qT3?=
 =?us-ascii?Q?k77OajQadG7LCxLSxaynrCD9K6F/cokdRTB4QJxxwOQSILgYgaYl3q95+fYE?=
 =?us-ascii?Q?psFX+2j/YWaaAhjWaxZW9mJaVwAZ4hlW7PGenxz+UXMiSVuc2KQ83iLU95fO?=
 =?us-ascii?Q?Z9BoYuLj/3zO/wyzRO62o0nu4fSUhKiZztmGBo6dYABbrIMPa81fagucOB9i?=
 =?us-ascii?Q?+/j4jWZpDb5Ng3Ltbh6DAfcwe1zx9tqS12ZaUyxJ0hU8TdDKSqJLsPsnWFCt?=
 =?us-ascii?Q?hQfbBPBBo2jKwxYw1d9dAB3DTQ48JvJPKrZKEURTZwprqpANBR933rLl+EFc?=
 =?us-ascii?Q?dzCidRo2LR7V5emdmtDuj3D1z8pygblC2VXqoDp+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f4239f-42b5-4d5d-88cd-08dc60831fe1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2024 15:12:27.1472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ofzbtn1LX0ln3HVuMUz95Eqy59sEftl4dq082whDnk++Ps+x0UDfQHIFOL9Nkuk30CeP+CSMwUcOyNCXQ3FLsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7593
X-OriginatorOrg: intel.com

On Friday, April 19, 2024 9:42 PM, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, Wei Wang wrote:
> > KVM_X86_OP and KVM_X86_OP_OPTIONAL were utilized to define and
> execute
> > static_call_update() calls on mandatory and optional hooks, respectivel=
y.
> > Mandatory hooks were invoked via static_call() and necessitated
> > definition due to the presumption that an undefined hook (i.e., NULL)
> > would cause
> > static_call() to fail. This assumption no longer holds true as
> > static_call() has been updated to treat a "NULL" hook as a NOP on x86.
> > Consequently, the so-called mandatory hooks are no longer required to
> > be defined, rendering them non-mandatory.
>=20
> This is wrong.  They absolutely are mandatory.  The fact that static_call=
()
> doesn't blow up doesn't make them optional.  If a vendor neglects to
> implement a mandatory hook, KVM *will* break, just not immediately on the
> static_call().
>=20
> The static_call() behavior is actually unfortunate, as KVM at least would=
 prefer
> that it does explode on a NULL point.  I.e. better to crash the kernel (h=
opefully
> before getting to production) then to have a lurking bug just waiting to =
cause
> problems.
>=20
> > This eliminates the need to differentiate between mandatory and
> > optional hooks, allowing a single KVM_X86_OP to suffice.
> >
> > So KVM_X86_OP_OPTIONAL and the WARN_ON() associated with
> KVM_X86_OP
> > are removed to simplify usage,
>=20
> Just in case it isn't clear, I am very strongly opposed to removing
> KVM_X86_OP_OPTIONAL() and the WARN_ON() protection to ensure
> mandatory ops are implemented.

OK, we can drop patch 4 and 5.

Btw, may I know what is the boundary between mandatory and optional hooks?
For example, when adding a new hook, what criteria should we use to determi=
ne
whether it's mandatory, thereby requiring both SVM and VMX to implement it =
(and
seems need to be merged them together?)
(I searched a bit, but didn't find it)

