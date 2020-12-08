Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0DD2D3017
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 17:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgLHQoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 11:44:39 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:34529
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730001AbgLHQoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 11:44:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFFYiHHnmsC0m/A7QVcHmwd1uSC3x8VdCIRUU08vBC4VuC0QTHCtSKLK9wdidBNmnBy/cjn2HTML9eHMJTEF8dQA9aBD1O2OKnnuktwbyHe6LmjFLuTQhhS5Q8+6vZ0c1pGvpdwMLfy8B9Xf073lN26RXBung5CibE2auISMt7GepjqUR2OwZYJxdyX0keGfO3QcSLueDacGXyxbbCk3WVuMNRgei1KcXro66iChGRGTHJJ5HeH8MjRs3TdmJFo2R0yayCuAe8LNu2oUC7S8xTEFwrhCTo8ITMe1Telc+5phtaPsKlA6oliV8ci1b2/63lVss1Zf2uBx8bb2qzrCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PoT/8DNUYeNYBZfj87jejRXhE9DAYVBmhOna+C0rkk=;
 b=IrER/yWu7Q3Ga6JRlvmH/CtRd0d5cHV0s6ObXBRUrODHHEwU+3dSOr1/7ENt0FyNp0Ih1PGcfUVU61cqq+j0w98R1FFaXLfaXUoI159ql9BZ2If3QSJdX5PrD5T1efElGsw0uOScCAmjYKlcDZuTaA1EoArt6QP5vuMi9jwc9ECp/ur5Zq9IQTjkyBxTm/2TpVEiar+7j5ReGp9BPHXfXUSKcJZL0zUIFfnoTaVTo3zDDiuiKmEa2n0pYYkHmhs0xnum9JRpEEJO3Yp46681yarlEFuVfbjWbrCwaM7g4gJZJTCB0xsZ8uI6ott40QzRCwKuhIle/nl97BaX7oMhhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PoT/8DNUYeNYBZfj87jejRXhE9DAYVBmhOna+C0rkk=;
 b=S+WlEadMywmo2mQrNPEcupW01NDt7pxitAWSKlX9dP1vN/PrG2epgJkTGBpvxY2GDCiXtfEDm/CPaYNNdiyxaozx2S0DNgo3j+ZiddWFPw0oTR32+TFpymN8vrkWMvlT9oNb58UOXny+DuChEbPJ6anTYlArze0RHsBlahnDVJw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4812.namprd12.prod.outlook.com (2603:10b6:5:1ff::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Tue, 8 Dec 2020 16:43:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 16:43:44 +0000
Subject: Re: [PATCH] KVM/SVM: add support for SEV attestation command
To:     Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
References: <20201204212847.13256-1-brijesh.singh@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e79c7610-21b7-a9e7-6b3c-f08b4e17dd87@amd.com>
Date:   Tue, 8 Dec 2020 10:43:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201204212847.13256-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0003.namprd04.prod.outlook.com
 (2603:10b6:803:21::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0401CA0003.namprd04.prod.outlook.com (2603:10b6:803:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Tue, 8 Dec 2020 16:43:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0bba7fc1-49e0-496e-534f-08d89b986d96
X-MS-TrafficTypeDiagnostic: DM6PR12MB4812:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB48127AE7AA6EE67137C2E7DCECCD0@DM6PR12MB4812.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQAFZSqFMBEv2bYBmy3lCqnXdOk0Mm/EoggZvuvl8zaaJyrPhucHTcZ6ugOnDbWG0TV6ZKtXSruxun0uo1cvCiPSmY6gZJfJmmkg3B6HpE+wcAlxYa786ULF+jLlfb9RNTckruwIDjOXwaaf2o12faUfFEyuukESr/JEJgWj333y1+632InCPheQ4Uige3RQj/vRB/abarnd04XAH/28HTBYPaONkMK/Ma9Qf3YbrT8zTQidYbcPaJYYTWTyyVAx+yxMlLN5uB5lZaHrllGDv7TOVw3AXywd1pgGVrnQOs2PD7EQp6cFty1ebbvtpcEnsP9K2Fh/YElqRlp31vNNQNSAtAsAT8DiXEjwkVE5apeipC8puEOlrGCadE+Bw8UXChmaFAFqsimI3ZxEwfnc/WySKWkEzOuhDoI0P4Qel4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(66556008)(16576012)(7416002)(36756003)(16526019)(54906003)(52116002)(31696002)(53546011)(83380400001)(8676002)(478600001)(86362001)(66476007)(66946007)(2906002)(6486002)(186003)(5660300002)(2616005)(956004)(31686004)(4326008)(26005)(8936002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFY5YVQyUXZrL09TR0I3dXlVYjdzRXlCNU5KeVNlT1k2NEpBL2M0SWtIQTFv?=
 =?utf-8?B?STJwaFVPRDNxS1kwWmdWZ250SkJVOHJxaEdsaFVyM1pzRHM4YVpiVXE0dVM3?=
 =?utf-8?B?TlNFWi9CMWQ4K0xCOGFoVEFOcnJ5emxOOXlIejBDb2lJRUFaQVQ5WFRLa1VP?=
 =?utf-8?B?dUk5SUltU2NEejlhV3VGV3VidUs3R3hRZWE2OHFtM055Z3doTU9Cb0JVKzBy?=
 =?utf-8?B?K3FjaGR6Ykc3eXZmU3Z2bzJqTjhxSFlZLzc3UDh3NFMyZ2pIZWdiN3hTOGpS?=
 =?utf-8?B?T0dXckR0Zk1HcnBQNnVPUEpKYlNDd3d4MVRPaVlSSWl6alBjOFpNN213Q3R2?=
 =?utf-8?B?VDJrWnRXdEQrM2I3dWVCREZWZmNna2k1bVFIOGM4MnJJUnpqTEJDcGRRRUdX?=
 =?utf-8?B?QzVIVU5WbXdjUjlsZVd0RUo3K0xqZDJKbHRQVkFCamxIaXJwYTRqeUljL1FU?=
 =?utf-8?B?TFlWZU5vNmM3NDdEcURkK2VKMjk5Sjh1VGg2M1g1YXIrN3pqc0JvNUdHMzRn?=
 =?utf-8?B?N0NaQnBDSENhZTdIZkRSQUY4K3MyWkFWWTlMRkUxTUlyRWNWSVlwbHFhQkt6?=
 =?utf-8?B?bUVKbllOaCt6T1BTaW16Yk4zVFlHcjErS3Bpd3BQSnhNTjU5NlByclJ4Tk92?=
 =?utf-8?B?ZjVKUjdJczRJdW1hdlNGajhONTlzR2JXeVNOYXBrTkNGWXI5SytyVnBXckNH?=
 =?utf-8?B?blJtVi9EVFZwd1RieE1ZM1hOMXJBaXA3UTZwNzBnNDh2TVBPc2ViSE1zVEVl?=
 =?utf-8?B?ZUZTS2poczhoWVV3dTRtTEd3cklheFFYdGJmVVd6WDJYWHZ6czVrQlZrZ3Fv?=
 =?utf-8?B?SmtKdXNrQlp6NmlmbTFOV01uYUpvZWk5UVBqYXZJVkxVTmgyMkt3TEorbVVE?=
 =?utf-8?B?NTNYR0lLcFVVaHZzNnA3c1BpUy80QUNmbHJJaGQ5Y1JrcWtXaDhGZWQyUEdk?=
 =?utf-8?B?Nmd1Yk4xajBLdTA0ckJMYWxLUVdCSWxseUxaeWVzYmN2Tms0L01VSGFtWFBZ?=
 =?utf-8?B?bVEzYXQ3eUdQSURoSmtXV2o4dWlBeWV1NVp0N1BNSFEzOFJaTnhJQWwrcWx6?=
 =?utf-8?B?cFJtNm53S0NZQWRreGhzOURXTVAyLzl6RjhOSUZSWFJudkZlVG10NDZMMDJo?=
 =?utf-8?B?VmhicHFCQXBhSUdNUHA2SXdnUUIzTWovSXZpbTN4M21ZQm1GZWhENnhhZktq?=
 =?utf-8?B?bUVkNXdCakxvWVRibHQ5NGwvYzZKRXB4RDNRM1hKcEFEQ2FSbU9aSm5RUWFI?=
 =?utf-8?B?aWxHOUd5TGgvUndraUswRW5CSmtIM3hyTytDVElGMS9xZzhpZ0FocXUxb1lL?=
 =?utf-8?Q?0lh6rICXT+twj1qdb+xoUrmEhKL2/aGFxt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 16:43:44.7758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bba7fc1-49e0-496e-534f-08d89b986d96
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+Yb8Jfttt2eXxlJ5/CvAGHbh/GbkzqENKu7vA490YTPoAOSM+D8we+XInMGVCOetSBoAeb/JKS3ChTxJ1LTbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4812
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/20 3:28 PM, Brijesh Singh wrote:
> The SEV FW version >= 0.23 added a new command that can be used to query
> the attestation report containing the SHA-256 digest of the guest memory
> encrypted through the KVM_SEV_LAUNCH_UPDATE_{DATA, VMSA} commands and
> sign the report with the Platform Endorsement Key (PEK).
> 
> See the SEV FW API spec section 6.8 for more details.
> 
> Note there already exist a command (KVM_SEV_LAUNCH_MEASURE) that can be
> used to get the SHA-256 digest. The main difference between the
> KVM_SEV_LAUNCH_MEASURE and KVM_SEV_ATTESTATION_REPORT is that the later
> can be called while the guest is running and the measurement value is
> signed with PEK.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: John Allen <john.allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Not sure if Paolo or Herbert would like the crypto/psp changes to be split
out from the kvm changes as separate patches or not.

Thanks,
Tom

> ---
>  .../virt/kvm/amd-memory-encryption.rst        | 21 ++++++
>  arch/x86/kvm/svm/sev.c                        | 71 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 17 +++++
>  include/uapi/linux/kvm.h                      |  8 +++
>  5 files changed, 118 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 09a8f2a34e39..4c6685d0fddd 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -263,6 +263,27 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +10. KVM_SEV_GET_ATTESATION_REPORT
> +---------------------------------
> +
> +The KVM_SEV_GET_ATTESATION_REPORT command can be used by the hypervisor to query the attestation
> +report containing the SHA-256 digest of the guest memory and VMSA passed through the KVM_SEV_LAUNCH
> +commands and signed with the PEK. The digest returned by the command should match the digest
> +used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
> +
> +Parameters (in): struct kvm_sev_attestation
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +        struct kvm_sev_attestation_report {
> +                __u8 mnonce[16];        /* A random mnonce that will be placed in the report */
> +
> +                __u64 uaddr;            /* userspace address where the report should be copied */
> +                __u32 len;
> +        };
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 566f4d18185b..c4d3ee6be362 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -927,6 +927,74 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	void __user *report = (void __user *)(uintptr_t)argp->data;
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_attestation_report *data;
> +	struct kvm_sev_attestation_report params;
> +	void __user *p;
> +	void *blob = NULL;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* User wants to query the blob length */
> +	if (!params.len)
> +		goto cmd;
> +
> +	p = (void __user *)(uintptr_t)params.uaddr;
> +	if (p) {
> +		if (params.len > SEV_FW_BLOB_MAX_SIZE) {
> +			ret = -EINVAL;
> +			goto e_free;
> +		}
> +
> +		ret = -ENOMEM;
> +		blob = kmalloc(params.len, GFP_KERNEL);
> +		if (!blob)
> +			goto e_free;
> +
> +		data->address = __psp_pa(blob);
> +		data->len = params.len;
> +		memcpy(data->mnonce, params.mnonce, sizeof(params.mnonce));
> +	}
> +cmd:
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_ATTESTATION_REPORT, data, &argp->error);
> +	/*
> +	 * If we query the session length, FW responded with expected data.
> +	 */
> +	if (!params.len)
> +		goto done;
> +
> +	if (ret)
> +		goto e_free_blob;
> +
> +	if (blob) {
> +		if (copy_to_user(p, blob, params.len))
> +			ret = -EFAULT;
> +	}
> +
> +done:
> +	params.len = data->len;
> +	if (copy_to_user(report, &params, sizeof(params)))
> +		ret = -EFAULT;
> +e_free_blob:
> +	kfree(blob);
> +e_free:
> +	kfree(data);
> +	return ret;
> +}
> +
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -971,6 +1039,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_LAUNCH_SECRET:
>  		r = sev_launch_secret(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_GET_ATTESTATION_REPORT:
> +		r = sev_get_attestation_report(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 476113e12489..cb9b4c4e371e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -128,6 +128,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
>  	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
>  	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
> +	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
>  	default:				return 0;
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 49d155cd2dfe..b801ead1e2bb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -66,6 +66,7 @@ enum sev_cmd {
>  	SEV_CMD_LAUNCH_MEASURE		= 0x033,
>  	SEV_CMD_LAUNCH_UPDATE_SECRET	= 0x034,
>  	SEV_CMD_LAUNCH_FINISH		= 0x035,
> +	SEV_CMD_ATTESTATION_REPORT	= 0x036,
>  
>  	/* Guest migration commands (outgoing) */
>  	SEV_CMD_SEND_START		= 0x040,
> @@ -483,6 +484,22 @@ struct sev_data_dbg {
>  	u32 len;				/* In */
>  } __packed;
>  
> +/**
> + * struct sev_data_attestation_report - SEV_ATTESTATION_REPORT command parameters
> + *
> + * @handle: handle of the VM
> + * @mnonce: a random nonce that will be included in the report.
> + * @address: physical address where the report will be copied.
> + * @len: length of the physical buffer.
> + */
> +struct sev_data_attestation_report {
> +	u32 handle;				/* In */
> +	u32 reserved;
> +	u64 address;				/* In */
> +	u8 mnonce[16];				/* In */
> +	u32 len;				/* In/Out */
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ca41220b40b8..d3385f7f08a2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>  	KVM_SEV_DBG_ENCRYPT,
>  	/* Guest certificates commands */
>  	KVM_SEV_CERT_EXPORT,
> +	/* Attestation report */
> +	KVM_SEV_GET_ATTESTATION_REPORT,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>  	__u32 len;
>  };
>  
> +struct kvm_sev_attestation_report {
> +	__u8 mnonce[16];
> +	__u64 uaddr;
> +	__u32 len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> 
