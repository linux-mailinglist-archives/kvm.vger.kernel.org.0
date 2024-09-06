Return-Path: <kvm+bounces-26045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A57B296FE7C
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 01:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3FCE1C2237F
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8845815B54F;
	Fri,  6 Sep 2024 23:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z6z9mtdo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F312E659;
	Fri,  6 Sep 2024 23:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725665499; cv=fail; b=dH+LGFwD9CD/M8j5HpCexYQPwCtZiW6vdK1OLNnNJVY8ToEqKbP6qpoWA3D8FTU0L+19YsDSOVGKlmWDut/oNMRfXj1TGb0vBWOY3r8IiKDBSmvGbCYWGaGN+NfaoW8Alkr7arKe5w3ahU5l3Hv6TNYiBFACPZwSirFbukSNBBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725665499; c=relaxed/simple;
	bh=iUklUbq+5cpFNg7h8mk18rmWtqYXTBy4y5WLo3k0x4s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rhWNaqQ5t/+rND/xJn/hHm2qeIazduqGfWT8dHAvdaNfAlnp5x7QVT3jmzfU8p/9tuDuAU3a52OLHqAGQRRfa8aLMHhnwgcjITKL1nuKQzd80zUR9tDg1CCtBjtmLvhEyiZ412rJ3daYi0fijixD12x7suRMaaCcJVw8Vdt7BPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z6z9mtdo; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725665498; x=1757201498;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iUklUbq+5cpFNg7h8mk18rmWtqYXTBy4y5WLo3k0x4s=;
  b=Z6z9mtdo1E71UWAPML3Z2vctNgjApkrgoaAVwyMwk4oPKj4my6kDMVGk
   tTOKT84d0I65mrg9ILDtjZlTeUc2wIrYyid+xgd5Zc+xGj1MZZV3hnc/e
   sx+wkrPyL0PhHMhGEEh5hYSvSyPtkqEvMTLlLwHOzmPTMbLUvG/LVfY3w
   ZuHAN3Gxkyen0DSfCfODLs8oMpPtQ1E3IRgRi4X2poYP+qDSElIM/6QAk
   /v40X21zLYPXw4CYsDEvIc4wsFcEiGefKAP6RnTZsiXq7PE7uDclmJJhj
   3qiqYVX/g7FeuNnWjCvh5S9yAz1hvk+HC3adF7Jq0RuDXv4X7gELFDRnI
   w==;
