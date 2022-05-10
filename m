Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75832521CF9
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 16:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241530AbiEJOxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 10:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345091AbiEJOwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 10:52:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7831426CC6B;
        Tue, 10 May 2022 07:13:26 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ADisAS018218;
        Tue, 10 May 2022 14:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Oor8ogHjkZpTqwQbjcKLw8UYnComIosQwnmrrso0yrQ=;
 b=MNupBJt8TPDODGMeh5oQef4oI2j4hZm9uJ7mNEaIZzCpzKc0721cviJm6eo6RUXJ7d3W
 cU5SN0e1nH98GK957oi2GZIOTBsKd+Gd4ctrc8ZSb1oXXTwnoGY1ZQlfx2Ije+dzvpsq
 4NnzNluJfa7AnORxVxy/CLFHkSa9THS9xYuOwvQnGTRffbUyL462rvYSy8Al2kYWlU1S
 tVPN+exz50Ks/7V3I6N2dzNdggEZYAPGNeVaXHXtfCQOnx1dB+M5w9KAG6graurRJtjV
 R/V1LvneZuhKc4l+DeqPmtdz6mObtgYrinGTrTO9hbYXoMH78Zkyd1GowJpzxVm08spo 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fymyq6kpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 14:13:23 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ADkkst026579;
        Tue, 10 May 2022 14:13:22 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fymyq6kny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 14:13:22 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AE9E3R019387;
        Tue, 10 May 2022 14:13:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3fwgd8k84x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 14:13:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AEDHpm52429178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 14:13:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A724B11C04C;
        Tue, 10 May 2022 14:13:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59B1311C050;
        Tue, 10 May 2022 14:13:17 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.124])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 14:13:17 +0000 (GMT)
Message-ID: <3c9561c190a61869ae55b7d762407379faed968c.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add cmm migration test
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Tue, 10 May 2022 16:13:17 +0200
In-Reply-To: <20220510154520.52274a76@p-imbrenda>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
         <20220509120805.437660-3-nrb@linux.ibm.com>
         <20220509155821.07279b39@p-imbrenda>
         <d87472c1556d8503bdda9e1cec26b5d910468cbc.camel@linux.ibm.com>
         <20220510154520.52274a76@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dqCWNAzEHktYP53qebKoVZvfalOlnGc_
X-Proofpoint-GUID: vcG4CgyDvtiU8kcHdm8YA8Fo8naGJft7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=819 clxscore=1015 mlxscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-10 at 15:45 +0200, Claudio Imbrenda wrote:
> ok, next less ugly thing: unroll the loop
> 
> for (i = 0; i < NUM_PAGES; i += 4) {
>         essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
>         essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i + 1]);
>         ... etc
> }
> 
> maybe assert(NUM_PAGES % 4 == 0) before that, just for good measure

That's nicer, thanks, fixed.
