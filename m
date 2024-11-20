Return-Path: <kvm+bounces-32142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A90449D3855
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 11:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EDB61F23E0C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 10:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA53C19CC31;
	Wed, 20 Nov 2024 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CyG+OeuH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3277C19C54D;
	Wed, 20 Nov 2024 10:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732098467; cv=fail; b=H8q1XHoJxrtBgzfzhUjX/yKoWlAHW29Lqx+LosVGVhGXMsc/7y5iB9tcxWA01NkqdznJJKITVsoETgAuyiMGA04VVxO0TPrTVY0RZqrxPn6RFuN1JhVMYlmJ5xSfsz9VIUPcuGACP6VYM5w2Cs96PIQVRthbJ/juxBM9gluQtsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732098467; c=relaxed/simple;
	bh=E/aPf3YuKN95X5Kq+hsjDt/M8j1ipCNm7bw7V90G88E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ss0RCTviEjayxUtdfZxoAlU3GXxYMBc83eEX59LPz7YfRSG/Nt7vmyqIkjNYhPZYY0SoWWBphRwJkPaAreV4BJJLE0yrjx0c2pVnxmcGv5iEPBV2yyiqYoKWOoI5OTAAvoqpAFuzBKb10LjubvjUcqIsNGIRsIAHTaZ5LuGX8qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CyG+OeuH; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/DKYtxj7gKjHYx9I4YFH779Op6VUTf/S5yuVTGKxcF3HE1R29ZpP67BvUl26HfT1ymrpqJaLM0kyDLvdEeaSj7t+um4SV/0gSE7GunAC+rZ06+7t1PJ9YTGOL76EYxacira6jqTdpTjxWDB/YNkpuPFYnq9LaXfKwxdLbSB3t+lKi9LD8kcZf8mmHT7QphAA8FimWrWtFrI5ox5z/6dYyAx4Dgou1NI63KOl47189EldbBArvPViySWkw9rYOqw5jlYxvltpn2KFB8RAIoWIKVm/8sozYtk/JlZalNaBzJopDdGc7V/f9yj2jfy7ahnmWrYdLpKKrRjNmswUCjkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/aPf3YuKN95X5Kq+hsjDt/M8j1ipCNm7bw7V90G88E=;
 b=mwWKs9ogT9isPnHNTbrgjWahEq0W8K2wifx4BXWJST25LDFT7UhuDQx4AtYCRc5YWTN7+nUYB9+IK+7HUFV9+2y0o6QHmiGXNo2fLPg0fqer6QT3jNoZQqzFSNR3dRX8fwTUkZhCXgDJoc95pfBbpocYhdy81gMPQ3cNo46QVmYt72lTBAwOJb48eZiDVFGAXRC5qSkoMYREQLwqhNkUUXqw7q4OPDGUnj0+bs2b1Jk3emIidWLVJv8dMQNlEZEXLCFZI+wO9asTqeBqPKnAm3JUilbBbrzlhLo4ITLjC4IoNRuUwMckr5w9Fw8236qevVbCg2u7EfEzq84E3a+ByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/aPf3YuKN95X5Kq+hsjDt/M8j1ipCNm7bw7V90G88E=;
 b=CyG+OeuHTmSGhRryRUyNT3CiCZnZ2tJhpE7I246nhD7loWu6Jnu8xR/xI38uNQx5yi/2Jx4ceKDkDRkUqOUk1pWE4VGqKm3uT9l9R0V2q4Lg/DoI4MTXPhOr8MIDabrfuT6WRss55Blb2hCO/bPYjeaJsoxQtuVt0M+zdn+n040=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by SN7PR12MB7812.namprd12.prod.outlook.com (2603:10b6:806:329::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 10:27:42 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8158.023; Wed, 20 Nov 2024
 10:27:42 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "Phillips, Kim"
	<kim.phillips@amd.com>, "x86@kernel.org" <x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "amit@kernel.org" <amit@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>
Subject: Re: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with eIBRS
Thread-Topic: [PATCH 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Thread-Index: AQHbOx29CotvqvmvmkqNyViPxCRbzrK/92sA
Date: Wed, 20 Nov 2024 10:27:42 +0000
Message-ID: <b2c639694a390208807999873c8b42a674d1ffa2.camel@amd.com>
References: <cover.1732087270.git.jpoimboe@kernel.org>
	 <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>
In-Reply-To:
 <9792424a4fe23ccc1f7ebbef121bfdd31e696d5d.1732087270.git.jpoimboe@kernel.org>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|SN7PR12MB7812:EE_
x-ms-office365-filtering-correlation-id: 04656542-b1aa-4d3b-1c47-08dd094df765
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?U1dZZDN3T3dGYjZvYllCNHBBSCtyQjc1NEg2ZXNMOStlcVJhbFJ1eXAzRWI3?=
 =?utf-8?B?TWJLd2oyL3kySFZoSkd1T3JZRzlvdlhGU2RaQzIweWxIb1pmZjhMNjJCd2V0?=
 =?utf-8?B?ZHFQM09vYjZDODJxUnNYWmZ3UnZVQ29QeG1ZZjBVQ3RVaGxqeDExRXpRSzRV?=
 =?utf-8?B?TWdJSlIwbE1tUmV3bk95OG9Ua2hkOVBnZTB0OWVLbFNkOXFoK0p3U0ZrQzFI?=
 =?utf-8?B?ZkdUTEdVT0VqS01jMDFWM01WaUZ4U1JkdTkrUERQTkJ0RTdNRllNbk40akpz?=
 =?utf-8?B?OHVQLzg4NEdsVTd1aWlwL2ltV1V4M1haRVdvci83U29TNkFXVWtEWGVERmdU?=
 =?utf-8?B?NFV4VG44NUlrb1BOQ3g3M0ljWEg4Yys5NnVPdkczVkVWeWQ4QzdCYVVoOG9o?=
 =?utf-8?B?WENrNng2NEljTSt4NzFkc0JzZENqSHZvNkE0VEFIakcvd0dSRGs0UUdFb3c4?=
 =?utf-8?B?UUo3Rmt1SDE3QlhKb3E0R2xGb016NUZIbTRYTnR5dC9xc0d2OTZ1TUpnSFlO?=
 =?utf-8?B?THErQ2x4MkYyZjd0MDRnU1MxMmhGMzRJVThkZWg1eXJPaTZUcjhhWSsrMlky?=
 =?utf-8?B?d3Y1cjlhcmFONjBPR0F4VWwzUUE1dUJtU1JBeUdhMitJN3lYSXBDOW1EL242?=
 =?utf-8?B?ZXpuNmYzV05vaUpqWU1ySWhhOG1xZ0dHby83OGlsT1BPN0ZNbDhScDBkeEpJ?=
 =?utf-8?B?YmcvajJPR053M204bSs1TzVCc1JKQ2N6QWZsSGxmNUs2YmxYcDlvSmJmME1t?=
 =?utf-8?B?VnZVakdpN01rRGpIRTZMY3ZvcEQrWUM0MDBVbkxRMGZTWnYvWHFzclJRYXVu?=
 =?utf-8?B?TzdEV0ZJQnFzNVBaY2NUSXVEYllsNXJ4QVZlRTJaUWZSYXpkRFUvaUhLUXE4?=
 =?utf-8?B?eENHdndneGZnMDhsejMrUjZoR0ZrQllMQ1M5RUFCaUI5KzVXTUFLWXVFRnk4?=
 =?utf-8?B?ZFJsQXJyQXdRVEJuUjI0QkZ5THlyS0tJZ2J0SFg5TkhVOS9oQnVrRmxyeE9J?=
 =?utf-8?B?VFBZU0MvSUFOZDF2SGo1UGw5S1BOdmZTaUc1TzJCdlVxbjhlcGI5Y0w1azFC?=
 =?utf-8?B?M0IzVXovNC9MU25RVlcyMGRxRzU5ckN5eTY2T2I4VTV0SjZVMU1qRzVQbHQ1?=
 =?utf-8?B?TmFSdlJDU3VxanFHRmVVMjhmRUhJVE1hY0J4c0daZ2lxVWVXL3lBdmVsOTJJ?=
 =?utf-8?B?dXZyUS82Zmh1VVhoVzh0c01yU0plVFdzWEViUHkwK3poL0lrSm1Yb0NWUm9k?=
 =?utf-8?B?VFpSbS9WOGl5ZlZkUDFmVDV3cEpNcGJPdWFRZjVEcnJKbVhOdGtXSmNpMWU4?=
 =?utf-8?B?aFRITkQwNnpoSGdyaUZ6VHNQdWxldmM1cmM1a3hydEoxdGQ5TFFLK3VzUVNC?=
 =?utf-8?B?S1cyK3NIdy84L0gvSjFQaE81SnQ2Qy9sSlgrU3Z6Vm9PaTZsS2hLRk1zblJ3?=
 =?utf-8?B?L2tHSWx2OTdFcG5JdUVwMG8wVk5tekZISGVVTzhtdXFJQTlOT29FaTlMVDVV?=
 =?utf-8?B?Qnp5alNKTWU1VXU5QnlNUEFRRDlrZnhmTUF5dkRhOWlRL2t3blo5RFY2dmlE?=
 =?utf-8?B?UmFwYW1JcmFDV0dYUUxoUC9ublBmcGc3cG5jbGs0d2J2QUtKb1N5NGdqVjJC?=
 =?utf-8?B?YWZodWN0ZDZHV05mZEthaXozbGovdWtmbGh1TUF2YWhxS0t2dXVHaWxFRzJC?=
 =?utf-8?B?Qm9Vc0o1SFZlQ0k3V3paeHhKMXZsU2ZPa2ZuNGltY3B0bTMweVdNckNYV1l6?=
 =?utf-8?B?ME1ZT0RSTWl4Qkd1WnpzSWkyUDF3MjVOMjlMT0Q0WjE5Mkx1R1plV1NrT1px?=
 =?utf-8?Q?eMacvivtnJ9J4XxO+3MfQXQvQGQIvlAgVuxkk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cGRBV1RKNVZPcE5aR0hjM0dMMHJhUDZKRjZpNVowV01Fakp2eHc2QVFEdGYw?=
 =?utf-8?B?RURjSXhvQWhVVTF6NmN5RkIyWk5oeXBLTWwxeVBYZGl1UzkvS0NyZmdheXQ2?=
 =?utf-8?B?akRrSTNyb1d1eFExMnF5bUZYRFRFaDNmU3VnOG5uOWhvMXdTZk40UnNMdWR1?=
 =?utf-8?B?VFZhTnhKLzNGVEVUSzJhelpDeGIxMVpLdlNXVVVZTnRWcGZmVTlEVzh3RDIr?=
 =?utf-8?B?a0ZPSzU5UDdBdFNNNFBLR2h5YlBQelgvay9zNXJHcjQrOFFCZlBUWUFkTW1Y?=
 =?utf-8?B?SDlWV2N6NkVSdFFyTGF4QnBhdG9talZJMGFlUXl0ckJpeUhrQk5MZDBRQkVw?=
 =?utf-8?B?ZnFENklDM3lIQWxoTTUrS3hDZFplcFpiREpFT3FNRmRHclN4dWlXdXR3Mmcw?=
 =?utf-8?B?K2IyZEpKK0hrYkFVRm1EUkRlSytkNFFqeVQ1S002M203RWNhbURSNXR0VGxw?=
 =?utf-8?B?Z3VPUXVBYU42V2w2Mjc5a2xXU3B5K0p6cGFVRzB1bGdUZytjMXlYMlJVZFgv?=
 =?utf-8?B?d0NCeFZiZHZ3aTVKQmY1bWtuNURLcXFFR2NDSW9ZdVpZZENSb01qTUZ2WURv?=
 =?utf-8?B?T3AvYkRQYm9ubkY5aVJZTzN3dzFndiszdmNJeTd3aXJObGllWGhVcnVoUHFa?=
 =?utf-8?B?WEs3ZE91dFlJemJsY3VHbWRQNlhvcmVXRUZaTUNLYlg4cHA4bkpEemFjbVp4?=
 =?utf-8?B?SVJERHk1NmZlZFZjMTBxTnZVSm80QW1uV3V0Y0xTTVRyaUFmcXFwQUtxRjdI?=
 =?utf-8?B?K1hqbW1hRVhSZzhodU5hN0R0Y1h1dlNTN0F4aXhrWkE2R3hlYWRyM1h2ZlZP?=
 =?utf-8?B?cVc3Zy9sVUZzWXN0L0F5cWZKVU1KN0luR0FGdmpoek1nNHNuZWpRU1plak5L?=
 =?utf-8?B?emx2QnhRRWswOFJ5SEV3TnVRN3lobzZGNTR3MlBxdDVuQXp1L3d0Q05xVE1Z?=
 =?utf-8?B?a01HVVJGSllVN01NWkNXU2xFbWtyQkNjclRtV1lDQXU5bERSc3A2VEQ4U2g5?=
 =?utf-8?B?clNudWlWWWN2N0xUbm1HWWYvdnN2Tk1uZTZQNjg0SjdGMkpoamFLNFhzNHZT?=
 =?utf-8?B?bUwxVHRBd1ZQTGE2dTZjZGYvK3BIdlpTYllmMU50YnBNOHBZWkhIdGtlb01S?=
 =?utf-8?B?OElwV1U1VzB6ZHc4MFk0WUI3aFlQdU1iMStlTEg1RjBUKytmb0NVR2hHK0xy?=
 =?utf-8?B?bDVFU3NFbVZFUmJWK3FSL29oK0RTbjhNb21XbEM2Tks5ZzRXVU0xYjJqK1Fi?=
 =?utf-8?B?a0NHTFIzeENzaWhnckdZL1BzbWRnb2Z4RFMwQWZJaE8vbndGUVIvWWdYSVln?=
 =?utf-8?B?UDltb25QZytoMk1FMGZzRkJhcHZ1K2hHdU5MMVdpWXBpTmkzQUJxbms5Zjk4?=
 =?utf-8?B?d0lCS04yK082U0JYNHVmdDRUdUs2VHFoVnpMaHljNnVEOWtLNHkrS1NSNDV0?=
 =?utf-8?B?VGphaU9aWmMzN2d5dEdTVVZIQ3ZIYkdyYVlnbklkZDZxSUpmbWVHRHR2N2Zn?=
 =?utf-8?B?N3MzRmVJa0E3VGZUZXdWMjN6UnBjbmJRaVV4NlA2VDZBbDhUYlJVbHhnR25E?=
 =?utf-8?B?cm8vSU1yS3hCUDl0a2ZvdjI5QXI5NDZyVkkzM3Z1ekIxVGVZenZ3M1ZPV0E3?=
 =?utf-8?B?ZTZFWE5UTnVvQlVMTExHZVp6RGJUOFE1T3NRelZDUUZETUdGWitDNzRkQ2sw?=
 =?utf-8?B?SERUQnR3cHdxL1VpYUpmNjhmOWNUcDB4QzRHMnNMbDk0N0hKenBoOW42MG4x?=
 =?utf-8?B?WTNGZDd1SUx0NitpSnZnSGNocHN5SHlhZzU3ek5iZzlYRlZLbFhQb0Fvc25G?=
 =?utf-8?B?NGZhTnRGOUU5MHhYSDBrRjFycCtzcGZpVFdkWnQrNUcyeDVkRTNvazdybGhZ?=
 =?utf-8?B?eG80ZFpYVUo2Tkoxd2YvS3VaQXpDTHBKNEVleHJicnN2K0pmbTgydXpFNU1H?=
 =?utf-8?B?TW5kY3F1U1hGTkZuaENXck9Bd3QxMHB6bGZvWDdHSW01VldCdFRRcEZ2dUpp?=
 =?utf-8?B?TU1sbzdIZkhsR1R1bUorVHlrbEVhT3JMM2VubFkxd1JZZ2Q0QmF3K3hscWlF?=
 =?utf-8?B?MEt6QTFJU3JLUjFVSkF5ckdTeC9sRno2NmJ6azg1eTFoa29ucmRORlpSNG1a?=
 =?utf-8?Q?u2D0Ca9g+MHFQ0JrT3Pv9y6wu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B8A392A379BFA4B90A9E10F954DEBAF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04656542-b1aa-4d3b-1c47-08dd094df765
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2024 10:27:42.3883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R9AKBIrSWv749kV3mzDuJ8Ty51krwtuyuIbXGHTNu+gRIXiSlMuRYdnZbdgzhtEEQTk2tBaUE7FHUCDToMoUug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7812

T24gVHVlLCAyMDI0LTExLTE5IGF0IDIzOjI3IC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gVXNlci0+dXNlciBTcGVjdHJlIHYyIGF0dGFja3MgKGluY2x1ZGluZyBSU0IpIGFjcm9zcyBj
b250ZXh0IHN3aXRjaGVzDQo+IGFyZSBhbHJlYWR5IG1pdGlnYXRlZCBieSBJQlBCIGluIGNvbmRf
bWl0aWdhdGlvbigpLCBpZiBlbmFibGVkDQo+IGdsb2JhbGx5DQo+IG9yIGlmIGF0IGxlYXN0IG9u
ZSBvZiB0aGUgdGFza3MgaGFzIG9wdGVkIGluIHRvIHByb3RlY3Rpb24uwqAgUlNCDQo+IGZpbGxp
bmcNCj4gd2l0aG91dCBJQlBCIHNlcnZlcyBubyBwdXJwb3NlIGZvciBwcm90ZWN0aW5nIHVzZXIg
c3BhY2UsIGFzIGluZGlyZWN0DQo+IGJyYW5jaGVzIGFyZSBzdGlsbCB2dWxuZXJhYmxlLg0KPiAN
Cj4gVXNlci0+a2VybmVsIFJTQiBhdHRhY2tzIGFyZSBtaXRpZ2F0ZWQgYnkgZUlCUlMuwqAgSW4g
d2hpY2ggY2FzZSB0aGUNCj4gUlNCDQo+IGZpbGxpbmcgb24gY29udGV4dCBzd2l0Y2ggaXNuJ3Qg
bmVlZGVkLsKgIEZpeCB0aGF0Lg0KPiANCj4gV2hpbGUgYXQgaXQsIHVwZGF0ZSBhbmQgY29hbGVz
Y2UgdGhlIGNvbW1lbnRzIGRlc2NyaWJpbmcgdGhlIHZhcmlvdXMNCj4gUlNCDQo+IG1pdGlnYXRp
b25zLg0KDQpMb29rcyBnb29kIGZyb20gZmlyc3QgaW1wcmVzc2lvbnMgLSBidXQgdGhlcmUncyBz
b21ldGhpbmcgdGhhdCBuZWVkcw0Kc29tZSBkZWVwZXIgYW5hbHlzaXM6IEFNRCdzIEF1dG9tYXRp
YyBJQlJTIHBpZ2d5YmFja3Mgb24gZUlCUlMsIGFuZCBoYXMNCnNvbWUgc3BlY2lhbCBjYXNlcy4g
IEFkZGluZyBLaW0gdG8gQ0MgdG8gY2hlY2sgYW5kIGNvbmZpcm0gaWYNCmV2ZXJ5dGhpbmcncyBz
dGlsbCBhcyBleHBlY3RlZC4NCg0KKGNmIGNvbW1pdHMNCmU3ODYyZWRhMzA5IHg4Ni9jcHU6IFN1
cHBvcnQgQU1EIEF1dG9tYXRpYyBJQlJTDQpmZDQ3MGE4YmVlZCB4ODYvY3B1OiBFbmFibGUgU1RJ
QlAgb24gQU1EIGlmIEF1dG9tYXRpYyBJQlJTIGlzIGVuYWJsZWQNCmFjYWE0YjVjNGM4IHg4Ni9z
cGVjdWxhdGlvbjogRG8gbm90IGVuYWJsZSBBdXRvbWF0aWMgSUJSUyBpZiBTRVYtU05QIGlzDQpl
bmFibGVkDQopDQoNCgkJQW1pdA0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBQYXdhbiBHdXB0YSA8cGF3
YW4ua3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKb3NoIFBv
aW1ib2V1ZiA8anBvaW1ib2VAa2VybmVsLm9yZz4NCj4gLS0tDQo+IMKgYXJjaC94ODYva2VybmVs
L2NwdS9idWdzLmMgfCA5MSArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4g
LS0NCj4gwqBhcmNoL3g4Ni9tbS90bGIuY8KgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQ0KPiDC
oDIgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgNTggZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9idWdzLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L2J1Z3MuYw0KPiBpbmRleCA2OGJlZDE3ZjA5ODAuLmUyNjFmNDE3NDliMCAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9idWdzLmMNCj4gKysrIGIvYXJjaC94ODYva2Vy
bmVsL2NwdS9idWdzLmMNCj4gQEAgLTE1NzksMjcgKzE1NzksNDQgQEAgc3RhdGljIHZvaWQgX19p
bml0DQo+IHNwZWNfY3RybF9kaXNhYmxlX2tlcm5lbF9ycnNiYSh2b2lkKQ0KPiDCoAlycnNiYV9k
aXNhYmxlZCA9IHRydWU7DQo+IMKgfQ0KPiDCoA0KPiAtc3RhdGljIHZvaWQgX19pbml0IHNwZWN0
cmVfdjJfZGV0ZXJtaW5lX3JzYl9maWxsX3R5cGVfYXRfdm1leGl0KGVudW0NCj4gc3BlY3RyZV92
Ml9taXRpZ2F0aW9uIG1vZGUpDQo+ICtzdGF0aWMgdm9pZCBfX2luaXQgc3BlY3RyZV92Ml9taXRp
Z2F0ZV9yc2IoZW51bQ0KPiBzcGVjdHJlX3YyX21pdGlnYXRpb24gbW9kZSkNCj4gwqB7DQo+IMKg
CS8qDQo+IC0JICogU2ltaWxhciB0byBjb250ZXh0IHN3aXRjaGVzLCB0aGVyZSBhcmUgdHdvIHR5
cGVzIG9mIFJTQg0KPiBhdHRhY2tzDQo+IC0JICogYWZ0ZXIgVk0gZXhpdDoNCj4gKwkgKiBJbiBn
ZW5lcmFsIHRoZXJlIGFyZSB0d28gdHlwZXMgb2YgUlNCIGF0dGFja3M6DQo+IMKgCSAqDQo+IC0J
ICogMSkgUlNCIHVuZGVyZmxvdw0KPiArCSAqIDEpIFJTQiB1bmRlcmZsb3cgKCJJbnRlbCBSZXRi
bGVlZCIpDQo+ICsJICoNCj4gKwkgKsKgwqDCoCBTb21lIEludGVsIHBhcnRzIGhhdmUgImJvdHRv
bWxlc3MgUlNCIi7CoCBXaGVuIHRoZSBSU0INCj4gaXMgZW1wdHksDQo+ICsJICrCoMKgwqAgc3Bl
Y3VsYXRlZCByZXR1cm4gdGFyZ2V0cyBtYXkgY29tZSBmcm9tIHRoZSBicmFuY2gNCj4gcHJlZGlj
dG9yLA0KPiArCSAqwqDCoMKgIHdoaWNoIGNvdWxkIGhhdmUgYSB1c2VyLXBvaXNvbmVkIEJUQiBv
ciBCSEIgZW50cnkuDQo+ICsJICoNCj4gKwkgKsKgwqDCoCB1c2VyLT51c2VyIGF0dGFja3MgYXJl
IG1pdGlnYXRlZCBieSBJQlBCIG9uIGNvbnRleHQNCj4gc3dpdGNoLg0KPiArCSAqDQo+ICsJICrC
oMKgwqAgdXNlci0+a2VybmVsIGF0dGFja3MgdmlhIGNvbnRleHQgc3dpdGNoIGFyZSBtaXRpZ2F0
ZWQNCj4gYnkgSUJSUywNCj4gKwkgKsKgwqDCoCBlSUJSUywgb3IgUlNCIGZpbGxpbmcuDQo+ICsJ
ICoNCj4gKwkgKsKgwqDCoCB1c2VyLT5rZXJuZWwgYXR0YWNrcyB2aWEga2VybmVsIGVudHJ5IGFy
ZSBtaXRpZ2F0ZWQgYnkNCj4gSUJSUywNCj4gKwkgKsKgwqDCoCBlSUJSUywgb3IgY2FsbCBkZXB0
aCB0cmFja2luZy4NCj4gKwkgKg0KPiArCSAqwqDCoMKgIE9uIFZNRVhJVCwgZ3Vlc3QtPmhvc3Qg
YXR0YWNrcyBhcmUgbWl0aWdhdGVkIGJ5IElCUlMsDQo+IGVJQlJTLCBvcg0KPiArCSAqwqDCoMKg
IFJTQiBmaWxsaW5nLg0KPiDCoAkgKg0KPiDCoAkgKiAyKSBQb2lzb25lZCBSU0IgZW50cnkNCj4g
wqAJICoNCj4gLQkgKiBXaGVuIHJldHBvbGluZSBpcyBlbmFibGVkLCBib3RoIGFyZSBtaXRpZ2F0
ZWQgYnkNCj4gZmlsbGluZy9jbGVhcmluZw0KPiAtCSAqIHRoZSBSU0IuDQo+ICsJICrCoMKgwqAg
T24gYSBjb250ZXh0IHN3aXRjaCwgdGhlIHByZXZpb3VzIHRhc2sgY2FuIHBvaXNvbiBSU0INCj4g
ZW50cmllcw0KPiArCSAqwqDCoMKgIHVzZWQgYnkgdGhlIG5leHQgdGFzaywgY29udHJvbGxpbmcg
aXRzIHNwZWN1bGF0aXZlDQo+IHJldHVybg0KPiArCSAqwqDCoMKgIHRhcmdldHMuwqAgUG9pc29u
ZWQgUlNCIGVudHJpZXMgY2FuIGFsc28gYmUgY3JlYXRlZCBieQ0KPiAiQU1EDQo+ICsJICrCoMKg
wqAgUmV0YmxlZWQiIG9yIFNSU08uDQo+IMKgCSAqDQo+IC0JICogV2hlbiBJQlJTIGlzIGVuYWJs
ZWQsIHdoaWxlICMxIHdvdWxkIGJlIG1pdGlnYXRlZCBieSB0aGUNCj4gSUJSUyBicmFuY2gNCj4g
LQkgKiBwcmVkaWN0aW9uIGlzb2xhdGlvbiBwcm90ZWN0aW9ucywgUlNCIHN0aWxsIG5lZWRzIHRv
IGJlDQo+IGNsZWFyZWQNCj4gLQkgKiBiZWNhdXNlIG9mICMyLsKgIE5vdGUgdGhhdCBTTUVQIHBy
b3ZpZGVzIG5vIHByb3RlY3Rpb24NCj4gaGVyZSwgdW5saWtlDQo+IC0JICogdXNlci1zcGFjZS1w
b2lzb25lZCBSU0IgZW50cmllcy4NCj4gKwkgKsKgwqDCoCB1c2VyLT51c2VyIGF0dGFja3MgYXJl
IG1pdGlnYXRlZCBieSBJQlBCIG9uIGNvbnRleHQNCj4gc3dpdGNoLg0KPiDCoAkgKg0KPiAtCSAq
IGVJQlJTIHNob3VsZCBwcm90ZWN0IGFnYWluc3QgUlNCIHBvaXNvbmluZywgYnV0IGlmIHRoZQ0K
PiBFSUJSU19QQlJTQg0KPiAtCSAqIGJ1ZyBpcyBwcmVzZW50IHRoZW4gYSBMSVRFIHZlcnNpb24g
b2YgUlNCIHByb3RlY3Rpb24gaXMNCj4gcmVxdWlyZWQsDQo+IC0JICoganVzdCBhIHNpbmdsZSBj
YWxsIG5lZWRzIHRvIHJldGlyZSBiZWZvcmUgYSBSRVQgaXMNCj4gZXhlY3V0ZWQuDQo+ICsJICrC
oMKgwqAgdXNlci0+a2VybmVsIGF0dGFja3MgdmlhIGNvbnRleHQgc3dpdGNoIGFyZSBwcmV2ZW50
ZWQNCj4gYnkNCj4gKwkgKsKgwqDCoCBTTUVQK2VJQlJTK1NSU08gbWl0aWdhdGlvbnMsIG9yIFJT
QiBjbGVhcmluZy4NCj4gKwkgKg0KPiArCSAqwqDCoMKgIGd1ZXN0LT5ob3N0IGF0dGFja3MgYXJl
IG1pdGlnYXRlZCBieSBlSUJSUyBvciBSU0INCj4gY2xlYXJpbmcgb24NCj4gKwkgKsKgwqDCoCBW
TUVYSVQuwqAgZUlCUlMgaW1wbGVtZW50YXRpb25zIHdpdGgNCj4gWDg2X0JVR19FSUJSU19QQlJT
QiBzdGlsbA0KPiArCSAqwqDCoMKgIG5lZWQgImxpdGUiIFJTQiBmaWxsaW5nIHdoaWNoIHJldGly
ZXMgYSBDQUxMIGJlZm9yZQ0KPiB0aGUgZmlyc3QNCj4gKwkgKsKgwqDCoCBSRVQuDQo+IMKgCSAq
Lw0KPiDCoAlzd2l0Y2ggKG1vZGUpIHsNCj4gwqAJY2FzZSBTUEVDVFJFX1YyX05PTkU6DQo+IEBA
IC0xNjE3LDEyICsxNjM0LDEzIEBAIHN0YXRpYyB2b2lkIF9faW5pdA0KPiBzcGVjdHJlX3YyX2Rl
dGVybWluZV9yc2JfZmlsbF90eXBlX2F0X3ZtZXhpdChlbnVtIHNwZWN0cmVfdjJfDQo+IMKgCWNh
c2UgU1BFQ1RSRV9WMl9SRVRQT0xJTkU6DQo+IMKgCWNhc2UgU1BFQ1RSRV9WMl9MRkVOQ0U6DQo+
IMKgCWNhc2UgU1BFQ1RSRV9WMl9JQlJTOg0KPiAtCQlwcl9pbmZvKCJTcGVjdHJlIHYyIC8gU3Bl
Y3RyZVJTQiA6IEZpbGxpbmcgUlNCIG9uDQo+IFZNRVhJVFxuIik7DQo+ICsJCXByX2luZm8oIlNw
ZWN0cmUgdjIgLyBTcGVjdHJlUlNCIDogRmlsbGluZyBSU0Igb24NCj4gY29udGV4dCBzd2l0Y2gg
YW5kIFZNRVhJVFxuIik7DQo+ICsJCXNldHVwX2ZvcmNlX2NwdV9jYXAoWDg2X0ZFQVRVUkVfUlNC
X0NUWFNXKTsNCj4gwqAJCXNldHVwX2ZvcmNlX2NwdV9jYXAoWDg2X0ZFQVRVUkVfUlNCX1ZNRVhJ
VCk7DQo+IMKgCQlyZXR1cm47DQo+IMKgCX0NCj4gwqANCj4gLQlwcl93YXJuX29uY2UoIlVua25v
d24gU3BlY3RyZSB2MiBtb2RlLCBkaXNhYmxpbmcgUlNCDQo+IG1pdGlnYXRpb24gYXQgVk0gZXhp
dCIpOw0KPiArCXByX3dhcm5fb25jZSgiVW5rbm93biBTcGVjdHJlIHYyIG1vZGUsIGRpc2FibGlu
ZyBSU0INCj4gbWl0aWdhdGlvblxuIik7DQo+IMKgCWR1bXBfc3RhY2soKTsNCj4gwqB9DQo+IMKg
DQo+IEBAIC0xODE3LDQ4ICsxODM1LDcgQEAgc3RhdGljIHZvaWQgX19pbml0DQo+IHNwZWN0cmVf
djJfc2VsZWN0X21pdGlnYXRpb24odm9pZCkNCj4gwqAJc3BlY3RyZV92Ml9lbmFibGVkID0gbW9k
ZTsNCj4gwqAJcHJfaW5mbygiJXNcbiIsIHNwZWN0cmVfdjJfc3RyaW5nc1ttb2RlXSk7DQo+IMKg
DQo+IC0JLyoNCj4gLQkgKiBJZiBTcGVjdHJlIHYyIHByb3RlY3Rpb24gaGFzIGJlZW4gZW5hYmxl
ZCwgZmlsbCB0aGUgUlNCDQo+IGR1cmluZyBhDQo+IC0JICogY29udGV4dCBzd2l0Y2guwqAgSW4g
Z2VuZXJhbCB0aGVyZSBhcmUgdHdvIHR5cGVzIG9mIFJTQg0KPiBhdHRhY2tzDQo+IC0JICogYWNy
b3NzIGNvbnRleHQgc3dpdGNoZXMsIGZvciB3aGljaCB0aGUgQ0FMTHMvUkVUcyBtYXkgYmUNCj4g
dW5iYWxhbmNlZC4NCj4gLQkgKg0KPiAtCSAqIDEpIFJTQiB1bmRlcmZsb3cNCj4gLQkgKg0KPiAt
CSAqwqDCoMKgIFNvbWUgSW50ZWwgcGFydHMgaGF2ZSAiYm90dG9tbGVzcyBSU0IiLsKgIFdoZW4g
dGhlIFJTQg0KPiBpcyBlbXB0eSwNCj4gLQkgKsKgwqDCoCBzcGVjdWxhdGVkIHJldHVybiB0YXJn
ZXRzIG1heSBjb21lIGZyb20gdGhlIGJyYW5jaA0KPiBwcmVkaWN0b3IsDQo+IC0JICrCoMKgwqAg
d2hpY2ggY291bGQgaGF2ZSBhIHVzZXItcG9pc29uZWQgQlRCIG9yIEJIQiBlbnRyeS4NCj4gLQkg
Kg0KPiAtCSAqwqDCoMKgIEFNRCBoYXMgaXQgZXZlbiB3b3JzZTogKmFsbCogcmV0dXJucyBhcmUg
c3BlY3VsYXRlZA0KPiBmcm9tIHRoZSBCVEIsDQo+IC0JICrCoMKgwqAgcmVnYXJkbGVzcyBvZiB0
aGUgc3RhdGUgb2YgdGhlIFJTQi4NCj4gLQkgKg0KPiAtCSAqwqDCoMKgIFdoZW4gSUJSUyBvciBl
SUJSUyBpcyBlbmFibGVkLCB0aGUgInVzZXIgLT4ga2VybmVsIg0KPiBhdHRhY2sNCj4gLQkgKsKg
wqDCoCBzY2VuYXJpbyBpcyBtaXRpZ2F0ZWQgYnkgdGhlIElCUlMgYnJhbmNoIHByZWRpY3Rpb24N
Cj4gaXNvbGF0aW9uDQo+IC0JICrCoMKgwqAgcHJvcGVydGllcywgc28gdGhlIFJTQiBidWZmZXIg
ZmlsbGluZyB3b3VsZG4ndCBiZQ0KPiBuZWNlc3NhcnkgdG8NCj4gLQkgKsKgwqDCoCBwcm90ZWN0
IGFnYWluc3QgdGhpcyB0eXBlIG9mIGF0dGFjay4NCj4gLQkgKg0KPiAtCSAqwqDCoMKgIFRoZSAi
dXNlciAtPiB1c2VyIiBhdHRhY2sgc2NlbmFyaW8gaXMgbWl0aWdhdGVkIGJ5IFJTQg0KPiBmaWxs
aW5nLg0KPiAtCSAqDQo+IC0JICogMikgUG9pc29uZWQgUlNCIGVudHJ5DQo+IC0JICoNCj4gLQkg
KsKgwqDCoCBJZiB0aGUgJ25leHQnIGluLWtlcm5lbCByZXR1cm4gc3RhY2sgaXMgc2hvcnRlciB0
aGFuDQo+ICdwcmV2JywNCj4gLQkgKsKgwqDCoCAnbmV4dCcgY291bGQgYmUgdHJpY2tlZCBpbnRv
IHNwZWN1bGF0aW5nIHdpdGggYSB1c2VyLQ0KPiBwb2lzb25lZCBSU0INCj4gLQkgKsKgwqDCoCBl
bnRyeS4NCj4gLQkgKg0KPiAtCSAqwqDCoMKgIFRoZSAidXNlciAtPiBrZXJuZWwiIGF0dGFjayBz
Y2VuYXJpbyBpcyBtaXRpZ2F0ZWQgYnkNCj4gU01FUCBhbmQNCj4gLQkgKsKgwqDCoCBlSUJSUy4N
Cj4gLQkgKg0KPiAtCSAqwqDCoMKgIFRoZSAidXNlciAtPiB1c2VyIiBzY2VuYXJpbywgYWxzbyBr
bm93biBhcyBTcGVjdHJlQkhCLA0KPiByZXF1aXJlcw0KPiAtCSAqwqDCoMKgIFJTQiBjbGVhcmlu
Zy4NCj4gLQkgKg0KPiAtCSAqIFNvIHRvIG1pdGlnYXRlIGFsbCBjYXNlcywgdW5jb25kaXRpb25h
bGx5IGZpbGwgUlNCIG9uDQo+IGNvbnRleHQNCj4gLQkgKiBzd2l0Y2hlcy4NCj4gLQkgKg0KPiAt
CSAqIEZJWE1FOiBJcyB0aGlzIHBvaW50bGVzcyBmb3IgcmV0YmxlZWQtYWZmZWN0ZWQgQU1EPw0K
PiAtCSAqLw0KPiAtCXNldHVwX2ZvcmNlX2NwdV9jYXAoWDg2X0ZFQVRVUkVfUlNCX0NUWFNXKTsN
Cj4gLQlwcl9pbmZvKCJTcGVjdHJlIHYyIC8gU3BlY3RyZVJTQiBtaXRpZ2F0aW9uOiBGaWxsaW5n
IFJTQiBvbg0KPiBjb250ZXh0IHN3aXRjaFxuIik7DQo+IC0NCj4gLQlzcGVjdHJlX3YyX2RldGVy
bWluZV9yc2JfZmlsbF90eXBlX2F0X3ZtZXhpdChtb2RlKTsNCj4gKwlzcGVjdHJlX3YyX21pdGln
YXRlX3JzYihtb2RlKTsNCj4gwqANCj4gwqAJLyoNCj4gwqAJICogUmV0cG9saW5lIHByb3RlY3Rz
IHRoZSBrZXJuZWwsIGJ1dCBkb2Vzbid0IHByb3RlY3QNCj4gZmlybXdhcmUuwqAgSUJSUw0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC94ODYvbW0vdGxiLmMgYi9hcmNoL3g4Ni9tbS90bGIuYw0KPiBpbmRl
eCA4NjU5M2QxYjc4N2QuLmM2OTNiODc3ZDRkZiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvbW0v
dGxiLmMNCj4gKysrIGIvYXJjaC94ODYvbW0vdGxiLmMNCj4gQEAgLTM4OCw3ICszODgsNyBAQCBz
dGF0aWMgdm9pZCBjb25kX21pdGlnYXRpb24oc3RydWN0IHRhc2tfc3RydWN0DQo+ICpuZXh0KQ0K
PiDCoAlwcmV2X21tID0gdGhpc19jcHVfcmVhZChjcHVfdGxic3RhdGUubGFzdF91c2VyX21tX3Nw
ZWMpOw0KPiDCoA0KPiDCoAkvKg0KPiAtCSAqIEF2b2lkIHVzZXIvdXNlciBCVEIgcG9pc29uaW5n
IGJ5IGZsdXNoaW5nIHRoZSBicmFuY2gNCj4gcHJlZGljdG9yDQo+ICsJICogQXZvaWQgdXNlci91
c2VyIEJUQi9SU0IgcG9pc29uaW5nIGJ5IGZsdXNoaW5nIHRoZSBicmFuY2gNCj4gcHJlZGljdG9y
DQo+IMKgCSAqIHdoZW4gc3dpdGNoaW5nIGJldHdlZW4gcHJvY2Vzc2VzLiBUaGlzIHN0b3BzIG9u
ZSBwcm9jZXNzDQo+IGZyb20NCj4gwqAJICogZG9pbmcgU3BlY3RyZS12MiBhdHRhY2tzIG9uIGFu
b3RoZXIuDQo+IMKgCSAqDQoNCg==

