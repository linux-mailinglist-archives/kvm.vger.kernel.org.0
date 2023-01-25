Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1F67B7EF
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 18:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbjAYRJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 12:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbjAYRJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 12:09:05 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA62B59748;
        Wed, 25 Jan 2023 09:08:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wkn/uu9yFWim/vVGbGqDmzvUc+HXmqnTixumBkWqIsNcvxflaGXbd1p1TCq/eyhcyotNFu6OMiZ4XM3T+5UrgsYh3m370WvxDNlUMAP6MNmmqzBYZUBMdlpFUkN8nC+f3kt4wAJvkPBkVTPS2/WF108UyaX+lnW09nuGcPPI5VSnGrJ3+/NUNbQzYuWpUCPJbZnmDw9iQyg1zZ7B/g7Efbq7IDsgxgo4KpiRM4SKDt11yw+sv+CB43ZLboZ6WfEB+xiavPR+pB7/IddlyRlwFgSsC5Wfi0TSHs67S/JlJYJ4y1H7nlDu3B7ULhOeVsN9kCiSkc+EwAZU4O0YYM5L9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+kSdQMt27Yg0S94yrtOauRvEVbBge+NkYY0JHPaSTE=;
 b=gSMaz7TikotsAd1+jLCtv61OYHKxG2Eh1bwlDGvGJcv8MCcFDGA7IYcgikMJOernk0KpF3Fak8+ElNKtZDBDYu+t7paGiOCL5YDTs6QWJoWWBRWz/iq/R3J3B3CUhVg93Mhnp07q0FFadkXondKo/jT9Njzhkk5gPgcDmTe3QQA/lSxI4pSdBrQAlRh4r/aXbRyvYTZUK8w8/FGMcwplJSh/cheCoFM3qU4TTOa9yGYWCX1RKHWm+Uysqe5L6bgsH8G8vgNxIegmZ7mJAqHriQ+pJEcKAHM+ZEWJ9vK8z1scyrfXkIV/XwN3b9YW45Y6OGj/nRzCkuHHXl/LSKfacQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+kSdQMt27Yg0S94yrtOauRvEVbBge+NkYY0JHPaSTE=;
 b=i2rLFP8gPW0KwToj0KfTrFM7BnS4b4T/yG+8jsTRewKMppXKd+VBKtfu6nJKmZWOmOwIsTaU/Ye5IcRvFwJSkEKtoTdfyH4BMuDYKsAEskmGODkR5PzcJAQb55MEh6QZ5a+Mkx0/MJvNdWPfEYAupmS44ON/yHbjq9fqV7kxAMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 17:07:31 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::cb0c:2b31:6f3f:12a6]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::cb0c:2b31:6f3f:12a6%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 17:07:31 +0000
Message-ID: <14db7a0b-b993-8d51-da94-893a2975f7ac@amd.com>
Date:   Wed, 25 Jan 2023 11:07:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com
References: <20221012203910.204793-1-john.allen@amd.com>
 <Y9B97dZnFnjEHhVf@google.com>
