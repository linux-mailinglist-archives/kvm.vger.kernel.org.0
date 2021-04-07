Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C8F3573C8
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355038AbhDGSAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:00:46 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:26855
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355033AbhDGSAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 14:00:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeFG1qBCPE4b2oLypR0LcpbtA5XoYlRip7XtmofW0eF2jmnt8hm7iLtWrXXuCDfskhT6AZ/VGptRcEPACiG7+Jba8moKz6A2poML+HwImEOsk1l7LaxSdxGofAFW33dEDRrBBs9sfSsQ3ML3HbA+L28glsSJEOAl35t4Bbn1QHSgKmOPCSgKd2QbIeqr0ADNM6zGgVudmrvuazU+2V+K4X+EHdjPg0njnfmsf+06vNotxXA1ff52aWsBY1+cvLYsoVbSTvUIAz1JaL6yDgYrkMMq3fKjXcc40eRKQYzn5fhOACKT2fZ2FCOhcFCJW/mur73L9JupMPZ+DzQkTt64fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpQrPQpZPLHM5SVygXJdCXrM7T8pbLhdFXgSoubrwCI=;
 b=YJ0wvsNpoQP8HWP0M0f1uiFgcn99i2RK1mXyX8bR/iGKhAnCoaDOBrozngenPJ8EUZSDeG1SADJEW7HsakkM74QEUnFLtrxFLNEkbvomlcOQyBqmsdaJnE+9kTsm+KrDecQIuipmpU9+XmuDWrAwbiu+DJ/1+mCpqeOU2dUUGDaUFkh1i8AsBwB6/9bOrFUTXqdna3tCp+RFGL3ney13Tgu/H5ZGZ9x7ZStgNiGKLZmY9X8CBiEKDi6lzdSLcgIPC5V09toh6RAChY/9b2YEYZeUzWHOEHAI2IV7lUHvJLZBUf656rgCbbeu/HvcTSSTcuk8Qk1IJYMNHmXao0e6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpQrPQpZPLHM5SVygXJdCXrM7T8pbLhdFXgSoubrwCI=;
 b=eWuWy03Wjp6bko2YdVd5oUO8YOhttw0i6s9+hvXzAlJtlhiHXGR73AxT3rto0FLwHet7aBkdJ4HgBhz8HoVvJoZgeYvPp2sxccGrKpeuAUDYG7iqHiW4nzt0yj8LVOHpGOmsifDzx+04+wISjDkRlW0jb31Vxpr02q3zvuw6qKw=
