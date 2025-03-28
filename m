Return-Path: <kvm+bounces-42214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7FEA7529F
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 23:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AEFC1894A24
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 22:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1861F4178;
	Fri, 28 Mar 2025 22:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="nUgxnuEw"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazolkn19012057.outbound.protection.outlook.com [52.103.2.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDEA1E0DFE
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 22:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.2.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743202721; cv=fail; b=PtnSsC7pJW/AGFOwrxPmzHZUGq3u+NPCaSQhO8orD1pdS7Qt2z2k8WNIHg+/yy3xjC5ym8QR8/NUZdVHhUAJQdnKi6C5ouK0V5atj0HOjz4iRKN+PaU2uZ+2dFJkdc9xVDAIF/jVEGWjsHLanUQhHUxzCI0FpbWVqenYOOsThXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743202721; c=relaxed/simple;
	bh=pIcovkEdpYOIgnUKlMQiZnc5vb1IhlR/bJ6SF/GRVc4=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NkRN5eEmVf7JUMlnDn4O3UJC4dK2doqKckN7wStXweGanroRRKcxVXB7w/8vtQYk385JDV0ASSnEz29WINEsXWRoyquoEhLWTO4EVPPA2GDtFPKu/ZtOR1oJssFWhd23nCSKBMFLZsq2NZN5vb5yWo7QnRcCMWbuGvxzE90s5c8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=nUgxnuEw; arc=fail smtp.client-ip=52.103.2.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N/eMqu5B4B18/BTyhCKxnYlzrPse+O9AedsH7N4LBYvwGyzbjGe/lIIpD1CeoY8T9v58A/wWckXpB2Pk+/dJeAvIqRVhLjECjCNl5lxdbTzGZOcdEppPnQu04qMQ1p+GAZCFlvNEs2dyWT3MlqCCD7AeQ+8koe0PmrFSXXAW4xnCVoKSkU/uU/OgQE3Ysw2aPFG2vB/vYt07SfW0W3UraFBsqqNTZrWVE7skqZMTy/K7P5BL4XZW5WKI/rP5F6PnP1B7Lg66E6hHOrOhQfxmLcrJYPchVoaLIxt1EN4Mrg6ppREiZDNFYwNUhCLZ66UKCiOwRnzH8tXCV+4vTG6rfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIcovkEdpYOIgnUKlMQiZnc5vb1IhlR/bJ6SF/GRVc4=;
 b=fznR1hOpl36D5rzuUUh8ZkADKILENZAI8Mn/cKzEJSce0Wh+r5KovwSTw6SDv+kUqKr2QMw1+GROEJ44uWbfdQ0Dt6SnkMsVWG0pzdRxEqdjqJi+D2uLDvuoIDn+V1ITIG8KBxm6KsZCx17FEpWhj3h7bFLLGAtQSWfNVBps9bNmA5S8AEWS5Om9DyW9Q+o1us9994Eyc0hr1RnG2J+twbM4/wo1hj3n37ZELv15jX1FlgitI9E+SiZhs09hg7SDxF6j5UsiqDhQPj+cdNG1uixI8TFT6g37uQ0PlF70HuihhR51UCxmCD/vIOwQDZjjjwhRu7uzc5JejqdIv+99Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIcovkEdpYOIgnUKlMQiZnc5vb1IhlR/bJ6SF/GRVc4=;
 b=nUgxnuEwDd2SLiF6aaMPa8PHO04xIPzhFvxj8vF4BixUThJwi4Jay7sU4JTXD/jdozNKiPfxdLAZyzMg5Y2HaTwoDksAM4X2GmcRBT33LckH20VXwYy5oKnWLryfzzyHX7z/4nj2mGQAY4AK8DPJ92AsrB7Mwv1E366XyDVSBKYBwf118D/7tks2iIYlwnLiFaXZaFArib6ot/ebnW0YWn5UUaS00uURfKbiRniwZCzCnb5E/hqX9Kvlh+WN+iIKVzPxNwWAlj0qfw5wLh6oGEXndVJNSYy5Y1B1wYFZn3e9yfKQIqOcll6s7/l0kKzLAsYbw3UlI5tt5Mxv2DR51A==
Received: from SA0PR04MB7324.namprd04.prod.outlook.com (2603:10b6:806:ed::6)
 by CH2PR04MB6539.namprd04.prod.outlook.com (2603:10b6:610:6e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Fri, 28 Mar
 2025 22:58:37 +0000
Received: from SA0PR04MB7324.namprd04.prod.outlook.com
 ([fe80::f7d3:b390:e9c0:2b9a]) by SA0PR04MB7324.namprd04.prod.outlook.com
 ([fe80::f7d3:b390:e9c0:2b9a%4]) with mapi id 15.20.8534.048; Fri, 28 Mar 2025
 22:58:37 +0000
From: Isabella Young <Isabella.protechinsights@outlook.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: ISC West 2025 Attendee Database for Strengthening Your Business
 Outreach
Thread-Topic: ISC West 2025 Attendee Database for Strengthening Your Business
 Outreach
Thread-Index: Aduf69MBxn6kqTANSNmjc+2MoP2wHg==
Disposition-Notification-To: Isabella Young
	<Isabella.protechinsights@outlook.com>
Date: Fri, 28 Mar 2025 22:58:37 +0000
Message-ID:
 <SA0PR04MB732420B0F67E77769AD7D6C28DA02@SA0PR04MB7324.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR04MB7324:EE_|CH2PR04MB6539:EE_
x-ms-office365-filtering-correlation-id: bb212004-1552-4438-8181-08dd6e4c1348
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799006|461199028|8060799006|8062599003|19110799003|440099028|3412199025|102099032|41001999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?vjsdlsTAhy3zy0bjOkYutkh0JOVMd27gzcdujC+svwXMXQjywqsS0syk3e?=
 =?iso-8859-1?Q?666JrUcvoc8rQQfF2zsaqsDE0QanewJtExa0m7voz7M9ZxMHUYrwEFTVBt?=
 =?iso-8859-1?Q?LqIqD6w1KXm8YYe6MSocECdqowJHbjsktB/cocG9HuqEczOQkxbcrcz+BY?=
 =?iso-8859-1?Q?wnSijnPf8OSrUqdp0PP+peTXcS30rQKnZAQsZ7AV+gt5vs4MFR6bCXmUOx?=
 =?iso-8859-1?Q?+dI3n7X1kiBOJsQ9mwY0cUjFb9lgwxbtZPVS4TB3VpGhStXlDkx6Q1bYXV?=
 =?iso-8859-1?Q?2MoFTdQmrJGWMlUAnTgaE1YkCGyHFvEebDLY+jHIvIVDWBoNB3oBY/37CO?=
 =?iso-8859-1?Q?iWtpcntkAAe9+amc7FkKYf5Zn7s7CHyzJmJyapyIHhy4b0Ox2BA92rmMqV?=
 =?iso-8859-1?Q?MNcHenYMydjzkGw+55S7EaQN5KaBiF5/dM1bgr/Gf5irmmUuCIWG69uDvj?=
 =?iso-8859-1?Q?AdS0lPacmupaZf85sE0/Rg5Kdhxkl4E+UxLHFNxGftt4hTG0LPFgcqKygh?=
 =?iso-8859-1?Q?BD+lRL6CqNCf+neY9H1aOIxKsPu5jQHmk3AcwOBcBuD+pfr4E7MnmXV+D9?=
 =?iso-8859-1?Q?ppNbhaZMV7Dd+eMEROfgy4kgXAuqVEwau8tj4NRi886aNAGLIKpYAjcZar?=
 =?iso-8859-1?Q?ZmHGk0G5fyAjZ429E+SUGOkx2BybWDJNsUxKIDQTa1egjEozS8eBQziZE2?=
 =?iso-8859-1?Q?AEKzI5z4g+FoChMWKUN8R0XXWrhQ/MFogcf2hQT4CmL24aDBShnJR8MZ+V?=
 =?iso-8859-1?Q?XgJ60P9vS6y8HVSwxuLDnDjbAy985kdSmFioONp+mpkr1noYb7EI5fLOkw?=
 =?iso-8859-1?Q?HjHd0j2k8SHUtuWnG3zxR/jgIjYZaNcCXLkWKge3e6fSjdpe9ICAH3rXbk?=
 =?iso-8859-1?Q?me4FY+toHtHVszWH9X79ZYexvyiBqChVJIXb6rsomlbJ/DPq43LKhN/f8n?=
 =?iso-8859-1?Q?JJojIckWuokzij2Ri5/No3N9oUfuum5K1S60sKIfd3RKv0xDHAb5Gjyk1V?=
 =?iso-8859-1?Q?CCpYcUehR8+kOKtMRy8RCh6SjXtkJCXbCcDHH9u1LgtMGiiu1yZ3jJLMMt?=
 =?iso-8859-1?Q?Q71CcA4wEjpBSjDGIpFL/GQNe57H22ppZsaUbFo/JUb4orcFnRvujJnGHt?=
 =?iso-8859-1?Q?5lplbp2VqyEfDP4fF/Ci2h+WMRy14=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+OfccU9OwvWShZfXQWG4TSgqABLidq22sr25yi+Wtln7QAM02cwjQ6zP9R?=
 =?iso-8859-1?Q?q/0cqJzBcZjEYLpzhK2dGsmHo/v7pCrtsszSRpZVHd0E9HWYcxHevyvCwJ?=
 =?iso-8859-1?Q?I+fDkBioqXPB0F8UWQ3k8xNp91PcdUaeek4lMx29b+/oGZYkFVa7B5gO4n?=
 =?iso-8859-1?Q?hVTKzSbeZIdpr9wZrBbF4mqbmZ6GQOzbHV+IDTyFFOMouqAYLR9ClJ39RW?=
 =?iso-8859-1?Q?RwufxQX1UH8q/F9+OWGVgdtLcMMCjQy4u9JNU7GAXAkKeSoePUshcufilR?=
 =?iso-8859-1?Q?RpZ77RKQpvEJnmVMKr5hv6zxyV9YIKApei+n8RH3n4wxsU+MucFFUI+feP?=
 =?iso-8859-1?Q?5ZMPKymEBHg87/W/r58g0kw8bIyYcN0hGPIUWOp0SDCTZCiopllRtpDMaV?=
 =?iso-8859-1?Q?CFcCjB+OlX4hHEhIsn/j5LNDPDeN8I0i8kJ8Bc6A4buebLf/f7+ggeXBWL?=
 =?iso-8859-1?Q?fTOoW1fUa787nEitHQqimyafHfiTpt9QOEtp1d12w8JIS583niSw1Lb3nr?=
 =?iso-8859-1?Q?VDneCajNti+Dn/S1sfUFIYVk59S7GJK9twaTZbIOTFK+LrbFQwMumB8CGp?=
 =?iso-8859-1?Q?nWESkISfG45JIlku/J/7MqIfb5whWgZhRk6I2CRiKbbHC7R8D4+3oC1D3V?=
 =?iso-8859-1?Q?V+jhm5QuIL8j8755mVHFsbDoyHwYChF2J0ySE6u3STa7V9W3ky8bcjHp5Q?=
 =?iso-8859-1?Q?ARw9Eg2bXoeFg7v3HMXo21P7gN5TT7X472bFR9PK/uLS10olSrTpp1uC2V?=
 =?iso-8859-1?Q?dB+lnrbE9ukGT2mrqrNLsbDYzFaSxdkCDpE++zPjvD6i1qNXo0/lzBMrNq?=
 =?iso-8859-1?Q?FxdSGpKVP1bL9fuHgXmUJamax2ql3jRnmZObNl9piahTC3MnTi1US8cuEE?=
 =?iso-8859-1?Q?O/a5XvRm70nHPn/MUHGNRYN/y05mMj9XzFu4L+AKhrwJWB5qMI7jphlwTY?=
 =?iso-8859-1?Q?Tajbb04dY4q4FwKD75d2x1BpCvmAEC69yCRCP3pt5AF6jXjANBsxyHYf5F?=
 =?iso-8859-1?Q?dVTMs3+JFRYXn14zxDngTl+TWX9WVnmLD3kvupJGRzP39VK83w04pHveBn?=
 =?iso-8859-1?Q?PLqW67JX1q8afC/nFPfaxSQEeoE7wSz/+Q2Wjy6vqRZlWk2WuCp92usz/w?=
 =?iso-8859-1?Q?1rlshbZfR6Fd645YtvouFIB10U2P3vncd6sw08sQg+KwV9W97usUr8eDY1?=
 =?iso-8859-1?Q?q2mJZILlW/Lggi3RKmAHXDuZhCSkfg4cQe0kIdYHlCMKbzNWf+bRN0nXYx?=
 =?iso-8859-1?Q?LL2MVwAJqIMzUBpWPoRRfs2PdPpJxEK9KUD8EdjZS9FxQzJtOpHkJWmI/o?=
 =?iso-8859-1?Q?tm72UIvBUoCzCOR/AkBhzkltz9RCjIejSDxJ1FoCbftvLTnRpXSyCdnPUt?=
 =?iso-8859-1?Q?Vc4gKb63+p+91S/Cg+Gs8i+gYkd59Www=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7324.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: bb212004-1552-4438-8181-08dd6e4c1348
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 22:58:37.5990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6539

Hi ,
=A0
Are you considering securing the attendee list for ICS West 2025?
=A0
Expo Name: =A0International Security Conference & Exposition West 2025
Total Number of records: 23,000 records=20
List includes: Company Name, Contact Name, Job Title, Mailing Address, Phon=
e, Emails, etc.
=A0
Are you considering buying these leads? Let me know, and I'll send the pric=
ing.
=A0
Awaiting your feedback
=A0
Regards
Isabella
Marketing Manager
Pro Tech Insights.,
=A0
Please reply with REMOVE if you don't wish to receive further emails

