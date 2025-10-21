Return-Path: <kvm+bounces-60667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C49EEBF6D3A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7ED919A63E2
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 13:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F01337BA7;
	Tue, 21 Oct 2025 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ni3cndh1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BAD328B5A;
	Tue, 21 Oct 2025 13:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761053878; cv=fail; b=bmAsqVg79vFOY7a32HEtBxCgkvsPkPVWPpM5WQAqdjFgjK20qT/TdAhnSggcq6ZLamRjFDq3XFUcw/Ac0RIaQ8sqcRXLHRfS79vOn9iHxdqp4tXB8l1kwCY+jaWqD08tsVoVC2wqfb73BrJuSYwH7IoiZogpG++SVVk+xgb+YNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761053878; c=relaxed/simple;
	bh=HQAWrzOGlbLeW7dstfyacZaErqXjRpdCKJ+WHMQdaa0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X/9O31Fy8YRdOmkcoY+TknAEgvHR1grbH9ddOyE/oBvd0Gnx4EGHoHRRbFfsWlf8xTxqEgM8a1oyMhvrYbrl7TEj9w4Y0VB+rFuS6H909G835HUPHw9nscSIFz2R2diN1iby3JnM0eY1GqCQF3dMwxil6A9KZIoyzpbxn9STZ6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ni3cndh1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761053877; x=1792589877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HQAWrzOGlbLeW7dstfyacZaErqXjRpdCKJ+WHMQdaa0=;
  b=ni3cndh1Y5ds/MOHhJApyijIZcfxlwd8ZXmKF0y4JOCE6ss4hMxMpyp2
   fF8gfEpCL4yzld1QG3tux3zF+xMKQyLoVKCjqQHFgIXA6EIyaz/+JEGNb
   xhIHPwBdNm4xNnU5mSXGg1W+aqk6LopP4e7u+dmClybIRtdnQ6msE7oh7
   EMdKrfySEWDlhaD8w9SIodQg8Owwr9PKXJwt5l5RhClmsAepeCaSNbhB9
   H0j4oNWBavyDZdXcyFBszl88UyuRPuVqgJ74Fk/eyMs/gYyEmnBpEu8v4
   43fSe2BaYY9gq3+P9niuGXnCZR7r7pxJWoC4Ywy/lnjP0C5/LLwAMo/ra
   w==;
X-CSE-ConnectionGUID: Mu1DxxZzSyKNwU/Jk9koLQ==
X-CSE-MsgGUID: rfWp+92+TD+i5Jq7zrMKUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74297982"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="74297982"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 06:37:56 -0700
X-CSE-ConnectionGUID: ggidZx5NSL2f5Knl6igjZg==
X-CSE-MsgGUID: JvPHz7T8SVmPiCB4LB/W5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="182798005"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 06:37:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 06:37:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 06:37:55 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.66) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 06:37:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S3ZGf5J+3xSvhFGjchNZoSs4EPd8xi9sTA6xI9VtK8C8PBVdqOlJrPO0kOR2ykYCAV5ut+AcC/IZP43ZLNRK9IxAhm8j6n7K/EHsFiVFTFIdiRd5SClc4T7ggSciE/vYw1esB71rQIPwowzmRW7RijRcEG1uwg3/v5s0ZQWTQmHOWXurQDJGcIzOJCO7xYHuP29yntSr8nAK7r06GmPuVw+aQKds0Oo4uoIT0FHm+kMid3jCLUiYq/VnzevcMVumpznvDHiAdeCWmKzYQjnAJz6Yxq5WHf1ne6FDNrSTsuiQhO0BTGGQCcoisuFf+Vn/chNjTWH4Y5Mm3ZaM6ZlOZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNlAhVsbSP4QC9UVkaqxlBRyE9otws2Gi+DTFdlGpYg=;
 b=NYzPUpU5AZKq0R+GEgTsAeoAYOk/2RP+qa+VRoqm4fNpP0nCRM+GA7onizVf6br3pGkFfbevmGlq4O+5zwGJJ9MWpjSK5za2Wwst5bCtuB2ynXvn5dbs63hVwejip947cohveOxkWeSTfg7DdzNptlckfJTPqRWcboFIiwdsJndZCgANPaTJ+wFpUA/jZy029mDP908J7NG5B/aPUlNo7h4oQekdz65WOUWkyYRIt8YKx+L3BsvY7DGUVObG1E8phA00tDYgykIQZW8vr7LwuRPmT844vXMpuGdsR75+2vDOoCajwCtow5901C5oHtSpwaj4synI09EgfvIH7lW5/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by DM6PR11MB4580.namprd11.prod.outlook.com (2603:10b6:5:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 13:37:52 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 13:37:52 +0000
Message-ID: <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com>
Date: Tue, 21 Oct 2025 16:37:48 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hou, wenlong"
	<houwenlong.hwl@antgroup.com>
References: <20251016222816.141523-1-seanjc@google.com>
 <20251016222816.141523-2-seanjc@google.com>
 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU6P191CA0056.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53e::17) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|DM6PR11MB4580:EE_