Content-Language: en-US
From:   John Allen <john.allen@amd.com>
In-Reply-To: <Y9B97dZnFnjEHhVf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: QB1P288CA0004.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c00:2d::17) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|BY5PR12MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 948c7478-ac8d-443e-6b28-08dafef6a52d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QBNIbluodxLNC9iOuQ8Bpr+XCH/r5ZeKpW7cRBRy/ipKzQO7M+EZk1dP6NNtToNFV5sPhZwgBzdETEPmsxt6jJ8DEKokD9k4Ni02yxIMtFjt2SvRTOiRrTipSJ4CLEs1VLRutMjqHX5bcRwnYWI1gtkZwYm9cUdl+nvqLVuO9z7b1mEr0Rx0aqRxd/fZLtgAPx25L6VNik4JkEFoIyb4+OY5zL3U7hUevWqJX7C2a92144BFtmVf831xmDZ1rKGob/QxCtMNfGD1cJQUVS/gSS03uEKN6C5Sbzj95Zo2xqqy4mrbv6qGQqkt/tdJ8Z3I4sJQQu5qSFL1kxGh3hQN//F+hJ8KH1WeuPNyBNSOr3SlxRs05ET14B1kBpJ+oGuiskO4keksiLMLSSsSp7M2FvX4Sw/s33LaOzFMO8KX4/k3LZKgnucwYzvpSAZrlxTK2q+IoZaFbQwRETRdlHVSm4y+s+RcKGGJxi1aTZ651jn/MVWuT+yBXlbsDcX+NjXP0Eh1OHKoT/5L4Bgzal6Fl0xBqZwRXVt6zvGP0qpZlkyxhY16GSxUOYr8lg3xXHjIvezVkkiCoYM9iqdr58CfrzGLs3SY9YzJoDVHz9LyMVfaQuPPPFbEO5Me6PzMD/nRTYpHHyRULbTMFxmkgLUxSgkrvxGjl3hr2MCPCit+Gs1jI6O6AwykZQGsOYnStNuEB2CMfE/E1IOhmI8zEYrFvjxz3lbeXBlYjsQH10S6BFugRUf8iNVN24wMIUTVdykw5X21gzseJOIn9AsGzewloz2aEfLQiL3Ov7N4OgYcwswIC8vsFJASAR7QgQmwcwvQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(31696002)(36756003)(8676002)(316002)(53546011)(6506007)(6486002)(966005)(5660300002)(6666004)(44832011)(478600001)(2906002)(66476007)(66556008)(6916009)(41300700001)(4326008)(8936002)(66946007)(38100700002)(83380400001)(26005)(86362001)(6512007)(2616005)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXZ6bFVocDZINm5BM0R3NzRHek53TVp4VEtkdGNUb1FUT2xIS0lzd1FxZlQ4?=
 =?utf-8?B?dDhMN1dLNjhpZ2RDdHo1YWk2Q2drK1ltVk83UmJwSjd4VmFoNTcvS2RiTUFI?=
 =?utf-8?B?M0NiNXd3RDRZYjduL0lVOHI2a1hUalNpQng1WHpocUFvamdVOXcveG1ZdHZN?=
 =?utf-8?B?YS9mT3cvUXhsQUQ5a05rZDZYOUdXMmovMCtjS0Z1ZUJYYnNEbWtmU05IaTBC?=
 =?utf-8?B?NGZJRGFoN2ZiT1gxU0V3RDFCT0NVcVF4TG5TVXNEbDdPVVQwN2xtNHdrRngw?=
 =?utf-8?B?alRrSjcvZm91d2h5dDJFWjZ4UVR1Umc1Vk9tWmZ0dmxoTU1tUmYvV0hnSG9U?=
 =?utf-8?B?Z1RTV0hWRG84clRva24wR0FSdXJkQTEzQmtNRHhiZmxWUk9ydnNyc0dkSGpO?=
 =?utf-8?B?dE1uN25CWThzWGVNR21xUFNURWNFWXFzU1JLcUEyK2xCMnhPWEFxTm93UFk2?=
 =?utf-8?B?TnJXSnlTbDdFV3JTbDNISjJ6YTRjUTlRc0tkVGtHeEtkT0ZhK3QxSWdFcGli?=
 =?utf-8?B?UkdqMUtQS1NjYVU0Z0gzNUVDbVhjRWd4TkpndENsaXRhRXkycEJUY2svWW1U?=
 =?utf-8?B?TWNZcmZ3M0hicFVkYWg5T2F4bXM0S1E5Qk83OGhVcjdvS0ZWaHZ2dWJNMGwy?=
 =?utf-8?B?alZJSFh5TGhERFI1YXhZeDM3dGQyYkJOVTd3YXdhUG9wYTcwdHh6cnVZV0s3?=
 =?utf-8?B?d2JEbGJaeFB3SFBmSm1jdkJOeHJ1NHk4c0xZVUR4Z3VmWStVWHB0MWRhSnpu?=
 =?utf-8?B?RVNaYlRCOVV5aGRmUjdwTjZSQnJzY3cxc3hQWXpqWEFCaExNQ3lxRmQrQ3ZB?=
 =?utf-8?B?Q0lXbGtXejY1KzhiRlJPYjFLUFYzTzE3L3hwTzQwRjh5TElqYnlhNEgyRVJO?=
 =?utf-8?B?NGtlcVZWNWlFc3pjaXBkLzlYVUpYRDlMc09GZnd5TDF4cWg2M25yVFRsUHdN?=
 =?utf-8?B?d1dNQkZGRUl2alN3NXF1ZFIwR2I2UGNWaDRuRGVJQWRaY3ErZXUzMXlUZlV3?=
 =?utf-8?B?czl2WjdFMk80UlpjbytxUFN2M0dYUk5Sa2JSV0U5SWxjanl5WVc3Rnh1T3NL?=
 =?utf-8?B?UCtoQXdMekxTMHZaeXgrbXVnUld1WnJ4b1ZDREhud0pIVUU2RHk1R1lwTWhX?=
 =?utf-8?B?amhSWUEzL3pnTVVzc1RZcnFxVDNJU0RmUGtGTkdacmZYQmtWNDRUeHoxMGZ6?=
 =?utf-8?B?em5EK3JlcnVXVDgrZVM1R3g1YkFUUFNJMHBhS3djOWVhNCtyS0JKZnk2YTl4?=
 =?utf-8?B?NHdrcXhha2Zva1VaSXA5aHU1TkxwbHNJeFpRRkVKallDWWw0NTdpWGdDR09C?=
 =?utf-8?B?T3lUeUVRdERlbG4yQ2ladmkxN21tUFJyV0h0bW5IbnJyTmtmOG14WkUrSWQw?=
 =?utf-8?B?TGdkeGxjd1F2eTZrdDJyM2RvQ0ZLdU4yZTVKVkpQb1FJOVVmOEl2ZitjSjZv?=
 =?utf-8?B?Z2locy9CajN0TlR4M1hJSTBCV25GOWwyUjd0QVM0U2NZc0N6WWUwd0JBR0pY?=
 =?utf-8?B?aGdWN25uNHVZVmZxd1hXdWxWVi9CZmJ4OExlQTh3a0Qxd0hyWmYzd0dBQ1ZU?=
 =?utf-8?B?Y0NHOGVKakhqUlZBbjdibVdjeDc2cFM2cGwwNkRRTUxuSkNRS1NIS25paUly?=
 =?utf-8?B?cGZIVU51QkpJYXpGYWt0UUZGdThEVHBwQ0VuMnZyeENvZXZuR05ieVNRc2xP?=
 =?utf-8?B?SEwxUmF1TDcvWkpJSWIzWGhNcjcxS2hQSWhrWlFGeUJkUDEyTUhzL2pPdXlP?=
 =?utf-8?B?TzVkUEs5dGs5clFuVTI4SHhIVWV1dWhId0JZbHJHNk9WZFgwWGZ5NmoyNHFE?=
 =?utf-8?B?Y2QrcEpZQTNQM0F1M2pUVit2OXBmM09keFpQUjB3eVpQRWY1ME1GOXB2d1li?=
 =?utf-8?B?ZlF1S3FNeUZJWjZHQU9acG1oWGJDR21DNlZFNVhkYndVdFJSQmtUbFNDOSs4?=
 =?utf-8?B?aGttNDNDSDlKSW1oQVEzeDM4WGZnVmhyc1lWOG5Ja2l6RXhRNmp6d1ZhMUYy?=
 =?utf-8?B?MHUydWUvQ1BnWDhvenIzWkpMbVEwUmx0ZUVjY2gzeVR1dXc2RzdBZWpqTDZn?=
 =?utf-8?B?MUp0UVhlM0E5eXVydzBIWGt0eUs1Y29BV2dmWU5ia01SaExaamZTTmozZWp6?=
 =?utf-8?Q?2uN6v7fwmFsayVig76Qu6M2n1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948c7478-ac8d-443e-6b28-08dafef6a52d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 17:07:31.4223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMLr9Bu8u6J1nIOmdOsaAUg+GqUtM7HFtiPi6Xwi0MeLiK0dZX6BjRnxj/eibqfoC34IPRJ1ZR39OnIw7RWHWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/23 6:55 PM, Sean Christopherson wrote:
