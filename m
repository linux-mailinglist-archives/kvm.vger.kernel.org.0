Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A252F6D57
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 22:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbhANViR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 16:38:17 -0500
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:4193
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726921AbhANViO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 16:38:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipsO/gfQFdpCKf+G4rAW48P2aCAB1Gm90U+kRNIMglMAtQeUY0WDvKRoACqt0Azb6ZzMF7F+4HYKYhsWwQu7CC1AWf7JU8TiMChKmw3g1gxgSBVPxl3FhRk4oZJu8wey64/PmZ39i0ePLdOHzim7S6RjHEPD10vbzazQ5MlfTP4pOXikiB+4dXd7Yi4eVKlR6kzDZeO4KdsSvos5sDI/ua/ud8hMwaRWqp1IB1NVgmGyNnUEwt/yMVWGsHiUZWlgW8L74iDYUthN4RjZOcbZo9oPMvTymBd4BVo/xECrpKKuMmoe8ENJhkqtWnQCId1YO9D+Cz0e2pIdQ8LYTFVG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzYa0YsO0fYuUTOHTaf5pvaK00/JrAvwgy9dtI/AGA8=;
 b=KUk6u0t6U0+fynAPnACTM16LegjOCjcrKdgPTg1HN8V+QDhqt2YpGV4ewgSkeSSexOnDiMmLd9esO8Nf107Dlv7PURaJaLKSzQ8J1GWuEo1bp6A2wlcZ/Rs4AuqrkO8TUcROzw6tz9U/95Qtg0PI2ZxE82cBx3LePnNXAv6aNAg9rkDlqbR934YOEXcHtFyHLPu7w0tS89/eth2ukFyfKR+NUWTcv98OC1yePWktbIK74Yk/sqVleoz3v8NfbjuaWjArvo6kpSWuwoeDYJEEjffxyKF6RWLWvNZe4QhFvmFi/dkBn1JQu340cJLuP+DV8Wk6fDX8uipNETdHr9LvKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzYa0YsO0fYuUTOHTaf5pvaK00/JrAvwgy9dtI/AGA8=;
 b=Yk1FgsbVYe8yjBpT1WIz5gU0eWg940eYghYWxdOTGBvjwHu3poMKpYjxFcfAluj01Xtr1xLmW+S/njetcqCLfB0sP7h9ZG9Sby3DkH0D557ddxZrWY4XlKOAxzyHfY+UXYc5kwhdRb2R58SY4SFVH8UlcgSbg7A4krrwbi62EAo=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 21:37:21 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 21:37:21 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 11/14] KVM: SVM: Move SEV VMCB tracking allocation to
 sev.c
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-12-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <10d43bb0-e19d-6d53-20f7-fa73983adb4a@amd.com>
Date:   Thu, 14 Jan 2021 15:37:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210114003708.3798992-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0076.namprd11.prod.outlook.com
 (2603:10b6:806:d2::21) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0076.namprd11.prod.outlook.com (2603:10b6:806:d2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 21:37:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9744f790-9e7e-4d4a-7a0b-08d8b8d49368
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457315C1991CCD4DC1F3AF9BE5A80@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oYfMFMDCSMlOr1w8F8pJ/a5HovdjasP78pDKWnoax+yP0ta5XrcS/yBukj7KKr2ZyLIQXDNgcLdhvRbQZ7kxZW+91RF7bGfE7vzA7vhzoAL34EbC3JdqgNKAEUdYWJCsbflb1jCFQcb3YNQh7zWXJBrtm6J6T6Kjnt1E33XMFPXoFTDMBzz3CmWr7ZSTSrcqnVlDiB12Lm/5Zl9f+62F2VoE6G8D+kKqruqeIRajer9LJ6+sJ/LFGDiYEtwGsDlUNOj4cus99XvL2wRf8yZ8liqXjQvnDyoc86qzBHzGmGT4+I/KRLyi2A5jsFlFdMgLL5twDlyxL2fdbEuBqrgUkTTeIl8IUGwrrP6QI4rhjGr3zPYOzHnUSCx+TYzx+sEgHa1+jYqJr5FRgjZlXlV5QDa1AlCRQitQHW4NDm5ylNBSoDj1BB2eMK2LqO5YgL0Nieibnrl9U7/ArSjSvU3ggDHACY+TxbTfQURXMc4dTJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6506007)(7416002)(53546011)(8676002)(83380400001)(26005)(16526019)(110136005)(5660300002)(31686004)(186003)(31696002)(86362001)(316002)(6486002)(2906002)(36756003)(54906003)(6512007)(66946007)(66476007)(478600001)(956004)(8936002)(2616005)(66556008)(44832011)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MlEveDVVRlZ3OGhSbmdZMmJhWUpRbFNSbXBDL3NmSy95eUhFZjRwVlNnV0F4?=
 =?utf-8?B?WlhrSFp0Z1EyWlRrU05VbSs2amp5b083OG40Qlg2RCsyVW1OV09JWWtYLzM2?=
 =?utf-8?B?WC9uMlRSZjZZamxoTU01Qnp2MUxaYkVuQzFLY1dVeVhrMU5CdFBaM0FQb2ZR?=
 =?utf-8?B?YUIxS1F0TGQwWWhnM3A3MFp5OUlLV3RVMEpFaHROS09ZNCtSbUU3M1ZTYlVw?=
 =?utf-8?B?YXRwanBjWmliWGdnd3ZSeXN0Vmd4aVB1WmN6NUwyZWU2OUhNRFRaczJXQi9t?=
 =?utf-8?B?WVlNUnZxbFVPeW1CcWlIbXcxR2p0L082N0xlaTNnRENLOFc0S2M1RUpUcFQz?=
 =?utf-8?B?enJiVTNkem80Zk1sSTN4L255VmRISGN0d2V2OXBLL2lVNjhZRlArN1owTUlm?=
 =?utf-8?B?UmNEdG5GdmNCV0pxR1JxR0kzUnNGMjlxRDlVRDNndnNxMkxnN3pLRGNnZ1Ru?=
 =?utf-8?B?UXdCMjFlQW11NHovc2xUZTFxY3RHeklMMUFkWHR5dExvTkZZd3gvNE1TYmpE?=
 =?utf-8?B?MS9qYUFQMUdRQ1BIcTUrTElqMWVWWnpJUVVYVTZORFBFOFBndlFyeU5OdHRO?=
 =?utf-8?B?aXVuUXJsNWtPYUJFbUZ5MUtUMk5yUTZFTlYyZHVnbHVhSGJuWnc1MGlHTWdn?=
 =?utf-8?B?SnVkYmNiSHBCa25Icnd6ODZnc1M4eDNrelphQjBRS1hpaDRGYy9YT3BBTFpX?=
 =?utf-8?B?bjJnYUhVTk1TeVdTaFpyblJHb0xUcDBrNEt5djF2Vis2bnMrTEJCY3l3aytr?=
 =?utf-8?B?dVdCRUNwajFYR1dsc2ZMdjNmT0NSVHVMbUc5NHR1TGozcjRXbEN1SEloWmNH?=
 =?utf-8?B?ZjRUZTZCZ3JiVVNyTG1yYnpReWgzc3FvS2dOQmtPWVZwSVltWVFxbmZQRjlE?=
 =?utf-8?B?L1NKaDdMa2VCcGY3Z2Nvakk3dXpsaDJMRklSNW1EQ1NERm1nWENBWnY0dm14?=
 =?utf-8?B?VDRicVVqSmxtUW5RTEhtTjdmY3JGaDdUL2xyNm52S0RRZmtFYkFSdmQ1ejdI?=
 =?utf-8?B?a0gxcDhualJoU1IwVzMzTHU0emRrTU40b1ZWWUpIWGZGcWhJN0NZdUN3UUNa?=
 =?utf-8?B?YnJxbVZrM0YyamxhZFVBRW8yMStHM04wbC9FN1VIWmRteG9ieGRLR2piSzdi?=
 =?utf-8?B?RmwySllqOTRyOE9ubllsb1pxUEZueUpmU2RXeUkvaFkrVVA2NXlMODZrdThJ?=
 =?utf-8?B?V3FOSC9vMmRUUXJVT0liYTNRSUQxYXZMbnF0Yk50L0hqVU1VemhNSUZaNG5h?=
 =?utf-8?B?WnU2VGRsMDkvcHBlbmg3OU5rUTgydDdmQjM2OWJKbUxqemRrWXFoSmRHYk1z?=
 =?utf-8?Q?W2F5osm4CP8gVRiq7KN4uoWh5ITX/w7KcL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 21:37:21.8000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9744f790-9e7e-4d4a-7a0b-08d8b8d49368
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qt+F6WW3UxoWf4AYVT2sdyIuvpzU5Oz8TAU0fDAq5sJnCMCPcukwxATT3qxtAKqMCrvdJGvsISbfwDdZJGJerg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Move the allocation of the SEV VMCB array to sev.c to help pave the way
> toward encapsulating SEV enabling wholly within sev.c.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 13 +++++++++++++
>  arch/x86/kvm/svm/svm.c | 17 ++++++++---------
>  arch/x86/kvm/svm/svm.h |  1 +
>  3 files changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1a143340103e..a2c3e2d42a7f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1330,6 +1330,19 @@ void sev_hardware_teardown(void)
>  	sev_flush_asids();
>  }
>  
> +int sev_cpu_init(struct svm_cpu_data *sd)
> +{
> +	if (!svm_sev_enabled())
> +		return 0;
> +
> +	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
> +				      GFP_KERNEL | __GFP_ZERO);


