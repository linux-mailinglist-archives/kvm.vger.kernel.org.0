Return-Path: <kvm+bounces-28713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF1899C17E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 09:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F008A1C2261D
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 07:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C2714A0B7;
	Mon, 14 Oct 2024 07:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sq0dlUw9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96C6149013
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 07:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728891488; cv=fail; b=M01i1J8kb25oXKAG/Jptk9WoC8ZvFG9AHHmh6tbAPH1CeqvZNFo2hx7MOkEKJNABcUi9mnxV4Dl8oiwdAARXqdNWq0Q1CQOTJoqG2gmn3cwLK1bnyOcPvvZ6oQpLPx9aEv4KRxD7jOxQ4+vUGj7RZUxBcOUoVTz6y1M82pDjlG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728891488; c=relaxed/simple;
	bh=xf3KGkQlzZWnfjmII8C4I+3gsKHDbitLkvEZ5/djXOg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dlJHDAVoeBzbuadQuXoJ+iL4uTUMnG0BdVG50Cy8hkz8IR84AufhUdQ/Suv6nQ6Z6azwooLrfyWBbLrtUATb3etoaoOn2Qx8JZLH+N3xGR7tFugDahbDeVHVPX5S5Dx/gQ/OFQ3epgKk4/Fan5F2n6HuiOeTT8Us95lwBHlsQdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sq0dlUw9; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXc4hzqijm8rLNLJLDSaw9hoGQUuiVGc5TrqXxoQ18kwwJGsMTAUX2gHA46UnjkC+lgkWFKdA0U1vKn0KwYD6m7nro/8rRDIMo81lk9fez7fsT6R/pcNtDh0bQue7jGmcaWcUqYnomHCoa2msXLGB6dvLCEYxBTCLpREp65IWKUvHftb4J3qNmblVPUQy6yI3ihn8mlUfPpMobwiKG+rnZBmluylOhGeuh83xtrjg73g08HwVPx2dtr5lz9Rp65MtUDL92H1/xh47xd/58CeJQ+oGSbsf33jkbpAT6jUc24ppIvCjV+D4zGBYAHvd/92lYwXUOm3yMAoToxLMApZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xf3KGkQlzZWnfjmII8C4I+3gsKHDbitLkvEZ5/djXOg=;
 b=aAJhC4XNFwHl1YSq38bBcec1PX5Fb98qzxoiqK+stGROe3ezw96COTi2BOOGNCbJN0Fa7KZzZXhXNuzgW1RRk1m3nbLIxC2cLH0nwc5KchZAHbeaSZPe5S0ve7amx94LToIep5Tbmzx/8rF1fGSGuyt+ZkHxC3wT9NndUA3Zh5YRGDZHyF4BJpHerC/eV2PUvLV7NPLJAv7TbIu/XuRbjLmsZ8xqDFPpc+r77Qe0k2DvZ420EHBcuggYJuWqlBv24QsoCrsrGxzbLo9YARmV17iElJiPDRR+eaPIWxGvQogTkxjXKW9UCUlZgMTc2OWqHlHlrY6Co9M2SyO3+DGMSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xf3KGkQlzZWnfjmII8C4I+3gsKHDbitLkvEZ5/djXOg=;
 b=Sq0dlUw9ElDd72M77MmbJo3vamdOcFOrekSmJA+ktCksKEnnCnME9joIiZohu7iBzLxL4v2t/DKBfLspywa44xJzra84+ncNDvX/uZ2pUGhPBkmJmD+DKWUgOilmvaQ8NoiZKQjc93OR4fUtiDOBpkaq08mun1dn4MS8gaGmGdHMuoYsJRbQjzIrsxh+HGsWtoXIXrqd7kspWZTKjHuOReaAcKuwErhtqjyeV9jzPjZfQMJoRVeDkKLMwuSGqVzkZnqbKHQ19oeBSLxOOpEAW78bUacWxK87Z6aHw0kZZHxWNnIZqy3Vkb3OmlaP+RX84shQHKAJfFX4sPHoy0MBAQ==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by DM4PR12MB6639.namprd12.prod.outlook.com (2603:10b6:8:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24; Mon, 14 Oct
 2024 07:38:04 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::8e11:7d4b:f9ae:911a%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 07:38:03 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "airlied@gmail.com"
	<airlied@gmail.com>, "daniel@ffwll.ch" <daniel@ffwll.ch>, Andy Currid
	<ACurrid@nvidia.com>, Neo Jia <cjia@nvidia.com>, Surath Mitra
	<smitra@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, "zhiwang@kernel.org" <zhiwang@kernel.org>
Subject: Re: [RFC 06/29] nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is
 enabled
Thread-Topic: [RFC 06/29] nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is
 enabled
Thread-Index: AQHbDO4HrY5AEnakj0qqdnG2zKq/RLJqtAOAgBtKIYA=
Date: Mon, 14 Oct 2024 07:38:03 +0000
Message-ID: <bc19bc8f-1692-49f5-9286-d4442714776e@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922124951.1946072-7-zhiw@nvidia.com> <20240926225343.GV9417@nvidia.com>
In-Reply-To: <20240926225343.GV9417@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|DM4PR12MB6639:EE_
x-ms-office365-filtering-correlation-id: 423de4c3-9b91-48d3-2be7-08dcec23232b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?M2F1Q1dIQVFLTCtqekovVVVPaXhXcGh0ZzZ6R1ZKVGRidGdEU1hBVitxa2xW?=
 =?utf-8?B?RWtUQUQzV0J2RnpYeUNMM2paS0ZOSm1tdHJ5UkxYNHFzWVQ1SWJSaEFaK3l3?=
 =?utf-8?B?TXdpaDNjVVpYMVRzNEtTa2o1bkVKWDBLdWszUnQ4MVMrMTBMdzlUb1hVWVl4?=
 =?utf-8?B?elNrUUdOdjE5eGxuQU16aDB3cjhNRUxYaGRxcm1EWkFvako0WU1nUDZLdjdx?=
 =?utf-8?B?U2VmcVFScTRPSGVGU3FFcU4veDNRbzVNUkUyZ2JFWW9uOW9ZVHhZVXhwT3hR?=
 =?utf-8?B?SFIrcWNPS2hhY1NIdlZHMXd6V3lEYXhEUk01ekhnazV6YkpDTUt2dnYyTFJY?=
 =?utf-8?B?ejczUytRcnRGY1Y5TkJtRTRvNVY3bWVzZHRqSEhoWjJlYmhzOHFXSkZ5bm1y?=
 =?utf-8?B?S0lIRk5sbW0zUDlGUWRURHNzM1czRXZyeFBMWnQ1MU9pQmpzay83VGtnY3hi?=
 =?utf-8?B?aVJTalVtRk1XejZ5dE5aMnhDYzk3cy9nNlYyMG1aVk9KZ3RyTHpHT1FFTXRy?=
 =?utf-8?B?YkU0b0JSS3FGaCtCTjMrZ2cvR1VxRklCQUJ6cWliRWw2UkpuL2g3NjRIUDJX?=
 =?utf-8?B?VkMwK0dFbjI2UVlMdWg1V3FwQi9FTmsrdm9hdFRSYi9CcS8zRUNkS2x6WEFT?=
 =?utf-8?B?Y1pMKzdsMXBCTGlLblpKbXNRYmozOGdmdTM1Y01aazJvSXE4UVpEZmFNUjZB?=
 =?utf-8?B?MWhyTFhDQS81bW1iMjNKU0M5K3padEVRc2NvU09pb3FteFVsVEtYMjViZE9s?=
 =?utf-8?B?N0NQajkrdWZOTnE3TzFuTXZZY3J2dTJJVnVwMkx4RG1DQko1blVYaWRhYjRr?=
 =?utf-8?B?SnZpVHZNVnZEMHJXZG1JQVM5T2hzb3lVeUp3MkxWQXdrRjBPaGxiYkpTQVVu?=
 =?utf-8?B?a2kwOWowQWNiYXpQbkxGKytQdE1UM3VvUHFCbnk5dXhFMWhlbjBwa2RlY1pu?=
 =?utf-8?B?NlJBNjJZblZNTFYxM0k2ZHdZY3dGM05tV3VWd1ExNnJHZy85VDBmQmhvSmZV?=
 =?utf-8?B?OFp6d2dka2IxdTR3VG4vOFFrZEhORXNsZ244TjFqeGlNbWl5Ym10Vmp0UWhU?=
 =?utf-8?B?algwTWNBbzJ6T2tOdHRHVTg4enRMZXV6U3lOSDlnbVFOTDV4a0NOTGtNNGJr?=
 =?utf-8?B?L3JUZHNTaElzdXh0RGpRZmhkcjJqZWxaazYvclQ0NVFxb2dDeHZUYmJiQ2tr?=
 =?utf-8?B?aUI2TncwanNNTnNscXFLaWVSS3o4UktjZTI0eTdFVmpsV3djNU1YR1ZBbEcy?=
 =?utf-8?B?VEhSS1pQa0RUWmpoUjlxQUNGc0toWkUvK1lhN25mVEtOUERxZlR0QStxTWJs?=
 =?utf-8?B?a0lqUEtSbTdnRldCdVNaT0wyUTF2RXZsczN2N0hEc0pMb0RnTDZ0OVdKYXlx?=
 =?utf-8?B?RCtzYnpNMS82REl4R3ZkUEVrbkpSR0crNlhoUm9zRCtnWmFxRDdic0tmS0M0?=
 =?utf-8?B?dkV0bVFacWpZdUpQZmM5a0RGMFMxMWZWakZXakl5dW5wd3Z4ZzUwSDhtYkIv?=
 =?utf-8?B?MW8rUFFLWmY5OVduYVk4VFFYYWMvUEtNN2lyR0RVTlVUMVNidWhEMjA0d2dm?=
 =?utf-8?B?ellOZ3ZWTXloYzQ3VlZta3lIaElxdjRwWXRyd0wwMG9paEcwaUxnSUpOTnBO?=
 =?utf-8?B?b3B1VkV4aWhNR1RMOFYydmxFTEYrMEpkczRkMzNJcEtLRDJLMFM4UUNTTXNt?=
 =?utf-8?B?aHIwTXFYZTArOHBHd1paSGhXd3ZlbTQycElhRmRBbjVJWENNR2RIclZvZEI5?=
 =?utf-8?B?a0xsQkI1Z2d2V0o5ZmZEclZINmR5a3NxQTFLTUJYS1J5aG1SSmZUVmY1eVBW?=
 =?utf-8?B?YlV1ZUhaaDJrbm04L1dBUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVR6OFdzWGNGNi9OMlozeGtFSTgyTFluSkUyV1ZnOXdqRjFyeCtPU084MkRO?=
 =?utf-8?B?MEtFeHpsWGJ4QzRWZGhXWnVpU3FnTVVRNk5QYzR6OEE3QWNrSUFndi93WjFR?=
 =?utf-8?B?d1NZQ2FGYWl6M2MzYkMxYVdhREpVUStEamY2R3lWaVVNTE8zRnB5Y2I0b1Fr?=
 =?utf-8?B?WmlDbHF4YUZ3KzhxaHNYOGwyK1E5N09mSUVpZWhtblF0MXg0R05lck5FaU96?=
 =?utf-8?B?SWVuSy9mVXZBaFRqL3VablRZQWRrV1dtdEczbnVkZ29OYW1tVExZRzBRaHhX?=
 =?utf-8?B?Tk5Uc3pTZ2lUQnJJVUQ2dGRuMThvOHN6NHUrTm9YWXJQWHRoeVNLL1NVWVgy?=
 =?utf-8?B?am5WOURhaTZMeVpaVlpzMHU0MHZNOE1ZVzVGaTRNbE9LcnJFVUIxK2pNZFNh?=
 =?utf-8?B?RlRVUmlMUjc4WklNM293OG9NRzF3d0hHVU9KbTRnbmJjd0RDNk0xcHN1bkVu?=
 =?utf-8?B?VDR1N3AwMHpUZ25pNEorTzdpek9FZExLSlNvOFlkdk81MmY1VG9pd3BaOWpk?=
 =?utf-8?B?RmtTQUZhWGRJR2dKbkEzMWpwdTBIZ3FpbjlkN0tKTk5CL3lIVTlCVDNJNDhM?=
 =?utf-8?B?WUo5S0ttOXNQeTdxdXNncUoxRlRIQUd1NkhHZFBXbDc3dkJQampWLytFbzhK?=
 =?utf-8?B?YW1GSi9UQ01ydklCK2JXanppQVQvSmtKcVFmY0NIMFRiaFZrNDhYb2FrVXJ2?=
 =?utf-8?B?OW4wMW56dlJmblIvZzl4K05majlNbUZKYVRJNHBwRGV4S1V1NkJxVHNEcVZv?=
 =?utf-8?B?ZmhqNGlUMzJZM2M0bE9mNXpHd3J2Z0VIZHFRdU9wMTdkaDNIR0tKS2oxN2pS?=
 =?utf-8?B?elpRS3J0c0VOUlgwbTAvYW94S2cwN2h5bTRpZmxBNTF5c1pBN2s5cXJQNi9Y?=
 =?utf-8?B?Mzc1MFh0NHZlaEVhV3U5MWRJQWVkNnpLMjVDREV0cmRwVmszT1N4LzJyZEJu?=
 =?utf-8?B?OHo5TkYrNnBkY0R4cm92eWdoNGRiNG5hNGxuem0rNUFvb1NuN1BkQjMzSnQw?=
 =?utf-8?B?K0FuM1ZXblkyMHh3NmtNdTBKd2E3ZU9FRHBMbFFJMkM2TFNNM0paaWdiSFd3?=
 =?utf-8?B?V3BENE5PWk5WLytydW9sY21nSFdLbDBMaTVhaERVVXBzaTc1OFFPcGJad1ZR?=
 =?utf-8?B?SEdtQWQ4b2J2ZU1VUnEzOTdZdTF5SFIxQkRidHZxLysxWHhLS3dQSHJhMTZI?=
 =?utf-8?B?R1B1TWxQd0xBWis1TXluZkd3SGZmdjhob21UeGFvV09EWEZ3OW9aWVRwbThJ?=
 =?utf-8?B?YjVXelYzUnY2aklRbmUwMU9YMzBXRk8wcEl5YzJiTXJzUVA1YktZY0l0a2Fw?=
 =?utf-8?B?TFpsSWlScFNTclZvZThoQ0xzbkpZZElIa2RwR2FFa3lsL0M4d1BTZUlNQjNN?=
 =?utf-8?B?U0luZ1hYMXFvOUpGbVBEUFZ1eTJhb3ZaalFyaGhvRWd2TWFsS2lGa1JMa2Nz?=
 =?utf-8?B?Zi91NlZXWWVVN1lrMm9RYXQyQVJtVEROR2Z5RXA1S05WVFUyZnYvQ2p5eWRr?=
 =?utf-8?B?YVFBbmYxMEpTaE04UDNvQzVwSXVzMWNoOWVYSTR1UlJOQnFKY3J2b0Z5QnN1?=
 =?utf-8?B?QktydWZJdWt0amJBUmYyS1BCSGxPUWhUK0prSiswbFNqbGlNTkFrOVpKdFVw?=
 =?utf-8?B?M01oY1lldnYxbm9GM0dmai9qYTUySWJlVC9PeE44dXUzaktlMldNbldEME5C?=
 =?utf-8?B?WVN2K0I3amE1cG5uZG9hSnNYUk96blIvd3hhNzVMUFRIdWpCTmtmWU9uOVFO?=
 =?utf-8?B?Sms2TGRmbTVnTS9FN1RaQVRkMUxSK3BsYUNZZzd2R2EwWEdSSEdYTWtjWmJu?=
 =?utf-8?B?S2tWdlZxN1MzZ0RXVmNFbVR5TERjVThRZDFJN3NVcDU3aDVCc3BwUHhadXJE?=
 =?utf-8?B?SUhCZjF3R294TzVFL3dlTjdjUThmaUwyaEtKOHN2VC9KNzFkTzRFMUVIVmQ4?=
 =?utf-8?B?YVowSFFqNmgzSlkxNUgydUdVVkMvMGRiNXVDR0k1a0dmU1lzcHJEbHVWTXE0?=
 =?utf-8?B?SFM2STFUYVNHVVVCYXREbnRWNlBDMm1WREkrOU95UGdUeFMzTW50cVl2VWtB?=
 =?utf-8?B?VG9wejJmb1oxNEQ4eWRtSlRRNkdQSUc0cEQ0enFhaWpnbTd4ZEJoaC9tTnNE?=
 =?utf-8?Q?uFPw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36C0A51E9DB13E43A57DC95DD9155A2D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 423de4c3-9b91-48d3-2be7-08dcec23232b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 07:38:03.7350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lHJmjmpVTGNS5Po5Vblj3pFWkNLMR0f4PBnRv8r0SNgbT8EwtLy0QW/L9S/opbfA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6639

T24gMjcvMDkvMjAyNCAxLjUzLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+IE9uIFN1biwgU2Vw
IDIyLCAyMDI0IGF0IDA1OjQ5OjI4QU0gLTA3MDAsIFpoaSBXYW5nIHdyb3RlOg0KPj4gVGhlIHJl
Z2lzdHJ5IG9iamVjdCAiUk1TZXRTcmlvdk1vZGUiIGlzIHJlcXVpcmVkIHRvIGJlIHNldCB3aGVu
IHZHUFUgaXMNCj4+IGVuYWJsZWQuDQo+Pg0KPj4gU2V0ICJSTVNldFNyaW92TW9kZSIgdG8gMSB3
aGVuIG52a20gaXMgbG9hZGluZyB0aGUgR1NQIGZpcm13YXJlIGFuZA0KPj4gaW5pdGlhbGl6ZSB0
aGUgR1NQIHJlZ2lzdHJ5IG9iamVjdHMsIGlmIHZHUFUgaXMgZW5hYmxlZC4NCj4gDQo+IEFsc28g
cmVhbGx5IHdlaXJkLCB0aGlzIHNvdW5kcyBsaWtlIHdoYXQgdGhlIFBDSSBzcmlvdiBlbmFibGUg
aXMgZm9yLg0KPiANCg0KQXMgd2hhdCBoYXMgYmVlbiBleHBsYWluZWQgaW4gUEFUQ0ggNCdzIHJl
cGx5LCB0aGUgY29uY2VwdCBvZiB2R1BVIGFuZCANClZGIGFyZSBub3QgaWRlbnRpY2FsbHkgZXF1
YWwuIFBDSSBTUklPViBWRiBpcyB0aGUgSFcgaW50ZXJmYWNlIG9mIA0KcmVhY2hpbmcgYSB2R1BV
IGFuZCB0aGVyZSB3ZXJlIGdlbmVyYXRpb25zIGluIHdoaWNoIEhXIGRpZG4ndCBoYXZlIFNSSU9W
IA0KVkZzIGFuZCBhIHZHUFUgaXMgcmVhY2hlZCB2aWEgb3RoZXIgbWVhbnMuDQoNClRoZSAiUk1T
ZXRTcmlvdk1vZGUiIGhlcmUgaXMgbm90IGVxdWFsIHRvIFBDSSBTUklPViBlbmFibGUsIHdoaWNo
IA0KYWN0aXZhdGVzIHRoZSBWRnMgYW5kIGxldCB0aGVtIHByZXNlbnQgb24gUENJIGJ1cy4gSXQg
aXMgdG8gdGVsbCB0aGUgR1NQIA0KRlcgdG8gZW5hYmxlIHRoZSBtb2RlIG9mICJ2R1BVcyBhcmUg
cmVhY2hlZCBieSBWRnMiLg0KDQo+IEphc29uDQoNCg==

