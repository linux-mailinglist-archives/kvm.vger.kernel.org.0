Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54673605FCC
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 14:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiJTMNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 08:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJTMNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 08:13:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC65150FBD
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 05:13:02 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KBV0V5027031
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FosFnfas6CpizAWJxBBba0oQcYeQaGFAJuqoLd/5Qv0=;
 b=i7Y7J60HQugRc/S2ZkgXdy6+6Oux0TrgKK5eInkUFc4n9sglpd9IamI8uTlzsIB1c9H3
 GgYR4gHtI7FGqu7yw/ujvp7Pou/SA3NO3b/jNhPsnNLJEAvWtiXDolNrjogE90BYn1EO
 CllmPUQH8tkHd769PDMQhEHxC0gGuG78YQKe+ZFjpE3gcFb+z3fVEfw1IDWkSbLZ0riM
 UX1qTGPyWgOCwhF/Fq5JerAkkOdkAmvm7M+7i6+rvcVgqAEl/gDJPce2jIyNyp/tzRip
 s1cegPdI6IaoVS34sBdXcF3WEp7eaIo2v8EYmAn9cWcD3MTP+5Zj5Q78uzki5KvQ2Y5F eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb5hbhfb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:13:01 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KBWmIY002187
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:13:01 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb5hbhfa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:13:00 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KC5Y0K005650;
        Thu, 20 Oct 2022 12:12:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg96nct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:12:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KCCtsx4981316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 12:12:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AE1C42041;
        Thu, 20 Oct 2022 12:12:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E4D24203F;
        Thu, 20 Oct 2022 12:12:54 +0000 (GMT)
Received: from [9.171.57.143] (unknown [9.171.57.143])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 12:12:54 +0000 (GMT)
Message-ID: <316e669c-0fe4-d92d-2bd5-7cf52e2a849f@linux.ibm.com>
Date:   Thu, 20 Oct 2022 14:12:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM
 interrupt in interrupt handler
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        seiden@linux.ibm.com, scgl@linux.ibm.com, thuth@redhat.com
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
 <20221018140951.127093-2-imbrenda@linux.ibm.com>
 <166616486603.37435.2225106614844458657@t14-nrb>
 <20221019115128.2a8cbf13@p-imbrenda>
 <166625268562.6247.14921568293025628326@t14-nrb>
 <20221020105738.2af4ece0@p-imbrenda>
 <593e6d2f-e857-48c6-fa2d-158b83b4db4f@linux.ibm.com>
 <20221020134559.609bba25@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20221020134559.609bba25@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: auEYm3KAjCEJTTJ0po6m9UiC_GFztady
X-Proofpoint-ORIG-GUID: SjZQJAuUGcmsbQF-5ij2jLAjUvUXULjN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 mlxlogscore=703 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 13:45, Claudio Imbrenda wrote:
> On Thu, 20 Oct 2022 13:19:36 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 10/20/22 10:57, Claudio Imbrenda wrote:
>>> On Thu, 20 Oct 2022 09:58:05 +0200
>>> Nico Boehr <nrb@linux.ibm.com> wrote:
>>>    
>>>> Quoting Claudio Imbrenda (2022-10-19 11:51:28)
>>>> [...]
>>>>> I was thinking that we set pgm_int_expected = false so we would catch a
>>>>> wild program interrupt there, but in hindsight maybe it's better to set
>>>>> in_interrupt_handler = true there so we can abort immediately
>>>>
>>>> Oh right I missed that. I think how it is right now is nicer because we will get a nice message on the console, right?
>>>
>>> which will generate more interrupts
>>>
>>> @Janosch do you think it's better with or without setting
>>> in_interrupt_handler in the pgm interrupt handler?
>>>    
>>
>> Any reason why you didn't set it in CALL_INT_HANDLER?
> 
> because then it will always be set whenever we get a PGM, the if will
> always be true

Alright, then let's do in_interrupt_handler = true

> 
>>
>>>>
>>>> In this case:
>>>> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>>>    
> 

