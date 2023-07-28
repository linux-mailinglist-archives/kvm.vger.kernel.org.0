Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5078D76656C
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 09:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbjG1Hen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 03:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjG1Hem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 03:34:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C21C2D5B
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 00:34:41 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36S7KPRH018527
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : to : cc : message-id : date; s=pp1;
 bh=hCwiY1IMUywcveOupUFDd4svOOXeqE8WoJ55Pc9Y0/s=;
 b=HdB2FDCp35OaWe2hi8EZxSpzUFYhTssLRCG+GK84pCOHjU3tZB59g6EsTFrTGwuyfuVX
 tnMfHfV7cW0t+2ChPq+R1VPvw+fmHOrdYgbrikfkLKtVCIPDc83BkoFtPjazpVZ1r8tw
 RPkaxXuHqbTj5KcdSK13VcvRF/W4TnnNsWDrPMQgaijEuxV9dbTqB4uk3jBOBnmi6iFO
 O1rQmL7/JnT0033pB7jTFl4BWewJ9pA0jaMoIVOicmwxH78LYG1EjmW/o5xYdIfjfVyW
 fxxFVBPzJ4kOd07vwRJPKlyVNfcJKwqwXSORFqruEt1ER0LqZLKsnyjWHfd56aIPrS2B 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4932gj27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:34:38 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36S7FfeB001607
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:34:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4932ghnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:34:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36S54ZwU002079;
        Fri, 28 Jul 2023 07:34:19 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0tenm5s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 07:34:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36S7YHhM42074644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 07:34:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB9B520043;
        Fri, 28 Jul 2023 07:34:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6964E20040;
        Fri, 28 Jul 2023 07:34:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.77.129])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 07:34:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230725033937.277156-3-npiggin@gmail.com>
References: <20230725033937.277156-1-npiggin@gmail.com> <20230725033937.277156-3-npiggin@gmail.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] migration: Fix test harness hang if source does not reach migration point
To:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Message-ID: <169052965551.15205.2179571087904012453@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 28 Jul 2023 09:34:15 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: F15Tvgd13ZdKae6JjlrCUvlbL6svVf6m
X-Proofpoint-GUID: m-1DeTpiuoN48VyYTPV6D7Y5eeTxNSG_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nicholas Piggin (2023-07-25 05:39:36)
> After starting the test, the harness waits polling for "migrate" in the
> output. If the test does not print for some reason, the harness hangs.
>=20
> Test that the pid is still alive while polling to fix this hang.
>=20
> While here, wait for the full string "Now migrate the VM", which I think
> makes it more obvious to read and could avoid an unfortunate collision
> with some debugging output in a test case.
>=20
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Thanks for attempting to fix this!

> ---
>  scripts/arch-run.bash | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 518607f4..30e535c7 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -142,6 +142,7 @@ run_migration ()
> =20
>         eval "$@" -chardev socket,id=3Dmon1,path=3D${qmp1},server=3Don,wa=
it=3Doff \
>                 -mon chardev=3Dmon1,mode=3Dcontrol | tee ${migout1} &
> +       live_pid=3D`jobs -l %+ | grep "eval" | awk '{print$2}'`

Pardon my ignorance, but why would $! not work here?
