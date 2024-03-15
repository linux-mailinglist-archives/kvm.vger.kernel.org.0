Return-Path: <kvm+bounces-11871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 429EB87C6BB
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A65D31F21CFB
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14B5819;
	Fri, 15 Mar 2024 00:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CTqaN/Ft"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CC619E;
	Fri, 15 Mar 2024 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710462285; cv=fail; b=DjdKgPwQA+Ja0XtT7BPpvXbL+/SQGKqaJz6mtfuuwmmKJr8swJYsmORS/ScOIeAskEMbcr3ghTbxz8J4vTFnzRebSzeTn3Ecmo2lsnIYyj+dfygVtIbFcr9ABRKUqu6UDEo3Le8A8Pl1nY5pv8LI6wY3ZF2Ig0NmPTQpO1ZQMAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710462285; c=relaxed/simple;
	bh=K82E+p68YS+BdXodC+zmj1491ptSUSNpXndeyLMRjKk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2+Wl95wm9O5+LEq23XhxhtsCd/nDvjH4yDa626Du2idlg9Lf/EFTiTSiXw8tddddAB0GuIEbsdNDjUIWyfqD7ZjrnHaQSXvld89pifuJzkUvm8lN3H6Bqbrp70LiYwe4bv0V4I5bSzYBjRj8p1FPRrfxYahpHkKbhjmpy/cG5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CTqaN/Ft; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710462284; x=1741998284;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K82E+p68YS+BdXodC+zmj1491ptSUSNpXndeyLMRjKk=;
  b=CTqaN/FtWkx5AtnDAoMDPtQaOTU5F03BUDpX/ANPOaHDYuhfJA0j96KV
   UsXCisuQ+keuVY0DR4/FgeOZoFFqRf0YBAwOxqcx2znCwYlX+34W/vsJT
   8ldb4/fSn166B8xhpnWIV1naBSCSKj3E1aFyZhGU7smnFniHJrQHvYMb/
   cVO+UA02qhdmgAyPxIDHDURb4vfN/VKEkIOq1MaIsJmuy0B8x+srutd/9
   hS0B72wlrgKLimYk3M+rggVtStvsBUO1n//deEG2pEXv9wEaZNVL7Bh1f
   yJciuMX+3P5ythsC1AzcLFuJG7+27FxxQ3OKLzN05F2LQOjDhZiX4rwZ/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5172082"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5172082"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 17:24:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="43383696"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 17:24:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 17:24:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 17:24:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 17:24:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa+BcWv9Hhj2tFJgic6OX51S9Zuhub0ndsGf2MWhx2TJ92BWnYT7mzLRi+5hApDklUtH9Iwgh1+nxSti7SrH8nuzUpyzNMSTWrBVDlFvAcx3TUwIVHy/JYuRRyVyvTxXrpCfYHZFNeqKDZrRbSp6X6p5vlAyw/+i6dWKONRp1jTNir3GlMql3KouO7rlUiItwaA3uEkyVif6+/Welhs507VZwKjE1woTNe9585/Gf/jpIL5VGLepESOlmpcjQ3X/3+Bsz69yUS0XUO8IInjDU9Ri00Kfjs6URBJyF0A1z22c6T/Ms2OFuPJTbpaI8NB5MvCCSi6zDp6jTJOkEire8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLe3uD27H0GoAiwiHe1UJ+8FIEQxFF+TTvwShPBeRLA=;
 b=beQpLI52NOTdUCttDcVjcSNSj/Ey07f0tJvS5j3PrZ6ew4ZbK7eNixiht2RX4yN4fneo+gNc+32XdrINNj8NSA8tBtjX7lQ5RFZg0EgLlLPooU/DfQQgEiVm5rwjyEsgC4Dd5kaxS4Y1UPX3ld7NoB9OszsJLiao24fJQhepIvLgyS8oTwYKY126s8QfyDtumIiT4jHbosB6Ucj6WhyYbkzpOv9ZShb4PWCgMJOiONxKBhnRLbWPok4nYQJKTlsbEb9tQ++2K41OhGikkWrQN6/j/t2nclCRiZYqE8iN5TUBWXqSv99idisspE6YyNdQC/C8cSi9d6l09zipIM5qhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7856.namprd11.prod.outlook.com (2603:10b6:208:3f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Fri, 15 Mar
 2024 00:24:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Fri, 15 Mar 2024
 00:24:40 +0000
Message-ID: <1c8537b8-bb91-48ee-ae9a-5f54b828b49c@intel.com>
Date: Fri, 15 Mar 2024 13:24:29 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <x86@kernel.org>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <bp@alien8.de>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <isaku.yamahata@intel.com>,
	<jgross@suse.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
 <bd61e29d-5842-4136-b30f-929b00bdf6f9@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <bd61e29d-5842-4136-b30f-929b00bdf6f9@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:303:b4::11) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d066778-5bfa-4b19-c4d3-08dc44864d98
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WebEib46TcynbcdVwDeP9iTRXqu7HMJMyljQZYZ/DT9MOlRdrsabw50G2V/6UlfyajudmMzlNaUrTtrkI0SKVzcIIHi+riayRHx9beZWRYXx8SEWgWhGUAOo1JXOGRa1PuufwwgT8V6A1G2IgtcxTvHafXouZ5LbqpZUH8zrYjWtX9HqW9AQ0J7pFzKh39FuCX2st/7wGT65qDlMhWxJ5YNufovXSnp7qDKaZa6U3Hosi6MZfwzDeRA200yiry3uN3WokCI81PVVrXKvpimiX3M7FIoD6Q0E0aTvuCD19wAT/t3cX469+ZPERMWJkGvG7bYVbSW4r6FLDfCYk+an+H2w3/PZ0r3uQt1ECDncy7W0SO3g+YrkdI6NFFAZWZojPMb/UR2aA7WSIjnJXbo0w7r955UclfiWIet463hYvBjFRfO442TDouU+2FN/jBCS/pLw+pVCvz2t5Mb5Y20ItJ+dulpDjjucl6GZdetKrgEdcTh4VXsXBdIvm1DlPSw6jTpjZ859F1EXhLz4Dcetl9nW2Qtbe2xa4x53P28MXJKEg14HbLimlxdP0rd2eG5D7bZIYpc0hUaapg6k2F4Ytq4fzbidG/1ebvENyZFxWG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmZpZWlLclh0UU1HVzJqUnF5cHlQQ1NwYVh5b1MrSE1ZajIwK3dqK3FLczJN?=
 =?utf-8?B?aGh6ZHVxSzBSYUloWTJ6enpLRkIwSXQ5a2piTm5CL1pNTTZvcitNMDNOVEd0?=
 =?utf-8?B?SEJvR3pJenM4MWllbDNpNDE5eFRSRjlIdVpKR3MwYTRwNWFCSEpJRnlPRmMx?=
 =?utf-8?B?Y3EvQlpJcUFvaGwxU2w3bTgyUi9iMHlGdW9zSjIxcWFrVU03TC8zZmc1UEJM?=
 =?utf-8?B?SUZwNkFJVS9sY1EyQklTVnpuNVp2T0V5ZXZ3SEU0bkZmcHFkMEptMGxnbkxa?=
 =?utf-8?B?MVArN21JcG1UYU5FYUFNaFk3eWpPK1JpOWFmT1o5S3RIMjBtcXNjR2Z4dU5t?=
 =?utf-8?B?M2hYQmUvYjZ5dkVuNW1mY0FSTU5xdkljMXZFb2VtcTFVVi96RTlwekFRVzQ0?=
 =?utf-8?B?M2ZTLy9JL3JldkszMGpYUlBvUkRKRENvd1VYZzBOMHNMT3Q4WXJLZzVUUVNy?=
 =?utf-8?B?dlIzNlNXbnZUVTJrcWMxb1o1NGUzRjJHcFZWeGtCNGcyZDFuRkNaREVGTTlM?=
 =?utf-8?B?VW9EcVlNaHlDMytPbU85M2pKU0kwQmdud2lhb2FKb3JPdk93RnFFZDRzOEVF?=
 =?utf-8?B?ckFIeC96Rjh4YnBramxwRFZpNDd0dTNWc0Z4SWgvVzhCR2Y2YkxKZlRJM3Ay?=
 =?utf-8?B?eXFRZElTSVRvdlRubDQvcm1jOVpsZnBVRXh5OXJ6djRKajliL3JkK09LNHl3?=
 =?utf-8?B?RElTSDgxQmhwdlcwUVc0UHJiQUhXT1gwdFpKZGY0djJQQUFrMlB2dTJqeU9l?=
 =?utf-8?B?a2VKZ0ovSkN6YXRUV0NRTXZwZjRqWHJDUVZiWTVhSlN6czZhU1Z4cW9JNWRx?=
 =?utf-8?B?bUo4bEkxb29sYzNsOTdHcXNPVzVaZmF1NHZyOUF6b1IwNDhJNk1GbXFBS25i?=
 =?utf-8?B?d3JBYXhsdVo4Q1V2akRxd1B2NVc5N2pSRm5mZ0MvcDFlSDMxbm9EekNsZzJE?=
 =?utf-8?B?bXpZNkdSOEVpL1ZFUUtucFJXOEUxblN1dytqQU1SOThZdytMWmsrd3kxVkFR?=
 =?utf-8?B?SmNMRjFOUE9KUnBYWXRhSWs1RDdQKytMTFQ4QXQrbGpLNlIwSkNCM1BHQStR?=
 =?utf-8?B?Zm15UE54eGp6QS9rTzQ4RG5mUlo1bVBCSjUzcDByZ3NwbHFleXU4Z1ZTUXBB?=
 =?utf-8?B?NnloU1F6NSt0KzNsZHVOYnBQTkNpSUZrZ3JvTlh2aWEzamo2bGZ1ckF6UEVB?=
 =?utf-8?B?L1pNcjJqQUxMWUs0ci9QM0pOL3RRMll6eDRlUldtVjR0Mis3TmZvVHY5SDdm?=
 =?utf-8?B?RER3aUJveUMwdmJtdHp6anlCdHJ6b1lOYVdKbGtVRG1wRUZkTzA2WDVCWUYr?=
 =?utf-8?B?TVUxZUJhRWw3WGhEVWdaeHQrdzlhL2c3bGZwWkpqdER4QUx3R093OEwxak1K?=
 =?utf-8?B?eDhQeTd5MFhvaHhIdHZZVjA5eHZ0VXVsYVFXcW1qdmhUaGgvb2F1blZaWVRB?=
 =?utf-8?B?cjhWOHZlRHE5Nzh6NFVvaTl3djN1MTJobzR2UC9CRE8yTFl5b2JJNXFIUFdP?=
 =?utf-8?B?ZWlVeGY3VDlpcFZOMHhiTERucGhTRkZMWWd3bW93MjgvTlJUUmEraVlxSElx?=
 =?utf-8?B?eVRYMVMyZm1EekZyOG11S2xTdnNtNXA4SGNvajU2V3BNZ1dCMWo2blhSaG1B?=
 =?utf-8?B?eHA1YXhrOTYrN2pvWjh2cmpWVzViSFVRRnpnZGgvQ1RlTGFsSW4vU1JkcWY3?=
 =?utf-8?B?MTRNa0FFK3pIMGRHNU9EZjVnTW92Qk13dVJIQkdCV2NkTWpablNwT0lrenN0?=
 =?utf-8?B?bkJ2OFFJbXpuUFdOZWxRcGEvTlEvSTh1ZWlTR3lNZTFvemdWdWxDSXZRSGN5?=
 =?utf-8?B?N2xEMXNtVGsvL21WTHJOYTFFdlkxWktDZVBUQWJxLy9YREp6b0dqa0dHRUVl?=
 =?utf-8?B?WFM1QmZzcHlNZDlFMnRoelpIOTFXZjZnYWY3c08zcUZTRkd2akh2V2VFS0dQ?=
 =?utf-8?B?VXEwNUZ4amFkNDJYY2Q1L1B3Z0ZlVGUyTmd4cWF1NnNZNytaU3NjN1FGazVD?=
 =?utf-8?B?RFRtWDRkalhRejk5S25zcGdYR1JobnJUcDYzZWZ6czNjdHR1ZzBwdXZWZkJ2?=
 =?utf-8?B?ZGt5M05vZTJqU2djbnhiYUZ3YWFXQ2x0am9yT1dCZ1NKVS8zRXZjYUFYOVBh?=
 =?utf-8?Q?0+/488JMwE+S9CS881b3GRa42?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d066778-5bfa-4b19-c4d3-08dc44864d98
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 00:24:39.9510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3DwUeQZ7/BsIDFmUubMm/HCTPtMlVy+2XILq9msw9tys2hDK24ncii9orPCtgwkSjdxo3nWTxfsQTDYhJPmXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7856
X-OriginatorOrg: intel.com



