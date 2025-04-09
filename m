Return-Path: <kvm+bounces-43023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D43A82EAA
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 20:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 956387AB978
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 18:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F70E2777F4;
	Wed,  9 Apr 2025 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MvENsFMZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDFF1A5BA4;
	Wed,  9 Apr 2025 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744223349; cv=fail; b=QETp9YVy1vLuQfSBSFuT9MjeV9hRbvAPhMczyH5Vr3KeV573meOVsGnWdmUEjWGplDh2T5MyYImUeRQqJr9u6X5FHHTaCpsPYWsQ6DVuUtwoi/bGTL1nEpu7uKadu7oeVOJZPNf60Sk6qfsR9U7CBnUQ3AdvgOyawtqhiSoKDAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744223349; c=relaxed/simple;
	bh=kuITl3JVyXZGtnys9UCA4ieSvCj6TTXh1zOvpGaNdjE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QK/y0rejt06wShkrsQK4q+ayXgB4ZCaV3oBIe6NEQL+kWkGxDmyRMzBBnK/ZizgS8JAa6OCngaM3XnN19gDV5UPANaoKNWtQKwEgXTexWXR9i3yAkgWbsIqGB/CkMk81N3jlAiEsg8bz79MWGY17ReY4hl6/9EVwrGAXVfM45oo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MvENsFMZ; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L2NMBMc8rAwSWrn8XEGQu3Dwt1PPcrvj+eoqgo0xM4k+UBOJaiha5vd9v8zVfLK/+K3P5dN8YHemT5eCiMx+XO6jWibeREvOifvffE1ivHF4yigGmYxBBgE7F/ec8jVqxbY06KcpvIHVKELTPLcFhhDZc1g0Kr+8Mftq+IX0w5xWryVdpzRKwpVkUGc4gN1chVw38c2XvN72VCL2XA7x0Ek9n+C7t4dutV2nK2s64Cradk1WPEKteGgRx7pzbdavyH3RsAeX6OYmWJvm+ffHN5jeBh1xf/atQCsFN6aM6v3XiqsCPqyaaXzkuliNqehJ7yXvnnGMncaOUQ4MrAiGqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kuITl3JVyXZGtnys9UCA4ieSvCj6TTXh1zOvpGaNdjE=;
 b=jhZiYAr0ihpzk73njGeIcLCGl0hxyMciUqUjNJdelnzf2irVoHjO9llG498jEKcko1384wGVkGU1IdhqT6XWcQ7tNGwpPKU0ohoet/uCs0WyUADIv6+5kmaS+OoTVpSZ87/m3FeZlgeXm//akl0BSRI+jTtcF/AtcgDXKwHQ4IICGodsle83GheQ+q2CfQcsNrCrC9FD50EgmdGzzGONMgV7B4twvHSyFAMHt9i14PWcT6j8/YUdGCujBmAsnJ2dzzEi8gDKFK2aCMCFZTfW1u5miXyD2OyUBgDBzjl3+CMkA+06kz57wSKY9EkkkU3mj/8DRYq0f2QoaSBTeUlbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kuITl3JVyXZGtnys9UCA4ieSvCj6TTXh1zOvpGaNdjE=;
 b=MvENsFMZFGScOVSO4XceLs3gdtbzQcJt3a3m0NstY1xmCclfdQJSeFQoaHgr13pGNVsIOaxy2lg6mMZMuoYNVfSr/WF7XXAdWBAAut1GQog2SBZvGn0MyAIJJCZ8Y+RXW2zW56AiLonCLgSgpQHFHAeApI+VYK/h9jnSR3VPHWk=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by CY5PR12MB6300.namprd12.prod.outlook.com (2603:10b6:930:f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Wed, 9 Apr
 2025 18:29:05 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%6]) with mapi id 15.20.8632.021; Wed, 9 Apr 2025
 18:29:05 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Jim Mattson <jmattson@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "amit@kernel.org" <amit@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Shah, Amit"
	<Amit.Shah@amd.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "Moger, Babu"
	<Babu.Moger@amd.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: RE: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if applicable
