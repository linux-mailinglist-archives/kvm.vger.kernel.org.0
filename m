Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC54D0304
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbiCGPfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbiCGPfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:35:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7F75D5E6;
        Mon,  7 Mar 2022 07:34:48 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227EGe7L028883;
        Mon, 7 Mar 2022 15:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YbI0+Spy3O3UqSOKx06fTvqU5hrwohK5X5oTqFcy9ws=;
 b=SPoIx/I1Cyvb5wk3+Xdommpf7SPs9qDPdMV2/uEtDM+0SAucHm+kZSpQwwas2o/HlPNg
 e1LAQuSJu47wZV7GvRdSCGOEBYbwAahaCeFMut+0ob7YbaJREsqjt917aqJnZfn0mYwC
 VDXimPXd1ySo1adVdnST4rVfMONzdSnSRP5jGz4N0w616tWvnWYfxdW6UQCITKOOSecO
 rE0QCROQ9rgcrJpRekgo4+A7Hc5tbUfGGSlIRzazBf7207l6xwK9CTFWzPR74wKwHvy8
 cypHs50bIM7+gTCQ6RO0nY4B/FVFJei4Lhb7YH8+TdGYjc0Lvq+xyoV0gzS5JFkSRfPL mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3emhdrpfqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:48 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227DkjV6004749;
        Mon, 7 Mar 2022 15:34:47 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3emhdrpfpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:47 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227FIrH1016781;
        Mon, 7 Mar 2022 15:34:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ekyg94b0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:45 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227FYgYO47645030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 15:34:42 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E57CDA4054;
        Mon,  7 Mar 2022 15:34:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C670A405B;
        Mon,  7 Mar 2022 15:34:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 15:34:41 +0000 (GMT)
Date:   Mon, 7 Mar 2022 16:30:07 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
Message-ID: <20220307163007.0213714e@p-imbrenda>
In-Reply-To: <20220303210425.1693486-5-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
        <20220303210425.1693486-5-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SUPczq4PzCmfzid63Hwi0mCdPGfWKxhV
X-Proofpoint-GUID: XQDIEqL8d8S-gBlcXJ6PnFXGhyOrAhZ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Mar 2022 22:04:23 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> When stopping a CPU, kvm-unit-tests serializes/waits for everything
> to finish, in order to get a consistent result whenever those
> functions are used.
> 
> But to test the SIGP STOP itself, these additional measures could
> mask other problems. For example, did the STOP work, or is the CPU
> still operating?
> 
> Let's create a non-waiting SIGP STOP and use it here, to ensure that
> the CPU is correctly stopped. A smp_cpu_stopped() call will still
> be used to see that the SIGP STOP has been processed, and the state
> of the CPU can be used to determine whether the test passes/fails.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  lib/s390x/smp.c | 25 +++++++++++++++++++++++++
>  lib/s390x/smp.h |  1 +
>  s390x/smp.c     | 10 ++--------
>  3 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 368d6add..84e536e8 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -119,6 +119,31 @@ int smp_cpu_stop(uint16_t idx)
>  	return rc;
>  }
>  
> +/*
> + * Functionally equivalent to smp_cpu_stop(), but without the
> + * elements that wait/serialize matters itself.
> + * Used to see if KVM itself is serialized correctly.
> + */
> +int smp_cpu_stop_nowait(uint16_t idx)
> +{
> +	/* refuse to work on the boot CPU */
> +	if (idx == 0)
> +		return -1;
> +
> +	spin_lock(&lock);
> +
> +	/* Don't suppress a CC2 with sigp_retry() */
> +	if (smp_sigp(idx, SIGP_STOP, 0, NULL)) {
> +		spin_unlock(&lock);
> +		return -1;
> +	}
> +
> +	cpus[idx].active = false;
> +	spin_unlock(&lock);
> +
> +	return 0;
> +}
> +
>  int smp_cpu_stop_store_status(uint16_t idx)
>  {
>  	int rc;
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index 1e69a7de..bae03dfd 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -44,6 +44,7 @@ bool smp_sense_running_status(uint16_t idx);
>  int smp_cpu_restart(uint16_t idx);
>  int smp_cpu_start(uint16_t idx, struct psw psw);
>  int smp_cpu_stop(uint16_t idx);
> +int smp_cpu_stop_nowait(uint16_t idx);
>  int smp_cpu_stop_store_status(uint16_t idx);
>  int smp_cpu_destroy(uint16_t idx);
>  int smp_cpu_setup(uint16_t idx, struct psw psw);
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 50811bd0..11c2c673 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -76,14 +76,8 @@ static void test_restart(void)
>  
>  static void test_stop(void)
>  {
> -	smp_cpu_stop(1);
> -	/*
> -	 * The smp library waits for the CPU to shut down, but let's
> -	 * also do it here, so we don't rely on the library
> -	 * implementation
> -	 */
> -	while (!smp_cpu_stopped(1)) {}
> -	report_pass("stop");
> +	smp_cpu_stop_nowait(1);

can it happen that the SIGP STOP order is accepted, but the target CPU
is still running (and not even busy)?

> +	report(smp_cpu_stopped(1), "stop");

e.g. can this ^ check race with the actual stopping of the CPU?

>  }
>  
>  static void test_stop_store_status(void)

