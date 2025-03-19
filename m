Return-Path: <kvm+bounces-41478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D030A685EE
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 08:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E7B2162C68
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 07:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573D624FC1A;
	Wed, 19 Mar 2025 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O+jlzNTH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF1A20E31B;
	Wed, 19 Mar 2025 07:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742370079; cv=fail; b=Ec90xqCtW3VPdsryYij2rXY9goSwWbofpOYHD3bLLW46no1NM+PyFpPINceX/2UntTFMT23JCoFC1tQCHCAjtsYujnzFWq832z2fOjNP702uPUi52jTAcVuLYEVQ5CfoSo+szaV2KKbhOONMWvPrwnd/Ix3ym23P9hPU5+lp5L4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742370079; c=relaxed/simple;
	bh=YtN9yfLvhgGth1fRvVB5AyNZEmQnccq2x+yRz5HR8VM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pI1BnUdW8pVM9W7tCEA3ZUJFqf5dgH63vJ7gibOrPH2vONlvMF6aV6tqirNvIw5mH9K7xQj+LcAMAK8Yp9W3jT2S5N7ysFUCDKlzu4QMP4anX1BrgDdGDHi7KpFZV5aMSZg9RD1d9///pv5+g0BK3wSC/fw+Xep4gzfhwlN3OJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O+jlzNTH; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742370078; x=1773906078;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YtN9yfLvhgGth1fRvVB5AyNZEmQnccq2x+yRz5HR8VM=;
  b=O+jlzNTHcpH5NMA3eB3AdpnoTbxLOrn+3W4hujNhprRn8mnqUpb4WZrK
   HeFw4Say/X5c8lvjG1S/CZVdEt+WYRIGCz+NlHrGuQiY4eb5d5LCUTByC
   nMVyfqec59vPGFtNuDe4Cz6yOdzQlJbrRlYp4iZCDtmyIviCdgaSfp1fL
   WcL1e1xBv1bCUde2Ls+94v43mjqaIiWErUocOSncrAbenykmozDiTVFG8
   Vv5G6EOmUvzmKp0KU2r3HaVLKyH46JFeN3GV5bOxL2fDO05lWsxF1BoRT
   y7VeEgaGWbG02xZzI9VSQ4eZOkKGVLVEJ9swVYZN1Pgo7yEfsgcPwcFFS
   g==;
