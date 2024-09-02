Return-Path: <kvm+bounces-25639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 408EF967D4E
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B97471F21880
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 01:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762A018643;
	Mon,  2 Sep 2024 01:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XuKDtM0l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE97579C0;
	Mon,  2 Sep 2024 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725240282; cv=fail; b=sw6eSnSomO1fYNZYzm6e9M/NfS6m0RAbh7X8fijDWe9gzqj/BRvzkqSkHXP5IgMA+7sDwGEqlui6jUs4rq6UFtRP1hnLAdKkZsxLaZZ1N0QgYdRwKDue7mHowZQc53lMLyWDK4FJfqOeKFpz/xZjj5Q1z9bTg5ACemSuR/sYJfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725240282; c=relaxed/simple;
	bh=niFDqO2/JSCj4MQuEjW73iMd9ZXYInFjYTlyeAbscOA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rcbNnTtC9ZVwN+tBNl+BPEvTil+cvOBkbxeC+FzJyVzVGHWO+ixOlV6/tfd8upiipPr0/zuEY04UXToDI2MGqbEZN1qUPS5DmUidvJWdmQPD/poM9QoySUUvNQY6SiK3eJ1ofz/hxaI0/a0WmcUxo4yjEflK7Mws6Xxv13OGKa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XuKDtM0l; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kwG4jcAAG577oSLUfKXvMfs1n+vx8cn3jFspdH0OQIuEouqNaMSs9vC7p05uHZtT36bYr2lA3A/9mSBzEvcIr6zBCviAQ4m+E/nOkdvSwPyp3F+K7DBhoOVy4PXwSMf4j84dnYWuTbUzEyMzl3r2PkPZ3zdTiiVkr+YCX5+dGETm/cnpX3A7EFteYZccc+23ysa3hOh38BLyNVaJndKzWFwzN1Bfr5zjgcOzrDJlVwsRzoGKOL0yWUnBkNBFhAfjr/X+PDNPZ+oYuwDSCzuSr0Uea4vqhX28eQgLFaGSfS/8x3/8fFeTGZimmMP24ve1XeRH3oNhng7RMcY5p15z7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iH7i3r/x2Sb/uhvf9Dd6J1pokjC8kKwRNjFqoWSXRQ=;
 b=nrIPd599Ne0gGxBHBYyfKt9+YfD6DrXw5W9LpaNfyZyDn06xZHQS3PXNE6hAfCfLyds9DqdWAotsiea898nmZH9Xh8vKsA1pIGlCK8Ow60997uOlk5Izpw9lhkyL797vFENJeDUrOrapptQJWugNEvwM/av5QfmSjGzhYUeJYavlFYJ3vN4zLrSXZ20UGqBRcC5z7YmR9KBwD2E9ujf1wpS0O4bj7HCH6WXXC3PkTmSIauA932otSV/OtGLtG1dMzxzTB6jGtdrye4UfK1e9JUsW7BarWJrMn5g2enT9pusH9DLwTHF7CPh9uhbug0Eji4UHxEoV+eopukAnm9jv7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iH7i3r/x2Sb/uhvf9Dd6J1pokjC8kKwRNjFqoWSXRQ=;
 b=XuKDtM0lapi5iBFDOWfxLlamNsfYvLNGAfMoFEDBiVUPBOx8Y50isL4SpSAvCx9++cqfqXBm+nCw5bS4EJiuaCdM2uKqhrsV6FTQaBCyRoZgLA2tgYA+tqk1XuqMNDaa2MaJZVw92yPg1CVSFSnIjTHlJGCPHAVqwwewEo2BV3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 01:24:37 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 01:24:37 +0000
