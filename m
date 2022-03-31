Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7024ED4BB
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiCaHXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 03:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiCaHW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 03:22:58 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3CA1E7451
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 00:21:11 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22V0mmbW022032;
        Thu, 31 Mar 2022 00:21:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=buLcGgg5ahpnRbsF/1NUQNhDw4EiOqlHvs2lRgqxgt4=;
 b=NqAdLl2GLYC4XxFtumyCLR07IXKnZAKJeafEjsQjJebhptz5rlXt3U4TPtRhRIzKAUcm
 dw+/TsR9pH6ylX0IY619O5GwySOH34gNxfwU+Blgas51E5VNivrOvxwARK7nCV8ftkDL
 GDYxFTMZIYrzbneKoRWlqYa2pw8vx4ZLTUMwIdxnyyj3m2FQU6mOBczaDXwLNmgKBL9y
 4Pr1DA42lSUWx/2hQYKgEaSBVR7Pwo2fhUBh9a8accH9V/g4T5Da4xTAv+sGZ4NMjITA
 N+XzspeIlAKXSOHiOPRprTDMZ/gkNgrpAc8wwM0rJ7JnTlpey1TxiRuqCShfK/Zg0O4P Fg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3f20xhtjnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 00:21:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut5wPopNgQjB4ILhrlHfADhh0DgO7CAPmkR8PRh5tJy1YyKG7/KQ4GhhMJqQpVLM0hSDsg35zgbwZ/nGOiGlX+Vh2CFJAFRR8a056/V3XjsUWVhhvqo5Z9yowyc9UFVvaqu+LmXwzQ0R85/QsMbDYlUF2g8zNzAs2CvhyZ0cuVgEaMMpTx5psP1IPnAXxS6NB+HmyTvZJuVRCbPaIlVlaxagZHUHU5F02uhW3W05YiN5SM2ONCXjJlwML1mpl7+pjRlJjCZbN/wlapLRDlPNxuWLFFxTzJ7/qygAFIU0VNTmrsLdWNQ3rAuBo7E2WWN7qKbYsBYHtzBHQl2jF27psQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buLcGgg5ahpnRbsF/1NUQNhDw4EiOqlHvs2lRgqxgt4=;
 b=ddygnJyuTeSs7LISr63owKGtbVRXgoAEbuCVL1S5Feqq07Q6YH/DoKkKLY1LheYu4PWC1t0eW3J43vK0XIPUHKN0Pynex1Qxp9k0dN4qD2AW7foa4y6wDR4YNI/Ez7vrkLjWASeIRET6lRI6t018sKxl1Eqg3jpIUWeUTsnUZlobyJxikydmIBBSO0viPTfuqfdiRnYwUWYJ2O3/0Qqp0te5uJIJEMftEQ77U/1Rq0M3VNrqAGoraqH/fHmDiDRL2mCQ8FoYEldK1IaOhvXbYu/Afzb7GRnnkyNOR0pH/OvEtZhtEANEF2ooLTyOLHw23Z+MHvm2AGspBOOAxmR9gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH0PR02MB8012.namprd02.prod.outlook.com (2603:10b6:610:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 07:21:05 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 07:21:04 +0000
Message-ID: <72d72639-bd81-e957-9a7b-aecd2e855b66@nutanix.com>
Date:   Thu, 31 Mar 2022 12:50:53 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YkT1kzWidaRFdQQh@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YkT1kzWidaRFdQQh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0092.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::32)
 To CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 837eb170-8a77-491e-c527-08da12e7045b
