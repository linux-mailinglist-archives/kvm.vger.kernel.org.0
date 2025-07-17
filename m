Return-Path: <kvm+bounces-52813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1754B0980B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE16B3B5077
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 23:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79EFE24BBEB;
	Thu, 17 Jul 2025 23:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="XVBdZ/be"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04olkn2098.outbound.protection.outlook.com [40.92.45.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12CA248871
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 23:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.45.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752794965; cv=fail; b=EBZ3xyCvG2VbaNdPQ7umrLrCjbkklyTmhkRyOi2T1cRrh+Dr7VDyZ6g+/xgO9CsPPGoG2RC2Lpw1AFgVQpZqP8B3lnTpeC8aQxz0vEYaZwrs6hsf1PGlaNYu8V822elPrC9XIjpjfYFFN3035NQxJmgBbeP7EnjwhJchtB0Thdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752794965; c=relaxed/simple;
	bh=kiRJqVH++4CLZ5aja6R2Z4b2IiWNV7lbCIhWwxPtiVY=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NnAG1UFgGxt1pbGcpGhtufH1vDR6go7GiZEkRAzdi0RzhOHcdbpdCaNtFeR19cJkV4HJW6nAmry6/F1yDIHflKpFaagzXBq0iHcpu+Dyj0IpZ2Sc01ZHWac+ocQDMdygDcEzKv346kmHfp6E8bIo+cSsl8QQDDCrZEgUnzATFY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=XVBdZ/be; arc=fail smtp.client-ip=40.92.45.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcC/zrbvFQjPW4NdaLwaqLhpCbNvY/aUtyGS1Yxe/NgNwXW+mCp9mx/zYEKQcacu5jaf4MC4EQMkEFY/GybQ1a7kigo5FLXnPqGcGBg9D97A9mQvxfL48RyBUexuwmSUgMTsdRt0NjiEwiVbgXWS+U2MyxOfwDRpSz2+MsfYEAyoFTMNP1MsBMpf+e10HP7fC3dP2SOirGdlopnbwnoRUWATrXyA8hzfPyNwTbtIZMGMhJ9Qt0i9o8wFYeSiDNNVvauCHBmIKIxyZI+IxftKpqz71ymHqp8zdTQJO3w3cefVeMt5p4An4QhDjiTNMVemnTx2a+p8Kr3uum0DEBwOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiRJqVH++4CLZ5aja6R2Z4b2IiWNV7lbCIhWwxPtiVY=;
 b=bpksgOthbM6UccCfI1l+yTogR0CxUT3sqgxs+ovD/iuvFOQdaznsyfkI4QLfZMrB7LXDfE0/mPUKnT3eL9ZOQ+VCJL1jVp6g/eTvCDYeli7Pq65UfdbwpWqEr07X/yz9yVcOuLTbg9PQn5P/vd0RD3mN2cz8TyzrvPXMrZ2rVGphO0/IqWNQkat9lLiQdRDjh+zYGDy+9NWMOpvTw0Z9q1GeZ0smNURLm3uoclxao9dWwWTbsMqKxyg99NxDQFzAvXcWrAhT8iN1jFYzienjY32Om+cJXhtXwxFMxzG1bqPiaqQnzdHRPn7S6cNEHsdmE0fBRk+PG0heAl1XIxRq/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiRJqVH++4CLZ5aja6R2Z4b2IiWNV7lbCIhWwxPtiVY=;
 b=XVBdZ/beU/OSZvo7OR/7tE5HS97ZqdKEgY31yoIUdxWB3hFhn7EwcWImrTHtsJfkGTeHKkG7l2r58iTxRVINn9ePYm7N4Plup++TIGaOIrO3pJqLqayGHAbGcpbd85UfQjttwF0l/Ezvrn4QhncEkUjEOmgTh8YkwWDDONOsWrFhZSAflp5wPJgJt2NHXiqSEjiBtLQ2ykOz5vJcFSja6Anwipfzfco9tpRptJi4dJp43Z479BDmuNcXHGTMtu1XlA+tFPfUazkJDfsDWIMdvFFIK7SIELg22behZd+dft6bK0OBr2QzThc0Ut+yqfQgib9c081HTcRQeUrHZ5vSzg==
Received: from CY4PR03MB3335.namprd03.prod.outlook.com (2603:10b6:910:56::14)
 by BN5PR03MB8042.namprd03.prod.outlook.com (2603:10b6:408:2aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 17 Jul
 2025 23:29:21 +0000
Received: from CY4PR03MB3335.namprd03.prod.outlook.com
 ([fe80::e8c6:bfb:511d:77d8]) by CY4PR03MB3335.namprd03.prod.outlook.com
 ([fe80::e8c6:bfb:511d:77d8%7]) with mapi id 15.20.8943.024; Thu, 17 Jul 2025
 23:29:21 +0000
From: Jessica Garcia <jessica.campaigndataleads@outlook.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Engage your market with GSX 2025 contact list
Thread-Topic: Engage your market with GSX 2025 contact list
Thread-Index: Adv3TZQu266CoboZQBqwH2Ujs40TKA==
Disposition-Notification-To: Jessica Garcia
	<jessica.campaigndataleads@outlook.com>
Date: Thu, 17 Jul 2025 23:29:21 +0000
Message-ID:
 <CY4PR03MB3335498F0A4F74D3D2A4F35EE751A@CY4PR03MB3335.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR03MB3335:EE_|BN5PR03MB8042:EE_
x-ms-office365-filtering-correlation-id: 905cf16b-57b9-4905-521b-08ddc589c22b
x-ms-exchange-slblob-mailprops:
 Vs63Iqe4sQkhtW6IUZ6WgDqnLPTu9NQEzZTEuYoKQX2QHS1lz+lJ3r0ETzbJJwkIIYenBUI3dM+c1iH48A3mcNJ4wWi0mfVFODPYNHJ0jteUFGRQxEnUrvo6gBmYGz1IMKS7C41HeFK9XZ8atHDKTDqMBDuV4F3aadpVvPLjDQnwA8fKK4zrJCtYjBal3HbQkKjtkyxSyJMUh+ZWxejLzcdKHTshRcqw40vz5tkr+xe0ai9lNknvk1XdYFJViKByw2srHw19dp7H/L9bAmygz7wredBC6qITjO4rkeH10RbYnBKlx3dVwvCRV+6/neWPzx2PCj8ri/3hD2pv09mwSnp6X6QJbf6Oycy+1eUF4/TPDm/mJZhVOuKnEfi0WTTonXKAbxFQc8E6/HoQZrD306Zc6OgwWPthShrXYqpD1k3g1p5IOqmlUFukYLNoAEz1K6BucMTHoJcgaF4QBlAtmtOomUPAmdxJ7zkZlopYcd16u4ZtyX30AdVuFhULZgyBCtAlaMGdQJULZ/99245eVFpE/RBaQCPP6mySkQC/hmSRMLNw6XK25vy6nGq759cdi84nKYkPFxmumA3J330ABemZw8/s07I8n7VSTV7Z3StCc788LNskJ5HWR01rktsDb7hm1lu5g18Aqj5LLk6Ef2pIUIdPGUo0X8pPnCbO7NKURM0mdTsg2GrsU++wWKuJyNzsuBb1co0SxlGmYPf/XLXNZzj1k5ADgDzeCHBvYQo=
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|15080799012|13031999003|41001999006|40105399003|39105399003|440099028|51005399003|3412199025|19111999003|102099032;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?Cq0PpRHQFA8ls7ZdmgzmTjt78wMhIUmwvNw5adL1uNkCOJAg19GUUG+8zm?=
 =?iso-8859-1?Q?ZnzVQ9CNsFk21NBIuYalyqwIEq6XFOOHHd8c4LWo+8r+0H+sDVVndeBYWw?=
 =?iso-8859-1?Q?e/91nA3YInweUJfOvEpnIMiY6ytpRc8LKBj1fN3f4VyXAn3P4opUVQLl9y?=
 =?iso-8859-1?Q?0N0arPsdDtRucpOTBTXfVt5Ox6O7ORNBskYulvUmPeOvNCezg+Bs/BOqsG?=
 =?iso-8859-1?Q?SySNVQmx/bi1o8t4hsBs3XQjlaEmYnft5O91LAoPZTf7bzWyZj5tdo7wMd?=
 =?iso-8859-1?Q?qwzviUt9bSM5BpEgqNUgB0sJBvo5AVxmMZkWmHxTijczN2avxCyhbv+Qwn?=
 =?iso-8859-1?Q?mic2EkI3sKLh6HD43FUHTEarn2/js3JV+mMV8vPKAJQaGMQEYWGBr4CJwL?=
 =?iso-8859-1?Q?7End8h3CLr9WZhDiYg4M/67ehdGzczq0lZ7jD4NFGIxoxkXwumMApI9v5q?=
 =?iso-8859-1?Q?pZAPHuGGkPljrFRzIr7sCh4mbhUkpCq4jY7Pz4y8z+w0//8AxKGueaN8go?=
 =?iso-8859-1?Q?RJ2EAAbH1h4heD1Uule9mqVohw/NQ88O3PfMF26S2LZDSdJAQYaVVoYEyt?=
 =?iso-8859-1?Q?JMh+IA4IQFVVinyuEIa1TtNxeB/4WylzINSRzUK2Cst3ZHfZz1jEnmnn0X?=
 =?iso-8859-1?Q?OLGDqVjSdO0xi51cYKEcXnTHsbfr/9HdNI9zP7wpzb3p1G8MVx2bj/k/7n?=
 =?iso-8859-1?Q?YH0HkPp6SlWAnKhLLqVhtRg11zI1u9b3y+beCaVh8dSb0AQCxHQqZTATDw?=
 =?iso-8859-1?Q?LaEKJsPZPZVsAMljCMv81X2S5P2AaykD8eWr64E6AA9MWc6vQu8CdUJxGz?=
 =?iso-8859-1?Q?mReY09QlSpMok9IoCXDpf6bEQ5N+QgM3Lqy8oqoRnnJK/6PjkE+N/1rNih?=
 =?iso-8859-1?Q?SXaFUqjGoLtx9674BA5QXaqenyE8qBCLFiuG/elWZAD2/vMchfr6Q7aiFa?=
 =?iso-8859-1?Q?w9j2b+DwMjNJlL0Yc2Hn9IRTFlvr0gi5DS2wAj9ZIGZcvEN+HmQg1yksgf?=
 =?iso-8859-1?Q?Dy9bgNczqFsNEVBYndnTUun0mfAG6Z3DMcM1Y2UeOXP2QzFVsDjMeSVyBH?=
 =?iso-8859-1?Q?wSKMaKOCnLM0dEx0e3kxcwgJ+b+0TWK4xEjDz2Oy+anFftaR0MZ3C/cXE+?=
 =?iso-8859-1?Q?VJ6SnZ6h7jiC4W9scysGfIpUwqxNe7hTLJ2LcvAtBxS9dlbIrks4QjIZRP?=
 =?iso-8859-1?Q?OnE8RW81jrGaMNY2+3XbuLHdeuw7GcdPVb9P19vs8Ry0yQJIwvRWqwsM?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?vZPfFVNZwhVtoDCix8ZImEsdptrwN6xajuN93kzARQGidKq1zwKeA2OC2C?=
 =?iso-8859-1?Q?9ZxHBoqQPBffXabx/MTo3XwSAsV2ESYv8Cx+z98Mf4/a0+4qpzsmBfXhXw?=
 =?iso-8859-1?Q?9DZNOs4tiX54lcYCjBXeMP59Br2+DI8bKJPaTwDrxLJKVQ4ap1cz/MV9i+?=
 =?iso-8859-1?Q?nYEnPgWhpI+ymPaSzAFhPw1P3ERZPXjWAt0ylgTucbf93ry13fkIs8NsC+?=
 =?iso-8859-1?Q?AXiwo7k94KFzAD9+dhaIwZ2ORnkhgsRyYNHLK185Jh1tsdLMJYkjFZrMXq?=
 =?iso-8859-1?Q?Y1gIMlNCDrVXvjDXY1UAPPVPWeP2n8qyu5/67+ZYfY8J9lBej73uvpAn3j?=
 =?iso-8859-1?Q?fYJ9BbwMC+nAwfBjUygTxGrVFAXoxpQYd80Lg6ACdsjiFsGzhQp4E1o6Y2?=
 =?iso-8859-1?Q?PKlP7eacHwGtVJ6FLX0izKdauJa9UKv8GopodQMecL4kSFdCnfWqrjoSIh?=
 =?iso-8859-1?Q?ODDGQBRp1p5yhLaLd8A6ZQA3kQGGj6CiVnEAkTA1LZL3e3M5rzOh7RnqUJ?=
 =?iso-8859-1?Q?5vAOlN/MsRv/Em7qjxShEoIi+W4xXx4OmZOSzU0rRUp+w6eAnkugbUL/Cl?=
 =?iso-8859-1?Q?eHlln/FkUVXEuSoj3DnF70lHThAqRTjmcT+jXDxS9tMjME1+uLiCP4OOR0?=
 =?iso-8859-1?Q?BQAkOkoXCUicbcTvFOrkLVwRNVAyfU4ntIcq5JRt2NkUglXYAyIhqEKS7Z?=
 =?iso-8859-1?Q?0PJWrhbuIa/bWof0SVAU8CbDSTC/0uRmHN5DazQPozfyC96PE7gGKIx0EE?=
 =?iso-8859-1?Q?7APz/tK7rkNhC7PkpKbT1h/XsZTVtrdjG+irbitVvOgTOpJSy+4CN083zU?=
 =?iso-8859-1?Q?p7114jAxXxP2vWVjXINLcq5HwdFW5ZBLLPFj/dVzkP6HyJK6uDWAcEp/uq?=
 =?iso-8859-1?Q?70ur5IfdGgmDZ/zbs9rxBZOfjwf7kXabraRfGUbg44gwK90+Vx3FaX5yEe?=
 =?iso-8859-1?Q?L0VhVqPVsFYKn/kdL87HgCUZFft4mshRRSjldcmEcPWpAQCa3BUPXz2m6D?=
 =?iso-8859-1?Q?yGXx5apElh94SdfkOF+dMt6F6dBOlW6ITOWh8HcyTP939Qp6/A3TXcyz+P?=
 =?iso-8859-1?Q?+q7tObzGs49uxR6UZe7s0MHs2r3e5u3MZ8pMia3/ryPPpfP83tRJAhRfL0?=
 =?iso-8859-1?Q?I66CZn2wW1A0F4X8ycm9YoLcteRY0VqCp80Upw3Gw0m3DJyQPdBUEqtmo0?=
 =?iso-8859-1?Q?09yD6RVWi++YdJKAxTiX3L8cFmrxzTOnUZAZyhRkGXQtgR1peDoFmEEp8O?=
 =?iso-8859-1?Q?YR8jwjbroB5tB6by+uvtfmASo2QmzFcFFJ2UzxQukOHef7fren858ZM8LL?=
 =?iso-8859-1?Q?CZElU6A0TWCj+vQ589pokK9P95eT7cX/HKOb7MKehdWZlNaTbaKrfu+PKg?=
 =?iso-8859-1?Q?1PGlY1Gwo0n/tc40I+vEp/NLoIlvgQ/Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: CY4PR03MB3335.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 905cf16b-57b9-4905-521b-08ddc589c22b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 23:29:21.5051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR03MB8042

Hi ,=20
=A0
Do you need the GSX 2025 attendees list?=20
=A0
Expo Name: =A0Global Security Exchange (GSX) 2025=20
Total Number of records: 17,000 records=20
List includes: Company Name, Contact Name, Job Title, Mailing Address, Phon=
e, Emails, etc.=20
=A0
Would you like to move forward with purchasing these leads? Let me know, an=
d I'll share the pricing.=20
=A0
Can't wait to hear from you=20
=A0
Regards
Jessica
Marketing Manager
Campaign Data Leads.,
=A0
Please reply with REMOVE if you don't wish to receive further emails

