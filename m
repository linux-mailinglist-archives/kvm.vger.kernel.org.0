Return-Path: <kvm+bounces-56357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E53B3C24F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972801CC3EE7
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 18:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21E333CEA9;
	Fri, 29 Aug 2025 18:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GPbchwat"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7374D77111;
	Fri, 29 Aug 2025 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756491408; cv=fail; b=a2c+DN687h378tW7cubVgB95jqQHTcI8vXKaCOm/B1HPBgK1t1uM4i2n9mMKPNmtLZbOaZC1tMkmk+2ecdcyFsr0m7DwgBct/PIKCz247rljnRoZnUs/GtBU6RYrc3ZK9hA9lCkkk6t/37Fs7eXQ7K9TPrBV7l/wNOgb9zpngfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756491408; c=relaxed/simple;
	bh=MnNCqAgfl6lwy/l1NTILYyM1OoICQEIU0zNZRwIZaAE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IDEYcY0Dj0SXzGDlxLoQay3qY7KYVXUguDKPoaGvaog4VUawRiMzT6zQDh0jYL9F+2m+wq4SAIGjstzWEIgLAHiun71lkVPk6I3GL5bbiotIQot/gdLoPjnUwhoZSUoMXsaGWIuF0mYUun6mSjkUygT71WXvR+wUF7koS3IA5Ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GPbchwat; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756491406; x=1788027406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MnNCqAgfl6lwy/l1NTILYyM1OoICQEIU0zNZRwIZaAE=;
  b=GPbchwatdl8P/zebddLTBy7MRMu1kbsRe3KIDuJZ7XfdLw4PwRr3eH47
   1EPg/WsQI6lpG9roIR5SWSqe22PgyIBpLfQ3JYO7/Bt7MiHbTTfCVodp7
   SnBiHf8LrF/IingcGrfGQYZuzbD761HBavkwTqTUbOvLIq16NMy/3Ly95
   6JZWmmzbeaZOLVQ3/ZiXDuj9Bd+v9WUwED5jkCyz5Xy1B0YLFyshS3G7k
   bnYCjLdbCFSHDGZBAD17RJtorhe7gepbhzCzTx8/NbPgVMtclGzj/MGJJ
   mHo3yLQ7oSDe8R1uxA/aZ0NlkunHnFn5FaQBYpDsr6nG7FylC/Gz75/63
   w==;