X-MS-TrafficTypeDiagnostic: CH0PR02MB8012:EE_
X-Microsoft-Antispam-PRVS: <CH0PR02MB80123AB5FADC30D8BE21A4A9B3E19@CH0PR02MB8012.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMiazA+8oY59zP7Il0eWo3fEB+FUI7lvNpnnXdTRFHPIq5n7es3oASv1G0ACVtrC3xk5z5SlyZQ5ckAej/D9mA6yXcBxn3iK8J02S3Mt9sV18x0PjVa0+D2x1izkaTIxOzfy/LKheniuFcAARTN3KN/Qqu63PB3dznewVMpBpabymj30JGluzpwYTKT3eKp3nosB9HSMKH2qu838DaMsv4mqxpGrRsg7e3xylBdoJJNhK7SYDkFokXiiZKqBc60TbdyI2Nh/9OdqdfIhcSw2HmzzD1lG6dHNiE3nPgN1WZgHujqyiG7xKDOvvDPDOMhibCbmfQvPDTH/DSexApUCrMTi8Vp/fd8fXAuGOSyVHQhPFPnMiucIu8wqNd4stwxRXwgcV8wEEawxI6abZe3xPWOPaqCOJTr6rN03yxOrDiAsea27vq1Hq7lTfwF88czo0vspV2EYtEsNfGvDaWOdw05Xxd7H+98qGnJkH26/vvSqmy07a42YLgy3TZ5MJZYqMFAh11LwQ2Q0QPBZCmUn2mmEg6M0zC8E05wIlZq1WvZpn4dmm3RK59uTtcorO9x4URyBnbinEWrihEobjtS/WDf2Dl0h6KY5BRVbmCNEh/o5MvVCKPvtAyt8uUOkJwUraSRkAok0qjY/p4SY+xCLFBL+/S+WREwsNKaaVJUrzKgGN5xBNnnhtdYLW9gTc73g9FqEvIx4AhsQxajw2KsTT3MUCFwz6VdOPWbYpXVfxEXpplVYNYGAdHL0L2QMqVkJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(316002)(6916009)(26005)(186003)(86362001)(4326008)(31696002)(508600001)(8676002)(66556008)(66946007)(66476007)(54906003)(6506007)(53546011)(55236004)(2616005)(2906002)(6512007)(15650500001)(8936002)(6666004)(5660300002)(107886003)(36756003)(31686004)(83380400001)(38100700002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVVsL0paUVlVSkh0eDYxN0NOYmlOdTBXNlEvZHMySGs0RTUxMFF5N2tiMHpF?=
 =?utf-8?B?L1FmK0ZFZU55MVREMnMza2gzQ3ozREQvOXZjRTZlUDRyZzhqd1Z0d1REekNI?=
 =?utf-8?B?dzJCRDJhVW1ib1d5eHJOUUR3QnI1ZXRJb1Z2MWdPb0pKaTErNzRzNE85Rnl1?=
 =?utf-8?B?UmhIZGV1QUlzQ21pU0ZGVHZiM1c2SjMwWjhJVkhwWmlCWEkzQ0hSTzdZNFdr?=
 =?utf-8?B?d2dHd1VrTytYSWhYNlk1Y1FOV3dKTkw0Z0gxclFBV2VBdlJxMUQxOERJK1FE?=
 =?utf-8?B?RTFGUWJtNU40b0FpRXZMV3BmWThPZmFEVkhaOVV2UkNBdC9ZOXA5ejBTc0J0?=
 =?utf-8?B?Yms2ZkRPZHludmg1aCtyRnRpQ0k0Y3V5bXp0QjRndTZ3ZHVBM3hQbmo4Rk9k?=
 =?utf-8?B?MFJNN25CVmxnOGZLZXNRSjMxTmZ0ZnM2Q1o3alVUTitybHBxTjU2YmdDTkI4?=
 =?utf-8?B?NjF3TzJ4VW9xS1BPbXJtSTNJYWNVUjNUR0MyMWp5aXp2WElUeVNZTTR3TlZN?=
 =?utf-8?B?ZkdmMEdiRHdGTWtPdXZOcEJ2L1l4R25vN3FrRTlJTHRaeWE5OEdXa20wWjFQ?=
 =?utf-8?B?WUtneVJkSXpQTDMrRmd1cXc4TVFHcXo4bW5YNGVVVUpyR1ZsenVMNnUwVGph?=
 =?utf-8?B?aS9NR2RBcW5HbTdBV0lmYUpOdTdxQTk5VFBIT3NBRkwydXBPalVWTGpOdVdU?=
 =?utf-8?B?U2o4Wk5iZDBaK3doanlmRzV0NzU2WFI5T1V6eWZIWFdLVkZnNUVhdUJkdzRx?=
 =?utf-8?B?SElUU0hFRk1kSGNoT3NZRUFFSzFYa1FCeFNROVlzODVsZnA2Z0syVzVnL00w?=
 =?utf-8?B?eXZEVW9zR1VuZ1A1Y1oyVDZsbzdkM3F2YWZpMnQ4Q3MwckN2REFoSjlDcHhn?=
 =?utf-8?B?OHVKS09lckRUUlQxcHRXd0NleUVwRmVhb1dPbVp1aGtrb2RkKzMveTZ4Ujds?=
 =?utf-8?B?ZE43VEt3UlRaNXJRS1VDdjhxTnpSQ3lJZVp0SzVvOWI5WTJ1dmpkUFFVcC9U?=
 =?utf-8?B?aWcxbVV4Q0NhTy9NS1FTZHczSVkrU09kNzEzYnh1aDgyZ0FXR0JXdzZ5ZmRH?=
 =?utf-8?B?eVJmN3VIbnNjeVA1MTJZVVp3WHlORHBqMlBUOGltWC9XVHFjRlFUQXBkeEI3?=
 =?utf-8?B?enptSXNuYk8vUlExSzlKdTZNMHJPdm5iM1BGYUpUajQvenVEdk1FaG9IbFRU?=
 =?utf-8?B?SDh5d2JQbWNGaTBscEVpZkpqVTBFdWl5Rkd2ak1laHpKWllLRjJBV0RBUkRj?=
 =?utf-8?B?bU12aWQvd0IvVkJDQmh0dmRXLzBiMmpOMUNUSnJCSC9IOFRFaERRR0FvOEh6?=
 =?utf-8?B?VnpLYWZKMTRlS29IUE5KYU1aWjE1cElOc3p5b291OU5yMVZTenVhcDdnenpa?=
 =?utf-8?B?alkvcDUyanJEV0txclVWSTRNdjFHd0V4VkhmYWpuUjExby8zLzdrbTRtd2Na?=
 =?utf-8?B?bERlRTdYZXpkTGdhU0VDV3dCUTc1TEc3L0FkN3NvQ3loQUgxRmpaYTJHSE01?=
 =?utf-8?B?UjV2ajVzayt0OWpjbVhpV1hTR2tCMjlkV1BRNURFbTcwSUF4NDNjcDZtNWtx?=
 =?utf-8?B?MTNUN1VTMFNna0lUVTlIMHMwZ3RRMkpDeW1pYWgvNFljYktKaWs0ZGlqV3cz?=
 =?utf-8?B?dERhcUZmSHVOdmJMNzY1cmszKzNzY09qdzQrakZQbFdmNHIxTW9aa3lQOStZ?=
 =?utf-8?B?ZEhpL0NmUXVCdVZKbGN6djVWTGdFYWVzcmtpTlFiRE82Q09wbTNpV2I5MTAv?=
 =?utf-8?B?R3pBM29yRmZsSGVnNlhPWGRNV2NRNFpweUw3MzIwakZpeXBtd3ZpQmpJWGpF?=
 =?utf-8?B?UXF5TGJCMVpHM2pNOHpkS3o5RHYyU2hxQ1FtN2NpRVdBZEQ3WHBjZWZhQmhU?=
 =?utf-8?B?OHpSb2lFS0l0c3dCbFlXOFNLZmxad21BdVRsc2s1VzdLUjFlUHBJRGl5eUpJ?=
 =?utf-8?B?cCtGcjBVd2VUdlBIV2hQZHdiNmgxZkJFU3JBRnF0MHBUa2xsUS9lU1phN3F5?=
 =?utf-8?B?bjRIU1lVQ3MxdHVWRDZKcTBzTjRhak8weGFISU53TURYRHYwRWk3WEZWWXRo?=
 =?utf-8?B?OU9ZVzBwamRrNkpTVVNXa3FPaXp0T2RUcXowWXBtTERsbjF5Zy9KcnNiOWda?=
 =?utf-8?B?TDYzU3hqV1hQb0phQUV2MnpSNlFSQTZ6UkNiUVJjQzRGU2RFZ1ZHVEVSamhs?=
 =?utf-8?B?UHhaNFY0R0pqWUVJNUk3N3ZTeVd1dTdrb0RoaVpVOVNFellxNlNvQnNYL2Nr?=
 =?utf-8?B?a29iWUtPTUdqdUdHUlN6YXVLaVF4SmhtdE5UTnl4UGJpOUVMZlpzLzlXN1Vl?=
 =?utf-8?B?Qm12ZUY2RXkxd3F3VUNXVXJJbGpxQlJNUit5T0ZnS3hMckZFNUhNSUxJUjc4?=
 =?utf-8?Q?ssvEgBkDkJMhXMD8=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 837eb170-8a77-491e-c527-08da12e7045b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 07:21:04.8102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1vsJPlb45NcklM5fcre4e9yVEspHl25hjGxsdsHPY7Yfi9F/8/U3GFfF+t9gMd8XN+1T7BkY+0OggZG2OyukNRiEPjhXCiizsH4hRtSx78=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8012
X-Proofpoint-ORIG-GUID: QbXqhVw1ZT7gdlejGXq_D4-Z-3KsTGf1
X-Proofpoint-GUID: QbXqhVw1ZT7gdlejGXq_D4-Z-3KsTGf1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_02,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 31/03/22 5:58 am, Sean Christopherson wrote:
> This whole series needs to be Cc'd to the arm64 and s390 folks.  The easiest way
> to that is to use scripts/get_maintainers.pl, which will grab the appropriate
> people.  There are a variety of options you can use to tailor it to your style.
> E.g. for KVM I do
>
>    --nogit --nogit-fallback --norolestats --nofixes --pattern-depth=1
>
> for To:, and then add
>
>    --nom
>
> for Cc:.  The --pattern-depth=1 tells it to not recurse up so that it doesn't
> include the x86 maintainers for arch/x86/kvm patches.
>
> I'd Cc them manually, but I think it'll be easier to just post v4.

Thanks. I'm waiting for some reviews on the selftests (the third patch 
of this series). As
soon as I receive some, I'll send v4.

>
> On Sun, Mar 06, 2022, Shivam Kumar wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index eb4029660bd9..0b35b8cc0274 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10257,6 +10257,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.l1tf_flush_l1d = true;
>>   
>>   	for (;;) {
>> +		r = kvm_vcpu_check_dirty_quota(vcpu);
>> +		if (!r)
>> +			break;
>> +
>>   		if (kvm_vcpu_running(vcpu)) {
>>   			r = vcpu_enter_guest(vcpu);
>>   		} else {
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index f11039944c08..b1c599c78c42 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -530,6 +530,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>>   }
>>   
>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>> +{
>> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>> +	struct kvm_run *run = vcpu->run;
> Might as well use "run" when reading the dirty quota.
Sure. Thanks.
>
>> +
>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>> +		return 1;
> I don't love returning 0/1 from a function that suggests it returns a bool, but
> I do agree it's better than actually returning a bool.  I also don't have a better
> name, so I'm just whining in the hope that Paolo or someone else has an idea :-)
I've seen plenty of check functions returning 0/1 but please do let me 
know if there's
a convention to use a bool in such scenarios. I'm also looking for a 
better name but
this one also looks good enough to me.
>> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +	run->dirty_quota_exit.count = pages_dirtied;
>> +	run->dirty_quota_exit.quota = dirty_quota;
>> +	return 0;
>> +}
