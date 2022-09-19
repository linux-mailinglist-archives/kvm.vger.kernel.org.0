Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B59C5BC24A
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 06:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiISEl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 00:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiISEl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 00:41:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FA2186F7
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 21:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5sbQ42Cpze9cgdBFu9Tqg3DoHxOV8vuy0CTonnGV4h7x9xC6F84LXz/Z4CKcGDi1hQOtNz23iPtwyE9LPF7WP/jZPHjX2qj3GjANYQOB6Ty0+pYAMPjlAODkwU0J4B0H8Qp23OGGop5s1y8/tYe8chl9+hG23Xe0cjf+M2V1AnSlPFWUkwX/AYXW1Ph//e0dGogqPfPzNYY5j3YZ24JgV3ttZfaNNPZtd5dg2mbd/BdkLkaTdDw4Uowwuo0j7MeiMrhHeuqwMVDQ+eXJm0bBSClzev3uaOTVtlXT3Avg/0wdLscpPq6mN0P5BjyktlAxXNukIuJXWLBEePaUwLpgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woKGjQhWoNzmORr+yeUhwCLlH9GpU/P2vWXbsoQsc68=;
 b=fca1xxSUO2Oc8gr+RV0GOr331J0x0SdEttBySq+Jj6opv2JzJKO6XMOpHe9sb9AxzFfzS3C5uc3hhrcjw8QZAxBj6v4y/n7Ru/bvl7Hy+tXkIn71s2aKYRlbtlYTPET0x0kmteBcqS+4KOpMuw93FaWpBI10Lyaqxagt65VzOUJOGANpT1IG/+xY9ZEyiLVNnx0yB9icJj+ljv3brP9thuNDH8hOBO+Z4Ued7nQKg+f6TYFcQYyJqDPXheQ3hsWEPj2sQb14ZQ8TRKVsZ/WTyCEyl8qYv/RHtMhf92lGN3kqnRWf7a2X4KpsqL6jtV7FI/4M8Xhhv5sm/h4CWaPj/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woKGjQhWoNzmORr+yeUhwCLlH9GpU/P2vWXbsoQsc68=;
 b=fK4Y74zKfOKrO5agBhwPsTPdEQRuxdiEBsVXkLr6t/Fdf0MD3UwEVeH7gGoQi/w1LUkSE/kAzAjkY7he+LWd27bmgVuYT/xwdNHJaebj5Pl6CCiZsnx8SEyPgO0IRLaZ1WYL7Fv0z1jfjrdXl0dM1Tx8izhVT+aVMiYc+pqBr8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 CY8PR12MB7492.namprd12.prod.outlook.com (2603:10b6:930:93::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.16; Mon, 19 Sep 2022 04:41:22 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::ddaa:b947:3e9:ce72]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::ddaa:b947:3e9:ce72%6]) with mapi id 15.20.5632.019; Mon, 19 Sep 2022
 04:41:22 +0000
Message-ID: <1b17bc6f-c7c6-2d3a-476c-7cf0ea24f4cc@amd.com>
Date:   Mon, 19 Sep 2022 10:11:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v2 0/4] x86: nSVM: Add testing for routing
 L2 exceptions
From:   Manali Shukla <manali.shukla@amd.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, aaronlewis@google.com
References: <20220810050738.7442-1-manali.shukla@amd.com>
 <d62703a8-7c8b-eab4-cf35-bb520312d0d9@amd.com>
