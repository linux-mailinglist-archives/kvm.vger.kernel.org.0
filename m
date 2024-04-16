Return-Path: <kvm+bounces-14808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A668A7263
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E9C9282EED
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6587F13342A;
	Tue, 16 Apr 2024 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="xD2FrakX"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2121.outbound.protection.outlook.com [40.107.127.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C14F4E7;
	Tue, 16 Apr 2024 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713288715; cv=fail; b=DZNO3Jof0gTPldr4JSZmYvFLLEFlVBxN8aXpntQd2gkAFo3Pxkyf00lPagEgrPZy1ueKvwcRlO1K3xEhjtwbuw9FCTjtTEP8SrtWt/ZoxIljdLInkt0pNPn8x9OY0YsrrcY0rPb/+QGtEXbiQbAygQPexiCNFCWd1LainCoBJQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713288715; c=relaxed/simple;
	bh=XVOpRgyl8XDRhJtB1N2VR45cgtBkvhwbYjz2JuX2FlM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C5YEEBNhLMymfK29bHHKt/Ah3RSaUwnVkN9+eUhRGpLBN8U8k1YPcg7VxjmjZfATv/iWV3C/O9Pojji4vxkxAEfpc/VkqovZWI3q0rP93xfxAxMRrKZklIa8u+PTplxHoAywduvUvayex470g4uYhZLWiNWFAhwevPaPi+MV6rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=xD2FrakX; arc=fail smtp.client-ip=40.107.127.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEcxuwtV5fIufdQ4VI0kAfaIdAvA+DaLrDr8/k7W/VbwjcPGjLiJgrzZVQpudN5OtRCBB6adaTVrPpvjmWoWTVfc5+1kp2pJ6DvfzSxwzkCgnwJ//n3ZoUD4G6fmc/zSpygvZXR7RQZBPF2O0S2w5SZfqN6ZCNEQ/fPj6P0xTrCNpekOfdZlow7iDvnsP2gtPcqUnKw1usJqmNzwc/yVnS1jY6rjQWBHGUSNBlgDFkrokArGFMWYCdMBHcS0mL2aIgjHUbg6yAJr9SldlsRfd8wYWIHrSf35vVtexmAGLCXGGsbkbZuqxvZxhi5wn8MmJAKUfSrcQetMnQBEbGtRQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVOpRgyl8XDRhJtB1N2VR45cgtBkvhwbYjz2JuX2FlM=;
 b=ckSMJHh4KXPqmQ/1ZF2MOD9N84Pp6Q/12M1CwihkxPWra5MO8Vt5cIYAQWxfxHTQurOH/uXPqeXw6jvVa6j3G5FMb4aPvn1Y/DcAqXyC7Gnh67ToEy9ezn9D/PbEuB20FZou9R+LNAbF9uMBLGZoUCH2jizPPhspAgqNzTcJ9aHNXdDOpvuEZf6eXxsghRsC97GWbTlB1l8m9xGEyr9xWoxdoMQjw3dORhCOWm4U+LVs3oYtkg7Pa80/HIOo2yRIRh58q8QpIy9YXH5Pcnz5UazsOqAy2ni+LyxEtDs+q/q89UvFf5/eho+6e0l+Wee01NP8I9hTBCTOjphFvRNSXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVOpRgyl8XDRhJtB1N2VR45cgtBkvhwbYjz2JuX2FlM=;
 b=xD2FrakXVzvcEsAeD72+djPEwxR2gEtkXeMScH3DPXTObF/xy9MntZDUbbCzyYw+Q7j3rotDJNrgb15zUjipFgL45HSW1BRy4/gnmbpRxg8+2Vrp87kE9A8EsA4+3A0bX2XxSxSGMgUqFyhL3rX5g0rtlijVu4sK65avSAAqu24LFM3FrWoySYgV0m5Cjh4zWB5nS/65uOcLnF96aCSGYwFN070jZhPfx9JmEwNTRVmZux9PzbfPNxyCLsUvWNTjkVCuZWWSwVfUsz4G6mxLFg6N1kwtwucxkf/mexTFF+lUl2ZIoRRjGMX3p6Q5SVj4pGWwtz9onylrCC/q8x9Brg==
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c3::11)
 by BE1P281MB2897.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:69::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 17:31:49 +0000
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75]) by FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 17:31:48 +0000
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, Julian
 Stecklina <julian.stecklina@cyberus-technology.de>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Topic: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Index: AQHaj/q7SvbB6thKm0KGE0qK9A01DLFq9pcAgAAJW4CAAAKJAIAAJXoA
