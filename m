Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0392F68D2
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 19:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbhANSDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 13:03:17 -0500
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:13025
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727791AbhANSDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 13:03:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEZHLeB160hkh3HPXKSk1YMvY924nermYd+kXVMg+mrVqnqFkw5udNKtVSaNBTLmdjOUUfgUfXeAwrHafxFDiH6ZeaGkjzeWuErXnaI9XoDzUcuegg6lUImQFGdENlonGsdNjAMFWeyGkkqQgkb8mD28DJjCC42OQp88IChZvg+ZnrP63PrSFMKmZWgo/BgDkVX9G/uyE1sQ16GE65FWjajMTcExp69tmmM1LT93cQEJr5cGk//Uy6/GFmrneJqZN72EJk0jnFiQpaXSxd/5ZG3cmAvuiE1spx9z2guk3YpgKVZE1024/ERWk8xI/43mQsqnjURuC6/IN19nVIgedw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhPSulKwabPs5+YMO67YnPDLcShN1Sw4Olhjh4L9M3M=;
 b=SVPwUxGNgmHBbyLVSyctCOIdvEBEucgmzvEBuw63EizydhlgPeNhyUqJ5aPC/ekvUsDakacGT3JeNTreWUxmFxLj7mpXUfR3rb88vKza2GsIoDOud32B0hAN5adsC87lVf4pRw9avmZAaeeXgYO9APItNIidDEVcllh1/aexPH3QZNzs4k6aQnALP4oFjGzs51RipgtJaKQuGi2c9MOxUvOO595smp9IsNaWcq8LqsQoWcgIwPMR1ZJB6YylfNETcABEluCdosuHZj/MvdfpXvB1gMnsiEvBLtqGL1UW48iDyiYmtDeTWzXVCEQbI748esDS1lfAvMs1ogOQHs+l3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhPSulKwabPs5+YMO67YnPDLcShN1Sw4Olhjh4L9M3M=;
 b=ptRunWtbfKuVwryUF3PSZkX6jVPvvD121q1+PdeSyYkQZ2QNyA5clNiEokdX+dcM9RciOsIrfd7hopAZfnOaDXaHqgf99GM6MFe4FvgVqTbtPg36hQxLbrVDAJPNAe0z/GUxErBumP0R1kdr36L0M1HrV8zFvZGMD3NR0z0jhn4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0220.namprd12.prod.outlook.com (2603:10b6:4:4e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 18:02:22 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 18:02:22 +0000
Subject: Re: [PATCH v2 02/14] KVM: SVM: Free sev_asid_bitmap during init if
 SEV setup fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-3-seanjc@google.com>
 <b1a6403b-249d-9e98-3a2d-7117ed03f392@amd.com> <YAB7ceKeOdfkDnoA@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <12cfd19a-7f6f-c422-5d6a-5317c1df72ae@amd.com>
Date:   Thu, 14 Jan 2021 12:02:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YAB7ceKeOdfkDnoA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0401CA0039.namprd04.prod.outlook.com
 (2603:10b6:803:2a::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0401CA0039.namprd04.prod.outlook.com (2603:10b6:803:2a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Thu, 14 Jan 2021 18:02:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b2426e7-f0f4-4bd8-5b3d-08d8b8b68ac3
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0220:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0220755C86C07B31B12949AAECA80@DM5PR1201MB0220.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sH7WnCl1WYOc+o8WHAIHZB/w5AxDvwQrRNZTcIlPW3h0oovhTuv3nN7p2RiqrkZ6AX200aK/lDCZYtHs9nlVbF9q0h0T0nHOMNuH0+2U/FMTvhqdxEJ1vbHJjSuYagXAobsonUaz6K2rYmiZvILlGxxQZNDOeALTPA7TFnNCJW0MK7gTyldTyqyEsatldaowOPJ1IKq/qWU5+rCCZKIqWgLrw/tnVqfjd0vQiFPi4HUmYSA8mnbq+rB5/3ubBmQcms9ToxOoq9hYdqvGp5+bniaHAp+CL5dHH71DQKhvgn6qc2u1VTIWCdIs5AKYsfE+4/8vyvLyZDir5W6AXfBiOkwmISz3zaSObdXNJqOz1EZD/SCXH6ysYj9GsaCUg/Q2f87IdciK9XZeqTEdESjpVc2raQex0n4uonGqLuQBg8ysi8uYaGFQsa9/GpRNaia9VS+2bnwobKFKUkAmsp3N6cB75+/cdXGsMOyzDQ3ox68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(7416002)(53546011)(6916009)(5660300002)(36756003)(66476007)(956004)(6486002)(4326008)(66556008)(66946007)(2616005)(2906002)(186003)(83380400001)(6512007)(31686004)(6506007)(478600001)(52116002)(86362001)(8936002)(31696002)(54906003)(26005)(316002)(16526019)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aDlHTkpmQ1hCVlgvMSt1ZGl1N1ZkU2hMc0FtVzBDVWNIMk5ZWktXNVplaE90?=
 =?utf-8?B?b0NaN0ZSVUo1cXZKS1FSdlNCamFLY2p3RjJScXhQR0ZMMlFiSHV0djNmcG1E?=
 =?utf-8?B?N0FJczVqbnBvUGYwNzh2VUova1FjZWZ2elY1b2hxU2tiZ0dIa21nV0luc1Jp?=
 =?utf-8?B?U3JNME02OU9DRm0xTTFLME9Yc1JKUnBwZGd0WkIxeitkQWFyWjh3cXM4U3Np?=
 =?utf-8?B?WUVFME9SUU8xbnN5VXYzbkhSbXBUT1RrREk4eXJySGJqMFhhVWtEVkU1YkU5?=
 =?utf-8?B?cGFSOUtWeFpEQWoyZGxMYmhuTUdQbDhGOUhTeVJXK1NzWlVNRU9wajIwejRp?=
 =?utf-8?B?L0wrbzBONTgzV29mQURLS2lMWks2dy9hWUd3VlNaVnRJTFJuZHV5Z1RMY0hW?=
 =?utf-8?B?ZmxlcDNhSkgydjl0aGYvRG1aMSs1a1Y2c1hCQUU2bGJzVDFVeGgxVlhZVGU0?=
 =?utf-8?B?VVZtbkFmMGMwTWtzZzhIMFZZak5jRWJTcWNwSjBPSEZCWGc5M0d3cm03bmd0?=
 =?utf-8?B?M1BKYWg4bGtsek9HQ1FWQldWcVF3V3poOGxzc3BWNzNrTExjYldpL0dhbk10?=
 =?utf-8?B?WEtGR2U1WUJaTHhWWFgxV3dOSUNoOUtrNEY0RnA2VVlNWG5wbVQ3OFh4SG93?=
 =?utf-8?B?OER0U0srSVo0WTErUytvbWMxeXB0Wm82YW5JeEZZWTUycytZQ05HQUc5U3pq?=
 =?utf-8?B?emRxR1VxdG1XcG05dlVyNU5wckFoQnZVWEhNWjlLa2RzeGl6OWpReSs5aXgx?=
 =?utf-8?B?M0FNSUFJYnhXN0xlcDlxaWt5OHpaUVpsbllhcDZMRy9Cb0Urc2ZpL0VwelRJ?=
 =?utf-8?B?TEo3SSsxU2xiSVowWjRIUlZacnprV3BsOUVwenIzb2txNU5HaW15Ylp4eENy?=
 =?utf-8?B?NlArS01lV1drTGlmcEJlRmEyS0hGdzBSZGxMUGdhb0wyUW5YTnF2QVVjdTcv?=
 =?utf-8?B?cm9IdVNzUzRQVlRqaEJhWVNEc0VDMjdmSXhiYmpFTFV1YXRwdG1HYXVjV0FK?=
 =?utf-8?B?bGdLd012cDRPRjZzb0NLazRxenhwbUlxU0JUNW9iL0RFd1FEV3NYeHFWbmgr?=
 =?utf-8?B?T1NmdEJBN2JxTjdLRFU1dGsvaEpqRlRIZnBFTXEyVkZVV20xalJaWHNvQXhk?=
 =?utf-8?B?UG1hRkhxMGNBK3BmaHg4ME9BMWhNa1lZNmI0YjRGZFkrUlNBWnFWR3kxMTdy?=
 =?utf-8?B?YUtnZk0ybE0yTHZna2czWG9IV1lLZ1A4YzB0R2VmcVVGd0FKUmpBNFdRb1RB?=
 =?utf-8?B?S3R2VFVMZkIwRTN4L2R6Y2dYdWMxdkxid3JsOXV0KzdxN3pEWlV0ak1VeGNZ?=
 =?utf-8?Q?LjflgNqSBp/oQxsjxfjN1dXA9K3mKbbL49?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 18:02:22.3213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2426e7-f0f4-4bd8-5b3d-08d8b8b68ac3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sX4+TFW3LtOnESKdxJxUDMscJYdWwvKlWuE4nUv9iuxra1hKQDmHTEP5ycyKzXM1XXup8soIaC2pXyu4+bs4iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0220
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/21 11:12 AM, Sean Christopherson wrote:
> On Thu, Jan 14, 2021, Tom Lendacky wrote:
>> On 1/13/21 6:36 PM, Sean Christopherson wrote:
>>> Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
>>> KVM will unnecessarily keep the bitmap when SEV is not fully enabled.
>>>
>>> Freeing the page is also necessary to avoid introducing a bug when a
>>> future patch eliminates svm_sev_enabled() in favor of using the global
>>> 'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
>>> which is true even if KVM setup fails, 'sev' will be true if and only
>>> if KVM setup fully succeeds.
>>>
>>> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")

Oops, missed this last time... I don't think the Fixes: tag is needed 
anymore unless you don't want the memory consumption of the first bitmap, 
should the allocation of the second bitmap fail, until kvm_amd is 
rmmod'ed. Up to you.

Thanks,
Tom

>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/svm/sev.c | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index c8ffdbc81709..0eeb6e1b803d 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -1274,8 +1274,10 @@ void __init sev_hardware_setup(void)
>>>    		goto out;
>>>    	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
>>> -	if (!sev_reclaim_asid_bitmap)
>>> +	if (!sev_reclaim_asid_bitmap) {
>>> +		bitmap_free(sev_asid_bitmap);
>>
>> Until that future change, you probably need to do sev_asid_bitmap = NULL
>> here to avoid an issue in sev_hardware_teardown() when it tries to free it
>> again.
> 
> Argh, you're right.  Thanks!
> 
