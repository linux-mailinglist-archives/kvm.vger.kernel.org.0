Return-Path: <kvm+bounces-15585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 540CC8ADB1F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 02:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B2722858F6
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9016AA1;
	Tue, 23 Apr 2024 00:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbQuSwiU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1328E8;
	Tue, 23 Apr 2024 00:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713832095; cv=fail; b=uT0ircyYmvNONCHWChDf8+OoxR6BNhebFk97bWanD3aUijyrRNER6avAd4Ps5EstC+Qi+6zuPDpP8iisS1DruVGXcj37E51k3cX/OpL5gmgmHQO80ZzZdK2ubdBEC29dLE+KqggyfY99yAvod/Q7WUqBqp/S0YH6ZN1uYeVbLf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713832095; c=relaxed/simple;
	bh=QyR1q3bXGapfL9SsHwIDCSzgGFd8XwOB3W1a8uBhnfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rUb6c8aVXDnRn465SdU5Fd+p7gGerf6B705YuXkxP6ICqky9ytvNNd0nJhuI3U4SXazovh7v3d7i3Cptc/gEnv7cXv3NwlVUX+1Bin0u2yntuGpiJIpjl8suOtBOlFCz5uVoSKkwTst9Oz1Ply2LIxI8owlTiTq2fMGqmbvrzKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbQuSwiU; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713832093; x=1745368093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QyR1q3bXGapfL9SsHwIDCSzgGFd8XwOB3W1a8uBhnfw=;
  b=nbQuSwiU1yDeOL/+Q4vLXPeM/peVZkUrPFqq+fjTynZeHGB1y4u1QBoH
   hZvUA/YCFQ9yNsTurZIjqXctgkRVY4mvJJzpi905oS9Xs6f6VuJsvmD7C
   DDwIw0U8ynMXkf8No8iG5vqSCzmTTYr5RGvbPOCdi8Zw1KyyNSjUXx4SW
   zp1ieZlx1z168hUwkXdce56YCZ+hy6MqezUQb2mCUrCglvC9JPCId+YAt
   OdTd1JpMqfJInxyRLtMeUnSg+EPlnZLA3ZELHFs9LsiqJjByy7nKmfSzw
   fhlfJ/ThR/4EHbqWEBnVA1wiSwoKSrbTLFrJAep5V96p/8gAl8Q710/a0
   A==;
