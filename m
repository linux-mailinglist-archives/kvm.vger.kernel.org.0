Return-Path: <kvm+bounces-60031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36464BDB4F8
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 592B84FC0B1
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 20:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E972D9EDA;
	Tue, 14 Oct 2025 20:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gdhFc0Xq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436743074BD
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760474834; cv=fail; b=A+lMGFBQeJlHzY1TVTpeNanp4CFR6q3HTvto+YChjcZ6fbeM9YMzH9AHCx1JytxPwrkdOjuhyMVG/t2h0RxBI6xCW7H9zhgpZ0/i9a7Cr0H4f/6sCq6Zsh/ynDNwQbwemkweEidcKv24jcFpDvOYDnv/YOGn8V3eRPWhgO28gDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760474834; c=relaxed/simple;
	bh=Hp0TLOMo7oGPHJ1mOc2bZhOyyX+lwCQ6zF5nOUt/me8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qEQXcqZ6dz2XJnvYZZNJVPHi9EBgjRTFPmh2yID2oLCMZDgCwBWxQkMYVaPcozr5o/GO7TNe8AocbiJxfwWrcAow7E25gzmbFqgz7PG4nl6G00Q7m+jHb2fBbDPAxHs4nfo4MbjrOzbM2GxyNC4gHlN+k83opNrJHIbCDP7EUws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gdhFc0Xq; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760474833; x=1792010833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hp0TLOMo7oGPHJ1mOc2bZhOyyX+lwCQ6zF5nOUt/me8=;
  b=gdhFc0XqxhbAORgJvmYRjAUQY8YhtCGKEoycuRaTn5JODviLH1b+ec+P
   n9aQ5xzk+7fZBgtLe7IfqJ1FsxCCBLRmcsNUJ1S7INw/T4Ch7UM5EQqZ9
   FfgcuTFFTptNl057uX++ahREZuKjcQSPCMKtfv/CxgdafkX0lpLOI/Ejg
   m6nRX4Uk7Uh41MtEVbXpMQXB6sM3AUTECdHFKHianlwNJyVXe0BNLQued
   K/2Dz5u+vcIr+y7aNz90vaPGOs2TTQ3KBvaYdiKC/GHilqb7TKZUbdfn1
   lpjpwOGM1NdTrB4xJWOReTPqcGxmMLTZyrF8AFZSwjGxpqWqcjrQvawMw
   g==;
