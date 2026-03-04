Return-Path: <kvm+bounces-72757-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EL0bITW7qGlbwwAAu9opvQ
	(envelope-from <kvm+bounces-72757-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:07:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BC9208DA7
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D9EF3019F03
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C5B382366;
	Wed,  4 Mar 2026 23:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2CI6uvo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3AF383C9D;
	Wed,  4 Mar 2026 23:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772665592; cv=fail; b=N+9EXgxWWzonMlZc924qVFT5SjDYzmiRqFyQ/4piQGMS9QWrDkiTpLa/s/o6uX/xAiB5ETWL3cPdxjgb30OibFOWfBq4+FGqCxjNAErgUMKJyW5KkwiJljyAVXrFoifAyorcfA+73VvDsdz9Ba9/sSylzaDp5gmF6pTf8UYIrPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772665592; c=relaxed/simple;
	bh=37kvnrdlOPoB2da27UuymeaV2SDJxc2Ojzf5hbknJpk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pdypiyE5v3FwpUskDJVmKK40sJ0mCjGJspvHZxEWKbMgHIabJVesyMcF8Mts0l0wsIGPBEBuKYMZeIvB8ydjZxaliXSiNmVc1hr6qtgU76kWeKrXtEQAY0Ae4iBPYqJ1hiNwm0dj0rGQbIjWfzt3tw4RiuXiRjPGrwSDiJuI2k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2CI6uvo; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772665590; x=1804201590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=37kvnrdlOPoB2da27UuymeaV2SDJxc2Ojzf5hbknJpk=;
  b=d2CI6uvomp4jn/4o9KSg0r08NycIRnasJ6HjdJYy+X6IMyIAQLKWH4F0
   I5QPooLo7WNlpDuqZS70lImlHY3Zg9LUZR9vM7+l0IBl65VQhjXM1z8fW
   Wten/XLNsLiK2x8iS/vwFbhSIN5exrEwUWPOCzRcvnXmqS/rOrGAFT6Qv
   z5bl6OsQv23KnyYGjsa7wlo//YQx/+kp9vGxoLWuw3JA69EZbsMDFoc42
   PrAGyzb83fQzDE4f/mYmd1FNKHYRcMbPaZ9Imyr2Pt0OqRpXlJCpwfn2r
   FKQd+uq/cFvp5lB3TcDCp5tFVw9lUr51Iw01liAGQgusZKyYEJnCem8Ae
   A==;
X-CSE-ConnectionGUID: 3I8tdTHHQXKAKzYgBMSk/g==
X-CSE-MsgGUID: VHnA+sBNREOzTEE11NuIqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73863940"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73863940"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:06:29 -0800
X-CSE-ConnectionGUID: Hy68LG4vR6SUOIhEYrg8jw==
X-CSE-MsgGUID: HiObbL9qRe2zXwKKeSuCew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="215371347"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:06:29 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:06:28 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:06:28 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:06:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRliX2tHnCEDgLSQC5hwjtq2xMzuaCEK8+O/M9UB2h7oypRxRZG/HbJzlYc37A5EENVrVrIVcK1qtwR7lX4/tKn6phwTvhAARlLfB083i7jhKhLabze9lWTlTWCMgqxKj8JafajgbbjbIrpmEYYj9j377l/0YzsP8Zj0AP7Qhkt1dGLZlDK0gZAdVhcdHcxJFgAwSAJIKKSg34mBIV/osoium7cCmbxD+TYCTWwQFEsakE5bFxD5h/CmHlVGAAeXsX0FXxH4hyv9JY+r0GpAzrAsUGU9BVAvhGhcbR2FsP/0ypASXlgYdPF/7AmmA+eJQKOeK/aW0F3es9PaROU3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37kvnrdlOPoB2da27UuymeaV2SDJxc2Ojzf5hbknJpk=;
 b=A1w/ofbSW7vvRzW6SyE+xCILaCf5TA9nrjnaIAcBLbVB4ajzGYwqrd7Zmqx6UrpQvpWnReLPXAWnjszzZlN2qE+vp7zH3sXVW50s8kZHyxiFJZ6TkmgU+Pb7H4kkNn9E2O56mVlltCsEmBDda6akOy3om8qcV8EewrciLTc51AZBmBhRrWI1QgTf9OnlXWGKe1JDd3QDYT75gEYKZQzepMqoehHAt+w85F6XI2cdUsBssZIYG0L/JjMJenHYi+NfUeu0w/eXgxV7x8G0pa0Jzl/PekT4hVI+7zP9Nt9HIY1jNjrDPWTUWySBXWy6yZa9AgXReAC0Kd+pqeL+UX/3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 CY8PR11MB7196.namprd11.prod.outlook.com (2603:10b6:930:94::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Wed, 4 Mar 2026 23:06:25 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:06:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 14/24] x86/virt/tdx: Reset software states during TDX
 Module shutdown
Thread-Topic: [PATCH v4 14/24] x86/virt/tdx: Reset software states during TDX
 Module shutdown
Thread-Index: AQHcnCz+xNMYVOgNk0apSlGH3Ym+1bWfHqaA
Date: Wed, 4 Mar 2026 23:06:24 +0000
Message-ID: <267b516d17b705ee94fe8ef339cfb81f85e5a12f.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-15-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-15-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|CY8PR11MB7196:EE_
x-ms-office365-filtering-correlation-id: 873efc08-97b7-42e4-3d31-08de7a42a8b6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: sekDPrdaG2DZU7ERI1rS3s5BQK94ZJiVr9a+WW9bTobnj2OCJ/u5RRXNXZwUmdnolgEBiIkVlf2bRawY6hKVoiR3SqHcxaXprxrdahEy61/aT/1bBo2kYJRUa8Ezsw67hKrIPeVgAmR/S4HWhMdKxRuhkE5BhHCejZBsX1SRfqRMBU8GHHJm1c7JbwYgTBEWcBsSWw9cIabyjkXpXrXgxID7mtZWHjWmEHESSzG0h9Bke5h0daZFM9h0XgJj0K52Js/JpHJzwqPSAURJxuJmQoLts95m18rI6Sc5l5PvnRLpFdu/uId0LpwDkihSjw4XRZx/AULPTURZ863B/GsspiDUX98OFwqMVsvs1UJpBjcHMcDKOzSfWxhEnZ+/8sU7FS6e9o7WK5IjAfwh2NMwcGk0x4LL3rDDFLDnp8LbC+jdvE7bTlgw0Pu6XKxGe6dThmPQ7ConUl9ScsD8lT5HMYQmEb+3dvKIQq31Ktj7otFuqO5AYxqHF3lGKaLEAOoMVyYggLmBsQK7o24ProNSOwAhrUR+w9idjHgk+CL9fFVz9JlIjAAkOcR0atPJ9s4oMK22AUlyMaFfmaqNgQG+9SD3u6fpNTKHm/IzE5KV1YgoSPlnGAoAnHRnGVrESg90viPWSBLxsFS8cITx0H+vxJIbdRotX2Lg3olHLRutCFeDgD4EpLkwhpCd6d2CN6q8TTuAik0oQHa82osVh1nqlkYJjz1GYiZv1GMO6ZkbLneFx6/rg97imj34sH4OF7hm1tScmgYb7ITT06Fb9dfzgR0+MG/2IjlIoqs7vDPNUZw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cCt4SG9YclZZeEFQL0Vyd2VzZVM1b2ZJMTBwckV6MCtKUzZDaDVMUDNTbW5Q?=
 =?utf-8?B?ZE5xRm5uY091dmt5enEydVFUeGxsejFwdHR1ZHR4RGZEMndtVS9ITkZ3RE0r?=
 =?utf-8?B?c3FuZ2ZlZHAwZ0VLRmlSNE82Z0VEYUE1MkJTUUkzMUJ2YktoM3BESTArVWJV?=
 =?utf-8?B?RXloam9Pd0YxUnVTUDRlTG9qVm1UaEplTjlwM0x4Y2NUVVAwOTBINGoreHFL?=
 =?utf-8?B?N3YvamZadldvd29xbWxHVXdvLzFNM3BzVG1xWkxyNkZibnNkdkpFNGhhcmFG?=
 =?utf-8?B?MGoxbEJDMjJ0SWs1d3dKNG5NL2x5bHZzTU9RVHU5clBhWHlHekFHc3lsLzcw?=
 =?utf-8?B?UnRPYXZCYWlrQ01jYTVyS3IvYlREdzNQTGV6ZDFqNS85anVTb3ZveXR5a0ZI?=
 =?utf-8?B?VGNCaFNHWkhFVlJ2VmhmR2xEeUF1YnltTjUzR1JVemYrcjNSZzhJakIybnpk?=
 =?utf-8?B?dkdlMVVwaUExMEtCYTk0NW5SVlppUkNwNitDQmlXNWpsaEc3NlQ1dWE2VGor?=
 =?utf-8?B?UWJYWHM5RTQvektIM0J5WHpoL2dVTTRJQ0szM0hsa2VOOTdUZEtJTGJXTVRr?=
 =?utf-8?B?ZkViV1dmK3BQVUhrVlB6OEsyc1E5Q1M3dWE5bEE2c0hEUWNZVThPMjJRVkVE?=
 =?utf-8?B?eXF5MmJvVk9RRkMwV3VVMWN2SVE5TXdFaG9VVFVMYU1mdGlleUFCSEVtbS96?=
 =?utf-8?B?eTBrV25wbitzUzVGblVBMlAxZjJxSVBiNmkrMVBmUFErempLcVVrWGFCa1A1?=
 =?utf-8?B?K2NucUxWYVZJVSsydjlUd0FKTndsMmZmSE9HcUxBenB4eDROWDgwUEtiNzZy?=
 =?utf-8?B?RStRei8zN0xxRzgyc09mMWRyTjJPZmNoTUI0eWFaNTZWY0lkdVh2Q2FwN1kz?=
 =?utf-8?B?OFFoK2V3UkJieWRra21Cb2IrV2lXMzFWWlZPZWJNVy8weHVBWGFNOEZNbG5T?=
 =?utf-8?B?bFZqcXdQTk9uVHNlSmJXNkpwUG5IYy9JbXpPaXF2N2R4bzlKa0RaV2N3RSs1?=
 =?utf-8?B?encxZklJZTVCVXZ2bW9haTBscERFOEc1QnpBK2RNejNRa1ZIRlJSdzBEZU9x?=
 =?utf-8?B?U2phSHRpRmF4UEYrUzlsYnVzeFdnb3I3U2hORDFJT25ZcUxPS2ZMaU0vVi9v?=
 =?utf-8?B?SmExTWx3d1o1VEpmQjRqM01GbzlicG9LMGtTR3p6NkN3eDRSdml0K0E1U3VZ?=
 =?utf-8?B?V3dOZytHeFJBUWlnb2VGaVJ6QUJqTHUvRVE4UGs1OXNlSHRsYjZBTFZRejFJ?=
 =?utf-8?B?VXpuL3luWHBndCttWmZUdVRkZ1lVN3lLUjJnUDBRenJITlJKclduc1BZd2hS?=
 =?utf-8?B?eXhDWlhEazR4MHB6Vm13ZkdRZ0JuUVBGK0ZvcGNDYmR3MWt5dC9xcGJkRk01?=
 =?utf-8?B?Z2tUcmsrRlY4QmI5VWhNQk1LY1FVUkRXVXdTd2JwZ2xUMnVjaEVoTHNpcnJj?=
 =?utf-8?B?dlVCZDlBcStIVkk1RmkxMDRSOU9oUFgwYUJaNFBldDdaZ0JxejhxOXZRSG8z?=
 =?utf-8?B?bmp6UTFzMkdPMm1qWW1jRTBnUlJ3eHVyamVBc3IzNDBpUzVEUW93WU5XTlBO?=
 =?utf-8?B?ZXVhTXltbE9JZGR2Z1lQMzloSG1PbklUMjVoWVBFK3lTdksxYzc2WW5iQS9u?=
 =?utf-8?B?VEtTUW5iTGZucm9pN09qYUlmaWllSU5JTkV3UXhUS3I2dkJGcGZqYnJ6dWE2?=
 =?utf-8?B?bHpySHFZWlVjWnJybXpwVUozMndESnozVzZLWjZXT2RjQnFBZXdDTk1LSGtI?=
 =?utf-8?B?U05oMjVqSGl1clpUZTIvUzdBeVBDSjJLdmRzNDF6eHZqRDFxdVBENEVvbXB4?=
 =?utf-8?B?dXhKSXNEbkg2M3NtZ0p4U1U0SHNYL2E0UnBCQVBUK3l5VCtkeG1hUGNPVE54?=
 =?utf-8?B?U0RpTVBJZnNTUU9MbUgybjlvMlJRVXVZTTJVS2JqRWs3ZVFPMml6bStkMlY0?=
 =?utf-8?B?QkRVWUhGTkZTNnFGcm11WUdWUUwwclhLSnc3c0tPUDhaT2EwajJ6ZGJZa3hP?=
 =?utf-8?B?UU5UcmVqRUZRK1pwbDhHakNHRXI1ZFAxRGJpS01DbW5kK3hDZ3B4Tjg2S3F3?=
 =?utf-8?B?ODRoOFhYODVVSU1SelFpOW93N0ZXN0JIdzQ4NU12VnhrVFVPL0FmMkV4MDVi?=
 =?utf-8?B?b24raWFTSmlYR1NtK3I0Zzk1M2E5UTlaQm4rZWhYeUZOVlU5MlpNTENsaytE?=
 =?utf-8?B?L01LR3BHbElxbkdTL0VVb1NlNjY3bHMyY0tPWjY4aytBNlhLRk1xbERac25S?=
 =?utf-8?B?NG8xWnppNlMzcjh1MlV4Lzl4elNsZTFsMXlpc0M2OSt4MHdIZUpBSUhmUzFH?=
 =?utf-8?B?N0x0cHZhdTdnb1dYeVBzaDMzUDNCNG9MalF6MldxOWNsUkRWZjVNdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B96639C2D23BE34FB5A26B012D7F0EE6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: XZyIYofsF3HcTF7diAeEXjQTxXEsZWCLRVHob0qFFNJ/cvH5rboPPqbjz9FPC64egL3HIOYsd8TwZbID9ZRv002oXFMHAgty7LytM0Z2ZY1DKgxavTWGZmlvNDmRDccGOpqaPfHAqFv4+mgao1Cz/gIkMflJxxlyFUksxpBTT2ZqUXho9VouzjuU5gqyGJHpR5jNN/L/EKL21KBIpernPP4WuIb+iZDPG0W9QKAfD6QAnH1SUsO+duB7/9f7hSZhWK6wU4m0QY00R1FlM0+juSOxrYfRdUXnbM5tskp9X1bElarBmG8mqkNDQkxrD+3n56LtNcDrW1ogV5ejO7x73A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873efc08-97b7-42e4-3d31-08de7a42a8b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:06:24.9760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6N8WRbEHaxq35sfSAKnAk6endnw7ntwZP89f59Ccv2GkxWDN05qwxBTybKfKzU3h3ygmFgX76gSHhmYUzLM2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7196
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 98BC9208DA7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72757-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

DQo+IEBAIC0xMTc5LDYgKzExNzksNyBAQCBFWFBPUlRfU1lNQk9MX0ZPUl9LVk0odGR4X2VuYWJs
ZSk7DQo+ICBpbnQgdGR4X21vZHVsZV9zaHV0ZG93bih2b2lkKQ0KPiAgew0KPiAgCXN0cnVjdCB0
ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHt9Ow0KPiArCWludCByZXQsIGNwdTsNCj4gIA0KPiAgCS8q
DQo+ICAJICogU2h1dCBkb3duIHRoZSBURFggTW9kdWxlIGFuZCBwcmVwYXJlIGhhbmRvZmYgZGF0
YSBmb3IgdGhlIG5leHQNCj4gQEAgLTExODgsNyArMTE4OSwxNyBAQCBpbnQgdGR4X21vZHVsZV9z
aHV0ZG93bih2b2lkKQ0KPiAgCSAqIG1vZHVsZXMgYXMgbmV3IG1vZHVsZXMgbGlrZWx5IGhhdmUg
aGlnaGVyIGhhbmRvZmYgdmVyc2lvbi4NCj4gIAkgKi8NCj4gIAlhcmdzLnJjeCA9IHRkeF9zeXNp
bmZvLmhhbmRvZmYubW9kdWxlX2h2Ow0KPiAtCXJldHVybiBzZWFtY2FsbF9wcmVycihUREhfU1lT
X1NIVVRET1dOLCAmYXJncyk7DQo+ICsJcmV0ID0gc2VhbWNhbGxfcHJlcnIoVERIX1NZU19TSFVU
RE9XTiwgJmFyZ3MpOw0KPiArCWlmIChyZXQpDQo+ICsJCXJldHVybiByZXQ7DQo+ICsNCj4gKwl0
ZHhfbW9kdWxlX3N0YXR1cyA9IFREWF9NT0RVTEVfVU5JTklUSUFMSVpFRDsNCj4gKwlzeXNpbml0
X2RvbmUgPSBmYWxzZTsNCj4gKwlzeXNpbml0X3JldCA9IDA7DQo+ICsNCj4gKwlmb3JfZWFjaF9v
bmxpbmVfY3B1KGNwdSkNCj4gKwkJcGVyX2NwdSh0ZHhfbHBfaW5pdGlhbGl6ZWQsIGNwdSkgPSBm
YWxzZTsNCg0KTWF5YmUgYWRkIGEgY29tbWVudCBsaWtlOg0KDQoJLyoNCgkgKiBCeSByZWFjaGlu
ZyBoZXJlIENQVUhQIGlzIGRpc2FibGVkIGFuZCBhbGwgcHJlc2VudCBDUFVzDQoJICogYXJlIG9u
bGluZS4gIEl0J3Mgc2FmZSB0byBqdXN0IGxvb3AgYWxsIG9ubGluZSBDUFVzIGFuZA0KCSAqIGFu
ZCByZXNldCB0aGUgcGVyLWNwdSBmbGFnLg0KCSAqLw0KDQoNCkFuZCBtYXliZSBhIGhlbHBlciBm
dW5jdGlvbiBsaWtlIHJlc2V0X3RkeF9rZXJuZWxfc3RhdGVzKCkgd291bGQgYmUgbmljZSwNCmJ1
dCBpdCdzIGFsc28gZmluZSB0byBtZSBhcy1pczoNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

