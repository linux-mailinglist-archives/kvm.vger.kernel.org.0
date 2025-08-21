Return-Path: <kvm+bounces-55342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C13C6B302FE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 582507B78EC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 19:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A2734DCD9;
	Thu, 21 Aug 2025 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HiWK7e1K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0701E34AAEA;
	Thu, 21 Aug 2025 19:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755804927; cv=fail; b=BiWNSoPJ5jUgK53W1ooZfs4dDuNnuT64LsP32lrJNNYdsSYmg+45FTPl2yNmUzQ4LoTHHoe4i8q1t92Wmd/GIw4DVnD81LldiTp4svOgyOZNE0EbtIDhbzpTsGS3XoMi+oQschNGaIvPr0x2/d6XR66Ctm42mD/GadOXDyRU1CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755804927; c=relaxed/simple;
	bh=3MCKTBlw/nn/H1B0V6kPgyxYjXaoT1IUd9NZGODEVZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DVuAFphfVxK3zB8kMzhJ1HDyHCVUJI6hFA1nGIk/74I1plM8+/iwGyoTm6XaNR0OOTKeL8eIBygut/ICf5VbFyDRZnSwYWtbo+o5WXLAg/81tZlK6wmfR01DySvX9Du5DoxGvKCkIpqk2xFxLQiv7/++Yx853m5uh3a/EACxTAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HiWK7e1K; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755804925; x=1787340925;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3MCKTBlw/nn/H1B0V6kPgyxYjXaoT1IUd9NZGODEVZw=;
  b=HiWK7e1KIgMvaA+FxP3fkn4AWemsQRdnb03fucgQ9yRt718VsbsdRKBQ
   NnKahvLw7OuFvnJynFabWwKRPTu/toscHG11BlYnAFyIqeHb7gY9FBIwC
   Q5SVA6IkvIqzL04LdSe0RxEbvtDwDsUVhHbUuxZi32fb7VgUGGt2HgLRv
   Khu5tiUt8L7lpHB6oh8Qul6FzlSVKuJG5lIZP64TT+l63QWIjKza9A9Km
   1Kc/BCYRnnTu3TckZVUiqAT51KoP8+bswwFALdxvb9WS0Cursxv42yATp
   e5NL12ecWDA2AcfOxqqzuXoLEWRdXMrjtAE7nzLAT9st4MUf3Z7Rt9mWV
   A==;
