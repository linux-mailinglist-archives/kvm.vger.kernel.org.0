Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A25638BD1
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiKYOF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKYOFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:05:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDD21E3CC
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:05:54 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APDuTAb028785
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=L3s8Y3DfM+80FFI18A66TdaX7PlrEIo95C3i69B6PGE=;
 b=NMJ6fmqVhc677Kqr83i8+5eAoOLFq/vFCrRD5SxbT1ZCGzJyhDH36f1uChy3r5Gfas17
 ohSC5Pver/PCQNTeeT3eMWYsMnsIN3WT0hRY5HavT6WTAjq0SGbvC+kL0szDiLNQPf18
 yzECwM0OlTRRyBbVIEu3zMDqigPsXkW/d0LJ4kOOotpU0NG9w8PmfIY93M/HPEq6x/Hx
 k5C8XUfSmfeOfb9tkndehGwuR6Xu8q3soMegcUw55bW+0ZP+86sWBo59Uy091t+KhI+o
 bNDaiCz6Ue1uelMMCv9b9X/gNVVXftRkJ3BaYl3HM37R/Mf8r1Z3tpibL6r55vFvSvyH tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2ver4205-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:05:53 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APE4rog024318
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 14:05:53 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2ver41ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 14:05:53 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APE5ZBd031720;
        Fri, 25 Nov 2022 14:05:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8xypm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 14:05:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APE5ki73277514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 14:05:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB7F7AE051;
        Fri, 25 Nov 2022 14:05:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78B9DAE04D;
        Fri, 25 Nov 2022 14:05:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.0.125])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 25 Nov 2022 14:05:46 +0000 (GMT)
Date:   Fri, 25 Nov 2022 15:05:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add CMM test during
 migration
Message-ID: <20221125150539.6b59a63b@p-imbrenda>
In-Reply-To: <8829c1f2-46cd-12b7-5939-48a1866ed001@redhat.com>
References: <20221124134429.612467-1-nrb@linux.ibm.com>
        <20221124134429.612467-3-nrb@linux.ibm.com>
        <8829c1f2-46cd-12b7-5939-48a1866ed001@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o-1gqjAXSmSQBa7zrY8x4s1UsTVEMgFp
X-Proofpoint-ORIG-GUID: PMa143V-K1HYv-2hCBBzJA1_lRcts3Ma
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_06,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=924 mlxscore=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Nov 2022 14:58:35 +0100
Thomas Huth <thuth@redhat.com> wrote:

[...]

> > +	/*
> > +	 * If we just exit and don't ask migrate_cmd to migrate us, it
> > +	 * will just hang forever. Hence, also ask for migration when we
> > +	 * skip this test alltogether.  
> 
> s/alltogether/all together/

nope, it's "altogether"
