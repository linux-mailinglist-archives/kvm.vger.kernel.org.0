Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787741C004A
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 17:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD3P3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 11:29:07 -0400
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:6266
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgD3P3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 11:29:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbyB40fVSV9pFUsWvisrl3P3+n8mnpx0GWnMwl5tiSEU2Lorne8xve1DLfQWdYKc9ZTa8v27m32tvAuJlvdrixiroKnnEy13efxdFNequ2HSkrTUKYFzpm7ni2Z9g+a/PF0NsmGgjjwb1dYhcN1T8fW8OWRBhzsNOe5k9P8tUwB9xz9plKo/dX3Y1bQzRkYbMq4Sr1AzzRk0ofBs9aJ7/tHGz4F2BDC9W73jHhd5Q5FM3vwmbejaJMxDV4sk5oNDByxzhzpAnClw+4rzs0wq8l+W/bV+/64Om0Qnx0G0oPbP3yg8xdJbWD/X67XcnEJpTsJ7m74w50KZg0zohY6HMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbH2YEmi8jbC5qBJqBEOxUCRWGrLCb0i6cAhYbokmOs=;
 b=cZqqJkpHutas3HZ/lsOjC5hmrHuUpQkFlU3/QLQWO0g9iKMPU9sl6GBT95vT3oQGu095Z0Q0VPTRiUyHLmM3mV8pwLydw04Oav+BrmVLLNlu39wWTPEfuhUqiGyj68UiGXs0D0k2KVkYL754W7WWfhy/k9yVx+nJjF+kdxFUMngT9J4ptZIGGGyAxkHPhUgnms1exeBUQff8/KD7S+jx7B6Y4LplAn63Wv8zA2Hcmmo/SNypYUsJhoUcyAMQZzuYwBwDj/cWTz42PjkxmtvxFD1vcPPcd/DK3PtQdxrFrDIFw8SXSh/aHKrOPAY4KGU6TevL50iUo9AGPRCvm/cyuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbH2YEmi8jbC5qBJqBEOxUCRWGrLCb0i6cAhYbokmOs=;
 b=M4qYO1MfzdeIAnApvBhqjoqLpH8eBomPOGNtoU7+SUtHFw2X93QbWwpnRt5YkV+ihAa8T1vx3kZgK4iSQsOi+QZ33EvCzDTOcKeY8qtE2eCbrVX1w9CoxMPxXYYpmHwM2NTMMWD8OKs1qfJdiw1+oPSK52lYUoUkMTaWXLcSgNI=
Authentication-Results: bstnet.org; dkim=none (message not signed)
 header.d=none;bstnet.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1579.namprd12.prod.outlook.com (2603:10b6:4:c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 15:29:04 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2937.023; Thu, 30 Apr 2020
 15:29:04 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH] kvm: ioapic: Introduce arch-specific check for lazy
 update EOI mechanism
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        borisvk@bstnet.org
References: <1587704910-78437-1-git-send-email-suravee.suthikulpanit@amd.com>
 <b051913a-10f4-81d4-6ef8-19d586db61da@redhat.com>