X-CSE-ConnectionGUID: CwXlg1TIQuSUJPOXPEr/qA==
X-CSE-MsgGUID: IW2c9Wp3TXKv10h9s2c/xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="73986038"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="73986038"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 13:47:12 -0700
X-CSE-ConnectionGUID: wJKVW2uSTPWN93OSKmmUWg==
X-CSE-MsgGUID: 73MPaqN/QtGtNPwFJX587Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="187291489"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 13:47:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 13:47:11 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 13:47:11 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.55) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 13:47:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kH4yEQAO+o7SiLiOE97JxxwAAo7iJ4KxBnJYS5/U3cABCwUstIXosuoR2rKaMiUnueEiO83AdK0Rx4B+pDTM7GlE/aGPASMDzXsb/ii3XWhaj9cZ2XE4tvno91QXhtncvdQMYikgHdb0e8hx8bb4zYxMstzXjDuwzX3vldwfXZpDP/nNQ+03ShKB2sWAaiN8pKc6OsgB66jhk+5g+eoXQ+XO9yaLsTIVXYyVWEudUpAnkQ0WzhlN6PO4KwIe/h4FRLY7B41BufCSLPxqRlCpo5uI7JvvQJ2nDvnPoqGqa2ldRTFDXRgor7Y69hoOnwnDbNc67ReWmke5i//1cFI6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hp0TLOMo7oGPHJ1mOc2bZhOyyX+lwCQ6zF5nOUt/me8=;
 b=ZPiMIEmRL7oznjcGkETFJlzVUZzVnKKIdF8Dc0xuLNdti92m0VGTHYw2GZvujfuYGayZQ6aBhN/ir6K1DZB66PZV5Udry0NFF/ctY4aB2YIXyFjbaDA9vl2IUE5E9RMka8O3OilkLRERk/GmaiXmoi+lOnf65wq4RQ01hMi7bB6t6UvtmaYOjeTFvfiPbNYFSbBUEnODId5Elp8rv1sAJz5ecnqD9AnsmbRNAsXsfHO0Rq57tkqqjYcRePu6h4OWT2OHICbYFhpKMDhmxm07rwoZXUB3IhmF2OJQbd+1vIznCUP0FVuU7EHkHMNCprkhue4bb9pBBwDT/mqhJMk5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN2PR11MB4614.namprd11.prod.outlook.com (2603:10b6:208:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 20:47:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 20:47:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "nikunj@amd.com" <nikunj@amd.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>
Subject: Re: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86
 code
Thread-Topic: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86
 code
Thread-Index: AQHcPApCIgnK1em+RkOZgv/5nL4CYLTBgiqAgACFnoCAABeKAA==
Date: Tue, 14 Oct 2025 20:47:08 +0000
Message-ID: <caa07ae9ebd6401a05ca6b28f31c11bff0a7f955.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-4-nikunj@amd.com>
	 <c6d0df58437e0f76ce9bdf0c3b7f5b53c81989a9.camel@intel.com>
	 <aO6jC_UEH13oWIs0@google.com>
In-Reply-To: <aO6jC_UEH13oWIs0@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN2PR11MB4614:EE_
x-ms-office365-filtering-correlation-id: 6cf7f0c8-e74b-4144-b082-08de0b62d7e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QXdmcVhEVE9aNFIycVZVUFZWRGZyNFVMNXpGZ25kbURyc2tMTUxmeDljZ2pm?=
 =?utf-8?B?eG0wNlY5NWJkbjJiMUNrZzZad2hreXJSMXBCNmprSVhCVzFFSnh3SW9Qcmx4?=
 =?utf-8?B?eHFsd1FyaDBmd0dPNjBnWlNTYjYxai9ONnVBZGg5bkVSanNpVC8zNDVpUDl3?=
 =?utf-8?B?UXlleks3eFpwcHRWV0xteFZKNTAwakdqdDJ5ZVk2RHVVNDNudXFjeHdMT0V4?=
 =?utf-8?B?eGlBNU5ucmsySGtzSlBpS2dKRzBSaGszclJMN3ZydnIrYk9iTzgyWWh0Q1JN?=
 =?utf-8?B?NmxITE9Sdys1aVpFUlVLRkZFTXAwVW1yY2s5VXlOT3dRYWJFcFJQVjNHZTBW?=
 =?utf-8?B?SG01Q0xIaWlCenJTS3hJOXNFWGVRNWQvVkxCT1l1TW5xanY4M2w1QUdDaURH?=
 =?utf-8?B?bWFWalRQd0Y4MGwwMVBGOHdQcUtQVmZ4ZGNjeG0zTDFwakNKUzRlbjNzR21x?=
 =?utf-8?B?dldJUlJCRmozbjVMeDhUaEJscGJNZHNlYWlFdjJBQTRLVmtsbkJ6bDZoUUhv?=
 =?utf-8?B?L1FEV3dObHhReWlsbFZTZ0ttMTFzSllKTjdTMUt3TUFpTUJCclRHaTFiUUp3?=
 =?utf-8?B?dWRZcE12am9QandFN2NLV3dzbjAvNWJwZWtWVFhabWozMHZvVWJWRUNZd01x?=
 =?utf-8?B?YVFXWXBVTkNsVG8wcTlvWGdsM0lWcjd4dEpPd3JXaVNWTWVocm1NRDlNQ2w5?=
 =?utf-8?B?U3kyaXVOODdwV0w3QWdoUE9hUlhVaVdsMXErUzNIL3cxNVVncklGanQrVjMr?=
 =?utf-8?B?T3E5MUVOb3RvalFEMk8zUkxvV3NobkdteS96UG9BNVAyeDMzMUF0WXNKOXow?=
 =?utf-8?B?dlhCajhRemVmcVZrazJyWkR4Z05WeVFOWURhc1lyTGROOTJLZlUzVGR5bEFF?=
 =?utf-8?B?VHRWU2dlcmxHdXVqWWVlTHNCbmdVbEQ0Yi8ySlhaOXZieFpWcVZzeEcwYkZz?=
 =?utf-8?B?WlRGRExza0grbDVLaXdwTWdBNCtkaTlwdk5GMGdXNXI4R01NTWswK29wNk9B?=
 =?utf-8?B?ZFh0WHByMmRVNzFoTFFLZmF0dDBYMi9JOWlZYzdhdUhOQU92Y1RONm1FcFln?=
 =?utf-8?B?YUtTYWtNdnoyUjB3VUZvYTd5VzhMVjV3L2VLejh0N1JMN2dXbVFPRFdmZTR2?=
 =?utf-8?B?dXp5T0lLQnpNRjRJNDZLQUpuWEl4N3ZHUXVRYWgvaHl5d1RUQlJnTlk4VTB0?=
 =?utf-8?B?YXJwK2s5NVVxR1loMUR2NGo4TkVPS292QkprWkEweUJpVE5qcDViL01adTBh?=
 =?utf-8?B?MlBLWGU1U1JOb3J0bnFCdTlDMVQzZ1ZMakV4UncwUHdVVzIxaytIdnpKUll3?=
 =?utf-8?B?RnJ2R05CbUliUHZMQ3hSV3dLMmtMb2NxMzdvWmNmY2RWeEdaZXd6aThFaWFl?=
 =?utf-8?B?d0NmNkRaRjZQVXo3cmJtcW8zT3lBQkNWYllFbmFWd1RESWZSTitBOXdkVDRN?=
 =?utf-8?B?UkxKUzZET09lenVFTjZsa0xHdmNiclJGUmpTcTZibldqRjNJR3BRS2J0elM1?=
 =?utf-8?B?b2tCNHdEZzJ6dXdBT1VaS3FwRlB2NTFSbnZDcUZHSzRpT2dLUldPZWRkZFl0?=
 =?utf-8?B?ZE0yT0Znelg1SlV5d1VLWW1WK3VOdHI5OU14ZTVkQ1Y1QkRHNjlpd296YjJs?=
 =?utf-8?B?bnorM25sMFlDTUFDaEsyNHZHaG82QXQ5QkNPaUQyTXhNK2d5NXNoempIU3po?=
 =?utf-8?B?MEZRVGNzU1ZPT2QzQU9rRlhxM2F0QjlDdkdFTndxOWFZU0xBUTZKd1dpMmpJ?=
 =?utf-8?B?RkhYZjd3QmdsUGJwQnY1cnlGSzBtbWgwRkk0NWhNNVZ1Z3B5cjlENk80RWRO?=
 =?utf-8?B?OVZxbmRJcjkrUnM5cVFXRTZ5Rks5bVBkRk1uWnB6RlNnM1pzTXVUZTQ3ZmVN?=
 =?utf-8?B?VExOSU1xakw4bzY4ZndFU091S2EzSlFKZ2g5dU1YaE11c09sc3Rxc2o5TUdJ?=
 =?utf-8?B?aTVMSEZXRUhRd3ZVTWp2YnJtL2V5M1hYdG1YZEtMNmhuRDlIbXdHVkJ3K2R6?=
 =?utf-8?B?SG5lZ2RQM3h3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1c3SHpBS29GMzZJNFBxU2ZmcFlid3VVdFJ0OHdHbHRYQ2JjZWx5QkNCQmU3?=
 =?utf-8?B?Zk5WMFR2dCtrT2FZOVZJSFNJc0Y0RVpzOHY5NDk4alNoekdQSE12Y29TSmNU?=
 =?utf-8?B?SVR3VG1JU25WMk5zenRncEk4dzBuRjlDNlRUTXRKNmdpcHhXd1hqb1c4L0Zr?=
 =?utf-8?B?U2QxcVU2U0dyaGwvWHFBV0pBWmpCbndUanFOa25vTDlxL2Z5aXZIeU1UYXMv?=
 =?utf-8?B?Vm5OdVhWalZQM3hyZTRWZEQwdXMwakNmb0xTSFkwMlBtQ3MzQW9ram55aEFk?=
 =?utf-8?B?dzJQTzRnNE81dk0wemZsRUtWVjZTd1BWUG5GdklhZGE2M2hLeEZQYkZRaktO?=
 =?utf-8?B?MWs0WFI4UUhrTktybEIrbUsyV0cxOWJEc2NBWDlSQ2FkTEZpQktVMks4MGNG?=
 =?utf-8?B?TytJQ2tqL2dzUVFQbjJleUg3cHlFVXVoUUFZSUZ1bDNLVEFyUm9WK0UwakVQ?=
 =?utf-8?B?QUduOUYwOTVXajZBbG5qZlYrZ2FSZHZiaERsYU1kWUt4WFZSTTdGTEZOcURm?=
 =?utf-8?B?Q1UvWGg1d1VaRi9ITTVxTkVRY1huMTFMQXppSnFSQWFTR2RnVmZQZUQ0c2I3?=
 =?utf-8?B?VmtBM2xRMEQ5VkwxZnJZVS9PUGRONnZPWGZFMUlpcWV2Yko3c2pkSzBIQ3hs?=
 =?utf-8?B?WGRCcEsrbXRoVituMHVUb0x0UytGelorOC9uWlRMTmI0NnUxbzdpN005Vndv?=
 =?utf-8?B?YUJSZVQrMWJ4Ymx6Tm5RWG0zWndwbXZLSWdYSjYxRXViZi9PcTBnZUM3V3Rk?=
 =?utf-8?B?UHpaUkIwR21rbjBIdUJJS0JRUVdrMGVuT01DUm1lRDV3b25ncHN1Uk15Ri9w?=
 =?utf-8?B?WHRHZmdRc2dpRE1Jb1NoK3hCY2U3L0l4UkVHU2JaQ1lMVjlCY1ZVNDdoK1g1?=
 =?utf-8?B?TmdDSzhGZEFHUTZzZzd1S3hYKzVVRjUwUHl1cnY4bUp3YW1sOGZ0enhVQnAr?=
 =?utf-8?B?Y2ZFN1pRMVJNbXJjZEJTNkFBOGlRK28zc1V3TWxVbTRRSWNaRTg4a1dzUHRh?=
 =?utf-8?B?d0J2N20raDNXcXRMWXdDdlNhdzB6STFpcDBqdm5XSEwvRnkvVFVKZVgyREpK?=
 =?utf-8?B?RG1ZNHZYN2pBWEtQZjVrdjVDYU5vVHcwZENJdE03L1hWdVZaV1VQL1h1akd4?=
 =?utf-8?B?d2EzN2FPb3QvYnRQNW9VK0g0SEgxM0hrMEp1WWpvT0Z0ZjZTTnpJYlQwemZW?=
 =?utf-8?B?N0tCSnBDMnFUMWxnbmdidGpaVnZURnlqdDU1RVZoUUsvdDBValB4aUJOY1Br?=
 =?utf-8?B?a1oyekNMdlJPL3d3ZG94MVM3ZWladGo2QmJ1cEV2R3ZkQk1uRm5uQUZCbldw?=
 =?utf-8?B?OUhISnYyMWhqZnE0RnhiWGIveDNEdlE3dWtodGJyMHk1ZFhiNmFNbmoySWJk?=
 =?utf-8?B?SWxFbnVkNm5EODdrLzRQb3pMUjY5bTJmYnhJd0xMbVh6MWhIRnBxeHVwQ1ZY?=
 =?utf-8?B?TWEyZEo2MTRLTkxybkQ2VmZ5WGpTcVl2OUVNdnBqMlQ0N3pQYXg4YUVmRGp5?=
 =?utf-8?B?aEZSU0JPV3NMWnpRSWdDSDl0YjVpdTB3eTRCSmRXTkJqdW5RY1E1ZUhxeXhm?=
 =?utf-8?B?eWFreWpSYnppU01XRDhlbTZ6NmRFSE41MEZKdk9pQXp2Q3JONnJ6UVZ3YTJH?=
 =?utf-8?B?Mk40RGhHVXI5ZUtNOGc0bm5uU2JKS09QcThwYmRublJyc0M4V0hwdk56amYv?=
 =?utf-8?B?ZC8xMUlJajlCRkFNVmFmTGhOQXdxVkJOUUYrVzBJb2pjWjIxd1M0eUZIVXFV?=
 =?utf-8?B?UHNHQU54YVNLRW05U0hFM3B5YTFDYjI3VitKdlBSRmlmY2crQ3BFYWtFZ2Zm?=
 =?utf-8?B?N2g1NkF6eFVVYlpLUE8zVHlWRWRoYXdQQlMrYmhDdmFqR0dzNmpQZDRXcXJM?=
 =?utf-8?B?RVNCSFNYeWdkWXhpTUpBT1BuMkVaSXkyclpsZnZjL1dSeHB1VG5pZHZLb1hL?=
 =?utf-8?B?TUF4MktMQ3J1K2MyMlpsckRLUXBrY1djbFBsalpWZEZ4Tkw5Mm9IeXFkYTA5?=
 =?utf-8?B?emd4YVdrQVFROHRjOUtuQUFoSUxxOWRnY0M4WHVsdnBjK1lBVDZITVBwaW51?=
 =?utf-8?B?a0FsV1lja0kxRWdONFlPVHdBWWVIQWp1UWhCZ2JXajVrTmZPVkkxeUJIT21x?=
 =?utf-8?Q?kQ+XmFR8sO9w4Sm2/QN4vAH6j?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <330B3E48AC2BC64186D16D612C77406A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf7f0c8-e74b-4144-b082-08de0b62d7e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 20:47:08.9226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8AGWQG5OAsGuIzvHxRLXtGeV1SyWkibeM1nVC00ZpVeX9AKt7OFCgfPOiMB5goRwA+HoJlq+zDnJJAAIFEhoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4614
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEyOjIyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE9jdCAxNCwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIE1v
biwgMjAyNS0xMC0xMyBhdCAwNjoyNSArMDAwMCwgTmlrdW5qIEEgRGFkaGFuaWEgd3JvdGU6DQo+
ID4gPiBNb3ZlIHRoZSBlbmFibGVfcG1sIG1vZHVsZSBwYXJhbWV0ZXIgZnJvbSBWTVgtc3BlY2lm
aWMgY29kZSB0byBjb21tb24geDg2DQo+ID4gPiBLVk0gY29kZS4gVGhpcyBhbGxvd3MgYm90aCBW
TVggYW5kIFNWTSBpbXBsZW1lbnRhdGlvbnMgdG8gYWNjZXNzIHRoZSBzYW1lDQo+ID4gPiBQTUwg
ZW5hYmxlL2Rpc2FibGUgY29udHJvbC4NCj4gPiA+IA0KPiA+ID4gTm8gZnVuY3Rpb25hbCBjaGFu
Z2UsIGp1c3QgY29kZSByZW9yZ2FuaXphdGlvbiB0byBzdXBwb3J0IHNoYXJlZCBQTUwNCj4gPiA+
IGluZnJhc3RydWN0dXJlLg0KPiA+ID4gDQo+ID4gPiBTdWdnZXN0ZWQtYnk6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiANCj4gPiBGb3IgdGhlIHJlY29yZCA6LSkNCj4gPiAN
Cj4gPiBXaGVuIEkgbW92ZWQgdGhlICdlbmFibGVfcG1sJyBmcm9tIFZNWCB0byB4ODYgaW4gdGhl
IGRpZmYgSSBhdHRhY2hlZCB0byB2Ng0KPiA+IHdhcyBwdXJlbHkgYmVjYXVzZSB2bXhfdXBkYXRl
X2NwdV9kaXJ0eV9sb2dnaW5nKCkgY2hlY2tzICdlbmFibGVfcG1sJyBhbmQNCj4gPiBhZnRlciBp
dCBnb3QgbW92ZWQgdG8geDg2IHRoZSBuZXcga3ZtX3ZjcHVfdXBkYXRlX2NwdV9kaXJ0eV9sb2dn
aW5nKCkgYWxzbw0KPiA+IG5lZWRlZCB0byB1c2UgaXQgKGZvciB0aGUgc2FrZSBvZiBqdXN0IG1v
dmluZyBjb2RlKS4NCj4gPiANCj4gPiBJIGRpZG4ndCBtZWFuIHRvIHN1Z2dlc3QgdG8gdXNlIGEg
Y29tbW9uIGJvb2xlYW4gaW4geDg2IGFuZCBsZXQgU1ZNL1ZNWA0KPiA+IGNvZGUgdG8gYWNjZXNz
IGl0LCBzaW5jZSB0aGUgZG93bnNpZGUgaXMgd2UgbmVlZCB0byBleHBvcnQgaXQuICBCdXQgSQ0K
PiA+IHRoaW5rIGl0J3Mgbm90IGEgYmFkIGlkZWEgZWl0aGVyLg0KPiANCj4gWWEuICBBdCBzb21l
IHBvaW50IGl0IG1pZ2h0IG1ha2VzIHNlbnNlIHRvIGRlZmluZSAic3RydWN0IGt2bV9wYXJhbXMi
LCBhIGxhDQo+ICJrdm1fY2FwcyIgYW5kICJrdm1faG9zdF92YWx1ZXMiLCBzbyB0aGF0IHdlIGRv
bid0IG5lZWQgYSBwaWxlIG9mIG9uZS1vZmYgZXhwb3J0cy4NCj4gSSdtIG5vdCBzdXJlIEknbSBl
bnRpcmVseSBpbiBmYXZvciBvZiB0aGF0IGlkZWEgdGhvdWdoLCBhcyBJIHRoaW5rIGl0J2QgYmUg
YSBuZXQNCj4gbmVnYXRpdmUgZm9yIG92ZXJhbGwgY29kZSByZWFkYWJpbGl0eS4gIEFuZCB3aXRo
IEVYUE9SVF9TWU1CT0xfRk9SX0tWTV9JTlRFUk5BTCwNCj4gZXhwb3J0cyBmZWVsIGEgbG90IGxl
c3MgZ3Jvc3MgOi0pDQoNClllYWggSSBsaWtlIEVYUE9SVF9TWU1CT0xfRk9SX0tWTV9JTlRFUk5B
TCgpLg0KDQpCdHcgbWF5YmUgd2UgY2FuIGF2b2lkIHRoaXMgcGF0Y2g/ICBQbGVhc2Ugc2VlIG15
IHNlY29uZCByZXBseSB0byB0aGUgbmV4dA0KcGF0Y2g6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2t2bS84YjFmMzFmZWMwODFjN2U1NzBkZGVjOTM0NzdkZDcxOTYzOGNjMzYzLmNhbWVsQGlu
dGVsLmNvbS8NCg==

