Return-Path: <kvm+bounces-15095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C4538A9B8B
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EEAF1C230C5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BC2161912;
	Thu, 18 Apr 2024 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="Zd0CzS5a"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2111.outbound.protection.outlook.com [40.107.135.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C6415AAB7;
	Thu, 18 Apr 2024 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713448005; cv=fail; b=NzVoA7Q0cYOZU87584knNfSCIiM8zgwr2vvbGG/dN7xrowSvODeZKw8ZqtNMdO5AmUD12JpKC8s4r2rCHTbSnIq8VDD7+xojgZEGdVq9RLeTGfMlrRtvcfdDHZzTQR9prR65dJeT5lx43F5bQRFOhEnHDKgrSgJMIElmQLwCZPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713448005; c=relaxed/simple;
	bh=RhLZfhZte2nCWYFVZ3bYFYyGLq19InA/kbKRglsE75w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DQuwk58ambp18eaTS/JbszixSHOLSBT6Uvvbs/6Ml3c3Lioyt4qltfmDcI8/FhzGfiyGHiVxTkesVWVcmlCj7JhI5ZEBA1J5HOkJPb3sfq4rV5L5PYly1VlSO6SGDayCvto8A8NvmULXORAMBrNFpKS01LPwgiIjsn2Xs/uApx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=Zd0CzS5a; arc=fail smtp.client-ip=40.107.135.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEw3bCtDSPaAQ6C1koDeznyzJYlQ7dha9hmdxlB1YbW59lvO2jTWtsFmk86RraltzpBYbbxy0a5h5+dUzQOsA3hxbw+oNXdUVqUXL8jgBl6o4fK/g8O5HHsJx8xY5+GMQiK7fga4iRahqAuualSUK5QfcLhgIRIQHQowG+G3Fm+7krjwqqRlhsN7Tjk864I5v8FJcXxCd5wTyj1vtZ/FVepY0QVGURVxPKrKL/RNKhHpvGg+V0kt0SIHfHC35/l0br1hgea2Y9+vRy9Gl5o79SQu7OEuJNykcj/Y2ZGr7dzmlWii0YasncU5783yB1wmGa6pTDzP4GnNSrNRo5tVOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhLZfhZte2nCWYFVZ3bYFYyGLq19InA/kbKRglsE75w=;
 b=b/aIe9kWn/Rho1MMnULmeo24+Z3oRMI+h6kfnCtnJfTIYK0+bBcJUE+clQT44HywdmWp4udIkC+50H6hiHpdBXbi05rBh/mNV7YexyuZ72mEza+C6bc3KkvQ2SFbWOqfMu+hscthW9MWDw+YL1RYzSoUPXBOz+xOSvzXbA5mCDVVPclxT+ASJEanDOUHGycvK7SMaQotJLkk53tuWgoyk7EsO33PS8xpcr45wUIBTGr4yMrxjCWAUWn/ZjSBI2/XBNpW5hs0LXhY+iW4tOBdKHU670AmPRITX+HCOiQxbx6k7vsAp1UEUr3v3g0l5jLlodsHJyshrg83Gvmo0ybJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhLZfhZte2nCWYFVZ3bYFYyGLq19InA/kbKRglsE75w=;
 b=Zd0CzS5aGsdTaIric7jLG6Ty7j5jTNdCKTQ3PzK7ceWUVA83XM+VrE1DmIxQLyjVDLdbHfubtQPUFiZndExCvnoNzVPpmcY8hlUkKLIBj/FGeKMZ2p3xlh3tYWtrc3p3TNiogEIe0hbJsO4cIFz1nKH/6piuNVqnNJGX1fpiZoIwXdFqrSYP010f0ynTpLOnmxafRx6pBhZNnMyNZ5+/yAZqPV3RQKnOpNMWpxPAbcTLTc1c+a6PvOHWV1ButODXX17EPKDgcZgwIXcy1Q9Bx4pVoW53Ia1YP6lUBl9TLhLsJc6LsN5vIgDFbIBdrj4fJyMf62fmSXLABH+vlo5cPA==
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c3::11)
 by FR2P281MB2860.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:67::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 13:46:35 +0000
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75]) by FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75%5]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 13:46:35 +0000
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Topic: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Index:
 AQHaj/q7SvbB6thKm0KGE0qK9A01DLFq9pcAgAAJW4CAAAKJAIAAJXoAgAAKGICAAT2zgIAANBgAgAFp2QA=
Date: Thu, 18 Apr 2024 13:46:35 +0000
Message-ID:
 <70f9f3f847e614cbb95be4c011ecb0a5cbd2ef34.camel@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
	 <Zh6MmgOqvFPuWzD9@google.com>
	 <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
	 <Zh6WlOB8CS-By3DQ@google.com>
	 <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
	 <Zh6-e9hy7U6DD2QM@google.com>
	 <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
	 <Zh_0sJPPoHKce5Ky@google.com>
