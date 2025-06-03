Return-Path: <kvm+bounces-48314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6ECACCA9C
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6853F7A7EDA
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C7023D283;
	Tue,  3 Jun 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bEBDtTlD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2848823BCFA;
	Tue,  3 Jun 2025 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965966; cv=fail; b=KxqEbknscsskXMrEmqXrH/wohhGGqhZqt5eqwWtQf9qATA4W3KWUN2k+ga7nq72Esqek51IfgFSPSNJKr8xsSmnIJqr+0rEkluw9dWVGHr//3oJ98ozrtvbd2YN7VbsC85FJVdjo5UIjCY05lxX1uXCSGruJuizM+RwN4eKObAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965966; c=relaxed/simple;
	bh=StiXz4sQArcKUWbDbIyH1NhVOyQTRn8NtusN13stmm8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BydY/hmXWlD17+8vPnIZCylg6LIVrbX8rU9oNpNdCfwxfNBXvC20H6mgweiGRC6vilT0/Rv7ncS2cCpJx5NRm840veRqejiCkbMfBzXAZGaZoYmXN9cTT65gnnTDN4FmzFDMJSvUxl17dOSD2uPgfFAb27SVzeHiBMuHEiFWDBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bEBDtTlD; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRTG6Sy8qOZ/QalDAaErKK19VJuWHnzOTz22paN9QHz78m7cqBm4p+BhuJE+Yz+K//7frDWpo864gU0Qz9R3AjgYbH1w6+y6lpRueDrr6Ni39zN4qANQC9i8HySkhg3LVW4cRT6dgThVOiOzUlcwwM3Np0LVump6btWc2WK+Xw6zl67LUna6SDTrp9CMJwLRku/YGGASrnGTsby/R/lV7NPB9CWTi+lhDsGOr/P5r5BpPGk/elcTvi9b8r/fPs7QbQ7jJennBX+3z19LpmDftjlrs29cnL8RmvL+oL7vATN/1luhrsZPyxWkQgKjBBl06U0u4xJ5PXtDzP+K7CAmPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eRRrUlZwtKiXUWlFFPadW7fzbyY6sOowMxR4RQ7Sig=;
 b=Ne4cbciync97taYyWP94wYss7C726Xfc/JalgGVqz1Pok8sIdkxjc2kqdiuK5kpL7kgxMjWUzTs/5WEQKc/duopngu6xTk9npGLPCa3P3NJb2I0J0g64qnEcWBR4nBuaHGwCcQ+Cw5YZDLwET838HFAcsKhC4htBt1JEhYs4/YfkJd+ntioZgcVjxZj4AmkrhGEC5vBKL/up1VNY+lpUgNX8iBzHbzusSLGDF8MS3u7X2GxO9bsx+QgFwyXIqFjZfxUQscM6P8QMKIsb+ysF7eeHe6zfTa/Ny/20c5Hx2TZU8p7x0wGjcXqx94+Q81063nT7tplABGrqGkKi7CO/zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eRRrUlZwtKiXUWlFFPadW7fzbyY6sOowMxR4RQ7Sig=;
 b=bEBDtTlDTiaM6Oo893oAgYDsFo7/BldAHXR58yxOnfo1dbpxkpZFOoVOlDgvTFAtcMf52H7jIGVf31ARBTnDlcaxMPGxZNzb1Ce5vQ51BtKwfpq9pU63Y0OsB05o/zUGcqju4dKoO8fu7nvGGdE9kCalboF0Nw8ROD6B2XlyFuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8261.namprd12.prod.outlook.com (2603:10b6:208:3f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 15:52:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 15:52:40 +0000
Message-ID: <1905a57f-3a0b-7106-111a-8231a6ec9380@amd.com>
Date: Tue, 3 Jun 2025 10:52:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 4/5] KVM: SEV: Introduce new min,max sev_es and sev_snp
 asid variables
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <0196b4b50a01312097a18bc86014d9f47c22e640.1747696092.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <0196b4b50a01312097a18bc86014d9f47c22e640.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:208:335::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3eef9b-e8e4-46ac-dfe7-08dda2b6abb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z09tN2NTa3lyYTZlWFRJTlhrWUl2NmRHeGJyY1VReU01ckV3bUY5UEdwMkRC?=
 =?utf-8?B?MVZYbEt0QkgzK0VzVlhBVUR6ODRkY2hEQ1BFRmdGaDFHVHpucTFrVzVPZkti?=
 =?utf-8?B?TGtQYmpDQStEMzdiM2tTa2F3V0Y1bTBpN2hhcFZpTHh6ZW5mMlpwYSsxRFMx?=
 =?utf-8?B?b0ZoR05pelpjQWFDT2NFUW4reGtjbzhaRDBhZUVPVUNKdVkxVGIyQTZhZFhD?=
 =?utf-8?B?d21ERWhDU3lhVzhjWVg2bWZtRFhFNVU5d3I3VVVQcUxjQVBva0V2eWJQeTEx?=
 =?utf-8?B?aEt2MmJwbjRvUTE2S0l4MlJmZUs0b0p6N0Z4NnU4V25XRXYyNHlpeXZvU0dj?=
 =?utf-8?B?YlpoU0FObXQwNVlscDNqRnY4M2YyRVp1cjVSZmd2cGZJdWh0ZHNZRExneG5U?=
 =?utf-8?B?bFkzY0ZGQzYwTVc1Y1NGMW5TM2hhKy90cEMzY2Jack1CUlBkc29IOXZoR1NV?=
 =?utf-8?B?QS9TMUVHRjJMTHExTVozQTFqclQ1K3l3NTU4MG5CUCtyMlNnZ1VBMUdEZWll?=
 =?utf-8?B?V05aREc0TkpRMFdXMjE1dG12ZXVhS0tzQTV1OVJuanRlYXg4bUFqNkZKYzJQ?=
 =?utf-8?B?ejU5VVZPQUlMOU5QY2d1U29CQThnRHoyWFl3L3JoRjg5VnNla2VhbXpUSCs1?=
 =?utf-8?B?OUIvcFUzMVA0OGl6YWFjcjQzREdsSnpFeU9xWVVOcUYyQis1WDhqNStaaVBx?=
 =?utf-8?B?TkZ1dE4xY09mQjVLQTMzUUJ1YjR0TTF4emRWTk55ZW9uNDlNOHJiUjdxcnVz?=
 =?utf-8?B?Smx4ank2NlZOOGJsYTV2TGxjLzJWblFCbjNFbHlORk5nb3I2aDc2ZnJHSVZ4?=
 =?utf-8?B?bnhIWE0zeXZvUVlmUmp0K0s5WVdEbERncWZRQlJHMzJROXNHOTlOMHJmK3lk?=
 =?utf-8?B?dFhsRXNMSDJHNDV4MjdZaW5BK2xVUEh0dS9vT1QyK0N2d0xJSStSUlRySTBJ?=
 =?utf-8?B?enVCZmxlcFRCaW9oZnF3UzB0aDBybmdjRmlmdWNZVXJFRy84Ly9TU1lubFFZ?=
 =?utf-8?B?SEx0MjZQNFBFcEsyaXMrdnJHbk5LZkZreDh0aTZDODdZalIyaVkxY0hEM0Rz?=
 =?utf-8?B?b2p5WDlpRUdsVU56SllRNDIyRDl3RGF1c3o3VUZWbFN5YVNpZ1R4blJVQWsx?=
 =?utf-8?B?RGlhNXhjSCtibTJGaUkwcFdjdjFKM09TeTh1WmNFaEkyV1hwczFYTlZ3cHJP?=
 =?utf-8?B?aEdqQnk4Ry82UVRPR1lDeklUb21UUklWN3d3ZUJEVEdXUHA4am1INGE3ZWJI?=
 =?utf-8?B?Qm9xdE9TZk0wQUkyTWtuRkVCRGZobnIreExGTU5oai8vZ2wxcmRKN3o1cnVJ?=
 =?utf-8?B?ampTZDlHR2c0MExTc01IbGRNbDE1WkhBODk3REFQM2dHNEM4dHJGRy92YjQ3?=
 =?utf-8?B?eUk4ekxuTlZYcEE2NTJ6ZnVyYjVnR0NrU1I2ZXFzU1Zlem5pSTdvNkFPRng2?=
 =?utf-8?B?Zk8wK0RmWExweENOMGpxbUJDWmtRazFaRlBwYzVCZm14TEVFQ0hJYWV3NTYz?=
 =?utf-8?B?NG8wNDlWY0RNMCthVkdmUzlLTnAvYVQ3dFJtM2cxV0VINmxKTjdHWkRvS3Z5?=
 =?utf-8?B?bDByRklwZ2Nrc3hmc1cweko3RTNmVk5XUUJMWlRGZ3g0MDhSY0tSaTNJdzBF?=
 =?utf-8?B?L0FCTmRxNDRGcGgzbXlTM0xmbHBQVGVVejZtY09DTXZsekNwN1VQa0ZSTkJZ?=
 =?utf-8?B?Z0NlZDg2MzNGaWdnQnZCcWZkT05xdXljV2RZa1hLdlJJVmRUWkN2WUV1alkz?=
 =?utf-8?B?NjJSVUZZYkN6UlJaamZPQ2dyd0IwVmZMaVc5NkRmTmFnQVVBVXlSb012Q0c5?=
 =?utf-8?B?R2Y5V1N6NVRTVFFqdWxtWC82NGEzRzF5RnFZbHAzSTZ2Nitnc0YvQjZPRG5F?=
 =?utf-8?B?cTBDeTdIMndSVnJ0NTdBWEN2dGVKZG1lNElPQXpkU3AxZ0dDOHB2NFZjSzVG?=
 =?utf-8?Q?BYe8bxpJdj4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTVnakdMeVRYaC9zSW9HNTRyT0Mvekp5Q2J5RkJTejBBdjZnTGd2VTlBd2hN?=
 =?utf-8?B?S2RSd211S2EycU9FRXNSZitkeDNTd2hpeXB4Tml0d1Y1SHVJVVQwdmNmb3hX?=
 =?utf-8?B?S1pNd2d1OXNoSTBQMEZ5QXpCSlpiVnQ1NUxDWTV4ci85aldRVkQvdFBOTHRJ?=
 =?utf-8?B?NjNaZGh6aXNIMjhKZVNTQUIzR1pUMDloWmNkRHVZc0YxTlBYSGVPN3BIcGdO?=
 =?utf-8?B?VU9IN0pGN3pEWHFiYmRMNi9vZWV6bW82eHdNZDdoMklUQVRGd0NYbGhCYjI3?=
 =?utf-8?B?aWJ3UDB2aWpqZGtKR3Iwb2pycEVHTU9UV2FMUVE3Slk3RDZ4QjZaYlpBb1l0?=
 =?utf-8?B?TDlsaW5xODZuZnh1aHNPVjN6YmwrWllSR3ZzVGd5L2ZlTmpoVStIVFVwYm1o?=
 =?utf-8?B?TXJlRWpOTHFtT1dzNWtCK3NOekJpeHJ6UDhBU1NxaHpEOFFBSUVxUGlNS3Nv?=
 =?utf-8?B?Um5MUENQNzMzODBVVUNPTDc5WUlCSElGbTQxV1RocUl2YStHbGdjaGtCekRF?=
 =?utf-8?B?R0RFckVBOHFuSHNXY3VINFB4R1BCaGpua2VHTlFpYWJkcUhlSXhkVmVYbktU?=
 =?utf-8?B?MkIvS2hpb2lqekxreWpIL0FNUmZlY2c2akhRYzFSYkRtNUxYLzJTY3RTTEJW?=
 =?utf-8?B?dHhvb3BsOUhrZGVrYUFaRVpuUXdpK01qWG50K3laZ3VLK2M4N0lTOFFsZFcz?=
 =?utf-8?B?eHM5dCthc2IzVGw3ZlVONFd0ZS9aUXg3WG1LM0Z4cWZqRU5uMUo0MDByZUpJ?=
 =?utf-8?B?TkEyRC9aaUs1T2tSeXVhUmJBanlzR29HT0Znc0NtWUl1L2QyZWtNcHVXd09H?=
 =?utf-8?B?emQxYU8xanNGSit4Qnl1aVQvVWtGdExVMjR6Q2I2ZWRiM1dnelFJUlZlc1B1?=
 =?utf-8?B?VTRmdEpvNHFzbTA1S0dxQkhMeHJPWmdlZFNMem9ZaXlvTnhIUVZ1ZC9ob1Bo?=
 =?utf-8?B?dWxKZzRzdDFyYTZkWWZ5N1Zsc1d6TWNENmlFYy9WM2NheTNSN0thZ2hidXFF?=
 =?utf-8?B?aE9GYVlzcVE5QU1DZmRLcjhVOGVaN3RQODU1SWZCSWFSWG0zQjhJZDBaWkZ6?=
 =?utf-8?B?VEVNUHVyWmFKZ1BoZzV2MFF1RlBqL29PdGVudlQ4VDBEUDV6YUdITkRwK2NZ?=
 =?utf-8?B?d3QzTkl6dGwzQkQ4ckRCcVQrSnVHQ2g5M0w1bVpDZm1oTW9yWlFHQ2M0L0pL?=
 =?utf-8?B?OXIwRW1zS2ErZ1JqU0o0TjhIUCtZOGp5ZW92REltVFd2ajVVNC90SUJYd1Uz?=
 =?utf-8?B?cGFIOHNxQ25pRGtVckhyTjRoR0RWb2tnSVJnZStwYWxpbGkxUU1tVDY1YVc3?=
 =?utf-8?B?cVQ1QnRzcnRlRnZ0MURHRFVpajBLWGZ6eTBqSzdLSlhsUTFMV3ZCMWpIZVdm?=
 =?utf-8?B?LzAxQjR1Z0l3R2ZiaUZoYmNueWRjTzN3c1haR01UVXhKb3pGdkdVMWF3Vm5F?=
 =?utf-8?B?QXI4WUpmNTFSS3RJN3JVZWZoYWdnb2laZlpkR1Vya1htQ3NyNmt1K1NOejQ5?=
 =?utf-8?B?NW0zOUdIbzFNajVuNCtlbVBSb0xEam9yU21UM3k1bmdwR2VTcEFMSkNFQ3Qr?=
 =?utf-8?B?ejhiNDNCbXNhaWpUclUrSDIzVEE1aFBiLzZwTFpjczAvQ1UrZmx5aVA2anhU?=
 =?utf-8?B?MHlMVldMc3JoUTlLc0J4cVk4REtXR0UwdS8rVU1Uak56dU1JVjJsbTBFenBZ?=
 =?utf-8?B?Q25PUTZoeG4yMVFzOTlUblZqekFOU1hZZVVhdG5WYTNVTEJ6NHVaS1NsbGdJ?=
 =?utf-8?B?WnVDcnFSWFpjMlBRWnVkeSs3NXdGTEc0RjBUbWFSanFmV0owOXRCU3VqZ2tG?=
 =?utf-8?B?c2hTaHY1MG56Y1ZPMEtKNkUxZVJqRDN6bEszSVlRTUNRQkVSeWlSQkd3WmJT?=
 =?utf-8?B?c3J3NnFvWkdRRGtPWWhjVDI5eUIyeVNGbHE0VkdibmlPWFBvaXFsTDBnenlG?=
 =?utf-8?B?Q1ZyaDlmWTliM0JvTXdSZUpaSDFCMGJ5UElhT1ZYN0tmRWtwVXJVNldLZzNW?=
 =?utf-8?B?K2xXY2F5UlBMalJadHZsU3BXZFJsMmVRZGUwSFphQnpUVTRNY2UrZjZVemJs?=
 =?utf-8?B?THlsQUF2SlB6VWlrajJKMjdhZGdQNTQ4MUZXenhhUy9GWk85QzY3YVRReDAw?=
 =?utf-8?Q?t3MU5GyZPCxlLYk94b7RrKmm/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3eef9b-e8e4-46ac-dfe7-08dda2b6abb1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 15:52:40.7232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fFZxU5cZN5fdYhLuBRzap3yvX99Uk4jFdUbEJsVHWypN3nKj33bExdhBMDNBp8/gcnJBZ466ULCyFNoamuSnXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261

