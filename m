Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5FE655DDA
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 17:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiLYQuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Dec 2022 11:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiLYQum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Dec 2022 11:50:42 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2A326F3
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 08:50:38 -0800 (PST)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BPGFDpH010796;
        Sun, 25 Dec 2022 08:50:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=5ucad86wh+fsQxnASjpwkqbhJU5Y8Paec9NxQUYNZwk=;
 b=aVGfDZN5ulGsLMMHb4hvkz1lQKhzxuD5ttJKG3ccDFKIvK7wK7ZpUsPWjMq8O1gYgnmq
 gjdE9gAGwp1jplW81h5+UqKkwKhmzJW5A/cD9JM/mRW0YJkohCX8pZKRr7jTR4ptOhXO
 k2KUBq6Z5pzG9aHxDkNegUwwm8v79Ovs+P0t8rBUNTMqkQxFrj6LnngJ8FNEpUsTJyw+
 WqeFn8Zr18M9M4PEA5DIu9rtG44Kb51xBGdzSfpOG8+Y6ODsknmtcjlzsW4j90pMJDjV
 lo09qSzAHa1o2b/Kph2CLaCpoQRjfaDwfRnbaEveKEfiGkaB5pUKZ2LBd/4qNAV5npRA Pg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3mp0dq981r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 25 Dec 2022 08:50:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anNunN3uPL8TcQowIMi+nc93YAcEvUjiwVArBSpd1MvXTu2SqW20SVvygQMEHv4t2pr2MBJrVlEfNX0RIPLBYXQUJNscx0xWECgePh9MkAMcEpUz1wa8XgW8LFEyHC0omnUnBPUyIjvmlmN+o6hM+/GPzd5eyXQ1be45crV2Q+Af6VWKug2SJQhZLA3uoF4iaUxGqeffm5hai9ZoUD9ibyqj/7PFAuR/k93wmSRa+n1CmJOtheA4DMDEceF7ShvrCJEhafBMNo7nrqCvoO7+YH+PcJb37i7aSalpNA5jjL2ZnsTNB+B4zlNL8YZRi0RQBt9EsyXFgyjPSHz1ns5xNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ucad86wh+fsQxnASjpwkqbhJU5Y8Paec9NxQUYNZwk=;
 b=JXpUkKw8awRBrAsiIxnShP7A8ZDQqt7KcX508m3Haiag+KxwO82NZjffikBer52f1dLXDUqwFBjaInD4aNvgqfO1mEcYMET+GaJHAl19d9xbKC5jKdSmz7e/eua35F+eSPTBQ5lwzp1n/ty/5q8spTv4B26SQdCnTWkKn/uvusHGmqthGOvrDEJBsOWWDzjMXG2oPCOWetahSRzV8m8XH3RgMP3y30DLh7ZXqNCz76hwIncZ9Xe4TZ83gO1y/sAGRGKBTWdEIB64IxdW9nqmjxW4qZesZaaawy8zpAhCLbF2tx1kVAQk+Pri1y/GBsyjd761LP5ADz93Z8qdlsK2sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ucad86wh+fsQxnASjpwkqbhJU5Y8Paec9NxQUYNZwk=;
 b=HVfpulfGCE3GsIFV92TUcZynM1E3stRt3HV/FjoPKp1uv3J4EcLdfRN682t+HQqzZ+IWqAM29U6W3NkpibtUUPPQHgF45AKBEKSNj2y1DkuMgIzJKh5ZoKuiYXlUlrsUzVjJcOdKnqpfxwvKJUXXFvoGtonWkPHe2Aoqks3LUblEnVomYsSKSAFdoIafqOA/GNhBCl2VZpN7zeC0sP9rguokte4W2o1odrTuBw3i53jHpvMrqB3d+KmW1BMun9+jcUJ+NhrCQnCYI0uaY5zaPFC3UlI1r9PGrPxdTs8erY5nGVF4WiQNX8OKs5U7y0S8AvwSjKUzf1HAWmEp23H0NA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BL0PR02MB6516.namprd02.prod.outlook.com (2603:10b6:208:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.12; Sun, 25 Dec
 2022 16:50:17 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a%8]) with mapi id 15.20.5944.016; Sun, 25 Dec 2022
 16:50:17 +0000
