Return-Path: <kvm+bounces-71856-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mLzoMHQyn2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71856-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:33:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2187519B9A8
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:33:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2465A303A121
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303D23D522A;
	Wed, 25 Feb 2026 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIfXthWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811B82D7DDC;
	Wed, 25 Feb 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040775; cv=fail; b=evcDOpPHbmdsRPczP6zF/tI1djZti1ssIBd8LbINTA+togp1YkkGl+B+I8QtgOOpRLBPsEqx2Q4WriIwYaG/KxHK6a04ENm6mQsY6amxS9IYrGSjNE0Z8kOVf+yj8Y5+3NvAMynQ26vpktUHA1REMkOA5wkSfZ1AsJleUJO3iiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040775; c=relaxed/simple;
	bh=8tOMoJ8gcgVv/ZVB+aQ1tJo7MUu5+VgqsfLevnjbVfI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TNSDzdpfeyFc69epaWrtY8E/aYfcqIM+9pneCLEDHtuy5WwUpGQXGiXNTLDqVsULJ79ulugCj6PD/T4gIqaZxxxnMadUUOBFkGZa94BD+0YLKXH07VbMTwJWr+gJj3CuaPBCydNDAUFgPSm/PnaMavNDWn7aBob7GiEIohGrWvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIfXthWZ; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772040774; x=1803576774;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8tOMoJ8gcgVv/ZVB+aQ1tJo7MUu5+VgqsfLevnjbVfI=;
  b=JIfXthWZjYMOa9onJJqam6bvzoBh8g40IhRioLsFQaSymOzLm3kai/MO
   wQQELg9WgOuYwpeShDmQM1MfNCgh1yHPS/rnN1/40+REJmjeMP3KT/6kK
   PMK/TkiNmL9L7mtj2V13rWyv/gR7tE8Flw6A74qbmSRTQJk5sT0OX6MIG
   mJZ3RHbg4cltAME7yLu9+1Y+eHmth1bOFXBqqYkI9ssLGuAm1mZO0cDm1
   opsqKLxPvjgsaDCHAq0+ZMZuBBDzDJ9L26hqjanEqFlcSTq0HhG+KPau+
   iZtD39wZXPEmqsIfUuGb6OqQk94UjUF/RnSU+CVv8zYDcY4xn2KmYulwo
   g==;
X-CSE-ConnectionGUID: ikTRexn0RjKjQupumMgeBg==
X-CSE-MsgGUID: i5n/KdXKSz+mQmZ5naOdLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="73264408"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="73264408"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 09:32:52 -0800
X-CSE-ConnectionGUID: bAT151hZQDm7GoF75j9NMA==
X-CSE-MsgGUID: XVuF7LXvQFemovgskdQjCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="244029076"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 09:32:53 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 09:32:52 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 09:32:52 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.14)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 09:32:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qRwaqDz3qiwA1uCQs62jP3VVzb0GEJTlL02aOxhoccKWS9pjN+JP0DpWRtjj4Nn8IIHFwfuhSVbB81gijYMeORpQxctKztLzohqkfF2kuj+xKnqEFbTOeY+ucWrYPCdRjr8SCmnlqkS/n7G4ta4yKMeUkICCUdQkjNmTumgfIeebSeqckRCjRrwEuktDLXlDNUgJJF2M7yNBf+Ig/zadZolXKdhA4kXfWnJmmbM1LrBjZzdcF1/WhNs6d1dLJJJOKV1csGePKU+mzNJ6EhxKNCHE4jqf4izToA6pgddhJJf4JqGga8Jyle+iHpZQPF/QmsgfmXRT4+4rqWCOEgkjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tOMoJ8gcgVv/ZVB+aQ1tJo7MUu5+VgqsfLevnjbVfI=;
 b=RXwDLgvuuz5CYbVWgLdfKUz9ZEDnZVEkIqW4ag8VDIKx5X7ZG0jyU0XqjugLMptAKvkth6fbHiK4eQuYxlvcOPDtd4+c78SRSQBKzuhw39mxV8NOLScCAW36GpYHRgxzLKRYcFISPGZO/y5YvepZ6SEcBDbj+KS0fHWf+yFc+Gcs3HIlw+udjbd5NPupI1cyW1mSs3Bwm8u65Vhvl4EOGEc+huLle8iEthPLmjRb9xMZquvVe/2cZjJzy40Xuxi1TLkOrOyfWvWePDemtAvRe1VtxkLm2nyc/AFTex4OACJrPS43X5fpmhQjgqx5SERbeJ+TB/oZcw7D39cRYbtMHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SJ0PR11MB5813.namprd11.prod.outlook.com (2603:10b6:a03:422::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 17:32:48 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::893d:78de:7a85:7c8c]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::893d:78de:7a85:7c8c%4]) with mapi id 15.20.9632.010; Wed, 25 Feb 2026
 17:32:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com"
	<zhangjiaji1@huawei.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
