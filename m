Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C02DA206
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 21:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503257AbgLNUvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 15:51:48 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:54465
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503159AbgLNUvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 15:51:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbsgUXZ/WPmdQ8z2H9aV/otFo9b2c/LvnJnjJTJm3gIkbK9c2a+WMplOAHaqimprH/joOICk8eRfNRIfYWS6z5lx7XyoiR9ZVPD5FmKc/MXlQmA+ZHp+P9O8XQyQEG4liP3/Fs0zo/pOzyuFJ20+BSlX6LPZ/gWoGDU08ihnpl+Su6VQLlNtXuPgioGiBZsSt1fujluElNq/vTQz2m2kNPLcP7Lwd0x4dcKJC9y1T1X2B7P6jicm87OGKwFOn9c+uZLHee2WusXm2vCAgStVc2qAU+QggxhwikH+uuHD5tqi5/F0OJSjMzhBwTdS1JzKjgZoiXu76jx739UDt4CpzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQIYMwfdg3LharXlqu9bW+nPhA/Uvv7OCqcg3v8IYxM=;
 b=OPBknp60oVP0Q8JL1WjKQh6hIQ3KC/Vl/5YLfxRXo6ARUOhGvxxKs2wXMx3Hn5YD+J6hAA3ReUCF4TqQHTBHukHAR6HB8h1rrHM3l7hj5XK3fhHrr/u/UV99m3kHnmHDjjCUVdPKPuEjkVq/WNLhXfTJxhrTzqGuOE9dhMPL3AKxywkbwtsHL5Wydf+KouLR+cimquCE8yVavhq5gyC/MLdvd5EWH8VdXSUCkpC4t8aNg8uP/JTRuD7CvCpHnLjnqZk41c+N2MBND/RJHCoZUdgeWX1uZUdXJNl9s3kAPHjzIaC/v+soWA9a49jTSDqAi1PkkSzns9CFUAOvOgeh/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQIYMwfdg3LharXlqu9bW+nPhA/Uvv7OCqcg3v8IYxM=;
 b=sKz7b1jmUC60c/5/v/m/Q/Pd/sPmN+MZgX+8Agvj0ojwIQY3tV3qna0lFqYJhKt2NxiOR+2LIR/TvJ5o2d9RULmZBSu6GEPAQueC2SBNuVshhrMbCsX8COpw9IhTnksmwd3wd7Xapwt4J0y709qSNz/Cfr2aS7e1N+oALXgOdVo=
