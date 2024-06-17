Return-Path: <kvm+bounces-19773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C5190AD43
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 13:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EA011C22DB3
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 11:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC9D194C64;
	Mon, 17 Jun 2024 11:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fX0Oq7yz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B1D18755A;
	Mon, 17 Jun 2024 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718624890; cv=fail; b=JGUsuPXgqXVbwfM3F4toa4/M6WR6N1vHtANTn+N9S24EqYKhWz4XKQxeE5tuSepnO5tCgrA0BzG2OKGpT3RRYnmqrlNoroqoprBcxRhpAWmRc/EWeoFZE+ImHVw8vFy3PYZ/FxvlNAnJwz/fsBHSsRKhUVVybH/FIHk+dF8Opsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718624890; c=relaxed/simple;
	bh=kZH9x1QcIVSULBx6b2ChKxxG/D7kmn8hLwNTaes1DMc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dKV1jzLqmz3yUSyhIC7HpRPD6bZ/BDkR0WN9Z9LEkyvl9ZyDUUiTgQOKLCNV9VmcYR5JRSXuaqekBZcP3UBkIsZnUuz/JuAdkHARY0Q3RPhNz78RgKh1uSa7vJGxMfZHgNaY5zHPNU3ACXBdYGYrF5h3wiLBUgjsqlN9Px5Qth4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fX0Oq7yz; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkjnC88Gn7AU0kHfCNpDavy6GzKtnf05viMHxBPafII8VlEncKV2/VxEIVOTDgI4YfdL9ROwn5+A04nZfCx/jtBxK4uObov+hI8gluu887OubRdARTLhAYgoh5P4Na2W7EVNd8jTOq0N4tDnIc0F4VspNyluXQjrcNrXD7thtc9CM0kZJs6ZP0rJVa0h5mOnG+iDGdGhwoO6vvcGsJv9EnNi3n65RFvac8UBrPSxEu25qabyipq52GZrIixR5/ETz93VMOkBqkFtzQ82XOKcKowQZMuG/aYxAMYS5cNrXbt04wym4gD268h48Vzc99Ltepn15os8YZ9AK8WxmGZjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZH9x1QcIVSULBx6b2ChKxxG/D7kmn8hLwNTaes1DMc=;
 b=IneG+euDCIj59Z+lvi4wto5dwp1psWaX+cJAbChZnJQEoJ3VVxQqcYTlDKSd9uIEB4mYTBxcTQ8AYXvPCCKHP3FWcCOfSlQIlJz2wroIvc4lQ4C/nsiIM2NdFOukYEo3IKU2gi7nENB3ZtAUZRQVPc5kuwYjWngknP82YQia//ud550dawBojY7YCi972a4J/rkNgBkiPE04xUHQMP8bIeKSB4/RNkOwaXlw28Sp7tu9D5hM2mWIg6YWj3r7FqOUm9TBx+8MfNhQssU3DvFR9/De6aqkRR5ws23S09oDy7yIP0I5soRpCStpkpEDIVUTUr1ZJxmZp2fBmdk88Kj3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZH9x1QcIVSULBx6b2ChKxxG/D7kmn8hLwNTaes1DMc=;
 b=fX0Oq7yzQsB1T3460U92PQFmigic2AMymTjFTk82gFe/x1ojJuRX9qR9jDb29r3A6FSShc7TVYKFvONbxb5Hb2XADQ4egrhkKXgHUk1kjy7cMmj5Z+giQiDylMUgl3/VAbhA8W/Zmm+G3NLw5Mho2xB6Twr7hcAQB52HWtv0pZYUXfVTdIwBu7cLKCsuC0joqrZLY7/DDkaxZGlxQGXXdqEAF/TS3XtyWuOQF+ybcTdnSWBsmQthqs58rd8smI9DVFQu9ZUY9Kip/U8GOvO0b/0m8OlAh868I06gjmvC+qjHQ5uAPxsN77JTTCJ8O+43uIRcNlvy59Rh1woR0ytX2w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CH3PR12MB8482.namprd12.prod.outlook.com (2603:10b6:610:15b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Mon, 17 Jun
 2024 11:48:02 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd%3]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 11:48:02 +0000
From: Parav Pandit <parav@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Cindy
 Lu <lulu@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>, "mst@redhat.com"
	<mst@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Thread-Topic: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Thread-Index:
 AQHau8E82Oi/Eu4kG0WR1z2wkwF2SbHDYHEAgABL6oCAB4z7gIAAEN/AgAByw4CAAABP0IAAIUaAgAAArTA=