Message-ID: <e6780b6f-a641-4b1e-a3a8-9c506d4c358b@amd.com>
Date: Mon, 2 Sep 2024 11:24:28 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 11/21] KVM: SEV: Add TIO VMGEXIT and bind TDI
Content-Language: en-US
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-12-aik@amd.com>
 <ZtBIr5IrnZF4z3cp@yilunxu-OptiPlex-7050>
 <db05ceb5-d38b-45b8-81c9-c84c0d8fbd96@amd.com>
 <ZtFumVbgXf9RBNxP@yilunxu-OptiPlex-7050>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZtFumVbgXf9RBNxP@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0032.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::9) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: ae1cea59-857c-47e8-240a-08dccaee0254
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dForSVJvYlkyUW5OUUZVZ1JrNVBuYmk0c0U5L2d4bCs4UlNseVpQYlZtdGFN?=
 =?utf-8?B?M3VVb2p5cnlIayt5ZXV3bVFUWXVud1RLOENqQXB3L0VOd285RUlRSEU5RjJh?=
 =?utf-8?B?NTBhMlBxRWMxRDEzUDZCQkNSM2Q3TUpDcnY1Zzd4TytuamMxMFlvcC9Iakx0?=
 =?utf-8?B?dlhIUlJsb0U4Mk91Z2tGYnhhSWk3c2FqTDd6Y0UxcEFKSjRMbzNsQU8yRUpa?=
 =?utf-8?B?TmpROGlKMldUS3ZjZng3Wkp6T3IvT2pOT1pOTUNlOFNGNlJHZDJ4TXJ2K0Jm?=
 =?utf-8?B?YlAxYlpqcmFqUjI2bThINEJISU9na3dqWFp3ZWdQMG9KUjJOcnNsdXE4Y0Uy?=
 =?utf-8?B?Z3hFaUJDTFpyNnFEQkp5VHphRmJpSEVoR096dnhmYjd5MCtwT2E3UnZJMzZJ?=
 =?utf-8?B?U3BaVzZ5b1BGRXdjV2RORDlrK29naEpwTWVPNHRseVdpMlFNdU1aQUtvL0dy?=
 =?utf-8?B?cGJOaDd4Q2VFTFFpTGtSZlVwTWhicFZHeXFaR1JnbWRrazI0SnlFUWpBbmpK?=
 =?utf-8?B?WEJFa1AzT0oxelA0dFZjcVNvVk04cWNHZzhrRFJvNThlKzYrRmtkTmp6Y1pL?=
 =?utf-8?B?OW95OVpqYU92Tkx4Z2RMRXdLblVlUDh3Vm5xR1greTB3UW1aMjhrRlh5aGlR?=
 =?utf-8?B?bVM1NEcrQkZGUjJ1VHRCdEZTTksxVkRhS0UxZHZqU1NJN24zV1h4KzV6MzYv?=
 =?utf-8?B?WUJmZE5pUTZpRlVUVmtSN05JZ040b0FwbnlnZ290bWdOSGF5di9HbXRGeVRJ?=
 =?utf-8?B?NXB6R3RYQjhLMFp3NXhZTVd6cW1aYWsrUWd2OURmbjRYZFhPK3ZsUUEvQ1ZX?=
 =?utf-8?B?TTVLN1pTanhLYmlkRkt6NEtuUmh1SEY1QWRTbnBIVGZscXRaZG5UbGlBK1N3?=
 =?utf-8?B?dWxqNHgycitzQlozOHZlcmJMWWUzMWZxUGtkU3Y0bnZhYUhhUi92UEl6T3ly?=
 =?utf-8?B?NXUwQWlpbDc2SlNtMlVHRU0yRUxPUlV5YjBqT21ieEQvTGJ2L2hyVnZhN2pU?=
 =?utf-8?B?ZnUrTGlkeEpuVG53aFFyV09xNnBZRXdIdDBlVCtveHBGQTgrU0NnWk56TVUr?=
 =?utf-8?B?UmQySGpOek5na203RVJXYTFqbTFOUTdHWS8wdGk5OUd3ZW4wRHZRc2VWUnhk?=
 =?utf-8?B?dHdsYTJQUURWRVBEbVByWE41ck5pR0ZFejFuQ0p1akM2UGd1cHlkTTRtb3dZ?=
 =?utf-8?B?NWtveVpCMzdmNzE4QUNjaEdkZUdna011bnB5YVlZWUJraUlkY2dHeG9GQVhU?=
 =?utf-8?B?R1Rsak93OUc3eGI5UHA1MHdqMzhISjQ5dWRyQ2ZPS1NVVHljczBUZXFaV2JL?=
 =?utf-8?B?VENNSzE1K2p0dlBpQWY0alhweDk0bXkxUUZKUWlFYmFCSSttRHJlZXBkR2pE?=
 =?utf-8?B?VHBzRVFmUmpiS2ZWU2VVTFBDSmJ2WWYrYmVTQ0EwMFhvbkpGVmxHZXRnTHR3?=
 =?utf-8?B?U3BZbkx1eVZYWFVkNDNLWlRZZVdpZ2dFOFBZUzhzdmx6ZFhmYkh1ZjBQMi9m?=
 =?utf-8?B?RHlVOXpmTmJuVkl3NHVpM3JNVzJ3ZG1nU2VUTVdHeUJiSWhLbDBNYk9oT3d6?=
 =?utf-8?B?SUtHVUZCVHNmbzRLN3J2L2FXZzd5Q2NDSUxZNHZXTEY4emtLcUdlazhKZVNR?=
 =?utf-8?B?cVJLNEFYUFQ5cFV3OGJtaUhIbU1ZbjBuczgvWkdCKzkrVzFzRjhBZkNocE9T?=
 =?utf-8?B?b2Rnb3piL0wwcjc0TmVvUWkzRkxJaFRZRXV2VHB0SFhtVkIyUi9BQ2psZ01P?=
 =?utf-8?B?M1hnWUFFWVp5RDFpNEF4RzVCTTdPN0dITnVSR0RuMDNQVUVRQklPVVlyVGNP?=
 =?utf-8?B?bnJGemlYWnNFNUs1L3hPQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0lYU3ZzQjNXSS9ubExTdS83dlhMeGhRWDlyQ1pxL1lORUJGT3dLaEJTK05E?=
 =?utf-8?B?OEZBVS9NUXN3TlZsTld3b2lmV3FtZzMycDVDZVcwS2dKU2kvTEJ1cUZudzNJ?=
 =?utf-8?B?ZzdGU0RBMFhZOEVCd3BKY05IUmFSVXhnMDZBazBtSHJqanJNSFF3dkpabnJK?=
 =?utf-8?B?SHIwTy9XQllpVy9UU2lIdE8xdXpFMVpRMjQxUmlFV1dTTUdZOXVLckpiaDJJ?=
 =?utf-8?B?bGV6ZDBSWWVBZjlzdkFyYlY1eis5UnNMbm9xWUxVdTVjc1BNZTVNTEM0OEp6?=
 =?utf-8?B?QzNpS2NUWnFpK0VPNVdHUjJmdWNKWU5yZXlXYW9XenhzQXE0S1g0c2c1cVMz?=
 =?utf-8?B?MEFzYnRkU2FkU2ZzMFJTbmZVQ2VpdE01VU1vdFNldTdUbVVqWmhsMmNybEQz?=
 =?utf-8?B?UFZxbFBad3pJWHBFTEhkbU5UUzZCOUVWMjl6UFJ4VVFoNnhhV2Z2N0RaMUcz?=
 =?utf-8?B?cDZud29wKy96UWJwZjhaWVJWbmdEa25sSlA4QzVvUFNCakpDR08wam4zK1l5?=
 =?utf-8?B?dFRRcjFRVEF0aXRlaWJTYmRBZGtoUm00Q2ZVM2puNnQwKzBmamt2Ym5rY1Q0?=
 =?utf-8?B?eVRxVGlXTjR4QU5HQnJOd3BsTjFMSHc1azBXdng4bVNXdEFvZDJ5THFuYnlW?=
 =?utf-8?B?ODlBa3FZYjVCUzBrTytZallpQXVFOVA5bVpOY3Y1WE5URUNWTHlvZEQ4SmVl?=
 =?utf-8?B?UVRKMUE3bDZ4YWg3cGdvR3BLOUxTck9ZU2lLS2l6SmpNMkZ2enZYTEJDQnc2?=
 =?utf-8?B?QVhVSUtVM0xWOTEzT0s1QSs4WUNCRGo1Rm1palZGUFIySVJnRExXU2U2K3VM?=
 =?utf-8?B?SWRaNytuVllBVjFsdDlaS2theUlxek10K0lNYVozSFBKb1hYMjllUlg2NWk1?=
 =?utf-8?B?TTVVaUE1cWxUZkZFd1dQWU5qY0xOTlRMcHF6bDhUVDlWRTZwZHRQQTBQeXpH?=
 =?utf-8?B?bXpncG4zT0dIaGlEc01vQ29pTTBSR1V4dTFwRnFtZGxubCtHR1pwUjR6SWFu?=
 =?utf-8?B?L0ZCdDhCcGhqZFpwaEN2QmdUUDA5eitDZE5sakNOakxWaGxuUnVvalk2bW5k?=
 =?utf-8?B?MzhCTUhjNGFDUlAyUGpxeUx4eGNLMWpNRW5pejFZVjY5VmtsQ1hYQm9EK3dn?=
 =?utf-8?B?SHRrTXRoRndPLzk2UWFRbXZXV3hyTjhZYUpNajBQOFd6Zm9ObDM2Z2N6MHlE?=
 =?utf-8?B?UUEydldmMW0yV3ErRnhkYmhqUTZOQlNHL0xCZ2JnQ0o2WlRqMEt3NEJCZkpm?=
 =?utf-8?B?L0t3aThDd2VhcjZOWm5tMzFVOGRGTk1Ld3hnQlgrTHZQalJxUzdBSTdYL3pm?=
 =?utf-8?B?Z2FWOHJXRlZaUWlvTXc3K2pLTm5XRFQ1aElQUGlPMUczd1dnT2Rmd0xNREZM?=
 =?utf-8?B?QkxGUzNMai93ejBnakMrcnpGOUFQeUJzYTZjUWpMYThyQldjNjVVbzdwVmxh?=
 =?utf-8?B?RUxEYXl3R29hcThDdWQ5MjNRYTdZaytYZWVqNFRCN0ZFTVVWODJUWkpKazM1?=
 =?utf-8?B?NTd2VzlPOVBBTVVyaDdpK0p2Y2F0K0VZaTBRWmVhc3ZISnpENnhWOWtub0VQ?=
 =?utf-8?B?NndVUkFSaHR6bFhvRFl1QTN4b2w3bmhkRW9zMzZiK0Jud09SUDc2RStNK3BV?=
 =?utf-8?B?Y010aWswRlp2V3JxbUdHNzZKazlISWNPU3R4VnJXU0tWcTZWYUc4c01sU1Fi?=
 =?utf-8?B?YzhacmlEM2FQNGVvSEtpVmdoWDI5ckpzQUdtVmQybkFZQ20weXdwNWJ5OVQ5?=
 =?utf-8?B?UTg4NGZVeXpZclpvcVJYNm42NmJDV3FwMmJtTnVmQkt5aHhVOVUrVENPZVQy?=
 =?utf-8?B?Z2plRUdveiszbGpiOUtHa3RPSnlZRFFkeCs0elI4UXM2VDBta1dnZ0w2VzBG?=
 =?utf-8?B?NkExS2l2ZkVoamtPU0Y3YWhma3Zac2ROVjJzeXdrR285OGhDa3hHY0grVFY0?=
 =?utf-8?B?OWJNcGg2Q0k2VGdOaVl6VG5qcDR3Y29IeFVIZGxjcEZhWFd2NGJjV0NXbDRl?=
 =?utf-8?B?bG4ydGI4MjYxYkJ4Nmc4UGNONTNUVlVUTVUrbWl5d2ROOFVleURSQkJHOTF6?=
 =?utf-8?B?aWRrTFVKS1hZV1AzWWwvQ3phUENhQkxHbHdNREFMcUJ1WmpwdkhZNW1QK2JU?=
 =?utf-8?Q?a7tIXRLf+MF0oIDl4Oa5zpAtS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1cea59-857c-47e8-240a-08dccaee0254
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 01:24:37.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4ywaUA++poV6V0JPEX5iCrOLf7v8pb4d6VpeJV+HRshu3JkL9327mXr1Py/SfeucL8XVEsqudCUz+jiYtRIMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021



