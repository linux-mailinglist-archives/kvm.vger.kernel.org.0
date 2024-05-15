Return-Path: <kvm+bounces-17427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 316FC8C657B
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 13:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 805F0B2127A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 11:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09606EB53;
	Wed, 15 May 2024 11:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="jXM+7vmp"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2115.outbound.protection.outlook.com [40.107.135.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B284557CA1;
	Wed, 15 May 2024 11:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715772180; cv=fail; b=oypF7Wq/efJg4KV2TfF431nV5rsM7To3Ribkgj+KUbusRMiw0y1GBGuzHaZwJ3TJpDYjppNPDWuL3rWQ+28Der7t6mcwhJN8SN/09sbyoQXc156WsHUSyh24Rww5TxWFulMUTP//lGkBiOoM+2rswyXpsJEXpjoU3i6/jDCl7Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715772180; c=relaxed/simple;
	bh=wAh7swIbdRos8TsJVTUts5Ef1hOF1+b+2OmRtu4g3D8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=phoUV1eQta40e1Ab+sYDEnjpU7edVAS280ykIdkjQuqYB+D5koSxMjfB3ZMLkblveZb9fcMXzwEXrL4hE+JpfDiuDD58dOFYVXutpvEy+wuf4kFVC67jMYuitRKAf2gJbGYt6lhSevviMpkVAPrBtIP9HXhlw7XgGyD3IQXl7Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=jXM+7vmp; arc=fail smtp.client-ip=40.107.135.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vrw67G8Dty7cDuMakx9TWzFJq4Caro/oxRjiInR2/RuNQ8I3x/aiMFnBzMDtgtZfC/LnAsflSTv/AQK5zWwzczrjHro+TAAcPzknuoOVyc/GMorSwMPu4WQ3KrTtJmgb+AfRWe2/tPWe4pZ7rw4PPZj/9UI7oE8zWWE+t1Y6fM/QAEgOf/TdSakOivmSjz4VDWf7ucG3IY3ThlfQsJenyiDkNqZP9d0OB8gxfKk1oSwbj1UIFfnRUTcRfyGlKrR5LtOliFZHwW4Vn2BZsJwez/FjLjAetaOng87Pf5PiQ3Eoak3kmmS474PS6bDPcu5RP0gt3Bd2sQ/XzBAlJm9dZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAh7swIbdRos8TsJVTUts5Ef1hOF1+b+2OmRtu4g3D8=;
 b=GwRCcn0Ho7biaQPDNmU6WGlDPClZOXZk0XpE2n0t7bpUxW6oNoKSftY/VrBNP0Q8PsRLkp9xQL604Vl/lvG2XoqG8RQPiQu7S6K73Vu2/Vh08I0aXs+fCh+2Zxioa8aZ3CQUB7X1d1RroOT6uIpW1byeWD/BXJHuc0YJsuIA4J+IQpFIklVtMdyS8NEZba7cK1gHOj3ow+WnSJAxypa3/ThArzmxJ/hxQaedzmXH2ZKxt1UwHEm2T7yI+Rvj3jJBDKXVAYK7tRIDyqkFhCeiL2px4qhZALRQA5Xc96+iqpPiTxzElumky5ZbNhk5WFOboTr+oOhFRGr87lpiisPjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAh7swIbdRos8TsJVTUts5Ef1hOF1+b+2OmRtu4g3D8=;
 b=jXM+7vmpg3VWFv4cig50uHo6gVGhUwZ2iWovQawQwYFxdLXfYr7cVScV5ZaScjKAnPOkB/4SJG1Tpf+AE85RRaqiCz0kIeIgTKPiTwrBLglB7wKbZcR/Klc5VND0nmhuVOIFekRN7+XL1f3Rc2VnsDj1Q7qFvvw5OELR4fABtWqZPsHH+vrFzzPylpz1GIzQ+fuBeXR9sVFb4Q4MBLqclYI3k+XCII4MVFlcqHyO2MB2tpS/cDRhhavSG3fp5VdmuhF1W9UdRS9IKv4gJ0sR3A7aVUorMGuDpqfvQ5pVUmk4/rYzOogwgGKfWwMxD3/UjqWOE7pROz9uu13cZ3Zlmw==
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 BEUP281MB3577.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.27; Wed, 15 May 2024 11:22:52 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423%5]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 11:22:52 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: "seanjc@google.com" <seanjc@google.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Thomas Prescher
	<thomas.prescher@cyberus-technology.de>, "mingo@redhat.com"
	<mingo@redhat.com>
