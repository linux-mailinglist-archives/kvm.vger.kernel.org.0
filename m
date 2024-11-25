Return-Path: <kvm+bounces-32403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9169D7ACE
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 05:48:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38C5DB217AA
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 04:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36E6537E5;
	Mon, 25 Nov 2024 04:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JI98Vggs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3012500AE
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 04:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732510115; cv=fail; b=p+fdHSZlJpNT2ZK4D3sCqSHtKGPvlUAL4KRM9Xhgw1/qUBUYGWSpnCeJaKtLfK35fzrpRtTsJxkPWoWOwhIGGPUGhFktgnxrPQSaKcTEviAmFA0SY0bt5xzCC4GQPtQLDnZk74Z7wyqin4/lex9g2AqNYH7mB7Ql4miJaiSgD3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732510115; c=relaxed/simple;
	bh=OlTRxffr3Qp851n+H3qStZs3V7pVvGHpk1RfXWbSNBc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kadNvBKK9Kr2dq+sLktTLIydMzOQYgpbpIkFGiUdp/mRY26gwV+j50d2zkH6wo1y1aq62duAPWA+Iyi/nqdh+Qg6VY2yov2ht49FflmPyEKKMsGmrtAHHqK8IjT8+dvmGB7EzD9IDZ4yc6wjTX7Cz9Q2RrZW2yVqJ5FoFoxy9SM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JI98Vggs; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732510113; x=1764046113;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OlTRxffr3Qp851n+H3qStZs3V7pVvGHpk1RfXWbSNBc=;
  b=JI98Vggsn1K1QLSpAZgPNqSB/gwGC2W+Rge5Go3Gb6PKnwgEI7DqJ0YI
   +ai06X9MC0DUueH81n9jejxHQq+eRLsbHHwCmlHRBp0//GBGPzKEBi7Nw
   jT9gLJECEiEtX6qc3KNHqqiPVimJiEJxnY6aXLsI2veJj9sd2LPJ8aj81
   x+sEXuDZ7c2oly87qjbJ1B++IhS7n42QzjlaMSNhKszhyss9Xgx+Feqvh
   BAnTyE/0LTuoYXeaT/q0J9i7BEnEG9rB3/Vpiz7K57UPx0PKkXC65ZSS9
   ehkTJ9B19inwaiQPNUaNT8G0qKdDge4ZTJ3mETrqXL+oVw5smhsi/98Gf
   Q==;
