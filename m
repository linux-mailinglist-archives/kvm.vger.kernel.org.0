Return-Path: <kvm+bounces-17480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CF18C6F3E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0099283AB2
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B8E50297;
	Wed, 15 May 2024 23:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B6U8yHVS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0BF101C8;
	Wed, 15 May 2024 23:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715816298; cv=fail; b=F96X3RKx+mp74pMR6ZvwCUOKa5e2jLmPwnrz4LS1T/KvY2BuLkqhE0ELpzgEbkldfRneOqtp8XQskGAKn8t6JrN8TNYJhRv0EZL2E4OXJZyoSiv7Q7YDDDF9LldQxVrrCpMkeaYEzue8XaNsSuseoRDHc8Iip1pN8sSijHrkVug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715816298; c=relaxed/simple;
	bh=WWmO6qbMRvfSDPbC/DhEYzFmVmPN3LJUNhdQH0BwleM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g2t6FjycLwGTlrPJYMkIKvwx8pmzEtUR1yBC44UDR1QTFdhZgZtKCy3+iXatJupsEtrNIgOWkueqzWMzWHjU7sLW+XbmGVq7XLwa4Eql/dAZaIwMfia4UKKYRPcUCY0oHHOXDM0D9/EbgpSFgfmZ5YhFbmOiiDVpW+bJuowb9b8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B6U8yHVS; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715816297; x=1747352297;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WWmO6qbMRvfSDPbC/DhEYzFmVmPN3LJUNhdQH0BwleM=;
  b=B6U8yHVSkIpYecnoYh4DnT78zLibgNrjgTYfD2E8SWkOxJBDUejKWL+i
   RvoEuOzW/AfsyjS5EMm5fYZhlExFmU80wAFsA1tLjHQ8xnQ2eYhIkO9EV
   Xz86ltL0ZvOFKtYnjptUszlVjeBR4Vw/TS4B4FcwoFGbG2pwfApF6L84f
   mdysZfsTUVA4Rt4Dc+t8tjSQl9P6efBIs+iAnEfcEaOnKE5O6DlORNsY3
   XAsD+x+JvsmOsDZN5EmpFnD6wQ2dNZggWUMXAoL3vtzGBTSmeZMwGgzFE
   IJcijyLaFqw1C1levidIhC4l7I/sdWHsbI7qIz84qn37UT/LQm0rTlCre
   A==;
