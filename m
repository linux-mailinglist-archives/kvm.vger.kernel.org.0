Return-Path: <kvm+bounces-14967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E3D8A83C3
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D2721C21CC9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 13:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFAC13D62C;
	Wed, 17 Apr 2024 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="Slu9dTPe"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2105.outbound.protection.outlook.com [40.107.135.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0D13D290;
	Wed, 17 Apr 2024 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713359113; cv=fail; b=XlfkU6qWQXnn1YYQUylRTJHcVjx7C5wec45jU0syD6EtIuCl1bK2sJUWiK3RFrpFno6SMN49/UWtjXIspShyP1ublQrEwgKn261RDdLnvJSJdkgcw8OCq6XWgQGck5q/gruIrVzPL+tYdi+JMCRuSwqyiIa7PjQSpOmbUTkZAaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713359113; c=relaxed/simple;
	bh=zzKme/hQibZEeSU4y/4/G9gAHTGG5ccsyRAxQDzl6aY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gCzV7lnjFAfCeGw+TF7a3E1GipXlfvLMQzCss5dRYk5r+64Ad+FvuV8ZQ+AM2Z+6RMug+du9nat9srNYhO9fsmNZ4zOOJ4quJdtuBN7G5zTNhH1lquR/nZE3B+yP1gxvOgA8J9RcLWTMPZ86JcCP1fjPd3cBSp8MAmt4coGEQNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=Slu9dTPe; arc=fail smtp.client-ip=40.107.135.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7ZFsmUpmhVnRGVuKGz1CjSEc+Stg9Rj7lR6bVOwS5FHeHzE0Wca31BaK/WnHId97LNusOB8TV5uhRSMKvLEhEjZp1PY/PcPSfl5/CcSEH4WPTAxwxRUs8RQzHDORPYU2Gl2HZX2m0AQIUmw01ge+iXFgwNz9f07zjHcWIm58RGH01+NCmAky/hKWKNAabTqugsXzLVSPXiXHuJE5g6H6eomA9DSk/+4VKAbeLQxad2d1PdSi4BgZGcN7k2Ph2ytu+p+p5r2By3EXiKtQEUlIkrkrNZ9C2g5Q8CA2vd/q059LAcVG8obmppAZtZNCIXCFHnKh476C/c3oT5n/hSvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzKme/hQibZEeSU4y/4/G9gAHTGG5ccsyRAxQDzl6aY=;
 b=BDQQX+BPWueTpCN7/pkZiEBE9azHIgHS7Dgu3p8p3KvjHRjj+ZW4EMW/MYYclSs1cAmAyK2ntfqwtMFQtlReaJIc0Gil+RIBB/b0Y4KFK742UDMLYGYT8FOIaKsNSRnq4LhESgJdUsu1ZOVnwUpRcY1SIeuxd6sjryy8QjOrFsbSn2hvWxomhIURKTgVqrsLIUp/kL2ywyyZW12UI+eGvvlYbBBKAi3XXW9DnfCZG7yD0nBKDmoK6HUNokk1LEJCTPoRXTUBHqzmLuVYbhDXuIvzVkGZQtx/8/AY3FBAHLFwoa3hKJpFQE2rb7xej3ilCdBgwPc+aNC0GILr0UOlQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzKme/hQibZEeSU4y/4/G9gAHTGG5ccsyRAxQDzl6aY=;
 b=Slu9dTPenQJOpIZay16mBNqNpx4Ltd+WiVz0KSajpXk7YYlsv1LnaVlETbstQ+JUT1RzfZmzN3yBw1mQmNPZcy69v+yYZ57/HvKrg9gAqilMY7PaynEYvfx4ptjnOvpx/ar64Xddj+2wU9H9m18N/bgMpmbaGg4SV1RzkUqP/gFn6FEG3wJI/CeKC5DUiwsQxhop8atiu6/q5XtB/ewkUBZEOGiwGgyQHlEkzYcJ3Q1FjQYdOpkiUIxaDxrtTGQaXavDy+86iXv/KoxCfu1Lj0v0B7SmBBL2+ApbBxas43l2vBkG7UUi8st8kGHSTMIIk/vpYd3P1XrL6Orvx4E6sg==
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c3::11)
 by FR6P281MB3582.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Wed, 17 Apr
 2024 13:05:02 +0000
