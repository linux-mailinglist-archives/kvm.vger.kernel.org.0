Return-Path: <kvm+bounces-17004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7238BFEBA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 845DA28ABCF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7032C7A15B;
	Wed,  8 May 2024 13:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="Ba6CEgit"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2117.outbound.protection.outlook.com [40.107.135.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE446E5FE;
	Wed,  8 May 2024 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715174881; cv=fail; b=DxcqAFeJwTXAQEZr/tDHJhRRR9buhgNL4thvEMn67bqfm6j+ffEZmrpVh158vqhREReZmaaaFS0bcz8YcQpN81eDNKsk1PHlR/nSSDX60yf4ONiboEAcOvQto/3mwCKTkKdUbVztAQ03uK0/bjdg462ahWFOo6L6XHpcukW3Pf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715174881; c=relaxed/simple;
	bh=AB7jfVTo812ly9PQhR70ZwI0b9ZO4FTgnNQt3sN/YXo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XOKNS1q8u50U8VOKAWH3Dt0LnHY4UZ1qvVv0tPiC9c+g7h4WZr8UM7O/bFUn4LTO9TLUFyzKJLWOinWt4VSoohjufzF+KHX+vddDlThWCHECOH3arSeCmYW8GHyygLu8LBeW3hZBb+mdHf0PLiU0Cr3x7Qdszve9yIKyr/W1REw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=Ba6CEgit; arc=fail smtp.client-ip=40.107.135.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9FvSNDLrAdXUI/MAoEY+GdCEMYdC0ZeNBtSEReF3RM384uxJwxecUD/LhV4jDMDFQ/FbpZ4eqmkcT5UbbBD+hV+M93jlJPa8iYVbNKBb0SROPv7HGp2T2QONOtNH+O17hb204LAkCoQAnKGEjgheALpAiu6WL4g10vCBZKejVcXy/d6ffowodGNBE07y75wco2QToGLfR24oQwe0oSv8vn2+M+aavmPwu2HCm314rUDl2/n7lYxn2nFLAvwzrDLS9zXi9JazvjjJeLO9IIXt/WPTmSCJSsBdTC2SX2/4CxlX5G9aWxeDlkftpoS9VHPBfNOm1dAYcXWaMZ2N44+OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AB7jfVTo812ly9PQhR70ZwI0b9ZO4FTgnNQt3sN/YXo=;
 b=nGMVSPSUKF2lCYY3erdnnkqpX/nznA0Dj7xsTGGu/Y5M56M2+mYwyEWWxy7MxxkryZVhjL+YuchKe0f3Lh5dWAd7XGSPD/ZpEifsaDdtZpWUK/AETf3yoP6agkc8Z6gUotaMlHzxQwlZ4dZKRpKW5aUn/UfcVcxlNktKkxN40hjFwdDBE4COSraDYiyEhA1IALE5/AFuUkOxDzQiOq49rmHz20zt+Uz/IzUvWIv4smo20D/zkiQl91JIZ7A4HjG2geiEhQlQ6gZ+36WXXP2uRetiyK6nlEpKhwlg9Ckng/IS8zz8YS9G/D8LKKaJcT5E6kqkyD4KGrwV6O8WHLjHRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AB7jfVTo812ly9PQhR70ZwI0b9ZO4FTgnNQt3sN/YXo=;
 b=Ba6CEgit/nvAWcXj/m7Gqndb93wRXgS113Wsf555mLojg6CcRDDk5njHJAlZv8twaS/1Aw/nBbvhQTpINsWgxHR49Qni2s1PuvL/2vOpix+0TM5PWc1+iscYepSauZDGi1NxCgDpdXr4jxZYAg5DXMC5MO73syXZLfl9aqwzNvrTBkn8ilZX2BoCyK91WERdpo06/hDqFM/ZO6m6fMNne5yoZu6T8/TFBNZ1ukThzDttO0znCToaiFueglHKk22y33zFTsRtad9tWmqWmiGqtk1Cibw5p8o23V7nY3JVFHUgtmvoAjbJ93l2Umd5yMh0kwv5Fp+6d7zNZVWaCz3vEQ==
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c3::11)
 by BEXP281MB0231.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Wed, 8 May
 2024 13:27:55 +0000
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75]) by FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75%4]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 13:27:55 +0000
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, Julian
 Stecklina <julian.stecklina@cyberus-technology.de>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Topic: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Index:
 AQHaj/q7SvbB6thKm0KGE0qK9A01DLFq9pcAgAAJW4CAAAKJAIAAJXoAgAAKGICAAT2zgIAANBgAgAAEzACAAWWUgIAATiIAgB8awAA=