Subject: Re: [PATCH] KVM: x86: add KVM_RUN_X86_GUEST_MODE kvm_run flag
Thread-Topic: [PATCH] KVM: x86: add KVM_RUN_X86_GUEST_MODE kvm_run flag
Thread-Index: AQHaoUswDl+XNTW8/EaYqu1sERH8urGYMduA
Date: Wed, 15 May 2024 11:22:52 +0000
Message-ID:
 <5547dd176122865e6a13b61829aa9c4b6cc21ff3.camel@cyberus-technology.de>
References: <20240508132502.184428-1-julian.stecklina@cyberus-technology.de>
In-Reply-To: <20240508132502.184428-1-julian.stecklina@cyberus-technology.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR2P281MB2329:EE_|BEUP281MB3577:EE_
x-ms-office365-filtering-correlation-id: ba0d7d33-ec8f-4375-9907-08dc74d15c21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|366007|7416005|1800799015|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?Wmd6TTNhQWxWWGtOV1RwbmdmR2NnWjkrUkZhU2g2WlhMY1RFd2MyRitFUGNN?=
 =?utf-8?B?N2VqVUZZSTdQa3ZGQThTelc2akpNL3htL2FJeEFMcithTHMyQjl4SitiN1FE?=
 =?utf-8?B?ZEpPdXlNNWlKS0I5TGxXalVleDFDSFpoRUtkcTNOd2RHQXQxMTZQRWRueHRG?=
 =?utf-8?B?OVJYdXlXcVdUT004dUVsQTZ6VFN4bmw0WGF5VDN3ajJwNnFJWU8yNWliUGdu?=
 =?utf-8?B?cE90OWlWWFpiT2lCZ0hSMWI0S0NOaU1HbGNuYi9HUWc1NVRCVzR4cWw2SS9M?=
 =?utf-8?B?b1pEbldWNTRlTm4wZU5pNUt2c04zZDVBbE1UWWN3QjdyM2N0cTRScjhMN3FH?=
 =?utf-8?B?NW1pWUVVMUNRYTMzUWtTR2xRWHRLd0p1ZWJkUitUdzR2elAxWUNTMjhQdGdZ?=
 =?utf-8?B?eFhZTFFscGt4Z0dJcFkwempYTnQxVXlTdERta0lYMzRoODNqNkJwaGtDWG5w?=
 =?utf-8?B?bVVuUHI5d0w1cnR4eUVjb3dQWGZFcGh0MnRUbXJvYitoT1RjTXp4QlJlSk8r?=
 =?utf-8?B?dXZ4OWp3azJ2b2RBbng2ZTNqdkZqY0RMdDNoc0dvY0lwQjArWTl6YUROWFo1?=
 =?utf-8?B?MHp6TTk0OTJYSW9IcTI1cXZsdGg0djR3L2daVHBieTBtcUY0VmkwcEN5YkJl?=
 =?utf-8?B?aWZ3elM5R2I4TFN4Wm0zMWRoeThQTkJEbHFRSmdJR0xjZWJyY3Mxc3RGbWZQ?=
 =?utf-8?B?cWpENGNNa0ZkUTFDSCttK09va2pXZXBTVHB0NE5nM3ZSU0hVRHVjRjdmWVNH?=
 =?utf-8?B?a0NMRDdIRlYyQVhTeTlyMzZNK3hOSElvQ09uUzdTYUZEUm5XZFRDTWlqRzdh?=
 =?utf-8?B?NU9PbUFtRWZ0TktpcndXMm9CZ09DcFZwSUxvNksxYStZNFFRNU1qTVZ6OTRP?=
 =?utf-8?B?elRIUGoyVmxCNGZxQUZrME5EOWM2cXlwUFEwZENPaHhYQmw1Qk83V3ZpaFFt?=
 =?utf-8?B?MFFOdVl0elJFQjFlclVuY2VHaTlJb3YrWkJUbFBSNldOcG8zcmo5S0NjZ1Fl?=
 =?utf-8?B?dnVNWlFid0FKQ2FNSmxsVlNuOXY4MG43bjlEMTlLZnd3SmtWSE5YVnF6ODBP?=
 =?utf-8?B?SkN0bElWV3JRdXo3eGE2STJ5UDFSVFBMUDkxMjh3VFZIVUh1RzFuZXZFc1Bs?=
 =?utf-8?B?QXc5RHBEOWVSa0lMRmtnc0Q5TWpwZnVadnM1RFJtOTNkdXBueTJCbkc5MEIr?=
 =?utf-8?B?Q2pmRi8yVk5CYTdZMFRybVZUZkFHaTh2RG5XT1BuWmdzL1FvL0tTR2hzT2ZJ?=
 =?utf-8?B?ZTNGVDA3bGhiUDNXTk16K0NmSEZETlZTUmdMQXJRYWFnaENEZ3IyRXVxOWQx?=
 =?utf-8?B?RE1wcWdVOG85WFZ2b3VVM1pVL0RST21lR2lFNTI0eG94TFJDSlZqVk8ralUx?=
 =?utf-8?B?SFZrTEc5ZWliTFhWMHgxT0FoQ3dhaUdBcHozUlgwcVk5YVZwTTBySGwrVG5m?=
 =?utf-8?B?Ykc4WXozc3YvTzEyMWtubTFMUW9neWtTcGZpRlNDTGY2OUFySVEraENYV0VM?=
 =?utf-8?B?bXhkS200R1RLeHFRU3Y1dnNUMUlEN2JFN1c4VTk1ZXN1WVpoMzNmSFJISHAx?=
 =?utf-8?B?M3dtSTk5dEVyVWdVUEhSOC9JUHhRSWs1UU50Q2N3WTJCcyt6ZGZQak50MExJ?=
 =?utf-8?B?OG92T2FPMlFaMnJGUm15OE5CLzM0a3AzVkRXUHpSUWpncUlZR0ovMjJpeWdS?=
 =?utf-8?B?NWluY1A4Q3hNcDU4YWJ0cW9RKzRvNWlCK0JIVERUTGFUM2dUclNRSzJnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S0FMb2RtVW1tWUdEU3g0a2MvQkFpSXhJWXdHMTRXdzRJVUZvMUdaMmg0R0x1?=
 =?utf-8?B?eE0zWGJUSE42dTd5S1dYQ282aDZ1M3RNa1ZQcDR4ZWNZTzVSVnhKcmlycnZw?=
 =?utf-8?B?ZXJHQXJHMXU4QWY2aE5YMHBMUXpHRWUvS0tXQjVacVFpak5yOFVyRC81OE9h?=
 =?utf-8?B?Wjd5ZFdlOWpHWWNCaWlMWHF0YkYrWUN3VGZNdUY0SkpsWkV1R1hyZWdoMEEz?=
 =?utf-8?B?YzNMQUxQSUJKclY2bE5WenI3VzBSQ2lFTXFWay90czdDaEp0aXFOY1FEK2k0?=
 =?utf-8?B?enQ1djBCV1llUnl1SjloMTR6a1NYbi9TeVpDNisxOU1TczZSSFlsREt2RmZ1?=
 =?utf-8?B?UFM1bTF3dGdJcHEyMzR2K0RZSG9kRnJKU0hsZ3VkS3VwQUkwL3V4bUROV2k2?=
 =?utf-8?B?SHhPUzlHQUQxUmI2Tk5JZlNjTEhIbjE1VjFya3pMQ2NjbXcyWDViTk5VWXR6?=
 =?utf-8?B?d1pENSt6dW9RRTRMemJmcmxiRUtySjdlZExRRTQ2M00rKysvcjFhaVlNTXJL?=
 =?utf-8?B?TllrV2s2eVNUL1FPY3NDOFBzSUhHYm1iMU5XMFlXNStjUVdBWTgxVVFpd1Ra?=
 =?utf-8?B?SVo2c2s3VXkwSWxCSFQ5bEVuck1CbFhpMEt2bDR4YllzaUNzQlZJdjg3V29i?=
 =?utf-8?B?M3ZlVEZzcytYZXlCdjM5eXBtSWw3VTBFL1pkUDZNNHBFeHZ4UmkvTG1OcFFF?=
 =?utf-8?B?Q3YxMU5jcElGTlNmZW5OR1Q0ZzhCOTJzdlhPTzdabHFkTGN4TmdwNzI0dGF6?=
 =?utf-8?B?aXVLMCtoZUx4NEp6MXIrWEUrWldZT0xhMXM5UFd0dTEyWTBVRjVwWUJOT1BE?=
 =?utf-8?B?REc0bFk4aGNwNk5VaFBlQmd3MTFROW5pb2pjaUE1WHZCRXVVVFhETlZmLzV2?=
 =?utf-8?B?YWlnOXh5NnJjejJCSDQ4aUV3ZFI3ejF4dTh2eWoyR2VvOHJWNFlCemhaY3F0?=
 =?utf-8?B?b3BzQVBMWDRCb1Nsc1FoTWdRODlJRGhERGVXK2Z6Q3lvczdWeVZ2YmhjQjhM?=
 =?utf-8?B?S01VM1BseUhOc2Y4ZXEwM2ZKMTUwNlc2ZUl4TVFwOFRjTEdJa0FKLzJ5bFlG?=
 =?utf-8?B?WFNHVXhaeVZwZFRWNU5SMmZPaS9raUtjNTJSd25UQklKRlVGQi9ZeG1FbjFZ?=
 =?utf-8?B?cUp0YmwyZ0VuY29mK0VJK1k3a3dkY2t2SkFFay9HN3V1WkNKcDlEOUJMazIw?=
 =?utf-8?B?eVAvTzZDN1h4WkVobHUzVDRDTlFnN0w4KzRubkpJUUVMeW1rdTdIakFFL0JK?=
 =?utf-8?B?L2wySlZ5c1JkbXlJU01sRVl6cnpBL3dOMVMwR3J6UVZrQlVIMnVER1NCVGlm?=
 =?utf-8?B?SjBZYU9QTmFXeURDaXQ3b3BPS2JzcEFmaTRCTTVHRlFKbENtalNXbTdKd285?=
 =?utf-8?B?Ny9lMnRUWjBxcWVWNkE4Ym5aU1FqazB6SFcvOFd0UHJGWVA5Um5Yd0tIWGsz?=
 =?utf-8?B?Wkp6WWpWRDc1b0dKT2lTRmQwTGJNWFp2OXlscXVyUlMzZyt0bnNaY3dHQkpN?=
 =?utf-8?B?NE95WXUzOVQvZktqWnNFRXhrSWNKT0RBM3plZzU3NTBHZXYwZlVRUGpqZzJx?=
 =?utf-8?B?WThDWTcyYk5VeHJUUFhuWm9wWVpnV0N0T2hyMlA5aVhwMENCdGVkNWRiNEpE?=
 =?utf-8?B?eTNqYlJVRFpsOHZZN05OOVVIK0NqSGxvb0twL3dSdEkvanh4cmxLelBOUDcx?=
 =?utf-8?B?aTcwaENuRDFHY3htSGk1M1UxdE1XMjhmWkozdDJYWFJBSG9rZ2NtQ2tiMnkx?=
 =?utf-8?B?MVoraDJxTlhOdjlDN2orMzRURGU5TVBhMDBPTHh5VXlKRzY2Y2JsMDVscmQ1?=
 =?utf-8?B?UjVlTzJ0WTB2d1BiaWZUcHZyRkFXcnpDWk4vQy9kNTAxZXVMdmZ6YkVwTHp4?=
 =?utf-8?B?K25oZitwS3ZFbjNhVzNzc0d4WE14a2FjTnFmdjVLVXF6YS92T2FzMnV6VnR0?=
 =?utf-8?B?dHExMnBpcFVWWlIyK1NvQkgyMkJMdHp0Q2JFVW1HMjVIb2V2VC9YMVppZW9M?=
 =?utf-8?B?QlhsV0hheEFTQjZ3UHlJcGE1TU9KY3U3eFg1WVdZNmIxTjg5NENHTkxxOEVO?=
 =?utf-8?B?OHRIeUpPOXlXcDlBMjhnZWEyQU5tTGo4ejNtck5zSXFHMHJaN2ZqdEZlZGRR?=
 =?utf-8?B?N1ovVDFwVy90TUJ6M3lDV2xhUS9tQisxVmE0TUcrZkpaKzR3bytVZHo5SmNt?=
 =?utf-8?Q?K6QNnZZhQbJzGFg9dB9HGNH8GLYk3AJ/oAVVHlYm+nim?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8BED776102E8444BC8A34103C1561D4@DEUP281.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0d7d33-ec8f-4375-9907-08dc74d15c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 11:22:52.1979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1TZvvtK9aqgskwoexMfVhVh3MkIhdhk66Q3zwR5AFKoEA1CcJTlCF1RwXvOuTbW6+VsiroUxbVKp4v0+2A5TEN8r6MwpAygu8h2brRGipzPNVg3TplM+fmG/vMjaMR4/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEUP281MB3577

