Return-Path: <kvm+bounces-28820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABED799D9F6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCE9AB21194
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 23:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4021D9588;
	Mon, 14 Oct 2024 23:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJsP1Tvh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD4F137776;
	Mon, 14 Oct 2024 23:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728947042; cv=fail; b=BT8oOL41Pjq22s6nFqQdaB9dhhfT63I8H4njHh/Q6cJcpzJyQXbKe503Vo8uT/e78kyaBgVP4CvoFRiZa9jyuw/ERMWJYnKnKNPO8Au15HxLAoIioQ68+rStGFRaSvcaP4cTyXHP1LYa/OGoAtDwR39zB+87Bt/9pk0qaJqX0yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728947042; c=relaxed/simple;
	bh=atLhAlBuy3GVoixjqqdAFwjC+XLqT3izFJfJPJTEfnk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=azZJIrLRen5K7l1NR3tr1MjYGAPQLTeGL7LeTQKEYGy8xV21j9IcSWC2VPMafaqhPo8c2wYOv2fuWkLS6qRxuJc3c8dP4yeBOjYDQk0t7rwvtsnpgEQzaoFQa4SPXQH87nEuOxbGmBU4FgJoIej/cGUk5p8m1Nx4e2rIjelE5+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJsP1Tvh; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728947041; x=1760483041;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=atLhAlBuy3GVoixjqqdAFwjC+XLqT3izFJfJPJTEfnk=;
  b=cJsP1Tvhw0HD1OOLW0D45A7izpAtPvsOEsOJhTntWNbOBDxKNWoCiY31
   lQXEw9wppcDHiZpn8sh1Z0rHNc9iJJjrcD+cOCYlB/+NabKl+IWyIMiJg
   0sLFJKqarU8aYyPsfzSNG/BmgdSkFear/Zii8jMWVZSOpdBj/qivaOT2R
   VOPOFm9zOZmG/tEzvQZN4vX2twxRgm71OWDNT8qsxtqUPlm/+eszRor83
   oLGaCTvMA7NOLrdFsb9YaiAZZGInJv3KkPltWjz4gakENs3ErS38l9dpk
   on63Ig+qJqKqO1k1kdYtz6Z17QYWYq/8X3upoNM0m23yhz8xSB9raOktg
   g==;
X-CSE-ConnectionGUID: quOFjXOfSYauHrdQg6qfNQ==
X-CSE-MsgGUID: l0AswohFTXenolsdt8Jykw==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="32237104"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="32237104"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 16:04:00 -0700
X-CSE-ConnectionGUID: IlP3ScDMRwWOU4nqdq/7Bw==
X-CSE-MsgGUID: yfUtt4dHQt+0Z+MNWeMnRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="101054609"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 16:04:00 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 16:03:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 16:03:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 16:03:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBI7IE0uQ3A6J3XWF42hiSVKC8hh41XBkuLpW7oDahmVLFx2oZ5y5BQH9EvqZq7dcPpYWj6TnqL+N50rcvpUE8GWL8utX8LI9p9ymDmxduIWruyh1Xc/9mWEECwMl+EncJQoTn58M0FF7VqXSSsBvh1OdiShdLiponxZVA4nra7jDgCBcDeemd85n8jxuv6nUAnrY3tkGyFq82Z06tNvKVEGidqeqwvtfvEhkQcjYsm/eDLWProW50Sn5jJi9x4/HZT8OhN9EleZ0sbDT5arHweOgo7P6RxHyVwkzIgTACgSYr0Fq3bpezqv6hHE54/FHTQoWKcivREnGC64VoxMWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yEWJaMn+/jdC8PP2xKD/xYVtHskPmYae/M1Ce061pfI=;
 b=KU04Jl6rpDRXOuvEZwoDuYEL9u+RoKjhydTci7HVtdxs1CB34jMkTSZ56N0CrsJcltx5CY2pqEpjRzNBMlhBvOEUNbvn6kPlBvjQimb4Nf4fSv0i75p1J9Ao0sCeFN/vDjpNdqT5rBfUHciBtOApbeaGXDEO7Elgnzh0S6wj/+WSyY8d5q9vwlVOIgBurnwvSJNato3fIpghkGVkhAsIhfp9bU6gA6gDIVEjooeStP4DFzGWhvWlB2//9W73KBPacdLovP6yXKYaEZUcEtXuOAKlZ2pltJ5NGAn4/bavqCfShntfOs5bF8xkEiwdM5EyR8mPrnYqrrOHwuT7g1IjUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5088.namprd11.prod.outlook.com (2603:10b6:a03:2df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Mon, 14 Oct
 2024 23:03:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 23:03:55 +0000
Message-ID: <6571596d-b8bc-4759-8378-6cc8ecd65c97@intel.com>
Date: Tue, 15 Oct 2024 12:03:46 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yao, Yuan"
	<yuan.yao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>
