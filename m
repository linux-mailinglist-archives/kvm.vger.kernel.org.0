Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD216AA94E
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 12:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCDLiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 06:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCDLiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 06:38:11 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C1B14212
        for <kvm@vger.kernel.org>; Sat,  4 Mar 2023 03:38:10 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 324A1jxF027526;
        Sat, 4 Mar 2023 03:37:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=17D2zvRiCFaxKrSfgtDJJcuofHn1GWR/bIMkv8tQaco=;
 b=DIRl1hUldRVy/4hdgobUeDT0+upf+gl/jIXCK04Ji1alsuXhlfjbrtTrYfTekBSYMhcq
 NiimMExm83A9+iQtRBjT7weID3B+XTzaN1tuv/mdp3HG4PWk5TfFrH0v9rX3aXXQzfeP
 nsSXQCKi46gD9R/EMOlFLVrK0PBoff1zpudilyFayP1cyzXTfqTBu2rY3rBdp1NroyTD
 9DStwQYerw48Uh7pXy1h4RE7cpDiTcZ8jAvSxGSmfJYCQ5nqTYrnoBBDLG4sK/V1MmHU
 9CYIAgUVwSwedAcHzxmvYOAKYSkmcJlbPzbhu7aJe4uNp5cqbcB4/QEy9lTcufi11Mb3 mw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3nyjs4jw71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Mar 2023 03:37:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQaX8YeS4/Mayi5Hi5uQf5z6wSSCI0b539Wxz4dNh25GplUdMzdgWxG09g6p2gYMK32c8KlLckrqV+I2RB+z+L8LZRfXYWzqE6/KQi+WYrsdXGtCT7+zVy+NS9BMjNuJkOPZWT0CKoQfzRIleVqK71m/Fty5BqJZcqmOEWvufRsPrgd7UO8e13ORJzrrstTWpBC4HG5wldGcUoF9KGL+a4rDPJCk0a2sWJWavE6A7x06aXeZoKGIdZt4h9HUzh5fN1JiXdU42ksdpel2vaW49UXWy3YY16urd+kAd0sh3FNT0hMnnp3gVCZJyYALfRUrfQYaRHOGkoYspRTFlmgDFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17D2zvRiCFaxKrSfgtDJJcuofHn1GWR/bIMkv8tQaco=;
 b=GiXb1HET+DmD8RqiHhM/ML92/PdsvgxKzDjjU6sNvIa0buVlZa5M/734FV6cYmdf27h3J73C4+ol/TkguerTYSwHTNnFtv/4b3HUFkSrvRb/B56pEdnX0GSVspt0aqrkq/i57cqmentBwL0w3FJnjTv3cWjR4nXLf+bp/nUGrBJuN3C+fkqPO3Vzey0wdmKlqHu3dwvyLcsV9YkQk3Lmm4y5F50iBXSmvlrPzoTDguRuyBCx6M8JNB0DAGBFQYhzU0v4o1/x7ngxnMMGsp7rJW1wcfRcQMWJ/c53E7rdffPGhTeqav9c2WNxgJVUdt2h4+aG21cIIXiz1Bw9SWIKrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17D2zvRiCFaxKrSfgtDJJcuofHn1GWR/bIMkv8tQaco=;
 b=LFxF/U30Ykd/nkNjROIFUlC7RlJS2ueQJLyMHBo3gOmEZH7qM0ds4r59w9mQLzohsJAZo77XM+l+ObuZUUo9Xdi+kd/HdxQbt6yyPI8bDS1wu2fHssCMQXl4XmtYcx/6fPNp8pDTu2Zhn2oV5OQo8fPIpFrPyJdiLpQS04MHkI8UEHCXUE/DdQU4hzQGMkknfq4EKDi6a9xbYri6mbBcoNgwaaVSIUCIuoa8PE9rVB+HE8Kg6k6ZLFaX4a9iGha2heLXk+d+V/ZBQf5WKQoLx9XdbhV5vYAHfKyImUIVPx0uz4V8Kw7qbIw9P7LJh9AkiZ64lPVDhzogS7Gtnpnxaw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CYYPR02MB9711.namprd02.prod.outlook.com (2603:10b6:930:c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.21; Sat, 4 Mar
 2023 11:37:47 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%8]) with mapi id 15.20.6156.019; Sat, 4 Mar 2023
 11:37:47 +0000
