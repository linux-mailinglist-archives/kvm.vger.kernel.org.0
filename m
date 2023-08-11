Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A8778DEC
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbjHKLl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 07:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjHKLlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 07:41:25 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D7426B6;
        Fri, 11 Aug 2023 04:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lrq609FuR0+3mVyxIoYsEnXlacfciKk6USpuU8gd8a+CHZgDDbbtq6XrqPquKxrQLeSUZAu2oRaIIVHpfefo59zGktDBedfOh7NdkE/gCEk3hmHJ1JQcSSKMEtiggpCgvZwckHbt/QOgJvGuyzY8SppDGSnwG+RIVdZMPaqkDEe3O9c+7Bv0mhNxgRajhsHgke2InwzycqivwioE/fYhTB3gycdIvUJNFmffkaVtCeH/7t1KRa5nOEOYVUkFRZk8x5F9+6yis1qG9wnmRRmJuwaQcjv5dgNvkX0ZaGq3SnrQauJOIZV66ck8WqXowVN3Xg7EfT9w40XAdohr6acY4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edl7Ekt9cF+DdsrT7McFI/8yHAKsPMaQOq10es2pUy8=;
 b=ISUaH3so5ERy2oog/57k4ickSxPycIGHXcdZf0iF1dh9R9Nz3wLuS6DBZYeNX8+isJLqFSRyov98nbhbXmDgNgMv+4LAJtzc95oFpxKOqVnYe+21amqjw1ZM4mdhCpoNpG4w8YnfnHCGbX5zWSaMo0hkYpn05SVkXF1UokqkGPRG8vOL2Jt1zQmWMJbjngdZD6mAqFjq0YykOdg801YkVataB/ti7e3lgxBdKxgacibSatSBLCaKbpYWOzIQRd/XvN4qZRwpwGeocWZ2u7YE7Fzgk6EFIX1nJPB7LnhL5uWbkc4VuHKMf+dq2ISqIXpEGBB/iUCXiJeW4S7yTQh5gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edl7Ekt9cF+DdsrT7McFI/8yHAKsPMaQOq10es2pUy8=;
 b=EOIyJzTP8Jcm5D6wId5F7KcxOQquhXVNsvlXe30470J/4+bIicr04ar/VpWlK6FbSJK139G/nsGrytBmSnityxkXY+pBCoS/7aBaKILYCgGIyf+LK3wZo+tO7jXnXMcZpdqnhmKtQzxTqR3096Ukme5FOCo0L+xSazvzPF7+7Do=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by BY5PR12MB4934.namprd12.prod.outlook.com (2603:10b6:a03:1db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.20; Fri, 11 Aug
 2023 11:41:22 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::ee82:d062:ad1f:ddcd]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::ee82:d062:ad1f:ddcd%6]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 11:41:22 +0000
Message-ID: <fed6f74a-244a-ce07-0018-e6c26f594dd3@amd.com>
Date:   Fri, 11 Aug 2023 17:11:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: next-20230809: kvm unittest fail: emulator
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-next@vger.kernel.org
References: <de474347-122d-54cd-eabf-9dcc95ab9eae@amd.com>
 <ZNVopRMWRfBjahB9@google.com>
