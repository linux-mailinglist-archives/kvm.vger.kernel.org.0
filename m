Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1286D70013E
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 09:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbjELHSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 03:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbjELHR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 03:17:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D79D172A;
        Fri, 12 May 2023 00:17:48 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34C7Cwid026960;
        Fri, 12 May 2023 07:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=419PI9ii7wYLMCwqWWspXkyI2AU/Mq/kR7TE3trVSrI=;
 b=laOkuLY+mnYee+g9KSPFDRmzL9Irn456nAvdy1gt6D5m0sHCcVlZs8Ou/zJ64taw88T6
 oyv+x6oR8L7tRoAjZfpCjRn/yiwCI3qlW5vTsJinuS+mxS67nbD0VGf6m0CPlcTmnCAG
 W7xo3e5cNSmEjI9sUfvFSvtLBDsrYbVvX4CN/nUgS9tnrVB1WAEUCC8yTfn3v4w63hE7
 mxAZzCPof4T3z2F1/bORWiZJqsPWGS3Y7j1wnakBADvB3CPloN9+jFSgOrzQxGRML1cW
 tdMlyB5rPGFFNEKKW+fx8jy0aFQIEh7OlI3zmfRkY+r/dEHdOe2rjhuAewKopCN6AvXE bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhgn40bgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 07:17:47 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34C7DSlX027843;
        Fri, 12 May 2023 07:17:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhgn40bfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 07:17:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C1dXp5020585;
        Fri, 12 May 2023 07:17:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qf84ea6eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 07:17:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34C7Hd0P63308156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 07:17:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3258F20040;
        Fri, 12 May 2023 07:17:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AACA520043;
        Fri, 12 May 2023 07:17:38 +0000 (GMT)
Received: from [9.171.66.102] (unknown [9.171.66.102])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 12 May 2023 07:17:38 +0000 (GMT)
Message-ID: <627fa79b-cc39-1146-13fa-ff5cabbdf57d@linux.ibm.com>
Date:   Fri, 12 May 2023 09:17:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] KVM: s390: vsie: fix the length of APCB bitmap
To:     Pierre Morel <pmorel@linux.ibm.com>, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com
References: <20230511094719.9691-1-pmorel@linux.ibm.com>
 <20230511094719.9691-2-pmorel@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230511094719.9691-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dOLmY-JlVbMAE6LZp5XUZz0qHh-2gwgF
X-Proofpoint-GUID: O80FuNflja7YimqOzW7Jh1d8y4CfaXTT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=687 lowpriorityscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120059
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/23 11:47, Pierre Morel wrote:
> bit_and() uses the count of bits as the woking length.
> Fix the previous implementation and effectively use
> the right bitmap size.
> 
> Fixes: 19fd83a64718 ("KVM: s390: vsie: allow CRYCB FORMAT-1")
> Fixes: 56019f9aca22 ("KVM: s390: vsie: Allow CRYCB FORMAT-2")
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Please push this to devel

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