Message-ID: <0209f700-723f-2d40-c26b-5f87ced34b5e@nutanix.com>
Date:   Sat, 4 Mar 2023 17:07:35 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v8 3/3] KVM: arm64: Dirty quota-based throttling of vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
 <20230225204758.17726-4-shivam.kumar1@nutanix.com>
 <877cw3ev2m.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <877cw3ev2m.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0079.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ae::7) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CYYPR02MB9711:EE_
X-MS-Office365-Filtering-Correlation-Id: e32f64e5-a532-4e69-862b-08db1ca4e072
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+w5EhSFWeMgwxBOoEDamd4KLI6Vvade0BmOi8p707bu98Pl1NliNHq7R6DoBBH8JaMDHRebrteanPR4Xh1iSzL7idzwLGFboUPM0pX3FbOClQP4/ChbO5Exr454FQiwN8EeLDiVIuQ6ECEZqL6n7zMQ5fv9ci/gQ5FGt4oqSKvWOgl1IavnfEkWmM/SJ3fsBY0O5Jc1ILtY+kcbstMjQm4fW3Eqor0fpbTGM9mTTn1emMJ1OsHrNPudtMNfGfv0lJQ+KxRyjt277tkq0WG1EwYwagQBZCf+OnYu5oGlyZauJBwb+xZwrz+PsFHkRfU8+58U6U215SF4+rlfDmUGjkIWnv49+RkGkCYW2z+xq6/chQE7G+WIYKn0WpyNCmG017yp2DpjV9WYB4CjYMRvk/STIBHkvsM8qZltnz9ZF64zxNA+ewsYfpmtrGnWj9dgackpoFH/8YBCvG9B2qTHqEyq+46lDCIQgGwidR2BzYLI4sGZv4DFKiiVrqv492YCIAL0uYbhICfMGT0rJVCX7iHVGjrzUN3py5zost3tn+iY33ioZ9g/3GYx58slneVpaJDPKaaiKirrtKAIuOd4pBZ6xgeD4RPBPz50DlrUBZI6aJacPRewHVc2Pa37BJmjIEnDhoIxRPKlvKJ5k8vCrU1UxlFpRMHt30oQdL8XBOipQ2kWyVjr2MXTWDgLFGoOsi9PuM+N4CIffN8mrrcpo6VAoHXqFB4gPVIg3RzfuaNY+yPAqInzQp4ccBakCsay
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199018)(54906003)(6486002)(316002)(36756003)(83380400001)(86362001)(31696002)(31686004)(186003)(2906002)(5660300002)(15650500001)(4326008)(8936002)(66556008)(8676002)(6916009)(41300700001)(66946007)(2616005)(478600001)(6512007)(26005)(53546011)(6666004)(66476007)(6506007)(107886003)(38100700002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGZlb0VMWisxS2MvU205djF0ckszWGlBRHlrTDRZUldtTGl2UXNweEpJVHZa?=
 =?utf-8?B?dlhYRkNBLys0YWk5Z1JPU0Z5dmc1VEFJQXd5VXRwWUVyd0EyT2VCdmN0VWJ2?=
 =?utf-8?B?Ym1VZnZPNUNoU1E2MTlaTWlUL0JYT01GVmUvU0lCZmdtaUxPVVZISUNmelJT?=
 =?utf-8?B?Q2hQVmVGeW1UeDBZWjdhaTRtZ1p1N3dVTHRRS2xYQ3FYV1kybGVQREZRODd2?=
 =?utf-8?B?ZFJZWFdmT1RiR1pGQVVVNmtnRzh2MmVJUEpQS1c1VmpTRGluaHRmK3RPYU1z?=
 =?utf-8?B?K0NMTFpFdzRiZm02YzBiVTlYN05mSXNwU0J0bUFqamY0clR4T0luckRac09q?=
 =?utf-8?B?MGlwTFNBMVhjSExtSUc3NTgxd09ramIwQko1VEVURmx5NWE5Rm1XN1FqWEUy?=
 =?utf-8?B?K2luY2FXcit4STJlc081d3NWZk1jWEhMbU1aanVtTTk2czFwU29IUGcyWStM?=
 =?utf-8?B?dlJaRnA5MHBIalFRY1ZzRnMxd0JwMU9zVWdvdWlSUEJ4ZkFOTXptMUo3b25r?=
 =?utf-8?B?K2x2ajVZZFJ1cTlBRmgyczBSN2kreVQ5azVlWHJQTkMrdFZMZWVjZTdrMlN1?=
 =?utf-8?B?aUU3R2Q5dTRoQ3RvQmFlaUpSbVY2UmlQUE1IeWIrZlh1VlJ3M09iSytOUGkr?=
 =?utf-8?B?QXZDYW9NbTJnNXNpcUNqNUtZNytjd0dVTlRvLzVmNVpUam9zQnZwajZ0WlFU?=
 =?utf-8?B?UkdVK2l6R3NhSnFWd01MOGYxRjQxaEdXS09NMHFlQ3NvdG1hWUV1M000Tmcx?=
 =?utf-8?B?UHJPRjZ0ZW50UE1lZHhhZU5vSFM0NDJiVEpDbjZHNGNlQlVBMFROY3M4WEtr?=
 =?utf-8?B?QS9rTVU0ZThScE1Qam1jSThGTG05bDlKaGtEMHMxbjZPc1RtMVExcFF6Y09J?=
 =?utf-8?B?YkdpQ3NpTUIwckV1aWtSV2xJM1hDaUVWZW5zdXhtUDRnOU9IbEEyL2k1dXUy?=
 =?utf-8?B?c2lkc01iUE85Qkg5MHR2dEdNbGQ2R1Z6bHZhTG5rZzJRVHVteHF3Qk94cjJo?=
 =?utf-8?B?dDJPTEVtMERtbDlxNXFkUithVWpsM2Q5bXR6TVRZR1ZIaExML1lhbkZrcGp1?=
 =?utf-8?B?Z2djUXRaOFNZQmlxSGo1Umk0VkEvREtHSDVhQThoL2x2NUJkTVArNHZJcnYw?=
 =?utf-8?B?RGFRS0pkUWRFQU45Y3dVWGllczdwUHc2TnE0b1AwNU9rMXpYaU5sZW1lcVI3?=
 =?utf-8?B?dXRhenpvWmNMTFFUQldyY2ZzWG5KU2FzS2RWcVJldlRSeTFFWmcyNk9jMzlF?=
 =?utf-8?B?M2tqdlN2NVdwK3NLMFBJSGFLMXpMOUtoa2oyTFVIODdwajJaeXF0V21lVlIy?=
 =?utf-8?B?QjlwUXVHcThlRVBZVm1yc1dyczBoK0d3Skx3Z25FNkxkK2xJOUt5YldpcEpM?=
 =?utf-8?B?ZkJoU0tuVjZHQ05NcmhHL1p1UzA2bDNvT01aYjcwRHNpblBkMEw1WmIzUHFT?=
 =?utf-8?B?UERhZkpqWUx6b2NjS21Zbk5nT3FWZVQ1NURnQkI4UzJFN0dIQllZczN0VU1h?=
 =?utf-8?B?OWFNL3VIVllXT0txWEZ0TEpCV0VVdWk4bWxjOURZRzVIS0RmVmFHTmNVczlS?=
 =?utf-8?B?b2Fqb0NvYTVsQXRZZStsSGZreWhwN01vMEo4UmMzbmhFN1NIKzU0Q21aMVJt?=
 =?utf-8?B?T2ozTjArdzFGSXRMSk9iVDV2SncvQWJyK285aExiRmFSOERyU3VieDkzNWlL?=
 =?utf-8?B?Z3BYT2JlUlcyNkpGbXBySW5SNFlFdk9ZL0tGc1p6Ym9Gb3oyQktrSVdNdkRZ?=
 =?utf-8?B?a3NIeERHMGZXbldoVFE2ZklWcklmZEtkQzltQzFhSVl2M0hFbVVCTW1LYWRh?=
 =?utf-8?B?U01ON0Z5d20yOWwvKzdvdzYwZXBJK0V4MFZ4MnpNQU9ocDVUd2k5YVpNZnc0?=
 =?utf-8?B?SU8vQlI1U05CSjBidEh4MnY1OGZaNSswcENzQnlZcDVQQTZHOG1mcHlzQ21O?=
 =?utf-8?B?QVlmWjlrdVU4Y0t4SUQ2Z3ExS2ZKa0hLWWxrVjhxVjM4U09CVm1sOGdkaUh0?=
 =?utf-8?B?bzVtTUxPY1R2WWNROElpV1NlZjZXMUQ5K2FDaVZYZDhJU25VT3h3ZVIwYW54?=
 =?utf-8?B?S1ZHR0N0VnFtbEdVTnQ5OFBIN0lra3lWS0kxK3VhdCtGL1lLRHdwQnBaYU1k?=
 =?utf-8?B?d2U3eVFSTmhOYVdWeWg4TWozYlJkT0NHTDdYN1NJWG5UTittRTNSQ3lTb2pG?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32f64e5-a532-4e69-862b-08db1ca4e072
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2023 11:37:47.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUICq51s1JsgBGmno/lDR/vq1xXVd8S7jnHgdI6DBAJl7Ed9hnd9ARFOZJRlK8PL5TGyyXKs+BEv6MGiBtUhS3Vr4+WXg6+LzVQ5HtLLotQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9711
X-Proofpoint-GUID: qcSTu06KCnomzfwysI0gKitv0lmpZtDv
X-Proofpoint-ORIG-GUID: qcSTu06KCnomzfwysI0gKitv0lmpZtDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_04,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/02/23 7:19 am, Marc Zyngier wrote:
> On Sat, 25 Feb 2023 20:48:01 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>> Call update_dirty_quota whenever a page is marked dirty with
>> appropriate arch-specific page size. Process the KVM request
>> KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
>> userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   arch/arm64/kvm/Kconfig | 1 +
>>   arch/arm64/kvm/arm.c   | 7 +++++++
>>   arch/arm64/kvm/mmu.c   | 3 +++
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index ca6eadeb7d1a..8e7dea2c3a9f 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -44,6 +44,7 @@ menuconfig KVM
>>   	select SCHED_INFO
>>   	select GUEST_PERF_EVENTS if PERF_EVENTS
>>   	select INTERVAL_TREE
>> +	select HAVE_KVM_DIRTY_QUOTA
> 
> So this is selected unconditionally...
> 
>>   	help
>>   	  Support hosting virtualized guest machines.
>>   
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 3bd732eaf087..5162b2fc46a1 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -757,6 +757,13 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>   
>>   		if (kvm_dirty_ring_check_request(vcpu))
>>   			return 0;
>> +
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> 
> ... and yet you litter the arch code with #ifdefs...

Sorry about that. #ifdefs are not required here.

> 
>> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>> +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +			return 0;
> 
> What rechecks the quota on entry?

Right now, we are not rechecking the quota after entry. So, if the 
userspace doesn't update the quota, then we let the vcpu run until it 
tries to dirty again.

I think it's a good idea to check the quota on entry and keep exiting to 
userspace until the quota is a positive value. Can add this in the next 
patchset.

Thanks.

> 
>> +		}
>> +#endif
>>   	}
>>   
>>   	return 1;
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 7113587222ff..baf416046f46 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1390,6 +1390,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	/* Mark the page dirty only if the fault is handled successfully */
>>   	if (writable && !ret) {
>>   		kvm_set_pfn_dirty(pfn);
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> +		update_dirty_quota(kvm, fault_granule);
> 
> fault_granule isn't necessarily the amount that gets dirtied.
> 
> 	M.
> 

For most of the paths where we are updating the quota, we cannot track 
(or precisely account for) dirtying at a granularity less than the 
minimum page size. Looking forward to your thoughts on what we can do 
better here. Thanks.


Thanks,
Shivam

