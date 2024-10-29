Return-Path: <kvm+bounces-29913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E430C9B3F20
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 01:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3EDB283136
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 00:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEF117543;
	Tue, 29 Oct 2024 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W4Mml5TE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6024747F;
	Tue, 29 Oct 2024 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730161455; cv=fail; b=H688UCUHkRbXY+RXD1f0C80RqQmwxhucumMUrM6o0eK6byqqE9FZEUKrYTbfjZ3K7aRLaisOLres77K0OubF2hIL1PHilwGQNSPREkIEf1BJWpHYV5m8jprgLtqFMz5GVJhng6hmzoSRmW15AlJ0NyZ46nAHDSRo0wx9UY6A0ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730161455; c=relaxed/simple;
	bh=vp44iCZAIz26gxvr8Yg8QUMF5gct+letmieleHiC+7Q=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DE7gZNGv3Q695Y4COj/5/95vrIgZYUrA1Xj7U7w75XviGhsDCiRwpDaic1Cvt3ynjrlX+S7HA9ohOaPdGvDCTi4PAm7h+n7p2dCh+bbZKhj+bNKSW1TG0Pw1DY1gv7htlm16pU7ji2vmLytw58XF8lV9wzGarv7Rtj8adGBPAls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W4Mml5TE; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730161453; x=1761697453;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vp44iCZAIz26gxvr8Yg8QUMF5gct+letmieleHiC+7Q=;
  b=W4Mml5TEzpSVgMVdLnD6ZF1uprm3Bc+hr+wwYcHBz31/HjOkFJW9v/Za
   ++GIhv/3UCHAPDCo5ca14x2gzWdtVk0SWbvjrOIfKoEn1TwmMPG2Di31N
   zs/J90teYFlTSAiniGbyuFxqY44BUhLrYukyDUiEZp98dZ3SUJwl3bVht
   OcFzdJ5Lspi65gNsfrdZmkOVIY7HEWdi9e/P17Y6XfPy19X0R3I4yuEos
   OVNXD5h7QMX6IAadaakV4zyjToYXkBvVveNoo+yQW3jVqdqcJMfHiw2So
   pV+hWy74an5yBU/yIjtSFvsdy0jrjSSseIFd7L/sPpHjSRyWKoezMMrG+
   Q==;
