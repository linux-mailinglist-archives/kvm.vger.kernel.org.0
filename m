Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18255F8D65
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 20:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJISuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 14:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiJISt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 14:49:58 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFF1FD1B
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 11:49:52 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 299I9xji011389;
        Sun, 9 Oct 2022 11:49:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=739fYIbTioUE9/vWRRvIPtqUu9edabAswMN8V4iQNJs=;
 b=Yp08xliOa727aFOeuBmqKxM8xqm6XdtlbUy51upBxXiSPoU2oWvBj0T5ltwAZteoptJe
 dOdQj31LP9Cs/jw9T7zOwYYzYMNy5DRWJpl1fOc03AcNAxGQZ3pbxxNshBvcemUHuYrt
 jBhDS4/D3XG0p5ptayz2xxk7P19bQegbskYAZde4/mlmBqO2R02ggaMUcUMVLedttQ8d
 9fH3y8a3k3KvAAyZJkkU65FGAr1tHTyQNd0/dgHLmVCjMKPPNIHaX1WBr9zzeJB0Kuk7
 gHsdME8a8EmMoI7LbLhTwG8GX7OPO69oCjEIED539MaUlXH/1zvkzViQQzRXjuJ/fnht gg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k35ht2adv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 11:49:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0DkR0NPXK13IloJv6j9NAFG9Ux3r9cnNrb2W20TSD5/EzhAre3CmQTrvgwzhUF7eyzBnmhty+iUjJCPAOimosM3IadVifY2fHffbQtt4pCXHEbziQO5dteBoI4bRyeQhPYezRAgEcxLIOa1M1Vr8NmoMYpgQbOwZj8LFF9oi6xlpE7NILvcNYxmIaqJaRef9NQjEfXDUYiUDhFh9iER/mmS9egzPww64vKayb/QRwW5LmB26gTMEtW8JcVHFvJXHixoS6jqWM5WX3s3A0b6x8Nr7hY4gkev/lb9WKDWQVxoOmTgUWGPEqPX+8CAnyOd7wph7ywXYnQ9NZTypYAgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=739fYIbTioUE9/vWRRvIPtqUu9edabAswMN8V4iQNJs=;
 b=bF2P52MrXfm0hYDig2M3FMDenbZTXh9L5jDixjF9y56CsIQzhn76g059529hZvgmp0l2SO6xY/zSd15U2ahQkLHp432qwUVZ2YWawUSDD4PCK8Ysys73UNYXIP/CezESpd8KgKDYFLyWbE/Xr8NUN/RKAjVVjZaAdcBOWP2Vufo+Y7Wx29clBvv5pw7ub5AJVpdHVwmSor+9DTWwC/TYLcf151O1S8rOUDQiN5m5OrTq2G+KyK+j13Pwk6rUxse0m0uS9dhEkytPLP8a8yIkpbHae+6RbLE3pi9ciqYB83k1RkGJ5bgcjGTQGpptXUG/lIqlFty8a2Z+fLAFCmZ2ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BL3PR02MB8162.namprd02.prod.outlook.com (2603:10b6:208:35d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Sun, 9 Oct
 2022 18:49:37 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Sun, 9 Oct 2022
 18:49:37 +0000
Message-ID: <7e3a978c-381c-5090-0620-40b7d6ef6fc0@nutanix.com>
Date:   Mon, 10 Oct 2022 00:19:25 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <Y0B5RFI25TotwWHT@google.com> <Y0B753GVEgGP/Iqg@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y0B753GVEgGP/Iqg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BL3PR02MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: 863304f9-fb80-4c14-d7fd-08daaa2703f2
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYmrlV2/qqmG3yO5ONX+w4sjbYKrM5n2iAOPh/n9kiEKZw1PeGFT6+578og9xcfvej1ewaW2j3PI7m1r6gYGykymj4FT0ubDPpwN+OLehg3b6HgRlIzxFl/ZbGndclP+3SFqtk2Fj6RoO3Pvf/AjOcxrGwVl0l7AzLM7MkzQUCTo6wGwymZqsUln1dLZEx1InL5k3adRkErjMeRlSPqNhy75hvY4U05xZwfCJHZoxyfAlnuP/RgRuYrjXfIMdEC9kr8aTROHSRw4WEiQCjlhdwENsyuksrlds5mcwYcQngv8oXYXnJh1ERUXv5vjO+kZMfIiUHgDyX3gojxPP2cbDogfpc571il9p+B/tnJgXrCPtB+No5DIddRws9bMds4uaLMi/1rSiCYLqJU75rR57TJEklPWiq13KDznAn4egXsCAEs9qw1mMuIcXqmBwp63OyBPnSj5AEDKePsWvi3Ip5Lid0tQYdiEFfR+nNWXETqAZsHceJPiVVm8FgBuOKwUF1aYxFds/HCSY28jMPU9e3QSLNPL1sxAKXchv49dng8V1R4f88jKscwW4zKN7kRFu6MddiQzxeU5WmoRuYJ3DA8ARwscUEBuytnEFyi/QN4k9B/JQ3N5iWeDTjS+xP7ehb0/N3b17iK6GkR+cOgCSXG8zkyWIwNvzeVmJQSBzIaeLlEBEtV7rSDPYuUDj8CuFOqA7sUWZpS5JBW9Cje5Pjzumy3mD+7nCoPxGj9LU8lKiQIfkatPXPV4sZe165N4oUsUIySgaVFZgE2Gml84K4EzufNhEljGA0tGbyWvbXc0y05/IiakUDolppID4LF38IYvuL0dKOsQjzAhPBPrJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(376002)(39850400004)(136003)(451199015)(86362001)(31696002)(38100700002)(8676002)(26005)(66946007)(53546011)(41300700001)(2616005)(6506007)(4326008)(6486002)(66476007)(6512007)(66556008)(966005)(478600001)(6666004)(6916009)(54906003)(316002)(2906002)(15650500001)(186003)(5660300002)(8936002)(107886003)(83380400001)(31686004)(36756003)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkEvdXBWYURWNW14NWNzdzZZZ083cXRCb0RqeU85MHdTMjlYajFVYzlmZzRs?=
 =?utf-8?B?bkczWEJ6aVVhZDBmZjBSL29qNVlLWk44ZTdCcTNTVmd6Y01WM1RkdTNERG5l?=
 =?utf-8?B?dXJpaUE4M1pUcmx2RzVRcExiRENieElLZWYrenV3K3NJTUZ0VERqVDFTajdn?=
 =?utf-8?B?NSszZTZNdUhmcTBOTkgra0oyMmRGMFlFQ0ZjRFBmWW0zT28wZkp0cFlwV3Jt?=
 =?utf-8?B?ekRiQWozbzFPSy9xaVNSWkZJVWRNWVdwV3V4TVpXYTlNUW8zMGdKR0ROYUwr?=
 =?utf-8?B?TkIzSFh5R0NvZEdvVkxFd1p3bDNkWFg2NWVScm8xN3d5cGdrUVlNOFRLR0Fz?=
 =?utf-8?B?elBxUHdnQUgrMHREU0Zrb2xQa1o2b29renNXY1U3ZEtaNkZDUmNna0NWdjVJ?=
 =?utf-8?B?M1IwMDFCd1UzNDZQWjhWNitWRWFLVkVzdDZ5UllWa2hnaG1sV2pTQko1RXEv?=
 =?utf-8?B?NWxJR1ZtaUZUekQyMzdpaE9SYnMvYTVNNmorU1lMOW9DTVhaZjdDcCtZRVAy?=
 =?utf-8?B?VzNGSFFodGcyNS9rekJkTmlSUGtlc240YVFZeWxSMGpSUTV0TTRoazNhZ1dU?=
 =?utf-8?B?U3dCcmNacGZhYmcrbW5odFlJN3FzNm9CakJkL0VHcGlEbEhFR0loN0xBZlh6?=
 =?utf-8?B?MnBsK2N0UUZnZzJhektGOFhpeDc3Rml3OUhna2ZlZjJZVjV3UWErbk41Q1hO?=
 =?utf-8?B?MDAwMU9kS1V6eUk1QnlKa0Fqdnh0Q1pITXB0eEZzTzJFNzBvdWNvN2FWZjNP?=
 =?utf-8?B?OU9QeEJwMnV6Sm92Q0U3b0NYYXkyaFZOSTZ6ektXSUNDQ0FWdWUxWFdaL1lQ?=
 =?utf-8?B?TkxYZWpoQnBRZDdjbjVNS2pRaWp4KzM5MFUxVkJudTZSU3B5RlFYOGNwUW91?=
 =?utf-8?B?bkVodzVUL1YyTTJIUWpJTktWNWc0WXJIcUhWWWN6WDB1NFQvak9ZRVpWTU5F?=
 =?utf-8?B?cGx0b1A0YTdkR2gxaTh4QmRKenVheDNHUXR3dnNKdk5TR21tU2VKalJSNW80?=
 =?utf-8?B?Wm44QXNhQjNiTFU2WjArRG9OeDN5aWZISWlMUm1EYkRPUzhsc280Y0JZRGY1?=
 =?utf-8?B?c2VwMUhwempuV1A3VGRudDJsMUtTYWxXeTMxSkxFRXRKdE11QWpPVnhLdzJC?=
 =?utf-8?B?MWV5NlprVFpIc1ZhR1dJZGhBYnBIUmtnaEM5Rlh6dGdIUmE5aEJvTUVqTStW?=
 =?utf-8?B?K3FteGd0REd2RVZLZ1BIS0FQakVNSE93OGtYV2Z3eSsrTndNbW94SFFRdmpp?=
 =?utf-8?B?UDRBRGJ4dU04MGh2OUx4MU1VdFoySEtnamdReGlWcHRudUcwOWVydWZPVUUy?=
 =?utf-8?B?YXRKQVpySjM0MFVla3N0VG5ORC9Qa05rSFpGREwvSGFSMzlCTEZXV2xVR1ZY?=
 =?utf-8?B?QThqMUgxTmdoeDRZaTk0OGl6Wm41QTZkQWNNVFpDSllzMFlsajFHV3ljcm9O?=
 =?utf-8?B?cW1jVktvRmpoQTBsZ1M0YXhncUQzd1RYdmpxcXBxam4yYlpVUzYvVE5PQkpz?=
 =?utf-8?B?MXhSUUx4WkV6RHpWQlp3dWl1RGZuVExrTWNtRmdnMnNOc2NBNzMrbndmVVBI?=
 =?utf-8?B?bUJqUVlLK2ZUdzFvR2JGUmdwanBiV3dCajg0eHhuRFNCWUpBWlpJeXA2Zmxs?=
 =?utf-8?B?clpFNU1rbFFwcmcxSlpmNVV1eGU0RU5Bc3h3VUVCakFoNm1yeGh4b0Nnbmtp?=
 =?utf-8?B?YjhScnpuTFR4cW9BN3NWbXZ0K0JiWGxCbUNQS3Y1VXpBMUhTMFdBYlFlcHZl?=
 =?utf-8?B?ajhyQy83cFFrNjRjYmJIOUU3YWpWcmVvNjd3ZXhGQ3Z4dFNNQ1BvSjQvQnEw?=
 =?utf-8?B?dlFWdWhQcXdiTW5tQW9PVloycm1acHZnaHVnT1FGbFNWTnpsamdhbnJieFYr?=
 =?utf-8?B?ZGFHVVhBSzBiTVExdW40STlKaFo5c1IyNzZ6TFlnTjVZZjl2Q2FjT3hDTm4v?=
 =?utf-8?B?UDBtbmlhd2FhZU9JbWxLNG1qQ3BvRCtpSGowTmFXOC9tNmVLTlJ3NVBBREVK?=
 =?utf-8?B?Sk5sWFFocmFhbFVxVnJDaFVtL2dESzdEV21aWGdNcnF3TkVLS0tubnEwVmJ6?=
 =?utf-8?B?TmRXT3o5cDlDR1JsamgyUVI0NkdndHdGQmJ4NDFhS3FBRDlsbk0vaWVOZWg3?=
 =?utf-8?B?YWR6R1VGdFJtcVlsYVBUOG9neDJuZG9FbWV4SWpxbHV5KzEyWFF5aXQ0R3FX?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863304f9-fb80-4c14-d7fd-08daaa2703f2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2022 18:49:37.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiD9CZPSZV1sr1H4kDJQHorEhSxM4VtcKtscm6O1/oiB1nFgSuEdZFZzpXnIXOFsJrchCLnAcm9FXPjUsJz6ZyCHm5d/xvqI1pi5E1opTrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8162
X-Proofpoint-GUID: YTpQsX_LHwihkA1JgbyeNWDJCYPUQoMD
X-Proofpoint-ORIG-GUID: YTpQsX_LHwihkA1JgbyeNWDJCYPUQoMD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/10/22 12:50 am, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Sean Christopherson wrote:
>> On Thu, Sep 15, 2022, Shivam Kumar wrote:
>> Let's keep kvm_vcpu_check_dirty_quota(), IMO that's still the least awful name.
>>
>> [*] https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_Yo-2B82LjHSOdyxKzT-40google.com&d=DwIBAg&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=0-XNirx6DRihxIvWzzJHJnErbZelq39geArwcitkIRgMl23nTXBs57QP543DuFnw&s=7zXRbLuhXLpsET-zMv7muSajxOFUoktaL97P3huVuhA&e=
> 
> Actually, I take that back.  The code snippet itself is also flawed.  If userspace
> increases the quota (or disables it entirely) between KVM snapshotting the quota
> and making the request, then there's no need for KVM to exit to userspace.
> 
> So I think this can be:
> 
> static void kvm_vcpu_is_dirty_quota_exchausted(struct kvm_vcpu *vcpu)
> {
> #ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> 	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> 
> 	return dirty_quota && (vcpu->stat.generic.pages_dirtied >= dirty_quota);
> #else
> 	return false;
> #endif
> }
> 
> and the usage becomes:
> 
> 		if (kvm_vcpu_is_dirty_quota_exhausted(vcpu))
> 			kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
> 
> More thoughts in the x86 patch.

Snapshotting is not a requirement for now anyway. We have plans to 
lazily update the quota, i.e. only when it needs to do more dirtying. 
This helps us prevent overthrottling of the VM due to skewed cases where 
some vcpus are mostly reading and the others are mostly wirting.


So, this looks good from every angle. The name 
kvm_vcpu_is_dirty_quota_exchausted, though verbose, looks good to me.
