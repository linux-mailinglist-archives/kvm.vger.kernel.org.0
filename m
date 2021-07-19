Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276F23CDC50
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 17:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhGSOwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 10:52:03 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:7328
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245472AbhGSOrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 10:47:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGkwC757jikjXjJkb0P0CSYELFhwlZPZ4dEUchkoFBrM8ufWNB7zviXRH/AXk4H4Zo6jbkcESxLi1Ad10XY/UXh6dPbj7vEEn8EGDidZbZPaOFjQgcwNzVdO9lcuf5po6MIoF+rAZ4SFAOPUasY/Pu6k3u8S0WIuBmafbTrEPQL1zmnX6+QuUcPVHhcdIdn7AqpEmVYhTvaQa4cAbG2lOKkDMjeXO60pQIU/9QIYrPin34TjhTAlI83EsDn+W3Z+n4Zn3aWbv2MjXq+ho2zqH/mUnhwsHAzuhvTDxMGY+i+QcisRftBuTYORrmXU7V9+uFzUzPdMyWyt3/LUL4nRJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UKNOJrFiAOuJHZDLYdRLeGOEzQRDo3y4wM3pv+Dqxo=;
 b=OgFY4k40yWrBoNx8QN3MIdCAR+15kNDS8tQVazkNWJvTihvjXn2ZVY2Mu+9Ms+7Kc8Nbw59vo4+PC/mtSxXBzBXhhGOzj4AnPG0vkvBX8ICBe9jP+QveI1WHJlmvdXa87YWopoQ4c+eUXl0gYCl3xgo/sHoL2fZsFKZ/MVJZs4zCdoc0iPVCFcspMymN8xJkjTfCVdxgKWTcFku6suxKE0cakH6aZQVYsF95LFGexrgAtvsI9iPTxk8BAagjf45hZ0w3B8ygvq6aTCzDMMjTqp0YfkchE73aMrcFe0NqMSNznRuB4xNEefnoApDURjVIFbT5X/l3N6N5EeSSWnj6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UKNOJrFiAOuJHZDLYdRLeGOEzQRDo3y4wM3pv+Dqxo=;
 b=hRRtiiMKP6RSqHqx1QIlFvdsxS3uqYRrjkUzCEnryuOeTmfpbTo1rw16iM9ZP/xCBjt2GFRK59c0UQpOQedKHUUS0Xonxgrc6AgfDZnbtxFeVLsPJzV8WYcEI9GdqhgNmW1gQFS2Movv+f49Pr5PelJ57rrqQMxjvP0odHhJ9JI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 15:27:36 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 15:27:36 +0000
Cc:     brijesh.singh@amd.com, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 4/6] i386/sev: add the SNP launch start context
To:     Dov Murik <dovmurik@linux.ibm.com>, qemu-devel@nongnu.org
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-5-brijesh.singh@amd.com>
 <d38d99dd-0248-bc96-cb4d-82ec8cc782f2@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8bdc918b-aa22-db23-3ecb-ea93148a92aa@amd.com>
