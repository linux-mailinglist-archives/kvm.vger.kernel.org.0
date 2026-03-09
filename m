Return-Path: <kvm+bounces-73338-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sHi3M4cIr2loMAIAu9opvQ
	(envelope-from <kvm+bounces-73338-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:51:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9B723DF3E
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1B0730FBDA9
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7822D59FA;
	Mon,  9 Mar 2026 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="is1Xh6QT"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F914280CE0;
	Mon,  9 Mar 2026 17:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078394; cv=fail; b=RZXGvk0/79FEQw5jPUuRxJSFG7+2RzXqKqSpsYDoYs7g5pO1ZkUakTxoS9fVAAoygSA4ryESydH19tpidECsziHvPK/f9O+VcOxN0mzowDfp51McQjnuIa9RBCz+UBBuXCKWjlnFrmUG4hON4RRFP7X/C6OcY2nfCI/CL7X27+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078394; c=relaxed/simple;
	bh=jc9zspf/xBdpcPpgpzQJy2GMInL2uw03a3tHArJjrM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RzzZ1HhLMgkFkUC6AIKRk3tvhnmOA57n3JM7m9cJdakjZCgsEZkIU5a1GBC640bchKtulk5ebCkfYGR5UNY2t78xegZevAiRNANpMOga3a5NgJiioRgddhTi3kRGX6i5ZNZNolYYsfsBfGnQmAg29P8l52pZHf0VDyrXUNhqikg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=is1Xh6QT; arc=fail smtp.client-ip=40.107.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=USe3J100eaSn1LeE907D54SelnxVI1WxiQyPe9foSZTRKeJ0kDxaVwe0Mk7Lx+kyhOstKm80ar6VLR98KrzF0e/v2APBsRgY+0qvobotxLc4TjvmNo3rO+Vk3N0JhzsaEL4U16YjODhsJW9VWX40Xg8gOBcjsHDBUkicsO5koJoTWpHUEq3BMsNi7qdXEUVMDOyNcLksH4qgvlfiW7EL6AYbmjne9C+zv42pZ3/izDdKaKBcjOlZi1/YTIae+J2BYeVewR8qOL8PkaoMe78tY+OKSXsyr68aLymB4gIBIfjoZtMK00iYs0Pxpja7TwnrPP93JGVrgXTxs6UWz9Wnmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljOIBLWLh+Zvbx1Sui4gal+H/s/fjvcRAxGufbtQm5s=;
 b=v1Pt4NcMytRcDnngt4ZjM6eL/CHcSVODWndn/20IvuyzbMubsemwA9BAqHDg9Ax2G1ZJmqRqY4esqsB4GbiNYmC6+4dissSI/NR+qa4oBo8c/qFTeqNl7+h/rGu05V5seZtVPzkUe8828bMippnNHVeN0Qlej4wSBKblkUgrGYwkhAee7R3mL4wG/wh0cAgkbDnX7wjoWZYt1uLF3O9B3DpZXgu2lIvaQ3A3YsFmcGdXWo1giREy2s+8e5+twFWz8uCJVY76hmjM97Wr+Q1zu+Bv3iSIZ9Z0HEH+Nnl4fGFS4+V1lHIj2p+DpRVc8rTCV8qBDs9Mn45Wxce41bkGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljOIBLWLh+Zvbx1Sui4gal+H/s/fjvcRAxGufbtQm5s=;
 b=is1Xh6QT8deP7hvK1/I2tAGSs0Dl2n+S4j+QjO5+ixMWtxhnQcMCgr+zfEzY8mCTn2wfpTzQPRS2MpZLK0Tb1/thXD7iBQ50AFjASIsKcGPU2FnFBG2reTSlCnxkTR9L0sGPO0QzIb5EASJdD8KvxQf71Dw6zbJ20oXZeK9Yt2E=
Received: from SA1P222CA0123.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::10)
 by SA1PR12MB5657.namprd12.prod.outlook.com (2603:10b6:806:234::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 17:46:28 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::db) by SA1P222CA0123.outlook.office365.com
 (2603:10b6:806:3c5::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 17:46:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 17:46:28 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 12:46:15 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 12:46:14 -0500
Received: from [10.143.203.87] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 9 Mar 2026 12:46:10 -0500
Message-ID: <7c5d0db9-5151-4edb-9b97-0f0b268cf36e@amd.com>
Date: Mon, 9 Mar 2026 23:16:09 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] KVM: SVM: Initialize FRED VMCB fields
To: Sean Christopherson <seanjc@google.com>, Shivansh Dhiman
	<shivansh.dhiman@amd.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <xin@zytor.com>, <nikunj.dadhania@amd.com>,
	<santosh.shukla@amd.com>
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-2-shivansh.dhiman@amd.com>
 <aauGTverUvkEJnPd@google.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <aauGTverUvkEJnPd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|SA1PR12MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: cd68e9f8-ad21-4f00-30cb-08de7e03cab9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|7416014;