X-CSE-ConnectionGUID: 1JxbQwRvQRaU//7Rl/MiGg==
X-CSE-MsgGUID: z9KGkQF5Q+azI2ZaoZF7/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="83524642"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="83524642"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 12:35:24 -0700
X-CSE-ConnectionGUID: 1386FrAdRCqn5ikoVhQecQ==
X-CSE-MsgGUID: BRIY6GoqSgG/JAdnjuInQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="173820243"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 12:35:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 12:35:23 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 21 Aug 2025 12:35:23 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.74) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 21 Aug 2025 12:35:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8cpluQUVn6PGfh46btizgXVyKbaE9wOaJk3EwiWPa4m/UmAwgUT8f8muel89eKJad3Rwi54avZXQMkqXdQkz+jDNzs4LMVT+y6fkGdLRPjvXjiLg0wvk/rzupdBWVvuKHV7GR7yOuBnP0V4ZIlgOLfhF6HGJcX3GE+TQcMAHutO6GlA07svnG9HDoVxBmTbRx/X2Pv7x/TT/hM9a7pbp9rWld0uezltHixhxOBDvD4SUUlvON6/jXVDkn+u+3Dq/L3COLWeYiZFDunnGwC+8NpaJCCZ4IbjqAYaMZx9U4M8+DWZFSKPHMsN4ogGYop5YbK/noYQa4RaOzpmrG+eug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MCKTBlw/nn/H1B0V6kPgyxYjXaoT1IUd9NZGODEVZw=;
 b=KyyvNjmViMxVW/NN8nCkhndicCEh9B1+D0h7hTjVnOaKv+Q88qJ8nDznXqopg/cNwt1nTMkOZW3eHXv+qaKq7vcDSdUNPj3jBmOL3AWL0KK03GoGuGaFQnLZ7/PERWkckEEuFGiG4BBJCTysv6/tOi3oyRQNN8kG45mwMxTTCShVTTCvJWua9halKKkymKrnP1znTOACBGdFlkxXg5swe3axSVjiusop0WzFWixyUq23g8GmRBPvg4WgV616Z5z4yuKD1z8J8do8CaxYsTzODAFs4oSBAWIiSjsOuKYdKWddsh2DBA3UWX1ke0jgqK9iIHw6O5vbPmjej9aisEquRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4876.namprd11.prod.outlook.com (2603:10b6:806:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Thu, 21 Aug
 2025 19:35:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 21 Aug 2025
 19:35:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"sagis@google.com" <sagis@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Thread-Topic: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Thread-Index: AQHb2XKum6lt6z+w7k2vHggT003XBrRt7saAgAADygA=
Date: Thu, 21 Aug 2025 19:35:21 +0000
Message-ID: <0a1cf08ba04b026a6c48a390a756dc2a990b3620.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
	 <CAAhR5DGGWss4jovHETYmBeK1gze04LR9c8Dcd2oMpCC3SnMDgQ@mail.gmail.com>
In-Reply-To: <CAAhR5DGGWss4jovHETYmBeK1gze04LR9c8Dcd2oMpCC3SnMDgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4876:EE_
x-ms-office365-filtering-correlation-id: d2c71387-0d52-4267-a5e1-08dde0e9de1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bFRaUEdGTHFBL2VsZ0M1WUN0QWtQNklTdXNJSHlxUFRkbzhkYWNkUmM5RHlv?=
 =?utf-8?B?UGxZaWU0dTNtMGRmcUdyTUtTLzJ1djRESHlNQ3RCNVVoQUZQQ1pDY2NBYlFY?=
 =?utf-8?B?c1Q4WFppb0NyZERCV2wvY05CaVgwYmhhOWZVYXVsa2xwbjhFeEVBTnZUVjJl?=
 =?utf-8?B?ZGN6RG1OdURGV2U1aDUyRWQrYlZ0enNobDRsQVVydHR2V1BRbHB4eFNzTVVW?=
 =?utf-8?B?SEFWcnV6ODlsMHNObm1qN1doYzQ5SkdrbDVXMGR6YVNLek05TVd0L3pOelBq?=
 =?utf-8?B?cFltU0NYdnVMWDBMK0ovei93cC9Rc0RTeTVzRDlGQXRlNkVocHZLRTJZQkhZ?=
 =?utf-8?B?aXpkZVpUT1JEOFBZNWE5QnMxMzNua05zRjBheWp0TWkvUWlvZVhXNUt0Q3FX?=
 =?utf-8?B?N3F2N2Zwakgyb2JjN2xjZEpocXpicWx4WGx3K1ZydTNZVmZhNFBFdmZZRzRS?=
 =?utf-8?B?eG1xakVNQTExK3VIYWFTY0xzTVllNHZrajZxakQvWUtZdWVQbTk5Q096eFZZ?=
 =?utf-8?B?SFJVdWtJUlkwL25tckgyZWxDTk5qOGZFYU12dC9yUGVWOHFxYjdBZmpSVkF1?=
 =?utf-8?B?TG5VOHUyUCs0T0V5eVFRNit0T1N0a2VrQ3RkYjdKbG5uWnFkREZwY09tK0ht?=
 =?utf-8?B?L1Z4OGN0a3g3YmxJVWg3Q0hISUR0SStpV29xUVAvcGF1ajA5cFdkTi9xbzJR?=
 =?utf-8?B?d3RzQU1QL3g3ZWphWjNJdk9pS1VXRXQzMGhPRlpCNVJBNWNFc2F4UmxrbE9v?=
 =?utf-8?B?RmczckNsQi84anM5d0tRd0RXZmZPUTR5U3hnL1FHd09IV2R3V1drWXN5dVdO?=
 =?utf-8?B?eUtPVDQ0ekpLeEduY0JYZU9vNFdZT2xrS1U0bW1zTkJSTlFlTzFML3pWM08v?=
 =?utf-8?B?RlhZd0tGZkVmMEFvaFRRN2Z5OW9abm9OUUVJOGdhMldVZFdFRHZKaDZ4UlhH?=
 =?utf-8?B?ZkpLK3N6Nkc5R3BOTFlQQjBwNTFrdFpPU1pJbFJLck51SlRMc251V2NubHlz?=
 =?utf-8?B?cmJjZjdpZG14Y0t1b0lCZnNRaVg3c21GNzRJNnFaZlBEcStsVkNERHlkak56?=
 =?utf-8?B?RXdhUFdWT1Z3a0J4V1RWN3dZdGtlNFM5TWpDWHlBSDhEWXdQLzZNa1Y4TE1i?=
 =?utf-8?B?RkowZHJySDZLZkZzR2xLY0dCLzRyOVJua3BheGVuZE05aUV2U2Vta1V6L2J3?=
 =?utf-8?B?U0orVlU1SHV4WWVvcXNnQldWcWZ1Qnd5V2JTNEREYkZvZTVVL3VKSmxjYjR5?=
 =?utf-8?B?S2hkQ0tBa0hxZ242VGRxWHVPaFZjNVlaaWhZTHNiM0QzQjFINzFyVmEwdno1?=
 =?utf-8?B?WDlVbzBHWFJtb3Zydy9FL0FPbExpOU91T0xERWdtR3dPalZ0dkJKbS94aVRG?=
 =?utf-8?B?TkNXdExjY2FHMVY3WU5VSUVVcGhaTlh3cFBvQjJBZHJDanZGeStuOTgyZkF2?=
 =?utf-8?B?THQ2eHBhTlRwMmh0K2VncEpWWmkvdzhXeDhlRWJVcVBzVk1KTG43RHFYVXZo?=
 =?utf-8?B?YVNiY2QvL2VsMVVhTHJoMmFYY3FpTjhWVkxPdXRHNlc5amhBcC9nRXBqckZ5?=
 =?utf-8?B?b3U0NDRteURReXQ2d1o2Y1VsTWdaVmhQVmZGa0RnT3V0azNyZzBobnJPRXJq?=
 =?utf-8?B?ejR1cGhkTVJWbVo1dE1VRVdXdDNZUFZsTEk2QnpESlF5dHI2OWsyQzRYc0U4?=
 =?utf-8?B?Y2JrZWRCbWpSR3l3S2l5UWc5b3ZONHFXb0NYTVl5QnkxR1pKQ3hJVWhCSW1k?=
 =?utf-8?B?VUNIOWJTM3VQU3RseXVYQ1NndGJHWWxkU002T2Mxb2lGc1pnVXdXdjZRSytR?=
 =?utf-8?B?Ry9OcHUrMXFGdG5WMTVHVUQ4VDhZK0hQaTVIdzdpbmxqUGI3MXJaM0QydXFS?=
 =?utf-8?B?SnZ4eDdWWUFjYlkyKzFCeE5WNWN6YVJqV3UyNXVXUTVsTXFTdEIra2YwdVAx?=
 =?utf-8?B?Q0NHYnMxTjRla2tha1p2M1BOSE5meXpTTFNYVitaczJvc2w3N3NWbW9VUW94?=
 =?utf-8?B?N3A0RzZmcVlnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUFYR3RRekd0NFIrYlkvaVhyM01mZ0h6bGZ3eUFqSE8zaVA0b21zVm82RlFX?=
 =?utf-8?B?MisyMVlJNXJMaE1JSzdWMHhKdW43WWhJUFU2T1R0VUhKdlFaclZCRFhkdHZY?=
 =?utf-8?B?dStCbXd3WG5ROFhIOXNzMjlxTUlFb1luTk9JbEFLMC80NE1VUElSK0p3VzlH?=
 =?utf-8?B?VDdFbEhSRjJkMDlXYlJrVC9MVkxoOVQ2WER3MmtrclVDNkx2LzU2RHNBM2pj?=
 =?utf-8?B?ZGhZbDBUWXlsTlZHQThIOXljSXFKbFBZcURqMENLdEhGcjJ6TklFNEtpdDFY?=
 =?utf-8?B?Mm1LQXhqWXp2MDRjOWZUeU9VeXNXWlVpZmlSU1cwTFM1Q1NmbnFCRkVEZitV?=
 =?utf-8?B?emVINE5USjhYRStwdVZyaTBNOGU1Q2dHRllFcXdvbzlQOFZYaTNjUm1wK05P?=
 =?utf-8?B?MkhDL0JVUHRaVVJKRkdwUEtvNERLa2hldDJDZmt1MGMwcXpUcmhST2xJMC9T?=
 =?utf-8?B?ZXdmenJlUmlGNU8wTEc1ckFHNXhjcDh4SWt6a3VLa2FxUGVMM3dpdkIvaDhL?=
 =?utf-8?B?VmQweGhPMnkzNkFrTWlINmViYXRjUHlYSlBnWnkzRVdSdVF4U3hGZkhTVGlu?=
 =?utf-8?B?amN3TlhONXMrRWtmcnZsdXNiSjlQSWN6RUhTQVJtYlJCcHM4SFVqQ2xhTXBX?=
 =?utf-8?B?NE5WOUQxNTdzSXFMbkxyS2JGYURkenZLQlZVZ3hnUzRVYmE2MkZWalk5SzFR?=
 =?utf-8?B?NDFpUk5kYlBLN1JwNklFNk5RMVlFZkpXcHJKVUo5bUxYOFFiMHU1dTFWakkx?=
 =?utf-8?B?cmRuOCtoWDM2UjhyRjV1cERLNEY1NkwyNStJT3IzTlRGVDFXbWlyekVXVkJY?=
 =?utf-8?B?ditrT2lFUERyaDRuQ2N2U2YrVUh2NkM1N2dzenlzbmxVR0MyQ0dOUG05MkV5?=
 =?utf-8?B?REdPSENkdlUrdnI4R2F5WmEzQ3orQ1ZYZEtvNXhIUHV0cjZldUNibytpZE1Q?=
 =?utf-8?B?NFlxanNOTi9sSXlMUHVmeW5nYTlMZ0ZMeUgrSC95OFAwTmp2c1kyVzRkVzNH?=
 =?utf-8?B?VUZxV3B3ZnBMZEN5ZDl0VXJNanIyUXVrRmFLN0t4R1RoQkx5VmRLcENiUDBp?=
 =?utf-8?B?azBvUEZib1kzUGNiVHF0dlVHU0hWNEpyWU8wS2RVNzFwREM5a2RjNHBud05z?=
 =?utf-8?B?Y0VHaUJ2R0t0dWFKcUtnUTVJUGFEMXg4QUloa1NVR3lUKzd6MFBYM0tmdzkr?=
 =?utf-8?B?Vml2ZlpMemtUYTZsaWVyeXZzcTZVdFJDNmNsZzk0NkhMTzNVUGJqRUFKNDFZ?=
 =?utf-8?B?dU1SNjFYNlNNWThDRkRXdmFpc3NvNnZuU1I3T1EzOE1jMmtnVERDTGhRR0dE?=
 =?utf-8?B?Vk9UTkE3ZTVJdG8xZDZKMjgxV0JaRkwva3ptdDNsL3pJME1oc096Zm1VaWRV?=
 =?utf-8?B?Q3lXdzErWkl4Z2FQTnpWKzlSaUJDbU9HOS9ISVZrWUdIR242RklRNTBxZGwx?=
 =?utf-8?B?K3NTQkVzOVB2M1dBNHJDa1p3T2lqUy93NExGNGFzb1Zna1hFRGhZQ1VKcjd2?=
 =?utf-8?B?eWcybFZnU09ldS8wVURBS3FydktLMktzZTdtZndMSEYySFRiZkFKd3RsSWpX?=
 =?utf-8?B?NVRya0NqNnVqL2VlNTVvOXJFRzh3dHNIYXlTMzZCUjJSVnU4YVlZZ0drek1l?=
 =?utf-8?B?ZjVTVStYV1o2RlM4VjFMcEJNN1E1Umo3UnVjcUdNTzNUVXBMbjBUS1Z2SlFI?=
 =?utf-8?B?UmdWTGVkZjNpQnN1Q0tjS01maUlYV21FdGVvWHhYbzdVR0RVaGRpMC84V3o1?=
 =?utf-8?B?ajFQb1YrSE9qRkEzbXF2aERnMXZBcFVnRWhQWWFJaHFmcERMNUxJdUFGWGs4?=
 =?utf-8?B?TGV6bS9jRjU5cVY0UTZOaEYyMElXenY3Q3o3Y3R4NDhHdnFoeXJ2RFJ4U0M4?=
 =?utf-8?B?Vy9pQko2YmtTbHhmdEFzUEhGM21FZk8wRGJHd055bk5pandrcjZrNnlNTE11?=
 =?utf-8?B?Z0dOZyt6bUFuU2FHVjBVRnVQVlMySEUxTm1sOFBtN01ycU9GZWVpZDNpc1F4?=
 =?utf-8?B?cW8xcUJ6cEp3b2RYYjhXU2pVenpoSU9zODBuZ1dvbHM0NjNZcC92c2gwdVoy?=
 =?utf-8?B?YzZaQ1Y0a1A3QXcvWldRcUFjVmNZYTRYY0tMajQwSldDT09zQnl3WXFGcHlp?=
 =?utf-8?B?ZW9PZHVxaUU5YXZQR21pSlBtclFqYVV6NmpmeVJNMlNWTGFhWHYybFB5R000?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB15186739DFC741A12F61DE72F5D0C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c71387-0d52-4267-a5e1-08dde0e9de1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2025 19:35:21.5063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SP5c84dKInNi6Ii38FuDzpPcojPFkHdjKTBOnCR34KCoMVCWbb+57EBpVi24o4LHsEZ0P0zcJg0F1He06+HErpojPx9yJpmQdH/hvD8r/Uo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4876
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTIxIGF0IDE0OjIxIC0wNTAwLCBTYWdpIFNoYWhhciB3cm90ZToNCj4g
PiDCoCBpbnQgdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90
IGdmbiwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZW51bSBwZ19sZXZlbCBsZXZlbCwga3ZtX3Bmbl90IHBmbikNCj4gPiDC
oCB7DQo+ID4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUgPSBrdm1fZ2V0X3J1
bm5pbmdfdmNwdSgpOw0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGt2bV90ZHggKmt2bV90
ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgcGFnZSAq
cGFnZSA9IHBmbl90b19wYWdlKHBmbik7DQo+ID4gK8KgwqDCoMKgwqDCoCBpbnQgcmV0Ow0KPiA+
ICsNCj4gPiArwqDCoMKgwqDCoMKgIHJldCA9IHRkeF9wYW10X2dldChwYWdlLCBsZXZlbCwgdGR4
X2FsbG9jX3BhbXRfcGFnZV9hdG9taWMsIHZjcHUpOw0KPiA+ICvCoMKgwqDCoMKgwqAgaWYgKHJl
dCkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPiANCj4g
dGR4X3BhbXRfZ2V0KCkgY2FuIHJldHVybiBub24temVybyB2YWx1ZSBpbiBjYXNlIG9mIHN1Y2Nl
c3MgZS5nLg0KPiByZXR1cm5pbmcgMSBpbiBjYXNlIHRkeF9wYW10X2FkZCgpIGxvc3QgdGhlIHJh
Y2UuwqANCg0KTm8/DQoNCitzdGF0aWMgaW50IHRkeF9wYW10X2dldChzdHJ1Y3QgcGFnZSAqcGFn
ZSwgZW51bSBwZ19sZXZlbCBsZXZlbCkNCit7DQorCXVuc2lnbmVkIGxvbmcgaHBhID0gcGFnZV90
b19waHlzKHBhZ2UpOw0KKwlhdG9taWNfdCAqcGFtdF9yZWZjb3VudDsNCisJTElTVF9IRUFEKHBh
bXRfcGFnZXMpOw0KKwlpbnQgcmV0Ow0KKw0KKwlpZiAoIXRkeF9zdXBwb3J0c19keW5hbWljX3Bh
bXQoJnRkeF9zeXNpbmZvKSkNCisJCXJldHVybiAwOw0KKw0KKwlpZiAobGV2ZWwgIT0gUEdfTEVW
RUxfNEspDQorCQlyZXR1cm4gMDsNCisNCisJcGFtdF9yZWZjb3VudCA9IHRkeF9nZXRfcGFtdF9y
ZWZjb3VudChocGEpOw0KKwlXQVJOX09OX09OQ0UoYXRvbWljX3JlYWQocGFtdF9yZWZjb3VudCkg
PCAwKTsNCisNCisJaWYgKGF0b21pY19pbmNfbm90X3plcm8ocGFtdF9yZWZjb3VudCkpDQorCQly
ZXR1cm4gMDsNCisNCisJaWYgKHRkeF9hbGxvY19wYW10X3BhZ2VzKCZwYW10X3BhZ2VzKSkNCisJ
CXJldHVybiAtRU5PTUVNOw0KKw0KKwlyZXQgPSB0ZHhfcGFtdF9hZGQocGFtdF9yZWZjb3VudCwg
aHBhLCAmcGFtdF9wYWdlcyk7DQorCWlmIChyZXQpDQorCQl0ZHhfZnJlZV9wYW10X3BhZ2VzKCZw
YW10X3BhZ2VzKTsNCisNCisJcmV0dXJuIHJldCA+PSAwID8gMCA6IHJldDsNCit9DQoNCj4gU2hv
dWxkbid0IHdlIGNoZWNrDQo+IGZvciAocmV0IDwgMCkgaGVyZSBhbmQgYmVsb3cgY2FzZXM/DQoN
CkkgdGhpbmsgeW91IGFyZSB0aGlua2luZyBvZiB0ZHhfcGFtdF9hZGQoKS4NCg==

