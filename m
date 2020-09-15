Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277C626A947
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 18:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgIOQCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 12:02:48 -0400
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:20833
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727222AbgIOP5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 11:57:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyiUaGRTYzLJ7ldHNZrgIFy1e9xNQThGeEkageTC28os7eIY1qZaNjgwUM1qDmtzbjALjHBeq71v6zAylX3YKYd1Z9zwHwqgDEa7p0z4D/qdNSuA/qYP6Bhk+ZHzDfzAsS1eNyTpzqBpNtpOYJSTu/F3/nw3kPFcIC5lXhV24zcLlJZ2/MyCtA5rNvsRjQnDxxa880BEO1Afha/FP1IQr5hxGz94BzZmARR+NeJn4f+wdgrQUHsvg9ETB1LY9V+FFrm+rX0IoSjsxI2W9kvC3vXehREpNUti1FKkiRfRfel5y4gAZboWNFuuPOhW48MJJHxpVxnbonX50JOufWK2Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnolk/a7KcpOU8wLx0MTnXDvd32y/9393jrgTeToe6c=;
 b=H53SkrW0NmCVyyRU4qJe2LUMsAxz2EkvP1REUG5AdU5Iryp1MIijvv2WUMiTFA5NBJ7OeQojvyVBPb5N4bRb/g41e5ZXMpCfHGNFueqp0uz8cYzizd4i4xofkXFkciPBw3786sjYq4SqSlWeXFfh/i3xQeCXUZTl7C+GdZmQusUuWVx8U9ZKK6tnLf/TBk/1sup0HGIGO/rrrw1eA6CCj50OCzfSYyIBqc2GNvqnQcS7qQTNkAZswEXc4nGdWWK8/vI4WB6IC60POuMcXREQyf/9UzhaMUbr+skh2syxjkUMk98hgCY/j0HQRYiieG+edRCVFN/GVMrUysBO/aDjJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnolk/a7KcpOU8wLx0MTnXDvd32y/9393jrgTeToe6c=;
 b=QLSBJpOwVbYT32m7vWtIqrL7FPMfZ7aUtdjvLLNDi95ODZicP+BoDx+tu/YqqJBQjvXZmqdayCiL/8am4ZPZcDRwfK2ia3iu4vyFFRgTFiT9xPgyrNNLeOtta69Yfw0ZZWT2FWmgA1IOZB5kzFwGh4DRv9XXjUWS/cTcxO5r24Y=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB2532.namprd12.prod.outlook.com (2603:10b6:903:d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 15:57:49 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 15:57:49 +0000
Subject: Re: [RFC PATCH 24/35] KVM: SVM: Add support for CR8 write traps for
 an SEV-ES guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e3438655021a0ca0c7ef5903b9250c4b4c285d82.1600114548.git.thomas.lendacky@amd.com>
 <20200914221904.GL7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <4b5d7e8c-d95e-a2f3-f8cc-fdca99aad0cc@amd.com>
Date:   Tue, 15 Sep 2020 10:57:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914221904.GL7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:3:12b::33) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR04CA0047.namprd04.prod.outlook.com (2603:10b6:3:12b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 15:57:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89873d74-5aa4-4c29-0905-08d8599017f5
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2532:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2532EB1F668F0E939D85E11FEC200@CY4PR1201MB2532.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQZKSkEkfRVlk24ve3YJA/ddO63OKjE+15rOSHm5L+hnVlUXi7ORm2VMKK1roMQh+Ge4ZvFwqKxbiHQ0/x2W0kbHDhEk3oOlke2XNlvqnLL2gButLWsskz+wNnzt6B53lbYgQh460um0CnmOGF/vhCBjfTsUN1RmUywZwPhSpNGFOajoSPut0PDOwcIZVA53YGoRmYPUBwPmoRnR/2WCLH/g7EQwjpOXB1Wlr87gEdAellKuYxng499e+vPZg5yQ3U5iZxJb/NvKMMKMBKSIvD3774PJgSCev3u+N95qWR4NmbYpK4r7krpFQGss34HvHd4dRUNEk4h8zRwirKS8IhPo28OrOq5NTnv8PTEiuakq85fyXP+sZ0WLlvl/wces+pyrrmFuSI3WJqO+asAi0znkAGnOfrhpTm4up3aAZHjRlXoDv6OdKTem+JJLr5Ym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(31686004)(6486002)(7416002)(66946007)(52116002)(8936002)(4326008)(26005)(316002)(83380400001)(16526019)(8676002)(31696002)(186003)(4744005)(2616005)(86362001)(53546011)(66556008)(66476007)(956004)(16576012)(54906003)(478600001)(6916009)(5660300002)(2906002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VL2rT7wN+QTCqxinKoaNtLpeXq4bS6C8vk7ywowdttcehIwd+f5e7cMmYkoelAKOEJI7tzxcel2U2KjQKs6AfQC9/ocshg4S9X9Q8qhSgrsTsiJj9xCVBS4y4jSlcoKMhFJdKKQPlSf640sWeaDcQ5BmgWSNCKJo/b8ViC3yDqTECI7KewJVr4yX3tvb0mPGIAtqMEziIzXfc69/YKvS9x/f2I+8vUDYQbrojlMeK6OC06S6rVgUaTQFwyd4Rn1P6Xd2Z3f0I26ge5oLSM2+QmwWHj/Pvan1agCN3X7nI6U8e9MBPNSA+iRJgXLrJIMXoJ2Vy6YydQRAtxWmjTfVKA7+y8v4bV+9HzBUiPytvdWsSlWrzE58BCVzTdOx8QY/6lSzpWh+UKVx1pyV6EfRnVxnt7kP4gPnKr4Z0PWvom9jZAPmn/viqjCES4E0XywjjxBieoYL5mP36mDIYiCqGZKuy8b8ZfOEymEMlEQiYPqkdKiF6tMoTOxFVeEjttNDPUChDkb38BzmgkURxdl7HhG8r9/ELJVY0eYU2j4Ox6ffyQDWK43CrJXeVeA+EXSH/VAqu+cVw5wStRjERz87UW+40bOr88Mxn6KWhu50xMY3LtHuyzEQUN5/X2jbeVAHIPuvHOCkXx1nBhCW1pjoww==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89873d74-5aa4-4c29-0905-08d8599017f5
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 15:57:48.7151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZozJJyT9OUqd1zvomjA2WDa2XHnYq+pu/qcrL0rHRQg5IhEoHZO5+5JE3Yp2fLBc7cTs1+aH56CU+FMDJ6TWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2532
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 5:19 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:38PM -0500, Tom Lendacky wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 5e5f1e8fed3a..6e445a76b691 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1109,6 +1109,12 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_get_cr8);
>>  
>> +int kvm_track_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
>> +{
>> +	return kvm_set_cr8(vcpu, cr8);
> 
> I'm guessing this was added to achieve consistency at the SVM call sites.
> With the previously suggested changes, kvm_track_cr8() can simply be
> dropped.

Yup.

Thanks,
Tom

> 
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_track_cr8);
>> +
>>  static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>>  {
>>  	int i;
>> -- 
>> 2.28.0
>>