X-CSE-ConnectionGUID: MTRngUw9RF+8mCbvSoiFOw==
X-CSE-MsgGUID: VbIXHX6WQQqh8VYm9SXC7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="28319684"
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="28319684"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 16:31:37 -0700
X-CSE-ConnectionGUID: e1nritSMSqu8xTovoDgISw==
X-CSE-MsgGUID: wD/AY1sVRF+j0X38x0CvNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="66078815"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 16:31:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 16:31:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 16:31:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 16:31:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 16:31:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSBFBYuiPWiAAtV+b4cHpYiPt54GhBP2CanelrwbLtUcNYQ7irIT2sLYlX/eOF71082VAjSAPLtSkX3/P1mOvnkUd2mTdZhT+/Hc2ySekMVxgK+rWsgiMRFmIbbBVicRVgfI+7P7daUn72zon9daXEy9a0DXe2NTilQxa+pevG81qDuzziS27BexMlbUqN2CSxPdtIajO7u75dQHbQoGD7P1HCMwS3FjQgoWFwfn5gQJ5nuKOlCD7eYWwR7LQ1cGb4R0Z4Rs6M1+69ZbzrbZLuDG8GtV+A9dT8W5LUR2O+o4cTacWhvcorTS4wAn+2kUszNi5CIW9p288sf+sQ2CCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4WUAdcdZK2hVeEStcKaiPpcaEdWgJXqE6XC7zDVcX4=;
 b=UWUdIjsLebgWPqDibm010Y8Wjhlha+YUsr4n+2eWCR6Qy6qYzsqIlyecHEDIjwM/WNsQz665X3Sz1IpUuSvcuLpwVAyJCPkcd9WxYCnORNZ2UMMYySHdcScujpyS5xDLsOvqgFS93xfgd3yS51rGbg+s24ODXRUmQpb+66313qP60VWELmlnErrtGbzw7HgySSoiHf55lux1gK4yyxW5j2f1gR19Vw/UUPhWzg3XkGjJ5tHu6lDwnNalke8WlVGa62qQsqbg6DWfcahi8VuZOWXXBp86zRHGkI5M0UUC16lvy0kWlTUQ5jvXNbT2TsTyyETJry5hxCfVFh/fhHNg7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB8576.namprd11.prod.outlook.com (2603:10b6:806:3b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Fri, 6 Sep
 2024 23:31:33 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 23:31:33 +0000
Date: Fri, 6 Sep 2024 16:31:30 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <adrian.hunter@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Message-ID: <66db90d269408_22a22948c@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0137.namprd04.prod.outlook.com
 (2603:10b6:303:84::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB8576:EE_
X-MS-Office365-Filtering-Correlation-Id: 86339a9e-cc5c-4dd9-3369-08dccecc0b09
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xL7FTjfnj7J/5t9kqrTfuaMmnsEejKP1GD+rxmhgXVkc9jK3dRMiRcOfO+/E?=
 =?us-ascii?Q?BfkOVjhgKg2j6pu8zcOY2FbKIQr6b3EsBvmtM5DtQvxhZo08JqKi8tbRBWDW?=
 =?us-ascii?Q?OSxjh9YYqkStS7Cz76WP0XzHpIVANxaL8HVbxwc7SWyKpswgJ5D9b2LmfTK5?=
 =?us-ascii?Q?8KRnKT8reeHjZE3mQnvHhx+9bFW8cVpUM6hEAhTYtZjSTNxzkQM+UTCYKK1T?=
 =?us-ascii?Q?Ej8+Q2pzryicdzK8PuvzTIdhfQZ46AsMgQKiuUnzTA/xV5lMy8XyC6WoyEQW?=
 =?us-ascii?Q?FL2qdcXB604PDy8WWdsSaRMJ1bvqQLvvNMzV1gehwy0HB+NYUd+/4lFqtbJ2?=
 =?us-ascii?Q?/RRKLVfcCezLd/pgSWDvAdUiCXzpkN0+pa92Z5emDh95n6J65/ooV/ysv57B?=
 =?us-ascii?Q?Mwhr9gp2Kq2b/DmfvnnPqoEQlfaSocm7VfM1wna1HY3VFDo9lg5FvexItZgu?=
 =?us-ascii?Q?jWPwCxBttQ2jwTyP3e6xImL9culfi5K71FYvVDZnVu3Nh1j8rd94lyRMBYB2?=
 =?us-ascii?Q?WBGFYwJwLvGRsg8e2rf83tnHV7fgGS+R+YW76AdolrdNChWuJ7Dz842pB6+U?=
 =?us-ascii?Q?6HLpkN/PXkiDVSfBSc+Ty5YsOoppyl+OHUDeAj6rKsWLOPL17cCAo5/9aZaq?=
 =?us-ascii?Q?9GUK2hcg3PEcaF+MqWeNKNTeOifW0TMD5Gpog1jGgP/vi/hCjP+D9oic+Uwk?=
 =?us-ascii?Q?jprLaS+Ne2f9rBvP/eO5qBpnO5RSPe9dOKl5ctUljXKxB/eJsaD7FVwfhmQ0?=
 =?us-ascii?Q?CWPfYU0gnkeFEqp3zJyUgHmM8GT7/ktKwIycKusF9iXN7n9U8zL2YlXPpnFm?=
 =?us-ascii?Q?DBv6LPYzXRy7X4+cRIrjaPblXRtfTqGCFkYZ9j10mURpAml8/vY/CElrDZ6B?=
 =?us-ascii?Q?eP9IXfzd59d5mPazL6yeELwyhdbVPTdsLiFj3Lqp8jGL+P70o2GE7RgyzmqT?=
 =?us-ascii?Q?upERx/pmiAYX8GkBvPCwgT0a5acVJn2m+P6EjUkbpl7QzFbq90CAXRQhLE/3?=
 =?us-ascii?Q?tPOSMhv9es5geIwhBqr8I4s2KSsb8790rW/zQ7j0Fwf7Ug1MrPBgeUF0lzvH?=
 =?us-ascii?Q?NCHuC2YJPcXAvmqEeOYIjbdCBPWqmN3mhtumpJMQINs8L2QBDIwctMCjeFDe?=
 =?us-ascii?Q?ujDdaSg1i4j45SZxX1LNMIDDxMRsP5VjRHb4hsns16MU2w3OqqgfKpiUlBCB?=
 =?us-ascii?Q?hSYAEhruTJXXifgAMPoviWVs2goPm+ySImY/rMl1Bod0U+822YAfwNwGtONc?=
 =?us-ascii?Q?o3NzFr2Wk3OtsBoznhkMf+/ZWJLiJ59Z/b01ja0WFNggYQYa9FJbtburHibE?=
 =?us-ascii?Q?gql8yFahTp/AkcGFBJNNq36mgVgk1UotJyNwGfuxSTUKxN0AXefSEnQHRw17?=
 =?us-ascii?Q?6aPu+Y1GbUkXNKU7uJ9Rkuvzp6A6?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bKuDUtA5CP6yWr6p+7xNHPL8B132sA1uek9J1hlxjbW4BjO5R7vG3LsjsDEj?=
 =?us-ascii?Q?5LPQsatpoi96EE46ZGBl33YtAP2GaZEoDVm87RDXm7B+lgwSxvUpefbPvRiB?=
 =?us-ascii?Q?8i0ecEqYSRFaNKPggE+xDX2L28dDEA10jruClFvx+EWyO7ZszX2a6qbAAuMN?=
 =?us-ascii?Q?Z5IVu6kpJAW2+u2PwpgxFmiCdg947exkwlNRA4hJHmLUci4lxxerold3ZGHR?=
 =?us-ascii?Q?xerBknjH90+uLGjCfDUekHFKcd+asZiDhYmVk3WuzxaFMT+gqBAIw3jydL/e?=
 =?us-ascii?Q?GMQQzQYVAyyfMNGdXXcaz87reHqszgFpU/ZBBA/tlMOXrKjyY8WXHw1WKeIw?=
 =?us-ascii?Q?n2cS1WyZ3Yv87htVIGIasggE6DuAJ4b/j78DVVx+W5n7GCH46JmFSX0puQW1?=
 =?us-ascii?Q?w/Q0m+hCGFnOF+HMp2Cs66V3AfxYMa+JOX9m6t8o5x4+/u6fVd6aXVgfN7QX?=
 =?us-ascii?Q?lJlZZ+rhPO4cAcn3NPMcvnrnRtgkLT/SwGmpxRKdhrGSMdnefl8IG5/k1RJH?=
 =?us-ascii?Q?o4+2YMsKsPwAEeFZP9WWJQ5FIDDGT7DqiHZhlM9LNC/Wy8NUd5dR27LQdhQs?=
 =?us-ascii?Q?526PpOu1QSm/qvWek/Z4+bdCEMkVMWqtrhgZz+ImgOleOq/K6n1o3ta8dc0r?=
 =?us-ascii?Q?txwlLmAEXqJeADZIfpDj1vv74SC9wVwmBv6ndM8peGemw7p8mxaUxf2d7UQJ?=
 =?us-ascii?Q?pQDQRStPwZ9is1jKQt+PllG0qYRb4U+lg48rKsyLnVEtIeZOMgRxSA49RWop?=
 =?us-ascii?Q?+vWSiX8jjfvQuLCO7kGoh09HotxQU1hIyotXnpBY+DzAU5I8LV2aBu5NiTB7?=
 =?us-ascii?Q?+m6qlYsDp/4rxZoBK3ce8UEqyeIAWVV+J3u3lCR2+WDJmy6Dfe+6QnOru/DK?=
 =?us-ascii?Q?YzwgzVJ7HC0vrt4/6K1m0aNXK4RIQhKwPl+WNJkEQresvNf1D+c/wexw4Xxv?=
 =?us-ascii?Q?d0nysqy2AICL+ckrxAa58wRf431j7kSADuifC4lEjHjfNcDX9NI3AUg/aQKK?=
 =?us-ascii?Q?F5+r/y0q+aTebsYBlgNs/6cLwEHnn6BTPKv19V/J+bQIqd/hV6HKV61oLodB?=
 =?us-ascii?Q?wC2BWanZGAw6PDBX5KQl7napFXz+iSyhubrP2TKZvp/oeUN3+4SGJfc60T2l?=
 =?us-ascii?Q?PSU46KG3VHNq5uXUJ4MZIXzkH9+gewDKilaZa+M/mn53ZWNt0leB+SOCz93s?=
 =?us-ascii?Q?CY3Bsz0kehVENJPMqmwiqxauwzfAbahcgjai7osjKRwXaRfOIios0nk5tbnP?=
 =?us-ascii?Q?+XugmfMNRa5/S7jwoqTecC87/Tmd1ksmKXiaOu/RNfBnRfYj39R1HPLk3JqQ?=
 =?us-ascii?Q?OoNI3zXrPBuf7iGoAWJqE2VOxsheYJ/dPJr6r48+d0Y4rXmRa/t5IaieVAXC?=
 =?us-ascii?Q?v/9kGUYFdGa/FkqPcakvEtDR5IuvzafJmpS8eTeC/DJmIGLVuf1A97gSey8g?=
 =?us-ascii?Q?mxVj99JGqWbb1ycv3QGe6ck6jR/h9ZQx2gq7dxeq74WspMX8944cnPLHC48a?=
 =?us-ascii?Q?zPa/InhcRVroRUQPyzD00cQbQTlzSGaFu587Wdz/xBQwCsxMbdMUzIici97S?=
 =?us-ascii?Q?G7Grmokn59qqEr7Z0+7K8f3wtyrYl5LomxNRvTEkwAyJqO15KlA+cZQ3t8GE?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86339a9e-cc5c-4dd9-3369-08dccecc0b09
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 23:31:33.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9IUdm0q9UiLKMXYFtejp4ncuTtkRFPRIMcTfNgNJBYWNsd0dlv4Ay6LS6OTIaaeLKwwdtNIzkp5ap9idYpC7YyD3BTxTyxfWONChxMyTbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8576
X-OriginatorOrg: intel.com

Kai Huang wrote:
> A TDX module initialization failure was reported on a Emerald Rapids
> platform:
> 
>   virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
>   virt/tdx: module initialization failed (-28)
> 
[..]

I feel what I trimmed above is a lot of text just to say:

    "build_tdx_memlist() tries to fulfill the TDX module requirement it be
    told about holes in the TDMR space <insert pointer / reference to
    requirement>. It turns out that the kernel's view of memory holes is too
    fine grained and sometimes exceeds the number of holes (16) that the TDX
    module can track per TDMR <insert problematic memory map>. Thankfully
    the module also lists memory that is potentially convertible in a list
    of CMRs. That coarser grained CMR list tends to track usable memory in
    the memory map even if it might be reserved for host usage like 'ACPI
    data'. Use that list to relax what the kernel considers unusable
    memory. If it falls in a CMR no need to instantiate a hole, and rely on
    the fact that kernel will keep what it considers 'reserved' out of the
    page allocator."

...but don't spin the patch just to make the changelog more concise. It
took me reading a few times to pull out those salient details, that is,
if I understood it correctly?

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 0fb673dd43ed..fa335ab1ae92 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -331,6 +331,72 @@ static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version
>  	return ret;
>  }
>  
> +/* Update the @sysinfo_cmr->num_cmrs to trim tail empty CMRs */
> +static void trim_empty_tail_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
> +{
> +	int i;
> +
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
> +		u64 cmr_base = sysinfo_cmr->cmr_base[i];
> +		u64 cmr_size = sysinfo_cmr->cmr_size[i];
> +
> +		if (!cmr_size) {
> +			WARN_ON_ONCE(cmr_base);
> +			break;
> +		}
> +
> +		/* TDX architecture: CMR must be 4KB aligned */
> +		WARN_ON_ONCE(!PAGE_ALIGNED(cmr_base) ||
> +				!PAGE_ALIGNED(cmr_size));

Is it really required to let the TDX module taint and possibly crash the
kernel if it provides misaligned CMRs? Shouldn't these be validated
early and just turn off TDX support if the TDX module is this broken?

