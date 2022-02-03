Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4682A4A854D
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244416AbiBCNeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 08:34:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232242AbiBCNeC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 08:34:02 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213DJhtK012904
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 13:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0IdcQWeK2XaUkP4GQZhyI/iMsuCUyZZkVbCKkW88VL0=;
 b=CLdcs5Z0oUuxdyZpYzuQIOd9DlR+NO6ueftDEvRMk2yhXZB1jurgSB0cu52ZbtR9e2Tc
 84Gc4O6sPRkBZ54YdZPIUEB7MgHwynI8qvt0TZx+kHFN4rG9sq/WDnOhe8PsU3b/h7Hx
 FR6CnVWBc1ZghcCuCqMhUnHOv9GCHss/ui76A5F4psgjw7ExF94VmGcQqJ3MpLdvTLzA
 LEYF2KzwLWIMC8vnZHGAGpGH0mKKEviGRUnTSkkFgh7yrZMQt3l+6R3eXr8VUfEsbwhy
 k6fZwsg9g/T8rrQHkBe6zODsKDWPa9e0YZ8nCjH6KG01jLkI1soPybmO5flaKodG7nDd 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e09h08hh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 13:34:01 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213DI0fP025668
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 13:34:01 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e09h08hg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 13:34:01 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213DWjM2025970;
        Thu, 3 Feb 2022 13:33:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3dvw7a4h44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 13:33:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213DXrTV29032734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 13:33:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C674A404D;
        Thu,  3 Feb 2022 13:33:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE59EA4040;
        Thu,  3 Feb 2022 13:33:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 13:33:52 +0000 (GMT)
Date:   Thu, 3 Feb 2022 14:33:51 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/5] lib: s390x: smp: add functions to
 work with CPU indexes
Message-ID: <20220203143351.2c4d8225@p-imbrenda>
In-Reply-To: <defe074e-0215-cb9a-39e7-cc4dcbf75785@redhat.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
        <20220128185449.64936-2-imbrenda@linux.ibm.com>
        <defe074e-0215-cb9a-39e7-cc4dcbf75785@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ynqwsf8GB6yYlGYM2VmmT8ZVOeBQ5HiM
X-Proofpoint-GUID: J-ejq3tEsE7cqUPORCKD-5HgSh05e74U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 31 Jan 2022 14:50:37 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 28.01.22 19:54, Claudio Imbrenda wrote:
> > Knowing the number of active CPUs is not enough to know which ones are
> > active. This patch adds 2 new functions:
> > 
> > * smp_cpu_addr_from_idx to get the CPU address from the index
> > * smp_cpu_from_idx allows to retrieve the struct cpu from the index
> > 
> > This makes it possible for tests to avoid hardcoding the CPU addresses.
> > It is useful in cases where the address and the index might not match.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  lib/s390x/smp.h |  2 ++
> >  lib/s390x/smp.c | 12 ++++++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> > index a2609f11..69aa4003 100644
> > --- a/lib/s390x/smp.h
> > +++ b/lib/s390x/smp.h
> > @@ -37,6 +37,7 @@ struct cpu_status {
> >  
> >  int smp_query_num_cpus(void);
> >  struct cpu *smp_cpu_from_addr(uint16_t addr);
> > +struct cpu *smp_cpu_from_idx(uint16_t addr);  
> 
> s/addr/idx/
> 
> 

oops!

will fix
