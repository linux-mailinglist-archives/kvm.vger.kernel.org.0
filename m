Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6925FC540
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJLMYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 08:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJLMYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 08:24:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3264F3B95C
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 05:24:08 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CBg1gN008004
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/aZP5WUO11RRn9fJZNddz7GmmERQzsDobSFxo98ZtY4=;
 b=lhHfW5ljkuCwF4CV8yYS104nncdxXI/fofqDnPR1y5OGmrVrl/sD5FjmajSj8/nFIosr
 DZUtk+4ok5Ad0kFbzW8DskUvDdEy61GjUuL6vsyt/F7rEKcTSj9fRk6Z27g5jvWAx8SH
 ho8ydWggJFRFFlwf5dP0/eVZG25+CVyMXLSDMDTRYN3dn1x9qce65sfpSm5shwPdYsYH
 YKErXZGVLTUncVZdoW3sLXHg0c1png9ytbnSEeC0kLuHpVgT3s8TJOgVisbJDue4oCf2
 t6ilTDSdJ33ixiYfBkFX9cvEJmCNbrJNemxuVMm+DRidabWsN8BOhIuJUJMXexsEmFMq 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5uwq2ukq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:24:07 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CBibqH015228
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 12:24:07 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5uwq2ujw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 12:24:07 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CCMkKN029680;
        Wed, 12 Oct 2022 12:24:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3k30u8vg7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 12:24:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CCO1Ow61276578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 12:24:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A004EA404D;
        Wed, 12 Oct 2022 12:24:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BC03A4040;
        Wed, 12 Oct 2022 12:24:01 +0000 (GMT)
Received: from [9.171.48.218] (unknown [9.171.48.218])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 12:24:01 +0000 (GMT)
Message-ID: <084c56ed-3126-a001-a6c5-2ee0684a147f@linux.ibm.com>
Date:   Wed, 12 Oct 2022 14:24:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add exittime tests
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
References: <20221012121128.1179252-1-nrb@linux.ibm.com>
 <20221012121128.1179252-2-nrb@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221012121128.1179252-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uvSZquDLE0Q-ZgufJDAY3GeBwcQB-1sV
X-Proofpoint-GUID: 6HG0AdIxdNE0FMHbHXNe5bAoYBA4tEPT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_05,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120079
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.10.22 um 14:11 schrieb Nico Boehr:
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 2c04ae7c7c15..11cac3ca135d 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,6 +185,7 @@ groups = migration
>   [migration-skey]
>   file = migration-skey.elf
>   groups = migration
> +<<<<<<< HEAD

looks like a wrong merge conflict leftover.
