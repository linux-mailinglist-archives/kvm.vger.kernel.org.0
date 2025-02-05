Return-Path: <kvm+bounces-37308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D06FAA2851D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 08:50:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C5E47A1DA9
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 07:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0CE212D69;
	Wed,  5 Feb 2025 07:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iBI7Yd1J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A092139C9;
	Wed,  5 Feb 2025 07:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738741805; cv=fail; b=ba5z3tVadxuaDeYES96sZZnx7565w83ShoQeNJZCLraQQdyhW+HBXTtbpf3KmBEDpFgJthG1LHJul0aH4pddnLlqG7Ux3uCjkDms0SeFEtG0tdCKWeirieIk7O4gmvQq0XmG2n8vVpVs9XCRqfyMAFGbn2UHPH76hJP/RN4lkBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738741805; c=relaxed/simple;
	bh=SNm9MpglJQDoJnDJ815PilHQCDSPydoa4y4Mk5XlWAk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kITXEq5E3gYhkvJm39p1+R/RQcp2+Rvm1IDRlWq94a6Hi1ArgJ4UAohmi6Yws4gRQKrg2Myqlb5KcldIflA8Oh+Jc1+bwr8VbIui5jOw+4BBFwCP20iC+8n3D/ED0ZbEhNYvGjNLNS++Wx9mAnA3Awt7e5KZ1VTSUN4mJiZfiCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iBI7Yd1J; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738741804; x=1770277804;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SNm9MpglJQDoJnDJ815PilHQCDSPydoa4y4Mk5XlWAk=;
  b=iBI7Yd1JVHW7xr5ehqDnR1Du4DqGWsmVl522u87Sn7an60Vi+ewmdvQ2
   BFqPwO7Y1ar+QnDUh8i41xcTjP85B7NmMMy5W5RQ5N7wst7Wdoznp1zUf
   WE3ysPeEqUykdYnnBU2/l/HTtdrURkEOXJuh8nbjIfHJcUo6uLQh/nTww
   hVQLsUosopnPi8aUXgAPGcQJH5RSWa0j2xmoYuuYD0ijRQCRM5SGwICyp
   Ss+oUSvpcL9j318umit0u61n0Rm0e8FRjIPhQtoqA/UeXg5PdDizMR+/9
   zXKyeFVumbtLQYzK6Q//xqre5ZHocfu4mYJW8mmXKQUDA/xS+k0MOdvJK
   g==;