Message-ID: <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
Date:   Sun, 25 Dec 2022 22:20:04 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
In-Reply-To: <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::8) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BL0PR02MB6516:EE_
X-MS-Office365-Filtering-Correlation-Id: b9415016-b593-4222-5af7-08dae6981979
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pe9daIhh7RCsNWrRl6fuaELR1WjDQXOnUxqOwyisyq1sYzqAlo2UX+uNFYRMAJzN67jtTSICEHwHNbPQfU9cR7SgBwtE4cDq+Bo8FJCCsG+byuHRAu3jstyHbm4B22eNDiL6SntLCp45OU9K6/2/gCTxTQdtdWhvUqClBYuLLpj4lZcmO3sDeLDMB+8NXsCC0mBocINMG2Oza/2RgmKJ7Jbw2Ybfk0NjnwkTBTFp1UPnNn1sE1v/JmI6LBwVHim3PI3yeC7j+9OvZGODEhLv34fMfdpVBfmJmgEao+q+a+E+mRvRXVkpL+bK6yoa6p3ffSG9Mk54A/oD5AGYrLv+pWGsavn5WZ9f5sWoqn/LCVtGn1SyRsRkXNW6nAq4C8UXiJ9P6IAt+vYVWfazMJ89HGDYqKVCYxYk1DwGungYuxYaUNQfafjmd3v/dUdrHvcXKK217YI8fjkL20WlRQWmGqcrYvGcWOi29wrsyLdGvJ5wd6ycCnFEP1ZlX8YwOyUglsztpvi6Z77My25fvnO56ZE46aT/vmnqe+u9CTdIth5k9ALFCs4hDE6Wvu3fzRgaHuVuampSCPe2a+qf+zn9lisvtW3CZbeetrxYfKruSAxDgFm/LvGdr85OuavdfluN2g725DVx1bYhRJiH90uzaa62sBTwVjVG7Vmehiukg+pBydRpkhTm/Z/AZ2HrobeKgL1w13JYtdlGo9F4B2SEKD5aFWMfKprdRrbx8puL2KPk4v/A1oBsHJyVw65V3Rgb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(39840400004)(396003)(136003)(451199015)(66946007)(66476007)(8936002)(66556008)(4326008)(41300700001)(6666004)(53546011)(107886003)(6506007)(26005)(6512007)(36756003)(8676002)(2906002)(15650500001)(31696002)(5660300002)(31686004)(186003)(316002)(110136005)(86362001)(54906003)(6486002)(38100700002)(478600001)(83380400001)(2616005)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEVYRk9SbDdKSW5CREhnZ3lQUGdiNy8wekRNTlhxU25UYldKOXE0NnhLNWhu?=
 =?utf-8?B?K3Y4N1RsUWQwRE43MUkxZnRLMTNnTkRCZkF5OEtQSXplM3R0TlFlUm1DOXpx?=
 =?utf-8?B?U0lML3RENmNlZG9FaGhpMENSclhSanhPaGJlaXhzaER1ZEluQ3l2dVJ0RDBB?=
 =?utf-8?B?ZExJZXJsTm8wU216SUNnR1ZDUjhXMU5mV0lObHZuQUxUcUI3TUJEYnBKd3E2?=
 =?utf-8?B?NWkzRy9sd0VNTG43bTRKVWpjdlkvbkdMUjJaMFNCcHdDOERjOFNCL0xYSXdu?=
 =?utf-8?B?RzNzNkpBTEF2S3RMclhBV1ljNlVLS0Z6dktRQVRvalhIUlphcjhUN0Era3lM?=
 =?utf-8?B?QzVwYjdwM05LKzJ6dU1NTkY3cTcrMzVGTWhOUm5UZ1ZDa0FnRloyQUhtb1gr?=
 =?utf-8?B?TWhacFJNODlJUGtaRmZoN2xqWnE1TnNDM0ZadzQxSFpaK1dDRWU1UklsSmJn?=
 =?utf-8?B?VllMRy9rUkJZbVQ1U1ZJek5KTEx1aVoycHFhZ0I3UStqQ0F1MEVpeW9qWTd4?=
 =?utf-8?B?QjVCRGdKU3FPUWlFZ2FxcUlicXUzZjVGZlpDdFhRZ2ZGcnJvVWNMckhMejFo?=
 =?utf-8?B?Q3I1cTBrRDI5UnJBOVprd0tnUUtEdVlaRjUzVHFzZzJ1QTM1bmRrbzFaS1Z4?=
 =?utf-8?B?MnZELysvZjlwYWJ4WnpOdms1TVJRVTZIVVRRQTczK1FaY0FBVTdCT3c0Z1hF?=
 =?utf-8?B?eURzdTB0KzZza0tsUDgxaGdKanZWWWtDamV3cGlHeTdRQm5LQmlwck5LSmc4?=
 =?utf-8?B?M0tLYU56Y1pkeGliMWtTVlA0Yll4SlRuakpRNnc0aVkxZ0V2RDFReWU3UXB2?=
 =?utf-8?B?eVkvMWF4VHRxeW9sWThzSFRKM1hieGhPMlBVSXR4K0l0c2ZWb3VDM3hZUFhi?=
 =?utf-8?B?dGxpQzJiNEpRb0g5OVdWZHRacmY0OVVFZExDVVJPWVcwM2MrdlljUkF2TU1B?=
 =?utf-8?B?YjkwenlOaVV4NERQSVRFRFdPVGptRjhDbkpSeEhRelA5MHJpNUdXOXg4MVdo?=
 =?utf-8?B?UVlma3h3ZXdhUVVMZGhJdHVwYTJ4ejc1THVXc25sTjNPeldwcEFYOE41ekts?=
 =?utf-8?B?bVgwRExqSGhvbExQcWlqbkoycFM2QVdZekY4UnhZRW9vejk0UUNXSEhIWXR1?=
 =?utf-8?B?ZUE4NnhDdlR4RTZSNXpQdDlwTjZ3dXJPak9Tb2EvSmhpMmx0eEs2cFVTQm1C?=
 =?utf-8?B?elJkVjQ2VmR2Zm1QRHpEdkdYcFVPOFV3L1lRVlNGYUo2QzkwWDFxMjJvbFhB?=
 =?utf-8?B?UTlxQ2xGakZ5QWo0RnU5R2M2UnB5aDdZVDNsZVVlN2FBMTdkRVk2ZWpsd2Zm?=
 =?utf-8?B?ZCtKalVkNUVhQUF1TzcrZmhSd0pGRGpwd3Rpd28xZmpZRk94YlVCdFE5QkYw?=
 =?utf-8?B?L2hJMWhhZmM4U3hnbVVmY05oRXU1NVk4aHB3bFlIMlZjOXFUa0RVU0wrOU9o?=
 =?utf-8?B?VVJ1cEJxM01mNkxLcTFNaVBBOUZlVDZGR3Q5Z0lLWXY4Q2R1bXVrYlB1bU05?=
 =?utf-8?B?dWpHTEFZZUZISjI1dWI4YTFjK2xTMUZlRG9uYklvY0QyV01PYjRNb1pqVnNQ?=
 =?utf-8?B?ckhiRWtUNnF2cjRkWkZOYTNKZVl0eVJ4dFQybnVmWW1JdUhQNlcwS0pHVzg0?=
 =?utf-8?B?OC95NmVIVlJ1UlZPQUIvZUlsdjdDQjY4aTlaR3lXQU5NSjYvQVIzL0MrYTlh?=
 =?utf-8?B?UmFlQ0FKOVpjRy84SnlzVjdZeFpscURrSTErYkg5V0ZtSU1Mcy9iNkpnQ3A3?=
 =?utf-8?B?a0FXMjFuU0FFcHo3dlhpcE94aEpWNVdXaHF0OFJ2Z3BhVVBPU3VvTUZQd0x3?=
 =?utf-8?B?bHJudHc5VmZZcEVNNEVBMGMrc0VlSmhqUGNMNFRjdjQ5dzNsYzVKbHlxUTdX?=
 =?utf-8?B?RTdXQmpHTWczSFFHV3NFSGNiVzBZNkJPOUhjWjN5OUR0Ry9NSUJic2FTd0g1?=
 =?utf-8?B?bG1UL0JGaE1aTVlHU0JpRVN4YzgySXBFWGdxTk05TjI1ZmZJcnZYc0VSNXlD?=
 =?utf-8?B?OTRJY25PRlFVUFUrd2h0YWUzdzIrNk5hV29RdGR4TGdCeE95cXpTYVV5NTFC?=
 =?utf-8?B?c2xpQTZVY2NYYlgyZjhVeXUxdXNoYjYvcTR5L0VBSEZLak0xREQ3L2dSMmJ0?=
 =?utf-8?B?c1JWQk5kT0hJOXY5ZUFOTHppZ1lXdzhubEFxdkRTUzI0SDA4Yk12d2x2T3RL?=
 =?utf-8?B?ZEE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9415016-b593-4222-5af7-08dae6981979
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 16:50:16.7053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E79DBt267j7NVwT1Ny0/htlkfoKWpwa1f5iEbeTj9E5GiabaR8Rbq2RLoA/sHzijbLYOQ2qgIqyd+9zHfOmoLSwZ3ItFbfOiwBj0fRWxRzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB6516
X-Proofpoint-ORIG-GUID: JPkhxrT5adeKK5nT9XVMXpP9UpIUI6Uj
X-Proofpoint-GUID: JPkhxrT5adeKK5nT9XVMXpP9UpIUI6Uj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-25_13,2022-12-23_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/12/22 1:00 pm, Shivam Kumar wrote:
> 
> 
> On 08/12/22 1:23 am, Sean Christopherson wrote:
>> On Wed, Dec 07, 2022, Marc Zyngier wrote:
>>> On Tue, 06 Dec 2022 06:22:45 +0000,
>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>> You need to define the granularity of the counter, and account for
>>> each fault according to its mapping size. If an architecture has 16kB
>>> as the base page size, a 32MB fault (the size of the smallest block
>>> mapping) must bump the counter by 2048. That's the only way userspace
>>> can figure out what is going on.
>>
>> I don't think that's true for the dirty logging case.  IIUC, when a 
>> memslot is
>> being dirty logged, KVM forces the memory to be mapped with PAGE_SIZE 
>> granularity,
>> and that base PAGE_SIZE is fixed and known to userspace.  I.e. 
>> accuracy is naturally
>> provided for this primary use case where accuracy really matters, and 
>> so this is
>> effectively a documentation issue and not a functional issue.
> 
> So, does defining "count" as "the number of write permission faults" 
> help in addressing the documentation issue? My understanding too is that 
> for dirty logging, we will have uniform granularity.
> 
> Thanks.
> 
>>
>>> Without that, you may as well add a random number to the counter, it
>>> won't be any worse.
>>
>> The stat will be wildly inaccurate when dirty logging isn't enabled, 
>> but that doesn't
>> necessarily make the stat useless, e.g. it might be useful as a very 
>> rough guage
>> of which vCPUs are likely to be writing memory.  I do agree though 
>> that the value
>> provided is questionable and/or highly speculative.
>>
>>> [...]
>>>
>>>>>>> If you introduce additional #ifdefery here, why are the additional
>>>>>>> fields in the vcpu structure unconditional?
>>>>>>
>>>>>> pages_dirtied can be a useful information even if dirty quota
>>>>>> throttling is not used. So, I kept it unconditional based on
>>>>>> feedback.
>>>>>
>>>>> Useful for whom? This creates an ABI for all architectures, and this
>>>>> needs buy-in from everyone. Personally, I think it is a pretty useless
>>>>> stat.
>>>>
>>>> When we started this patch series, it was a member of the kvm_run
>>>> struct. I made this a stat based on the feedback I received from the
>>>> reviews. If you think otherwise, I can move it back to where it was.
>>>
>>> I'm certainly totally opposed to stats that don't have a clear use
>>> case. People keep piling random stats that satisfy their pet usage,
>>> and this only bloats the various structures for no overall benefit
>>> other than "hey, it might be useful". This is death by a thousand cut.
>>
>> I don't have a strong opinion on putting the counter into kvm_run as 
>> an "out"
>> fields vs. making it a state.  I originally suggested making it a stat 
>> because
>> KVM needs to capture the information somewhere, so why not make it a 
>> stat?  But
>> I am definitely much more cavalier when it comes to adding stats, so 
>> I've no
>> objection to dropping the stat side of things.
> 
> I'll be skeptical about making it a stat if we plan to allow the 
> userspace to reset it at will.
> 
> 
> Thank you so much for the comments.
> 
> Thanks,
> Shivam

Hi Marc,
Hi Sean,

Please let me know if there's any further question or feedback.

Thanks,
Shivam