Date:   Mon, 19 Jul 2021 10:27:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <d38d99dd-0248-bc96-cb4d-82ec8cc782f2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:806:d1::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SA0PR11CA0097.namprd11.prod.outlook.com (2603:10b6:806:d1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 15:27:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6200ef35-f6cd-446c-03dc-08d94ac9bc97
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4349771998C6AEB84809C3F8E5E19@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3yRa4brPxAkFhc1U/OQNy09K16qI5bR5RosG8+PFE+84Wkf7rDi86C4F3BTxIUMRSO0K8dugF5Om5dxZh8YB25OF2GpSjRXlrvelzyDtcMqMFEKxBYFbirX7aF0bbwmDu7Iteh9UAnxeaTym+EXdwIZmsV1TEEtBMvZRyfUUm6UNpP9v4PjoRJL33hg2j8REoDK7dQoFvxFhablAnfYC54BSDkZBsy3Xf/SwvM8p/2KDqKWJgiCCfzUrYWgJmKSEjqE2E26aOqoG/dU8Ckvt2vKXAVF4AKLmXx5Ls9KZjR4pmR5Od4XAme1AqWBWVDc9jsIqW8XzKM46v6rorKXmVZXLoEgdTmToxbKJL2yUaWaFuO6cxJZJoYa9p6h9Z61r1cguDsAuFZcgqojFLBANXiQVIAggHkQYquOuj/yJcS21xBDqzDdzikUiPKMZDksIEWpntyQk7veLkzhqgrS/H/7X4zZbBJXA/rhSdX59DyIgS39BwG6KaIy5vsl2/2Jn+D0ef24CB84pXsYKu8HakbcNLywKucLtVIzyA897YF2R0c6gfvjJUIAoYl4jViYH/un/L7Cc34J0BC9b435eWcTQ4rj4qWYWKOGwS5SJbymyRUeXz5lvRfHkkX8zr0nI/pol2GWZ8dcASaYh0QA/6X8QX3904jG3+UXSLEwflpaaxHalDEUJhWiLSt5gUCcloVl2E3/0SnmPkqDAJ8fPB5iCtDHBsT7112F3VYfxQQdP+nobqFyk6Esv5m0w5gUQkQ9Tpv+ahDhgpZu2cSSyHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(6486002)(83380400001)(316002)(36756003)(16576012)(53546011)(38100700002)(52116002)(38350700002)(956004)(8676002)(7416002)(31696002)(26005)(2616005)(86362001)(54906003)(66946007)(8936002)(478600001)(186003)(66556008)(66476007)(2906002)(4326008)(31686004)(44832011)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjdSb29ISVp1Y2hTbzJMT1BDTkFaSXBhY2czYmpVQ0hkaFJYUk1ObjF0VUdV?=
 =?utf-8?B?bTlRSXVyMWIyY0lSRWk1VmtOSHJpanJLdWNuS1BvOU9EQ3hyUmw3ZG9sTEo4?=
 =?utf-8?B?UDExTlFJUm1MNllMQUZvWjAzekg1UEZKbUIxOFUzam9pQTJlUVg1cEFmRk8r?=
 =?utf-8?B?RW5Kc0tsbGdHMnR5LzAwOTlrMERMREV3Mk1OMDBsdXl6blBPWEtmcUc5b3pL?=
 =?utf-8?B?WEJ1bmhjdGxMYkJIWm1rZkRHc3dsU28zSjc5WW5nMzd2OVVxN0pQNXpiRS90?=
 =?utf-8?B?eEpvTGxpY2txUm0xYlRGSUNmYWZHekNNWVlRaXBNQzZaTDFXQjNTNnZOUlQ2?=
 =?utf-8?B?dDJ1dkhSRE80NjBkWEJGMEhwRzZFTy82SG5YWU1QZm1aQWhSelA1Wmh0ZUI0?=
 =?utf-8?B?Vk50VXFGd0Mwam9IamJlZTFCMjl5dGkxdlJheUxKWGUwWGtoNjBrSnh6S2pF?=
 =?utf-8?B?Mk1EZmwyTTM2ZVBvMTlMVS9hNnpZZ2hCcmVvTDkxSnFIcnR5VFlDQzNDOGov?=
 =?utf-8?B?bUhyMWMzcFlmWXhuQ21kcExLR0Zrd0c2cmFobmRySm9wK3RWRmFVdVQrOFBU?=
 =?utf-8?B?UlNGUHU5UndrU2U4cEl3d0JtTW9UemV1anprSlNuYy9FZUNTSkZ0YTNLcVhX?=
 =?utf-8?B?OXVlMjdRNzJDT3FTa1NZTmRwMXUzUFh3MHZrRSt6VFFaTHR2N0ZrMGhjSHZG?=
 =?utf-8?B?ZnZwcStZc29qUm9ONkpuS04zZWlQWGF0WnFmeVZqZHNNZFJVaVhHbGdMNm1I?=
 =?utf-8?B?c2E0YWJuWDFobTJicmZLK2NneHJkMm91MnplRXBuL2VtaGFvWnNtVXplSTRT?=
 =?utf-8?B?cDhBblFFazlGVlFaZjI1VW9VVXlZcGF4VnZsZXdnZVphbUJwVGJMdVdmOXQz?=
 =?utf-8?B?SmtFZXJoazE5Q0xRaGE4Y1BGQXBTVGVIeXNyR0srcFZZSEYvdUY4QzkyVS90?=
 =?utf-8?B?SDBYK0ZJNFdXaWxwQTVzVDlEbkh0Y3I2eGd0YTZWWDA2dUN3NjVjeVNIMzVv?=
 =?utf-8?B?NEZoTkNERkgva1kvbzFzSzFBcHdyVjJma3FtaUd0S2ZGSGkzOXZ1OUtOSmZP?=
 =?utf-8?B?WndFcjhWZnNXQ1E2dzkrZVl1YVhPWW5OVk0yYitDYjZiQzN6V2QwY2FlUUZU?=
 =?utf-8?B?UUJFQVZ3YUJXNFo0Tnp4bnJmSnozczdBQmZ3dFBxaTArR0VaRHFWc1ZRekZV?=
 =?utf-8?B?b1hoeVFjM1BmOHN5L09qRHRYeHEzRXRRSzlQYVZ5azk3a3ZkM3pqL2ZXanA5?=
 =?utf-8?B?TERidnBwRTBCdmhKa1loY2xjdk0yWThZdmZ3R2ROaFVudVhaSXZGTkVKZU5v?=
 =?utf-8?B?Q3NQbzBJTHJUZUJnc3JVb0xtMXBycDhPQzlnZEtmS2hOM1ZHaWRsNTZ1NDRm?=
 =?utf-8?B?M00zWlRlU1A1c0RPNGZqOW9MR3NseXI1eklsakpHUzVvTWJ4dWgrTjUwQnVr?=
 =?utf-8?B?cHB1WFR2ek5ia3ZVM2ZPRy8zeks0SUo4SzBGRFpoVUpiYzRZUGp0MWhTY1Yw?=
 =?utf-8?B?cWd4Z291NHppRUxnWFAxZ1pWZHpEQlZHWGxRVUtENGtIYmp1V3ltTTNIQU1w?=
 =?utf-8?B?bUp4S0tVRGNEQTRSa0JwWS9hN1JsbTgvZjJyWjd4L1dUMTFkK2NIVHpZMmlO?=
 =?utf-8?B?bzdkQUlzRlpIalRQUmN1VGkrY3laeUxadlVPNjdYU3cwODNKdTVEUlZ4Q1or?=
 =?utf-8?B?V1VYSS9MUnJuRU9tekw1KzErblVWYk9KNGoyR1l5UEh5YjAzbkFyRXBvKzVY?=
 =?utf-8?Q?+tRHzodsUK9VL1QDkM98FHLjw/nHqNw4Ym3FaMk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6200ef35-f6cd-446c-03dc-08d94ac9bc97
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 15:27:36.4060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fol4onUIF5mWDJiy7DR+Ic7YX7+QnCOrY1nOvqJtl+lNFus1Srnx69NwCl05pVdC/WWguQHKwjDlHl/658pv4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/19/21 7:34 AM, Dov Murik wrote:
> Hi Brijesh,
> 
> On 10/07/2021 0:55, Brijesh Singh wrote:
>> The SNP_LAUNCH_START is called first to create a cryptographic launch
>> context within the firmware.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   target/i386/sev.c        | 30 +++++++++++++++++++++++++++++-
>>   target/i386/trace-events |  1 +
>>   2 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 84ae244af0..259408a8f1 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -812,6 +812,29 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>>       return 0;
>>   }
>>   
>> +static int
>> +sev_snp_launch_start(SevGuestState *sev)
>> +{
>> +    int ret = 1;
>> +    int fw_error, rc;
>> +    struct kvm_sev_snp_launch_start *start = &sev->snp_config.start;
>> +
>> +    trace_kvm_sev_snp_launch_start(start->policy);
>> +
>> +    rc = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_START, start, &fw_error);
>> +    if (rc < 0) {
>> +        error_report("%s: SNP_LAUNCH_START ret=%d fw_error=%d '%s'",
>> +                __func__, ret, fw_error, fw_error_to_str(fw_error));
> 
> Did you mean to report the value of ret or rc?

Ah, I was meaning the rc.


> 
> 
>> +        goto out;
> 
> Suggestion:
> 
> Remove the `ret` variable.
> Here: simply `return 1`.
> At the end: remove the `out:` label; simply `return 0`.
> 

Noted.

thanks
