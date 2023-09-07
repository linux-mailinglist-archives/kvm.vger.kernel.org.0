Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53FB797E28
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 23:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbjIGV45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 17:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjIGV44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 17:56:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130011BC6;
        Thu,  7 Sep 2023 14:56:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIKVHh8eSxUBaqSjyqqrbZHAQTg1V4cPU7itYk+zcVyo7EQwWbYfYva32K3/SU3/5wT71BX2Nfm0r93mLHke3p9wVUoqScRvNNWBd24FT/dR3QaLUtXQT5QrCagu/PR/KtIsQqzeYAPLq2Xh20s8+KmnL6hul6sDjWMjNIM8ZR+LHjWnhDBx2b9CkHV3d1VneI6YkOQAUG7kLbHexUD5FocmrIBTcbDkXDDuOoz0nQXffbk7GI4OJ8zsCAao8eUEDV2Lk1aZ0e09rU2+9EQI/S0WbZERpImVOmzkfHfLs+HEx+YVHWoRETtdvDDRb+A2V/gEaWxPfl+PWt4G40ER8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wki2vmNxuksPM75xezSj0G8FGK/lyV9tpYa8a84bFZk=;
 b=glZvl+eITcf7OFO/aRY0tpsyftk2vvpdW8vvTuOc2Tprk5GJ9pSueOC/FIYAhCgSId+P5+VqK3SlDiIpTC0/0PPXPCbyALU5AMwhT0clkkLA4bekZp+9sDBhcgQfE1I6v+QSeHokiJ8GW1nW02v2Qb5tos4yl1lMvWfPKTCugtEQVBz+ee0lZqqDl1l6h3tdhqDxvahyF4UKYCR1xLiwP2mrb35AVExNdl3rNG9M6D7GPAZfYbaU4ZAUaSgU4/prxKItnljxU+oTazFK+RAJH2IiPqN/AnSSwNgjdAOuYtYcQCyS+OeKBQtcaqllO9o2N6D9jT03tfTKEr0soaOcQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wki2vmNxuksPM75xezSj0G8FGK/lyV9tpYa8a84bFZk=;
 b=jdKSMWG4FLAr5bdTKjSRpZq/GXHHixkfSYS4qSA3GD6L1J186pOjRk+eBXYJ818Bg4KBHpZ3PRCArO3hZxEvaP8jFuUvithMYoUAwOiPeEg/SmDntnsGjWfhUMg8A7xmql2nMGHYZ+H+pZiViF765La1+qpUF/Czi0Q2Bu5ip0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by IA1PR12MB8222.namprd12.prod.outlook.com (2603:10b6:208:3f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 7 Sep
 2023 21:56:49 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6745.035; Thu, 7 Sep 2023
 21:56:49 +0000
Message-ID: <2b6b1ae1-d209-edc9-76ab-15a17c23f038@amd.com>
Date:   Thu, 7 Sep 2023 16:56:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH V3] KVM: SEV: Update SEV-ES shutdown intercepts with more
 metadata
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230907162449.1739785-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230907162449.1739785-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:806:21::8) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|IA1PR12MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: bb287c65-8d29-4790-c64a-08dbafed5617
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGmRyLmTWnS6xhr7RQwz02BpIdHILMu1xA3znR1d+tACVoU1Qcs1aAYWleOtKmEdoSrSiYpRLkaXTUxva5WLNEDEfKWGVSGcbZ6aoKWg8axD6pjjt7+wbpPrMXVb22EMUkWxGPGzwbOPnQzrI+dSDsQ4AYk2APAQda/KdYlDWJ7omZ3kFzXAlYoKKFFpqK1xa/w6SO39a1PxX2tfp7Dpsh+MZp/tLutojwuKnFVIBj1YinJ+3SvQa7BNZHevLghcKvvO2IPItvg+5gyxYmotpDJuWFt1No5Z2rkGIz5n97yPyBnZ56ooP9IrcnDe/Y5+bcEXEOW8riVHey+gZ0jsQjIt6jMswFCxj3NbInZA5GBoYt7qZGJMzmkykXYMFMhmWIkFcOukbQDfMonfRqfq6ZCkvuranw3ucBkYVY6mIIwsjosp52nPTNeucmVL5ln77lmTzlfCZkRHy2tPcLhhT8bscOygpJWM2HniUv9OgnlfGvfmT1C7p8wrq7BWg/2yJ9o7Ef5WwfSDURFPJk+llaPivtL1xUdgLb4Sx4V8zYsJndJ49qz9w3cwDEHfizd1yLX0JwU35jlOHpzWhwqKWVLLYNWmqlj5iy+q88OS8aK+KMa28i0bl5kGxuOROpAyiT+8FeM4HT5dYa5+n05VgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199024)(186009)(1800799009)(66556008)(66946007)(66476007)(4326008)(5660300002)(316002)(54906003)(8676002)(41300700001)(8936002)(6512007)(6486002)(2616005)(6506007)(83380400001)(53546011)(26005)(6666004)(478600001)(15650500001)(2906002)(86362001)(31686004)(31696002)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2RkOXRwb1Q1Rkw1U2c2RnM1aTY1TGM3bEZTVmVvZWtOejlDZEY3VG9Rb3VP?=
 =?utf-8?B?M0NnakI2cE0wb2RsWHNhZUpXSklRK3p0c3hMMkY2M2JNSU5LUGNWSjZxQXFW?=
 =?utf-8?B?dUFtenBPTmFKMjJ4cXY0RTUxS0oxRHRvc2ZSOHFRM2U3RUhicElmWnhTUmhD?=
 =?utf-8?B?S3dIazVydklaeUpvclM3L3YvZDFFSTF6U1hSb0pTeDRCOWlSdVBXc0x3ZHlI?=
 =?utf-8?B?NjZ2ZmJYRjVHYy8zRHEwTW9mWStzL2xFV0V1ZzhIR2svTjBVL2pYYWgzd25v?=
 =?utf-8?B?eG5tZVZIekQzM2Yzd3ZlMnBJdlR4aHRVelIvSEpFSS9EK2VHSUNPMFNFcHJp?=
 =?utf-8?B?UGg3VDhONnhHRHFCQm0yUkJDU0lZUGU1L09wTTcvSVUyY29FV3JpaW1ZTDNG?=
 =?utf-8?B?cTQ3d3FKbm4rYnNrbk5FaXZRQThwR05EWm5lQXI2d2QxSzlUd1g1bkNpSUxD?=
 =?utf-8?B?ZUcrUXV4ckNTUmg5NUZBNE5VMHdjYlZkZHJPWHBiQTk2T2xMKzR1Q2JEUmxK?=
 =?utf-8?B?WmN2YnJZZDEybmRnZmpoSUNUQ3hKVUJWU3N4SGxEelZ5Mk5BSm9hYndqVFZl?=
 =?utf-8?B?SXpTb0hyOHZ3b1UvL0N5Wnh6eTgxNlBVU0J1MDVRMFdZbHBpN3FuSlB5U0NC?=
 =?utf-8?B?NDI5Uk9kSk95R0kxQkEwZm9GTFRoWXB6RUNZRllFZzZzaE1COWNEOFpJMHk2?=
 =?utf-8?B?bnhueTNYbHY0ZWRBYUZTSk5CckRVeUFBejUvSDllbDh1TlpmZGJxWW96YkZi?=
 =?utf-8?B?aS9ZSUh1WUtMeUVKak9Rb3dvcXJlNWhpbGNMbVBNRkZML3QxMm53ZHkrVDJC?=
 =?utf-8?B?b0d6MmVCajBhSkhhUGkxelVsWjhLZGw0QlZveGpwWkpacVF2QmVWV05XZU05?=
 =?utf-8?B?bktqYjFOMTZvdk9WdExNb1h1cDdxdENGS2ErTFZFQkhsWWYrVUFFUDJ5a1Bv?=
 =?utf-8?B?Q1dFMU9KUlJ2Y284VEFWMnFVT3Z3MlRhdUtWUDU2R1hxZWhPSU1Oc0hWOEc5?=
 =?utf-8?B?TG5TRzcyWWJOckhacXA0emR5ZEZheXRkU0NSc1NadzZ4WXpnL00xeS9NZnd6?=
 =?utf-8?B?OXB4YkkzR3VxSTljSU5HcnczQTdsRzE1Umc1dVNhUzZzSk1ZaHlJcHNzbmxZ?=
 =?utf-8?B?bWJicVVjWllFSW5NQTBNWUVMVWs5RzZqTmZ3OGVHdEYvSUJnbWFscHN6NWhF?=
 =?utf-8?B?d1FZV3Nnb3J1TEU4UjFaZnFzSzFMTFNKTWtuNlc4UnQxSkdCcThCaDVBR20w?=
 =?utf-8?B?V2xrN1l0NWVpMVlTN3FrdCtCd0gxbHZQanF4UnpTRFFrNGxvZlYwL0tyZnpq?=
 =?utf-8?B?eWhuV0RXVW1KZmVqcXoxZUZsdDNFRXZFUi9ZaStqcnRWNm5rVUdkekRueFY5?=
 =?utf-8?B?b0hDWUI1V0ozU3FNaFgxNzN5WHgrc0tYaEgzU29VdGIzMm55Rkg1TXNVVytz?=
 =?utf-8?B?dGVYN083SXZoRmJVOXJDZ3lONVQ1MlhqVXkyb2hxVWxmZVAzdTE2QXl0TVQ2?=
 =?utf-8?B?WHNtQ09vKzBiRzRqV2xXME9EWTZ1R3B0OXpnVlNobnVnOS9MK0MrYzhhekNl?=
 =?utf-8?B?MnRYRlNGMjhjY0ljWlRKWVNzNVJIN3VyNUUxU0xLWVpKczRzQVlxbHNmMFhZ?=
 =?utf-8?B?S3VXOWg3MzBOQmp6YnlqdnNSTmVTYys5SVFzR1NNSVdqTkE1b2ZCSHcwejFp?=
 =?utf-8?B?Vk9NWjZ5Z2hESmhvVVlveUN0WmxESS9SYWpVTnhkNE03eHZ1ZXRpQm4yL1ZE?=
 =?utf-8?B?MU9qSmN1ZUpZUFdlcStoY0NzQ25jeE9pZGJyUVp1MHFRMTg3WWZkcVB3Q3oy?=
 =?utf-8?B?QlphdU5TQUNuTFVWcFBTanFVdnZrUTlZSzU2Uk5ha0tHMzQ4RzA1ckVTbEwx?=
 =?utf-8?B?UkxWMEFVb0d4OHRVMUNFQUlJWi9uV2JJbDVXWjV3WFl1QldiMS9RSitiQ1h5?=
 =?utf-8?B?azFHSEFiU2pleXRUS0I1MkdpK3NldExaT3Z2VXVCelZzOTI5S0pPNXYxc2No?=
 =?utf-8?B?SVJSL0VJUmVRUzJKMUJOUXlDVmlDM3N2RTd5MTNEYmtwdDJDVG5MbmdVL0dV?=
 =?utf-8?B?b0pMTnBUT25hTWtqUnl5cUNjdHk5eTN0a1BYK1lseEp4dGVvQXdaMnZZZ1FM?=
 =?utf-8?Q?7p5Lc9JQQDWp3XyVXjDmv93gB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb287c65-8d29-4790-c64a-08dbafed5617
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2023 21:56:49.1694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJ9IgHIpkS8TJeml/sgSUysbea8mzppYBkrm3l3R/amj5hCzRsHNCSwbyOICR4mhr8zrbk9q+xWejhS/nxLeYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8222
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/7/23 11:24, Peter Gonda wrote:
> Currently if an SEV-ES VM shuts down userspace sees KVM_RUN struct with
> only the INVALID_ARGUMENT. This is a very limited amount of information
> to debug the situation. Instead KVM can return a
> KVM_EXIT_SHUTDOWN to alert userspace the VM is shutting down and
> is not usable any further.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/svm.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 956726d867aa..114afc897465 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2127,12 +2127,6 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>   	struct kvm_run *kvm_run = vcpu->run;
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> -	/*
> -	 * The VM save area has already been encrypted so it
> -	 * cannot be reinitialized - just terminate.
> -	 */
> -	if (sev_es_guest(vcpu->kvm))
> -		return -EINVAL;
>   
>   	/*
>   	 * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU to put
> @@ -2141,9 +2135,14 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>   	 * userspace.  At a platform view, INIT is acceptable behavior as
>   	 * there exist bare metal platforms that automatically INIT the CPU
>   	 * in response to shutdown.
> +	 *
> +	 * The VM save area for SEV-ES guests has already been encrypted so it
> +	 * cannot be reinitialized, i.e. synthesizing INIT is futile.
>   	 */
> -	clear_page(svm->vmcb);
> -	kvm_vcpu_reset(vcpu, true);
> +	if (!sev_es_guest(vcpu->kvm)) {
> +		clear_page(svm->vmcb);
> +		kvm_vcpu_reset(vcpu, true);
> +	}
>   
>   	kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
>   	return 0;
