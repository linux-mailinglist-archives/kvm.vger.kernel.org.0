Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB9F54837B
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 11:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbiFMJT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 05:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240085AbiFMJT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 05:19:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DDB18E12;
        Mon, 13 Jun 2022 02:19:53 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25D63WT1022905;
        Mon, 13 Jun 2022 09:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=L1rH1OfcRhiRn2UYx/PBGMyvxeJqPnY89HRAMGrWj3A=;
 b=NGFjt1+Bg0PkS4rVwqlhRjp4aOJVIshkDIO4ohBOy0UvtrpIK+b8i3UJSj5XKg19LDc7
 uZq6FajqKsEbNlhcJ+b2YsyzbSBGAtea6BR8CkhpZ9+HiciCslaOP5w606CGxMJuvlv5
 /oNAfS3c1kuC46eUhSx2VznkV5ws3oXqjXvOgELIFDBD+81RBwAFt7EG6H+6gC4dDiq6
 TZ+6KeaINcTRrCQ3kE06ePEie32d1EBzj2vZljUG5tdTpRtpigoloiaCcZO92qXm1VAG
 5UolFpxtYFT4OPrhADnYzAEj4UPDOCxW7j5VrOtOGC/oe+I+HH9egAQVXwRqOjSoBwJN Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn51ev5n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 09:19:53 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25D9Jqht006982;
        Mon, 13 Jun 2022 09:19:52 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn51ev5mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 09:19:52 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25D9Bnvh021822;
        Mon, 13 Jun 2022 09:19:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3gmjp92fft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 09:19:49 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25D9JJBB22806844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 09:19:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF37C4C046;
        Mon, 13 Jun 2022 09:19:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8396A4C040;
        Mon, 13 Jun 2022 09:19:46 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.171.88.29])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 13 Jun 2022 09:19:46 +0000 (GMT)
Date:   Mon, 13 Jun 2022 11:19:44 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 1/1] s390x: add migration test for
 storage keys:q!
Message-ID: <20220613111944.6fd2c4af@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <2fc9f517-57d0-73ae-3083-26e5dcf05dbb@linux.ibm.com>
References: <20220608131328.6519-1-nrb@linux.ibm.com>
        <20220608131328.6519-2-nrb@linux.ibm.com>
        <2fc9f517-57d0-73ae-3083-26e5dcf05dbb@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: feUOZYtZOrdRD9aVxtxBFd903ieg_6mI
X-Proofpoint-ORIG-GUID: 2zNKQlx3Tbj8vVcQ1d5Ffg-qox61pumy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_03,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=940 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jun 2022 10:49:28 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 6/8/22 15:13, Nico Boehr wrote:
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > new file mode 100644
> > index 000000000000..323aa83202bb
[...]
> > +static void test_migration(void)
> > +{
> > +	union skey expected_key, actual_key;
> > +	int i, key_to_set;
> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		/*
> > +		 * Storage keys are 7 bit, lowest bit is always returned as zero
> > +		 * by iske
> > +		 */  
> 
> Maybe add:
> This loop will set all 7 bits which means we set fetch protection as 
> well as reference and change indication for some keys.

OK, done.

> 
> > +		key_to_set = i * 2;
> > +		set_storage_key(pagebuf[i], key_to_set, 1);
> > +	}
> > +
> > +	puts("Please migrate me, then press return\n");
> > +	(void)getchar();
> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		report_prefix_pushf("page %d", i);
> > +
> > +		actual_key.val = get_storage_key(pagebuf[i]);  
> 
> iske is nice but I think it would also be interesting to check if the 
> actual memory protection was carried over. The iske check is enough for 
> now though.

OK, we can add an access check later on if we think it's needed.

> 
> > +		expected_key.val = i * 2;
> > +
> > +		/* ignore reference bit */
> > +		actual_key.str.rf = 0;
> > +		expected_key.str.rf = 0;
> > +
> > +		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);  
> 
> This spams the log with useless information and hence I generally try to 
> avoid printing large loops.
> 
> Instead we should print all fails or a simple success message if all 
> comparisons were successful.

OK will be in the next version.
