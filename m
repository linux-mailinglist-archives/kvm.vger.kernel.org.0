Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61633645D22
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiLGPBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLGPAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:00:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C391663DF;
        Wed,  7 Dec 2022 06:59:17 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7Di8q5028746;
        Wed, 7 Dec 2022 14:59:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=38TkxpuCDc1rkg9BpED5d/5JYbHeOXmRvwygUYJ4Kqw=;
 b=RkL2Mh/7F/o7YKyQT1fIbuTH9/FH1BtSZTrUaIe9lSQBiWaKu6cqt4hfgyk2zs4AgV1y
 snolnoFws5bC+uzXeFdwuSgmQlY5jtyBdYs2iFJ9CkVYURfSXrFa9d1hgFN3s741cOhg
 A4GWlPy8Z2SsIuQa6879vGa3J2VP/5duwt8NaxbAjllnHfpK1u1P2zAujbwNMmH/CDQH
 FoJJEbyJLzvlyuT3x6YfHvvyi3EEtpBIM7nQGRycNO19+6POyUHE9NJLIPFw5woLYLTV
 jzxT8Zd4m7vBfGZbEbmc9il7Cr/6sFn/RIst08Zri9GyUBkS/bK5bKoGi6uRFjzUD2Iz aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mauyht7px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 14:59:16 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B7EAfPj006713;
        Wed, 7 Dec 2022 14:59:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mauyht7p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 14:59:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7CAZx6010873;
        Wed, 7 Dec 2022 14:59:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3m9kvbb3hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 14:59:13 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B7ExBIx42729780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Dec 2022 14:59:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 676D82004B;
        Wed,  7 Dec 2022 14:59:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 420DB20043;
        Wed,  7 Dec 2022 14:59:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Dec 2022 14:59:11 +0000 (GMT)
Date:   Wed, 7 Dec 2022 15:59:09 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: sie: Test whether the epoch
 extension field is working as expected
Message-ID: <20221207155909.6a3271f7@p-imbrenda>
In-Reply-To: <20221207133118.70746-1-thuth@redhat.com>
References: <20221207133118.70746-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p24tt_fyjWuXTBBWW4q3eRayG7NbLgMO
X-Proofpoint-GUID: zmwEw-5QRQB_Tj_fLFjy4BJy28-h91ZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_05,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212070122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Dec 2022 14:31:18 +0100
Thomas Huth <thuth@redhat.com> wrote:

> We recently discovered a bug with the time management in nested scenarios
> which got fixed by kernel commit "KVM: s390: vsie: Fix the initialization
> of the epoch extension (epdx) field". This adds a simple test for this
> bug so that it is easier to decide whether the host kernel of a machine

s/decide/determine/

> has already been fixed or not.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/sie.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/s390x/sie.c b/s390x/sie.c
> index 87575b29..7ec4b030 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -58,6 +58,33 @@ static void test_diags(void)
>  	}
>  }
>  
> +static void test_epoch_ext(void)
> +{
> +	u32 instr[] = {
> +		0xb2780000,	/* STCKE 0 */
> +		0x83020044	/* DIAG 0x44 to intercept */

I'm conflicted about this. one one hand, it should be 0x83000044, but
on the other hand it does not matter at all, and the other testcase
also has the spurious 2 in the middle (to check things we are not
checking here)

> +	};
> +
> +	if (!test_facility(139)) {
> +		report_skip("epdx: Multiple Epoch Facility is not available");
> +		return;
> +	}
> +
> +	guest[0] = 0x00;
> +	memcpy(guest_instr, instr, sizeof(instr));
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = PSW_MASK_64;
> +
> +	vm.sblk->ecd |= ECD_MEF;
> +	vm.sblk->epdx = 0x47;	/* Setting the epoch extension here ... */
> +
> +	sie(&vm);
> +
> +	/* ... should result in the same epoch extension here: */
> +	report(guest[0] == 0x47, "epdx: different epoch is visible in the guest");
> +}
> +
>  static void setup_guest(void)
>  {
>  	setup_vm();
> @@ -80,6 +107,7 @@ int main(void)
>  
>  	setup_guest();
>  	test_diags();
> +	test_epoch_ext();
>  	sie_guest_destroy(&vm);
>  
>  done:

