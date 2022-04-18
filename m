Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917BD504C14
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 07:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiDRFCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 01:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiDRFCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 01:02:19 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DADDB7F5
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 21:59:40 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I4VKJb001307;
        Sun, 17 Apr 2022 21:59:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=S/HApIc1+Y2bPdD5BcI+IU/pwGlY1tUa9jisu/6oAGM=;
 b=MkRrVQeMuAdybeff0qjvuXksBPBVtQ7D/acQI5vB23DaDX0GDFnn3TSVVM5DqPIs+9d6
 /bZnyj6jm51W/gt6Dvkzlo34/rlfG3Y13TrlH3Jpm5CP/PBhVTEb4hdrkHhhZQpxUldI
 CNFrlfBR66zJyw0/hmounclYTq8K34vRsjyElS/07TnZz+gbL2sSvkoQ7ZUahY7AWJPu
 Aiv7kohFixSqX8U7YGgvblTPjcZ6NQBdUmto3epeqMSfGEUr6qjTMhJwFtpFfZB6s1K2
 G3Ai3RI8VNaONaj18eHgqqeqZINZoxGVwnKP630gkrSxE+o1cFwl5EJqwDWhKsekQFXb lw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ffwbxj9ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 17 Apr 2022 21:59:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKE56ZUCOyGyy2HWAvLVQr4g08N3UDU9dBFMMnrjErlcaEKuk+yY3As2rNSTwfg3uGgCd3y7XsaBN2KXQCxcXpXLJEs8IVU1g6wm6sVjaZmnBCbXFvy97VtiUICSF2SE5Hv6ExUEYKpcaux88LdRTK+nbw44OV8iiyo1I5xpebSYSU/VNlm3i/Vp1O4gdu4hlGiXnYzj5lI6B76TV2zPZ3xG0B6+sQHtc0gJV99BgHUvnTuXucxducbr++rGMFRffkquIvVRFMR41Ekbsb89CgrAYfQdHtd76oWD2VodQgRkhKy4fEaKvtGvjxDfAQWjjtF+FaPmRCFCoDIJYdzwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/HApIc1+Y2bPdD5BcI+IU/pwGlY1tUa9jisu/6oAGM=;
 b=OQVoYAgKU1Dd+bDuvRPiUGSrEz7m/3UE1bBq5aop22gftlt9x7RVABBKDANjsernaeHb3T+/mvrCoVTQ3S7eaptQ19jO7IIMfSztLCtTfjMPXOtTVRpzRFeDeCi7btUBDJ1J0HBZW52MttokfBqCiJWphIqDILZT81VgjCHjREdwxTktZdeDBq0uDBjDuXyImy0Z/HKlZCJSTiAcpJ5pCreSVxnjZPGZj2SdY4qFfZbxKxTx5AhfsBjPay86kvVg9SwXDxsH0K4srLaEBxR3uVuY7qhdd10ruL4AvbwE+gSYEZW2qr9vvqxRoGXidlM6b6uppM7QV/G9xyeOKaexcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3786.namprd02.prod.outlook.com (2603:10b6:907:4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Mon, 18 Apr
 2022 04:59:32 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::d9e1:228f:6385:a107]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::d9e1:228f:6385:a107%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 04:59:32 +0000
Message-ID: <6c5ee7d1-63bb-a0a7-fb0c-78ffcfd97bc5@nutanix.com>
Date:   Mon, 18 Apr 2022 10:29:21 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v3 3/3] KVM: selftests: Add selftests for dirty quota
 throttling
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-4-shivam.kumar1@nutanix.com>
 <3bd9825e-311f-1d33-08d4-04f3d22f9239@nutanix.com>