X-CSE-ConnectionGUID: NFtlWexyRlaX4ouEqtSeWw==
X-CSE-MsgGUID: sCKl4E2gQxi+CTlt7nZ4RQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="43978316"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="43978316"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 20:48:33 -0800
X-CSE-ConnectionGUID: IjKeRsJrQemXhhIcYPyXZw==
X-CSE-MsgGUID: eMh2p4rcRVqL2CArbq8s/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="128660791"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Nov 2024 20:48:33 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 24 Nov 2024 20:48:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 24 Nov 2024 20:48:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 24 Nov 2024 20:48:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cA8eNYIF+lRzHGWpb/haZW0+KKKB+uWpNzXSOXFBoi+nAjcfwNWSwWeA2wVoCMGsg7NG3PAY4TLXr74JtSHuKIz1VMv7LugKZzsTkA27BW1Sm2Flhlu0VLQmjABl9Jb5p52pylJCU3rqwUiGGgiQp20cxQmt126SzZkrfsnNZq41mbg/jzxFnqsVjXeuVkonJXAesOcKqAJFDmGVYqsxUIHzsrlUn0/E2jHnA/fDKXuxF6wvuNKKuu2cgGhRzrJbqkqd63g8UvKDa/cWxNg8VTuRk26TvPIV2tus9R9ZR0F88pLHqvfL43/2iNBuf+cJ8bfneGerlYCdWki6ukKLvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6qHWxzcCfD103M1NLT0kGyM6r7b0WmKTF/BamMqmFM=;
 b=GkaFjlhkGJF6BJUZwiFB2J/w5fIii4vaMmQ58i4b5/DAqHITNFJ6/pbX7tXE8+UZYFyPqULnJljgSbwAvWEUfmDGkB+chlTlKIArHdbhPOEOI1XNlHNU+U+sMi5MyW6al1xMJVRgKlhnZUDBpWLilikPJpBjPl+hvabK0EsIHPAW9Tu56Uj2ETHP5OmRKWHJWdVaY/XU7GdVvoU7IE0HZl+bn0YW8PKawAoXxWV70CrOk/Komqkl7KFtOG7Xpmm492Sh2N9TkKDKr2k25dlcIxCuOlP+FNS+uLTrAsxY+92IxGPdua5PF+KyDNROOg/eI1KVQWrGwp6UbjDeVJBy0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6925.namprd11.prod.outlook.com (2603:10b6:510:227::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Mon, 25 Nov
 2024 04:48:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.021; Mon, 25 Nov 2024
 04:48:29 +0000
Message-ID: <333dc68e-9b64-427a-8c7d-66b83b502fe6@intel.com>
Date: Mon, 25 Nov 2024 12:53:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
To: Alex Williamson <alex.williamson@redhat.com>
CC: Avihai Horon <avihaih@nvidia.com>, <kvm@vger.kernel.org>, Yishai Hadas
	<yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb
	<maorg@nvidia.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
 <14709dcf-d7fe-4579-81b9-28065ce15f3e@intel.com>
 <20241122094826.142a5d54.alex.williamson@redhat.com>
 <4e02975b-0121-4267-81f5-fb41f4371d81@intel.com>
 <20241124202039.77b787d3.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241124202039.77b787d3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0071.apcprd02.prod.outlook.com
 (2603:1096:4:54::35) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH8PR11MB6925:EE_
X-MS-Office365-Filtering-Correlation-Id: d1a2ca1e-2ba8-478a-a85b-08dd0d0c6808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NVYzY05MSFpCY01RSkdpZXVnQTNWSTVybnd6Y1VMTTZERm93c1kzSEVsQVlm?=
 =?utf-8?B?UEswT21YR2hMcDNpaE95ZVlPK1NHUFFLSXJNZHZNZVB2VGNoZFdhVVdFVGQ3?=
 =?utf-8?B?MXpia0N2MXZkMnJrOVlHUXdTc01mRVE3YkF3Z1ZWR0J2TVA2M1BkM3VMMTFN?=
 =?utf-8?B?R3pkVjZBTXBoMGxtMk5mSDFiYmVmU241QlViYWwzUXdpeG1xU0hOK21zUXJ2?=
 =?utf-8?B?MW9HcU9NT3dRK2xnWFhsWjd3WitldG5jRjM4NkdYazJUMjJFUjZEdjNudlFl?=
 =?utf-8?B?RlhLeWR4eFkrWHNjTk1XNmF1bEp1RzNmY01YTGZKMGFjZFpVTmpZRy9kQVh2?=
 =?utf-8?B?REVtMHBTTnl4bjZEN2RrUndsRHR5SVZGdDdsdGxFMXl2cXo1aWgvbUtPMjM2?=
 =?utf-8?B?SjQ5TkJnL1dTd3l6YnhiQmxSbm9rd0s0bU9VSG9RNldweDV2bmc1aVNSWkll?=
 =?utf-8?B?ZnlwRE9uNGM5dlk5WW5hTXBIb1RJRmQ3NUpWczhGNFVRSVdCdXdITVNlOFJj?=
 =?utf-8?B?VjgwZG5YYmM5MXBSQmtVY21FRkdvM0NXdGNXOFdiR3lTYUIvd25OMERnSmhO?=
 =?utf-8?B?MlkwWUhHUDAyTVBJRzc0MkZWV0NSL2J2QTRRMGM4ZGJMcDlnemdLZzE0ZVRE?=
 =?utf-8?B?S0JtVlIzcG5wM2ExMis0NFZqUjJxblpsMkd6OENWeXBBN0pHVVcxbXBZZURZ?=
 =?utf-8?B?K2NzZyt3NGFaU3hXdGdTQ284TTJzd2dENDVjV24wVnR4eEpxSkZNYnZia0dM?=
 =?utf-8?B?MHBKdU1LdGNDK1RTbTJhMUdXdUZsTUxjR0Vyc1J5bTF0NUtlaHBaNnlYN3dB?=
 =?utf-8?B?NlRmMEwrV251VTFVZnV1Wno2VFRSRUhsWTV4Z1dySjhoTmhadmpsS0Fwc2I5?=
 =?utf-8?B?RmVXU1h3ODUyTkQ1Sm50bitVR052bEEzbStLZzVrN2o2YkprbUxLL1VaZjg5?=
 =?utf-8?B?bTNXTmtpR2N6emJhbGN2NU9Bd2Z5Z0JFWU9ySHhwbURiQUxiZUdwUkNaZ2hp?=
 =?utf-8?B?ajRWRkVZZ3B6aUgwV1hMdVZ0ZkhjNURXYWo2aVM2UVpNRWVOdXEvdmQxNUpa?=
 =?utf-8?B?R21RbzN1TVBtSjk0dmRDVHU3MDdrenU5VGxxcEFVbHdWV01KTWdicnJsb0pn?=
 =?utf-8?B?ZzRFdndmbGF3czVGT3RlTFVkdUtHWFZTakpaN0J0MHlJalNBWGhkWWJydHh5?=
 =?utf-8?B?YkZzT0ZveUpkdEl2YThIZTBlNHkyZVZQVzNrMTR2ZFlsNE0ySVR3WmN1VStE?=
 =?utf-8?B?WmJNYnpqZU9YSCthUnlkVWdtc1IrNjl4cHl3YVBLZDlSdGxDdjlLcFNRT0tp?=
 =?utf-8?B?K3ladk5SNVpTU2twWEtaOS85SXpTTVl4VDA5RHlraFRnTHpkSU5Od0p4NEdn?=
 =?utf-8?B?bWJLS0FrditBcHpyV05OZndJYXpBQ2VVbUtTUytQb1pRR1lwWG83Nzg1b1oz?=
 =?utf-8?B?TnMyR2kwNitRQjh0cXdqYlVqbTNGVW5tdEZuamJJY0wwbWo0SUpxN1RrNU1E?=
 =?utf-8?B?dElSVjZESDNuZmhPOWdvMTA0TWxVczQ5N2pLOG9Pbk1Rdndqa2wwSndzOEVW?=
 =?utf-8?B?Z1FKTW5HYmgvd0d1NUFWdmxJRXh0OU5VTDJCUWZrbWZQclVSRmplRnNHV2Fq?=
 =?utf-8?B?VVMrbDRoaTgra1l2TlBndEtna0gxZHdMUVJ2cklGVnVtNFdZTEhuZUY3Y2lF?=
 =?utf-8?B?S0djd2I4WVQ4YUJGYmZWYnpyZ0xWbnFMa3llMkt0dXVUcFYrZGRVMmJaMG83?=
 =?utf-8?B?b3ljSFBpcEhNOXJiZ011ZDh5VzhGdjFjRC9yWUNHeVNWYW5TS3YzRzEwYm8x?=
 =?utf-8?B?cVdxbWMzUUxrZWxoWndoUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVRnelNQbVNEUHAxNi80d3BGV1M1WE1OU1JLaWwzNEdtWnFmME40ZU9VanJi?=
 =?utf-8?B?cHBDdm5IaGVMcTA0N1FPb3h3SUZBalV0eWVmc2Y5RGtYUnNxZkF3Q1krU1Zy?=
 =?utf-8?B?NUN0ZzhieDk0UFByVjZGZ05YcGxvNHVIY0l4K3dvN1FPdGNDbkszK2FGMzZS?=
 =?utf-8?B?M2FwdUhuUkR1RGJrZ25wZm1NcklPTFZmMUZKcmVmOXIyb2k1VmpKc3ZjbytC?=
 =?utf-8?B?SzFkZEhWVDBaUVhWOGVyODBvQWxVMDg3cWFvLysrWks5WDc4RVRoTTRFMGg1?=
 =?utf-8?B?L2xRTDc4TWpwaVJZN1lGU1dHSll1bDA4WjNyelpPQUNSTkk4L1BWcUZ1NlVV?=
 =?utf-8?B?ZFpRSEFLVjcwRXhCOWF4TDN1d2NHd043R05rYmsyZWRmQzJLVS9RY1crTHhK?=
 =?utf-8?B?WWY5MGlMZ3lMeldaKzVoVGNmcExKczhPcE9kTG9sdlVKbU1mSnpScnJ5Z2lu?=
 =?utf-8?B?VjNYUVRWUkRnM3NBM09JenZ6UDRQL2tVSGhmblRybkxaenllR1duaVpyeUVx?=
 =?utf-8?B?eWJRdG5pS3B2RDFscHMwTE1ORTNZRXZaZWpuSE9kU3hrcS9zNzJyeDdRNy9i?=
 =?utf-8?B?dUk1Wk1mVURaQmdwbWlBejREbWY5Y3pUSkhXYzh6ZlJGZGhqcGRjaHpiL0J4?=
 =?utf-8?B?N2JCc1ZIOUxvd1BmMXduU3hPdFBpcTNpYU93aFBEYVppZVhaUkdtU3doL1pC?=
 =?utf-8?B?T242UkJtcklXUkFkdHlpNWxhaFo2U0YrblVMMkRtOE1wL054RWtRdGNqQU4v?=
 =?utf-8?B?V0FsM0xad0NUMnNacklERmoyaG0xQzJlVVk5bWVYKzhTVSswV2FiNWM4SjhL?=
 =?utf-8?B?b29YNlFDRG5VUmFkbHV4aWpodE8zZU5DMmc2SFcybmV4cHMvcUhjUjhRRUFr?=
 =?utf-8?B?Z3dKbWtsK1plWEdFMEhwVXpsUzh5Rmt0ei8vWlB4MnlaZHl5TVVPU0pZYzZy?=
 =?utf-8?B?UTVRa2Rkb0FLMm1pK2F5TUs2OGh2emp1OHlVdHY2S0xkTUFOMDhmQkRvaFdM?=
 =?utf-8?B?NThxTHlvYzVwd2ZCWnErSCtNMUwyM3hJU3h0MUZOUnBOdjI2VEJ0WEY4NC9i?=
 =?utf-8?B?dFN2eXExN1FKbWVLSWdxb25xSW9BSG5INktHL3ZTWFhWMk1aMjIyb25qa2lJ?=
 =?utf-8?B?ek13UHhlYkgyZnRidk1taW1pQ1RJdFQvNXpiM0FVcE1SM0VDeGdrdUJvelJ3?=
 =?utf-8?B?eUlNeG44NW1YQkZMS3JRcjZTTVNUb2xLN0prc3RJUllrNmNlVzZHbDg0Sk4w?=
 =?utf-8?B?OWwrZnl0NUg3Mm5qdXp5aVl6aSsrS2luZlkvNGNLRG5uUU1nc2JYNUg5UGJO?=
 =?utf-8?B?MWlBRC8ydHk3Mmh5V3pvVzZ1b3o1QVUzMjZ4Wjl5Y1YySWhPbmxaTVFjOWtm?=
 =?utf-8?B?NlJDUW1pUDAwWVdDTk1EcFQwdEZBVjZ5QWRFTnZOTGRCNjhnSmRDYkVtb1RX?=
 =?utf-8?B?Y0Jpc2YxNGhWRzhzM2RIRWtUUVdzb3dUNkw0R25ML255MDNaaW9wMlpxNFd3?=
 =?utf-8?B?OHBtbHcvV0tsSmVua3Y5Y2F4VC9tdUlDdTJzMCs5Vm92aEVEQzhrRCttRDhY?=
 =?utf-8?B?NkROdUZvNjg1dHUvUW9BWTVIK0Y5RjdiRC9ndjRFdUVxTjdaTGdRN05yZFFq?=
 =?utf-8?B?cHh4NUIxMmtoTDFtQ21pTlRIcTV0RE4vck1GVDF5bnZPUzJPdlFjVkdETHdm?=
 =?utf-8?B?djVCMXNLQ053UFovTTNFeE8rdVF4M3NTM3NNamtNclJZNFBIWWtVMlRwZEJr?=
 =?utf-8?B?YVdaTXA4STQwU2s3OHBGejBUWjQzREkvWk93MHMvTklJblBBNFNGTDRqOGxs?=
 =?utf-8?B?enNQTUJFRWQ2ZU5wMTNxb1B1dzJOaDlkNnJIL2dpanloQmpnZmFyUStRMnUy?=
 =?utf-8?B?dWsvbEZBdmxtdGkyZmNyRmtwMGltZlA4MXh5KzNwdHNCc3RLOVRja1YyRUV6?=
 =?utf-8?B?aTNuZ3lLWkt1RWl0di8zL1FtUmhpMk1oUG5tRDJ5YWtvU3hSc0YvSWRKVWlj?=
 =?utf-8?B?UEJISThxc3ZzaGZSZzdaZmo2anFXMjM4c0IxdHVKYWVzaHZBanNmQkFPYnYy?=
 =?utf-8?B?SndzZ1NsNExTYXliNjFMd1NVL3E1R05jbkkvSXhjSmZTZkxzQTRjOUdDWVdP?=
 =?utf-8?Q?G7bMUPlZ0171yRXMDma4Xa7xi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a2ca1e-2ba8-478a-a85b-08dd0d0c6808
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 04:48:29.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZS0HgOGnY03hiKp3WZ8SE43v45XA4KUZskjko4UeTPBGkXDCB92v7Ygz/++BoMdIBTyXpXPiL9r8q9Dg+KI0WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6925
X-OriginatorOrg: intel.com

On 2024/11/25 11:20, Alex Williamson wrote:
> On Mon, 25 Nov 2024 10:31:38 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> On 2024/11/23 00:48, Alex Williamson wrote:
>>> On Fri, 22 Nov 2024 20:45:08 +0800
>>> Yi Liu <yi.l.liu@intel.com> wrote:
>>>    
>>>> On 2024/11/21 22:00, Avihai Horon wrote:
>>>>> There are cases where a PCIe extended capability should be hidden from
>>>>> the user. For example, an unknown capability (i.e., capability with ID
>>>>> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
>>>>> chosen to be hidden from the user.
>>>>>
>>>>> Hiding a capability is done by virtualizing and modifying the 'Next
>>>>> Capability Offset' field of the previous capability so it points to the
>>>>> capability after the one that should be hidden.
>>>>>
>>>>> The special case where the first capability in the list should be hidden
>>>>> is handled differently because there is no previous capability that can
>>>>> be modified. In this case, the capability ID and version are zeroed
>>>>> while leaving the next pointer intact. This hides the capability and
>>>>> leaves an anchor for the rest of the capability list.
>>>>>
>>>>> However, today, hiding the first capability in the list is not done
>>>>> properly if the capability is unknown, as struct
>>>>> vfio_pci_core_device->pci_config_map is set to the capability ID during
>>>>> initialization but the capability ID is not properly checked later when
>>>>> used in vfio_config_do_rw(). This leads to the following warning [1] and
>>>>> to an out-of-bounds access to ecap_perms array.
>>>>>
>>>>> Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
>>>>> than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
>>>>> read only access instead of the ecap_perms array.
>>>>>
>>>>> Note that this is safe since the above is the only case where cap_id can
>>>>> exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
>>>>> are already checked before).
>>>>>
>>>>> [1]
>>>>>
>>>>> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>>>
>>>> strange, it is not in the vfio_config_do_rw(). But never mind.
>>>>   
>>>>> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
>>>>> (snip)
>>>>> Call Trace:
>>>>>     <TASK>
>>>>>     ? show_regs+0x69/0x80
>>>>>     ? __warn+0x8d/0x140
>>>>>     ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>>>>     ? report_bug+0x18f/0x1a0
>>>>>     ? handle_bug+0x63/0xa0
>>>>>     ? exc_invalid_op+0x19/0x70
>>>>>     ? asm_exc_invalid_op+0x1b/0x20
>>>>>     ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>>>>>     ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
>>>>>     vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
>>>>>     vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
>>>>>     vfio_device_fops_read+0x27/0x40 [vfio]
>>>>>     vfs_read+0xbd/0x340
>>>>>     ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
>>>>>     ? __rseq_handle_notify_resume+0xa4/0x4b0
>>>>>     __x64_sys_pread64+0x96/0xc0
>>>>>     x64_sys_call+0x1c3d/0x20d0
>>>>>     do_syscall_64+0x4d/0x120
>>>>>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>>>>
>>>>> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
>>>>> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
>>>>> ---
>>>>> Changes from v1:
>>>>> * Use Alex's suggestion to fix the bug and adapt the commit message.
>>>>> ---
>>>>>     drivers/vfio/pci/vfio_pci_config.c | 20 ++++++++++++++++----
>>>>>     1 file changed, 16 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
>>>>> index 97422aafaa7b..b2a1ba66e5f1 100644
>>>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>>>> @@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
>>>>>     	return count;
>>>>>     }
>>>>>     
>>>>> +static const struct perm_bits direct_ro_perms = {
>>>>> +	.readfn = vfio_direct_config_read,
>>>>> +};
>>>>> +
>>>>>     /* Default capability regions to read-only, no-virtualization */
>>>>>     static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
>>>>> -	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
>>>>> +	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
>>>>>     };
>>>>>     static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
>>>>> -	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
>>>>> +	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
>>>>>     };
>>>>>     /*
>>>>>      * Default unassigned regions to raw read-write access.  Some devices
>>>>> @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>>>>>     		cap_start = *ppos;
>>>>>     	} else {
>>>>>     		if (*ppos >= PCI_CFG_SPACE_SIZE) {
>>>>> -			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
>>>>> +			/*
>>>>> +			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
>>>>> +			 * if we're hiding an unknown capability at the start
>>>>> +			 * of the extended capability list.  Use default, ro
>>>>> +			 * access, which will virtualize the id and next values.
>>>>> +			 */
>>>>> +			if (cap_id > PCI_EXT_CAP_ID_MAX)
>>>>> +				perm = (struct perm_bits *)&direct_ro_perms;
>>>>> +			else
>>>>> +				perm = &ecap_perms[cap_id];
>>>>>     
>>>>> -			perm = &ecap_perms[cap_id];
>>>>>     			cap_start = vfio_find_cap_start(vdev, *ppos);
>>>>>     		} else {
>>>>>     			WARN_ON(cap_id > PCI_CAP_ID_MAX);
>>>>
>>>> Looks good to me. :) I'm able to trigger this warning by hide the first
>>>> ecap on my system with the below hack.
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci_config.c
>>>> b/drivers/vfio/pci/vfio_pci_config.c
>>>> index b2a1ba66e5f1..db91e19a48b3 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_config.c
>>>> +++ b/drivers/vfio/pci/vfio_pci_config.c
>>>> @@ -1617,6 +1617,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device
>>>> *vdev)
>>>>     	u16 epos;
>>>>     	__le32 *prev = NULL;
>>>>     	int loops, ret, ecaps = 0;
>>>> +	int iii =0;
>>>>
>>>>     	if (!vdev->extended_caps)
>>>>     		return 0;
>>>> @@ -1635,7 +1636,11 @@ static int vfio_ecap_init(struct
>>>> vfio_pci_core_device *vdev)
>>>>     		if (ret)
>>>>     			return ret;
>>>>
>>>> -		ecap = PCI_EXT_CAP_ID(header);
>>>> +		if (iii == 0) {
>>>> +			ecap = 0x61;
>>>> +			iii++;
>>>> +		} else
>>>> +			ecap = PCI_EXT_CAP_ID(header);
>>>>
>>>>     		if (ecap <= PCI_EXT_CAP_ID_MAX) {
>>>>     			len = pci_ext_cap_length[ecap];
>>>> @@ -1664,6 +1669,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device
>>>> *vdev)
>>>>     			 */
>>>>     			len = PCI_CAP_SIZEOF;
>>>>     			hidden = true;
>>>> +			printk("%s set hide\n", __func__);
>>>>     		}
>>>>
>>>>     		for (i = 0; i < len; i++) {
>>>> @@ -1893,6 +1899,7 @@ static ssize_t vfio_config_do_rw(struct
>>>> vfio_pci_core_device *vdev, char __user
>>>>
>>>>     	cap_id = vdev->pci_config_map[*ppos];
>>>>
>>>> +	printk("%s cap_id: %x\n", __func__, cap_id);
>>>>     	if (cap_id == PCI_CAP_ID_INVALID) {
>>>>     		perm = &unassigned_perms;
>>>>     		cap_start = *ppos;
>>>>
>>>> And then this warning is gone after applying this patch. Hence,
>>>>
>>>> Reviewed-by: Yi Liu <yi.l.liu@intel.com>
>>>> Tested-by: Yi Liu <yi.l.liu@intel.com>
>>>
>>> Thanks, good testing!
>>>      
>>>> But I can still see a valid next pointer. Like the below log, I hide
>>>> the first ecap at offset 0x100, its ID is zeroed. The second ecap locates
>>>> at offset==0x150, its cap_id is 0x0018. I can see the next pointer in the
>>>> guest. Is it expected?
>>>
>>> This is what makes hiding the first ecap unique, the ecap chain always
>>> starts at 0x100, the next pointer must be valid for the rest of the
>>> chain to remain.  For standard capabilities we can change the register
>>> pointing at the head of the list.  This therefore looks like expected
>>> behavior, unless I'm missing something more subtle in your example.
>>
>> Got you. I was a little bit misled by the below comment. I thought the
>> cap_id, version and next would be zeroed. But the code actually only zeros
>> the cap_id and version. :)
>>
>> 		/*
>> 		 * If we're just using this capability to anchor the list,
>> 		 * hide the real ID.  Only count real ecaps.  XXX PCI spec
>> 		 * indicates to use cap id = 0, version = 0, next = 0 if
>> 		 * ecaps are absent, hope users check all the way to next.
>> 		 */
> 
> This is just expressing concern that a sloppy guest might decide the
> list ends at the zero capability ID w/o strictly following the spec.
> We've never seen evidence of such a guest.  Thanks,

got it. I see linux pci_find_next_ext_capability() does it correctly.

-- 
Regards,
Yi Liu

