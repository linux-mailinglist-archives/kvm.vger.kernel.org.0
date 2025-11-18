Return-Path: <kvm+bounces-63434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B89F7C66A0B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4853935ED7B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2CA1A3164;
	Tue, 18 Nov 2025 00:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9Uoy5Ze"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6C8A41;
	Tue, 18 Nov 2025 00:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763424877; cv=fail; b=i/+wrANaAebJWKCJrrHYXpPYDC5N0rgxvgzy5F1ncIxXdutjpGhuXDInX/bwBGvZP3HkQoEBSHSty8fTAI+Eq/WQObEBRH58yQu7cGXew3IYjROmIqDRKPktA3tVyLxKvGdndbipkj7hlOB9lksnCqQWV5F5Gz1iVEwkUvTw7cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763424877; c=relaxed/simple;
	bh=vz+C8rn9ln8ifojH4WiulFms4jjZAfvS0FZ60kqtjOA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TIWjipXWm4RCWN0O9cTbHTRbO73fq1/BzSWVVN5ZEVWjtlLMejmSVBdWascInjCS7bs0FMs6YF2EZ/AfYh378cNSFCpsHUSXqwXrXmYW/GyFyhO6eH3D4BGaRis0F4JdC1yU0u6D/60sM0KPtZNCzKMcm4mAWTAhAFvSZbIdG6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9Uoy5Ze; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763424876; x=1794960876;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vz+C8rn9ln8ifojH4WiulFms4jjZAfvS0FZ60kqtjOA=;
  b=U9Uoy5ZeppA9wfnkNwfWuQw3hYsuvgEYi7PpUm5QZveQT+yIWCi53JMC
   3GhD1Nksd0FsbKjekGtkrRuMY2rZglqt61xZ1Tc3NjVD33Tb4Zj+JMqxs
   ktlxCalb8cWqVMhvHwYNhsVYdpA9h7qzJ6xsTEsyXQ2DsmthrJscfbbN6
   XpFZfi4OlbOzPyul8LBUZxqEblAysMIOAOMrlEPaOL8qjmh/kkHGDhDfZ
   EPszQxk0CjrQo7SsTQQ/nkn5UEjCv+1DG5dpxNGKd4x2iqZJKbaHQGFvw
   Y/2oA4AdMQ/mUhLXGlL2mNdDzI146zjcd2dSEkUneE6cS5V+b0V+rankz
   w==;
