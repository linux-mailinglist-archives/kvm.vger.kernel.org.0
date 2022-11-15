Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450BC629165
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 06:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiKOFLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 00:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKOFLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 00:11:22 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE6115A10
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 21:11:21 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AEM0B3r017119;
        Mon, 14 Nov 2022 21:11:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=gnCCY2qBKXITsaZN/aP4e78dCeWeC9Igdl7h5HuKfGI=;
 b=pC/X/H0t9TOLn6VzUAIkMVca32qzoWpln97b91+wSLOML9wCzvGCEfPu/eURpMP4/Thy
 x/cjunTOMOK+XAkEEvPAiKq+1egiOPBiGY0Byt1YNJkaRIQSjhmO69Kii433xHot0nb9
 t03ESWcfg4r6MWUHmuWNV7XZ/K7yl08hq8vUsGclT8UzKlplTO5nsBlgnPDr6Vh4vnmh
 Dd88yZdgose/zl4gU29r8Bfe31yD0LJij70BPMgc3sBbTR/y7EAbflpR0mx1lLZpMQyj
 rhQFDuqAMR+xBR9kJhVtHjtkhZf5u+3cHkbF8dqr/R1mdpfo6tJelgh/0tCoi6B7/6It +Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ku2n6bxp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 21:11:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duq8ZtSOp17G7BIDTKiZaNYpF+K43Ya0Dy+IfOACs1i2VVwJKZ6zEN94epbzCb9QxNhJqgjdY/t18Jcr/kJfI+wUL0Iak08Mu2sy/GdzYPjmEvul6BhGIbIUQg08dHTkxPkn8jakiFceyXoz2AAu/B3Ze8zRBDr7hu1Mvm21zi5Fwj2mvV280Kfzz/h17C74G34KAY72fkRI+NPkWOyyjoqIPR6uGc9Fy6jOD3r4hwXMZklSS7hJv8aNtmSl8O18v+feyJgcaJYzzxnMxCTDJ1vEVpEJ+21nca79S3e0GnF83ZrsszCXa2mP5Gg81rp0lEgNo0qbQEkfjFR1+/uitw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnCCY2qBKXITsaZN/aP4e78dCeWeC9Igdl7h5HuKfGI=;
 b=ECfpjr2lXa/1SQp8F0dWtRRnbM5gTWmPo1dck26XKzM3Txh8KdNMdhkSAdK3rKFtGdfxdTKQOnFkJWl6Tijx0X5IX9TAdKfMxmMdaePsM+dyJ0/MxuWSaLyzW5j1bMc3EdBeNLQCw/rHnDeutQh7bn3BQasjdKjjcgOvZgKyGqtAWtdnBQVjdW8K/wjpzFz1h3q9fdIYT/ecUEYXH1EhWKfI83ya8j+6xiiB/BBkg50Hsqoy7tIk4SiatFEl/vId7tTlYVxbAAThTMDgFlMg1BE6hoE8ddNMem0j9jSc3sWGZEDH6Fxi/E5sTzzHZ+K+azunf94qEm3F5F1QnlQ45Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnCCY2qBKXITsaZN/aP4e78dCeWeC9Igdl7h5HuKfGI=;
 b=S2U5XJxg0yf2B791rXm5R8hAn+GuiPzAQENIA9Kn98Qp5BMPw0SXvV0J95uPhoEyXdkmSJ2Gx8LK1ywjB5PfHwB1QMX8uMGPA6fbX3jfqzem/VJyH76vOcEPQWq41McL5SmL0nWFlgK3BmDhlnmcF3Qg21yRGfgXTeR0m4cHLvp6M5CWA31sRQJYd2Av2PvmQjcr6hUgnRNDsJk7YMd4mkqkkkHPNqOw7G7msrDYHrYePXNhhvBU+AvOlT8kaiWs0ju+MoPh1onx9aqzf3bNBtVWIsjqRpPkBsZcvkmHGorEx7z9cQKkWr0Inw2zGghGl9w4phClVUowMXR/xkQNsA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DM4PR02MB8886.namprd02.prod.outlook.com (2603:10b6:8:8f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 05:11:06 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6ae:b51b:f4f3:3c20]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6ae:b51b:f4f3:3c20%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 05:11:06 +0000
Message-ID: <a64d9818-c68d-1e33-5783-414e9a9bdbd1@nutanix.com>
Date:   Tue, 15 Nov 2022 10:40:54 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v7 3/4] KVM: arm64: Dirty quota-based throttling of vcpus
To:     Yunhong Jiang <yunhong.jiang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-4-shivam.kumar1@nutanix.com>
 <20221115002747.GC7867@yjiang5-mobl.amr.corp.intel.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20221115002747.GC7867@yjiang5-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0007.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::6) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|DM4PR02MB8886:EE_