Date: Wed, 8 May 2024 13:27:55 +0000
Message-ID:
 <155d4e72266096e0fa125b11e3bde04d8788e41a.camel@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
	 <Zh6MmgOqvFPuWzD9@google.com>
	 <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
	 <Zh6WlOB8CS-By3DQ@google.com>
	 <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
	 <Zh6-e9hy7U6DD2QM@google.com>
	 <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
	 <Zh_0sJPPoHKce5Ky@google.com> <Zh_4tsd5rAo4G1Lv@google.com>
	 <61f14bc6415d5d8407fc3ae6f6c3348caa2a97e9.camel@cyberus-technology.de>
	 <ZiFmNmlUxfQnXIua@google.com>
In-Reply-To: <ZiFmNmlUxfQnXIua@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR6P281MB3736:EE_|BEXP281MB0231:EE_
x-ms-office365-filtering-correlation-id: 3214b230-63a6-4e2d-0d07-08dc6f62ab9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|7416005|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZXdGWHIzejF5RjFHOUFSQzNzL2hSSWlQNWJXYmRaUlYrUUdxUUpyNXljckhv?=
 =?utf-8?B?T3YvQTNWc0NPTUZXZjZwN2tmY2ZNemg1eFEwQ3FXQlNHMmdCUHg0bGRGMnlN?=
 =?utf-8?B?S3VxTHhuNTRyUFNVdnNzQitkSnlxcU10UkQyN2UxR1lCT29zQU1UZjhFeGpp?=
 =?utf-8?B?VEZsRXBNdXVHZWZmdm5Tb1dGeTZvRnhvRnBsNjJEUkt3VGpERU9ybllIanhv?=
 =?utf-8?B?dVBYeER3WE1TcFFaUGZ0SkFzODRtQ3NqSVFoUktXcGJYdllKLzl4RE5uaGt6?=
 =?utf-8?B?VFcva3lpbFpYcW8rWXhuaDZjOE1CUklLUkJoZWdKY1dHSFR2TVRlQlJpNXdn?=
 =?utf-8?B?RzBMTVFrV1F4dlhVclpJZFFsUE5wMGNJRkxuU2daTGNVbU5UOHR4ZFExNEFh?=
 =?utf-8?B?UVo3SFQ2VFV1VzlTQmRBN1RXQ0xvM2RUalB5TGZkb1BKVHdpRVB6ajFCdzgz?=
 =?utf-8?B?M1ZJRzl0Z3BqRDljYTdNMWJicWI3ZnNkSGV5dG1VbmZ2RGtLRE56SU9xalds?=
 =?utf-8?B?dGVnQlVvQ0djWXRnVXlEKzJublpyTXg3WnErVlkvYWpJR0ZRbVBoZ2hqeHQw?=
 =?utf-8?B?NFVWRk1KUzd0YWh2emF3ZnljU3pSSzdzeTE0WjU0S0NxaThoa0VNbktiZEg1?=
 =?utf-8?B?NU91aSs0NExyV1d3N2pmYzlrZWVWMGNNQXV5YytEc1dJb1BIeVlPZStONVhp?=
 =?utf-8?B?Zm4wZkhOQXZYS0hHeTVnSEppZGhaNzFVQkpVT05XNlY4MFRYLytzdVpaZ0xk?=
 =?utf-8?B?TEkwVGVNOW54RTVjaklFMnAvc2swc1hLRHdJYU5LOEE1NUNGdUVkVklNRlZ2?=
 =?utf-8?B?SlFHZCt6VzZUV1dPaFRDZTY0K2JoZzM0N0lvU2hySk5qT0tIRnZkeVNOS3N5?=
 =?utf-8?B?SGwzMFpCMENEL2RXOEdwRXQyc2lNL0x0TG1XU1lHMzhnejc3YjMrUHRKczFL?=
 =?utf-8?B?b2FuOG5Ca1h2SmNRYzZ6U3BWbFlicHNHd3A1RjVZVm5aWWVmMFVELzJoT1By?=
 =?utf-8?B?Q1p1ZTBCcCt6SlNmLys3OHFMQ2VXSGtwS0R0bnF2cnF6TWVjanJiQ2ZiL3FU?=
 =?utf-8?B?RkMvY3BhSk1XQWxJU2JDVlJ3dm9peUtsWW92RFNrMFZyNmhCMXNXSzZ1a2Vr?=
 =?utf-8?B?MUJvZWQ1aUhweDNzQTNQS0tTTXdOT1VyL3N0SWh0R2RNdmdhZVU4WDNzd0pD?=
 =?utf-8?B?R0g4MnNxbEdwL3NpRHVzeFBRa05TeHJ1eERTbHp4NitzT2N3WEJ0Z3cxSDFn?=
 =?utf-8?B?TG5wQ1RNbzBsRzV3YVlVWGtqTEJBWHVsMGJCZm9vMHM4cVNCT1UyN3Z0R0c0?=
 =?utf-8?B?M01HN1ZsMXVneFRVSUk4WXEwd1BjSFlFaDNtWitOWkIzOXlua3pKYUxDSFVn?=
 =?utf-8?B?KzBlekhzbHpmYWFtYUtmMTF2ZjhqWkVOa21Fdno4WS94Rk1tZ3dJVnBmWEJ1?=
 =?utf-8?B?QkhSTkxQWkVrMEhUMTZ3TjNpeVZHYlA4RVhkV3Q3OUM1dVJYcFl6dW5Da29o?=
 =?utf-8?B?TmdWMEFadEVEZUQ2ZWRidkhWeVpaODNhSFF2V1NLd1pNUTRBWVRYQzd5QVZl?=
 =?utf-8?B?Z0RtendCRi9lT1NWc0MvQ0FmZEMzQ0Z4ZnBCYnRNYThiTHlUMm5SaStMZnZo?=
 =?utf-8?B?MEtWZkdjOHVaK2lOZml3MVlIbGQ3SndheDdUZnZKRE9pbEhXRUpOY2pXRk9D?=
 =?utf-8?B?M1BRQVQvMUl4YTYwNFV2NjA5cnBaczNveVN6elhSbk9PdGZ2ZnllR3ZnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T2xtMHVmZTR5N3FIN2czcTkzb2ovUEswYnhvQktIM05YWE5CbXZQekg3Kys0?=
 =?utf-8?B?VmhKZmpzbmwxdytCVjdBUVlvckNyeXVrbStUUHB3RGM5dzdCRWxyemdBV0s4?=
 =?utf-8?B?OGJOOUowT1BvSDVnSmR6aWJVTHZzNUNBRFFsVlhUOGt2SWNBbmVHQTJWUThW?=
 =?utf-8?B?ZWtHaUFnNDdkaElBQ0duZlUrd3UrakIwRU5KY1ZXSTdqc2N0THBGZ3ltSmVq?=
 =?utf-8?B?L09hY3F0NlFJQzhuTklKbXpZUmpJbFZkSEVUN0hnUkRtenRNZW5LZmkvN2lR?=
 =?utf-8?B?VDAvdFRsMVZxUGRsRkdWQkszUGplOTVFZWhzNWg4QldBRE94ZWxkeEJlK29I?=
 =?utf-8?B?QVlhSWRrZVhrbGd5NmdPcGNJbVpwMkRoa3ZQbzRiM2FROXhweEdZWmhUUHJR?=
 =?utf-8?B?NThvTEQ2b2srQkdYa0NWa2Vpd3YyT3E2N2dHaGJvdWpiTHViRUF0eUZmT1gy?=
 =?utf-8?B?QTNaMDdrN1JIWUNGelNUaFNVTGdIUktpdjJHNUFsQUhZREUvR3lRYk5KWmJj?=
 =?utf-8?B?NlliVHF3VTZqUmh2S05xcmdwQVZRbm52ckNDcGpNNEg1eFJWNXVNeFA4RW1U?=
 =?utf-8?B?ZlRjeW94SmN1N0VXNVZ0a2d4MEZ0UU16T2pVVWVWdXM2L2J3QWpwaGVvOVY3?=
 =?utf-8?B?d1BxVGJBUm1CY0tVc0hieDlrM0pZSUZweHo3cFJQTzdScWZ4V08xdUc0Vi9I?=
 =?utf-8?B?MW04NVY3UE85TVovQW8rUUJjU01qNm5HNDNPYkdtSWRXK2NmRWRydWV5UCt6?=
 =?utf-8?B?cXJaQlFMcVJ4NkpNQkZYREJqRHpWakhIS1lIRXJwUmFPN1hpanhIbDgvL3ZV?=
 =?utf-8?B?TjRtOXZhODdtM2ZGT2pic3VORi96b2pOTWFKNzF1Z1NzUVpXQlhibmJLT20y?=
 =?utf-8?B?STJvbDErdFJJOGxMVnd3UktWdFJxbXNyZWxmWm9sOWlUQjFrYWhXVTBhOVUy?=
 =?utf-8?B?NFRnU3haeDM3Y3pBMGpYTHlrRDhzRnY3TVhoTlV3TjJ4RkVtMWJuaEdsNERP?=
 =?utf-8?B?eHVKRDRZRzM2K29HREFUMzE5WktBWlljazNMRTVXNnRrdEdkUEcyVkdLRVRK?=
 =?utf-8?B?Qy9MczNxdWdoMHFkNU45amZETEp3d1JMQXcyT29PNVpRbVhWQ25wdEhDaW8x?=
 =?utf-8?B?NWhhd2MvNkl5MzhQbHJHb3JFY2NEUFNHcEs2Q1grRXdUMkd2ZVZKMnpLTHZk?=
 =?utf-8?B?VzdwOEdhQjdQOXRES3p0eUxYSm9aVzlLVjBqVVFleVBLYVFrR1RpODdIVUJ0?=
 =?utf-8?B?ZUNZRDhDaDI5cU4rMWNORkJqRmNDalM1eVpNQmdIR0ZnWVlzVGlyY0Q0d1pO?=
 =?utf-8?B?ZjRteWtmOHFWNUluU1ZuWWptQjZXU1JLbFpmajhOdG1LZVczU0F4SHBESDEr?=
 =?utf-8?B?MTI5c3NwV2NhNm9aL1VpOUhwakljMGp3TUxtZ1E3ZXVzMFdOek40NmdHSnpq?=
 =?utf-8?B?T0pwa24xQVlSM3l3WHU3UWYwOEZ6SjMrWGg0bUxEYU5RZGhXSmtkaFpTSnRo?=
 =?utf-8?B?OVpKL2wyVXlRMllkbDM0R2xpVnRMRjRWTGt2RytBRmVMc3VPKzhWVmxqTFJz?=
 =?utf-8?B?OEEyZlZTZkdMWVp1ODVSTlUrY3MvY1lQQUhHWlBwMFMxYjkwR1pNa0RXOWR6?=
 =?utf-8?B?UGpKdEZXenY5UkN3K29oekpCWEh4U1NGY2ZUSzRZb1M5cTNMekZxMnIyRVkw?=
 =?utf-8?B?RnhSTktIUlJKTitvTUVWU2lXOEY1NWxCbHJycTFBd1NzaXJkVTByMGFKdTQz?=
 =?utf-8?B?aUh0OWNnS292a3ZlSzc5bVJpK0UrSStNelJ1bTA5YnRJdCtONHhZNUlZNTVU?=
 =?utf-8?B?Uzl3ZGl1Yi9pNUU2eEFaM2tOZHpXOUlmWm5BbjI0LzFkM3FnMVZhQ3dJTWsr?=
 =?utf-8?B?QSsrOExsT3c3TjN5QmhGNmh5SmQ0Z3hka3ZwdVFoNTRQVmZDelc2K1hsaG11?=
 =?utf-8?B?MHdMY1F4S1BWN3Vodk5rcHVxdlFTSjFDNUZ1bitzb3ZIakpkN20xWEp2Z2Rv?=
 =?utf-8?B?UTZPb28reDhZdEtFbGc4MjJMQXMzUUFrcjR6U01DVDZkN2kvTXBLdG85S1Rt?=
 =?utf-8?B?U3YxY1ZjclIxRmF1d0VzSXpaUGhGMXUwY3lLR1krc0J1Vjc4cUR1ckN3dEh2?=
 =?utf-8?B?L2FPUXpZYUNJN3duaktibkZKL3EvRW9NdEFhbHRPbEl0VDIyRTlxRW1vUEFm?=
 =?utf-8?B?Vys2TFdvaWd1VnZnV2tsRDBWaUtlb09QazZ0V01INVQvQXVqa1pMbmExQmp5?=
 =?utf-8?B?OFFSdVZUUE51U0pCTEcrUHlMYzArMUxGelcwcThiKy9xNC9oZVdvOXJ6UFhU?=
 =?utf-8?Q?LaQhJ4+XwlAvTi+ikn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2305C6E8BEDC8E4F8E37687C0B4D013E@DEUP281.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3214b230-63a6-4e2d-0d07-08dc6f62ab9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2024 13:27:55.5932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B22E6oBaWg/opgK3ftulCnX4muhm2ry0I4Xp9YzGUnxvZIA3g/1pBV0zbfa1IjY6cKb8lSA7p6t9xt1TUDUkiLK3HwzdirzMB19RVKlkKN1+OIzpaBOU/JCqbXVnTBOV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEXP281MB0231

