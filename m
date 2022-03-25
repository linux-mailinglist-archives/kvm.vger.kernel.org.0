Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF244E73F9
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245019AbiCYNLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 09:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiCYNLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 09:11:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7AD3136B;
        Fri, 25 Mar 2022 06:10:08 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PD8Dim024108;
        Fri, 25 Mar 2022 13:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=+5gRtM+b/bII+IIEu8okDOR2tIAkwos1yLyPSbr5yJA=;
 b=TM6BpSIAMJlLUQt3K8kEi7LvcjLHB0II3xXEVhaw3JQw04xqbX35nj1E04Sy64/o3Wu4
 ksDMbJPRCosssozTNE7ouy+EYjjvJU8tZ01L1T3bu84rI/9JPxVkqevdew46nllrSYn+
 npanNbc6lQEZec44XWc/fcBSi7M4zvyMg7FeHVELEzj1HLMh5Sc/a/AJ6btGwu1TzVZz
 xCOxCRX0T49c09CFSIYvt5dIwBP19hG0/tsSIIMEcdgLmtcpi3tcZxJkO0H7GucQB44v
 YHwrblMt6l4zeMZsKT9IYh0tfpz/nGfNfwMPYbC6rBt7INg9emFWnvGsreaPimgG2Oeg yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0q5nx1qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 13:10:08 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22PDA5JK022765;
        Fri, 25 Mar 2022 13:10:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0q5nx1q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 13:10:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PD3X9f013779;
        Fri, 25 Mar 2022 13:10:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8uat7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 13:10:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PDA1io42271182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 13:10:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D98C5AE045;
        Fri, 25 Mar 2022 13:10:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84A54AE051;
        Fri, 25 Mar 2022 13:10:01 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.81.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 13:10:01 +0000 (GMT)
Message-ID: <0f193ccfb13be7e4a082ddc3fd59e64ca13bc8fe.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/9] s390x: smp: add test for
 SIGP_STORE_ADTL_STATUS order
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Date:   Fri, 25 Mar 2022 14:10:01 +0100
In-Reply-To: <20220324140317.49a86cdd@p-imbrenda>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
         <20220323170325.220848-5-nrb@linux.ibm.com>
         <20220323184512.192f878b@p-imbrenda>
         <7a624f37d23d8095e56a6ecc6b872b8b933b58bb.camel@linux.ibm.com>
         <20220324140317.49a86cdd@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Mvgga9TbY1TeTjzaWw6JxYNvtkbJzv-i
X-Proofpoint-GUID: -bmedveGx0XxwftUf9fxebrOSWey3lMM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_02,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-24 at 14:03 +0100, Claudio Imbrenda wrote:
> hmm, it seems like that without guarded storage LC is ignored, and
> the
> size is hardcoded to 1024.
> 
> this is getting a little out of hand now
> 
> I think you should make this into a separate test

Yes, I think that makes a lot of sense. I will factor out the store
adtl status test into its own file and send in a seperate series.
