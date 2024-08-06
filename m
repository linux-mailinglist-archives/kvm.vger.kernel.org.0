Return-Path: <kvm+bounces-23314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C23B89489F3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CA3EB24146
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 07:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186F91BCA09;
	Tue,  6 Aug 2024 07:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hTD8KKh9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8A51BDA90
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722928765; cv=fail; b=LswXvhtBbuqzW5e0Dtc8b7MgpGWSweljv7DZuIhPt6GuZwzAWxQdMU3bdhR0MlN931IQsd72SaWdbuFzadfjWpT6PDkreRTCupnLU3KLPovZuOE/Mw1psWoOgIfpXizotFRA4hdPEkQfo+FZpVITRD06NZitOY+j78LFyfa1S7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722928765; c=relaxed/simple;
	bh=QokclGt4yDJAHnHkUaJDSR26HeaIctEucHc6mEK32M4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mqk1D3z3qikzJdaClfxOXMZNZWOutIxhn0nmU645oSFCjrlT0qpf9wD9Diubb8jC43gCK++Rgp5Lqs4BsNRQWRESHKkoKV7nfLdJIM2hCZvNbQfNjmjF0kbrb/jKrnnE8gYavN9WmFcD+agOBb1aY2mCg5bC8isEA21Sznqibu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hTD8KKh9; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722928763; x=1754464763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QokclGt4yDJAHnHkUaJDSR26HeaIctEucHc6mEK32M4=;
  b=hTD8KKh9eNLJkF4sBj/vdP+QKa1ok38fLV4eGVIi1L84958XvSoqpZox
   FayHG2bCKRzHMNiGmuv+3BYh7Cz41StaLjZvpX6eoRBwDobSjy0l8sFpE
   2TNehNQuHOjHx0USVbRNleyfv6uk9QmstBA6mWFQOiy9ag2MisIMeHVS4
   42hCEOxvi4dWHBgeZLI64xbx9d7jbz1uCQktG8OjILZyeBsQoNheHNbCY
   gHa/K7mTzG1iIi65yl8cENwmZsDvEQGhTknGgXMwdt0aN8wWfuseM3zgu
   UcuooX3AKiZX36n1ZKDKMsiA6U+R8bfRsMT8ULn5XZU///hPPgNpBENIO
   Q==;
X-CSE-ConnectionGUID: Ytom4boKQVSO0NKm8XIFaQ==
X-CSE-MsgGUID: KCb/XILCSWSZBiymB4DfWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="21104824"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="21104824"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 00:19:23 -0700
X-CSE-ConnectionGUID: qEO1x0c7Tka8oClVU3Wy4A==
X-CSE-MsgGUID: KFB+rkodSVSni0MZfoolaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="79675377"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 00:19:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 00:19:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 00:19:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 00:19:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 00:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUGe0lgzHem9KlKLLoIQJ/6VPSNQqmF53FL6iLquKC3Rty8MUhkbRdzKgxMpp4z18Wn5/qeIXXfa83EO+SAlIpg6IfWYGE5/512cRIcv5thXJe9Y8N2dVPpQpEtnGvJ2ghP842P8yhj/LO2Cq+yP2wx/bZQB4FxqljFDJYp9P4xZiVwB/8qp4TOC5nUKxq71yW+RvX0N4iKYN6mKY4J9uOuriYTqR6/bDYhyieWQD7Ki7auCqZC6E8ByKBAIjSHfWni68HRjMSEM8Yj0znm+EJVdp7DhquBFref+P/IC/hiQj9bTeD8+6Qkal75V4OUpiN9X+eVsEq+1aL0qC7Yl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QokclGt4yDJAHnHkUaJDSR26HeaIctEucHc6mEK32M4=;
 b=J3akUgorBNHgGLzwdc1CNcXdp/ybNuhyDVkmyrN9MEFZgYzhCikjtfAfUCapmLOI+0nt/fwUmcpiK4Uf6ZdNFwmTIG0JoJ0nRoUBbEQfA1+R6R4ZdM6Cj74XItRozw39yB7seWGPDgh9qwlGi1rF+zoJnKIJPLR8cLEP4D4F5o473yJFeYJT7g+lDV8eHRZb0D3KQfjfpnYinzdBL8Nj18HBy/4ZnFj5Dl3yTW6dD0JzMKtbEV5rYSPC4Is+ya1AJ9bZo3/HJR6fZ+fsi80lsa7Ip4/kt/rGlu0ZrdLBwmjGgHQblufBxCCvYqhaIWvAalHuDCDWirH406FLS4y/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7873.namprd11.prod.outlook.com (2603:10b6:930:79::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 07:19:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 07:19:19 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Keith Busch <kbusch@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Keith Busch
	<kbusch@meta.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH rfc] vfio-pci: Allow write combining