In-Reply-To: <Zh_0sJPPoHKce5Ky@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR6P281MB3736:EE_|FR2P281MB2860:EE_
x-ms-office365-filtering-correlation-id: 3216d353-e57e-448b-9976-08dc5fadf695
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?RFFtSzM3MlVYRnlrYko4aVNXRFd6Zkt3RzVoRkZUd0tMbEdBcVIxWjJWbi9C?=
 =?utf-8?B?Y0ZIUDUycEFibkxRQWVNNXBzS3pHbm9DN2hzVkhHaWJyMnNNMDZpaHVHMjZ2?=
 =?utf-8?B?a21xeGJ1ZWFBVWJEemgzUEt1Skc1b3dZd0RIZVp1SC85WVNmOUZLL0cwSU1K?=
 =?utf-8?B?VDI5TUY4WDlWWGROYWNLMFFBMVNEM2N0REhiTHpvang0eHR4d3NPQ213Qi8r?=
 =?utf-8?B?UzRqS1RxN1hKVy9yakZUdU82Tnh6NXYwMFd2K0prZEt0b1QvendTdU5rZ3Ay?=
 =?utf-8?B?eFVvYkFCMkpvQkp4RzU0UlB6d003RjJBL1U5Q2JIYm5GVXJ6TkJYdEJRZGZh?=
 =?utf-8?B?SzdYL1VnZHZtaVdrVmZNNjdjZVlMYVJGeTNoMWFtU1p1NERCZFR5QjVHdGxj?=
 =?utf-8?B?SzhOajJhUCsrVmd3d0Zxa1l3U05uSEN4WHVvdTdYbjk4UWxtUmljTEJvV1BS?=
 =?utf-8?B?NFJwMEhlQmNzQmw3VjZMejZyMVJXdGlBR1NkOStSL1Q5dEtaZ3FqSTErcGwy?=
 =?utf-8?B?N3lhN1lub1lvZmUwa0s0cVgrenpjNzF5ZWNuTGxUMFpWNVdaSDBRa1BuKzV6?=
 =?utf-8?B?SVNmMWxYYnVLU1ZleWRIOGwzbzQrUHNRdWUyQmtRWmFadEFTMzlWOGdYZ2M4?=
 =?utf-8?B?VW4wdGZXazg5VER0Q2NiSUw1M1hBN2o5bGhNd3ptMW5taE12NjRnZXZXWm9H?=
 =?utf-8?B?WCt2NTJDK1VGalA4RGF2dUR1bUgzK0xaK25QZiszZFBJYWZPTDhxWDJRNnRO?=
 =?utf-8?B?RjdQNG5Ta1gzbmFEY0NObGpsOWFnMk1IU3JxMEQweUt0dlRub3Q4dmFTZ0NM?=
 =?utf-8?B?aU1objlvaUV5Um9ZMmw0UGlTZkVQY25JYyt2L3c4OXlBODBhTU1DblZoZjI2?=
 =?utf-8?B?RUFIMk0rNHlGUmlUdVc2bWFRazMyTjIzMS9jYlM0dTdXVFQzV2I1S0s0UURt?=
 =?utf-8?B?TlRuMm1WVlM1aWFTbU9henptUVlBYWVzM3pKTUVUUWdwbXVueDlMZWZsUDd4?=
 =?utf-8?B?ZnVRdjV3dkZYQUtGT3lpRkw1WStyT3RYQU5hdWU2NzdTTHc1akJidjBpR3FM?=
 =?utf-8?B?cm1EYmtmZHFkWmpvOG1HQUFSYjJqMit1a3UvdmRjNGhwK1RibG5hZjY1UTdF?=
 =?utf-8?B?MjZUdlpHNnJ0bzk2dWhlV3ZxWVplUlhKU3BzcElaY01abk9HTEJmanlrY1d0?=
 =?utf-8?B?NjdWOUFzUU0yY0xrZFE1aS84YmJ3d0JlUWUrZm84TGdycnpmZkxjTjZVNjBr?=
 =?utf-8?B?cUZkMkJiWmMzL2RPRUdVbmJjUGp2aEV2eG96T0tXS1hvZjF1M2twRTJkdDBN?=
 =?utf-8?B?SWhZVlFSbklQRUFtUitTaktQbUJEWXdPQmVTNU5DU21hN0x5TngvbGFNQjdH?=
 =?utf-8?B?MFk2bC80eTYrVlEyY3V1Szg5MytjeEszWEtNd08vQnR6UkZnOW93SmZxVjJT?=
 =?utf-8?B?cHBwM2xSeWY3OURpemlYWjhCQVpDenJPam1JVzZDdWlSbTVxUytYWE5ieUla?=
 =?utf-8?B?L1Zua3pEUGozODhDTFEvUXBOTmR4UXNhOEZpRVkrQVVZcWFvYkdWdWZhZE9l?=
 =?utf-8?B?VUF6SjAzakRIczliZHlCWWQ3ZjZJYnd6N05mUnU0dk9pZWhNT0VGU2MxTlNK?=
 =?utf-8?B?WkhPRTF5TTk4dW1raFZSY2ZtTm1CUEpNemJsUHIvUGEweXZZemVXSjdPdEp3?=
 =?utf-8?B?VXUzcFAvejllNDZaQm9FdGV6OVJxRkE4R3pwakhVOEZ6azhYTlR2WVlGRlc1?=
 =?utf-8?B?cmM1cmt6WjZ4MU1oWWJtSFROdDZRTlhOcTZ0ZmdXbzNheDRIK0kxcUx3Vk1l?=
 =?utf-8?B?ZTVJODkyWjk1RTE5ZHRBUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MmJ1OTFpbm9peTVqNWxaaWFuV2NpOG1VUTNnOGxodndZMitqY091Uk04cmdQ?=
 =?utf-8?B?bG82MHBxU2k5REtYazRLVk05SncxV2ZhbWtGWHN4OFZKMUMyNkt2ZkxScXRE?=
 =?utf-8?B?U2dnenlpOWdldGltNmppMU1UNEkyM0hRQ3d5Y3FKdDVJZWdCSWFoR1JJVjEz?=
 =?utf-8?B?dDZkVHZpcVNzWSt6TTJPMjl2NDRTT2ZYUDViTE1mbC9WeVFSVjZOTktEVUow?=
 =?utf-8?B?M3c1VHVkZ0lTYy9VUnowZm9rMStKdzVSNnZTM21HUEpzNXpYWlc4U25PTDJp?=
 =?utf-8?B?bUwwbkVlb3FWVWRQWDlZVW9sZEUwWVllR0JiajdralZnZFpORG5RTkdUNHAy?=
 =?utf-8?B?QllVOHE1dWNCTllnallKRkl1R0VGQ2VPOUwzTUEvRVBXcTZDLzNXK1pSYnYr?=
 =?utf-8?B?ZE9lR0hDQ0NJVmlnWS8wdURIN1lyWVRnWk50T1FZV2NsUEk3R0paYlBPOFkz?=
 =?utf-8?B?R2ppZkZwK2FLMUI4UVU4cmIwc0JxRTRxcyszM2ViMVkxMmd0cWZrVmFMMTVx?=
 =?utf-8?B?VEFVdDNUSkM1ZmpKems2SGxlY1g3ZkxwWHhNWXRrNm4wU3c0MmxvbHhDamUw?=
 =?utf-8?B?a3hUcVg5RGxic0RJS1ZHZmcvN1U1ZGtvWWFib05VaHF6VW80UmtUaVJCTm1C?=
 =?utf-8?B?dTdYWDVURUorVXdTRUtFRnpyRG1WV1VOdnBvRklNV1Y0bUcxWk5nMTIxQ1c0?=
 =?utf-8?B?NEVWOGNUMkZJcWtwTk56bmFIZEU2cmhNSG9aK3NWdU9SeFJONEpPbkswTVJk?=
 =?utf-8?B?WG5GTWtzVmdoUU04eDQyN21ycWxWL2dUd01sdndzTGM1SGJSOWxuanFIYytT?=
 =?utf-8?B?eG9RUUw0YjZXTEJJcWRiUG9CbDRoQk1TS1IrazdaQ213ZVkvdGFNN2Z3a3Az?=
 =?utf-8?B?VWxPclBRZGJlRDVaZ09QUVp0anZFbHR4bnFiY2ZIbjZBNlVHTjNaMGpqR25S?=
 =?utf-8?B?bUR2TVNWSUlVbmtFQm13emRzSFQ1NTdKb2xUb3lNUGovN3orOTg4Mnp1cHVO?=
 =?utf-8?B?WER6dGtRNHRNbXc3WGtWK2dsNzZTWDlqTUtxRUFqY1Q3S1RRZDU5d2xzc0lP?=
 =?utf-8?B?STFoSHpVWFZDQnY0OGt3aHphTkxJd1ZiT1QwZzlSOGtKWEo2eEZQK08zb0NW?=
 =?utf-8?B?eXhla2RMbk1hdk5SK1NWZ1FDdkF5c0pyUjV2cFBRQnZKdEU1SUVSNWM1TXRL?=
 =?utf-8?B?Q2sweTBSVjU3aU5tZGE3RGljWlVHOEh0ZGwrL1Y1TUJXQmJFcG5JVTRzbmVm?=
 =?utf-8?B?YnlpTkNDd0laRmh0RHo5RGI2a2drU2NOZDNqbEtyMmp4WmxNcEVncjFTTWdB?=
 =?utf-8?B?NE5qQVdSUGdaVUJWQThzLzRwbDI1b2F0ekRPWm1jbHQvNXk2VS9ZRWN5T29z?=
 =?utf-8?B?SE5yZW9lSG15c0NBNWFDMUl6b2xvUGtzUHAycVc3MWI0SzNldExDVHhNVm03?=
 =?utf-8?B?aXRoUTFFdGNnOTRJVDhlcVZQblJHSmNQek9wRERwZHJ6aFFHOTNmeXg1N2Ur?=
 =?utf-8?B?UFZnRm5IY0pTWFc4V3llYmhScEdyd0kySWdYbTVUbEkrbVRVVzV2bFJCckhF?=
 =?utf-8?B?SXpJNVdCcUp0LzN1QzE0OUNuSlRKM0RJT0FlZXp1OS92SVpkaVdOQlg3RDdR?=
 =?utf-8?B?MVJOY2REaUtMZjVGMWJZZm9TKzQ1YlpONURZRVdMUG9qTnBOK0tXbG1WSTly?=
 =?utf-8?B?T2dVQ3UzdGp2bFN2THJicnVNMFNQY3kzY09UOUxUeVFUQmxBSEd5d1VqOU4x?=
 =?utf-8?B?aHpQb2xhbjJncU9qUE1xWTZWYmN2YklIOGZTS1RCbFpDbmgxOE9lZFJEZ0ts?=
 =?utf-8?B?S0owckx4MmtjOWEyaHNHS05LQ1p4bnI0S0psV1RzbXRGUy9SZzVFOXRPWHF2?=
 =?utf-8?B?NlNhLzRaNVJ4YkRYc1c1Z1lTNndsWHUzNHVaNHI0N3RjN3FsSjVTS3BndW9n?=
 =?utf-8?B?SjlRZSs5Z01WT2swZE52SE9RaEFtTTlrZE1yRnVxSWJHTEtGL09mdFVSanFr?=
 =?utf-8?B?MFU4Z1F6UnEzVXZERmVFUU82SzBnTzJJa3pvOWFvaWUvZUhmV2N5MGVRNW1W?=
 =?utf-8?B?dHBPZGVpYkNKaEFpdDYrVFg3V2VmYVhSZzJVTjFHejdRd0tnRkFla3lGZ0xz?=
 =?utf-8?B?ek1tMmVqK0ZrVHU4Y0RaT3N5OVIrY094c2JKS0ZMNXBuVkFSVmhBMCtXSVRP?=
 =?utf-8?B?TDFwMWVMbWd6cVdaN1Jybk1zQXUrNTh5N0RDTDF0d3N5WnBrN1djTGVGMzhv?=
 =?utf-8?B?SWZkWnROdi9QNHAvZEp1Sk9hZnF0TTl1QUtnblQrVmhxQjFQYUZNWE1SeWU4?=
 =?utf-8?Q?caSkOhWI0P4I1uqvGo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB475A9422430848A17902323EF200CE@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3216d353-e57e-448b-9976-08dc5fadf695
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 13:46:35.0468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VDvjwcgMQbTU8PkWpj9JBWJM/F65Hg4tuqTX5a4wEVRoBZFeD7W0Q7xGXBsDDQspFZ31g6xEPJln4AoykDOJMMz9XXONw9xqkRG2Nje59Yo0vgawWImFbBMJz2nUoD7T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB2860

