Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936C1495032
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 15:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345512AbiATOdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 09:33:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17078 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236043AbiATOdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 09:33:39 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KDjZB8001468;
        Thu, 20 Jan 2022 14:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Mgw0xUSgZOuy+hgwbz1sjphnXLnBpDB+PUPuOBsX870=;
 b=bAal7bdS7S6tqgqbPze1nefaG4IA2sUsrXazi7ryl1Npicw6BXXGi4Sqv0/BYz4I3az1
 +1yZno2pbqLPJiAWLdr3T4JMoRuGNnFk31RCdSZhYRKK0D5hlHnPzXhmqAO47C7FSMul
 Jg+RZF3985k20VXcHPJjwfPJ9WIhiFLl9kcqMGMHaaTJjTvNcRCDn0y3kUXsAOBfBDoz
 5GyeVLkLPLYmm+M70896/cJZEdInAkSDUhXaUi2D68N/NlXFVlfAsYl4XTc71iLYADiL
 2crarL17QBOpWlld2o6Xgo3JTKo8gUh28zkufVxeSYDf86Re+uO6xQuCgwX32CwY+98Q gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f8bdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:33:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KEV0In042855;
        Thu, 20 Jan 2022 14:33:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3dpvj261d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:33:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEWHsw3QXBfUVmjhQc1wAuBgeERxQ8WXbNSLQEsSvUMFceo2CaMSmhT3PXGVLd35xh6dRYkSOiTrh88gjtJQB6e9GBMz9flhgwfa9DDZSB1tfz8oSiq4IZC/tERrWRAqLBsP4esqw3FGb/wErP3p34HpSYr4Mg9OwWvUzwXt/95lq9n8OB1lIGBavBqVjt/3rP+q8UBP06ip7PogijdkmKXlRSjk4aCrUUCy1VZ/enZek0LfGNOUzbTJ8xhJRGbW23SWi42j4nRGrC72ahnK+oEmfueR4XhNui7iKxUZYL2IE8qhFr/aIHA3e/RFcnZ48nugy0N0mVIr/3cJ3mh59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mgw0xUSgZOuy+hgwbz1sjphnXLnBpDB+PUPuOBsX870=;
 b=GDKwr/+JdmuTVxKXRHihacJJLiEckz/xPEaFVN5vOXXj3TRrqzge5WzdnEdDnU9eMfved6TpnZUk/7Mhh1+7dFS6TCisJmwKCS7+FpTpM5k9SfoLFfW+9w09dKJw8PF9qDIkloxFYODCgMm2yW78v+hZG1pUCTdtXRt08QoUQmolR3o+LJ/1f18fRfpfHGNgPNkR3fGQCgNdxxZMXTCKPVuFjZRZKE4m6BT7ST7XA93/8QzQH93u5JTrQnbM9DdnAe0O+/1tvrssT/jkDZcTix6VHb+uXdjsi+o1SwdJ6o2/BvWveEkvFJNCKkq+AdWU4KYmnKCu0vCa9vitJxswRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mgw0xUSgZOuy+hgwbz1sjphnXLnBpDB+PUPuOBsX870=;
 b=kMXPYYICEJZ6dkhljGIAWr19tEBQNApi5PaQVHPJMzfd6LDC4yY9+Fw/XT7W28LkfmBeeVZr14dXWLLwjTKNmx3nI8KarmK6f885CMdTiNa7B61rBDu3tDg3vJ3LDBXqJOldEwNkdceUOBe7sRvOb1Qn6hMBCPofl9MjYd5Cy5E=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Thu, 20 Jan
 2022 14:32:58 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 14:32:58 +0000
