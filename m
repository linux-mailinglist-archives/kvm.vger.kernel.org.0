Return-Path: <kvm+bounces-43655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D680DA93701
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CA231B6602A
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905A1274FC4;
	Fri, 18 Apr 2025 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1hRVhsNW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDFF2741AD;
	Fri, 18 Apr 2025 12:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744979113; cv=fail; b=CtPre8HVa4YN+0E5wQyKSpEB6We2K+p8rnXKkkTiH9pLdIROzfOPAP2OX1WqimxqKxXghFIF/lsFv82ZIdYYJidEhzDYEA9icHW/QMvGUuiCD/aqxPhBPoVXIbjkT41HyMmpXh5bfHS6perQJz/aQEozKhCd6ozkUvJkF+XopEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744979113; c=relaxed/simple;
	bh=9ZvnVvvamxHETrZoaHoBHt2fJuxHhtFyZptj/uu3m6E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tJ/4MjcvlQzW9Quqb4IdOkW3VnxMaRXibmhiFILwBAiiMLxsNyNcrMDk8ZGEW96f5PKWJ6emBRjkVp8IDvmnklxKNys4SfYoSehg84e7HR7gfODkGvnxEoku9gY6IN7WrIiCQEGDD0GGY6QIC8zyXTDPdK9INgUZ1hpqFTl67J4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1hRVhsNW; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l251TwIj8I00nkJ5y29tfNYnXZRRV5wvP5ALuBW39opEDoYfcm5zqXOInuXGjbL/8O+dJRbmbM2Y7KCIQjqCzkiluvAgkWTMpCko6Afrn7RBUWL11CsZHnyuz/6YWtO7QqeU0nPDcI18nGjUimgrYUXBxq+dxP0MKka5uerXZKz22iTKtzNBPS0r7JFIkj8iQTqq48yVfCOz6bqHpcMHB/BLfIWGdEPP8RPjACdpxlnKRPaI41l4DPRLt9N22q9IWMfkZzdSEc8+VGb/KsFdWAPLynANoMK/550uuIQsit8RR5TQmdOtXB4whmoCXucZIZx/vJiaS8gKQd2LruXX/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rv2Zs/zrudVqpfCX1Pj3sxdHnGcd29IIwaBFBfnRpio=;
 b=zM6p2bfFb750bPrzCKmFkqBoSNzpuj7h3NaDk6rT+0OIkvwKbCbEnpR5cv4dXQ6OES4a5OC7ajkqyh1D4D3M1RrfTyCXVBMHVftD3/UDpN1jJ+S3AODi8A21DS5DFINoQku2MsUV9SJTq6KWlkC9V2z4sII3IRV5jb4/UY8o4mkQxTlp9FYzNIeOqYTEt3biVIwYE9u90gY2zYiDOvTsNPXcl2rQbW5Hr8f1Jvol23CjPxhgB47XrF13rL4ZCkj3Sd6cT7ac7gGnrbY3B7Ap9YzERnW1eY7OF1BYi04wOI+ajxklJwY1HHWLFpSUB+FS3ow+bAUQrs6bNM8eeVQ0vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rv2Zs/zrudVqpfCX1Pj3sxdHnGcd29IIwaBFBfnRpio=;
 b=1hRVhsNWf+2KG9uJsXd5U0cpxe7JJx3CjOJ5IREEwPbarOav3+JscaeV4nkCPODWtEBOKcNYMOXlQHHbo1ofACUxNET3ejTcQOqPUJsofNw6guhConyQpnJ5s6FnXGQMqyJodMIIyT9xicwxTjqM5O4WeukG0iIoDMnuXvFiF14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA0PR12MB8422.namprd12.prod.outlook.com (2603:10b6:208:3de::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.34; Fri, 18 Apr 2025 12:25:09 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 12:25:09 +0000
Message-ID: <2c72358a-13f9-4925-9cfc-50bb61e9d9fb@amd.com>
Date: Fri, 18 Apr 2025 17:55:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/67] iommu/amd: KVM: SVM: Delete now-unused
 cached/previous GA tag fields
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-27-seanjc@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20250404193923.1413163-27-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::9) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA0PR12MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: ba456b70-c9d9-4337-ae92-08dd7e740eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TlNLTldzMk84WWJpVlB3UVdtZk05M25LbUtUazNuRmtlbGRhdlpjVnk4OExK?=
 =?utf-8?B?eDhIK3ZFTHFSekNnQzRHNytMck5SRFZ6RlV4RU1NaWpIV21xZTBFa2RVbkZ1?=
 =?utf-8?B?ZzhzeVRpVE5LT3lPc0JJV0w1YThubldWUEcyUUNleVVpV2F3UVZkTm9TSW9k?=
 =?utf-8?B?ZzZablNMMENETTV0VmsrS3hQUHlBdUhtN0FUbkZSa1dLY1phVllFZ01wM3Bq?=
 =?utf-8?B?cWl5KzZTRkhhNk5UelNyRHJZN1ltbElGMmsrSjhUSW5QL1ZmRlVHNlg0ZlFn?=
 =?utf-8?B?a3pFOWhZb0dlZ3JXd2cvVzJTNndXT0hweUovWFpGWTJ2b1BzbWhMSjJJd1Zn?=
 =?utf-8?B?VnRYRFZZNlJwOWpxSGpKR25JZEMzclY4dzlrSzI4alFyWVJDaWMrczI4clpW?=
 =?utf-8?B?VEQ4M04xaDRUZnFsUm15SDMwQ3lBMGV3MVQwZGxmbW9OMmlLYS9wdEs5bkJ3?=
 =?utf-8?B?dG5oVmZUREdUeEpRY1JaMFVsNnVCOHQrVjZDWnFIVTZncnhFUldudDd4dDND?=
 =?utf-8?B?WEFFbDRybVVRc3lJOTQ3dFJUNE1XYXNxK3BneWZxMlo0SEFVM2NxVTIwQ1RU?=
 =?utf-8?B?Rm1EN2Q5dTlOUjJtNWF3aVM1ZG5FWEovbWVSSDNZMmxaSUd5aUk4SVB2NkRG?=
 =?utf-8?B?S09yQTdJQVlsQ05UOGZaZFZGcnhIa3loZit5Mm52aGNGSWJzRE5mUDQvQklw?=
 =?utf-8?B?OUNxWk5zdUIrczZwMG5yelZQQXM3N3lhejdycjA1SXdqRUxJSmlZVUVJcXVZ?=
 =?utf-8?B?dmJjUi8zRnM5aDI4Ym4zeHZLNWlialJHUXpyRVBDRUJ5RHFYcGd5aDJsOFQr?=
 =?utf-8?B?ZE8rQVQwN29KbGdoMVUwS0xPMVB4OG1RS2Ruamt2cm5wc2VKL0J3OWlyVDZz?=
 =?utf-8?B?UkJjZkd3SlhIRzFKa3J4K0Q0Sk1Ta1o4ZmZQN083eEJ6YXBYZm1lWGR4cEs4?=
 =?utf-8?B?TmpUTkp6K3RHeldpQ1g1UEwxMFdoV2ZPZ2tUd1BhcnRWclQ0aldhZFo2OGlw?=
 =?utf-8?B?MGxHV3dOd0M0SlR6cVNKdnh3WEQrcjZVT3ZOb3hUUzVBcVdFS3A2aHYyZUhk?=
 =?utf-8?B?cXUzUUhPbGxSYW0razE2dnZteTRUWGpoS1NYVTk3Qk9oZCs3RHV1N2tZVTlM?=
 =?utf-8?B?SXJla0hqbE9rbDZGYTVmRFlhMGUzbHRSNVdxZGt2bno0VUZWU2M4N0I3ajAr?=
 =?utf-8?B?ODdlT1llQWIzOUZ1c0Y5WWZpVU5BbUNzM2FnK2JZZ0EwVjM1TUhpTzRpVnRp?=
 =?utf-8?B?d3ZsNHZ4T2VsSUpuVHNSMU14ZnZYdFUySXJobzdZVDA0Ukl5ZGJDaWdmQXhl?=
 =?utf-8?B?TUhFbFVtYlQwYW00RWV6S3JxNHJwclBpSzlYN0xrNFFQa0hhQ1RRN29HcThl?=
 =?utf-8?B?SmYvc20vUjh4YTNWbmV3eUFxS3czd0IrWlEwaXd4VllqYkQwcngrRWtFZ0xu?=
 =?utf-8?B?SWdQL1lnTmROUU0yeU9jVUtTMGFveW13dXFLRXRHTFRjRC9aMDJCa1dxcFpr?=
 =?utf-8?B?a2xGWTQrZEdMMXQ3bC9DT0RpdDBscDE5ZDA2TXVEUWdUZ05XRTl0b2RsRHpC?=
 =?utf-8?B?dVBjcEdCNE52M2xZUjc0dE5PZnZBQzBNMERKK0NVMmJPemplaWQ0TWNraVFq?=
 =?utf-8?B?QnFoa3JmeEtDTUkzUXdNa0czbnQ0WjhaUUMxTUVQZEpvUE52blpsTDBDQ0RY?=
 =?utf-8?B?Vm1sdWRGTjBURmdJQkF6S1NxSGcwU0NMUmJ3aHk2MFNBcS9NZnZTMUkrdVNm?=
 =?utf-8?B?U1RwVFFjSHo4UmVFNU9MaEVzWXJOcFlzNlVOU0h0b0gvbnNSQjZmM0VkcUhm?=
 =?utf-8?B?SU1HelFRQ1NKaDlSbGZ3aG9aMFV4amttVmo2cXRtOU1QRWJQejhwUkpWK2xz?=
 =?utf-8?B?K3gwL3FTTDd4OWpyL3RYRE5wejJ3K3lac2FiNEs1Tm92Mk4zUkY5MFlPVjF4?=
 =?utf-8?Q?L4mDpfc9gkk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVJ3cXVweWF2UEVZUm9STXk1RXQxSkUzSjNvcXc2L3ZIMnNvcm9wbjhhYk1O?=
 =?utf-8?B?WERoRC9kdVEyNUt0aTdraDNSZlgyQ1pndjIxek5sdGxYdE51L2xMZEhSY1BH?=
 =?utf-8?B?d05hNG1DUWxIcHRQTDJvcyttblJQTG0yTWZ6bnlZUXRDRkZZWjN6TjgwVjV5?=
 =?utf-8?B?eURzYVFjS2tOaE5SVmNIVmppeHNNK1hTelVIK0V2U0tubUtXcEJ2eWFJYkls?=
 =?utf-8?B?enVLTWY4eGo0cCtyZ1BtZmtUNVhrWTF3bXZZbkxuVTRsTUZXakhkYXQ1QjBt?=
 =?utf-8?B?WENhdTdSN0NJRW1NQVI4MHhOMHdMTXhVekVsb1NTQkR2R3BjUjBQVlRNcyt5?=
 =?utf-8?B?TzNjQWQwRU9XaHZZa1o2eUNTVlBEUFpOcXlWaUd2cXB4Q2RLUlJVcUd5OWQ5?=
 =?utf-8?B?NkVMNmE2Qk9uOHBnNUJGRUdMM3hwbGkyNWVHbEpLUXpNeEJmM2pXM09oTS85?=
 =?utf-8?B?TFBNcjZqbEt3MTJiRnRpRXQ3TnNHRWRxV25Qa0lnVkdIYXB2bms2dDdBM09j?=
 =?utf-8?B?ZlhIMWlUaVpwWG82NldiN2pzYS9NRGdacnJrSkJlOVlxbUo4a2JXMExteXNQ?=
 =?utf-8?B?eXkxa3h3anFjTzA4TXZ3TkpBbHhwcUFTS0tCVm1vWDJQMkEwbHAvNFlDNTFl?=
 =?utf-8?B?WFNxcGFsYWlYWGFtaVl5azM0WDBTTkN6RldvUkt5TDN2LzM3VmpKSkoxMFJN?=
 =?utf-8?B?NThXT0xZMHVKVHZFNXpJNmY2dEhTQStDdVR4Q0I2cmhEazNSL0ZkR2NkZFo1?=
 =?utf-8?B?R1VSaWFKRjlmMVowcDhyb2tQR01RWkZHL0kxZ1IvK2NpaWZjSnFKVmR1K3JO?=
 =?utf-8?B?UW9acEMvSlB4VXE1T0hNVU1XeWVESjFua2szVVdmQ3VEaWltSlU1V2RlNk9n?=
 =?utf-8?B?UWQwNHZBM1FscHg0NzZQK1JrWHpZbnhVdGFGM2Y4b090MjhUWEYybzc0TmJh?=
 =?utf-8?B?YVFRMG5KdmJWaFY5bFBxSmp4SFZ3QncyTGcweDFSY3plR3NVdmt3cGVHZmFq?=
 =?utf-8?B?dnR2V2l6YnVMREovM0k4VnBhanFLRDZOVHNUMGgwV1ZSTVpmNmJuZDh2dFJK?=
 =?utf-8?B?SE5wSXU0TnFLVk5RR3czSU9Ud3Z2c29MQlN3TDRyRVdaZlRTK201c3IzOUJZ?=
 =?utf-8?B?SVFCbDE1V0JSSVRsWkxXQzcrcVN2bEtES0o2N0JZMVZLUVExdW80STk1ekR0?=
 =?utf-8?B?RkYvdWM3ejRWQ2FWMHo1a3gweGtZYlJkTVd6aUMwQlBldm8yVDRBN0VMOU03?=
 =?utf-8?B?UnZsRWphQzNzaURlZ2NVOVl3NXpjWnJyWnJoZSt4V0dRTk5jNTk1ZEJvSUdt?=
 =?utf-8?B?QVRWQktFaUJPclB6MkpDYkZiNDY2OGtsYXV1Kzg0dElra0piRDBMUk0vRzVx?=
 =?utf-8?B?VWx6bXM2TlJHL3k5TE1Tb25qaFZsZEZEdkxoTEhCV3BCQXBtb1l6WXVXUjBI?=
 =?utf-8?B?OS9US0JOMVNLdWZreWIzd1U4eWJ1OHVJZzJqTk5FN1l2MFZYYlhnQytNTmZW?=
 =?utf-8?B?NmgrNFl4aGEwcmE1STdrcGptRWsxR0tlSzR1VHI5UVJhZ292VUVSMXJsc3ZU?=
 =?utf-8?B?WkFrMnlNVFc1NklyWi9CLzJtRWdpUjliY1ExUnZIMVF0cVpXZC8xZjFackhq?=
 =?utf-8?B?cllxdjVUUlRsUWNVd2t0WEdaYndiV01EUVdXQjUyRlVGT1NKVTArMXR5U25R?=
 =?utf-8?B?Wnd3ZXlHK3Uxa2NnN1J1cXNMS1EyU0lDOHNLOU1sUCtaQWxBOEt2MXpYakVG?=
 =?utf-8?B?dUNYRTBSY0RTNEVKWmxIZE9YZVV4bFhNQ2d0Q0NaVlJRaVBBdVZ0VUVPMzc0?=
 =?utf-8?B?VjYyQnBKZ01QcHlRcENITEJyWkhMUk1DWXo0QTBtS3dHd2tENW5WeUk1Z2Yw?=
 =?utf-8?B?eDRqZnpGUm5jQWYycUF0a3lyZmg3N2dxUGR3MzFUSlR4aUd6UWtkRm9yUk8r?=
 =?utf-8?B?VUhUUGEwSDBhRzUvQTFxKzB3bERHVmJ2ajlNcHZDM2F4dkZPTWlwbHVwdWJa?=
 =?utf-8?B?L25aVjNOemErQmNhdmQxeWx0WHhqMXZ2VTcwbnEyU3lseGkxZkNXclYrR3Y1?=
 =?utf-8?B?RnBVazhENGh2VE1tYUFoL1NRUlN6M1JzNCs2eE5xTmNiV0EwR1pURE4zSjUv?=
 =?utf-8?Q?i6eYxUuhdxgwpx1bLKx9WGMOJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba456b70-c9d9-4337-ae92-08dd7e740eee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 12:25:09.2354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jbSgisjK6Kiyi/p9USPYynB52U6AHZ7eUPSdBzbtM0GCPLolAbPLtdk0NB2CZvrpDmtMi4cdIS9zvRNO+Qdag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8422

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Delete the amd_ir_data.prev_ga_tag field now that all usage is
> superfluous.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant





