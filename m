Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2A46940B4
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 10:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBMJTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 04:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjBMJSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 04:18:37 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE2C15567
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 01:18:28 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D77JU7008938;
        Mon, 13 Feb 2023 01:18:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=wyQ8K4F87gB0/naBdIuZsKOEBqqSvZlz6y/8JkpmmQs=;
 b=UKxrcnstbVchBzS0came/x/9ccPA6NOMZt/3OGlEUeV+4r4yn3js56z35rwL3EwirWsH
 vlOJqAE5AWC6SiEMN7u74s6q7g4QcbsyYIhBB8OjITGI8Jy7+VjB+ZGWWiQkkb/5IpAS
 WLYIqbOpFxstXC3NObyJ9yrnz+fy1eSYIrGo5IlXK7aYaSonDeyn2U9Mmbe6ATFHog/J
 N+Jhb68O6eTpOR1GYjR7hcYkPJJ5R4pUSvOEz9GMplaCo22cgbAe60YORPB5d52RpazQ
 6zZHpCe/RbUncixA12K0VSDdF/TMzxvda75dK9M0iLBp5OomGMklTzScekQ8e9eWBP+s 3w== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3np7tdvpw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 01:18:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcgwyMPfPgW2fIarpRoWQDik8OZ4d7DW4wD2VM/UnC4tbXDz2Qatv+uJvDUieg3mNn9h9ZsSlKpJsztDv2ia7/VBJKaj37A1pJn09l/6+4Bgh/QXOcYQpn44KTJmp6sfTZMJ6flLG7AOWpeijVJ76k2OtU68PIYCMF3c1ZSHandw440dtw4guX4Ku87Eakj7wMXO87yLkZny1LRsGxJCecKA27c9lQeUK8LAv1BAiZmm0vj23SA/7RWtz87mpHlWnVDXeyl4WwahGxxA2DC5m9wOFf/eAMYbjiz6qadY6D8Hh1DyItMBJ5uWuI4JPkc0y2dMMa+3Uv3+FS3XvomzKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyQ8K4F87gB0/naBdIuZsKOEBqqSvZlz6y/8JkpmmQs=;
 b=X+MZGX9y8RPl1z1nr0xsJElE6utO1plYxY4ru+Dvir+B6lI7PknjT4PJNtLxkKMmkY1/eIjHrfKO3JBfk5CwYZrc0gA/ysaItdCDzzcuNKKaV6xbEGh8umnIVsMgWiWFJ5lGsKDCJF2wQf9gYFwdA84bK7uOozkkHU0ZuE+qn6WXf2fSVARb5iMKf/k+x69Y315cZ+BQKe7rxH3M4zke1+UEA/S1tZ41Uschuetxa992I1RyzoviJSuZlYcfnL9LkRVgOzUukuc0+0z8nfZyWsuc5t4jd3Hb/+BTG//rpytFymiB39EZRPEtFM31+al+sQA9mcwAubCzK1Cd89YwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyQ8K4F87gB0/naBdIuZsKOEBqqSvZlz6y/8JkpmmQs=;
 b=BKiGSvnqaAQIqxH6vKSe9CDMxWQdv1nsLSsOtUp+RX2Tkb/UE3+sYkgGUWyaUG9yo/IaeAmvym7ZGU1EEP+1W9GZQ8I88ZQuRyc3twj6ugaOXr9ZuHe59WvRK3aUN1uJoZCtwA06FRoX7aZ497nkamm2ufn3edb2kDrnn2KRgldO4Fmj8PY3y9ximBLGc5UBdWEBH8zXnnx+Lg8G0dShFRJTJNfuoOKRA7ltpjJWLpBLpNqbYFl1Lo5EcywdsafFdK5XVRC3jnE4c208SVK77S+MGjcWu0dJlJ8S4s0V9RQC2e2xGJ1JU6448u43w1B7cE9+wHJRhBG4wg21Wo8jQg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SJ0PR02MB7823.namprd02.prod.outlook.com (2603:10b6:a03:31a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 09:18:12 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 09:18:12 +0000
Message-ID: <ae726bee-9bd0-bbbb-c416-0e1762cc57be@nutanix.com>
Date:   Mon, 13 Feb 2023 14:47:54 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC PATCH 1/1] Dirty quota-based throttling of vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
 <20221120225458.144802-2-shivam.kumar1@nutanix.com>
 <dcaf828f-5959-e49e-a854-632814772cc1@linaro.org>
 <8cf78246-d00d-dbab-7e67-0ba09300e6ed@nutanix.com>
In-Reply-To: <8cf78246-d00d-dbab-7e67-0ba09300e6ed@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXP287CA0013.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SJ0PR02MB7823:EE_
X-MS-Office365-Filtering-Correlation-Id: 277049a4-d36b-4c57-32a6-08db0da33aec
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OxuXCNlJqKEWIVuwCeNQfA7M7Eg3/w+veyfSc+nldKetLCmMn1Ezk4BKjzIkwJUPPhoEJosAW9ptT2w3nj49eDnRrcCO3h4fMgyn62rQgk7MfMF3T9kSr/uw9o0zv3mCn6ECXlA/CBNqtj6sGUX7qQKumCUv+31UdiL/gF4H8YvdTpDTaVkF+zNLilIIkVELt8z6WqnLmI4Tx4xzaJX0TUfNht7Vq19wTrIEG4LsyfrNmjG+gplbOs/mz96DYjF8l2U7wBceeMjGMExWG6nnUObI6YOEYEexPhzFYyW/CWy76ESsKRfVNtZatLSjZJ/E9Brb06tmi2402UFAewTQXDXS8UQIh1+lC7Pj1DtgLL3ce4Qr77T8GdBUZ1p4eRWQKuqRD5ZE+0JMhtkg4U1gugDYJ6wv4WCoAxNEYPZTmSBudxbP2RBEAOAwubJLt+P5SqGuYylO66Xa4IMf55W0DSACSRsgNWjYGQFVUe2PjEyx2xyMWdNeFyc08a2cruOn8EvNloN4pXWeDRB1Zia0U+irc9UshYV3oHJIb02XU8DCUCla8VzVlsabveqf9i7Uh1owPh2M5NxXMUmUTLxbkyqMo8j/h7+KVd8aWQL9KbenT9tK5NEiM0lpZkFnuwT+nOSEsx3vczL76bYHW+M36Ba5A1W8QOOTOnzQ2bNbApaK08mDgasTMfaqMUzdr8pw99QmhGAGpxOHobrIUOq9TFQWOETEFw14T0vw8NYlYtfVz6/Yx0vSN7JEP784iCOO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199018)(4744005)(15650500001)(2906002)(36756003)(5660300002)(31696002)(83380400001)(26005)(186003)(2616005)(4326008)(66946007)(38100700002)(8676002)(316002)(54906003)(66476007)(66556008)(8936002)(41300700001)(107886003)(478600001)(6666004)(6506007)(6512007)(53546011)(86362001)(6486002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXVubFVrZEtRZVhsUWpPVTgrN3p6ZVN2REluUG1LMzRaY3pDS2kxSlMzaG93?=
 =?utf-8?B?eUxuaDdwOVFHWmtpSFJPRGMxRXlFMkFUSHp1Q2VrTmhsUEsxejhVTSthTFYy?=
 =?utf-8?B?OWlDWnB2VUN1VE5OTjF2VTEyNHBoUUlvdVFKNUdaK0daUjcxNmNzT3F6WWhv?=
 =?utf-8?B?U0VrOFJBaTM4N0w2c3MwR0c2cHhIUzhoa0wxVS9mbHpyWVBTRUJMaTNqVExP?=
 =?utf-8?B?bnFGcVQ4RWVud2JGYUppek13cXhkMlJaeTdkaGJLM0V4b0JrM2xORHNXS0Rw?=
 =?utf-8?B?N1lPT3RjVUl4L0tyMTRBUFBYUDBpZGw0TkZlOTFhbzJiZExkSHFYa3R5QVhG?=
 =?utf-8?B?bEZxa1IxYTFxMW1MN3FzRm9vaXdhSlNPQXBQQlFhL2ltKzdWTnk0TmcwYWNP?=
 =?utf-8?B?aXJVUnQydjhrUEFRejN6QjRBb0w1em95NmwyV0hRd3U4L1puU1hQNU15emwr?=
 =?utf-8?B?bWloNUZwcjdZUkp3dFpyM25JVDgzZFlDcjJRcWhuM3FMTlVSOU5FcDk3dHly?=
 =?utf-8?B?K25ucEozOWNId0FWbG0xbWpFaGh0UVhueTBRMTQyY3Bra1RQK1V6Nm9iVFo0?=
 =?utf-8?B?R2Nzb0dRd2txUkVuZEFGUXdhYjhTZjNNR056MkN2ZXR3OHBLaFBjOVFOTEh5?=
 =?utf-8?B?a0FOR1hCN1I2bGluTkJGT2hEa0E3TTNqZDYzQ2FrSU9lYWZzbFMwbzJXT1Nk?=
 =?utf-8?B?Z2tJNUVNbEI2NGUyQlUvK2todWc2ZHpxY3RUay9sK2FJWCszN3Q1cXdGb3Jn?=
 =?utf-8?B?Sm5oM29TdmkvVU9LUDZNR3IxbHlmZkNlMTNnOGpmbE9HMWRMUWlqaVJjVy9w?=
 =?utf-8?B?U2pWUzZZMjlGK3RNTDNYY0wzenFuNEdqSGR1WE5MUlBvb01iNmNkK0IyaTJm?=
 =?utf-8?B?bTJkUnFMMzBmblU5MFBldlk5bmlFZkdjdnhqanUycVR2akJIaVR4ekt3NkVE?=
 =?utf-8?B?UHY4a1BCUHc5c3M5M24zVkRLcFdmWUM5Q3BZM3FoMWxXQnZuc0w2d1NhSWRH?=
 =?utf-8?B?QXFSUTJJSlFzR2U3UEd1QW44dTNsUGpwVkMyRnp6OVhFcDVpU0s1YUUxVkt5?=
 =?utf-8?B?VXM4Y2VKZkx6aDF3WkViTG13akcxUnBGL3kyUkhibXM0UzBRTGEyWHh3d3U1?=
 =?utf-8?B?dTRCbml1ZlVBRG9hU0M4UzZBSDExUjFsV3Z5MGY1clp1VHQrMUp4bzdkSHhV?=
 =?utf-8?B?Z3dBU2VZTXB1d3AxTWh5amp0NndOVlZ1ZndQNGpoQUpVYW93Qk5VNTRRODBC?=
 =?utf-8?B?K1I5VHh4S1p0RG5tK1EreTdYTFVYSlR0aU5oUDkxV0ZmQzNaS2hyQzc2YzlX?=
 =?utf-8?B?YjMrNXR1MW5ZWGtDNzhvalZxc2c5b1FRRHZFaU1udGFleWMvOEZjMkpQK1Rt?=
 =?utf-8?B?bWQrSXJINklGVzN0KzRyaDBCSE5xT3QvMWUvSklQSHAyYWQ1aU5zKzArcHR6?=
 =?utf-8?B?ZzcvdllWWHZrenFRUjh2NmZzWk5uUFR4dDZUdUMvaFlRdktyR21PMVlWRGJm?=
 =?utf-8?B?VDVZTmVNNmdlNDBrbDBFcWlQbGJONHBSMUdlOHUvNVNOWnAycWk1Ykt0MzlU?=
 =?utf-8?B?TnJnMVQ4Lzl3aVVTYmpLalYxNXRiTW5jMVRWOUs3VVlwWFdSSnp4ZVRieTdB?=
 =?utf-8?B?ZjArK0I1c3lUYi90SFNVSU85QTZBcTJncG0rZnFQQ1dFcGhVNzg0TzEzVW0v?=
 =?utf-8?B?WGJ3MlcvZXNTbGpwK1U1Y1RGdVBhVzRlWVQ5NHdaMlNSM2UwVUpPbUhUT1BT?=
 =?utf-8?B?NlFhRC9VSVJXbmcvUVpvbFU2dk85Z3F4OFp0WlExOERqK0Ryb2QyUDE2Rmll?=
 =?utf-8?B?bExHR1lYRGRnVHl5TG5RSWVUelRyVFljNWRJbXk2amMxOGJTdGpyYmdMWkNl?=
 =?utf-8?B?WC94TFIrZ3BzaEg0OElxUWdScDA2cnV0LzU3QndpUVdxTDVhSUtIRlVOOGlk?=
 =?utf-8?B?RlNWUnVpQXBxNnNlblBvMC9aY1NKK0poNlRhSGg0dnM4WXNaZk1GbnVvYzVZ?=
 =?utf-8?B?QnhnUXZCZFFDWWRSejVYWWk1ak5zbWFlZ0ZzblZEVjcvYkhCNzFkTGhHYjhi?=
 =?utf-8?B?aGRxU2VIMkQ0VnV3RlhGMTF3MG1jZHVmamhVU3JESDJjZnVOdDFmaG11U2dq?=
 =?utf-8?B?UFZPL0dWSU1yVU5DREV4Z09sY0haRVdaelhPUWpmSWtqTXlMSmZ5dTc3aWhz?=
 =?utf-8?B?aWc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277049a4-d36b-4c57-32a6-08db0da33aec
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 09:18:12.6038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJzkbT906wcI0UlDQIY21mChIf46rCiECcAGFt3sPxQbELy8MMUpggJWryDb7JzV4Y3w1l1PraJo85J+8XLHN/Q8TzYkyItNBWS5g7TX8Ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7823
X-Proofpoint-ORIG-GUID: hNnO1Pp1iinZFUBZ4Z3dgT18K-br7ZyL
X-Proofpoint-GUID: hNnO1Pp1iinZFUBZ4Z3dgT18K-br7ZyL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_04,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22/11/22 9:30 am, Shivam Kumar wrote:
> 
> 
> On 21/11/22 5:05 pm, Philippe Mathieu-Daudé wrote:
>> Hi,
>>
>> On 20/11/22 23:54, Shivam Kumar wrote:
>>> +
>>> +void dirty_quota_migration_start(void)
>>> +{
>>> +    if (!kvm_state->dirty_quota_supported) {
>>
>> You are accessing an accelerator-specific variable in an 
>> accelerator-agnostic file, this doesn't sound correct.
>>
>> You might introduce some hooks in AccelClass and implement them in
>> accel/kvm/. See for example gdbstub_supported_sstep_flags() and
>> kvm_gdbstub_sstep_flags().
>>
> Ack.
> 
> Thanks,
> Shivam

Hi Philippe,

I had received a suggestion on the kernel-side patchset to make dirty 
quota a more generic feature and not limit its use to live migration. 
Incorporating this ask might lead to a significant change in the dirty 
quota interface. So, I haven't been able to post the next version of the 
QEMU patchset. I intend to post it once the new proposition looks good 
to the KVM reviewers.

Thanks,
Shivam
