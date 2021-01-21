Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BCC2FEEF2
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbhAUPe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:34:27 -0500
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:6320
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733066AbhAUPcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 10:32:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm3Hgu/KBrxeIq/ElSxWG5z/pnA/ZPiifxm2AdErs3OdVRMSbK/iwyvw6/z5Vi5jvMMjOy3BqIpODZUHmFkBmtm8wXh30piY6JOodUujRjuvEtkqbFTIJyRYS+LfL3S3g78P2OdqZmDQm5cwOe9UaP3WZjrAdj4mDJlidZu3ucojLvQ75fHkhfr2E0eoKFPN7YWxFowrWF6RQ9OPYDZzucMmB0lYjMeurzzAGo3DPuVshBWOQcBgcameZssHvGpZS90CawGnN+I2L2Y+cABdS/UMXTiPW8LS/OMm2ZHlUttgNdLwOTgVD56AvkQN0P17OFqJtFZqwddKWk5kOPLtyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sKWqbrzfu/Td9eemDEGZVTAxK8NWX0t5hgbRv3rsWg=;
 b=nHV/2pY1ZxbE3XKEZhgAMt1YcSE3drvauS5ioPeKtrVXcZ3SS3qncQTpP3sescuUTGjMUgLyDLpiZLSiy8P7CE+giTfAkJfNCEzfY3NqyVZPtU88sSZQ+72CNyPWbTR0WN3wPIPNawBrRAsC1jXI4vKVxjfMnxv6ERh5YBM5FSQphUzlDAfaYZaEfnxe/Cx14KQLwJb9TrDgzOCqh79FDzNi0o22nIv+QnNJO2VHL/IN59HrIfeXsaatFBMOCGY9wPLdJmJMQaiLhpgtM9wHdrmom4cdc42fPcPIjqLlZfTvasxLuS2zPS1Fj3WPjnbrUDyr9gGQ8EyJEmFt294EjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sKWqbrzfu/Td9eemDEGZVTAxK8NWX0t5hgbRv3rsWg=;
 b=BC+sPaxGOBx5B2wFBQGQdaa56+5y7Xumuc0EeR954GoCkxvtcRcaOyNJLLblRYb8rXgQQn9+UFK5SJp9tllrCVbeU9RFXpJx7wsHAxl6JFrM0Uiac8U0siekbf4NJQ6Rp8F2q74SXVmY8aHtv13vYYrZkCr9pDXnYxLPSfhDI2g=
