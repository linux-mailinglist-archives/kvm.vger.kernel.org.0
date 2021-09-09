Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3138C405A83
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhIIQJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:09:02 -0400
Received: from mail-dm6nam08on2049.outbound.protection.outlook.com ([40.107.102.49]:56160
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229616AbhIIQJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:09:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezXMGb8tKTwhswfhgb5OzCuSh9eLyqjpvVrNHzhjZcWcDITyaSRst+d1UziGIIbCROKwvw9CURyV8Aijh2QVjg5FCls67iMX6qi56oK2DBRxn29JdiBNONRW985A/Ap+ZA+GhtwT9twBuvCO3ED32ztMzF0+2THY7ZGaAl7ArlqSfLkmJZ1IxW/hj3KUhlJHhc3z2nYBJopAdmTmq4C/YWvTfVmuJleNptiK0D2VziPNLSMPhuIesgllkWOK7JEBjGgF5fwegFNEPTO5ChqnIMj+5hqJomoTj6v1r33m1hh0k+vrbFQpqxcmWIINWeaPHAGTZGgHZExxZT/y6AVCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EGB6Is+YQtu+Uw8ZDerypI3GYhKL4kISBT/bqwoh6Nw=;
 b=OVKKRXbxDoRry9XHKw8ZQ50w9yk5X4xxg2Y15YAWkHC1z1rRkhHefFaejM9sH8U+NUOdT+xsI4XSUD6XNNgXPnGu1Bb17aE3Te/nzij50LogqBP48VF+FMAHKF4d/U+jQRtnhOmgm3u+WcUH1d+RcV2ecAFFsSl15AOkAfDeVVGcyLUhQY+rMm/q99q6Ds9Q75W+xze4+avPuFNxay7joTmODt4MjWC6nrxoR3GAWuzie1D6WdvyWGuMCeL3orwBenJjTSVLJ2crJbbkpY2cAxCkHGSsKUMJhhPl6huINfy26+baiqBiiMTRhKQbo0dzXdNTS3xtBrScEnf+2UxG6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGB6Is+YQtu+Uw8ZDerypI3GYhKL4kISBT/bqwoh6Nw=;
 b=nipjz2bKhPnGTjQaa1o4tD+9hEbduIkzT2z63rZxvKjFSEhYxyFjmOS1oTBzIkBYCc1CDBohSRZyKi7W4h0cVo7UqflJe2kdyXeQLa++3ZSb6N+Z6Ul9eCKHWkWt1KYT9n+IZmR4EfJIOWS2VK6lLDH/Z1OGzFVrMYL5jUpi9Y0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2542.namprd12.prod.outlook.com (2603:10b6:802:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Thu, 9 Sep
 2021 16:07:49 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4478.027; Thu, 9 Sep 2021
 16:07:49 +0000
Cc:     brijesh.singh@amd.com, Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
To:     Sean Christopherson <seanjc@google.com>
References: <20210818053908.1907051-1-mizhang@google.com>
 <20210818053908.1907051-4-mizhang@google.com> <YTJ5wjNShaHlDVAp@google.com>
 <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com> <YTf3udAv1TZzW+xA@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8421f104-34e8-cc68-1066-be95254af625@amd.com>
Date:   Thu, 9 Sep 2021 11:07:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YTf3udAv1TZzW+xA@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::14) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by SN7P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 16:07:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d721277b-ddf6-4a33-29a1-08d973abf7e2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2542E7F85E412C76992218F1E5D59@SN1PR12MB2542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TzwBTeyGHNwnGuoEcCKIK6MIP6DQpvGKaCK2amqeskzsbUMqsn3lTEWhbzL3t7CDeAK9PcfTSD1jDlsvWK6S5q6lXLo50m+/cu4QPdhZ390H3i1prDjEUyXjPHtrlicWN9UBwCH7vNYh5VT2ckbNRGcEFNST1GjjCyn5LrRekPdhqhn9/5+QT/1Lbe4Yv0JwNclKPRqEEenBnYEQmN93r7RTdN598Z6szB7LJTYtr9J/2+/M5xby7MLmiK9oeZ/ep53VdSBayZ3cgK/W4v/sdOUw0tnQmYJWM9qGDvSD8/MVPQWxRG0lFcZw2LXpxQEILvA2p63h2Cc4Egr8Z0mTTIDqF3BF3tavk5A2i5KKmmqLvaU/DzHayneGSJIkqKclCJ4C62yRKDecZ7KoUm4FQz2rIqmqgi1H3vXCb/0ZRQZQEYgwDREfVbzlNnrZo89NZLKcgmwAQWqBk5sHXXRbj159bGAq6OqUjZL1VtQ6oYdUP2uDjHC092slBx/JtbRhVjT6vo7faKKsf1uRlREAzdDEzocHvwoA89vQP+jfW2DcLmtSsQH504FAlA5B4ty7jjw7CMP2DgoFnS105MzJ6GcAlDNPzRPUHBZS+hWxjDKiu4OneRRodrR/Ke7kk0qS2EFu49CyUIrXQSbqsGzonFCB1KAt4Y/+quZXSCXVck1FDd+DCNwkLGzBrntVJ/ptiqz+VdREOD+TxJT67TqoFcJ7Z2neZhy6Euk3Zv7EOirWf6/j+haS0bfGCgN1cVIxC9DPNeTAdn2MpYcheuNXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(86362001)(53546011)(6486002)(2906002)(83380400001)(38100700002)(8936002)(26005)(186003)(36756003)(31696002)(66476007)(66556008)(66946007)(52116002)(7416002)(44832011)(956004)(54906003)(2616005)(316002)(6916009)(5660300002)(4326008)(16576012)(478600001)(8676002)(38350700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2YyLzJhR1FhUTgwYlZ0NkZoWjg2Z3BxcHFmVFRWOU96aDJDNFN2RXFJOXor?=
 =?utf-8?B?dnUwMkR2NG5HN2V5Vit6QXNkamZEdWdvSUNQNWl4akhhWjN6eC80SkxZalRX?=
 =?utf-8?B?WVJIVGhpUm1pRnVUckMxSnA4RndwZUw3d0ZCV20rL0RPTVlVaWgrK1hGYXZE?=
 =?utf-8?B?ampJVGJMRTVKSFJUMlJsS24wNWtjbVdCWUtpbi9mSmJNS0E5amZjOEM4YnNn?=
 =?utf-8?B?SWNnREF5MzVjOXY0VGJ2OUZvenhNaXZrUHJEK01GZUp6NWJudGwxdGhQa25m?=
 =?utf-8?B?ME14QXpSalplMmVOdmdMbUFUVFlDTlllbzNXVUZRdVhmWjZJTUxoTW52b0pQ?=
 =?utf-8?B?Si9lL1V4aDlUeVE0eG8zZ2JvcVZEWDZHSFRHcG0wWXJUQzBxRzJBc0IwcGQr?=
 =?utf-8?B?SmVGb0d0SDY0UlhwS1NRWHNFUVVyZ1hZN0R4M3ZqMit4RFIySGxEMW92YlhF?=
 =?utf-8?B?YzBYeW5XUjdrT0cvOWJKSERaUGJBYjFmMXhqcmVwZ3JBcE5UUGFxdlNHazl5?=
 =?utf-8?B?TkZTczRCQzA1ZEhvZkswV3ZodStTbWE2bDlZbjVEMUNSVXZ2NWxCYzljamgw?=
 =?utf-8?B?NWg5UkVGZDlFdUhlc0F1NkgvWWVGQ1MvOHkrRk1iNVd0ZDRUTlZTRWs4Nmxp?=
 =?utf-8?B?K0Ivd3phbFRPcGFCU1J6all6d3FXQVljL2NFR0RYdTNKZTRoeUZCWkM5MlQ3?=
 =?utf-8?B?S00yalNkTFNuVHhwR0NXR2NBWHZiMVM1dC9zRW13TDh2Uk0rZ1ZhY0MxWEc0?=
 =?utf-8?B?aUxQditSNXpCYjllWUNDMEtDbmc5VXliNW9pZGhjU2NuL1JkUVFHWUp2TXZR?=
 =?utf-8?B?ODFsbGZJeTdQRlZablFZbkF1Tzc2VU1HbU9EQXRFbUJlbzRkUi92MTlvZUln?=
 =?utf-8?B?akVyd0ZpdC9lVm9YYTExMUVLSWxOTno4Q3QyVnEzU3B6WU12Yzh4WENnWVRS?=
 =?utf-8?B?ZTVTbElLL0Jqa1JNUzNHRzdhZmE5eHFDNnc5a3hhd2VjRVpLaEF1NFhiMDJF?=
 =?utf-8?B?K1pDTGRiWjRLU2k5R1AzWWdjMXBIYzh6N0U2ckM2SFZBNk5udURQVjdRS2lZ?=
 =?utf-8?B?Y3pYOWVHQUlFZWMrS05YTzkxNlJVUS9vRUgydWdrQjF0MHlxSGZZYjhzRmFD?=
 =?utf-8?B?QXVJempNdVlPV01zeDBmaloraHNFQStwb3RzVGY2eURQTnM3dlFQaVJTUHAx?=
 =?utf-8?B?ems3b1JJOWtHTjNFNnE2RFhWRlR1K0dDYzJadVFTNENIQXRMcVE5ekNUdm15?=
 =?utf-8?B?R0Rta1Y1T09ranFMR3I3RzYzSjhObUk5UUhtUWVyNkM3YWxpeEpiUmVUQVRS?=
 =?utf-8?B?dkgrMDNyQ0E3Y2diVG9aT29XNy9BbmUwYUpucVFsTmphZml4dGdOcDh4azFi?=
 =?utf-8?B?akRuQnlzVkVjc2RBVktUbDBWSjZhaHA0MDF4dEJIRFB6Y29weGk1TWtYbDVk?=
 =?utf-8?B?c0FJdW9sZEx2Y2J3SWl2WHVNdG1YYWZzMWhIY2dsaUZ5azlsZTBGcU4wbjcv?=
 =?utf-8?B?d0NrQXREdVdGTkxBUG9XMFpGbFZhVHBlZXJvTDFLTVdFb0dTSWhGMTdBcWEv?=
 =?utf-8?B?Z3VTNEZmMS9KNkFUVytramk5MllNUGkwaTltcTBhcy9FT3AyV3FLSTAvNDlT?=
 =?utf-8?B?NnJSeUpVNzZMblFvSEp0Y2ovRWtMTitsbGxyOFpITUtqNjZYUXFoYkQ3b2s5?=
 =?utf-8?B?ajR4U0wydU5qWGUxMTNaM1VQcVlSaUkxSndIazZtdDVOK00wckJCQmdkQ05F?=
 =?utf-8?Q?T7AS2y2UxFPtU3KfFpXxGdtam3aLq4p24aYTkUd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d721277b-ddf6-4a33-29a1-08d973abf7e2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 16:07:48.9929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VndNg08try30WQ7htKtg9bCPjDBw7Xc6E7Ea77cthjjM6NTGOUdeB/SsI/4BSLizPRSZrq09PtaqMC1yFJEiyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2542
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/7/21 6:37 PM, Sean Christopherson wrote:
> On Tue, Sep 07, 2021, Brijesh Singh wrote:
>>
>> On 9/3/21 2:38 PM, Sean Christopherson wrote:
>>> My personal preference is obviously to work towards an abstracted API.  And if
>>> we decide to go that route, I think we should be much more aggressive with respect
>>> to what is abstracted.   Many of the functions will be rather gross due to the
>>> sheer number of params, but I think the end result will be a net positive in terms
>>> of readability and separation of concerns.
>>>
>>> E.g. get KVM looking like this
>>>
>>> static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>> {
>>> 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> 	struct kvm_sev_receive_start params;
>>> 	int ret;
>>>
>>> 	if (!sev_guest(kvm))
>>> 		return -ENOTTY;
>>>
>>> 	/* Get parameter from the userspace */
>>> 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
>>> 			sizeof(struct kvm_sev_receive_start)))
>>> 		return -EFAULT;
>>>
>>> 	ret = sev_guest_receive_start(argp->sev_fd, &arpg->error, sev->asid,
>>> 				      &params.handle, params.policy,
>>> 				      params.pdh_uaddr, params.pdh_len,
>>> 				      params.session_uaddr, params.session_len);
>>> 	if (ret)
>>> 		return ret;
>>>
>>> 	/* Copy params back to user even on failure, e.g. for error info. */
>>> 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
>>> 			 &params, sizeof(struct kvm_sev_receive_start)))
>>> 		return -EFAULT;
>>>
>>>       	sev->handle = params.handle;
>>> 	sev->fd = argp->sev_fd;
>>> 	return 0;
>>> }
>>>
>>
>> I have no strong preference for either of the abstraction approaches. The
>> sheer number of argument can also make some folks wonder whether such
>> abstraction makes it easy to read. e.g send-start may need up to 11.
> 
> Yeah, that's brutal, but IMO having a few ugly functions is an acceptable cost if
> it means the rest of the API is cleaner.  E.g. KVM is not the right place to
> implement sev_deactivate_lock, as any coincident DEACTIVATE will be problematic.
> The current code "works" because KVM is the only in-tree user, but even that's a
> bit of a grey area because sev_guest_deactivate() is exported.
> 
> If large param lists are problematic, one idea would be to reuse the sev_data_*
> structs for the API.  I still don't like the idea of exposing those structs
> outside of the PSP driver, and the potential user vs. kernel pointer confusion
> is more than a bit ugly.  On the other hand it's not exactly secret info,
> e.g. KVM's UAPI structs are already excrutiatingly close to sev_data_* structs.
> 
> For future ioctls(), KVM could even define UAPI structs that are bit-for-bit
> compatible with the hardware structs.  That would allow KVM to copy userspace's
> data directly into a "struct sev_data_*" and simply require the handle and any
> other KVM-defined params to be zero.  KVM could then hand the whole struct over
> to the PSP driver for processing.

Most of the address field in the "struct sev_data_*" are physical 
addressess. The userspace will not be able to populate those fields. PSP 
or KVM may still need to assist filling the final hardware structure. 
Some of fields in hardware structure must be zero, so we need to add 
checks for it.

I can try posting RFC post SNP series and we can see how it all looks.

> 
> We can even do a direct copy to sev_data* with KVM's current UAPI by swapping
> fields as necessary, e.g. swap policy<->handle before and after send-start, but
> that's all kinds of gross and probably not a net positive.
> 

