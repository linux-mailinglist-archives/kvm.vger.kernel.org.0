Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504B8355C7A
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242897AbhDFTm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:42:57 -0400
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:64352
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238002AbhDFTm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:42:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlQBfzDtfj57GaVNeJHnD+xnKbVN26IOC4bMd036L5kHkZMRXdicz9uCz/17Y8ysHjQwgD70PJ7p2BysTDCHU1nIiHQUe60RKykL+T9z7kNgD8dh37gjX2sual4Ppoe7I6mrk7mXXP7IeQQMIr53Mnma5KRBKkHQkxgtmgb3Z2bFfebgDoR09sKnameVzwOQTLgKCWX3meMYkVu96ICEiQHuFQOOcWEu/h4o+S3BMN7OyAiaEya+S6hBYzVEUpQ76JZ8jG75Kw+RA8L2hO4pzezttV+xCs5MDQ2vj5m4p5+rU8fwXSyoNtwEgcAHz8XSqFjvBrJUwHVxPvd31zfPog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcwgxqNalrusaHAQqVfDd49OWfNGuq99u5s6s5MPUUw=;
 b=mgoGPcjui+C0gC49kpPOCIxeIu6HJpaf6csTP2SR8ID/L3tSEcWFZO6qUIepi4/CKUJBb7V2+MbURXuzNvApfAgWWOvStMT6Q1/wOg6neXwNdzqWRv9erUSxoHWDkfGmzXJy9MX7H/d7F6+pQTWiqZeSkvFm/J1MahyOvAjWbnN0hLL+7dnmkEN3e37wXx+PJ0e/VSW7oZAsbPMUnD3e7ZkYlNVKh/ZZ/t/xjiIE+Po6kLH98jlqplQbt2gRnoyMC8QCKorLk0BEHpATYDQ5W02Bw/yt8fJ54HiUnOrPrNJtQ6OrAnLAeMAtUsGWkBK+a6dDVICIdX30l4T0zIC8GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcwgxqNalrusaHAQqVfDd49OWfNGuq99u5s6s5MPUUw=;
 b=0e6dC67RRzAKswTs0TSmRObkro2WpKUbFiOBmv7gTjGi03Ubpse7R+kZJ+RPRNXeIrTeYgxcsGfKAc6Faw3p9XjKcNAdwuhnWLDSfSVZXhq3FUQR4lXhHxQho18Qmxg5Lbfzwa31YiicC2dYybvsx808VVhhF/iOqftruNEwj0M=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1354.namprd12.prod.outlook.com (2603:10b6:3:7a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Tue, 6 Apr 2021 19:42:46 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:42:45 +0000
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the
 memory used for the GHCB
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <67f92f5c-780c-a4c6-241a-6771558e81a3@amd.com>
Date:   Tue, 6 Apr 2021 14:42:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:806:120::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0041.namprd04.prod.outlook.com (2603:10b6:806:120::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Tue, 6 Apr 2021 19:42:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63e5173e-ecd2-4041-61d6-08d8f934268e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB135465BE4101F08DEABE1499EC769@DM5PR12MB1354.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVTqV0iI362HWZjdG5YK1jx8YTM0jipQfKMJwtlfl6GByB5R/0EDuoRzzT6nbVUdzFRLIoFclcrSMc4Stz/M0JWdXkJhobSY5dRbfZz69VwZO5vrGP9Ygk2yj3BSVQPhcV7kkP5wM5PGI62tHSCU/3vL0BsbLk6d9NqqyjmCzbmhwdEMWO6Im4x1F+1a8BK4cGXFYEadMPbyCeTVqPagjWE/Z07Abd8ubYq8Kod2JkZ50dWtWiLHu8mROZ1IjXbosBgAiJszxo2z+09zrALTZ8sRIVFKasHhxi2YZpyu1iCdXnia9TJ8wampfb64BjjXV4jidzlFMkSraB1mOWxzd56t0CeeQ0TIkltL6junI6WwbPvh5167xtydRHFC3dboFu2pY+UI7OdyJggYbTEWgngboAYSf5HV1vi4noM3URR9N2VbHAeJejGHtsuMoFEoJ1VsXaWhTELbiW+8AGvvGHv12bOJPKFr1rPETgzL8XlPh559CfdFFV+57qJL6utGahli4oyt0spONIbYr2MRGV/+es84mSjR7iBKRkQBO0xcIH0Wes7zwwU2v/TX1pwG/RBPt0xNzN2lQCKdjSPjYCgv/SeCLYX35Oyp0rSYc9G+lt4RNDWFwfYSHK8ffA0LAhjY065PsnSkxa/4Hrr55Ly06RcR85w5owecMVPighSFndNGKEY2n653apvS20htF6GPc2Kxjl5eue3boxKTEYCHe5cFyE58Rjr2uJ48j68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(6486002)(4326008)(31686004)(15650500001)(8676002)(83380400001)(186003)(16526019)(26005)(31696002)(54906003)(36756003)(53546011)(6506007)(8936002)(86362001)(956004)(66476007)(66556008)(110136005)(66946007)(2616005)(478600001)(2906002)(5660300002)(38100700001)(316002)(7416002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L0RWZ2cwa2xOS1ZIMStIcHhmc1VqZ29ieVhtcmVaamhYUWdrbTM5K2s5c3I1?=
 =?utf-8?B?MEcvNW1hemN2bitoSWRjc08rRHZSejIvQTdGcVJkOElPMXY4SGQycHA2Ulhz?=
 =?utf-8?B?YWZPZVdqWjFvQ0ptSTZ3ZjdmdEx1WmZJdDFDdVc0bVpiVWoxYmR3eXdsS1ds?=
 =?utf-8?B?dlZObFZnTi8yTXI0YUwrR3pkZDFsTUI4V0lWekZkSkcwTG9YbU1aZElJUTU1?=
 =?utf-8?B?U2g2MWNqbGwwRnNKQ1lpdm1UdVJiZ2tCempPN1lmU0J3dmJhTFZJNFdNMVVJ?=
 =?utf-8?B?M21MQ0ZhTFRhWVBjVXpQdEx3UEx0dW05OEhCZDcxUVNNZVdsdnAvUW52WnVT?=
 =?utf-8?B?UGlHUjdGMHB0aUtsYk80NFphQ01STmFQNEpLL3VKV0E4akNVc2x4dC9pQmtn?=
 =?utf-8?B?eGg1LzlPcjVPUVh1SFBpNDVQOW1vS3NhaGI0dEFkKzNmZlQ1azRjSUkxSDhu?=
 =?utf-8?B?Y25xRy9qdXJEdDBkT0JYNDNmbkNBbHdyTDRyeWZqdGh0UUdsci80OVB5MTBQ?=
 =?utf-8?B?MUIxVFhxbFYrZkFmY3FpL09xT0JEa0NSRTMzQW5JK2d6NU9rY21UYjRHbEZ3?=
 =?utf-8?B?bXpCSXpkQ0phdzJnTjNkYUhWK2tHeTRHNWxlU2xqbU1DRk9lV0Qrb1ArR2R5?=
 =?utf-8?B?ZWM0VFFITCt5cmROeXV2WlVWbW1qa0UxMnBPdkkzWG56UVQrMnF0M1RwY2cy?=
 =?utf-8?B?R256c21aZzc4cld1T05EdUk3anhrMHNHVkQ1czZScW9PVktJOWk4M3MzMk83?=
 =?utf-8?B?UWdWaTByYmVRMnJUaytJaEcxVlR4RXZuK0swYXZtY3ZmbVptVWhVT3hEa1Zw?=
 =?utf-8?B?QkpYcnl4Rk51VEk5V1NSeGRGbEhkZUxjTWVlOUlEVjZNQ1RyekI3VkM2YXVU?=
 =?utf-8?B?ZDRnZU5DZTdGN29scDlIS0dYcmw2TTdNOVZzcU1YVVRvZ1FoY2tYS1Y0bC9R?=
 =?utf-8?B?cEo1dnA2OHRUcDIvUXdnV0JuN0NvZjhSMDhCTHM2bzZ6cGEwNTkwUmpld1Z2?=
 =?utf-8?B?R2xzODZKeFZOZWRQVDNSaGI3SWxmVVNlZnlvOTlzSHkvbHRnOEFNUlhZVGt2?=
 =?utf-8?B?a0dWcml6UnZrblJNUlo3bTdUS3JrSmVLdUVBdW1zeDFMTnE0R1ZOLzZiSkJm?=
 =?utf-8?B?aVBiTzJEc1ZsQ0hqdnkrOHpnTitPby9DZVY2MUpVclVPYk1TU1lYWjJ2TUxm?=
 =?utf-8?B?YzkydnJCVXdYTnJXUm1qTmwrcGVKeGRpKzBzR0tWR2ZCNFBmcDZmcUljOG5h?=
 =?utf-8?B?UyttYjY0RmVLVjVLUlA4aUJWSm1uYlBaWGZJOEJtWEtrVXZmR0dyZ3AyUzhz?=
 =?utf-8?B?bkV4RXFlZ0wySmtjU05ZUlJYN1ZybjNaRlpIditFdWErODNWRzE2Y3VJL0tu?=
 =?utf-8?B?eUxmQTV3akxnSVppRjVlV2Z0RFlJd25UTEllM3NVc0hvMUtENy9PbnRwSmli?=
 =?utf-8?B?SjUzWXBKWVV1WGU0Zm5jRksweWtDdzRZYlhGVTNRZkR4ZlI5eEVERmtqLzNI?=
 =?utf-8?B?a0YvRTBSMjRHTm5vdDZkR1lLOE04V3lGbE40WStabFhtZ1dGWnhuU3N5c3ZR?=
 =?utf-8?B?aTQrSkZZR21hQVl1LzlveXNUeGN1S1VIVGpla0RVUDVVb29iWFFHaC93R0E1?=
 =?utf-8?B?eUFmM1NNanJUd2JZNmZtZ0U2T2l2bUE4RFpmLzcxU01nTzFNdUFLaGxscks5?=
 =?utf-8?B?bGkzNmQ5Rm82N1hrbVgrL1BjbDdPcHYrR0VNdm1YSHZNbTJ6bXJ4azdqT1dX?=
 =?utf-8?Q?eyoRq9toGqTfKgBscddlBihjp6+P0UM7E5yc3p4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e5173e-ecd2-4041-61d6-08d8f934268e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:42:45.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ2lG9Q8WQDzRffaJ51kuab0k/NYoPpW9qqf0iftb+6v+xcBrZfmGnrsyhmp86mK+gxNKjqLREHZ5BuBSyYo6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1354
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/21 10:47 AM, Brijesh Singh wrote:
> 
> On 4/6/21 5:33 AM, Borislav Petkov wrote:
>> On Wed, Mar 24, 2021 at 11:44:17AM -0500, Brijesh Singh wrote:
>>

...

>> *Any* and *all* page state changes which fail immediately terminate a
>> guest? Why?
> 
> 
> The hypervisor uses the RMPUPDATE instruction to add the pages in the
> RMP table. If RMPUPDATE fails, then it will be communicated to the
> guest. Now its up to guest on what it wants to do. I choose to terminate
> because guest can't resolve this step on its own. It needs help from the
> hypervisor and hypervisor has bailed on it. Depending on request type,
> the next step will either fail or we go into infinite loop. Lets
> consider an example:
> 
> 1. Guest asked to add a page as a private in RMP table.
> 
> 2. Hypervisor fail to add the page in the RMP table and return an error.
> 
> 3. Guest ignored the error code and moved to the step to validate the page.
> 
> 4. The page validation instruction expects that page must be added in
> the RMP table. In our case the page was not added in the RMP table. So
> it will cause #NPF (rmp violation).
> 
> 5. On #NPF, hypervisor will try adding the page as private but it will
> fail (same as #2). This will keep repeating and guest will not make any
> progress.
> 
> I choose to return "void" from page_state_change() because caller can't
> do anything with error code. Some of the failure may have security
> implication, terminate the guest  as soon as we detect an error condition.
> 
> 
>> Then, how do we communicate this to the guest user what has happened?
>>
>> Can GHCB_SEV_ES_REASON_GENERAL_REQUEST be something special like
>>
>> GHCB_SEV_ES_REASON_PSC_FAILURE
>>
>> or so, so that users know what has happened?
> 
> 
> Current GHCB does not have special code for this. But I think Linux
> guest can define a special code which can be used to indicate the
> termination reason.
> 
> Tom,
> 
> Any other suggestion ?

The GHCB spec only defines the "0" reason code set. We could provide Linux
it's own reason code set with some more specific reason codes for
failures, if that is needed.

Thanks,
Tom

> 
> 
>>
