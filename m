Return-Path: <kvm+bounces-9771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B03866E12
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DAF91F29044
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616DE524C1;
	Mon, 26 Feb 2024 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="VYDSOLKa"
X-Original-To: kvm@vger.kernel.org
Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com [68.232.152.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75549524C3;
	Mon, 26 Feb 2024 08:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.152.246
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936685; cv=fail; b=rg2lK0yLXPGKsdkjY5hqfnRbJLMyEWH1z7V8VW1KxAd2i8K/pnudVl6OboM7m9ibKmClav/Z/bkNppwGsFXbum5PWjMOrz2uzA4IJZkdv8Sx2PyBVYYQs0Z4NMbezyOShrpGSdV24qjjO4Owqmyx6yp404MWKCMi52o5R3HScLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936685; c=relaxed/simple;
	bh=soi+QIPwIHE+W9uNXLWbiOFuREUDJoXH9JHDwIrUeNs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nq+bo1OZrPKy7Ru48/Ii/8TNlBoTawZNhvfghWd/64mRogA6FLcN51s6RwsAgafsZ1pNJ6zoNg9mTG3B75Z+bgeSmRrNZSOlirHYvYb3xrcxI4zoY3FSsUV3W/faTPV4l0lxZR7m7ojvBOwJKjNtAVMBYjaqouP+GCOSu+P4bCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=VYDSOLKa; arc=fail smtp.client-ip=68.232.152.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1708936683; x=1740472683;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=soi+QIPwIHE+W9uNXLWbiOFuREUDJoXH9JHDwIrUeNs=;
  b=VYDSOLKalfh+aQk/5uIpoGq58oygNxExWY0yZyhH8xppnIxY/EYCLIGh
   nSWQ8dl81tWr5Dj4Nx/Q6tS4IrFevMA090M6OFio4z7Hpx2lsX8sGosqm
   p2bcdeSaHR47OIzkhZBlvxqpsDsChIaInFaOKNL5VQ2WUeAxaPaq6ZEeo
   j+7vBM34vhnUn8/fZ3q/Z83Fb15Rm3BGMPjAhHVqCR5j4KX10ma9NKdnw
   g9YitlqtzAE/oeBhC1mIvqA6CFZxwuyYWtMLqkDhMODAKnrnhKrZ+xk5d
   bgrVB+NZs9BDyfra6mSg+PKgY+eqWC3wIWTM6DZlm4UiWPK2+VMED4+EP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="23225138"
X-IronPort-AV: E=Sophos;i="6.06,185,1705330800"; 
   d="scan'208";a="23225138"
Received: from mail-os0jpn01lp2105.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.105])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 17:36:45 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+hE3kmZKc6IFS0QiSlGMFSrX0vf+QME2ebg2snpw5blS4PTgUt8/it57d7EdkuLCPWe3Pr6AkwIDLMSCBYHwhaAO8pgAz/CXFReJq8LYaEwoEM7K605nElysvFAfqdHoSAXA8OWAgdXInR9WzQMtl03/Qqc84MFTvRSZZMXWntUAU+kvaxoZ/iouFIX+Pyry6Okdu+UTSIUlykJzd+o4kpTezs+Y4v4sX5AxGBgXtF8lZ76yt3WvAQngoXfH7XEMfDNBnnVX11QnneOzZp4rJQ5kLOewqVLf/CYjnAzyWG7ALjxHyghjUn7fTNDCAAP8zot1f5uztWRe5Cqbxj8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9vodBSANotGwd5vD4rSiyBr+NjT4gFQ6qs/AGh1Euc=;
 b=ThZv3VgWoHkQ3MkQinNkTm6W+z0LpoIp0SY3CdT4QIEDwfpYcoDePsiRRlssP842EUQcOi2diBEYm85Afrbz9y3LWyw24TLi1APromVsVWLInxoi22XQFBR8OHMT0OrMhh+wj1RbD3g2Uw29M15SWWdsh8nwmUS7iYwmFOISWy1rp9FsjWKZdfSKtN1fwhcDGPazYUW+tlJFWF9EcWoGWNqB75ANTHzHIGHWo5DY1J0ZyTBKwbkbfdW7jSXwE7hYVOlPqXAiJqdlcTlo70AZ7Fa/xm0CNeNn3HQTKGzHjSRJ1a1Y1+u1KmFyUQqvhSymKDxMAfs6CYuUQIPcfKSb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY2PR01MB4330.jpnprd01.prod.outlook.com (2603:1096:404:10b::23)
 by TY3PR01MB10985.jpnprd01.prod.outlook.com (2603:1096:400:3af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 08:36:41 +0000
Received: from TY2PR01MB4330.jpnprd01.prod.outlook.com
 ([fe80::da21:d66c:22d1:fdcc]) by TY2PR01MB4330.jpnprd01.prod.outlook.com
 ([fe80::da21:d66c:22d1:fdcc%5]) with mapi id 15.20.7316.031; Mon, 26 Feb 2024
 08:36:41 +0000
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
Subject: RE: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Thread-Topic: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Thread-Index: AQHaX+1Gvox7RnWHnUWfe0PEFo6XArEUVjnQ
Date: Mon, 26 Feb 2024 08:36:34 +0000
Deferred-Delivery: Mon, 26 Feb 2024 08:36:34 +0000
Message-ID:
 <TY2PR01MB4330F7FF122BBF12EC0ADE06E55A2@TY2PR01MB4330.jpnprd01.prod.outlook.com>
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
 <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
In-Reply-To: <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=77b23a09-c031-4c36-9627-b64b2ffb57d5;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-02-21T05:59:05Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: eceddb408e08436880adf6b8349bf71c
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR01MB4330:EE_|TY3PR01MB10985:EE_
x-ms-office365-filtering-correlation-id: c5022e5b-316e-4d5d-a467-08dc36a60e40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 skSpbZj90bWQ4+gsFDLpjGb+Ig7Iekz1h+e9vgP5Wh4CW86ahhFmWZPFW4+f3I2Khl32eGwuwizDBXCL58UBnIyDzTkewBrhumRO1YwEDcJ6q7SAgEECzXaOaY8nKkrs5T/UEOhrTzIoKoti6vPcIllCdc6RbWXgxrsPTffE1P0iJWdjuZT+y2iw43JpEH4eOWPCl2l3i6AbCLZV+DBm3LdoPrWRnpLJ24XwH40YCIb5KwFuTR8MoquwetsCAfUyGiIaFX5GtdPuzbi55XBS/09RU7ltmwBK9r5rAFf4dgTggWBfIG4NpAbcqIbjBKSwidaBtH5eru0/nk0mQo6U2PZBXA19t4fPI7/ZpOqMC3WTxYAgobWnhkLOfp+Rhx/bBvtwIvMAsGMUVZZ/aw4kRtoYqg5UGZaoZQkfiVi7PSXIJO9biYr5bXPtMuv2b8GVgmH9XpHLSy8bHsnpec7YmRGuT8c1ozFkpBeBx3ptsMjhk0wC7My6AVXaMfeJ2v2eMz+pOgF4R5MpZAMrNRtWRv888Zs2VhIr4RbqegcXIVaBfv+8G7Gwy01X5j1TDQBFNWPr1zOg61BCHmIG7/cbk6sXjvODjvWTxNvvENBnLLHy2waffJkhWHI5OMEa/VMSEpeOu0yHYJ+TwFTsbzahnx3QT3P5/N+ym4JyR+uFvKnWTLu3AC/RFk8/2aH17TGdlHkF6V2jhXBTsdLA4+SGtW/0qzhPMT/T5TUIqW2xi+g=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB4330.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(1580799018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?dEtwL1orWXNlZWFQdm1kVHVIVGROWjRCNWdSNitocW9vZ1pRdzhPMjlM?=
 =?iso-2022-jp?B?QmM0M3pwYW9ISDhoVE5pSG9PQU5KYys0a0w1SkloaThIalZCOUdueER3?=
 =?iso-2022-jp?B?bFQyNERUelZyY0VtalJRZFozTVYvZVhLSCs2ajIrMW0wTUd2MFEvQ1RJ?=
 =?iso-2022-jp?B?SzBTM3dNNWdVSDJhMDZVNkVrS0tYYmJnK3Y5SFY2ek53SDhhVHlXQjZV?=
 =?iso-2022-jp?B?ZWJ6ZU16dnlqYVBOWmFySkJXTUw4NHZWWllyRG5UT0FFUVZ6Si9GOE9o?=
 =?iso-2022-jp?B?dGJhcWYrRXVZY3Z5b0d2ZW80Tm9xSWUxdDUwcHNzY1NnQmJSdGp5bUhh?=
 =?iso-2022-jp?B?aGxiRHdESEFHajRnWlhoSWpOMkZuSGRybTU3LzhoMFROU3hlRnhsTWtB?=
 =?iso-2022-jp?B?MTA2cElUcEpMeWVFckZpdXNkK2FtV1d2SWdMZGRuZmgxQWVxRnhrdSsw?=
 =?iso-2022-jp?B?cDE1STdiZ1NzUzVGNUx5ZktLdFBXeXNIcUdzaDFkQ0t1bkhSOE5LZXlp?=
 =?iso-2022-jp?B?NnVGR29rSTB2TVdUTnhZYXdrRm82UG84VmE4em9xM1hjY2Vub0o1SzJM?=
 =?iso-2022-jp?B?TlAyU1A2b2dmTC9kSTlmdnJXejcrUzlFOVJEWmF4WTJjYnF3MWhoTGpL?=
 =?iso-2022-jp?B?T2p4U3F0bHJQUGRCN3RNTVJhWkVCaWt6STFvSnBBTC9uMzFQNDg3WTB5?=
 =?iso-2022-jp?B?NmE3Z2drazZ5VjFQMS9ZYW1PYzRIN0hKZDF3NGswYXcvQVMvbWZ6VGcr?=
 =?iso-2022-jp?B?QVdqdVJDeUFMb3pHSFJPQVEzamY5TUlPM1ArVlByM1VVL05WS3V6eDUy?=
 =?iso-2022-jp?B?cFIveC92am9rZysyWWt2VnJZWDZ0SVdHZXdkekE1YXR5eExDVVJPWmNL?=
 =?iso-2022-jp?B?QzVyMVRZUFBUdDlpRzYrTXNQeE5BNkV3WWNPNXJMS1oxbUZ4N2xhUDdy?=
 =?iso-2022-jp?B?QmRQMFVnSDJMb3hmY2lmbVhmMjVrNjVoZC8waEpBK2hIZG9ZMG5SWWR2?=
 =?iso-2022-jp?B?UGF6K1RQOUdqcjR1eUcwdm5vOFZiRmU5VkRDOHFQcWFaR01YcVBPc3Vh?=
 =?iso-2022-jp?B?NHdrUENWb3ZuTy8yZEt2UlFFYjY2Vm9VRUxGM2RVZ05PMXVJNHdyeldR?=
 =?iso-2022-jp?B?RVBwUUQ1d2lBZmVTUzk1ZUZmeHFuWmo2enFBU2NHZFdXL0d2eUU4UzQ2?=
 =?iso-2022-jp?B?bzFDNWx0a1lROUEvNERKQVh3MEJTaHM2S09CckFaWUxrVEJTS2lLWWJ5?=
 =?iso-2022-jp?B?L1hFc2dSV1M1dm5wQjc4dkJVbUF2VzZxYkI3SFhEa0UxSHRQZTF6aDJF?=
 =?iso-2022-jp?B?VVU2Sm9sSEtwaS9VUVp3Wk1UcTV6UlY1Z08vYUFuVTBQM2U1dXdod3Fx?=
 =?iso-2022-jp?B?MytzNUN2dkpjd29Sa09YMzYxQmJJVWNZV2dJVHVVY2RrSWRNNUQyMWg0?=
 =?iso-2022-jp?B?R1VKV01CYlFoK2dENndSL2duNW9YU2huN2tQckU5ci93WW1lU04zcmRs?=
 =?iso-2022-jp?B?NEs5dStvSldkeTdhRWg2Nk41V1VkTUlXRk9SeVc2OFNCUlhNK2JIVkUz?=
 =?iso-2022-jp?B?ZkFrRGNSMllCN3lmeFY1TU5iMG9iUWtxMVc3dUNDNTVqeERaYUFNdERm?=
 =?iso-2022-jp?B?WTN3QVJOYmpHbHF2WmU1UE5BTk9meUNPSEF4cVFkVHBCSTJIMk9VUGs2?=
 =?iso-2022-jp?B?Vy9TdEJzWWZwYVQxQWtGZjF3Y3JwdWFVZml6MHZtU05LeDAvS2o1T2tD?=
 =?iso-2022-jp?B?ZDFoVkdjd2tNb2tBSEN1c0lSNmxOdEJLZ1RScGVBYlRKTlVyZE5vUUtJ?=
 =?iso-2022-jp?B?RllPdHBGTmJRZ0EvUTNLMWREZE9WOVRIVnpmWDJ0cDFKNXcybnVKTTU4?=
 =?iso-2022-jp?B?Z0xpN0lyQ3JhS2xRS0R1Mmp4OVdlejNxN09XMW9ReExsTUZBN3BpRUFN?=
 =?iso-2022-jp?B?bkcxUlR0am0xeEtkN0o5K3FCTExBNDF6RHJEUDFCRHhHaXMrMHZKaXBK?=
 =?iso-2022-jp?B?c1d1ZURJMHlGMTlqNDdlRU9WZDRqeGlQQ1hiWEVSbWpaUUl3TUt4NEpX?=
 =?iso-2022-jp?B?WVM3ZHB4dkdOSlY5Q1BLL09NUHdWemtCS1pxR0QzeXFidHVhalArQ0Rz?=
 =?iso-2022-jp?B?dnp4YUtJNENLZlg4NjRGUWRhbG43YXdoQXhQWHgzZXlCVzFGaFpnVmpY?=
 =?iso-2022-jp?B?a1E4MGo2VnVOZkVodHNCQ3Z3Ukk3aW1EZmE5c1JDTVpTcElEMCtnMnA2?=
 =?iso-2022-jp?B?by83Y0FZSnlZUGxQT3YxTWc1dGo4allJUmcvUWJFbFhYKzVaaTN3RDRX?=
 =?iso-2022-jp?B?YVZsemhCY1k0V0crVHJjMmR0WitERmIwdWc9PQ==?=
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
	UTXHsYwePGLLn2tS1RffJaEhlHhdvsJ8UqOHstuykhWahBXiLr2CmD6Co4560UFryijsGp+izHuUScghh+WZsXNU1V0XPLrgSfkA+um2C92aC0Hd3hXZCYUE7TAxn/T4lKT3Svxi1Kog3Z4olsVl/xJoSeo3aDqk9qi9dU1qROvgfAHsmDpEVTjyjHCqy3wqdy7slKAzBe2xdelKdJbNhS1z9etwH4NEsBOAymGBkwmrtmZMi/WfgUUMVj47bDa38w6leeUlckQUOXwh/rvtFPwkg+Bj8bFKYadFlnHR3I4LYoa5zFnpZl7ExsvUAgkjrejkVbyFsj0kZkrw/HhOGkYBgselvLUMZgjY9OUa3FkVKlVBpYv9SEwmW7T9mXPSIkwKnTjDtbYHEl2JHKMKc0lmkHKjh42AubyIC2z9j/OPVJMLn3dZQBeV09ui3SbULGIq8DyIoiXL/htrLsMwDPxWaGLRaa7Ru/7EKxdWa/Ar+J2pu+ZFmvKQGkJ4okTP4xTnLsIzA1lTMnZ0n9YJpBCrBFt6g2bu6leeKrXnuF/truoZ2/JNyKIZjor78MGDGbNYe9X8XGsUZ7+GGKxXu0FUYG1ei3lb3n3nOuw/IWEifVrq4sSqP6D/U6NIWS0E
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB4330.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5022e5b-316e-4d5d-a467-08dc36a60e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2024 08:36:41.0740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RUWLV7+nEgWWP0O+kgx8UDBT5iXcOhyhMFcKc1tHAv3lRCfX2aK/LCrm6OmP3OEhn9cemT8++YFnDQOtxIt7uHXuAqIa8JsoYh9/AGoACfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB10985

Hi,
> Subject: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with smp_co=
nd_load_relaxed
>=20
> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
> smp_cond_load_relaxed which basically does a "wfe".
>=20
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> ---
>  drivers/cpuidle/poll_state.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..1e45be906e72 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -13,6 +13,7 @@
>  static int __cpuidle poll_idle(struct cpuidle_device *dev,
>  			       struct cpuidle_driver *drv, int index)
>  {
> +	unsigned long ret;
>  	u64 time_start;
>=20
>  	time_start =3D local_clock_noinstr();
> @@ -26,12 +27,16 @@ static int __cpuidle poll_idle(struct cpuidle_device =
*dev,
>=20
>  		limit =3D cpuidle_poll_time(drv, dev);
>=20
> -		while (!need_resched()) {
> -			cpu_relax();
> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> -				continue;
> -
> +		for (;;) {
>  			loop_count =3D 0;
> +
> +			ret =3D smp_cond_load_relaxed(&current_thread_info()->flags,
> +						    VAL & _TIF_NEED_RESCHED ||
> +						    loop_count++ >=3D POLL_IDLE_RELAX_COUNT);
> +
> +			if (!(ret & _TIF_NEED_RESCHED))
> +				break;

Should this be "if (ret & _TIF_NEED_RESCHED) since we want to break here
if the flag is set, or am I misunderstood?

Regards,
Tomohiro

> +
>  			if (local_clock_noinstr() - time_start > limit) {
>  				dev->poll_time_limit =3D true;
>  				break;
> --
> 1.8.3.1
>=20
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

