Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DAF4DD783
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiCRJ5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiCRJ5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:57:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DC32B3D41
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:56:14 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22I8aUGH002768
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=umoJlNkGKONgabmPJslxv1RvxpbIjTi1I+O7hRURAXc=;
 b=qazqgSMxdlTN7XMflxHbcKq40EgasTYnl4j9oX7Mw3XP1LqHJ3lgKHwm6euz2x9KqFoq
 C0omNXs8OYCDegjUziMJ2WswAkmrqntgA/YkgBcJe4It5OxbXlqWjJJ+wQ9Zk78R/yoa
 0XS3QBHXxF3boENcsdmV8iilNNi4QObNUSJ6KbtN2ACuXpR5ouCFmfFDDlMONrti2NGS
 w7XMjOpFgGzFGu6Hp1V2w5vN2awLsHP+9p1KUk2fVZoH/dJZpwghdce0dfFylLCiMrf0
 TYX53X6vl1OsFPbRLkPUn9QVK/T7Thogd5w22aBjRb7OK49bbtzVaxMUa/ZOvQZfSjSL 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3euv2yyny9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:56:13 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22I9Dalj017028
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:56:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3euv2yynxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 09:56:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22I9rGEO000391;
        Fri, 18 Mar 2022 09:56:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3erk59584m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 09:56:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22I9uADT43647362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 09:56:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE793A405C;
        Fri, 18 Mar 2022 09:56:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F5A4A405F;
        Fri, 18 Mar 2022 09:56:07 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.61.11])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 09:56:07 +0000 (GMT)
Message-ID: <86e8b5d021d5440f75b1635e1f7d2b0e464bd85b.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] runtime: indicate failure on
 crash/timeout/abort in TAP
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, pbonzini@redhat.com
Date:   Fri, 18 Mar 2022 10:56:07 +0100
In-Reply-To: <87bky3veaf.fsf@marcibm.i-did-not-set--mail-host-address--so-tickle-me>
References: <20220310150322.2111128-1-nrb@linux.ibm.com>
         <87bky3veaf.fsf@marcibm.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mPGPcoSHbqaud54I1JLSdzNrpMEhRCCL
X-Proofpoint-ORIG-GUID: mlM00oOA2l5thyttch77OXHAkyH73RZm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_07,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203180051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-18 at 09:46 +0100, Marc Hartmayer wrote:
> Nico Boehr <nrb@linux.ibm.com> writes:
[...]
> > Which looks like a completely fine TAP file, but actually we ran
> > into a timeout
> > and didn't even run all tests.
> > 
> > With this patch, we get an additional line at the end which
> > properly shows
> > something went wrong:
> > 
> > not ok 7 - diag288: timeout; duration=1s
> 
> This results from the fact that the TAP13 test result is generated by
> the function `RUNTIME_log_stdout` and not by `print_result` (see
> commit
> 6e1d3752d7ca ("tap13: list testcases individually")). In
> `RUNTIME_log_stdout` we don’t have access to the QEMU command exit
> code.

Basically yes. If we had that we could do all the TAP special handling
there.
> 

[...]
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 6d5fced94246..b41b3d444e27 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -163,9 +163,19 @@ function run()
> >          print_result "SKIP" $testname "$summary"
> >      elif [ $ret -eq 124 ]; then
> >          print_result "FAIL" $testname "" "timeout;
> > duration=$timeout"
> > +        if [[ $tap_output != "no" ]]; then
> > +            echo "not ok TEST_NUMBER - ${testname}: timeout;
> > duration=$timeout" >&3
> > +        fi
> >      elif [ $ret -gt 127 ]; then
> > -        print_result "FAIL" $testname "" "terminated on SIG$(kill
> > -l $(($ret - 128)))"
> > +        signame="SIG"$(kill -l $(($ret - 128)))
> > +        print_result "FAIL" $testname "" "terminated on $signame"
> > +        if [[ $tap_output != "no" ]]; then
> > +            echo "not ok TEST_NUMBER - ${testname}: terminated on
> > $signame" >&3
> > +        fi
> >      else
> > +        if [ $ret -eq 127 ] && [[ $tap_output != "no" ]]; then
>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>            This is a new case, no? If so please add a separate
>            patch creating another `elif` branch.

Probably depends on what you mean by 'new'. The else branch handles the
test aborting (for example, exception in the guest) _and_ the case of
at least one report failing.

In the latter case, I wanted no additional line in the TAP because we
can already see the failed report there. 

Making the if an elif makes sense, will do that. 

I don't get what you would want to see in a separate patch, can you
please make a pseudocode example?
