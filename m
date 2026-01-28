Return-Path: <kvm+bounces-69311-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLxoCf9yeWn2xAEAu9opvQ
	(envelope-from <kvm+bounces-69311-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:22:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9623F9C34C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:22:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1E3A33025164
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD4A5296BD1;
	Wed, 28 Jan 2026 02:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ddhaXipd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ED92877FC;
	Wed, 28 Jan 2026 02:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769566970; cv=fail; b=Y276sUZnNuyXyyE65TZf33XnmYpeQh9a6ypmfJRGAkw0L0li4wv7aKKXlW9z2QTtofh3dpxs/cBzIKcJ7taHoNWNy9/VkeN2TKd0diu9JBwQr2unowIIwJugUOcxb8JHbSHYprdAX1/BEUuFwn8xc2E5a1po1xyutFgEgWZ/8Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769566970; c=relaxed/simple;
	bh=hbbjSUSn7DLs6g0fTz4lzj8YtkLC2ybMp0UqRL6RsNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AwgfKpIH5jw81EdVGj92F1IGWeBOynmAKyOGi8PeGOphmtjg5+gxip+LvDBB2nG2Z6vLgCPbkiCHhkjZIQ9USNKhcKcTJ8Ew2+MdTs2+l3UCSghggpOpeB05JYgrOHrLERy+EzSxjgvtebgQJIiNFMiDwtp24l6bZ6kJiDcrIWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ddhaXipd; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769566968; x=1801102968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hbbjSUSn7DLs6g0fTz4lzj8YtkLC2ybMp0UqRL6RsNQ=;
  b=ddhaXipdCvr7RAsQGrnRBj44cmYJVWW0hvfiu7NHg93CqEgcqbWEPiGR
   aHm+dNVRFhc5BHf6sBiwiu2Yea49rlmDFSUAb65tttfvxMPPR2YlWUsXd
   xIKUT3xoz0LBaIAeaSnVpi7mvx4EJfvutImPYzNJkSG3FDv7rZpRpAv3T
   Ga2WGTaB2CsS2/jcAJyM+Xc6cK+uDcHOVZHDoPdBBftAE99VSIoplPi9A
   IdB6rJvlWBASyjrMKyVjDBEywhLKC/I+E9AyeOVRtK+Bgq1nAgGZTlelJ
   O9ACd2VMLufq/OVaYgRVpDR6/ZuXGOR7oT3Xotj3gO4/7T6YeZ0wr3Szf
   Q==;
X-CSE-ConnectionGUID: kb5tVrj5SgqLw/3lrMy3yQ==
X-CSE-MsgGUID: z1I7IMiKSEqXoSpxUSs3YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="81409336"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="81409336"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 18:22:47 -0800
X-CSE-ConnectionGUID: t+j55fh8QdmbLa8nkyILBQ==
X-CSE-MsgGUID: VSbcHKBFSCemXMsKYXN/Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="208374288"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 18:22:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 18:22:31 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 18:22:31 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.3) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 18:22:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZHqIrjPK88PezGWHtscEy6lKRY7UNV5ISDN67TsuVj68Z66r8SyPi0Gtl8Y22L4P5NrBq+yt65ngTaRO7EjNRsdf9ee2a9XJ1petpqKeAk7CU6rHfxgMqDv2bYOxSDd1yszy+votRbIXWfPS23MKJcfopZF/49RVQs4Px0vfC1dUj4fAJLqmiSXit4d5nICzcxOHoRI3YDXVyyJct+ps62cdrUn+YVLKvWTMjAQ0j0PjQuqDEvlleSsVunpstqQVk9ldupJ6sCaFejQaoYOjRUIFG5AUHawO65HZ249TLd84QqXXUnq75Js7WTfGu1/UWXfcsH//1c8ARMVlFSltw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbbjSUSn7DLs6g0fTz4lzj8YtkLC2ybMp0UqRL6RsNQ=;
 b=uHnzUTF374UnvM94LZ6MSvv85UnVbAwWu8Euc2VzaIdpWfeR70vZIbEqielOjwKySsFI1fdPbIR6aPUk8vSOqtcsa+PCBHp5ta6uSwCnBh1hjplfDY2EKoP7vP69Pe0hZrlOriy7g0TgEcDRBiqd9Y675xdbXR1x0qFql7ra0rNphVHDGBhVSg2Ns7srmF+I50//qNf4HGBAKmhbg6Lo3rnkAFTEA9JGmbOLVP4qJ49QvhjKAwdZ7h3TxwUzB0iewMkzZmDl8v6NbLSGEEYfqsBAHjdE+lCyaEyvUEmvWhjh4E/n4qYo+i8N0CBMOC39v0MIFJBE+/aCO9IgOJwNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW5PR11MB5905.namprd11.prod.outlook.com (2603:10b6:303:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 02:22:28 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 02:22:27 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>