On 30/8/24 17:02, Xu Yilun wrote:
> On Fri, Aug 30, 2024 at 02:00:30PM +1000, Alexey Kardashevskiy wrote:
>>
>>
>> On 29/8/24 20:08, Xu Yilun wrote:
>>>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>>>> index 76b7f6085dcd..a4e9db212adc 100644
>>>> --- a/virt/kvm/vfio.c
>>>> +++ b/virt/kvm/vfio.c
>>>> @@ -15,6 +15,7 @@
>>>>    #include <linux/slab.h>
>>>>    #include <linux/uaccess.h>
>>>>    #include <linux/vfio.h>
>>>> +#include <linux/tsm.h>
>>>>    #include "vfio.h"
>>>>    #ifdef CONFIG_SPAPR_TCE_IOMMU
>>>> @@ -29,8 +30,14 @@ struct kvm_vfio_file {
>>>>    #endif
>>>>    };
>>>> +struct kvm_vfio_tdi {
>>>> +	struct list_head node;
>>>> +	struct vfio_device *vdev;
>>>> +};
>>>> +
>>>>    struct kvm_vfio {
>>>>    	struct list_head file_list;
>>>> +	struct list_head tdi_list;
>>>>    	struct mutex lock;
>>>>    	bool noncoherent;
>>>>    };
>>>> @@ -80,6 +87,22 @@ static bool kvm_vfio_file_is_valid(struct file *file)
>>>>    	return ret;
>>>>    }
>>>> +static struct vfio_device *kvm_vfio_file_device(struct file *file)
>>>> +{
>>>> +	struct vfio_device *(*fn)(struct file *file);
>>>> +	struct vfio_device *ret;
>>>> +
>>>> +	fn = symbol_get(vfio_file_device);
>>>> +	if (!fn)
>>>> +		return NULL;
>>>> +
>>>> +	ret = fn(file);
>>>> +
>>>> +	symbol_put(vfio_file_device);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>>    #ifdef CONFIG_SPAPR_TCE_IOMMU
>>>>    static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>>>>    {
>>>> @@ -297,6 +320,103 @@ static int kvm_vfio_set_file(struct kvm_device *dev, long attr,
>>>>    	return -ENXIO;
>>>>    }
>>>> +static int kvm_dev_tsm_bind(struct kvm_device *dev, void __user *arg)
>>>> +{
>>>> +	struct kvm_vfio *kv = dev->private;
>>>> +	struct kvm_vfio_tsm_bind tb;
>>>> +	struct kvm_vfio_tdi *ktdi;
>>>> +	struct vfio_device *vdev;
>>>> +	struct fd fdev;
>>>> +	int ret;
>>>> +
>>>> +	if (copy_from_user(&tb, arg, sizeof(tb)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	ktdi = kzalloc(sizeof(*ktdi), GFP_KERNEL_ACCOUNT);
>>>> +	if (!ktdi)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	fdev = fdget(tb.devfd);
>>>> +	if (!fdev.file)
>>>> +		return -EBADF;
>>>> +
>>>> +	ret = -ENOENT;
>>>> +
>>>> +	mutex_lock(&kv->lock);
>>>> +
>>>> +	vdev = kvm_vfio_file_device(fdev.file);
>>>> +	if (vdev) {
>>>> +		ret = kvm_arch_tsm_bind(dev->kvm, vdev->dev, tb.guest_rid);
>>>> +		if (!ret) {
>>>> +			ktdi->vdev = vdev;
>>>> +			list_add_tail(&ktdi->node, &kv->tdi_list);
>>>> +		} else {
>>>> +			vfio_put_device(vdev);
>>>> +		}
>>>> +	}
>>>> +
>>>> +	fdput(fdev);
>>>> +	mutex_unlock(&kv->lock);
>>>> +	if (ret)
>>>> +		kfree(ktdi);
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int kvm_dev_tsm_unbind(struct kvm_device *dev, void __user *arg)
>>>> +{
>>>> +	struct kvm_vfio *kv = dev->private;
>>>> +	struct kvm_vfio_tsm_bind tb;
>>>> +	struct kvm_vfio_tdi *ktdi;
>>>> +	struct vfio_device *vdev;
>>>> +	struct fd fdev;
>>>> +	int ret;
>>>> +
>>>> +	if (copy_from_user(&tb, arg, sizeof(tb)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	fdev = fdget(tb.devfd);
>>>> +	if (!fdev.file)
>>>> +		return -EBADF;
>>>> +
>>>> +	ret = -ENOENT;
>>>> +
>>>> +	mutex_lock(&kv->lock);
>>>> +
>>>> +	vdev = kvm_vfio_file_device(fdev.file);
>>>> +	if (vdev) {
>>>> +		list_for_each_entry(ktdi, &kv->tdi_list, node) {
>>>> +			if (ktdi->vdev != vdev)
>>>> +				continue;
>>>> +
>>>> +			kvm_arch_tsm_unbind(dev->kvm, vdev->dev);
>>>> +			list_del(&ktdi->node);
>>>> +			kfree(ktdi);
>>>> +			vfio_put_device(vdev);
>>>> +			ret = 0;
>>>> +			break;
>>>> +		}
>>>> +		vfio_put_device(vdev);
>>>> +	}
>>>> +
>>>> +	fdput(fdev);
>>>> +	mutex_unlock(&kv->lock);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int kvm_vfio_set_device(struct kvm_device *dev, long attr,
>>>> +			       void __user *arg)
>>>> +{
>>>> +	switch (attr) {
>>>> +	case KVM_DEV_VFIO_DEVICE_TDI_BIND:
>>>> +		return kvm_dev_tsm_bind(dev, arg);
>>>
>>> I think the TDI bind operation should be under the control of the device
>>> owner (i.e. VFIO driver), rather than in this bridge driver.
>>
>> This is a valid point, although this means teaching VFIO about the KVM
>> lifetime (and KVM already holds references to VFIO groups) and
> 
> Not sure if I understand, VFIO already knows KVM lifetime via
> vfio_device_get_kvm_safe(), is it?

Yeah you're right.

>> guest BDFns (which have no meaning for VFIO in the host kernel).
> 
> KVM is not aware of the guest BDF today.
> 
> I think we need to pass a firmware recognizable TDI identifier, which
> is actually a magic number and specific to vendors. For TDX, it is the
> FUNCTION_ID. So I didn't think too much to whom the identifier is
> meaningful.

It needs to be the same id for "bind" operation (bind a TDI to a VM, the 
op performed by QEMU) and GUEST_REQUEST (VMGEXIT from the VM so the id 
comes from the guest). The host kernel is not going to parse it but just 
pass to the firmware so I guess it can be just an u32.


>>> The TDI bind
>>> means TDI would be transitioned to CONFIG_LOCKED state, and a bunch of
>>> device configurations breaks the state (TDISP spec 11.4.5/8/9). So the
>>> VFIO driver should be fully aware of the TDI bind and manage unwanted
>>> breakage.
>>
>> VFIO has no control over TDI any way, cannot even know what state it is in
>> without talking to the firmware.
> 
> I think VFIO could talk to the firmware, that's part of the reason we are
> working on the TSM module independent to KVM.
> 
>> When TDI goes into ERROR, this needs to be
>> propagated to the VM. At the moment (afaik) it does not tell the
> 
> I assume when TDISP ERROR happens, an interrupt (e.g. AER) would be sent
> to OS and VFIO driver is the one who handles it in the first place. So
> maybe there has to be some TDI stuff in VFIO?

Sounds reasonable, my test device just does not do this so I have not 
poked at the error handling much :) Thanks,


> Thanks,
> Yilun
> 
>> userspace/guest about IOMMU errors and it probably should but the existing
>> mechanism should be able to do so. Thanks,
>>
>>
>>>
>>> Thanks,
>>> Yilun
>>
>> -- 
>> Alexey
>>

-- 
Alexey


