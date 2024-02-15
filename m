Return-Path: <kvm+bounces-8828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E06856F25
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 22:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 684E01F244F8
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 21:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2727D13EFE9;
	Thu, 15 Feb 2024 21:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xopz8IjP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDDA132461;
	Thu, 15 Feb 2024 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708031663; cv=fail; b=Kr5yTZ4zyPQNWo1ZvEFQePZScVUz0ceHiyeC9rAIS9J0aX14jRN3OTAMQwcX194jtdTog7GNG+MErJzrMl51l1Cq4hbUIvqY0bUFP9GU39GSX1Ot7YgmyE80MahUApfD0g4XJvhfivunNfBz6vdDi29QjOTj2IO4FYU3vNIcbAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708031663; c=relaxed/simple;
	bh=Nwt4uRny0J6SpAtpWi3SSf40171nVGfYHfXFNJIfl3g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Co7yG6BugMMEIoZjgjBF4arQEqVaJ6py19v7gwDNzpVZNVj7ciXWWAS3dmaDGVo2RheKPArtKFEOgnGWUaSCc0VAn6rD2k6uC0WsNxFX6dY1wDit17DFWc166yuLhKWJ5RGGR9ngSEEu54ydfL7rdLdYcHXSqRT+v+PgofqJ4BM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xopz8IjP; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvKWPHJlvBJ976EuuRP6TI7euzsFzIb5ax4KEYeMvS4QeBma6u5bZaW/udHJx1s9TiDXP3cEWh8a7DBy3ylnNMHaZFTRnYPsYKxAM+YVwVICd3l8lPEaEyYOdXGoZ445GrbP68tq74JxQYW5XbWKpuKnSTg7ke/gGmX+p2tJguYq104biEA4OS9HrFcQ1vMF7rERJzReNTKvVfe0fKQLJnGji0C9cUe+QBsLVhGbVwH9nRDegQykKv1OuMJlVgeSeDm3MAf9RRnhif/zIB6yz9kkc4A3TszxAV5UKSeJKbBwkdChVVCexmwwaGKl36kjxvKdQecoi4JahrDNehoWoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wj1HJ+XoBXSdtQVUgy3twPlmybZw2DZ6F6mq+9Eb9fw=;
 b=hxDcCmBSaMAbYJD7ysUL4wWQg5jF3vytq89VfzmM5O3XPMfwX7GkYNT2lnvxBjQ7nz9FdmfsdGVgAgU3Hsg99PJpTAQi2IDLdN91quxT8paemAif9focBrVwzwcL3+SVjl8c0OslgaI0USgeJRhJFXpPCEFZYRunsBNmExvN16c0KIKP019NPVVuDazaBB6DpEjMrE8j2sfxriq3GAgBIcaIIqJCwPTG3YZ5X7qa9oNx6SbLjJaydLj2cCb0SpOKa71rN+AeYMqX77xb3XMJ4hbQtkpc5ul+FZBAWv8Q7xu9Yo+Qhzj2igyBRpm54BjDWwQHswCIeW/zydOEIPxiog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj1HJ+XoBXSdtQVUgy3twPlmybZw2DZ6F6mq+9Eb9fw=;
 b=xopz8IjPhHwFj0X3ZdxJqUtbt9jB5AoHZF/Jpa9ysE3o+iMnIcHE89y5v7YtYKN5BOLmVxYRV2DlTXA9k48H2Z+5x24Wp3wBZGTZNKc+ttSTgxsYURrIv9ZJVVJ1CJRCsocWHZLcwofHqoAUUoNEWJ4AEqnYxDqhitHhu3JW4pk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by IA1PR12MB8078.namprd12.prod.outlook.com (2603:10b6:208:3f1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 21:14:17 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e164:6d6:c04c:ff59]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e164:6d6:c04c:ff59%6]) with mapi id 15.20.7292.022; Thu, 15 Feb 2024
 21:14:17 +0000