X-MS-Office365-Filtering-Correlation-Id: f0bf1481-3b49-467c-7b21-08dac6c7cc85
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NwtzyVn85QguOcLVuVr8hlupssKGBAO66SjBI0PC5rL4TTUp0f6gQ0kqGeHO0iMWZw2YThSsM8NwHoW3PH66RXLKYg1MDfDRxltuQWC88KKPTY3rI16r6BEGj7k4JIV21V+p2vkXUg1uxMMKqNwGulBDnnhFwp4HFm03Bbi7PeNRzT3vFMy1bohMudd8BQimjJY3npe5iDzWtLNC35ETIDBiVWA6zc82Up/CLnRYiYhA4IzZZjn73SDc+kk0hrx1r/78OI9QvtPr+QXiNGEJWyQql86y0ZwU9bW5EN8QFXBsrkbCkaMWzRVWTh45lC2j1UDkHBjHsrynocuUC5UaR7dLB1CZrTL4HfBs3PqjlkwVYi40MKYe4OA4JW/fGgs5P7YCchWyRvHz6OlI+0mX5cgGVUB/VQNLE/gJOKWlnUPMwY1MXUS9jEJHkjgJ0WS06xMZh2J80dirQvhPHQqNFwxvJXRBRUbrQyY8ydBgfHoilHkxYxU/97VPk1iZwcXzPXVkMyGi2lFMlLVpYuk141lTU+1ZhcBOXu7givFq9Cmt2QByCNV4w5e/yg5rgsLXU/GpXCNzwr23oZ9C7EZbtPY5Q3b8BB/ps9ZNOZzgUi1YMQMFENu7Icws8XzAFtWTlmGivOVxhioVV/pJpdLVNGtpxRHUseE7UiMFGAelsgvWZdWDnnNoyE/onQjARgvBgxhrwyj89yR/sksdpILAeBwCUvxR37h5gzG/RlCJSlfCt8Ea/Lbu9d72U3aUcr+O/Ql6HtJSYi7N3OmcPPkloOdEdyRo9jD4COHMuZBNO7gvaiyVs32jdV7a8eqj8zM9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(31686004)(41300700001)(8936002)(36756003)(86362001)(2616005)(66476007)(186003)(15650500001)(31696002)(478600001)(4326008)(2906002)(66556008)(8676002)(6512007)(6506007)(66946007)(5660300002)(53546011)(6916009)(83380400001)(54906003)(26005)(107886003)(316002)(6486002)(38100700002)(6666004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGtRVU9RVTFJeWJvam9vMnd1Q0U2NEcxTXFEOStySjI4ZTRObTZucVdUek1M?=
 =?utf-8?B?U0tyME80RkpodjlDeVBEdWZKaWVvY2JpQWhCSlBHTkhKNkxlUkVlQWI4c0pV?=
 =?utf-8?B?UG82QXhqZ2RsM3Z5bnVOZjlidFc2SEhPeGVEOWNnVHNnOW5jc0tsYXRocHhJ?=
 =?utf-8?B?c3AzNUF4dm84cWgrcFFadjB3aEo1cytpcVQ1aGxNWUJUT3JaQkVSTjVHRWl2?=
 =?utf-8?B?MXp6bEZUaXprT1p6TllCTEtUOThQYmNRbHhjTWhWK0N3QzRrN1pxK3I2U3RL?=
 =?utf-8?B?VWkrWnBHaG9yQVBzMzROSXRpY00wcktxNDduOGdKbDNFS3dudHJNbzlma3BQ?=
 =?utf-8?B?YkhQNnRMQVNQRlptNzRxNjgzdDNZUW5UM01odzVrTi9pQmhUbE9rcUdNTDlm?=
 =?utf-8?B?N2VJeFZ5dkJlQUZKVGxobGlPZWJtZ2tacmVKTktLS090ZjRQS2RUb0x5cVFt?=
 =?utf-8?B?NkxLYUZzRDZFNXhpUzQxQVhLdTlEbUZRT3laMnEyeGliZDVDN1Q4eDVtYm9a?=
 =?utf-8?B?RDhGRjNXTllqYmtKa2VhZnY2WmtVZGpqRGczWVQ5NkxTbi9mOHNGQ3pGcmlX?=
 =?utf-8?B?bzVGbVJ3WVhuNVFtbVE3Ti9WblJ0QU9Yc2tOR1NmZ3dZWExNNHMrTnN2Z1pN?=
 =?utf-8?B?WitpSVFWQTYxMkJNd0FpbUdscVVDZmJGYkRTM29YMERQRVJwMjR1U1lLdkI0?=
 =?utf-8?B?TEw1UlI5bUtRV2lVcWZSdy9IS0w5VGw4aVo4NmFEVk9oTHZ2S2lqcnlqWGly?=
 =?utf-8?B?SEJpOVJsR3RtQ1R1WkZvSjdVSTJpUDRwNkVucWFvdDhvZjMzMW4rRTBDdjdC?=
 =?utf-8?B?bCtmRC9JUWtpc3N1OHVLWkFYaGQrMUtGQndaa1VsWTd3OERoRnZnaU53c0dy?=
 =?utf-8?B?ck5wUWgzR29MWkJ3Y25obHQ3Y1YxQ04xczNENnpSSFBnVEpJTnFna1IwL0t3?=
 =?utf-8?B?LzJzc2RCMm9jK2FUS1VzYjVWWEFOZFlFVWZ3VUVoSUFkaFp0Sk91REhUWTNR?=
 =?utf-8?B?Q052dmdHRUpmcGVPcm9yZnhkZi8vM2EvM1l4N0paMmdSb0pFQ0IxN3orTkIx?=
 =?utf-8?B?WHdzSVFFYmJLRFhTLzJQNlZWMFZiWVZVNVFLTUNBNVhPNTNwdjZMOE1VVXZQ?=
 =?utf-8?B?TkMraVcvdWs2QnlWMis0dmo1ajNnNkJMSkUrbmMrMWtDWFAwSWlwRmR4WjdV?=
 =?utf-8?B?c0RjTHk4QzVYRjlJbTFXam9ZeVI3TDlqS3F2RENKRmZabWs3TDk2bjQyQjdr?=
 =?utf-8?B?MlBHOGVCLzY1Qk90akRMalp2eXMxSzdIMVo1dVkzeFk4eWVJYytaQkVsRzJM?=
 =?utf-8?B?VDV0eVNUY0Q3ZTFrVEdsYnFqWjc0NExlTGk5a1NQNnlBaHRObFh0VTdaQ1hq?=
 =?utf-8?B?dzVtN1M4QS9oMWR6bUkwVG9pRHkwYkxIUmlUMlg2ZldpaXNVV1pYempLTVh5?=
 =?utf-8?B?QTZKVVBlY2ZpaktKUkhLN2JnSVhqbFNacUwyVTFuc2htYnplSnBIaGtFM0Qx?=
 =?utf-8?B?QXJ2d2svbUtJSU9TRy9NaDVYUUk2MWQrcFZ3NFRjSERCQjRlMU5sRTdQeERW?=
 =?utf-8?B?dnRrMmJIRTJ0ZGwraStZSGRwd3lKRGxkc3Y5T0MyNWcyaUtVd25wL3Z2OE15?=
 =?utf-8?B?RVBDaDZMU3NvTG80ZFBEQzFPTkhtZTJOTStQalhOQ3pUQ1A5T0lEbHVmMFU5?=
 =?utf-8?B?ZVBvSDNSTU4xWkhvVDNOSmtPWUZHV2JZWEVWelh5ZmZYZWk3ZzFJMEtyZ1h4?=
 =?utf-8?B?QkhoelpzQ1FrT0JIazREdXpkSlBzckhjZnphdURTdUhva1JMSVZ2WHNxV1gx?=
 =?utf-8?B?cG1PWm5mMDRuRncwaFI4TmRXaFpCd1Ywd2tyakpjOFlMUFBmY1Nad1p4czha?=
 =?utf-8?B?UnJSTG5zZFR6V2tKK2JoSzVKSHFUUThnVUlJc2JreGtsV2gwbDQyVVB6TkNY?=
 =?utf-8?B?dmlnQ0xiQ3dNZG9YeUhaaC8rTUx6cGl2YmpSSUQzZXRSZnBQZzA0eWJkMlRv?=
 =?utf-8?B?ME41WFM2N1g2U25sWW44VnZQNExEK3F6V1V6YURtZDBnUzhYTHp0dFJMdXBW?=
 =?utf-8?B?L2lUV1hEc0djT0tEWWFzYnpNR3ZPcVFvZWpHUlltREtJSDBuUTEzUTd6WFV2?=
 =?utf-8?B?TG5mVDRxOGR4ZVM2QVMxMXljbnF0RDd2ZHZ1SWNodFRqSUsrTldST3dtd3lO?=
 =?utf-8?B?NEE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bf1481-3b49-467c-7b21-08dac6c7cc85
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 05:11:06.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AFUVzoB++Vdu1X2sPtowoPcU0mjAQ+fi7ue7aN3ug4kq64CLoToMlOF4uFaPLD+TUhO4/f9H9LrjmGjeQ5D6117gbVSKsp2gzOFz3wSPcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR02MB8886
X-Proofpoint-ORIG-GUID: uGtDt5ah3YwddfglpdRpT-nBvut6Ryor
X-Proofpoint-GUID: uGtDt5ah3YwddfglpdRpT-nBvut6Ryor
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



On 15/11/22 5:57 am, Yunhong Jiang wrote:
> On Sun, Nov 13, 2022 at 05:05:10PM +0000, Shivam Kumar wrote:
>> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
>> equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   arch/arm64/kvm/arm.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 94d33e296e10..850024982dd9 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -746,6 +746,15 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>   
>>   		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>>   			return kvm_vcpu_suspend(vcpu);
>> +
>> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>> +			struct kvm_run *run = vcpu->run;
>> +
>> +			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>> +			run->dirty_quota_exit.quota = vcpu->dirty_quota;
>> +			return 0;
>> +		}
> There is a recheck on x86 side, but not here. Any architecture specific reason?
> Sorry if I missed anything.
> 
> BTW, not sure if the x86/arm code can be combined into a common function. I
> don't see any architecture specific code here.
Yes, I think we may use a common function for x86/arm.

With that, this would look like:

if (kvm_check_dirty_quota_request(vcpu)) {
	return 0;
}

Thanks,
Shivam