X-CSE-ConnectionGUID: 1CIqZ+E6RcOc3rJvEldpBw==
X-CSE-MsgGUID: 1lqBlA3dQsS+wuk7jCpRXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="43678796"
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="43678796"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 00:41:17 -0700
X-CSE-ConnectionGUID: X0Bm3ax+Tl6sL1JpQVTTkw==
X-CSE-MsgGUID: nAqvG1UhQlyWfVPA2hl/Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="126710232"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2025 00:41:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Mar 2025 00:41:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Mar 2025 00:41:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Mar 2025 00:41:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZ2WUM69WfbLDfke+1Xy8nD4+qc/RzBvPbo6VFj0Hxp2Qmb7tXxGj/7sdazFLdRnW7PUrNOves7SorqBopINSg0AyNRUO8urJfPgcwpDU7GbhDenN/19wFQxusRo1EzdEt4a6QSKcn6of/6zsk7MVeucJFTNfyb+7I2Bcu7rQK2uRN4isf2AwpDtRCawCEcp6g5dD0x9FMkwJxAfXnXl2XWAeiGhSfxBB4ua0mzgoaj9ZsE/dG41LV9j57OBxVkf/6OYBB2/UnETRiUyOCwdP0CDfsfVejJJ8xswOdugNiG2T3NfCrr7hEwhxBAGbH6zzF4yVxNk3EHkUEMZGiCCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J103ze6pwTUQTY1pxUnaNQVYPFxUemlyWBOqSXDkwfY=;
 b=zLs8VLyCo3DvKfotR3zzv2Rv0M1OEBASIhek+qyChdTSCZ1ps6rIolkLF2qWCGSwfHcScdBsTswN035JwTYOxwOHLYqNaoGK/477zsm0/vFy4HP7cMtBVvCI+aZsGjROufaE7H3P9EkIX78VnI2gZckJ7D4T9zRv0i4KhNrXL6kRTxFfHkoTEvRRm4PuRg0aAjM8/pqSKhWVoCHJz0ukt11qcQChZ8oHh2Fl1IGu7OZSMsbPejXS+R45icsVZ4EYTKdh0NuHbT+m+tWO3jCAzXPkX430VeMZK9ClbP0ulxqRhCn7GIOfntLbZE1MopzTcTpEAZF8v7+QGa1zn5uQPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8393.namprd11.prod.outlook.com (2603:10b6:806:373::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 07:40:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8534.031; Wed, 19 Mar 2025
 07:40:41 +0000
Date: Wed, 19 Mar 2025 15:39:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: "Shah, Amit" <Amit.Shah@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Roth, Michael" <Michael.Roth@amd.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "seanjc@google.com"
	<seanjc@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Sampat, Pratik Rajesh"
	<PratikRajesh.Sampat@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
Message-ID: <Z9p0nFvVxoLkx+6y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
 <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
 <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
 <18db10a0-bd40-4c6a-b099-236f4dcaf0cf@redhat.com>
 <Z9QQxd2TfpupOzAk@yzhao56-desk.sh.intel.com>
 <Z9jZRdFyyr1DFkvV@yzhao56-desk.sh.intel.com>
 <7c86c45c-17e4-4e9b-8d80-44fdfd37f38b@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7c86c45c-17e4-4e9b-8d80-44fdfd37f38b@redhat.com>
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8393:EE_
X-MS-Office365-Filtering-Correlation-Id: 2062e164-7e06-4d16-ee83-08dd66b95978
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/KR5VESg///SPVYvWm+IkHgA4dbUwIImq03RyyiCT9t3NcTVByKL3fxfDPLy?=
 =?us-ascii?Q?T8ApGxSoU9u3Y+G/4FhTmyGP1txOcFWpw5FNnA2PYMMWozCJ7qhPsRS1hYWo?=
 =?us-ascii?Q?itFsQm+ACXjGNTH8cXHg1Nfw09GB0eSk8sP4Fb2Pg0jcMzHh6nQhPzpNC4Ob?=
 =?us-ascii?Q?FIy3yvGeldHnOYcsvfTtUwfhDzEeHt1IxUjqBwpwfztC7SPPkK5FZ/e9Ykbh?=
 =?us-ascii?Q?F5FtRYvKyzdl6ViQPIEPzIN5RpYETXafs70AULBNgCLYWnVfDGULREe7oYXy?=
 =?us-ascii?Q?vNiPR8b9oZvDBdmtuVfjkSuHOmXXI9DwSAhDYAOvGg9Tcfko993/ycPlsCvu?=
 =?us-ascii?Q?86JflZ4dGMtoxUAVCwb4fCviVGCpNMG1z6XCberESU1S9515pAxsWh8pJq5j?=
 =?us-ascii?Q?qFIIrUrGdlRC7/XVmPo/9MC+pvWVzZdL+bXi/QjLYMiFvXuqQH6r+6xP7g7J?=
 =?us-ascii?Q?IKCtNL+C/3fJwxu0SrrpVzOp1W67l8JACVYcBTQLlACbis98kqrRpBbykBDd?=
 =?us-ascii?Q?up5lWxzWVWYS3S6rsG/fVu8I5FBIcuOQwXI8HRzC44sTmojjNIxXpHYXx/PT?=
 =?us-ascii?Q?i+5q2igMCIIMIuKwkNIIUNLRNA+rW85yCFmpXhqgpMpwgrz1UiVOdkB2LPUP?=
 =?us-ascii?Q?EYNf1PHo6kkwZgyGCIjkPh5zdz3koShrpOR833CmkoZxtZcLTnI6sjCWS2l6?=
 =?us-ascii?Q?b7adbxcmtqDi8BOtnOEaqcp/iqYb3y7Vpo5+/41pFJYf1TBx28qNm3VHTlDr?=
 =?us-ascii?Q?2jJVf1YabbRCc4ZMKS4JLhehq6yE89pstc3xNC574B6cw77uIWfTois76d1d?=
 =?us-ascii?Q?uLaWr5uXimdfxW4ftL2sXFZ5MPyt8CxU0KtAPmddG5Cdm7/X+upcTWVdnEgb?=
 =?us-ascii?Q?DFuZoLXI5RJo6pVlb2JX5V68Wq2t9ax//dWlZI328FSujoIZHpfxgD+F8+su?=
 =?us-ascii?Q?iRB7s8IQNZF1NVFHu7VadroDSmU9G5AFZtoH0sDtHv2FuxMRF1RUoFtNxJxX?=
 =?us-ascii?Q?U1JK6eGKKVA5Ez8y9/hGUThfjgYAMrvfrxQfZrJAmmkkytFStdQbCsPPjD6u?=
 =?us-ascii?Q?WMgAvpS9Is3ZrN8vu40Bg5SROHEo1SQiukyzOnkqziijno5IfabMbuJwsHvo?=
 =?us-ascii?Q?B/ey2vkKkFBh42u0d1ZCc1xQ4itC+EJko0wxWWym3wFM5Y6jq/UxwflQUz0J?=
 =?us-ascii?Q?BIoyViNRSSYN1RwhehEbDhDzWstep2bQkMxpa65oi/p7mdD+2WYfF6XH6A3y?=
 =?us-ascii?Q?SL2FyqQNan4ZJLW47DPjwsfpTFh6zx43SnSJnJE3LYXL+3xOOAeq8SN7/EbZ?=
 =?us-ascii?Q?7U29CD4y3ZuYShpnQUuxgyLbuhJ9THEPd0wZPihbPXz4sdAeX9X9rBQOTFgI?=
 =?us-ascii?Q?NGA35HaKU8uoxUKyb/YqwkTDEr3T?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J7Yoi+jDDZWZ557udkWeSxy5hhf6bxfpM3U5OWvLj+iVd4ysBQzbqkuMUFRq?=
 =?us-ascii?Q?TfKXc69rFfnNPJZ9FodXv8WP1V5ri7xVy4ZZvsZRebz4s7DD/N+80EyCwHDK?=
 =?us-ascii?Q?ysI81ThxaEC+LDYxcKKULbZQqyOe9CL43MZR/UeZhfxwcMwAOW1Eh72ZTH/d?=
 =?us-ascii?Q?kkkufX2k6U76FVC3vS4zGeRSbiuIvlnpbde4F+EyfCuV7X0zN1JsdJ/pVRAo?=
 =?us-ascii?Q?95i5zbBekwjQWHex0zsRzw9D5k+aXqKuNzSNfPB2sShTbWftCd4D2lvW1eic?=
 =?us-ascii?Q?tQo8kWd3LWoLZH7yfS5Vu7r4IjmQCtDEsu2NqS7c3BNZIz20QpJqvEXdxM1k?=
 =?us-ascii?Q?ASyoK1H23Skd9Iyg7BkMFjsXHpQA1RH/e5T0OBVcxmIUS5NIVKTpkRIRRdTe?=
 =?us-ascii?Q?Aty8LUvLhn/48GVNVbJ9nKQ7UjK0vaxCKaRg7MCko57vIH3tOKzofHmG4B8F?=
 =?us-ascii?Q?rOECpgyDPSt/niSYz0pnc2H5EydoBcgCX/lBDD8nsnumUe1DVkauoCnfH4dl?=
 =?us-ascii?Q?aPjQ0PV7AZvnIuG8vAPW4A/sT/ljoxhLMxvjkY96xDG1w2J8etwk64Iz3oYJ?=
 =?us-ascii?Q?B/4AbACTulMK57xE5hAMUL0fnzwoKdqk3RT2eKegj2GIGTsSvqKJEsNYUqDL?=
 =?us-ascii?Q?6UmynZNKqTEIiWn9+aXi9+p4s9ZM6MCP7DeVwiTR+8NvDUFE3WRlCKyzXw/h?=
 =?us-ascii?Q?oA1gCvu4e3RrJM4XRQx+hm9eGFzEo3o7/N3ULLr4ZsGK+q7iqdxPn6bMwEfa?=
 =?us-ascii?Q?2mAz7RZ/pXrZbPrfKBhqOICJ3lUg4IQvbl8odLgXc84oK49xBbHn077DHdr6?=
 =?us-ascii?Q?f2cCJMx9mcEM3HSZHvBc/83evMfa5t40jchowoj2hIjww/NiFYTe0rqMVysI?=
 =?us-ascii?Q?eXjozHBVYi4R9j1siHTydo4+ukwk33XaSvDoctkwYnRdQGaSAwUMpy/8b+J3?=
 =?us-ascii?Q?s3KzFzOtRZ/q2PxRglNp1OwyOdt5nslRHnJruMF61M/nIXyP2TlYtWnqdJNG?=
 =?us-ascii?Q?IgqCU0TYbf2JRnWqQodtZEqkwZpyjnwcsHucoG7CbbuIBieaVTniwCxKSKZr?=
 =?us-ascii?Q?YDljx7Cp9nY/CSPkIM9RgukwDkvO7S7QKcJbbYacB8/NAccwBOIK9ZSXkpvh?=
 =?us-ascii?Q?azTE0RYyOikBzdVbxPr2JwhR5IjkG4iD4OlFu7Ijt3Fmruw5GpRVbJqCQA9j?=
 =?us-ascii?Q?SPXAsCqgX/7e30p+VGvFGHMSdKlcEyV0buM8s1xp11gsGdlNkA9akeCuXtMn?=
 =?us-ascii?Q?5fT2KZz/32Alt4bciDA+wgM5FRvrSKKY6FoOCHO/fpsdZY9CIso3i4bZ6Pqe?=
 =?us-ascii?Q?+jCD4Cs1iHu9OuY55IyVxiTWJRmP4s69aCOnZpp2rVkQ2zjTBvniw5dI1p1I?=
 =?us-ascii?Q?Em0qCUfF9d3vJFjJ8Q1vFHLhy2SDU+3mOTmR3fgYQdk9AR/8377+NKffQWYx?=
 =?us-ascii?Q?bXjCEfw6oCc/BQQ4DBfGeXNefaXZs4dDCuU0mSC4yQEMZcMWMLB4HUTiUt0W?=
 =?us-ascii?Q?KKCZ2JPoZyQlqL5J1Gz604/fj5ykkOBKLNN//57SDwgkEyrxun0ca07oBrd4?=
 =?us-ascii?Q?BYzp3IeUh5cRKU6/3SyyhkseBwZ42vlxw7im6Ihd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2062e164-7e06-4d16-ee83-08dd66b95978
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 07:40:41.3996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2OjpEuNG0quGD21FWjvMGmiri5b17C1Wp59195MZ/Um+HNcTx2Okq8ZqcQZpUQtFGYcJ/HDajtojqgZq+oMiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8393
X-OriginatorOrg: intel.com

On Tue, Mar 18, 2025 at 08:13:05PM +0100, David Hildenbrand wrote:
> On 18.03.25 03:24, Yan Zhao wrote:
> > On Fri, Mar 14, 2025 at 07:19:33PM +0800, Yan Zhao wrote:
> > > On Fri, Mar 14, 2025 at 10:33:07AM +0100, David Hildenbrand wrote:
> > > > On 14.03.25 10:09, Yan Zhao wrote:
> > > > > On Wed, Jan 22, 2025 at 03:25:29PM +0100, David Hildenbrand wrote:
> > > > > > (split is possible if there are no unexpected folio references; private
> > > > > > pages cannot be GUP'ed, so it is feasible)
> > > > > ...
> > > > > > > > Note that I'm not quite sure about the "2MB" interface, should it be
> > > > > > > > a
> > > > > > > > "PMD-size" interface?
> > > > > > > 
> > > > > > > I think Mike and I touched upon this aspect too - and I may be
> > > > > > > misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
> > > > > > > in increments -- and then fitting in PMD sizes when we've had enough of
> > > > > > > those.  That is to say he didn't want to preclude it, or gate the PMD
> > > > > > > work on enabling all sizes first.
> > > > > > 
> > > > > > Starting with 2M is reasonable for now. The real question is how we want to
> > > > > > deal with
> > > > > Hi David,
> > > > > 
> > > > 
> > > > Hi!
> > > > 
> > > > > I'm just trying to understand the background of in-place conversion.
> > > > > 
> > > > > Regarding to the two issues you mentioned with THP and non-in-place-conversion,
> > > > > I have some questions (still based on starting with 2M):
> > > > > 
> > > > > > (a) Not being able to allocate a 2M folio reliably
> > > > > If we start with fault in private pages from guest_memfd (not in page pool way)
> > > > > and shared pages anonymously, is it correct to say that this is only a concern
> > > > > when memory is under pressure?
> > > > 
> > > > Usually, fragmentation starts being a problem under memory pressure, and
> > > > memory pressure can show up simply because the page cache makes us of as
> > > > much memory as it wants.
> > > > 
> > > > As soon as we start allocating a 2 MB page for guest_memfd, to then split it
> > > > up + free only some parts back to the buddy (on private->shared conversion),
> > > > we create fragmentation that cannot get resolved as long as the remaining
> > > > private pages are not freed. A new conversion from shared->private on the
> > > > previously freed parts will allocate other unmovable pages (not the freed
> > > > ones) and make fragmentation worse.
> > > Ah, I see. The problem of fragmentation is because memory allocated by
> > > guest_memfd is unmovable. So after freeing part of a 2MB folio, the whole 2MB is
> > > still unmovable.
> > > 
> > > I previously thought fragmentation would only impact the guest by providing no
> > > new huge pages. So if a confidential VM does not support merging small PTEs into
> > > a huge PMD entry in its private page table, even if the new huge memory range is
> > > physically contiguous after a private->shared->private conversion, the guest
> > > still cannot bring back huge pages.
> > > 
> > > > In-place conversion improves that quite a lot, because guest_memfd tself
> > > > will not cause unmovable fragmentation. Of course, under memory pressure,
> > > > when and cannot allocate a 2M page for guest_memfd, it's unavoidable. But
> > > > then, we already had fragmentation (and did not really cause any new one).
> > > > 
> > > > We discussed in the upstream call, that if guest_memfd (primarily) only
> > > > allocates 2M pages and frees 2M pages, it will not cause fragmentation
> > > > itself, which is pretty nice.
> > > Makes sense.
> > > 
> > > > > 
> > > > > > (b) Partial discarding
> > > > > For shared pages, page migration and folio split are possible for shared THP?
> > > > 
> > > > I assume by "shared" you mean "not guest_memfd, but some other memory we use
> > > Yes, not guest_memfd, in the case of non-in-place conversion.
> > > 
> > > > as an overlay" -- so no in-place conversion.
> > > > 
> > > > Yes, that should be possible as long as nothing else prevents
> > > > migration/split (e.g., longterm pinning)
> > > > 
> > > > > 
> > > > > For private pages, as you pointed out earlier, if we can ensure there are no
> > > > > unexpected folio references for private memory, splitting a private huge folio
> > > > > should succeed.
> > > > 
> > > > Yes, and maybe (hopefully) we'll reach a point where private parts will not
> > > > have a refcount at all (initially, frozen refcount, discussed during the
> > > > last upstream call).
> > > Yes, I also tested in TDX by not acquiring folio ref count in TDX specific code
> > > and found that partial splitting could work.
> > > 
> > > > Are you concerned about the memory fragmentation after repeated
> > > > > partial conversions of private pages to and from shared?
> > > > 
> > > > Not only repeated, even just a single partial conversion. But of course,
> > > > repeated partial conversions will make it worse (e.g., never getting a
> > > > private huge page back when there was a partial conversion).
> > > Thanks for the explanation!
> > > 
> > > Do you think there's any chance for guest_memfd to support non-in-place
> > > conversion first?
> > e.g. we can have private pages allocated from guest_memfd and allows the
> > private pages to be THP.
> > 
> > Meanwhile, shared pages are not allocated from guest_memfd, and let it only
> > fault in 4K granularity. (specify it by a flag?)
> > 
> > When we want to convert a 4K from a 2M private folio to shared, we can just
> > split the 2M private folio as there's no extra ref count of private pages;
> 
> Yes, IIRC that's precisely what this series is doing, because the
> ftruncate() will try splitting the folio (which might still fail on
> speculative references, see my comment as rely to this series)
> 
> In essence: yes, splitting to 4k should work (although speculative reference
> might require us to retry). But the "4k hole punch" is the ugly it.
> 
> So you really want in-place conversion where the private->shared will split
> (but not punch) and the shared->private will collapse again if possible.
> 
> > 
> > when we do shared to private conversion, no split is required as shared pages
> > are in 4K granularity. And even if user fails to specify the shared pages as
> > small pages only, the worst thing is that a 2M shared folio cannot be split, and
> > more memory is consumed.
> > 
> > Of couse, memory fragmentation is still an issue as the private pages are
> > allocated unmovable.
> 
> Yes, and that you will never ever get a "THP" back when there was a
> conversion from private->shared of a single page that split the THP and
> discarded that page.
Yes, unless we still keep that page in page cache, which would consume even more
memory.
 
>  But do you think it's a good simpler start before in-place
> > conversion is ready?
> 
> There was a discussion on that on the bi-weekly upstream meeting on February
> the 6. The recording has more details, I summarized it as
> 
> "David: Probably a good idea to focus on the long-term use case where we
> have in-place conversion support, and only allow truncation in hugepage
> (e.g., 2 MiB) size; conversion shared<->private could still be done on 4 KiB
> granularity as for hugetlb."
Will check and study it. Thanks for directing me to the history.

> In general, I think our time is better spent working on the real deal than
> on interim solutions that should not be called "THP support".
I see. Thanks for the explanation!

