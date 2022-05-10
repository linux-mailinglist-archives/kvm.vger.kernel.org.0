Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12AB5215CE
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbiEJMv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiEJMv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:51:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B5AE52AB;
        Tue, 10 May 2022 05:47:31 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AAqPc5000815;
        Tue, 10 May 2022 12:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Lo2ncoSlpbd4n7h/Shl9pgvfqkip5AOvGgH7yPp6/I4=;
 b=W/Oum3sXcinK5yf0wEKt91nnlW6Fozhw5P0lpaIrwvNXyFWQRqG290rtYKF9FX2suIYS
 s9ohtHSfrRkm9JA2yblMm+IW2SVWI4KuFBUOTViwog16E1o7Rfa6Y6I7Bryt48PR/5Km
 Cuya6Bq7pWgyYwYv6v/A3DMwKqp+RFWfBjDDXPv3HDs3VV80ji+VwmcyBIbUJQroUL1a
 vpMkL2alz8GYyKAF7GaoHYA82CUPW6p2LJAYZPATBGvuIlDZztxNCAmPTvyKFnkYFNAQ
 OEscUOARApuR8syfCV76HNl5vSShp65eD8u7ZHekGh4rO6dUz99LWPnvvd8Ngj/Up3DP dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fypp0t808-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:47:31 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ACUCf1002580;
        Tue, 10 May 2022 12:47:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fypp0t7yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:47:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AChcET003878;
        Tue, 10 May 2022 12:47:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j43fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:47:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AClPSA45482452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 12:47:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 494CFA405B;
        Tue, 10 May 2022 12:47:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 039F9A4054;
        Tue, 10 May 2022 12:47:25 +0000 (GMT)
Received: from [9.145.38.155] (unknown [9.145.38.155])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 12:47:24 +0000 (GMT)
Message-ID: <9ab646da-c104-b7a1-70f8-fbd8a6e74150@linux.ibm.com>
Date:   Tue, 10 May 2022 14:47:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v1 0/2] s390x: add migration test for CMM
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com
References: <20220509120805.437660-1-nrb@linux.ibm.com>
 <20220509160009.3d90cbe4@p-imbrenda>
 <aaf93deff51ccac5d17d8a6d38c399745ecf30c1.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <aaf93deff51ccac5d17d8a6d38c399745ecf30c1.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sa0gBqM_SyNmFflOgZ2SAGnOYwTKrL7g
X-Proofpoint-ORIG-GUID: S-TkzC_7FIUT8RqClIkUHMIfVK05AGz9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_01,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205100057
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 12:58, Nico Boehr wrote:
> On Mon, 2022-05-09 at 16:00 +0200, Claudio Imbrenda wrote:
>> I wonder if we are going to have more of these "split" tests.
>>
>> is there a way to make sure migration prerequisites are always
>> present?
> 
> We could not run _any_ tests if netcat is not installed, which seems
> like a bad idea.
> 
>> or rewrite things so that we don't need them?
> 
> We need ncat to communicate with the QEMU QMP over unix socket. I am
> not aware of a way to use unix sockets in Bash, but no expert either.
> 
> We could ship our own version of netcat and build it for the host,
> which adds additional complexity and maintenance burden.
> 
> I honestly can't think of a good way.
> 
> Or we just put all cmm tests in a single file and accept the fact that
> if you don't have all the migration related requirements installed, you
> don't get all the tests - even some which are not at all related to
> migration. I did not like that so I went with the extra file.

Having them separate is fine. I'd change the file name to 
migration-cmm.elf though. We might also want to change the name of the 
first migration test in the future to make the name more specific.
