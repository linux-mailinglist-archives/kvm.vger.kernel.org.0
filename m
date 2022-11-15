Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29575629144
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 05:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiKOEt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 23:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKOEtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 23:49:24 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A2D11C26
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 20:49:23 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF0E5WJ017067;
        Mon, 14 Nov 2022 20:49:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=0SYHgj62V7B/eDEgDFqIeB3ORCHGOpBB3xJbTM61iuk=;
 b=EJNA3fFjNJwm5EavA7kpRD4aDyc57/HoW/K4v2NTyZpGFDQRFRD0UaJHsZWt2i/cGiPn
 rRoOc4Ket7Eqy2kOZjNt7sSjVdmktGH2IQ73jrJzkaX3zr/ECaSKFQlfuKKYcpfMWxzy
 x2vpllKwS3lcf843hGdLOsvodD2mxTC9knhKMOWTolUTkll0gxpDHsI4VQUqubSovSNE
 Aj8uVVjvG6e5PTA8rNrdGocDvsUjhmWMZQtbPoBcu8Hx2AVq5BZvDHNr4NJX67Gg08GZ
 Y4HPGSLN/D3CbjRKv0GEec88RyGEug3mjbswLa1c0VAPXyryAnFHHRCYPtvXtOsvi7VR FQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ku2n6bwa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 20:49:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABeI+UIyuFLvVOiwxitS/L0Isjauih+rNvPRam78bRDCM2ApjHakyHHVdd5agHkIMuNsgs4Jw7NQP31/MubjPQH68ObQ9p74wcoMSp51I3EGOziad9SRS5kgdTwJjXxMjOgZk1qfcCfC6osKQjjk7kZMhC0HNAptRiGB/femDeghaxqOGWQnQWF4wPTwFwFb3zPrTukxkRTyQB8Tp7zAtG4oPE703nS1fPB7VVeoc18BF75MaPSPW5ldsB/Hyx56AhZIBD1yUqg+30DBgnT82rcugvkNmChkH8r+HJwMyrImsF2Hs887amiVpEWlmlcpV6PK44OJkZHxCD2x46aDLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SYHgj62V7B/eDEgDFqIeB3ORCHGOpBB3xJbTM61iuk=;
 b=X7uSrsUetODZXsY+5B6CC1ex9iUy5uVyyS0sBGPd2RQlor6Ue9BYyfuP6Qy7yRhEylyjlh7R9m+/VaJ57Ego3srqsSzKj89GtQa5tcD1WMsFGXEDd2Ro7T5cewcBAi2H2XIjbQKatVOZO/7EDqX3Dha/QkureNCELOlj3nLzsUefP6lzAVat3Vi6atgh3cLBLtHhDjaDDfB9Jt8qNGFOfrQRbFzMpYU+tKO4hqY1jdIWDvGgzeE8dS4sz4O4JCgIbZTqwkE3EZsTbBWXTdHQ/yCCXaQLGhwd4sRzuLchVUZpOz6EXwtYCkkQoYJ8/s7HB8tMjrs8/dhMDsyR142f2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SYHgj62V7B/eDEgDFqIeB3ORCHGOpBB3xJbTM61iuk=;
 b=TBq0PJ12wjCgHaUfMexLw7te7In03xGydHqAqQ9cu8nh1reLmz1me7XPQ1BeHesD9XXHi/h063CgIMbK/gnEsyPOwpqqtY80RiqJxwBeBCtAKfI93jCVjbTTXG86YzlDU6Xq4DkZ6IXgEpMIj/XWC1u/p+LAoHUnKYrqwYFi8PNEf5jAMbPTbq4RhfDe3vkx1Ju8DPlxDGtoHRjaAX/s+BnAeLGTj8m3ZpKHb1rvhMV+NKCat2Bwg6M/O3GAFM3BGqlt/BW0lyXOJOxyKIuBJgcjADm7n4jusH9Z4ZfVlEkezGFzSlcKzK7XTcV5uZuQmrW4ykHuazvLU1V7zl3Mzg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BL3PR02MB8146.namprd02.prod.outlook.com (2603:10b6:208:35d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 04:48:59 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6ae:b51b:f4f3:3c20]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6ae:b51b:f4f3:3c20%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 04:48:59 +0000
