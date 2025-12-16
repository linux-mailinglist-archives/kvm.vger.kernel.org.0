Return-Path: <kvm+bounces-66060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D36BCC0B7F
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 04:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DB0C3026B1E
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 03:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACAE30DD10;
	Tue, 16 Dec 2025 03:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WTT281aH"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A52435979;
	Tue, 16 Dec 2025 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765855783; cv=fail; b=fbkQLOwurmmtS8VhDHkDeKx/rgehU096ByjmnFbH/GjlvlKCnXA3cGw187zmyrDIyrGr/xHr6QUX0jLU3wd/QuFbGeraOGEH4pFP96W6hGVvcR1vOzu205BIqH5/8B5JKhdSegoqHIof3Lwg58IZGMHbWAFo4D77i24HTiYerR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765855783; c=relaxed/simple;
	bh=knfJiYckeHk4tTT8QczpqOuVADdyf36xcWM/z23h5zg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HRMhgWPHPBuqRuYhckZxGBj9BRRQJGAnrT1JUbmtrfVvrrzvWZTQVCc3u9ZDYyV8osr269x8jtgpvN1RSNusTJGiaHcZyIMSFQTrNELobcIgA+B3DrN8dWos6aT3d7JVPwaJDdxlI8XeDeKuJtS1PiUEEFuGplN1BPtZGAdx41A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WTT281aH; arc=fail smtp.client-ip=40.107.208.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvTrkvgnFs5/QoEXCy6gLQxxjJpE8OT9WaRoA8PQNlxGB6jb5jrsIwKP7/rY4GDMWhOMPSgIwyqmu0se3k+UEMfCqFUrl9fonnxnliY92eAHzlPouZJG/Z9mGdtGJ98y6Jhu8KYRXml1byJxqBGsFuHQB4YuovajNHhP9bmBiBp8L4afMVFT92gY1bUfoNeuacOPF6zitAp9pxkYOlRmq/ZTjR5nyAu5xQq4OwLj3YCjCe/onOOsGvsEVpmAHu/a6CWtvDsnnDP0a8rNoZt95I3i/W3cHpWgqjGl9oXrP9IJ8pT/0koqDL66xXXA7G9yx9/jhRAzKPjKTKz/Ns6/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFi9/lgAH9Nv8NljfhPO2NDR/MJmWe1hRTv3vLOPvko=;
 b=ppGajKhuWROKIdHz2Se6zh4iO4T050uzhlfoUqfoSahqYNa4o8bbahz4yblM+0a5dAVGFBrxfPmw07Q/M3zIvyfHuQpou4EQbv6kO6ZeoHCebi3rYk8H7f/23HS28RKTYpbYL0ISQtr0tA7JJ+lmfaxeNU3sftUqnKfVRRuGpG4lyT2oRYNaVMXQDrlSID8msCjXd1dCimcplskK1dIDl2MN8MPM4PWG0+W88evih+GNM2H950BRXScJ8Nna2bI1l8j7vyrzdY/7UAdgIqqzjiV8uMiTAh+DzfiOQParwSOKpv2amLRF7sOa7jEJVa779fA9t5fKqtwJeZ/pvNCnYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFi9/lgAH9Nv8NljfhPO2NDR/MJmWe1hRTv3vLOPvko=;
 b=WTT281aHTs2aXYXx+8aY+UBOUMEnWM0YOJ558OfZaxlAKpUHa67t7xKhBFefwvDePVM4Sy/cYsxSNKYEtva4E5X/MSTG4lWrl5Vg9X+Je+RRYNg9UTgj4SLYlEZQH2ngiJO8fIRs2BtXqjvUj6CNOPCWlMQLDB9DrIaOi1udjLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by PH7PR12MB6693.namprd12.prod.outlook.com (2603:10b6:510:1b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 03:29:38 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 03:29:37 +0000
Message-ID: <3d12c060-f794-417f-bcf5-4f549ea00f02@amd.com>
Date: Tue, 16 Dec 2025 04:29:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com,
 seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com,
 liam.merwick@oracle.com, david@redhat.com, vannapurve@google.com,
 ackerleytng@google.com, aik@amd.com, ira.weiny@intel.com,
 yan.y.zhao@intel.com
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-3-michael.roth@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251215153411.3613928-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0066.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ce::15) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|PH7PR12MB6693:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c47b242-f75f-432e-e729-08de3c535706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTlqdWxDY21EeGl6Q2NMczdSKzZvSXhkcTdpT08vUnNpUWdUZDdueEJ3cWQ5?=
 =?utf-8?B?dG0yUG9SdWk3VE9GMG1MVUtaY3h3Qm1FSWxBbHFaL1I4U3gxMUNFc1lIcTZG?=
 =?utf-8?B?KzRBQWY0N3BkMmhhaEU0ZHVMSGtQZ2xSeXZVMnUwWWp4UmJ0aG5WUzRTMmEz?=
 =?utf-8?B?clJDbVY4WVVqTlo0T1czT2U4TnFveC9wRm1INm9GNWEvWTJoajB3amdwMlpx?=
 =?utf-8?B?aHdLTzRneEtqbmk4UXFoaldKczdjOFJERzU2Ni8xdDRKZkZ5L1FicCt3RzRR?=
 =?utf-8?B?MzE5eEtFcnVtQ01zVkxPYVNaTWZIOTBlb1dzQ3lOZytITENwL0NSbHVnNlBM?=
 =?utf-8?B?K1RkQ0FpQUpPRkhNdzFYQzNVUHI3TGtRaDR1RGxSeXYxT0NKd2Vjb3g2dHlL?=
 =?utf-8?B?djhhWXdhRi9Pa2hDVUdhZFNvVDlJUll3OEt1RVdYbVNhOThVc3lYcUhNdFp2?=
 =?utf-8?B?SDdtUE9YcVcxRHUxYnBoNDVZK1g1WDdma05sQ2JMT0hHcWl3anhKRHNFUms3?=
 =?utf-8?B?U3lQMFkrMFRubENWcVJUYlBqU2E5YVNmcVlGQVRETGgxTnk5aU9JdmlDSWNo?=
 =?utf-8?B?by9zbG9VaTlnZEduQXFwK3h0ejdWdTEveFlMbWMwNDNldk5QV1ZjSWgwcDI1?=
 =?utf-8?B?cWRSMTFiUGpHbEcwdjM0WStyVzFraTNUTTRTVnJhd2J1dVowRncwVEllOTZI?=
 =?utf-8?B?YjI4bEx3aDE4dDdaY2NoZlU5anBXSlNtTXNwMzJCME92SC8ySVByYkIyUVYv?=
 =?utf-8?B?Zk0yM2l4UzVZZG95Qy9tSitsTWpRaDBhTHpEZDY4MGRqVVlYMDJGMDBaa0Z1?=
 =?utf-8?B?bm1LNUZnT290alErTjJ5M1A2Y0lYRVNwSlVTK3hNWWtaZTQxeHg3cUZTZkht?=
 =?utf-8?B?S2FIQnM1VHl5Tml6MHJITkdtUVdEa0JBOTZnRDdMZ3hUdFZVcTA3Y2FjOUFR?=
 =?utf-8?B?QmpnY1RVMzQ4Q2p1ZFgrVS81eDFUVXN0T2N5clcwczRGNTFrNnR5cXhFeWY4?=
 =?utf-8?B?d01xU3gwcDlHbTBNaFh1V3JyOUpFTm1hVHk3NkkxNHZWeGQ1eGI4Wm1NY2o0?=
 =?utf-8?B?NWNyZEM5eXl4eEtqcTEvTU5TQ3pQdEJYK28raTdhL21yUnZjV1hOeGlKaFYy?=
 =?utf-8?B?Y3NXVklKWGhQTFVGZVdVVzY3dnhyOGdhcCtVLzZHdW1NV0xDd25yQ0ZuUVRG?=
 =?utf-8?B?cG9kUWduclNBRUZSY3hmOVJLQzJDTDJNRGlrTnE3WiswOW9ENVgvZU80OWY3?=
 =?utf-8?B?V1JJYUtiK2NuckdXTkZPYlFiU2NDT0EvbHNxRmM2aG15MzN1aktxYU9rOUJY?=
 =?utf-8?B?UVk2TjgxdXZ2ZUpTVFRiZGdFOUdRTEVidC9yK04yR3kzcVNFT3VYMmxIaW53?=
 =?utf-8?B?UDZ0aFdCQVdRN0hSSjZMcmo3eWtYd0p4bWdVS2hXRGFMSTlTM0RTeEthOGN0?=
 =?utf-8?B?ZW9UK2lWLzFObzlXdFV0MGFJUHdiQ0ViUkhyV2FsNEZkbnkxTVBuY1haS00x?=
 =?utf-8?B?VUVFV3VhMTJVK0NFcmtYUXZPa0FwV0w5NjR6bWpNOElrTzNZbVdHRVVHb281?=
 =?utf-8?B?SDRwbG1XSjMrOEtkN3BEalFFSXZGcXE4NE1LaVY2c3d5SC8ycm5qeVRZem11?=
 =?utf-8?B?Rm9yUUd1WmliWDRBa1FKT2pRejVtRFAyWDNWeC9mTXN5Z1liT3poU1NSaUpN?=
 =?utf-8?B?QngzaGo2dTFzcytiUmhxVW9kWXUvOVhCNzhWNHN3T1JPMkIxdjQ1WUJnb3hB?=
 =?utf-8?B?R3dQOS9IQnZWK3JjUXVJdHdUTUY0S3FKOEVIekt0akpnTjZDajVjV3g2bmZJ?=
 =?utf-8?B?cmVGQ2c4UHo1ZU8xOTgvYWtHSlM3SE9SazFEbjcydHVDL3A5dEpZN3lPYlpG?=
 =?utf-8?B?czRRNzZ5c0lGblVWRTNQbUd3WXo4RTFCeGF2YUsySFR4bHpTUDRRUk56T3lw?=
 =?utf-8?Q?ad6aiHa4KFZi7xx7tUBgS9Mx3Z3NIuZA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alpRQlg4RkxXQ1YxVngrMzc2V0pqamdZeXJTam5FaDUxVVhUUXJoaHR4Z0Nx?=
 =?utf-8?B?SWpTeEk3ODhMYnlvVnp2eHJlaTdwWm1UVlg1b0NIb1RBVTJaUEtGUVB0ZWUv?=
 =?utf-8?B?R0ljZXRtYXFWNTI0eW1vZEtQZHJmbnNiYko4TEdvYStZT2c1bWZOeVVtMHR3?=
 =?utf-8?B?ZjB0ZUVBZnoyWWtmbVpkWWwyRVJOaEJOTFRlYU1NM0hBVnU5SGRpS0drS0xD?=
 =?utf-8?B?MmxNemt5eVc4VUZicWhLZXdjbzRFbjhRcjg4QzZVbnFXcGttZ2lTd0UrREhE?=
 =?utf-8?B?NHJUdnRGa2JRMG9wVWZSOGlVSWJMQjdlZU85ZVZoNHdHdGc3WUxwVGQ2QkpV?=
 =?utf-8?B?NnJLdnJHSnJ0a3lnQzF5c25xczAxYmlwVThzNU1BM2pCVDR5S2hySW51VmFD?=
 =?utf-8?B?NHlyclVwUjF4dDdERUNNY1ZpSWRRQVUrSUthc0gxcFFnT2NXVTBPcjRSZ3hB?=
 =?utf-8?B?OCs0eHRwT1FjclNpWDg5ZkRQUmljeVJVVlVsYzNFVHI5UVJBSzhSTXlwLzVo?=
 =?utf-8?B?bUxqOWpVUFN1VG93UUxYTFFCcSt2VXpLUS90UW1WajVIQm84N3ZQVkZSaTN6?=
 =?utf-8?B?SWZpTU9jN2dieC9NWm9mVTVxVHlacXJvdW5iWEJaVXJZUnNVWjhhb0IyZHpp?=
 =?utf-8?B?dWVtVG1UUU9zOElvbU1YQ1ZETXFQZk9tajZxa1I4eXlvdSt0RnRkcXE2dG1j?=
 =?utf-8?B?aFNSZDhRVVJNTHRMa0xTcjFHRTJuOXlSemxvR1VBZ3c3REpMdHI5RjhkTjhW?=
 =?utf-8?B?TklUQ2RYb0RhbjZXMHZXL1k1Z3NmZHJFQnlEZ21nWnhTSXQ4YWlEYTdlWkFz?=
 =?utf-8?B?ekxiRGJ2UjZIQjFMVzNBWHZwbUhvVGhGN3FEQ2VsaUExbGlIQU9NMXo0ck42?=
 =?utf-8?B?a1VTTmZ3NXVBcndWVnA4bWMvVHlRTXI3bi9XUFA3RE9jUis3ajJ4RnRyRm42?=
 =?utf-8?B?dnNVMGdZeXhGUE5meHI2TDRQT2FWbGtnOFZvaG1lNHArSEdkMlJOQ0diTmJh?=
 =?utf-8?B?TGpCdjE3eGgxSlZBR3g2MXlKWHMyeE9MSExLU25jYXRQSmVwbzZlNkVFc0pC?=
 =?utf-8?B?QjlvNkRKTmJLL0x0djRvTVNkQnBKYkR5akkra1BxV3RZczhMU0pwdzlzK2ZN?=
 =?utf-8?B?MmVlVFhLZkRyREwreWpOV2g5d2MzZStRbmx2emxBQ21tUnFCbUF1bmhCNC9n?=
 =?utf-8?B?aWNrOStBVmIzQ1ZXMkJRSm5MSU5LdElyRENEZHhBYTcxSjhpL0I3ZUxoYm9N?=
 =?utf-8?B?bCthcWttQU5BSmszUnlaaGN4MU4zV21GTk5qRExqN3paUlh6d2tiSWpTcVkv?=
 =?utf-8?B?QnBGVitJMFcwSG41NjZoaFMxZ1RwQ1daTFR6T01WcHZYaXIwbHJPaXgxeFBH?=
 =?utf-8?B?UGhyV1I4cVN3My9maEVMRjRqWWxNWEZtaWFsU2dzVllZTi81Mk5iWjFOVGJY?=
 =?utf-8?B?cTg2MTdVd1ZFdHZGSi9TU1dKZ2I1NzIwbFBRNGZUQ2d3MytEbC9MaVdHTTVn?=
 =?utf-8?B?K0Eyeks1bXhuR09rTGQza1BkSmpDamxhb1RjU3RoSmZ4RlBFUG9rN2FYTTJz?=
 =?utf-8?B?RjVsRWlQbzR2c3JOMFNEVmR3YlJsdDZKL2tNaWhiVml3QjRDSnc2VGJnckFL?=
 =?utf-8?B?UHZMUFJnbUcvNkFGcEpxZmFjQzg1RXREaWliTEQ1ZzNGWlZvZXhPcnlYUk15?=
 =?utf-8?B?Uk5DZURHdklNSXBmL2t3SnI5TTdMRzFiYkdyQWZFUUFOeDJNVU1kUVdoNHR5?=
 =?utf-8?B?V0VmZklaTGtHM1dqR2cvRUhYMGVWWDg1L2Yycnd5RmlONXY4WFo1Njlkbnpk?=
 =?utf-8?B?SUNxYmxoamhQOGRaQmlQR3Fqeml1VnczR2NIM21FYWd2TXROSEs5Nmk5ZlY3?=
 =?utf-8?B?U3c5SFNJSXRZSDAwcUR0Ykx6SG5ZKzdKQjF6UXVJcjNCU1hFZEQ1YnVHYi9Y?=
 =?utf-8?B?eXM2WWpUdlgwSXpzY3djK21BVVVETTlpK2Q4UWxURE1IbnFIRmhERko2eER6?=
 =?utf-8?B?S2FRd0dGcjFSNXlJckhjTEdkZFpFQmRMcW1uNHBYTjlZMWJlTmczZk9UWFNt?=
 =?utf-8?B?cDdqTkhMcmZUemNPMXRXRURYZ0p4c2FjM1BGUUJ4REpEUXdVakdnSVhGWEM1?=
 =?utf-8?Q?f93mfM/FhVTQRReioGs4VHVxW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c47b242-f75f-432e-e729-08de3c535706
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 03:29:37.6738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //Xx56nAiByWB4TTNXTvqqEqWVyAKwJzOewAdXVRvyPoa6O5T0mKVgtIryY7GAK8+f2UbNJ9QieCKZ+RCLJ55A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6693


