Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4771FB91
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 10:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjFBIKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 04:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjFBIKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 04:10:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D9513E;
        Fri,  2 Jun 2023 01:10:16 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3527qc2I001666;
        Fri, 2 Jun 2023 08:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ziac00Ta0a1QyKeiWy07siCmxj/DG1Mi5ybwV496+fw=;
 b=aiIfIFeQyRUEytDZJCP8zSGl2zHJ7nGX4ATGxMvj1OXhopqlF1xgrtHDPkeGnFdAJEfu
 ot+ZpcBCSxbyCMiofHlm9mi0gb+rN2dPAtWBUwErTxkBXn4TXKaHRU01EfRka9A/0BT3
 +31ULc7+W4VcnJzOlPr9Y2/f6UDaMf7Ih95EFqwm/OlEWFv4UTtBUXW4GA2ZhdwHIuNA
 rtxmoJEfR/OIZPCBUqrOBijCVR6S0c3tllMvNK+GwcvvE73H0s6/KJkKjwGso9kVJZbq
 HYWLLc+41zX10d9sgcPBfeH6OKXZJySC8C63GZB5r2g3r3p1BFDTD9Gu41Ci6HpabeLb 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycdugfsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:10:15 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3528639V005406;
        Fri, 2 Jun 2023 08:10:15 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycdugfr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:10:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3524RaKP009016;
        Fri, 2 Jun 2023 08:10:12 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qu9g5advf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:10:12 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3528A9pj10814112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 08:10:09 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01A3220040;
        Fri,  2 Jun 2023 08:10:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEDB12005A;
        Fri,  2 Jun 2023 08:10:08 +0000 (GMT)
Received: from [9.171.82.186] (unknown [9.171.82.186])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Jun 2023 08:10:08 +0000 (GMT)
Message-ID: <ffd0961e-fa5f-ce17-4e0a-3614f5e6968b@linux.ibm.com>
Date:   Fri, 2 Jun 2023 10:10:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [kvm-unit-tests PATCH v3 0/9] s390x: uv-host: Fixups and
 extensions part 1
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
References: <20230502130732.147210-1-frankja@linux.ibm.com>
 <168554442988.164254.12199952661638322868@t14-nrb>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <168554442988.164254.12199952661638322868@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dMH3DKpiHrLDJeSW2iqetOf-LvHRtgyW
X-Proofpoint-GUID: pW6noZ-m09lIgQcINrdkxBYg7IEbWG7c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_05,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306020061
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/23 16:47, Nico Boehr wrote:
> Quoting Janosch Frank (2023-05-02 15:07:23)
>> The uv-host test has a lot of historical growth problems which have
>> largely been overlooked since running it is harder than running a KVM
>> (guest 2) based test.
>>
>> This series fixes up smaller problems but still leaves the test with
>> fails when running create config base and variable storage
>> tests. Those problems will either be fixed up with the second series
>> or with a firmware fix since I'm unsure on which side of the os/fw
>> fence the problem exists.
>>
>> The series is based on my other series that introduces pv-ipl and
>> pv-icpt. The memory allocation fix will be added to the new version of
>> that series so all G1 tests are fixed.
> 
> I have also pushed this to our CI, thanks.
> 
> Also here, I took the liberty of adding
> groups = pv-host
> in the last patch. If you are OK with it, I can carry that when picking for the
> PR.

Sure, since Thomas reviewed the patch introducing the group I'm fine 
with that.
