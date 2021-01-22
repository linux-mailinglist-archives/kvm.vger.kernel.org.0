Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800FF300E9F
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 22:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbhAVVMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 16:12:09 -0500
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:65248
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729524AbhAVVKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 16:10:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrzGpx+uRyErhNBImGz5Cuk/vUQqFxRad7H0aKcwW2hLdMtHlgd//I+V9QMvBj2Gecm2C4WBRr5DZe+m/u1iQvbE79V6w/+jC3A0pATc2ss8LHhZ3PA45KUFbXIMscNyICsiqPkSe4L/OcS+JveHqyZEBMYh2Hzhp8sfHVkHO7Pd/3u+wn8OnyIPiojT4lM7DtIsiO8XhOXiJ6NYGMsmdKDWudLvHllll7iwtHM0nwE3ZYm86/bgLmtkDLdAlSQMFAwAeJTMyZlOyOexjfcE1aPDiPqDLxjyY/epQKfVaD0/NfMftH57zBZreQBQimZsD4W8cXKr3qDnlTE22sgG5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uex747HFuOQ0QjjqHm4fUf4qW97e20+JQI9DFb5PBXA=;
 b=mmQ1telp3xMJELIRFT2y3QvtM4M46pRSUaxroVBcNLlk59ZFBD5k7HUYbzD8MKGJGS515MBo+/vaKKWp6U8qdbD7rb+6qXApID2lQFssF6Uix/AI614aO6ysEjBQupJFeqnrXRyN1ZTGhvRxtZLx5qfBUJohQ5PNZZUV/kyqJEWzx/frUFva3B597GPmQ8G175UID+DmcyS3b2GRpy3MXreCZvtzEGS8fsBxx+0g+AldelwzCkK03OwUdEU4WjkYuuYdsqmGNGDXhDgL7T95FNMec8EmV0MA66mVk+H/Ht1iyewtg/ePFF4tWrtUYPFIicqd48r6Nj9hyQx40JgyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uex747HFuOQ0QjjqHm4fUf4qW97e20+JQI9DFb5PBXA=;
 b=lgiqcXKSzJGNNKBCWtNWEmq1aV8uyNubjqm4oM3zQWpjKV5t0nfxDg9+VmIuyXseI6XHBf8xOIZRewEVE7uFHzOF6//QfOHbTiAznLRCB/csqMCAm5YnBd6RdD6ikZpaqBKhW5curm9GzMQHxhNzdllDBA5AJB8Tibk7Zmv0tx8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3273.namprd12.prod.outlook.com (2603:10b6:5:188::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11; Fri, 22 Jan 2021 21:09:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 21:09:25 +0000
Subject: Re: [PATCH v3 02/13] KVM: SVM: Free sev_asid_bitmap during init if
 SEV setup fails
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
References: <20210122202144.2756381-1-seanjc@google.com>
 <20210122202144.2756381-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <c013cd19-8120-838c-2357-f87a99f7ba1d@amd.com>
