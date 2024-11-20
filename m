Return-Path: <kvm+bounces-32173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25DA89D3EF2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3B0A283DCE
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80DEF1AA793;
	Wed, 20 Nov 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TOv7MxHp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7718660C;
	Wed, 20 Nov 2024 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732116276; cv=fail; b=coKPS44WkCEiMIh7vB2ZqdBxJONyHdJGZWr2pVAn00nuHp69d5ogouZAsWErAiICe0iqjC4xiMjzKoJUbqDY83BhgcLHSr8Ky8vX6ZH5MKLMLyoCdr6jwckSg2yAkstNKOKIAkCsIaC33/6nRJsIw9whNMIMwm7K96V0CFlKPao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732116276; c=relaxed/simple;
	bh=oRRlqnMCKpcgypZnapMx7QOX8Pf42/Khf2e5Zz0w5Nc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fMqklkoZ8H5VdEV0GLb9Vkhfk90I2ek15jAt4pHd9RH1RXVFohQGpli/2MDXmDrURFbSLsqyWghGduHr0Z1QHTUmpw+yAS6xmilZ6bd+5iOBeZWUqm2lYJxKXUo1Ja1Y8lue6MwjoRhA7rlcpLSaGmNjZ+UlsBFGe7BFq6+cWhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TOv7MxHp; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0THZ7xaQzmyQ4ZShVkX9Wu8Ya9kMjmj08up+KWO3y9u87VWam5y79I1trvVNPrk6+21Pz5Nt369y9VKgZcBbO0B60d5T76U6i+Uzw5Yy+hc+flK4c6danFKJy4bsAi899h3D0ndMRthN36y3PWP/WxiHvpTq9eQkSnzXFOVx6lfMdnz6FY1Xbi233kCIkwNpNGH2XODjSsk00YoeioACvcopQmg7B8l6i1VSh92q1fPWV3Gb/OkA20ekeBzRk9a+pfrk7xV0S6ygit15aPP3NJwrxcdPnj5K3h0NXZfMwlZcNX9mTFyGYC31jRCIeg5hznvXb8UFDHHkZiKGubzgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRRlqnMCKpcgypZnapMx7QOX8Pf42/Khf2e5Zz0w5Nc=;
 b=GOu8deVleUzWn4HJmBm/dG+uAJvy/9Cnz2KAcBE5kQ8g4nuc36NUvVOcBMR7OzR/eD7xJikMSERplYt0ryI75RhWHPip+/RS5Eoa3+MteQOkT8SM2yu/7pN5b43QmZV7WjTIPuB5rwgsOhlVp3Bx0mXBU9YIhv2+OwWMEdzrMDsRU8eqeDvLP4dHazQEBFirF8uZ5JAAUvpLR7RAhwc4xhhd3xUWvNdOGG/wNRNvcQ7FDg85ZLjnsYmxkdH0R/mGsWF0kuxKygaxibzqwSu6yVpH6ys7G6FCd2m9dNM8irRQuqXjmfbpEE+MEatQ6dgNMzpj5IenGVZurKTLA29wbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRRlqnMCKpcgypZnapMx7QOX8Pf42/Khf2e5Zz0w5Nc=;
 b=TOv7MxHp1seD/c1HmmOVPnJ1KKclju2Vlq6TPBmFoamZHtjEAf1WWuI1za6YDEFQBhCm3f8Yplsy5dNBL6KQ6tlLhFF5H42gwh+g+6ujRLUY/F4hR6enoN0PCJJV6Ss1EwOV8IxhQYhanHqK1hA13vSnHOwPPopOpoT+nar7qKs=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by CH3PR12MB8460.namprd12.prod.outlook.com (2603:10b6:610:156::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Wed, 20 Nov
 2024 15:24:31 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8158.023; Wed, 20 Nov 2024
 15:24:31 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>
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
Thread-Index: AQHbOx29CotvqvmvmkqNyViPxCRbzrLASloA
Date: Wed, 20 Nov 2024 15:24:31 +0000
Message-ID: <442d59be02af4cdda6f8a32f2eb934aca53c0440.camel@amd.com>
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
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|CH3PR12MB8460:EE_
x-ms-office365-filtering-correlation-id: 6939af4e-df28-43df-67c3-08dd09776e6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eXJSNlpiaTE2TUc2S241b1RJdlA4Q1ArMTNUYXhSbWYvYkVlVHJPS3p5YTBU?=
 =?utf-8?B?MGwrRU5YRnZseXROb3orc1pHZE1IM2ozYjNoaDIxL24xYTUzL0Jkb1N0b0dZ?=
 =?utf-8?B?bk9mbkFZRTN4OGxYMUM1clRKRmIwYVEyWUFYWkdXTXc2VEZCczBESkdTbWth?=
 =?utf-8?B?R1VwUmp5ZHJlamQwM2RaYURreHh4K3dCOElpUE54ZkxxdXdkQWpaNWY4dUJN?=
 =?utf-8?B?Z0RpZFR4Y3NIb28zVzY5cXg5YzZUWnV5VzBoaVhXdmo0UisrVlE5Mnh2dmxK?=
 =?utf-8?B?RDZVWjM3UzdLcCsyRk1GeVB2bXNqQ0krcU9ZaUg0YmNsUHV1aS8xa0g3K2xt?=
 =?utf-8?B?NWROL1NOWEZGd3RCWkUwN211dS9ESjhBTHR2R1RjbStUcWU1cnNUWnRyVmpR?=
 =?utf-8?B?RjM2NS9wNlFIeHF3dWdpSEJ1L0FTTys0WFpDUng4dEE1bFJUSWdDaTN5YWF0?=
 =?utf-8?B?Vi9XY1l6OXZZQ1hncnYyYnpCdTZsTGU4N3RXRVlHQWhPWHNyZU51VFl1Tlhl?=
 =?utf-8?B?VUxoNFpPV2c5NVBUaytsUWxTNXRqRHpKRmtzQm1OSWtHVmxrRWVKYWdRTGN5?=
 =?utf-8?B?ZGs1OCtKOUpxd2N2TEZZM0w0ZXBtd3plbjJpQVMxMUJkZnlWdHdXekM0M21Z?=
 =?utf-8?B?dGZrVG1NRDgxZGtLNElmeS9TV0NEclNyYklNd1NKSkdIZlFMdmFmcUhMQVA5?=
 =?utf-8?B?STRmbHhSOVlKSEVjc2VFWVNnWFAwajc0SFdNUEdVajNNSFR0WWZJOElmN0pi?=
 =?utf-8?B?WmwrWjdLQVlTZzZWcUhPQ1F2NFVkc05MSC9wVEk1dG1tbUdkQ2cveDVjQk9m?=
 =?utf-8?B?d3ZvTG52UHVBMnhHTjR0N09oY0lEUDZ4L3czcjYyU1JzWWNaVGZLV1U4NVNQ?=
 =?utf-8?B?eldER2pCZHMvV2hxVHdTbE1oeFQvc2pRVTMxeHp1VGtuRSt3VlNBcWpzTVJE?=
 =?utf-8?B?VEtmRFBBTXVQUlBKaVc4Z3F5cEtUMVBTMjhWOTV6R25BcGZPbHM5N3AzR28v?=
 =?utf-8?B?YW9UVm9xanhPWlpiTlhBT3BoYUFWREZKSzRudFExZVVBNWFqb1lYWW5OKzdy?=
 =?utf-8?B?OEkyS1lLU1U2NmhFaVVVR1pKVVQxYlFZUEErd0pmR0lZaHNyYXozWDBqbTBs?=
 =?utf-8?B?RnByUXcybnlrYmJRVHlDRHZFbXB0Wjl5QiswbzFDclcvbGhteVJQSmxvblgz?=
 =?utf-8?B?OEw1YnNOV052M1NldE51ellLcThDOGF3MlV1aWpPSzJ1RG9DVGN3bEM4Y3Yw?=
 =?utf-8?B?OGNuOVBLNVd0cDVyVkY0WmNYdWxDdHdoSmVUbjk0NDd3b044amJQUEtPRGxC?=
 =?utf-8?B?eWZab0tsWmJKcUpUVXNSR0tZUVY0alFkMXVMRGhrbklRRTgyN0RxYldpdWhl?=
 =?utf-8?B?VTI4aXd0ZlQ1NlZsaDRsaS9XLzMvN3ZVWnd1T09qY3pFMDNlSnRwVGpvSnRY?=
 =?utf-8?B?T3FzOFJQcEpSUnVjbU1zK0JzNlJrRkkvWmhrcDc4QmhrdXhpOFIrWEpPcGlC?=
 =?utf-8?B?aXRSRVdtZEJ3dVhMK2hRV0ZMMFVqUy9MU3Fsdm1uTERCY1MzNWh3a0RPVFhi?=
 =?utf-8?B?RVkxVi9oRFJMM0E3NTJ0VWlHMDFGZWh4SmRKRVNPMG5mOTNxMzMzT3hBcUlN?=
 =?utf-8?B?Q01xV0ltTFVoc25xTWhycVQyMTVLWUJ3TEhkT2Q0NDBwcFYzaHZPd0Jqay9Y?=
 =?utf-8?B?dk02bVppOGtHeHRyYXV0THUxNDhEdkJxZXN3VzV4cWV5ZisyeVZXNFU4N0Ux?=
 =?utf-8?B?YXVVSnFIQ1ZQSTZMQ0sxY0ZkWVlKVERkb0oyUnNWR3UrK2NMMnpKSXhuODZn?=
 =?utf-8?Q?RUL8b0WqSrbbFuh/jVItR8l9qZwyGhrGWDcsY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R1lIT0o1cUpnUHFHeVY1WGxxc0daZ0dqUFEySVVydDI1alFGU090VEsrSlA1?=
 =?utf-8?B?bDVrVWpWcmtQNFBoVGRxSGJ1VDM4ZHlpelc5MmhodWRkRUFsOGFBOXhvUXRk?=
 =?utf-8?B?dXVNVkg5dE04SUFMVG5UdnpSUXkwZGQya2wzMVdxUnZhTGdOTzRPSzgwWGhY?=
 =?utf-8?B?dDRMMW4wQVgrOFJ4SFZBUWI1M2NIa3owM1NVb2Y4eUZQTEFWTU5rRkdOUVVE?=
 =?utf-8?B?Rldpb25BWWc0RWZTOVBoSVBsTFhzKzdPV1JlRWkyUDNMMnVzRFNTS0N4Zy9P?=
 =?utf-8?B?WEtSbGlSdDIwVWZ5YmlHencyaEZXMGU5d3FLdjhaNlg2cHU0M1NDTTNQWGtr?=
 =?utf-8?B?bXJ5TE1CTUVmS1JpUmwremVXZitTQmk1Qm55NmFvdVh2S1A2ZHk3WlFuTC9O?=
 =?utf-8?B?THgyWkJzOENVTWZDRVhuZGVpbzNNR3dzTDB1NGVSY3ZvbDFFbzc2LzJBRjFF?=
 =?utf-8?B?OTI5cDBKQU0yTXIrVWlMb0lFZGRUQitZUTdaQVFPL0hPRkJsZkZoKzhJMkR3?=
 =?utf-8?B?REZmTm9keHVvQi92OWppSHA4NVhTNGZJU0V3QVE2bFZzWjFXQ0dka3Bud2J3?=
 =?utf-8?B?L09RQjR4b0JsRXViMWppQXdOc0I4VThzc0dneGNSRHdVbHN4TkR5Y1dkcll0?=
 =?utf-8?B?dTJUZGJTbFYxM3cyZGhJNlk2akNoNE5MUS9ySEN2Qm85bGdMTjZMQllidTZ1?=
 =?utf-8?B?ZzNHTldNU0kwYjFhQ2dSMFB1aFY3QXRIV0hXTWZ1RVVsRDZqUUdwampVNFJz?=
 =?utf-8?B?WGRIUUI0VFJsYitUVGxiZnJRdDZkd1VrdlhZTGVkMnp4SlBoRFdINmpZZThE?=
 =?utf-8?B?MTMzOUtTMzJmRXRrNjJacDJpUFdWZUtaTFFpellNMGl3WTY5T2l0NFFEam9p?=
 =?utf-8?B?cUZjZnlPU01wYkxESHZUVjYwcXFYSnFKa1RwYzd6OWlhM1R0ckVZK24wZ2hI?=
 =?utf-8?B?Q05oaVFmdEpNb1ZJQm9uZWFpWTkwUUwxUm1TSEdaWFpJc1RYREhUM09zTFlI?=
 =?utf-8?B?RWQ0RDJUMitrV0FSYzhzYkxFM0dsSkM2MEphWk9FTlB0azJPQ1BzM1lmb0dj?=
 =?utf-8?B?NzBxVzl1bVd6MnQwWWppaDZuNEIzaGtvZlB6eFF4bmZ2TlhIM1pQaTFNNTZF?=
 =?utf-8?B?M2RrMFdPVE9IbHhRbE96WjVPOWd4TjN0N2tuNE1JUmNqUnBTVjRpbjY1TS9u?=
 =?utf-8?B?T1pobGN4NERYcU54ZVpQRUhGYUowYTBxMGFnSXczRVJoVy9JZFAwa3JzKzFo?=
 =?utf-8?B?QTdVK2gzMmVkVDAzcXRrU0l0ZzRJMTBMc0M4bUgyL0tWaXRDN21tVnZGR3d2?=
 =?utf-8?B?ZitONzdLTEhQblFTdVpwdkIrYW9ENE1Yc1lEZXA0YmoxbXBPaWloRk4rc1dT?=
 =?utf-8?B?eUpDOWNKWjBqUjNDc1lHYUFVRFFwNkpYVjdOUWRsRFN5eHhBenc4VnJRS2pW?=
 =?utf-8?B?TERoemFwa2RDTlB0RzRxYTVuQmh4QlM0WTFkcUxPREpKOFg5RHNidXJFaVNS?=
 =?utf-8?B?RE9EeWZqYkE4dGVlQ1hWVjhoQmxJaW5WY29SSWJBdVVPNWZpRFI2MUh0c29O?=
 =?utf-8?B?YUEvMTJ2NlYvMTZlSnBXMjRQNktGZU1GMnJRVFMrRm1haGoraGhsOEIzQUJP?=
 =?utf-8?B?d2tXTHZJVHpybWZoWWl6QU5weGJqNzQ0L2JxNlF0Z0lwV1ZzemFQQkZydFF4?=
 =?utf-8?B?bU12cTJhU0ZCRzlhSjdBMkNkdE9aZEsxdHBwbGpoY1dJVDlOeERjQUpoQnUz?=
 =?utf-8?B?K1hlc2c1cXd6TlpnS1hJd0t1NDZ3TERTT3pjcVBycEZmSER2d1VuWkY0YTlt?=
 =?utf-8?B?N2dnZDZYbVROK0h3Z2cyZmt6V3czUVFjYkFIZEpYQmxBS2Z0OXIvV2pBK2Nl?=
 =?utf-8?B?T2pYSytCN2lVeVhpakRsMXl3TlhhaXdocWEzRVdwWTdIbVAwaWM5cDUxTkI2?=
 =?utf-8?B?dHNCM2JDS1B3SElERkpYMlgrbEFmQzZqYmNXNUhCQXloYjZxeGU1enk1MGtk?=
 =?utf-8?B?T2RZZnJxbk1lQzR4VWg2VzhuYUt2QjlsbS91aFZaU3B4eEhXRFgzMjlCb3hL?=
 =?utf-8?B?OURrMk53OFkxcWpXblFQQmJpeTZZbHhEbTBTNlpUYnhkUHNSWVRiWG1nbVVO?=
 =?utf-8?Q?LJuttQ6hrTDFfqJtxJAHznCfq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FD0E5183EEB594DBEFB4634772F1149@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6939af4e-df28-43df-67c3-08dd09776e6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2024 15:24:31.4854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fk0JP7s6edkaQ6584NnWXQicDwdv3PCSvcAI4wq76TbeA7KfA8ECQYhFVV1eBo5kqwxs7Tj2GHbqH+r/lwacgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8460

T24gVHVlLCAyMDI0LTExLTE5IGF0IDIzOjI3IC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cg0KDQpbLi4uXQ0KDQo+IEBAIC0xNjE3LDEyICsxNjM0LDEzIEBAIHN0YXRpYyB2b2lkIF9faW5p
dA0KPiBzcGVjdHJlX3YyX2RldGVybWluZV9yc2JfZmlsbF90eXBlX2F0X3ZtZXhpdChlbnVtIHNw
ZWN0cmVfdjJfDQo+IMKgCWNhc2UgU1BFQ1RSRV9WMl9SRVRQT0xJTkU6DQo+IMKgCWNhc2UgU1BF
Q1RSRV9WMl9MRkVOQ0U6DQo+IMKgCWNhc2UgU1BFQ1RSRV9WMl9JQlJTOg0KPiAtCQlwcl9pbmZv
KCJTcGVjdHJlIHYyIC8gU3BlY3RyZVJTQiA6IEZpbGxpbmcgUlNCIG9uDQo+IFZNRVhJVFxuIik7
DQo+ICsJCXByX2luZm8oIlNwZWN0cmUgdjIgLyBTcGVjdHJlUlNCIDogRmlsbGluZyBSU0Igb24N
Cj4gY29udGV4dCBzd2l0Y2ggYW5kIFZNRVhJVFxuIik7DQoNCk5pdDogc3RyYXkgd2hpdGVzcGFj
ZSBiZWZvcmUgJzonDQoNCj4gKwkJc2V0dXBfZm9yY2VfY3B1X2NhcChYODZfRkVBVFVSRV9SU0Jf
Q1RYU1cpOw0KPiDCoAkJc2V0dXBfZm9yY2VfY3B1X2NhcChYODZfRkVBVFVSRV9SU0JfVk1FWElU
KTsNCj4gwqAJCXJldHVybjsNCj4gwqAJfQ0KPiDCoA0KPiAtCXByX3dhcm5fb25jZSgiVW5rbm93
biBTcGVjdHJlIHYyIG1vZGUsIGRpc2FibGluZyBSU0INCj4gbWl0aWdhdGlvbiBhdCBWTSBleGl0
Iik7DQo+ICsJcHJfd2Fybl9vbmNlKCJVbmtub3duIFNwZWN0cmUgdjIgbW9kZSwgZGlzYWJsaW5n
IFJTQg0KPiBtaXRpZ2F0aW9uXG4iKTsNCj4gwqAJZHVtcF9zdGFjaygpOw0KDQpGb3IgdGhlIEVS
QVBTIHBhdGNoZXMsIHRoZXknbGwgZmxvdyBiZXR0ZXIgaWYgdGhlc2UgdHdvIGxpbmVzIGFyZQ0K
d2l0aGluIGEgJ2RlZmF1bHQnIHN3aXRjaCBzdGF0ZW1lbnQgKHdpdGggdGhlIG90aGVyIHJldHVy
bnMgY2hhbmdpbmcgdG8NCmJyZWFrcykuICBJIGNhbiBkbyB0aGF0LCBvZiBjb3Vyc2UsIGJ1dCBp
ZiB5b3UgbmVlZCB0byBzcGluIGEgdjIgYW5kDQp1cGRhdGUgdGhhdCwgaXQnbGwgc2F2ZSBzb21l
IGNodXJuLg0KDQpUaGFua3MsDQoNCgkJQW1pdA0KDQo=

