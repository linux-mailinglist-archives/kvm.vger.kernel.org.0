Return-Path: <kvm+bounces-66924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D45FCEE74D
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 13:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D64C302177F
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 12:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FA430EF90;
	Fri,  2 Jan 2026 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tNI2vE0z"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012024.outbound.protection.outlook.com [52.101.53.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94812DF12F;
	Fri,  2 Jan 2026 12:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767355755; cv=fail; b=QIpXzgYTgmEaXketZat8UrFLFAvHAyHqCaZ3OtFCds0ulHdLXeVCN09PDrquG4GY80lOGq5rbKqrEYH1G2Za1FRjn0yqrkyNNIizVSPkUOA2CYTb6C71nc5C6OfjnIvE7oKDKrCqPIpdjhYuatDibXJjkQ5EAfD5KeV4/Hu9zgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767355755; c=relaxed/simple;
	bh=ikIfiLx3wYeHl77XkrAToDkCzB3NDyEWzOh/mCqo3lA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sJNhpLzbAbod7NcmNoaJJ5EJWJinaf/OYnhrTgzj2WeD5GQrZYBvbRCU8STs6nMxXksX2sC5P/bgrlqxtg634tFGTRvvb47dKwlv45D/Yq7C0G9XuTjVflH3OU1M9TcLaGZRTzyGg1islhpDFE+LHFz665zUCv9fzCHjLin9WJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tNI2vE0z; arc=fail smtp.client-ip=52.101.53.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dSZtnlqKfRyqMD3lBnx7gbp9RVdHhn441H+tz0q1k3RAv3xd3wmW6p7Y0sZdMlFbHhpKPTUTh1sNxhwFRq4yazAIyo50Wvg+MIhddgVp1lHRYsT/4OPyZSYweE/VeZHaJtC4FUJHNH1hv2PYwQt9Ro+k6Z9nVIkK/gdpjk6IuMEuohStKMLyIPviNktcRJXQDzWKXgqOc3VYOGGMB4R93SM+HQQC23ebEgImGROmsQkaeenLidXBr3xZ54vVb5q4MEiWuIBH0lPtrj0yRy5lIG0MSh8wQVm8phJv8yHSNVvB42yxmASbWSzG1byTP1wPIKCSCQNzj+awjcrQpXCrKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMbItBKWMb2M9CwUHj6+GDk7nwmJpBtd+kHfj0vmiIg=;
 b=GEa7q4a4RjKYmkqvr32igRUcgfGdEMouc7hd6FWhxGdQNbmznx2pRamPcL2nHcWdJjwNdoKGnKDUDSGC4AbUFLSEiwPuFOok7SddVuhSb/0wbyk5i4idp7yFGYj4pmOdEso81JEPp3HbJd/Ki7TOW/e1jc8fkS8p3oAIK+18+Bh/af8jTj27dTR8IkuRFh/xSo3TJYXVacHs3CB34GHjXGjrEio5Y6fgZn9WU/ZSa+lz8VYUbdOGVSCH+KPxK0X0CR+WHxBcEMHvs4uC0FgxVKL3EAvJWahT7ZvJlyDsJ8SDAqWHlC00775zGrDe+V9szN3aD9VoCCs5xcXsKj/XWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMbItBKWMb2M9CwUHj6+GDk7nwmJpBtd+kHfj0vmiIg=;
 b=tNI2vE0z/erjjUh5IkwNY2a04IbAKhOM4+mr9V5Y19uUP0Pp2ku9oym3yOsYF1UkS+LUMsS0c9bzZ8ethcQLT9t7JPBsgssVFsx/RS4eQUebhusBCKyUUFi3mod5YeVLWugP9Q/24XBtpxYEir2+PP8Au9gLu8ogZcOsCd3c2P1If8Q7S00q0Bq9Kg/UwnMvBcATMFiOVYKwMMAmM58S/8Sz9BOJCZ8zpRGrcvdDhvoODv7ledM1yh7YhCCzk1t3PhY7z3U6vFSKpKTipveTvpTnRfyUpoNOxTKOQYd+8J2zMmubE6RNTewHM0S7b1XBUoe9zwPvD5gdElWpswSGsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Fri, 2 Jan 2026 12:09:11 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::7e7c:df25:af76:ab87]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::7e7c:df25:af76:ab87%5]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 12:09:11 +0000
