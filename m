Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCA06ABD9F
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 12:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCFLC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 06:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCFLCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 06:02:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43320579;
        Mon,  6 Mar 2023 03:02:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsiigN4c4PlIn2sdbfkrH9fxqGFSLFIICSGwMzG9YXOa7oiUrCMpMXFZ7g6XysNpjDDFLM7aq+ZSDXkE4XV4ptoD6gsYOL/IDtDUj5AV0nCNwS471ihHPgIpvb+wPd0kvL2FAbOA/eGH7MIZI6OpXLNL7C/Cfvio/bkuPwflqqg4YTtNE4aT8TP918VYjXxkSKbSigKlZgM+rTbimE/4bVmfZA3wPSC+Ivw+u9KY0PWNWmZA3rY8Xqrw2CqC4GSNTDGiv1FcFkGiQsrCpblhIl1WnGM7vk1NXS09b9yv4FlStLOoPTf+SZOMjQ/6Tt5wrfsub3YT7KEDh5RggaLfSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRWhJejFxr4siLbRxlJkp1XMBBpTKIANuj/WOhHlhl0=;
 b=gRBcP/gSTMwlj62peRMmOqVoXhu99M4dWAcrjB8YvW3/lrahwQ1Cxmmlkf7R0ogtWWGHN4fcVqNH9oCL4jb0vQLxskMFQ8G6LJuGDPUFMo70rgsB4JwJ6WXEZMmGLtfiTSYBpK5zi5H468QFixondS60eLpbPuLhOZNwWnx5iKC3GwoKh6MQ0rpxKxQLwqV/Sl6AaPiQKqY+T5EJQmBmJSWgQNzFLY9CTEyJzFLImMubKpAJ9Vdlc7amTi2aDY4W0U+WR4sZ0WgYgT2jHnT2flABkQidt82D3vzBj9MIU9QJ5UbpLQ68XXj6I7laYdnHlAObY97j0TYMUaEj1w2G7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRWhJejFxr4siLbRxlJkp1XMBBpTKIANuj/WOhHlhl0=;
 b=N9Pj3RynjiewmnW7FvgUxyERPptLTCwGvkmwxgyz5hQNsX2+K8nCyiZGPCHzRMpt+UxV5z2cZ2ztPRJLkEdgIYBQPT2fjjm1ZX2h1Z/Ao/00vJl0uxKUo9gv9b80ACG0A69o0j4misKmCFZO8gEx5rlZwpUJVqBNoZLDm01wB54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL3PR12MB6378.namprd12.prod.outlook.com (2603:10b6:208:3b1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.27; Mon, 6 Mar 2023 11:02:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6c34:2aaf:bf7:c349]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6c34:2aaf:bf7:c349%8]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 11:02:20 +0000
Message-ID: <32f6e47e-453d-3f8b-84b0-a9b7590cd19e@amd.com>
Date:   Mon, 6 Mar 2023 16:31:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v8 08/56] KVM: SEV: Rename sev_{pin,unpin}_memory
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-9-michael.roth@amd.com>
 <86906f29-9853-6e18-6e03-7b689088ed5d@suse.cz>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <86906f29-9853-6e18-6e03-7b689088ed5d@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0227.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL3PR12MB6378:EE_
