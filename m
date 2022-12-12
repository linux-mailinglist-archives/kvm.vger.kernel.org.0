Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F10F64A8CC
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 21:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiLLUhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 15:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiLLUhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 15:37:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2612D19B
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 12:37:36 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCJmb3W013242
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 20:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=qBeh0TimPv+qQUwLwYBwCc4aV6KSDDqrOWCKswCTWVE=;
 b=IT24sFriqdBTaSnVmQyQEGmBdGmekBBx55LMIqMtgFOovhgjjHHDKTOKDGgH4ie2XPeT
 ogjxB+INWBXjqHAm+8XtbcE10D9kNi75Di2o7qWU3ICK/0/tA1V4og98MO2IpzqOxdha
 xCY6bOsOJqMOxu7zaUsbDNSp5rxaqmNItcEc0c5yUu7h6qR8JZfsc2B4sOtTyfzAXPt4
 8o/6Xt3Ogwyifm9wyPKIex+Zdh8tn4uUpbPOXx3ZAy7ISYaKkdcarQ83lCv8w4uJl2ZM
 fDZUsUq5r07fcCczY+beIjmSAjjyiHpLky8kBYC1Mspw9BlJL2kjisQG5N0i7g786Jy8 Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3me7rvdwj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 20:37:35 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BCKY5DP001967
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 20:37:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3me7rvdwhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 20:37:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCBFlDH029603;
        Mon, 12 Dec 2022 20:37:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mchr629q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 20:37:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BCKbTcm15925604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 20:37:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3226C20049;
        Mon, 12 Dec 2022 20:37:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3D2A20043;
        Mon, 12 Dec 2022 20:37:28 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.179.1.26])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 20:37:28 +0000 (GMT)
Message-ID: <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey
 migration test
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Mon, 12 Dec 2022 21:37:28 +0100
In-Reply-To: <20221209102122.447324-2-nrb@linux.ibm.com>
References: <20221209102122.447324-1-nrb@linux.ibm.com>
         <20221209102122.447324-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F9EKuo3_Y2wF6x19Dc-C3xVeYIZD4guI
X-Proofpoint-ORIG-GUID: uBKOJ4KLMDuJAIBrCEFpaOiRH4skSs8i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 mlxlogscore=999 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212120181
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote:
> Right now, we have a test which sets storage keys, then migrates the VM
> and - after migration finished - verifies the skeys are still there.
>=20
> Add a new version of the test which changes storage keys while the
> migration is in progress. This is achieved by adding a command line
> argument to the existing migration-skey test.
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++------
>  s390x/unittests.cfg    |  15 ++-
>  2 files changed, 198 insertions(+), 31 deletions(-)
>=20
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> index b7bd82581abe..9b9a45f4ad3b 100644
> --- a/s390x/migration-skey.c
> +++ b/s390x/migration-skey.c
>=20
[...]

> +static void test_skey_migration_parallel(void)
> +{
> +	report_prefix_push("parallel");
> +
> +	if (smp_query_num_cpus() =3D=3D 1) {
> +		report_skip("need at least 2 cpus for this test");
> +		goto error;
> +	}
> +
> +	smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
> +
> +	migrate_once();
> +
> +	WRITE_ONCE(thread_should_exit, 1);
> +
> +	while (!thread_exited)
> +		mb();

Are you doing it this way instead of while(!READ_ONCE(thread_exited)); so t=
he mb() does double duty
and ensures "result" is also read from memory a couple of lines down?
If so, I wonder if the compiler is allowed to arrange the control flow such=
 that if the loop condition
is false on the first iteration it uses a cached value of "result" (I'd be =
guessing yes, but what do I know).
In any case using a do while loop instead would eliminate the question.
A comment might be nice, too.

> +
> +	report_info("thread completed %u iterations", thread_iters);
> +
> +	report_prefix_push("during migration");
> +	skey_report_verify(&result);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Verification of skeys occurs on the thread. We don't know if we
> +	 * were still migrating during the verification.
> +	 * To be sure, make another verification round after the migration
> +	 * finished to catch skeys which might not have been migrated
> +	 * correctly.
> +	 */
> +	report_prefix_push("after migration");
> +	assert(thread_iters > 0);
> +	result =3D skey_verify_test_pattern(pagebuf, NUM_PAGES, thread_iters - =
1);
> +	skey_report_verify(&result);
> +	report_prefix_pop();
> +
> +error:
> +	report_prefix_pop();
> +}
> +
[...]
