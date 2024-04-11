Return-Path: <kvm+bounces-14255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C2D8A15A7
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B1B91C21F40
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73C21509AC;
	Thu, 11 Apr 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5VenDP5k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E59114F13D;
	Thu, 11 Apr 2024 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712842442; cv=fail; b=g82uL9vV0pRQbhYTSO61oFIiHoIhChTlymTURvu/02MBVGocF3Y8uNjeeclQFh8joCKUUjeF46rDcPVNwVfGx9IjSl+rJo4TlAvM8lON89z1yfIJvxgkc47gN4MSasgyrvvQWRtgEIwvW6/Klhzdt/rZc/sca7dLjfnPmKAR4Xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712842442; c=relaxed/simple;
	bh=o+KkzQc1IDW19NSkJ4Xh/Fw56B5+sNlMM3VRXaFYgPA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=XnH7LgHO1jUqfw/n9SK6i92vmLG0VTj+H9qmg5o3dIu07vnZVCC5deOs6un8yUeXrRq1Qi0zHLDFQW3ymlPpSyLbJE6c8bLEgdcGEvlX5HMAYEHSP/VXanjJDHVy14NbxlFkslz5JvOSKn+/Se28k04F7q1NLeEFVE7NAt1CqlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5VenDP5k; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrO3dKIFCiOhOE4yzq2EY/KYZylP0Txu7IVLBTx61bhkvbZrR0F4OYz06Q0IRhtmZo9fcYLVSSK5X4LurrprOya1vS8fa9PQz4+yxlzrrpEkwSBskxdiv8ZLPyhQJigJRMVWASkoztAqpQ/PufgOtiFskXlzm0KFH7OnYXIUer/P30oq6QCLzsfxrS1SMvSw4jWwqUYq2L2boYJQGXAy1WYQH8QstXUUuv+oMZEkYkK2JBhYvnqNQLrs2FI+EXdCVIFsXo5e5tdNrz5LXIkIGLaJehu318VSRJ+sxMFDTUSsH1QFVXWQenQCVip9/kmfJpTW1UkYKJJDrTrOX4vKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OP7iCONSt2x+x+rkn/Rm1B7Q2oq9yJKrAkYJT2hnBbM=;
 b=a/w/mfBA16zguFB3EVvNL7mn9C5LbVxA8xoXpW70johP7VFn1dVgIL0ew8PA/3rNlWE21Qd/hp3OBHsT0EWuRkicTCijVBtnVmckvGvX60UlakbTQVLI2Z01gFV7ugMIC6QV2ljWmZWjf8C4iiXy0ouz4aww0hUhkHo9u0nArGk6ENob+RwYqFnfxXYk79ldRUb96skpTFxY6wmGHoyAFS/m3do3Q/P+aHS1ITgLuGyYm+7x/KF6Ins8/CZ8TBac1JMk6ANRyJ7atjZ80rzx7nCRswCkI4ROkb2Wl/bjinhoX6BPEtUqIOmHK6k6XmZciv+kGhTOHPRzfkRObb97BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OP7iCONSt2x+x+rkn/Rm1B7Q2oq9yJKrAkYJT2hnBbM=;
 b=5VenDP5k4w731IfMqFscQbsO2PHBv7lYhHZ3OHyMqH9Z+P676gF8DiyqJE49nKBvtEc2g9gaNYY4L1oOzVtkJ7PLQz0o++Xb5Dq4Y5ei+513+CwQnP8VseJEWOXHA0CNRebyxcqiqXQHo7f0qHK9K5nYRgyCWxMpVnk04Ez5nlw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CY5PR12MB6129.namprd12.prod.outlook.com (2603:10b6:930:27::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 13:33:55 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1032:4da5:7572:508%6]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 13:33:55 +0000
Message-ID: <5f0e74f2-6261-d836-5161-a525ed9c497a@amd.com>
Date: Thu, 11 Apr 2024 08:33:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, hpa@zytor.com,
 ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-30-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v12 29/29] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
