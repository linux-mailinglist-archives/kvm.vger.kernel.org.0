Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB7605AA9
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiJTJH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJTJHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B234819DDA7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:46 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K97dxQ024602
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=w3sfVwGuNKwrZ58aRjItKchdDnzf7NMzXAeYgFEhD88=;
 b=nAoYMTZYxyYOQe4KWikqe3AWsG+Nb36wWNcvSqgCgnxHmu86iCXUs4vVob+LBY97FWnz
 WBIQ8B+dA1MTLlcWWrwLTIC/rLMgU+M02AHGDFFdM402cjesMU72L/Nx7dBb1G9VBkFb
 H9Ey9kcr9U2EMzGP/qP6jlwh6pfiORlpEK+FsaJRiFQAIrxIcDUBvpP4JJ18fe1S5J0Y
 AJ1+g0VmAu7B3Chz3SR0yC1sETMfsecANfigAaxLUm7Ah+wFNAm7npLa7wgOpL9LU0E3
 6qND22Q/43aXLzHIyVoNgxgx0Sxaoe+VTetHaA17isxn0mcRNE+8YSUjhhVOHlJVPRK6 Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb1rpbd32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:45 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K97iGi025120
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb1rpbc1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:07:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8pXWK005093;
        Thu, 20 Oct 2022 09:03:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98mnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:03:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K8wFe343581764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:58:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B82C752051;
        Thu, 20 Oct 2022 09:03:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 67C4E5204E;
        Thu, 20 Oct 2022 09:03:17 +0000 (GMT)
Date:   Thu, 20 Oct 2022 11:03:15 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/8] s390x: uv-host: Access check
 extensions and improvements
Message-ID: <20221020110315.7ef10f6d@p-imbrenda>
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q0wtM3HZfy6vH_JGjbP7XD1yk0EE-QJW
X-Proofpoint-ORIG-GUID: tqIn6yEJ8WsOg00zAnfTxUcOPDUW4EaI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Oct 2022 09:39:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Over the last few weeks I had a few ideas on how to extend the uv-host
> test to get more coverage. Most checks are access checks for secure
> pages or the UVCB and its satellites.

thanks, picked

> 
> v3:
> 	* Added len assert for access_check_3d
> 	* using the latest version of patch #1
> 
> v2:
> 	* Moved 3d access check in function
> 	* Small fixes
> 	* Added two more fix patches
> 
> Janosch Frank (8):
>   s390x: uv-host: Add access checks for donated memory
>   s390x: uv-host: Add uninitialized UV tests
>   s390x: uv-host: Test uv immediate parameter
>   s390x: uv-host: Add access exception test
>   s390x: uv-host: Add a set secure config parameters test function
>   s390x: uv-host: Remove duplicated +
>   s390x: uv-host: Fence against being run as a PV guest
>   s390x: uv-host: Fix init storage origin and length check
> 
>  s390x/uv-host.c | 264 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 254 insertions(+), 10 deletions(-)
> 

