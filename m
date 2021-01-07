Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C3C2EE665
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 20:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbhAGTyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 14:54:31 -0500
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:18399
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbhAGTyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 14:54:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUapxasHYjclLLd23Zrdf08accdTXR7M7JSJ9/iU79I96/0nAJDkpIH/3YAyCHk30CONtwuAx8ZtE7rGEXifXrPI6KPxRQeB94ya2ge6XIUsq3HijEkiNrU7dRnF9dbjbyFX4QMsCtkFo4g+Brrcf12umO+vuI9s+1x3R5DMXXeBm2kcJhSYfdknEx9w5RGXpprow1IjIqIxiJqG0v9jDuBwgN7x1Gk3zlgILHQbsrT50AGBL4oHENXXAXfb0xJ1rQSSN0gWENE9OdPZodAC1kmy1Fm95Iri9c/fbf8LGWn8kiOFvUdvR5WwctHuSdbLalJOKvggDMlS5cfTKadLyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+DrOaovaFtH+Ymm1S57QBRZW6LU4CfJtvFeXnQKGbk=;
 b=J86N7Vx0u/Fh3NHyNSjyPCSZniektkrNd50hIsUd+hPvCeQ2qHsYjGfDWB/QHsrR2nVr5G5998hE3FDlwnq4mdCIyz90seIX60j1KlVp6G84+Se4QXGxjvZy6da5kwgZvvFDmNQI9mU9Wx6u/JpjgudstXIrIwcC7QBPp5PREvNWlSz+8dLT6hlcqBmrY5EM/0yJxthzRgosH/qJG5vPkTOyNZzWKGOrQhqKc15tpIfg5nIt1jnzHisqr7cfTxZg4cV/6souCe8q6TcmJmNi+WInmg2neKrKUX3lEFDpAmq4PhegKz/oDb9RuqwMjSBBEDt9oZeHegHDzaLxUdeEgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+DrOaovaFtH+Ymm1S57QBRZW6LU4CfJtvFeXnQKGbk=;
 b=u2bIiI5/cb+2Np6OhxdQCjUHohhejeX9OaZ9BXcDnR020nXg37wTXHClyl5wRzbSOqaXDcVFDtRIT5vwjhylgoGDZR+lXirEgMSfpRLZapfNTwb7+tWP524IhT3FC6zpt2DurYHpwaUjs9qZK2UghdD4vddT0uHQOJwXJIgjGto=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.23; Thu, 7 Jan 2021 19:53:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 19:53:38 +0000
Subject: Re: [PATCH v5.1 27/34] KVM: SVM: Add support for booting APs in an
 SEV-ES guest
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
 <e8fbebe8eb161ceaabdad7c01a5859a78b424d5e.1609791600.git.thomas.lendacky@amd.com>
 <f7df25ab-0a2c-7295-05c9-dcc6e1878b9c@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e543b262-d5d2-a752-72df-5299919720a3@amd.com>