In-Reply-To: <20240329225835.400662-30-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:806:21::24) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CY5PR12MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b950d46-f3f6-44fe-88c3-08dc5a2c089d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E5NXiPUYegdxsM2ENNoHt9iFDVF7jk8RDIyCOUwzuu4loajaahqdubX8mj75OAGaa8CgoW6NwfX4+e/pX59U1Mr3UHBYn9XxBxCFaIrUL6w5rJAt4We9qCKEyN+oYVqzZRbhjF4+JD1K01pYwqKCe3TlvDtCZUX3Orf56QH9/hBJc3+mA6t6TUQ5ky6vbZ26xpQDFQCOnA11/0BV9kNxCAnjE6pcUN7j5qzHZ0Xc8sKqLKYO/UQDVdv/ELnf0NXbugrHHmdgi8v3SrnEmIeNvcCmAlFSVSdZh72JMb+Ddjf3BqnwEjDId8NIQ/c3iN/PJzqQLz50tfQRCZmKYDdiPxewxmgIXdEuE1I/ceTI8QdEUwulT8ahlnEk0yjVAx3pGtHbLjcqCpr6oiQTA4ty2v7fHOl5aIsfN7XnkteFpGRuNgk4xTmtceg26UK0SoJtwDg50OmSw8mWnA6Wq0/vrIUok4NHiAaDeDP+P3l8akutKTwur7smzvi4tOhSi4SE0bX/ZNG0QsCIyGp8RP4h4kdK8rNp890FdvE0+5r69WDfxnGvZGFcJAovPw0iIvzK1sD9Xvy/pxoi+5kajxZxJn8+zw2H+5SPW4WpEQ1CxyMjyhl8/t0weD2R9+mkfiBNbsTjdAEgKsNN4slVhWNh/WRrrMJDqeo0It/H0RoT0eM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE5QendCVXpKZnN6eXJRa3ZZTFUvSHJCTktXWGJ4QW5Ocmc3ckJKeFdpUnly?=
 =?utf-8?B?YjRMdjFFL0hzemNhMkpKeUVrSjdVMkNvQXBIb2dEUU9iN3BRV0Q5OWxRUUR2?=
 =?utf-8?B?V0doNFFYYlpzOEtXNjVQVWQ4NTY2cWVuckhBVkVPYXo5SXQxTmJieGkvT2Ev?=
 =?utf-8?B?blhBdTl4bHk0dklKQUY5N3BOcUZpYkwzL0RXNVRBSG9qQXc4OWxzZkJ2NS9z?=
 =?utf-8?B?TjNlNVVwNVJIcHBUZnpKQXNEOEVZbzFzVHowZ3ppdnZxVC9SNlNNWUxwU0Va?=
 =?utf-8?B?bUNqay9Sd3RsVGRrQWhMbjl1WHRNYVQvdzhhajBCMytXeFVlZHJSZThFQjM0?=
 =?utf-8?B?Vms2UEdNWUpycEQ0d0F1WGZLQWNJb1BNWHNYOHlaK2Z0RTJpMmVyaG13cnlp?=
 =?utf-8?B?ZUpMRFdzb0dldDUxYjJhTkl3UUY4cG5WeWtoS1hSUmtCNGE5S1h0elYrUFNU?=
 =?utf-8?B?ZTFSTlRsNFhpWXlQQ2E5MDlqWHRDdEtjRUVkb2wwMmxiK1MxWWdGTEFTZTdU?=
 =?utf-8?B?akFLNmxRNVhOSDBtcTJiUXZwM1ZmZEdEcmh2N1VLVXZ2QWJOMDRGcEpiY1ph?=
 =?utf-8?B?MnAxRkJrdlVPb2RVdGdlazMxdGg1cFpGbktRL09NMFdmT3NSWDZPcllnMWdh?=
 =?utf-8?B?L2RXc25Wc0tkeC9YREdoZ1lpY2hwQ3dJOFdjRkx5OWxRTDNsYThLemo5cHNC?=
 =?utf-8?B?QUFIeW1KRzZ6TDlNbVl6U1ViTzE4YmdyS0xUM3NoVE8ySTRnT2NubDl5aVJG?=
 =?utf-8?B?TGk1UHM2SXlyTDVWcUxqNEliVVJzUmlPZzF2N2lLUzlWdkkwdU1MSGxERlpx?=
 =?utf-8?B?eFl4TEcveEczYjkrSVV4bjFBblJxREVsOWxsL1lZVm1XcnE3a2ExM3Zvc3hB?=
 =?utf-8?B?MVlmRmNEakNEKzgxTDV5cXFibUJGOXU5dVdCWEhpa0pNMkpyNkd5K1RMRVBy?=
 =?utf-8?B?aU1zWnNlRGFiSU1TWXRkQXVkbG1BQkZuZzI3VXhnMzBwSVdzcEM1STMxcjJW?=
 =?utf-8?B?MHpLd0JaelU1bXdrZHNrYnR5d1p3RkFkOTlmZlMwY2txL3g4WThzenVpeS9J?=
 =?utf-8?B?UW9TeTZqN3hVSzFJM0ZveEk0Yy8wZ3MwNjRrdWhtbDVwM3F4UGw1T3RpTi94?=
 =?utf-8?B?bUhQeHZJTUV0L2FXYXJiV21HRVpsV3BkUnVLa3F1Wlp4cU43Mnp5WlA4MjVl?=
 =?utf-8?B?SjRtWVVRNDRMN2J1NUhhQXlpUHpNd3pXejlNVUkrbDE0aDNOejc3V1g1Wlh2?=
 =?utf-8?B?ZEdPKzBIY3A3Z1JQaVRqUmY0eTRwRm4vaFQ0VHRpYjlVWDNTUWU0Y3doeTRX?=
 =?utf-8?B?U0FnU0YyRElIaTVsMWNBclFXTDlQSm5jeGVzSnA1OEduVmZscnF6N2R4Ulp3?=
 =?utf-8?B?VlVZMmcwNEhDVjI4SzhyVGxrbHpjS0NtSlhOTlovSnN2Vm1SN0tIZ0Z4ZzdC?=
 =?utf-8?B?MkEySmlEL2FqZEVPVGFaTnk1UzZJWkJZcXkxcExLcnpEN0k2YXB5ZFdkM3B2?=
 =?utf-8?B?b0tKdHhuMHQycFVINmJrbXNpWlJreEdDTnZwNDI3N294WFFNNEcxNjVyL2Iv?=
 =?utf-8?B?WmNBdTNnSGdwbFBIRWlyZENJWDlFTisvVGxoR2FsLy9LN2JGZXdRY2REb3JQ?=
 =?utf-8?B?L0E0SW01S2wzZEhJMENwdXZtck5KazlUMnVkYWE1U2JvQkxRQVlySno0bDI4?=
 =?utf-8?B?UXorNWJyc2x6UVFzNjFERXExODhRV0x3Q3hTa0ZrS3lZZTVoa3VIQjMvQmZX?=
 =?utf-8?B?MXBtbGdTb1l3ME51c3JkUS9IM2ZBUEJUZnMzR0ZQRXlvYkhmVGVMa04ySmlG?=
 =?utf-8?B?Vk9jZzNZR3VEWWovc1BtQlBHVEphNzRmNXlkd2FoNk1QRWF3aU50UExObG16?=
 =?utf-8?B?Tloxa3p4ckRYejQwYjIzcWFGNnpVMzBmV05DaEhUSnd4b2dLZmQvTmxpVVdi?=
 =?utf-8?B?TjBSSndYSDlFbUx2Z0V2RXpIWWlwRWREMDBiam1zcCtsNzhQNlNzYTB1R2ZB?=
 =?utf-8?B?bGZkZ2FQM1RtZTJIbFpjRkI3UnhoUjJSWStJWHhQMFNqRi9QbWVGeHhIaUs5?=
 =?utf-8?B?ME1KZzJTY0NvcWUya0VBZGV2bkpsWEhxcUV6bWNtNUNFYzYzd3cyMzYrdklL?=
 =?utf-8?Q?dmI+oI8coesRarkATXoJ3ZRRX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b950d46-f3f6-44fe-88c3-08dc5a2c089d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 13:33:55.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFf6YMJECUgrvRoSzJZqoRjNvYh4+PoEbJqpH3yLB0aSSGWgrUEpCYdThZrL0DCGKQK9h1UdYcSxJsTNtqVVvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6129