In-Reply-To: <d62703a8-7c8b-eab4-cf35-bb520312d0d9@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::13) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|CY8PR12MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7030ef-3196-419f-8ccd-08da99f933a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmTqcfeC6wrFbrvJ3gFnUQlwf9eJ8ArzkzbDR/8LwAxo7AIn3L83UqxYRM8IqjvU43tTBSLXZvxyYYCpZNufu25CstLFztmojlP9TmoVI9q1ykjY8ArLA31MJzTl2kesNeHitdmifz83JI6tP5u6YEUA6utmDu/FebhxHjqIJMjsgDeCd83GZtz+w4jWPHmo8MKsXy/iIlnwwdt4jjvpu+avgwv9c/ZPeXEgYb4lOwcJVE92ET7uhrzpYT9wF/MO8+BgPzC0g8KFL6x1zD5oQT5qzY2FdwAkHzF9QS9zHIXwOIPiNoZ1HbIXtezCpj3j0w9Lz0p2HUeo9x8Pk6opjYOjyjD7uPuBFXew6zck4rrI9rCehpT5Vy8NFwqHYiTFdIjaLWj695SI2TnPg2YdJu9hXjwGvn/Olx+X4qtZ7GR5Kbb5iGMgkBld7jjjYKKeu6PD6uPZrgY57H+vJ8YPATcpLj1pCy/t2SERSdbGsLaxv+fg8CjGhyjNbiBQ7u6wLXi2ueUDHz+Lb2YyKYXvnALh6OPHiyeTGOdzmzNoOlSAkX28A3+Ha/+qNTrAvL1pm9cwRLpIGmmoLZr1xnCiRwFeU5gXRgcxI7hUef7dEQ/Ne7/oYB1npCgvCA7BIjBonXNaBumCNHrf+dTagzHml/sLsOGtJV1NqfTr/AgRGjDf15bn0cRguUs26IF11lBPj6kEZNGmNOeOVvzUmKsCpS8c4BH29vNrW2TLF6WT5+re4NDS5+tSWcmTUytBj4HM8w/rmFbNC8P7ADEYOx5NXP5DSOxiMJVoiwbV2632M0VTNQ7MtBaO9YazqnqBiSpo+P4FTrw4PRq/pLxkKOCCHG85Vzq9C6mq4wNScYcTire9kBl7T+nxMX+m/f2zRkl+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199015)(6506007)(6486002)(478600001)(186003)(66556008)(41300700001)(966005)(2616005)(53546011)(6666004)(26005)(6512007)(44832011)(66946007)(2906002)(316002)(8936002)(5660300002)(4326008)(8676002)(66476007)(38100700002)(83380400001)(86362001)(31696002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEFwZHEwdGdBbmJUakNnSjlJeGwvOWNJNDYwaTBoMTdGTGUyakM2NUJMaXZo?=
 =?utf-8?B?R2VIb1E4dFNaMDJsdVJpbXZQc3I0cjdxdi8vM0Z5S3Z6R0hGQ01iVm8wL1dT?=
 =?utf-8?B?Y1pOeHc4TWpsVHpzYmdVbUVKalRaRURYT2U0S1lBdHJCMk9zUEtoSDJVeTlZ?=
 =?utf-8?B?aFRjdkhtRmxwcERzcGhiSmxnTmpwTWxMb25mclp0VFFrb2NLZngrSWhkc1Vl?=
 =?utf-8?B?YWdNR2lJWU1uVVVaaE5nMWhmc000cTlVNG1jcWFJcWJUVUpEdW5NRUtrTm1E?=
 =?utf-8?B?dFRaMkNzRHB1ckxvMHVUU2JzRFR3Z1RrMXNGYVRZelRJNHRzN0h5MHNkeGM2?=
 =?utf-8?B?UmZvd0VBZm9OVnJ5b1gxM2pacElIZDBrcFBRSGlrV2pVMUpVRW8wNEFmQWV2?=
 =?utf-8?B?R0VKWVA3M0Z2TXFwU1hid3VqMlN2aDFRc0g2dmg0WGpscE9MaDNXcjdCWjVu?=
 =?utf-8?B?U01VK0V4ZzcrUWZqdGNSTE8zclRybHhEN3FGOVVXV2JtaXh1SUFTcnJEbmU1?=
 =?utf-8?B?blJ4UGUrSXArRkJ4VGJodzNjWEFWd0Z6ZUlyeHplRkJtcEM3Y2ZaWkxzczVv?=
 =?utf-8?B?aDV1M08zODFuTkYyYWR3dFJ4NFoxYW9hSGd2RnFXTFBsT3ZnUktBTHhJZ0pi?=
 =?utf-8?B?TEhPcUxUTGE3bVRXMWxIT0xxYzFCcFlnQi94UlNhcVNnZGlrMGpPUnNicnc5?=
 =?utf-8?B?N2t6QnlleW1MMkozbGF5RmZjUHNMdFk4SVhBelBhZTI2VjNrdCtrZ2pBRkU5?=
 =?utf-8?B?bDAzRHAzMTloVXIwZjg4WUNOS3E4aWdQSWJsMmcrSzhqZThneVBydDU1Z0Qr?=
 =?utf-8?B?VGRXOERyNHQyOVI3VFZnYnpieGVxaEVCMHFNdTkrNTdacmRKVGk5WmNUVXE2?=
 =?utf-8?B?MWpBc3hFU25xZ3N4SWp4RkgvTm1oQkdDaWxCNW5jOU5FNXFvL3JVaHV4YldG?=
 =?utf-8?B?bzhnbkUxNkUzS3R2dmJyTThmSytSZkZTWUswYkwyM20vV1RPcGtMSHRMV09W?=
 =?utf-8?B?TlJ0dXZ0L2F5WHBBNzZNWDNORHB2K3BidWdva3h1Ty91dGxnaUFKNnNqUlBy?=
 =?utf-8?B?dUZEdE0yWjc5VWhEVmE4SDR4RkpHeXRYMENBM2FrV2JzVTdGQnNIdHA5NzF3?=
 =?utf-8?B?N1ZyQXlSNC9ySkVVeU9FS3pLdXNFQzFMaEtadHlJOHRPRTVxRERVRFlnTmlu?=
 =?utf-8?B?eG41SUh3bE9QVTMwUTBpeGIzc21XZStFMWtPZmRjWHhCYVhkaGtoOTdKV3Ri?=
 =?utf-8?B?S0NyeHZmdytqbXJ5dVBHNUFIVEhwR1RFS0R1WGg2Qmwrc1BKNWNGbi9pSzhm?=
 =?utf-8?B?VytCdTZEYWxHTm5uZlJ4a0h4VWhsaHJocWtmZVZ6YXZIYUprcU85MHI5azQv?=
 =?utf-8?B?R3F1SWFVSURIL2pvSnJMTFNiUFFHOUIwVTRHRWlwNXQrUHlhbkZ3eVZJcFVn?=
 =?utf-8?B?a3ZxbmwyWVBrcEc4TXNDQ2ltNDZmWU1GWEpqaEt3WXJpNWxZQURacTZiWGJo?=
 =?utf-8?B?VXB0QmVIbS84K0NrcUxzODFPVHBlRFFEVE93OW5lWUxGNTA4UW5CNWlVbGd1?=
 =?utf-8?B?NzNLM3IvdGVVS3NWeGwzcnBTTzBpQ3dUQ1BiT2lKWFlaVHRlRm1RQkFGSzhX?=
 =?utf-8?B?TUpPQ1JMY21TeXRHZjhHcGFlQ3g0NFJHVmpHd2hDNWlhQmw2RlJGTEhGWU9n?=
 =?utf-8?B?WmxtdnQ4MFBzeXJLT1V1aWlDNWN4THhqT3FLNFJ5VWYvY2tWbzZvMXpVZmxz?=
 =?utf-8?B?QU03amZJRERQZFRRUG56dE5HR25UODkvbE9nbktUTUx2ZXJqVDUzbTJUdE1w?=
 =?utf-8?B?a1owSVZkZ1RPbHcreWZKTFF4RkZLOFFPbDJpVExwTWRUR2FaMVRZdGFPSnQz?=
 =?utf-8?B?eDA4SmhUS3JjNTEyRDVzakRUWTFZbDI1aFJxRCtMck4ybDVHUVFnK1lya08x?=
 =?utf-8?B?clNITHBaME10Y3IxZ0diam45cjhuNVA2ZEJ2QUtTYzFxTWozemhjcmdQVXI2?=
 =?utf-8?B?Q3EzaCtubUFZS09DdDFiTFptaDdIenJKektWOEJvL1ZiTlF4Sm1wZjIvbjYr?=
 =?utf-8?B?VzBibVpWTlpORWd2ZkZYbUwvVDY0VE9LamZDZmZOWjVsT21SNDJzYW9NQjJt?=
 =?utf-8?Q?B/fAMgXSjGOhBcrkowz/o635L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7030ef-3196-419f-8ccd-08da99f933a0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 04:41:22.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUxyd/HSpUktj17UmROEDJpXFKy9aS+RBSotDF5w3RAQJP22Up3Vb5+C+SfZO+AhFN8jWB1jqiziZZpXFjAu5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7492
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2022 9:41 AM, Manali Shukla wrote:
> On 8/10/2022 10:37 AM, Manali Shukla wrote:
>> Series is inspired by vmx exception test framework series[1].
>>
>> Set up a test framework that verifies an exception occurring in L2 is
>> forwarded to the right place (L1 or L2).
>>
>> Tests two conditions for each exception.
>> 1) Exception generated in L2, is handled by L2 when L2 exception handler
>>    is registered.
>> 2) Exception generated in L2, is handled by L1 when intercept exception
>>    bit map is set in L1.
>>
>> Above tests were added to verify 8 different exceptions.
>> #GP, #UD, #DE, #DB, #AC, #OF, #BP, #NM.
>>
>> There are 4 patches in this series
>> 1) Added test infrastructure and exception tests.
>> 2) Move #BP test to exception test framework.
>> 3) Move #OF test to exception test framework.
>> 4) Move part of #NM test to exception test framework because
>>    #NM has a test case which checks the condition for which #NM should not
>>    be generated, all the test cases under #NM test except this test case have been
>>    moved to exception test framework because of the exception test framework
>>    design.
>>
>> v1->v2
>> 1) Rebased to latest kvm-unit-tests. 
>> 2) Move 3 different exception test cases #BP, #OF and #NM exception to
>>    exception test framework.
>>
>> [1] https://lore.kernel.org/all/20220125203127.1161838-1-aaronlewis@google.com/
>> [2] https://lore.kernel.org/kvm/a090c16f-c307-9548-9739-ceb71687514f@amd.com/
>>
>> Manali Shukla (4):
>>   x86: nSVM: Add an exception test framework and tests
>>   x86: nSVM: Move #BP test to exception test framework
>>   x86: nSVM: Move #OF test to exception test framework
>>   x86: nSVM: Move part of #NM test to exception test framework
>>
>>  x86/svm_tests.c | 197 ++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 142 insertions(+), 55 deletions(-)
>>
> 
> A gentle reminder for the review
> 
> -Manali

A gentle reminder for the review

-Manali