X-MS-Office365-Filtering-Correlation-Id: da27227c-d70e-4fb3-8a12-08de10a708a4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U29OYitRK1hBSzhZTFJ3c0RNYmtXdUp4N29JQmEyS0JFQmVhM053NzZ6bkJE?=
 =?utf-8?B?TzNaQlhqbEttYlJOdEJZbk8vSGZQdy8vRFQ4cU90Nktaa0RyVHdLMXhRblNq?=
 =?utf-8?B?ZTVnTnd5c0g1QUwxN2tFQnBwSExGVkNTK1dYMFNVckxlcCt3bDNxeXY3aEM0?=
 =?utf-8?B?Y3BhL0VCMFhTNU1lOFlPaFgvZ0ZJUkxKZVpUZE51Sk9rd0phdm1XNUZxYldJ?=
 =?utf-8?B?RXl1U2syamlZMzc0dVIzaWJpZjlIZGlCRDhKUXJ6b2NWM3lOam9ENjVQaHAw?=
 =?utf-8?B?UWhLQkhkN0ZjVE8vTUoxdnEzNmhIMHF0Y3VxbEZ0VW5yclRzNjlqVm5LYXZI?=
 =?utf-8?B?eEcvMjk5cHcyWkR0ZnpDd1VobXl1RHYxWjFERU1rQ2FUb3hJWXBZaTMwRURU?=
 =?utf-8?B?TG9nWmlEVGNlZytVeFlGVTJCR3o4ZlVpb0M3b1Qycmo1UDdBZTFBWUxoSXdE?=
 =?utf-8?B?UXBXT2owY2g0OVozSU1haEErUHFDQk8vRHZCWk11V0YxUndqNnltcEJoUS9r?=
 =?utf-8?B?YmZDb0VFUDZRTUU0aWkvV1FhcGhQMXhoWThHZnpnVHlNRm1wRzlYOFB6VHFY?=
 =?utf-8?B?RCtTelkrelZjcjhsd2ZQdzdwaUEyWUpwVWFOQnFscDI0bEhWTFpaNDNMdzR4?=
 =?utf-8?B?eEp1aUV1QzNhWlpNcUk1UXoyRzdjTWU4RUxrNUU3RmJ5RXF2Wk96QzM5Rm9E?=
 =?utf-8?B?VWFRbXl2ZTFjM0VxNWpaTCtSc3hQYll4OWZESGk3dE5TZnIzQ294alJPd1Q5?=
 =?utf-8?B?VkxPaEhqVW1iTFFSNUpEeVJTL0RwblVqOVJxNXB0dkhUem55WW1qK3Y1L21T?=
 =?utf-8?B?VXQ4cWUydlNCVGFxSlZ4RE52bE1lZ1YxdHVySUZ3WG9Pd0ZTeEdpUmVBTmRN?=
 =?utf-8?B?R1pEakYxakF0eTdGMU53WU82UGdwZVE0eWlmcC93NEZJa3UwNzYyZWl4Q0hL?=
 =?utf-8?B?T0pYY09oRHZIa3V3OVk0aFVJbFFFQWxIUTBRUHNmY3p3V1lhendnTlUvaDdP?=
 =?utf-8?B?U3RkNzNhOXRod2I1ekZTVGM5QnFhdW9FVytwNTByOTBXU0U4VmN5bUovS0dr?=
 =?utf-8?B?YUZ1ekNMV25Pc3ZNMTN2S09qYWFqWXk1cm5OdUdBOC8vcUFOSEpnRXJhMjl3?=
 =?utf-8?B?c0tpN3J2YXdETGJXQXNWcVVzT2R0d0Vkd0hoU2JZSDMwcVRnc0h5L0VhaWNP?=
 =?utf-8?B?a0w2RFNqUEpvb0V5OXZsR0pIdTdpVUJEUnJJNFYza2ZqaU04ajBiMGpCSjg1?=
 =?utf-8?B?N2JPWGpreEp4UU5LazVwMUNTWlY5cHR4ajBtWjZESERMUjA2V3NIS0JIUEd4?=
 =?utf-8?B?Ykp5UzZVUWI4V2diWmpDaDhIbEJTVXFoUEkyNlZ3MGlhWnloMENNZG05R0My?=
 =?utf-8?B?YkoyZzJkd0hvU0ZPOE1ITm5pdGxUY00ybUNRUTZKQlRpeW90QTRPWGRNeVJz?=
 =?utf-8?B?N3pZbEtNb2RvUlRkNmo2QXpIbUZKNDVHdnk2WnlxaGdNbFk5SGsra2FWQTkv?=
 =?utf-8?B?SXZIald2cjlKMVAvdzlyUTZpMDA2SUprNkYvc0Jkam5OOVpmUCttSzlqU2ZY?=
 =?utf-8?B?aWRJZ21Scmg0UWt5R2xkNVMrV0Z0by9iVlo5RXA0TlBDVjRXWDFKVHNidUJo?=
 =?utf-8?B?aU9MN3AwUEdaM0Z1WWFKTjU0b2NDSisvc3ZTbldVWm9wbmJSc0NhamNYYjhp?=
 =?utf-8?B?WEtRY2lxTTdQbElpL2Q1RXpTakwwQkY0ZUlCenJtUTBWR3BhZlU0bWpVWWZt?=
 =?utf-8?B?emZMSVc5YVpzSU5jSmpjazBjS3NVaUs2c2FhY3JHM2lDRk8xMnRmTkNMN0NT?=
 =?utf-8?B?OGN3L201bHYrK3o0eEt0NE9tTnRldkJkUzdCVlNNajNhSjd6UmVMVFJMN3lE?=
 =?utf-8?B?WjFLUDFlM3poMDJIdHlaK01iaEFMZkhHb0plN01qcEViR3ZOZkhWeVBLZXYx?=
 =?utf-8?Q?kO9Gh03pXakPm+hhAw28zNl8FDPWJNKe?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vit2Y1dHdHhNVWNOb1pVUTFiUmFzeTFqK0tNOThLRlZOZWpWNDZQcnhJS0Vj?=
 =?utf-8?B?YTNod1RsckRzNUw1WDdib3VBNW44WUxQckVWV1dLMTBucnQwVnFvU3MzcGVv?=
 =?utf-8?B?Q2tkUlFncFNUVHA0bHpsMmVWUnBibzhZWTdkYURGVFRaZFJzVENPbGVERjgy?=
 =?utf-8?B?ZUlMQWU5YUNqTnc5YVY0REpzUFdDVjE5dTB0V1ZxWVFpV1YwYjZ4ZXIvUjlh?=
 =?utf-8?B?azFUU3AvQjZybFNRMUlVMStLNU53SkVQd09HZHM3R3dYOW1IRmVGMmJBbVU0?=
 =?utf-8?B?Ykh1dUxuR1hLc1BhK1lwM09OUW9xbGJ6YU1XSHozcThFVGI0eXJHYXdTa0pQ?=
 =?utf-8?B?cHRvZ2hOK3BPT0Q2OVBuNWFFc09UVSthOVd0Nk12TlRWdjNGRGRWN1Rrdm9S?=
 =?utf-8?B?V044OFdXZ3lYbjhRRXY1NWtJTDFUN2lDdWU0Z0FvaHJxUjVod1pvcFVDdGZw?=
 =?utf-8?B?cHc1Wkl3NTF0SzRGUU1qZW5QcGtUZVRHZ0dUc2xzOUpTWWcvWlczcS9oSkJR?=
 =?utf-8?B?WmRYVzltOHdlWDZLN0VRbWs3UjZHcUZOMHU3bjI1a3ZHcUpZdVF4SHdpdU1M?=
 =?utf-8?B?S1ZkUjVOb2hXeDBwMDZXSWh4Q0pENTlub1hMYURmZ0NWM040RHdvbXBWanNM?=
 =?utf-8?B?aFpTTk9QNDJra2dFQ1NvbjUyTjRaVU5DYWxweWplY2Y5VCtpY3hBWjJianJ6?=
 =?utf-8?B?M2c1YjRwZEw2VDg0NDRwaTlUOW9FTDZ5SUt6aWd2RVZ3aldoZzBFaERQZ1ox?=
 =?utf-8?B?b3QzUDd0UGJsem0xQngxOXF2UUI5b0FORDhHSnB3d2JkK25BY3JBZjl5eHov?=
 =?utf-8?B?d1RYRHREODAyTFRmZStWWXhOT25IK1JUVGV6bW1qenA4ZkFsbk5UeTlycHQv?=
 =?utf-8?B?TFpzVGptMzVTWnJQZ3JMd1pEazlBOVFlVjdjL1hTUVQ1UmM4WS83T2J6ZWpG?=
 =?utf-8?B?YkN0Y3BEVkVXQ3VkYnk1L2NEdzBFYUhJa013cndIOU5MbDA5elJZUXRqR2hp?=
 =?utf-8?B?ZlNIeFdOKzRWRjBzOFk0cFdOUXpJYW4rdEJ4Zk5WUzU0YkhpMlNKUkl5UWxk?=
 =?utf-8?B?WlAxTG9OL3lRZUprYUZ1Z2VVTUxOTEFkMHNtblpweDlySXo4WW54NkUzMmx3?=
 =?utf-8?B?MkloUmtwWlY5K2RlOHU4SE5PcVZJZ3g2em94L0pkeHk0L0ZrVVk5Vm9sdGlu?=
 =?utf-8?B?ck8rdFcvVVQ2ZmlObGZrTWVKU0Q4a2dXZElxR3d0S1hFYlhxN0lVbG5jNzda?=
 =?utf-8?B?VzF2VXNkRDV6RU9UVG9ENGtueDJObEZUdG1RbmZaUGZZZlo2em9sRXhjalNq?=
 =?utf-8?B?d1o1UHo3WU53Sll2Q2RVcWFXem13Y1NjVXdHR2NpTzl6ckJJZ1JBV2VIU3F3?=
 =?utf-8?B?UW83OEJ0bnM0cXhlRGlmcmZycFI2WkEydW5hUCtUTndMM2lhK2dMdCs3cmtM?=
 =?utf-8?B?ZHBqRlN6TFplbTdyQ3lxbjZCa2NaUmVNVzJKSGVZaHM2QWMvU1A5ekdxb0xx?=
 =?utf-8?B?OUs0WWVLMjJ3NmZWTXF6aXZvTHYzcjZaZjZ5aDh5NmtYSDhpVDhFVHhOelEv?=
 =?utf-8?B?bHc2bGJDZ1hkZU9sM0pHc2g0L3RVUnMwU2UyVkw3U1ZlbCtub2RWRGJzdUd2?=
 =?utf-8?B?SFFNUmVIeEljaFFkK25JMUY4VDVaRGkvNkxZZlVUbGJsYkt2YkR6NHRzOGxk?=
 =?utf-8?B?d3o0dEpQcjg2SWx1Qk9mV2pYa3hLTkp2RGcranh3dFllQmtpMW51b0Y0ekRz?=
 =?utf-8?B?OHRFMmRDTWVORHVraklFY0toYjJMMENIOE1FTnNhalJRZHR4UkVzanFSTExN?=
 =?utf-8?B?QnpQcXpxazdXVmhkdGVTR08rTTdYSCtvQytQOVA1U0lGOCtZWUVXRWpJU0w1?=
 =?utf-8?B?b2VVeCtSY3ZIK1p1SWMzTHV5TkpNMFlValRXRXRzNWs5K0NBV2l0bkdDd1lG?=
 =?utf-8?B?dy91RWlJMkt5T0lXeHlGalA5N2l1a2F6Y2pzd3R0RlpPUDFFWEVQVXdqTzFF?=
 =?utf-8?B?YllFVGVaTVlFcktWVCtEQWpLVXhsY3V0TUZOMEo4eU5RR0cxSjRhbDJrTEJZ?=
 =?utf-8?B?ajNwbTREOHlDVmJhZkR0YkFGTXgybEVzTUQ0MzVtRlp6QUNZQ2RMb2VkdlZy?=
 =?utf-8?B?cm9WVDhsb0tZM0NlTmpYTFU2TU1yRkdaMms2QjkyNFhIaFhjeFE2WHVZby91?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da27227c-d70e-4fb3-8a12-08de10a708a4
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 13:37:52.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlDk+VFOywkROD1Si4+Os3dUmoNw2CadJEczgNkILYIjVfNmYjI6NcSRh+E8U2BNUbNgFW60M8H2dlDmBFG5jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4580
X-OriginatorOrg: intel.com

On 21/10/2025 01:55, Edgecombe, Rick P wrote:
>> +	 * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
>> +	 * VP.ENTER succeeds, i.e. on TD-Exit.  Mark those MSRs as needing an
>> +	 * update to synchronize the "current" value in KVM's cache with the
>> +	 * value in hardware (loaded by the TDX-Module).
>> +	 */
> 
> I think we should be synchronizing only after a successful VP.ENTER with a real
> TD exit, but today instead we synchronize after any attempt to VP.ENTER.

If the MSR's do not get clobbered, does it matter whether or not they get
restored.


