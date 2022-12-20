Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED11652274
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiLTO0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiLTOZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:25:44 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490422B6;
        Tue, 20 Dec 2022 06:25:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyi3o1PS7mIA89RXFiiIzK5w+ffFgVNg3mfZCCHkCkwDaf6lRJK2X60MeGkoIbXynlL5FkPwoAlvdVvioMm/+IWHVOjwswHqxMV4BhI8DtOApy7IswbNHhrswyjEFzlJVL8rs6Ms+UkFktx86/u9ol723zDT8W9H7VaIp+xx3ihdHHNhg347IMFcNkKHpodJ5BnVkqIMre/aKa3NJObmknngCNzwKIwJ13gTCrcNmKlaxS6aLthR6Kj33UZ1bZl6qhtMUevYStdWpYpdI7NF0pRLkLKb+QrTx5zzusERVe/7sCvOaelx7XRIBQm7RinypkMj6ft1JbpOr6k+wmJdVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyLVYK1ACNNL/d8I4yoGlbQ7565n/pfBygmwD4Ez06Y=;
 b=mReX5ISsc47NIjnN7yM/f3pTg1Upf1CvxYrQSJCDWGNUiLkx72CuWFV/BeUQd6FIM1h9nMfNrcMXzxhYuU66KiDPLfZSYX6ghL34apC3GzjOiRNZl7J2WKacb9ylV9dO2s6WEnDf8it4BLuBXCszOqw40Fn9PA5HMWS18N3cEcEW09dqpcR2psVdYS31Z3Fgc31cKQAlZDRDyrJYZXMHlb4oro8bUo/cNsif8e2dgTqYIcXJ/vlKg5Hsfk1f6MYK/qIjf18DDAjf8GFDJd4XmPZ+eR8AP/VmyIrJKfxljrZfnHuw5BtAoMqG5nqpmShaEvYbFG0CMo8uiUsiI0afNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyLVYK1ACNNL/d8I4yoGlbQ7565n/pfBygmwD4Ez06Y=;
 b=ZSCqLdSjknR0d02plyN9oGEUWMg4uImhhDpYFZSqf/7TzqrpUnnPihRV+qHBcLlMxbDDoQSTzuZCWSB+dsEepf6Wz7IOv7s6PodK+FqVOvbQNXIO+XGDhsB0VYU50S8EzKLWUsRNRXeEI5PDqjwuuh8HoSim5ALtAu1qy1l6h5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH8PR12MB6674.namprd12.prod.outlook.com (2603:10b6:510:1c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 14:25:38 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 14:25:38 +0000
Message-ID: <8b925a6c-bc0b-7ae8-ef4a-da8651fbc182@amd.com>
Date:   Tue, 20 Dec 2022 08:25:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 40/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-41-michael.roth@amd.com>
 <272cf383-f97f-805c-fd70-1ec14e756523@amd.com>
 <5e27ed72-2cb0-0bdd-3234-58ff75cf7d44@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <5e27ed72-2cb0-0bdd-3234-58ff75cf7d44@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0121.namprd05.prod.outlook.com
 (2603:10b6:803:42::38) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH8PR12MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 75027962-b357-4e8c-cf41-08dae29610c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6C5Vcbk54wOwGFY2IuLzqiPnBfJr5UjYNy9mn4vrlUBlEfj5uqAHIt/awi/Y/tNN1tXwoPXzC0WUCFcCge2GFrU/g1f0RiGZd6dDqilKO/13XP+IOEpQOgG+hbvy6fEftU6N8PIV4a4IdalR0nR3ujfXjBUNPgjNrgPXSavoEid+zsiJ8yXH4JaxVUKu5v2DdWrhX/Zpze01AYan9zGc3WmeMLz3PGy7HQ5i0V0fVmzm37qheUV6VyG6kSgEVauePwMjR4VsqJlsRmPuJ4Kv2xTxcL53tLZ2RZiAI8fzMf1+kWi3tMGZlsxYLG/uSI9SL2jFPKbQuHs66fXSMyLhh2wrdP+S0qfeDMqL3gdkLDmrOt//dUKFeKD+1Y+xzg4HJ7uSZ53anJ0GXJQ1RxUCcAYMCrQ3Tlnpbjdzpujl7/GHLtbT2sgSriJdC8E2+uwrp+HSx8iKezUTBpxDkIVpjM3qvIOiTAeNRTNsYL/sp60TrxkvYROnB45AQ6fkw3jibBnphWO357P1mubKIJ9l/bXX5zeJFrRPIkf1a3e/MEcIyeHPqTKkfP+bRHhJ0Bx3xK0K2HiWydUotbHW6ppdnuiqIR4kpeMxHhHnyZciSyHDPrMkFiciXTKwngNMgn+ps2+LYZwmA/QdA9esScdE2zhKNr3t/TpCtiUEalNLDEasYBXu7jbeXa/N7Th1u5FHnAuGW0bHts5At6E132cUkwZOqeUDEie0BjZ9VmgweeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(38100700002)(53546011)(6506007)(186003)(6512007)(26005)(2616005)(478600001)(6486002)(6666004)(83380400001)(36756003)(31686004)(2906002)(8936002)(41300700001)(316002)(110136005)(66946007)(31696002)(66556008)(86362001)(66476007)(5660300002)(4326008)(7406005)(7416002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTduU29NRHlqRlJSOXBESjlQTElzMmU1M3dHM0lNT2lvZnczNnVZZzR0Wllp?=
 =?utf-8?B?QUhDWTNFOGZKNzFuVVFQRHpBN09EYTlnZE5DNlBvVHBmUlRpZ3RHV0tqVUVT?=
 =?utf-8?B?UEFuQ2s5NmlLNVk1TGdCMVI1TGFjZlVVN0Nvam85Q0hlZXI5WnpMaUkvbVRz?=
 =?utf-8?B?Yk81aTRKcXJ4U21XMEZVWnlucUlxbG5rVzQ3aGdKbjJkOUVFL3o5Sll2cGVs?=
 =?utf-8?B?NmhDMzFHMDJ0R3drWGJZU0hibHF3U0E2aW01NXkyNTJRV2w3ckNxVVlQNHJh?=
 =?utf-8?B?WldybHZsN1E0MEE3MGZwMXZ3OXpyRm9XbWlpZjJFZ2luYWI1NnVzQTNBZkla?=
 =?utf-8?B?eDRXY2htcVAyb2ZoK2ZNR3ltYUQ2RkwxZ0s3VUM2U2grcUJ2NUo0TldJWDNL?=
 =?utf-8?B?U0NKY0g1NDN6UnMvbSswUVdNejQxSm5CSHUvWTlzajNJM1FkV2RkQWxsZDhi?=
 =?utf-8?B?L09lRzVnRDR6Unlva3YrbGFFVzV1dFdBWVRIcFR6bER1TjU5WjhwSS9VcEdt?=
 =?utf-8?B?dUt5RWZkR0o0S2pTSWE3QlVrT2orenhtdGtsWUJmZXkxZW1YVnkydzA1UStR?=
 =?utf-8?B?R3lSbjF0dC83UkkzNjVHZ1dDeWo3V214S0NrQXQ2Q2hMNmFOcHZYQ1c4RUVk?=
 =?utf-8?B?eUFqWk0vcUovN3EvUlZVSmpXMEc3ZGNka2pyYmtZR3ZKUjJDTmFXMGRub3ls?=
 =?utf-8?B?VndvZVBjOFRjSjNGMFB6eHV3TXE2R240YTVkVmJwZDFkODJUUWhkbHJ1NTlN?=
 =?utf-8?B?WlhMMUhGd0xSVmswTUMrbysyaTRIYlQ5czJaNlJUR0NXWG5FYWNVNnUrME9w?=
 =?utf-8?B?WlRkMURENlJ0TVN0eVBlZmlYYVY0d215Y3hDMnkreEpLSnhsTmhaaUQ4WnNL?=
 =?utf-8?B?QS83ZEhSMS9QM0xmc3lrSDBDQm1raThVKzduVzlVWVJITi9GMStTVHFnQVlj?=
 =?utf-8?B?NnIvaDBXVmxWdDB0NURKSHd4VTVJT1NXblZNelhKeDF4MFVWWklGb2NmbnNB?=
 =?utf-8?B?bE5tTk9hWW9QS1k5U1BqZTJOUlhEb2FtaG4rS29BOUdPaHY3R2RuSGRhcUx6?=
 =?utf-8?B?UFFDVW8ySWpoV3J4S1VIOEljbXdONko3aWpDRVpZWGg1NDMxTG9lUHY5T1ow?=
 =?utf-8?B?QWtFdHNuRjNoMXhnM0l3S2J6NHkrVmNDc1RvOWUyNEkxZUh6WEszNWJwVGNH?=
 =?utf-8?B?aUVoSDNjb3dYRmdseWhRTjZya0tBUmFGVmd5b08yUUdOSlFFczZtVXdkWGRH?=
 =?utf-8?B?d1YvZ2ErOXQ1Zk9nWmUxeHJCR0hKaHBRbXdvV1hpc2JXZUNJYXIzN1p5NDBG?=
 =?utf-8?B?cjU0dUdTOTU2NVJ0bGpXN2FuOWNjcGFDVUo3MkV1WXRZUUtLd1pFeWZrZ0tH?=
 =?utf-8?B?OGVwaTQ5dVVVZk9WQkR5K09BSk04SVJvclEyYTRxZUlJYUgrUmhvbTI0UVUx?=
 =?utf-8?B?NUVDdEYyS3JMdVpFdUhDUklmODRWQXMrb0pBUEI3YUJIRHlXZWhkVHNlVURF?=
 =?utf-8?B?TWh2dHRiTC85MWlzdTk5OXdNVTl4K3VnTnF3RkFhdjlSZFdkMUZ4MWU5Vkth?=
 =?utf-8?B?ZWhHY1hFaDBxTEN4N2JvZitVT3hrbkFuOFlKOHFVL2lEU1prWTZoSGYydHVx?=
 =?utf-8?B?eVc4TnRuMDJRaWxLWm9FdGZ4WWJ4aG9qUnB4SnY1WEo0SFl1MEF5dEx2T1ND?=
 =?utf-8?B?N3hJT1BnVjVpazZvZkZmaGpicXJoeHJ6OFdxSE5GSVVvdmVjQ0lEcWIvQXMr?=
 =?utf-8?B?U3ZXaU52TC82VnpSbXpXam93NldBazdXVGtSblkyQTdCTDNhTS80K0tsWUx0?=
 =?utf-8?B?QTRTbUpRSkJCN3pGaFFmb3JJWGJacURQTTlTQ1JrL09RYmdyVFVmS0wwc2o4?=
 =?utf-8?B?TVBjOHJGYXF3UnlrRWtZY0UxKzBOVk5xZUFkY2FqWmxWd1FOR1pwOHpkT0Rs?=
 =?utf-8?B?Y1kyN0dEdzkyRUFNb2ltMnRucjZ1VEVqRjFsNjF1Y2pwdFcyTmo1ek9CSHYy?=
 =?utf-8?B?bGQrTEpaemEwc3I2M3prRXVCcmVSUkx0TmNTSTMxSmNNa3pQajA4OW1FbFM1?=
 =?utf-8?B?YmpTL3VxR3NLRXNFZ1lTL3BnZUJCTktpV3ZqN09nalU2SVNiajR3TGhHcGl3?=
 =?utf-8?Q?lNPUE3dna7O1JZSv5rPiz2Wjt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75027962-b357-4e8c-cf41-08dae29610c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 14:25:38.3972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVO+7t7PdClB9m8t6HYXr4Z/TDkN0hjcH4SDiQFSUeC/0aH79eDHW4i64KF0uN0+OmPkalbXXhOLYlFBWGm48w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6674
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/19/22 17:24, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 12/19/2022 12:04 PM, Tom Lendacky wrote:
>> On 12/14/22 13:40, Michael Roth wrote:
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
>>> it as the measurement of the guest at launch.
>>>
>>> While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
>>> to encrypt the VMSA pages.
>>>
>>> If its an SNP guest, then VMSA was added in the RMP entry as
>>> a guest owned page and also removed from the kernel direct map
>>> so flush it later after it is transitioned back to hypervisor
>>> state and restored in the direct map.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Harald Hoyer <harald@profian.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> ---
>>>   .../virt/kvm/x86/amd-memory-encryption.rst    |  22 ++++
>>>   arch/x86/kvm/svm/sev.c                        | 119 ++++++++++++++++++
>>>   include/uapi/linux/kvm.h                      |  14 +++
>>>   3 files changed, 155 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst 
>>> b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>>> index c94be8e6d657..e4b42aaab1de 100644
>>> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>>> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
>>> @@ -513,6 +513,28 @@ Returns: 0 on success, -negative on error
>>>   See the SEV-SNP spec for further details on how to build the VMPL 
>>> permission
>>>   mask and page type.
>>> +21. KVM_SNP_LAUNCH_FINISH
>>> +-------------------------
>>> +
>>> +After completion of the SNP guest launch flow, the 
>>> KVM_SNP_LAUNCH_FINISH command can be
>>> +issued to make the guest ready for the execution.
>>> +
>>> +Parameters (in): struct kvm_sev_snp_launch_finish
>>> +
>>> +Returns: 0 on success, -negative on error
>>> +
>>> +::
>>> +
>>> +        struct kvm_sev_snp_launch_finish {
>>> +                __u64 id_block_uaddr;
>>> +                __u64 id_auth_uaddr;
>>> +                __u8 id_block_en;
>>> +                __u8 auth_key_en;
>>> +                __u8 host_data[32];
>>
>> This is missing the 6 bytes of padding at the end of the struct.
>>
> 
> Yes will fix this, the documentation is missing that, the structure 
> defination in include/uapi/linux/kvm.h includes it.
> 
> But why do we need this padding ?
> 

I'm assuming it was added so that any new elements added would be aligned 
on an 8 byte boundary (should the next element added be a __u64). I don't 
think that it is truly needed right now, though.

Thanks,
Tom