Date:   Fri, 22 Jan 2021 15:09:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210122202144.2756381-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN1PR12CA0065.namprd12.prod.outlook.com
 (2603:10b6:802:20::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0065.namprd12.prod.outlook.com (2603:10b6:802:20::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 21:09:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c0d7bf4-dfc0-4f6c-0fc1-08d8bf19ff6e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3273:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB32736132C251C271C94BBBD3ECA09@DM6PR12MB3273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t157RKoZJrsEjXTYOpNMjXjvsUcypRPxxHeG8ygfERDfNo/gJxJWoLUJ4LYhts33C4gqf7jpIrulcINZ+bTUmUG6AyaqMtKVQklxsNTTxUxL76eu/UQ7DsCGotzmpFGMz1huWJrcLBKafLYPOMSILWWIB1jVqI9bUmVHeBx15jqTomX4CNNBaSFYDYxZBoZXJvNt9dBF5d48BaheY5+zlRQNcf9wuqnB9Yxfs+8Mqa3elpTU10wqnzmEDsJ+OOQuvVkXHgntDV9Nzu4Iuai5bW+wlJrXCNkmXpJn+XHhlMq0rxAoD5J/fpO5jq9pNHBp7ld+UlgHeAyhC/x2E6jaTsYBpMn2AAVL+UO3XiyHMkF/FKipkMe1SlLlMEKtTNNnD7GVppOh5whThiUCeceaH20nMNEy1Q/Hb+TXNUITlAiM3Zgdq+HVqt3QnPeUluFkkVbutLDuRpMp8X1B1kYFRnTV/h1wP51Dh5ybESBHL6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(498600001)(54906003)(36756003)(2616005)(7416002)(86362001)(6512007)(5660300002)(4326008)(66476007)(31696002)(8936002)(2906002)(53546011)(66946007)(956004)(6506007)(83380400001)(66556008)(31686004)(52116002)(6486002)(26005)(16526019)(8676002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q2lOY3JrZ2U4SGpwdkhOTE96WDdYSHpCT3RSZWtYYTlrQ3AwL0dWOFIxNEl3?=
 =?utf-8?B?a21KRlNHSEQrV2E0d0xxdHk0TkNsT0RCVlVtN2NKT3FHQjBHakpNWXIrTnJ0?=
 =?utf-8?B?dWpJSTluV1VJRFRzRVRkME16QkNKNkNaKzlLTGdtbis2Ry9IdmxRSTJuRFkr?=
 =?utf-8?B?NXJZMFZmdVJqcEgvZUE4ZXdxNm5YQnIyc29nK05RRXRnMWJJOWdhZUxFeTNx?=
 =?utf-8?B?M05BVWtaSERrUXRTOUM5RHhqN1phdjBLNWs3bVhza1YwTHNnYWtuSDU2WjY4?=
 =?utf-8?B?eldzS25ZUkQzRjhhUVdnNkpCMVZFSjFwU2IxTGI3WkN5OVZYVzBZdjZiRkhx?=
 =?utf-8?B?Z2wzMld6QU9Ia0puT3FnZUw5N01ENWh6dHhLbkZqcmJSVE5NbXRPaUh2bjgw?=
 =?utf-8?B?dGRYdXB0NFMyQTY3TVMwS0tDemU4OXFlVHNZenoza0YwbEdya1BZd2NnTFE3?=
 =?utf-8?B?Vmg3VEVEVWtTT0UveEhWeWxOZmdPcVp0elZNTWlVZzFEZmFpbHNHazU5Z0I2?=
 =?utf-8?B?NWhHVnFCTXcyTWQwbjhTaHRoWEJpeEZaQW1yWnhFUUFTRWt3V3dxbHZ3QTZo?=
 =?utf-8?B?aHJGY2QySlVXUnZ1VXo2ZWkzd08vWXlJRnp0YlpOM0JOSE1Gd0JJNHN3VUdB?=
 =?utf-8?B?QVB1c3BDK2ppaklBZkxyeStkSzdESlcrcjhyano4M3psdDRyYlpiOE5nL3Zy?=
 =?utf-8?B?VGtVcXdoNUtla0t3ZktOa3FKV2tqWVNveDZ1SDJWemRRUnNZMkNrWGVUUjd2?=
 =?utf-8?B?NVNYKzNQR2JTaXBqTkdPcjgxZGtGY1QwSmRNOWlDekN3dUx0TkdHelR1VlpK?=
 =?utf-8?B?OEpGZ2x2TkV5L201NFBPVHQwbXN2REV1dm40S0tMN2E2Y0p0Yzl2Tmd1dDJB?=
 =?utf-8?B?SGxldDJNMkVnZ3pzQktORktEUWZkM1QzQ1VGQVRQZ1VvTm9JUEVhbGRGVlpO?=
 =?utf-8?B?U1FlMDhzcXN4eXQ4cFQ3TWdUZzl5WDFYVC91d0NVUDdENTdBSTFleHhMRkJU?=
 =?utf-8?B?U2wvQjJkdnlPQkl4Vm11RTc1S05mSTJKZlU2cTRKKyt1U3BwWGNKUHl3anEz?=
 =?utf-8?B?aU1rWkRDbkVTRk52MVdCR0gwL0pyMDNldEdKWG9DWHlRei9RbU8zNERhVFFX?=
 =?utf-8?B?S3Z3RGFvN3BXTDdNc2NhZ2JDb0o3blpkWmV0RVBkbXpyTENaaEVEWE1nMjZJ?=
 =?utf-8?B?SklPeVp2WkozQ0pySDRjOENEa3hlblUxVXNPcmZjU2c2UFhNaE1HVlJNY25z?=
 =?utf-8?B?S2tFaHRhdDd6NU9xZlphUGxvYUFlS3RvN2ZDVnFTaXJMM1Evd0xnSzcva2dT?=
 =?utf-8?Q?ijfiRVUog/5Fbk+ZnbEDppztDjoWJyYECs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0d7bf4-dfc0-4f6c-0fc1-08d8bf19ff6e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 21:09:25.5574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ly2mUXED0IbCUlCWIcbdoRTxq0VfvchNpMkD0miP1+Qa8qP5+VDbGf2sYqw+mqQRww7JViet8OvYiHPYre55yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3273
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 2:21 PM, Sean Christopherson wrote:
> Free sev_asid_bitmap if the reclaim bitmap allocation fails, othwerise
> KVM will unnecessarily keep the bitmap when SEV is not fully enabled.
> 
> Freeing the page is also necessary to avoid introducing a bug when a
> future patch eliminates svm_sev_enabled() in favor of using the global
> 'sev' flag directly.  While sev_hardware_enabled() checks max_sev_asid,
> which is true even if KVM setup fails, 'sev' will be true if and only
> if KVM setup fully succeeds.
> 
> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c8ffdbc81709..ec742dabbd5b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1274,8 +1274,11 @@ void __init sev_hardware_setup(void)
>   		goto out;
>   
>   	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
> -	if (!sev_reclaim_asid_bitmap)
> +	if (!sev_reclaim_asid_bitmap) {
> +		bitmap_free(sev_asid_bitmap);
> +		sev_asid_bitmap = NULL;
>   		goto out;
> +	}
>   
>   	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
>   	sev_supported = true;
> 
