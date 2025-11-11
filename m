Return-Path: <kvm+bounces-62711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7E2C4B8E3
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 06:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE185189252A
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 05:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12FE2882B6;
	Tue, 11 Nov 2025 05:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GXFueeCd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F74277CA4;
	Tue, 11 Nov 2025 05:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762839625; cv=fail; b=FgfAm4jRaZ4cQuHCjSbwP1GoffC3Rqf6PQY8qSI4aBtYHUkr/XYS3UMQHzRas+kqHfcuPS3FVpCvHjeB+MDj1QNmjgO1tYMg+KmhyB0+lj/a54KrJd9ciEUuoQrGJyWh4v5VYuDrn3xGlrBjwbISI8bRu/FNiCyDis49XSZMbLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762839625; c=relaxed/simple;
	bh=rx2/jpj6A6S9oXSIwjuoA3XNWKntTbFW3mT4FOAIOzc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cAqWo3ngsHzKEZA9NZggubwXGZkhnslWwtKOqPVPpwboYK3HPrdnB8By/JpzvouWsp7xZR9P/CTCPQa7qV2SInYcsJp0VSGYDXA0USlMJE5Pef/QqNh0sLaIptdgTJ+SA5rrt+5/lu5ai+P8E5/HVttAol/ScBQb5S8citvwbqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GXFueeCd; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762839623; x=1794375623;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rx2/jpj6A6S9oXSIwjuoA3XNWKntTbFW3mT4FOAIOzc=;
  b=GXFueeCdCtTMQN5NgIn3xxD5dNLekFD8Q67ZfiblcxjRlURmhbbu/oB2
   +/jmH0sT2huwf4QClGLRxY7PR61XIs7eGijZirhxh+rM98MMck4twZ5KX
   jYRxT0+o9eTAd4QwjNnDBotDJepH1YhYETN6ljAn67RStjq5i2i5BGwcb
   2p0BXBS2IR9wFxK3eoEitnPaoA+1jtC1Av7gAppk+Yuj5wNxLnxjgsIM7
   0BRou1jcKe6RlIq/TvTl9gK16DbjnnzZrj7bugh50IhLxcHH8/cy05uDZ
   lgCVbJazedbSsCkcxevgYP0Y27sWR8WGxVHg05vPukgYKS7Q/18to2A6/
   w==;
X-CSE-ConnectionGUID: vkU5vSfUTpemHOE5+8SccQ==
X-CSE-MsgGUID: Qlll4pboSxy5SUVEqNJJ4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="75510365"
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="75510365"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 21:40:22 -0800
X-CSE-ConnectionGUID: TIwj88i+Qxah+u5vM0qK7w==
X-CSE-MsgGUID: XlBuFUF4SSqxBQTCRevWHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,295,1754982000"; 
   d="scan'208";a="189613562"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 21:40:22 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 21:40:21 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 21:40:21 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 21:40:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xlgYZOjn4JBuu7dXPFmcplGCfO2rVY/xUgAT4G94g81TNywQ9ycDEdxy5yTzq2dtVRvpr15hqJcNr4CXLikKML+VrIOFL8tr8Eo0rRnPkicUzVzi6SsRvu5oDsb6j5M4F51dNFy/86KoEjgW5KyACdBaG581gSDthFVtt8j3t//sib4pr5vCqS3LUb+JLpt/q5KnWdbZ3vZtO+TxaSt84Y/MjpZIXLiDAWOgrGYtxWZX0fewdkUI9+3VNRDFDSyuX53YTO3lMPTFgFFESGuBJAxgljVEC+Tjj5LeMgqT0YPbkmHLicdKYi0rSgdwsnn8Ae4KeZ7BSf4uB+1K6cqq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OeT9Lf/8cpYThMf+TD2FBB6TNEndJSRjO1mePx/F3Y=;
 b=bOjBqxZn2GtBiVVopT6+Ziaq/Mw3fFlWNlLYUy0dk2BF6Wr1MpQvC5Yy2Y44lXIS+848tB+/a7VB2MX++r4z/RSdWK7gPlJX24rrPkbNSkw2NOnu/L9J1ieFO2+DDR8bHWifOpel/j+vs9tL/DoxisixmM6aVvvzFUllaZ1Vt79ZdLxS0a2hF0r/ECbqxHZkvXKtJUwf3pw5mKSAp1odCOClHNeEXkHF4letB8ioRiltKxS4OFy553zp/nUYyNfaeemdSRAUtUHlBaU2Ajc47jsB7+dKeoCyXGvPpe44E2ocI3D5rSk1PvVTBbbFxsm4F9WMHBMpWgIAZGkAcN1Y7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 05:40:19 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 05:40:18 +0000