CC: "shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
	"khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org"
	<x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kohler, Jon" <jon@nutanix.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcjGf2hzr1Aefe/EG2AzLgdqhXDbVmiYUAgAALLICAAA1igIAAPvyA
Date: Wed, 28 Jan 2026 02:22:27 +0000
Message-ID: <699708d7f3da2e2a41e3282c1a87e6f4d69a4e89.camel@intel.com>
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
		 <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
		 <aXkyz3IbBOphjNEi@google.com>
	 <ea294969d05fc9c37e72053d7343e11fa9ffdded.camel@infradead.org>
In-Reply-To: <ea294969d05fc9c37e72053d7343e11fa9ffdded.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW5PR11MB5905:EE_
x-ms-office365-filtering-correlation-id: 3000ffb2-5048-4e44-c939-08de5e141502
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QnZYQTJYU1p0NEdrUHFiOHhCNUJNSnVIOHlDenRuV2JLZGpRcEdwTG5NNnlU?=
 =?utf-8?B?TTBLUGp4a0hQR1k3a3MyUjZ2QjY1TUYzK1lCVmVTc0hIU0NlajRldEl2N0s1?=
 =?utf-8?B?c0FueURlbzhDWFlEYWY2NFR1bzgwdC9NMWhBMmtVaEQ1NHVBYWIrVHdhUFQw?=
 =?utf-8?B?eHhGUWtEdmRWV0xTeXYxSW0rZkhSNHJ0QTIyeE9FYjV4YUdkdjYzNjRuYjU5?=
 =?utf-8?B?OEJVT1lZYXpSMHZqRWcvVEpCZkVMUytmUWFaRU9hRWNVZ3VaQzN2ZWRyMXBS?=
 =?utf-8?B?MWhvRU5CUzNpdDAzZkpTMGRGVXQyV1Z3bWVGcHdkUWp5c2tsY1BLWWtsL1RG?=
 =?utf-8?B?eE43VTIwcHNIKzJVQXpJYlY1dUMvZ1JweE9NdDFvUzFnaTBnekNXZ0NSZEt5?=
 =?utf-8?B?UnBpTUUzV3Fuc0hObU5zVFkzTWpvRjBjSGV6b3VJOGxKZFVzaVMzTjJOZ0VN?=
 =?utf-8?B?SDFIdVFsNFIvNVZhaHpXSWxHaGRZWlM5UXhNVHlXOHZCdDM2R1BQQTJ6dWd6?=
 =?utf-8?B?QldXOERvYnY1RkcwNkFlUldZalJXbmxtQlIvUEJaNG1SNjJQbnZTcU9TT3g3?=
 =?utf-8?B?WlBRVUtqVU9jK0pjdU05TnJtMGpYbmJEQWhJTWxTMG1sL21ZeU1LU0d4MmVG?=
 =?utf-8?B?WUdwQnVqTXYzMk1IcU80akZUTnRWMjU4QnRqL2JzRjQzdVIzSjdNay9PS2Vj?=
 =?utf-8?B?S3V2NXJTcStUdHNrMFhmdk1qcURUS3NmSm5ZeVJYQVlzRFk0cENYS0RpM2N1?=
 =?utf-8?B?Kyt4MW91VlgvUEN6RnkyKzVlRlhtZHlnQS9ad0lkZGlONVRNZm14MmEvYkgx?=
 =?utf-8?B?SGRTVXAzN0kreUhHb0VDYzNEYWdVYVlLcGE0RTlOYXNScDJJTjVZL0lFL0hW?=
 =?utf-8?B?MjV5OFp2bnZDMmRaeFM1YzRXM2VGOUJCaEtKcEVoUkdmeEgrNEE4REp2ZU9p?=
 =?utf-8?B?ZWhnTm9xZkRUWHpmMFRkR1JlNThjUFczd3dBVzVWNGN3RktrS0s5T0NkUWsz?=
 =?utf-8?B?Rmt4cnYvOFFuZDNiWjN3MytuUDZ5TU5DNmFKRUJlWTE3a2doUkZzbzBpT0V1?=
 =?utf-8?B?L3FrR25kS1dCZExGWkJEWjByYTB5ekJMQko2akdPQURPVCtwK08yUE50NURF?=
 =?utf-8?B?SXNVSVVLd1AzY1FQZE9QaFZncnZySnQ4ZlBXMTNGZlo0UUFHVklzK3l3dXhQ?=
 =?utf-8?B?aGdNa0xhZjhuZlk0NFpONEROU1cxaTJKY0pJZ3FhL0pKSmtVSjhDNjZpaU5M?=
 =?utf-8?B?dStTaERTVWsxUnFUNUt1M1VqZnpYa0U1YlJCNDdwTjZyT3ZHNGVUODVVMDBw?=
 =?utf-8?B?RWZUM0lCTTlYYlU1YVBWbHgwRWdJN1VVckNSaEVkNlU4cWFjaTJyYmRBbkVr?=
 =?utf-8?B?a2xqSnBSUzhKelVscDZQdXp4UVpJUG54QW9KWFNmQWtRS0RFYVlkK3IxdnJp?=
 =?utf-8?B?Mk9HYUpnUkc0WjUvRUZ5SEtuYXhOR2NSci9YQVhFMGQ0OEVHSm9DcEVUVnNt?=
 =?utf-8?B?d2JpdGwvWXlDZzJDUUo1bzIzNDNhT0NCTWJvTVZoK1NrdWQ4bFNzVDMxbHFy?=
 =?utf-8?B?V0l3b3pMR1IzWjJYemRoMXpTSWZ1QnZNWXBhVFFVMnhmTEY5NlVhQ0dkNHYr?=
 =?utf-8?B?NHE3d1orQ09iRElDYURlOXFJU1BzQUxpSlVJMTJFTWlvdElCd0FlaGFrTU8w?=
 =?utf-8?B?V1Nod054VmVRVCttMTFmc3BZeWJUNFVDTWxSUE95KytZOFM1YVlUa2ZBaFRi?=
 =?utf-8?B?dW44R1RYdTZKdDZheGVIMUhIY211Qm5SN04vM2pMUzdSM1h5SVI3WkRLczdo?=
 =?utf-8?B?ZGZib3JBcmp4NFU1RG10SnVJdC9pbFVMQllJWjU0VzRBMEMzcnhTNnFySnlG?=
 =?utf-8?B?MENvVXhpUmpna1V1SHZrYnhNVGdRMDQvRWFBaWRYeHk1SDBmSk5OdEZTZUt2?=
 =?utf-8?B?dUJxWWlZUThoc2VqTldWNTgxWU5OTW5wSnduZ3V6d0hpY2hLaE5ZWEo1VTlr?=
 =?utf-8?B?QmFhVFd6blZUaFdyTURTYVhjMU92ZDd1eTM2VkRxVVZLZSt6MjByK2d4bXF5?=
 =?utf-8?B?Yi9lUlJZK0xPd0pCbmJ3SEdLMXlweFRTU21NU1g5ZTNSVEVaL2pJdEJyaG9K?=
 =?utf-8?B?bll6bWlYeCsxY05zQXJ5NHd3OUtacWx0SjFFU3IrL20vKzExK0VCakNkUU1H?=
 =?utf-8?Q?EVGS2y/dgvwCSNpETT1XABA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVV0d0RjaENGT3NWN0lla010R2pwODJDd2NneHpycGdRdVRXLzd4Y0p4TkNO?=
 =?utf-8?B?SHcvK1hPbVpNOFhzNUc3Z3FRSkVsdHljZ214MVg0UVFVdHhaSUV2YU94clFw?=
 =?utf-8?B?Q0lXdkxTdGFoOUVQVFBseENncTBlNjZYTnNxTzh4SVRzR1R2RXZtVkltbXk0?=
 =?utf-8?B?OWEwRzBFWDdSUHpNQmxUNklReGd6TzRQVC9YQ3FDcDlwVW92a0JaZW8xazBq?=
 =?utf-8?B?enBPY2ZDY2NmcDBuQmtPQk5uU0cxVEFkaWF0anU5am9Ocm0vdG54Zm8yWERi?=
 =?utf-8?B?SEVRM2VHeFJWMFpURUJ5OHBUVk00UjhjYUJEaW02dVpGQjlsdDJXRk9sRi9Q?=
 =?utf-8?B?engxMFpLUHA3YjU0K2MyWlJLZWxpTFJiS1E3bGJIVzAxZG5KU3lZMHR0aXd3?=
 =?utf-8?B?eG5FSWUrRGhHOTBZcFA5aUVkK3F5M2RLaEkyTlJoWTM3dnQ5QnFGb0tOM1JU?=
 =?utf-8?B?dlNXYWFBMHRzVGljNER4aTlKSGt4dm5iNGwzMDdkTUdMMUdSRTRCQ3ZKaGpy?=
 =?utf-8?B?RXB6bGNMUnRlVFRPYnI4NVhoSVlYaHIzaHRFbzRrOGlOakZhR1IvNGJEVDM1?=
 =?utf-8?B?QnNDWTVYNmw1OWR6cVZKRzMxZUhzanlwZ21YRmdwOEc4aFFuL2tLdEI3QzNI?=
 =?utf-8?B?NmhUMDZEaksrMkJxWWlYRnJZMWNrOGptZWsrem1HV0ErQzhuNXc2SGVGc0FJ?=
 =?utf-8?B?STIrL3J1NVI0dXJiWVdJQVhLS1lLRms4UlVkRnpxWDVJOHFDb1U4MVo3QTdK?=
 =?utf-8?B?TDYxNmJEZXF0RzRVNHFPNnJ3NzMvcDM3YlZnNHdhVkdQbHZVaVFtSmorL3Bn?=
 =?utf-8?B?aWVNVzR4c1dMWVpDR3JaakpIeERDMVJyWWl5ZVp6eG02djBiTFdJcXUrc3Zq?=
 =?utf-8?B?QVh4SkwyY3V3U3J2eDdad0o3YlBSWEl5NlUzRm9Ob0pBMXo1Q2hzU0poQ0RI?=
 =?utf-8?B?TmR1c2ZWMlY5MDFDcEExcFZ1MFRqM0NRaXhZd2RyQjdndkRyb2xBZWpMbjhs?=
 =?utf-8?B?V1Iwa1lHdWUxRzV4OFJTODYrVFBIck9Ealo4YTRITCtOMlR4Slhpd2xiUFFi?=
 =?utf-8?B?WFlIUUZUaFZPN2ZiQmxjeG1VNW1zYkR0NUFxQkIvNXExYVhJK3dQanpqUW0z?=
 =?utf-8?B?UXhFdXVnS01Sbm1IMDhXenY3OVFCbThBdmw5Y3p0S3hjOHl0RVhLVVdoazhE?=
 =?utf-8?B?VVBlaHFXWTNGVE9VZThyeVZISlhrbkIwTDl3Z0RucUpFazBTeElFSmtGMER6?=
 =?utf-8?B?K0lJZzd2elo4WlJVYndXYmpKcDNGYzlRZW4wRCtEKzdjVnc5ZFVKTks0ZE85?=
 =?utf-8?B?My9DS0psVjJpU0pITWx0UUZVQ0hEUFZWZ0wwbjNMSit1bjFZYm4yYWpDYWtQ?=
 =?utf-8?B?eWQ1OXF4UkxZa2pWSklSeDdKTHFlU0lEc1RzeVo0akhMaTVZNnltcTNFakZa?=
 =?utf-8?B?bEprRHFiVklQVk1VUVpyekdsOHZ3YkRocmJnVHNjLzlTZFduK3BuMFAycmNO?=
 =?utf-8?B?K0pCNjYzaHFQZHgzZFB5NlA2bTc3TVJxMmhaYUFhcCttK0d3bzE4T1krOXFZ?=
 =?utf-8?B?Yk1kT0RVN0tteFN4dVM0OW0yNlpjNXI3OGdtb3lsUXJ4akhBd2g0Vzl0bDhJ?=
 =?utf-8?B?eUlPZlBkMG1CdTVOcU1MaVdpQ2NZVkZ2NGJPbzY4alNKZldKbkxrWENZanhs?=
 =?utf-8?B?dXR0ckdmYXQ4cW9ONmRpZE81UHlmZ1MxZHIvejlDaUJwNTM3dnQ3OUVqVDBv?=
 =?utf-8?B?bXN5MlE2UnRraWFCeldXcERKOTkrYm0yRG5lRXlCbEdsYVZwbHRyNTVWVFJt?=
 =?utf-8?B?U2ZmMFFvRW91NVNvWjA1clAvYTJEaFlQcVZ0QU5vNkd4aHJFSVNObjlpdmpP?=
 =?utf-8?B?ZjJISTdZT2JVS0xuT2Y5NUY3LytmYmdlYmI3a1lZTm1SSGI3MmRmWHBnNkNm?=
 =?utf-8?B?c252cFR0VC9qS3l0dzVTYnJjSjU2bzVVMmNoV1dJWUk2R0pGMEVxK3NyN1BJ?=
 =?utf-8?B?TUQxSHM3aUY0TFNmYzF6NFVQbVJwOGN4QTlnTHFENGlzZGp3aDk1cHU0bkZX?=
 =?utf-8?B?eEF3WDBBRzVuUWRqdXFuRG9ZVHpTMmFMTUxiQjRqRW4xVGxIdGlhQVZBdlBS?=
 =?utf-8?B?NjNGeG5YQktPL2J0anZYbXlLUkpFa0hsclVtTnY5WW4wTmZ2OWtIeFY3dk5p?=
 =?utf-8?B?NWE2bTk4aG10YTNUNEdYNmJndzVXbjY0R2N5UDJJKzhDV3NZcG9lUGxrWWhK?=
 =?utf-8?B?bUtGNTJ1UzRTK09RcnBZR0NreGxiLzhUeENkY3BGdkxJZzdVVTd1b2dMY3Ar?=
 =?utf-8?B?bUJaR094TlFtZE9uZ3BRRXYyQmFJYjNrUjNHYkQzemFzLzBzRFVVQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21DC7700C5441043A7B8ED2607B09071@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3000ffb2-5048-4e44-c939-08de5e141502
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 02:22:27.7976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Da4r+7odpjvbrusUMjg/JQrk7xPpJ26JaymIzct/KKJ2MxxK6u2kZdmqJ5ApeZDQW6MRLMyLNyj3emB7miZeYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5905
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69311-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 9623F9C34C
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAxLTI3IGF0IDE0OjM2IC0wODAwLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6
DQo+IE9uIFR1ZSwgMjAyNi0wMS0yNyBhdCAxMzo0OSAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNv
biB3cm90ZToNCj4gPiANCj4gPiBOb3BlLCB3ZSBzaG91bGQgYmUgZ29vZCBvbiB0aGF0IGZyb250
LCBrdm0tPmFyY2guaXJxY2hpcF9tb2RlIGNhbid0IGJlIGNoYW5nZWQNCj4gPiBvbmNlIGl0cyBz
ZXQuwqAgSS5lLiB0aGUgaXJxY2hpcF9zcGxpdCgpIGNoZWNrIGNvdWxkIGdldCBhIGZhbHNlIG5l
Z2F0aXZlIGlmIGl0J3MNCj4gPiByYWNpbmcgd2l0aCBLVk1fQ1JFQVRFX0lSUUNISVAsIGJ1dCBp
dCBjYW4ndCBnZXQgYSBmYWxzZSBwb3NpdGl2ZSBhbmQgdGh1cw0KPiA+IGluY29ycmVjdGx5IGFs
bG93IEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1QuDQo+IA0KPiBBaCwg
c28gdXNlcnNwYWNlIHdoaWNoIGNoZWNrcyBhbGwgdGhlIGtlcm5lbCdzIGNhcGFiaWxpdGllcyAq
Zmlyc3QqDQo+IHdpbGwgbm90IHNlZSBLVk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJP
QURDQVNUIGFkdmVydGlzZWQsDQo+IGJlY2F1c2UgaXQgbmVlZHMgdG8gZW5hYmxlIEtWTV9DQVBf
U1BMSVRfSVJRQ0hJUCBmaXJzdD8NCj4gDQo+IEkgZ3Vlc3MgdGhhdCdzIHRvbGVyYWJsZcK5IGJ1
dCB0aGUgZG9jdW1lbnRhdGlvbiBjb3VsZCBtYWtlIGl0IGNsZWFyZXIsDQo+IHBlcmhhcHM/IEkg
Y2FuIHNlZSBWTU1zIHNpbGVudGx5IGZhaWxpbmcgdG8gZGV0ZWN0IHRoZSBmZWF0dXJlIGJlY2F1
c2UNCj4gdGhleSBqdXN0IGRvbid0IHNldCBzcGxpdC1pcnFjaGlwIGJlZm9yZSBjaGVja2luZyBm
b3IgaXQ/IA0KPiANCj4gDQo+IMK5IGFsdGhvdWdoIEkgc3RpbGwga2luZCBvZiBoYXRlIGl0IGFu
ZCB3b3VsZCBoYXZlIHByZWZlcnJlZCB0byBoYXZlIHRoZQ0KPiAgIEkvTyBBUElDIHBhdGNoOyB1
c2Vyc3BhY2Ugc3RpbGwgaGFzIHRvIGludGVudGlvbmFsbHkgKmVuYWJsZSogdGhhdA0KPiAgIGNv
bWJpbmF0aW9uLiBCdXQgT0ssIEkndmUgcmVsdWN0YW50bHkgY29uY2VkZWQgdGhhdC4NCg0KVG8g
bWFrZSBpdCBldmVuIG1vcmUgcm9idXN0LCBwZXJoYXBzIHdlIGNhbiBncmFiIGt2bS0+bG9jayBt
dXRleCBpbg0Ka3ZtX3ZtX2lvY3RsX2VuYWJsZV9jYXAoKSBmb3IgS1ZNX0NBUF9YMkFQSUNfQVBJ
LCBzbyB0aGF0IGl0IHdvbid0IHJhY2Ugd2l0aA0KS1ZNX0NSRUFURV9JUlFDSElQICh3aGljaCBh
bHJlYWR5IGdyYWJzIGt2bS0+bG9jaykgYW5kDQpLVk1fQ0FQX1NQTElUX0lSUUNISVA/DQoNCkV2
ZW4gbW9yZSwgd2UgY2FuIGFkZCBhZGRpdGlvbmFsIGNoZWNrIGluIEtWTV9DUkVBVEVfSVJRQ0hJ
UCB0byByZXR1cm4gLQ0KRUlOVkFMIHdoZW4gaXQgc2VlcyBrdm0tPmFyY2guc3VwcHJlc3NfZW9p
X2Jyb2FkY2FzdF9tb2RlIGlzDQpLVk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURD
QVNUPw0K