Message-ID: <09178761-3ff7-4c6d-bdf4-cbf16531d71e@nvidia.com>
Date: Fri, 2 Jan 2026 13:09:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] vdpa/mlx5: update mlx_features with driver state
 check
To: Cindy Lu <lulu@redhat.com>, mst@redhat.com, jasowang@redhat.com,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org
References: <20251229071614.779621-1-lulu@redhat.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20251229071614.779621-1-lulu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::18)
 To CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|DM4PR12MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 206eb313-bc99-4800-6122-08de49f7bcfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjN5WmxZTkIrQy9LWnEzNG1ibW1JSENzUUtiYXZMNlNlWDFJVmxTcFpqbEFT?=
 =?utf-8?B?ZC91UUw1d3RKMjhvb2FnUU9jVXJ6Q25YNHJqRUVzZlNiTkRMY3pSdlJRVlI0?=
 =?utf-8?B?WUZVSGtLbjVSdHhQL3pRWGFxUnNhYnM5T3diM1RRRzN5Q0RXRVc1RC9DME1y?=
 =?utf-8?B?alR3TCs3MXRheEwvUkhZcGM0RjIyeExySWVDWjEwSy9IeUtWSGRXV0NuRjJn?=
 =?utf-8?B?dUptQzRXU21IYlUwMzN3ekRIU2J6VDdNVTcwTHBaNVlkTE1PcU5sZGtpYlRC?=
 =?utf-8?B?UTFJSXRBbElXRmpyZUJFN1JIKzJmczdpU0xjWG00R0FIdXJaa2o5amV3Rm5a?=
 =?utf-8?B?R0dubE9tOU1OMEVmazBDdmIybWtobzQ2aG92T2RGKzNBYmFRUXA1OEFMeUUw?=
 =?utf-8?B?NUZJL0tITUVxZW0ybXgzeHAzZ3VycG4xSU1mOWdZT2FpbTR6Z3VCVSsxWnVF?=
 =?utf-8?B?Ym9FdnNYdDZLbmgvYjIvWlNIMW9EaTJsYlpPVjRPRkQ1amg5bzBCc0ZhNDRi?=
 =?utf-8?B?NkJoZWd4QXZQTTFJWmVHajRDckc5VFdoU3BUY3BOQ3k3WElZa1JHaTlIa1N6?=
 =?utf-8?B?Zm9JTnJac245dHNkS20wUzJGL1RyaTdQeWczMy9sRDY4K2M4MzJWMVJYNDho?=
 =?utf-8?B?SE5Lb2FoaHZOQ3VocEJ5MVRYKzhuR29WbVpvU2dzV1pKMzMzZHVRWmVJUC9m?=
 =?utf-8?B?TVFkNU1xRjZMNVJuY3JIZW8yTVFFeTFtUDlYL1BlcFFnaVJJbGc1THV6U0E1?=
 =?utf-8?B?VXBVUXVGYXV1ZHNCS2JjM0JmTmt1Lzk2M3VNVnpaRG1PaE94UTJqUkFRTGR0?=
 =?utf-8?B?T0x2SHF0NDlYOU9jVUhlaE5IYStoZTM0VU56emhGYVlFREZ4VmRvZHJ5RHp5?=
 =?utf-8?B?ankrTGlwN3ZQY3djc0NoYy9mRXZqZVNYUFdKa2pUYkFQTGdNdnU0NnJaY3Q2?=
 =?utf-8?B?d25Ja1pRSE5kQXpaazhubUR3Szd0TUZuR2NMWUZ5MkZvZWk5MmRtOTJjR0tH?=
 =?utf-8?B?VU1WeWhHQlFWVGZGK2pDSmU3OTZuSWZzUTBVNjZHTVlnOVRrbTVLcEVvL1Bu?=
 =?utf-8?B?T3B4VzBrZTR4c2p1dmNEVldYWGNKU1NleTN4KzdWcXpTeUtva0c5dnBzcHY4?=
 =?utf-8?B?dCsrdFcxZFBscjFwMysrOXV4VmVwdEJDUXBOamRoYjQranpYU245RDM5VnBV?=
 =?utf-8?B?LzNoRHZVY3IxcnVQRGZFQ3dYTGVrNmtsRVRNeUJXUVpVMzA0TnU3aWlEd00z?=
 =?utf-8?B?MnRsNlJYc1hCZ240MlJRNGFTb1pybWVTNkdlMFZrTlp5T1ZPdEk2ZUxMNjI2?=
 =?utf-8?B?RGFxazY2WjVhdGlVZFpWUXNzaFdDc2F2UnhKMFdmUzFuUGdJTGpMRHlrM2Qw?=
 =?utf-8?B?TjZoQVBzVHhwY2RidlFSTjgxOFlsbEpTVTZaV0lnVmduNDZuTWVVZlhsN2dJ?=
 =?utf-8?B?TWJnK2ZiRm5GaVhHUlRFeGVYNktXVGNWL3RWWmFjY0N4M3lpN0RjbWF0aXIr?=
 =?utf-8?B?YzJ4dUhIT1B4a2lzQjVpSEltN3pDYkY0cDJOcnIxV3ZaOEN0ME5lS0VSUDEz?=
 =?utf-8?B?czRWbmVOTHc3Q1VXWUh2K3g1b1pGNGN0ZENUb1BWM21VaW5PN1pDbHhBZG9R?=
 =?utf-8?B?a2JLWGdlQlhVb241K0x5dHBVVTBOV1gyck0xTXREMGRKc1k2bCtmUmVtY2tL?=
 =?utf-8?B?YlBUR0JoK0MvdmM3SHBFNS9qbWtNZUFtNkFlZEp4Y1JCT2NKREhmRmxycUlB?=
 =?utf-8?B?T1NBSE9lMjNVMmxnYTAyaittMnN5cGd0OC9NRzdaYVVES09wZTRhdFUvTllE?=
 =?utf-8?B?Y2hlK2FlMGFteWhjVi9LMU1wVVpxRWkrT2V0TmhYU2dHcmsvRnF4aWtCNElE?=
 =?utf-8?B?UlhkdFdmdzdQU013S0E1Q2svaVVtNGtuNXJ5WXhQRFA4dzRKNTdnSlRRSFlo?=
 =?utf-8?Q?VOK2FzMnsV/m/yDZwF0m/zsTGMzBAVMZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHVtNGNMSURUczh3L3o3N002VnVlbU00REFiNVE1YTNqeUVXNE5sTE85N1NB?=
 =?utf-8?B?QUwwWENQVEQzQ3RGY2IvWHlKM1hJM0FZazJkQW9RWlFRT2w5UlJ4TjU3QUtu?=
 =?utf-8?B?T0YwWFVMRUVoUmxhMzdMK2RhdkUvU0RweG9EUzk1NjBTYk1NMEtsRG1nbTds?=
 =?utf-8?B?SnF6T1dsdUVRNlFpSERHLzhVVUNoaEJQSmg2ZFBBZUtHQTJaelI4UUZlbDlC?=
 =?utf-8?B?T2VtMng5Wks3SUhuNkNoOFgza2tuSzJvOU50OVlWeEJ2czcvRkVpNnAxdmdQ?=
 =?utf-8?B?bFNhWEZ4WGtZRlFqb0daS2xzb1lUK0JVOGphMU1lazB5dzQrbXh6amVyeHV6?=
 =?utf-8?B?T1pUYVVvL3p0b095dlpJKzBhbGZHYVc2MHBHUlVPaE1EVG9YQTVLejRQSm9y?=
 =?utf-8?B?SFcvTDlTdDgwaW5IeVE2dzl2K2RtRHVkOW9xTFByd2UybDBWWmdocC9RVDlB?=
 =?utf-8?B?SkdjRXlsQTR6SWhRcEV0MWJOSmdOYzRSeHl4aW9PU1NtM1UzcmQrV1dDdG82?=
 =?utf-8?B?Q01Ua2RuTnE3bWRBQm04VzRkcUJSOUhYWUkrM0lHWm9KWExYOHJMS1FyVWNV?=
 =?utf-8?B?TTlzQjYrSzZOYU4reC8yTTVDenB4NlMyeGp3OXFPSUtIczMyRkFrenFrNndl?=
 =?utf-8?B?QzFVME5XV2I1ejdiQVdGcng1MkwrM0dXN3ZKN1JrZ3pFQ0gwRmVTRUJCTTIx?=
 =?utf-8?B?TUI4SUdzcjNpMmVwL0Z5K2poMUNJcVA2SEVUYU9QTzlBZXNjbFBHazUyZ3Bm?=
 =?utf-8?B?QnFiS3VuUEtsaDBueWErN1pFRVZ3VG1FbDZrUWtjR3NScTdwb3BDcGhCWWU1?=
 =?utf-8?B?THNJbzlVbG00M0h1SG91cXJiRFhCZG4rczZoQ2l4Wm5ZL05WYWRIalZ3OXNS?=
 =?utf-8?B?MXNWeEh0NWtSNm0rMm9YeUIzUTNpTTd5Q0pwT1puSDJNeGJvTG80bm0xRFE0?=
 =?utf-8?B?MGZ3THYvaURNRm91TXJaeEh0MmYzM2M1NTNYa2JkZnlQdzAwVThDVzNFY2hF?=
 =?utf-8?B?V1h1eFNLZVg3cGpkNGVjaEhjSUprREUxK2ZKQlpRMkpqZEJiUGV0QmxjVDRq?=
 =?utf-8?B?dnJ2VGxzSExwWXN2QWUyRGN3WlVLVm5CMHRZWmg5bmR6Vi9NVlRGdS9TdXpR?=
 =?utf-8?B?SEdkUVhReUFFelJPSmFrMFhlNVJTWlkvVVhpNWpqa3dlbU95dUx0M21TYldY?=
 =?utf-8?B?aVNCNVNTUEhFL0VWbUY3L25sNXRxYUcxSnk5b1VaVzZadHRqS3owWWJqcG05?=
 =?utf-8?B?OW9meUJWNDgxUEN5Y2JpTjhkbytxaXpPMGx3NGRqUjAxNTFPcDZJVlFFRnVW?=
 =?utf-8?B?OUxxazBZT2hMbFZuUU5UWlF2MnlXenhGS1FCVVpSM3FyVWUvTDFJZlZxRDB6?=
 =?utf-8?B?Q2ppRnVEUWJYTDlhTDBPOW15WCtxd25oaFk1aHZ6SHMwSkxWSzBGRlkzRm90?=
 =?utf-8?B?U000ci9KdHczSCtuemNKVzJFWTA2ZTNEdlA0S2V1bTVvQk9KUzh4cWFWNXBy?=
 =?utf-8?B?TmkwbC8rUUQrK05CSDZLbVpLTU5GYWUrYWdjWERXZFA0M1JOYjZpaUt4MFFj?=
 =?utf-8?B?TlZhUXV6UDVTcDlQd1dOOUMzTHRtS0pMWTNDQXZCenR5UHlJYU5PQXBlZ29w?=
 =?utf-8?B?aUZZR3RBWnY1SnhHUWs5NSs5YllLdmpudi8vZGhoSDdsZ1FpY3lVd1dvSUda?=
 =?utf-8?B?UkZRSzlpQUhHeHFSbHFaYVNMYmNsZVFrVWhCaVIzdWlNRmpMalhJOTlicnVN?=
 =?utf-8?B?R1djbktvQTBNNmpzWkNJeXBLNHNxQTBreEM2aEtuenUyVTNPYmg2RkVab01u?=
 =?utf-8?B?SFdxanZ3cUErR2xSSXA5T2RmNUZxSlcxYjc3QVRUbkQvZVdCWUNjZTY0UU13?=
 =?utf-8?B?SEVjWjVHaDdGRTFPR3FmamM5VGl3OUsvZmFzMUJJSmtMWVhxWjdubG1RTHN5?=
 =?utf-8?B?K2tmeHRjQ2xkemFSOHk0V3hpODNZclV5bnBPeUtUcWhnek5kWmNaeFlsNXdT?=
 =?utf-8?B?a2UvWjRPUWwrbDNwNVkxQStkSXpWbXRZcHh0YnYvazdZbUI2cHF0NmNsMlUx?=
 =?utf-8?B?S1BQcVo1ZkRQSHh2cXU1dXcyb1RJb2N1VlNHNExnSnN3OVN0N0tLTGJqa2Rz?=
 =?utf-8?B?VjRSSllFbUZGdXpRR2poZnh1RC9YMVRjOU4xUm0vT253bjhYbjVuSzlDNFFa?=
 =?utf-8?B?dEpxZktOK0tPOHZJU0R3M0UxYWswTmhyN0pzSCtjSzIwZis2RVZYcENpRjR2?=
 =?utf-8?B?cEdnK3VJTFgraVdMOVFsSFB1UVVCRlN5aVhoSEh3TjBYRFJzN24xQ3pHY1JL?=
 =?utf-8?B?WEJPNktiV3ZxWWxzMkJmMUgvdHJBeDRWWCtGQTY0S1duUG1OUExmdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206eb313-bc99-4800-6122-08de49f7bcfe
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 12:09:11.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jlLDsdWCYKavx+tDKHIwmP7KRxmH8B2V+hmXCochpFza3B/hawdya+5iUyZglw2TqZA2uMX7qjE3Bkr9aFL+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6373


