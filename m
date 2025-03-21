Return-Path: <kvm+bounces-41689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 823AAA6C09E
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:53:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25C7A166322
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167E022D4D9;
	Fri, 21 Mar 2025 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M2B6GTlj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6342122CBF4;
	Fri, 21 Mar 2025 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575965; cv=fail; b=ZaePRzxDaqZVhcm4cne1B13FS3EBmGvnvgX0Gv+qO/vh4pkoFmBMBZi07i5tePKG3T0IzH71FCeQfmFkssUdLf3mFwszRYlhxfubF9fSdRZ3FxAuJy5r/m/Z02cs7K7kJvSQyhPLVs1YgFTErdlWiZNL8n9iNn7K//WUlH0EvHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575965; c=relaxed/simple;
	bh=GOr0Vc+0TLCC86huEC5cOp4YfRn5eDiZoV4ydKoe6Zs=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dNMxY5Q5y4Enj7MTy1YdG2Uq2ARvyqbetopDXoPevPDsULGUvIRGt73YkfuJg9sK6Ht3vx0gwt+rTJJho8ygy9eIVP4OGvpINa34ILG1dvKnWJhai5JfJroADexaolqK/n6s/brkQU7/XKig3GyusiPZKbZoffXnKYWkpfRPtsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M2B6GTlj; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDAQq9tVubyIjSEwFnPK9Wda6JnvOD72sj/UcpYrppoJcOE4vY/zAyUZXHuzY3+Bz1hxZtIwwUEhV7WrCfYC+bQVXII/I/CL8mSOv45vkWOEPzQdVt3rnGX5hI7qXLuRgdIb7KphTLYPI0LYYCGUIBSbIdT7mp7aoI0zpOghmtkZ9UrcTN5y0r0n81nwS+b8aiq4zyfWYLY3j9nA6E8oFVZ+MhNH7lt3Gu5gSEMYHBwT1mvwBxWiT5YiK5XOxyWjib9Ak7lxujHvgzq/XHjYziweeQNtvbQTE31X1OdXkzCEyYT/sOgupXUr6ukH6X3bruCGtyOUIt9n3bSQPZ1UFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBeQaZ/OvamxdcYXXD/pD7pwq6owHRCgKSFrUyAoCKw=;
 b=ZgN7XmcqE/aQ1OoCf5IovIVZZJln+NRnyamEWfrsa8HTQAQ1Hx3EFTQt/pmnSdjgnnAJU83oC0z72MPjwsS8fpvz0t3iOdYP243JglzT/rpwAAsIO0xgY+aRv3IRMtsAN8QjH9g1lTgHqrayF5LnV1H+HFdzOKaa/qoe05mijkbIEbyOQaWCC+sYnu7l758gxMXb+jsM1cP+mmxVA29zCC1L6IkyV94QL+O98UwFh9Wv1wVD1hJn39tNDl8CzAvL3AZOv8oyDGkTlWkrWOuSktUjyYR+iR1V111GpInANzfwxG/s7W24vTtMzxF9zSyQJq9YYewmgmOnat1GSgfzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBeQaZ/OvamxdcYXXD/pD7pwq6owHRCgKSFrUyAoCKw=;
 b=M2B6GTljcVt3otDU+/WTvLalcjYyZPPeHiU3fOD0mTiFej2CiMSoRlAgaM35+rI07yhLhlXZ1QbwaZvjJVgzcOG7DJUAFlf35tmfvuifzfHEmjgv38HY4j6mtg6SADXHt7YbcsMP4smKrbhuCgHyEnJ+ZHxiZOxyOBvI3BlUee8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB6804.namprd12.prod.outlook.com (2603:10b6:303:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 16:52:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 16:52:40 +0000
Message-ID: <aeabbd86-0978-dbd1-a865-328c413aa346@amd.com>
Date: Fri, 21 Mar 2025 11:52:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
 <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
 <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
 <29b0a4fc-530f-29bf-84d4-7912aba7fecb@amd.com>
Content-Language: en-US
In-Reply-To: <29b0a4fc-530f-29bf-84d4-7912aba7fecb@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0221.namprd04.prod.outlook.com
 (2603:10b6:806:127::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB6804:EE_
X-MS-Office365-Filtering-Correlation-Id: b1607c6b-ba34-43b6-ddc6-08dd6898ca74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NDVmY2x6OXFiV1hkeHpVRVdhTUxzWDZzSXNoRGxPR1cyNklSM3BCa1VoU3Zk?=
 =?utf-8?B?MytWSkxhZFh2bkM2eTl6YkhPL21vdW91QTNxTHJuQi9wVkFiR1dPNjRUMXZz?=
 =?utf-8?B?NkJzcm5vakdza1c4alFtVDVnSE5LWi9yZVRyeUttdFAzQ0V0eFl3WlorYS9F?=
 =?utf-8?B?OVpMRVF0UnFHM21xckNRMTlOUWFYYXhBSnlDVWl5Y1RsMld4U2E0OFV1MFk5?=
 =?utf-8?B?Y3RJN1lnSGk1VUxzRTdJc01PZ0xRYlkyenNrZG00ZEVaazhkQVZsbmQ2elky?=
 =?utf-8?B?Nk80UWpwdmVzR2ErcHE2TUZuNFRSYjdsMnFIZDBxLzcyYXI5ZXA2STlmS0p2?=
 =?utf-8?B?d3pOcEwwUlBIN2RlTHU0ZnBBVHJaTDlPN1I1UWVMSnpoVUtqN2w2SmRuY2Rh?=
 =?utf-8?B?TzFhTHhUaVNZQ2c2TnlQSGdWSHZaZFRVRWp6MEs3ZXdaR09raXJWdWhOS1I3?=
 =?utf-8?B?cDhBeXFpcnN5eFY0WVVDMjZ6Z0RLRTJUL2REME1kSUdxSFZja3FkZCtEbXZI?=
 =?utf-8?B?VUFFdlE1UlNReXJtUldrSW96b1dVTjFJSURRczQzQVRrMSttNVB4MEtKdWlI?=
 =?utf-8?B?Zm5ucG9MYXlpZyt3cmlZcEZqZ1hUcllKUC9MeHVJUEM2TTlHTWxQK012RU5l?=
 =?utf-8?B?QlNmRldtNU5iL1JlN0cwQ2NpVm1icjlreUxlVG4vYzRVbnZCLzQyQVVDVGdK?=
 =?utf-8?B?Y0I4QXdBeGZ1TTNkRDhlVDJabk5TcnY0N3JHOTZRNCtkVitPT0tIQmlwRVdu?=
 =?utf-8?B?VzdKMUNIKzFKbmJycm00TmhjdE9sei9xbjNWRzhGVnI2YWhsa0dtbEFqcDB1?=
 =?utf-8?B?Uk5IL29YUm9KN21jOWtEUXY3V3pKUzJLRVgwK011cG51MExQZ2oyZFhTVFhI?=
 =?utf-8?B?TVhuS25sSmY0VWh5MjR0NWVaMU1VemJtdVcyZm5kTTRCY1hkeVZxem5oTFBZ?=
 =?utf-8?B?d0MyMzgrMERCaGxRK2JnUDY3bTFVZ1RvN21ieUpVS1NaazZtREdFME9zaXd0?=
 =?utf-8?B?aE5KWGM1N2IxN0lzT2E2Mm91Q2tUV2lPSklnWG04cUYzN0xYVG51TlJvaWRL?=
 =?utf-8?B?eG5HUFBwb1BMbE9rVUcxb2Ixb1BNYWtOOVRMNEtEaG9tVXNTZzNWbzdRay9V?=
 =?utf-8?B?enZzbk5ZZ1FMbDZkMktSYllaNkxvUmhZejR6NHV4YlNQdzlVOFRWYUd3MVNp?=
 =?utf-8?B?WGhwemJnNWF4YlNLc3NIMEhJc2xIcnQ5dHJxQ2NTenJFTTJ5ZFdhSjRHNG0x?=
 =?utf-8?B?VkprR3p2YXNJMTNjZlBFUHdBVzJqNlQxbEJoeWtVUUtESDFvR3RRdWh0OHFx?=
 =?utf-8?B?NVZURGpOK3ZDbDNQOHhxRHJpbUQ4bVZzQmx0b1ducVRyeG9BamN5ZllUMEtT?=
 =?utf-8?B?dW84N2t0d0Y4VjlaWnpmQkpGUEw4L3BuUkIrZlJ0NEVLL2FrV3JHMTJoRW5y?=
 =?utf-8?B?YnBmNHQ2ZG51ZFJTR2R6azVZaWNsZjlxWWlEd2N6ZmM2UUg4dHpJbUg1V3J4?=
 =?utf-8?B?Z3UxR2NUSXN6Zy9vaFA3Qjlid2dlalI0dFNvQURpckpldXY2eU9xQ25TdmdI?=
 =?utf-8?B?bWNUaGU3MXEwS1hkM2NWdXloS2FmOWkwb0RRemI3eG9HT0NKT2d4K2U3RjJa?=
 =?utf-8?B?NXQ4MjU2cjdLWHJyM1NEaWxvZGVmUU0xSEJtMWVaRHZhdVk5WW5zUitZNHF2?=
 =?utf-8?B?dmhrMXFtd045Sm5FUVlzRlNacHY2a0tLTXBvNWdHbW5oaGIrb0dvM1FjUUJi?=
 =?utf-8?B?U01PNWdHRllDaFFteGFPTzArL3J6bUZGL2N5TlpOcDY0ZktFa1BwUjh6WUFj?=
 =?utf-8?B?T0hhcTgxL1d6b09OOUhpTlc4UXc1NEh6OGVTU2VFMVFvWlpaQzU5R3V1YkZR?=
 =?utf-8?Q?RsyTo6msY3gg1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTN0eENNTkVWQnBVZjZ5NmlVNldrVFBlUkpWcXZnbVNISGU5THpUSC9mSjJI?=
 =?utf-8?B?V01KQXJVZmlHbHNiMTdKNUFLNWhBSjVQQ3BUdTFyRThNZWlqUUlkbi9mcEcx?=
 =?utf-8?B?Um8vckNSanVPUTlYUWFaVUJndEhWUjFGOWs0ODVxSlREV2Y0RlU2c2RlVnFh?=
 =?utf-8?B?ZHZWTmtyM200bk1vRkFYT2JLOUNEWFZPQzRKNGEzdGxFdzluVmlrSGZEY2VT?=
 =?utf-8?B?bUtLY1djbFZaZEp2SXdUZ2g5TDYyUzdZSTdRbktnd2pId1F0bDRqaHlmck9C?=
 =?utf-8?B?Y0o4RHcvV1RqNXFjNGJNRENESjBvYUxLZ3luZEtLOWg5V29IREluOW9iOXp4?=
 =?utf-8?B?MzlEL0hoTWE1T3N5OVRDQ1VFcHgwVWRYRjNqV1d3NmR5SWt0YWgyYlhuY0xI?=
 =?utf-8?B?YzN0VU5CeTczakdpY0MyR3k3VXBmZ1VheXR5S0Z3WDZIWlF1cWRxTGRYbk5u?=
 =?utf-8?B?cnBmNS9Ca05oenRuNEJpM1hMcnRxL0Z4aEJoY1hHR21EUnA1UmVoUmRORXI4?=
 =?utf-8?B?SWJQcGJwblRNZ3JwazhVb2hzZnV1alhBbitRWnRVa0lFSDVaZjNwY0ZuelRa?=
 =?utf-8?B?MzVrSXNyeFZTcjcwUzRHSDhWS1pIdHMyQlNrMkd4Yk9VWnFVdW9ySnJsZXJP?=
 =?utf-8?B?NjZWdUJQKzdNcTBWcU9ScmlnODhMa0h0NmZxQ3BxRm5CdTJIcDQzUTFPaDNk?=
 =?utf-8?B?cW1WMEQzWVdYRi90WXBSYjBPTlVwaG01d0dYNUh3cys3Rm15SGtLSjV5bllE?=
 =?utf-8?B?Tk8rb2xkUHNUbDdBL0xSWmxDZmVWSHhpMFdRZWJGYi9zVktRSlFmeWZtV2g3?=
 =?utf-8?B?S3pCeCtJbXFSZUsrYlVZVTFSVHZudVo3aitqN0xFNDVIcFlVdzVHSXA2dVVv?=
 =?utf-8?B?NzFYRkxiS1NweUdBN2hUSytaaGlWdEY1OXZTOGFxUysybTFuRHZpVTZuNXhY?=
 =?utf-8?B?M3dOSlVQT2JSb1BSenNIK2tNczdDam1QVUFrdXVPdytyTkx1aU9SUHdLMlNj?=
 =?utf-8?B?VXlzSXFOckk4bUZYU0o4N3JGRGJQK21zVWFId1JjY1dkMjRJOGJGVEpkOGxX?=
 =?utf-8?B?TFAwWFg4UU82andLTVFWWjhSdENhMEJtWTFDNkFxRFRucWMzR1poMjIxcVE5?=
 =?utf-8?B?L2c4TXp3SjVraTdzS2oxdDBDRlhJWG5tc3hhUWpZNGFqUGs3WU95ZW1OMndZ?=
 =?utf-8?B?bnJqZEVMVzAxdk1YOWZweDY0dFR4YUdMS01CSG1Qc2pNZlplZWVLVVRPRzRj?=
 =?utf-8?B?SkVJanNWME15aGVkc0JJVmMxNUFRNU1IbHNZWU42eXIzak1mZ28vU2MzTHll?=
 =?utf-8?B?YkUzbWhwbmxuQkxFQmY1S0RTK0RWMjh0aHFMdG5mUUFaVTFLdGxEMzlaYUVq?=
 =?utf-8?B?TE5WU2hPZ0ZjMTE1ZytmMzRIUjFEczFwNDNEZ3puNi9MTGVQRjJUR3QwRjYy?=
 =?utf-8?B?ZjVUT05KV2twQy9IMmU3RTZrQ2ZBTUlYN3VoTGpmTTl4cER4RG5TNGxvSWxo?=
 =?utf-8?B?Wnpuc0N2MU1HaFhDNVErR01Wa3B6c3BVTm5NU0JRSUJUU2Q0NEltcFFzTlVO?=
 =?utf-8?B?ZEFhMTFrR1lvcFpvd1RTeS9IcUh2RmFoUnFCOTZybUI0SHpOVXcrQ0lxRjZZ?=
 =?utf-8?B?ajJjbGQrckRlWnh6alJNaDJHMXhjaHd4Y2IvS1VwTldrMGxCQW1lMGEyUXpa?=
 =?utf-8?B?aDNwL0dWK0hJMTMzL3RmbkFaMGdCWUNOVXVQYUVNWDZxS2ljZFVzLzAyUUFq?=
 =?utf-8?B?MVhjUEQ3YUpaOWhjeGVkbVRwZEs2TEdMb3JKVXpsbFpmN2xwa3F6b0FvOW40?=
 =?utf-8?B?Rkc0TEJZOHROKzN1dVMzdjlqQ0E3WGRibjZnQ1JIQkRVOWlWbFVwZ2tlMGJE?=
 =?utf-8?B?MEkxOG8xNm15VGxscUlkMDI0MUEvYzZMSDZhNUY3SnhvTDFyOWdZNUh2Skw1?=
 =?utf-8?B?UTFtS0VpbmY4OUt2MElzQlFESW1rK1Ryc3RaY2dtYnp1cHcySzluK3A5MUJs?=
 =?utf-8?B?ekV1YmQwRUhJQlU1MjlwNkREVjRxcWZKMnh4V3YwWVNKQXZIMTdZR1BWWE43?=
 =?utf-8?B?ODBkY2FmN3hBNUYvbWxsNmJCcUg2ZnUzazhZSEtsNmljS3grOFR3NU9JMEds?=
 =?utf-8?Q?2i6ceJFfStqzPdplwbLJYFT0u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1607c6b-ba34-43b6-ddc6-08dd6898ca74
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 16:52:39.9116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9VECv1Ep9TS+jTFQVOE+Ro8ogm+veyRBLAMA0HOx0u5WyqGosJMUli3o+g2b6p5Y+vEPTR9bC6mM4w2ap4HRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6804

On 3/18/25 08:47, Tom Lendacky wrote:
> On 3/18/25 07:43, Tom Lendacky wrote:
>> On 3/17/25 12:36, Tom Lendacky wrote:
>>> On 3/17/25 12:28, Sean Christopherson wrote:
>>>> On Mon, Mar 17, 2025, Tom Lendacky wrote:
>>>>> On 3/17/25 12:20, Tom Lendacky wrote:
>>>>>> An AP destroy request for a target vCPU is typically followed by an
>>>>>> RMPADJUST to remove the VMSA attribute from the page currently being
>>>>>> used as the VMSA for the target vCPU. This can result in a vCPU that
>>>>>> is about to VMRUN to exit with #VMEXIT_INVALID.
>>>>>>
>>>>>> This usually does not happen as APs are typically sitting in HLT when
>>>>>> being destroyed and therefore the vCPU thread is not running at the time.
>>>>>> However, if HLT is allowed inside the VM, then the vCPU could be about to
>>>>>> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
>>>>>> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
>>>>>> guest to crash. An RMPADJUST against an in-use (already running) VMSA
>>>>>> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
>>>>>> attribute cannot be changed until the VMRUN for target vCPU exits. The
>>>>>> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
>>>>>> HLT inside the guest.
>>>>>>
>>>>>> Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
>>>>>> request before returning to the initiating vCPU.
>>>>>>
>>>>>> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
>>>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

>>>>
>>>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
>>>> to be annotated with KVM_REQUEST_WAIT.
>>>
>>> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
>>> This is much simpler. Let me test it out and resend if everything goes ok.
>>
>> So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
>> me try to track down what is happening with this approach...
>
> Looks like I need to use kvm_make_vcpus_request_mask() instead of just a
> plain kvm_make_request() followed by a kvm_vcpu_kick().
>
> Let me try that and see how this works.

(Lost the thread headers somehow on previous response, resending to keep
it in the thread)

This appears to be working ok. The kvm_make_vcpus_request_mask() function
would need to be EXPORT_SYMBOL_GPL, though, any objections to that?

I could also simplify this a bit by creating a new function that takes a
target vCPU and then calls kvm_make_vcpus_request_mask() from there.
Thoughts?

This is what the patch currently looks like:


diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 32ae3aa50c7e..51aa63591b0a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -123,7 +123,8 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
+	KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6e3f5042d9ce..0c45cc0c0571 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4038,8 +4038,13 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 out:
 	if (kick) {
-		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
-		kvm_vcpu_kick(target_vcpu);
+		DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+
+		bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+		bitmap_set(vcpu_bitmap, target_vcpu->vcpu_idx, 1);
+		kvm_make_vcpus_request_mask(vcpu->kvm,
+					    KVM_REQ_UPDATE_PROTECTED_GUEST_STATE,
+					    vcpu_bitmap);
 	}
 
 	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..08c135f3d31f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -268,6 +268,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 
 	return called;
 }
+EXPORT_SYMBOL_GPL(kvm_make_vcpus_request_mask);
 
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {


Thanks,
Tom

>
> Thanks,
> Tom
>
>>
>> Thanks,
>> Tom
>>
>>>
>>> Thanks,
>>> Tom
>>>
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 04e6c5604bc3..67abfe97c600 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -124,7 +124,8 @@
>>>>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>>>  #define KVM_REQ_HV_TLB_FLUSH \
>>>>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>>> -#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
>>>> +#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
>>>> +       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
>>>>  
>>>>  #define CR0_RESERVED_BITS                                               \
>>>>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
>>>>
>>>>