References: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
 <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com> <ZwVG4bQ4g5Tm2jrt@google.com>
 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com> <ZwgP6nJ-MdDjKEiZ@google.com>
 <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
 <08533ab54cb482472176a057b8a10444ca32d10f.camel@intel.com>
 <ed6ccd719241ef6df1558b69ec81073a3b3cf77c.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ed6ccd719241ef6df1558b69ec81073a3b3cf77c.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5088:EE_
X-MS-Office365-Filtering-Correlation-Id: c9cf7aec-acc3-445f-5a40-08dceca47a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dHRtZEVkTlp3Skw2bnpwZGVSTGFRQ1Jja0dOLzJLOHV3TFpJWmRjSmNKOWFx?=
 =?utf-8?B?bG9WOTR5WUtjaVpDZ1UwRVZBTC9ObnVra0FZYitiTUxTRGdTMkQxc0IzOUpp?=
 =?utf-8?B?eEhTMjNMT21TbjJYWlExQTFaQW5GY0RZN0ZqQkNjdG8ya1FvK2tUZXY0dFJ0?=
 =?utf-8?B?a05kZ2tvYVBFWStEaW5sUCtsODh1Zk9ib1MzcHJ2eGxCcUVtMEJmc25ORmtE?=
 =?utf-8?B?S3BSMlVHcXhYT2Z1Vy9VUTRzRkw2azl6cnpCNDEyd0lSakxIKzcyeWJpNC95?=
 =?utf-8?B?ZHl3a1JIdzV5UG03K0dmamZHYmYza0RqQ0tESnU2K08wQTJkTWxCZmpaMStm?=
 =?utf-8?B?NkdQcmY2aUVCbWZYSzVoY0tnRm95RlBlamlKbnZBZlNGbU1OcEN0V0NTR2kw?=
 =?utf-8?B?RGlneEh5NndyckxaaHRRR1pPRmd2UGlZS0g4emZXOFdUMTNjYmRzVENnOGtB?=
 =?utf-8?B?Y0FpT3JPeTE1MzRlRkJHc3QzQmhBRjJUM2tMN1VHT01DMGRlZUVZZGoxVnox?=
 =?utf-8?B?Y3JwWVd2dTYvK1ZUZlFmeHJTSXJCcHJxQmRUVnNWRmg0dVVnaWR0aWx1L3V1?=
 =?utf-8?B?UU9YSm9iMjNJbmZVMXlES2hUZjdDcFhIUFhkcWZIeE1vWFgwRTdXeWNheExU?=
 =?utf-8?B?RTA4eWdrd0YvcHEwZjJNa2ZQOFkyeTc3NGJWMWRCaFptc3ZVTHA2eVJmR0Rz?=
 =?utf-8?B?SW5ya05ES2pwcnA1YnVocy94cGN5bGtrMGpFM0tRZnE4dnJRdVVubDZuY1JC?=
 =?utf-8?B?UVQ0M000ay9laUhxYVV1a0R2cHlKNUpTdmROY0pXMnFhUnJWWmkzdks4aHZh?=
 =?utf-8?B?aUVaV2JhNGFSRUtNTGpIWmVxTmgwNkIxMmhNNFRybmgrM00vN1M4QkxqQTFq?=
 =?utf-8?B?WVR3RlQ4WWVIVEJHTTduY0dha2x4ZkpLNHRMLzg5VHVKLzVkNVM1T2p3ZWRv?=
 =?utf-8?B?U0RXd3Q4WG15VlkzT3dCRmlGTVlsUmFHMDJRd3BXSlpSVC9keGlxcVpvV2xM?=
 =?utf-8?B?R1BxL0xlS3g2eXg4Ylh1b2xGVThYdllSRFh2b2F1enVPTDJOTUJxcHdMa1Fs?=
 =?utf-8?B?ejJ4Y1JVamJNSzFHK1FPMk9NcnpwOERaRUgzenBpeWRFOGdEQ0UwQWtqMEhT?=
 =?utf-8?B?YVR1VFlDMkpaYmdnRWFZT2JHQmJNcDJib3BweXR5V2lVb0J5RUt6RCtJaFhB?=
 =?utf-8?B?bzN6SExldmlNSjk2QzBUc2tFQ0s4eERBaDRUT3FWNnZGZmVPaDZtK0l0dlp4?=
 =?utf-8?B?NGdrYjVBVTZEUU9nWGhISlBGbXJscWI1ZTdJa3FiZEdOMTlZaUVQSTRTVUxr?=
 =?utf-8?B?RldYTmhDUFhlamlvMnM4Wmh4TWN1TFJRNXJCM2c2R083cmsyZXNuUGgwbVFW?=
 =?utf-8?B?bVhsa2JzUXhYYjdkVnZoZTRTd3FGeWpNeFllNGl1UWM0YW82K1JUVm5kRFZ2?=
 =?utf-8?B?RTEzd203QjN5S0U5WVVOMkxEZURkaWpVY2dqRWQ0R0MrTWRWcGJaOGNJVDFS?=
 =?utf-8?B?UDlqZThaN3FEV05GenFCUXdaWkRRMk5vd3dpR1plNXluU1ZUd21Ha1JPbmxO?=
 =?utf-8?B?YVJ3YmNjMzZOajd2MlNxK3V1MVlhd2RyZmpSeGpxRU1vVkdyVUQ5blVseGta?=
 =?utf-8?B?dHlLa0Yxd29qOWFobGtQN1FwUXZTTUJXQ0JiQmR3Vy96Z2FvWVdqaktLM0JE?=
 =?utf-8?B?N1BhRWM1cWk1MjV5Qm5uaUVrQlROeTRBOG1WRERwZkhWMERlWVk5MGFBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czBJczJUNTRIVHN3Q0JBWTJhMzFmY25rNFZaUHZkTmxSNTB3ZjF0ekFPV0M5?=
 =?utf-8?B?ZVBOQzhLT2VxcnVBRVlvUGJnYUt6WGJkQXhPb29YUTB5OUVrd1UrUTU2WVhj?=
 =?utf-8?B?OTNoL1ZMTmZ2ZUYxVzFmRlRqWkJGQStIVy9GNDBSY2pGSVB5aGZoeFA5aXNu?=
 =?utf-8?B?OFRtSSs3YVBqY1haSmZHWFd6MFE1WmRmZTdoc3pJM1Q2Zkt2Mko1WXNVRXN5?=
 =?utf-8?B?THVZZnh4bFJzRGNaYnRidm9VcGFJQlM0Z3h4REdRTVByOUJKNEZNUTFndzcw?=
 =?utf-8?B?N0Y1OW14TklnMUFVNmo4bjAxWmFEWTVPUTdOL3UrM2d4eVUrTUFWb3ZuUWJB?=
 =?utf-8?B?Rzl5bEhxUnBPbk5VRjRqWkkzbTVLUDduK1I1MHlqaFg4TlYrNGoraFZ6NEJC?=
 =?utf-8?B?cGl0TWFaVzVubGdLdWlLc25xSXdSbnRZaEYrL3RlRElldGNpcUhBZ3NROHRv?=
 =?utf-8?B?MUZtKzdUak5uN3U0TW8vdUpqZml1Y2Z3cXZmVHJOdlF2TFV3WGIwcERNZjZ4?=
 =?utf-8?B?emdTMzZvMTlaayt4UDhnUUViNUp1aFFzalRnbnFRcEpnWmNoQU9SamNIOG9n?=
 =?utf-8?B?YXRZV3FDbTlHenpxNklYZkRaSFVnMko3VVpJQWs3Sko2TUpyMmp6UngrY0tR?=
 =?utf-8?B?bXI2SVNFM3FtQk9qY3UwYmlTazF3RWpsaHQ0SWxTVDJiRkZKRmdRVldEK3Vi?=
 =?utf-8?B?MGdZYnFIYTdIdWMrL0hYaE01MjNmWE1IWS84V0lSZkhxL2YreTB3YVVFT25y?=
 =?utf-8?B?ZUI1bjhvanZwekduUkpmUHV4Q21HOTkwdFJXZCt6c0ZrYWtGdnZBbE9MNVU2?=
 =?utf-8?B?ZGJMbWdHbXV1OTZMc1FUWlYxV2tjbkdRNW5LRjFRalpydG02M0k1alViaXcw?=
 =?utf-8?B?bGhOT1JZaEwrRWZVRTcxZkdWYXJlVUhUb3ZwOHE2dnYxZzVQaXQyUjFwWExw?=
 =?utf-8?B?VmRJeitLdkQyQThYMi9FeFpwZitlOEErQ2dYU2FHSXBjOFZuaXlyQWpkOHdV?=
 =?utf-8?B?bXdiUFlaZU55TUlmS3dKWHE0MkJLRCswVFArWVFERjhoZmtNaXQ0SE04dEIw?=
 =?utf-8?B?Y2NYMVNweEVrbmplY3ZJdzJJOFNvVkRIWXRLT1VqZS9oUmhNaGdNQVUrVlVR?=
 =?utf-8?B?S1F3WHEyL2RxdEZDL3ViTnBKRWJzdU13NGEvemJFUGZiWDVhbHNnUTc4WGRa?=
 =?utf-8?B?emlwRytqVGNEUWdEbkgyUjZKOVo3SWFRK09Kc25zNDBsVlVSNkJBWnhCcXJy?=
 =?utf-8?B?aDY2TS9DOVdxMENjV2hRRXJHTW5WTU8zOS9NN1A0Q3k2d2lxbzc2M01TZWZv?=
 =?utf-8?B?L2NhQ0hYaXJKYVJqOTZRdnBaUnJlcUdXR085Si8vY1J3VCtEdzZORXhyUTNC?=
 =?utf-8?B?dWRLcmNGYWRzSmcrcmE2aXdodlVMTi9zVXRxMGhtd0hRay9tZTk2alhJOVps?=
 =?utf-8?B?S29CU1RPMFJRL0w0ejlBT2I5N3lCM1BmOXNpMEV5OVJJcXNBajFUK1ZmZ0ZX?=
 =?utf-8?B?RFpoNlI0azdub0dSdm02Q3BQa1A0bHBkUDdUb2k1c1JyV2pMMjIzMlU2YUVt?=
 =?utf-8?B?bjVnWGIvTXhXOFkzeUhiem9DaW1zSVFxU3BXMlNrL0VUZUZGaVhBdlJtLy9S?=
 =?utf-8?B?azV1Qll3dFJHLzdmSkl6M0ZnMFpJVW1kTXNueGFjOGFLdDE2akxhY2toTXkr?=
 =?utf-8?B?enhhMjluQmRlK2tWaGhpWkN2VTV5Mlc2Q2VlVkZwUUpER1Nnejh0TmNwbDVG?=
 =?utf-8?B?TGthNEZoZHhITSs2b2kvQkdBZmJDYWR6UHU1Ty96RDVyRTMvWXVZbG94bG1m?=
 =?utf-8?B?OW90VG5XMGg0d2RxbGdUbUpHd3M0Y1VjZWxUOVNrWis0a01YdEVaVnhUU0Nt?=
 =?utf-8?B?UUxONGdlbkN2czBoc1JXLzE1akxPeEVCK0VRSmQ4S3RmR3RZYXA5ekhYOFZR?=
 =?utf-8?B?MzUwMjh6MXA5OVAwSU55VjBLWHV4dFZKVld4TnRyYTZWcDkyOU44NVNzdVoz?=
 =?utf-8?B?ZG56cmhnbGgyRDZRVGVEQXNKVmJJTGZEbnIzaDRxRW1BbVl4eEJ5R0NyclFp?=
 =?utf-8?B?QU1odmJaU2xFZTRPYm5oS0NnNmxXaDdYZzk5dVBrTDlsUzBPMURKUlcwMEZM?=
 =?utf-8?Q?nu8Xg+p2yx5rD1S0UERHdypuT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9cf7aec-acc3-445f-5a40-08dceca47a81
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 23:03:55.4821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPYRr/++aiOIWgkdlD4zrVa4Y7iPX6s8dW6dZAgV5tIJ+M3j4r9kiLtO5wjYX755BkqDTzcC/hYLU05aruLvmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5088
X-OriginatorOrg: intel.com



