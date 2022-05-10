Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3D1522215
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 19:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347052AbiEJRSA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 13:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239349AbiEJRR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 13:17:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D067B2BF30A;
        Tue, 10 May 2022 10:14:00 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AGQHCI009350;
        Tue, 10 May 2022 17:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=B8JUa8Gkq6B8oFoZ0huHyIRt5JmUqk4NH/1EQMXEK2c=;
 b=cEM2ezvSUZ0+O0LN6DCv/d3SfunWwDMKaSAmOfAE8fK+xo2s1D8rAAlSDVM+vx9aWugo
 ynP5TcKDORhq5S7t9scqRAJpEG5WIGeHQRLlK+W8CRBbwSj6zFUAw63PdB1AAvbfpVG3
 ShP652Pn2GVaF78BCLImwOjcfo++R618zkGe46BRYAAePEJnMRZqwNqMKC6IP3G2QZcw
 2RWaLLT81VlYF4qT/QQU3CXWSJdHPFUdY1uoKcgejTN0/9qPvqOU8cr9rpRRNWeP4UiK
 1L9KXMM7Z3tH1OO6mlCvFhtzBrOuC+qaskTkgVy3HWYV6IbQ+uqQhJ5fMNGq9Qbwhw0G kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyujs93f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:14:00 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24AHDxP2027820;
        Tue, 10 May 2022 17:13:59 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyujs93ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:13:59 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AHDfhi030977;
        Tue, 10 May 2022 17:13:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8kcyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:13:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AHDs4L34472264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 17:13:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 183E7A405B;
        Tue, 10 May 2022 17:13:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD320A4054;
        Tue, 10 May 2022 17:13:53 +0000 (GMT)
Received: from [9.145.38.155] (unknown [9.145.38.155])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 17:13:53 +0000 (GMT)
Message-ID: <cd228e1a-3c38-544d-1968-e99458998f71@linux.ibm.com>
Date:   Tue, 10 May 2022 19:13:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Fix sclp facility bit numbers
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
 <20220505124656.1954092-2-scgl@linux.ibm.com>
 <20220506173121.667ef671@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220506173121.667ef671@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9sKYU3DfbW7bNZZgxkfm25Y1oKTpGB2c
X-Proofpoint-GUID: YBcCGc4_oKsCBa8iHU4tGNxYZIVZKlnh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_05,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205100074
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 17:31, Claudio Imbrenda wrote:
> On Thu,  5 May 2022 14:46:54 +0200
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> sclp_feat_check takes care of adjusting the bit numbering such that they
>> can be defined as they are in the documentation.
> 
> this means we had it wrong all along and we somehow never noticed

That tends to happen when you add definitions and never actually use 
them. :)

> 
> ooops!
> 
> anyway:
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
>>
>> Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   lib/s390x/sclp.h | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index fead007a..4ce2209f 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -134,13 +134,15 @@ struct sclp_facilities {
>>   };
>>   
>>   /* bit number within a certain byte */
>> -#define SCLP_FEAT_85_BIT_GSLS		7
>> -#define SCLP_FEAT_98_BIT_KSS		0
>> -#define SCLP_FEAT_116_BIT_64BSCAO	7
>> -#define SCLP_FEAT_116_BIT_CMMA		6
>> -#define SCLP_FEAT_116_BIT_ESCA		3
>> -#define SCLP_FEAT_117_BIT_PFMFI		6
>> -#define SCLP_FEAT_117_BIT_IBS		5
>> +#define SCLP_FEAT_80_BIT_SOP		2
>> +#define SCLP_FEAT_85_BIT_GSLS		0
>> +#define SCLP_FEAT_85_BIT_ESOP		6
>> +#define SCLP_FEAT_98_BIT_KSS		7
>> +#define SCLP_FEAT_116_BIT_64BSCAO	0
>> +#define SCLP_FEAT_116_BIT_CMMA		1
>> +#define SCLP_FEAT_116_BIT_ESCA		4
>> +#define SCLP_FEAT_117_BIT_PFMFI		1
>> +#define SCLP_FEAT_117_BIT_IBS		2
>>   
>>   typedef struct ReadInfo {
>>   	SCCBHeader h;
> 