In-Reply-To: <3bd9825e-311f-1d33-08d4-04f3d22f9239@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::17) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23244a1b-7fbf-4f42-f92f-08da20f839c3
X-MS-TrafficTypeDiagnostic: MW2PR02MB3786:EE_
X-Microsoft-Antispam-PRVS: <MW2PR02MB37869B717B7A79F1DCD15520B3F39@MW2PR02MB3786.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGCp8KYfwBzyQu+jgpYtaDGatkd2Oo50Eh2Q4QFKwcrd7x2lTj/TIctj5DvhGDRFbcciOoSZXB/DnovhgGgFotv1v12R4UoPjzrND+8VIoUCFVWxoOsYqwCeIWd5kre7Wjw7jDa+c5liHGoORLHdQDoKtmBJfE0p1lDxz1akP5WX0eViJxqmLgVfEPawejyd5H9AUH4WJwflz5gugXIz9yIo1gOx02Ne3ch2yldd/PO4rBtqkf3ez42iFfoojtddF/v4dfQTeU8JUwmVqlhdzNq6gYW+nW2Dn8zC4ei3/kzcc0+YI6pnVU+8ZilpM9xPu1+1c3/5XvX8PP/0LlNshmZ0V6vIOjZmt+JquUnLJFGFUpTl38LSaS5ZlG5/RBCd4GqVmAyaBOg4QBN+MfQ12DUcpRP4XyvacmQ2JXDyw3C83CsbrI8bFTe5rgWGb56MQoTGCtwHTVmToPIrgYjKyn9kxCgjrgKdIEwt+9xFs9GnBRbJ5pLiI462b55oiYaGVQJ3nbwfMiFP93vM0FXVOmjbyhsLsxPam4PuwNxkaTnausYBeZKmBfcEOJDtvFM8XKp9vRz0tYQMBX08/2gfVdGgiiYq4a3LlPwf2DSjMwisDksCEuZB1OljemtS1ynNp1ItKVBIkT7eb08nM3wYutPfQxUbD8EUcvffiuOSNxGN7GbCkv5omp6+VxyrFV93OnjqjrBaicGVEObyc2DTqkdaSaNqrJVn7rAaexh1mVFXXCEa3jxlQFoH1Oe2L1DMRzlceHroN3OexIF6ORIVEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(107886003)(2616005)(6512007)(8936002)(6486002)(186003)(86362001)(83380400001)(15650500001)(6666004)(2906002)(45080400002)(6506007)(55236004)(53546011)(508600001)(31696002)(5660300002)(316002)(4326008)(66556008)(31686004)(66946007)(8676002)(66476007)(38100700002)(36756003)(54906003)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHYvakZFZHNwT2djMS9vZndHWUpkLzJ5NVJ3aC9pVDJ1ZktvUkMrYzRQQ2t2?=
 =?utf-8?B?dUhJS2grQTZyODZ3YXd4d05qcHAvYlkwVC9MVkNZK2pGMVJYUjJEZkk4WHVH?=
 =?utf-8?B?c1NFRmNzU3FpeE9OdDZsMVFRWVZLcVlsbHZ2NXVockJIUkJqbUpUWkR5ZEcw?=
 =?utf-8?B?Z1VMcmdIRVNPQUZqVWh2dmtwaHJOdThLOE5MRGR5OXhYZEVyOXcvT2xsR1pv?=
 =?utf-8?B?UWI4WGlmSnlkU0lmSzRwRmN5UHRXL3MvN3lDbWRIUGdldytCUHlGTXVnb1Rr?=
 =?utf-8?B?am5rMWM5TVh3Q3J3dU03NmZTNlM0WHA0cGg0TGoyWHo3MWQwY3ZHK2xsTGFJ?=
 =?utf-8?B?UGpyZXBYMjBaWnJEYVBvTnY2cDZ3SjJwcHBoR0tyK2EwYlpVd0ZaNEhQa1Rq?=
 =?utf-8?B?V3hkaTJtSmJveEJpVjQrc3lPM0JabUdZK2lFem5tMDVRTm51OGEyRnlDeHh5?=
 =?utf-8?B?Zk40ZzZCZVdHU0pmNUUvd2FwanExeERoMGpRcUMzU3NDempSaUxNRnFVWWlp?=
 =?utf-8?B?Y0Nxa2JaSFBEOG1mM2kyTTBwZlE5N0R4RFhJRExGWTlENDVWSkZBek83YVpw?=
 =?utf-8?B?bGRSN3pnamJNNzdsV3IybzYrcE8rbzlPajA2bWZjU0VTazF5M09VR09aZGVm?=
 =?utf-8?B?WGYxWS81bG53VDJaVFpialplS2U0VFpPZXFPdVRkdmRtNXRUSGkxcmNvakVV?=
 =?utf-8?B?ODZabUNHVTVvOWdUNE5tbVdqWTlUbTZIT2Yxd2xna0tuL2NkbnpxNWZldEJt?=
 =?utf-8?B?V3lYQXhXWERRemFoLzJmdWVjU1NJTm1vd3VoLzhRUEFXd2t0ZW5QWU1XamZx?=
 =?utf-8?B?cDJJZ3lOSUx6aGJNU1NNakpja05QYkpHcUViQTFCZERIU1ZmTlkrd0lmR0FY?=
 =?utf-8?B?ajIwOGZURmM3Ly9zUWZqV0tkY1Zyb2FSWTgwSFM5L2E2cFYrYVlSU1R6a3ly?=
 =?utf-8?B?aW51UDhxN0R1MzNlTkora3RzVHVpelFvb1dmbk9NREFJeklpOHJueVlKSzd3?=
 =?utf-8?B?eGwra21DTU5BSElaTkYrZ1NwRmVtaGIwcGc0c0RLdnN6bGpEbmo0YXFvb3Z0?=
 =?utf-8?B?TnE4RkcwQ1kvaHRUdHpWcUxLR1BJNXNkdWtPT0NTUCtLdFhBeEliNGZQRk8r?=
 =?utf-8?B?R3FqOUgwNk9IRWY1VzNxQkFySGFQSVZDeWxHWVlVa3Y3aVRWUVlPNW93aUtJ?=
 =?utf-8?B?NUNGZUt1WUlDWDF2c1Z1UUFRM3RYcWs3RVhweVA1Mi9YRnVadG9TL280cm1H?=
 =?utf-8?B?MFpBUi9KUThXb1ErMWJUUlNqbFBJZWlJSlVoenJKYVdOcDlkeGFOaE92Z3c4?=
 =?utf-8?B?OWprLzkzMWRNRUQ0Ly84dU1OZDF2T2t6MnNhV0J0MlllL2pteTFZdjBMVWV0?=
 =?utf-8?B?OHBMYmIzTG1kckRpZmwzMFUyMWhFMDN0OHNXY1lhMFljZWhkTkhxRGlzT2ho?=
 =?utf-8?B?MXJxSTc3cXFsN2x5dkdVMVQrL3JLYi9sSkp3YVhCYjF5VGpRRmJBSEVMZi9I?=
 =?utf-8?B?b05HVURlaDByVy9wTmVsMWU0NDRjL3RZdWgxTk1MUTJmUDEvRnQyYWtxbEJw?=
 =?utf-8?B?Rnppa3k2WXVyVHgzTmxOUnRBbEMyT3pKTW9FTHNwbmEzZTNaN0FNekdXZHpC?=
 =?utf-8?B?Z2c0VDhmNFhldUU1UCtmaWtJbjFrYTdtb1poQ0tpM0hwZ1c1eTdPRzJ3WFJ3?=
 =?utf-8?B?UER0M2REcmxRcTVTdndSUGNTYldHT3ZQRzBxQ0Vhbmhlcmd1dDUwRUhoQ0lr?=
 =?utf-8?B?RE4vSXhQdEx4TXEzb3BDdDVxaDVkcDJxQUxzMldWcWZYWUJuYTlBeTlRRU1T?=
 =?utf-8?B?Tk5kTllYVXFYSTJxMEdpTHJiRi82T0RoaGRpUXhBaXJqRnp1YTNmcEVHMm1Z?=
 =?utf-8?B?VXpPY3FieWJuTnd5QmhUdE5rVlhlOHNjYUFWUUR5U3Z5QTlvYmdSa3VWbkgz?=
 =?utf-8?B?bzFNeDhOSTVES1NRQ0JGRThNZ2NyOEVVNm80ejRWeWlhRnNDaWczTW42TnI5?=
 =?utf-8?B?Y053aWh5YjZSUDdlcnVDSFBtZUNZTUU4cE5wSDl5eGdRZGNvbGxpUHBKQUxa?=
 =?utf-8?B?QkxwaTdNUnNjSzA1TEdmTnJLQVBGcFc2dXE5azZFVDQ1ZVdLSVZibXBHbnFu?=
 =?utf-8?B?dkNYNW9Qb1E3OG5aR3g1cmlkZnBWRjNkK2RxeDVMbmlZWUdBb20zWFRyanBB?=
 =?utf-8?B?OGU3d0hBd2dxQzdIcnlDazhuZ3R0ZnFpU1JtY3prQVhCS0xHZnJzQVdFSlVX?=
 =?utf-8?B?V3BkUTZXdUVldlhBR0NjN2hrMlphVmp4a1dKSHcrY2p6ajFrWXRRQmc3ello?=
 =?utf-8?B?KzZaWlRhMFViYU8xWU9CcTFlU00yZ1kyb2lSNkhaK3BBL0c4VFVxS3lQU3FW?=
 =?utf-8?Q?02w89R0ciAiguBL8=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23244a1b-7fbf-4f42-f92f-08da20f839c3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 04:59:32.3687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhP/gR+7hDRIftD33fG/HGxToKdlSJRr6GrJDKV6W49u4MluWkSKgl7DiXzH031RB4Ol3uq5dXwSPu4g7XKSZeRPt9X35AsYINDnkcARPl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3786
