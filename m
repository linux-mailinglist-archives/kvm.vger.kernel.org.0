Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B227D59E6A9
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 18:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244308AbiHWQLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 12:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244250AbiHWQLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 12:11:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A0EFFF48;
        Tue, 23 Aug 2022 05:30:48 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NBPjfp019394;
        Tue, 23 Aug 2022 11:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=R+CqFLYVJqrurl73kOAfzCmdb5kQdBAjrWzu4M9MMnA=;
 b=MHPdM7ungOqgo8h0gNvVXz8t3eUqENbqZLF3xCK1VRaYw5kdm37yz/M630QTuZuT4Slp
 iaFSVmp4ybe4AYT8ELqEScxJEimxYQJJPwjkz+gfEMJD83HP+hnMYPPU+TE63oN3fwmu
 ZTMvyeQSmppW7TxehCvRebgTtHz/rpDDW4iUN8/8+ArBVUJzZZgc88kvGpQKuNBfa8nI
 4yQewsbp11Tfu8P8q4NOtcaNGYa93q10NVaZKrgL02d9J6jwPKy/fzisaiGGRO8DsL9J
 0BSL0Gypx1OJ5qAyDEfW5dLydHxTMAzDD/q82SO+5Wi5wJ0NUBumlUQnbteFsHT337It dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4x0w0rhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 11:54:28 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NBQQZh020876;
        Tue, 23 Aug 2022 11:54:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4x0w0rg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 11:54:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NBpCIV010203;
        Tue, 23 Aug 2022 11:54:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3j2q88tqm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 11:54:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NBsglc31981936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 11:54:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3846F42041;
        Tue, 23 Aug 2022 11:54:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C17A64203F;
        Tue, 23 Aug 2022 11:54:21 +0000 (GMT)
Received: from oc-nschnelle.boeblingen.de.ibm.com (unknown [9.155.199.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 11:54:21 +0000 (GMT)
Message-ID: <62420273c48f2edecf12ec8784ef03adadea2a4b.camel@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, alex.williamson@redhat.com, cohuck@redhat.com
Date:   Tue, 23 Aug 2022 13:54:21 +0200
In-Reply-To: <6d11d3b5-a313-8e2b-2f38-44c5a4a63a28@linux.ibm.com>
References: <20220819122945.9309-1-pmorel@linux.ibm.com>
         <6d11d3b5-a313-8e2b-2f38-44c5a4a63a28@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ayEz9EVTrAievka9n9TQSWhAN9zWq_-K
X-Proofpoint-ORIG-GUID: Z8IzRk8T2i07unRaT4MaxrE8cgm63uop
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxlogscore=890 bulkscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-23 at 09:25 +0200, Janosch Frank wrote:
> On 8/19/22 14:29, Pierre Morel wrote:
> > We have a cross dependency between KVM and VFIO when using
> > s390 vfio_pci_zdev extensions for PCI passthrough
> > To be able to keep both subsystem modular we add a registering
> > hook inside the S390 core code.
> > 
> > This fixes a build problem when VFIO is built-in and KVM is built
> > as a module.
> > 
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop interpretive execution")
> > Cc: <stable@vger.kernel.org>
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
> @Niklas @Matt: Since the patches that introduced the PCI interpretation 
> went via the KVM tree I'll also move this patch via the KVM tree.

Sounds good, thanks.