Date:   Thu, 7 Jan 2021 13:53:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <f7df25ab-0a2c-7295-05c9-dcc6e1878b9c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0401CA0035.namprd04.prod.outlook.com
 (2603:10b6:803:2a::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0401CA0035.namprd04.prod.outlook.com (2603:10b6:803:2a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 19:53:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9892eee5-5dc8-4155-3dde-08d8b345ecf9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB135604A3845F505502D0B159ECAF0@DM5PR12MB1356.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BVJzu0W7DrvSVhOWqcT+xJgNe525WYrhTXgj4Kc+VAsHpkgwnDViPyfb4RiVK+Pm6DZc3OaYThRLBXAIoXRSMTnkCwQrgIcmUWZ5JG25rmHDv+J4eBEOh2LgvtjTwPQ6M/MNsVokeZj3l7xuXliRRDy78PnnS0RHwXQe0TK7sHfL17u68thziHkrnAYumlB2lRZABREPyEf9SFnem1xcKwSrQmMejJuiTuEUNyvb1f57TurAU5gEtNEExc1JbcBTUmA+QG3mp7BzVU+pvWPPQfoKMgyvjMqMhMj2jJnGbW8+1q6xRL37HT5xjjN4TUaxrWJfo1utgJhdpW1mC2g527nLeuXrZx3TCFNxlmUhg6d65JfEJilnkcviBRFWVhe13oQ54swqn/SNd4Vb3YdbT6gC3H3kgVL0XLscyP6cxek+v4OheZqHBTm9SLsRt6DBSI0iGmca+b/w3E2ImPDWK0id/cx2RsY8IilIhHChfs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(7416002)(2906002)(66946007)(6486002)(54906003)(66556008)(83380400001)(316002)(66476007)(6512007)(6506007)(31696002)(26005)(53546011)(36756003)(31686004)(2616005)(478600001)(956004)(8936002)(16526019)(86362001)(186003)(4326008)(5660300002)(8676002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGtOdjVYY3haM0ZDSGFPbytwN3ZzNzRnWnZkZlJDc2hINm9RSldER2JsWnVx?=
 =?utf-8?B?SUxXZ25JSkRUbFM1SFZ4aU15ZFFFSloxOTdCMTlKUVk0Y3FKZVRacnNNWkJV?=
 =?utf-8?B?bkpFL2tJRDBwT1VnUDBtV0lYRExsWVprc3QzdXNHRkh0SUtMNVRVQ0xYSnBv?=
 =?utf-8?B?QjRtL0dpeDlRbS80Nkh1WE1NZFdSSmFQVkVLVlNzWUIyNXpVNmxqVTZ3Zm55?=
 =?utf-8?B?ckRuOGVkcldQVm5qcjJZRjdvRHY5dUR3M3Via3lSNklMOGhsL1AwZGFWUm5m?=
 =?utf-8?B?UzF0RmJ5NHVJazNrZDhERXFYcnpBLzdremliR2Y2dUFBRTRxMFMreC9FNVdJ?=
 =?utf-8?B?b3N2dTBBc3NxWldqLzNRYWFZT3NLWkhZMVYwaThvbWZBV0RzS250ZVd4TXA5?=
 =?utf-8?B?NGNWcHZQeFEydXBFOFpNaXVFZnk0VzU2L2pqYmFhR04yWGxZSXhoOUc5UVI3?=
 =?utf-8?B?REhiT21xakp0cmtpbTVDeGQ1SFlQOFZVUDd6cHhyRVpTRWladzlPVnovdUFt?=
 =?utf-8?B?RVVjaG5pTFl0RUZqQTZHSllLakNxTlF2Z09xM2VKQS8rYm02YWoreDAzSFls?=
 =?utf-8?B?azhCTGR1emhIMFEydnlqRmtYcTFsTTlpK1NFeXZCeFFxQjF2YkluMERZVGtK?=
 =?utf-8?B?YW9YR3lONE9XT3NoanZBU1ZMTHZ2eVA4cjFiVm1QMXV0R1ozYlFzZndzN3Vm?=
 =?utf-8?B?T3JFSENJWlR4c0VvSW1pWUQzclE1d2tGQ2ZVQTlCY2VVLzBicGdIbGhGaWFP?=
 =?utf-8?B?MTZHVUFVRU1vN1VaTzU4UTR5YlcvYlZRTXhSd3YwQXVZTEJPRjk3UHY0Qlpq?=
 =?utf-8?B?NFNodURwWXkraDMza0lNQ20zQXRmdS9FRWZYcUxrdzZJejdtRU45a2NjaVQ2?=
 =?utf-8?B?ZWNIRXZ1NG4zRjdRODFZZHVLTUVXUk1KcGRFdUZXSGZiSlE5VWh2a1c3c1oz?=
 =?utf-8?B?dmI5dGZDdlJrWnNoNEdvYXArUWNoUkxqMkp4Yi83ZmtKR3ArSFpQWkg3VEJh?=
 =?utf-8?B?SGxadDV1TnUwSmZ4aklCYlNxSVkvOVM1SGpFZUZOTmlOODRpZWFQRzh5R2V6?=
 =?utf-8?B?aFZVK2JLOUw5ODNvSHlCdnNMNnRSdGlqUFRNM0hIYXJ1WFlzdTJYY2VPSklz?=
 =?utf-8?B?QUNFZEtwL3JVdmI2aG9pVzVwWThJV1hNWXdOSEhnSVh2WFJiMERlNTFCSWwv?=
 =?utf-8?B?Q3ZPenQvUyt0VGZ5TkJGdmwwWDdrZWpNRkF3WVJMU1JaM3dkUkt6WW9nWm1K?=
 =?utf-8?B?SnFyL0NaM3VZcUhjN2NtNG9hblVXTjJ2QmtkWDYrMnNucW5DRDJxVHI1b3NH?=
 =?utf-8?Q?ziLB2OICwviCg06+faF2A8sabAOnM053i5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 19:53:38.1428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9892eee5-5dc8-4155-3dde-08d8b345ecf9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCKLvHf4Wm9Kiabjk6eDTjWuzRcG76odTaHQANR+DWYTBkwimoKkFkjcyisKyPBylN56XXUn2piZnXczk/lPsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/21 12:13 PM, Paolo Bonzini wrote:
> On 04/01/21 21:20, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Typically under KVM, an AP is booted using the INIT-SIPI-SIPI sequence,
>> where the guest vCPU register state is updated and then the vCPU is VMRUN
>> to begin execution of the AP. For an SEV-ES guest, this won't work because
>> the guest register state is encrypted.
>>
>> Following the GHCB specification, the hypervisor must not alter the guest
>> register state, so KVM must track an AP/vCPU boot. Should the guest want
>> to park the AP, it must use the AP Reset Hold exit event in place of, for
>> example, a HLT loop.
>>
>> First AP boot (first INIT-SIPI-SIPI sequence):
>>    Execute the AP (vCPU) as it was initialized and measured by the SEV-ES
>>    support. It is up to the guest to transfer control of the AP to the
>>    proper location.
>>
>> Subsequent AP boot:
>>    KVM will expect to receive an AP Reset Hold exit event indicating that
>>    the vCPU is being parked and will require an INIT-SIPI-SIPI sequence to
>>    awaken it. When the AP Reset Hold exit event is received, KVM will place
>>    the vCPU into a simulated HLT mode. Upon receiving the INIT-SIPI-SIPI
>>    sequence, KVM will make the vCPU runnable. It is again up to the guest
>>    to then transfer control of the AP to the proper location.
>>
>>    To differentiate between an actual HLT and an AP Reset Hold, a new MP
>>    state is introduced, KVM_MP_STATE_AP_RESET_HOLD, which the vCPU is
>>    placed in upon receiving the AP Reset Hold exit event. Additionally, to
>>    communicate the AP Reset Hold exit event up to userspace (if needed), a
>>    new exit reason is introduced, KVM_EXIT_AP_RESET_HOLD.
>>
>> A new x86 ops function is introduced, vcpu_deliver_sipi_vector, in order
>> to accomplish AP booting. For VMX, vcpu_deliver_sipi_vector is set to the
>> original SIPI delivery function, kvm_vcpu_deliver_sipi_vector(). SVM adds
>> a new function that, for non SEV-ES guests, invokes the original SIPI
>> delivery function, kvm_vcpu_deliver_sipi_vector(), but for SEV-ES guests,
>> implements the logic above.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Queued, thanks.

Thanks, Paolo!

Tom

> 
> Paolo
> 