Date: Tue, 16 Apr 2024 17:31:48 +0000
Message-ID:
 <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
	 <Zh6MmgOqvFPuWzD9@google.com>
	 <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
	 <Zh6WlOB8CS-By3DQ@google.com>
In-Reply-To: <Zh6WlOB8CS-By3DQ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR6P281MB3736:EE_|BE1P281MB2897:EE_
x-ms-office365-filtering-correlation-id: 268bb7e5-a551-475c-bacf-08dc5e3b1898
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?R2ovOVBERXhaRXNOWWpZbGRsc0dLRnl4aG9Uc2tCbmlNM0pBaCtKQXNDRXQ0?=
 =?utf-8?B?S2g2VXNiUFVuN3p4QWxPL1V6R1dCaFN6YVZzSVFJejlWUGhNczlTaFpqV0dn?=
 =?utf-8?B?OUpyVStYWDhJeWp4NU1qdFRPNnQ0emJhditmUTlRdXhZdDd5dUtkS2Nuamdp?=
 =?utf-8?B?NUZIeFBmMXFYejZ6WXp5MWdXdUs4ZllxbXNlaGRFQ1NLZ2QzaGxaTlVUckZq?=
 =?utf-8?B?UUdZZGdpNys1RWlKRlk4cGV0dWVqRUVaOXQxTUZDc2o3dU9ZOXhXb1V2c2Vm?=
 =?utf-8?B?MUVrdXZpb25razVpL2FVeVdXdWVydC9GN3ZTREY2Z0xCZjJ5anVDU1BCQ2hv?=
 =?utf-8?B?Nkpjdk5pL1daazJqT0FHRVhIYVF1bXRqSEZjaElSaEZSS2V2V3Z4emp6U0th?=
 =?utf-8?B?dU1MamorUVMra0pKVld6Mi9OMHYvTzY1VURYT2FhbHhtWDBhc3o5NEV1a05X?=
 =?utf-8?B?SUlCdzQxMWtRRkJUVE5waUh6T2tyckI2YTRIZ1lybXhJanRSdVlTWlYrZjZ6?=
 =?utf-8?B?RUdubVZXSDQwdDRjS1R2SzJ3SGpkaGVFTzUxYmJDa082VmlNRThtc3h4WjZu?=
 =?utf-8?B?cThzMndGQWx5SXdValVjc285RDlTNlo1K0IwRWQ4ZVg3cTExSUYwaXFTaUZT?=
 =?utf-8?B?bVVCN2xkZC9xQ1ZGY3F0cW4wODBuMUFIcC9PMytrWUdjYVd1TURScnlFQnJC?=
 =?utf-8?B?UjlEcmJ1ekFOK0xad1QwRHdLMGc5QTBKSHJsSmlrYmo3OGJHcS9DdXptcUZ1?=
 =?utf-8?B?MFFrSGxsN1FjTXR6NHVEU2ZjQVFpWjBBb3N6dHZXK3hvbURDYld2eFV2UFlZ?=
 =?utf-8?B?aEcydGZFZXpFYjlMWXlEUVhmR3hlZkh4NFFGYUc3NGZwdmdRcllNeEs0cUhn?=
 =?utf-8?B?dW1jS0tkMk1Rb0E2aHI0T3RtcVI2MW4ycFNCOVBPMUFKOVQxLzhjZ3d6U3NQ?=
 =?utf-8?B?ZG5HMGZFT3hsdFJ0NjhRWThVWFpRUlZQSXFyRXNFMEFEaS83emtXN0xERnZ5?=
 =?utf-8?B?cDgzaXlqdHFzMWk0RzJXQnIyN1M2WGE1djR4Z1h0UmFoeldOWmU3THdCK2M3?=
 =?utf-8?B?SjFyaGhITHl5L0R0NW1SSnp4eW81YVYvQ3RaTytCbmtoMUsyV0UrNlV5dk5R?=
 =?utf-8?B?WTQ2aHZtWWcybUxvSXdxK0w5UUxmcmJZb01UOElUaWQ5N2swK1BqMVFncDJw?=
 =?utf-8?B?UlpZZVRzZm9qTnZ2eTRxZndHT1NpZ2daSk84a1UxZDBDV3ZwOGdPOUk2ekl3?=
 =?utf-8?B?anpPZkxsWWx3cGoybW80WEtTMFY4SjltU2p2S2l1czcrU3NFWElYVVdCakVZ?=
 =?utf-8?B?TEdJVmlJMDh3eUptN2NxaThEa1h5bG0xVFFqc2t2aGlLdGdIWXEzaW9RVGkr?=
 =?utf-8?B?Q3ZueDRhbWxlWnRYdGh4aU8zSXhLM3ptcHQwQXgwcnNPaDVVS0NRcGhCcU41?=
 =?utf-8?B?TWY0c2RVWEozdVFCcFFLUlpSbjFCZDNCMG9LSHk4MXNJREFPSjBuVTRwaU0w?=
 =?utf-8?B?SGRIV29RWi82OHR4dWdzTytSWGNxQi9qRTFjV2l3b1BISUorTU1tWEJoTTI5?=
 =?utf-8?B?WkZTbHV5UWtGdUFYaFB0UHBkR1l4b01VbGJjNFl1N1ltQ214TDQ2THdzN2FF?=
 =?utf-8?B?cmVYaVFocXB5RC9PWmdTOUo3UEpKeEUycERsWElzczErN3FBUnk0N1VMUGdT?=
 =?utf-8?B?WnpSMGNzV2I2ZUNrbHVrSXhzeWVic3BhdG1HSkdtbHB1RDRlcWh5Q3RNNkp1?=
 =?utf-8?B?cUJ4cEh6QWMweGJJSzZLN0RmOWE2UVVSZ3BhZkRaV1FqMnIvejA2cXk3Q2lC?=
 =?utf-8?B?Mm9JTGYwd2FNaDJDMENXQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UUdYOXZ6V1BiUkMyNUpzRmljblhncUZMdUEyTXFhOHNGM1dWdzZ6T2NNYVJZ?=
 =?utf-8?B?UU9ERUI5RmN6dWVkMHhxeGhWSWlnYVg2aWhTOFVoTzB4b1FLQTlUeHZGVXpy?=
 =?utf-8?B?UUFVNlVaMnNtRXU4YVBNZGFNdHcrZDIrVWtQdyt0Tm9wNUNjcnpKOTFabE13?=
 =?utf-8?B?bnlZYzZjcUVXUG93Q2E1SjBBSnpuS3U4WVZ0dEFvbWQxbll2aHFad3F6TnB6?=
 =?utf-8?B?SkZ0cmh1R1VaMFNZdmNaWFFkRkU3Wk9qOW55emZuSGVDTjZpRk1zRHhqSkFz?=
 =?utf-8?B?ZnBaSVJBdHZrcmZRaUlzVG94KytpYUJ2NW1EZ1E2U3hKVWpQSTcyQ0dHYWpl?=
 =?utf-8?B?Q1RmVjZFTEtZeDM3YkllL0ZLRmViMGdrMGJHSEpsNExMK2pCSkRmWGViRG1x?=
 =?utf-8?B?QnBPc3NZOGc2ajEvRVRVR2w5cWoxUG1la3hYcWs4ZlFYVDk2SG9HTDJSMmdm?=
 =?utf-8?B?UVpqMkxmZnVyZWRDK1hTK0N4Uk04VGlTWEVPYUxoOFZta04ydElBOFRKaERJ?=
 =?utf-8?B?b1NFejlSRDJnNkVZZ0lCMWFnUmRNaWxRN2lGVC9YSFU5RjlOanB1VU1FOUdB?=
 =?utf-8?B?bTRGSWtGZEVZbWlEWm13RVEvWnFNdmhONUw1SVNVaXRQOXc2ZXJtRUVpTDRk?=
 =?utf-8?B?WktVQjUwOEI3Tjc2SnNnQ3FEcG5BbnhsbENsVTFHaklXUStUYTF5SElBWU9K?=
 =?utf-8?B?WXZja0xIaDJ1eW1FempnM2tjemR4bmhvQjhxOXExd25pNkw3bTZzY0JwdU5W?=
 =?utf-8?B?ZWNySEZiTVJ2d0dZYVUxaFlaa2J0cDZ1ODI1U0FUbTF6OFBVUjdqZ2NiVXZK?=
 =?utf-8?B?VzR1RlVPSW10WlBRWWxmQU0wNEtScTJJbzYwWHZlUW85RTJZd1p2YUtFVFJi?=
 =?utf-8?B?LzNDRldtUDVnTEFOYkxxRFR6WUZCR2pLOWoyTXkvWDhad0R4VUxLb2N5VW9q?=
 =?utf-8?B?b0NTeWRPUlBaU1hZdnZNSjlTbXVLRHNudTVHTm1lUlFIRVZsM2I1aXdMTE1S?=
 =?utf-8?B?b242OVAxVFl1S1grSVg4NmY2a09xSThDVjNtQWVOSWNmM1dQYmZGdmhEWE1q?=
 =?utf-8?B?U2p4bU1WNzRBMUxVdG9weU0vVU04MXcyUkZ2WlNtVkN3ekFmZWtiQlduTVFL?=
 =?utf-8?B?WlFRUDNvK2hxa3FzMjJ1RHNOdnRSYUlxVkRLV2U4THJoSkVDVHJSckZ5Ym9W?=
 =?utf-8?B?dE10TXRDa1NYU2UwQ0czdVlJVktoVmdvMVR5V3QzSERUbGN2V3VEYzlUdU11?=
 =?utf-8?B?VVF6UEo0cHFoME9WWldXZGV4NmFHVDlNZjFZYWo1WDBUNFN5Z2lKTDhOTTlL?=
 =?utf-8?B?NEpIckNXdkY0VGRSd2tqZUJxNTZEdDVzZWpUQ1g4dTFTOVY1MXFmOWpmUTJn?=
 =?utf-8?B?dDlTUGsyOEh5bXl4OUtkK1JwbXltL1FxZ2JsQjZERkpJK2hpbzk3SG1FNDQ0?=
 =?utf-8?B?RWdLT09nTzU1MEdGUmRabFlnZlprMFUzOHZRUzBGeDM4OGNGVndMRnk5ZU5x?=
 =?utf-8?B?MFpJSlVDanF1ZldrZ3FKb1JaVVAzZnpVajd3Y1ZXbzU0dU1aT0RFRTQ3VjRP?=
 =?utf-8?B?a3RhRVMySU1TT2huL20rUDBsa0N5TnZadlkrT1Y2Q3pKRjdXRGhCajlxS1cy?=
 =?utf-8?B?ZlBYaHJSWkRxaHJLWjNSRTJPRGNxTlFNajR0ajkrU3Z4YnhVZlVaU1dUYmw5?=
 =?utf-8?B?aUtlQnBxMi9Tb2IrNjJQTURONmdDbkZMV3ZrTHJYWnVYWklRdHhBbGhiL0Js?=
 =?utf-8?B?VDA1cnRaN3ZBajQrV3JMQVNnbmlNVERqZDhPenhqUHJObC9FT1l2K3hza3Ez?=
 =?utf-8?B?d1N6U2dnMmxlRVZWdjBJb3NGcXZUckN5UE43Rk1rOFFOOG5sbDc5V0FjTWJj?=
 =?utf-8?B?S0pVZXlwdWhaa0FWbDlwSDlrcXFpMFdTenR0RnVDcWhVVWhRN1FkVTlXcW1l?=
 =?utf-8?B?N2tyeGNUNmh3cmVjdEx6eWpFQkhIK01iQVlZeUZHL3Q1VjJZTkJLN2VPdEtV?=
 =?utf-8?B?UVg2dXpZblQya1F3UHltMFYzMkpBK1hYbC92K05CVEZHaGloOXYyd1NCdVZL?=
 =?utf-8?B?T2JSMHlQMTRwVjlKTlRvdXlqWi82dGxNT2lQWVM1c2djaDlhZlhvRE9VUHdl?=
 =?utf-8?B?MzdScjdsVjZlWlQ0OUFIcjY5TVQvcFZVTllEekp1azNBcG44SG9tR29oRFkz?=
 =?utf-8?B?NzZsQ2ZqVlk4TzZwU0dRS3MwTDUwVlhUOFoxT04zMGNpRmlraVpqc2p4cHY1?=
 =?utf-8?B?alM4Z1BPUnZyditWYTB2RWsyU1pldWdQeDI3R2UwaWZZcURsY2I3TnlpZmJF?=
 =?utf-8?Q?9R2ylXm1+PKr6sz6Gu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBD35F437A15FE41BE4D23B2896CD673@DEUP281.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 268bb7e5-a551-475c-bacf-08dc5e3b1898
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 17:31:48.8089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4pDgr6RdUCgZg5rBkEZam93YbzlNlbBKchYKziRAUO6ytXcnyxMZFrBqOXHCrhgN+AjTCBXtNUCOIziX8ex8aDJNE3mf04EqlkWmp9ZrsUvaP2Cur6FMr2BsNN53Xgce
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BE1P281MB2897