On 15/10/2024 6:36 am, Edgecombe, Rick P wrote:
> On Mon, 2024-10-14 at 10:54 +0000, Huang, Kai wrote:
>> On Thu, 2024-10-10 at 21:53 +0000, Edgecombe, Rick P wrote:
>>> On Thu, 2024-10-10 at 10:33 -0700, Sean Christopherson wrote:
>>>>>
>>>>> 1st: "fault->is_private != kvm_mem_is_private(kvm, fault->gfn)" is found.
>>>>> 2nd-6th: try_cmpxchg64() fails on each level SPTEs (5 levels in total)
>>>
>>> Isn't there a more general scenario:
>>>
>>> vcpu0                              vcpu1
>>> 1. Freezes PTE
>>> 2. External op to do the SEAMCALL
>>> 3.                                 Faults same PTE, hits frozen PTE
>>> 4.                                 Retries N times, triggers zero-step
>>> 5. Finally finishes external op
>>>
>>> Am I missing something?
>>
>> I must be missing something.  I thought KVM is going to
>>
> 
> "Is going to", as in "will be changed to"? Or "does today"?

Will be changed to (today's behaviour is to go back to guest to let the 
fault happen again to retry).

AFAICT this is what Sean suggested:

https://lore.kernel.org/all/ZuR09EqzU1WbQYGd@google.com/

The whole point is to let KVM loop internally but not go back to guest 
when the fault handler sees a frozen PTE.  And in this proposal this 
applies to both leaf and non-leaf PTEs IIUC, so it should handle the 
case where try_cmpxchg64() fails as mentioned by Yan.

> 
>> retry internally for
>> step 4 (retries N times) because it sees the frozen PTE, but will never go back
>> to guest after the fault is resolved?  How can step 4 triggers zero-step?
> 
> Step 3-4 is saying it will go back to the guest and fault again.

As said above, the whole point is to make KVM loop internally when it 
sees a frozen PTE, but not go back to guest.