Authentication-Results: amazon.com; dkim=none (message not signed)
 header.d=none;amazon.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1164.namprd12.prod.outlook.com (2603:10b6:3:77::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.17; Mon, 14 Dec 2020 20:50:45 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 20:50:45 +0000
Subject: Re: [PATCH 1/3] KVM: x86: remove bogus #GP injection
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>
References: <20201214183250.1034541-1-pbonzini@redhat.com>
 <20201214183250.1034541-2-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <22ca8895-31cc-b851-b3ae-f6362bc78978@amd.com>
Date:   Mon, 14 Dec 2020 14:50:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201214183250.1034541-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:610:52::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR04CA0018.namprd04.prod.outlook.com (2603:10b6:610:52::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 20:50:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8998b32-2b0e-41fd-9e78-08d8a071ee19
X-MS-TrafficTypeDiagnostic: DM5PR12MB1164:
X-Microsoft-Antispam-PRVS: <DM5PR12MB11643E829A36033BDB359B5EECC70@DM5PR12MB1164.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g38CNp9fFbPM2E925KwzvAscYVMzawXN4OewypdUfxXFZnEqZl1saMh22+fnSYFAObmyLZOKCpy5b6mJ8+Fn5Vby50nF70/b9GZWDneAKLbL4bOh/iurDR1PFsYUs5JVm/pMy0PkCpy4Je841OUDHrJU4Isb84UBS/jzOs/LCSBj6sj5sKZ7Tn6IONM/EUnKYPwqSb61gdQpWVYUWYU0pzR2qrigm65yOodoyD6TPEE3DJu8Ur86TNkwYTEOkQJaUPkBKK0T+8ljY9KL6hgWh+n9GmdEi+axRDjMuuv/IkWM3cbhtfDR+i64vNkQAyYzr62m4RGk7/Q8/jKpRPTKNrNxpfBAx+zZVp8MR7MKmx1DQUtw3Vw0zyHGZTgBvZnm1rsgPrQLE79l4XgnPKh7VDSQsKMGL7GGkac2QfdQCw/Mg4u/k8xwGrWsZ4zGVh57
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(508600001)(53546011)(4744005)(16576012)(8936002)(4326008)(956004)(66946007)(8676002)(26005)(5660300002)(52116002)(2906002)(86362001)(16526019)(83380400001)(186003)(36756003)(2616005)(31686004)(34490700003)(31696002)(66556008)(54906003)(6486002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MWo1KzBtVnhPZHBKdmFOcm5RMEZnT3pWbWt0ZVBzSDZDckZBNUtuTDJ0d0pQ?=
 =?utf-8?B?V2MwbmVYbGdLa2RUb1ZrM0czM2pzckd4K3lOeHZSdHFpdWxHTVlkL0ZnNGZI?=
 =?utf-8?B?UkZscmk4N0tOYUh4RkdSN1ZIZFRObzU2aDF3RndwN2NvUkhqUUxqK1Nkam8v?=
 =?utf-8?B?VU1HZHMrRjFSdlZHS1Q1U0hzMXhMbEJkMWlkUFhmNWFBSnFyYlowd1RmRUhU?=
 =?utf-8?B?Z2cyWjU4T1JjQ2ViVXlINW1GanV6UFA2eUxPWkpGZzlpNGRYTVVTMm9PTGZr?=
 =?utf-8?B?cWlRdytKVlQvOG9TelBLaU4yYld3TjhXRHVJZ2FsYWlCVXNHc0VVNGFlZC9y?=
 =?utf-8?B?Y0xLbFNoT2x4L3pNY2ZZSHdEYTdUNm5zQnlpVnl0MGlCekREdEZ2V3FYODhl?=
 =?utf-8?B?d05FRUIrdTJWeHhLVXhmWjhGYWJHeXp3YVlBYVpodEROMFJWQnpsWXFjQzlZ?=
 =?utf-8?B?MmVGekxCVlhoVDAxdE11THk5ZUlOT0FDSFhsSnprZ0lEL1pkdGg0RmcyM1dZ?=
 =?utf-8?B?QzlMRmoyS1FZOHlBMzVIWnR3aGYzalRpQS9GZ0U1dHpxMkZqN1Q0UUdXc2kv?=
 =?utf-8?B?bjhaRWxjYUg3VmtWTHkvYlM4Y2J5Nml5cDhxeHJ0akNUSWlJa09Rd0MwZThu?=
 =?utf-8?B?clhJbGtlR3ZMSk0wYW1FOVJ5RXNuUDRqYU1RdUtidjlNcE1Udm80dkUvanpK?=
 =?utf-8?B?VTNzN1kzclhSRFN0YkhHMmUrd2g2cGY4Tk9heWhoblVWWS9XV2N4M3pYRC8r?=
 =?utf-8?B?N0l0SFhVVWMyLzBqU29jZEMwZno3YXJ0TXBnaDE3bzdVaWdqd2FldUxWNGJL?=
 =?utf-8?B?clhUbVhHVUJLb1dSYkYyOFZwOGFSOVFmSmZEenNyTzVFYnQ5cGZIeDhtZTZQ?=
 =?utf-8?B?T3JicEh4blEzbUswRVFmSVV1WnhpTktEMlpGdW9FTHh6RGNYMUJpOFRhejBT?=
 =?utf-8?B?ZjZNQzlIVHRhTUcyeE9wczRIb29NMVgvU010S2VkL2xRdHBIWXBSbGsyS1hx?=
 =?utf-8?B?ajNxdUFid2lBWi9HRjZMZ2hDczZkdkRjV09HaEl3QkNRcWJuTVNKY2g3dWUw?=
 =?utf-8?B?R09BdU50TUs2TVpIc3BZNGpMN2kyRG5lQjcvenNWbEdyUEtwUEtJV2NoZkdh?=
 =?utf-8?B?TW04OHlHVjhsYnpsZXNPZ2YzNXpVeG9wMFNtYWF3K1Qza0Q0UjVYTk1zVGVo?=
 =?utf-8?B?SzlaUWV1dVZWUjBTb3VIMmc0cGN2RkdWTjBscU55TUNLWmxCbVl0UGNMYTJU?=
 =?utf-8?B?bXdUZkdxcjN1aENVcGdpdDdtY1ptT2xUcTB3S1JmSkw0S0VQWFlBQ1hydXY4?=
 =?utf-8?Q?8BoheyGRrA5NXJM8KcLc2a3EkXwNnGVTVN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 20:50:45.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: b8998b32-2b0e-41fd-9e78-08d8a071ee19
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lP78WeUsYudD7zkEm8Oxk6MEMyRey4FCRkQB2XNI4P7r0/7ridyab67Hf0b2ijhWlYj2RtEs/y1USeTp3lwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1164
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:32 PM, Paolo Bonzini wrote:
> There is no need to inject a #GP from kvm_mtrr_set_msr, kvm_emulate_wrmsr will
> handle it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/mtrr.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 7f0059aa30e1..f472fdb6ae7e 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -84,12 +84,8 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  	} else
>  		/* MTRR mask */
>  		mask |= 0x7ff;
> -	if (data & mask) {
> -		kvm_inject_gp(vcpu, 0);
> -		return false;
> -	}
>  
> -	return true;
> +	return (data & mask) == 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mtrr_valid);
>  
> 
