Return-Path: <kvm+bounces-9770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0ED866DFB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 205781F28C0A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1FC4D10A;
	Mon, 26 Feb 2024 08:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="IyLEnTAa"
X-Original-To: kvm@vger.kernel.org
Received: from esa5.fujitsucc.c3s2.iphmx.com (esa5.fujitsucc.c3s2.iphmx.com [68.232.159.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D58839FFA;
	Mon, 26 Feb 2024 08:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936358; cv=fail; b=TEG6Ud+9WSnqwpTr/6g7bvjIBnxcD6BbVwso42d03VJ8tdlkGCVctbgoSzauay/KAOb5+TiLyFIQtvQc1JszocbJgVbkvUr7B7wcMKr+jCOEEEpyjFlgQ2T3lBcU5QMptr4lOTbMQr3rqCc6EAoRL5Bv0DL1IcJuyquHtTFCiPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936358; c=relaxed/simple;
	bh=vgUVaiXWTGmmIIDfpSaO8rWWAbCfsM5pWp/LoXKr0pI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JY6wzvqY6GSGttYJ0TbRJYc4hibRY9tE6QbKOtA0CN+3d8RlX7WxKLSpzF9PFxoC1LLYbMUqGcjDbW5kbHRC3EyKSpFMjRwjJvDxsMoFcLZ03M6fLJGDFKHKaQFy8vN7SzBA/EdoOjMkOh2GEB61U+YcLnZs7l/kdncZz4qlArg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=IyLEnTAa; arc=fail smtp.client-ip=68.232.159.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1708936355; x=1740472355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vgUVaiXWTGmmIIDfpSaO8rWWAbCfsM5pWp/LoXKr0pI=;
  b=IyLEnTAafn68yBqzW5Ux0aNBuz9KgJBoUq5JR0JO2RYFDWo6phwuGTNM
   IbC1ydSfHSHnR81Otr4ObTn/Y4VMnkeqoKvJCzKOpFGC30cSUV05wZluZ
   UAm7TXNsKIkqjABA3ea9hdvZZTFegjllG3aWm4dLXamvVjjU3nLbyQTpT
   qCVsJenpssTk4LNOOSyenWMrJ9atGfM9A+9ySOE5j7HE+aNT8NbCRN6s3
   nSWPBeha9/K0iPfbcE3QQBfZF73BtBlizDswDoeAg+w82Ra3n0g1eoANY
   J7OynyMz+pLKmQPlfocAoobGSEDAXfsKkIeB2OG0MjeLzVwvLqIaPAxND
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="112516120"
X-IronPort-AV: E=Sophos;i="6.06,185,1705330800"; 
   d="scan'208";a="112516120"
Received: from mail-tycjpn01lp2168.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 17:31:14 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZgP8SDHJ3taF7GVFONuUGuvgjKWt9l1Mmoe0E2q8EFxvs0p5u880LUl4ePj0oV0seNpOYYBKbiZCq769v8uf59BZsihm9m4v2u1pKdAJQmJGW8xL7WVi2KOZ0l2jY7CP+ETUktgPgH7YLx1vKYXM1SZPqx4gIr+jocU3zKTXvisibvCFbCylaC11Kk3oZ/V5uA5ekuoj5w2Qgvr/LJoMk/hI9Zh1CXR8Mj/zvzFEDztFSZXpbhrNv7vaad8PmMtlZQOKlAPt1spPw+HHCGIm0ZO6H1yc7E0TJRh+HIGPd9CpT3EO9A6hSV58WBAN4MAQ49yixAGfXbDLHyPyssULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrZ56LYGXBj3MoItpwnPwsRNHwXPDYlYml6tM4mpuzY=;
 b=TcxQU8k5Cxp/KZ/N74q3PsQ7crVzXfR9WQgHprhF3g8juVQJvsrDApIq8swayiTmyPSC24ZB4R1Mfa19IkagKW0PDvPM7Fra1D4+o8crAv48ZPzlozbmzjlG9gjMGGs3M1Xwp5QmHGf0UQYeGZThjxTmUI8Su+YgFBN2OumWHOu72kbqGbocLAPKcZWPYuXSKbvvKt+TeZUEjC2iydFKfMnbDj+3DjBaicpoazsy6HLsJcA/K7aMtuDv1953zIi1pIwIB5So0w4ivTSB8prUmqx6j50oohb+R4egOqb+dA4kS7uHzM2N/zxEa3zLEemVgblQPXiM6q33oSCBkM3v5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY2PR01MB4330.jpnprd01.prod.outlook.com (2603:1096:404:10b::23)
 by OS0PR01MB5777.jpnprd01.prod.outlook.com (2603:1096:604:bb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 08:31:11 +0000
Received: from TY2PR01MB4330.jpnprd01.prod.outlook.com
 ([fe80::da21:d66c:22d1:fdcc]) by TY2PR01MB4330.jpnprd01.prod.outlook.com
 ([fe80::da21:d66c:22d1:fdcc%5]) with mapi id 15.20.7316.031; Mon, 26 Feb 2024
 08:31:11 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Mihai Carabas' <mihai.carabas@oracle.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "pmladek@suse.com"
	<pmladek@suse.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"dianders@chromium.org" <dianders@chromium.org>, "npiggin@gmail.com"
	<npiggin@gmail.com>, "rick.p.edgecombe@intel.com"
	<rick.p.edgecombe@intel.com>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "juerg.haefliger@canonical.com"
	<juerg.haefliger@canonical.com>, "mic@digikod.net" <mic@digikod.net>,
	"arnd@arndb.de" <arnd@arndb.de>, "ankur.a.arora@oracle.com"
	<ankur.a.arora@oracle.com>
Subject: RE: [PATCH v4 6/8] cpuidle-haltpoll: ARM64 support
Thread-Topic: [PATCH v4 6/8] cpuidle-haltpoll: ARM64 support
Thread-Index: AQHaX+1Hq6V2Fk4p8kqc+P+eHMT2n7EcVd6w
Date: Mon, 26 Feb 2024 08:30:50 +0000
Deferred-Delivery: Mon, 26 Feb 2024 08:30:50 +0000
Message-ID:
 <TY2PR01MB4330E33D15DEE3DE33794B6FE55A2@TY2PR01MB4330.jpnprd01.prod.outlook.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
 <1707982910-27680-7-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1707982910-27680-7-git-send-email-mihai.carabas@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=8fa50612-dde9-46ba-ada8-1e4bc859f4a9;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-02-26T08:07:43Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 67bc8e64b849456398be7bc360475294
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB4330:EE_|OS0PR01MB5777:EE_
x-ms-office365-filtering-correlation-id: 26101985-180d-4fa8-9b6f-08dc36a54990
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Y152gDUdFn/GbA6i6e6aG5cIOZyQpIxWg92RBk2XXWftkpgeC4EhlN3s3QbgEKn16Xc+AJAe8ehvX0BacULobo50U2YCev3d3q2RwLtVtR9pnSdQ9a4TVhpSMyAIc6eZzUwdJzj+2J3bpF/rwPw5L/+6yXmW/DYLiMuTK4HYvQ2hMn/xcmFfmYtphAYuoJmbfzoKTH3L3aVlZBw9CzigjkX1Hisj77ZTaajq6XU7TFmD5uGJpFuGRSMKNEK57l6kk9U40y03zqgncbMxfiOLk/SWeB/u3ocQ1GAHtFjuYXhgZJNahcX/laWJ/7E2hk/SpZklKN7+FrBOzB4BZlta8f6WhYgRANsxvbtptP8vV4p3nnbIAKjZSgoxqVTkvjfSNJBfTG0YI2MTQWCGRVXBI9mmvcuoyExW0b8P0lHAjo6GeBrOzgRkalDu+5wCnI/t12Jyz03x/rB6wz13hIj9A3JlT/cwQSBz4xrvinG9YFl0SiJEz5PsU0NRIJxxeZibhsVzz3r9w/JQE4ZPMwtuLbuNe4KCvGfTW6YRlKhPqnNoYUD0E0SGO5BU88Nymo+JLr8LekRefIi0abhZCsj+vzqE+PYnRuT72XGeIqEmFuPT6NfKawLKHweoC/ca+LAGm1RwJG1+OPJhnJcre1Hj19bENMfObddUdGkyfhHWZpv6QjSgHpxdMUd0ZIlkWn5KgeJcumIEnU1z6bj8FfedGnQleI+vsUQ4GO3LUqbH9NM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4330.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1580799018)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?dUd1cEVKaWxXWkhuL2l1TVJtSHpZNU1BTVhSVDdYaDZGYkVyVDlXbzNS?=
 =?iso-2022-jp?B?bXB6NHI3N1RWNVUzOGt2WThSWDVJM3ZFdzAwWDI3VGpaVWlUZFhPQ0RN?=
 =?iso-2022-jp?B?Z01nNVZ3d0xBZ3dpVkM2cXNtTmFkdGhZM2R5S0xsQ01uVXA5WFVOUU1i?=
 =?iso-2022-jp?B?RE5Va1UxWHJxRHpRNHZWVEFUZm11SkJMMXcxWVpzVXBtclR4YmZIaHBZ?=
 =?iso-2022-jp?B?Ly9qUkxnVDUrRlFKMjA5WnRFdm9aNW1zOHEyRld4SHVTUDZUMWVCYmVp?=
 =?iso-2022-jp?B?OHF0M2I3TFhsN0pJRFJNL1hyckZmQTJmanl5Z0twa0dwV1JTSmVaV1Js?=
 =?iso-2022-jp?B?WWwyQXB5NEpjWEVjMTVudVE3RHRHZ2dnUFZ0dXpqdnVhdzUwc1NvOVAx?=
 =?iso-2022-jp?B?a2xJM2M0RDF5QUd4K1NheExoNWkxVVFYWHZvWFZOTkR4cWpTQmZpZmZq?=
 =?iso-2022-jp?B?TitMc3BKYUVBY09XZUJjZWlmeTV5UTdtdHUrbmRDekdRSEpwWWZHR0to?=
 =?iso-2022-jp?B?bTdDc2xRd2VpZnZEVHY2bnNpU213MUF0OHZNMW53RWFNbG1zK3NudUpZ?=
 =?iso-2022-jp?B?OEtXQUkyMkcxQ1BvMHZDUFZ1aXBhbUNwUUp1VExZZGthUndUTE5sdHdp?=
 =?iso-2022-jp?B?ZGtlU1hqRkJYdDNHWXpNdHAxQy9hNmxSQ1pkdzZpRlV3NVM1SURtak5t?=
 =?iso-2022-jp?B?bEF0cVdUVW9Md3lxeXNWdEZhWFBDcE1TZnVZWUVEUlc0eFlwVDM1UGFN?=
 =?iso-2022-jp?B?OEFJTm1MRkx5QXp2ZS83UzRxa2JUbjJCQVpMRUdJY0dZa3dPRnNqMmxC?=
 =?iso-2022-jp?B?aDFveGVVaUxkTExiM2x6RTFoOGx3NHMrMEpTU1JnV29wcDd3RzdQd0pi?=
 =?iso-2022-jp?B?TkRXYXYwV0t3SUYyNmtZbTJ1cmt1OUJmalNUZFJKdm1RaUZ0Nlhvckt1?=
 =?iso-2022-jp?B?SGwyVUJ5a2gvK0F2VXZnRVVZK242ZDJaWnVlaEhvWk8ycDJER2NOQVYw?=
 =?iso-2022-jp?B?SlFWRXBMNmtzcWZPc3cvSG9ieUIzeXJZZjBEaFB3MlZ2aUVubmR1eGZn?=
 =?iso-2022-jp?B?c1g1cmRuemliejFncERMVGFUOG10M2MzM3drWnRzWG9uNHV1eVc1UG9T?=
 =?iso-2022-jp?B?MFBXOTNwd2EzcnIxcEp0eWc1N0NMb0UrOVoxTS95WDlqQ3Z0SUZ4NTZz?=
 =?iso-2022-jp?B?QW9uNUg2dy9Ia3AwT2U3U3lEUkJhamRsR3l2eXA4RDlGZ1dIb3R0cWFu?=
 =?iso-2022-jp?B?eE04QXFBVnYvYWVIV000RzFyUURmaXJHWEI0RnJZczRUWHorYTBpZHho?=
 =?iso-2022-jp?B?c0Y2SVZMYzBQY1doeVpBeFVUTnMwMHJDeStGMHdWZ0lmYWJWWHZYWUdr?=
 =?iso-2022-jp?B?OHZPRmRDTTBTdHdGODRDS2FiaHMvdnVsVXB4NUd2VHI3R1BmeE5hK3lu?=
 =?iso-2022-jp?B?OHBhR0UwY1ZmUzNPblF5cUI5UnNMWHZiSlp6b0tMSlFHcnd4Mm80T2sr?=
 =?iso-2022-jp?B?QzA3RTFFRmhSenBxZTNNWGU5R0c0QXhRMTN2WFNmOTZiNE5uYUpnREpO?=
 =?iso-2022-jp?B?TzBsRmdtRW5vbkpJejlnRk1FTTFET25zeFhRQjRkOXJwSDBmVVVTajU2?=
 =?iso-2022-jp?B?SXJDR0pYQ2JCalZMMm01aGlrTEt0eUNLUExOekxzdDdPNUJiREd5WjZV?=
 =?iso-2022-jp?B?aFRCZjJrU2dDRXl0OGZ4UUNoSWtJdldGTlYxYXhONm1DdktSeExJL1A5?=
 =?iso-2022-jp?B?aVpDNUYrWWtaeXVSS25nT1JTRDg0R2I4REVpMW9yZGZFNXh4N05YTkla?=
 =?iso-2022-jp?B?WjRjU0R4UEhTUS9uNjJjREIvTURENm1ZL1R2RWtKTDc0ZHRUc1h4SUhq?=
 =?iso-2022-jp?B?NzZvTlJ1enJycm1NNnVzQkdTakVCSzFJL0R6b3pRaHduMFZ5Q0w2THBM?=
 =?iso-2022-jp?B?L0dmZVVYS1RlY3RWWEI3NGZhWGRCc3g2cVRnbTlxemh5VTZXLzZybjZS?=
 =?iso-2022-jp?B?RWd0a053L0xlZVJVcEkvUHF4Sk5VUCsxMTR4cEZOY0d0d3VFVGMzZEps?=
 =?iso-2022-jp?B?R2hRR1UzUVZkYlYwZHhLMDNQdVhkNUxwWm94ai92aHJibm5FT3BxQkdI?=
 =?iso-2022-jp?B?blBQOW5tNUEvNTBmNVFjRTdZdmU0blIvRXRwNmhUR2pmYlN6Q21kak5J?=
 =?iso-2022-jp?B?VnFzcjJ2SnFLbThySVhPV3hjTkVMN1ZUVDJSRVVsSUpJWm5WZk1lWmFX?=
 =?iso-2022-jp?B?NjI2UGhHODdhdUszSWJRa1Z3aUtnVStjUXVzTzdtZTI2RXAxblAzWk91?=
 =?iso-2022-jp?B?bnhEakd5Z01mYmU2d2xZVS92aDc3Wit2U2c9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cDl6dhtUlCvEfzWzSZ6BvlhN37vhBac0FVR8ZCaX2U0OaE4VWnGOrRQBiUhgQi8omajTyZQPtSdLny6kjLTbm7rl7UXCL073KfTk0hjpC6D6cLY2j4S8h+Xrc1BV/pQbPLVHO9Tt0XSrr/0Dp2hH3LDvFb/XMdDJIaWn/NF1dFtXTNxTXVzWU+60wf7qXBTQxhUOm/5ojM3S+1JINn502m3PKjJS3N+7uY7frMasCDucHR59lVHtGd4xfZ5Hs9h4fFEUA+MxrwSLSDzejubYLFzKAgJADDqEpxUn1D+/Pxb2kO/D/nQjKxqotZ9zOcAYY9npubHLjSVa6M7C+cVKHQ4GfVAtK1GTGhS2JilgutHwQ7Cg+U+aVXiL6yEc36dl5NIRrpLWwLRlTTBIdMpEVXBHjdxtdV6Bg9y+EoKKThtCZw5UxGAiT6pCdk6laMXepS3p47iPz63h2JIkW7ns01puPvqMX+OqodNW1n4MUoN7zasMce03gYlAUhd/eE6Wx/cdSWbqBOSvmtaeK614g9LCw1gzBcxyhtb1rvkPmtZh9cNbgOauVdxzXlOmV4c0W2zVf/IymQiqhSnKLJ/A10s1DA/lqex82x0m5nV2H9LlgDfJZzrNkGqZ7W3v9hS+
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4330.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26101985-180d-4fa8-9b6f-08dc36a54990
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2024 08:31:11.0865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +vqW5XEQIvBruYfRSxsZxdjHuLX3XsllCn122wXcumfkWePNJTs0eE5roQIQy32o33sK9W06rmw3FOQhV5UPECT9Xce3lV8meurYxje73u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5777

Hi,
> Subject: [PATCH v4 6/8] cpuidle-haltpoll: ARM64 support
>=20
> From: Joao Martins <joao.m.martins@oracle.com>
>=20
> To test whether it's a guest or not for the default cases, the haltpoll
> driver uses the kvm_para* helpers to find out if it's a guest or not.
>=20
> ARM64 doesn't have or defined any of these, so it remains disabled on
> the default. Although it allows to be force-loaded.
>=20
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> ---
>  drivers/cpuidle/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index cac5997dca50..067927eda466 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -35,7 +35,7 @@ config CPU_IDLE_GOV_TEO
>=20
>  config CPU_IDLE_GOV_HALTPOLL
>  	bool "Haltpoll governor (for virtualized systems)"
> -	depends on KVM_GUEST
> +	depends on (X86 && KVM_GUEST) || ARM64
>  	help
>  	  This governor implements haltpoll idle state selection, to be
>  	  used in conjunction with the haltpoll cpuidle driver, allowing
> @@ -73,7 +73,7 @@ endmenu
>=20
>  config HALTPOLL_CPUIDLE
>  	tristate "Halt poll cpuidle driver"

I noticed that to build as a module, arch_cpu_idle needs to
be exported in arch/arm64/kernel/idle.c like x86.

Regards,
Tomohiro

> -	depends on X86 && KVM_GUEST
> +	depends on (X86 && KVM_GUEST) || ARM64
>  	select CPU_IDLE_GOV_HALTPOLL
>  	default y
>  	help
> --
> 1.8.3.1
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