Message-ID: <1f66d577-30f5-4686-94a3-3ce7f92a12c8@amd.com>
Date: Thu, 15 Feb 2024 15:14:15 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, michael.roth@amd.com, aik@amd.com,
 isaku.yamahata@intel.com
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-10-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20240209183743.22030-10-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:806:22::7) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|IA1PR12MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: eaee41ab-663c-42ee-cc6f-08dc2e6b1190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tGrd8WdKjVJZ31Z7WQIPZ6f6ptqWDb1cRv0JpbcKD0QW7xBEnLpD/Mjn2FtqPbEgOI2sTniVW5Ivl7DB1fthRBQCj6BEMoNrjIF/bSwHiWotXxkUFQ/3U2vIhMe15uQ8/BJFl31hvpaeGSqyAmN7oewJRLMfDXXUWSp7bXKU8A99E+oHUXnTVfH0VD8JwVXIfHX94pJqG7u3JD+Tq37pBl2E0ajX+GRfbnAIu0oSSN2cz64645u2FeAUQxHGWaV7u55VcfSUNvWSTRSU1MeufbWOpCUGFSBaKbvVawcAYhVfhelFenBCrMRjsWZrCiDyz2gFBnGbfGfdiOrOhS+cKPVFV9G4gpn2VW1Q8FUZR24Kw2278Vhth+A+JN5we8saZOKC5Lovo4ZKkY7k8BpTFQho0coYLEom74WkhP1qKRnlwHHToKhz+3BYfoO/HVIwcyb7uglBhmy0z2pgS9Ox3SF1MqFR2VlB2iRXj8FztbimwGkJd0QWp9r/RlaXU3spC6+cDsLcUjz822e2sFTtsj6y2tWubnSU1Mpul+vs8dClVmmMqI6JCNRnEjbazkHx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(31686004)(4326008)(8936002)(38100700002)(8676002)(41300700001)(36756003)(26005)(86362001)(83380400001)(31696002)(5660300002)(2616005)(66556008)(66946007)(316002)(6486002)(66476007)(478600001)(6506007)(53546011)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFBSYzF4QTNMTGd2cEYzZ2JHY21LMDExNlA2dmJvNHFwR2tvT2RFRStsWGs0?=
 =?utf-8?B?VXhQWlZ2VkE0SHBtbDViakhIbE9jU3dpa3EzcWVlNDNqRjdJZWdHcHdwcGJR?=
 =?utf-8?B?c2pMSTlYQ3p2SkY0blFjTzkvQnlkUjlKVWpsMG4zSi81SitjZEtiZE9IK3FY?=
 =?utf-8?B?UU1CdTZ4a2d6aStSNzA1RkhGdkg1NGMwMTR4TkZVUkxSQUFmK2ttcXRRY0tV?=
 =?utf-8?B?T1IzRHRRNW5sS0ozVGpvRjdscXV6akdPaEtCelptSTZHOGRKVlc2QTRsTHRG?=
 =?utf-8?B?cU40NXYxSjJmYVhlTEV0eDJrWTlZUTN4dlV4TjVDcE95NVd4SmMyekNxN1M5?=
 =?utf-8?B?cjlQWlNsRml0OWJiT0djd2dsL0tVczZiVlNTMnc4N0hhaUhxVGdSaTJEK0NS?=
 =?utf-8?B?S3dpNlhrd0hFV21PNDVzK01sSllpNXZWcDdDYWx2cTQ1Y05rTGR4NEExN1BY?=
 =?utf-8?B?LzJXem1YdkVidEt4VHdyYjlCQmdRbUlUdVlydHNqZkFyR2FmRmZLMWZhQjJL?=
 =?utf-8?B?OTFpUkZWWmw4MEdYWVc5STBnRDBOS2ZIOHRNVFBMQ1YwVUhHbzZtdi9wc0R2?=
 =?utf-8?B?OGRFVkZvd0R6ZUhwenppYmJDZEFFNG1zenpOV0FZcUZ3TG5ra3IvRTJWTmpq?=
 =?utf-8?B?bGpiM3I3OCtZWU1MSkpMbmFMYi9xL0xOdTc4SmppYXFVT3BteVAyM3ZKUGo4?=
 =?utf-8?B?SmZpbFMvbXZDTnB2WlpGVGVPL0VjTG9hYW1vazg1UWNIWGJLZUU0MERGS2p1?=
 =?utf-8?B?UTVYc01Bd3g3MGlhWDM2N0I4U3g3WXgyeXVIM1NIdDluOVhuRXMwUjB3OVFL?=
 =?utf-8?B?c2NjQmphV3RnZmh5amNFUHZnazVCcndxeUNPVXo4SGJzMXNxWGxOV0pKbnpi?=
 =?utf-8?B?Qk9WYi93b1dGRXduRDI0NVFSb3hQcnp5aXk4OWNOblduaEpwRXA3MlE2VSt4?=
 =?utf-8?B?ak1lL3kzSjJHK2ttdzU5VFhINW1hQUlUMkJhSGhaUkhQNURXcmJkZTJ1Q241?=
 =?utf-8?B?aVl4RXlIVnVlaUZ6Y3MzYjVJYkUyOXNDbWNWTWJlRnRrd3ZRNzFCcW90SVlM?=
 =?utf-8?B?d2NnNzVYSS8rSVBETk5Kam1SZEZ5cWZGQmxyNVE0M1FROGVxS1hJVGgxd2pt?=
 =?utf-8?B?MTI4aEVMSjM3S2hRTVhsbzh1UExhSGRVMUpoWm43NFJHMTVGUlU0Ukd3MFov?=
 =?utf-8?B?NkdqUVhwOXQwa2VvUitOSHBWZU92ZWd3Ui9ob05paThTcFU3azAzL2JadkZD?=
 =?utf-8?B?L1QxdmQwcWsrWlVCQ0RLbzh4Vy95azVNL2FJcVZ2SFFvMDVPSWhIcnZ2TEtv?=
 =?utf-8?B?cVJuZm9xdFdwZUpmblBEK1g2UHI4c1ZFWlppMGpickZsT2RXU1pHMXZpWlEv?=
 =?utf-8?B?ODNGb1lzcUFlMjlhQU5nNGswUVI2b1Budzc5bjRsMnlGWVVsbXlEZXVoMFJ1?=
 =?utf-8?B?NFI1YXlpR2h3Y0QzdVYyVHhaRDBKUlVlVndLYS9LRVZtUTQxK25JRjVTWThX?=
 =?utf-8?B?d2VsYnAycVhzejd0M1A3N05rK0ZuTEhrdkpwZ011enE1T1FmRjlNSHhyWXhi?=
 =?utf-8?B?bFF5TCtGeG5vZWpHZkhXWWpmYkZwQzVhenN2MVVYNnV0Q2VxdFZNR1Fvb1li?=
 =?utf-8?B?c1F2aGNNcFhRSFQ5SkxVM1pXSDhPeFdodCtaWkcycnVaSVNtLytVSmZWdTNa?=
 =?utf-8?B?cXI2dSttZ2hvakZ1OTQrRjB5VWE5WkNWZXMydXp1a2xKYVhIeTR4SGdKQU1z?=
 =?utf-8?B?SGMzSW9XcDhTZFBydGVOejFKcjlYcSt3eWx6OC9CRGo4eDJaaitGV2JyYjND?=
 =?utf-8?B?WkVpSkFjeC9rYzF2SWJOSk14UUZkcEZ3UnNWaEZEVkpyZEFZMWhiT2VVbmlG?=
 =?utf-8?B?TEVoTTR6OXFFL2NoV2o3eHJ4cVoyWlcyWDZ6RzFFL1U5aDhnNTQ5bFAxZGNU?=
 =?utf-8?B?Mzg0S2xmb05oSGszM0F6SG9nenl6TTBXcEN2T0tyTUc0Y1RCYzE5ZkJhL0g3?=
 =?utf-8?B?eHNVN1FrY3o3SE1lWUZpYTBBK2JPekszWDJOQzZZNlU5ZnYzdk40bmVWTHIy?=
 =?utf-8?B?ZXpBbjhPQ01qbVNWVy96WWY2d24yZ2g3cVBDU25YNy83ZDJZNUgxa3g4dDVu?=
 =?utf-8?Q?eco/YpMDl4J6X6envLy/+E+iA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaee41ab-663c-42ee-cc6f-08dc2e6b1190
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 21:14:17.2477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fk1fm+JrtRUiQiLvzRGvTd47DaKIpmiFTnba+I0ui8OR1e836658+s++wfKYBojf56LmOnd8IDBhjeQUNOf8vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8078

