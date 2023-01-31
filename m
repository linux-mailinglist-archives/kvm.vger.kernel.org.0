Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012CD6838FA
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 23:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjAaWA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 17:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjAaWA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 17:00:56 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7F14FAE4;
        Tue, 31 Jan 2023 14:00:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRjWwHmSZhqLUMU7EC9sC6kQGxdancMUgXj5mk/aZuWnTideWyA++AN0D9dmxJ7Py4soobA588vh2hJLYT6g+UIU2E9i7FiA0RrV/NlBpaEJ3MF//EnjIprIEiqVq7rimLcJ0LqtfvbW60FgKIGc1wlRVqNwMQz/2yxrMF0r9gZZwjBracpMDlr3nIuTY5vT1AJ3njjXXaKtj3go+gu/8Kl4W3p3lyieZxMkgxWlP6YafPxtKR6fgiLYTuJuWbap5jTui4xDaKqmTkv5s5pU14gz6BIUqLWHvIR0yHiqCk8+hbd9Ixm4gsowaGefAwKW82Dlbq1TSoCUe0sor/7srg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dsVyyYs0e5NyYf3dAMOlv0j3RXmAL7O8D4n09s61MLY=;
 b=mj3kb2s/0RsXUwmrRzyhtkRR4IBVw91zANlA89wAy1gWGT/ZHCSrQ2Ua+lg6jJJE7csdnZwWz/FBSsgeLJR3Dv6l7F+I3/0sGcRaXfCpWvcUoSaviAPFX4Xwt8q/jqnntvkit7P0UPtL/OC9ZsiwRUoCCKSc5/F87QXNK7PAq2qV/45TbWTidLeVHWiAEogxchT8fcv2NTpNNFYTx1ti/qWqiQwTxskvSsoyWVXo0VjpE3Rd7KYEZXZPU+pJCWM0pr+vNoHBcWA7aBCfCjp+gE4sKJ3dTkmVV63P2XXoaBUC1w8tRQCRSNQUqyKdGPbYMfm+WKsG8/QAcHnEtH0reg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsVyyYs0e5NyYf3dAMOlv0j3RXmAL7O8D4n09s61MLY=;
 b=3ixcV8BFXl0YDBe6rv4Jmhxnv5Au8in0AFC2G9T20m4uY/Bf1hhajbrtVIrM/2IWmueSD2xAS8HOasCPEnkGes1utF9qRcPwqHclikY+x3HQJhNl90lw24tGxj2jjGpMSQ7W/+sSP+rbP2h9+LdBRQFTQnGC0rOzfn1jGs+EUdo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 22:00:53 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 22:00:53 +0000
Message-ID: <4c642bd1-5f1c-292e-398f-eed699db590d@amd.com>
Date:   Wed, 1 Feb 2023 09:00:30 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
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
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <682c0bf9-ccf7-9660-21fe-925ef63c5fbb@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0152.ausprd01.prod.outlook.com
 (2603:10c6:10:d::20) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|IA0PR12MB8301:EE_