Thread-Topic: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
Thread-Index: AQHcpfUVg+RNJOrOv0Cmb5EAu8jOw7WTrZgA
Date: Wed, 25 Feb 2026 17:32:48 +0000
Message-ID: <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com>
References: <20260225012049.920665-1-seanjc@google.com>
	 <20260225012049.920665-15-seanjc@google.com>
In-Reply-To: <20260225012049.920665-15-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SJ0PR11MB5813:EE_
x-ms-office365-filtering-correlation-id: 51e749b2-4ced-4e3f-d247-08de7493e505
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: H5IBKQeM6zv7Gfu/qSfVNLOx9bEJYV5+g8iVa3WyzfFEzfgtwxTK+0iCFF83IKChFFRiGl3xnMTpSm0mwmXe7T0gqQO0ZCJeNUGdLXC5TfnLFM3Wc56c7AhqzsTXLckwalYbYwwZ4qj8RivgHt+gV+QqU+OINlQ20YuYWtvLoBFC0jaPFWeJzu9XMl9U7Y3h5e7XdAELrBMpz4X/zOAl7csfGZuKYHRA91obXd6UeDIQQQs8Rx/anpbcz5OXo/Hagq5Znr08iuCo5m8vSyxnmEMV2LlcumlHyiJNlYJyYkfapzW8x0rY2fho4TCzmIPcnWCR3QSPvkyX94Ar6k7xjfQeKunBeUfeUJPPAIN0eXGSdme707KH+ZcE+z2s8i1ZfO1GDy3aSFRoBmEKeXXDAowRWhDL8XDZ4U1adb3faE4TYPqzWkd9yUq7HkUuRjnysyRLT8NlXxd20HU/8b8filTHYEbcoBUmBPoeLXxrCXac2J1qRkjjknhR2swgAFoe8UFVE9iPRKt4LdNjph4C7fcvp2sj5eBp1GIdNL6EGNcLuBlnI8S6f0IM4yAbhviMwgAF58eqQqLM6j/kGco+aJHhle+w2+8DhcxquJhpt7D5IAqW7cNu27I3qmWA9l6JGuk51opAvliS2VDMa0RcA3HNXP414BG4YC7sm8wAasggfiRr2tAXr//xdkJIbNZQN1fm8PybTUrisP6Z2mm166+MkAKxT1vq7v0yMv3YK6IhdoaTzB3TuX68PQpD2TBea7vCUdPzWklxOGxkEa2pl6ZlWbWu+bWm5DZtc3lQYzA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dy82VzFsbUdzQlViRnphbmZGRUhHS1hhVG5MMFJ0Z3E3Mk93TWowell0aXRs?=
 =?utf-8?B?WXZvUEZnc2hYWkVnYUxldFdUa09kR3Y4ZEZLZlJlT0lBU2tnOTdIL3Zkak1R?=
 =?utf-8?B?aTluWlBYdkk3MkY3VGpjRDBHY2QrUlZaa3FKNExnRWlJNXdPQUd4UWg3L2Mr?=
 =?utf-8?B?L0gvTVk4WEQrYy9QKy85bk1vUUZsYmtaWDVNTjg4WGVTeW9kZDhGOXMvNk9n?=
 =?utf-8?B?VGNySy9vZ3JvRjRneHFSOFJCTDhtcElUK3dnNVM4T3I3UC8ySCsveFJ6ZWdN?=
 =?utf-8?B?ajhtd3YwMStuS3ZTT2FvRDljVWM0dGRqU1RkYm9LZVlPTW9wWmVIWkQyUXRU?=
 =?utf-8?B?TXBTSXJQdUdndWhhb2tQQm5McUMxd0grQXc0eUJER3JJYmdBdTZhbS9MMGRY?=
 =?utf-8?B?NitrdXVnSzhQb2IwbDFkWEZCbGpVTXF2Q0lpS1BGWWNCZkhPdC8wMDhTNGtM?=
 =?utf-8?B?Y05aYk1QQTNZVGVNSTBRRHRUMS9KUENXd09RSTdENDdOT0l0R1lxMmV3MzEr?=
 =?utf-8?B?TzcwR0lXd0xIN3h5MkVrTEJZNDlkc29lejFwYzJVUkpManNzYWszQzdWbHpK?=
 =?utf-8?B?M3B1ZDM5T1Q4dmFCSldUdENKMVlEL1gvdUltWHhRdW5FQlM1elVkT3RBdFNB?=
 =?utf-8?B?SHRGYVVOeFIzOEN6eWdranM0aG8xMUt6ZEVqWnA4VEV1TFV2QnlNVFcrSldD?=
 =?utf-8?B?STRQRGgwKzR5Zy80aGh0eGd4cERQYnMrNVF5OW5sa0IySXlxdkRvMGs3YmtJ?=
 =?utf-8?B?KzdJN0xSZDdrSzVVd0g3VWt2NUEyODR3aEJoZ1ZFTkx0a2ZsQU1lRmZBeWg3?=
 =?utf-8?B?N0dzQ09Pd3lmTjFQcGx0RXYrd3l0WWR2TUxDME0zMU9rbURVWHpYMmI3VFU4?=
 =?utf-8?B?OUZ3UVFta2FrbURJNXE2YkxiR2cyUjBucWpYQU1pbjkxc2RZaVpNaWJZZW9Q?=
 =?utf-8?B?ejJ5SnBXY05hVWhZYTMyRldydjJLVnRkOUU3NGtZaUt0bFNQK24vOWVaWDVp?=
 =?utf-8?B?eTJJU29RSDEyQWxKZlRWbVFZWW9XWFFmV3VBTkthdlBLbTRGQmRrRTV4K3dH?=
 =?utf-8?B?SFJ3encrNTE2Sm9KYU5uclZ5ZzFySndOOU0wMjJJL0h6MW9Vd09xcDdyRC9n?=
 =?utf-8?B?Sk84TkN0ZGJoeXEzT3JDUDZLR1B2YmczMC8ydVE1SnR6ZGlxalJaK2J3U3Nt?=
 =?utf-8?B?T0wzU1lGV1YvR2hWMDc1eFdTcHJqUjEyTUdyVzhjY29aL1hwVmVjdTV5dHV4?=
 =?utf-8?B?TWZzcDl2VkVPS0pKZkprZ0JPQnNjcTBIWkNja3VHTGRBREczanhYMTZoSVhP?=
 =?utf-8?B?WTFOdks0VmJSS3BDVi9NNEpwcmNPVG9VZ0l1a3BlRzMxcjBiMVV5UC96dXds?=
 =?utf-8?B?TEx0bWIzUVc5Sy9LaW5HMkREbUI5K1hkQm9DT1JBSnJIYmlqZVBSTUVkaEFo?=
 =?utf-8?B?MUpoZVN2RWsvVVAwN3NoaWN6UWlJL2V6U3gzMkxObGZxdTRSMTFUNkMvbnZr?=
 =?utf-8?B?emFONHpNaHJPUXNhM096eHpwOCtVNlJNM2Y4MDJSODB4dmdsQWxMRU9IWWJp?=
 =?utf-8?B?UkIvYlIyajFwY1J0T3VnSHlhVE9CWVk5ZFBVM0l6em9tTTlObm9oMVY5VXhu?=
 =?utf-8?B?Syt2R1NuZGo1SWhpOE4rcGJTZUJZMmRtRU4raTlkcStGWmpURUxXdXIvQ3Vk?=
 =?utf-8?B?dHk0TjZObEFZM2s1enppa1N5VGdybkF3aXQ1MmVPMk82NEtYaFRSK0xwYWlF?=
 =?utf-8?B?ang4TWw3NncvWTViMGRJVWNUSG9KT2l5T0N2cVRqdXpzYkZPYkxrOUJ0eUxB?=
 =?utf-8?B?Qlp1L0FPd04yNFVIaEE4Y0ZacjBLZzk2TUZpRVN4NDRNV3NQOFFoOStqNlBK?=
 =?utf-8?B?Z3lnYmVxWGQvZUtobmxLRlo4Y2doTUR3VmR2eTlFdVJEQUlIT2RURnIyaiti?=
 =?utf-8?B?ZGEyQ2hjNUxGQlRKYmNzQ3lEVngrK1dOM3BmZ2F2VUd5RDM5MXEvNzg1N2Ns?=
 =?utf-8?B?QmNFTDViQkZielp2dld6MnVhcEFuUWVCSlVvdzcxeGZOa0IxTi95Z09oQXBl?=
 =?utf-8?B?UWdpTWgwVkxUYTBEd043VVFWbWxlSGsrQ3VjOEh5WVhNV2E5c3BDcVRZWXJz?=
 =?utf-8?B?Z3RKRkdURzNJc1pXdXlrOFlnb0Z0cUFvRldFUE93alZJOVN5WUZyMmt1OHNM?=
 =?utf-8?B?QlNwVmxZZHNiUTBlamtIaTNyK21KVzN0V1BZbFQrcEJiTUxSV05UYmxBMys0?=
 =?utf-8?B?Ty9CQ1BmTytNbStiUmR2aU1jbG1SWnRzM20xU3gzRldMVmVCMEdYZ3ZJS1RM?=
 =?utf-8?B?UkFmZnM1SWhkOW9iNVY5WU5QMHJiM3B4bEwrKzBxVVFYNW51TFd3SXJGUjNs?=
 =?utf-8?Q?CIbz+38YCBbwL0dM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3E02DEB7CEF1F4CAB57EF119B7A08ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e749b2-4ced-4e3f-d247-08de7493e505
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 17:32:48.4111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/2PEE+aiczqCmOI4qFAhqB27qW1CAmPXTnVbDeSq+NIuOZwnpAA4uBCFLcwOhJ4G9ZrbYgS6ULIbp7K2Zj5e2Ki0uFMp59/INzxfji/ckc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5813
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71856-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 2187519B9A8
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDE3OjIwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiArc3RhdGljIGlubGluZSB2b2lkIF9fa3ZtX3ByZXBhcmVfZW11bGF0ZWRfbW1pb19l
eGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gKwkJCQkJCcKgwqDCoCBncGFfdCBncGEsIHVu
c2lnbmVkIGludCBsZW4sDQo+ICsJCQkJCQnCoMKgwqAgY29uc3Qgdm9pZCAqZGF0YSwNCj4gKwkJ
CQkJCcKgwqDCoCBib29sIGlzX3dyaXRlKQ0KPiArew0KPiArCXN0cnVjdCBrdm1fcnVuICpydW4g
PSB2Y3B1LT5ydW47DQo+ICsNCj4gKwlydW4tPm1taW8ubGVuID0gbWluKDh1LCBsZW4pOw0KDQpJ
IHdvdWxkIHRoaW5rIHRvIGV4dHJhY3QgdGhpcyB0byBhIGxvY2FsIHZhciBzbyBpdCBjYW4gYmUg
dXNlZCB0d2ljZS4NCg0KPiArCXJ1bi0+bW1pby5pc193cml0ZSA9IGlzX3dyaXRlOw0KPiArCXJ1
bi0+ZXhpdF9yZWFzb24gPSBLVk1fRVhJVF9NTUlPOw0KPiArCXJ1bi0+bW1pby5waHlzX2FkZHIg
PSBncGE7DQo+ICsJaWYgKGlzX3dyaXRlKQ0KPiArCQltZW1jcHkocnVuLT5tbWlvLmRhdGEsIGRh
dGEsIG1pbig4dSwgbGVuKSk7DQo+ICt9DQo+ICsNCg0K