X-CSE-ConnectionGUID: PGK/dDXYSOugpqjFHKlXrg==
X-CSE-MsgGUID: cwS7eubkRkqcT2wdxqL/wA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65338038"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="65338038"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:14:35 -0800
X-CSE-ConnectionGUID: gSxvtUQqS5KefRJChF+wCg==
X-CSE-MsgGUID: 7+e/2U1LQNGOlH0KUhl1RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190748297"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:14:34 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:14:33 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 16:14:33 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.20) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 16:14:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEySCB5r5wXnw/Jz9iDn9TAAmS7OyYc5LCfboVLMz/xvWR3rV2kIaeIg2jciI/UNZchBnFq6NYtVDxgOuZFe6izEgrnUgkng0T+coCVo61gBZmn23OLYmR/5PdvEhw2IKWsRi7XxWKMJONnGgHtpmxfq9q+o3gPsvafjna5WQ9le7nYFilIZPeJImHwPNZkNXNbSz6xmcsV5CTYWMVRcBroC5TdYtmsb2Enxs7GLzqaiFD87I7Ct94w1mAW5+/p74UDlyxad7XsiUHWnMgwYuX5KRMuiaFmN9JKOivRuVk5KA0Bzx6RGW+flVX+mYJc7JqxDy3DCseTiisEGgqKb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vz+C8rn9ln8ifojH4WiulFms4jjZAfvS0FZ60kqtjOA=;
 b=LJWR/FqH1dtlBvWcibKpwxJzdUGVJhCCgD59wm7W6diBBHEEe6CF+vGZzVd5sBgKZ8wdLBy24kjOlP2a/TGRvAxbyfMGO7jIeovmTAGCsfwZiMNqnNjtIxw87dypDlq+YTZqNTcIrqWMpARTQS7Tc8c6dWtELpi3gp40Mn6D34AOrlzrCt+X4FUe21DJd7ukT5FI6QaR02F+HuaPoZSV6S4Kgv3NuvL4TZt3oc6VAKUePFf48qiS+3oCpbiQ3iN/Y+T5SS+rHIbZGkgvA0eV9Fk9LkbghXMsFtzrgUuV+MeldIDKsQlgaGzCg6wFnOlp1FDDX+cPBffwBFlnWMaXww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ2PR11MB8423.namprd11.prod.outlook.com (2603:10b6:a03:53b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 00:14:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 00:14:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcB4AQJSSoQW12Bkmtr+PwbHPEybTt4N2AgAMGZYCAACPdgIABQHwAgAXl7QA=
Date: Tue, 18 Nov 2025 00:14:17 +0000
Message-ID: <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094358.4607-1-yan.y.zhao@intel.com>
	 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
	 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
	 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
	 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ2PR11MB8423:EE_
x-ms-office365-filtering-correlation-id: 0aa1f0d6-2759-4119-2f73-08de26376a40
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eTJsemVXRXdpTWgvUk1YQjZWMzE0djhPU2d4SDBrTTZpT1ArdmdYUWM4TDNW?=
 =?utf-8?B?ZXU2bkdnK0tpUDc2SVovMEQ3aUwweUJKNWtHS0Vhd1B4V0kwWG13T0I1K1hV?=
 =?utf-8?B?RGVwdkRLS0NQRWJxUnlBT2JGUVdPK2U5cmxSR0UzWDFJN1lhd2c3ZVdzanZo?=
 =?utf-8?B?WXUyTXcxRGlqRDhoaFl4UUx0K3YrWEFEak9VSTlmREU4WndudlRWeUd5cGF6?=
 =?utf-8?B?cnZ4Wmc5TkpFSGcvaHgxL1dYOHZOcmE4QjQvUG80ZnNISkNmelgvL1phbjFD?=
 =?utf-8?B?Z3dDZ25CTVFxSFNiVUY2ZXpnR3hIaGhMTzV4VGo3Z0ZKWkhDcVNUTHVDWTZE?=
 =?utf-8?B?R2JUNVY3dERoOGl5Zkd4NERTWmE1NUFzVjMzd29lT3dpanF0eW4yUC9PT2g3?=
 =?utf-8?B?c1YxQ0ZUN2ZXM1o2NFJDbDR0bkExRCtGNStKbXp2c3lpZWkyZVV4VkNCRzdZ?=
 =?utf-8?B?Q2xTT0czeUdxUy92Nk45QTY1cE0wZGV0ZjBvbmRVcXJqV2RFTzZHb0sxZk13?=
 =?utf-8?B?TXcxaXpORGJ0eEpoTFVvdVpUR3hycytxZmQrRVFHRWhDdHR1dk5pTXhjV3Fv?=
 =?utf-8?B?eTdjaE5oanNrZ095cHN6YmZEaWt2NHo2MUl6V3hhbjkrY3ZHdGN6d3NTS3Bx?=
 =?utf-8?B?eDBTcWdLdndicVJrU0Uyc0FuVW5WcWVhc01vbVM3V0l5dlJSelMwMy9maEp3?=
 =?utf-8?B?YitobTcwYVI0bk16aitMbGloNEt2VFp4VmVIV3RPWGoxQ1MwSkFDOFhlTDhh?=
 =?utf-8?B?T2lnMDB2TERSRGlYSHA0aUlwSWRTMWRkaTFaZHBRZmtqYUhYWlZQcXdIRDcz?=
 =?utf-8?B?SGxsSVVVc3F2eEp5T3FOdEQ4bjhXNEI1ci9oamJjcHUrN0dJWTVKa3pOYnQx?=
 =?utf-8?B?NW55RWNnWHZDZjVmS0c1T1hDdzJ2blQwRlhnNDI3cy9vb01JR2JvN29TMjY0?=
 =?utf-8?B?dUZMTHN4SS9jMitxMlI2RlZDMzBBdTc3TUpNZURWa0VmditmMjU4WU53dy9L?=
 =?utf-8?B?emRMOXFDQWREdmo4NzJwL2lNeFZlVXBRNFZhMVhSNGEwcWNJOVVaUDFGV09Y?=
 =?utf-8?B?YnZSWmlnMDUybzc1Q1RIWExONDd0cmhOMFJmOFFZaGVuM1MvNmR4V1B1Zjll?=
 =?utf-8?B?RFF5QlQ0MzliVnJLKzRqeUhBOERmbkJxOEY5alF5ZGkyUGt5YTlOVHJTWDdr?=
 =?utf-8?B?NW9NcTZlTnltN2g4aXN4YzNFNTRRN2MvaDhNc1ZNNW1XOWtuaFhTQjBVMDBw?=
 =?utf-8?B?T3pBbUxTaUtldkhUcG5GM1N2eTl5b2hEczdLZEFZaGM3SHdJaDB1Rmw2WHAr?=
 =?utf-8?B?VWZIVkN5OVdvaElCajRYTXpHcFJBZ0FZL0lheG83L2RROGlUVWNhWnFtWFMw?=
 =?utf-8?B?b0pIV2craEljOVBBWStjcjRyckxlaE93ZDdUSzQvZGdFTHJIYUJOMzh1SWRQ?=
 =?utf-8?B?UWFGVmVJbGhsdzdhMnNKT1FDcllkdjBrVThHVjFUT05UdjdsaklNVis3VlJ6?=
 =?utf-8?B?RTBBUWdTMVo0dzF1US81NFJiWEZzd09WWUFERWcrTk1oOXJWSVRmRWVvSko3?=
 =?utf-8?B?UXFLZnVsQkZnU0x4NGx0MHR5aEJlbEtJcml2bXlPcDFNVE9xYkRPb01GNU9s?=
 =?utf-8?B?YmRheHZySUdVZy95UUlrekdjM0lhU3BmdDVVZjBVbTF5a0diZHlHZmxQNjg5?=
 =?utf-8?B?L1F6WFRFQVpCQXdrajRMeXJSKzFIUDlxSzQwdk1EMFJEZVBmUkdiVUI1QTJ4?=
 =?utf-8?B?UzFrZkQzSStFcjJLNUx4bGY3V0ZaZ2NKNkN6L0d4Uk9BNE5xKzZXaHErUDdk?=
 =?utf-8?B?ZUgwNHRVbnlTQ0VpQWFheGppSGdqQnMwNW9SMytnSUdMbUZvelRnUmVLNUhV?=
 =?utf-8?B?NXlxc3h3UnNjcHRCeUVJRnduajJyTEZSUVpLbksyS2YrZThpRFhUMXQ1ZURT?=
 =?utf-8?B?ejdHbzFLcWtGaHZ4Z0RQMjJEa0IvY1lwdlBXd0VDbDRDcm1MbGtVTUszd2JB?=
 =?utf-8?B?eGE1WC82RmY1V08yK2dvWWRIU2gyblFLK29vaDhlZHZ0OEdJVFBxYmR6cm5C?=
 =?utf-8?Q?6vxmFs?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aytaUDIrVnF4T3czUGRqa1ZQYmo3bjZRWVpBcldkVmNKclpDU1BqOUNqT2lY?=
 =?utf-8?B?L1NndWQ4dno1UzRyU2dOeGgxZ2JGeExZczZteFlRNURmTXpkMlVTQmxwaHJT?=
 =?utf-8?B?VFR4WEd3VDZDbzZwT1VnU0ZDUWJEdVd2dUY3dDNuNGRtYXhQdnZtQ2RtSmtH?=
 =?utf-8?B?TkdyMnJFRFJnMjhGZElVS1pLWGZmTHp4R3BydXRPZlQ1T1k1OXJ3c055c21k?=
 =?utf-8?B?M2R0TWRLam9EdUh0TGJhanFtY1drT1VOZnhxVndnVGYwMzAyZi9nRlZIK3F5?=
 =?utf-8?B?RjJKL21XOGd4SE9KSkExNGlQYWRVVTgwbFQxQmFYN1Bna0JQaU10akRxYTBz?=
 =?utf-8?B?d2tTRTh0YlpHdllYNGtiVlFkeFg1R3ZHeEZ5MjNQM2J1akNGWDRZeHhpMXor?=
 =?utf-8?B?MnJGNStRengrWVhqSkVVRlNmODJMaE9wTWMyUmZmeFpQdVdyMHJoOFZkcEIw?=
 =?utf-8?B?bDdHM3VES2NIdnBTYTJkVXAyczF5bzQ3a3FzUlFNYkRhWElxUjA3MFZvWC9C?=
 =?utf-8?B?ck5SR0hOdnRiY1pqNDRESWRtQ1ZsZkJIS3E3cy91d3hYWU50b3hzYWR1RGh3?=
 =?utf-8?B?TEp5K1JSUHltZ2RzUEpyekVEZ1Y1amgvOUlEanluMFEwNFNPYnNNbzV2Wkgx?=
 =?utf-8?B?bHhCbnBKR0tnL3IwM0d2YTRWbElSTllRYyszVUtORHYySWdNS1RHUW9OamF0?=
 =?utf-8?B?YmEvU3hNWFFoUHU3NUs1TUZLOGZaeFU4M3lLTEEzSUlYVndlV2gvS2NzeC9z?=
 =?utf-8?B?dDZ2MzlUR3BqbU1QT1NxUFR2WDBNREhBaG5xSVFvTkU3YTJONmwwK2JlR2g3?=
 =?utf-8?B?Sis0amZSSkREV2ZpdHpXVjRwZHQyZGNNYTgrTFJBUk5MUko0bkJ6bmh6ZE1N?=
 =?utf-8?B?eElOV1kyeWZpNnUySlBocExKaklCT1UzWjdHaHlaek1MTVdKQ2RLVWIzWDZ2?=
 =?utf-8?B?ejdpQXhUd1hWdVBkMUU0OTZ6QmNWd0x1cHFrQVlScWVYbzFLS05HcDV0MnZp?=
 =?utf-8?B?UFZON3FQSklTcnpWeGJQVFpxL1NQcTluV2hvYk93bldBTjJxOUNTdVBnOGph?=
 =?utf-8?B?N2NJYWZPWnFQdWZhRm0vUitnVk1kK0lRR0ZXOGc2bTVFZW10aUEwcWRWSll0?=
 =?utf-8?B?cWJVVWRpZVcwbWxsWXB6ejUzbHZQeEpPa3BQZW1zQ1JBcXNEQVBhOTNDcWhr?=
 =?utf-8?B?MnNNOFJxaHh4SnQvVXdXaGhZU0xXRzJKU1BsdGlud2ZORm91eWhQTm1TTG9O?=
 =?utf-8?B?R0F5cjlxeEZvU0ljSG1wMlVSZVY5WjlRaU1WNWUrd3pwWXZVbHVPcVpybnhR?=
 =?utf-8?B?MEJYQkUwZlVYSjhLcTlDMWlzSitBNDJxT1NUVHVZWEtUNzViT0JQTVEvMEZn?=
 =?utf-8?B?QXc1YU1qU3UzODA2SUsvZTVCamxidE1iU0ZXdkd0VEQyS3VYVnpaYXM4Qm9N?=
 =?utf-8?B?U1BsMmh0dGMrVHRXZDhnWCsrMzBCNTlHQlZzcE1tWTNUcituMndmblFFWDVZ?=
 =?utf-8?B?K0U0UFZQUThzcjZqaDlTTkRZL2ViZzJoL1p3T1g3cW1TSC9lNjZYbzJhMS9w?=
 =?utf-8?B?UmRJUVhjUnc3eDN6eW1nMmtaRjNsaVk3MUtEVCtpcGJFaTJ5Y1ZselQrc2Rs?=
 =?utf-8?B?TUFzRGZwMzF4VDBpcUgwOW8vUHc0WDd1aHo1WWh4QllOTHoxd2wxNW5XYnB6?=
 =?utf-8?B?RnI5akxjQTZMazArM3dDMnJwR0tUdGpNbERpYTZKRFdSaVFlSzJ1UHJuNmFT?=
 =?utf-8?B?elFydG9LbGg4UGowY1ZXZkkxNm9tZ29KYlF5OEhkSEhpVzFBdVlkU3lpWkRl?=
 =?utf-8?B?ZCtDcXUyOEhQeXZHcmljSzl4RFhPa2M0QlNYUWUrZFd3N0tIOFErNm5Mb3JS?=
 =?utf-8?B?Y2ZjcnJ4YWVoS1dHcUdnRjRJUVBrekkwdVR5WFRJY3ZDU2t2VVROaXEveEZI?=
 =?utf-8?B?M282dE9FM3MwOUFVMTZPc0NtL3pKa3JjVk9tZS9GTHRJQy9VaWhEd1U3cFlC?=
 =?utf-8?B?V0h0MG14WTFuWFZoQlFMWFFuc1VsMDI0MUJEeHVPTE8zK3Z2ZFJsRGFiY1cy?=
 =?utf-8?B?aE42cTZ0elJ3Qi9CTDZUY2k3SFJjK1JzVWtiR2phTHFZK0hQQ3FxMDY0N0xM?=
 =?utf-8?Q?UVg8wyiUSDrUKk2grQfanY1JL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCE81506881314469DADBEE9C1895EF5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa1f0d6-2759-4119-2f73-08de26376a40
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 00:14:18.0223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EPi6OJ2rtx3Y9XcKD90+mcKPNb2vA76LFXw+UfK1wZL0LBkZuO5T+lLTbnY50K5874PjPYkw3Yoz0bAEjOeM8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8423
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTExLTE0IGF0IDE0OjA5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VGh1LCBOb3YgMTMsIDIwMjUgYXQgMDc6MDI6NTlQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjUtMTEtMTMgYXQgMTY6NTQgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gT24gVHVlLCBOb3YgMTEsIDIwMjUgYXQgMDY6NDI6NTVQTSArMDgwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiA+ID4gT24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQzICswODAwLCBZYW4g
WmhhbyB3cm90ZToNCj4gPiA+ID4gPiDCoHN0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9odWdlX3Bh
Z2VzX3Jvb3Qoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ID4gPiA+IMKgCQkJCQkgc3RydWN0IGt2bV9t
bXVfcGFnZSAqcm9vdCwNCj4gPiA+ID4gPiDCoAkJCQkJIGdmbl90IHN0YXJ0LCBnZm5fdCBlbmQs
DQo+ID4gPiA+ID4gLQkJCQkJIGludCB0YXJnZXRfbGV2ZWwsIGJvb2wgc2hhcmVkKQ0KPiA+ID4g
PiA+ICsJCQkJCSBpbnQgdGFyZ2V0X2xldmVsLCBib29sIHNoYXJlZCwNCj4gPiA+ID4gPiArCQkJ
CQkgYm9vbCBvbmx5X2Nyb3NzX2JvdW5kYXksIGJvb2wgKmZsdXNoKQ0KPiA+ID4gPiA+IMKgew0K
PiA+ID4gPiA+IMKgCXN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwID0gTlVMTDsNCj4gPiA+ID4gPiDC
oAlzdHJ1Y3QgdGRwX2l0ZXIgaXRlcjsNCj4gPiA+ID4gPiBAQCAtMTU4OSw2ICsxNTk2LDEzIEBA
IHN0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qoc3RydWN0IGt2bSAqa3Zt
LA0KPiA+ID4gPiA+IMKgCSAqIGxldmVsIGludG8gb25lIGxvd2VyIGxldmVsLiBGb3IgZXhhbXBs
ZSwgaWYgd2UgZW5jb3VudGVyIGEgMUdCIHBhZ2UNCj4gPiA+ID4gPiDCoAkgKiB3ZSBzcGxpdCBp
dCBpbnRvIDUxMiAyTUIgcGFnZXMuDQo+ID4gPiA+ID4gwqAJICoNCj4gPiA+ID4gPiArCSAqIFdo
ZW4gb25seV9jcm9zc19ib3VuZGF5IGlzIHRydWUsIGp1c3Qgc3BsaXQgaHVnZSBwYWdlcyBhYm92
ZSB0aGUNCj4gPiA+ID4gPiArCSAqIHRhcmdldCBsZXZlbCBpbnRvIG9uZSBsb3dlciBsZXZlbCBp
ZiB0aGUgaHVnZSBwYWdlcyBjcm9zcyB0aGUgc3RhcnQNCj4gPiA+ID4gPiArCSAqIG9yIGVuZCBi
b3VuZGFyeS4NCj4gPiA+ID4gPiArCSAqDQo+ID4gPiA+ID4gKwkgKiBObyBuZWVkIHRvIHVwZGF0
ZSBAZmx1c2ggZm9yICFvbmx5X2Nyb3NzX2JvdW5kYXkgY2FzZXMsIHdoaWNoIHJlbHkNCj4gPiA+
ID4gPiArCSAqIG9uIHRoZSBjYWxsZXJzIHRvIGRvIHRoZSBUTEIgZmx1c2ggaW4gdGhlIGVuZC4N
Cj4gPiA+ID4gPiArCSAqDQo+ID4gPiA+IA0KPiA+ID4gPiBzL29ubHlfY3Jvc3NfYm91bmRheS9v
bmx5X2Nyb3NzX2JvdW5kYXJ5DQo+ID4gPiA+IA0KPiA+ID4gPiBGcm9tIHRkcF9tbXVfc3BsaXRf
aHVnZV9wYWdlc19yb290KCkncyBwZXJzcGVjdGl2ZSwgaXQncyBxdWl0ZSBvZGQgdG8gb25seQ0K
PiA+ID4gPiB1cGRhdGUgJ2ZsdXNoJyB3aGVuICdvbmx5X2Nyb3NzX2JvdW5kYXknIGlzIHRydWUs
IGJlY2F1c2UNCj4gPiA+ID4gJ29ubHlfY3Jvc3NfYm91bmRheScgY2FuIG9ubHkgcmVzdWx0cyBp
biBsZXNzIHNwbGl0dGluZy4NCj4gPiA+IEkgaGF2ZSB0byBzYXkgaXQncyBhIHJlYXNvbmFibGUg
cG9pbnQuDQo+ID4gPiANCj4gPiA+ID4gSSB1bmRlcnN0YW5kIHRoaXMgaXMgYmVjYXVzZSBzcGxp
dHRpbmcgUy1FUFQgbWFwcGluZyBuZWVkcyBmbHVzaCAoYXQgbGVhc3QNCj4gPiA+ID4gYmVmb3Jl
IG5vbi1ibG9jayBERU1PVEUgaXMgaW1wbGVtZW50ZWQ/KS4gIFdvdWxkIGl0IGJldHRlciB0byBh
bHNvIGxldCB0aGUNCj4gPiA+IEFjdHVhbGx5IHRoZSBmbHVzaCBpcyBvbmx5IHJlcXVpcmVkIGZv
ciAhVERYIGNhc2VzLg0KPiA+ID4gDQo+ID4gPiBGb3IgVERYLCBlaXRoZXIgdGhlIGZsdXNoIGhh
cyBiZWVuIHBlcmZvcm1lZCBpbnRlcm5hbGx5IHdpdGhpbg0KPiA+ID4gdGR4X3NlcHRfc3BsaXRf
cHJpdmF0ZV9zcHQoKcKgDQo+ID4gPiANCj4gPiANCj4gPiBBRkFJQ1QgdGR4X3NlcHRfc3BsaXRf
cHJpdmF0ZV9zcHQoKSBvbmx5IGRvZXMgdGRoX21lbV90cmFjaygpLCBzbyBLVk0gc2hvdWxkDQo+
ID4gc3RpbGwga2ljayBhbGwgdkNQVXMgb3V0IG9mIGd1ZXN0IG1vZGUgc28gb3RoZXIgdkNQVXMg
Y2FuIGFjdHVhbGx5IGZsdXNoIHRoZQ0KPiA+IFRMQj8NCj4gdGR4X3NlcHRfc3BsaXRfcHJpdmF0
ZV9zcHQoKSBhY3R1YWxseSBpbnZva2VzIHRkeF90cmFjaygpLCB3aGljaCBwZXJmb3JtcyB0aGUN
Cj4ga2lja2luZyBvZmYgYWxsIHZDUFVzIGJ5IGludm9raW5nDQo+ICJrdm1fbWFrZV9hbGxfY3B1
c19yZXF1ZXN0KGt2bSwgS1ZNX1JFUV9PVVRTSURFX0dVRVNUX01PREUpIi4NCg0KT2ggdGhhbmtz
IGZvciB0aGUgcmVtaW5kZXIuDQoNClRoZW4gSSBhbSBraW5kYSBjb25mdXNlZCB3aHkgZG8geW91
IG5lZWQgdG8gcmV0dXJuIEBmbHVzaCwgZXNwZWNpYWxseSB3aGVuDQonb25seV9jcm9zc19ib3Vu
ZGFyeScgaXMgdHJ1ZSB3aGljaCBpcyBmb3IgVERYIGNhc2U/DQoNClNvIHN0ZXAgYmFjayB0byB3
aGVyZSB3aHkgdGhpcyAnZmx1c2gnIGlzIG5lZWRlZCB0byBiZSByZXR1cm5lZDoNCg0KLSBGb3Ig
VERYICgnb25seV9jcm9zc19ib3VuZGFyeSA9PSB0cnVlJyk6DQoNClRoZSBjYWxsZXIgZG9lc24n
dCBuZWVkIHRvIGZsdXNoIFRMQiBiZWNhdXNlIGl0IGhhcyBhbHJlYWR5IGJlZW4gZG9uZSB3aGVu
IGh1Z2UNCnBhZ2UgaXMgYWN0dWFsbHkgc3BsaXQuDQoNCi0gRm9yIG5vbi1URFggY2FzZSAoJ29u
bHlfY3Jvc3NfYm91bmRhcnkgPT0gZmFsc2UnKToNCg0KQUZBSUNUIHRoZSBvbmx5IHVzZXIgb2Yg
dGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSBpcyAiZWFnZXIgaHVnZXBhZ2UNCnNwbGl0
dGluZyIgZHVyaW5nIGxvZy1kaXJ0eS4gIEFuZCBwZXIgcGVyIHRoZSBjdXJyZW50wqBpbXBsZW1l
bnRhdGlvbiB0aGVyZSBhcmUNCnR3byBjYWxsZXJzwqBvZiB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFn
ZXNfcm9vdCgpOg0KDQogIGt2bV9tbXVfdHJ5X3NwbGl0X2h1Z2VfcGFnZXMoKQ0KICBrdm1fbW11
X3Nsb3RfdHJ5X3NwbGl0X2h1Z2VfcGFnZXMoKQ0KDQpCdXQgdGhleSBhcmUgYm90aCB2b2lkIGZ1
bmN0aW9ucyB3aGljaCBuZWl0aGVyIHJldHVybiB3aGV0aGVyIGZsdXNoIFRMQiBpcw0KbmVlZGVk
LCBub3IgZG8gVExCIGZsdXNoIGludGVybmFsbHkuDQoNClNvIEkgYW0ga2luZGEgY29uZnVzZWQu
DQoNClBlcmhhcHMgeW91IG1lYW4gZm9yICJzaGFyZWQgbWVtb3J5IG9mIFREWCBndWVzdCIsIHRo
ZSBjYWxsZXIgd2lsbCBhbHNvIHBhc3MNCidvbmx5X2Nyb3NzX2JvdW5kYXJ5ID09IHRydWUnIGFu
ZCB0aGUgY2FsbGVyIG5lZWRzIHRvIHBlcmZvcm0gVExCIGZsdXNoPw0KDQpbLi4uXQ0KDQo+ID4g
DQo+ID4gU29tZXRoaW5nIGxpa2UgYmVsb3c6DQo+ID4gDQo+ID4gQEAgLTE1NTgsNyArMTU1OCw5
IEBAIHN0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2Uoc3RydWN0IGt2bSAqa3ZtLCBz
dHJ1Y3QNCj4gPiB0ZHBfaXRlciAqaXRlciwNCj4gPiAgc3RhdGljIGludCB0ZHBfbW11X3NwbGl0
X2h1Z2VfcGFnZXNfcm9vdChzdHJ1Y3Qga3ZtICprdm0sDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290LA0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ2ZuX3Qgc3RhcnQsIGdmbl90
IGVuZCwNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCB0
YXJnZXRfbGV2ZWwsIGJvb2wgc2hhcmVkKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgaW50IHRhcmdldF9sZXZlbCwgYm9vbCBzaGFyZWQsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib29sIG9ubHlfY3Jvc3NfYm91bmRh
cnksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBib29sICpz
cGxpdCkNCj4gPiAgew0KPiA+ICAgICAgICAgc3RydWN0IGt2bV9tbXVfcGFnZSAqc3AgPSBOVUxM
Ow0KPiA+ICAgICAgICAgc3RydWN0IHRkcF9pdGVyIGl0ZXI7DQo+ID4gQEAgLTE1ODQsNiArMTU4
Niw5IEBAIHN0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qoc3RydWN0IGt2
bSAqa3ZtLA0KPiA+ICAgICAgICAgICAgICAgICBpZiAoIWlzX3NoYWRvd19wcmVzZW50X3B0ZShp
dGVyLm9sZF9zcHRlKSB8fA0KPiA+ICFpc19sYXJnZV9wdGUoaXRlci5vbGRfc3B0ZSkpDQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ID4gIA0KPiA+ICsgICAgICAgICAg
ICAgICBpZiAob25seV9jcm9zc19ib3VuZGFyeSAmJiAhaXRlcl9jcm9zc19ib3VuZGFyeSgmaXRl
ciwgc3RhcnQsDQo+ID4gZW5kKSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBjb250aW51
ZTsNCj4gPiArDQo+ID4gICAgICAgICAgICAgICAgIGlmICghc3ApIHsNCj4gPiAgICAgICAgICAg
ICAgICAgICAgICAgICByY3VfcmVhZF91bmxvY2soKTsNCj4gPiAgDQo+ID4gQEAgLTE2MTgsNiAr
MTYyMyw3IEBAIHN0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qoc3RydWN0
IGt2bSAqa3ZtLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gcmV0cnk7DQo+ID4g
IA0KPiA+ICAgICAgICAgICAgICAgICBzcCA9IE5VTEw7DQo+ID4gKyAgICAgICAgICAgICAgICpz
cGxpdCA9IHRydWU7DQo+ID4gICAgICAgICB9DQo+ID4gIA0KPiA+ICAgICAgICAgcmN1X3JlYWRf
dW5sb2NrKCk7DQo+IFRoaXMgbG9va3MgbW9yZSByZWFzb25hYmxlIGZvciB0ZHBfbW11X3NwbGl0
X2h1Z2VfcGFnZXNfcm9vdCgpOw0KPiANCj4gR2l2ZW4gdGhhdCBzcGxpdHRpbmcgb25seSBhZGRz
IGEgbmV3IHBhZ2UgdG8gdGhlIHBhZ2luZyBzdHJ1Y3R1cmUgKHVubGlrZSBwYWdlDQo+IG1lcmdp
bmcpLCBJIGN1cnJlbnRseSBjYW4ndCB0aGluayBvZiBhbnkgY3VycmVudCB1c2UgY2FzZXMgdGhh
dCB3b3VsZCBiZSBicm9rZW4NCj4gYnkgdGhlIGxhY2sgb2YgVExCIGZsdXNoIGJlZm9yZSB0ZHBf
bW11X2l0ZXJfY29uZF9yZXNjaGVkKCkgcmVsZWFzZXMgdGhlDQo+IG1tdV9sb2NrLg0KPiANCj4g
VGhpcyBpcyBiZWNhdXNlOg0KPiAxKSBpZiB0aGUgc3BsaXQgaXMgdHJpZ2dlcmVkIGluIGEgZmF1
bHQgcGF0aCwgdGhlIGhhcmR3YXJlIHNob3VsZG4ndCBoYXZlIGNhY2hlZA0KPiAgICB0aGUgb2xk
IGh1Z2UgdHJhbnNsYXRpb24uDQo+IDIpIGlmIHRoZSBzcGxpdCBpcyB0cmlnZ2VyZWQgaW4gYSB6
YXAgb3IgY29udmVydCBwYXRoLA0KPiAgICAtIHRoZXJlIHNob3VsZG4ndCBiZSBjb25jdXJyZW50
IGZhdWx0cyBvbiB0aGUgcmFuZ2UgZHVlIHRvIHRoZSBwcm90ZWN0aW9uIG9mDQo+ICAgICAgbW11
X2ludmFsaWRhdGVfcmFuZ2UqLg0KPiAgICAtIGZvciBjb25jdXJyZW50IHNwbGl0cyBvbiB0aGUg
c2FtZSByYW5nZSwgdGhvdWdoIHRoZSBvdGhlciB2Q1BVcyBtYXkNCj4gICAgICB0ZW1wb3JhbGx5
IHNlZSBzdGFsZSBodWdlIFRMQiBlbnRyaWVzIGFmdGVyIHRoZXkgYmVsaWV2ZSB0aGV5IGhhdmUN
Cj4gICAgICBwZXJmb3JtZWQgYSBzcGxpdCwgdGhleSB3aWxsIGJlIGtpY2tlZCBvZmYgdG8gZmx1
c2ggdGhlIGNhY2hlIHNvb24gYWZ0ZXINCj4gICAgICB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNf
cm9vdCgpIHJldHVybnMgaW4gdGhlIGZpcnN0IHZDUFUvaG9zdCB0aHJlYWQuDQo+ICAgICAgVGhp
cyBzaG91bGQgYmUgYWNjZXB0YWJsZSBzaW5jZSBJIGRvbid0IHNlZSBhbnkgc3BlY2lhbCBndWVz
dCBuZWVkcyB0aGF0DQo+ICAgICAgcmVseSBvbiBwdXJlIHNwbGl0cy4NCg0KUGVyaGFwcyB3ZSBz
aG91bGQganVzdCBnbyBzdHJhaWdodCB0byB0aGUgcG9pbnQ6DQoNCiAgV2hhdCBkb2VzICJodWdl
cGFnZSBzcGxpdCIgZG8sIGFuZCB3aGF0J3MgdGhlIGNvbnNlcXVlbmNlIG9mIG5vdCBmbHVzaGlu
ZyBUTEIuDQoNClBlciBtYWtlX3NtYWxsX3NwdGUoKSwgdGhlIG5ldyBjaGlsZCBQVEVzIHdpbGwg
Y2FycnkgYWxsIGJpdHMgb2YgaHVnZXBhZ2UgUFRFDQpleGNlcHQgdGhleSBjbGVhciB0aGUgJ2h1
Z2VwYWdlIGJpdCAob2J2aW91c2x5KScsIGFuZCBzZXQgdGhlICdYJyBiaXQgZm9yIE5YDQpodWdl
cGFnZSB0aGluZy4NCg0KVGhhdCBtZWFucyBpZiB3ZSBsZWF2ZSB0aGUgc3RhbGUgaHVnZXBhZ2Ug
VExCLCB0aGUgQ1BVIGlzIHN0aWxsIGFibGUgdG8gZmluZCB0aGUNCmNvcnJlY3QgUEZOIGFuZCBB
RkFJQ1QgdGhlcmUgc2hvdWxkbid0IGJlIGFueSBvdGhlciBwcm9ibGVtIGhlcmUuICBGb3IgYW55
IGZhdWx0DQpkdWUgdG8gdGhlIHN0YWxlIGh1Z2VwYWdlIFRMQiBtaXNzaW5nIHRoZSAnWCcgcGVy
bWlzc2lvbiwgQUZBSUNUIEtWTSB3aWxsIGp1c3QNCnRyZWF0IHRoaXMgYXMgYSBzcHVyaW91cyBm
YXVsdCwgd2hpY2ggaXNuJ3QgbmljZSBidXQgc2hvdWxkIGhhdmUgbm8gaGFybS4NCg0KPiANCj4g
U28gSSB0ZW5kIHRvIGFncmVlIHdpdGggeW91ciBzdWdnZXN0aW9uIHRob3VnaCB0aGUgaW1wbGVt
ZW50YXRpb24gaW4gdGhpcyBwYXRjaA0KPiBpcyBzYWZlci4NCg0KSSBhbSBwZXJoYXBzIHN0aWxs
IG1pc3Npbmcgc29tZXRoaW5nLCBhcyBJIGFtIHN0aWxsIHRyeWluZyB0byBwcmVjaXNlbHkNCnVu
ZGVyc3RhbmQgaW4gd2hhdCBjYXNlcyB5b3Ugd2FudCB0byBmbHVzaCBUTEIgd2hlbiBzcGxpdHRp
bmcgaHVnZXBhZ2UuDQoNCkkga2luZGEgdGVuZCB0byB0aGluayB5b3UgZXZlbnR1YWxseSB3YW50
IHRvIGZsdXNoIFRMQiBiZWNhdXNlIGV2ZW50dWFsbHkgeW91DQp3YW50IHRvIF9aQVBfLiAgQnV0
IG5lZWRpbmcgdG8gZmx1c2ggZHVlIHRvIHphcCBhbmQgbmVlZGluZyB0byBmbHVzaCBkdWUgdG8N
CnNwbGl0IGlzIGtpbmRhIGRpZmZlcmVudCBJIHRoaW5rLg0K

