Return-Path: <kvm+bounces-72984-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMI1O2xiqmlZQgEAu9opvQ
	(envelope-from <kvm+bounces-72984-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:13:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 810D821BA5C
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3EA13051D32
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 05:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8A736D4FA;
	Fri,  6 Mar 2026 05:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h9KJwfZe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1CA261B6D;
	Fri,  6 Mar 2026 05:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772773983; cv=fail; b=fIHrpCT0zQW6nRt8hDCKCv69WteLzt8aggYtYt/MS0xkh7jl2klFT5Qypn4Cfnz7BlWNYvrfWTDV/tkyo/RXkkICzFogyX64KcSE8VZ3DI4rGrbiPeCwWc2vcik/4hkMpyX7imWWHPju90VHS9j1j2iZKH0GQZNO5a1ouWhTDWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772773983; c=relaxed/simple;
	bh=28dVSslBiWRWzbDhzuZpxArfTQjNPwJLTK5cTVrLJQI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RMP21dbDXZm+d404y7jiyzPGJWJE0zcQkPdUBq8mGVrm4IupteRlaJ+lyG5M39HeJoVjXVe2dFgVgUPPlt9eW+B34/ti+VVPxO9/fUHaOAUMWF+zW/DrvjC4HAPdXGh1wwsExNugpMUT6BQ71C/IcdMgNyJZDdpmaqpGIJFdEO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h9KJwfZe; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772773981; x=1804309981;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=28dVSslBiWRWzbDhzuZpxArfTQjNPwJLTK5cTVrLJQI=;
  b=h9KJwfZeimBt97Dnsvku85O6v47jn2F/kk7HKR1FYGAPGS88Tx8slFzq
   mwCY1aEecDBUGBuNuG+EXAGHHDZSDyh+wykUQGBKhKUBMAjdpTxqsKOdO
   gc5TVDPCoqHPKb6WfZhlaIdvGNzXwTHWxl51SOS6NqvUU4AIqiQTBcfFc
   L4UstEbRxctJ9FYkAWrY+LR616quCuZ87kWR7pIb8W1OSRdu95qOq3skd
   OLWtVEatdkHIjPjHja+V3X0HjlYqF8taOz6MIq7qmx1SWP8NBQQAYZYOW
   AwBsfbnvChhV8yFiItZE2QPtNLWREMUktNtQ/n4fHt+DpTUVnPtqkObIB
   A==;
X-CSE-ConnectionGUID: p1iXyVqASqGD+qDo41EOeQ==
X-CSE-MsgGUID: MLO3Nf63QLCLspETXy5GVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85226312"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="85226312"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:13:01 -0800
X-CSE-ConnectionGUID: wWXvnz3wTi+v6MfwnNMTXQ==
X-CSE-MsgGUID: cc1FMBBfTwC502OauKS5tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="216070443"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:13:01 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 21:13:00 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 5 Mar 2026 21:13:00 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.26) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 21:12:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LoTIN4OyXwXopMZG9IjGoMmPB1P5zgCdcywi6DSMXb7N9yPQe1pe19BmVmf7IAToGCbSjg+X65mo20sGqR+2nantE0u/hdnui2R0avcyLPyNHHOVp15tgYzrdT95T0n2FbMOsTnJvHRCkFMnY4OK5R1hCbNKXUQ89Oso3wU2w3ONLE5Awk7C2Cjzeh6ph8vVmsgGecyZ5IK/Xdox2KofAfUUhHlv3eqGFrvSyz/DNQGHWgTYwA0c9ZTG33ghV3I31utG2SXuvQPkTFNNGrY2EDuRw87HfhiLWG80H6rtAh4xgnuUl7qOuD0Pyp/6JgpuF3Fd+9kwULWuVaXUxfJgHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lk8NeNG8ugKyd1Iy/ATDhKuJTRSuiTdL5tgYtJ5bDbA=;
 b=H+fVfRBhjmX0Qg3yETdOiDsyjhtu2yToY/JDL1lURIujVWriTfFW3kbaRGnC+XFI/43az3jvlMBftiYcuyb68U7brSaQcsvC5q0kOc3W1aJ2TNZVWtuYbv0x7kHQ7Z07PYm9i5vZY6AsJ9wZ9G5ZKrXEl/O0vAY6pu9V9dUWvUs14n79UWcBS911TGr56zCVYksYtyB/HmNlFeTx1PHrHdlYCmuI6H5SoHDyfTPH6PwwxCqwucPdoZRX4Hm5M5fPgPgpx5mDj93hBKXGUb7y2QcLhewLsH0+glt6kz9dtYCF0dNy41hZTOUpff1YKW8D0v3eOohdeAWuGA7Jhs5Ydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4862.namprd11.prod.outlook.com (2603:10b6:a03:2de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Fri, 6 Mar
 2026 05:12:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 05:12:55 +0000
Date: Fri, 6 Mar 2026 13:12:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Binbin Wu <binbin.wu@linux.intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>,
	<tony.lindgren@linux.intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v4 02/24] coco/tdx-host: Introduce a "tdx_host" device