> On Wed, Oct 12, 2022, John Allen wrote:
>> AMD Zen3 and newer processors support shadow stack, a feature designed to
>> protect against ROP (return-oriented programming) attacks in which an attacker
>> manipulates return addresses on the call stack in order to execute arbitrary
>> code. To prevent this, shadow stacks can be allocated that are only used by
>> control transfer and return instructions. When a CALL instruction is issued, it
>> writes the return address to both the program stack and the shadow stack. When
>> the subsequent RET instruction is issued, it pops the return address from both
>> stacks and compares them. If the addresses don't match, a control-protection
>> exception is raised.
>>
>> Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
>> collectively referred to as Control-flow Enforcement Technology (CET). However,
>> current AMD processors only support shadow stack and not IBT.
>>
>> This series adds support for shadow stack in SVM guests and builds upon the
>> support added in the CET guest support patch series [1] and the CET kernel
>> patch series [2]. Additional patches are required to support shadow stack
>> enabled guests in qemu [3] and glibc [4].
>>
>> [1]: CET guest support patches
>> https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
>>
>> [2]: Latest CET kernel patches
>> https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/
> 
> That dependency chain makes me sad.
> 
> Outside of a very shallow comment on the last patch, I don't plan on reviewing
> this until the kernel side of things gets out of our way.  When that finally
> does happen, I'll definitely prioritize reviewing and merging this and the KVM
> Intel series.  I'd love to see this land.
> 
> Sorry :-(

Thanks Sean, understood. This submission is mainly for community awareness,
but any feedback we can get now prior to the main kernel series getting
merged is much appreciated. This would give us a longer lead on addressing
any concerns that the community might have and potentially allow us to get
this in more quickly when the kernel series has been merged.

Thanks,
John