X-MS-Office365-Filtering-Correlation-Id: eef611a4-3402-43e4-cf76-08db03d69ebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7GaFX+FatlI/v2eZpaRb6J1Q4S1tZVPZLnjVwzgEHIsErz4nm3BoozMLtxOld6p0ff3+X9Ux8ty2ghh30m0Pug7kl0gxJwkrZNJXOds4BT+myWgGT/i8eeVEyANazcTRLxD45CxE2jM924MgOD4K1EYHVE8WUHoPFF6bc5LOKiC9JkeibT7SWVkLY13i/XmqrtAfcE/LxI55Evcu/mSe8KRd98uLYYe/bx2+3L3ZBDjdJlMZO1ftkAXLCS7bNEZdU/7BUo1YQWkzBnUvq5kcAenm5oSAjRzJL6Ek01Twuk/rQ26JKMs25RBLoYaTzYg6j3uo63Srxj+7Kvn5Z/O2vU+X3v3pQc8a+njIcpD+ySk5+cPCsDMasOHHOmp2T7u7+LOOZYAe2QeoTpIOgBhQfl3SIOi/E7jwBdXki0yr2Iuywh+hAz2z+IfVLhTTX2Cy+Hk1MnUIXzZNKLtT9WN2uKQ4wtZMLhq0hdAt64vc1gRJrrDT8kOOfKfSO5pMg+WkCEQVFbyLdUi9XalmHhO/OiQdfJyJt084DQPw2PiRMVTUyUvNShE7Yn+Csi+4UnpwujNCgyVx4nb5wNIiuUf8Vbdh3yNlj/UY6Po61Y10t7bgtiPhAc63wZ6fYfeIgNLYxFXTeLbKWCDFt0k6QlIejPcTHHChDtaK2rgKRcWc4w2OgN6z6B7XTHYTYjaEouGBUBB0HX83YoeKVOiyCRXpLyx2YQQkJPoloL3ZH4J0nI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199018)(41300700001)(38100700002)(316002)(8936002)(2616005)(110136005)(7416002)(7406005)(31696002)(5660300002)(2906002)(36756003)(83380400001)(53546011)(4326008)(6506007)(6486002)(6512007)(478600001)(186003)(6666004)(26005)(31686004)(66556008)(8676002)(66946007)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0ovcnAxS2ZCRWlxOExmQVBTZjB2SCtyWkdjS0pZTXVsMGRUVys1aEhrVmNl?=
 =?utf-8?B?ZzBac2FYYko5LyticHYrS3FzSDYyRkwwMVAvOCtiemVhcUhCcnYxZCtnY09j?=
 =?utf-8?B?bVhLc3VWcjdMajFScFVnakovcWViWWcwSE4xUXRreXdiQlBpUFc5TGU0ZTlx?=
 =?utf-8?B?cUcwSjNtc0NGTm94dHpUSm9IcG0vNXdmU2RDNmJwVHlzaEIySnh5dllvSkZn?=
 =?utf-8?B?dndjRHI4eG1lV2FrbVJGYTd3aDk4MHduaXdWcFpwa2FJQldhcTlaV0ZSRERq?=
 =?utf-8?B?V2FSSDNobkl1UGtHMnVtSnVyeUVIWWFDSVZyR2toQ1J6NUF4Ry8xaC8xSmZv?=
 =?utf-8?B?YmNUUHloL0tWSnpNUTgzSmdqWXdOWVZDNzRVWEJCUEc1dGc0bno0eE00SU91?=
 =?utf-8?B?MWc1VTlOVVg0dmFoN3k0ZnFrRDBJVlh4RHVKUFJFU1RXSlNybnZWcWJXditk?=
 =?utf-8?B?UjVYbWVWeDQ0aTNDaTJLN0ZqK0gzd1dXanIrRkJSeCs4eU94WmlZWWMvczMr?=
 =?utf-8?B?ekxpTmVyU2g4ZGR0aXNHTlpQRHpDYms4d0VjcjVhQWVtR0dYUm9uNzM1cE1F?=
 =?utf-8?B?RS9wUS9UdG9LOWdGK05OYWFDZlh5NEp2S0lDVmZGdEQwbG5teW9OTjFFUCtF?=
 =?utf-8?B?a2U3ZWg3MUdPY1lRM3FkakZjZlVtM04xeVM2dnRPSmpFYVpuQjZUUUw2Q2tT?=
 =?utf-8?B?YTVVZGwyTFpCWWpoMVMzMzVSS1R6N0N5Nm5rMFd5TFd5RXg0dEpFSi9Ya2VG?=
 =?utf-8?B?WVlpQ2ZwUjRSTm5YWUJIRk44UTczN3d2VEl0REdkUktaelRvNWE0ZFI3U3gw?=
 =?utf-8?B?SWZaZUlvSUM4ZEhvZEN3dGhIWUhzNmZIT1VubnhlcHBqR2VwY2d4WGlGeW5Q?=
 =?utf-8?B?ME9GbzNWYk1UZ1diTW1KdFk3YTZ0Z0ZFblkwOEMxdzBmV1FGMGlkejVBR3c3?=
 =?utf-8?B?dUVuQjdiRlZIeFRqNkhjNDBrY3MwWnBUUzVuTjBCNjh6c3o5YkVEZS9vbFdR?=
 =?utf-8?B?MXhOM2FMajhnWnJiQWVmelJLNGkydWh1dEJTQ2RWRC9rNzdud1ZxUmtUSHRM?=
 =?utf-8?B?ZW1PRFJKMk8zNGpPSitBZkZQMUZlWU9Ob1Vic0NsbTFGVVpqdlhZWnpuWm9x?=
 =?utf-8?B?TzFQYmYrOUZ1OFlpT3daNGdLK1FlTlkyVTArZEhkRHJjZnZleVZ6ZmZWSFI3?=
 =?utf-8?B?S2JxTWVNODVUaE5vS2pTRVdHSzF3UVdtamtTSXNmSUVyM0IzZjBuODg5MVFJ?=
 =?utf-8?B?WWJSaDBZWnJEQXc0TW5LblVVQ1c3NVlwZEttSWoxMk5VZXEyMlZQbGFtdjl1?=
 =?utf-8?B?T2RSRzhsanpnQ2VURG5MaE54WGI2eTBiU0tnSkpTWXlyQmZyNFBLME55MUdo?=
 =?utf-8?B?TUVCNXNUNHdwRXdJc3RnYi9KY1VLKy94WXNrUlA5ZGNQdnZSZnlhaHVxVndW?=
 =?utf-8?B?L3JGNXY2RkxscldjaVhlcXducUJWdXhrWmRxZDdjRVdFclhEMm85WElubGxk?=
 =?utf-8?B?UDh4SmptT2tXT0JEc1NnVmJnODRMVzdsbi9ORE5DUEUraTFIOURNWFk5M2NL?=
 =?utf-8?B?YmVBU2t1VEwwZEFUUHU0dFhxdFB1cTlDN0xOelFOQ1gvWUdCbWFOWFl1aEVN?=
 =?utf-8?B?dWF4UnJVVW42UStKRElwRnNLWTFOdTVNMkxzKzNBekJHbTVGdzJQOVBsMnFt?=
 =?utf-8?B?UGdKa0dubzlDNGJsUXBNeEdQcmxJSGVhVjczZzFJNVp4YVZPRVRMN1ZPNVQ3?=
 =?utf-8?B?SXRUZzNiUlBnK1k2WXRkZlJuVG9QQ3QvWktsNW00U2JMTEdrdXR2cGhPck9M?=
 =?utf-8?B?S1VmVVo0WGU0OHE2cU1uc0J4cUdYdHZ6WlRLWjMrazJtbWxzUkt1SzdIbkIv?=
 =?utf-8?B?eDRpNTZqa29NNnJlRzNTUy9ETUJpcWs1UUpSaTAxMHNNUnNkRUx6VU9EeCt0?=
 =?utf-8?B?Ni9yVDhrSWEvRkJhMnhnU3NQRmc0YWR1ODJldFhla0kvZUZGNHc2a0JneEE3?=
 =?utf-8?B?VWJEUC96SDRwbGN4TjhlYkNGZG9qelUrLzA1SDlIczFVMTVSZFhyM0d2L1hN?=
 =?utf-8?B?S0JvR3dMdFdXeHREUWNCME84elVXaXFhek9yei9LeStrYVRkcWdjNVlubWRU?=
 =?utf-8?Q?EtbPbpLsfoDFomdSXG0uq+d/w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef611a4-3402-43e4-cf76-08db03d69ebc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 22:00:52.7396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGJMagJtsEV2Ag0zFjabhHD1ib9xPeZEudN+5SjK9FIZA82cKMh57FE8YgoJ1pcZ2eMWdi26wpl53resfT+RKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8301
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/02/2023 08:21, Tom Lendacky wrote:
> On 1/31/23 14:21, Alexey Kardashevskiy wrote:
>> On 01/02/2023 03:23, Tom Lendacky wrote:
>>> On 1/30/23 19:54, Alexey Kardashevskiy wrote:
>>>> On 11/1/23 13:01, Kalra, Ashish wrote:
>>>>> On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
>>>>>> On 10/1/23 19:33, Kalra, Ashish wrote:
>>>>>>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>>>>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>>>>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>>>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>>>
>>>>>>>>>>> Version 2 of GHCB specification added the support for two SNP 
>>>>>>>>>>> Guest
>>>>>>>>>>> Request Message NAE events. The events allows for an SEV-SNP 
>>>>>>>>>>> guest to
>>>>>>>>>>> make request to the SEV-SNP firmware through hypervisor using 
>>>>>>>>>>> the
>>>>>>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware 
>>>>>>>>>>> specification.
>>>>>>>>>>>
>>>>>>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST 
>>>>>>>>>>> with the
>>>>>>>>>>> difference of an additional certificate blob that can be 
>>>>>>>>>>> passed through
>>>>>>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP 
>>>>>>>>>>> driver
>>>>>>>>>>> provides snp_guest_ext_guest_request() that is used by the 
>>>>>>>>>>> KVM to get
>>>>>>>>>>> both the report and certificate data at once.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>>>>>>> ---
> 
>>>>
>>>> And GET ioctls() return what SET passed on (not something the 
>>>> firware returned, for example), what is ever going to call SET? The 
>>>> userspace can 
>>>
>>> As stated above, the firmware already has the information needed to 
>>> sign the attestation report. The SET IOCTL is used to supply the 
>>> certficates to the guest for validation of the attestation report.
>>
>>
>> Does the firmware have to have all certificates beforehand? How does 
>> the firmware choose which certificate to use for a specific VM, or 
>> just signs all reports with all certificates it knows?
> 
>  From the SNP API spec, the firmware uses the VCEK, which is derived 
> from chip-unique secrets, to sign the attestation report.

Does the firmware derive it? How does the guest gets to know it?
(forgive me my ignorance)


> The guest can then use the returned VCEK certificate, the ASK 
> certificate and ARK certificate from the extended guest request to 
> validate the attestation report.

>>
>>
>>> This reduces the traffic and complexity of the guest requesting the 
>>> certficates from the KDS.
>>
>> Guest <-> HV interaction is clear, I am only wondering about HV <-> FW.
> 
> I'm not sure what you mean here. The HV doesn't put the signing key in 
> the firmware, it is derived.


Those ioctls() are in the HV and they take certificates which then get 
sent to the guest but not to the firmware. The firmware signs a report 
with a key and the guest needs another half of it to verify the report. 
Sadly I do not know cryptography enough.



-- 
Alexey
