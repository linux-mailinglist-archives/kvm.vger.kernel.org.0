Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAF4DD669
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 09:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiCRIsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 04:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiCRIr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 04:47:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F188B19C838
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 01:46:40 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22I8j8tR000378
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 08:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=TBsVAhQR9Hi2gm2wQutvQLZbz6/0yaowfWOXuejJpmI=;
 b=BAaU7JMKCWGH6YCigcnt3qCQmWltyZwRdSg8fmghsqu0sgWNxz6U5IKlmrBLrDVWNRj9
 A/8QE8Trc2hf7L++o4k2vQHyRebGlI00Fl4OZ55RyrSBS0V77P/hittC8nTlxYJfDtiM
 +KOB+2c7XRTpg3c45agwvVnrVxjxmpo1ciohGeGnGZPugXFRiH6+0CSKra6bxtu6JyAZ
 6Xl4losOgwhxpsybCtzjA3jnAU+n90NKaQocpidA3LcJwLcdiSi2QkNSuX0DQnDTm2FM
 7ieEgXqhtkdCrlzgD9e3AGyMzlB4t4CXG3TvCCp5wqk/YOYJrTUORCsmWt62AkUE5RX+ 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3euxtr3q29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 08:46:39 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22I8kdEU007409
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 08:46:39 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3euxtr3q1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 08:46:39 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22I8ctSQ026424;
        Fri, 18 Mar 2022 08:46:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3erk58u5hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 08:46:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22I8kYC951380632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 08:46:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 782E1A404D;
        Fri, 18 Mar 2022 08:46:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29EB5A405B;
        Fri, 18 Mar 2022 08:46:34 +0000 (GMT)
Received: from marcibm (unknown [9.171.66.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 18 Mar 2022 08:46:34 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] runtime: indicate failure on
 crash/timeout/abort in TAP
In-Reply-To: <20220310150322.2111128-1-nrb@linux.ibm.com>
References: <20220310150322.2111128-1-nrb@linux.ibm.com>
Date:   Fri, 18 Mar 2022 09:46:32 +0100
Message-ID: <87bky3veaf.fsf@marcibm.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a5a-4vcwg_4jb8BLk6V13EVX6v-P5tBt
X-Proofpoint-ORIG-GUID: l2Zm7JWHP5vW2vsThy4jsLR_EWgncx5k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_07,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nico Boehr <nrb@linux.ibm.com> writes:

> When we have crashes, timeouts or aborts, there is currently no indicatio=
n for
> this in the TAP output.
> When all reports() up to this point succeeded, this
> might result in a TAP file looking completely fine even though things went
> terribly wrong.
>
> For example, when I set the timeout for the diag288 test on s390x to 1 se=
cond,
> it fails because it takes quite long, which is properly indicated in the
> normal output:
>
> $ ./run_tests.sh diag288
> FAIL diag288 (timeout; duration=3D1s)
>
> But, when I enable TAP output, I get this:
>
> $ ./run_tests.sh -t diag288
> TAP version 13
> ok 1 - diag288: diag288: privileged: Program interrupt: expected(2) =3D=
=3D received(2)
> ok 2 - diag288: diag288: specification: uneven: Program interrupt: expect=
ed(6) =3D=3D received(6)
> ok 3 - diag288: diag288: specification: unsupported action: Program inter=
rupt: expected(6) =3D=3D received(6)
> ok 4 - diag288: diag288: specification: unsupported function: Program int=
errupt: expected(6) =3D=3D received(6)
> ok 5 - diag288: diag288: specification: no init: Program interrupt: expec=
ted(6) =3D=3D received(6)
> ok 6 - diag288: diag288: specification: min timer: Program interrupt: exp=
ected(6) =3D=3D received(6)
> 1..6
>
> Which looks like a completely fine TAP file, but actually we ran into a t=
imeout
> and didn't even run all tests.
>
> With this patch, we get an additional line at the end which properly shows
> something went wrong:
>
> not ok 7 - diag288: timeout; duration=3D1s

This results from the fact that the TAP13 test result is generated by
the function `RUNTIME_log_stdout` and not by `print_result` (see commit
6e1d3752d7ca ("tap13: list testcases individually")). In
`RUNTIME_log_stdout` we don=E2=80=99t have access to the QEMU command exit =
code.
So what you=E2=80=99re doing here is to workaround that fact=E2=80=A6 I=E2=
=80=99m not sure how
to fix this properly without refactoring the whole code :/ Maybe Paolo
knows a better fix.

Some small nits below=E2=80=A6 (I don=E2=80=99t make any comments regarding=
 quoting
since it was already suboptimal in the code).

>
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  scripts/runtime.bash | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 6d5fced94246..b41b3d444e27 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -163,9 +163,19 @@ function run()
>          print_result "SKIP" $testname "$summary"
>      elif [ $ret -eq 124 ]; then
>          print_result "FAIL" $testname "" "timeout; duration=3D$timeout"
> +        if [[ $tap_output !=3D "no" ]]; then
> +            echo "not ok TEST_NUMBER - ${testname}: timeout; duration=3D=
$timeout" >&3
> +        fi
>      elif [ $ret -gt 127 ]; then
> -        print_result "FAIL" $testname "" "terminated on SIG$(kill -l $((=
$ret - 128)))"
> +        signame=3D"SIG"$(kill -l $(($ret - 128)))
> +        print_result "FAIL" $testname "" "terminated on $signame"
> +        if [[ $tap_output !=3D "no" ]]; then
> +            echo "not ok TEST_NUMBER - ${testname}: terminated on $signa=
me" >&3
> +        fi
>      else
> +        if [ $ret -eq 127 ] && [[ $tap_output !=3D "no" ]]; then
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
           This is a new case, no? If so please add a separate
           patch creating another `elif` branch.

> +            echo "not ok TEST_NUMBER - ${testname}: aborted" >&3
> +        fi
>          print_result "FAIL" $testname "$summary"
>      fi
>=20=20
> --=20
> 2.31.1

Otherwise, this patch fixes the problem you=E2=80=99ve mentioned - although=
 it
leads to even more fragmented code. But I can't think of a better (easy)
fix right now either.