X-CSE-ConnectionGUID: EJwy1mwGSruLUiD48ix5Zg==
X-CSE-MsgGUID: wPg+De83QWG8/eXaqen83A==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="19949856"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="19949856"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 17:28:13 -0700
X-CSE-ConnectionGUID: mxzXs5dzQ9eRpnoUiA4mlg==
X-CSE-MsgGUID: Q0iitkTaSPWb5o3mzy3sFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24630984"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 17:28:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 17:28:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 17:28:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 17:28:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 17:28:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7ArkwhSpOu/8wamt1hxNvMuAcrxMB9J638pm84+Q5fhksM6STu2Sh5XXB/zouQFhaqGM2unwWBfZOnz6QxRNmfsslSFrYBEW1QaWegw4Uw96VpYKuhR49RdvkSdCKqJ4Jj/GAzwEmiLN3UMhHfMjif/518KRI+gfotv0+3f2JaJh4caG91JkwmkoJSMDnPkzEhnhfi/aF3I7h+N/snZbQnkz+I2g/X1INShNAbgII1x6QMl0mX+FSXo4ws8GKIwKd9kSp7zV8UlcNfDtE7uIWCFhLXmYAR8Wflf4Ez276Fws4fKrpyc3Rd7fG9wygaCQ0vLyTYu9yEVU4QsOdwySg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyR1q3bXGapfL9SsHwIDCSzgGFd8XwOB3W1a8uBhnfw=;
 b=XF/REjnXVIwTORx01XkoB45sr890CrUSC0YR3fiWxGECxZ+FCHMaa5Bynlw1DpalNPgDIunRA+53rOZumo6AHG4eL4/v25LAdHo7ltZXfMB6HpTDweHGa/W6aH/6yyb7pC1aTYw40Y7PQyOkhwDNwRt9/gi0XWfyp0RZOFkBbTeWdOhrqGJKXYnFvmHC1hPIvmTyZ8VxZgak+aTR6r/ZMLT/fu3Jzmhl20Ny8dod7NEqMXzh5DKSZXATuUC2qNOqRz+cTu3TevdD1FMwZAsx02XbsM4PppdtG7e1Es0OjDZl4/WFUNOla5+3I7VNWUqPdrKRm9oz1qtfFBLMH6yJ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7275.namprd11.prod.outlook.com (2603:10b6:610:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.17; Tue, 23 Apr
 2024 00:28:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.020; Tue, 23 Apr 2024
 00:28:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6ribE4BK4AgAD7XwCAKJ4bAIAJ4iGAgALItgCAAEXagIABVNMAgABY9QCABCvfgIAARcaAgABBd4CAAE2IgA==
Date: Tue, 23 Apr 2024 00:28:02 +0000
Message-ID: <7cd0743a250fdb2b5c89fd092f8da36b9f4393c1.camel@intel.com>
References: <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
	 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
	 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
	 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
	 <ZiFlw_lInUZgv3J_@google.com>
	 <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
	 <3290ad9f91cf94c269752ccfd8fe2f2bfe6313d1.camel@intel.com>
	 <no7n57wmkm3pdkannl2m3u622icfdnof27ayukgkb7q4prnx6k@lfm5cnbie2r5>
	 <ea77e297510c8f578005ad29c14246951cba8222.camel@intel.com>
	 <Zia_hxSH1p_8qB8L@google.com>
In-Reply-To: <Zia_hxSH1p_8qB8L@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7275:EE_
x-ms-office365-filtering-correlation-id: fd732996-d29b-4fc9-6cae-08dc632c3c4c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bFRuYjluL1BtVXB2WWhiM2I5WkdhakFPOGlUTUR3VzlaUmhPeG5HNjF3NHNK?=
 =?utf-8?B?MDBEclpWUzlDcldYRzZ3Y1Q5a2RCWHZuME9TbTZCYUMyQWc2RjJCa1l5T2dP?=
 =?utf-8?B?bm43QXozQVJ6L0ZaRGFSZG1sYWx3bkdpaStDRHNDaVJ3ZjBIWUYzTHRnQnQv?=
 =?utf-8?B?Y0xFUmNVc1NsWE5CeE9GdnNLaE5JSGxNSTh1b2lZU0xXRG1FaXhqWm41bW95?=
 =?utf-8?B?SUVxRDUyVHZidlVvRmZBR2VzcjhJeGx3c3pNQkVOTVh3QlFLVW90b0JZcmMx?=
 =?utf-8?B?RDNRSTFOeGdwUXI5TU9qcE9SZGJOL3dSOVpGa1Ard1h4bEw0YmlnY0tNSXpx?=
 =?utf-8?B?TDYybmFYUzZQTUV5Z2gwMnVkL1hMV1pZeUlwWkoyQ3RmZ3lrV3ExMXRTQTd4?=
 =?utf-8?B?bjhiNHhvOFc2Q2JuZlBGMC9STnNwOVNxdEhwdVkrckliVnZDR3ZMcFg1WVpn?=
 =?utf-8?B?ZHZHSzN4dlpxbmFIRU1JOVJYTE9Uc2lvM0plSHl5dy9YY2lRWFppcEZQM0FC?=
 =?utf-8?B?Tk9wS1IxNkNlRGNpNzFSb0k4LzFJZG12cVBYTXhQTS9UanFQdnhFNWxvQVlr?=
 =?utf-8?B?OGprTWlzZWFNcFdkNXF5Y2pZVk9LcDBWRW5FUkhKS0RCRnlVZlQvVmtFdGlK?=
 =?utf-8?B?ZU1za3VwT20zQ0ZXc2VsVXU3RXZNQnV3ZWlZdWVhUGFZMEpRUG96anh5UGYr?=
 =?utf-8?B?b0NqalhBMmF6cDB3R0RwTTczU1VISVd4aENxS1FacFlMd29ielUrd1BRV0Qr?=
 =?utf-8?B?bnhncmN0UERhak4rTGEza25TdXpnamk4a2I3aWdXT0VqaTFaRjBVUjhsaWZw?=
 =?utf-8?B?VkJ1S25NTDRZYWhoOTJKSlQyQVI1U1Ruc1RIQ3hJaUo5dXFWV3ZQN0VyWjd0?=
 =?utf-8?B?RWRjQmhDM1NBSnZoK2lZSU41aTI0VVo0YWdaWGJsS3ZIckFJRGhhVUIwZ0xt?=
 =?utf-8?B?RVJaNnVvLzc1L0xiWVRnQlplSVJFTUhubHh3YW8zNmxYWk04TXl5RjU2RVFl?=
 =?utf-8?B?TUVDMHZHRHQvTE9GemNpN1Y3TlpQdzNYZVh0MFV2emdyRmM3MzlReXFONWNN?=
 =?utf-8?B?L1hOVXBlMXAzU2o5cERZbThRd1VVODRXWFc5bExRY2dEZVJydlJoZlZzL2hI?=
 =?utf-8?B?Sm40Q1pTMEFGR05SNFdlcGw0VHhDaGVqakkyQ2tDVHdnR0M5MzdKa1Yrc2pB?=
 =?utf-8?B?U2htWlp6YnRWSERSWmEwKzYrZWZFKzFvSTNGUTJpSlViNWxnVHhxdHJDb045?=
 =?utf-8?B?L0JqQzd2S2RaZ3JGdnB3UGZXYmkzVjhaV1k5R0ZERHgxVWZXTDNOSGQveUN0?=
 =?utf-8?B?ZXdmNFpYeVdQSU5Md0ZnUy95NHRBVG5VZGx4WEREL2JqV0EzNmg4YjUwdSsy?=
 =?utf-8?B?UVVJV25wb3JKNEVrdXNTUU4yTnV0QWtUN042ZUJxaDB1dlA2OFFPeWtwczVq?=
 =?utf-8?B?NkVKZ0lQTFRpczhaWnFsYk5uTFpqYWhRMkMxekU4RmNoNjNrU29hRHIrK0Qw?=
 =?utf-8?B?MGErZWRnckdGUkZaY0M2REpwVXgyM2UrdERQTU45V2VTZ3A0OE9PSEVHOUdu?=
 =?utf-8?B?M3l0T0VkOTVRR0MxaDlTbm5iU2F0SUQzQTMzZ01sTnh1YkFRWHI5cUYzNzZ5?=
 =?utf-8?B?SU1CUVhXMmJ3UkZBNHpFWlpOeHlINm1yeTV2VHoreUh5WUZBMlVTUWJNSE4v?=
 =?utf-8?B?ZUk1b0JYSkowTWQ0Lyt0dThUUWxTVVlIcTFnN25tVFlOUTltNHhNWHJkSGpC?=
 =?utf-8?B?UW1qNnlNYWtVb3lOTHFvZUFQTlowTUhqSGtnZUlRamlPK3RCNzRhWXJXRDJW?=
 =?utf-8?B?WXlwK0ptQjc4OGFyVmMzUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bE1oeFR6V2xrZnp0Z2w1cVh3eXVKcGpxL3dSWnNsTUlSa0FmbHRyYmtvemZn?=
 =?utf-8?B?c2pSeHhiL3lqU01BaFdQanlPbTYyWEZDcURSd0dWY2kweC94N3drU01yYmV4?=
 =?utf-8?B?VXRHS25Qb2R0TE5jTWlMa1hxemNNTEVWTksrUVNJK3JGVG0xWUYxS3RwN3l2?=
 =?utf-8?B?WmNUejYxbDlvaHhoeXR4c2tpU29vc1N2enE3SVFjWWUzY1BLYWJMcHAxM0F2?=
 =?utf-8?B?Z0dKRSt3cW82dnc3c2oyL0RRUmxGTmt3eSs2ekhBdkQ3YWtDVGNXaDFQNHZh?=
 =?utf-8?B?ekhSS1hQWTZ6MXV5Q3JBTmNJdmhKRnFSYkdqZ0lUYU9ESjB0eVYyRy9rb3FH?=
 =?utf-8?B?SnovY3loV3J3NGRBa0pDMURWd0pOOGRUVFZrTXBXTytMVTBzQ251QU5GNEZ4?=
 =?utf-8?B?dUord3dJdzJCQjBzQ210RVF1eE13SFJ3a3JhK1NWbVJyNkZtVVRCSnNtMkZB?=
 =?utf-8?B?dTVlTXVySlBIRHk2R1R2d3JUL3BORVA5QnBHdmpUWVUxOVBHWW54a2ZsTjZs?=
 =?utf-8?B?TUwzVlZBSWorYVViYWRST2txVGQ5ZlU3Vy9GUzN4ck80enNmVzd4RmtCaGp1?=
 =?utf-8?B?aFJsTkZXWHBzeGJuYmVscm1WM3lzQkRPL2pNdFZ4Zms3T1U4akYwV1kyU0lT?=
 =?utf-8?B?bkt4MHkwVDZ6V2liOG82YnRoMTZZQndRMGsrWTAvUzA3NEhIS1VMSkdsSXAr?=
 =?utf-8?B?VkpvU2hMSHZnaWlyRzhTRy8wa2ttN3UzSXBxbklod3M2VmxtZG1QYzFacUhu?=
 =?utf-8?B?YW1GVU1UeXdaTTIyVEs0RmNpUFIvME81OUlUaWtUUHhXaHN6eDdvS3hIYXVs?=
 =?utf-8?B?TjJLRFdkWFIydzJ0M2ZQTGFKaW1TVGpYeU4yTUcxNVcxckhsZC8zUGVTYmdP?=
 =?utf-8?B?aEVKK2RqbHp5cW9Jc0pjTEludHMrbG1IUm1SVnJqMTl4UXlIanE0TS9Ld0tL?=
 =?utf-8?B?cStndjdzU2xsYUx1THlJeDdJdFBZRVdQdlFmYkRjRUpRcDhFSVhOL2Z2WmZ6?=
 =?utf-8?B?L2poSndDN0Z6UUl1OC8xUXRMK2dxUTc4NGhxT2FuTWJZUkpPSFBoamRuS0Nx?=
 =?utf-8?B?bU9ETTZ0dURqV1dDMkJ1anIvajlKdVZuS3hkMG1uQUp4ME9hd1JsckJOdEVy?=
 =?utf-8?B?a3QvSXBlbUNhYVdnamFoTjFSZHh3Z09TU2ZPOHdJRFo2elNWR011YVkvMFdm?=
 =?utf-8?B?NDRoQWhIVDVSbjRoclgzUDZlKzFFQjhTdDlCRm5zdTJld2hhV0xvWS9YbGsz?=
 =?utf-8?B?Q3owU3QrZW1kdTBBSG1IQ2cwWHRMWDBtWk5tYkZENWg2eFVQcEU2WitRRmJ1?=
 =?utf-8?B?eUJaMEZiL2owbkYrc1NrTCtrTXZyemFPbUU4bGJZSTRYSmtkajU5SVFhRnk3?=
 =?utf-8?B?ZFNCREE5OEd4a2l0dGFrQnFyZGlwTXcwdUdGRVF0U0FIaEtxb3pNYVRRSzI3?=
 =?utf-8?B?S0V0THkyYnRXQ01ORUIxdEwzN0tkeEtxWVg0VC9FV0s5MDU5VzJhNk9vYlNL?=
 =?utf-8?B?a3NYaHFxTzB4cUh3V2cvQzRlNW9uZGpQRWpsS294TVlUSnA1K1dDS3N0dHQr?=
 =?utf-8?B?Z21ERkxTY1VBQzc4Q2g2MGNSdkgya3g2VXQ3ajRUSkl3SXpTRHRsVVQ0OXk4?=
 =?utf-8?B?VzJjaHZiaGc3QnVzcHYvdFpxV1d2MWJYVGwxRldxRWhWWkthOWhRYnBUTTBM?=
 =?utf-8?B?SFN2OWp0eVUzVmc1V0dLcDB1M2dWeVlnNmh5TFpJNmNoWEh1WXdrRmlPRllU?=
 =?utf-8?B?a08zQ29sY1prQjJoOXptOTNLWExyM05IdmZwY1FSc0ZRVnl6YldhbnVBQW9T?=
 =?utf-8?B?TkVnT1o0MnNxRS8yNC82SHFNaXFJUUpTcUFtSDJBcVhmdlNpYi94b0t5ZXZT?=
 =?utf-8?B?WWFVK3grNVo5dHFVc1ZoN0RkZGMwNWUwc0N5dnMzc3BlMndRejZuRWRjK05i?=
 =?utf-8?B?eHk0RWgzVnV0VVN0RWFjRDU2bXJ0VWoySnlKUFNpNDhXa3FiNE9NcFZ5Yi9U?=
 =?utf-8?B?OTd6M2F1SlRHYWpneGdiUUx0dDlnSTJGb2QyQzZWT1MvV0pLM2xGcmVjWlEy?=
 =?utf-8?B?TTF4b01EMzZJYjltZkRIclBkWVNqUHY4cXlnTGY2N2M0L3VBNW11TmZvZ1FY?=
 =?utf-8?B?TUZnMUZaVnFSK3d0cFVUTGgxTGcyL0d3cHU5MmJyNUV2dGZDSmVHZWFRT0py?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F74B2F30E5866A408EDEE74CDA8A85CF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd732996-d29b-4fc9-6cae-08dc632c3c4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 00:28:02.0521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8dBfImPNopY3EeY/5yPNRe58nuG12W1ijANoK76iE36Qr2T645FO91FHs46WKaiW4NbOuhwkoENENaM6IvGzP3ea4HiSB4QkJ9wglur1fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7275
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTIyIGF0IDEyOjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGUga2VybmVsIGFscmVhZHkgZG9lcyBwYW5pYygpIGlmIFREQ0FMTCBpdHNlbGYg
ZmFpbHMsDQo+IA0KPiDCoCBzdGF0aWMgaW5saW5lIHZvaWQgdGRjYWxsKHU2NCBmbiwgc3RydWN0
IHRkeF9tb2R1bGVfYXJncyAqYXJncykNCj4gwqAgew0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKF9f
dGRjYWxsX3JldChmbiwgYXJncykpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cGFuaWMoIlREQ0FMTCAlbGxkIGZhaWxlZCAoQnVnZ3kgVERYIG1vZHVsZSEpXG4iLCBmbik7DQo+
IMKgIH0NCj4gDQo+IMKgIC8qIENhbGxlZCBmcm9tIF9fdGR4X2h5cGVyY2FsbCgpIGZvciB1bnJl
Y292ZXJhYmxlIGZhaWx1cmUgKi8NCj4gwqAgbm9pbnN0ciB2b2lkIF9fbm9yZXR1cm4gX190ZHhf
aHlwZXJjYWxsX2ZhaWxlZCh2b2lkKQ0KPiDCoCB7DQo+IMKgwqDCoMKgwqDCoMKgwqBpbnN0cnVt
ZW50YXRpb25fYmVnaW4oKTsNCj4gwqDCoMKgwqDCoMKgwqDCoHBhbmljKCJURFZNQ0FMTCBmYWls
ZWQuIFREWCBtb2R1bGUgYnVnPyIpOw0KPiDCoCB9DQo+IA0KPiBpdCdzIGp1c3QgZG9lc24gaW4g
QyBjb2RlIHZpYSBwYW5pYygpLCBub3QgaW4gYXNtIHZpYSBhIGJhcmUgdWQyLg0KDQpIbW0sIEkg
ZGlkbid0IHJlYWxpemUuIEl0IGxvb2tzIGxpa2UgdG9kYXkgc29tZSBjYWxscyBkbyBhbmQgc29t
ZSBkb24ndC4gSSBkb24ndA0KbWVhbiB0byByZW9wZW4gb2xkIGRlYmF0ZXMuIEp1c3Qgc3VycHJp
c2VkIHRoYXQgdGhlc2UgYXJlIGFibGUgdG8gYnJpbmcgZG93biB0aGUNCnN5c3RlbS4gV2hpY2gg
ZnVubmlseSBlbm91Z2ggY29ubmVjdHMgYmFjayB0byB0aGUgb3JpZ2luYWwgaXNzdWUgb2YgdGhl
IHBhdGNoOg0Kd2hldGhlciB0aGV5IGFyZSBzYWZlIHRvIGV4cG9ydCBmb3IgbW9kdWxlIHVzZS4N
Cg==