Message-ID: <445bea5b-a268-2a62-539c-235c0fe0eefa@amd.com>
Date:   Thu, 30 Apr 2020 22:28:52 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <b051913a-10f4-81d4-6ef8-19d586db61da@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0009.apcprd04.prod.outlook.com
 (2603:1096:820:f::14) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:99e1:28a3:aa38:c6d8:dc69) by KL1PR0401CA0009.apcprd04.prod.outlook.com (2603:1096:820:f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 15:29:01 +0000
X-Originating-IP: [2403:6200:8862:99e1:28a3:aa38:c6d8:dc69]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eaaba941-072b-44f4-ce01-08d7ed1b36ee
X-MS-TrafficTypeDiagnostic: DM5PR12MB1579:|DM5PR12MB1579:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1579047514804A68ECCE1581F3AA0@DM5PR12MB1579.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(66556008)(6486002)(66946007)(186003)(2906002)(6666004)(86362001)(53546011)(36756003)(52116002)(5660300002)(316002)(6506007)(8936002)(15650500001)(16526019)(31696002)(31686004)(66476007)(2616005)(44832011)(478600001)(4326008)(6512007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 91gPwu01dkboORxt+T2eT9yVYVOkBf9bN+TW/tIUS+b9vaYuBZjt69lgIuwC+mAcicfq2Pm+X1OYPoZ1rnrdcY9+/2ATkYoLoSDktoie8J55sQ0MPIqOF8BGEIkLObl94hnAkq6W//YvGvUD53i6Q0/twnFgm549AAGIHkjP8E70GA+o4mUNGkoAhrotadSsrAZEXHExHgb1dJ1u7OE/7YCLiTRqfJtDRyIWK5eOCzdsm6chD0VMkXvJRAbKxhWT54wUYAMVDhOVcamLTcrMMHc04vkNFVEMjIkp0j2kC/uCc+6MgPzxQ1ARBiB7IsfFZ0Ur1Vh1ceMANttrPEibXcwGB/o/rfFeUqwX+tHcfuvTPZ7KAIo6DX1wXXu2Ya7FdMe8fWaUWMlVTSwHDeEi8c04epO+aEB2io8ZXi7jmphQJHFST/w8dGt8o10uaNjZ
X-MS-Exchange-AntiSpam-MessageData: SRVMN7nXX/j2P9AAUspDGDbRDu8VQobO7jbnmwlpD7w5hPx+pX0Z/+1sFdBHYgdZUruucSKH+Wup71CQtDz+BpxblAhO6J55Zlsc89i2y3pTIRLEq+iizT57YIwCSelWsy0y3VtYqm6oJLvUre80aaUHiYL0DWKKwMWThXQqaJ+RuugKRGpTcTT8vqoFulx7AB9+5/RIdqf0boagEwuwaId3oqvH6VAzgPl8OJ4L+MhlaxzsaDtqCAKrLXjvs/bQSye/GS+47uCqHBvcIcGxGfu5DjZUcrwfJ/sXjGC3RcO0R7hQhMzRFTAEyh9HmNGBUz7xWx5oWNiqjDrVhl30rbhSk/3rlmA+bv25dl1pltpfpZhNMQGdlAA1KmIv10TR7Nsl22vegGOMolO9McMmgxJ+swKfa6P0pESmOz7Dyk4qy/RTz6vlxO5Ihx7mUVNENaZRYWe+AfgubeyQ/cRMEYUzT/6emxS+/BWH4QbaKDzgddgBAiObMScW03j/PlwrNiiIIN6ZF8YyQe7UoWaP3XMXt+lgQbk2Y56L0vMaJtz7HSKvXv6yuMRd7sYGZwMyenTXsUvhOT9CxNgUACPm2wktI1E8MMH9tNF999wDPlyloSsqRGhYbeJJAmxRPXkNJDNLS5wN782CLLmrJ06z7qJOML0OCUYi+xSfvkyXJAYKK9puyqD+S5GwwH9uI4S+g2ANIbp1g5ZrO1Q3xpuJYYz/GtRoI3OVCC0LvVn8WabaW6W39llmPgkUcgzkFnIMteQg7LYlt1ZEq7ix8jIbV7uCREnceIvPs2WnNrwGanMfXJEwSis6vNza7Nxy0VhTFnU8wSBSzkurCo9q0ev7M3crpmHYtV+jIpx33gDQeyIScOoJc+8TfgFJo+Yr7Ne7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaaba941-072b-44f4-ce01-08d7ed1b36ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 15:29:03.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkLQ76+u1weN93p9tGP5sXafft3Mhdbf2lXlgzkGLRTSDb0CErgnZzoop/fHtyf4tVe1nZ7/YKqh3mRmWx3PIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1579
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On 4/25/20 4:52 PM, Paolo Bonzini wrote:
> On 24/04/20 07:08, Suravee Suthikulpanit wrote:
>> commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
>> the following regression on Intel VMX APICv.
>>
>> BUG: stack guard page was hit at 000000008f595917 \
>> (stack is 00000000bdefe5a4..00000000ae2b06f5)
>> kernel stack overflow (double-fault): 0000 [#1] SMP NOPTI
>> RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
>> Call Trace:
>>   irqfd_resampler_ack+0x32/0x90 [kvm]
>>   kvm_notify_acked_irq+0x62/0xd0 [kvm]
>>   kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
>>   ioapic_set_irq+0x20e/0x240 [kvm]
>>   kvm_ioapic_set_irq+0x5c/0x80 [kvm]
>>   kvm_set_irq+0xbb/0x160 [kvm]
>>   ? kvm_hv_set_sint+0x20/0x20 [kvm]
>>   irqfd_resampler_ack+0x32/0x90 [kvm]
>>   kvm_notify_acked_irq+0x62/0xd0 [kvm]
>>   kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
>>   ioapic_set_irq+0x20e/0x240 [kvm]
>>   kvm_ioapic_set_irq+0x5c/0x80 [kvm]
>>   kvm_set_irq+0xbb/0x160 [kvm]
>>   ? kvm_hv_set_sint+0x20/0x20 [kvm]
>> ....
>>
>> This is due to the logic always force IOAPIC lazy update EOI mechanism
>> when APICv is activated, which is only needed by AMD SVM AVIC.
>>
>> Fixes by introducing struct kvm_arch.use_lazy_eoi variable to specify
>> whether the architecture needs lazy update EOI support.
> 
> You are not explaining why the same infinite loop cannot happen on AMD.
>   It seems to me that it is also fixed by adding a check for re-entrancy
> in ioapic_lazy_update_eoi.  It's easy to add one since
> ioapic_lazy_update_eoi is called with the ioapic->lock taken.
> 
> Paolo
> 

I finally reproduced on AMD system as well. I'll send out a new patch for this based on your suggestion.

Suravee