On 13/03/2024 4:44 pm, Xiaoyao Li wrote:
> On 3/1/2024 7:20 PM, Kai Huang wrote:
>> KVM will need to read a bunch of non-TDMR related metadata to create and
>> run TDX guests.  Export the metadata read infrastructure for KVM to use.
>>
>> Specifically, export two helpers:
>>
>> 1) The helper which reads multiple metadata fields to a buffer of a
>>     structure based on the "field ID -> structure member" mapping table.
>>
>> 2) The low level helper which just reads a given field ID.
> 
> How about introducing a helper to read a single metadata field comparing 
> to 1) instead of the low level helper.
> 
> The low level helper tdx_sys_metadata_field_read() requires the data buf 
> to be u64 *. So the caller needs to use a temporary variable and handle 
> the memcpy when the field is less than 8 bytes.
> 
> so why not expose a high level helper to read single field, e.g.,
> 
> +int tdx_sys_metadata_read_single(u64 field_id, int bytes, void *buf)
> +{
> +       return stbuf_read_sys_metadata_field(field_id, 0, bytes, buf);
> +}
> +EXPORT_SYMBOL_GPL(tdx_sys_metadata_read_single);

As replied here where these APIs are (supposedly) to be used:

https://lore.kernel.org/kvm/e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com/

I don't see why we need to use a temporary 'u64'.  We can just use it 
directly or type cast to 'u16' when needed, which has the same result of 
doing explicit memory copy based on size.

So I am not convinced at this stage that we need the code as you 
suggested.  At least I believe the current APIs are sufficient for KVM 
to use.

However I'll put more background on how KVM is going to use into the 
changelog to justify the current APIs are enough.