X-CSE-ConnectionGUID: oD83oCjcT4Od3obPJAkGKA==
X-CSE-MsgGUID: Va8/4giUTZia/QpRF4aDCQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11545797"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11545797"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:38:16 -0700
X-CSE-ConnectionGUID: HOBBXQurQyKh1tZzCXPNqg==
X-CSE-MsgGUID: LWvIjduLQnWtqKz+yw2kNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31230525"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:38:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:38:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 16:38:15 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:38:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n887drK4oRpChXp1NjqZMhZ1lP1KbkYbycY1kwziFmdkUSbZd741A2or7Y0dxc6WqVv0G+WBTeZgBx7Vxa87VfQc9AGiFpfd6uGbM+w6njEF84LFCRj7YWh+tMvKEl502vReBx6KM3Fr2j6WAkxy8T5Nl4UlzmEG1Cy2ESjXPbNuGckdmnZ66EAoRfENGCbU/I1Hkhu7XennZiThjSgvl6BKvHxS71UMGD0hueVSBadCJ8ZE6gxMz/kNfrJnUjTogxenHcD2sak8URee8w8DQ6OU3Mgxh2EXi42x2ijk9TKVyqTpSUkC/ktrYuLYYVcVLGJ3P9JHMkzg2tUdK4swMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWmO6qbMRvfSDPbC/DhEYzFmVmPN3LJUNhdQH0BwleM=;
 b=S0/yFQ5The4Vm3k+wyS9LVeSE3MvXxXzwjC+bDVp7mHudQSlK50gpkmtsgGHXLMUviGIspRnzfkSujqwCqyb7JgJPVobKABdTUq+axqWx7Id9vCsbDw0w+xl3FtB6jPKING846GYe0LPIlpB5dIPHOhRbRfQ6jWMntVlMSdyIddF1R2SZ5sOkDIeWz/EX748p8GfqCO2KppUSz3YcyN6H6DwYVY6H8TfO8hyjMyRhK3YDBbs5pMUwrPKOHYWDHekenxo81I3yDJrQEFA3H2IDqfuhV3RjBPKnA+qDXIC0E0/huinRLkTD/LQ/X5KWOKqctZhpboGw703xzUbvhTZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7250.namprd11.prod.outlook.com (2603:10b6:610:149::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:38:09 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 23:38:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaA
Date: Wed, 15 May 2024 23:38:08 +0000
Message-ID: <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
In-Reply-To: <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7250:EE_
x-ms-office365-filtering-correlation-id: 9ba397d7-3fb7-4040-b9a0-08dc753813c4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NGRsQXJROHF3aE0xWGZRNnRxWjllb29nenc3R1FnQXNLOUI1UTY4Wlc4dTV5?=
 =?utf-8?B?M0pYMU90T2JwOXdWZm5WWmRPeitzczN1eCsyWi9SemxXL2dZSmx4aS9sNERB?=
 =?utf-8?B?dkx1MmxidGovVDYwczdVK3J0c0NOVnRKVFRWWUNCbGozdU04ZldsbUR1K3ZS?=
 =?utf-8?B?VVBqVjFuSjJiekJmb1FtUVV6a3pzN25UVUhkT0U0eGxqYXlPbmJGUXhROEQv?=
 =?utf-8?B?UmttS0Y3blRnVk1abWJ4bm5zVVNkekZBcDlhSFc2WndFU01KYzdhb1g1UTBV?=
 =?utf-8?B?bk5iMWhiU2NwdytwUlh5c3VmY1pkeUZMdnFGaUF0clBSa3lpN0kvbzBWS2FJ?=
 =?utf-8?B?MThxQVdCTWdFQVJ2WG95d2pCc2FyeEZPbENpY3VTY2JvSVk5TUJNYnNkYllx?=
 =?utf-8?B?MWlvaTI2d2h3RDZVQjZrWnJqczVmMUVXQmdFaUk1UHc5Sm9kRFBmeHlZdFM3?=
 =?utf-8?B?SDNCaFN4dnZBeFVtZk5uNG0wNUpLY1JrN05lQU9UdXNVMFZtbm1UTWxST0hJ?=
 =?utf-8?B?ZnhtdW8yT2xITnVVbXozUVpIckFnYVN2NTZ1THI3cEFzMFlIb2Z0MVp4SUZY?=
 =?utf-8?B?VkxUdGZ1b0w4eDlaL2tBRXQveHp5YTBEMXZYVFVteVRUZUJ2bnd5V3kwRThG?=
 =?utf-8?B?WjNQRXJ5VWxkTEpxT2JXdXJQc0lIVXlkTjJWTUhzdmhnZjhVZzNWdE40cTlZ?=
 =?utf-8?B?a1lpYUZzdUhGY2oyaEFwaVA4ZFowYkovUWxBS1JwTFpBZTRlSEtmVDh6THNL?=
 =?utf-8?B?MjVtT2I5YTE0SVdYQnB1TGMxaHk2eTlaRmlKOGFSNFJKeG1TZ1NQaGxudERH?=
 =?utf-8?B?VFNwZ1ByZVpYYlJIRllLTGtlUDNIeHk1WEk2MFdWTDZzU1grQVZrQitaMDdw?=
 =?utf-8?B?OEFGSEhBYitiTWdwQ3pxUzEwaEt6a1VUc0VwelozUmJGMUloSUI0cjFlL0V0?=
 =?utf-8?B?cS9tNHFBZi9CcHlpdzlUT2M1QUZXK0h2V2xleUNBWTRjb3NaMk45a3JsTmlU?=
 =?utf-8?B?bXo5cC90RWtzUncwQWx3ZkhqTHo3cVo2UXM0SW1QNTFaVWo4SDI0MmRxQ25D?=
 =?utf-8?B?Q2dER29WNnFJVVJqV2RKaWVEdmhMcjJOblU1empRZXgzdlVDTHpFR3NUNW9u?=
 =?utf-8?B?RW5NanZ4bTVSN1BURm1TTkhleDAyTVRrbDBRaWJDbGppZFF3NUtkLy9qT2lG?=
 =?utf-8?B?THV2WStUekl4YTFzeW5LRXdUUHJka29KNDNjWk1TdlZiVlNVTUY3QlY1NGdX?=
 =?utf-8?B?dWdERUFVc1h3Z1Y3QUQ4d012R1FpSGxxUWl4ZXVMTXo4UDVqbTdBRktDMm92?=
 =?utf-8?B?bzBFNTdCb3d2U2E1WVBYZUdnemdCUVlqSU5LWm51QW5NZ1p3ajlTSmxRdFkx?=
 =?utf-8?B?bVlwUzY2Tmc4d215cG1SRWZuV1JsMEVydld6ZmRkdnRZM1IzaThlT04wK21a?=
 =?utf-8?B?RGlCemtJYUd6bkp3cWpUR3RhdmhnaHRkQVlreFBiKzNFTkRYMndIaDR0TDNT?=
 =?utf-8?B?VnNxcTAxTUpnZWdpTkxRZTVvUTl0YUJMRGMvemJqY0hLY0dxajhOYzc2RG5M?=
 =?utf-8?B?WjZndGpwY0EvTE5jN1NrY2V3eE9UTW1XUkNSVENPZVFkMzJMMHErdlhQWmhP?=
 =?utf-8?B?d3oxR2dmY2ZUaXF4bmZQTXZlVGlVTmpWSFZSSDdNZXd6K1BXK0hjazZzbnZN?=
 =?utf-8?B?emE0LzIrR0FTV21HdlE4OGRUdTAyNDNpMDJFelJYZ2c1MFFSSGQwbGVocFJI?=
 =?utf-8?B?WjVsejBvWVEyZy9NaW5iKzdqa09uTEcyeTVISURnazVmdXZzeDVVWk5KQVVW?=
 =?utf-8?B?NS9ieTNWazdVTDVZUFpYUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkltQUhIekZwLzhTaGt4S0h1Qk14MWFabG9RMXhCQkdTVDh1VkRFR0tHdkJF?=
 =?utf-8?B?U3hPYWpaMWFNMGhKaFRmY0hYMDFEQUpSYkk2NHpOdE5BeVNhcGdRSVFEUVJq?=
 =?utf-8?B?ZktWcXg3enpPM1Bad3dJdGYwaW02cERPaG9KTlRsRkdHNTVJMXdwbXprNTVL?=
 =?utf-8?B?ajVRNk0zUE81VjRTd1cvUU1vWWhsMngveUJQSnRpRHlrbXAwd0g5dDhwVTJj?=
 =?utf-8?B?WlBBVzVGa2s5M1RheEU3QVFDVlFYMU80cnJiWldiTFJ5ZlhleXhIWk9oZ0JU?=
 =?utf-8?B?eldtWm1HR2gvM1dNd1VWR1R2S1hXemdFdlUvcEdncU9ycVpnK1BnaXJCdCtF?=
 =?utf-8?B?WlRNL2VoeHRrTWJFSlMzV1lHbkZYZGJ6VDlNMlJ2UmdNRlFEVkQwUk9OYzY2?=
 =?utf-8?B?bjBsYmpMYVRTRGVvbFZoYU53M0hwYXpjbGdSdzdsNG1wazB0SGV3VTN5d1g1?=
 =?utf-8?B?Z1BYZWNTMHZtMVZ4bWtjOEYwKzdDREJteDk0MXR0RlpCMVB5a2NmTzMzMlF1?=
 =?utf-8?B?ZHBvNksxbG1MdVlJR2l0M2IwZ2FvTkFGdE9Dc1ljekNHTFl5NEhmSm1OSW1T?=
 =?utf-8?B?VUw1TDg3QzRqSFRDQlBjU0htNElESkFXRmpHYll2Zk1LZ3QvalJkYkQrU0Rw?=
 =?utf-8?B?dmg1Mm5uWjJER3BXeXZveHo2Z3FOSVROZnFQMzBVODN2NURpM3VtYThIS2or?=
 =?utf-8?B?N0NGL1NxWXYwKzJCdEV6K1c4eHR6Q3cvWFBRaU9tMUh2dXA1Tk1zK0xwVUxY?=
 =?utf-8?B?SW1YODBtZXI2R1pBSU5MTUNsN0puOVR2bnFlVVFPeUZuUkdNZzNEWnpYTXp5?=
 =?utf-8?B?V1YyRXFqSit4dUFkUjRQTHpRVWJ2WlBiK0V1dXRCN1NRUEtiV29aWmpkUCtP?=
 =?utf-8?B?Tk53ZzZZMkpIbE9jZ1hKVHdPLzV4VW13R1g3dUZBUkwySHEvNS9zem85VzIz?=
 =?utf-8?B?USttSzh6QTA3TjdJU0F0VjlwVjhLSjhVRXRNUFRPRUZHWloxMVphdkJGVXVk?=
 =?utf-8?B?VzdhWFVpSkJkdElrSlpZczFHM1ZNcjlic0t3UTl2KzRENnI5TDFrajQwSHkr?=
 =?utf-8?B?OGtiKzVtVHdmVVhpU08vRXBUQWtBaHZ3UHdaK3d2b0w3Qk0vR0xDb1l1VEhT?=
 =?utf-8?B?RzVrbkJrRlhZYlF0eDVjUnhTMjNZclV1NHVZdmhscFF1czJqekZDQmhwVmxO?=
 =?utf-8?B?OUxRTkdQd2hMRTlidmFtV0hsWXFaeUVnZjRDZWEvekthRUpjMW1BRU1qZ3Zm?=
 =?utf-8?B?VmF1TG1RVTgyeUF3ZE9Tcm1MeFR6ZTlzOEZkV2FjNFYxOGlOMlJWaWNsZi9T?=
 =?utf-8?B?dVdqb3Qzc3FVaEZ1UWZFWnhrSTJRUEdTRm1CUTdES2tYc2VXb3BLeFlhZElS?=
 =?utf-8?B?K0dRSXFqNnkza0doaTZwTENyZGFjaE0wSklJcmFSNUxhRlVMZ29qM3Zta2ov?=
 =?utf-8?B?OFpMUHBzR0Jhcm0zUUVRMHMzemQ4MFRYSml0UmZXaERPQytCZkIxL2VPcURu?=
 =?utf-8?B?aC8xQ1hJV2ZIb2RHTURZSEY1MGRuNk5wNmhsbkVjQ1NRQ1lmREV3dytCdjJl?=
 =?utf-8?B?bnJmZmU3Ymx0R2hST2lNWkNodThzYlhubnFGUFgxQ0dhejRVRUJRa0Vsc1JQ?=
 =?utf-8?B?UkNySWVVZ0tIZllBVEJjRXZnRG1TQWpMV0s3NlA5V0ZBRGpDc2tVTnYwU1lv?=
 =?utf-8?B?WC9Ub3JHakJrM09qZkhIQmF2dHQ5QVBuT0UxV2huNjZ3aFhySTdYdG1QSzF0?=
 =?utf-8?B?aG0vNUVmZEtzT0pYOUl1S3hjNGxwekdpbmJ1eCtzZ0RjcU90Zm50RUpuZ1Jr?=
 =?utf-8?B?cHA3N2k4bUhWQU9aZXNNZ0dNR1JmbVBVNytxbVZubXh1RXByU3VKeThGYWxx?=
 =?utf-8?B?UFNJUE53STVWcE5Ud0lhcHVGZWx1NHBkTHl2UTBnWkdLUjBvOEZkN0pHeC80?=
 =?utf-8?B?V2tlbitOV0h6d3NhQThtMzVzeURacHVUYWlTeVFHMHRvUGNyTFNpNVBNN0ow?=
 =?utf-8?B?VVJBeVdMa0JRTk5WeFZWTEcwdkVLSTFhc1loUkZVVWNwTTVOZDU1OVJvdWZh?=
 =?utf-8?B?QW5vS1FPYVBESmxIOExoQXE3SVFIeWVjL1c1OXV5b09naVVUZ0VmOVQ4bith?=
 =?utf-8?B?QWI3NitFeHpKOFBrVHFqRGplWlRQWFptamQwR0tqTFUzNjU2dFppSEFMUGtt?=
 =?utf-8?Q?cxzv5nkHwmsEP6jGj81sJ1s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1233716562259746A1FE0C8A28270C5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba397d7-3fb7-4040-b9a0-08dc753813c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 23:38:08.9576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /bLSQWl3YFugTOO178lM7iSYfSE4bIMj7sdSwEqNgKRxsNV+G1Ua47EcuJuN7KHI+BknkCjCf4QkoiZxpTQib+hY9WnnBWYa0gFO4jMWUzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7250
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDExOjMxICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDE2LzA1LzIwMjQgMTE6MjEgYW0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0K
PiA+IE9uIFRodSwgMjAyNC0wNS0xNiBhdCAxMDozNCArMTIwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBPbiAxNS8wNS8yMDI0IDEyOjU5IHBtLCBSaWNrIEVkZ2Vj
b21iZSB3cm90ZToNCj4gPiA+ID4gRnJvbTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRh
QGludGVsLmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IEludHJvZHVjZSBhICJnZm5fc2hhcmVkX21h
c2siIGZpZWxkIGluIHRoZSBrdm1fYXJjaCBzdHJ1Y3R1cmUgdG8gcmVjb3JkDQo+ID4gPiA+IEdQ
QQ0KPiA+ID4gPiBzaGFyZWQgYml0IGFuZCBwcm92aWRlIGFkZHJlc3MgY29udmVyc2lvbiBoZWxw
ZXJzIGZvciBURFggc2hhcmVkIGJpdCBvZg0KPiA+ID4gPiBHUEEuDQo+ID4gPiA+IA0KPiA+ID4g
PiBURFggZGVzaWduYXRlcyBhIHNwZWNpZmljIEdQQSBiaXQgYXMgdGhlIHNoYXJlZCBiaXQsIHdo
aWNoIGNhbiBiZSBlaXRoZXINCj4gPiA+ID4gYml0IDUxIG9yIGJpdCA0NyBiYXNlZCBvbiBjb25m
aWd1cmF0aW9uLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBHUEEgc2hhcmVkIGJpdCBpbmRpY2F0
ZXMgd2hldGhlciB0aGUgY29ycmVzcG9uZGluZyBwaHlzaWNhbCBwYWdlIGlzDQo+ID4gPiA+IHNo
YXJlZCAoaWYgc2hhcmVkIGJpdCBzZXQpIG9yIHByaXZhdGUgKGlmIHNoYXJlZCBiaXQgY2xlYXJl
ZCkuDQo+ID4gPiA+IA0KPiA+ID4gPiAtIEdQQXMgd2l0aCBzaGFyZWQgYml0IHNldCB3aWxsIGJl
IG1hcHBlZCBieSBWTU0gaW50byBjb252ZW50aW9uYWwgRVBULA0KPiA+ID4gPiDCoCDCoMKgwqAg
d2hpY2ggaXMgcG9pbnRlZCBieSBzaGFyZWQgRVBUUCBpbiBURFZNQ1MsIHJlc2lkZXMgaW4gaG9z
dCBWTU0NCj4gPiA+ID4gbWVtb3J5DQo+ID4gPiA+IMKgIMKgwqDCoCBhbmQgaXMgbWFuYWdlZCBi
eSBWTU0uDQo+ID4gPiA+IC0gR1BBcyB3aXRoIHNoYXJlZCBiaXQgY2xlYXJlZCB3aWxsIGJlIG1h
cHBlZCBieSBWTU0gZmlyc3RseSBpbnRvIGENCj4gPiA+ID4gwqAgwqDCoMKgIG1pcnJvcmVkIEVQ
VCwgd2hpY2ggcmVzaWRlcyBpbiBob3N0IFZNTSBtZW1vcnkuIENoYW5nZXMgb2YgdGhlDQo+ID4g
PiA+IG1pcnJvcmVkDQo+ID4gPiA+IMKgIMKgwqDCoCBFUFQgYXJlIHRoZW4gcHJvcGFnYXRlZCBp
bnRvIGEgcHJpdmF0ZSBFUFQsIHdoaWNoIHJlc2lkZXMgb3V0c2lkZQ0KPiA+ID4gPiBvZg0KPiA+
ID4gPiBob3N0DQo+ID4gPiA+IMKgIMKgwqDCoCBWTU0gbWVtb3J5IGFuZCBpcyBtYW5hZ2VkIGJ5
IFREWCBtb2R1bGUuDQo+ID4gPiA+IA0KPiA+ID4gPiBBZGQgdGhlICJnZm5fc2hhcmVkX21hc2si
IGZpZWxkIHRvIHRoZSBrdm1fYXJjaCBzdHJ1Y3R1cmUgZm9yIGVhY2ggVk0NCj4gPiA+ID4gd2l0
aA0KPiA+ID4gPiBhIGRlZmF1bHQgdmFsdWUgb2YgMC4gSXQgd2lsbCBiZSBzZXQgdG8gdGhlIHBv
c2l0aW9uIG9mIHRoZSBHUEEgc2hhcmVkDQo+ID4gPiA+IGJpdA0KPiA+ID4gPiBpbiBHRk4gdGhy
b3VnaCBURCBzcGVjaWZpYyBpbml0aWFsaXphdGlvbiBjb2RlLg0KPiA+ID4gPiANCj4gPiA+ID4g
UHJvdmlkZSBoZWxwZXJzIHRvIHV0aWxpemUgdGhlIGdmbl9zaGFyZWRfbWFzayB0byBkZXRlcm1p
bmUgd2hldGhlciBhDQo+ID4gPiA+IEdQQQ0KPiA+ID4gPiBpcyBzaGFyZWQgb3IgcHJpdmF0ZSwg
cmV0cmlldmUgdGhlIEdQQSBzaGFyZWQgYml0IHZhbHVlLCBhbmQNCj4gPiA+ID4gaW5zZXJ0L3N0
cmlwDQo+ID4gPiA+IHNoYXJlZCBiaXQgdG8vZnJvbSBhIEdQQS4NCj4gPiA+IA0KPiA+ID4gSSBh
bSBzZXJpb3VzbHkgdGhpbmtpbmcgd2hldGhlciB3ZSBzaG91bGQganVzdCBhYmFuZG9uIHRoaXMg
d2hvbGUNCj4gPiA+IGt2bV9nZm5fc2hhcmVkX21hc2soKSB0aGluZy4NCj4gPiA+IA0KPiA+ID4g
V2UgYWxyZWFkeSBoYXZlIGVub3VnaCBtZWNoYW5pc21zIGFyb3VuZCBwcml2YXRlIG1lbW9yeSBh
bmQgdGhlIG1hcHBpbmcNCj4gPiA+IG9mIGl0Og0KPiA+ID4gDQo+ID4gPiAxKSBYYXJyYXkgdG8g
cXVlcnkgd2hldGhlciBhIGdpdmVuIEdGTiBpcyBwcml2YXRlIG9yIHNoYXJlZDsNCj4gPiA+IDIp
IGZhdWx0LT5pc19wcml2YXRlIHRvIGluZGljYXRlIHdoZXRoZXIgYSBmYXVsdGluZyBhZGRyZXNz
IGlzIHByaXZhdGUNCj4gPiA+IG9yIHNoYXJlZDsNCj4gPiA+IDMpIHNwLT5pc19wcml2YXRlIHRv
IGluZGljYXRlIHdoZXRoZXIgYSAicGFnZSB0YWJsZSIgaXMgb25seSBmb3IgcHJpdmF0ZQ0KPiA+
ID4gbWFwcGluZzsNCj4gPiANCj4gPiBZb3UgbWVhbiBkcm9wIHRoZSBoZWxwZXJzLCBvciB0aGUg
c3RydWN0IGt2bSBtZW1iZXI/IEkgdGhpbmsgd2Ugc3RpbGwgbmVlZA0KPiA+IHRoZQ0KPiA+IHNo
YXJlZCBiaXQgcG9zaXRpb24gc3RvcmVkIHNvbWV3aGVyZS4gbWVtc2xvdHMsIFhhcnJheSwgZXRj
IG5lZWQgdG8gb3BlcmF0ZQ0KPiA+IG9uDQo+ID4gdGhlIEdGTiB3aXRob3V0IHRoZSBzaGFyZWQg
aXQuDQo+IA0KPiBUaGUgc3RydWN0IG1lbWJlciwgYW5kIHRoZSB3aG9sZSB0aGluZy7CoCBUaGUg
c2hhcmVkIGJpdCBpcyBvbmx5IGluY2x1ZGVkIA0KPiBpbiB0aGUgZmF1bHRpbmcgYWRkcmVzcywg
YW5kIHdlIGNhbiBzdHJpcCB0aGF0IGF3YXkgdXBvbiANCj4gaGFuZGxlX2VwdF92aW9sYXRpb24o
KS4NCj4gDQo+IE9uZSB0aGluZyBJIGNhbiB0aGluayBvZiBpcyB3ZSBzdGlsbCBuZWVkIHRvIGFw
cGVuZCB0aGUgc2hhcmVkIGJpdCB0byANCj4gdGhlIGFjdHVhbCBHRk4gd2hlbiB3ZSBzZXR1cCB0
aGUgc2hhcmVkIHBhZ2UgdGFibGUgbWFwcGluZy7CoCBGb3IgdGhhdCBJIA0KPiBhbSB0aGlua2lu
ZyB3aGV0aGVyIHdlIGNhbiBkbyBpbiBURFggc3BlY2lmaWMgY29kZS4NCj4gDQo+IEFueXdheSwg
SSBkb24ndCB0aGluayB0aGUgJ2dmbl9zaGFyZWRfbWFzaycgaXMgbmVjZXNzYXJpbHkgZ29vZCBh
dCB0aGlzIA0KPiBzdGFnZS4NCg0KU29ycnksIHN0aWxsIG5vdCBjbGVhci4gV2UgbmVlZCB0byBz
dHJpcCB0aGUgYml0IGF3YXksIHNvIHdlIG5lZWQgdG8ga25vdyB3aGF0DQpiaXQgaXQgaXMuIFRo
ZSBwcm9wb3NhbCBpcyB0byBub3QgcmVtZW1iZXIgaXQgb24gc3RydWN0IGt2bSwgc28gd2hlcmUg
ZG8gd2UgZ2V0DQppdD8NCg0KQWN0dWFsbHksIHdlIHVzZWQgdG8gYWxsb3cgaXQgdG8gYmUgc2Vs
ZWN0ZWQgKHZpYSBHUEFXKSwgYnV0IG5vdyB3ZSBjb3VsZA0KZGV0ZXJtaW5lIGl0IGJhc2VkIG9u
IEVQVCBsZXZlbCBhbmQgTUFYUEEuIFNvIHdlIGNvdWxkIHBvc3NpYmx5IHJlY2FsY3VsYXRlIGl0
DQppbiBzb21lIGhlbHBlci4uLg0KDQpCdXQgaXQgc2VlbXMgeW91IGFyZSBzdWdnZXN0aW5nIHRv
IGRvIGF3YXkgd2l0aCB0aGUgY29uY2VwdCBvZiBrbm93aW5nIHdoYXQgdGhlDQpzaGFyZWQgYml0
IGlzLg0K