SGV5IFNlYW4sDQoNCmRvZXMgdGhpcyB0aGlzIHBhdGNoIGdvIGludG8gdGhlIHJpZ2h0IGRpcmVj
dGlvbj8NCg0KSnVsaWFuDQoNCk9uIFdlZCwgMjAyNC0wNS0wOCBhdCAxNToyNSArMDIwMCwgSnVs
aWFuIFN0ZWNrbGluYSB3cm90ZToNCj4gRnJvbTogVGhvbWFzIFByZXNjaGVyIDx0aG9tYXMucHJl
c2NoZXJAY3liZXJ1cy10ZWNobm9sb2d5LmRlPg0KPiANCj4gV2hlbiBhIHZDUFUgaXMgaW50ZXJy
dXB0ZWQgYnkgYSBzaWduYWwgd2hpbGUgcnVubmluZyBhIG5lc3RlZCBndWVzdCwNCj4gS1ZNIHdp
bGwgZXhpdCB0byB1c2Vyc3BhY2Ugd2l0aCBMMiBzdGF0ZS4gSG93ZXZlciwgdXNlcnNwYWNlIGhh
cyBubw0KPiB3YXkgdG8ga25vdyB3aGV0aGVyIGl0IHNlZXMgTDEgb3IgTDIgc3RhdGUgKGJlc2lk
ZXMgY2FsbGluZw0KPiBLVk1fR0VUX1NUQVRTX0ZELCB3aGljaCBkb2VzIG5vdCBoYXZlIGEgc3Rh
YmxlIEFCSSkuDQo+IA0KPiBUaGlzIGNhdXNlcyBtdWx0aXBsZSBwcm9ibGVtczoNCj4gDQo+IFRo
ZSBzaW1wbGVzdCBvbmUgaXMgTDIgc3RhdGUgY29ycnVwdGlvbiB3aGVuIHVzZXJzcGFjZSBtYXJr
cyB0aGUgc3JlZ3MNCj4gYXMgZGlydHkuIFNlZSB0aGlzIG1haWxpbmcgbGlzdCB0aHJlYWQgWzFd
IGZvciBhIGNvbXBsZXRlIGRpc2N1c3Npb24uDQo+IA0KPiBBbm90aGVyIHByb2JsZW0gaXMgdGhh
dCBpZiB1c2Vyc3BhY2UgZGVjaWRlcyB0byBjb250aW51ZSBieSBlbXVsYXRpbmcNCj4gaW5zdHJ1
Y3Rpb25zLCBpdCB3aWxsIHVua25vd2luZ2x5IGVtdWxhdGUgd2l0aCBMMiBzdGF0ZSBhcyBpZiBM
MQ0KPiBkb2Vzbid0IGV4aXN0LCB3aGljaCBjYW4gYmUgY29uc2lkZXJlZCBhIHdlaXJkIGd1ZXN0
IGVzY2FwZS4NCj4gDQo+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIG5ldyBmbGFnIEtWTV9SVU5f
WDg2X0dVRVNUX01PREUgaW4gdGhlIGt2bV9ydW4NCj4gZGF0YSBzdHJ1Y3R1cmUsIHdoaWNoIGlz
IHNldCB3aGVuIHRoZSB2Q1BVIGV4aXRlZCB3aGlsZSBydW5uaW5nIGENCj4gbmVzdGVkIGd1ZXN0
LiBVc2Vyc3BhY2UgY2FuIHRoZW4gaGFuZGxlIHRoaXMgc2l0dWF0aW9uLg0KPiANCj4gVG8gc2Vl
IHdoZXRoZXIgdGhpcyBmdW5jdGlvbmFsaXR5IGlzIGF2YWlsYWJsZSwgdGhpcyBwYXRjaCBhbHNv
DQo+IGludHJvZHVjZXMgYSBuZXcgY2FwYWJpbGl0eSBLVk1fQ0FQX1g4Nl9HVUVTVF9NT0RFLg0K
PiANCj4gWzFdDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDQxNjEyMzU1OC4y
MTIwNDAtMS1qdWxpYW4uc3RlY2tsaW5hQGN5YmVydXMtdGVjaG5vbG9neS5kZS9ULyNtMjgwYWFk
Y2IyZTEwYWUwMmMxOTFhN2RjNGVkNGI3MTFhNzRiMWY1NQ0KPiANCj4gU2lnbmVkLW9mZi1ieTog
VGhvbWFzIFByZXNjaGVyIDx0aG9tYXMucHJlc2NoZXJAY3liZXJ1cy10ZWNobm9sb2d5LmRlPg0K
PiBTaWduZWQtb2ZmLWJ5OiBKdWxpYW4gU3RlY2tsaW5hIDxqdWxpYW4uc3RlY2tsaW5hQGN5YmVy
dXMtdGVjaG5vbG9neS5kZT4NCj4gLS0tDQo+IMKgRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGku
cnN0wqAgfCAxNyArKysrKysrKysrKysrKysrKw0KPiDCoGFyY2gveDg2L2luY2x1ZGUvdWFwaS9h
c20va3ZtLmggfMKgIDEgKw0KPiDCoGFyY2gveDg2L2t2bS94ODYuY8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHzCoCAzICsrKw0KPiDCoGluY2x1ZGUvdWFwaS9saW51eC9rdm0uaMKgwqDCoMKg
wqDCoMKgIHzCoCAxICsNCj4gwqA0IGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QgYi9Eb2N1bWVu
dGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4gaW5kZXggMGI1YTMzZWU3MWVlLi43NzQ4YzNlYjk4
ZTAgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPiArKysg
Yi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCj4gQEAgLTY0MTksNiArNjQxOSw5IEBA
IGFmZmVjdCB0aGUgZGV2aWNlJ3MgYmVoYXZpb3IuIEN1cnJlbnQgZGVmaW5lZCBmbGFnczo6DQo+
IMKgwqAgI2RlZmluZSBLVk1fUlVOX1g4Nl9TTU3CoMKgwqDCoCAoMSA8PCAwKQ0KPiDCoMKgIC8q
IHg4Niwgc2V0IGlmIGJ1cyBsb2NrIGRldGVjdGVkIGluIFZNICovDQo+IMKgwqAgI2RlZmluZSBL
Vk1fUlVOX0JVU19MT0NLwqDCoMKgICgxIDw8IDEpDQo+ICvCoCAvKiB4ODYsIHNldCBpZiB0aGUg
VkNQVSBleGl0ZWQgZnJvbSBhIG5lc3RlZCAoTDIpIGd1ZXN0ICovDQo+ICvCoCAjZGVmaW5lIEtW
TV9SVU5fWDg2X0dVRVNUX01PREUgKDEgPDwgMikNCj4gKw0KPiDCoMKgIC8qIGFybTY0LCBzZXQg
Zm9yIEtWTV9FWElUX0RFQlVHICovDQo+IMKgwqAgI2RlZmluZSBLVk1fREVCVUdfQVJDSF9IU1Jf
SElHSF9WQUxJRMKgICgxIDw8IDApDQo+IMKgDQo+IEBAIC04MDYzLDYgKzgwNjYsMjAgQEAgZXJy
b3IvYW5ub3RhdGVkIGZhdWx0Lg0KPiDCoA0KPiDCoFNlZSBLVk1fRVhJVF9NRU1PUllfRkFVTFQg
Zm9yIG1vcmUgaW5mb3JtYXRpb24uDQo+IMKgDQo+ICs3LjM0IEtWTV9DQVBfWDg2X0dVRVNUX01P
REUNCj4gKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ICs6QXJjaGl0ZWN0
dXJlczogeDg2DQo+ICs6UmV0dXJuczogSW5mb3JtYXRpb25hbCBvbmx5LCAtRUlOVkFMIG9uIGRp
cmVjdCBLVk1fRU5BQkxFX0NBUC4NCj4gKw0KPiArVGhlIHByZXNlbmNlIG9mIHRoaXMgY2FwYWJp
bGl0eSBpbmRpY2F0ZXMgdGhhdCBLVk1fUlVOIHdpbGwgdXBkYXRlIHRoZQ0KPiArS1ZNX1JVTl9Y
ODZfR1VFU1RfTU9ERSBiaXQgaW4ga3ZtX3J1bi5mbGFncyB0byBpbmRpY2F0ZSB3aGV0aGVyIHRo
ZQ0KPiArdkNQVSB3YXMgZXhlY3V0aW5nIG5lc3RlZCBndWVzdCBjb2RlIHdoZW4gaXQgZXhpdGVk
Lg0KPiArDQo+ICtLVk0gZXhpdHMgd2l0aCB0aGUgcmVnaXN0ZXIgc3RhdGUgb2YgZWl0aGVyIHRo
ZSBMMSBvciBMMiBndWVzdA0KPiArZGVwZW5kaW5nIG9uIHdoaWNoIGV4ZWN1dGVkIGF0IHRoZSB0
aW1lIG9mIGFuIGV4aXQuIFVzZXJzcGFjZSBtdXN0DQo+ICt0YWtlIGNhcmUgdG8gZGlmZmVyZW50
aWF0ZSBiZXR3ZWVuIHRoZXNlIGNhc2VzLg0KPiArDQo+IMKgOC4gT3RoZXIgY2FwYWJpbGl0aWVz
Lg0KPiDCoD09PT09PT09PT09PT09PT09PT09PT0NCj4gwqANCj4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2luY2x1ZGUvdWFwaS9hc20va3ZtLmggYi9hcmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL2t2
bS5oDQo+IGluZGV4IGVmMTFhYTRjYWI0Mi4uZmY0ZWQ4MmEyZDA2IDEwMDY0NA0KPiAtLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUv
dWFwaS9hc20va3ZtLmgNCj4gQEAgLTEwNiw2ICsxMDYsNyBAQCBzdHJ1Y3Qga3ZtX2lvYXBpY19z
dGF0ZSB7DQo+IMKgDQo+IMKgI2RlZmluZSBLVk1fUlVOX1g4Nl9TTU0JCSAoMSA8PCAwKQ0KPiDC
oCNkZWZpbmUgS1ZNX1JVTl9YODZfQlVTX0xPQ0vCoMKgwqDCoCAoMSA8PCAxKQ0KPiArI2RlZmlu
ZSBLVk1fUlVOX1g4Nl9HVUVTVF9NT0RFwqDCoCAoMSA8PCAyKQ0KPiDCoA0KPiDCoC8qIGZvciBL
Vk1fR0VUX1JFR1MgYW5kIEtWTV9TRVRfUkVHUyAqLw0KPiDCoHN0cnVjdCBrdm1fcmVncyB7DQo+
IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4g
aW5kZXggOTE0NzhiNzY5YWYwLi42NGYyY2JhOTM0NWUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2
L2t2bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTQ3MTQsNiArNDcx
NCw3IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBrdm0gKmt2bSwg
bG9uZw0KPiBleHQpDQo+IMKgCWNhc2UgS1ZNX0NBUF9WTV9ESVNBQkxFX05YX0hVR0VfUEFHRVM6
DQo+IMKgCWNhc2UgS1ZNX0NBUF9JUlFGRF9SRVNBTVBMRToNCj4gwqAJY2FzZSBLVk1fQ0FQX01F
TU9SWV9GQVVMVF9JTkZPOg0KPiArCWNhc2UgS1ZNX0NBUF9YODZfR1VFU1RfTU9ERToNCj4gwqAJ
CXIgPSAxOw0KPiDCoAkJYnJlYWs7DQo+IMKgCWNhc2UgS1ZNX0NBUF9FWElUX0hZUEVSQ0FMTDoN
Cj4gQEAgLTEwMjAwLDYgKzEwMjAxLDggQEAgc3RhdGljIHZvaWQgcG9zdF9rdm1fcnVuX3NhdmUo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiDCoA0KPiDCoAlpZiAoaXNfc21tKHZjcHUpKQ0KPiDC
oAkJa3ZtX3J1bi0+ZmxhZ3MgfD0gS1ZNX1JVTl9YODZfU01NOw0KPiArCWlmIChpc19ndWVzdF9t
b2RlKHZjcHUpKQ0KPiArCQlrdm1fcnVuLT5mbGFncyB8PSBLVk1fUlVOX1g4Nl9HVUVTVF9NT0RF
Ow0KPiDCoH0NCj4gwqANCj4gwqBzdGF0aWMgdm9pZCB1cGRhdGVfY3I4X2ludGVyY2VwdChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgva3Zt
LmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gaW5kZXggMjE5MGFkYmUzMDAyLi5jY2Ix
MmY2YTY1NmQgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaA0KPiArKysg
Yi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gQEAgLTkxNyw2ICs5MTcsNyBAQCBzdHJ1Y3Qg
a3ZtX2VuYWJsZV9jYXAgew0KPiDCoCNkZWZpbmUgS1ZNX0NBUF9NRU1PUllfQVRUUklCVVRFUyAy
MzMNCj4gwqAjZGVmaW5lIEtWTV9DQVBfR1VFU1RfTUVNRkQgMjM0DQo+IMKgI2RlZmluZSBLVk1f
Q0FQX1ZNX1RZUEVTIDIzNQ0KPiArI2RlZmluZSBLVk1fQ0FQX1g4Nl9HVUVTVF9NT0RFIDIzNg0K
PiDCoA0KPiDCoHN0cnVjdCBrdm1faXJxX3JvdXRpbmdfaXJxY2hpcCB7DQo+IMKgCV9fdTMyIGly
cWNoaXA7DQoNCg==