X-CSE-ConnectionGUID: KT9rjK2GQmicja6zOZP42A==
X-CSE-MsgGUID: ZTw7/fy7T8CMWfEEIuPtIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="61763883"
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="61763883"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2025 23:50:03 -0800
X-CSE-ConnectionGUID: bl/If7DZRXWU8kfNad2Q8g==
X-CSE-MsgGUID: Cx76SG3xRwqFg/tm240zkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,260,1732608000"; 
   d="scan'208";a="111409749"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Feb 2025 23:50:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Feb 2025 23:50:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 4 Feb 2025 23:50:02 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Feb 2025 23:50:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yru8BwcfW++utPaQL2XNScYaPSlMJMMaH8PZgp4L+e2OJ0jIvF/QifUfx2/GPf/Yif3MWcCU091sqzfJafel+ptYlFgPXuqxuATzb607sgivem6BeN3cYYTJDbzIrbD5MP3zbwPsbsjNjJYEFOt28F0/zZ/+CFlbINx3jY5QpU4d4Ga+Rl+O+fdeoRKmVbHSxAlESOm9mICpwF9uQTZRnQ7ylxCboy9J+LllTBCcro9jNrjURpx5Tzzyh0Yc2onc5LP/sb08XkGS8/UD3j35zxiYVg+HJ1VtK4U4zwOtXtd5NONrbRSlxVxTLN0d86W8/jt43PBYqGL/+pt6/qjt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNm9MpglJQDoJnDJ815PilHQCDSPydoa4y4Mk5XlWAk=;
 b=P6rlY0X4V8AFLR0zxKPkqcqT6DxGxIpCHR+tRE0HKa2xE0Rt5ou3hWotkDVQcU7/4AaBudD7TImwMMXxOa/t+TvDgbsnyUmHGwYvDxbU5En/rEyLn1Gp3idwBg9006U6oUbFa/Zon2iClZMBhB8N2ZxbHnfOffgbM5WGCL/BhDZgpQEbDl8Tt8Aafx5/AjYmsUquulwfp5nRne0R51UuFhcXysbZofeS+KI+FNahSb5ArB5a0bFFR9eA/E5b1RyW7b99kEiPWPmE5ma2bYJmANN8U3b+jRz0BRn2zItjghMN6eWQVk3rXNNW/abU5RxTsGVSr6SsgOBEc8Am4DeNyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15)
 by CH3PR11MB8749.namprd11.prod.outlook.com (2603:10b6:610:1c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 07:49:46 +0000
Received: from PH0PR11MB5064.namprd11.prod.outlook.com
 ([fe80::33e9:2b0b:5259:ff9e]) by PH0PR11MB5064.namprd11.prod.outlook.com
 ([fe80::33e9:2b0b:5259:ff9e%7]) with mapi id 15.20.8422.010; Wed, 5 Feb 2025
 07:49:46 +0000
From: "Xu, Min M" <min.m.xu@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Wu, Binbin" <binbin.wu@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "jgross@suse.com" <jgross@suse.com>,
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>,
	"Xu, Min M" <min.m.xu@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>
Subject: RE: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Topic: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Index: AQHbd4ErNs5CMFeezEGbcc2IJySmKbM4Utlw
Date: Wed, 5 Feb 2025 07:49:45 +0000
Message-ID: <PH0PR11MB50641EB8CA3EA442FF2A0ABFC5F72@PH0PR11MB5064.namprd11.prod.outlook.com>
References: <20250201005048.657470-1-seanjc@google.com>
	 <dbbfa3f1d16a3ab60523f5c21d857e0fcbc65e52.camel@intel.com>
	 <Z6EoAAHn4d_FujZa@google.com>
	 <0102090cd553e42709f43c30d2982b2c713e1a68.camel@intel.com>
	 <Z6Fe1nFWv52rDijx@google.com>
 <f1800b4f27554df2b2c538bdbe0a38419a231a09.camel@intel.com>
In-Reply-To: <f1800b4f27554df2b2c538bdbe0a38419a231a09.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5064:EE_|CH3PR11MB8749:EE_
x-ms-office365-filtering-correlation-id: c423ebf2-7f9d-438c-0b87-08dd45b9a8cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T1lNcTdkV0J5R1Jmbm1rVldiS0pqZXg0TmxXdzNRazl0Vk1rUjJzNHRtWFRu?=
 =?utf-8?B?WEJaUWpUc1psSjN4VmJOMmcvS3RiZXVONUVyeVI3WGRrZ0J0SHZiUElTNUlz?=
 =?utf-8?B?TFJaa2N5VEtWakNhemFpSE1aMGxBS3pUNGZtaUNhR2p1NHBCcG1yRm1seXd5?=
 =?utf-8?B?MnFTc1dUa3p2WUd6Z1B5SUVWd1lRWXN1NTRsdFY0YlBTSWc3U2xGbi9DNHc0?=
 =?utf-8?B?K3lRTWprY0R1L1ZSYStYbWFEK1o3emU3YVh2TUt1VmFSWnpjSzdDL3FuYXdm?=
 =?utf-8?B?ZllhOUoxcllYMVhycmNvVUpuYm5Cd3FkVnROUHZnTmY2enRoVmZ2UFdDV2di?=
 =?utf-8?B?bDM5RUJSbWVQdFFGOEtJaU9sTnZWWmZsRFRBS0NJMm5kNG5WYUdtb0llTld5?=
 =?utf-8?B?a2NLclBrdmdXSnhsK2k2MkZ0TDJzNUFxMU0wZWRtdDBOV0Z4eDR2aFlUYXFB?=
 =?utf-8?B?dVRRMVI5VjVJdGo3Z05ZZklIRlkxRm1LdGJTeUxadVRyZUJ2M0JhMFUvT3JK?=
 =?utf-8?B?MnR0Q010NGsyWGd0VUdWRFFJRVNpTDR6ZlVaNkMrbW50TmZCMlBsTzJvek5L?=
 =?utf-8?B?b2VIUnZicm9HVVNXWVJ5OWJJK0FWOVlmZDBoenNwM25hcXFYWGxXSW9MTFNE?=
 =?utf-8?B?b3d0VU45Z3FJYlFrT0psVnNQMGRoRm1iTkh5ZjdoRkVZam1ZekQ2YlZGNEw2?=
 =?utf-8?B?T1hCdUQ1ZjZ6U2VXNFROUzcwWmJKdGM2UTRzVXFKckJWbGRBLzdTNEVzcVZp?=
 =?utf-8?B?eWE0d2tPaUo1WGRSVGZUMnB6R3YzWWZNek0rVFpGWGVqS1VFT2xsS2x3YmFZ?=
 =?utf-8?B?a0JqVm5FdVRUWU9QN2JjOWk3Rno3ZDVrSGF1TFF0UDlGOWgzZGw4czFFaGRp?=
 =?utf-8?B?VDBpZmRITnhDNWFGdHpCeWY1ak1vOUF1SlU2anVBOE5pdnR2WWUyRjVkc1d6?=
 =?utf-8?B?RTR2NllKYmVFVmNXOVY1cTEvQTUzbVVYeUNKZXVPMFpINVp6UHhGaUNBV0c5?=
 =?utf-8?B?aVppd0N2WjgyYVp2cFFEK0ZzMzRjanRZOFRPZE95K2wvK1NLOHRWQjlvR1I2?=
 =?utf-8?B?U0luVjNvWVBReDA4TlF3c3g3NnVOT2E0OWVKWHBNVDEyL1VENWdaQVF3cUly?=
 =?utf-8?B?WXpZNmNicFdaZjJSbjBqKzN1Nnl5NjNVWVdjaWYwUmhDNWR0RExGQTkvNzBC?=
 =?utf-8?B?d01jNUNMNG5ISjhSbTJsNkQrOFhiZzRTU01yU3JwdzgvY0xOeTVJeHpSVUIw?=
 =?utf-8?B?QnJXUVViMFQ1cmxCYlFYVzRRblc5Qmg1dnYrK3BsbHZ4STJ5MXk4aUdLWVpp?=
 =?utf-8?B?Y2ZmOXEzdEFYS1FpMTZsQjZrQmdCWnQvWFZoME11Zm1oeTJ4UVJTdmdmY05P?=
 =?utf-8?B?OGlvTHJQK3l6Q214YXRoMVBlYmFMMCt1T0kwcTNmMVNTOVl3ekFwNUNFRnRs?=
 =?utf-8?B?VWx3TitVU0dVb0JMSGdLNjkyUzBjL0Q5aStEbDM4M0FUeEhRTUg2YmVQN3hZ?=
 =?utf-8?B?ekIvVkc1c3Q2UGU2TG1XRlBMQ282MkRqbldxbVhWUGQ4dFdyZ0xxTzVQZkND?=
 =?utf-8?B?UEhYSHBTTVhkSTJFU2RSdXM2VExRM3ZDcDVSSmk3TmE0cm03TlpURThVU2JB?=
 =?utf-8?B?T0ZUakNQTFVTNXpidVdLUG5WejE2TXFvQm9wcGJZcCt5RE9hdFM2bklQLzZu?=
 =?utf-8?B?Wk1VVEFzanNZampwaktWTFE2bUZwdWFqeXlNUmJTSTJiaUlUY2RhcmpHMTN3?=
 =?utf-8?B?amZoZlZzY3BuSnd6VkM5U3JUU2FaSzQvNVQxT09XeUo5cFlkbCtJWGNzaDUy?=
 =?utf-8?B?ejdPbk12NlZLa0ZjbENxSTk0bFZzNFVkTlh6Ymk0ZXdYMW9EZzZRL1RLdVpo?=
 =?utf-8?B?cXAyS2ZCWWQzNkdCNEpxcHp4dXBSa04vNmxRVEduK0pOUHZ4aHA2ak9CTjBh?=
 =?utf-8?Q?fz+XAhm4SCeFGO70JV9jd1sLQGDyVGgL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5064.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmVKUWNReXFvV1RoVEY5SHQ2eWtjbGJObEh1MUVqOUYweEFxRmtYaFNEdElV?=
 =?utf-8?B?UU84c1J0R1VHZ1lOWTBFWnlnNEtqTlNrN2Q1eXErZnFBVVNoakNFNGtyNE1Y?=
 =?utf-8?B?V096QjRnUklmZXJwQUIySDBwOFR5OGxDS0tDRjUzckJiekROMDNhODNHbEUr?=
 =?utf-8?B?NkQwU2o2SHBIWmExTExiei9IL21ZY3A3TjdUbi9zdmppVU50TG5RSXdVSldJ?=
 =?utf-8?B?Z0o0a016aXVVc21nT1hFUVdHVmQ2dFBWVVhJaEJsVTRKWXNIS0w0SU1HcW05?=
 =?utf-8?B?Q2pHOWRld2IyWlJxMU1FZDR6bUd5bDdZSFZOQ1NzSm1nRFlCdWR4VnFoZ3lB?=
 =?utf-8?B?ZjZ1c3dua3BLYVdDcmVnbHEySFY3TmlrN1FhZmt4UVhva3JySlZJMnZtN3Fn?=
 =?utf-8?B?NlA3UTluckhBMzFybmJlWU9YY09DZ2RXb0tWazlFSjdjMHdxVkdMYkw4NXRv?=
 =?utf-8?B?UXE1RkpEalFmRTF1N2V3aU9GeEN6VWd1UHg5WWRVSDA5LzJ0SEJBYTlyU3c1?=
 =?utf-8?B?VENOVUtadndoOWJGRnFmQjdITXk3Q2w0aGZmd0NFZXJhb1ZSdmdLZ0s2NTIr?=
 =?utf-8?B?Z1RuTHhRSkxvYUZsdm52bHhaYmJYVkNNTk13NHVSMnN6N015cCtRcXBVMitp?=
 =?utf-8?B?UU90Y2NwZ0VQb3JNQmhTaDl3aXl6bFd3WnJvWll4SHVSMHN0L0JsUHl6Q3k3?=
 =?utf-8?B?VHl6L2xkWXQyS3RDaXltQzRpSWI1bzFNVXpxWVZHVXVYcml5TTRDaU9Odzhi?=
 =?utf-8?B?WHlNVEd4UGFXUjhBMUJ4TlNPOG1VSkExeGs2aWZWelVxYmlsZ2EzcGU0NzMz?=
 =?utf-8?B?VUIveDZHZHdyTEVVNkV2dzlucmZzSzRIU291WllEWTlWb21IL091Q01SY3Zy?=
 =?utf-8?B?RWxodlMxVXBUdGYweFhUcklydVJQNStDODJnVFdDeTRMeHRDMERacmNQdG9C?=
 =?utf-8?B?WlgyQ2ltZWY1VWRXbUQ2U3hQcmZpV2NUTExLOHlicWo3K2wycW9MK1lTZGlX?=
 =?utf-8?B?cTJSelRLZEZFMFR1dW9XOThsQ1I1MHVlTlFETUNGMVVMQlJSdjA3eXFrZlZS?=
 =?utf-8?B?QlVkQUF3anlaSFN2U1lEbXQwSjhCSDlCa1c2Z1VNY0J2K24rTThMemhJZHRU?=
 =?utf-8?B?NFd1cnVuZUtPZXZOZmV0aFRFM1ZrVTg5YWg3ZkdUSXNsR3o1RGowRnc5akJo?=
 =?utf-8?B?N3pCSXQ2QkRBaXpYSWxlcHBOTlB0VkhNSVNwOGZFck4yK001VHBEZzFPWXhJ?=
 =?utf-8?B?NlFjTy9GQTVjWXpBTm1vZG9vZXNRRDZDUldpQVZkV2hHQTlLMFJQaDc5cm5x?=
 =?utf-8?B?K0JJWkhwZWtZcDJpWHYxUCtydnR0SjNJSWVwQjFaOFBwUERVVmZhbmY1UVhw?=
 =?utf-8?B?NWdwMTJqMXhXSTZXMmpnWStWdmFsaXlmSzNBeUYvZ3laRG1qR21GNWVGbmZK?=
 =?utf-8?B?RTQrTjNZOHk1ZFowM1FOV3pmbzYvc3l4U2ZzRWhwWWVKZWsrdG1qT2l5ZmI1?=
 =?utf-8?B?dTNzUUphTHI5ZnFtWGgvMXV2K1BpemgwUWZoUEw4TTloQVhwTmxpZnF5Skd4?=
 =?utf-8?B?eGdJUFB2cUE5QU1vY2ppbTJWTzV5dGQ4QnN5SWd1NjRVVkNEd1pORG96R1du?=
 =?utf-8?B?ZldoYmo4dzhlaHp3ZXpuUVdTUzVuelBYNE9aR05PSWpleG9FZVVWME1HL1dM?=
 =?utf-8?B?TTZPUzB5dzRVN1VQK05sVjRKbGEwWWxKRzQvcDV4NEQ1UUxHeGh1d2M2S3Zk?=
 =?utf-8?B?U3loRGwzTU9kQXN6WmFYWU9qVk92RHo4aFF2Yzdma0RNVythUkptdHUxSWc4?=
 =?utf-8?B?QktOTXlYS3ZvNnJHanN5RHRvaTA2MFZ1Z1hZVCtxSjVPODQ0dkxpNkh5WTAr?=
 =?utf-8?B?MldrS3BQYjB6dUI5dUhEWkcwVWRocThubmJqdjBFS3lRZmZuQlZ5WW9qRFpl?=
 =?utf-8?B?M0NQV1lBZTN4L00wVmRNaE5SWHRSSndvdTVjeTNwNTRyQnB0dXFiR2luMG41?=
 =?utf-8?B?MmNYYmpVVzI1MVRlaXFSd1VQdFVoNEtLbWd2anlEMFhPaHZDQmphUTRmUXIr?=
 =?utf-8?B?eWh2d3JFZFN4YjQ3ejcwM3pmaFV5cGI0WjYxTllTK0RSM29VWnpCT29mMXlO?=
 =?utf-8?Q?3SmQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5064.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c423ebf2-7f9d-438c-0b87-08dd45b9a8cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2025 07:49:45.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YtfmFzAQ0bZorQ7zbRFmrx9Vl8qNLajAhiu40RdK4bvD1ZpqZ0oqrj5UUQe0yOEf7JPMhsHuO44uoHjD5eulZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8749
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBGZWJydWFyeSA1LCAyMDI1IDExOjUxIEFNLCBFZGdlY29tYmUsIFJpY2sg
UCB3cm90ZToNCj4gDQo+ICtNaW4sIGNhbiB5b3UgY29tbWVudD8NCj4gDQo+IDNhM2IxMmNiZGEg
KCJVZWZpQ3B1UGtnL010cnJMaWI6IE10cnJMaWJJc010cnJTdXBwb3J0ZWQgYWx3YXlzIHJldHVy
biBGQUxTRQ0KPiBpbg0KPiBURC1HdWVzdCIpIHR1cm5lZCBvdXQgdG8gYmUgcHJvYmxlbWF0aWMg
aW4gcHJhY3RpY2UuDQo+IA0KQXMgdGhlIGNvbW1pdCgzYTNiMTJjYmRhKSBtZXNzYWdlIG1lbnRp
b25lZCB0aGF0ICJGb3IgTGludXgga2VybmVsLCB0aGVyZSBpcyBhIG1lY2hhbmlzbSBjYWxsZWQg
U1cgZGVmaW5lZCBNVFJSIGludHJvZHVjZWQgIGJ5IHRoZSBwYXRjaCBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvMjAyMzA1MDIxMjA5MzEuMjA3MTktNC1qZ3Jvc3NAc3VzZS5jb20vIi4gDQpG
cm9tIHRoZSBkaXNjdXNzaW9uIGluIGJlbG93IHRocmVhZCBpdCBzZWVtcyB0aGUgcGF0Y2ggKFNX
IGRlZmluZWQgTVRSIGluIGtlcm5lbCkgaGFzIG5vdCBiZWVuIGludHJvZHVjZWQgaW50byBrZXJu
ZWwgbWFzdGVyIGJyYW5jaCwgcmlnaHQ/DQpXZSBuZWVkIHNvbWUgdGltZSB0byBpbnZlc3RpZ2F0
ZSBpdCBhbmQgd2lsbCBnaXZlIGFuIHVwZGF0ZSBoZXJlLiANCj4gRnVsbCB0aHJlYWQ6DQo+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI1MDIwMTAwNTA0OC42NTc0NzAtMS1zZWFuamNA
Z29vZ2xlLmNvbS8NCj4gDQoNClRoYW5rcw0KTWluDQo=