Message-ID: <7a4b37ad-dad1-25e7-456e-fe974d74dff1@nutanix.com>
Date:   Tue, 15 Nov 2022 10:18:42 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Yunhong Jiang <yunhong.jiang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <20221114232906.GA7867@yjiang5-mobl.amr.corp.intel.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20221114232906.GA7867@yjiang5-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1P287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::33) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BL3PR02MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 7796e143-a871-47d0-0a41-08dac6c4b59d
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uZ3u+bwCPqF+WifbHWiDkteaMEVGbYAbw+GwKtZQ8w6R0d6xb/D3ojgiWhn92cOOVcCrxlxytClkxjpDxz1BJbVJUftfsNuAf0BpHGbhtkq+fmN+JVt3hdx8JDGzKLArXlv+Nr2R/ZCKuawUJeR3zm4E+ZK2lJTkEyeA4qdeYFmc8c51Y/5wDEFwwT+3aYEOjQUIbQ3RfPX1keAI9JApQCXDJ+R1NzfBPMQ+x6wWyD+lQWaEAFAu0ZLNXf324qQWIduoXiyvXMTCO1P0winlII3NDe8ccnCbkngsOIa+zRa1+XHNaHpseuXBWJAvghEVoGFapcoQwjWpieDOpqwGvQVmu4wLmfhg6rg1air2PZUwzZ2OJcJzv87eozDg83bbFNvWrScm5Lj+GQ3R6GC8ANwkNziVYA4A2SqDgHAEMBAGUk2zEvee0wVzbzScmOmnCs4klXDKFzyaslxLhxNBv3/FYfnJ8uXpqKJ2QSV2pKXi0LmXXJYUlZTfouJhMpMDy+FCoZRKu+2F5HxXqB2R/6hcJ1gxIkVhbH8DY/9g5C2AIlchJ9TGYkmna4aRDnGIaa620UgI/uqDYvuvv7UbiZuU5Ou9z2r5MtE+CsgEfv4IZ9KTLa/bTdFJEWQmMYH+C7ybs44r7RvxfY3a3DsJp0hj2nHBzI/Zfn17HMX4Y2gJT9fjZl4smi2iqty08zdObjz7s5oSEp+8/ngF4U4nEE3axsTeuCIptZqpWk6oRoejvo937ZOR+M2B/IWCO1Fh4gb4Yil+JlsXWJ9RWCA5d+vDcSPo2xOslzhcoLr/mzj3eUImwULmHlhu/MfOOn4nV7wF9lrqKJlBrodWjLz1nhsrzuc+CImIELGfLOjcXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199015)(31686004)(478600001)(6506007)(53546011)(6486002)(966005)(6666004)(107886003)(6916009)(54906003)(15650500001)(86362001)(6512007)(26005)(31696002)(316002)(38100700002)(8936002)(8676002)(4326008)(41300700001)(66556008)(66476007)(36756003)(66946007)(2616005)(5660300002)(186003)(83380400001)(2906002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L25XeTVIemNYRkVDSDBGNmVRQTlSZ1EzNUNqSC9pdjFCdUZpWFlMV0FPYXd2?=
 =?utf-8?B?clBQQjFUczlxdlk4Qjk2QXlzWG1jdXpvdXJ5c2xFMUx3Z0JtZGd2Zm95akxk?=
 =?utf-8?B?TkxsbDdLVldtSENLbWY4RE8yUGJDM3NCcUpOOUxUdllXZFRMU0FxTEIzTHBK?=
 =?utf-8?B?M3dFN3EzTXF0ZW1lWExVcnFXZXdyVDI0bGM5RUNUd3M1dkJycGpBN1BiZERM?=
 =?utf-8?B?TlU0ZDdBbDd0REZoemM2ZG82cmRMR3A0YjBsRzFBVDZJUm1ZNm96YlR2aWpY?=
 =?utf-8?B?MytzUXNDVHExV3VrL2RMcW5jZGxXV1V1OVh4Q0p5dGlHUTBJTmJjMHdEem5l?=
 =?utf-8?B?Z2ZFUzdqc3JPY2QzTGJGUXVDY0FRRnRWRHJDbk9xazNUZ0VvK08yRmRvWW85?=
 =?utf-8?B?dy8rOG5xT3F5NjYvVnFKVzNMYmpVS245M2ZQcjUrY09vNEVwMWVoS0NOM2p1?=
 =?utf-8?B?Q2JSamV3S1A2bVg2YjQwbzBwZTl6Zzc0OHI2eGZ6RS9NK2NVbncxNUZtRENB?=
 =?utf-8?B?OXBWVzNXdmozL0VqdE1adkhOSE9kbnVDOTNrVEFxY2MrUXhiNTN6aWdJTWl6?=
 =?utf-8?B?SnBoaCtxY3dYSlpsZ2t6UzBWRzQ2YnNDTVVRc3d1QXhiaytudVdoeEZ1YWxU?=
 =?utf-8?B?bDllUU5Zd1hrcU0vZlV0RHQ5YmJYaDVobFgreWduemZLYXZpTjcyNG5VY3R1?=
 =?utf-8?B?QTZzOVVYMnNvTmttZHQ5TWhjSC9kVHNZUGFPWnNEWGUvT0ZKRHpLbldxZDZu?=
 =?utf-8?B?UjBGVGR0aVhjSFRRaVVCdUFPcDNuUnBudi9KN1ozcFM5dHBzOWQ1YSt4SUd2?=
 =?utf-8?B?amE0NCtuazhiSm9NME1JQ3hvZVp4WlRuWUJHSzRMSnVDV1I3ekd4dVVrdVFo?=
 =?utf-8?B?QVBnN01VVEFHR1ZNcGdabkJwK0RVR0l0Tzk4UG41dU5yTjhEY0laK254cEc5?=
 =?utf-8?B?ZnFKd0RMdUdqQlRrRWtKTTV5WHNtRndXemJJN3hxRmZidEw4WmJINFdUN1Jz?=
 =?utf-8?B?WWxob1FxZGNMZVg2RlphdXc4cEk0MG9xTFZzZE1zSExjanhnKzF6NldWRVRr?=
 =?utf-8?B?T0hvOUd2am1zUW15R2M4SUtKZlhQMFJETitpZVo0NTgySTdKMXdpd1pQbisy?=
 =?utf-8?B?ejJTSFEvQUdjT1hPcEhYMVNtM1NOT2hKRXFoSk4ybisyRk5LZG11YS9ROFZL?=
 =?utf-8?B?VWdpa2wzRUx3aEJtN0h6Y2VnTjlOQ2JCanZmSU1aWlQvY0x2cGVhQkNoVThk?=
 =?utf-8?B?QVU0Z3RBUFp4RzBPWmVNV3lMcXBxUlNMc2h1Q1dCcTUrZ0hVck9wSXBVNm1j?=
 =?utf-8?B?cEFGS2UzTGoyYXhmVW92SkwxczNPZHZTSThaUUZFNitCQWEzNkw4RnEvT2k0?=
 =?utf-8?B?Y3EzVU9HazdlbVM5Z0h5OEtqbXBMejJCcHZQaHZUYnNXRzhNN1FEdXRHWUZR?=
 =?utf-8?B?R1pUWnk1UmJZNTdEbGdrUEpMSmZ1TmFEeEhKRm4vK3oyblNWSlpiZHF0WXY2?=
 =?utf-8?B?enlLV2tPd2lDZGxTVWpKcm9vS0RST2srU3ByZ0N0aS9mMWFpV2lkS2pKNG5x?=
 =?utf-8?B?WlN1T2RaL1IzbFdGRFZYQ0VUNW9reXp6aGRtYVN0aHQxS1djQzduOHB0NFFJ?=
 =?utf-8?B?MjJac3hOa3I2Yzh4LzNRMmMzZUlJR3RTS25qd2JHZXRGU1IvYkNSamVRWnpG?=
 =?utf-8?B?Z3NpVVNZM0psbzNRQXFhNzdtTFJjalJPM2xadURqcE13MzVaK1dFYThEdG5Y?=
 =?utf-8?B?eWJjaUlHZDVUTGtxVHd2TktZNjVKcWxIcXlab1RQSC9kRDlpb3JjWXVIZTRi?=
 =?utf-8?B?UEoxS3ZuRTlXRjFoQkNuQThyNWZFMmx5QzA4dE5tbm9YZGx3bEZudytyNGVI?=
 =?utf-8?B?b3p3L0kzcGtJbmNtRXRGdVZ5aElnbnZTWUdxQnZNUGxEU09ZWVpQWjcxVXp6?=
 =?utf-8?B?VlQwSHY2dm9WcjM3VUp4b2V0RmI4K3JpWm9TaFp3dUFtN2FyUjlMelB3ZVFy?=
 =?utf-8?B?cGd4UHVLenE1OVFrQU1nRERDSk9uMzZqdFAyeStOTDlvWjFFUTMvQVgxcllD?=
 =?utf-8?B?TU1wNmZTWWJxMU5hN3V0a2ZBeFFvbzZ4Z3l2NEo4YlU5TFNSMVZENk5JaWNj?=
 =?utf-8?B?Z2lzb1BWRStwZVVzcHIyRkxhVFk4NzdDQXk2U0tGbzEvWVliU3RqVDhyS252?=
 =?utf-8?B?UlE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7796e143-a871-47d0-0a41-08dac6c4b59d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 04:48:59.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rSXPVSAKnETMNCDdkWpiYexwhLbPsNNaMiX2A7YGmXXgxIRIgLdHz3Slwv0L2ePlO26rm0X1iVy7fu4UgllVqXQzZoWtKVNh/GeTrYAej3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8146
X-Proofpoint-ORIG-GUID: SUi4kN5E2DCT1Fv9juxgdDJAALzRFY7t
X-Proofpoint-GUID: SUi4kN5E2DCT1Fv9juxgdDJAALzRFY7t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/11/22 4:59 am, Yunhong Jiang wrote:
> On Sun, Nov 13, 2022 at 05:05:06PM +0000, Shivam Kumar wrote:
>> Define variables to track and throttle memory dirtying for every vcpu.
>>
>> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>>                  while dirty logging is enabled.
>> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>>                  more, it needs to request more quota by exiting to
>>                  userspace.
>>
>> Implement the flow for throttling based on dirty quota.
>>
>> i) Increment dirty_count for the vcpu whenever it dirties a page.
>> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
>> count equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 35 ++++++++++++++++++++++++++++++++++
>>   arch/x86/kvm/Kconfig           |  1 +
>>   include/linux/kvm_host.h       |  5 ++++-
>>   include/linux/kvm_types.h      |  1 +
>>   include/uapi/linux/kvm.h       | 13 +++++++++++++
>>   tools/include/uapi/linux/kvm.h |  1 +
>>   virt/kvm/Kconfig               |  4 ++++
>>   virt/kvm/kvm_main.c            | 25 +++++++++++++++++++++---
>>   8 files changed, 81 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index eee9f857a986..4568faa33c6d 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6513,6 +6513,26 @@ array field represents return values. The userspace should update the return
>>   values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>>   spec refer, https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_riscv_riscv-2Dsbi-2Ddoc&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=tRXKbxC9SnS7eawp-UoL_Dqi0C8tdGVG6pmh1Gv6Ijw1OItZ-EFLCPz4aAQ_3sob&s=HFLZ0ulDwLg_-wHdDvDhunY5olDW4tZ-6NQQE9WirIY&e= .
>>   
>> +::
>> +
>> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
>> +		struct {
>> +			__u64 count;
>> +			__u64 quota;
>> +		} dirty_quota_exit;
>> +
>> +If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
>> +exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
>> +makes the following information available to the userspace:
>> +    count: the current count of pages dirtied by the VCPU, can be
>> +    skewed based on the size of the pages accessed by each vCPU.
>> +    quota: the observed dirty quota just before the exit to userspace.
>> +
>> +The userspace can design a strategy to allocate the overall scope of dirtying
>> +for the VM among the vcpus. Based on the strategy and the current state of dirty
>> +quota throttling, the userspace can make a decision to either update (increase)
>> +the quota or to put the VCPU to sleep for some time.
>> +
>>   ::
>>   
>>       /* KVM_EXIT_NOTIFY */
>> @@ -6567,6 +6587,21 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>>   
>>   ::
>>   
>> +	/*
>> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
>> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
>> +	 * is reached/exceeded.
>> +	 */
>> +	__u64 dirty_quota;
>> +
>> +Please note that enforcing the quota is best effort, as the guest may dirty
>> +multiple pages before KVM can recheck the quota.  However, unless KVM is using
>> +a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
>> +KVM will detect quota exhaustion within a handful of dirtied pages.  If a
>> +hardware ring buffer is used, the overrun is bounded by the size of the buffer
>> +(512 entries for PML).
>> +
>> +::
>>     };
>>   
>>   
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index 67be7f217e37..bdbd36321d52 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -48,6 +48,7 @@ config KVM
>>   	select KVM_VFIO
>>   	select SRCU
>>   	select INTERVAL_TREE
>> +	select HAVE_KVM_DIRTY_QUOTA
>>   	select HAVE_KVM_PM_NOTIFIER if PM
>>   	help
>>   	  Support hosting fully virtualized guest machines using hardware
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 18592bdf4c1b..0b9b5c251a04 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -151,11 +151,12 @@ static inline bool is_error_page(struct page *page)
>>   #define KVM_REQUEST_NO_ACTION      BIT(10)
>>   /*
>>    * Architecture-independent vcpu->requests bit members
>> - * Bits 3-7 are reserved for more arch-independent bits.
>> + * Bits 5-7 are reserved for more arch-independent bits.
>>    */
>>   #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_UNBLOCK           2
>> +#define KVM_REQ_DIRTY_QUOTA_EXIT  4
> Sorry if I missed anything. Why it's 4 instead of 3?
3 was already in use last time. Will update it. Thanks.