Message-ID: <2701ea93-48a6-492a-9d4a-17da31d953c2@intel.com>
Date: Tue, 11 Nov 2025 13:40:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: The current status of PKS virtualization
To: Ruihan Li <lrh2000@pku.edu.cn>, Paolo Bonzini <pbonzini@redhat.com>
CC: <lei4.wang@intel.com>, Sean Christopherson <seanjc@google.com>, "Jim
 Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, kvm
	<kvm@vger.kernel.org>, "Kernel Mailing List, Linux"
	<linux-kernel@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20251110162900.354698-1-lrh2000@pku.edu.cn>
 <CABgObfZc4FQa9sj=FK5Q-tQxr2yQ-9Ez69R5z=5_R0x5MS1d0A@mail.gmail.com>
 <dh77d4uo3riuf3d7dbtkbz3k5ubeucnaq4yjdqdbo6uqyplggg@pesxsx2jbkac>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <dh77d4uo3riuf3d7dbtkbz3k5ubeucnaq4yjdqdbo6uqyplggg@pesxsx2jbkac>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ0PR11MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c24d64f-2b16-4a2a-93af-08de20e4cc73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WEV5MFllS01GMVVKbkZkL3hxWUp3SmNsS05nc1lsZS9yZ3dKUFY1L3BEZHNR?=
 =?utf-8?B?ZWFzZGxjVDQ4ZDFNS2NTUTg2RUNMYThFdm8rRml6TDZyZmgvVk5nc3hpbW9V?=
 =?utf-8?B?SnRaVXpTMXBhcS83cHpJdFRkYTZBVWt0N0lLWFFYbkZ0WnhReWxyYnpMMjF2?=
 =?utf-8?B?SDdqSm9BV1VEcDBPMzJnY2R4Tk9vOWVDVHY3T0dlNDQ2UjhLRFVEeWphVkgy?=
 =?utf-8?B?N1VQNC94VzJ2cGE4QkJOOC8xSThzYlBKVDJoSU1ldGJQUFFXZEdQeXc0dkNm?=
 =?utf-8?B?UEtDNlNuS2huZk9PU1YxWXZKUnA5bVVaWmY4QUY1cVZNS0hkeDZhQlphWENn?=
 =?utf-8?B?SXpjQVFFdUxkM0NsN2JONWVTRE5FS0JsR1BwaWpsY3VURjlMYVZaVVhPNXJj?=
 =?utf-8?B?MkVGaHozdTNSaStKbUtHRlhsY2huZlpaOXZMbjZDdGxhWXlhYzZ5eHFNTlRC?=
 =?utf-8?B?NTFpbXVsOHlOTzRkMGRqOTVHeWd2VlVndnZwYSs3c2N5cERRT1FHUWRlSkl2?=
 =?utf-8?B?aEFHb2hUV1E4d0lHQXgveTNPQW04b3g5eWNxdjdQRzYvbTBCWmhBY2lkY3lx?=
 =?utf-8?B?S2Y2YmozWStaQjcrdmxmLzdqRmlmY09ld0Vza2dQSXZ1K2luSFh1K3JOMDRh?=
 =?utf-8?B?RDNCRFlObVBldkkvTzRxVXhlV3U4dWo3VDdQeGk3VmxXaHVDRnVZQjVnOENm?=
 =?utf-8?B?blJkZmNLNGV2RElrQXFDaExPdDhvQXRCbjNzOUJ6VnBjTW1PV1ZGL1BWcnFJ?=
 =?utf-8?B?aFc3UnI4YXMva2VwWEI1dDU5SHhrbWhIM2Z0RGhJZUo5L1JJYTVBbXF4RUhh?=
 =?utf-8?B?c0tGeXlRZ2xWM21pQ0dXVWx3MTlpZG1qeld1K3VMWnVaNG8wd1hITGx2TTlh?=
 =?utf-8?B?VlZ3L0NBVDFFQW5xOHVvZ3V2OUcvQ2pXazZ4b2JpU2lScHlMTnRLL0JWZXk1?=
 =?utf-8?B?YjVwc1B2blVSbGtDWTYwNlVVaUYzaHRGcEo0VzJNTy9oakJPRkdUWXRncEdK?=
 =?utf-8?B?TFdTUzZzUHBmaEdZaGJVSWNwMEM2VGFObm5hd2hlY1JHTjhPY3dZUVg2V2Jr?=
 =?utf-8?B?U0I5U1k0ME5wMnVIMi8zMUtqQ1k4TEZVQ21BaWovNWpHNUkrSStuOXhWRXcr?=
 =?utf-8?B?b2hWcWhZcGF0VUR0NGhyaFRnaUN3N1J3TDVwN1haemVBL3ZTWklocHJtUEpE?=
 =?utf-8?B?QktMK2VzQVRLYW9CZm5jYWtEOTVlaFZ3enUxNDdPZldMdDNNbWZtd0VMRm5a?=
 =?utf-8?B?YkJ3Z01pVlZIZGpPZUR4WXVZR0RWVk05dTJobHpVVkMyVWdmc0V0TEVjZmc3?=
 =?utf-8?B?Q1lWMDBTMWxTZTRQcGd6d1hTc3JDUTd2TFVycmJGV2lQeFZ2dDRZOHV6VmhE?=
 =?utf-8?B?UEEzclhsZHA4cUo2MVFrSTFQcEZHZ2djYXNXaEZjdlpkZDJpVWhTRkhJT1hl?=
 =?utf-8?B?RmxlYkg4OHFrd3NYcFRWc0Y2KytSSjVVdGVtNHlKNkdySWlRaGRYc2N4QWZQ?=
 =?utf-8?B?TGRRYUtVWVhFT3hMejMvaGhIWllRQUQxKzhjNERwcnZJa1NxaVJaUWdTc0RC?=
 =?utf-8?B?aFZLV2NEdVhyb3ZmN1IrZ29tSHlqNlBTY0ZtZXRUenVFY2tFQWUrc0tpOUhn?=
 =?utf-8?B?QXpvYXRpVHdQRE5qSWZqekdOUlFtbnYwWkNmKzNuczFMOS9Ya2M2MUxKaWEv?=
 =?utf-8?B?Y3ZSWlNvNVptVzVsRTgxNE1oWUVUUkdSdWRod3dnbTJqeUNmMDQxaXpnQzNZ?=
 =?utf-8?B?RXZFR1Q3M0t1aHNpYVZyeG1hQXRNL08wVEd6VEgxb0lxaUhkbXNXc3d4Ny9X?=
 =?utf-8?B?TW5OSnVtOE4zR0wxY2ZQWTVpcXEyVlNzVGtwWlNkNWNGVm1jUUNaZEFrZFNC?=
 =?utf-8?B?VEl1QTJrY0QvTlVaa1Ezd1I0Y3V5M1g2YzRlWVhHMTExd0pWWU55RUZZclJp?=
 =?utf-8?Q?zIfjDqKWOEkKEzUTasWP/TuJMDfwVWpG?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFJEa045V0NuRndLK1dycUZ4OFdrNjFLdFAyd09EOER5eVAxL01VR3BHcUVv?=
 =?utf-8?B?VFkwNTBOdTEvd1VpbEpyc1dNTE0vY203OG5QdEZYeW5WUzFEc01zZExDYkRi?=
 =?utf-8?B?eG1lazBXaFRXVXNoUTJ4N1ptb3JJalBndVVmT3NLL3AwdzN2QmNWT0tkUHVX?=
 =?utf-8?B?cHF5cU9NMUdPNEVCREswdzlQb21BTmRub1k4SHdJcVp3YzVGNWVuM3Btdlpo?=
 =?utf-8?B?b0YzKzNzNWZvTmVwMis4ZUFCbWtlUW5ZU0g4RlVMMEh6NGFkUDYyaFdGZy9Q?=
 =?utf-8?B?akNSRExVeGdVNVlkNG8yTDI4WFEySFpDcER1YVpIa2dLamhHNlJXVUR4VndF?=
 =?utf-8?B?Ti9QT0xOR0FsaGhGZTFJQThvQVQ2bk9ycFJ4Mjlzdm9ZQVgwUFExSEJzdmNL?=
 =?utf-8?B?SmEvTCt5b0tPa0hPSXJWaDNMM1QyTWptam5kY0NFUmlKUWRpMEVhbjZUYStT?=
 =?utf-8?B?bllSeXNjenUraVQ3dzl2WkxmMm1SdHU2OHZXdkhlUEhmMjkxKzhmV0txUTBQ?=
 =?utf-8?B?L0hid3VhdUJ4V1oyKzg1UlYwT25Ca1lPbHJjMHlOUTNQWmFJQzM5Nm1yRXB1?=
 =?utf-8?B?RHVnZmVCby9GcXk4L1dZdDFaa2pyc2F5cjdTaldzVDVMQzFoaWkzQ1JkbTRR?=
 =?utf-8?B?SDNNanE2eHFZVTJDZlNBcHZucVNmY294UDNyblJIZTk4ZUdjM2EyNU5EcGNv?=
 =?utf-8?B?WDJMWGJlWHEvNzU1OVRzRHFjS3NHS00vczdrQWQ0NUwrQ0RhbzN5RFByRFJr?=
 =?utf-8?B?UnlXRFN1anIrc0VIRk1NWHBQNXh1dlg1NjV0clBuS3Y1TTY4R1V1V01KVHlZ?=
 =?utf-8?B?RzllTm40UXcvQ2ZpZUNkQy9sV0lsMXdJUzc5alBOU012bjJUc2hlQkY4SUhz?=
 =?utf-8?B?TUYwU2wwNHpUSlFWcjhUaEYzMStyYWtxQ0JJeVo4cGJpMlFUL1IzVTN0TUN5?=
 =?utf-8?B?dnl3TVZxSmRYNmhQMlBoSmljMWluenB4MWIxOTJHVG5VZE1GbmJNejY5MUR4?=
 =?utf-8?B?OTJaZlJrWEdBNDk5MDRtTUpueE5UblJJN1pWeHIyKzJOVFA2MXRFbU9lelVD?=
 =?utf-8?B?NElxSVJNUmh0dDJTZHdydnZJTW85RVRXYTZqVXRwZG05RmZENEQ5NkZYKzZn?=
 =?utf-8?B?d05GQm83bmR5SnROblEwNzFZQ0pnQVVkcStsOHM5d3phT3IyMW04YllFWUVI?=
 =?utf-8?B?ZXFmL2s1ZE11ZXlaQUJNVUlOTzZCeXFKVndNU1VtaDlyYUVTTDIrWXo5YnhW?=
 =?utf-8?B?aC9XdlpJMUNZQVlwWUVvQ0QzNklHeTdBYlpncEJoWE54N1J2NE95V1VVVjg0?=
 =?utf-8?B?bTcySzBxTmZKZ3Fua2tQZ0ZEWFNWSlZqODZoMnRBc0FiZ3RIS0c5SDJoMkhj?=
 =?utf-8?B?czZiR0VockI3ellrVGkvbFMraEZuWW4reDEwVFQrWWJzbUJRTTlEbysrRW40?=
 =?utf-8?B?RFdWWEY1aldoN2V2ZllrTEF1MitrMzRWdVFLNGNQdk5VY2J6VDFHKzhXT2xS?=
 =?utf-8?B?eEtPK3hJTjY3ODBHRm1HaWk2VEhNN1JlZzN0MGhmemQ3UjhORzJXWXpYejk1?=
 =?utf-8?B?YjlBeUJlSFZkUlZBZzBycGxlaUpCQmE0K3JSM3RmVm5ZWmVPdFAxMFBUaGlZ?=
 =?utf-8?B?VW1SM215bHArTlJhQUtuZVR6NTlIUzNOVlFHdU85Q043RFI4YWFxaDJ6NGNa?=
 =?utf-8?B?QmZFL3dxalh4Q1JqVHVuL3kwcVNFb3hFRnJjN1pGdmtIeGd0b2VSSlNyWjVO?=
 =?utf-8?B?bjRKMUFSbXpiTXVPbzEranFZdytvczQyOEtOWVZOOVg5bThIUjNpZDlNQlFT?=
 =?utf-8?B?NzJIZGdxMzBlSldnVWIySGVpMExVaWIvbWVwTWNsVmloTUtDdStaOG1vaGJF?=
 =?utf-8?B?L2Q3ZWgxZzU3S3pEVjBqeERSMlZsVTU0RTJsOHFWaG81UW0yUjhzcyt6b0Ey?=
 =?utf-8?B?T0p0bE1NZTcydWs1cEdSUkZZUlgxOXp4ZEk2K1NucVk1UEtiNzZSSysyWFVX?=
 =?utf-8?B?NGxYeDRHSHplT0VldW9xMkhZelhOMFJxVXdMM2tieDZ1VzRKUCtiNGVURTJX?=
 =?utf-8?B?SytsRXFDUVY2V2gzc01xWTZYMk9GL1dFa09WU2w1R2doNmRoL2I2eXVpOUFv?=
 =?utf-8?B?S0pQYmZiY3RnSVlkZUZHYjdsSllQMTFibWUzM2hrd0hrS2c1am1UUWtzaWlM?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c24d64f-2b16-4a2a-93af-08de20e4cc73
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 05:40:18.9346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUPWXNwO0VXjVIThSu/dFQ8Kl4cRz/eFneH+5tyYXd7HOeIjwLv8BnrmJlDc+BSru7Ermp73p2OzWDjVFNDa9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4989
X-OriginatorOrg: intel.com



On 11/11/2025 9:14 AM, Ruihan Li wrote:
> On Mon, Nov 10, 2025 at 09:44:36PM +0100, Paolo Bonzini wrote:
>> No, there is none. In fact, the only dependency of the original series
>> on host PKS was for functions to read/write the host PKRS MSR. Without
>> host PKS support it could be loaded with all-ones, or technically it
>> could even be left with the guest value. Since the host clears
>> CR4.PKS, the actual value won't matter.
> 
> Thanks a lot for your quick and detailed reply! That's good news for me.
> Then I plan to spend some time tidying up my rebased version to see if I
> can get PKS virtualization upstreamed.
> 
> As a side note, I can no longer contact the original author of this
> patch series. At least, my previous email was returned by Intel's
> server. However, since more than three years have passed, I assume it's
> okay for me to post a new version after I have the code ready.

Lei has left Intel so the mail address in unreachable.

And as you found, we dropped the PKS KVM upstream along with the base PKS support
due to no valid use case in Linux. You can feel free to continue the upstream work.
But I'm not sure if your use case is compelling enough to be accepted by maintainers.

> 
> Thanks,
> Ruihan Li
> 