Hi Cindy,

Thanks for your patch!

On 29.12.25 08:16, Cindy Lu wrote:
> Add logic in mlx5_vdpa_set_attr() to ensure the VIRTIO_NET_F_MAC
> feature bit is properly set only when the device is not yet in
> the DRIVER_OK (running) state.
> 
> This makes the MAC address visible in the output of:
> 
>  vdpa dev config show -jp
> 
> when the device is created without an initial MAC address.
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>

Having a cover letter with the summary, history and links series would
make the review process easier.

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index ddaa1366704b..6e42bae7c9a1 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -4049,7 +4049,7 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>  	struct mlx5_vdpa_dev *mvdev;
>  	struct mlx5_vdpa_net *ndev;
>  	struct mlx5_core_dev *mdev;
> -	int err = -EOPNOTSUPP;
> +	int err = 0;
>  
>  	mvdev = to_mvdev(dev);
>  	ndev = to_mlx5_vdpa_ndev(mvdev);
> @@ -4057,13 +4057,22 @@ static int mlx5_vdpa_set_attr(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
>  	config = &ndev->config;
>  
>  	down_write(&ndev->reslock);
> -	if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> +
> +	if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
> +		if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK)) {
> +			ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_MAC);
> +		} else {
> +			mlx5_vdpa_warn(mvdev, "device running, skip updating MAC\n");
> +			err = -EBUSY;
> +			goto out;
> +		}
>  		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
>  		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
>  		if (!err)
>  			ether_addr_copy(config->mac, add_config->net.mac);
>  	}
>  
> +out:
>  	up_write(&ndev->reslock);
>  	return err;
>  }
The patch itself makes sense. For it you can add:

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos

