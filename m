Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C10599B4F
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348673AbiHSLtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348061AbiHSLtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:49:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E112BE86B3;
        Fri, 19 Aug 2022 04:49:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JBNqXv027771;
        Fri, 19 Aug 2022 11:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=eMYxvmLsm5iUEOW6SBmPUb7Z+2GvFGXcg+1PfhEYPkg=;
 b=i4ACEMZQ0aKj2CEuprWNtZAiP2N4QjeWrC5z3THOqv9mo8Jhm/sV5AzZn5Fx2xOy/YsI
 RzJoh43Uq5We7g303KX+W07of2sAkYUkwlCLz8Adem8dgyXdvYIMLzeFDxpPRziYytQ4
 orJ3BURZmgGHjkeNey9YbSrH45cTKZcA/b2mvLZpV8Va+TfofeXusN/G6ErY/b1dWZCP
 DtLG2GM1nkUVbANZH96Ys7GgCVAsj3MxONCxgEUi7LUAjW+EmmRokGPC25RyzSR+m8g3
 lWHK1yraVSczoXquHTx+lMPHoUFjPkA0kagy1L/ao0bATLilwQG64/yAHzk1svCzAtkM FQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j29m1ghqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 11:49:35 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27JBLEus029171;
        Fri, 19 Aug 2022 11:49:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3hyp8skttd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 11:49:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27JBnUpU33423776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 11:49:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D24C42041;
        Fri, 19 Aug 2022 11:49:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADD154203F;
        Fri, 19 Aug 2022 11:49:29 +0000 (GMT)
Received: from sig-9-145-84-131.uk.ibm.com (unknown [9.145.84.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 11:49:29 +0000 (GMT)
Message-ID: <5c06e9dae0848e21168a70183f2cfa4e55793586.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, mjrosato@linux.ibm.com
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, frankja@linux.ibm.com
Date:   Fri, 19 Aug 2022 13:49:29 +0200
In-Reply-To: <b22977d5-6df7-13e0-802f-6201e6445d72@linux.ibm.com>
References: <20220818164652.269336-1-pmorel@linux.ibm.com>
         <2ae0bf9abffe2eb3eb2fb3f84873720d39f73d4d.camel@linux.ibm.com>
         <0d7d055d-f323-acba-cb79-f859b5e182b4@linux.ibm.com>
         <ae19135f580e1f510e99d1567514cc2dfe3571be.camel@linux.ibm.com>
         <b22977d5-6df7-13e0-802f-6201e6445d72@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AyeLoIx0s6d3qrs920OQHpAddIe_F9GL
X-Proofpoint-ORIG-GUID: AyeLoIx0s6d3qrs920OQHpAddIe_F9GL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 mlxscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

---8<---
> > > > > diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> > > > > index bf557a1b789c..c02dbfb415d9 100644
> > > > > --- a/arch/s390/pci/Makefile
> > > > > +++ b/arch/s390/pci/Makefile
> > > > > @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
> > > > >    			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
> > > > >    			   pci_bus.o
> > > > >    obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
> > > > > +
> > > > > +obj-y += pci_kvm_hook.o
> > > > 
> > > > I thought we wanted to compile this only for CONFIG_PCI?
> > > 
> > > Ah sorry, that is indeed what I understood with Matt but then I
> > > misunderstood your own answer from yesterday.
> > > I change to
> > > obj-$(CONFIG_PCI) += pci_kvm_hook.o
> > > 
> > > > > diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
> > > > > new file mode 100644
> > > > > index 000000000000..ff34baf50a3e
> > > > ---8<---
> > > > 
> > 
> > Ok with the two things above plus the comment by Matt incorporated:
> > 
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > 
> 
> Just a little correction, it changes nothing if the pci_kvm_hook.c goes 
> on same lines as other CONFIG_PCI depending files.
> So I put it on the same line.
> 
> Thanks
> 
> Pierre
> 

Of course yes. Thanks for fixing this and I'm assuming this would
either go through the KVM or vfio trees, correct?

