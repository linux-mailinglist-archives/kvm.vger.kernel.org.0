Return-Path: <kvm+bounces-14766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38D6C8A6B85
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 901B3285787
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B0612BF25;
	Tue, 16 Apr 2024 12:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="nP+cjNvk"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2101.outbound.protection.outlook.com [40.107.135.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4DA12BEB8
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713272032; cv=fail; b=RfJV6o9/dZYaQVf5Eb7wfw7WBXnHKkEQSOJlvZJZj2n7NLnrgbbnLe4G6tyGN96V3iOjWYIkf9p3z8XJtUumX+Lyl5UHwzSzPmc/cI+B5jnCAeDvqeqfZHl5bNffhUxfOcV1GUG6d9iV/0pHfnJLYRvaX81E5O3QauKEimvfQrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713272032; c=relaxed/simple;
	bh=zffPdWCK37Ja5f7UzEIjszODiopldZz6H1j2aRPFYTc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QwLjmJMl6tL68cE7FYzj9RByUP1phhW0VZyzrCeRLSp1/LZNKvwd5v99W1OtNCD6cA0J5UfoCRwCWb94Bp7juYh5bf0rAs1HFilGdBlk1T85kIBtdCgnQ722N4TEw31w0EBKgK8a32hRI9vHdOWbYoboVWKwl0QziWuTwTqhsu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=nP+cjNvk; arc=fail smtp.client-ip=40.107.135.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UI429fPO8iR2N71wHJB5KskPNq6kSEQTzOwtbjor9r6zpj4nHrMcyVPJ0IkvaCgeX+Kv+cABDd3Mp/3srvTUWFzVLrD8XNXxiZdObCSWLMNVl0cbeV+YiJjwiR5r38xgA4x2SDUVSzRGBx+PAtGrkvoxzgK/G8NnPMeE1V8eOjWdrYRmK7E64R/V/T+U9Ssh8HWJhKWohI2Fh44kjBw5itxFQpZMydJlKXLAV/jXV0SWnu232HZFuqd7DYLPSsghvHHHNEi44GAP0yPAd+bl6HRkEhalF820COkPtf0GoQvBzlN+XWqHq64lshpjV9F41/o7AR4niGtEm5n9uNSvDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zffPdWCK37Ja5f7UzEIjszODiopldZz6H1j2aRPFYTc=;
 b=aeckzZFJv/uunBcafrWrXcyWlw2g0ZXB8X+NQpGnDiICpBlpiSpRSTWXBiiRTicMwKEAeD0/VaDScfwrc9UsneWrdo1OHMRn2P/tvcbzZdxN7wVqjZpd4/LsFjxocJtgglTY7VC5/oXyoKk+kB7fMRIP8BMESFFx0sjKh+wLd3b6UK44P6wsnAZ+0dm0uAtWNqKDMc0AMjy5QtW8Q0GlxeS4LEAAi6eDYBzJODp3Ju/xm4VY40MrXTwkjxma+mxuxCkUil+F8HQNCcVu6FPxauqdxCNEdnrfBvYH5miY8+L5+6dDd6aDM0NXqmmvRGvURSLuCBQnNpJX73YHZNy/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zffPdWCK37Ja5f7UzEIjszODiopldZz6H1j2aRPFYTc=;
 b=nP+cjNvk5fAHQGKSXRJuoLkOsUAMLE72z+E8mxetOM4Mh8lgfFux+VdAHRuX6jZuRt9jw3O95LlgqCEQ73N15Lub2iohX2p76qfXKExFAYvk7klePB8F2f2UZUM41jgZx4gES59LQ9KrIi39SMujrxrplNlAwGHH90mkvZ5wV+keAhKZHJY9UVSVUCEosTxlOMW+0MYHNdVmtlFkhQpY2n8oT2+kusa0bNtMKy2PZE4nQdwuGLOrA9qBickeuTMLSy9X11SV+Y8NfLD77+d7GEdeRQelkOiEDiMCUc1lN+UBLaAqJyOfhCMqqF5P4C3r7lCOgLvcDM4G9s4IwZaxUw==
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR0P281MB3275.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:56::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Tue, 16 Apr 2024 12:53:41 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 12:53:41 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Thomas Prescher
	<thomas.prescher@cyberus-technology.de>
Subject: Re: Timer Signals vs KVM
Thread-Topic: Timer Signals vs KVM
Thread-Index: AQHagE068r/MPqfdwUiSZ7JW+AmgHbFUBZKAgBbxZACAAAKlAA==
Date: Tue, 16 Apr 2024 12:53:41 +0000
Message-ID:
 <f52cfce69fc7d120dab3289ce11ce6b50274e8a3.camel@cyberus-technology.de>
References:
 <acb3fe5acbfe3e126fba5ce16b708e0ea1a9adc9.camel@cyberus-technology.de>
	 <Zgszp5wvxGtu2YHS@google.com>
	 <af2ede328efee9dc3761333bd47648ee6f752686.camel@cyberus-technology.de>
In-Reply-To:
 <af2ede328efee9dc3761333bd47648ee6f752686.camel@cyberus-technology.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR2P281MB2329:EE_|FR0P281MB3275:EE_
x-ms-office365-filtering-correlation-id: ae65b127-c2cb-4184-4469-08dc5e143e0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 =?utf-8?B?Vi9aK2xaZElZcjU1dHY4LzVHb01RQ3N5TGdXcDIza0pRazN0dUc3WlNYUXBW?=
 =?utf-8?B?UlJoTDNJUTZ2NkN5N1hFU2JkdjVWRUZ5YklGYmU3SVJvUXRXM202eVpjZDlG?=
 =?utf-8?B?alhlN1puSDR2NTYzSjFNNFJkU1NBWFlPOE1JTmV2Yy9PcHM4V1l5UWIxRS90?=
 =?utf-8?B?bjhsMk5ma2RvaExnSnNZUkZ3YXFwVGR5WkNEeDkzNWoxMkpiT25iaXdZUFFD?=
 =?utf-8?B?dzI3eXBYWENPTlgzMGFJMDh0L0F3VlpHekdETU5rUEtFM2h4Rjd6ZGE4MFpx?=
 =?utf-8?B?MUhXZXFuZFBXMHFONWdCSnRFa3pCem5JcTVlOFlzL09NZmtldmF1WjJPdnhu?=
 =?utf-8?B?UVIwSEt5MktmMHZjY0xCeGwrTE15VjNtcG9wV2lYejZiOGhYeDE4OGZTVDcy?=
 =?utf-8?B?V1FoaVpoMk9vWmNWOWxscFdPSUhYZEtEMEREdXRDcU83MitTbkZZaHN6ZDha?=
 =?utf-8?B?UW93MWdteFNMaTlNSEdqSHk4WElwUjlVRUNhaElncXptaldCQ0tweTdUWC9k?=
 =?utf-8?B?a2JJLzByVVlnYWgxS211cm1oQ25FVG9CekRKdHFFbGZIZGlNWDBzbDNLZVpw?=
 =?utf-8?B?SWZ3cUVKNU9xOCtoNEVlTndZUlZXdkZRZkdsZjVycTFPZWs0TmcrY1J1bDlv?=
 =?utf-8?B?NFFoT0hNczJQYXZqNnNjcGVnOEx6K0NTWFBCRW00dHpVTm1HTDliaDdvUERD?=
 =?utf-8?B?U3ppK3dzamNpaGxMS2N6K3JwN2RaSkxaUHNWVklReTBvYWk5anRDT2xVWVpX?=
 =?utf-8?B?RmFFWmN2ZUhaVHpaOGZwRCtLNHZrTWR1cWlaY3Y4czJ5aFNJZW0xRmNqQnlR?=
 =?utf-8?B?cmFqWWlaa0hWV1hiYVB1YlVqdkRpcXlEeG9SYnZpcnFpTXlQRnJ2MW0zdEta?=
 =?utf-8?B?alg5OU5HOWd6QmxSa29nQWMyOUl6a2Zsazd4Q1ljV3NOVmxkQ2JSaDV0QVE0?=
 =?utf-8?B?UVI5eTYrK3d2aStVR3A2Ny9UZEJyQ3UwRzNxQ2M1NE44UHRuQUlwRGlkMENW?=
 =?utf-8?B?cjUxNFdDWjlFQmwzdnYvRzhIMTRWWUZZTEdlMVpJakVFL3d2Um92d0phSFhz?=
 =?utf-8?B?K3dzamlSUzZqVGFWMkE0SlBBZHVybnRmS2RqN21kc1dJekptdUhKcFN5U3Fl?=
 =?utf-8?B?dUkrL3hjeEF6cm9YVC9QbU5VamYybTh5Yldxa2pmbG0wQTRuMHdxbS9Sc0xh?=
 =?utf-8?B?b29vWWgwUmh2OEJJS2U3SDY0V0wyd2N4M1hJVVZhbWhhU0UxeHJyTkJRVTVv?=
 =?utf-8?B?WE9wRXFFZGRmOU9oR3FVVlNHeDJGV3F2VW1hcmp4dDBFVTQ4c0VNMXpMUXdF?=
 =?utf-8?B?dFBRMG5WdGs5UTJyWnA0NDZWL0p3NnlTcEIxV1NFN01zVlBSTmVIRjhZRDBy?=
 =?utf-8?B?Q01UN0RTNXUyOWZ6UGVhV0d5MXZwdURnNHQ5NFVKaS9naExiUHJkNDYyM2pD?=
 =?utf-8?B?WnNUSUwyRXRqTXNWWWM3elViMlB0UlcweUVwb2xHZFJoYmIya1VCeXN2RkJD?=
 =?utf-8?B?dzRDVTNtQlpIY1o3ZkdaVFlnL3pLVmJLUmJGZkxibU1IMW85aEhHU1hQa1li?=
 =?utf-8?B?QjVPSWpyck05ZjEvOGZWQWdDSVBzWUJzOGkzdmx1d2NRUGJnb0lpMzBLUWVv?=
 =?utf-8?B?RURldWpCQjJaQ1dTMDZTY2RhelpEVy9vZnV3OTVoK0h6THJTZDQxZHVyb2NQ?=
 =?utf-8?B?enNac3lNTU95S0JyTS9QY2JEUUIrYjZSZkFBaGhVTVRadTZVVzZ5bUlnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cHdScThZSEJ6RmZTb3JSUlNOVGhQTkhhRTNaL3NEc0Z6ZFBBckFvVjV4YzEz?=
 =?utf-8?B?OVQ5SGxwQ0JpSi9CbmRPVGtYZWhnOFNac1dLd3ZlcGRFTVZlWmlWeTAyNi9y?=
 =?utf-8?B?ckk1dFQxclptcWFWWHN2MVhwVW5TSUtiVjNEYXFYOVp6MklzcmZOUXg0MGFq?=
 =?utf-8?B?L0ZJZnhJT0xUTWE1UEdJYytoTmxTeDV6T0NJei83Y0hrSHZjV3ZZYVcwVzJV?=
 =?utf-8?B?Y1RUWWpvWVhkTStNeEJ4VVl4bnN4dktxTEpFS21ndGdST0gwY0RZQSswN1pn?=
 =?utf-8?B?ODljQ1lyaGR4aXIybHlmc04xWE1uV0M0WXgra0lqUC8xWVBBNUFhRys5Vjhm?=
 =?utf-8?B?aW53V081WGl6NnZrMkY0ME5jWWxyNnY3WHhTcEI1T00zdlBPS3BXcEZRVWF0?=
 =?utf-8?B?dy9HVmNpbnlpMnVBUTVtYTd4Z1FHSFNqL0trTDBTc0dhemtNcy9aYWUzYmV2?=
 =?utf-8?B?UWwwUXh5OVZZWVo2L2MwOEUzNmJad3ZocGRmanN0anJiY3JQY1FhaTM2UzlV?=
 =?utf-8?B?Q0ZGSUhzSFpZR0UwMW82ZVVRKzJrdE1NQTdKTDYzeW9JTG9wNndRNmtOdkZF?=
 =?utf-8?B?VTNRQ3lrS3pyWEl1bnRpZllLeldEd1ZKaUJRQ0FQQmNGcGVtdTFuTlhiMlNL?=
 =?utf-8?B?dWxuUktjVW5tNWN2WDlKNldCOVdsbWN1S0VQNkszWjlWOHlVNVF0dGNCVGt2?=
 =?utf-8?B?ZlFtLzNBaWpHR01OMVNLUXI1U1M0bm5TRjAybmlVWm5SaDdoSUJacDl2N3p0?=
 =?utf-8?B?NUw5TzJnWUxPZTFSaGhTK0pGWXlqNzdZU3lBL0hMTWJZWnR0dnh4WDVwaVc0?=
 =?utf-8?B?V2pUbjVibWpjUjBMc1VzRUJ3UlM5OWJaZzIwYkF1L3prL1UzclpmcGNseUdH?=
 =?utf-8?B?MEJhenlROEtiMkY1emJWblRMK0RDL3ZCZEhUYkM3L0x5R05lV05XK3p0OXVR?=
 =?utf-8?B?cXh4Vmd3L2ptWlRzSUhXamV3cWIvMmFFNUUrTVJCYUprQWxZcDBuY3lwRVh0?=
 =?utf-8?B?ZTZIMlVEZDRlS0dZcjU4am9BY3h0Yzl4SWRkMjgzWlpsOS9Qc2VDY1E1NVA3?=
 =?utf-8?B?Q05TOTFPMTdzdmtubE5HZnBZNkJuREQ0Wk5NYmlSVW1RUDlYOVNNZ28wdmRs?=
 =?utf-8?B?YUt6MWljeUdRUEhNVXVYOUQ5WWxzNDY2R3hwQ2hpVFgrWEdSeEUzVEFIY2hG?=
 =?utf-8?B?ekM3NEpuUzNIWVdPOEZmQmd6RGNQZTZ2bHhiRHVWQnBpWkRzUHBBTENpdUlv?=
 =?utf-8?B?RnVueWhIOXFqY1BZSTZyTGhGV3pZcjd0VUdWTkV0KysrV1VzWW5DT1dPK3Vm?=
 =?utf-8?B?MWtIQ04xdDQxeFozVEFydVlnb2RhVmIxbmJNL3hpNlFzNGwrek9BTTRESHlE?=
 =?utf-8?B?aFVGVEpRWVdIMXJWL0Vmb09tYzNCUVoxaG1VZGxsVkhPZzQ0dFFSeVZMQnI4?=
 =?utf-8?B?SWhncVZtNWtnOUR6dkthcEx4MGxpNElkMDdQczdJMTdjU3BuQkZWRUJTbklx?=
 =?utf-8?B?cGs2bk02K3VzQ0hucW1vR21penJTWFpndWpwQS9GT0dNT3pjWnBWTUtybjE4?=
 =?utf-8?B?YkRGbEN6MWtteXoxMjY0MmU3V0tsN1lYTUpNWkJiR3E0SkhLdHg1cnVTcmdy?=
 =?utf-8?B?NCsxS0FCQjdPN0RDQXZBWStlNDBMVU9yQXFQVUtQZHFlN1JMNUhKLzBBSlFZ?=
 =?utf-8?B?VU1idFdlSnA5Sm43eEtlRG1LNEJoTm5LaTczNWQ4RGJqV0RIOENIcjhGRkUw?=
 =?utf-8?B?ZStSMUtyQkZkcWtmcjRWK0VUVDI5VHlqQWNQNUNyNWZ6emV0eTBWUlZKMGZK?=
 =?utf-8?B?QnJRVXE5QnEzTGt4c01GMG82VnNONHR4bDFDeTRGNzk2bGk2VVk5K0taa3Ur?=
 =?utf-8?B?cGkzRGliWmFNM0NhUkc5T2djaHJRWC9iaXdJd2xaUEJ3RlN4bnFLc0hNd1Ay?=
 =?utf-8?B?RmduY2VlMjg0R0U2WVpwL3BUbHdNaWlSS3dJMWJndmdRTUp5cDl3eTB0bDdO?=
 =?utf-8?B?Y3R0bEVOWEJaYXk0S013MElPTW9GQU9hNEZ1Q0p5Q21WMnlXQ1pUNFNGSUVZ?=
 =?utf-8?B?N3JsWHdIWVIxMFJiNjRTMmtXQk9Ib01ycWVzY0dHeFBDRmMrcGtVMTVsSExj?=
 =?utf-8?B?QjI4dEZCTGx2Mmd3Y08wNCtmejdvdnppdGNXUWhtQlBhL0pMWXE2cldkVjYx?=
 =?utf-8?Q?2kX/JmgUQJqFshtuLg+LbXpd6ybsAoOz72+hgAmtxLjT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BE5D41A71B74740891793F93A7A696D@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ae65b127-c2cb-4184-4469-08dc5e143e0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 12:53:41.3014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5iuvUZc+uJBTvrahbaHoL18Ev9y0Bw2KoGiqVL7FU2palMcNT22BeITDCHpSDAK+s4FfifDOA68msnLjAishObUOzSCduEkHJ3G+r4HBKOyMKI7EYicYyCbXXjqiEdJ3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB3275

T24gVHVlLCAyMDI0LTA0LTE2IGF0IDE0OjQ0ICswMjAwLCBKdWxpYW4gU3RlY2tsaW5hIHdyb3Rl
Og0KPiBPbiBNb24sIDIwMjQtMDQtMDEgYXQgMTU6MjIgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJz
b24gd3JvdGU6DQo+ID4gT24gV2VkLCBNYXIgMjcsIDIwMjQsIEp1bGlhbiBTdGVja2xpbmEgd3Jv
dGU6DQo+ID4gDQo+ID4gPiANCj4gPiA+IFdoZW4gd2UgZW5hYmxlIG5lc3RlZCB2aXJ0dWFsaXph
dGlvbiwgd2Ugc2VlIHdoYXQgbG9va3MgbGlrZSBjb3JydXB0aW9uIGluDQo+ID4gPiB0aGUNCj4g
PiA+IG5lc3RlZCBndWVzdC4gVGhlIGd1ZXN0IHRyaXBzIG92ZXIgZXhjZXB0aW9ucyB0aGF0IHNo
b3VsZG4ndCBiZSB0aGVyZS4gV2UNCj4gPiA+IGFyZQ0KPiA+ID4gY3VycmVudGx5IGRlYnVnZ2lu
ZyB0aGlzIHRvIGZpbmQgb3V0IGRldGFpbHMsIGJ1dCB0aGUgc2V0dXAgaXMgcHJldHR5DQo+ID4g
PiBwYWluZnVsDQo+ID4gPiBhbmQgaXQgd2lsbCB0YWtlIGEgYml0LiBJZiB3ZSBkaXNhYmxlIHRo
ZSB0aW1lciBzaWduYWxzLCB0aGlzIGlzc3VlIGdvZXMNCj4gPiA+IGF3YXkNCj4gPiA+IChhdCB0
aGUgY29zdCBvZiBicm9rZW4gVkJveCB0aW1lcnMgb2J2aW91c2x5Li4uKS7CoCBUaGlzIGlzIHdl
aXJkIGFuZCBoYXMNCj4gPiA+IGxlZnQgdXMNCj4gPiA+IHdvbmRlcmluZywgd2hldGhlciB0aGVy
ZSBtaWdodCBiZSBzb21ldGhpbmcgYnJva2VuIHdpdGggc2lnbmFscyBpbiB0aGlzDQo+ID4gPiBz
Y2VuYXJpbywgZXNwZWNpYWxseSBzaW5jZSBub25lIG9mIHRoZSBvdGhlciBWTU1zIHVzZXMgdGhp
cyBtZXRob2QuDQo+ID4gDQo+ID4gSXQncyBjZXJ0YWlubHkgcG9zc2libGUgdGhlcmUncyBhIGtl
cm5lbCBidWcsIGJ1dCBpdCdzIHByb2JhYmx5IG1vcmUgbGlrZWx5DQo+ID4gYQ0KPiA+IHByb2Js
ZW0gaW4geW91ciB1c2Vyc3BhY2UuwqAgUUVNVSAoYW5kIG90aGVycyBWTU1zKSBkbyB1c2Ugc2ln
bmFscyB0bw0KPiA+IGludGVycnVwdA0KPiA+IHZDUFVzLCBlLmcuIHRvIHRha2UgY29udHJvbCBm
b3IgbGl2ZSBtaWdyYXRpb24uwqAgVGhhdCdzIG9idmlvdXNseSBkaWZmZXJlbnQNCj4gPiB0aGFu
DQo+ID4gd2hhdCB5b3UncmUgZG9pbmcsIGFuZCB3aWxsIGhhdmUgb3JkZXJzIG9mIG1hZ25pdHVk
ZSBsb3dlciB2b2x1bWUgb2Ygc2lnbmFscw0KPiA+IGluDQo+ID4gbmVzdGVkIGd1ZXN0cywgYnV0
IHRoZSBlZmZlY3RpdmUgY292ZXJhZ2UgaXNuJ3QgInplcm8iLg0KPiANCj4gQWZ0ZXIgc29tZSB3
ZWVrcyBvZiBidWcgaHVudGluZywgbXkgY29sbGVhZ3VlIFRob21hcyBoYXMgZm91bmQgdGhlIGlz
c3VlIGFuZA0KPiB3ZQ0KPiBwb3N0ZWQgYSBwYXRjaDoNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2t2bS8yMDI0MDQxNjEyMzU1OC4yMTIwNDAtMS1qdWxpYW4uc3RlY2tsaW5hQGN5YmVy
dXMtdGVjaG5vbG9neS5kZS9ULyN0DQoNCkl0J3MgdGhpcyBwYXRjaCBzcGVjaWZpY2FsbHk6DQpo
dHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDA0MTYxMjM1NTguMjEyMDQwLTEtanVsaWFu
LnN0ZWNrbGluYUBjeWJlcnVzLXRlY2hub2xvZ3kuZGUvVC8jbTJlZWJkMmFiMzBhODY2MjJhZWEz
NzMyMTEyMTUwODUxYWMwNzY4ZmUNCg0KVGhhbmtzLA0KSnVsaWFuDQo=

