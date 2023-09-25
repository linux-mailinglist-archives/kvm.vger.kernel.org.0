Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE567ADACD
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 17:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjIYPAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 11:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjIYPAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 11:00:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339C2103;
        Mon, 25 Sep 2023 08:00:25 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38PEdjPc003761;
        Mon, 25 Sep 2023 15:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0XnGU+HhFugEoI566S2IeVCh7/GRwEQPF9PUwnwFgzs=;
 b=mAJLTkqgu+BRtK0+zd7QFBKcU1iyQaCMrsbJ2NH4WY52TSgxqgEQw5Yhsl0NS4luRTZV
 sxRj3mLGn1oEMwN9huyu/p5OwjkhsLQrf5r/ks4FA1rcg0YuSVi6K8R8v5C1xVeEgeJk
 G5G/kFCPZOgfJL0Pjap6uVVz9xhLIqn9hft8IRoba7B+jlO3w9OxegtP27FE2KxLtO5K
 NY13f2B6T4ZSJ5ABe9gNaBnccUijsEa1QCurArfxGOH9ah2lA6p9JKENSGmXK2QHI4bG
 DHNkQhwdIJKptkWDItZmBMDMjdwjbAxVkAni2z58ltoXfmRhq7zviWNdOgGfw1MAIMcv xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ta5rdg8d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 15:00:24 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38PCf25q031182;
        Mon, 25 Sep 2023 15:00:23 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ta5rdg8bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 15:00:23 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38PEoMLk030544;
        Mon, 25 Sep 2023 15:00:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tad21ajhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Sep 2023 15:00:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38PF0JvA38994194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Sep 2023 15:00:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D48A20063;
        Mon, 25 Sep 2023 15:00:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D4D2006A;
        Mon, 25 Sep 2023 15:00:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 25 Sep 2023 15:00:19 +0000 (GMT)
Date:   Mon, 25 Sep 2023 17:00:17 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, nsg@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: run PV guests with
 confidential guest enabled
Message-ID: <20230925170017.7ab08784@p-imbrenda>
In-Reply-To: <20230925135259.1685540-1-nrb@linux.ibm.com>
References: <20230925135259.1685540-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I4z1nAcAJtar0tGdUmSj6DY0uDEmtJvu
X-Proofpoint-GUID: av6KdGFoTLA6Xliaxdb7j21zWqM8SQEq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-25_12,2023-09-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309250111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Sep 2023 15:52:45 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> PV can only handle one page of SCLP read info, hence it can only support
> a maximum of 247 CPUs.
> 
> To make sure we respect these limitations under PV, add a confidential
> guest device to QEMU when launching a PV guest.
> 
> This fixes the topology-2 test failing under PV.
> 
> Also refactor the run script a bit to reduce code duplication by moving
> the check whether we're running a PV guest to a function.
> 
> Suggested-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/run | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/run b/s390x/run
> index dcbf3f036415..e58fa4af9f23 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -14,19 +14,34 @@ set_qemu_accelerator || exit $?
>  qemu=$(search_qemu_binary) ||
>  	exit $?
>  
> -if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$ACCEL" = "tcg" ]; then
> +is_pv() {
> +	if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ]; then
> +		return 0
> +	fi
> +	return 1
> +}
> +
> +if is_pv && [ "$ACCEL" = "tcg" ]; then
>  	echo "Protected Virtualization isn't supported under TCG"
>  	exit 2
>  fi
>  
> -if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$MIGRATION" = "yes" ]; then
> +if is_pv && [ "$MIGRATION" = "yes" ]; then
>  	echo "Migration isn't supported under Protected Virtualization"
>  	exit 2
>  fi
>  
>  M='-machine s390-ccw-virtio'
>  M+=",accel=$ACCEL$ACCEL_PROPS"
> +
> +if is_pv; then
> +	M+=",confidential-guest-support=pv0"
> +fi
> +
>  command="$qemu -nodefaults -nographic $M"
> +if is_pv; then
> +	command+=" -object s390-pv-guest,id=pv0"
> +fi
>  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
>  command+=" -kernel"
>  command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"

