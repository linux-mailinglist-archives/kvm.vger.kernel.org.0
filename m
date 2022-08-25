Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D2F5A1982
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbiHYT1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiHYT1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:27:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6E8BD4D7;
        Thu, 25 Aug 2022 12:27:33 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PJQ6CR000945;
        Thu, 25 Aug 2022 19:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=FRf9fy5opzo2bmw8fuO4rezVPx48dGCN82j1Syr0JiE=;
 b=PN9AFXaoWRmnfACOfyM7emO34xdYUf7MHqZIo0NKcRaV8DFvOY34wmzC4OBJuVFQheYU
 vrQwVhTsLHLCcZsnBbsRwsa5wbolcn0T3b4OY7PHPP65/CzOT+UH+VM5Vo6D5XipM3fz
 A7LKk7Vxbr4cN92lZybmPZvMjRMpIX9RXqv+JZkyA11gTcvQ8amnxPecDGwncHXjv8Ic
 1UdJvGHpm3GZml1ywRiQusRw22UpWsX8cZ3e1aiKSbcBWS5Lkh90jfRyt5E6JnlwzdHw
 fmHlEIK9f43kqKhtMZA2vslfYaZ6X9rqkJQx7D4t45ff7O+dmTK+o2+Xuq22lcmkRs+e sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6f8301c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 19:27:30 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PJQDRa001823;
        Thu, 25 Aug 2022 19:27:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6f8301b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 19:27:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PJPCiV015250;
        Thu, 25 Aug 2022 19:27:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88xstn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 19:27:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PJRObR41157110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 19:27:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAAF642041;
        Thu, 25 Aug 2022 19:27:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56FD14204B;
        Thu, 25 Aug 2022 19:27:24 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.4.237])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Aug 2022 19:27:24 +0000 (GMT)
Message-ID: <923f4d1b576295ea738df052543e4ca0be2ea616.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: Pass initialized arg even if unused
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 25 Aug 2022 21:27:24 +0200
In-Reply-To: <YwczITkxvvghyvWq@osiris>
References: <20220824153011.4004573-1-scgl@linux.ibm.com>
         <YwczITkxvvghyvWq@osiris>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tcW6MmkbDjwgSkGzVpD0ojfdBvOUDHQd
X-Proofpoint-GUID: O2uiKcuOZqQToS6egsd_jgehDkkQJ_ER
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-08-25 at 10:30 +0200, Heiko Carstens wrote:
> On Wed, Aug 24, 2022 at 05:30:11PM +0200, Janis Schoetterl-Glausch wrote:
> > This silences smatch warnings reported by kbuild bot:
> > arch/s390/kvm/gaccess.c:859 guest_range_to_gpas() error: uninitialized symbol 'prot'.
> > arch/s390/kvm/gaccess.c:1064 access_guest_with_key() error: uninitialized symbol 'prot'.
> > 
> > This is because it cannot tell that the value is not used in this case.
> > The trans_exc* only examine prot if code is PGM_PROTECTION.
> > Pass a dummy value for other codes.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > ---
> >  arch/s390/kvm/gaccess.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)

[...]

> >  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> > -			if (kvm_is_error_gpa(vcpu->kvm, gpa))
> > +			if (kvm_is_error_gpa(vcpu->kvm, gpa)) {
> >  				rc = PGM_ADDRESSING;
> > +				prot = PROT_NONE;
> > +			}
> ...
> > +		if (rc == PGM_PROTECTION)
> > +			prot = PROT_TYPE_KEYC;
> > +		else
> > +			prot = PROT_NONE;
> 
> For both cases I would suggest to preinitialize prot with PROT_NONE in
> order to keep the code smaller - but not my call.

I chose this to make it really obvious that PROT_NONE is used only in
cases where code != PGM_PROTECTION.