I saw Tom recommended to use kzalloc.. instead of __GFP_ZERO in previous
patch. With that fixed,

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


> +	if (!sd->sev_vmcbs)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>  /*
>   * Pages used by hardware to hold guest encrypted state must be flushed before
>   * returning them to the system.
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index bb7b99743bea..89b95fb87a0c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -552,23 +552,22 @@ static void svm_cpu_uninit(int cpu)
>  static int svm_cpu_init(int cpu)
>  {
>  	struct svm_cpu_data *sd;
> +	int ret;
>  
>  	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
>  	if (!sd)
>  		return -ENOMEM;
>  	sd->cpu = cpu;
>  	sd->save_area = alloc_page(GFP_KERNEL);
> -	if (!sd->save_area)
> +	if (!sd->save_area) {
> +		ret = -ENOMEM;
>  		goto free_cpu_data;
> +	}
>  	clear_page(page_address(sd->save_area));
>  
> -	if (svm_sev_enabled()) {
> -		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
> -					      sizeof(void *),
> -					      GFP_KERNEL | __GFP_ZERO);
> -		if (!sd->sev_vmcbs)
> -			goto free_save_area;
> -	}
> +	ret = sev_cpu_init(sd);
> +	if (ret)
> +		goto free_save_area;
>  
>  	per_cpu(svm_data, cpu) = sd;
>  
> @@ -578,7 +577,7 @@ static int svm_cpu_init(int cpu)
>  	__free_page(sd->save_area);
>  free_cpu_data:
>  	kfree(sd);
> -	return -ENOMEM;
> +	return ret;
>  
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8e169835f52a..4eb4bab0ca3e 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -583,6 +583,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> +int sev_cpu_init(struct svm_cpu_data *sd);
>  void sev_free_vcpu(struct kvm_vcpu *vcpu);
>  int sev_handle_vmgexit(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