X-Microsoft-Antispam-Message-Info:
	17wh2oF+cZVpELCcsG1WmrmDjH1t5XCUK5MgomV9TWCPYPxuqWkahUalz8/YNylf1BLJ68eFUiP3usmsgOGCmWn9jTKn4TVrd0S7TbNJJejIbc2vMUszEy8cweZHkh98Ey2B2iiMw0qRA2/kdM/QUB0wSGOeGAdwWhErzA2qG9tsykpgA43KfKBSf1IrUNYGpGRIozS/7fsuJ4vDFgwZxxUUwtRIL9iDkuUzdgxA+eM+HbtYPBod9ZfTC4GhHQmXSxmXXlryygebhGE74pansPLFWSxllAcvK6r+8DmnBGky2Of9msFH2d0KVLIKa1mvT5CQ7H+jFf8N+H/O2d5PS1oUZgFPF9UMP1uZaPFtiT6ik+axA0MM64dBVoOE5dw5HrtFovcwoBfxoY6j0hO4S0/hDf7NwSJpT1s2augAkNSWKD/NuJVJXY/9CE1hY4oyYLMh7KYUEWBIrZATFNQ1+oP1Vla32Iu2nCIPPY3yh4Sww5gaKBjTyEngh1X4uoh2/EtMbpmHEw+1ojvH1BWYzoOEAA+OvIfunWioPU137OUO7Vsb+0kLFR4Ud7FoO74Bvezfsu73Fo7sDJTMuKJ65NaRvgk+QWnZnGXBNHFqVDY1rPX1JBO9jst7tIFPUmAziDJ9YVeguPMSmg9poccfJFfv45r0s3ES5QUuh1DjEaAYKlOo2fO22TvtnH1JWlmRzdlec4Eez8GZErdjMtLnw/tmSglae6/rbHrGDBS6nzqLweB8JK9MEObI7+8N1ssvVZJ70j+jSWaTfHanpCQ/sw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AI3ShnDMH/tdhD4eI9G1FeD+e3J1fC694O/dxH49GREY3uGC74c30yZLUnXugxDlyWg8zI6xfnYJ7OJUhkmDSNbXaerUfTGADqlI43VkB/86opI/pNtLNOgsj7ZzdYuFAre8WVDCzVgQTAZMqSlUVHlKxcCa5a9veLOh2ITH6zY+vp4QEeRmA1TKalEcX44ZDIrTdPBwH+32cjkby6ZgolkXD9/Z/coCwV80XpOe0Al2AfZ+kAolLdIS4D3nK2GvHGwsPVQIQ0RzO25MJg2/BWTWJVKxpW1fYPBFz9AB+DIQE6PdQgjYtweRuIhc/FtLOujY7HheR4v3RSXINDoWietTaNBfrtUN+aO+L1ajuZR3bf2YBWfMSx8rsUay9vp+30FEz/90GfLocKcJacaLZeN1RiiLisSutgQ45kDomgmlqpPtNc6Uf3LF09KTclUp
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 17:46:28.3706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd68e9f8-ad21-4f00-30cb-08de7e03cab9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5657
X-Rspamd-Queue-Id: 7A9B723DF3E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73338-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:dkim,amd.com:email,amd.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Action: no action

Hey Sean,

On 07-03-2026 07:28, Sean Christopherson wrote:
> On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
>> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>>
>> The upcoming AMD FRED (Flexible Return and Event Delivery) feature
>> introduces several new fields to the VMCB save area. These fields include
>> FRED-specific stack pointers (fred_rsp[0-3], fred_ssp[1-3]), stack level
>> tracking (fred_stklvls), and configuration (fred_config).
>>
>> Ensure that a vCPU starts with a clean and valid FRED state on
>> capable hardware. Also update the size of save areas of VMCB.
> 
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index f4ccb3e66635..5cec971a1f5a 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1110,6 +1110,16 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>>  	save->idtr.base = 0;
>>  	save->idtr.limit = 0xffff;
>>  
>> +	save->fred_rsp0 = 0;
>> +	save->fred_rsp1 = 0;
>> +	save->fred_rsp2 = 0;
>> +	save->fred_rsp3 = 0;
>> +	save->fred_stklvls = 0;
>> +	save->fred_ssp1 = 0;
>> +	save->fred_ssp2 = 0;
>> +	save->fred_ssp3 = 0;
>> +	save->fred_config = 0;
> 
> Is this architecturally correct?  I.e. are all the FRED MSRs zeroed on INIT?

Yes that's right, the FRED MSRs are zeroed on init.

- Shivansh