Authentication-Results: amacapital.net; dkim=none (message not signed)
 header.d=none;amacapital.net; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0167.namprd12.prod.outlook.com (2603:10b6:910:22::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 15:31:52 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.014; Thu, 21 Jan 2021
 15:31:52 +0000
Subject: Re: [PATCH v2 1/4] KVM: x86: Factor out x86 instruction emulation
 with decoding
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, luto@amacapital.net
References: <20210121065508.1169585-1-wei.huang2@amd.com>
 <20210121065508.1169585-2-wei.huang2@amd.com>
 <82a82abaab276fd75f0cb47f1a32d5a44fa3bec5.camel@redhat.com>
 <3044193d-1610-fd67-e4ec-12a87fed62f2@redhat.com>
From:   Wei Huang <whuang2@amd.com>
Message-ID: <83e320bd-9c88-b384-e72b-ce8d31c1deef@amd.com>
Date:   Thu, 21 Jan 2021 09:31:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <3044193d-1610-fd67-e4ec-12a87fed62f2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: MN2PR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::48) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.29] (70.113.46.183) by MN2PR15CA0035.namprd15.prod.outlook.com (2603:10b6:208:1b4::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Thu, 21 Jan 2021 15:31:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 676b2133-6917-4228-636a-08d8be21ad2f
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0167:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0167CCED10BE345848188868CFA19@CY4PR1201MB0167.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQy/dS+sLUcRDJCUi6JPMpEtM/89EcsR/ZBp5RKCnAKLkzMkIrmdLhEmDgmhAcmj18BGoBuIds/MqZZ+Nb563YRJ+tLmMuEdlKvvE+Tz4aHqM4ruPgKrnvcXuE48IAQJoU1R3ng2Bp3BA3QARLZfAJERQFqxfSczGdjBo0T5ecluw1XLgp535CoCcrmSIpsfH71Tl9DZO9GQf1XijgQvOOISN8DrfdwgxrbvIg28H3ahgIBZMT90tfNja+zlXDISzK8KzjkVlR+liqckKGWUFTYgs8rT9mXLhxrHYG6yY7ulUGnE5Q+AetysuSyqHbY+hQh6OtlqjMVIJJTuB3MuzFyqTW1cWGbs4l43HR3RWYLiSrz/YgoT6izvSdEWoj6/HVoAVrtcD1cfrEEAG87Qx8TwMck15POhrfAErOWYAy5ACqrIzBjaJaiOVv5ysvKSwFNSttE/nAiIwYHJFweCdu/AL0lvcM2FysLHryRFaOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(4326008)(66476007)(52116002)(66946007)(66556008)(36756003)(478600001)(2906002)(6486002)(31686004)(6666004)(31696002)(8676002)(8936002)(316002)(53546011)(16526019)(186003)(956004)(16576012)(2616005)(5660300002)(110136005)(26005)(4744005)(83380400001)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHB6M1lrL1AxM0h5bmVKMnUwN04zTXpHUlZaRmZmS2tqUVRBNnQ5UHBheitD?=
 =?utf-8?B?dDF4T3RYaVZGUE5GNDFialZLMG5tUWJXZm9NM3ZGNXNsOUR4TUU3ZzJPUDBl?=
 =?utf-8?B?dnBQcXNUUGVvOGZlSk1ld0xtZUNiUVIwZWU4dEVXVXdaNmZMMFk0cFNYNVhm?=
 =?utf-8?B?ZWNEYXFCcmFzdmVJZUl3WjN1TnlWR0dFa3ltWE9mcU5BbmxPcHUrSFFCKzRr?=
 =?utf-8?B?bnV1bzd1NnZnTFVGZVFjcUZWWGZmYVdvVEdyeVVxc2IvdGxvUzMycngxVXE4?=
 =?utf-8?B?UXNObTlHdXQxZFpBWDd3bW1SZ0sxWjRtYXY4SFMyOWRqblVIYTlUWVpSeVFB?=
 =?utf-8?B?bzZiYVlISkhxaTVhVzF3Q3RRUk4yL1krRFhrOXcvZ2p4L3ArOFd5Z3B5Q0Ez?=
 =?utf-8?B?K0NBb1ZYYitxZW5YOFNpTjI1VHdreDY0SXhyQ3JJVkNxUXdXY0UwWmtLWFFS?=
 =?utf-8?B?RTJaT0dxd2c4a0lROHFOV1RkRTQ5K1hNY0trM1VCS2xDaGp2T3pYRmI2L216?=
 =?utf-8?B?UWNMVW5kQmJLVHkwRWxMZzhWV3R2SXNZbUdpRHhzUWdubGJJeVMwYVpqQ3N3?=
 =?utf-8?B?SDAwVlpXMEdXUjlDRDhZa3Zwb3BCRkQyVkQ4TzdWMGFTM1ptTmsrVllBZmE0?=
 =?utf-8?B?T01QdEV0TGNpVmpiY2gyQ1U5b1FQa2xCZEg2THdUVEF2aXU5NTAvWTl6NklV?=
 =?utf-8?B?bkdsNDg4TWlTREZyQ1hFVm90ODlVMGFNU2pMQVZ2Y2FBMXpHUkYrd0RuQkZD?=
 =?utf-8?B?RFZCZFpCSndCRWZMbndZNEZvRHptSGJjQ0JxZVY3OVNNeG41WjhUbkFTWUlR?=
 =?utf-8?B?cDQxMzg3THJqK2NjQ3VUNUtJYStKa082bm8xYzh2SEs4ZlZacHdvanpLVFRC?=
 =?utf-8?B?SDNaS1NBZEtHMDlJdFczOUYwellxOTl2aHIzN3lLTy9acHpPZGl0KzNtMVRh?=
 =?utf-8?B?RVZYa245T09DbXFKY3MwTUp0Z05tZFVaRXEyRlFwTnRPRkhyNnJ6WTRNc3I0?=
 =?utf-8?B?bXNUei96NWxDd2dVbGlQLzFaYVQ4SHpWVmxVZ2EwdFhqbCtsNFdob1NCdjFa?=
 =?utf-8?B?REYwbDkxRXdUcjdnNS9UV2t6K29iOUZjdHNzTlFoa0RDejJ6RWJvMklpYUFv?=
 =?utf-8?B?eTFyK0cxQnpEemNrd2lqVFBIaTd2RXhTWGRoUlVLTDlpVTVsVUJhTUpwYjk2?=
 =?utf-8?B?cTVQdlN1SzFIbVVRKzBTeDNJVHRuQkhQK3diL052UEYrSEtpTngwakNFR3k5?=
 =?utf-8?B?RmJPK3N3eVpTc3g1WEFyQ1FwVThKYlUrQmJjTk5VNWZwREhNaDh1VmhEZHdR?=
 =?utf-8?Q?An13z+p47w+1R3PlTYbxNyWJYonPlTukS/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676b2133-6917-4228-636a-08d8be21ad2f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 15:31:52.4426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojdFN/cgbSIpefcXBa3wpjv6ZXXpvElm/ouz/4oKkiuLCrA+XBQzI+3rZIMZkgdG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0167
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 8:23 AM, Paolo Bonzini wrote:
> On 21/01/21 15:04, Maxim Levitsky wrote:
>>> +int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu, int
>>> emulation_type,
>>> +                    void *insn, int insn_len)
>> Isn't the name of this function wrong? This function decodes the
>> instruction.
>> So I would expect something like x86_decode_instruction.
>>
> 
> Yes, that or x86_decode_emulated_instruction.

I was debating about it while making the change. I will update it to new
name in v3.

> 
> Paolo
> 