Message-ID: <aapiSqq9ebBwoM9M@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-3-chao.gao@intel.com>
 <1be33429-25ee-4e99-b795-18f77f6cbc34@linux.intel.com>
 <aao4VunqChU5ZTOE@intel.com>
 <635e5c2d-9b4d-4c2b-8e7d-b9b6b3ec538f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <635e5c2d-9b4d-4c2b-8e7d-b9b6b3ec538f@intel.com>
X-ClientProxiedBy: TPYP295CA0005.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4862:EE_
X-MS-Office365-Filtering-Correlation-Id: aec570e2-e3e5-49db-5684-08de7b3f0667
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: xejkm88Kch8nPH+cWXKRJrh9olE8aH2wjQ+YyInx5qUbuAAWH8NsVhmP5wvCRTBvyqxn14jun/ATA0Dq0qg6PlT9hQi2dGdLKVPwlOdcxsAex3OJTXjVeBP5oS6GnVTvcOsuA+S2GcA5spPKUFlh/2G1odmQQxnRqWISyOOT5irmZVFbAaYsXnc33/Chc77OwcwJ7epqjzsHZfN7RkUc3nuNVTKPSSiUK913JX+buL6sR9lO2BzkTvq6UEsRk1/Dywm0q5+a3xjez8o7LAOw1ZKZccjfi3N+iz+krcrGTQajPOnO98Bxwb6a1p0RBE08y0IBWAkeRcsxhvWZk02y4mWgHjtC57ChWCjop3O6xyCdxNskmgznpZ2VXjzjebj24TfYcWfu8ynhx84U8w/zia+6d0rCDEi+qJqwyz6+0+ZA3KDpQYFbL76EYQ3kAmYEBIEWaJNqG2ZtLH9ZzSQQcg1/IBaLgaU1sdMCiwQ5s+wV8sxePMeF3sNSrfE0ped9Ec6b3RrwmsNHNWXZ7nlHtRCeQGWsVmlr6Vh+7EgjDJDdpB4YdlFiq7QFSdWQo92Vfosmv8aZpfstwtAwxaRSEW5MTC80iiZ4nMtHE/MVdTH4pUzptlyGFgiunUgL+7s4B0G/PLWlJXAehQ3OmxwKVmeFyipIHEmuTPT6Sk6eD/dXEeJiaxlolDlu1XgvdAJi3vo8PGgI+1RR3jjx5PwkWF6cHkTtBFvosy3gajTjq7M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJPAiUIblMkeDnySTPeCIjumOFty3NqxP60WbS/SheG9mY6JyQ8/eo1rkyEa?=
 =?us-ascii?Q?k8dU8G44uReDLe3LqU0ROimRD/4eGpD4DdHjaLICkK6rrLwc/PPFqhS9YzKI?=
 =?us-ascii?Q?4h8dWaRnlOO1KAlpdGtsAS/QnzKrTzpvdJy1RFzJc7UEYtGlVouNOarb63zZ?=
 =?us-ascii?Q?C+XIRbSYDH13zvL0YmIqbG9OLsXI6TFv2/uxRvBZeJfoaSK0EHcCq9/RWp4j?=
 =?us-ascii?Q?zGEhs7APUL2vtyzQwYG4UnzxLie1aHE8V2PEeUraTN0WFtSHs2Z8ZvAePgF+?=
 =?us-ascii?Q?biyXfGTvHsjC/0M0q0p1xW7qAAPsd/BrAvjdD25qfIxNEOIdbDDTl03PhUHY?=
 =?us-ascii?Q?91pL9W7LVLIUvp4EwvDWSjOYp9+q0mXlpkmX3j4LqdXh3ZxDYDwuRyT0RpRa?=
 =?us-ascii?Q?UZNkaH51Hjybh+adVLhzqRx9snfiJCrPnvVJwvP+Uz1X9Ac9Y8MPF4pCyk4o?=
 =?us-ascii?Q?scO4YxBxcZxewT2ptob8RxxHRm8redoHUMbcxTSlc0qmDlIwNFyP1ym29zke?=
 =?us-ascii?Q?q7Rbs4L9LDLQqOpyjYAUuTzpMypS89X5mD0Tm75DNeHkbfEM7mvB6OXIcl2I?=
 =?us-ascii?Q?zOQKzkQROir6ucVwoGDcuc0otfwaypYxc2s8Ns7DiGdA8MxqPvGHRev0dsjM?=
 =?us-ascii?Q?Gaj6QVZJKs3uLDKF4Xfyud0qIOOgTSZ4gmqlXBYNFyCc9UBk2eM6OwPIyXU2?=
 =?us-ascii?Q?vtuN8Ka6qcAgIFeMZNrgNVHrIrpUPAkirjDVBWOluDNlHux59GP+hJgiN8+w?=
 =?us-ascii?Q?/Qsoo/JrGatI0zrlyRYfLr3xF9YAKuDBX5j1o+ci+yBCIPzna7gPMfgHORI6?=
 =?us-ascii?Q?/m0fc8quzaq56iiwHyCVN3dpEI/f3fi2zM+3McPDUlVexfvoAGErZgxy3Lsl?=
 =?us-ascii?Q?konin73eKkNkwMS0bg8BCFV1C847CQBcf48sZ1ZoDsKJK/Vsi7a3Gt+IRbMr?=
 =?us-ascii?Q?7sMFp6Xbjh1OwdhxJmAQqRhR6i5l0A1XPn+B15lFxTluNBk7RJ1IuW9olYaw?=
 =?us-ascii?Q?aM8YSbXBDNo0fTDpRJrMOkGdZ8NMqZiVNqQxVQna74fXFE9COLMz/DSvW/E/?=
 =?us-ascii?Q?eTkdvmdqQSCOCf+pt+DesDSXYi/mnnFyRUAJdRMtqipMWVwF5MLnDS66sZgM?=
 =?us-ascii?Q?0eyU6x87q9Z+MKtLY8SoycV+ypQj2pViqExIaUTlWA30cMNkG5yG58X7ZIWF?=
 =?us-ascii?Q?/9jClUpWOd/G+hxZpb+6yXx6S+Fw7Ib27yl5JouuQ+AR5ooETaWCnm+xXc3S?=
 =?us-ascii?Q?AwdOxfyHTweJ2FWKzTCDiVk5wvdQF3DeXiZdqVEKynQ6EN45MgNZZwakMWC2?=
 =?us-ascii?Q?Ux1dW0DaUnWueBlW1zsLhqjliVhl6fwqbpAIJHkSUu9CBju/yRFVl2mlm5vr?=
 =?us-ascii?Q?d22jHvFYKDM4MRj1yxX/Z15IkXCZ0MdsvUsy1XaBOlhzHDmwURGeIFhni30h?=
 =?us-ascii?Q?I31nVUhcF4N9XA8gEjQGU+LOiWh3wW7QvBftOsAIl6YgHqiwXiSm967qkbzi?=
 =?us-ascii?Q?oCdWqwKpIEidE8dZvPqLG7i4b4P9Kqd+MT0JVCscxRgc2kIz+FZSErABlN6B?=
 =?us-ascii?Q?3DwAdySQcU3KWN++nwlrTWtJ5/3l0K3B/0H5nLy6B51BTW3E35m5KWFkZAr5?=
 =?us-ascii?Q?Nhms9Wm9yS/GwTAPxvbElqFjeVObWDkuRgexseOeuYitjll3ueTWRRab1gsb?=
 =?us-ascii?Q?7Mssr9LmARQ7cR+pTQYy9WalU82T1PAXsGb9SuG8ePkYGK2ZJG4PJm3s1pQO?=
 =?us-ascii?Q?MbRnh9c+qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aec570e2-e3e5-49db-5684-08de7b3f0667
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 05:12:55.7113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzfWAc4mI+Z15iAXzQ7Ds7A6+gLpvEPMGppigIfisFuImgPssgffpq8dQFeHK5285A/tyHHgdUYogeIahCfvJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4862
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 810D821BA5C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72984-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 08:17:34PM -0800, Dave Hansen wrote:
>On 3/5/26 18:13, Chao Gao wrote:
>> I don't have a strong preference, but I'll standardize on "TDX
>> Module" since it matches the Base Architecture Specification, which
>> I think is the most authoritative source about TDX Module features/
>> terms.
>How about doing what the Linux kernel does -- and has been doing --
>instead of trying to pick a new policy a few years into the kernel
>dealing with TDX?

Makes sense to me.

>
>"TDX module" was the first and it's 20x more common in the history than
>the next closest one:
>
>$ git log -p arch/x86/ | grep -i -o 'tdx[- ]module' | sort | uniq -c |
>sort -n
>      2 TDX-module
>     21 TDX-Module
>     26 TDX Module
>    501 TDX module
>
>If you don't have a strong preference, why are you arguing for change now?

I was just explaining what I would do for this series and my reasoning (if no
one had a strong preference and no one responded). I wasn't arguing that "TDX
module" is worse in any way.