Date: Mon, 17 Jun 2024 11:48:02 +0000
Message-ID:
 <PH0PR12MB548116966222E720D831AA4CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org> <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
 <CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
 <PH0PR12MB5481BAABF5C43F9500D2852CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ZnAETXPWG2BvyqSc@nanopsycho.orion>
 <PH0PR12MB5481F6F62D8E47FB6DFAD206DCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ZnAgefA1ge11bbFp@nanopsycho.orion>
In-Reply-To: <ZnAgefA1ge11bbFp@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CH3PR12MB8482:EE_
x-ms-office365-filtering-correlation-id: 3cb0d668-f27c-4516-ff67-08dc8ec3582c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?UTVWWjlxN3MxUnVQU09zc244anVLMDhwZ3BaU09hanVuZEJsK2tvdzJJQlN6?=
 =?utf-8?B?Q1lNN0RaSmV2MXhCdXJZb2p2YzlQblFBcFNuQkNvUkdOa3M3eDIrb04vaXh2?=
 =?utf-8?B?WVgzWDl3c3NCZ2NRUmNUajdNZWhRZWE4b2hEcDRSNlZkdnNjNmlTbmxXMUlp?=
 =?utf-8?B?Uk1wSEJybUlVQVh5eWFZdXgwTEZTN25ZZTA5UEZNK29wcTVFOGJSZGpsSkF1?=
 =?utf-8?B?Z0tGWkFacVgxZ1lUN0JpNEV0ZFJDem5KYU9sdDdCTmJSSjdFZXdrRW9VZm0v?=
 =?utf-8?B?YUVrSk5lc256Q3VJVzJERExMU0lqUk92QjliRE13VlpENkZOaThNK1ByNGNz?=
 =?utf-8?B?dW9GcFR3MjNTOUpMdzVId0ExZzhwSnJ5NGxkNklVV2VGNE8rV3NmREZZOFZq?=
 =?utf-8?B?ZUxjSVF4azM1S1NFNU5CR1NhTjZyQk1Xa0prR1JuWnBCVGZHbkdHK0k1Z1hQ?=
 =?utf-8?B?a2hPVzdldU9xb1Y0cktaYWFzQ2gzMTFCSjN0MnJZS2c0Ry9nQkYxRzlDY1dB?=
 =?utf-8?B?ZVA4OGF6T2E1aXRUWW1NdGVvNmo1UzJJazFWcFd1d0VZQ0h2Qmk3ZktFekZ6?=
 =?utf-8?B?MWN2QzNPeHV0cm5XTytyYS9uSy85SXg0TzA4YSs5ek1waUtvWnU4SS9zYzZP?=
 =?utf-8?B?MEU3Wk9WQUtId3dnT2dCYkZXbkI0Q2JsR2g0L2xRUFduLzdueW1adEkvZkpv?=
 =?utf-8?B?YmRPNEdzanE3YU5BMWxadEV6OG5nVCtmU05LRGo0NGplV1lZZHFWRlBOTnNo?=
 =?utf-8?B?QnMrU0YzSS9kRDhoV0xtdDdHaDdqUGVER1hISlFjOW1PVEJIT0g0SWJuK01V?=
 =?utf-8?B?TWhmQ1pBc1pFSEY3R3FhS0tzK2FJNlFrM1RaRlBtNWxkS2V0NzFJblkxc3pq?=
 =?utf-8?B?TWNZWm9FU2pBY0lhNW1MU0Y1LzFjZnpVbnU5Sm9vZ3ZDdlFpZDRTR080c2I2?=
 =?utf-8?B?VUNpVkwvNHIxWUlwUlZPd2xHcDdVUzZKcGNOM1hSU2Z6cnpocndjd252TzVT?=
 =?utf-8?B?MzEzaTBGOENUK0Fvdnc4VVF1aVJJT2cyWEhidCt0TXNBaUpqSVl4TFNyd2JZ?=
 =?utf-8?B?OFFhYnd1d0hQMDMvcEd5Y25CWG1ES2VtYjFkYXlodkFKN0N4RnBnYSt6UEZ1?=
 =?utf-8?B?UUM3dmRDZVdvcXVtUlBadlRtQW9BZ1R2bzdYK01Pd2YxL0JPd3JQdFRlby9O?=
 =?utf-8?B?T0laTjR1a1VnekJ5RVg5cUtkaFFWMGMwcit2RkpzK3ZGVE1ray9iVEFHdDRH?=
 =?utf-8?B?K0hHK3J1dXR0bWhtWmNEZVZCVExuRG5abll0dW1wZCtRYjNDRmdtSWpEUTFk?=
 =?utf-8?B?RGpxRlp0MllQa0Q1NElaNFh5YWVVa1dnZzB2bzFrZFg0YSsxOVYrUFNFWnpR?=
 =?utf-8?B?d3BkcHlqTlZNWG5ZSGYwMUlNNDlOYlN2bE5jOS9vRlJIclllUmtDa0U0bnZT?=
 =?utf-8?B?anp2Q2lLSkxZNSsraWFXOE9uS0xCQ0V1U3NRa3dZK3F0UjY5czlOQXZ5ZUsr?=
 =?utf-8?B?ekUySk9TY0k4NFhIZDRMRWNaR3NTSEhrL0tHQ24vVUFmOTNCZkJHS0ZIYnhu?=
 =?utf-8?B?RXNaUVlVbFJmTDZkYmMxaFZvYy9oRkxJcEUzcWZOWmNqZlpScVBrall6UUFy?=
 =?utf-8?B?Zy9kMUFmcTVUM0Y5RTRmY24yV2U4ZDJYS1Fzcy9iZGZ1MDlVUVpXd0NraDBZ?=
 =?utf-8?B?eVNoY3kxRVFrM0d3V3NXOGJqQyt0eERGYzY2VTJBRjl4LzJMdGNaelk1azRr?=
 =?utf-8?B?YjY0OWtrazNGanloWTdVTGEvVHBSd1Z0SWpjb2FuYVlGMm0velZkdllOWGQz?=
 =?utf-8?Q?8+rZuBXRDTDRFgGoA3KWX8NkWrm3LJ4hghT+Y=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SmNTcUoyMWh3SGRjdXJrMEN3NUZNZzczcHdta3ZJVXlQRkNlZDJuYitoZk4w?=
 =?utf-8?B?emUrM2Y1ZHN6M1dGTnRDbzlIdnVKb3ZxQVNOTTAxSU5yNFNnbGVGam5vQWp2?=
 =?utf-8?B?bmNnTlhPaHNUenhUM3pzYWtQVG5BNXV3eHJsODdCM0x2dEZteWxac2o0a1h6?=
 =?utf-8?B?YkVwbVBJbjU5WnhrbjRMYlVrWXZadFBpbGlTOHNOekx6TVE4VDJWMHBaUFhL?=
 =?utf-8?B?NmRFRzJGU0tXYSsyc1VvYnpNclRDdmg3d2ttRDBPTXZnMXduVXNiemNkUFN6?=
 =?utf-8?B?L0lMRzlFK1ZmV3kyUUtDdzZnU2NqNzFIbWxLQ29EQlF4Zm1PcVNhVWV4cGpl?=
 =?utf-8?B?dks3alRQanNWMDQzTWZKdTJMMmJVNlI4YnQ3TTBLcWgrclZHb0lncVRQeGU1?=
 =?utf-8?B?QVZidFp3WnBnbi9rTkpRc29tZ2crcnlEUlFqL2dEbGg1ZUVvZnlvR1ZIOW5H?=
 =?utf-8?B?SzZJZkJWZjVHekt1cWZRUTdkb3RRTzgwL1k5USsrQUsyVkRHZDg2eWdCeEtw?=
 =?utf-8?B?cVhxL3FVU1RTMWFaNGpNMUVYMGl3bFhjTzFDTlhlZjVVTUZsRkN1UnZxNnJT?=
 =?utf-8?B?KzVsSHpsd0habk5qbiszenBQY01DN2hRKzdCY2Q4ZTJiamlxRkYvRjc0TEZQ?=
 =?utf-8?B?bVBzNndkY1lQOWpuSTB4ekFLMmpIeVhISXNnL2JPTS9YYUhEK3MrYkg4QTEx?=
 =?utf-8?B?VVBLQkpnbkR5TGZPa2kxUEVRYWJBNlJRUEt6QzR2amJNblZEditkNHd4cmVT?=
 =?utf-8?B?YUJ1cTQ2WGVkLzMrUzEwNVpHQllCYXA1SVNHSmhNWVg4SUVxL2ZEUGVPTkls?=
 =?utf-8?B?Vkl3OWd1TGUvaGRmcWZqS25iczU2ZktOZXo0NjNhUzM3VFg4TGlvdTJKZjcr?=
 =?utf-8?B?WkwxYjdPcW13Qnh0M1pPaVJFY2J0ZUtETEJVNnhmSjgyc1BnSjdOUlhQOFdE?=
 =?utf-8?B?VUZyS3hOMGZlOUlzY0hoQjNKYjl4ejA0NEJBdktVbDB6TkVJa0pBUDdIdktj?=
 =?utf-8?B?RkxzU2M1aWZxUURPaGNBY2FHQkluenBMamRVcmRGQUI2amgvejJhZXFTbTQ2?=
 =?utf-8?B?blhHUTZmNG9RSE5NMS9Ray84cHY4VXhLN25kYStLbGVLQmlyay9WZE1VQjFt?=
 =?utf-8?B?WnlZb0JubUpQUUpJUjM1WHF0dWZ1Q2JTcXlZYng5NWlmK25LbHdjeG1RdHkx?=
 =?utf-8?B?cCsrbC9KSEY2WHRkcGdJK3I1dWhWVHl6L2R5SFZ6bU5LOVR4dmtVTWVnOGdY?=
 =?utf-8?B?aXNrcDdTQU4xNS9vNlduZEJVSk1QWUQwNWh2NllNSm5iTnAvSEd5TDZ5MmpV?=
 =?utf-8?B?TUFlK1NRT2swYWtJV0RDRWw0Vy9rN1IvV0ZyLzdrSjVOWlhmNTVNaFFLaEYw?=
 =?utf-8?B?dEQxdklBT0NFcW1CMnFwZmNoY1hZVzM5bGlvTlpvWU9vN2NGQnhLK1hEMHlT?=
 =?utf-8?B?NmZiUkRTclNDMll5L0hxUno1azlaOGNNRUtad21FcktsOFpwdjlJQ1orVkZu?=
 =?utf-8?B?d1pIbDhLUVdzTjNBMEhmRFJ3VU1rOG5KeXlGbVlUdGhOcVNURlRSMGwva0pV?=
 =?utf-8?B?MnlUeHpFNldsRnhYUnBTalZ3UzVubDRFUTFGTE0yVk9naWJOTm9RODEvSlZX?=
 =?utf-8?B?Ujlua2p0Z0MvSVZjd0N0bWZEU0xRa09NM2ZEK0hrZWlEaTNsTnhmV3plQzZH?=
 =?utf-8?B?Uk5wLzE3ZFJnNWE3YjJJZlVqMnJCV2xHTWY4Zld6bVFzenhVLzQzVkFVZzQx?=
 =?utf-8?B?MThHZTZQV3lKU3czWjJod20vRkJFL0RDeDVEb2JIM2hrd1ZmNGprUUpEdEpT?=
 =?utf-8?B?L3dVdk1EWFFSTnMwaVVaRmFlejR4dmNReDNkZ25BNHZkak1UUzVmNkNxWDE3?=
 =?utf-8?B?eHhZYVFwYmJHaDFMUXVJdnpVUnpPekJKSVJZRDdWRlVLTExROHEyak9iSEU2?=
 =?utf-8?B?R3hDeFBCSm0zVW9nTzBpcWdTOXF5K0FoVFQxaGhiNE1yOE1DTG5wejA4TTdR?=
 =?utf-8?B?aUxFUFZpNXd2SURvakdXRFZjSjBNOFFUdU81RU9ac2drR1pxOVYzSmVodzhX?=
 =?utf-8?B?bTNqd3hVdHZ3SjJXdGdpS1hEeVVmS3dtNnZhK3hJT3FwVlg2TEgzVWFTTTJG?=
 =?utf-8?Q?4r3s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb0d668-f27c-4516-ff67-08dc8ec3582c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 11:48:02.8455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L974MrVjXH4QUgNVtCG2NYar/ErFz4dUMSMiRyOd6Rl6STbV8mkX8W4iaHtlZbFCobVZq0NtdmCMYysrBdJBYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8482