T24gVHVlLCAyMDI0LTA0LTE2IGF0IDA4OjE3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAxNiwgMjAyNCwgVGhvbWFzIFByZXNjaGVyIHdyb3RlOg0KPiA+
IEhpIFNlYW4sDQo+ID4gDQo+ID4gT24gVHVlLCAyMDI0LTA0LTE2IGF0IDA3OjM1IC0wNzAwLCBT
ZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBBcHIgMTYsIDIwMjQsIEp1
bGlhbiBTdGVja2xpbmEgd3JvdGU6DQo+ID4gPiA+IEZyb206IFRob21hcyBQcmVzY2hlciA8dGhv
bWFzLnByZXNjaGVyQGN5YmVydXMtdGVjaG5vbG9neS5kZT4NCj4gPiA+ID4gDQo+ID4gPiA+IFRo
aXMgaXNzdWUgb2NjdXJzIHdoZW4gdGhlIGtlcm5lbCBpcyBpbnRlcnJ1cHRlZCBieSBhIHNpZ25h
bA0KPiA+ID4gPiB3aGlsZQ0KPiA+ID4gPiBydW5uaW5nIGEgTDIgZ3Vlc3QuIElmIHRoZSBzaWdu
YWwgaXMgbWVhbnQgdG8gYmUgZGVsaXZlcmVkIHRvDQo+ID4gPiA+IHRoZSBMMCBWTU0sDQo+ID4g
PiA+IGFuZCBMMCB1cGRhdGVzIENSNCBmb3IgTDEsIGkuZS4gd2hlbiB0aGUgVk1NIHNldHMNCj4g
PiA+ID4gS1ZNX1NZTkNfWDg2X1NSRUdTIGluDQo+ID4gPiA+IGt2bV9ydW4tPmt2bV9kaXJ0eV9y
ZWdzLCB0aGUga2VybmVsIHByb2dyYW1zIGFuIGluY29ycmVjdCByZWFkDQo+ID4gPiA+IHNoYWRv
dw0KPiA+ID4gPiB2YWx1ZSBmb3IgTDIncyBDUjQuDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGUgcmVz
dWx0IGlzIHRoYXQgdGhlIGd1ZXN0IGNhbiByZWFkIGEgdmFsdWUgZm9yIENSNCB3aGVyZQ0KPiA+
ID4gPiBiaXRzIGZyb20gTDENCj4gPiA+ID4gaGF2ZSBsZWFrZWQgaW50byBMMi4NCj4gPiA+IA0K
PiA+ID4gTm8sIHRoaXMgaXMgYSB1c2Vyc3BhY2UgYnVnLsKgIElmIEwyIGlzIGFjdGl2ZSB3aGVu
IHVzZXJzcGFjZQ0KPiA+ID4gc3R1ZmZzDQo+ID4gPiByZWdpc3RlciBzdGF0ZSwgdGhlbiBmcm9t
IEtWTSdzIHBlcnNwZWN0aXZlIHRoZSBpbmNvbWluZyB2YWx1ZSBpcw0KPiA+ID4gTDIncw0KPiA+
ID4gdmFsdWUuwqAgRS5nLsKgIGlmIHVzZXJzcGFjZSAqd2FudHMqIHRvIHVwZGF0ZSBMMiBDUjQg
Zm9yIHdoYXRldmVyDQo+ID4gPiByZWFzb24sDQo+ID4gPiB0aGlzIHBhdGNoIHdvdWxkIHJlc3Vs
dCBpbiBMMiBnZXR0aW5nIGEgc3RhbGUgdmFsdWUsIGkuZS4gdGhlDQo+ID4gPiB2YWx1ZSBvZiBD
UjQNCj4gPiA+IGF0IHRoZSB0aW1lIG9mIFZNLUVudGVyLg0KPiA+ID4gDQo+ID4gPiBBbmQgZXZl
biBpZiB1c2Vyc3BhY2Ugd2FudHMgdG8gY2hhbmdlIEwxLCB0aGlzIHBhdGNoIGlzIHdyb25nLCBh
cw0KPiA+ID4gS1ZNIGlzDQo+ID4gPiB3cml0aW5nIHZtY3MwMi5HVUVTVF9DUjQsIGkuZS4gaXMg
Y2xvYmJlcmluZyB0aGUgTDIgQ1I0IHRoYXQgd2FzDQo+ID4gPiBwcm9ncmFtbWVkDQo+ID4gPiBi
eSBMMSwgKmFuZCogaXMgZHJvcHBpbmcgdGhlIENSNCB2YWx1ZSB0aGF0IHVzZXJzcGFjZSB3YW50
ZWQgdG8NCj4gPiA+IHN0dWZmIGZvcg0KPiA+ID4gTDEuDQo+ID4gPiANCj4gPiA+IFRvIGZpeCB0
aGlzLCB5b3VyIHVzZXJzcGFjZSBuZWVkcyB0byBlaXRoZXIgd2FpdCB1bnRpbCBMMiBpc24ndA0K
PiA+ID4gYWN0aXZlLCBvcg0KPiA+ID4gZm9yY2UgdGhlIHZDUFUgb3V0IG9mIEwyICh3aGljaCBp
c24ndCBlYXN5LCBidXQgaXQncyBkb2FibGUgaWYNCj4gPiA+IGFic29sdXRlbHkNCj4gPiA+IG5l
Y2Vzc2FyeSkuDQo+ID4gDQo+ID4gV2hhdCB5b3Ugc2F5IG1ha2VzIHNlbnNlLiBJcyB0aGVyZSBh
bnkgd2F5IGZvcg0KPiA+IHVzZXJzcGFjZSB0byBkZXRlY3Qgd2hldGhlciBMMiBpcyBjdXJyZW50
bHkgYWN0aXZlIGFmdGVyDQo+ID4gcmV0dXJuaW5nIGZyb20gS1ZNX1JVTj8gSSBjb3VsZG4ndCBm
aW5kIGFueXRoaW5nIGluIHRoZSBvZmZpY2lhbA0KPiA+IGRvY3VtZW50YXRpb24gaHR0cHM6Ly9k
b2NzLmtlcm5lbC5vcmcvdmlydC9rdm0vYXBpLmh0bWwNCj4gPiANCj4gPiBDYW4geW91IHBvaW50
IG1lIGludG8gdGhlIHJpZ2h0IGRpcmVjdGlvbj8NCj4gDQo+IEhtbSwgdGhlIG9ubHkgd2F5IHRv
IHF1ZXJ5IHRoYXQgaW5mb3JtYXRpb24gaXMgdmlhDQo+IEtWTV9HRVRfTkVTVEVEX1NUQVRFLCB3
aGljaCBpcw0KPiBhIGJpdCB1bmZvcnR1bmF0ZSBhcyB0aGF0IGlzIGEgZmFpcmx5ICJoZWF2eSIg
aW9jdGwoKS4NCiANCkluZGVlZC4gV2hhdCBzdGlsbCBkb2VzIG5vdCBtYWtlIHNlbnNlIHRvIG1l
IGlzIHRoYXQgdXNlcnNwYWNlIHNob3VsZA0KYmUgYWJsZSB0byBtb2RpZnkgdGhlIEwyIHN0YXRl
LiBGcm9tIHdoYXQgSSBjYW4gc2VlLCBldmVuIGluIHRoaXMNCnNjZW5hcmlvLCBMMCBleGl0cyB3
aXRoIHRoZSBMMSBzdGF0ZS4gU28gd2hhdCB5b3UgYXJlIHNheWluZyBpcyB0aGF0DQp1c2Vyc3Bh
Y2Ugc2hvdWxkIGJlIGFsbG93ZWQgdG8gY2hhbmdlIEwyIGV2ZW4gaWYgaXQgcmVjZWl2ZXMgdGhl
DQphcmNoaXRlY3R1cmFsIHN0YXRlIGZyb20gTDE/IFdoYXQgd291bGQgYmUgdGhlIHVzZS1jYXNl
IGZvciB0aGlzDQpzY2VuYXJpbz8NCg0KSWYgdGhlIGFib3ZlIGlzIHRydWUsIEkgdGhpbmsgd2Ug
c2hvdWxkIGRvY3VtZW50IHRoaXMgZXhwbGljaXRseQ0KYmVjYXVzZSBpdCdzIG5vdCBvYnZpb3Vz
LCBhdCBsZWFzdCBub3QgZm9yIG1lIDspDQoNCkhvdyB3b3VsZCB5b3UgZmVlbCBpZiB3ZSBleHRl
bmQgc3RydWN0IGt2bV9ydW4gd2l0aCBhDQpuZXN0ZWRfZ3Vlc3RfYWN0aXZlIGZsYWc/IFRoaXMg
c2hvdWxkIGJlIGZhaXJseSBjaGVhcCBhbmQgd291bGQgbWFrZQ0KdGhlIGludGVncmF0aW9uIGlu
dG8gVmlydHVhbEJveC9LVk0gbXVjaCBlYXNpZXIuIFdlIGNvdWxkIGFsc28gb25seQ0Kc3luYyB0
aGlzIGZsYWcgZXhwbGljaXRseSwgZS5nLiB3aXRoIGEgS1ZNX1NZTkNfWDg2X05FU1RFRF9HVUVT
VD8NCg==