X-Proofpoint-GUID: -Dzlz5E-M39n_u1EOkZFhngzGoP8qwfL
X-Proofpoint-ORIG-GUID: -Dzlz5E-M39n_u1EOkZFhngzGoP8qwfL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 18/04/22 10:25 am, Shivam Kumar wrote:
>
> On 07/03/22 3:38 am, Shivam Kumar wrote:
>> Add selftests for dirty quota throttling with an optional -d parameter
>> to configure by what value dirty quota should be incremented after
>> each dirty quota exit. With very small intervals, a smaller value of
>> dirty quota can ensure that the dirty quota exit code is tested. A zero
>> value disables dirty quota throttling and thus dirty logging, without
>> dirty quota throttling, can be tested.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   tools/testing/selftests/kvm/dirty_log_test.c  | 37 +++++++++++++++++--
>>   .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>>   tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++++
>>   3 files changed, 73 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c 
>> b/tools/testing/selftests/kvm/dirty_log_test.c
>> index 3fcd89e195c7..e75d826e21fb 100644
>> --- a/tools/testing/selftests/kvm/dirty_log_test.c
>> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
>> @@ -65,6 +65,8 @@
>>     #define SIG_IPI SIGUSR1
>>   +#define TEST_DIRTY_QUOTA_INCREMENT        8
>> +
>>   /*
>>    * Guest/Host shared variables. Ensure addr_gva2hva() and/or
>>    * sync_global_to/from_guest() are used when accessing from
>> @@ -191,6 +193,7 @@ static enum log_mode_t host_log_mode_option = 
>> LOG_MODE_ALL;
>>   static enum log_mode_t host_log_mode;
>>   static pthread_t vcpu_thread;
>>   static uint32_t test_dirty_ring_count = TEST_DIRTY_RING_COUNT;
>> +static uint64_t test_dirty_quota_increment = 
>> TEST_DIRTY_QUOTA_INCREMENT;
>>     static void vcpu_kick(void)
>>   {
>> @@ -210,6 +213,13 @@ static void sem_wait_until(sem_t *sem)
>>       while (ret == -1 && errno == EINTR);
>>   }
>>   +static void set_dirty_quota(struct kvm_vm *vm, uint64_t dirty_quota)
>> +{
>> +    struct kvm_run *run = vcpu_state(vm, VCPU_ID);
>> +
>> +    vcpu_set_dirty_quota(run, dirty_quota);
>> +}
>> +
>>   static bool clear_log_supported(void)
>>   {
>>       return kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
>> @@ -260,9 +270,13 @@ static void default_after_vcpu_run(struct kvm_vm 
>> *vm, int ret, int err)
>>       TEST_ASSERT(ret == 0 || (ret == -1 && err == EINTR),
>>               "vcpu run failed: errno=%d", err);
>>   -    TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
>> -            "Invalid guest sync status: exit_reason=%s\n",
>> -            exit_reason_str(run->exit_reason));
>> +    if (test_dirty_quota_increment &&
>> +        run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED)
>> +        vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
>> +    else
>> +        TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
>> +            "Invalid guest sync status: exit_reason=%s\n",
>> +            exit_reason_str(run->exit_reason));
>>         vcpu_handle_sync_stop();
>>   }
>> @@ -377,6 +391,9 @@ static void dirty_ring_after_vcpu_run(struct 
>> kvm_vm *vm, int ret, int err)
>>       if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
>>           /* We should allow this to continue */
>>           ;
>> +    } else if (test_dirty_quota_increment &&
>> +        run->exit_reason == KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) {
>> +        vcpu_handle_dirty_quota_exit(run, test_dirty_quota_increment);
>>       } else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
>>              (ret == -1 && err == EINTR)) {
>>           /* Update the flag first before pause */
>> @@ -773,6 +790,10 @@ static void run_test(enum vm_guest_mode mode, 
>> void *arg)
>>       sync_global_to_guest(vm, guest_test_virt_mem);
>>       sync_global_to_guest(vm, guest_num_pages);
>>   +    /* Initialise dirty quota */
>> +    if (test_dirty_quota_increment)
>> +        set_dirty_quota(vm, test_dirty_quota_increment);
>> +
>>       /* Start the iterations */
>>       iteration = 1;
>>       sync_global_to_guest(vm, iteration);
>> @@ -814,6 +835,9 @@ static void run_test(enum vm_guest_mode mode, 
>> void *arg)
>>       /* Tell the vcpu thread to quit */
>>       host_quit = true;
>>       log_mode_before_vcpu_join();
>> +    /* Terminate dirty quota throttling */
>> +    if (test_dirty_quota_increment)
>> +        set_dirty_quota(vm, 0);
>>       pthread_join(vcpu_thread, NULL);
>>         pr_info("Total bits checked: dirty (%"PRIu64"), clear 
>> (%"PRIu64"), "
>> @@ -835,6 +859,8 @@ static void help(char *name)
>>       printf(" -c: specify dirty ring size, in number of entries\n");
>>       printf("     (only useful for dirty-ring test; default: 
>> %"PRIu32")\n",
>>              TEST_DIRTY_RING_COUNT);
>> +    printf(" -q: specify incemental dirty quota (default: 
>> %"PRIu32")\n",
>> +           TEST_DIRTY_QUOTA_INCREMENT);
>>       printf(" -i: specify iteration counts (default: %"PRIu64")\n",
>>              TEST_HOST_LOOP_N);
>>       printf(" -I: specify interval in ms (default: %"PRIu64" ms)\n",
>> @@ -863,11 +889,14 @@ int main(int argc, char *argv[])
>>         guest_modes_append_default();
>>   -    while ((opt = getopt(argc, argv, "c:hi:I:p:m:M:")) != -1) {
>> +    while ((opt = getopt(argc, argv, "c:q:hi:I:p:m:M:")) != -1) {
>>           switch (opt) {
>>           case 'c':
>>               test_dirty_ring_count = strtol(optarg, NULL, 10);
>>               break;
>> +        case 'q':
>> +            test_dirty_quota_increment = strtol(optarg, NULL, 10);
>> +            break;
>>           case 'i':
>>               p.iterations = strtol(optarg, NULL, 10);
>>               break;
>> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h 
>> b/tools/testing/selftests/kvm/include/kvm_util_base.h
>> index 4ed6aa049a91..b70732998329 100644
>> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
>> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
>> @@ -395,4 +395,8 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t 
>> vcpuid);
>>     uint32_t guest_get_vcpuid(void);
>>   +void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota);
>> +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
>> +            uint64_t test_dirty_quota_increment);
>> +
>>   #endif /* SELFTEST_KVM_UTIL_BASE_H */
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c 
>> b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index d8cf851ab119..fa77558d745e 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/kernel.h>
>>     #define KVM_UTIL_MIN_PFN    2
>> +#define PML_BUFFER_SIZE    512
>>     static int vcpu_mmap_sz(void);
>>   @@ -2286,6 +2287,7 @@ static struct exit_reason {
>>       {KVM_EXIT_X86_RDMSR, "RDMSR"},
>>       {KVM_EXIT_X86_WRMSR, "WRMSR"},
>>       {KVM_EXIT_XEN, "XEN"},
>> +    {KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, "DIRTY_QUOTA_EXHAUSTED"},
>>   #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
>>       {KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
>>   #endif
>> @@ -2517,3 +2519,37 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, 
>> uint32_t vcpuid)
>>         return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
>>   }
>> +
>> +void vcpu_set_dirty_quota(struct kvm_run *run, uint64_t dirty_quota)
>> +{
>> +    run->dirty_quota = dirty_quota;
>> +
>> +    if (dirty_quota)
>> +        pr_info("Dirty quota throttling enabled with initial quota 
>> %"PRIu64"\n",
>> +            dirty_quota);
>> +    else
>> +        pr_info("Dirty quota throttling disabled\n");
>> +}
>> +
>> +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
>> +            uint64_t test_dirty_quota_increment)
>> +{
>> +    uint64_t quota = run->dirty_quota_exit.quota;
>> +    uint64_t count = run->dirty_quota_exit.count;
>> +
>> +    /*
>> +     * Due to PML, number of pages dirtied by the vcpu can exceed 
>> its dirty
>> +     * quota by PML buffer size.
>> +     */
>> +    TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of 
>> pages
>> +        dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
Sean, I don't think this would be valid anymore because as you 
mentioned, the vcpu
can dirty multiple pages in one vmexit. I could use your help here.
>> +
>> +    TEST_ASSERT(count >= quota, "Dirty quota exit happened with 
>> quota yet to
>> +        be exhausted: count=%"PRIu64", quota=%"PRIu64"\n", count, 
>> quota);
>> +
>> +    if (count > quota)
>> +        pr_info("Dirty quota exit with unequal quota and count:
>> +            count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
>> +
>> +    run->dirty_quota = count + test_dirty_quota_increment;
>> +}
> I'll be grateful if I could get some reviews on this patch. Will help 
> me move forward. Thanks.