X-MS-Office365-Filtering-Correlation-Id: c5d5d64c-f626-4625-1f17-08db1e32417c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWI1k6jDNbwZ6Ty+28lQShuAovW3wbQcQyNLeSSr+K3JvErhaPwASb/+51jEXxDbC5N2bJEZ3tXjcc58oJppS/NOWHiX9Yp8mdd6dWo0EtujZ6fef4a+s+Mci5K8XjsxqvAlf2TizMz7VjSlv6hEFlFP84ekxJHD+0i4E9EVwKyI+7blPpc8akfsfSmFTqJJGzdJqWDdL8rmkK/XC7B7z7hg/t2ifiibc1XXXqdUAJaSZZZONIxfSHr8wyV6Xn2cx0FJP8GO8FEfpcYD9H6oZxoZxnXI+UC8Nj7RnaVfpJZgvA0fYQhWqbi8C9tiQSzZEJEJWy7oOIeJWYCke7xsnzDA3U9/ogeEIr6WRw7kF/yeQHL3/EYri5NhQbk7PDOMt+iZ9IsDlOgggCqHKS7Y0cJdnhuL6Qx6vdiayc1d66/+1wkkdS19DZeaLCLsw7oSHH6rxtaJSuEHFGFgQxNJyzmdl5IfBARXSEK0Im3HpaNjIDjiIlAT7kRaXskXv8p5EnRxTe7hYtxsn1YSOhQn5nJSIJxofPvhHGpoErHIoUnwpcO3qXrF2028mJCO8pbPDieuWTZ6WWZwOVGIA610AqbQqjbaPpkmNWkRNY2pENTnv8F74/W3CFzg+CtSgQ7POqeXNW6lcPGOXbS+GlzuXnQcSgs+gGaAXwXanqCcZvq7bc8xlmw+UgSPXly04uywPu4vKHvkUJ1XTeVaXD0Bj7CIIjiN1JWfh6C81Y8lg+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(4744005)(7416002)(7406005)(5660300002)(41300700001)(8936002)(2616005)(2906002)(478600001)(6486002)(110136005)(186003)(66476007)(26005)(316002)(6512007)(66946007)(6506007)(6666004)(8676002)(53546011)(66556008)(4326008)(38100700002)(36756003)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHBVeEx5SXlUeFgvRWM3RjQzdkY1OERWRXUzQUd0WUJya1JxQ3F0NUs2NlZa?=
 =?utf-8?B?MDRrM3krSityNjdqMzBiZllKU2hmWEQrQlBmSFlzWEJjY21rejlacU5JdU9G?=
 =?utf-8?B?TzhsMUVnMnlKeHZvaWpBWklvRkRGMXR2MWVSeDZxUWpibWowa0YvNTg4NFpS?=
 =?utf-8?B?NjNJUWNiUi9TcHVRVWdzbTNIWlRCdlpxcWpmcmRSVmQ2TmlMckN5ZGUvOGkw?=
 =?utf-8?B?d1F1VTNodUNBajhnNEpKOWZOVGZiR3NMbExLeHlzT0M4YXVLNnMvamoxL01F?=
 =?utf-8?B?QWpRMmc4K1A4eUFNT1IwT0JReWN3TVZUSGd2aDBmOWxDVUMvL24zcWU1Q1dX?=
 =?utf-8?B?dWgrTkNJdmdVeG5laTRWRTBXNFZsRmtkbTZYUkJZQlIwTVZqdHd1ZVRJaUhD?=
 =?utf-8?B?ZXhTMVdwTVVvT3VMaS9iTnBLTGVPV1p1ZXJpUUxHL2lFd0hyVEJLbVdYVTIz?=
 =?utf-8?B?dUZFUEg3dk0vcGJ5ZzZUdS9ydlF3a3I0NGZIR2lod0E4TDVMT1JYelVSOVAv?=
 =?utf-8?B?L2V6VjdxWDdtY0RZT2hlblcydHJzcUh2cm95UlNEN296K1dwL09hTjBrRTNi?=
 =?utf-8?B?Y1krQm04aEs4RW1oM2xmRFlCZ3VyVXU0TG9XLzBLOEVuV052eTk0ZHNHdnAr?=
 =?utf-8?B?eXU3Zy9SV1o4ZGVOL3NZYkJDS2IwZTRHS0pZZW9TdkJ4d3pReWZKTTVUNDJ0?=
 =?utf-8?B?aTlTbG1tZWFRR2s2SXcyMHV0UFMrb0dpSm0rNEI3OVRLMFRkQmNGemcva0k0?=
 =?utf-8?B?aWFvK1pEaUJBMW1ia1ZpWWpxVDlaL2xESS9XZWszdGtxL1l6cjdLeUFVWUVo?=
 =?utf-8?B?elRxVkwwYVBQZW1rVS9yWnVZN3EzWEdIYk16WjR4MmdqWmx5akxPYU4yVW1D?=
 =?utf-8?B?RjY2TVByVy9BbzlWMWllemJEazhaejhuTXFoYW9uOEVSVTJBR3hQZkFDYmxS?=
 =?utf-8?B?NFZudWVVR2l3OE5qRi80TzhtRUFLVzJscDAva0Q4Mkg0M2ZPa05JRGlWMUoy?=
 =?utf-8?B?b1dOOWVyUk9SQlkyeFpUbHNrOFpINE5NS1FDam9zM0dQNGhPa3FCaHY4OThj?=
 =?utf-8?B?MDNCbkI3VWQ3Z0psbjJ3OVN6dmh5RTVvZ2hvOW1QQzF4eFhJUEhCd213MHc5?=
 =?utf-8?B?LzFva0pJbkUzOXFCTHlSekJvN01JTEQxdno4eGp3Tk54dHhubkhFb2MyTUZ6?=
 =?utf-8?B?eFFmMmRsOVU2VFhiV296YzI4RDRIeUJqbmo5VTlDRWVxc3dNODFqYnVFS1Yv?=
 =?utf-8?B?NWUySS9NemJpRXVjU0h5dmphb25OMm5nVFAvYUFQWUQ5SzVMeHJkelphMFIy?=
 =?utf-8?B?M253N0wxUFN1bngvMEs3czdvMG13bTZHNGF4Y3Joak1IcDJvMVZSRXRJaitJ?=
 =?utf-8?B?b2x0YUV3K0FSTXQ3RUE0aHJsQkt1Uzg5eXl0Nk93dCtYeFltVmpJU2llMWNw?=
 =?utf-8?B?bWZjNUxyVUJXV2k3WTBKV3hpL0hyRGpZWnR3Y2RmZ3BVSjVYOHVQWVBMTFR2?=
 =?utf-8?B?clkzVmxSUGhlVXFPYSt3MkpSbWNaYS9XR1dCSWFkUjdCSlUrR0RQSlFyVStH?=
 =?utf-8?B?YllGR2pwNDRXU25rckFaWk43cHlTS0hCYkpsQVFjYk5lQ1kySklxNXJQdng5?=
 =?utf-8?B?bUpPRS9yK2JHRm1Nc1lNSFJmalpwbFFJaDl4Z0dMUDJTMjA3OCttQWlybUF0?=
 =?utf-8?B?R1ZXUWl4bVVTS05ROGFtWC9FNXZqclI5bEV3eWIraFhkMjEyWWV4UjNpTnc4?=
 =?utf-8?B?TnRMS2kzYTZXN21UYlJ1NWJrdFlrTnhZYTdkNTF6eUQwM2xWU0greFE0ams0?=
 =?utf-8?B?NGRaWlR1T05aejlWTUdHN09iZXNiaS91WlNKZVQxNncxVEJIN3lRZHFCSXpo?=
 =?utf-8?B?RlEyVk5SUWxVNkdzSm1kSk5VdWNXSnptamZrS01sdUh1Wk9ZSSt6aTd2S1d2?=
 =?utf-8?B?dW5Zb0lOOVlFaDZUOEloaXE5UTVQYUo5VmVIM09EM3lKUVlJb2lZY1VwRVRi?=
 =?utf-8?B?VjN3TjBUVzVVSkcyVHJaaTdQY3RtcGlSQ2RxcnRMeHY0OGlTenZCV09xaTVF?=
 =?utf-8?B?SUNQZ1dKcFlFNFg4N2lQYitEKzJvdVhBS2NRUzZURUxyRXNWSTN5TDFURVd3?=
 =?utf-8?Q?5znL+RQLAVw0R3m3QaecMWpCq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d5d64c-f626-4625-1f17-08db1e32417c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 11:02:20.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFvV9s5ypd0RBSe54ZrZkYs/SYJKgh8BSYUiW8f8Px3r/cPUi0GmQ23XnPh+b0IsAcIy+GlND7L5v/c2Aa3AKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03/03/23 19:30, Vlastimil Babka wrote:
> On 2/20/23 19:37, Michael Roth wrote:
>> From: Nikunj A Dadhania <nikunj@amd.com>
>>
>> Rename sev_{pin|unpin}_memory to sev_memory_{get|put}_pages. Apart
>> from pinning the pages, sev_pin_memory also populates the pages array
>> which is used by its callers. SEV guest using restricted memfd do not
>> to pin the memory but will require the pages array to be populated.
> 
>   ^need to?
> 

Sure

Regards,
Nikunj
