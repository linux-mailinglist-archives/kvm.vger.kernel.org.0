Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3915B5B8D
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiILNsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 09:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiILNsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 09:48:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0FC12634
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 06:48:34 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDNhQe018217;
        Mon, 12 Sep 2022 13:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=nUEjAhTeAWa1dYc2rgevzz7yeYuFIBnuhqBemiU7Vx8=;
 b=o8L5cx6Ss14OFYtYt89BfDPsueaiNpv8r1EzDCVBA2RJy0mVxj77iR+yCf+hYvNahtqw
 54ouhD71fguz/6GHpmO8OR/KqK7h0PrEsPAaS6fO7b3mo1akGy8D5qi/XCfLk3d9fojI
 QpQ/dOJSAmBsjs5FZml1dyoSzpaXerRqqJNrZ3zXcI2FTW1Ir0BT2XjisB5Mg+a+B9ch
 m6dfnRTzQUOT8oB1IvpZ9U/gtHFXdpcziEqLtlgNYUKs2X8KEYVB3rXcvuPbghvQt2pY
 4SijHfnnmWTfYT8C/hpGIeJ6MnsUTaB1/NTIn030DB1xaPBzcE4xnY7+kUtNkYYBrlH7 Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj5m78nnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 13:48:28 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CDO8eV020136;
        Mon, 12 Sep 2022 13:48:28 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj5m78nmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 13:48:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CDcsd5026120;
        Mon, 12 Sep 2022 13:48:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3jgj78stq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 13:48:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CDie6q17957210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:44:40 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A507A4090;
        Mon, 12 Sep 2022 13:48:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F786A4075;
        Mon, 12 Sep 2022 13:48:21 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.22.70])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Sep 2022 13:48:21 +0000 (GMT)
Message-ID: <ac3a9ee7df2e2c47b83a1bff01fd357ca83c2f5d.camel@linux.ibm.com>
Subject: Re: [PATCH v9 10/10] docs/s390x: document s390x cpu topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Mon, 12 Sep 2022 15:48:21 +0200
In-Reply-To: <20220902075531.188916-11-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-11-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N_r310c33U5FxnGv6k5Y3_KiKubtVEq1
X-Proofpoint-ORIG-GUID: FoFBXWcXP5lLJS32Zi4DzWaELSDDK29L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 suspectscore=0 mlxscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> Add some basic examples for the definition of cpu topology
> in s390x.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  docs/system/s390x/cpu_topology.rst | 88 ++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
>  create mode 100644 docs/system/s390x/cpu_topology.rst
> 
> diff --git a/docs/system/s390x/cpu_topology.rst b/docs/system/s390x/cpu_topology.rst
> new file mode 100644
> index 0000000000..00977d4319
> --- /dev/null
> +++ b/docs/system/s390x/cpu_topology.rst
> @@ -0,0 +1,88 @@

[...]

> +Indicating the CPU topology to the Virtual Machine
> +--------------------------------------------------
> +
> +The CPU Topology, number of drawers, number of books per drawers, number of
> +sockets per book and number of cores per sockets is specified with the
> +``-smp`` qemu command arguments.
> +
> +Like in :
> +
> +.. code-block:: sh
> +    -smp cpus=1,drawers=3,books=4,sockets=2,cores=8,maxcpus=192
> +
> +If drawers or books are not specified, their default to 1.

Forgot this:
s/their default/they default/


[...]
