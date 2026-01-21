Return-Path: <kvm+bounces-68775-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FX4KsQ3cWnKfQAAu9opvQ
	(envelope-from <kvm+bounces-68775-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:32:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1D15D476
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 94705A861B4
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 20:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A444D3E95BD;
	Wed, 21 Jan 2026 20:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QPu16ruy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA71F346A15;
	Wed, 21 Jan 2026 20:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769026831; cv=fail; b=HDw4s72a3+grKql35yi/kZG4o4gOLGGdA9VCrUTioyQ4vQLFCTyuSzUHHoSHlSft9Nxw5lSb/Jx2cnuk8xZLXWm/+TqAZW6N8bPtTN7IJFZY4CPEBNkfmxyZGxo7Lz0xFEN3s5L1C/dxMw0y97yDCMi9e/DoIUJi+Rj/bDn6uxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769026831; c=relaxed/simple;
	bh=FyXlcN6dlbomCWgVtWIaReRCMtUlDWFSIdWJvnjeqwc=;
	h=From:Date:To:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=S99V8py9bp4GMnG5upkLCrgfqLne2HH9VMNsHWFgwhfamcjC+DpC5Ou6IHXU7QzwiV7NZsmIMEY6aOBeD8BXwIRffS2ekUhUDz11tpskRCPC4uMkKcTi5qbuVMbqRaMNZkt7ajeRlZVLQPf9e8pwuNIvY1PlD1LPgO3+0+a+77g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QPu16ruy; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769026829; x=1800562829;
  h=from:date:to:message-id:in-reply-to:references:subject:
   content-transfer-encoding:mime-version;
  bh=FyXlcN6dlbomCWgVtWIaReRCMtUlDWFSIdWJvnjeqwc=;
  b=QPu16ruyaHUdF7dPDgDWq0vqANubiwKk3gQljOa6Y9PzeI7eYACUE8Wg
   PDJ7At6WrgCIODBW3s71j7+nY49vSHhbNR36fz0u0ARt60ODztsivFCK7
   HhE/i6sEWb05r6y2Sb8fV7bBMR4YkLttzyh86pb3vxA5pcb7QxmuwcI33
   VeSFN4zhDcTUnMH8ArdqANN4hm4wPV6pIGasadMtE+jerqMMPsrxXSecg
   DcQ3YdjoZX4A2r+2ywlaCRFfM3QcWyq7qAMl3vT1KTvyTPHU2+66X9ZSp
   Ay2GXqlE0UUK/mqnFXEGf1R9Y9PKSQ4YUOW1ZpIA+vzwVqVYjMcc3Jhzk
   w==;
X-CSE-ConnectionGUID: +a2/CIZ2QAOl2wzPV77h/Q==
X-CSE-MsgGUID: 4/2J+c5hTP6gJx3DnnsZvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70429053"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="70429053"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 12:20:28 -0800
X-CSE-ConnectionGUID: ZR3R41GUR+OrFg/1Aqsphw==
X-CSE-MsgGUID: cbkDN/z6RXq7ssj4Da++4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="210699295"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 12:20:28 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 12:20:27 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 12:20:27 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 12:20:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vZM1UT2LgXKAD4Huvz86xceVsGIKWATnOeRoXTABLkDGbwz5ZoTboYcYMWWEywd3OFjAc3F3dLBHc4lJQQjPtK74BLkymjMpLAl3q+gh9OIlf5n1s2R9B1EJi6f7WrJG1unvYiH1tMeZ9VVT41nE+XsgfN9mMO6HVv5TBRQI1sLPH/agEJE9q41T5xxPzC5WrOT66GXvSjOJcIgoxUijUFgUOUJFeHVnq3iZfX6gMI4U7cDyeLdxwV/fi+P2mJIrRqOmSBcsLc/khkN0XJx1fxtb1sdozfN3rPQktsdIJGlZj4MGIhO/PbVj0Xb8d+lun1/Qy13PnpacnooqHU3FGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/GEqsbnOQpISapF/WSBR8tOZsfN3JpuQJSwZp2LxpY=;
 b=Qp2gZOTEDXuU9TKKQWtwYysW2MMzERthw9TVy3HTiUPD0r4nEYs3ai4p2KpYk0vlhovtgFkpcGBY22F3HMVBqzUuKRpTr63u/IS8bzRcXt7UHUt7ATHmRLT/28Ye3Uw13npcHc5ZxFVKBpGgCHaNu3JEb+6UluC/uobnQNm3tCyyvqzexnoYJFFpIza8Dv4ecs/exmLMxcZ3w94lLTqOBsDDRvGqOpw2a1ODyMUJSIC8Fg6EsiuZTCut0FfUS+hP6Yg/ivcUBe+Z9dfJyXG9CObfRmZU44KSS/CTI1SR43ofJucZEDg/fV6+tWkeDoAs9eQiauXOOR7ZkmDDnIRuBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB8248.namprd11.prod.outlook.com (2603:10b6:208:447::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 20:20:24 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 20:20:24 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 21 Jan 2026 12:20:22 -0800
To: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, =?UTF-8?B?SWxwbyBKw6RydmluZW4=?=
	<ilpo.jarvinen@linux.intel.com>, Alex Williamson <alex@shazbot.org>,
	<jgross@suse.com>, <sstabellini@kernel.org>, <oleksandr_tyshchenko@epam.com>
Message-ID: <697135069627e_309510030@dwillia2-mobl4.notmuch>
In-Reply-To: <BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
References: <BN0PR08MB695171D3AB759C65B6438B5D838DA@BN0PR08MB6951.namprd08.prod.outlook.com>
Subject: Re: [PATCH v2] vfio/pci: Lock upstream bridge for 
 vfio_pci_core_disable()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: a3a5c0a7-ba9b-4771-fe57-08de592a8217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Szc4OHBvTWlSZ0d4OGtDbUgvQUF1VmM4M1FPWHVGS3diR3pWSHViZmVCb3o0?=
 =?utf-8?B?RjB1M1QrekRNM29vV1FaNjUrSWJYUUVXb0hQVWlpbUgvdlF0bXh1N0Q5dzV3?=
 =?utf-8?B?eUVmbGp2dFNpdDdXandiVFFjK1A3YmFKcnBmMGk4UFdMRzRvak81UHVqZjNk?=
 =?utf-8?B?dWczSUU5dFEzWXRqWGdKZ2VBRWk3MDNOek9PZEx4MW5HM2J0YlczckFPQVlx?=
 =?utf-8?B?dEhLWVI2WG94MTA3SXN1TUF1N1E2c3Y4OHdtdHc1OEpCVFhjV1dKZVVrbVps?=
 =?utf-8?B?ckVhZ3FleGl0OHdnTGtJTHlXMVBYazZabENnWGhXWWxMK0JndjFiaHVldHFz?=
 =?utf-8?B?MWF2K1lleFZHQm5oNy9HVEZXT3A3MUZjUHpNRnRodmtHTUxpQmwvQ1FHcWIw?=
 =?utf-8?B?bUo3V3Nsc01Qa3JwMGdxSEZ2dTZBdHJkZ1Q1ZjkzdktQUVUyZkt3VnhMU3hB?=
 =?utf-8?B?aDVSLzh2VTdiVlUxaVdqYW15QTZnUXJCL25oZ0M3WEp5dXpwZzlkN1pTaWh3?=
 =?utf-8?B?MlhYcnVaWHROQ0I5T3pwYzl0NWdXREcvdmFXYkE3eitjM012TjNZVEVhRzZ2?=
 =?utf-8?B?dWMxcGN1MUI4UU1jYXZiS2lqVnRyK3RZUE9BZWtZdFh3VTg4NG1QUG12dHg0?=
 =?utf-8?B?MXFGajZIeHBlNFFSSTRyMjRUZGdzNmJOay9IYVFLYXBEOFl3aXgxS0FVL2xN?=
 =?utf-8?B?UUdSYUlUYjRndjJLK0dldm0zZHBMZmlGQUdObEVWTDE5RUp5bitJc2VCOVZI?=
 =?utf-8?B?QWh2ZkVsMng1U0owZGpIdVJRbW9vdHlVbFNCd0wwZzE5dktqVExJbGk0VFl5?=
 =?utf-8?B?WjkvaEpnY2wyd3daQ0ZwWXhxbi9zNitmUjFkcVdqNzNPaXZLSUgzdTZ6OFVS?=
 =?utf-8?B?M0Vxb0VJT3ZsL2x5Z3QxYkl0LzNQaHlLVXhRU1NnNDQxeklNMG56ejZrSWpo?=
 =?utf-8?B?TElNeUhVbUxzay9EVHRMeGZ6QTh6dEtpVVlsNjBLMnlPWndTdC9hZ081SFNm?=
 =?utf-8?B?bEp5MDhkblVjdng5U0UyLzdFU3pEYWk5RGxaMHNiR0xybnpyRHN2akplVkRD?=
 =?utf-8?B?TzhFV2ZiR1JTK3o5WFJ1QzdTR1hOQlJSdlhPZ1paZHRLOVhwOVRtUkxYYy9i?=
 =?utf-8?B?YnRGc0FNQU1oRXR2LzlsbGlVYytnL1dRdWNGOXpUWmdBZTBlUzlDcEY5UTNC?=
 =?utf-8?B?NTEwQVFoWmlya2N5SmRkR3dtb0l3NFZtMzFxM29KYW92dzRCTUM3VVR0ZDho?=
 =?utf-8?B?NFUrWGwxT3NPOUhUYkpWT0d3c2JlUjJ2UmVRZkVtdGxlUHp5NStrSllqbngv?=
 =?utf-8?B?MVNJcGF6Q0ZRamF2NUg2OXN5Q1BXbFhXb1EvcmZxcXNKeWpieWtrN0wwSjJh?=
 =?utf-8?B?MEY5L0QzTS9wTHhla0VMcFc2RWJmVHU5Y1haZnloWUZ1QXkwRUloaUR2eXo4?=
 =?utf-8?B?WUlQQ0I3M2RabGQzbHp6eEtXQ3NNTlhyMksvTXRPNXJveHZVdHFOVUR2cXh0?=
 =?utf-8?B?VWxQbU1KWGVDbGYxaWxBMDlPdHJoUmc4Ujc1cHNhZ2laZHVaVTd6ckR5eVFI?=
 =?utf-8?B?N2pUc0lMYW9VbjRTdi9VZ0JaYTFyc28xSEwxWlBSU1N5aHFvU3VIK0ozTzZ3?=
 =?utf-8?B?TGNUVXBYVXlmbTRZR3J4eTYvNEV2THdYZ1JQbTlVMXpEeWhSb2ZyNkpTbzRR?=
 =?utf-8?B?RVFhTW41elhRUVRUbEgxc3E3TmE1WUR3MStjQ3FCUWhQcmcyUUtHckRNaXdL?=
 =?utf-8?B?eFYzSjVGRW84N0I0cUU4cVpZUXVqTXhHVXJROHV0RlgvaUFoUlR5a1NZSjNE?=
 =?utf-8?B?YkRabi9FdCtUbVZTNkNkaWdpWDdPWDdsdEFOak5xWFB6SFFUTXpWVExQcXVB?=
 =?utf-8?B?QzdsbHV5azRIWm0vRlBpVlN4b2Mxc0xTdGVFL2JxUmVMUG41SGtFZGpyTHBV?=
 =?utf-8?B?SnQrM3ZBQUhzbFVVbG1MNllKSVhGUHlwTW9ZazJuS0NkTUVteWdXNHRDZStY?=
 =?utf-8?B?UXJkc0ZiWVFDYVc2d2pnNHB5SEJBNDI5TUJjZnZtUzBrLzgvZkV3RmVyWHZw?=
 =?utf-8?B?M05QWGxqdjdnakFCZFY2aVVjSVBaeGR5TDc0Sis1dnYrYy9TdXA4NlNoWDZG?=
 =?utf-8?Q?7S8o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFdFMmVUMDV3dGE1UUZMWGtKajRseWlwTjVtZDVPUFJRTkhld053U0FmYmh1?=
 =?utf-8?B?Q0xQNXVYY2hyZU1RbHVaSFZ4WWo4Wjltbm4yd3NTQmJNcExrdnFydWc0UFhw?=
 =?utf-8?B?TGtYRkVwSXhnczBqSWlmckE3b2ZYYXJLSnFiSnVRMHNKRjhpQktpcVpiYkQz?=
 =?utf-8?B?bDc5Wi9TeEI1TW0vVGNJYXZCM05nQk9lazZXV3dJMUk5N05ydUxYTmYrc0My?=
 =?utf-8?B?WStUanV4NjJUOTZzOS9zMDIvS0wzQm1rNThTMG9aaEJqbzBMY1owM0dQTFlS?=
 =?utf-8?B?NGFpNlh4S2pYdjZHRWJPdWdiK1FTZWg4Vk1NWjZqWE4zT2FTV1dLK0pSSWtP?=
 =?utf-8?B?ZFJkYWpYaVJHSnpNcWZYdUVpRVIralB0azkvRHVKR1RTNEZFUm5qSmtwOFZ5?=
 =?utf-8?B?YW9jeStYUzJ4M01oSWhlWlZoOGgrYWViRy90Y0VkT1JOR1JZZTc5eGR4M0JE?=
 =?utf-8?B?OFNla1E4TXJsdHcyNVpIMG1VdlIxKzAwL1A3azh2MTZ2WWhVR3VkMERvTHhm?=
 =?utf-8?B?N3ZOZWd6dHJkNjVDR1Uvd0FRQzhraVI3UFFtVUg5Q2hvTk5BbWZiZ0hQVllB?=
 =?utf-8?B?ZUhWUGZXY3U1N3JDdEtGazFQMXlFZ3h4aWErVnQwU2hRRDROVWFHVDN5Z21P?=
 =?utf-8?B?VW9YN0NybHU1ZEVLSnFYOEpVWWtCdit4SHlaejI5TDJRWWJEQWo3N1NmMTk4?=
 =?utf-8?B?cXo1Mk9GRWttaytmZktqdUVvbnNLUkxkemlXeFd5TXZ4aDdQRFBEWG9hMkVz?=
 =?utf-8?B?VWZNTUxFbEE3TmJxWTM3cmdKT1REOENCQi9mY0tHd3VmRWV3SFp5Si92NmJE?=
 =?utf-8?B?dmFQaCtpMlphQThINDNmdjUrWTNQcTdXYnJUM3NkbXFRd0QyTVlhMDdMUU1G?=
 =?utf-8?B?OU5uSkIxMHIzWWxKZWYxOGljOVlFcnllT1BTK1BaalVNSEo4b0RUQ1dWaEdB?=
 =?utf-8?B?SmNVdGJMSTNZM1NKTGVmU2dxQkFLQ0EvbDBvWVpiaXMxRGQyQWNGUUZyc2Z6?=
 =?utf-8?B?WFhpTlhZOEl4Y1ptQTVWSGFGT2hnNDMxU25DUEJRaHN3d2VTZkNwc2FJbkNj?=
 =?utf-8?B?eWI3TW5aQVZGcGRwcEpURWhsZTQ2dUZqbE5RTVNyREdMUXl4RURuQmplQ0VF?=
 =?utf-8?B?VE45cmRDbVhxNHZWZ2I3YW4zUFJKKzVKTTU1V3JBd0s4eERBeXdmVlZaZVZw?=
 =?utf-8?B?RjRaWU1Ba0ZIa1A1R2g1N1RDaUovMktUMGdFNDBjb2dnUVZpU3A3Tk9vK3Jr?=
 =?utf-8?B?WjM0WWFLRmxKVHJvdWhYbTdja3ZpdmtBVmxMNDdSOHAwdFlzQXhJakplTm1G?=
 =?utf-8?B?K3g4M0VmUXlCbkJLeTN3KzZ4RmF5WHkwNEJNMmNEd2l5bkQrbkx4K0xRU09a?=
 =?utf-8?B?a2lETlFZQXEySklnYWRZMHpQbVRvL09jb1VlWVRmbkZjVVVNTmdVNFNyaDI2?=
 =?utf-8?B?NUZEY01wVDM0VDRZMkpscVU5RHB3SUk3UFV5eGR2dFRMM3VpK1IzbVJ3MHQ2?=
 =?utf-8?B?eU1mcTV6WGlUSzBHWC9icDhCSGlJUU9iUm9kRjBYRWNoenBVb1U3UjM1ZzJp?=
 =?utf-8?B?d1JTTUtpTzdBR2RrcUxRT0ZtZ3RJaHFqc3ZYa0ZGVC9WNWVTRlpBYmtid3FZ?=
 =?utf-8?B?OWZTbWZMYXBLTTJaZDFSVWlmbk90bXNuWVVRY1V2Zm42dnJFTzZiK2V6cjJw?=
 =?utf-8?B?czhSa296SDR3RTdmZk4vRUJpT1lqb2ZoL2IyY002eHFKQThUanJVU3dROTBl?=
 =?utf-8?B?V1pTY1gzSGswL2gybjh6a3B3UEt2aHpyZWlvaVI1c0ROVGNzVGdkMXMrMWF0?=
 =?utf-8?B?UjNqVnJhR1F5YngvWG1NQkxzTmpVMzBuMkQycVpyTnZ5WFg1SXBuTHVvUktn?=
 =?utf-8?B?VXYvYi9xaFdwYzE2WkVRK0lIN3J4aGZJVTU0OG85V01CeFVMcTVta2c2ZElS?=
 =?utf-8?B?Mkw0MXcxMFlqODl2THp3MDRud1BOdExaMi9iQ1VCbnlOTG96bzBXWG5SOXVO?=
 =?utf-8?B?Q2tHZ0Qva2ZNTVd3dzZoMU8rYkhqS3ZoQjhxaTRxVW1MVy9Tai9saGVtb0Rt?=
 =?utf-8?B?K0d5dDRTVnNXTTVYdktnZzd3TWdyUGpIdEo3elBLRUNVZXFvNFBweEVFNStI?=
 =?utf-8?B?RWVFL2hOZjhQOGdpci92M2RTU1Vwd2NWdzFpQU1LVkV2bWNRRW1tTk1vOXZF?=
 =?utf-8?B?VmFwZlllbWx0UmtsT3ZNT0tOS0wyaDRvUHVRQkVEbkZKWlNKb0lwZ2xEdzFm?=
 =?utf-8?B?ekdJYTFSY0hBTStXMEdmNmc2VmJod3QzTjR5cXRJbW1GM3NDVWVFY0NrUGt4?=
 =?utf-8?B?RHpleWp0a01IQmlSM05Ta2R2Rmp3RXBhRXJCTUkwYWRUZlVJKzZtc2U5OU9K?=
 =?utf-8?Q?NrpJwTW4J/OUCsOU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a5c0a7-ba9b-4771-fe57-08de592a8217
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 20:20:24.0478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+lX7kS7Qqny8VdivGuFWfwagU5Ne85f2TPNsV+Dxr6aSEgoMHxzqh32+KzonEmxXJVdtm3hWmlL0LozGeI7K0tjCTJIlhGJurXv85zTwjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8248
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	TAGGED_FROM(0.00)[bounces-68775-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,intel.com:dkim,dwillia2-mobl4.notmuch:mid];
	MISSING_XM_UA(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 0C1D15D476
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Anthony Pighin (Nokia) wrote:
> The commit 7e89efc6e9e4 ("Lock upstream bridge for pci_reset_function()")
> added locking of the upstream bridge to the reset function. To catch
> paths that are not properly locked, the commit 920f6468924f ("Warn on
> missing cfg_access_lock during secondary bus reset") added a warning
> if the PCI configuration space was not locked during a secondary bus reset
> request.
> 
> When a VFIO PCI device is released from userspace ownership, an attempt
> to reset the PCI device function may be made. If so, and the upstream bridge
> is not locked, the release request results in a warning:
> 
>    pcieport 0000:00:00.0: unlocked secondary bus reset via:
>    pci_reset_bus_function+0x188/0x1b8
> 
> Add missing upstream bridge locking to vfio_pci_core_disable().
> 
> Fixes: 7e89efc6e9e4 ("PCI: Lock upstream bridge for pci_reset_function()")
> Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
> ---
> V1 -> V2:
>   - Reworked commit log for clarity
>   - Corrected indentation
>   - Added a Fixes: tag
> 
> 
>  drivers/vfio/pci/vfio_pci_core.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f7..72c33b399800 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -588,6 +588,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>  
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  {
> +	struct pci_dev *bridge;
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_dummy_resource *dummy_res, *tmp;
>  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> @@ -694,12 +695,20 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 * We can not use the "try" reset interface here, which will
>  	 * overwrite the previously restored configuration information.
>  	 */
> -	if (vdev->reset_works && pci_dev_trylock(pdev)) {
> -		if (!__pci_reset_function_locked(pdev))
> -			vdev->needs_reset = false;
> -		pci_dev_unlock(pdev);
> +	if (vdev->reset_works) {
> +		bridge = pci_upstream_bridge(pdev);
> +		if (bridge && !pci_dev_trylock(bridge))
> +			goto out_restore_state;
> +		if (pci_dev_trylock(pdev)) {
> +			if (!__pci_reset_function_locked(pdev))
> +				vdev->needs_reset = false;
> +			pci_dev_unlock(pdev);
> +		}
> +		if (bridge)
> +			pci_dev_unlock(bridge);

This looks ok, but a bit unfortunate that it duplicates what
mlxsw_pci_reset_at_pci_disable() is also open coding. It leaves Octeon
(orphaned) and Xen to rediscover the same bug. At a minimum I copied the Xen
folks for their awareness, but it feels like __pci_reset_function_locked()
really is no longer suitable to be exported to drivers with this new locking
requirement. It wants a wrapper that contains this detail.

