Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E571268397C
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjAaWmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjAaWmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:42:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6C81BAC4;
        Tue, 31 Jan 2023 14:42:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWeTk86te0HFWf9yHvEIp5uEoNONrI8a773xFkcOQGSUTHT+H07GnC2CeYS0yIwW1kdjAVgEsm6+5hgkdlOostwktoes2ASbKSnTp4hMJGirfQaDLxv9EDSvvZID5HF1d4aDx/jwS4IQjbzvXlZe/MTi0AFTBD3pKqGiqDXvZZTwDMq7AbUZCT2TUY/aGn++aVNI//px1GBYdWiT4nkZ6731yRPyUSP0S0xWNfQ70L33dRHvVNKRknyvA8Pm4udCED2p1LO/Qn7sXiPq2dsSeuUUq0/UnFYyVwqv6ehzWPm9AJ6jlnwgywdhDQAdrHJsQ6h1YH/pjhUg5URVhte+wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogMc1Or4w7ebrVqasXzFd1ET89kvKakAFQ2scjApBAQ=;
 b=nEBZXaf1xYonyAJbb12F8Loc5k71fuhb9lzOaNyjykyOQmXdNsWqKdmfxqobIswPZWj5tLkFAgNz/SwyjrcYFptUX810IgPWulKUVcYkuIjtSspWrEQ+jMSW52OWeX/t2IRNnHrC240BeeLbIYRxne/xObkmKfSE2o5xSmvsQo4o9UzAEvuSZaL5AHcYZTnuwdSlBw+rkyfkjkUtDKFpCMIK2SkzjPtEF9RxH/Ah/AoDAJYjmw/sA2O99KnZdS51ifzFb3bidLevNbi+tx1QRU3oo+XQhJkrb9dC60FKbm2RoTV0lAXPq/hFTonKGNP/mzwDzOGQgsOJURFO2/R6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogMc1Or4w7ebrVqasXzFd1ET89kvKakAFQ2scjApBAQ=;
 b=OPxLVKJOc+fKcRLA72SEh6tfd97A/EuHQaGFO5uZVYT1PCUtiOyFDiSqIg35z+lvKMYcU9au4/KZo44YV5TiqX0Qx+M8PY3/MFnPl70gEvsHXNJaiapXDGfQOPmcNBLAEXd6CbxNeXhYirT+DxR5ircV6mFW99csU+h9aUE2lpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by LV2PR12MB6016.namprd12.prod.outlook.com (2603:10b6:408:14e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 22:42:21 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 22:42:21 +0000
Message-ID: <65cb8f0f-7e8b-6df6-6bb1-a9f1add027bb@amd.com>
Date:   Tue, 31 Jan 2023 16:42:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>,
        "Kalra, Ashish" <ashish.kalra@amd.com>,
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
 <20221214194056.161492-53-michael.roth@amd.com>
 <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
 <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
 <119075dd-5f3e-a393-f543-6cdfd34cd337@amd.com>
 <385016f9-e948-4f7f-8db3-24a0c0543b3d@amd.com>
 <55e5f02f-4c1f-e6b0-59ba-07abc4d3408f@amd.com>
 <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
 <b0baa6ee-ea6d-3a30-d5fb-3ec395896750@amd.com>
 <dbcb6666-270a-4867-6de7-73812d32fd8c@amd.com>
 <7fb25176-3752-1be3-66d4-a7f5a0e1617a@amd.com>
 <682c0bf9-ccf7-9660-21fe-925ef63c5fbb@amd.com>
 <4c642bd1-5f1c-292e-398f-eed699db590d@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <4c642bd1-5f1c-292e-398f-eed699db590d@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT1P288CA0025.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::38)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|LV2PR12MB6016:EE_