Message-ID: <f2836ee9-6261-a86a-b821-c9e3f75b9273@oracle.com>
Date:   Thu, 20 Jan 2022 14:32:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4/9] KVM: SVM: Explicitly require DECODEASSISTS to enable
 SEV support
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-5-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0380.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::32) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90387c7e-2373-4583-f890-08d9dc21c0fb
X-MS-TrafficTypeDiagnostic: BYAPR10MB3288:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB328888D9B740B311DFF050EDE85A9@BYAPR10MB3288.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: urLee7a1vQgCwCpbgnIv5xBr5V3+vY3ebeJJv1jeOawx9bSXeXLdOPRBzuDBZI24LQZ+WASo/Bi7sTfK0Rpl4HHQhKCVVawnvMpo9Zl4ReRkdCuaoAEkfzpUPVpspWEUrc8H3hwnjkKK2ozSspydRg1Om9rsyUXLAo7HCZX/TdwyMrqZy2w+TqBI4yejRFr4bXhUE1V2g6zNHDF8oyJz/YAhNkWK0XjQXNr+yMprig2Uve/xwptd095LQw+ldH5nuJbKqIIAEk76Kc9umscehwKeTsQ3C0rdy0LUsjrS7bmxTzXOPx9bEtAZOGuUKzEH8XSsGDNfbw00h2CuXIbfL3WOckpLyAlrx9rLbWBOopGBBuYY9q/rMlaKW0wtni1sSX098Wlv4M1m/SxVK/HKiAFVnKEodsM/vKoTzh6JoJm9MuRnoufABidbmdYv2KM5QdImbK1ak+tMikhXINSzUdQ3GBqVPwN1C1kYqcrUwBVPkDyd9n7nnsj7jVsgp/2Er8z9//EOTURWLd1tIElakLPiHiNpShoIVqJLJ/C7aDCJZJtBj6/L4XQt02cwu3lB0Zw7IEkng/sk9+0EaKPY2sM5ltr7IriNEi/mAscpMptCXeyKPo2ef9PTN0xwa11qxDoixcgkwpH2qczZVDGZo8Vy6wC1VY9Ys2lPu1AJqR6y7qlb7cgohSJauH9hHmYZGm+TczhuIWlZZtp4ZxidgMQj7n8Reo+LUzyHhRUqkTKhgv9wdf/TdD/cB2C9jZ/I7sj6GU49pAchdZwNFpOD5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(66556008)(6506007)(86362001)(6666004)(4326008)(38350700002)(31696002)(66476007)(107886003)(316002)(2906002)(5660300002)(54906003)(31686004)(110136005)(6512007)(26005)(52116002)(186003)(83380400001)(66946007)(53546011)(8676002)(7416002)(38100700002)(8936002)(44832011)(2616005)(508600001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UnhjWWd0Yk5rckk0Uk1GdGF4TzZpTzZ3b3BISWQzclpGcDFYV1RZZjRnWTN6?=
 =?utf-8?B?Q2pVc3A0clFmZEFCVkVrUzROWlFUR0ZFb1pBWGd2ME5TRXMyclduYm1GVnIv?=
 =?utf-8?B?UXBVV0FJRGhVbWdnd0wycVo0aStKVGg0OWpvSjJxTFhRQW1WakpYRDNNWC8z?=
 =?utf-8?B?VWY0RXVWeE1xSC9KSlpOZld5N1hHa2xGVDJVWVp4YWRXVHNBM0hEM1BkVXg2?=
 =?utf-8?B?WmswY1c2K25hcDIxTUtITksxWDJOZFlyd2JjRnc1Snh5ajJaajRyaTJ1Q3lj?=
 =?utf-8?B?TkdOQzBjdHp0SEpiZ2U0anRXaDl1UHlmNUFGc3dmNXczOXY3cU5iMmcrQTFo?=
 =?utf-8?B?djFFcEtEVUhkczNaTUw2TlZ1SVRzYndVRnVMRzBFQW5nM09MbkpwRFBHTUU5?=
 =?utf-8?B?bkxERWN0V3hTTVMva1ZheEJzZnlvVG1pOVNQWmtiSXJLelBraHV3dXppaVNZ?=
 =?utf-8?B?Y3NsRUIwQjNFb3psVy9mSG9IZForblBCcUJXMnZLWnMvV3k5VmZQRDQ1bTFS?=
 =?utf-8?B?QSt0a1lYZ1h4Zmt1bG8yeGVWN2RLK21SZmdrTzdveStHN0hLMEZJY2c2U2hX?=
 =?utf-8?B?YjJaOGdzeCtweU0rTkJvU1dmd05MdkNGczRXSnZ4eEh4WFIySm9FTEY0Y0dp?=
 =?utf-8?B?TzB4Vk10UVZXMEd4bGN0NVdqSFFneGNDVEZ2QkVJa1RNcFNFNUFEdlpnWVpr?=
 =?utf-8?B?ZXFHaE9Jc09qeVdXVzkvQ0hzbHRaOS9BcHpHSVBDMzBjVUZQN1FZY2hoWG5W?=
 =?utf-8?B?R2JEckZ5OVVibnhTY0liZ3F0QVdKcllIcUl3LzN3MjZqR1FOZE9PNVpsRkdr?=
 =?utf-8?B?cm1ZNWlWRHFDcnJMWExBRkJRRUc4MTE4WUlkeDFUWUNDOWNGWTQ5cDdVRk4w?=
 =?utf-8?B?dWtnelcyR2FSMFcyclZTV1gyL3dXRWhsZ3NyNW4zMUREdGEzRERXMzlYR21E?=
 =?utf-8?B?dTJkQThueEMvR0xEV01JVGtlQ0dCVmE4bVpsOW1kN1VObTA3ZmRrd2U4VXBu?=
 =?utf-8?B?SWhmTURkaXdjc2gvZHJMVmJ0bEpmbEJoNUxZdmR6bHZmNHAzaFRnQjI0YXVh?=
 =?utf-8?B?Qkw3SjJMQTZ5TkFjRUhqM1oyaHFQU2FCcDR3NG01Mjg2UkU5ekdBR0NHUDQ5?=
 =?utf-8?B?ZjNvLzNwQ1U5WWxieGdQaVJ3RW9wNHRkNlNDTmJMQ3dWNXI0enl5NWlJcUd5?=
 =?utf-8?B?VURick51WDY1NzBlSEdyTWVrbjc5L3dFZXgzY3lpZEltRWJLd1VLNytQZVQ2?=
 =?utf-8?B?L0xlTDFFU09KTlE5N1luWWs1NG5zSnZOZHo0ZVM2aE02MVc0NklMaGIraEhU?=
 =?utf-8?B?RzVidUZRQmVYc0YyQ0pXdm5HR2NsWnpmdzVnRzVRWTJuT1Z3NUpGT1VXNkt1?=
 =?utf-8?B?MHFteFd5cU9rNFVqSWx1RjhvK3dGL0pEZU9wYTlhQXhNbjhWbVM3RERoM0dJ?=
 =?utf-8?B?Q0dkRUh2WWpOVFNxY25JcStkNHV5OWl5Z0pYVk5QZ3NEekNrMUhTWHFMVGNQ?=
 =?utf-8?B?Y0k2SWo0Y050MFJwdXMxRnFVVm1UdXJCTTl4ejVwMzgvaEFOUWE0N3AxaFE5?=
 =?utf-8?B?dUYwSjFsakplTk1YTzh6clZLTmRDUXdxWmk3S3ZqaGoyd1Y2U3E1RWlGaFlP?=
 =?utf-8?B?enpIaTFDVnZPWCtaYWlWcjdxM01nRzlWZ0J0TVlGYllZRkxqWERCTzMzZyt2?=
 =?utf-8?B?SWdnMDhnQmNCZytNTWJNUHRKY2VvT3VIdVN4MXJRQ3N0Q1BFR3JPYlFxaDU3?=
 =?utf-8?B?ZHZXaUpZUml6bXptQXFtRXozUW5ZUEF4WVQwNmt0bXozdzFOMlhCY05aam0v?=
 =?utf-8?B?YmpvOVRIemN4YlRvWlFIZjdQSURNeGgxaC91KzBYeGhIUkVCTTMxZjE1V0JH?=
 =?utf-8?B?d2lJbms0ZDI0MmZsR2VQc0xWRUxLWjdhc2tkMHVOWlJkME8rR0ZaTGMwaDEx?=
 =?utf-8?B?cTE0emREclhPL1UxQmNEcytTdEhpWXBLaUhLVFhmc2h1Z2RCTVpBbmhmRXNZ?=
 =?utf-8?B?bkZYYUFWMURuOWpHd2JGeUdVT3daaUVJOU91UVZEaWFSbUVTNEF0Y0dXdW9y?=
 =?utf-8?B?UCtwQldTSkoyaWo1T2ZSeTRrYkpRL21ZTUc3YmFoK1NRcnVLdnVEcXdqTllB?=
 =?utf-8?B?b2psRklWYnp1ajUwTlhqcjVTMHJXS01ONS9rck55cXQ0cndRRlpTZkROdVlP?=
 =?utf-8?Q?dgI54OmxQ6eMv83NFnFrY4o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90387c7e-2373-4583-f890-08d9dc21c0fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 14:32:58.1749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AkMu0tdbizMQ1ROWtHoNKODtapaB6Ot6RTokQD3lJEqqMtNlKOHXYOlKNJiyqWmomYc3XNHynkpFguqC79y45w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3288
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201200076
X-Proofpoint-GUID: oN8iLpJQPa6IRB_KVczr8BeRqbaTZ17z
X-Proofpoint-ORIG-GUID: oN8iLpJQPa6IRB_KVczr8BeRqbaTZ17z
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Add a sanity check on DECODEASSIST being support if SEV is supported, as

"DECODEASSISTS being supported" or "DECODEASSISTS support"

> KVM cannot read guest private memory and thus relies on the CPU to
> provide the instruction byte stream on #NPF for emulation.  The intent of
> the check is to document the dependency, it should never fail in practice
> as producing hardware that supports SEV but not DECODEASSISTS would be
> non-sensical.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/kvm/svm/sev.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6a22798eaaee..17b53457d866 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2100,8 +2100,13 @@ void __init sev_hardware_setup(void)
>   	if (!sev_enabled || !npt_enabled)
>   		goto out;
>   
> -	/* Does the CPU support SEV? */
> -	if (!boot_cpu_has(X86_FEATURE_SEV))
> +	/*
> +	 * SEV must obviously be supported in hardware.  Sanity check that the
> +	 * CPU supports decode assists, which is mandatory for SEV guests to
> +	 * support instruction emulation.
> +	 */
> +	if (!boot_cpu_has(X86_FEATURE_SEV) ||
> +	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
>   		goto out;
>   
>   	/* Retrieve SEV CPUID information */