On 5/19/25 18:57, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Introduce new min, max sev_es_asid and sev_snp_asid variables.
> 
> The new {min,max}_{sev_es,snp}_asid variables along with existing
> {min,max}_sev_asid variable simplifies partitioning of the
> SEV and SEV-ES+ ASID space.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index dea9480b9ff6..383db1da8699 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -85,6 +85,10 @@ static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
>  unsigned int max_sev_asid;
>  static unsigned int min_sev_asid;
> +static unsigned int max_sev_es_asid;
> +static unsigned int min_sev_es_asid;
> +static unsigned int max_snp_asid;
> +static unsigned int min_snp_asid;
>  static unsigned long sev_me_mask;
>  static unsigned int nr_asids;
>  static unsigned long *sev_asid_bitmap;
> @@ -172,20 +176,32 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>  	misc_cg_uncharge(type, sev->misc_cg, 1);
>  }
>  
> -static int sev_asid_new(struct kvm_sev_info *sev)
> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  {
>  	/*
>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>  	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
> -	 * Note: min ASID can end up larger than the max if basic SEV support is
> -	 * effectively disabled by disallowing use of ASIDs for SEV guests.
>  	 */
> -	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
> -	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> -	unsigned int asid;
> +	unsigned int min_asid, max_asid, asid;
>  	bool retry = true;
>  	int ret;
>  
> +	if (vm_type == KVM_X86_SNP_VM) {
> +		min_asid = min_snp_asid;
> +		max_asid = max_snp_asid;
> +	} else if (sev->es_active) {
> +		min_asid = min_sev_es_asid;
> +		max_asid = max_sev_es_asid;
> +	} else {
> +		min_asid = min_sev_asid;
> +		max_asid = max_sev_asid;
> +	}
> +
> +	/*
> +	 * The min ASID can end up larger than the max if basic SEV support is
> +	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 */
> +

Remove blank line.

>  	if (min_asid > max_asid)
>  		return -ENOTTY;
>  
> @@ -439,7 +455,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	if (vm_type == KVM_X86_SNP_VM)
>  		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>  
> -	ret = sev_asid_new(sev);
> +	ret = sev_asid_new(sev, vm_type);
>  	if (ret)
>  		goto e_no_asid;
>  
> @@ -3029,6 +3045,9 @@ void __init sev_hardware_setup(void)
>  		goto out;
>  	}
>  
> +	min_sev_es_asid = min_snp_asid = 1;
> +	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;

Should these be moved to after the min_sev_asid == 1 check ...

> +
>  	/* Has the system been allocated ASIDs for SEV-ES? */
>  	if (min_sev_asid == 1)
>  		goto out;
> @@ -3048,11 +3067,11 @@ void __init sev_hardware_setup(void)
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>  			str_enabled_disabled(sev_es_supported),
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_sev_es_asid, max_sev_es_asid);

... so that this becomes 0 and 0 if min_sev_asid == 1 ? (like before)

>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>  			str_enabled_disabled(sev_snp_supported),
> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +			min_snp_asid, max_snp_asid);

Ditto

Thanks,
Tom

>  >  	sev_enabled = sev_supported;
>  	sev_es_enabled = sev_es_supported;