X-MS-Office365-Filtering-Correlation-Id: fc66b041-46cc-4cf2-8b86-08db03dc6a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RC6HTS4moo6hZ+U/NkkDuclgQHJETZbEiF43ulvsaDRnwCEmirgjShPtwtnq+PT/oPnlNImYrSJDsXbciBE6UeJ8vZE+VJw76aLGrLcOnoIgd8whzhiWAY7j4PCrcA/qgMkbXG5VkXh29aEoXy8VoGTY0ONvwB977ugUZ85hzM2PulKJscHCBahfzZF8mpnQ1dnGoI2cvStpBh8Oe/TUICGNPUqqi/biVm+kb6idhCa4ozrmsOQ9AwP/IFb8ZmbSGgRQUuov5ETzr6claijoAI9vLxZqfoiSOazDyz5SRP0qKa5E4267paIDdAdc4+yu60PuhdAtYOLKTH4SOmICJGE6o1MSDHGY4umU0teagv7HUfKesT5jQQGYp7nk2Q6bjcS/pXGAzU8uooVgXZAqSiknBQSahXN7eVqEtZWCK1knT7svS8BNWvHH7jT25c75C0DVeJeHQs8WkQjxyXkGm+TGj90AaK0UAAjtZ4jbxPbWWio9w1+TK7n1k13vvQvaxbxpUmUQJIk+GAw4FQrBVcHt9yfMBPaG9BR40H/LhW2hLwCsDZZ2lDV1xCCcmCPHJjExnjx1UrciyAdwDpTfccpIgOVjHJmJQi0dBd/7ofs9EnRiQqeERRsDGgQsIWGfRg4TEO6JQaVmzr9EYZPd/QSe8mlOvYWDGliid3c/unoB14I2aA+DrR3QD4CF41xXTOXjf18ck6SmZ7Z/GcbkMzPKjVvnfq8F75GMvF8qkUI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(7416002)(7406005)(6486002)(83380400001)(38100700002)(86362001)(31696002)(6512007)(2906002)(36756003)(186003)(6506007)(53546011)(478600001)(26005)(2616005)(6666004)(8676002)(66476007)(66556008)(8936002)(41300700001)(31686004)(66946007)(4326008)(5660300002)(110136005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFlHK25WYVFGWWV0eWN1QWNHSGxNcXVxVktmS0dyK1RGdmlpVWdBelZrYW9H?=
 =?utf-8?B?emQxdFRwRTZwd0JlelNPNnI1NTNKbzNwdEdMbEsyRmJQbGN1cWlMSjhHYlNw?=
 =?utf-8?B?anVVb2cwVGhFNVFvRHRvclVKUGNTRTdLcTlxUzBPeHdqdjFNVHNWMTJBRFhJ?=
 =?utf-8?B?aVJsSHpvbHdLdWt1QzFtSHR5VHVMdWRyYm9TMmM1R1Y0NythNGN4cElQTTdq?=
 =?utf-8?B?Mi9VbDd4anptNHUwS2JEZE8wTUxJV2RYSnkzbEd0ZUx3c0ZwV2V5ZS8zLzEv?=
 =?utf-8?B?aGU3Y21QRFEvbTluVHZLK1VWWmFhMzFYR2g0VHlJdi9WS2JLMFJ4NUZ5U2NH?=
 =?utf-8?B?SDJ4bDRBSm5wc1hwempQS254YzlmUkJLM20vOVF0WUliT0F0cUViMmJ0dEZu?=
 =?utf-8?B?UTROMS9xUGxMaGc3QmJkTDd6cVVaeW9QbmtNbUtLQXRIN0pUNkpTTUpBNjdE?=
 =?utf-8?B?MDNFMDdOZnJiSWdETUl3MFlodkNIVytOcWJuSEovVzBsNDB1ZXZVazg3QUk1?=
 =?utf-8?B?c1VQeWNBb3ltNEN4N1NGVlNUdTV1RnhNaVorMG5vcVhmRnpRUmpWUkpDWGdE?=
 =?utf-8?B?Vm1TOUo1enZyMU95WlNYRVdMTDJNbjBSMG9WVjlaM0RNemdqSitHMXE4RE1M?=
 =?utf-8?B?aHhaRXNDa05oWmV6R0lPbm1aYXluR3lsbWx3TStRb0dzZ3JuZlJnZGZodjV2?=
 =?utf-8?B?RG1OalVDS3M4OUhYbjEyYnUwRHRXTHZPejlSSnpRRGZOd0xoSmpONnRkNGZ2?=
 =?utf-8?B?d2F5eGVFSUZIOFlYU3NtTTl4Ung1Q1VOcHk2OXVIT1lwYXZRRzVnSEhJeDBI?=
 =?utf-8?B?QTY2MWlPa0Uxd01FSEtaY0JLdGRtbHhqVFJvU29MaXRQRUloc0dycktPK2E4?=
 =?utf-8?B?aWRHVy9pRUV3VWQ0M05MSTdYQm8vcHp3eHlCWUlnZnVkSVRUYU1KRDlJbk9Y?=
 =?utf-8?B?MlpiT0ZVUmNIVU1uMWpUSDlpczlxODJKaVJmWTVubDhYaldEVTlZZGJwMnR2?=
 =?utf-8?B?ZEUzNUdSV296ZWVjRlVwYWUvZjZzTWZQTHdSUUtwZkZzZFFia3Jqc09FSXB6?=
 =?utf-8?B?eVh6V0pnNVNiRlZZR2JnMEZqUDVCSUdJWVBTSUdMUm5FZHM1T1JramI0YUtZ?=
 =?utf-8?B?ejJIM2JWUUtWTzdLS3dkTW42TmVWUG9kZU1tb3ZTdnM1NEtZb0tPejNQb0pj?=
 =?utf-8?B?bk4vNFg3Vm9kdW5FTldMN1A4bGpIemlMSXpSOWY4Z0hHYmkxTmNJdWxaK1V4?=
 =?utf-8?B?OGhpbFFUbjFGK2E4UnZ4RjYvUFhSd2U0VzVGTmwrNk10YjdJK3MwZGhucVpP?=
 =?utf-8?B?N2tHRWhHdHVlTnR3MUoxRUUyUVlGbGtBaVJvRGVKZ1VzcjV2L1BxcVROY1Rz?=
 =?utf-8?B?cUdJVUZqbThWQlo5ZFhpbTlqdTJ5cUFVaERKcFhDZ1MzSWpVaXhpbTg5eGRx?=
 =?utf-8?B?cU1HKzBoQUQreUM5ZGtZWkE3RzlVbUhhRmVyNUdSUlJJVG9RMjJuMDNqQXpT?=
 =?utf-8?B?Q1NXZ1hSSm1yNHBsRksrUXB6THNGWkhTM0RFTGJDSkRCNFlTQ1dqK3pjRGNT?=
 =?utf-8?B?TkgzQlRwdm90TnFCcFRWS25RZ2VuL25KUzFqQlJ1UGE3SVJ0VkNWdGR3bWpy?=
 =?utf-8?B?ZitDcjhuNks2VXZIV0VwR29DcG5XcDhvZnFkUjVORWhjdnZkK0hEVFR6S3cr?=
 =?utf-8?B?STZoOERYaGpqWEVsR0hIVjdJUzR2b2NkL0cxalQvK1NPWEhlSUwvQmRQZ0sr?=
 =?utf-8?B?ektxaUpVN2FVU2JYV3ZWc2tJTUhEYzJ5aFZqb29ZZ1R2cVB5Q3Q2UTh6ckFD?=
 =?utf-8?B?RjMxOGt3NTBDMUEyZjRwdmVhTzZOZnJXaXBiNE03SWFSODdKMWFvN1FDZ1dW?=
 =?utf-8?B?OE9LWkE2ZEIva0hsZ01SVnRCVWNXeXJ5U3NoUWticlVaWGt0NUVtbkE3anQy?=
 =?utf-8?B?RllIQ0UxMDQ5WmF0RGhDR0VCSXY3U2FaWEpKOE1EQk5XcEZoRVJiUnQ2UFUx?=
 =?utf-8?B?cThEY1BQcjNjY09JblluYllTYXNyRXBoSEpYSzRmRnFkNlZUaE9oVThYbzIv?=
 =?utf-8?B?K1Vva00rczZSYktTU0p2RGlLN0NXS25pTmJmeWs2M0NCU2U2eXBwWFNySGdG?=
 =?utf-8?Q?geZbg1zg2u6K2reLfv9DXiCHn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc66b041-46cc-4cf2-8b86-08db03dc6a40
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 22:42:21.5391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijCilJqp2Ey7WSMy5gKfOvrcklrqeikRNDJ0EMVRuj/5MrLtMYmolPTpQcKwNiWgccqUN6nOTVjnPvYCJYRi8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6016
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/23 16:00, Alexey Kardashevskiy wrote:
> On 01/02/2023 08:21, Tom Lendacky wrote:
>> On 1/31/23 14:21, Alexey Kardashevskiy wrote:
>>> On 01/02/2023 03:23, Tom Lendacky wrote:
>>>> On 1/30/23 19:54, Alexey Kardashevskiy wrote:
>>>>> On 11/1/23 13:01, Kalra, Ashish wrote:
>>>>>> On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
>>>>>>> On 10/1/23 19:33, Kalra, Ashish wrote:
>>>>>>>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>>>>>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>>>>>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>>>>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>>>>
>>>>>>>>>>>> Version 2 of GHCB specification added the support for two SNP 
>>>>>>>>>>>> Guest
>>>>>>>>>>>> Request Message NAE events. The events allows for an SEV-SNP 
>>>>>>>>>>>> guest to
>>>>>>>>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>>>>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware 
>>>>>>>>>>>> specification.
>>>>>>>>>>>>
>>>>>>>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with 
>>>>>>>>>>>> the
>>>>>>>>>>>> difference of an additional certificate blob that can be 
>>>>>>>>>>>> passed through
>>>>>>>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP 
>>>>>>>>>>>> driver
>>>>>>>>>>>> provides snp_guest_ext_guest_request() that is used by the KVM 
>>>>>>>>>>>> to get
>>>>>>>>>>>> both the report and certificate data at once.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>>>>>>>> ---
>>
>>>>>
>>>>> And GET ioctls() return what SET passed on (not something the firware 
>>>>> returned, for example), what is ever going to call SET? The userspace 
>>>>> can 
>>>>
>>>> As stated above, the firmware already has the information needed to 
>>>> sign the attestation report. The SET IOCTL is used to supply the 
>>>> certficates to the guest for validation of the attestation report.
>>>
>>>
>>> Does the firmware have to have all certificates beforehand? How does 
>>> the firmware choose which certificate to use for a specific VM, or just 
>>> signs all reports with all certificates it knows?
>>
>>  From the SNP API spec, the firmware uses the VCEK, which is derived 
>> from chip-unique secrets, to sign the attestation report.
> 
> Does the firmware derive it? How does the guest gets to know it?
> (forgive me my ignorance)

Yes, the firmware derives the private key. The guest doesn't know the 
private key, it gets the VCEK certificate which has the public key and can 
then validate the attestation report.

> 
> 
>> The guest can then use the returned VCEK certificate, the ASK 
>> certificate and ARK certificate from the extended guest request to 
>> validate the attestation report.
> 
>>>
>>>
>>>> This reduces the traffic and complexity of the guest requesting the 
>>>> certficates from the KDS.
>>>
>>> Guest <-> HV interaction is clear, I am only wondering about HV <-> FW.
>>
>> I'm not sure what you mean here. The HV doesn't put the signing key in 
>> the firmware, it is derived.
> 
> 
> Those ioctls() are in the HV and they take certificates which then get 
> sent to the guest but not to the firmware. The firmware signs a report 
> with a key and the guest needs another half of it to verify the report. 
> Sadly I do not know cryptography enough.

Correct, no need to send the certificates to the firmware. The certs have 
the public key which can be used to verify the report signed with the 
private key.

Thanks,
Tom

> 
> 
> 