On 2/9/24 12:37, Paolo Bonzini wrote:
> The idea that no parameter would ever be necessary when enabling SEV or
> SEV-ES for a VM was decidedly optimistic.  In fact, in some sense it's
> already a parameter whether SEV or SEV-ES is desired.  Another possible
> source of variability is the desired set of VMSA features, as that affects
> the measurement of the VM's initial state and cannot be changed
> arbitrarily by the hypervisor.
> 
> Create a new sub-operation for KVM_MEM_ENCRYPT_OP that can take a struct,
> and put the new op to work by including the VMSA features as a field of the
> struct.  The existing KVM_SEV_INIT and KVM_SEV_ES_INIT use the full set of
> supported VMSA features for backwards compatibility.
> 
> The struct also includes the usual bells and whistles for future
> extensibility: a flags field that must be zero for now, and some padding
> at the end.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   .../virt/kvm/x86/amd-memory-encryption.rst    | 41 ++++++++++++++--
>   arch/x86/include/uapi/asm/kvm.h               | 10 ++++
>   arch/x86/kvm/svm/sev.c                        | 48 +++++++++++++++++--
>   3 files changed, 92 insertions(+), 7 deletions(-)
> 

...

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index acf5c45ef14e..78c52764453f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -252,7 +252,9 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   	sev_decommission(handle);
>   }
>   
> -static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
> +			    struct kvm_sev_init *data,
> +			    unsigned long vm_type)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	int asid, ret;
> @@ -260,7 +262,10 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	if (kvm->created_vcpus)
>   		return -EINVAL;
>   
> -	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +	if (data->flags)
> +		return -EINVAL;
> +
> +	if (data->vmsa_features & ~sev_supported_vmsa_features)

