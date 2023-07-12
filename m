Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2E75075A
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 13:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbjGLL7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 07:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjGLL7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 07:59:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94453210C;
        Wed, 12 Jul 2023 04:59:11 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBlBVp006859;
        Wed, 12 Jul 2023 11:58:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hbUnn8+/rBblVsIIulEHh/Riw5JjFRL/FdcsKayaEbU=;
 b=r7B2ZPukz2rqx3Ga/25RUrE2aED0Zwx2tQGBCYc75/2UOEPhkXY1L9aK/ncAqH+aQqx7
 WiLlLsueb60BYM4aqNGg/L4jyg6d7Z0FwHX5AGxGNpwnlmTdbWX1a9WT0LG7RA6qPheZ
 7ZosLbDEL48TRNzGl2CcLHy/fbqWm3T8PorBzmeWyrJBpJRofscAHIPpO56XIsUgUgD8
 4jvp/TSZRzYqbPMRuVK/RA0nqkFEiJ3SMuX290CX/AKat94xvxAdk0It9Rc3bQCKgSaq
 HpDF/lGn+C3BqAg4QMnCc/90eynXuy/E9YBfXBItDvE9Z+znKmAm81J6RKBWkULCIkXp yw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsukx08sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 11:58:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C2DVUJ019835;
        Wed, 12 Jul 2023 11:58:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5amex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 11:58:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CBwoR129622602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 11:58:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DC182004D;
        Wed, 12 Jul 2023 11:58:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6EF520049;
        Wed, 12 Jul 2023 11:58:49 +0000 (GMT)
Received: from [9.179.10.213] (unknown [9.179.10.213])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 11:58:49 +0000 (GMT)
Message-ID: <e3daf6b9-c7e9-89f3-b6ab-d8cf89de0b86@linux.ibm.com>
Date:   Wed, 12 Jul 2023 13:58:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 2/2] KVM: s390: pv: fix index value of replaced ASCE
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        mhartmay@linux.ibm.com, nsg@linux.ibm.com, borntraeger@de.ibm.com,
        nrb@linux.ibm.com
References: <20230705111937.33472-1-imbrenda@linux.ibm.com>
 <20230705111937.33472-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230705111937.33472-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6IeNygMyaxLYJmH5Y7IW7wbtdiOHfxYh
X-Proofpoint-ORIG-GUID: 6IeNygMyaxLYJmH5Y7IW7wbtdiOHfxYh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=936 adultscore=0 phishscore=0 malwarescore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120103
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/23 13:19, Claudio Imbrenda wrote:
> The index field of the struct page corresponding to a guest ASCE should
> be 0. When replacing the ASCE in s390_replace_asce(), the index of the
> new ASCE should also be set to 0.
> 
> Having the wrong index might lead to the wrong addresses being passed
> around when notifying pte invalidations, and eventually to validity
> intercepts (VM crash) if the prefix gets unmapped and the notifier gets
> called with the wrong address.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

No fixes tag?

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

