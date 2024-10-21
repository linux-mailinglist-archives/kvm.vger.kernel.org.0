Return-Path: <kvm+bounces-29293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9BB9A6BB5
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 16:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A05CE1C21B9A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D481FAF0C;
	Mon, 21 Oct 2024 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N4U70Irl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AF91D1736;
	Mon, 21 Oct 2024 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729519739; cv=fail; b=d8GkyoLlou6LsUQi8qNQd2njXha57nj5XUnAL0ICt+eXl5zCYE/9XQEy4naQ+bcbaapFgnLbUp1p2Anug4YuPbuERTE0eqKtlmfDqaDBWH0mMtYddzS2gexBW3b4voI36R7hlSm5b2RgpQDinFG7kTSNq/P8eIvXCQmfBkz80v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729519739; c=relaxed/simple;
	bh=ye/ylgOF/PQPTTdQxNdJ/EMjCvjPowbxd6hsVsFvwbc=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=poBKG22jcPWqDRnGuBp4fp21wStC+ZI8ymoTVjG4OswFp/BK6AcHNN5UNBht6+YP/M+GaoJTBruC8OnprzZqeYK/AALbHfaIMhPz/r7TP0B5W6xK15faKr6bRvPINdn9mYJ61oxYRbCNB9pLEh+fqdlwgagPpUKpTgWuc94qpkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N4U70Irl; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNN0YyrEseO2u7VKz/zuMl4mNSY6h3MfPtt3dvFqPdXetJZ/MdH0KRpQC0q7m1E5tTIIhEPeu6UKQ8dYmM72V13+X/mLssqmXJ6AkgLKdDPIXYa5SCTDKHI+UzJ1mUnByWEYzqaTvV2k2xzDKvM2Aw/QYmkZqtI+t+k8UqmDC9tnAG7lh6WKRiVZU6Yf2jnPqFXbi+F6HsHSXi1Y+PqaEVJ+ywdNjz9GGbMnkkKMqUXV51EyvjbyQieBCqawkWNunXqfCtX0MV9pa7gW4dBhgDycmkcgO3hQaq/H/Abmon5vFYTlo02durGq5NBNfiU/T+y0gvBcqhmUlETL6pyZog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wl2DmKeJJIASGrHgLQ6WTs6aonkiVzYRAGkEcGaSpWo=;
 b=jAGtNKGR5ikEzUdp3hNE9tbI/0cVfHTtdUxFvKbTkA6yj/RI/nulT+ym6ASTrnBQTz2sYHDbT1DRiXIv1i6Smv79hNP2A5D+IXkuZa3Per92u3k3446EIOQJN/e3rMOdnvUR9Ri5tXXIIU/K4eSFMafFge3iR19jnn97it9IqlLxeG64x4EtFJLbDrTLFIscxWQxf4OMzENBeyGh799b2v7JPuZ/sUyilkYEAzZmalCcbKwN+W7OaRVNVPSZA8GGXJupc2eb13H+Gx1fyJ0HwaAWMs8GZdjhgntlGSibYuxBCWnjy0Si0SQMIkra5GAT1JB28kKimJ782UO9p4st3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wl2DmKeJJIASGrHgLQ6WTs6aonkiVzYRAGkEcGaSpWo=;
 b=N4U70IrllJ75m2TOJuV3tomkfqTr3zQY+nKG0iJCZwKExuritWfzytqTmtz8wTRTPtWGAiwVWY8DAvNpdueZ42q5qtf3f421Z/ac0VGFU1zcay05MuKbLhsDf4EA4/nxUgJopWr6V8icqtq1EPN2B30G8eL3rWMUvWy7x+FkRso=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7009.namprd12.prod.outlook.com (2603:10b6:510:21c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Mon, 21 Oct
 2024 14:08:52 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 14:08:52 +0000
Message-ID: <a25377ad-27ea-3a45-2a42-4bd41bde783a@amd.com>
Date: Mon, 21 Oct 2024 09:08:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-7-nikunj@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v13 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
In-Reply-To: <20241021055156.2342564-7-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0161.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7009:EE_
X-MS-Office365-Filtering-Correlation-Id: 38b78d97-08e8-42cd-0570-08dcf1d9e460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXhsdmcxUTh4blF6ZVlrWVFvWEU0UGt1LytBZSs5a1JtWVkxUVRmYXQ2S2JM?=
 =?utf-8?B?Ty85U3NUd3QrcFhJckFoeUFmUGtMQ1FyR09EQytXcTY1NG9tRGdqd1hjWnVZ?=
 =?utf-8?B?VFJpUkJxTXM4WnluVytoclo2dXlhWEFOZjBEei85T2xmMG9YYXFjTlN5eU9Q?=
 =?utf-8?B?TWRFTWpGZ09qVVZXdGlHRno4SE9qdUUxMWkxaU5QS1diOTg3M1hvWmNSWGtN?=
 =?utf-8?B?d0JjRTJ4SG9vZjd3aXBMcGpkaFBEdUNqWjNrZXpBUkdPY2tlNThrUTVkcXNQ?=
 =?utf-8?B?S0ovWWVvcUhZYVB3SWpzZXRaalUvU21FOVV6OEZyTzFaY1ozWm4xVEU1dSsy?=
 =?utf-8?B?aEkvTU1PSjhyK2xYcHdSRXoxTUoycmpVeWJBdWlvek8rRnNyM0xOWll1OEJ0?=
 =?utf-8?B?dDJ5aHl5djh1eWhNVXZwQnpWQ1pINC84a1JUd0Zhdm10d0c4NXJPbDA4K29U?=
 =?utf-8?B?RkZHRXpFeHAvQTVNVzFqYUtEaE82RnVZOHJzbk9Ta3gzdFNyelYxUkIrR0p2?=
 =?utf-8?B?U1k3NmZZUElhbTlQU3puMUhpOHU4R25nNmJaZlR2WHpyY3poRitHMHF5Sk5E?=
 =?utf-8?B?SWxnZENleDlnM0IvUFE5dGZtQTJ0OTJvMEpNS0pzcUx0WC9XaXZUQUJTbVVW?=
 =?utf-8?B?R0R5OXFYekZJYUIrdUo3WndMMmZ0Y05DK1NLNXNKYUgyREtyb0Q5b1YrU3hC?=
 =?utf-8?B?bTExM1B2a0JGejRhb2FIOVVWNDN2aE1DT1dTS1h6M25CcVVpOEdvQTNwOXNv?=
 =?utf-8?B?QWFreEQrckNhMzd1K0I4ZU0wZ0Jjd1U5bkpOM3lsRGZMeTViY3l5aVo3cUpj?=
 =?utf-8?B?ZHhtaUN2cFhSaWg2TGNZajVaKzFOcGc5VmF4eCtSK2R2bDNjWVZmTm93Umds?=
 =?utf-8?B?d3hTbFNDSEl0V1hyekJuQnRvbGZhZkJZRXBPVGp5SUZYcVhuRzh0NFZCa0pm?=
 =?utf-8?B?a01sdGQ3S1hnd1N4MHZ4M3ZoZ2Rhc1RHN2wydWRkMWFTa0FtRVdXQ0YzeGs0?=
 =?utf-8?B?elJOa0ZybitKOC9zZlBWaW5yQUlWTVRCREhqTGF3YjlMUkp0VEZpR3M1dVRs?=
 =?utf-8?B?SFhYY3dpZzZrUUtNY1hlajROZlcwYkI4TFZ4WURkOGlYc1NueWdzWEw0NWxB?=
 =?utf-8?B?Z1R6aXhaQlBwNEVIYTRGNjkrZEhjVC9kMWptaW9Wc05MTFUwenpqQi9yV093?=
 =?utf-8?B?Mk1Gd3Q3WXJwU2NnbUdiRnBJb1FMZWdheVBFNUYvNmNHU1RNWkNSMlNMNUpm?=
 =?utf-8?B?c1ZMZkVtOVJ6UGJ4Szl4SG5aZ3FodmZ0TFIwbEhXRVh4TEU5TGRYWTY3aXFB?=
 =?utf-8?B?ejBJVUVhWGdrTW1YWXZoS0EvQTBHdHZPVHpTTjRXUk1heE5LTllONzFRZ3h6?=
 =?utf-8?B?ZzIrNUF6TkV3ZlhyU3hCS3grVGs5bk9yKzdUVXFrMW1KeDRNTUw3RmlUcG5p?=
 =?utf-8?B?eEFMaW9zT0hnd0RyMzV0VUk4SHZkM0lIZURBR1ZqNlJlcnpNMXdCd2pQcExT?=
 =?utf-8?B?UDJkVzFrUHpFMEdWVFFTSm5oWVVINFZsemZNa293c3ZTVUZzZ2FyVXNsdit6?=
 =?utf-8?B?Wm1sN3RyQ2V0eUVUM0hjd256MGtGSlF0aE9SK2tueGpxZVZXdmtGbU9HVktP?=
 =?utf-8?B?VUw5c1hyeG52RTVJa05YZWozQnhZa3RYampDYW5aNmJEU0I2VXE3Rk5zR01E?=
 =?utf-8?B?RkQ3blFNQUN4OUc0MTU5Vm9Ndkcrc24yblk4WVJ2aXhiUERaZzNreTJ6WEgz?=
 =?utf-8?Q?cdBbUVLuy8wIraceHDeUHOmii+gTCKStStmlAjM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGV6V0ZkR0pSSnNmTUI0eXdiNENrOG9qc01YZXcvaDM4cW9BbmZWL01mck5u?=
 =?utf-8?B?YmFWOEZRSWh2Sk9YeU4vTzJxWlBYZ3pYUTg5cm9Wd3J0U3pFaWtwWitQUkJ6?=
 =?utf-8?B?d2pSc3BpYWZXOUFoZFlBaDhnNmZnTGhDRURnUkxIKzlVaHkwbHpvUEFmUlFW?=
 =?utf-8?B?ZG8zYlFTZDVGOTdtMnE0QVhOK09yMkFVUGk2Wm8rdTI0cE16Ti9SV1djWkVK?=
 =?utf-8?B?MGVQQnNFaHYxUXJYNlBtZlowM1FjZVJqUnFsV2gxaVhVMSs0c0dKSFZJTWlq?=
 =?utf-8?B?MGk4WXNpOWNKV3ErZzBkazNTMnpRRTNjNWFRQmdBM201b0FYNGc0MzN6M2tv?=
 =?utf-8?B?MHFncERtZ2dtOVR1amNkT0FtZDRBekxHYmEyZDlxQWZ0dnpOTUFQSUJ3WllD?=
 =?utf-8?B?YjNOSXh5dHZxLzA1N2tMd240bmJlT3hCaC9KZjNIWm1adzBsb0NZdGt0c0F1?=
 =?utf-8?B?YXN4ZEVkRFFncE14N2thMVpHeXNpKzlhZ1JTRzdXcEQ3aDJ0b09aaVFnUjQr?=
 =?utf-8?B?czhWS0k2dDRRWWk1OE1WMFZVOG53TCs1RmEvL1NlZTVhMXQ3RXRkeWZLM1Nx?=
 =?utf-8?B?eHVrT0w3VVZpRXNBK3pFc2R2Z1VPUklISG1MdERRTmtBTjZCODFMd0hMc1BN?=
 =?utf-8?B?Q1hoUmhIVkRNVDFMSEZWaXpKckZwcmNuWUppRk92T1h5dGZjN1JBVzZYM2VX?=
 =?utf-8?B?RXFOUDRFWGQ3WHpiaHlyb3J2MUdIQ2lLS1lrdXhrOHFQQ2RsdVNUUTd0MnRw?=
 =?utf-8?B?bTUwdVdicncrQ241RktzS1hKeTBDajg5NWljUWZ3NWtFOVlmWHpEdnZ1THJR?=
 =?utf-8?B?cUZEVXJuK0ZnYlh5V2V1YnZTT3plY0dXOXlJRlFDdEJVeC9sMTNCOUFtMGRN?=
 =?utf-8?B?Y2R3ZUdGbmk2RW1xM2hZS3B2NHEwblNncWRaN1lCZU5OZWRQc1REaDhnMndY?=
 =?utf-8?B?QjZrb0NRT044VnBIUjBZZ2dNaklxcHF6NEt5aGpiakVITk1POEJlVmMyY2RH?=
 =?utf-8?B?c2E5T2JSRFFuZVdOTU4vYjNkYkEwVHp6WVY5KzlTTXNNV2c1OVBnamUvdDF6?=
 =?utf-8?B?NG1IQjJxV2NESndQcVBjWitEUWpRQWVnVGRkZjBtbHJieUFvV0xxY3R6dFlR?=
 =?utf-8?B?bklpUzcvS1ppam0xcTk1MTZVc0d3WGNtVjdteXJHSXQxdlpqK1ZSYk9BOC80?=
 =?utf-8?B?TGtjNTFQMkFDWmVyYWZEUzVoeThGU1BKTmM0d0d5Ulcra3hSVS9iaHEvcEhR?=
 =?utf-8?B?YmFvSko4dHN4ZHFtRlhVYzFzbU90SDVPUjIxdGtrdzRjMkxZazNyK3RMSnNW?=
 =?utf-8?B?djdGQmRwajhWQWFUdFJyblU5U3hiSndBLzhvWWxmVWRFV1N1NGlwTUUraXhW?=
 =?utf-8?B?RktYYmY4MmZuN2hmUXFkNEs1K3NEWjg5elZJTmYxeTB5Z2FoSm1rb0N6NnVn?=
 =?utf-8?B?N2JuNUg0a3FKMXJBdWhMNng1Y1lEZ29FUURFTDJJZTdnQjRLUHNDYTh1WU51?=
 =?utf-8?B?c282blRSa0NCQ3Y2Q2ExV0k2R2tzc3VzeXZ2TkdLdlZDTGswQTBCd1RBRklL?=
 =?utf-8?B?NGJuQlNNUzg0TFVhNW5WUjc1ZXdVUEppekxockVoUUNtTno4TzljczVycER1?=
 =?utf-8?B?bHJRUWZjVWZBbnoySHlhRnJ2aDdwS0k0NHZSZ0dZUlFDa3pyV1JJeGs3RVRW?=
 =?utf-8?B?d0tYVTVCWDRKaVNsbi9IS3hTVUEweVJLK1pncWd5NFlUWkdNcnB4VUowNHh3?=
 =?utf-8?B?ZlhSelBTRkhqb0ptN2YvMTBBbWx2TGlNdXRvUjY4ZUhra3BnOG5kbmxWWWtn?=
 =?utf-8?B?UkIxVGNUdHhaODk1RFNsZW00NDFyZVNIdENiUlZGalNZK0JZUm5kd3RmbXpF?=
 =?utf-8?B?NVczVU0rWXBrR2k2cWhSc2lNQjUxNGk0MmR5NDBJU3JOUDFVM1I4SVFXNWV6?=
 =?utf-8?B?a3FocXJCU0VTMUxjSjJOMHVrcnFBRnVNZ2o4emhvNDgwNUlwODh0czdrdzB5?=
 =?utf-8?B?OHUwU0VtT0ZrTTBBVVhUNDdyb0l2YjVISWFId0JoSzE5OHJJYVNiWFI1Qnd6?=
 =?utf-8?B?L3hEMnZlSkpFTHBYNE1Ubmo5aVAybmprRmUxcURBK2M3SjJ1WGRKMTRwd3E2?=
 =?utf-8?Q?g7Tee6UWaogL0fd+d3EDDZLxQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b78d97-08e8-42cd-0570-08dcf1d9e460
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 14:08:52.3460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXjhE/FijLCihavZ+9pg9n97hXAN0cLXPVXEV4b+cw90CGjjgWBbAjRjKea1pOIve2pU5en3dh0tlHaZvqB1TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7009

On 10/21/24 00:51, Nikunj A Dadhania wrote:
> The hypervisor should not be intercepting GUEST_TSC_FREQ MSR(0xcOO10134)
> when Secure TSC is enabled. A #VC exception will be generated if the
> GUEST_TSC_FREQ MSR is being intercepted. If this should occur and SecureTSC
> is enabled, terminate guest execution.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Just a minor comment/question below.

> ---
>  arch/x86/include/asm/msr-index.h | 1 +
>  arch/x86/coco/sev/core.c         | 8 ++++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 3ae84c3b8e6d..233be13cc21f 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -608,6 +608,7 @@
>  #define MSR_AMD_PERF_CTL		0xc0010062
>  #define MSR_AMD_PERF_STATUS		0xc0010063
>  #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
> +#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
>  #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
>  #define MSR_AMD64_OSVW_STATUS		0xc0010141
>  #define MSR_AMD_PPIN_CTL		0xc00102f0
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 2ad7773458c0..4e9b1cc1f26b 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -1332,6 +1332,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  		return ES_OK;
>  	}
>  
> +	/*
> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 */
> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))

Should the cc_platform_has() check be changed into a check against
sev_status directly (similar to the DEBUG_SWAP support)? Just in case
this handler ends up getting used in early code where cc_platform_has()
can't be used.

Thanks,
Tom

> +		return ES_VMM_ERROR;
> +
> +
>  	ghcb_set_rcx(ghcb, regs->cx);
>  	if (exit_info_1) {
>  		ghcb_set_rax(ghcb, regs->ax);

