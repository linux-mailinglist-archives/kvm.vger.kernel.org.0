Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D676D5231BC
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiEKLcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239460AbiEKLcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:32:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5175A08C;
        Wed, 11 May 2022 04:32:11 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BAbQr9016936;
        Wed, 11 May 2022 11:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Ke0W5Kae+F0Ex4s0W9qA6BLgMeuZPg9PC+xRVT4arIM=;
 b=RzNvsVmeCl3HDt8dgTe/WNbaUj2J4rEDTkzM0AfEolXSqEE1zPeKTPGSY5q4Xgf+68EI
 eQIUbkMD97AurPcN+wOkud2f5tiqzEbew135fOEAz5Mu33uRg9+X/YlG2zFDZvkjScx5
 K5AS+TLSVf+wuQEKLmaHegXoHJdXmzveA4KHHtMpparP12pQ2ZkYWyWtt5+eH9uPs1Mq
 f4J+/JksXF/TBVnOxP5NwMH2FNXs6F8odkma1iCDVYC8BxwSnGGFtx43JS4rrpJHnV2R
 9TqDXdRV7ToO3mZHWtJYx+boYFhY89emxNoZJ31morm/OxOtNQko5/wtnbjAcOYNcSo5 Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0a6ytb0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 11:32:10 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24BBWAJ2027787;
        Wed, 11 May 2022 11:32:10 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0a6ytb0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 11:32:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24BBDPIx025946;
        Wed, 11 May 2022 11:32:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8wcja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 11:32:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24BBVkVZ23789896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 11:31:46 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A625A405B;
        Wed, 11 May 2022 11:32:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D360A4054;
        Wed, 11 May 2022 11:32:05 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.152.224.44])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 May 2022 11:32:05 +0000 (GMT)
Message-ID: <fda492b4645a343ef612320f3694b45ea4875f20.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add cmm migration test
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Wed, 11 May 2022 13:32:05 +0200
In-Reply-To: <20220511131414.63edc473@p-imbrenda>
References: <20220511085652.823371-1-nrb@linux.ibm.com>
         <20220511085652.823371-3-nrb@linux.ibm.com>
         <20220511131414.63edc473@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cLmivH95e3cvzNwFhy4dHnqZ2XrP14hy
X-Proofpoint-GUID: H94I9I2SBFXbhQjej_Or_Hdjq7AAw7vq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_03,2022-05-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=818 adultscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-11 at 13:14 +0200, Claudio Imbrenda wrote:
> do we actually need this include?


It is not needed, removed.

> if not, remove it, then you can add:
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks.