On 3/29/24 17:58, Michael Roth wrote:
> Version 2 of GHCB specification added support for the SNP Extended Guest
> Request Message NAE event. This event serves a nearly identical purpose
> to the previously-added SNP_GUEST_REQUEST event, but allows for
> additional certificate data to be supplied via an additional
> guest-supplied buffer to be used mainly for verifying the signature of
> an attestation report as returned by firmware.
> 
> This certificate data is supplied by userspace, so unlike with
> SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
> forwarded to userspace via a KVM_EXIT_VMGEXIT exit type, and then the
> firmware request is made only afterward.
> 
> Implement handling for these events.
> 
> Since there is a potential for race conditions where the
> userspace-supplied certificate data may be out-of-sync relative to the
> reported TCB or VLEK that firmware will use when signing attestation
> reports, make use of the synchronization mechanisms wired up to the
> SNP_{PAUSE,RESUME}_ATTESTATION SEV device ioctls such that the guest
> will be told to retry the request while attestation has been paused due
> to an update being underway on the system.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   Documentation/virt/kvm/api.rst | 26 ++++++++++++
>   arch/x86/include/asm/sev.h     |  4 ++
>   arch/x86/kvm/svm/sev.c         | 75 ++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.h         |  3 ++
>   arch/x86/virt/svm/sev.c        | 21 ++++++++++
>   include/uapi/linux/kvm.h       |  6 +++
>   6 files changed, 135 insertions(+)
> 

> +static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_control_area *control;
> +	struct kvm *kvm = vcpu->kvm;
> +	sev_ret_code fw_err = 0;
> +	int vmm_ret;
> +
> +	vmm_ret = vcpu->run->vmgexit.ext_guest_req.ret;
> +	if (vmm_ret) {
> +		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
> +			vcpu->arch.regs[VCPU_REGS_RBX] =
> +				vcpu->run->vmgexit.ext_guest_req.data_npages;
> +		goto abort_request;
> +	}
> +
> +	control = &svm->vmcb->control;
> +
> +	if (!__snp_handle_guest_req(kvm, control->exit_info_1, control->exit_info_2,
> +				    &fw_err))
> +		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> +
> +	/*
> +	 * Give errors related to stale transactions precedence to provide more
> +	 * potential options for servicing firmware while guests are running.
> +	 */
> +	if (snp_transaction_is_stale(svm->snp_transaction_id))
> +		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;

I think having this after the call to the SEV firmware will cause an 
issue. If the firmware has performed the attestation request 
successfully in the __snp_handle_guest_req() call, then it will have 
incremented the sequence number. If you return busy, then the sev-guest 
driver will attempt to re-issue the request with the original sequence 
number which will now fail. That failure will then be propagated back to 
the sev-guest driver which will then disable the VMPCK key.

So I think you need to put this before the call to firmware.

Thanks,
Tom

> +