X-CSE-ConnectionGUID: sIx7sXNSRMWUS1j25nxBXw==
X-CSE-MsgGUID: mOFsgWkATOSFv6ceUe1lyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="32639628"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="32639628"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 17:24:13 -0700
X-CSE-ConnectionGUID: kOy8k4qYQAyS0wz5dzruQA==
X-CSE-MsgGUID: PnKaQgkbQVCOg10rxIwj6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="112594135"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 17:24:12 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 17:24:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 17:24:11 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 17:24:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJFSMiz/7+YsYng85iS31db7MwwFJ9fiB0sm6olVXrSnTe1kuuCMmFVPdy2O26U2t5GP2HsxuvX0P7kBeqv/PzJKNN/thFVeEjd0/L1O+Sep0vRqE0klQruQ3NxfuPGJ+d5u4xlgTLO/dc5LUP6VEhgFPdCA6cTuZPaQxWe410d5jY+jpbhlb18ckCEDcxmL64edEblKmSg5Fd4ElQj2qj1TJpO80aONAs6miZbFUEGNGmD/sp/JyO0w8oGkrRJr2lq3eTel+VLwEHDDF8/PaziTB50LXxRCiqCLVKlD6MsH6DYcmBMQ0QQTnqNxyxdVd1Ob0XI9dcIoRRItZ43Tnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOgpbi4M2QGtSuBAWcgU9lvw+F9gM0N4PB+16dIWCiU=;
 b=Qn/F2ElDKE8JLDLo6nT6i6KG08meZnGc+kaqkiu+sq557MzJ3OmWi/gZe0g0+F7fjBmPD9bH69EP/0U2u/sntN4O+Nq6OhEqMaZEKuhrfQ+L80kyUZEJXXf0fwJ22/S/NL1FZXRVdg7nzZRy2GabVRLWBneg30EP6OTirlsclxyMWJWxsLePfHG39A692OvHz03GIDgWwZSnwoqv3WB8f00H1GYK/fvfyF16ODW/s7O4wU3GvgFak962Lh1q9GwOG22ElRBdGsKPUpmPapBcvXeyPfvVyzQKeeJNQDy0GSLEvgG8rYDbgYBfAoD4rbDPME4/qe2lRg+A8CtUrmL5vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7873.namprd11.prod.outlook.com (2603:10b6:930:79::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Tue, 29 Oct
 2024 00:24:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.023; Tue, 29 Oct 2024
 00:24:03 +0000
Message-ID: <6c8bff1a-876f-47b7-a80c-3f3a825ddbc0@intel.com>
Date: Tue, 29 Oct 2024 13:23:55 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
From: "Huang, Kai" <kai.huang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, Klaus Kiwi
	<kkiwi@redhat.com>
References: <cover.1730118186.git.kai.huang@intel.com>
 <0b1f3c07-a1e9-4008-8de5-52b1fea7ad7b@redhat.com>
 <08c6bb42-c068-4dc1-8b97-0c53fb896a58@intel.com>
Content-Language: en-US
In-Reply-To: <08c6bb42-c068-4dc1-8b97-0c53fb896a58@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::6) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY8PR11MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: 77ea6144-4b73-4a15-88ad-08dcf7affe1c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YkZQMCtDWDFMSFBENkNvMm55aUFKaHNnV0JHUWwrSDU2RHprdUFUaVBTRHpL?=
 =?utf-8?B?RXE1a05oSGxZVTZWdnk2SEI0b2x0a3V6MG5wUmlDU084OGJlRjBaa3pMbkNF?=
 =?utf-8?B?NExWbjBlOGs5cjl3aWFMNHVuYTZBM05QRkJhTHBwUWhsWnRaVEtoRVpWemNa?=
 =?utf-8?B?V25IY3QvYVZUWUVnRm1YV1QzeUI2OVlCZ0o3NDgxREVrSTdMMTNLeHJSZlYw?=
 =?utf-8?B?RGEvQkhmRncwUy9sVHF6VFNkZ2FraGt4cXdWdlBHMlBBa1M1bE5vMFVobk5u?=
 =?utf-8?B?MUhCUTJQUVc1b0wvZEt1VDhPZ00zN0p2aVN5QWlkcVVBd2ZTZTFpaXVYQlpj?=
 =?utf-8?B?WUVleE1vN0VaeVplaC85Qm9nSWcxV2ZrVHc4RWExZ2wyZllaeXczajZqaXh3?=
 =?utf-8?B?SzQxenEzUVZCKzhJZkhZWStHa1dPVW03TnFGOExERXV5SWVxUUpldGtTVm8y?=
 =?utf-8?B?YjAxb2l0ZnVJTTdIMHJzbVVIQ3l6ZE9SN3oxMjJRMVArNDFJcUNGcWVXd2hk?=
 =?utf-8?B?QXV5cU5YSFJ3dGZ4b0trUzBzaFBDeVlrQWtSeTM4WXpneTljZHVzczVrNWFz?=
 =?utf-8?B?N2wrdkF5Y0JRTkFBQ3cyMkVaR2JjQzVjN01ha2h6eHdUa3JwY1J4Y3dLdm94?=
 =?utf-8?B?WDRKZkFsdUsxbWZ5Uko4MDBZY0ZUOUFRb2N6ZzNqcDFzeDZWdElWQUdTSjdZ?=
 =?utf-8?B?QUFHcmwrVVRoNWs3U1RnejB5VkNKdXdzeFFBdjJMbzlIZnAzYmVXOFRxU3oy?=
 =?utf-8?B?NGI3YmRENUxjNGlGWWY0K2JsMUZLSFU5dkxJMmxBbjJzUEhsc251eStuZUJV?=
 =?utf-8?B?VE04VlRiLzhrdERPMlh5UWxVTnRNVG45YkRmUDVQSFJibzZKbjU4V3g1RS9m?=
 =?utf-8?B?bGhVblphRDMwcUx2MjdkNzI0d2R5NFh2a1NSYnFZTEkyMlk2T0RjSld4SUdV?=
 =?utf-8?B?NURQeDY2ZWZTNHFlR2J5amFLTUQ3bGpBWTZqZGNwSXpYazM1dGxFM3pwZVBO?=
 =?utf-8?B?dEswNkZQdW5rK2tSTnNxa2xqOEFVQUlYbGhVQU4yRDJ0a2Y2REU2ODlROUxE?=
 =?utf-8?B?RHVwVi94UEQrT2lleW5qa3Nqc0VPNWJwRmdIN1R6QXFsbjVMQUNuemVGTDVu?=
 =?utf-8?B?bXZNWnBrZ25ZR2QzanZXUWErc21ER0hLb3JCOGVEZnNHalU1SWtVT1FSenlM?=
 =?utf-8?B?Um5QaEl1SUkrZmNOVmlzUCsycXU5dlVtYjVkWlIrdnVVMHR3MnE1SW91SmY0?=
 =?utf-8?B?cEV1R29ZZFZ3N3JYeXFiV3BVZGVoWVpXa2hLSFBaaXNDbWQ0TTJpY0tTV0I1?=
 =?utf-8?B?MFBJNFgzWnJSRzYrSkh2VnlpbktRNllCYzg5K3Rabm9aSk1OZnppQlJMd1RK?=
 =?utf-8?B?VmxHYWVSMHNicXlUcmxyNWdzdUFEVm1OVmFLVHg3VWoybDg2VnhuRDJHejh1?=
 =?utf-8?B?UkVCRSs4WFg1c1RJNytqbVAyNEpsbjl3OHY4bVBvV0toeTg1V0ZqQmQ2T3hL?=
 =?utf-8?B?MkNsOTVHU01ua3pHZFlES29ldmhMbE9xY2JSL002Vmh3OXBYSWFaaHkvbTBs?=
 =?utf-8?B?ajE5WnkwMjIwcFArTzRJMVdEMEdVVVAvQU1FRkFWR3JMMTZlQ2lDQU4wSm8x?=
 =?utf-8?B?djlhOXdzemN3bW91MG1OL1NndDZHLy9zY29KVU9xdnhkUDJVRkpiYVlQSXBM?=
 =?utf-8?B?Mit6ZmZDK0FLc0JFSU9RNTEzNlZTVVpDb1N5UTQ5bFRBRzBGejg5RmR6ME5G?=
 =?utf-8?B?NE9xTkF4WFVUT2xuR1ZxUjNsOURuMkVmNG80NFFmdXFvT0k0eTFDM2ZhaTAw?=
 =?utf-8?Q?/n42M3eJm1SVQh3NzvMdwtMA8vD5e2IMqcfo0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXphZ1BiV1YxUm1tK21pOVhHaEpZZzVpK3cvR1p2RXJ3V1hGR0NtS3ZRdDlP?=
 =?utf-8?B?RE5WTFV6N0xxc1AzS255YVA2WnhuY2JLb0ZvTkdwYUU4ZkhtNVpwT0krdUVP?=
 =?utf-8?B?VkI1L1IwNDh1aHdJdzlkVjVGcERmOWd5Ujd4STh4TC9qSmc4VUx4TkVLQ1pU?=
 =?utf-8?B?MnNSbVgxajdQV2ZtekgzbUd6TlhLTW5DNW1Ed0c4c1ZGMDg4QWdSbDA2TzlU?=
 =?utf-8?B?SWVqY2tUSWcyd00wOE9XTk80QjdsZVp2U0ZNbjllK1dHRHVKcExJQkM4UEZF?=
 =?utf-8?B?UHZORjNOdTNpb0YwOE95bnZ4UWgzcDRUQ2pWSFJxMHRsaFVna2xUN1RFaUdm?=
 =?utf-8?B?SHB2aDZnV1NCY2dkaG9TSDJJejlXUHdoM0I0SVdwRUtwVVlOWXJDcFo2Tkgv?=
 =?utf-8?B?VUxVS1lWU0FxRkVWMXQ5SUMwYUlmbFFDRXE4eUtlM3hhTkR4SCtlT3VxQXR4?=
 =?utf-8?B?cmlEMUNWd3FhWElnTWEzdUM4U3hKYkpUQnJGR08yeDJ5WElhK3R5b3hidGhz?=
 =?utf-8?B?NlFxTnBZYmVvN3EvMG5tUkxCL3k3TDF4ZjcwUWFVMThld0hTNlc2ZzhCT09h?=
 =?utf-8?B?MzE3UlBjQXJTZnVmNUFZSlYvT0k5c1g2RjVNYnAzeHVmb2lEQk1nekt2c0xs?=
 =?utf-8?B?VGpLaVYyeFRDNmpxTng3NmNESTYzUjBYdElKOWFtSldrVUFReWV4ZkdlMkxv?=
 =?utf-8?B?OCtUNW5mWUROTUVDbElCdGFDTk5EV3I5TDA1b0tvV1Rhdmo2UTQ2WEZlN3RR?=
 =?utf-8?B?MkRod09YRTg1a0ZRN3k2ZkIwcHE3dGZyUUxjcWcvc3QrUHR4WWF3Lys3YXpk?=
 =?utf-8?B?NUUvbHFHS3NzRG9mZUZYOWJ0ZFp1cUZjQ04xRjhLdzJNeTB0UzNCNFhzcFpq?=
 =?utf-8?B?U2VLQWduMVBheDdHcEZhRG1tSXNHei9qKy9qQXVMMStvR2lzbmMwV2dJb2tG?=
 =?utf-8?B?cXZ4bnB4YmhIanlWK1dqYmZ4U25hL3c4QnhmRkdTcE15aVFDNkNLckJZZHB2?=
 =?utf-8?B?d1BjSDM1Zll5SVoxaW5nUm8rQk5rNE8vcDdKU3NHWitnNGJKcVM3NEgwYVVw?=
 =?utf-8?B?REhIbmVEbitSKytpcHRjb0JvVlJDTXFBcTQ1ZWhSUjQ0NGdtUlRRRzg1bUhz?=
 =?utf-8?B?UldLdFFSMXVOSkt3eSsyS0szZkQ4SGpibmU4WEI0eVVHME5FTTJQazNpeTdO?=
 =?utf-8?B?YXVNZTlXWVREbWl4elcyRXpjaWh2dDM5VEVLY3R1THQ3Y084NUtlM2s2VjdS?=
 =?utf-8?B?ZVdVSm4yVWJUbmV6VGhGZElaclNjTEdDTzc3QkZKRXV3UWI2L0ViR3U4R2lP?=
 =?utf-8?B?SlZKRk1UTDFuZHVDK01mUkMxbWZhdEl6eTA4enNwSERURmU3c2pOT2ZmVXFY?=
 =?utf-8?B?aVZSc081OTNmS21zR0h1RjcxVm9Td2pEWTN1WWI2dk9UQkNjbE5zVlpsZDlp?=
 =?utf-8?B?ZnVhOUdmbk81SWNMYW5haEtSdzBoWmx1VnRMay84aTJUb3YyZnd2YVNaa2RR?=
 =?utf-8?B?RVBuSEc0VlQ3eWNKaURSYWFQalk3NHB3VFdWVFdHNU96VG54a2hqR2cxa2dh?=
 =?utf-8?B?UUtVdVBNaFE3d3NNSWExTkE2VHZpcUVsdUhDRTN5bkhFTHVqQSsyaENTNjZX?=
 =?utf-8?B?RFpIdEkwVTJVU2JDVTV1Q1ZNeHFTRGMxNlRBWE14ZFhQdFM2QXdubWhsZnds?=
 =?utf-8?B?Slp3VnFuVjkyemlURWgwQ2ZWekNrMXpoVWp1aWRYMjczQVl5ektPUHVRSy9t?=
 =?utf-8?B?SVNDcVdlYlRjcWlvamhHODl4cEExT2kxeFdYaDBVRlIvWHNaUXVvblNFK1pY?=
 =?utf-8?B?cGpCcDExRzJqODQrN0VrOXZmT3oyUmMwT3Uxb251MFhEU3U2NWJXZHBZZmJG?=
 =?utf-8?B?ejNKN2x6cVVQTVFzeFNzZGIxeEsyTWpSOEdmZGcwdnUySFZlVDJYTFppN0ph?=
 =?utf-8?B?V3lFeGZJS25SaDI1c25zNGhJc1Z4OWNHQWMxeGlta1FLcUhCVXZjOXNtTE54?=
 =?utf-8?B?SWZuOWNuVWxFNnc5UDdxQUs3M0Nyai8zRzdjUW5SMng1VWhpTFNwNVpHMFVl?=
 =?utf-8?B?U1Bucm1hT0Y4cUw0c0R4Q3dXbkVoNSszYnNhNHg1U2oyd2VoQThpbU5xRUY5?=
 =?utf-8?Q?S3wQrU10qR10WX5oivzFeNymQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ea6144-4b73-4a15-88ad-08dcf7affe1c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 00:24:03.6363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8i0pndDofWRCV0tB3DwHaLV5a6L8lSYiLQ3tz/z8FMPkMCxhKb4w9ZZlLpkx3tY6z8Rc0wgKg8a7emlwQulWWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7873
X-OriginatorOrg: intel.com


>>
>> Are you able to send quickly a v7 that includes these fields, and that 
>> also checks in the script that generates the files?
> 
> Yeah I can do.  But for KVM to use those fields, we will also need 
> export those metadata.  Do you want me to just include all the 3 patches 
> that are mentioned in the above item 3) to v7?

Sorry I just realize I cannot just move all the 3 patches in item 3) to 
this series since one of them depends on TDX module init KVM patch.  So 
yeah I can just move the patch which reads more fields for KVM to this 
series but leave the rest to future patchset.

But for kvm-coco-queue purpose as mentioned in the previous reply I have 
rebased those patches and pushed to github.  So perhaps we can leave 
them to the future patchset for the sake of keeping this series simple?

Adding the patch which adds the script to this series is another topic. 
I can certainly do if Dave is fine.