X-CSE-ConnectionGUID: tmYpZtG8TUue3Qv7sRJ2pA==
X-CSE-MsgGUID: VLkyKXB/TpuO/ZXe4vsCpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="58492676"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58492676"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:16:46 -0700
X-CSE-ConnectionGUID: FiZscq0ZRoKTLmDElhyphA==
X-CSE-MsgGUID: pjPVHKouTpSpYiE5dAsCeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170824287"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:16:45 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 11:16:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 11:16:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.82)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 11:16:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HsLx8BNup0o4GBNDxSBD7mm0ImGAPSY1JU7QYs50VHDdevTAVb/SDISe104famxiePNFtqGWOb6+WWhuG1fgvx/LioqEozTIIyKKPtEPiY7oLnZDr6qw5kbnHMFVRHIUiZ+WEWqEbv45JsTJvF8E4M1/l2Oa2M7TKNT0WX0030NCh1DGCBvnz69AexkRXzLIZiCg2KqD+fqdbyJJXLiZQiNiFTC8v8WvdAV+RFJC2xtoySlohR2BWKyuSp2gX+P1o1WEtKZ3dTA4IEWFYTajlKpU/AyTEnrzObctdWimlApAz97Seyw1HrUSTYDKCEuiTW8Vfcj9ySbIKc7J6fQeSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnNCqAgfl6lwy/l1NTILYyM1OoICQEIU0zNZRwIZaAE=;
 b=nMabWaniqLZHjJ59zSV0O3ypLmB1LKLNYbhWz03N2Id3PlKYi06qvbPWr0JzYMDqMge2DOCn+TxcAI8sE+8xztBgH333Lq3sSWqznCrT9TU6CuOpGyJqbwL1GHZ+Qq9LdnzCC8X8WYWuET9RZjGqIME7VSbPr1puqePQ8lu0aqx/cStxBIMQ6pyG+gPlM2hPkAnjHxS/KMycCVFuTjvzSkesWYrmhDkdz6rnZ0EmRh5Tbjl3UFDjVdq5em0xmSDX7jXDrqT2GW4ifkBGETiRIid07MOSoby3bYD/ct5fZWK0MDQgIVteFywTXneZiQ0ePJ2bmIpPXk4ASZzqX3PpEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6219.namprd11.prod.outlook.com (2603:10b6:208:3e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Fri, 29 Aug
 2025 18:16:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 18:16:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the initial
 measurement fails
Thread-Topic: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Thread-Index: AQHcGHjSRjNmRiPKf0OfM3rq5B2s2rR5SfIAgACnMIA=
Date: Fri, 29 Aug 2025 18:16:35 +0000
Message-ID: <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-13-seanjc@google.com>
	 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
In-Reply-To: <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6219:EE_
x-ms-office365-filtering-correlation-id: b7179f51-8f8c-4b21-3f39-08dde7283067
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SEVuWnV1VlZuc01oR2FIL0ZGQWNzU3RBbzRxU3VKbGhtNCtkUHdvNkdkM2l4?=
 =?utf-8?B?WlRwV2JGbTErVVZKYmliWHpmTFRtcUhmdWJVTUVIbGRRczVkT2drRC9iTjdi?=
 =?utf-8?B?MXBJcTBkOEU5by9RcGdmSmZCKzJZczluTmdPQmt5eTB5V05oeEhEZjZ2ZHFp?=
 =?utf-8?B?UGp0bnNFcjA2cGZHMjZxL0oycE9vdDdMajlWUDFLaW5rZlVpMEJ5R0tCdGFa?=
 =?utf-8?B?QVpVTU9FZWYxMWlhdGNOcEs0OWpmTC9kWEJ0aGt3WGhnamhXdWhobERSZ0V4?=
 =?utf-8?B?ZThkV05xOUxoU2VLd014SFJySGdPS1hVWE9PWXhxL0hPRC9EOVZHK2svbm9F?=
 =?utf-8?B?VURiWUQvWDA4Q1pUZmxiQkFaeGIzQmpCY0lJUTRpKzN4blhFc1VLdjg4eXcv?=
 =?utf-8?B?QStoK1dkQ3BBY244QlQvZlY3UkpZMWV2enE1aWVOS1F6U3duSExwSmpxMWEx?=
 =?utf-8?B?clQzV2NZRFQ1b0FPRlI4VDZQbVhhM3NEVjlSVGJBTlh5Wk9nbDVqVzR1UlJl?=
 =?utf-8?B?OGt6YjNmanZZdDd6dlVQaGJRK1ovY1dtTWhwZlV3ZkNlV1A3MWROZWxuczJp?=
 =?utf-8?B?NlY1VDlldzkvbm1peFQvc2g3TlRkWVFodnBlQTVkZFF3UndFWnZhLzdZOWRt?=
 =?utf-8?B?SjgraEV3RW1xQWdkZE5TV0tMQTU1Sk85bmdqckRWdktFc1ZPb05UMkN1VW1C?=
 =?utf-8?B?QnphSlJtTVdZaElRV1lGTHNvb1FpTzloMksxSjA5VU5MV01jcG54dElWTGNS?=
 =?utf-8?B?UmUxdzJva0hTbHV3SlRtS1hneWx4T29kVCsvRERpSjJXeCtMczZ3OFBBeU9q?=
 =?utf-8?B?cHQ1SDdiVkxiL2cwUHdiZWRLekN3SmR0akdKQVcrdlZiS0pyenpYNjM2cnR3?=
 =?utf-8?B?cjlGdWh6Vzl5S1o3aGQ0eDQxRXA0UmRXaVNjWXBSWFpZbkpZbUJuWWRaeWlw?=
 =?utf-8?B?WEE0QlZTVzZNUlVjR3FiM2x2TUxDNVgxRUZSVEpPYnV6L0RrOFdwVGh5Tjhv?=
 =?utf-8?B?Q3Q4WE5qSVdsMVpUaXI5RFVMRStvSzEyMjFFWVk1dmdLRDBsdi9VNkViNWNI?=
 =?utf-8?B?UGJFWUVFZG5vUHFka0JpSjRrY2NwYzRWNGZXK2tmUXRhZ1hkUGpJWlVVRHZU?=
 =?utf-8?B?bSsxNDNLUTExU3N3bjlhaXdNTGtDNS9iNHI4MXZBbDdEM2Fmb1ZqVXYzN2dM?=
 =?utf-8?B?bGtDVCsvYjkzT2JNQlZhdHgyU0VhbExTYmpaVHBWUXQrK1VUbGJLaTdaSDFp?=
 =?utf-8?B?NldVRUNUZkJrRzRUZ2dadXhZNmdMTzVtckJSbDN3L2R0N0JZaWxQZ0tWcDdo?=
 =?utf-8?B?dlJZTGQyY2ZXQ2NabUVjeHlJZ20vZDR2ektBdGRrUzEwSi9rZ25CbWZLQUl3?=
 =?utf-8?B?SWZtYVZrRW5HQ2xOMFVzdHlXSnBhOEc4cnFEUXdCQ3lvdEpZMUVIZmNWd0lm?=
 =?utf-8?B?bWRJQVlHMEZlNHRzOXJCajlrM2c4SVpqMkw5aGJPdkREUTkrVEx0MjZSOVBO?=
 =?utf-8?B?UGFXRmJvZTAreWFBMGtkRFhBYyt6MUNxbnZFVkIyUGFwNnFiWUM3Q3FFWnRV?=
 =?utf-8?B?UUZWekVBNElBVWtUY3Jid2UzS0ZzdjdtN2RhaTVIRmtXWENSbG5uQWdUR1A5?=
 =?utf-8?B?QWtOcHpKbXVQbmNvMUhkUlRYMW9PS1NHdGgrcERyMHptdmI3MVZUOEs2RnJl?=
 =?utf-8?B?Q2RFNERwazZwOUNuY04wS0ZYSkZFejRRR0pxVlliVjA2TlJETnlxc0doTTlJ?=
 =?utf-8?B?UXkyRlpha0NZMEM0S2UwR0lMZjJvVHZld08rYmppSVN0d091aUZmVzlSSHNz?=
 =?utf-8?B?WFdaTHN0S3BEN2VpZkhBZHo4RWsyNmp4TUxKSmJEYWRja2EyMll2Lzk1RjBI?=
 =?utf-8?B?VTQ4V0J3eXBPTWFvMzRxRWlxT1o3Z0JHUnM2ZHBzUnRaU2wreFZzc1drRGk5?=
 =?utf-8?B?YmFuZkNhUEVHOHk3Zk1OVVhTemZaZmwwVWtXdDAyK1VSTUQzMDNRVG15WE9a?=
 =?utf-8?B?TzlPbzhRR3hnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTA2cjRtdndQSWFqaWJKT2RRMzByWGg2OFNOWVAxSlRxaGx6emhTc2NVbm92?=
 =?utf-8?B?OXVXMGNCNkhMNG9VWVhqVDRCUWxtV3luNkJINUc1bWU3OG1COFgxY3l5eDV0?=
 =?utf-8?B?TEhHajg1SllFblRYS01vVFVFZmdlQzUvSGdiaXl4dEVibHJ0MU1UYVpmVFRz?=
 =?utf-8?B?TENrcWRBY0NYcE1FbHBXU25SZUJsK3hOMWZvZXY3S2RqMHZxdll1R3JGanNz?=
 =?utf-8?B?bXRGZTI3dklINWxNVDZpcUI3R1paQkk0b3o0dlc5MVYyd3c2b1NxRlA2WTM1?=
 =?utf-8?B?NWV5MWpTYzJ2QTNGODdvMW5nKzI1K3BvdHZOM0JGemM1N0svc0NWclJpZmhT?=
 =?utf-8?B?eVQ0ZkExZ3Zrcjl6N2lkQzhxV1FhZW5SM3JGOW1EbSt5Mjg4eURhbDRseGQ4?=
 =?utf-8?B?RE9FN1hJSTE3TUxWQ1JYaVhzMnJGZWJOM1BWT2xIaUFoZ1RWMXo3a3UwWndC?=
 =?utf-8?B?SzZoSkpMb3VhZWtzTWNKaGRKdFR3dkI2MENXeUZyOU9KYXdKZXdodG9aakRv?=
 =?utf-8?B?em9lZ0VPQXB1Uk5WQTBNQVZBUHlMaE1NL0xkNzFlaXhZanRKT25naUFtSnpM?=
 =?utf-8?B?d3pEdTVrdjI0czA4RTBHZ1hJZ3pxc0FsaUdmQ29PK200RndhZnF2Ly95aHdL?=
 =?utf-8?B?RWxSWlZ3MEIxT0Q0N0N2NSs3TEw0eEE2WW5vYlppblArUnk2TTA2VXo3RUNm?=
 =?utf-8?B?Y3FvVmtVL2llMEpsZnJwS0s4Y0w4cDFTL2tKTjZneHVTZ2RhcVdjb2dqSnlN?=
 =?utf-8?B?UGlZYzBQKzJ1UXBMamNTckJvK0Q2SDZuYlI4aCtMS0RYdFhJenUxMkJVZzF0?=
 =?utf-8?B?WkxFSXhoQ1BWYnFLdEpFVFRoblhwOXFHcUNpNDFBQUFCaG96UE1zWXhpM05q?=
 =?utf-8?B?amRqV2w2WUpGVHVVajRycGtQWm5OWC9MeUxHYlgxbExqMytRTk1DbFY1REZy?=
 =?utf-8?B?MFlaZ1R6U01BOTZ2NmJYTFMySDZ0d3VUZnlGT3dSeWs0RFprRXJod0NMZVJy?=
 =?utf-8?B?bE01SVgwVG1MeHM0Ymdsc1E5UStVZndvUGoydUZzK2tnOFhtL0M2SXMxQnlM?=
 =?utf-8?B?TFVmTCtic0Z2WDhpR2FRTEVheGdFTzF4b0FnS09UN2ZBK1g5eFN6MWJ0Mnhp?=
 =?utf-8?B?TmVxeGdXRndBUkN4alNWOERwTndoaCtoL1B2Wkp6RmMvTUtqTHlMUGhXVGt5?=
 =?utf-8?B?anhuRk9JbGcva29SYnFSQ3NrdmRpU1I4NC9xaVRXWFVXbHZxdCtSYXdmampm?=
 =?utf-8?B?SDVVTE9STjRyZWR0YVpFNTVlRHNxTTl1QWs0VkptR2JpSWVDbllRTXFHdXNW?=
 =?utf-8?B?UXZrWDRYSW1FVE01dC9scEVlM3lVS0hPcm5KOWpjaUVnQncyYXh4WGp5aGsv?=
 =?utf-8?B?VmhtY0NHT1JicUZjcmJacnRGd1daK2ZId1c1K2ExUnVnM1EyVFZjNGdEY2t3?=
 =?utf-8?B?WFNHNnpvNXNOVUtWTHI2TWN4c2tXbmZlc01LYTNrdE5Zck9LRG1Ya2pIVXNK?=
 =?utf-8?B?a05XY3o1WU4zU05XV2RjZXp6c1cxYTdWYWtoTjNHUnVrMDRpZnBLeDE4elpv?=
 =?utf-8?B?a3FXV3hkSHkwRGVreXB5a1h6cTJmSmNJVHZtQ05FRXVwYm9QZlpxWm9iRldR?=
 =?utf-8?B?d0FoemdpSXFNVDVvTFZEMDkwa2krOG4yZE9IQ1dEd2Z1UHcrYnJZdEVHRlE4?=
 =?utf-8?B?OXQ2UzN5N1dZUlNmYmdDWTlVbm9xWWVERVBKZmEzQ1VxRjJWZzlvdWFNc0ZU?=
 =?utf-8?B?clp1cXZBNDRCQlRQWVpiSzBqRHRRUnBTMnpIUDdQZ3Y0eXZab0Y5MWdMWUNT?=
 =?utf-8?B?dlJyL09uWVc1b0s2UHZpK05wRURiUlhhWFdQR0xjcmVzSnZ6TVJOSyt0S2Za?=
 =?utf-8?B?c282OGdmbk9FQXZaUXZvUnF0Z3UyUmkxNGVDbzdmODIvMW05SDZ0R2xFbmd0?=
 =?utf-8?B?cUsrWVA2SHVESnpsSG9PSmtOSFR1OUNzQStWZVFnNStjaGJRM0VFd1hJaW5R?=
 =?utf-8?B?Z0xXY25kNmw1V1paV0g5SjNwczlwMmdkYnd2dTh4Rzd4VjBkUWQwZWVmSEhU?=
 =?utf-8?B?SHdlckRTU2VGaHJhWGtvZEtsODFxUXlDZlRWUEdrc0lVZHZCdi9YUS9jM3Zh?=
 =?utf-8?B?VmpxV2dETEpVNkZuazNQajNQc3R3dnB6eVZrYjBsQ3VDSkZjQWF3MmpWWmdE?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F717D5C8EE6E3844A7561D5A58BB17C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7179f51-8f8c-4b21-3f39-08dde7283067
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 18:16:35.3219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGTo2Cc8YAnrtgg8YxkwRsvBvu/BXkMCo9OI+rv1LSr3ukWZnJzk8N1ydxJdEme4VFDLYmfh1ZepyHucArmkn3nvCtsDdl12UqkZOLfEtTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6219
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTI5IGF0IDE2OjE4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiAr
CS8qDQo+ID4gKwkgKiBOb3RlLCBNUi5FWFRFTkQgY2FuIGZhaWwgaWYgdGhlIFMtRVBUIG1hcHBp
bmcgaXMgc29tZWhvdyByZW1vdmVkDQo+ID4gKwkgKiBiZXR3ZWVuIG1hcHBpbmcgdGhlIHBmbiBh
bmQgbm93LCBidXQgc2xvdHNfbG9jayBwcmV2ZW50cyBtZW1zbG90DQo+ID4gKwkgKiB1cGRhdGVz
LCBmaWxlbWFwX2ludmFsaWRhdGVfbG9jaygpIHByZXZlbnRzIGd1ZXN0X21lbWZkIHVwZGF0ZXMs
DQo+ID4gKwkgKiBtbXVfbm90aWZpZXIgZXZlbnRzIGNhbid0IHJlYWNoIFMtRVBUIGVudHJpZXMs
IGFuZCBLVk0ncw0KPiA+IGludGVybmFsDQo+ID4gKwkgKiB6YXBwaW5nIGZsb3dzIGFyZSBtdXR1
YWxseSBleGNsdXNpdmUgd2l0aCBTLUVQVCBtYXBwaW5ncy4NCj4gPiArCSAqLw0KPiA+ICsJZm9y
IChpID0gMDsgaSA8IFBBR0VfU0laRTsgaSArPSBURFhfRVhURU5ETVJfQ0hVTktTSVpFKSB7DQo+
ID4gKwkJZXJyID0gdGRoX21yX2V4dGVuZCgma3ZtX3RkeC0+dGQsIGdwYSArIGksICZlbnRyeSwN
Cj4gPiAmbGV2ZWxfc3RhdGUpOw0KPiA+ICsJCWlmIChLVk1fQlVHX09OKGVyciwga3ZtKSkgew0K
PiBJIHN1c3BlY3QgdGRoX21yX2V4dGVuZCgpIHJ1bm5pbmcgb24gb25lIHZDUFUgbWF5IGNvbnRl
bmQgd2l0aA0KPiB0ZGhfdnBfY3JlYXRlKCkvdGRoX3ZwX2FkZGN4KCkvdGRoX3ZwX2luaXQqKCkv
dGRoX3ZwX3JkKCkvdGRoX3ZwX3dyKCkvDQo+IHRkaF9tbmdfcmQoKS90ZGhfdnBfZmx1c2goKSBv
biBvdGhlciB2Q1BVcywgaWYgdXNlcnNwYWNlIGludm9rZXMgaW9jdGwNCj4gS1ZNX1REWF9JTklU
X01FTV9SRUdJT04gb24gb25lIHZDUFUgd2hpbGUgaW5pdGlhbGl6aW5nIG90aGVyIHZDUFVzLg0K
PiANCj4gSXQncyBzaW1pbGFyIHRvIHRoZSBhbmFseXNpcyBvZiBjb250ZW50aW9uIG9mIHRkaF9t
ZW1fcGFnZV9hZGQoKSBbMV0sIGFzDQo+IGJvdGggdGRoX21yX2V4dGVuZCgpIGFuZCB0ZGhfbWVt
X3BhZ2VfYWRkKCkgYWNxdWlyZSBleGNsdXNpdmUgbG9jayBvbg0KPiByZXNvdXJjZSBURFIuDQo+
IA0KPiBJJ2xsIHRyeSB0byB3cml0ZSBhIHRlc3QgdG8gdmVyaWZ5IGl0IGFuZCBjb21lIGJhY2sg
dG8geW91Lg0KDQpJJ20gc2VlaW5nIHRoZSBzYW1lIHRoaW5nIGluIHRoZSBURFggbW9kdWxlLiBJ
dCBjb3VsZCBmYWlsIGJlY2F1c2Ugb2YgY29udGVudGlvbg0KY29udHJvbGxhYmxlIGZyb20gdXNl
cnNwYWNlLiBTbyB0aGUgS1ZNX0JVR19PTigpIGlzIG5vdCBhcHByb3ByaWF0ZS4NCg0KVG9kYXkg
dGhvdWdoIGlmIHRkaF9tcl9leHRlbmQoKSBmYWlscyBiZWNhdXNlIG9mIGNvbnRlbnRpb24gdGhl
biB0aGUgVEQgaXMNCmVzc2VudGlhbGx5IGRlYWQgYW55d2F5LiBUcnlpbmcgdG8gcmVkbyBLVk1f
VERYX0lOSVRfTUVNX1JFR0lPTiB3aWxsIGZhaWwuIFRoZQ0KTS1FUFQgZmF1bHQgY291bGQgYmUg
c3B1cmlvdXMgYnV0IHRoZSBzZWNvbmQgdGRoX21lbV9wYWdlX2FkZCgpIHdvdWxkIHJldHVybiBh
bg0KZXJyb3IgYW5kIG5ldmVyIGdldCBiYWNrIHRvIHRoZSB0ZGhfbXJfZXh0ZW5kKCkuDQoNClRo
ZSB2ZXJzaW9uIGluIHRoaXMgcGF0Y2ggY2FuJ3QgcmVjb3ZlciBmb3IgYSBkaWZmZXJlbnQgcmVh
c29uLiBUaGF0IGlzIA0Ka3ZtX3RkcF9tbXVfbWFwX3ByaXZhdGVfcGZuKCkgZG9lc24ndCBoYW5k
bGUgc3B1cmlvdXMgZmF1bHRzLCBzbyBJJ2Qgc2F5IGp1c3QNCmRyb3AgdGhlIEtWTV9CVUdfT04o
KSwgYW5kIHRyeSB0byBoYW5kbGUgdGhlIGNvbnRlbnRpb24gaW4gYSBzZXBhcmF0ZSBlZmZvcnQu
DQoNCkkgZ3Vlc3MgdGhlIHR3byBhcHByb2FjaGVzIGNvdWxkIGJlIHRvIG1ha2UgS1ZNX1REWF9J
TklUX01FTV9SRUdJT04gbW9yZSByb2J1c3QsDQpvciBwcmV2ZW50IHRoZSBjb250ZW50aW9uLiBG
b3IgdGhlIGxhdHRlciBjYXNlOg0KdGRoX3ZwX2NyZWF0ZSgpL3RkaF92cF9hZGRjeCgpL3RkaF92
cF9pbml0KigpL3RkaF92cF9yZCgpL3RkaF92cF93cigpDQouLi5JIHRoaW5rIHdlIGNvdWxkIGp1
c3QgdGFrZSBzbG90c19sb2NrIGR1cmluZyBLVk1fVERYX0lOSVRfVkNQVSBhbmQNCktWTV9URFhf
R0VUX0NQVUlELg0KDQpGb3IgdGRoX3ZwX2ZsdXNoKCkgdGhlIHZjcHVfbG9hZCgpIGluIGt2bV9h
cmNoX3ZjcHVfaW9jdGwoKSBjb3VsZCBiZSBoYXJkIHRvDQpoYW5kbGUuDQoNClNvIEknZCB0aGlu
ayBtYXliZSB0byBsb29rIHRvd2FyZHMgbWFraW5nIEtWTV9URFhfSU5JVF9NRU1fUkVHSU9OIG1v
cmUgcm9idXN0LA0Kd2hpY2ggd291bGQgbWVhbiB0aGUgZXZlbnR1YWwgc29sdXRpb24gd291bGRu
J3QgaGF2ZSBBQkkgY29uY2VybnMgYnkgbGF0ZXINCmJsb2NraW5nIHRoaW5ncyB0aGF0IHVzZWQg
dG8gYmUgYWxsb3dlZC4NCg0KTWF5YmUgaGF2aW5nIGt2bV90ZHBfbW11X21hcF9wcml2YXRlX3Bm
bigpIHJldHVybiBzdWNjZXNzIGZvciBzcHVyaW91cyBmYXVsdHMgaXMNCmVub3VnaC4gQnV0IHRo
aXMgaXMgYWxsIGZvciBhIGNhc2UgdGhhdCB1c2Vyc3BhY2UgaXNuJ3QgZXhwZWN0ZWQgdG8gYWN0
dWFsbHkNCmhpdCwgc28gc2VlbXMgbGlrZSBzb21ldGhpbmcgdGhhdCBjb3VsZCBiZSBraWNrZWQg
ZG93biB0aGUgcm9hZCBlYXNpbHkuDQo=