Authentication-Results: csgroup.eu; dkim=none (message not signed)
 header.d=none;csgroup.eu; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4959.namprd12.prod.outlook.com (2603:10b6:5:208::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Wed, 7 Apr 2021 18:00:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Wed, 7 Apr 2021
 18:00:29 +0000
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3d4ae355-1fc9-4333-643f-f163d32fbe17@amd.com>
Date:   Wed, 7 Apr 2021 13:00:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR2101CA0014.namprd21.prod.outlook.com
 (2603:10b6:805:106::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR2101CA0014.namprd21.prod.outlook.com (2603:10b6:805:106::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.3 via Frontend Transport; Wed, 7 Apr 2021 18:00:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7edf2fa1-aa98-435d-9d91-08d8f9ef07bd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4959:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4959137FFC31675997B05B2BEC759@DM6PR12MB4959.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:24;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLFrDNoIcTGpi5336dthtea37JFqmAMVIHiGjh7HHOV++IQNV939ldCXbs1q9lM8Sb9Xt0UTywavwToxnNsj43R6wWGNDMJYirbpZ7gT8m6z4jyGy5ErrINS1Vd/iIH3C79VJ5IIWXvyJtaBEQBd4OycDkdIIIzf+Ks/5BxnpObostu0hQbc7pBqlz2yum9buS9m+1qH9gPuZnbKBK75yIyAbsj3YTrpXZzqORYRT7KHtyqXFoMyWGGql82kkcD9HykrhHDwEpqzzaolr5xTmClGQdYvb6xanN+EpssYYldgLeeuFJ67OU0r2d7rfd8vDYOp07qcmiCaoy1sxMEubnO9NZVj3w2XB5g0QL3qwCYopBjd4JvIRP2qJvMuuYdZleKa0QwSSOdVsMBYjpZxqwEWV542MmoBZ0n0al3d8J8HO62L5HL5Vgi9VrfeDgpVbZyHhNHTs/nGpytZXm0iL5Z2+rwnLayxscatXCy273pX7Oz4jtZcU14b7WxhRiVKjIbMJtTP9g140f41q5w6DkznVDfCXXnMiCP3Ln0rQrvRvaM+R4WE6GaliJvsivxGW1pXuKEAQ695298sM49EozUsoCtgYYsfP8WYDAMrZ1zli3h+LgegP4d20S3Ckk3D347GCdGrVQNcTdrT1OttLzxgpywnO88DhncGn8R2CkOKhEZMD+pRHYYeCAO0WjR5zc7k4uiOJ4wE2zNiz/MfTzy7WPk1kq1+gwHw+zVki24sPvVtmCdNE892BHCZgY956Y1Av7stopNdfrqAFKQEtvyNVn+z0+TE3Dgg7MLMP3/8XtsIdRoI87z8XC8AC/dP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(6506007)(6512007)(8936002)(6486002)(66556008)(4326008)(31686004)(66946007)(38100700001)(966005)(66476007)(86362001)(53546011)(31696002)(7416002)(8676002)(83380400001)(6636002)(110136005)(54906003)(16526019)(186003)(2616005)(36756003)(45080400002)(316002)(956004)(2906002)(478600001)(26005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OUV4ZnNEZkhZNndVS1lHQVJ3N2tXQ1dtWUtIV0NraG5QVEZoL0hMek1DUkxn?=
 =?utf-8?B?Y211SG5TbnlVM0p1eXpsMkEzSG1ZQUNEYXdKTDdaQzJrMVZPaExiK1FIbDJw?=
 =?utf-8?B?V3RlN01HeG51YkovZWlLdVRjMm4wRm5BcHd1cFZIem5nZlBaTnhCNHVZRGlR?=
 =?utf-8?B?RXR0QTNaV3cxS2kwYWs5TEtQT0pPSGlYbm1oMEMyTUVmSTl2QytUM242ZUl5?=
 =?utf-8?B?UFAwVXdubWhXbGNXSEpOcCtXWW5PS3hlMUplV0YwRThqbGRQaDBSN2FWNHg3?=
 =?utf-8?B?TytmazJZZktEOGNUc3NBU0tUSWFrcU02M2NwRzVJZlBRUFBrOU9qUWt1USti?=
 =?utf-8?B?OWs2WUVCWG50ZnJkQzEzTWFjSkFzOTl3TGZXOGNpU2todnZyd3FqUVVIb3hC?=
 =?utf-8?B?SDNQQmFFOXpBaU04YWZJSVcxNzUyY0FaZVVrKzNJNlJpckVNOUxZdVZUTzVj?=
 =?utf-8?B?ZVFKV3ovN0VIM2RTMy8vYzFyc21UM3YxQkx0aS9pVUhkVHJFcjhlWWN5SFpY?=
 =?utf-8?B?MnVMKzFrSVF5aXk1WUp5Q0VQL3Nsb3BZVE11VE1FOWxBRHE4Mjd0YWgxQVB0?=
 =?utf-8?B?MjRXam8zZXExU3d0QVN2NVBvNGdDNzNpWjhUOEJIWEUrVnIxZG1jNk5VZk4y?=
 =?utf-8?B?TlJWeGF2L2tDa0VtOWV4UWlZeEhaWWFCamMwdE5ZWkZkcm9FN1R0UGxUaTIx?=
 =?utf-8?B?WTNZQjBDTFJQT0dKMCs4VkxtRFZZeVNDcjRjYUVZNHNreU9NMkJ0LzdlL0Vi?=
 =?utf-8?B?enVBOHd3bGh1MHdJK2ZvUFlqUUx6V3B2VUFUd1Z6amt0NS9BRjBqNFl6V0xo?=
 =?utf-8?B?SVIzSHc2dE1TeEVBaFFkYmhUY0c3RlZJT1YwQTN1b1lQc0hJU0haTjNmWENz?=
 =?utf-8?B?aFczcTVzQmtjZWtKS0dsY2gvZE9lRUNSZmQ1dUY0NXlMdmp1YWtNbURPQkNI?=
 =?utf-8?B?Y2pMRnAzc2RHSTNXa2VleEdXWXQ4YVZ5QkUrZ3RIYkYrbmszNnpZSkxienNz?=
 =?utf-8?B?cGVMSHlMd0Q5cE9CRkdUd3B6Mkk3UXZzeEN4OEFrK3M1bTJLNjM5UVhoeDZN?=
 =?utf-8?B?SWx4S1lReklaY3RreEFWdmkrNXM1a2ZpRmZpbDlqRDhQcnJnUy96YWM1ZDNl?=
 =?utf-8?B?UzFkK3A0YVlYT1ozQ0hmWE5CYzVwTk5MeWFvQTcvcDB0VG90dm94NjBuVzQv?=
 =?utf-8?B?RTdrOExwRXBPcEQ1UHZ0bzFEU1lPeEI4VFpqMURQQUpkdkFjNCszT05mS2lH?=
 =?utf-8?B?MHVsb2xQMVBQSSs0dW1kU2tZTnBLWEN3Tlpna25hOG4zc3d4dVR2YzBISTNF?=
 =?utf-8?B?eDd3a2RkQWVwRldGcStyai9YTno3RU9WeGxobUllQm1PRlJjc29uTTNJVlU0?=
 =?utf-8?B?Zmt0bnRtRGhVdVpSLzdZUkhCUHZUYng4TzVLdTg2YlFoYzJoM05hYnRWWUJH?=
 =?utf-8?B?VGVKbXAzc2RCRjZ2enIvcFpydXJZc2FzK1R5cDFBUDVrYTUzbXFwMUxsVktL?=
 =?utf-8?B?bWhRbDNWU0t2QWRDV21VaHVlY3VlRThoeVpwWGd1UDZ1Mk11M0hzT3hEbTZ5?=
 =?utf-8?B?ZmFGaFdBMFBZb3J5L2pSZkNOeEFubi8xd2NrbkhaQTRBVk1KODlyaWVqb1Bh?=
 =?utf-8?B?bThZS2tXQ0k3Zld0M2N2U0w2UjM0RkIxZFNQMStGekN4RW5YL0RvRFdhd1Ni?=
 =?utf-8?B?U3I1SktnSjNEbTFlZnNvM20zUUhXbndBWDluMFJHN1lLVFZqd2lxU0xVSVI5?=
 =?utf-8?Q?qZCbTunOl8eTdwSEaVRj+XfPjmjuDp+f5Gwx9HZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edf2fa1-aa98-435d-9d91-08d8f9ef07bd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 18:00:29.6381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20t909LmBtEA50Ko6uTq6PFPqMbNf1hkHdUiXdO69WXaLjha47iOJU5fb/hHnt3pTY83jTviV5vIoPhuXxKZDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4959
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/6/21 5:49 PM, Sean Christopherson wrote:
> This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
> command buffers by copying _all_ incoming data pointers to an internal
> buffer before sending the command to the PSP.  The SEV driver and KVM are
> then converted to use the stack for all command buffers.
> 
> Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
> near enough about the PSP to give it the right input.
> 
> v2:
>   - Rebase to kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
>     sharing SEV context").
>   - Unconditionally copy @data to the internal buffer. [Christophe, Brijesh]
>   - Allocate a full page for the buffer. [Brijesh]
>   - Drop one set of the "!"s. [Christophe]
>   - Use virt_addr_valid() instead of is_vmalloc_addr() for the temporary
>     patch (definitely feel free to drop the patch if it's not worth
>     backporting). [Christophe]
>   - s/intput/input/. [Tom]
>   - Add a patch to free "sev" if init fails.  This is not strictly
>     necessary (I think; I suck horribly when it comes to the driver
>     framework).   But it felt wrong to not free cmd_buf on failure, and
>     even more wrong to free cmd_buf but not sev.
> 
> v1:
>   - https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210402233702.3291792-1-seanjc%40google.com&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7Cecd38fba67954845323908d8f94e5405%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637533462102772796%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=SUN8Zp%2Fi%2BiHAjMSe%2Fjwvs9JmXg%2FRvi%2B8j01sLDipPg8%3D&amp;reserved=0
> 
> Sean Christopherson (8):
>   crypto: ccp: Free SEV device if SEV init fails
>   crypto: ccp: Detect and reject "invalid" addresses destined for PSP
>   crypto: ccp: Reject SEV commands with mismatching command buffer
>   crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
>   crypto: ccp: Use the stack for small SEV command buffers
>   crypto: ccp: Use the stack and common buffer for status commands
>   crypto: ccp: Use the stack and common buffer for INIT command
>   KVM: SVM: Allocate SEV command structures on local stack
> 
>  arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
>  drivers/crypto/ccp/sev-dev.c | 197 +++++++++++++-------------
>  drivers/crypto/ccp/sev-dev.h |   4 +-
>  3 files changed, 196 insertions(+), 267 deletions(-)

For the series:

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
