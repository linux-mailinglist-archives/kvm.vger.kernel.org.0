Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E804D951F
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 08:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbiCOHWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 03:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbiCOHWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 03:22:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A54D4AE29;
        Tue, 15 Mar 2022 00:21:06 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F5HpM7033165;
        Tue, 15 Mar 2022 07:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=rSbI7wSPKwmEIx2PL2iyecfi4qztJK21+a3pilSG2xg=;
 b=cWSfzR7T3JEHU4PD5RBgP6Z+HjHQiukwhCujoAQUOHAN6kAhdmFHNcqlCMGaVUil4oQp
 sL4dVWcXbgCoXF6LG/AvzLGnoZ5CCwSEDGJZ6hJGWZ4e4o2D70Z5gM19B9HFTnp+swZa
 hVug/Cf3s5nntAFkMVM+BbeLnKUeHwVDzPiFuBuE16d/jSpOr+k1eRuVT+1dpZoqxIbl
 KIdxnwNzZQhWqmGzkjlZjmH3uxkDbByJLGA1Au1QHajCksvMCsW1dDuD28BJh+a+oP9l
 ksTJX3Hf943WmcFye4x/dfJCgM3fqsMBxHAnByhpc9ot1jXWTED+qJkG3S0EM/vJm8OH UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etmhet30j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 07:21:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22F6mEeL035820;
        Tue, 15 Mar 2022 07:21:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etmhet2yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 07:21:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22F7DGqi009017;
        Tue, 15 Mar 2022 07:21:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3erjshnxbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 07:21:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22F7KxUj25166198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 07:20:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C20AA4C2D;
        Tue, 15 Mar 2022 07:20:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15564A4C23;
        Tue, 15 Mar 2022 07:20:59 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.5.92])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 07:20:59 +0000 (GMT)
Message-ID: <726298ed4be76acb61ac514fa7c18f9f7934a9a0.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v2 6/6] lib: s390x: smp: Remove
 smp_sigp_retry
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 15 Mar 2022 08:20:58 +0100
In-Reply-To: <20220311173822.1234617-7-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
         <20220311173822.1234617-7-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: L3emo3aZFKbsnbQDlecvPVosWFN_zTdd
X-Proofpoint-ORIG-GUID: 5zor1OqG9LxPVTko3x4bqop6J_7ivQeF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=842 mlxscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-11 at 18:38 +0100, Eric Farman wrote:
> The SIGP instruction presents a CC0 when an order is accepted,
> though the work for the order may be performed asynchronously.
> While any such work is outstanding, nearly any other SIGP order
> sent to the same CPU will be returned with a CC2.
> 
> Currently, there are two library functions that perform a SIGP,
> one which retries a SIGP that gets a CC2, and one which doesn't.
> In practice, the users of this functionality want the CC2 to be
> handled by the library itself, rather than determine whether it
> needs to retry the request or not.
> 
> To avoid confusion, let's convert the smp_sigp() routine to
> perform the sigp_retry() logic, and then convert any users of
> smp_sigp_retry() to smp_sigp(). This of course means that the
> external _retry() interface can be removed for simplicity.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