T24gV2VkLCAyMDI0LTA0LTE3IGF0IDA5OjExIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAxNywgMjAyNCwgVGhvbWFzIFByZXNjaGVyIHdyb3RlOg0KPiA+
IE9uIFR1ZSwgMjAyNC0wNC0xNiBhdCAxMTowNyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3
cm90ZToNCj4gPiA+IEh1ciBkdXIsIEkgZm9yZ290IHRoYXQgS1ZNIHByb3ZpZGVzIGEgImd1ZXN0
X21vZGUiIHN0YXQuwqANCj4gPiA+IFVzZXJzcGFjZSBjYW4gZG8NCj4gPiA+IEtWTV9HRVRfU1RB
VFNfRkQgb24gdGhlIHZDUFUgRkQgdG8gZ2V0IGEgZmlsZSBoYW5kbGUgdG8gdGhlDQo+ID4gPiBi
aW5hcnkgc3RhdHMsDQo+ID4gPiBhbmQgdGhlbiB5b3Ugd291bGRuJ3QgbmVlZCB0byBjYWxsIGJh
Y2sgaW50byBLVk0ganVzdCB0byBxdWVyeQ0KPiA+ID4gZ3Vlc3RfbW9kZS4NCj4gPiA+IA0KPiA+
ID4gQWgsIGFuZCBJIGFsc28gZm9yZ290IHRoYXQgd2UgaGF2ZSBrdm1fcnVuLmZsYWdzLCBzbyBh
ZGRpbmcNCj4gPiA+IEtWTV9SVU5fWDg2X0dVRVNUX01PREUgd291bGQgYWxzbyBiZSB0cml2aWFs
IChJIGFsbW9zdCBzdWdnZXN0ZWQNCj4gPiA+IGl0DQo+ID4gPiBlYXJsaWVyLCBidXQgZGlkbid0
IHdhbnQgdG8gYWRkIGEgbmV3IGZpZWxkIHRvIGt2bV9ydW4gd2l0aG91dCBhDQo+ID4gPiB2ZXJ5
IGdvb2QNCj4gPiA+IHJlYXNvbikuDQo+ID4gDQo+ID4gVGhhbmtzIGZvciB0aGUgcG9pbnRlcnMu
IFRoaXMgaXMgcmVhbGx5IGhlbHBmdWwuDQo+ID4gDQo+ID4gSSB0cmllZCB0aGUgImd1ZXN0X21v
ZGUiIHN0YXQgYXMgeW91IHN1Z2dlc3RlZCBhbmQgaXQgc29sdmVzIHRoZQ0KPiA+IGltbWVkaWF0
ZSBpc3N1ZSB3ZSBoYXZlIHdpdGggVmlydHVhbEJveC9LVk0uDQo+IA0KPiBOb3RlLCANCj4gDQo+
ID4gV2hhdCBJIGRvbid0IHVuZGVyc3RhbmQgaXMgdGhhdCB3ZSBkbyBub3QgZ2V0IHRoZSBlZmZl
Y3RpdmUgQ1I0DQo+ID4gdmFsdWUNCj4gPiBvZiB0aGUgTDIgZ3Vlc3QgaW4ga3ZtX3J1bi5zLnJl
Z3Muc3JlZ3MuY3I0Lg0KPiANCj4gQmVjYXVzZSB3aGF0IHlvdSdyZSBhc2tpbmcgZm9yIGlzICpu
b3QqIHRoZSBlZmZlY3RpdmUgQ1I0IHZhbHVlIG9mDQo+IEwyLg0KPiANCj4gRS5nLiBpZiBMMSBp
cyB1c2luZyBsZWdhY3kgc2hhZG93aW5nIHBhZ2luZyB0byBydW4gTDIsIEwxIGlzIGxpa2VseQ0K
PiBnb2luZyB0byBydW4NCj4gTDIgd2l0aCBHVUVTVF9DUjAuUEc9MSwgR1VFU1RfQ1I0LlBBRT0x
LCBhbmQgR1VFU1RfQ1I0LlBTRT0wICh0aG91Z2gNCj4gUFNFIGlzIGxhcmdlbHkNCj4gaXJyZWxl
dmFudCksIGkuZS4gd2lsbCBlaXRoZXIgdXNlIFBBRSBwYWdpbmcgb3IgNjQtYml0IHBhZ2luZyB0
bw0KPiBzaGFkb3cgTDIuDQo+IA0KPiBCdXQgTDIgaXRzZWxmIGNvdWxkIGJlIHVucGFnZWQgKENS
MC5QRz0wLCBDUjQuUEFFPXgsIENSNC5QU0U9eCksDQo+IHVzaW5nIDMyLWJpdA0KPiBwYWdpbmcg
KENSMC5QRz0xLCBDUjQuUEFFPTAsIENSNC5QU0U9MCksIG9yIHVzaW5nIDMyLWJpdCBwYWdpbmcg
d2l0aA0KPiA0TWlCIGh1Z2VwYWdlcw0KPiAoQ1IwLlBHPTEsIENSNC5QQUU9MCwgQ1I0LlBTRT0x
KS7CoCBJbiBhbGwgb2YgdGhvc2UgY2FzZXMsIHRoZQ0KPiBlZmZlY3RpdmUgQ1IwIGFuZCBDUjQN
Cj4gdmFsdWVzIGNvbnN1bWVkIGJ5IGhhcmR3YXJlIGFyZSBDUjAuUEc9MSwgQ1I0LlBBRT0xLCBh
bmQgQ1I0LlBTRS4NCj4gDQo+IE9yIHRvIGNvbnZvbHV0ZSB0aGluZ3MgZXZlbiBmdXJ0aGVyLCBp
ZiBMMCBpcyBydW5uaW5nIEwxIHdpdGgNCj4gc2hhZG93aW5nIHBhZ2luZywNCj4gYW5kIEwxIGlz
IHJ1bm5pbmcgTDIgd2l0aCBzaGFkb3cgcGFnaW5nIGJ1dCBkb2luZyBzb21ldGhpbmcgd2VpcmQg
YW5kDQo+IHVzaW5nIFBTRQ0KPiBwYWdpbmcsIHRoZW4gaXQgd291bGQgYmUgcG9zc2libGUgdG8g
ZW5kIHVwIHdpdGg6DQo+IA0KPiDCoCB2bWNzMTItPmd1ZXN0X2NyNDoNCj4gwqDCoMKgwqAgLnBh
ZSA9IDANCj4gwqDCoMKgwqAgLnBzZSA9IDENCj4gDQo+IMKgIHZtY3MxMi0+Y3I0X3JlYWRfc2hh
ZG93Og0KPiDCoMKgwqDCoCAucGFlID0gMA0KPiDCoMKgwqDCoCAucHNlID0gMA0KPiANCj4gwqAg
dm1jczAyLT5ndWVzdF9jcjQ6DQo+IMKgwqDCoMKgIC5wYWUgPSAxDQo+IMKgwqDCoMKgIC5wc2Ug
PSAwDQo+IA0KPiA+IEluc3RlYWQsIHVzZXJsYW5kIHNlZXMgdGhlIGNvbnRlbnRzIG9mIFZtY3M6
OkdVRVNUX0NSNC7CoFNob3VsZG4ndA0KPiA+IHRoaXMgYmUgdGhlDQo+ID4gY29tYmluYXRpb24g
b2YgR1VFU1RfQ1I0LCBHVUVTVF9DUjRfTUFTSyBhbmQgQ1I0X1JFQURfU0hBRE9XLCBpLmUuDQo+
ID4gd2hhdCBMMg0KPiA+IGFjdHVhbGx5IHNlZXMgYXMgQ1I0IHZhbHVlPw0KPiANCj4gQmVjYXVz
ZSBLVk1fe0csU31FVF9TUkVHUyAoYW5kIGFsbCBvdGhlciB1QVBJcyBpbiB0aGF0IHZlaW4pIGFy
ZQ0KPiBkZWZpbmVkIHRvIG9wZXJhdGUNCj4gb24gYWN0dWFsIHZDUFUgc3RhdGUsIGFuZCBoYXZp
bmcgdGhlbSBkbyBzb21ldGhpbmcgZGlmZmVyZW50IGlmIHRoZQ0KPiB2Q1BVIGlzIGluIGd1ZXN0
DQo+IG1vZGUgd291bGQgY29uZnVzaW5nL29kZCwgYW5kIG5vbnNlbnNpY2FsIHRvIGRpZmZlcmVu
Y2VzIGJldHdlZW4gVk1YDQo+IGFuZCBTVk0uDQo+IA0KPiBTVk0gZG9lc24ndCBoYXZlIHBlci1i
aXQgQ1IwL0NSNCBjb250cm9scywgaS5lLiBDUjQgbG9hZHMgYW5kIHN0b3Jlcw0KPiBuZWVkIHRv
IGJlDQo+IGludGVyY2VwdGVkLCBhbmQgc28gaGF2aW5nIEtWTV97RyxTfUVUX1NSRUdTIG9wZXJh
dGUgb24NCj4gQ1I0X1JFQURfU0hBRE9XIGZvciBWTVgNCj4gd291bGQgeWllbGQgZGlmZmVyZW50
IEFCSSBmb3IgVk1YIHZlcnN1cyBTVk0uDQo+IA0KPiBOb3RlLCB3aGF0IEwyICpzZWVzKiBpcyBu
b3QgYSBjb21iaW5hdGlvbiBvZiB0aGUgYWJvdmU7IHdoYXQgTDIgc2Vlcw0KPiBpcyBwdXJlbHkN
Cj4gQ1I0X1JFQURfU0hBRE9XLsKgIFRoZSBvdGhlciBmaWVsZHMgYXJlIGNvbnN1bHRlZCBvbmx5
IGlmIEwyIGF0dGVtcHRzDQo+IHRvIGxvYWQgQ1I0Lg0KPiANCj4gPiBJZiB0aGlzIGlzIGV4cGVj
dGVkLCBjYW4geW91IHBsZWFzZSBleHBsYWluIHRoZSByZWFzb25pbmcgYmVoaW5kDQo+ID4gdGhp
cw0KPiA+IGludGVyZmFjZSBkZWNpc2lvbj8gRm9yIG1lLCBpdCBkb2VzIG5vdCBtYWtlIHNlbnNl
IHRoYXQgd3JpdGluZw0KPiA+IGJhY2sNCj4gPiB0aGUgc2FtZSB2YWx1ZSB3ZSByZWNlaXZlIGF0
IGV4aXQgdGltZSBjYXVzZXMgYSBjaGFuZ2UgaW4gd2hhdCBMMg0KPiA+IHNlZXMNCj4gPiBmb3Ig
Q1I0Lg0KPiANCj4gSSBkb3VidCB0aGVyZSB3YXMgZXZlciBhIGNvbmNpb3VzIGRlY2lzaW9uLCBy
YXRoZXIgaXQgbmV2ZXIgY2FtZSB1cA0KPiBhbmQgdGh1cyB0aGUNCj4gY29kZSBpcyB0aGUgcmVz
dWx0IG9mIGRvaW5nIG5vdGhpbmcgd2hlbiBuZXN0ZWQgVk1YIHN1cHBvcnQgd2FzDQo+IGFkZGVk
Lg0KPiANCj4gVGhhdCBzYWlkLCBLVk0ncyBiZWhhdmlvciBpcyBwcm9iYWJseSB0aGUgbGVhc3Qg
YXdmdWwgY2hvaWNlLsKgIFRoZQ0KPiBjaGFuZ2Vsb2cgb2YNCj4gdGhlIHByb3Bvc2VkIHBhdGNo
IGlzIHdyb25nIHdoZW4gaXQgc2F5czoNCj4gDQo+IMKgIElmIHRoZSBzaWduYWwgaXMgbWVhbnQg
dG8gYmUgZGVsaXZlcmVkIHRvIHRoZSBMMCBWTU0sIGFuZCBMMA0KPiB1cGRhdGVzIENSNCBmb3Ig
TDENCj4gDQo+IGJlY2F1c2UgdGhlIHVwZGF0ZSBpc24ndCBmb3IgTDEsIGl0J3MgZm9yIHRoZSBh
Y3RpdmUgdkNQVSBzdGF0ZSwNCj4gd2hpY2ggaXMgTDIuDQo+IA0KPiBBdCBmaXJzdCBnbGFuY2Us
IHNraXBwaW5nIHRoZSB2bWNzMDIuQ1I0X1JFQURfU0hBRE9XIHNlZW1zIHRvIG1ha2UNCj4gc2Vu
c2UsIGJ1dCBpdA0KPiB3b3VsZCBjcmVhdGUgYSBiaXphcnJlIGluY29uc2lzdGVuY3kgYXMgS1ZN
X1NFVF9TUkVHUyB3b3VsZA0KPiBlZmZlY3RpdmVseSBvdmVycmlkZQ0KPiB2bWNzMTItPmd1ZXN0
X2NyNCwgYnV0IG5vdCB2bWNzMTItPmNyNF9yZWFkX3NoYWRvdy7CoCBLVk0gZG9lc24ndCBrbm93
DQo+IHRoZSBpbnRlbnQNCj4gb2YgdXNlcnNwYWNlLCBpLmUuIEtWTSBjYW4ndCBrbm93IGlmIHVz
ZXJzcGFjZSB3YW50cyB0byBjaGFuZ2UganVzdA0KPiB0aGUgZWZmZWN0aXZlDQo+IHZhbHVlIGZv
ciBDUjQsIG9yIGlmIHVzZXJzcGFjZSB3YW50cyB0byBjaGFuZ2UgdGhlIGVmZmVjdGl2ZSAqYW5k
Kg0KPiBvYnNlcnZhYmxlDQo+IHZhbHVlIGZvciBDUjQuDQo+IA0KPiBJbiB5b3VyIGNhc2UsIHdo
ZXJlIHdyaXRpbmcgQ1I0IGlzIHNwdXJpb3VzLCBwcmVzZXJ2aW5nIHRoZSByZWFkDQo+IHNoYWRv
dyB3b3JrcywNCj4gYnV0IGlmIHRoZXJlIHdlcmUgc29tZSB1c2UgY2FzZSB3aGVyZSB1c2Vyc3Bh
Y2UgYWN0dWFsbHkgd2FudGVkIHRvDQo+IGNoYW5nZSBMMidzDQo+IENSNCwgbGVhdmluZyB0aGUg
cmVhZCBzaGFkb3cgc2V0IHRvIHZtY3MxMiB3b3VsZCBiZSB3cm9uZy4NCj4gDQo+IFRoZSB3aG9s
ZSBzaXR1YXRpb24gaXMgcmF0aGVyIG5vbnNlbnNpY2FsLCBiZWNhdXNlIGlmIHVzZXJzcGFjZQ0K
PiBhY3R1YWxseSBkaWQgY2hhbmdlDQo+IENSNCwgdGhlIGNoYW5nZXMgd291bGQgYmUgbG9zdCBv
biB0aGUgbmV4dCBuZXN0ZWQgVk0tRXhpdCA9PiBWTS0NCj4gRW50cnkuwqAgVGhhdCBjb3VsZA0K
PiBiZSBzb2x2ZWQgYnkgd3JpdGluZyB0byB2bWNzMTIsIGJ1dCB0aGF0IGNyZWF0ZXMgYSBoZWFk
YWNoZSBvZiBpdHMNCj4gb3duIGJlY2F1c2UgdGhlbg0KPiB1c2Vyc3BhY2UgY2hhbmdlcyB0byBM
MiBiZWNvbWUgdmlzaWJsZSB0byBMMSwgd2l0aG91dCB1c2Vyc3BhY2UNCj4gZXhwbGljaXRseSBy
ZXF1ZXN0aW5nDQo+IHRoYXQuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5LCBzaW1wbHkgZGlzYWxsb3dp
bmcgc3RhdGUgc2F2ZS9yZXN0b3JlIHdoZW4gTDIgaXMNCj4gYWN0aXZlIGRvZXNuJ3QNCj4gd29y
ayBlaXRoZXIsIGJlY2F1c2UgdXNlcnNwYWNlIG5lZWRzIHRvIGJlIGFibGUgdG8gc2F2ZS9yZXN0
b3JlIHN0YXRlDQo+IHRoYXQgX2lzbid0Xw0KPiBjb250ZXh0IHN3aXRjaGVkIGJ5IGhhcmR3YXJl
LCBpLmUuIGlzbid0IGluIHRoZSBWTUNTIG9yIFZNQ0IuDQo+IA0KPiBJbiBzaG9ydCwgeWVzLCBp
dCdzIGdvb2Z5IGFuZCBhbm5veWluZywgYnV0IHRoZXJlJ3Mgbm8gZ3JlYXQgc29sdXRpb24NCj4g
YW5kIHRoZQ0KPiBpc3N1ZSByZWFsbHkgZG9lcyBuZWVkIHRvIGJlIHNvbHZlZC9hdm9pZGVkIGlu
IHVzZXJzcGFjZQ0KPiANCj4gPiBBbm90aGVyIHF1ZXN0aW9uIGlzOiB3aGVuIHdlIHdhbnQgdG8g
c2F2ZSB0aGUgVk0gc3RhdGUgZHVyaW5nIGENCj4gPiBzYXZldm0vbG9hZHZtIGN5Y2xlLCB3ZSBr
aWNrIGFsbCB2Q1BVcyB2aWEgYSBzaW5nYWwgYW5kIHNhdmUgdGhlaXINCj4gPiBzdGF0ZS4gSWYg
YW55IHZDUFUgcnVucyBpbiBMMiBhdCB0aGUgdGltZSBvZiB0aGUgZXhpdCwgd2Ugc29tZWhvdw0K
PiA+IG5lZWQNCj4gPiB0byBsZXQgaXQgY29udGludWUgdG8gcnVuIHVudGlsIHdlIGdldCBhbiBl
eGl0IHdpdGggdGhlIEwxIHN0YXRlLg0KPiA+IElzDQo+ID4gdGhlcmUgYSBtZWNoYW5pc20gdG8g
aGVscCB1cyBoZXJlPyANCj4gDQo+IEhtbSwgbm8/wqAgV2hhdCBpcyBpdCB5b3UncmUgdHJ5aW5n
IHRvIGRvLCBpLmUuIHdoeSBhcmUgeW91IGRvaW5nDQo+IHNhdmUvbG9hZD/CoCBJZg0KPiB5b3Ug
cmVhbGx5IHdhbnQgdG8gc2F2ZS9sb2FkIF9hbGxfIHN0YXRlLCB0aGUgcmlnaHQgdGhpbmcgdG8g
ZG8gaXMgdG8NCj4gYWxzbyBzYXZlDQo+IGFuZCBsb2FkIG5lc3RlZCBzdGF0ZS4NCj4gDQoNCllv
dSBhcmUgcmlnaHQuIEFmdGVyIHlvdXIgcG9pbnRlcnMgYW5kIGxvb2tpbmcgYXQgdGhlIG5lc3Rp
bmcgY29kZQ0KYWdhaW4sIEkgdGhpbmsgSSBrbm93IHdoYXQgdG8gZG8uIEp1c3QgdG8gbWFrZSBz
dXJlIEkgdW5kZXJzdGFuZCB0aGlzDQpjb3JyZWN0bHk6wqANCg0KSWYgTDAgZXhpdHMgd2l0aCBM
MiBzdGF0ZSwgS1ZNX0dFVF9ORVNURURfU1RBVEUgd2lsbCBoYXZlDQpLVk1fU1RBVEVfTkVTVEVE
X1JVTl9QRU5ESU5HIHNldCBpbiB0aGUgZmxhZ3MgZmllbGQuIFNvIHdoZW4gd2UgcmVzdG9yZQ0K
dGhlIHZDUFUgc3RhdGUgYWZ0ZXIgYSB2bXNhdmUvdm1sb2FkIGN5Y2xlLCB3ZSBkb24ndCBuZWVk
IHRvIHVwZGF0ZQ0KYW55dGhpbmcgaW4ga3ZtX3J1bi5zLnJlZ3MgYmVjYXVzZSBLVk0gd2lsbCBl
bnRlciB0aGUgTDIgaW1tZWRpYXRlbHkuDQpJcyB0aGF0IGNvcnJlY3Q/DQoNCg==

