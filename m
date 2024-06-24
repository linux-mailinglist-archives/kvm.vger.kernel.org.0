Return-Path: <kvm+bounces-20412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D927D915658
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 20:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DC8128B5A6
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 18:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5907B1A0716;
	Mon, 24 Jun 2024 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tFla3U/C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96F019FA8D;
	Mon, 24 Jun 2024 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719252781; cv=fail; b=J7yaRTJM6jgTjEbd5Z4rxepRr5AXGKb3xTaSeXJJoveFLT3pqzUleMCR9biEscg0K1EEFKiWV4+DcxwGdsxCuh77Ioau4p5TMi4tuYfQ/r32tJ0Ka7HAF9Q0fM81yKV18lvdRHuJ6GqAFDjZXnLtdJfzu/1+QnL9nDYjXjpFpms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719252781; c=relaxed/simple;
	bh=KD5UO/AGR16MeOMlNMMDm9QHo/8bmoztn6Q3oV4C1j4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f3sX4PA0lIXZ+oT0e/i5Yuu5SSDaQvUHgYsrJere9oCsIrtUHHqmerFzxzhuYdhlmqvOUGvqxat7E5dZjfdNQt+tbgDSTB7vKVCWCq+BCAZIfrsHPeQWL54ugJx9zL5KfbxbfdozeeeZGb6Zo/a0eH4IaoSFFHllpX1jilPp5ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tFla3U/C; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxeszRUz67IlREmqaVYkhxwRFmAosVxXWpmfJd1myIZmQD/h2PC7UrhuTGusbmRMD2GBaXmIByeHK3QPK+5welOA1NsF7/oNPpMHBn3ys/AXW/1xrTOehd8HWCgarREJTDYh2cEJZHxZEak0nV/CcuA/4QFOo7w2zPEpV6WYCLM4bCxXT1z1g7t8NR8MERwRFPjZ7MdX89NzLDPpRM6HmBZJdqDihbdwbm+4655PtKJGctN7M1JzMukY/VOX6Z4wEudduQwNXizNAKIyY6nUIKiRVSC+a8OQXN+kmN5c7UDZ8eUjoVRyrqTZyTjMgdamoDwTJB7rdmyWgv2B37hkJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7f1rPvZaBjcCvPbILvChEQl3HG1fqx3AqpJCVvJL0PI=;
 b=SqV5GccjRvWE1f+msx9qREB/gxyzR3zD5BD7XgqrxrVgzThebAoVYM/dajKt0eMvqKvlvb5ZA+8D0rqd1mIfXheXNmNSAw/WAZzZoGtJ3IHX3C1ogVQCIWVoZZacfBSxEq/fMa9VYdz2Thv6CaTwkv/tcCg7EeARiS/mAPK3iP4GlkUvgsMRiP7xlRjD68ZhadT4WTlkT1776yidpx6nul62jMzKLquDnyuYKQlKwcPuJRcBrg4m/CwD6JFsNn3Y+7heDmiqgfiN38dv3rlceRdrqrxLVKZOiEW4jYTS4j50av3YYchjNgZZ7iibBA8EXdQsNUaqBqTuDZfNe0CVlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f1rPvZaBjcCvPbILvChEQl3HG1fqx3AqpJCVvJL0PI=;
 b=tFla3U/CLqT14PdzbfXj0r9u5FpGin6d42U1qE2oJagwjgbtcWO4RFudakQPrwMEU3ngbvWFS1y8m8RFwVrPzxbGD/0Gbvqk7/xTRiEPrifcd+4Kn4/ek8/KKlXMdKDdYhp6K5bnQ3S+8UEeLCHnAr9wtt+g4QC4e4DFW3a0abw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB8059.namprd12.prod.outlook.com (2603:10b6:806:32b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.26; Mon, 24 Jun 2024 18:12:57 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 18:12:56 +0000
Message-ID: <4fbcdcaa-3238-8dca-4d91-cb645187671e@amd.com>
Date: Mon, 24 Jun 2024 23:42:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length
 array
To: Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-4-nikunj@amd.com>
 <20240621165410.GIZnWwMo80ZsPkFENV@fat_crate.local>
 <7586ae76-71ba-2d6b-aa00-24f5ff428905@amd.com>
 <fe74fd23-5a5f-9539-ba1e-fb22f4fa5fc1@amd.com>
 <20240624133951.GDZnl3JxlKXaIvrrJ3@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240624133951.GDZnl3JxlKXaIvrrJ3@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0195.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB8059:EE_
X-MS-Office365-Filtering-Correlation-Id: 89dcd3c6-ae18-4e07-b5e7-08dc947945e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGRjWjZnUGVZQzJwb21vaGNnb2lOL3dTOGRYSHZ4NnVUNDZpMkRSbklRb2U4?=
 =?utf-8?B?bGF3Szh0NkZqVnF6WCtsTG5VMHl5TytkV0g2d25GODA4eVA5QkNidzJKUURv?=
 =?utf-8?B?MGU4Z0FRanNXcDd5aDFsN0NEZWxBY3hsSE5yKy9xYXpTS0prOWtOLzNMRTEr?=
 =?utf-8?B?K0lPYXBDUU55U3F3RUxWTWJlc3VSNklDd1lPaFZBUFBiaTRVcThJTmw4a21l?=
 =?utf-8?B?K1V5N3pkeVJSazNTbkVwUTZxNW43VE5sZ2lSVTVCZG9jUHNuYUYxeS8ycWFP?=
 =?utf-8?B?U3FiTEdmdjFPaVRvVDVFZFZ4Kyt5V1RRdzdabGwreXZydnFIbTNYU2VoelBE?=
 =?utf-8?B?K2RCTW9Rd3U1YlAvM2Jzb2R0OTJFRHc0VnB5M0FjTlFsUmdUdnEwc2Z3TVpJ?=
 =?utf-8?B?SDlzMC8xcy9RTGh2cHJwdldyektFT1N3N1RrQUJJNW82OUNuMGlyL1BoM2NK?=
 =?utf-8?B?TjF2RGMvaHRaaXBpSU9Dc09MdnpNdXk0S2hUUXZaamhOQW11bmRyQ0tiMnlJ?=
 =?utf-8?B?NHRreEg2elpPOU93TGxkT2piQUZIbHNXVzFpS1VjY3IzSWw5VXRWSHBCSXZS?=
 =?utf-8?B?NVRwU1BBK000QnAyVnBESHF4eUJ2Wmd1b0FDSFFLOWFHaGU0TkN6ZXhPeVRZ?=
 =?utf-8?B?amhlMTF2dFQybkdWSG1VSk9yMnh5UlRNQit5cVFmYTlpV0JIRFEyWTBaa0ty?=
 =?utf-8?B?ajExdktRWUMvUEpXbGRBdmxUUWhNZEdCZkR3ZWtZUm9vL0M5aGtzTEt3bXUx?=
 =?utf-8?B?am5KNVJ0RkdNdytLNVBwV0NGUGV4b2R5cjEyWWs3MXQwOTN2V1hqbWlEMXQ2?=
 =?utf-8?B?YVFCcmNYOENKOWc4SGtHbit6TFNZUGVmWXdxdC95YnNlN2tXeDExZ1c5VUFE?=
 =?utf-8?B?NytnYVBJSkJNL3R1c1g5TzFGTXlBYnUvbVJIMjQ1d0dzT0MzTmRMVkdlQkN5?=
 =?utf-8?B?bTQ5Nk5RaHpDd0dFS2JseU1kYTR1QVFoUmxtTmhkLzd3LzJ3VEJ4ajVSYVFv?=
 =?utf-8?B?VWltS3NyMXQxY24ySVVNbE0zVTdLeGtzVnhBZGVBaDA3WHIzb0I4UVAzNGVy?=
 =?utf-8?B?cTh4N21KNGlmK0diNjNlVldnZGszcGxBWFNwbGFjR0t2Q3MvcElSM1Z5TG82?=
 =?utf-8?B?WEs2ekF1VHRCSzJyYXdaRU9IYnpRcFZGdFVrZ1pjOEN0WGc4TzU2cjhqTHpp?=
 =?utf-8?B?em94WnNDWXRROER5c1VmMVA2eElVZVdsS25ZaGdIZktQc1VpQ0FZMDFsajNH?=
 =?utf-8?B?bVY5OGdLM04yY3FJc2w5N1NiZWxjc3p1K2R3UjZSZ0ZtM1NWU2lON01TeU16?=
 =?utf-8?B?OU1aOXgrM09qOHdZelhud3BkUzJiWjVma1F0OHp0ZUUrU0pOTjNFOVNGNzI0?=
 =?utf-8?B?MDFCN3V3eW9YU1REOU5TVjU1NlRFbGdjMGoyRitnZlh2K1RLdmhoZHFvR3RO?=
 =?utf-8?B?UzR4Um1xTEJld1ZZdVRSN0xoWFRZRExFWFRuTmk3R2pEV1hlTjVlVWdaV1E4?=
 =?utf-8?B?dDlFYmtMazl0OTg1YXNtMlg0SjVqV1RnNmZuVXArSXlWQUZFeTAxZmdlemww?=
 =?utf-8?B?ZG5tRkdlWlpueGRCQnl6VjVnaUFEakJTbmJSN1l6TC93V0Y5NVlubWJDMTNQ?=
 =?utf-8?B?WElLa1EyZndoeFMrV1lPOVdRbWZJUjViSWVpTU1xSGlmR25OSWw4NU12V0tB?=
 =?utf-8?B?anBHQnY3RzVaNDNDKzRBYU81ZmdYd1FmRHlmQWpXTmJ0c1JXV2ZDU1NQYTRK?=
 =?utf-8?Q?1LPee4y5y5xvTMzNj4VPQ1miRfnHSFdb2FK2Rgu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1cwbXdNUzFkRkE4akppTHN2Q3N1ZlQxdXZhSXhTb2tSUmpORVErTWRDaXF3?=
 =?utf-8?B?eElVMHJ3bE4zOVEwblJ4U2paTjl3ZGhWRkV6dERsK1FWNzhIN0xxY0xocFV2?=
 =?utf-8?B?UXl4QlFqRlNXamRFZHNyUDdIdWZvQld3YVFMWEwvc0pGY0hhTXBPQVFkSFhK?=
 =?utf-8?B?Z3ZOeGE0REsxaW5nSzF4cHM1UWk0SXByakV5VUU5bDZMSWFNbUxRTXozeFor?=
 =?utf-8?B?Y1FYQ0xJQXZ3c1Z1Q1JzTGg4eExXY1JlNGlHcnpDWXpSb1lZcWRnQXY4bFlS?=
 =?utf-8?B?N2dXaTFTN0Jsc1RLNm9COGs2ZEJaR2ZlOUhJTGh5OWJ2WTdkZVhoVE83VHdJ?=
 =?utf-8?B?dytncGg3TXVISjIvT2tvMWxMQzlUWUZQQ0Joa0tsQVZnd01UZDhXZGE0N0RN?=
 =?utf-8?B?MmxKWG9GQkZSMDBFM1ExTk5KOERqeEcrbUJFMTlQRWQyVWZhNUpIYUd6NVIz?=
 =?utf-8?B?OHlCa3NDNkJVVU1RdFlBdC92Yy85Kzk0WFVRK3FmZ2tta2JwcnJPZkVhemJ1?=
 =?utf-8?B?UVJPb2lwRWt5cEdrZFlTVzd3WnlodHErSXh2NXRRQ1FyYklSTGdLMFJuc1Fp?=
 =?utf-8?B?aDAyMmpmREZTc1pjaFljRm9xUk80a2llZHVmRmlHU0NwWUdaR0FGbDd5eFUz?=
 =?utf-8?B?ZE5YWDZteW1xajFRb3d4RisvMUw2SGhXWFNzRUFIVGpOU3ROc01PalRRaFgz?=
 =?utf-8?B?RnhXM25Jc0FYRnBtSnZVNFYwZjZRL0U1N3JKZmNBNEJ2U1dsNVBOYVRpb1NT?=
 =?utf-8?B?bXVPTWpGWlcxSzVMU0lTZnFQQ0g5d0dnZTkxOTJJdTRwU2hsSGVNbVU3S2dq?=
 =?utf-8?B?bHRGNVpGZ2pLQzU4ZXk2ekYvTWN3WWsvSW1EaC9TQkVTbHV3WkZQT1A2N3JN?=
 =?utf-8?B?RzZ1dVVGNml1dy8rM1hkaS9YYjFVRm5oR29PZlBHZDFJeVJ3dEExMjB5UVVC?=
 =?utf-8?B?dnJXd3hZNi9RSEJoRDRBaFBZbEIzMS9MNGhuV1F6WG9rc1ZsVUpRa1pQb2FS?=
 =?utf-8?B?ZnJXYW9HeDRjelJucDI5Z3NXQjZCU0UyaXhaV3lNbHRhdjFBNElienZqWWtD?=
 =?utf-8?B?KzYvOGtMTXVqZkhqaUVvczZGWGkxSEY5RXBpcy9qbEQzZDNoZjg4M3NKYUxW?=
 =?utf-8?B?K0xHSUpnd09DNWRPM24zdWxLckh2R0RjdVZ1RktqaVhjVExjcmx5clVuLzhD?=
 =?utf-8?B?WG5va2UxUklNN0NWL1FUeTJVTElsODFHU2kxaHoxQ0VjQlJqRzI0OVVsMk0x?=
 =?utf-8?B?eHdWclVKRk9COWNFWkIrZTZ0L0U2Vk5HSFF2b0RUMUxJRy9jMXZQak9aK2hV?=
 =?utf-8?B?Tm5TSGViNTZ2QlZUendIN0J4Qk9aVmVGYXVWWFBGYnFONDMzNkRiRTJycnpV?=
 =?utf-8?B?UW1GcThXbGFtTTgxMmRQZEx2WEQzaGlQc3VrekQ4SWUrblNvS3FVUER4M01y?=
 =?utf-8?B?WGliQnpNc3EwMktITEtqakhjZ01QRkxVRitDbms5SWt0bEZSbjFxVlRDaklj?=
 =?utf-8?B?TFMxUFZwUUlKSHg0T1lvWmF6RHp1YkVnMEh4cUc1U3QxV1R6cHkyZyt0SXdV?=
 =?utf-8?B?c2Y5N2pKYkNiTWZucjQ4RTB2ZnB1UnBnQTQ5S2NHMG0rM0lyYjE5ZWVLMFRl?=
 =?utf-8?B?OEZDQWZGc2poeXRpZnZSYkFLUEdPNWprZE1RRVcrazZ1dmZEc2tBUDNNUkNk?=
 =?utf-8?B?WmhKd3IxaFF6VnJnMEZndEREbU9aa2xLWW1aMGw4WnJFcWsybGs0YnFpcWR3?=
 =?utf-8?B?ZU1KNmFxeGI0Q0xlZkdsT1psajJkaDRRSm5rU1NwcXFTSWFpWURKYlRQN3pP?=
 =?utf-8?B?VEw4TFBQSmp4RERaUEdSblRHQXNZT3N3L09zcU1qT2ZZWFNtVkhhZFN6VDZv?=
 =?utf-8?B?Y21jWUltL1h5WWJER1prWFdPL3RLbTJaYzgvS28rK2hyTXlIdDZXT3Rydlpx?=
 =?utf-8?B?bnFWYkE5bkN4WnAyTlJLWXNXbjJycXpIa3ROUUJid21SWU1ZOGpoN0d1UnhC?=
 =?utf-8?B?Z2pSbldFNksvLzBQL0VZT0VJd3Q1d2xpV20zMmNkOHpWWGNzd1JHVkVkcHlx?=
 =?utf-8?B?NFp1U1JraFROTkpxeElqNDFwRUsyNFBwLzVIZjZ4djhHNkY5YjFUREJkZmZX?=
 =?utf-8?Q?JfU2zlvWs78i9+nHGHcMARyMx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89dcd3c6-ae18-4e07-b5e7-08dc947945e3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 18:12:56.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKba6DpTR7XyiGUxYh0WVeOcp09klUHDQqS4U20G9UPib3pNAE5GLm6nOtTSnaQf4SmHGo+6uOurkFp+5HU54A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8059



On 6/24/2024 7:09 PM, Borislav Petkov wrote:
> On Mon, Jun 24, 2024 at 08:00:38AM -0500, Tom Lendacky wrote:
>> An alternative to the #defines would be something like:
>>
>> struct snp_guest_msg {
>> 	struct snp_guest_msg_hdr hdr;
>> 	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>>  } __packed;
>>
>> Not sure it matters, but does reduce the changes while ensuring the
>> payload plus header doesn't exceed a page.

Yes, it does reduce a lot of churn.

> 
> Yeah, because that would've been my next question - the requirement to keep it
> <= PAGE_SIZE.
> 
> So yeah, Nikunj, please do that also and add a 
> 
> 	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
> 
> somewhere in the driver to catch all kinds of funky stuff.

Sure, here is the new patch. I have separated the variable name changes to a new patch.

Subject: [PATCH] virt: sev-guest: Ensure the SNP guest messages do not exceed
 a page

Currently, snp_guest_msg includes a message header (96 bytes) and a
payload (4000 bytes). There is an implicit assumption here that the SNP
message header will always be 96 bytes, and with that assumption the
payload array size has been set to 4000 bytes magic number. If any new
member is added to the SNP message header, the SNP guest message will span
more than a page.

Instead of using magic number '4000' for the payload, declare the
snp_guest_msg in a way that payload plus the message header do not exceed a
page.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.h | 2 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
index ceb798a404d6..de14a4f01b9d 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -60,7 +60,7 @@ struct snp_guest_msg_hdr {
 
 struct snp_guest_msg {
 	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
+	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
 } __packed;
 
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 427571a2d1a2..c4aae5d4308e 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -1033,6 +1033,9 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->dev = dev;
 	snp_dev->secrets = secrets;
 
+	/* Ensure SNP guest messages do not span more than a page */
+	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
+
 	/* Allocate the shared page used for the request and response message. */
 	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
 	if (!snp_dev->request)
-- 
2.34.1