Received: from FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75]) by FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM
 ([fe80::aac1:4501:1a07:e75%5]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 13:05:02 +0000
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, Julian
 Stecklina <julian.stecklina@cyberus-technology.de>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Topic: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
Thread-Index:
 AQHaj/q7SvbB6thKm0KGE0qK9A01DLFq9pcAgAAJW4CAAAKJAIAAJXoAgAAKGICAAT2zgA==
Date: Wed, 17 Apr 2024 13:05:02 +0000
Message-ID:
 <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
	 <Zh6MmgOqvFPuWzD9@google.com>
	 <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
	 <Zh6WlOB8CS-By3DQ@google.com>
	 <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
	 <Zh6-e9hy7U6DD2QM@google.com>
In-Reply-To: <Zh6-e9hy7U6DD2QM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR6P281MB3736:EE_|FR6P281MB3582:EE_
x-ms-office365-filtering-correlation-id: 15f43c7b-fc61-483b-f19e-08dc5edefe87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?MHIzUVNjVmRzVnhxc3BrRUh3TlBuS0E0ZFlFb2kvL1RBVVNQVGV6UjM1dllI?=
 =?utf-8?B?UC9HTjQ5bFg4eVM4VGhaZUhtRGUrOFNZdEQ0UytUMy83L1dxc0hTZmhucTgx?=
 =?utf-8?B?c00rZVVYNlN1c2xKN05SSzNxQXg4T2ZFdmN5eDRUaHFzcFFtNEkvYXRGOHM1?=
 =?utf-8?B?Y1Vnc0UwM1B1MFlMNDlJS2V5N1Jyd0xITGZqQjYrN3dZaThCU2RFd2VtN2RN?=
 =?utf-8?B?QnZJZ3BVRDFQREhIRVJNL25Qejdvb0poVE5oNkcycjJLZ1dvV3JCUnNkMFkr?=
 =?utf-8?B?WWh6SFlnZ2Z0YXZQc2RjRVp5N1E0T1gzV0JpSExRRS9CcnZsQytJS0szaWc4?=
 =?utf-8?B?U0t5NytiVEpnT1FvejlQQjNLOWZuUzUxdllDTXRPM2tTU0h2NngyUnltWFZ3?=
 =?utf-8?B?Y2p3cHdlYkV5YjJYOVp6WkhWMTRMb3d3aEJXWHg0ZDFrS0ZPVjkwZ3cyTnh0?=
 =?utf-8?B?M1YwZWwyTjdGSHc1aVRxN2FXTXBjczNPLzZqMzdMcnN0U0xCYUpLQUQzOFJ1?=
 =?utf-8?B?TmdvdFVySFBudjlOQTJQRVZHVC9QdmhvN3ZZNGVqa1JYdWY0NnVaZ3RQSGN2?=
 =?utf-8?B?U0E3cUxYRmdFOUVVNkNyQnk4dlRyM1kvYit0d0dYd1NyNWNacUNSL1FjYnVn?=
 =?utf-8?B?cWIzOWh3SnZxR3dzTTFRaVZ6YUNCaS9iQWRaVnp1cDNpTnRETkxraUdqcXRY?=
 =?utf-8?B?VkdYRG9Vb0pMaWZ1enBnRlNzbUtvNHJGTFZKR2lEQVhWb3AvbC9yRUxIWS8x?=
 =?utf-8?B?Vk9hNHdYdTBRZkdhRVAxbkhFS2U4NE1TaEZMS1BpRk5TYzBuSUhnUy84UHJZ?=
 =?utf-8?B?Qk9EOW1Kak1TajBpaWYzRVBFaUVxa3BIdkt2aVZnd0U0V2xZSHlaN2ovQ21i?=
 =?utf-8?B?ZU1GcjVCeVNzWXp6d1VtNkpUb0ozTS9EVVRuWWN6eHVuYWlVY055cDJKNlNq?=
 =?utf-8?B?L21LbVorVkk0dHg4cGxIVUFpVHJIVGRld0F3b3RjZktJY25kVXRIZDZMYTRR?=
 =?utf-8?B?M2pPVVNPMkUwVUNCZEg4WkNydVZzbzR4YkZnZzJtVVBjNWFDVHdKeTV4b2R0?=
 =?utf-8?B?Sll3b05TMFg0cDZiNTd6RlJrY0Z0T1hqQXk0YklpVlE2Z1dzaU5WMEtvWUxu?=
 =?utf-8?B?Um5uSVVDcjQ5MWFacXgwZ1d0czZBTWhKYWtZTGo1elRvaWNwTDhDU04xdDU3?=
 =?utf-8?B?eXNwSC9PWWlyZGxhYlUrUTlVWXh1aytXNzVXVVNKOTJyN2hMK0tUd3BQU1gv?=
 =?utf-8?B?dnorYllJZnFuK3RMWE1neHRqb0VOa25YTG0vaFZpbS82QkJFZkx2TUZqZ2lX?=
 =?utf-8?B?WTY4dDdjLzB1b1VzNDVNRVFXK3Q1NDIzQkRlcmVsTExZYXlJQ2g3MkZDZWc2?=
 =?utf-8?B?OVp1Rm91V3RxdldWN2NjK01IZ0FQU1ovNWprc25VK3IxQmRBNkR3T1k2dG5E?=
 =?utf-8?B?ODNhblVHNmxUYkZyVklyT2gxb0hGMG1SOXJ1UGpBUTlpU2NITkZXVVc4NjVZ?=
 =?utf-8?B?NWczd0hJZzBJUWx6MDBLRHdjMWU3MEZRRGtNSkEzZlltYUtIV3RhUE9BNW9Y?=
 =?utf-8?B?NDJjNGszUkI0TDFobm1uMGs5TklUOUZCbHkrTWxKaVRacHVRVUtLS0JWM2ZD?=
 =?utf-8?B?eWFlcHBmWEpDSjFZenE0ZzUyOHN4NS9Ob21aNjhnazVBeEtEK1d5WURDdEll?=
 =?utf-8?B?OWlQeWhSQSt1amNDTU92M3BEeGdXVDdESWVCNHR6aTlZVkF5N2pZNS93dklR?=
 =?utf-8?B?TFhIcFY4Y3daVTFtRWlsZ0xIM1VXN2Y1SjFlbkFRRHh1MXVGb1EyUE5velRJ?=
 =?utf-8?B?d2ZRUUE3YTRQWWt3MmQzUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR6P281MB3736.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UDNxWWljam5pTitTenZJek9xd3lFb1RZdW1wQXl4OHowOXdSQkZXbVJwenJ0?=
 =?utf-8?B?TnRORFhTaUw2T2pkblU3K0FpVHBub1VENi9sMlFMbytRcW11cnZ4YkdIdVBl?=
 =?utf-8?B?LzNoU3ZnLzBMbFMyMmVQRExPK2NMc3F0MHlBQk1RMDQ4ZGlLZE9BWmpMTzFm?=
 =?utf-8?B?VEVxeHdRTjFhTGZHMHlXVUhkYWcwUzF6SGZlaWNESWZTYkFYT1Iyek12SkFr?=
 =?utf-8?B?TGtlSTJoR1ZsSU85MW1KMksraE9tWEI4UlllTWRwOFBld055UFpKd0tQVVI4?=
 =?utf-8?B?dXpPZjdLcHE2ekV2NFhQR0RYU2dMRDIxQmZCU3llOWRGbVNwOUVWeTA2eGpP?=
 =?utf-8?B?cmpZZUQ4QlFsczdjN3NwbW9YZDlYM044dHRQem1QWkZ3SWxOQmp1Q0FGdWlN?=
 =?utf-8?B?QTZqcitiaGJ5d1RrUC9DSmVURGNiVFcxUmsyWG53ckV3UWJDN0haOUpwaks4?=
 =?utf-8?B?VktsU0NrbGpyakZiTUFiZXVIb3VTQ3kwbWc0bWFPRll6TXBsOGNwc1BOSzJi?=
 =?utf-8?B?TVlMZXl2Ry9VWjNCdFl1SStVUUVyV05HekFxdmtTMkxLVERLSnBpUEpNZ24w?=
 =?utf-8?B?N0kzWWZWVmRYb1lSQUU2cmtJNUpnUnk4YzlqN0p1emZwU0ZjZDM1M1R5NVMw?=
 =?utf-8?B?d1FIaGxiSVlKL0RHdmRYQ2ViU0dkb3RTeW5GUzU0eS9rOEtZUGhzSXFyRzlv?=
 =?utf-8?B?dkpOc1haMG12citOTGpMQkltQ3BDdmxlY2pvdWxwd1kzMGNYN0tlTFg5a0xR?=
 =?utf-8?B?Z3ZJeWc5NjlEV3VDeERNdFF6NVd1OFlKbDBYQmtXY29STFBKVWNXaWRxNUJz?=
 =?utf-8?B?ankvQmRUckYyUy85WmRVQlZPVDRSdHVBR3VvNUxhYmR2c1hBbGxZRWtaSkFj?=
 =?utf-8?B?cVk5VDBUbUN0WjRxTTQvalBXdmdHbUxManhULzNjRmNGS0dHMXBBNFNxdktM?=
 =?utf-8?B?K0NEZ1EycU13RWRaaGx6dEdMcUNxMTZZbHphSHBxYk5uQXJFYjVwaldqejRl?=
 =?utf-8?B?ZUlmMnpsTzR1b29jQ1NhdjRFMFMzS3NrZ0Yvdmoyb0xOdUxqaE9qeDJrcmRz?=
 =?utf-8?B?T01Ka0xEeGhLeTNLME9qU2h0WnR3MTJsWTdGZ252S1Avb3lLZlQrdkRZZUd2?=
 =?utf-8?B?Um8rWnZac29Cek5uVEhjM3F4NGNScnExREpCdGFLZHZtZ2JZckNpMk1DWkpF?=
 =?utf-8?B?Q2NVbWhSNFNPa2JpQTRmRThqYzhuZFFYWXlhY2drbzBPSVdOVm5EVFBiMmtt?=
 =?utf-8?B?bzMzZ05rcUYvN0FtZENKVnlxUFRrSFYyTzJiYUNKNkJ3Q3p0OG5TUlFFL1Ju?=
 =?utf-8?B?dTJVbHJRSkFTKzNUSWtjeE4vVVlpNWNNZDFTTG5iMTMyZUovKzA4SnRjRmVY?=
 =?utf-8?B?cDB3NEQrTUhuSXgyNTNNcXZBVXJZcWVWREYwTGlGa2lJbldVYTMxREs3MXYv?=
 =?utf-8?B?SlV4NEl3dk56aEIzc1ZFai8vU2dOWVIyK1BDL2V5M3BrMk1NSG5QVlBSRjJ1?=
 =?utf-8?B?dGFlUjFaWVI1VDRBWTJzTjJOMkw3eWVLZHoyRUZZc0ZDa2tra0ZTSDJnUTE3?=
 =?utf-8?B?YzN6QkwzMXc4R1lkV05WRUdGL0hBWjFQek1JT3FxbTZYcy9Pb2JNNFgySHZl?=
 =?utf-8?B?U0JHbEtLZ2RzR1FQWElZS2ZXbmZZZlJPa05RWEtsRWFyMVJTL1ZBSE10RGxh?=
 =?utf-8?B?QVVKMGI4cVJkVlBOOFdSbFJYekFjUnB3b3lZVkRoUnBmaHcxbG1BT25qYVBx?=
 =?utf-8?B?eEg4R2JYZUp6VFNlaFRHSFh1U0hEWnVrK0NtUU9oVzdBcGw0bjZmOUtCQnNp?=
 =?utf-8?B?QlE4ZzJEdFFpcEUvRFo0OFhFakg2ZlBQb3VDTlU0UVZGTVZuckQ2L1NoK2Vo?=
 =?utf-8?B?eEV5UUYzQ1d2dC95enFZZjBsUExxKzVqZ3Q2czB0UjZwNmszam1LZ2p5aUd4?=
 =?utf-8?B?ZllWUG12TDFaMHhwN0RlT01ubVJVUWVFWDdZNWZVTFNENmxRT1o3QVJwakNV?=
 =?utf-8?B?WWlrRmZORWVQR2JFNThpTkVwYnN5ckw5TGJqNlI3SER3NFQzZlV3dEZEYTQr?=
 =?utf-8?B?WE1ydE4yWDYxWFJ3MXcrQ0Z6cEMrQVFHaVhDZzgzVmxCTFQyOXJCSFg0VnhJ?=
 =?utf-8?B?dm5MMWJBME9TdTFFRlZLMnFNU25qeEU5ZzhSSzNZdG1xMHQzTzA2dWJmRFpm?=
 =?utf-8?B?MW9jOUdyc3ltZFBTc2pyT3FrMmVrbE9YdmpOb0RxYzhMOUREUUdNZ2ZRQlZn?=
 =?utf-8?B?SWVidERQcjNxb0QrYzZpNFA3QU5wU1piRUcrM3lUWnhncjBzcmMvTFZ1eDdM?=
 =?utf-8?Q?8R/nXA5P8lQXnqHGkA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCBB7BA6A3DF89409D8BC780E2C3B36D@DEUP281.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f43c7b-fc61-483b-f19e-08dc5edefe87
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2024 13:05:02.5623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kb3ibXa+FQxJ0twU8NuaLsEcsIm0sAX3RrevL6MKfQuKv3sToKMR6Uu0eiYqo/CTekl+DNCQj1VdbubdQXTF8rFRXvk2baDhRgh8+f6wu+uZnMY2hlf2klTDTyBkd5QT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR6P281MB3582

T24gVHVlLCAyMDI0LTA0LTE2IGF0IDExOjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAxNiwgMjAyNCwgVGhvbWFzIFByZXNjaGVyIHdyb3RlOg0KPiA+
IE9uIFR1ZSwgMjAyNC0wNC0xNiBhdCAwODoxNyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3
cm90ZToNCj4gPiA+IE9uIFR1ZSwgQXByIDE2LCAyMDI0LCBUaG9tYXMgUHJlc2NoZXIgd3JvdGU6
DQo+ID4gPiA+IEhpIFNlYW4sDQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBUdWUsIDIwMjQtMDQtMTYg
YXQgMDc6MzUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiA+ID4gT24g
VHVlLCBBcHIgMTYsIDIwMjQsIEp1bGlhbiBTdGVja2xpbmEgd3JvdGU6DQo+ID4gPiA+ID4gPiBG
cm9tOiBUaG9tYXMgUHJlc2NoZXINCj4gPiA+ID4gPiA+IDx0aG9tYXMucHJlc2NoZXJAY3liZXJ1
cy10ZWNobm9sb2d5LmRlPg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUaGlzIGlzc3VlIG9j
Y3VycyB3aGVuIHRoZSBrZXJuZWwgaXMgaW50ZXJydXB0ZWQgYnkgYQ0KPiA+ID4gPiA+ID4gc2ln
bmFsIHdoaWxlDQo+ID4gPiA+ID4gPiBydW5uaW5nIGEgTDIgZ3Vlc3QuIElmIHRoZSBzaWduYWwg
aXMgbWVhbnQgdG8gYmUgZGVsaXZlcmVkDQo+ID4gPiA+ID4gPiB0byB0aGUgTDANCj4gPiA+ID4g
PiA+IFZNTSwgYW5kIEwwIHVwZGF0ZXMgQ1I0IGZvciBMMSwgaS5lLiB3aGVuIHRoZSBWTU0gc2V0
cw0KPiA+ID4gPiA+ID4gS1ZNX1NZTkNfWDg2X1NSRUdTIGluIGt2bV9ydW4tPmt2bV9kaXJ0eV9y
ZWdzLCB0aGUga2VybmVsDQo+ID4gPiA+ID4gPiBwcm9ncmFtcyBhbg0KPiA+ID4gPiA+ID4gaW5j
b3JyZWN0IHJlYWQgc2hhZG93IHZhbHVlIGZvciBMMidzIENSNC4NCj4gPiA+ID4gPiA+IA0KPiA+
ID4gPiA+ID4gVGhlIHJlc3VsdCBpcyB0aGF0IHRoZSBndWVzdCBjYW4gcmVhZCBhIHZhbHVlIGZv
ciBDUjQgd2hlcmUNCj4gPiA+ID4gPiA+IGJpdHMgZnJvbQ0KPiA+ID4gPiA+ID4gTDEgaGF2ZSBs
ZWFrZWQgaW50byBMMi4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBObywgdGhpcyBpcyBhIHVzZXJz
cGFjZSBidWcuwqAgSWYgTDIgaXMgYWN0aXZlIHdoZW4gdXNlcnNwYWNlDQo+ID4gPiA+ID4gc3R1
ZmZzDQo+ID4gPiA+ID4gcmVnaXN0ZXIgc3RhdGUsIHRoZW4gZnJvbSBLVk0ncyBwZXJzcGVjdGl2
ZSB0aGUgaW5jb21pbmcNCj4gPiA+ID4gPiB2YWx1ZSBpcyBMMidzDQo+ID4gPiA+ID4gdmFsdWUu
wqAgRS5nLsKgIGlmIHVzZXJzcGFjZSAqd2FudHMqIHRvIHVwZGF0ZSBMMiBDUjQgZm9yDQo+ID4g
PiA+ID4gd2hhdGV2ZXINCj4gPiA+ID4gPiByZWFzb24sIHRoaXMgcGF0Y2ggd291bGQgcmVzdWx0
IGluIEwyIGdldHRpbmcgYSBzdGFsZSB2YWx1ZSwNCj4gPiA+ID4gPiBpLmUuIHRoZQ0KPiA+ID4g
PiA+IHZhbHVlIG9mIENSNCBhdCB0aGUgdGltZSBvZiBWTS1FbnRlci4NCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiBBbmQgZXZlbiBpZiB1c2Vyc3BhY2Ugd2FudHMgdG8gY2hhbmdlIEwxLCB0aGlzIHBh
dGNoIGlzDQo+ID4gPiA+ID4gd3JvbmcsIGFzIEtWTQ0KPiA+ID4gPiA+IGlzIHdyaXRpbmcgdm1j
czAyLkdVRVNUX0NSNCwgaS5lLiBpcyBjbG9iYmVyaW5nIHRoZSBMMiBDUjQNCj4gPiA+ID4gPiB0
aGF0IHdhcw0KPiA+ID4gPiA+IHByb2dyYW1tZWQgYnkgTDEsICphbmQqIGlzIGRyb3BwaW5nIHRo
ZSBDUjQgdmFsdWUgdGhhdA0KPiA+ID4gPiA+IHVzZXJzcGFjZSB3YW50ZWQNCj4gPiA+ID4gPiB0
byBzdHVmZiBmb3IgTDEuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVG8gZml4IHRoaXMsIHlvdXIg
dXNlcnNwYWNlIG5lZWRzIHRvIGVpdGhlciB3YWl0IHVudGlsIEwyDQo+ID4gPiA+ID4gaXNuJ3Qg
YWN0aXZlLA0KPiA+ID4gPiA+IG9yIGZvcmNlIHRoZSB2Q1BVIG91dCBvZiBMMiAod2hpY2ggaXNu
J3QgZWFzeSwgYnV0IGl0J3MNCj4gPiA+ID4gPiBkb2FibGUgaWYNCj4gPiA+ID4gPiBhYnNvbHV0
ZWx5IG5lY2Vzc2FyeSkuDQo+ID4gPiA+IA0KPiA+ID4gPiBXaGF0IHlvdSBzYXkgbWFrZXMgc2Vu
c2UuIElzIHRoZXJlIGFueSB3YXkgZm9yDQo+ID4gPiA+IHVzZXJzcGFjZSB0byBkZXRlY3Qgd2hl
dGhlciBMMiBpcyBjdXJyZW50bHkgYWN0aXZlIGFmdGVyDQo+ID4gPiA+IHJldHVybmluZyBmcm9t
IEtWTV9SVU4/IEkgY291bGRuJ3QgZmluZCBhbnl0aGluZyBpbiB0aGUNCj4gPiA+ID4gb2ZmaWNp
YWwNCj4gPiA+ID4gZG9jdW1lbnRhdGlvbiBodHRwczovL2RvY3Mua2VybmVsLm9yZy92aXJ0L2t2
bS9hcGkuaHRtbA0KPiA+ID4gPiANCj4gPiA+ID4gQ2FuIHlvdSBwb2ludCBtZSBpbnRvIHRoZSBy
aWdodCBkaXJlY3Rpb24/DQo+ID4gPiANCj4gPiA+IEhtbSwgdGhlIG9ubHkgd2F5IHRvIHF1ZXJ5
IHRoYXQgaW5mb3JtYXRpb24gaXMgdmlhDQo+ID4gPiBLVk1fR0VUX05FU1RFRF9TVEFURSwNCj4g
PiA+IHdoaWNoIGlzIGEgYml0IHVuZm9ydHVuYXRlIGFzIHRoYXQgaXMgYSBmYWlybHkgImhlYXZ5
IiBpb2N0bCgpLg0KPiANCj4gSHVyIGR1ciwgSSBmb3Jnb3QgdGhhdCBLVk0gcHJvdmlkZXMgYSAi
Z3Vlc3RfbW9kZSIgc3RhdC7CoCBVc2Vyc3BhY2UNCj4gY2FuIGRvDQo+IEtWTV9HRVRfU1RBVFNf
RkQgb24gdGhlIHZDUFUgRkQgdG8gZ2V0IGEgZmlsZSBoYW5kbGUgdG8gdGhlIGJpbmFyeQ0KPiBz
dGF0cywgYW5kDQo+IHRoZW4geW91IHdvdWxkbid0IG5lZWQgdG8gY2FsbCBiYWNrIGludG8gS1ZN
IGp1c3QgdG8gcXVlcnkNCj4gZ3Vlc3RfbW9kZS4NCj4gDQo+IEFoLCBhbmQgSSBhbHNvIGZvcmdv
dCB0aGF0IHdlIGhhdmUga3ZtX3J1bi5mbGFncywgc28gYWRkaW5nDQo+IEtWTV9SVU5fWDg2X0dV
RVNUX01PREUNCj4gd291bGQgYWxzbyBiZSB0cml2aWFsIChJIGFsbW9zdCBzdWdnZXN0ZWQgaXQg
ZWFybGllciwgYnV0IGRpZG4ndCB3YW50DQo+IHRvIGFkZCBhDQo+IG5ldyBmaWVsZCB0byBrdm1f
cnVuIHdpdGhvdXQgYSB2ZXJ5IGdvb2QgcmVhc29uKS4NCg0KVGhhbmtzIGZvciB0aGUgcG9pbnRl
cnMuIFRoaXMgaXMgcmVhbGx5IGhlbHBmdWwuDQoNCkkgdHJpZWQgdGhlICJndWVzdF9tb2RlIiBz
dGF0IGFzIHlvdSBzdWdnZXN0ZWQgYW5kIGl0IHNvbHZlcyB0aGUNCmltbWVkaWF0ZSBpc3N1ZSB3
ZSBoYXZlIHdpdGggVmlydHVhbEJveC9LVk0uDQoNCldoYXQgSSBkb24ndCB1bmRlcnN0YW5kIGlz
IHRoYXQgd2UgZG8gbm90IGdldCB0aGUgZWZmZWN0aXZlIENSNCB2YWx1ZQ0Kb2YgdGhlIEwyIGd1
ZXN0IGluIGt2bV9ydW4ucy5yZWdzLnNyZWdzLmNyNC4gSW5zdGVhZCwgdXNlcmxhbmQgc2VlcyB0
aGUNCmNvbnRlbnRzIG9mIFZtY3M6OkdVRVNUX0NSNC7CoFNob3VsZG4ndCB0aGlzIGJlIHRoZSBj
b21iaW5hdGlvbiBvZg0KR1VFU1RfQ1I0LCBHVUVTVF9DUjRfTUFTSyBhbmQgQ1I0X1JFQURfU0hB
RE9XLCBpLmUuIHdoYXQgTDIgYWN0dWFsbHkNCnNlZXMgYXMgQ1I0IHZhbHVlPw0KDQpJZiB0aGlz
IGlzIGV4cGVjdGVkLCBjYW4geW91IHBsZWFzZSBleHBsYWluIHRoZSByZWFzb25pbmcgYmVoaW5k
IHRoaXMNCmludGVyZmFjZSBkZWNpc2lvbj8gRm9yIG1lLCBpdCBkb2VzIG5vdCBtYWtlIHNlbnNl
IHRoYXQgd3JpdGluZyBiYWNrDQp0aGUgc2FtZSB2YWx1ZSB3ZSByZWNlaXZlIGF0IGV4aXQgdGlt
ZSBjYXVzZXMgYSBjaGFuZ2UgaW4gd2hhdCBMMiBzZWVzDQpmb3IgQ1I0Lg0KDQpBbm90aGVyIHF1
ZXN0aW9uIGlzOiB3aGVuIHdlIHdhbnQgdG8gc2F2ZSB0aGUgVk0gc3RhdGUgZHVyaW5nIGENCnNh
dmV2bS9sb2Fkdm0gY3ljbGUsIHdlIGtpY2sgYWxsIHZDUFVzIHZpYSBhIHNpbmdhbCBhbmQgc2F2
ZSB0aGVpcg0Kc3RhdGUuIElmIGFueSB2Q1BVIHJ1bnMgaW4gTDIgYXQgdGhlIHRpbWUgb2YgdGhl
IGV4aXQsIHdlIHNvbWVob3cgbmVlZA0KdG8gbGV0IGl0IGNvbnRpbnVlIHRvIHJ1biB1bnRpbCB3
ZSBnZXQgYW4gZXhpdCB3aXRoIHRoZSBMMSBzdGF0ZS4gSXMNCnRoZXJlIGEgbWVjaGFuaXNtIHRv
IGhlbHAgdXMgaGVyZT8gDQoNCj4gDQo+ID4gSW5kZWVkLiBXaGF0IHN0aWxsIGRvZXMgbm90IG1h
a2Ugc2Vuc2UgdG8gbWUgaXMgdGhhdCB1c2Vyc3BhY2UNCj4gPiBzaG91bGQgYmUgYWJsZQ0KPiA+
IHRvIG1vZGlmeSB0aGUgTDIgc3RhdGUuIEZyb20gd2hhdCBJIGNhbiBzZWUsIGV2ZW4gaW4gdGhp
cyBzY2VuYXJpbywNCj4gPiBMMCBleGl0cw0KPiA+IHdpdGggdGhlIEwxIHN0YXRlLg0KPiANCj4g
Tm8sIEtWTSBleGl0cyB3aXRoIEwyLsKgIE9yIGF0IGxlYXN0LCBLVk0gaXMgc3VwcG9zZWQgdG8g
ZXhpdCB3aXRoIEwyDQo+IHN0YXRlLsKgIEV4aXRpbmcNCj4gd2l0aCBMMSBzdGF0ZSB3b3VsZCBh
Y3R1YWxseSBiZSBxdWl0ZSBkaWZmaWN1bHQsIGFzIEtWTSB3b3VsZCBuZWVkIHRvDQo+IG1hbnVh
bGx5DQo+IHN3aXRjaCB0byB2bWNzMDEsIHB1bGwgb3V0IHN0YXRlLCBhbmQgdGhlbiBzd2l0Y2gg
YmFjayB0byB2bWNzMDIuwqANCj4gQW5kIGZvciBHUFJzLA0KPiBLVk0gZG9lc24ndCBoYXZlIEwx
IHN0YXRlIGJlY2F1c2UgbW9zdCBHUFJzIGFyZSAidm9sYXRpbGUiLCBpLmUuIGFyZQ0KPiBjbG9i
YmVyZWQgYnkNCj4gVk0tRW50ZXIgYW5kIHRodXMgbmVlZCB0byBiZSBtYW51YWxseSBtYW5hZ2Vk
IGJ5IHRoZSBoeXBlcnZpc29yLg0KPiANCj4gSSBhc3N1bWUgeW91J3JlIHVzaW5nIGt2bV9ydW4u
a3ZtX3ZhbGlkX3JlZ3MgdG8gaW5zdHJ1Y3QgS1ZNIHRvIHNhdmUNCj4gdkNQVSBzdGF0ZQ0KPiB3
aGVuIGV4aXRpbmcgdG8gdXNlcnNwYWNlP8KgIFRoYXQgcGF0aCBncmFicyBzdGF0ZSBzdHJhaWdo
dCBmcm9tIHRoZQ0KPiB2Q1BVLCB3aXRob3V0DQo+IHJlZ2FyZCB0byBpc19ndWVzdF9tb2RlKCku
wqAgSWYgeW91J3JlIHNlZWluZyBMMSBzdGF0ZSwgdGhlbiB0aGVyZSdzDQo+IGxpa2VseSBhIGJ1
Zw0KPiBzb21ld2hlcmUsIGxpa2VseSBpbiB1c2Vyc3BhY2UgYWdhaW4uwqDCoCBXaGlsZSB2YWxp
ZF9yZWdzDQo+IGt2bV9ydW4ua3ZtX3ZhbGlkX3JlZ3MNCj4gbWlnaHQgbm90IGJlIGhlYXZpbHkg
dXNlZCwgdGhlIHVuZGVybHlpbmcgY29kZSBpcyB2ZXJ5IGhlYXZpbHkgdXNlZA0KPiBmb3IgZG9p
bmcNCj4gc2F2ZS9yZXN0b3JlIHdoaWxlIEwyIGlzIGFjdGl2ZSwgZS5nLiBmb3IgbGl2ZSBtaWdy
YXRpb24uDQo+IA0KPiA+IFNvIHdoYXQgeW91IGFyZSBzYXlpbmcgaXMgdGhhdCB1c2Vyc3BhY2Ug
c2hvdWxkIGJlIGFsbG93ZWQgdG8NCj4gPiBjaGFuZ2UgTDIgZXZlbg0KPiA+IGlmIGl0IHJlY2Vp
dmVzIHRoZSBhcmNoaXRlY3R1cmFsIHN0YXRlIGZyb20gTDE/DQo+IA0KPiBObywgc2VlIGFib3Zl
Lg0KPiANCj4gPiBXaGF0IHdvdWxkIGJlIHRoZSB1c2UtY2FzZSBmb3IgdGhpcyBzY2VuYXJpbz8N
Cj4gPiANCj4gPiBJZiB0aGUgYWJvdmUgaXMgdHJ1ZSwgSSB0aGluayB3ZSBzaG91bGQgZG9jdW1l
bnQgdGhpcyBleHBsaWNpdGx5DQo+ID4gYmVjYXVzZSBpdCdzIG5vdCBvYnZpb3VzLCBhdCBsZWFz
dCBub3QgZm9yIG1lIDspDQo+ID4gDQo+ID4gSG93IHdvdWxkIHlvdSBmZWVsIGlmIHdlIGV4dGVu
ZCBzdHJ1Y3Qga3ZtX3J1biB3aXRoIGENCj4gPiBuZXN0ZWRfZ3Vlc3RfYWN0aXZlIGZsYWc/IFRo
aXMgc2hvdWxkIGJlIGZhaXJseSBjaGVhcCBhbmQgd291bGQNCj4gPiBtYWtlDQo+ID4gdGhlIGlu
dGVncmF0aW9uIGludG8gVmlydHVhbEJveC9LVk0gbXVjaCBlYXNpZXIuIFdlIGNvdWxkIGFsc28g
b25seQ0KPiA+IHN5bmMgdGhpcyBmbGFnIGV4cGxpY2l0bHksIGUuZy4gd2l0aCBhIEtWTV9TWU5D
X1g4Nl9ORVNURURfR1VFU1Q/DQo+IA0KPiBIZWgsIHNlZSBhYm92ZSByZWdhcmRpbmcgS1ZNX1JV
Tl9YODZfR1VFU1RfTU9ERS4NCg0K