An SEV guest doesn't have protected state and so it doesn't have a VMSA to 
which you can apply features. So this should be:

	if (vm_type != KVM_X86_SEV_VM &&
	    (data->vmsa_features & ~sev_supported_vmsa_features))

Thanks,
Tom

>   		return -EINVAL;
>   
>   	ret = -EBUSY;
> @@ -268,8 +273,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		return ret;
>   
>   	sev->active = true;
> -	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> -	sev->vmsa_features = sev_supported_vmsa_features;
> +	sev->es_active = (vm_type & __KVM_X86_PROTECTED_STATE_TYPE) != 0;
> +	sev->vmsa_features = data->vmsa_features;
>   
>   	asid = sev_asid_new(sev);
>   	if (asid < 0)
> @@ -298,6 +303,38 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_init data = {
> +		.vmsa_features = sev_supported_vmsa_features,
> +	};
> +	unsigned long vm_type;
> +
> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +		return -EINVAL;
> +
> +	vm_type = (argp->id == KVM_SEV_INIT ? KVM_X86_SEV_VM : KVM_X86_SEV_ES_VM);
> +	return __sev_guest_init(kvm, argp, &data, vm_type);
> +}
> +
> +static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct kvm_sev_init data;
> +
> +	if (!sev->need_init)
> +		return -EINVAL;
> +
> +	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
> +	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&data, (void __user *)(uintptr_t)argp->data, sizeof(data)))
> +		return -EFAULT;
> +
> +	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type);
> +}
> +
>   static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
>   {
>   	struct sev_data_activate activate;
> @@ -1915,6 +1952,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_INIT:
>   		r = sev_guest_init(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_INIT2:
> +		r = sev_guest_init2(kvm, &sev_cmd);
> +		break;
>   	case KVM_SEV_LAUNCH_START:
>   		r = sev_launch_start(kvm, &sev_cmd);
>   		break;