> guest_memfd currently uses the folio uptodate flag to track:
>
>    1) whether or not a page has been cleared before initial usage
>    2) whether or not the architecture hooks have been issued to put the
>       page in a private state as defined by the architecture
>
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
>
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   virt/kvm/guest_memfd.c | 44 ++++++++++++------------------------------
>   1 file changed, 12 insertions(+), 32 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9dafa44838fe..8b1248f42aae 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -76,11 +76,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>   	return 0;
>   }
>   
> -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> -{
> -	folio_mark_uptodate(folio);
> -}
> -
>   /*
>    * Process @folio, which contains @gfn, so that the guest can use it.
>    * The folio must be locked and the gfn must be contained in @slot.
> @@ -90,13 +85,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>   static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>   				  gfn_t gfn, struct folio *folio)
>   {
> -	unsigned long nr_pages, i;
>   	pgoff_t index;
> -	int r;
> -
> -	nr_pages = folio_nr_pages(folio);
> -	for (i = 0; i < nr_pages; i++)
> -		clear_highpage(folio_page(folio, i));
>   
>   	/*
>   	 * Preparing huge folios should always be safe, since it should
> @@ -114,11 +103,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, folio_nr_pages(folio)));
>   	index = kvm_gmem_get_index(slot, gfn);
>   	index = ALIGN_DOWN(index, folio_nr_pages(folio));
> -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> -	if (!r)
> -		kvm_gmem_mark_prepared(folio);
>   
> -	return r;
> +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>   }
>   
>   /*
> @@ -429,7 +415,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   
>   	if (!folio_test_uptodate(folio)) {
>   		clear_highpage(folio_page(folio, 0));
> -		kvm_gmem_mark_prepared(folio);
> +		folio_mark_uptodate(folio);
>   	}
>   
>   	vmf->page = folio_file_page(folio, vmf->pgoff);
> @@ -766,7 +752,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>   static struct folio *__kvm_gmem_get_pfn(struct file *file,
>   					struct kvm_memory_slot *slot,
>   					pgoff_t index, kvm_pfn_t *pfn,
> -					bool *is_prepared, int *max_order)
> +					int *max_order)
>   {
>   	struct file *slot_file = READ_ONCE(slot->gmem.file);
>   	struct gmem_file *f = file->private_data;
> @@ -796,7 +782,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>   	if (max_order)
>   		*max_order = 0;
>   
> -	*is_prepared = folio_test_uptodate(folio);
>   	return folio;
>   }
>   
> @@ -806,19 +791,22 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   {
>   	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>   	struct folio *folio;
> -	bool is_prepared = false;
>   	int r = 0;
>   
>   	CLASS(gmem_get_file, file)(slot);
>   	if (!file)
>   		return -EFAULT;
>   
> -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>   	if (IS_ERR(folio))
>   		return PTR_ERR(folio);
>   
> -	if (!is_prepared)
> -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		folio_mark_uptodate(folio);
> +	}
> +
> +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>   
>   	folio_unlock(folio);
>   
> @@ -861,7 +849,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>   		struct folio *folio;
>   		gfn_t gfn = start_gfn + i;
>   		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		bool is_prepared = false;
>   		kvm_pfn_t pfn;
>   
>   		if (signal_pending(current)) {
> @@ -869,19 +856,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>   			break;
>   		}
>   
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, NULL);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
>   		if (IS_ERR(folio)) {
>   			ret = PTR_ERR(folio);
>   			break;
>   		}
>   
> -		if (is_prepared) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			ret = -EEXIST;
> -			break;
> -		}
> -
>   		folio_unlock(folio);
>   
>   		ret = -EINVAL;
> @@ -893,7 +873,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>   		p = src ? src + i * PAGE_SIZE : NULL;
>   		ret = post_populate(kvm, gfn, pfn, p, opaque);
>   		if (!ret)
> -			kvm_gmem_mark_prepared(folio);
> +			folio_mark_uptodate(folio);
>   
>   put_folio_and_exit:
>   		folio_put(folio);

