Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE32F2F6551
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 17:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbhANP56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 10:57:58 -0500
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:9724
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726468AbhANP56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 10:57:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvrUtWlKvwQDXDTRXmMkFUf7Lpujl8SufAoNGdDecXV+/5AA4RyARlkkzL57rI1g4bSEJ5yjChq6sy8fA1x8IGseoQV0Ty0EYopvYzwPBintcG0wQ2ZWNkWTvyCA7neiM/zGrw6eqwxRG/vLz7Dft9mm1fWKpIgU+g7jZs3eaX4Y1UcI26/Pkk10cdfRVp9jhwqvKZnZAXEycnt/Q3nKq9pPn8wYZhDokSASnWHHon60hjGAYqfKZdKv3uUFTQFf217XY0n9mk7UGE0rU/fTREvkbpiPBYL3PxQ6wq/5k/ztZUjG2+KwW6Rccck5tsYFu73AOdEf4F/rPCO1gtzutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJIYsay0nkH1KGAPL5rR2u2QzPBO+kzsgBxUS7uJ1jY=;
 b=JLJOvMkcWj45XGS5H7gB5nt2Z/yyFo7b4YZyabd4IvCHsoC2EfYiKBWqJ+3doVrANOBgO6QxH9lJK++28xycW/ez/ANbDW2wszHFzWxPSueRxJ/NnzUdDzGMFdDu6gsxb7jYxyfiEWBGLZ7BeGRVdaK9J9aHBetj+KPkizmPED2XOULuzQjg1lwhjomM79X/fDfi8GaHIgQ2SQILHpGEAAtXj03Wq9Oz3mgENdnMEmojYUKJzqUFwwDLm8ilTkrnjQtFwEMU4blYY7F1gMIqz7bMetBBhbX5XKCEOJ8/hzzz3CCKbbGYBsV2n4nIOoDLrcx+0+4wCWqpsikHmzQcZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJIYsay0nkH1KGAPL5rR2u2QzPBO+kzsgBxUS7uJ1jY=;
 b=bH+hMOePmTBCPEOJGPASL1dLF6Fe92r+RrasiUt4M5HsZeLsX3kjTZMIulhnJq+H/J2S1gwqL6JIhdX0f83+RMHJS+wJh6fV3kgG4vKFds9FCtDVkmsbtrmni4xG6G0K5kuDeSh5RQEzPz/3s0de7sTYhrOg8cW842a2j1r7McE=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1708.namprd12.prod.outlook.com (2603:10b6:3:10e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Thu, 14 Jan 2021 15:56:42 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 15:56:42 +0000
Subject: Re: [PATCH v2 01/14] KVM: SVM: Zero out the VMCB array used to track
 SEV ASID association
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-2-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3d41137e-e8e0-8139-3050-eac58ad82a4f@amd.com>
Date:   Thu, 14 Jan 2021 09:56:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR04CA0081.namprd04.prod.outlook.com
 (2603:10b6:805:f2::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR04CA0081.namprd04.prod.outlook.com (2603:10b6:805:f2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 15:56:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c96579a0-23cf-460e-8597-08d8b8a4fc8c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1708:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17084CB2E6969A581731D067ECA80@DM5PR12MB1708.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hF3PiLJaeY5AJRffydTJzo8wVzcqwmCnisB3Ii6bPkpfS+xX4PoZQNgN8l86uEOxMkLVQSCwtGkvPBq5+mBPVIMoZWYwE9gp7GJ2O59AnySvk6EznEdGiZY75v2GdefUe36OhwzMRwTacjmpKklFJO2v3yqXVGxkPOw2MnPTZuV2M5V8WYWmMRn9SVPfKkImcPMTGapDBOX1jHnLMTINjipWyw6EwsnfYglPUTiTJfcurxRlqfZr56BB9Unh6ud7OodEAkZYEnHK7vLEJNBXmTneERTcIIwAa3AcMih8I42VrRdANB9COktTEJHJgP6XLQpzTy0cCdD/UANmcpoJPmGoVjc1MEkw65xernOdcXpkUxkS523ODiswj8njpa9i2eiOEKOnyZHzFHjAGZu6ii25ZSXhBXxo7gcMmLVw2d3FNV7GwvVI44LUtPSWXVTzMyFDwsRbwvnLIIpO1bwgHAqY3IC3IzpYZ3gNUOVHMts=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(86362001)(956004)(66946007)(36756003)(26005)(6506007)(4326008)(8936002)(53546011)(8676002)(83380400001)(66476007)(316002)(6512007)(52116002)(54906003)(186003)(110136005)(7416002)(2906002)(478600001)(66556008)(5660300002)(16526019)(31696002)(2616005)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TU9ITi9lc1RDVHVhZENWZ05ITVduSU5WZElvWlNEU3VwaEMrRHBza1FCOEJC?=
 =?utf-8?B?b1JOMXNubjdGamRTUTh0Y0VKdERlMHNZbEQvWFNUV2FWbG5xazMzamszM1hI?=
 =?utf-8?B?V0t5UUxqWTBKRXpxZGR3MmxyZkx1dUJLeEdwc2FzVXNuUTRrV2haNEVoTkli?=
 =?utf-8?B?NzROTVNBYXJBclYrMUZWSVh6ZlFCbS94N2dGd2tRMUwrSUtBMUJVNWY4eWVO?=
 =?utf-8?B?SFc2YlVGaEcvOWZEWmNFY0VubkpRdmlYNXNzbC9mSGlYTHdlVFJudkRnZ3Iy?=
 =?utf-8?B?NEVFVm9NYUxXeDBBZGR1SE5EVEh1N09hTXd4NXdkUXltUVdsV2pqUFZqa0NH?=
 =?utf-8?B?a3BITWdSREpIL3RSa1VtVG0xV0xhM3d1bUdYZndCQzB1UU54bjRYWWplR2VZ?=
 =?utf-8?B?UFVKNzhiRVo0ZHBrQ1R1NGZsMERHdlJpZkJrNGIxSHB5azZtNlZpdS9pNHRw?=
 =?utf-8?B?eEw4cCtDd1diMGFBR2ZjVlVEL3ZJQ1ZQcURERTFMWDVvdHB0N203ZVFYanZE?=
 =?utf-8?B?T0NsMGRvaHh2M1R5ZVdBNUNBOXFSUVNNSDd3Y2lWb2ZNMzlRZ2RXVlg3cWJC?=
 =?utf-8?B?NW5PN0lNYWV3ZE1BN3ZjdGZnTGZNT2ZRaGdiaVFBVkVldk1sV1FsSEk4WmRk?=
 =?utf-8?B?dlo1aFhZaFp0U0c0MUIwdmU1TUFCTGxlSXQ1NjFXM01SbXZiNXFwQXhra2wz?=
 =?utf-8?B?SUtIaktEY1ZlWndVcmoxRlVMOTh4cnZLcVFXcHRabkg3TG5MN0szbUsyRUJu?=
 =?utf-8?B?aytsNjZQbXl0SnRzT3JwMEI3b1VCMXc2VDV0YXNoa0ZibFZwYnIvOTJSUm5R?=
 =?utf-8?B?ZVMweXI1bjJmQ1dPcngwV2JDSnVqaXVvK3lNbWZEcDd6aGdGZTJBYzdDcXo5?=
 =?utf-8?B?RFFucGlMWGFZSTFUclp0SjFEM21PZm9Cc0ZhOERPcmU4bnhkc1J3K2NZUjlL?=
 =?utf-8?B?RHBkNEhieDhTQ3JkRll6VUV0L2Iva0dzNHpxMms0aVlDbUs0ZHd4SmhGQ1Uy?=
 =?utf-8?B?aHQ2QVJKc1FlOHZFbyt1NXpaTnpKNmZLaFdrUlFGZVUzWGdXMVlYZ2pUVTNv?=
 =?utf-8?B?Zkg4YWRQeSt2OGdTQXYvSGV5cytBM0hSRWFmRVI5ZnpEM0IrbG5mSnVWSi81?=
 =?utf-8?B?cmJ3K3J6N2o3QjlTZzFqZnVJTjVwSlAxZjNHODd0U3RHU2VVUFBaMWpFUnRy?=
 =?utf-8?B?bUV3c2o2UWhOWENWOGlUM3kwd3N1OWFJMFhlZVBybXNnVkN5OS9kb2s3Q1c4?=
 =?utf-8?B?dkxnUjgxcUowcFZVSHpLZ1hsTTVuTnBKVHVEUUkrR0dpYW5wMDV0bXNobVJl?=
 =?utf-8?Q?iOOYdUGDaOup552fX13f1oca4D8zJA+Bcs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 15:56:42.3520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c96579a0-23cf-460e-8597-08d8b8a4fc8c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50C2xJpybELVCHPRzAyquYC6PK8GkKfmGmOiT2gYRLmv/5jyq+XILckpKcUBPc/ula+YmDY9x1oSF4/sXiHDGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1708
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:36 PM, Sean Christopherson wrote:
> Zero out the array of VMCB pointers so that pre_sev_run() won't see
> garbage when querying the array to detect when an SEV ASID is being
> associated with a new VMCB.  In practice, reading random values is all
> but guaranteed to be benign as a false negative (which is extremely
> unlikely on its own) can only happen on CPU0 on the first VMRUN and would
> only cause KVM to skip the ASID flush.  For anything bad to happen, a
> previous instance of KVM would have to exit without flushing the ASID,
> _and_ KVM would have to not flush the ASID at any time while building the
> new SEV guest.
> 
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ef171790d02..ccf52c5531fb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -573,7 +573,7 @@ static int svm_cpu_init(int cpu)
>   	if (svm_sev_enabled()) {
>   		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
>   					      sizeof(void *),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL | __GFP_ZERO);

Alternatively, this call could just be changed to kcalloc().

Either way,

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

>   		if (!sd->sev_vmcbs)
>   			goto free_save_area;
>   	}
> 