Thread-Topic: [PATCH rfc] vfio-pci: Allow write combining
Thread-Index: AQHa42HtgQ6o01Pjn0yufS55gLKnfrISdM4AgAAW9ICAAAhqAIAAC2YAgAAGCoCAAAWKAIABXYyAgAACW4CABcySEA==
Date: Tue, 6 Aug 2024 07:19:18 +0000
Message-ID: <BN9PR11MB52763F2A0DB607F9C2BB97928CBF2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <ZqzsMcrEg5MCV48t@kbusch-mbp.dhcp.thefacebook.com>
 <20240802143315.GB676757@ziepe.ca>
In-Reply-To: <20240802143315.GB676757@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7873:EE_
x-ms-office365-filtering-correlation-id: 6d43766f-bf3b-4fa0-c9d2-08dcb5e8163b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?JEyvuaB8xe9jLwedBNykWTsbzl0zH8xub6s3k+HZZE5QmMFxJs5ZLFT43nFL?=
 =?us-ascii?Q?X/oN002LFawFTUMEcRZchmEtuSohCk+tqA4bmiXvf0qupT8ADRBSHEUSGGzS?=
 =?us-ascii?Q?u4ZoAAck5v9daob7SIawG2YmT5p30CWHcrdEIiJ04AC35bM9nhbYspQo0rD8?=
 =?us-ascii?Q?BAdN3sv14ICBECvO6hIQ/qDXoT5YUymmt4PryZ88lLlmlR5lMUUSd23p84KK?=
 =?us-ascii?Q?8IOV9ZLgeJcTBqlnGMFqO1uK5PPZrVSVb7fcrEX7ebzzFrxf7WNGE8uxlKzt?=
 =?us-ascii?Q?QwA3unDajPCE709XesJ+nMw7taAFyuVdZNJNsAheA6pqoxianLr6Ow7YrKv/?=
 =?us-ascii?Q?DUd2rKQ7KL0MZq5XmSH9iOJ+pgZgDcparsMoP3BnLTZuHkg4IGsaQT+B3onp?=
 =?us-ascii?Q?v+UX0v1dVPD1pel1+tI0PyGN21wmF6urvOb4F/InAQaaCUgRP4kR6y8A72u0?=
 =?us-ascii?Q?fQzvloe3FMwNG9HXf8M+14E5bimfo0GlorvbZ9PksYDqeSOdAJ2/S/ol6LwU?=
 =?us-ascii?Q?XulmzEiuWwQ311ZC/RGHDR8FEdGjSOo5wSANxoFEa6OOVjWQQxtAlJRDQuVo?=
 =?us-ascii?Q?YciDGd6DH+z3Z4fQDWfDr+i1O2ZVsgrptlyKVHToSyuQ78LYv82ZsC8b/NTd?=
 =?us-ascii?Q?PeFdsR6KEEqMZev64cM8rbmeGz3FuGjS0gPr1Hl0CFLdTqpcVZCuqB/CWwvG?=
 =?us-ascii?Q?BscXIgwiVWM88DnKyWE//zQagj9pk3YYNDmsJvy58rmKKzGrAMrCW4iyD0+k?=
 =?us-ascii?Q?ThJSvoieMrQ2zffNWfg+oVqQ/nUaeb9MC99vfzTTbFGBzD2D4UUXWF8XabZL?=
 =?us-ascii?Q?zOCSGcn89j8ZZXHJnvZerXfI08UiBEn0dillTeMnyOAmIJUJ8kgImRcpzhx5?=
 =?us-ascii?Q?tAts2z5kmHJ/iQmsnGNwYEWOLWH6K7guaw/bSzgfyTt26BkQ6NlDxwJGjw2i?=
 =?us-ascii?Q?skEMh00Egj2hEqQXZDcRNu7d8v5uKG4T3WUXOp8zO6dM6PpiBBaeYP6ghyBm?=
 =?us-ascii?Q?CNKcYp67kB4e+vBhAl98JZBcaiw+XT4oMR6STyoY1diqTwU4fp0iiMks+o5m?=
 =?us-ascii?Q?2xjO7v+3XMFHqSdkb+YrW02QCTHjARf9PC1b5N4htexUt5aL7d9ex4tlD2Mv?=
 =?us-ascii?Q?CAXKd3mnZPdCVC8x5KhpxlQfNUCqgllval56FgtY1DvkjUdLEC5+tFpGmqqI?=
 =?us-ascii?Q?UKQbP90OFqNj0Pxfvt4TjSdt9UALn7Pp0M+5jKOaIkwQHazqOX0Qp2tmrrPd?=
 =?us-ascii?Q?gjtDpZQmBPzUilyeVfjBgDiYYqSicfueiRCxp7ZQtOlmIQv5iLbKKgA+2+Ls?=
 =?us-ascii?Q?fvf/jTuOxZfLvZRbabwcYoo0i38YbTtGxLzo7+P6C4PPjNFOaXBB+UnYsh7S?=
 =?us-ascii?Q?LNBB/6FYBy/ZeGbqBykbNrKdBIeH5BHkdJd0p0iagEnW7Tvx7w=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xX40YWjTiV7+e+WtTjC9kr0JSqEe0bIvsLmuiWV4BBchl71nL6aguzzdeQqm?=
 =?us-ascii?Q?7b7eVa42xFh3M6Dq36KlJK3KZX39zjst4ORsJZNVrnrgZho7ouXJ2Xpb0ltj?=
 =?us-ascii?Q?gnQR1JeQupQdx5wsBuKdwg5Yn+RFa1OYyK5+n4qEgSInTYKvrEXaVrI/kjNv?=
 =?us-ascii?Q?5oyrSkAZTAsYVbt/b5dpc4tHO9KR8d7NOoYXQG5n+vJpkIU6SN5+Xoxx02pI?=
 =?us-ascii?Q?q1qu8fwwjZ8C8DR24oZG3C45D9uC5urwbojWLVTtc9G2jSao8Bh3LQHL9zjt?=
 =?us-ascii?Q?TSYNysn1w/xGo+IWaG2H4XqH0pVte65hsEb8WY3OISCWol3DpWyTD1SSI/qY?=
 =?us-ascii?Q?RalFSwq5+zJMKEVWt/XaAX9gvMvmT9RdNTTD35jg/MsXnX/BdHImSRvby4Lx?=
 =?us-ascii?Q?f5ZY98XzbWX8KC/HnJPrq2va411oMhaeis1pRxxrJG8L711K2zfA5J2ZNhgI?=
 =?us-ascii?Q?VQnKn1NVcsE5ojEZFx/ENaa60/vpKpK0VPcsI1/m9IiBCiZodQoAZku2xbEC?=
 =?us-ascii?Q?sO3+zwh0OcaPRDEKtlEAip//Fp5kQsDa2ogTfi+AWzrkbKGoyI4IiIBdvhXQ?=
 =?us-ascii?Q?qGe0xtAek0Z4WF4d1BozKUqDrSBBqpWeyeE8mx7clRf4HeVSWm5jGID+fYOx?=
 =?us-ascii?Q?0nfBvlly0iQmoc6awc3eyuJajld8JQPH3SCzBWkGoKLmPCyZvSty1spxfjRV?=
 =?us-ascii?Q?8aasYsv6jmaeYe6bI6TpNVIKXdquqLCnLlEhSj+bWvhDoMuASlCNDmowzh4d?=
 =?us-ascii?Q?EXE3V/rFGE/i9xCbHMQb19Qc3Ln4qPVWy+kisuFhTbIzcNDaVTEuF0qsIgtM?=
 =?us-ascii?Q?iZJI4O4w3v3yXO7d5t6D0nUkUhEuhEZRxi3B7QWCtXCR+y0BXGr/vkQdVkY/?=
 =?us-ascii?Q?Cd/VNtLuC+JmOG04v2xMLApHmq941NAAn8KOoBg/P7AfSUj9FGqqF4cVzEts?=
 =?us-ascii?Q?TVKC5usqhlY3iwho00d0i4uRxXQaWNMCvNLaa03zWF7klZoYazmi1wHFshet?=
 =?us-ascii?Q?cfQsEEKQcFMi4SAEKhEoUDKdXnAyaYSrKHDjyADu+Rn9n7rFp06yJEM7l+rO?=
 =?us-ascii?Q?INxdjb5GUZMSPGrSt+z5+gxEtSmWE97qfqVdEj6SNN7KJbcVaGGtkzNHZuhj?=
 =?us-ascii?Q?5MY9rMArclETA40q+gDym2mCmqk1aMXYZ4yYSW7ULXi1lbcWJ3FFhtIQTtBD?=
 =?us-ascii?Q?SsJCIqcWeguDwz5yWwqpb02WTlAwj0FCREuJnPsAdVdLJqnLOkCZ+ukRVwdo?=
 =?us-ascii?Q?glOYmH8G4RIGHOTDJsj6hH9oIJqyc1jQM8AbtGCINpBUnSKcGRerqC796cK9?=
 =?us-ascii?Q?tHlUToQMcufkIJQ1WbYFqploLWzUZ+yWlmhppjrKFMEWe00N42lUFtAMhSse?=
 =?us-ascii?Q?HMu9Du3H0MuvVTVmgJkNFAVpCQ64pjtr6sHKGvrAnlSCAx7RK6q5yme95G8S?=
 =?us-ascii?Q?L2sWfgkIbrUHRH5YOWPlJpfQ2a9YL+fvYhSh7wyeQVYD9u0GFIEJFKfwqKj9?=
 =?us-ascii?Q?bLMCGyIVLxmnCNeCQtsUJCsCbS+3U75KHFrkmHc/5OHs8RaRPGFuGWiMadbJ?=
 =?us-ascii?Q?jcL6BEPpYiCjxGGNEbrh6hGc99uROm5cq5U6lX5u?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d43766f-bf3b-4fa0-c9d2-08dcb5e8163b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 07:19:18.9200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1sfFyxw92Z7s/SJmYPlC2IJyLfNJtHHNzrXUAu92hlsFFB0NNlTEg5FWPGICuBolhpIt0QPl6O2KJWqpO6JCeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7873
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, August 2, 2024 10:33 PM
>=20
> On Fri, Aug 02, 2024 at 08:24:49AM -0600, Keith Busch wrote:
> > On Thu, Aug 01, 2024 at 11:33:44AM -0600, Alex Williamson wrote:
> > > On Thu, 1 Aug 2024 14:13:55 -0300
> > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > > On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:
> > >
> > > > > We'd populate these new regions only for BARs that support prefet=
ch
> and
> > > > > mmap
> > > >
> > > > That's not the point, prefetch has nothing to do with write combini=
ng.
> > >
> > > I was following the original proposal in this thread that added a
> > > prefetch flag to REGION_INFO and allowed enabling WC only for
> > > IORESOURCE_PREFETCH.
> >
> > Which itself follows the existing pattern from
> > pci_create_resource_files(), which creates a write combine
> > resource<X>_wc file only when IORESOURCE_PREFETCH is set. But yeah,
> > prefetch isn't necessary for wc, but it seems to indicate it's safe.
>=20
> Yes, I know, that code isn't right either... It seems to be the root
> of this odd "prefetch and WC are related" idea.
>=20

According to PCIe spec:

"
Bit 3 should be set to 1b if the data is prefetchable and set to 0b
otherwise. A Function is permitted to mark a range as prefetchable
if there are no side effects on reads, the Function returns all bytes
on reads regardless of the byte enables, and host bridges can
merge processor writes into this range without causing errors.
"

Above kind of suggests that using WC on a non-prefetchable BAR
may cause errors then "prefetch and WC are related" does make
some sense?