Thread-Topic: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if
 applicable
Thread-Index: AQHbo/vbySgR3ElLOU6WctxZ4AQw37OQ3ZAAgABXtYCACnctAIAABC4w
Date: Wed, 9 Apr 2025 18:29:05 +0000
Message-ID:
 <LV3PR12MB92658D9E1EBD4C38C035B19594B42@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
 <CALMp9eTGU5edP8JsV59Sktc1_pE+MSyCXw7jFxPs6+kDKBW6iQ@mail.gmail.com>
 <fqkt676ogwaagsdcscpdw3p5i3nkp2ka5vf4hlkxtd6qq7j35y@vsnt3nrgmmo5>
 <CALMp9eTHsPeYi7wLaWtp-NuxE8Hz_LZUFYKUfzcx1+j+4-ZjmQ@mail.gmail.com>
In-Reply-To:
 <CALMp9eTHsPeYi7wLaWtp-NuxE8Hz_LZUFYKUfzcx1+j+4-ZjmQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=d0f14a54-6814-406c-a7d5-13fb1f81b143;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-04-09T18:22:05Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|CY5PR12MB6300:EE_
x-ms-office365-filtering-correlation-id: ed402101-4b2b-4fdf-de4f-08dd779468d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MTR2VWZCc08vc05iOVE5TmdNb1kxZzRpZGp3c2NBNStRSlhZdlFhZFZJMDU2?=
 =?utf-8?B?ejV0OTMxczQydUR2cDE5bUJ2Ly91aDA1YjFwek5wRm5heFhFWWx2c3JYUzF6?=
 =?utf-8?B?dy9Fd0prZjN1ZFFnbU1TTS9IY0ZiMm9reEh5YXc1VUVxQmRmN1hHcmpvR0ZD?=
 =?utf-8?B?ck0rYU91bHFtTk9OUlhSYmw1dGRJaUlGREozdjhUdkNxZjgrZG1sR1drNFZt?=
 =?utf-8?B?UlpIV0J0UVlVdEZESFRhUHlUTm9yKy9FSUsvalZBNGpJZmNCU0kvNGkyYTQ5?=
 =?utf-8?B?bzNhQXV0NXBydjFJQmdhdUttK2lxWTJPZEpQeGVtblY1OEhiVFV4QURJNThN?=
 =?utf-8?B?TDZPSm95RUJXd2dCbXZ4bDNXUzMvQ25SaW0rS2VpVkFXQVg1bGp3NDBpMVd2?=
 =?utf-8?B?YXRPdDNlUDd4NndXVTRyOFZVN3c3WHVUNGhwc0d3SUZYQlZXbFdReTMrcWdL?=
 =?utf-8?B?MVkrTFFIdWpndGlpNlJoQjJHRGs0WDAzcmRRSXRjYzV3LzFnd2lIS0tjZGlJ?=
 =?utf-8?B?dmFVcXI5cW1DeFVoTFVMTmNEVElKWkpPUUFJclo0WDEwTmJ5bU5kZVFqcnRo?=
 =?utf-8?B?VlpaOG5XZms1OHdNeUZOTDNlUDREU2FwYWVyNmNTeUtTVkIvUGpIRE01OW1K?=
 =?utf-8?B?REdUbnJKY3VjbHN6QXNiaVZGd0pDY0ltYTRSSDFjUHBOdVRqMmI1RGJ1WUZD?=
 =?utf-8?B?UXJNc2VwU2xFbXF4RFJlTHF0Z0k0YUxYUnJHZFR1WXkwaHhQNWZpVEp4SjRF?=
 =?utf-8?B?czIzaTAyUStXV0c4TkR1SFQ5K2hxTWVWQjdvK0ZJckU1NVFZaGloVVFDY1dF?=
 =?utf-8?B?aG96MUNCYW5QVWhXVW1iMGJMSjE2U1lFcW1mV2swdXcrRmZRRlRlcXdqTk9q?=
 =?utf-8?B?dklyMC9vaFJ5MVpzZWdmZkpXZGFXM2ZjclIzMWtlaEZlZ1duRmo2TmhiWk5p?=
 =?utf-8?B?WHVUUzAwOWNldDJ2QnpydWFQUU9qaVRiR2VhM3VGSlNreWIwd2lCOG5zWjAv?=
 =?utf-8?B?ZXl2K01oN0RtSHQzclpBSXA1ZWFNZ1I3SlY1aUpkYmxrRTlWcEVNdXdsNVZo?=
 =?utf-8?B?SXl3L1VKWkptTzZDUzMzSlRpVi9IQ1NyRVNOV3BrZUkwaVF2a21HT0kvRzk1?=
 =?utf-8?B?WHUrOVg5b0FGVlo3SHJ5UTlqazIrTGZXZ2M2Z21OUWdQdFZic0xTeWtobEt6?=
 =?utf-8?B?RVd5QlNmTDZJcGY3R0Qxc2QrUDlhb3MyQkRCMForWUkydkZ3SFhyMllZVWlY?=
 =?utf-8?B?azhZOTlsMlA5MlVpOGR4VlJPb0xOZDFVTm5TVHI5V0lIYkRmYXZpWWFMUkdX?=
 =?utf-8?B?cnlTNnlsbjd0dHU3T3pVdFVPQmN5NnhDY3loWTlxcVc0dkdLREpJQ2hZcnlN?=
 =?utf-8?B?VnF3ejlGOTlocFRMbVFkNTNwUzZZVEhIbE9UMG1RQ0hYNlZTcUdtNGFrTDBr?=
 =?utf-8?B?NzVGVUY0L3hyNFFwYTJWZkNvR1I5TFpub2hXWkNpU3JJVy90MGFsdWJiTzNT?=
 =?utf-8?B?a3VSc0FVVnhIcUtDcTV3UGwvYi9LK2FJelhWNGlJT1VuM2tpblhocWttTW9T?=
 =?utf-8?B?cUo0SjhmbkdhaGNxM0VSL2dtTXplZzlQN244WnYwQkxueXRZU05OeXpPakp6?=
 =?utf-8?B?ZnMyTkF2aG1MbVdIU2NYMk5SenJGOC9JUWpBb1FLUmlvSkxKSzBnZzVyWWky?=
 =?utf-8?B?dTR0ZXVITGVZeGNVT3JISlNSSmJBd2FiQllZVGdEcjhzL3NhbWpEMFoxdTN4?=
 =?utf-8?B?TzZvUmZMV1lsU1c0K2hkclVQUTYwbXgzRElPODNlOHpJQ243aEJsYXlGZnIz?=
 =?utf-8?B?SCt2UEdCZXdPNzhidnl3K2t3ZnNXRzJIMWJTNVI1MVgxWUZCNnlzVnN4ZTVT?=
 =?utf-8?B?WXFKTWQ3Z293REdqSVNLdnRxY1hXS1BuYXhYd0pzVHJhZm9KVWt2dnIwN2t5?=
 =?utf-8?Q?55ubl25gtaqKNScVVudSYNOGE5O11Ynj?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b0x2VG1YYTJjMGptRXpkTnpTektOUkJqcHBTRTdwdlBBNkNJSlBSR01xMXZP?=
 =?utf-8?B?UUNTTW1Kd2taU0Z6aTd2NnRqNHIxSGdnTUFlK1lzVlYwNmE3bmRMYzdFc0Uw?=
 =?utf-8?B?ei8vNW01M2dPRWJvN1RIR0RSY1k3QUpIUGxCbWdtODJzMVdsR2E5eUtnSGhn?=
 =?utf-8?B?ZDVES1gySjlpdzhxcFRRZ21GYXI0WjZlaEhydml1T0h1MGtLTnhHckV0UWcx?=
 =?utf-8?B?OFJsM082NTAwNnZEckFVVE9hdjhvejBWaGUxKzVMSWhSLzI2blZpOFJ5dXFm?=
 =?utf-8?B?eDNhREJBYUlKL2FtNW1qRDhUNkJMYkl1b1dEdTV3L2JkaDJZRXYrQTRQd3RD?=
 =?utf-8?B?NVV5eGdLWjlQOVJwdVFPcTFzWm0xM2t6OTZ6UVYyYzBxRlVZV1ZQSzZPS1h1?=
 =?utf-8?B?UldMVGJHN2hLakpxc0RNbFE5VFJwMFY5SnVqOGExVXRRQTlGbElKN043RGlV?=
 =?utf-8?B?QVh6Um0yOW4xRC9tbzNmeE9TRjA1a1pxOXVtTlZIdjRFRHY1dlIrbmo4bkU3?=
 =?utf-8?B?ZkVJUzdOSWIyQUxTREZLdnFIUXdHenQ2bkt5anJXWFg0ZVZWekRvelRvMkhN?=
 =?utf-8?B?VW1ON1haNmZ6dHptMi9oVTFjYko1eGtkNW1VZW9aSWNMYmY4Rk16S2IwanhZ?=
 =?utf-8?B?em9RaEs4Sm1TUHl6VTNxNzN2Z0EwekZPUWR5YjlqL2diaFV4VmRUTm5kK2VD?=
 =?utf-8?B?M2RoUFVOVFV0V2t1TkRMTU9DQmJic3JnaFZiVlFCWk5FcHo3K2xTL3MzdExl?=
 =?utf-8?B?dVpHcTJUVjdkbEpDcU1teWJlYnIwa0M4V3pWNkVYeUxEQ1JrNVpwajNpSS9L?=
 =?utf-8?B?QVc2dHhvQ1lvZ2UwUCtYRGZLMmhua25xbnZPODdqRkFjMkFtYXMySytkN1Ey?=
 =?utf-8?B?cVIrNWxPcE44TGxOdFJhL1N2SHVDRWxUNktJeXp4UThIdnJ1dmhIMHQyWGtk?=
 =?utf-8?B?U0dydXNyZTRYL29rdkJoeTlGSWNscUwrTFBpWExLSWVTS0tZVXFtKzV1eVRI?=
 =?utf-8?B?enFCbkZ2RTBUbCtUb29YU2M0TkNJK2R0ZlV4RDQ0TGYzVnpNNVlCMmM0aGJM?=
 =?utf-8?B?ZjNlZmJqdjFWZXBCLzhwR3RDTkI4bTJmM1RIa1RITFgvMWpzRm9pMmFwNE5Z?=
 =?utf-8?B?L0NOaWhmeURoQWZXYXNoajV4MUxPL0lyY0lUWW5zTk9YbGZsWFZYcURaNzJt?=
 =?utf-8?B?T0tiK1ZjUU4rNm9BMG5OK1BBMDE4UFR1TUJMcExDOGNYeGZZSGFPY2dRK0U2?=
 =?utf-8?B?Nm8vNy9oSE92UGxaUjhjdFhUQnhLZ0ZVSStLVStGYk16N1dzM0hWcWtyTGJo?=
 =?utf-8?B?cVFYMElYdm5nSmdOb1dQU0MvaGMwOXRxR2w1dzVwZU1BeVhacFZ2ZE9qaTBu?=
 =?utf-8?B?K0VRaUxEV3Nyd1hFUzF5eTU4dkRvdHI5Q25HcE02cHFSS3ErSjZCWlp3aDN5?=
 =?utf-8?B?S2hXRlU2eHhHUHdBdDVTWHNGc2Q4VEJiMlZUNmZ1b0kxVlpyWG9JY0VPcTdz?=
 =?utf-8?B?ZHlNcW5pbWU0SGE3RGhXRkNBeWZmT1VBT283MmZ5Vmhtd1U0YytFS0psa3Av?=
 =?utf-8?B?Wlp5elUvaGxyaU5VVFVSVnBwSk9kTHlzMjB3OVZMMzdyYi9hVDBzdU84c09T?=
 =?utf-8?B?TVdBLzVXaGRiSWNEeDIzSm52QWwwNWRtQXk3THIwcFRCY2M1SDE5dnBZbGdO?=
 =?utf-8?B?RFBhRkN6aXdCdGR4cEFCZUlaUkVVL1FOcDlZSU5XS1NRTkFoeUg3WDRoQTF1?=
 =?utf-8?B?YTdVaHErWWlEVHdkbGpHaStCRitqL3h4eTF3N1piTFF2aTlCQzdoek4xUjho?=
 =?utf-8?B?K0ZvQnpWU1NpSG9GNFlBMFcwTGtGdkpBN3JhOVkvLzNsMGUyYkR5UGQrSjM0?=
 =?utf-8?B?bDlNTElmZnVFWlpRL0htM25zY21TL2QzVHp0MEd0cW9XMzQwdFVTNldHNUV5?=
 =?utf-8?B?U1V6N21lVE9rWTI2a3FaNWtsM2IvMmYzS1pLWXNhMUdNdFdSUWgrZVBrdTg4?=
 =?utf-8?B?OGdmQndDUDVnNDRXQU5hWURHQVVlSk5SMDdNQVpla2lEYWt5eUtQODJwbVhw?=
 =?utf-8?B?RnUxdmxwSUtFOFdhQkVFU2JrY3BXTnlxWWkxSGF3SVUrQzh6RzNWaVN4bGND?=
 =?utf-8?Q?Iwy8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed402101-4b2b-4fdf-de4f-08dd779468d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 18:29:05.3979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: slv7Z7bP+KNLXIiAW7xpcKQvjEnrLMY9T3p+mw7mKzK+yvWhhJ1LzcpZWJCFKQTw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6300

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaW0gTWF0dHNvbiA8am1h
dHRzb25AZ29vZ2xlLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCA5LCAyMDI1IDExOjA3
IEFNDQo+IFRvOiBKb3NoIFBvaW1ib2V1ZiA8anBvaW1ib2VAa2VybmVsLm9yZz4NCj4gQ2M6IHg4
NkBrZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBhbWl0QGtlcm5lbC5v
cmc7DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFNoYWgsIEFtaXQgPEFtaXQuU2hhaEBhbWQuY29t
PjsgTGVuZGFja3ksIFRob21hcw0KPiA8VGhvbWFzLkxlbmRhY2t5QGFtZC5jb20+OyBicEBhbGll
bjguZGU7IHRnbHhAbGludXRyb25peC5kZTsNCj4gcGV0ZXJ6QGluZnJhZGVhZC5vcmc7IHBhd2Fu
Lmt1bWFyLmd1cHRhQGxpbnV4LmludGVsLmNvbTsgY29yYmV0QGx3bi5uZXQ7DQo+IG1pbmdvQHJl
ZGhhdC5jb207IGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbTsgaHBhQHp5dG9yLmNvbTsNCj4g
c2VhbmpjQGdvb2dsZS5jb207IHBib256aW5pQHJlZGhhdC5jb207IGRhbmllbC5zbmVkZG9uQGxp
bnV4LmludGVsLmNvbTsNCj4ga2FpLmh1YW5nQGludGVsLmNvbTsgRGFzMSwgU2FuZGlwYW4gPFNh
bmRpcGFuLkRhc0BhbWQuY29tPjsNCj4gYm9yaXMub3N0cm92c2t5QG9yYWNsZS5jb207IE1vZ2Vy
LCBCYWJ1IDxCYWJ1Lk1vZ2VyQGFtZC5jb20+OyBLYXBsYW4sDQo+IERhdmlkIDxEYXZpZC5LYXBs
YW5AYW1kLmNvbT47IGR3bXdAYW1hem9uLmNvLnVrOw0KPiBhbmRyZXcuY29vcGVyM0BjaXRyaXgu
Y29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgMi82XSB4ODYvYnVnczogVXNlIFNCUEIgaW4g
X193cml0ZV9pYnBiKCkgaWYgYXBwbGljYWJsZQ0KPg0KPiBDYXV0aW9uOiBUaGlzIG1lc3NhZ2Ug
b3JpZ2luYXRlZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gVXNlIHByb3BlciBjYXV0aW9uDQo+
IHdoZW4gb3BlbmluZyBhdHRhY2htZW50cywgY2xpY2tpbmcgbGlua3MsIG9yIHJlc3BvbmRpbmcu
DQo+DQo+DQo+IE9uIFdlZCwgQXByIDIsIDIwMjUgYXQgNzoxOOKAr1BNIEpvc2ggUG9pbWJvZXVm
IDxqcG9pbWJvZUBrZXJuZWwub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9uIFdlZCwgQXByIDAyLCAy
MDI1IGF0IDAyOjA0OjA0UE0gLTA3MDAsIEppbSBNYXR0c29uIHdyb3RlOg0KPiA+ID4gT24gV2Vk
LCBBcHIgMiwgMjAyNSBhdCAxMToyMOKAr0FNIEpvc2ggUG9pbWJvZXVmIDxqcG9pbWJvZUBrZXJu
ZWwub3JnPg0KPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gX193cml0ZV9pYnBiKCkgZG9lcyBJ
QlBCLCB3aGljaCAoYW1vbmcgb3RoZXIgdGhpbmdzKSBmbHVzaGVzDQo+ID4gPiA+IGJyYW5jaCB0
eXBlIHByZWRpY3Rpb25zIG9uIEFNRC4gIElmIHRoZSBDUFUgaGFzIFNSU09fTk8sIG9yIGlmIHRo
ZQ0KPiA+ID4gPiBTUlNPIG1pdGlnYXRpb24gaGFzIGJlZW4gZGlzYWJsZWQsIGJyYW5jaCB0eXBl
IGZsdXNoaW5nIGlzbid0DQo+ID4gPiA+IG5lZWRlZCwgaW4gd2hpY2ggY2FzZSB0aGUgbGlnaHRl
ci13ZWlnaHQgU0JQQiBjYW4gYmUgdXNlZC4NCj4gPiA+DQo+ID4gPiBXaGVuIG5lc3RlZCBTVk0g
aXMgbm90IHN1cHBvcnRlZCwgc2hvdWxkIEtWTSAicHJvbW90ZSINCj4gPiA+IFNSU09fVVNFUl9L
RVJORUxfTk8gb24gdGhlIGhvc3QgdG8gU1JTT19OTyBpbg0KPiBLVk1fR0VUX1NVUFBPUlRFRF9D
UFVJRD8NCj4gPiA+IE9yIGlzIGEgTGludXggZ3Vlc3QgY2xldmVyIGVub3VnaCB0byBkbyB0aGUg
cHJvbW90aW9uIGl0c2VsZiBpZg0KPiA+ID4gQ1BVSUQuODAwMDAwMDFIOkVDWC5TVk1bYml0IDJd
IGlzIGNsZWFyPw0KPiA+DQo+ID4gSSdtIGFmcmFpZCB0aGF0IHF1ZXN0aW9uIGlzIGJleW9uZCBt
eSBwYXkgZ3JhZGUsIG1heWJlIHNvbWUgQU1EIG9yDQo+ID4gdmlydCBmb2xrcyBjYW4gY2hpbWUg
aW4uDQo+DQo+IFRoYXQgcXVlc3Rpb24gYXNpZGUsIEknbSBub3Qgc3VyZSB0aGF0IHRoaXMgc2Vy
aWVzIGlzIHNhZmUgd2l0aCByZXNwZWN0IHRvIG5lc3RlZA0KPiB2aXJ0dWFsaXphdGlvbi4NCj4N
Cj4gSWYgdGhlIENQVSBoYXMgU1JTT19OTywgdGhlbiBLVk0gd2lsbCByZXBvcnQgU1JTT19OTyBp
bg0KPiBLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRC4gSG93ZXZlciwgaW4gbmVzdGVkIHZpcnR1YWxp
emF0aW9uLCB0aGUgTDEgZ3Vlc3QNCj4gYW5kIHRoZSBMMiBndWVzdCBzaGFyZSBhIHByZWRpY3Rp
b24gZG9tYWluLiBLVk0gY3VycmVudGx5IGVuc3VyZXMgaXNvbGF0aW9uDQo+IGJldHdlZW4gTDEg
YW5kIEwyIHdpdGggYSBjYWxsIHRvDQo+IGluZGlyZWN0X2JyYW5jaF9wcmVkaWN0aW9uX2JhcnJp
ZXIoKSBpbiBzdm1fdmNwdV9sb2FkKCkuIEkgdGhpbmsgdGhhdCBwYXJ0aWN1bGFyDQo+IGJhcnJp
ZXIgc2hvdWxkICphbHdheXMqIGJlIGEgZnVsbCBJQlBCLS1ldmVuIGlmIHRoZSBob3N0IGhhcyBT
UlNPX05PLg0KDQpJIGRvbid0IHRoaW5rIHRoYXQncyB0cnVlLg0KDQpJZiBTUlNPX05PPTEsIHRo
ZSBpbmRpcmVjdF9icmFuY2hfcHJlZGljdGlvbl9iYXJyaWVyKCkgaW4gc3ZtX3ZjcHVfbG9hZCgp
IEkgYmVsaWV2ZSBvbmx5IG5lZWRzIHRvIHByZXZlbnQgaW5kaXJlY3QgcHJlZGljdGlvbnMgZnJv
bSBsZWFraW5nIGZyb20gb25lIFZNIHRvIGFub3RoZXIsIHdoaWNoIGlzIHdoYXQgU0JQQiBwcm92
aWRlcy4gIEtlZXAgaW4gbWluZCB0aGF0IGJlZm9yZSBTUlNPIGNhbWUgb3V0LCBJQlBCIG9uIHRo
ZXNlIHBhcnRzIHdhcyBvbmx5IGZsdXNoaW5nIGluZGlyZWN0IHByZWRpY3Rpb25zLiAgU0JQQiBi
ZWNvbWUgdGhlICdsZWdhY3knIElCUEIgZnVuY3Rpb25hbGl0eSB3aGlsZSBJQlBCIHR1cm5lZCBp
bnRvIGEgZnVsbCBmbHVzaCAob24gY2VydGFpbiBwYXJ0cykuICBJZiB0aGUgQ1BVIGlzIGltbXVu
ZSB0byBTUlNPLCB5b3UgZG9uJ3QgbmVlZCB0aGUgZnVsbCBmbHVzaC4NCg0KSSBhbHNvIGRvbid0
IHRoaW5rIHByb21vdGluZyBTUlNPX1VTRVJfS0VSTkVMX05PIHRvIFNSU09fTk8gc2hvdWxkIGV2
ZXIgYmUgZG9uZS4gIFdoZW4gU1JTT19OTz0xLCBpdCB0ZWxscyB0aGUgT1MgdGhhdCBpdCBjYW4g
dXNlIFNCUEIgb24gY29udGV4dCBzd2l0Y2hlcyBiZWNhdXNlIHRoZSBvbmx5IHByb2Nlc3MtPnBy
b2Nlc3MgQlRCIGNvbmNlcm4gaXMgd2l0aCBpbmRpcmVjdCBwcmVkaWN0aW9ucy4gIFRoZSBPUyBo
YXMgdG8gdXNlIElCUEIgaWYgU1JTT19OTz0wIChyZWdhcmRsZXNzIG9mIFNSU09fVVNFUl9LRVJO
RUxfTk8pIHRvIHByZXZlbnQgU1JTTyBhdHRhY2tzIGZyb20gcHJvY2Vzcy0+cHJvY2Vzcy4NCg0K
LS1EYXZpZCBLYXBsYW4NCg==