From:   "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <ZNVopRMWRfBjahB9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0217.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::15) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|BY5PR12MB4934:EE_
X-MS-Office365-Filtering-Correlation-Id: add74a7b-6c2e-4f96-c101-08db9a5fe28a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NABHqsyzDwQnoAviSrfNal2UMeD6gZXRaV07rKCLSDcbj8n2VW8OIzXFBJnD6zXJ37wYauEfTSZQ3R5jG2b0v/VEqO2BxlhRM4i1DSunjKWGI6TiSytwVgm1jP6VGj3YlGBHza2Kh6B3zI5pfspc/5+HxWKNPEooigNToXJEXejSk+Uv2HdAg5apJDuhsSOyeoXBiHu8dl7mMt1lJjJJAxPC8m6QDT5h8ktzLLjr/hOiybdHMnIL5Gpqyc5btQCRkGGPXg5O1K1ofRSub8VGnvU9S+KJTS7gRftCtQvFPbLl4CZ8SK8/hh06hwyz+fuhe2aLyA7dANwkDsO1224Di/R5kst7gftQRiekwWCVpgvhSBRuB4pnTVZ4ZLde+M1D2CtKdvhkLMK+G2sHoLco9Ue7dyswfe5axzhJgfCnszPqbto/DOCAcImXG15IcXUwNJAJgjRHzf18GCGlkWcXiiOdZb1J+fHQFDybSdVY6DN33Dwz2RdG08dcIdbpNDxQ5fb67o4l48m07Hqa33+LF5Y38j5warlxsBssMuTHwLPfwdHgnvxjzMs16j5MTWUz0FxjV6Fdaed5/cEubIZLRkEASGRv6F9vxqoKAOuHf1+r7rfjTn35uUDnylMpmfk01H2zGgMe4/Fiv3bO10CCMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199021)(1800799006)(186006)(6512007)(966005)(478600001)(6666004)(6486002)(6506007)(53546011)(26005)(2616005)(4744005)(2906002)(66946007)(66556008)(5660300002)(66476007)(4326008)(6916009)(8936002)(8676002)(316002)(41300700001)(31696002)(36756003)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2p2Y1lGVlNQL3JJdUUyVUorTHoycm9KUVdmRTNJVWpDM0RuYnpqY3o1UjdK?=
 =?utf-8?B?MS8wN0FRaXkzRTM3Y1B2d0dYWG9qOHlrdlV5VlNtc09ZVHdWMlpCZUlWeXM4?=
 =?utf-8?B?bUdESWkzcEdCUWRORnFmMkQ0MEZmVFl4ZWdvdXQ0dU1zYkt3ZDU0OFN0K0lZ?=
 =?utf-8?B?SVQza3hnL1ZkaDZITEhEdkRiREQ2d0F4RkJDRHJhTEtBa0xuNGNiQlg5SUdE?=
 =?utf-8?B?eWMwTHU2U3RoUlNxUmlGby8xWGt1aG1UTE5GUTgyYUViazhhZlhrRTd0OGsy?=
 =?utf-8?B?RFJxaDNFZFRtRitXUW5XVldwWjdTdUtBSnRLYTlsd0hMNDA0dTFoQXA3YnY0?=
 =?utf-8?B?ZjlHbk1SRTVpOThtOW9KWURqcUp0RWpVd1BqZlNWTHNQRmdLY05zdkw0R2Fx?=
 =?utf-8?B?eDhPb3pVcXNzZWVyMlU3WkFOaDlHbWlmMlhNSnlUdnZvMzFKK2xIdHk0KzlQ?=
 =?utf-8?B?eEVSMEJMa1M0ejNkZCtUSGhGaVlhWHB3ZGpJMklnTmMycG1NK1p5am9wUUlL?=
 =?utf-8?B?OEZHYkc5Qk9pNXpLaGxkL3Y3YVpZOUlKTlVsdHV2TmhiUmpubnN2RFFTNERY?=
 =?utf-8?B?YXNJR0NlNFdsZ2taVnpueU4zdzFDaGZFTElYc3luSCt2THJIcklpb0VnbWdY?=
 =?utf-8?B?dUJCaUFidW1rTHArNlA5a1ZjTjRnVHh2cFNob0ZOamJlZUhIb09IYUV3M2JN?=
 =?utf-8?B?Nmp3eSswWXBEb28wWkV1MndSWmQzRTMybk9BZXlEZElBRkJKOHNidFZ3ZUtH?=
 =?utf-8?B?RVlHWklOS1BETExsMDFhcCtSSk1IcFRncmFiMUJKbUU2dG1DMjI1azVqejQ0?=
 =?utf-8?B?Y3hEYTZMbktZNE5yVXBNUE1xMmNSVzE2dlgwRGlUSUdOOFU2YW1QL0g5RlMz?=
 =?utf-8?B?MWFlOVA0UGtRVVROSG1sQlhWK0xqeWEvYnRIV1ZVc2h4ZEp4ZVBEZkluQVZz?=
 =?utf-8?B?VXNzaitlcyszd1pCZGpucVdNYk9tRzA5cTVoL0l5Rm1HZVh5cnl5ai9YVkpn?=
 =?utf-8?B?em9jOFNENUZQR3RvaTRnZEFaVndrNWU3MlNwVWxESG5QZXpWVDhNekhYRFFG?=
 =?utf-8?B?WEJQSGdGdzVpRWcxK0N2Q00yRFl4OEdYL2t4ZTJvOFNWRTNad2xZV21ScWpk?=
 =?utf-8?B?YUdTS3FqbVcrN0JuNDNIRTVSbG5LQ01LRHpOSENyaUNEWEZQTWxwdTNpYWhW?=
 =?utf-8?B?d1IzRVV3bWV6YUwzQllkbURTaVZTNVpNUkVYMld3Y3F5YWxFNEZZcnFzQXpj?=
 =?utf-8?B?UVN0dVNKSHduSnVUZk11a1RJUEs5WlQ2OFNPSXJvNnllaHV1ampUajVJVk1U?=
 =?utf-8?B?R1ZMZVhZQTVHcWRiYzZzRHE0cEpBRVVpbWF2OEN3dnFIaEhvQjhrTHZRd0Vu?=
 =?utf-8?B?WmRsTWNxUzU4a3lYbFd3N25YclJUSDFEdkZBVk5kSytOR01aKzBvRHZHTWRN?=
 =?utf-8?B?QXFrdHN3V21NR1hia2RQeGJRak5tREdVc0g4Sk9LTmJMY3hCSnNMeU0yWTJQ?=
 =?utf-8?B?a0pSQW5TakNEUVl2QmJkc3MwQmt1ZTdZL2VRVjY0ZFZ1bEFEY0srdGJJaXZZ?=
 =?utf-8?B?aTNCL1hsemt1V1p1QXhURTE4a2xmVzY1am5NQ1VFdXhwcExrTkNVclBMOTFn?=
 =?utf-8?B?RE5ZZHVQQ3ZZMWV1dHdjZUFYMWs1Um1aVEtJMHVUU2c2SVJiMGZVQUVTaER3?=
 =?utf-8?B?N2JxSFVmd25FQ0NuWW5ibGFLQ3Y5bVF0SERLZXExMXk0bnoyVVFlZkp4emNY?=
 =?utf-8?B?YU1mUnB4bXBLdHE0UDhISXBKNUNpb3o4K2pXQklQMUdDVFVVRU5DU1c4S1g1?=
 =?utf-8?B?enVZT1VnY2lSTUZJZjdVVEk3TzI2L3B2U1YxVDNyV2l6bDZlemdBNzNDajJX?=
 =?utf-8?B?YXl0dHZXVGJZNUNFSWxpNElvN2R6ZzBYWk5GaFpDakNzWm1OYk1KVmhXdEpx?=
 =?utf-8?B?dTFBUmN6QmNuTWFsTmFJMTJObVNpYmpzVE9jR0ljWC9hRS84WWtXU2R3NU9V?=
 =?utf-8?B?TksyTmFHTlFSNDRveDNLc3JQZE1iZDdJUGMrTUpNTDBRWDFnc1d0ejBLWVFT?=
 =?utf-8?B?N25wL2o4OFN0Z2l6bEFlQnRFbzVVNVRUWVVCbjJ3LzVtUVJwZTc3M3dnYVBP?=
 =?utf-8?Q?et94lJGqTAruM9r/XESDKV7BU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add74a7b-6c2e-4f96-c101-08db9a5fe28a
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 11:41:22.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dWqBTL+H1Z63vNEkCB6NFVOMgeY8txGuElwbdPMPPzuO/lIkRLr1lqytKw8GIH0Ro2BBeoOEsoA79Uk8a6zwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4934
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/2023 4:15 AM, Sean Christopherson wrote:
> On Thu, Aug 10, 2023, Srikanth Aithal wrote:
>> Hello,
>>
>> On linux-next 20230809 build kvm emulator unittest failed.
>>
>> ===================
>> Recreation steps:
>> ===================
>>
>> 1. git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
>> 2. export QEMU=<location of QEMU binary> I used v8.0.2
>> 3. cd kvm-unit-tests/;./configure;make standalone;tests/emulator
> 
> What hardware are you running on?  I've tested on a variety of hardware, Intel
> and AMD, and haven't observed any problems.
I am running it on Dell PowerEdge r6515. Same tests were passing till 
next-20230808.