T24gVGh1LCAyMDI0LTA0LTE4IGF0IDExOjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEFsbHJpZ2h0LiBJIHdpbGwgcHJvcG9zZSBhIHBhdGNoIHRoYXQgc2V0cyB0aGUN
Cj4gPiBLVk1fUlVOX1g4Nl9HVUVTVF9NT0RFDQo+ID4gZmxhZyBpbiB0aGUgbmV4dCBjb3VwbGUg
b2YgZGF5cy4gRG8gd2UgYWxzbyBuZWVkIGEgbmV3IGNhcGFiaWxpdHkNCj4gPiBmb3INCj4gPiB0
aGlzIGZsYWcgc28gdXNlcmxhbmQgY2FuIHF1ZXJ5IHdoZXRoZXIgdGhpcyBmaWVsZCBpcyBhY3R1
YWxseQ0KPiA+IHVwZGF0ZWQNCj4gPiBieSBLVk0/DQo+IA0KPiBIbW0sIHllYWgsIEkgZG9uJ3Qg
c2VlIGFueSB3YXkgYXJvdW5kIHRoYXQuDQoNCkhpIFNlYW4sDQoNCndlIGhhdmUgc3VibWl0dGVk
IGEgbmV3IHBhdGNoOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjQwNTA4MTMyNTAy
LjE4NDQyOC0xLWp1bGlhbi5zdGVja2xpbmFAY3liZXJ1cy10ZWNobm9sb2d5LmRlL1QvI3UNCg==