DQo+IEZyb206IEppcmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+DQo+IFNlbnQ6IE1vbmRheSwg
SnVuZSAxNywgMjAyNCA1OjEwIFBNDQo+IA0KPiBNb24sIEp1biAxNywgMjAyNCBhdCAxMTo0NDo1
M0FNIENFU1QsIHBhcmF2QG52aWRpYS5jb20gd3JvdGU6DQo+ID4NCj4gPj4gRnJvbTogSmlyaSBQ
aXJrbyA8amlyaUByZXNudWxsaS51cz4NCj4gPj4gU2VudDogTW9uZGF5LCBKdW5lIDE3LCAyMDI0
IDM6MDkgUE0NCj4gPj4NCj4gPj4gTW9uLCBKdW4gMTcsIDIwMjQgYXQgMDQ6NTc6MjNBTSBDRVNU
LCBwYXJhdkBudmlkaWEuY29tIHdyb3RlOg0KPiA+PiA+DQo+ID4+ID4NCj4gPj4gPj4gRnJvbTog
SmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gPj4gPj4gU2VudDogTW9uZGF5LCBK
dW5lIDE3LCAyMDI0IDc6MTggQU0NCj4gPj4gPj4NCj4gPj4gPj4gT24gV2VkLCBKdW4gMTIsIDIw
MjQgYXQgMjozMOKAr1BNIEppcmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+IHdyb3RlOg0KPiA+
PiA+PiA+DQo+ID4+ID4+ID4gV2VkLCBKdW4gMTIsIDIwMjQgYXQgMDM6NTg6MTBBTSBDRVNULCBr
dWJhQGtlcm5lbC5vcmcgd3JvdGU6DQo+ID4+ID4+ID4gPk9uIFR1ZSwgMTEgSnVuIDIwMjQgMTM6
MzI6MzIgKzA4MDAgQ2luZHkgTHUgd3JvdGU6DQo+ID4+ID4+ID4gPj4gQWRkIG5ldyBVQVBJIHRv
IHN1cHBvcnQgdGhlIG1hYyBhZGRyZXNzIGZyb20gdmRwYSB0b29sDQo+ID4+ID4+ID4gPj4gRnVu
Y3Rpb24NCj4gPj4gPj4gPiA+PiB2ZHBhX25sX2NtZF9kZXZfY29uZmlnX3NldF9kb2l0KCkgd2ls
bCBnZXQgdGhlIE1BQyBhZGRyZXNzDQo+ID4+ID4+ID4gPj4gZnJvbSB0aGUgdmRwYSB0b29sIGFu
ZCB0aGVuIHNldCBpdCB0byB0aGUgZGV2aWNlLg0KPiA+PiA+PiA+ID4+DQo+ID4+ID4+ID4gPj4g
VGhlIHVzYWdlIGlzOiB2ZHBhIGRldiBzZXQgbmFtZSB2ZHBhX25hbWUgbWFjDQo+ID4+ID4+ID4g
Pj4gKio6Kio6Kio6Kio6Kio6KioNCj4gPj4gPj4gPiA+DQo+ID4+ID4+ID4gPldoeSBkb24ndCB5
b3UgdXNlIGRldmxpbms/DQo+ID4+ID4+ID4NCj4gPj4gPj4gPiBGYWlyIHF1ZXN0aW9uLiBXaHkg
ZG9lcyB2ZHBhLXNwZWNpZmljIHVhcGkgZXZlbiBleGlzdD8gVG8gaGF2ZQ0KPiA+PiA+PiA+IGRy
aXZlci1zcGVjaWZpYyB1YXBpIERvZXMgbm90IG1ha2UgYW55IHNlbnNlIHRvIG1lIDovDQo+ID4+
ID4+DQo+ID4+ID4+IEl0IGNhbWUgd2l0aCBkZXZsaW5rIGZpcnN0IGFjdHVhbGx5LCBidXQgc3dp
dGNoZWQgdG8gYSBkZWRpY2F0ZWQgdUFQSS4NCj4gPj4gPj4NCj4gPj4gPj4gUGFyYXYoY2NlZCkg
bWF5IGV4cGxhaW4gbW9yZSBoZXJlLg0KPiA+PiA+Pg0KPiA+PiA+RGV2bGluayBjb25maWd1cmVz
IGZ1bmN0aW9uIGxldmVsIG1hYyB0aGF0IGFwcGxpZXMgdG8gYWxsIHByb3RvY29sDQo+ID4+ID5k
ZXZpY2VzDQo+ID4+ICh2ZHBhLCByZG1hLCBuZXRkZXYpIGV0Yy4NCj4gPj4gPkFkZGl0aW9uYWxs
eSwgdmRwYSBkZXZpY2UgbGV2ZWwgbWFjIGNhbiBiZSBkaWZmZXJlbnQgKGFuIGFkZGl0aW9uYWwN
Cj4gPj4gPm9uZSkgdG8NCj4gPj4gYXBwbHkgdG8gb25seSB2ZHBhIHRyYWZmaWMuDQo+ID4+ID5I
ZW5jZSBkZWRpY2F0ZWQgdUFQSSB3YXMgYWRkZWQuDQo+ID4+DQo+ID4+IFRoZXJlIGlzIDE6MSBy
ZWxhdGlvbiBiZXR3ZWVuIHZkcGEgaW5zdGFuY2UgYW5kIGRldmxpbmsgcG9ydCwgaXNuJ3QgaXQ/
DQo+ID4+IFRoZW4gd2UgaGF2ZToNCj4gPj4gICAgICAgIGRldmxpbmsgcG9ydCBmdW5jdGlvbiBz
ZXQgREVWL1BPUlRfSU5ERVggaHdfYWRkciBBRERSDQo+ID4+DQo+ID5BYm92ZSBjb21tYW5kIGlz
IHByaXZpbGVnZSBjb21tYW5kIGRvbmUgYnkgdGhlIGh5cGVydmlzb3Igb24gdGhlIHBvcnQNCj4g
ZnVuY3Rpb24uDQo+ID5WcGRhIGxldmVsIHNldHRpbmcgdGhlIG1hYyBpcyBzaW1pbGFyIHRvIGEg
ZnVuY3Rpb24gb3duZXIgZHJpdmVyIHNldHRpbmcgdGhlDQo+IG1hYyBvbiB0aGUgc2VsZiBuZXRk
ZXYgKGV2ZW4gdGhvdWdoIGRldmxpbmsgc2lkZSBoYXMgY29uZmlndXJlZCBzb21lIG1hYyBmb3IN
Cj4gaXQpLg0KPiA+Rm9yIGV4YW1wbGUsDQo+ID4kIGlwIGxpbmsgc2V0IGRldiB3bGFuMSBhZGRy
ZXNzIDAwOjExOjIyOjMzOjQ0OjU1DQo+IA0KPiBIbW0sIHVuZGVyIHdoYXQgc2NlcmF0aW8gZXhh
Y2x5IHRoaXMgaXMgbmVlZGVkPw0KVGhlIGFkbWluaXN0cmF0b3Igb24gdGhlIGhvc3QgY3JlYXRp
bmcgYSB2ZHBhIGRldmljZSBmb3IgdGhlIFZNIHdhbnRzIHRvIGNvbmZpZ3VyZSB0aGUgbWFjIGFk
ZHJlc3MgZm9yIHRoZSBWTS4NClRoaXMgYWRtaW5pc3RyYXRvciBtYXkgbm90IGhhdmUgdGhlIGFj
Y2VzcyB0byB0aGUgZGV2bGluayBwb3J0IGZ1bmN0aW9uLg0KT3IgaGUgbWF5IGp1c3QgcHJlZmVy
IGEgZGlmZmVyZW50IE1BQyAodGhlb3JldGljYWwgY2FzZSkuDQoNCj4gSSBtZWFuLCB0aGUgVk0g
dGhhdCBoYXMgVkRQQSBkZXZpY2UgY2FuIGFjdHVhbGx5IGRvIHRoYXQgdG9vLiANClZNIGNhbm5v
dCBkby4gVmlydGlvIHNwZWMgZG8gbm90IGFsbG93IG1vZGlmeWluZyB0aGUgbWFjIGFkZHJlc3Mu
DQoNCj4gVGhhdCBpcyB0aGUgYWN0dWFsIGZ1bmN0aW9uIG93bmVyLg0KdmRwYSBpcyBub3QgbWFw
cGluZyBhIHdob2xlIFZGIHRvIHRoZSBWTS4NCkl0IGlzIGdldHRpbmcgc29tZSBzeW50aGV0aWMg
UENJIGRldmljZSBjb21wb3NlZCB1c2luZyBzZXZlcmFsIHNvZnR3YXJlIChrZXJuZWwpIGFuZCB1
c2VyIHNwYWNlIGxheWVycy4NCnNvIFZNIGlzIG5vdCB0aGUgZnVuY3Rpb24gb3duZXIuDQo=

