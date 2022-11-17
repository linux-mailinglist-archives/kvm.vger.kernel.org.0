Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF3462D7AA
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 11:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiKQKCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 05:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiKQKCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 05:02:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E814C389B;
        Thu, 17 Nov 2022 02:02:50 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHA0esf029082;
        Thu, 17 Nov 2022 10:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dN57SuLEydviquPBemJzc7K+HvoVyGQNNX5axWPmy0I=;
 b=ZbNEQSG6mS1l4X8BRkoSSWeTzN9keZ/NQv787RS3LFKwRL6f5BusBtniaRUmrX7qWMmB
 Y8cmKydUJj47oAOiwgGoD7GVIXNDvFseXSAdxZI+Ml+74pYIjovuDRTSzUVnv3fI+Ex9
 mITx9PoFKJv6RaIczvuD1q861aArkED4/ovhhazqoUjvzz6C28ncydkctV3wwb5bSiEY
 GJvPRNA0WFJvaPrTkmJicNu2896N/VHeDurNGFetwREoZ76LO53yRxf9WncrttjoZaBI
 wIHtN1US7W+UTMTQk8cc6QVtA/F7iTRKOj23kIpQ2VL0cBK3JJEfZP2+qdN8X+2TYinD Nw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kwjtwg6tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 10:02:48 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AH9r2Wb031391;
        Thu, 17 Nov 2022 10:01:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3kt2rjfb76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 10:01:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AHA1kO529557124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 10:01:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02E0742042;
        Thu, 17 Nov 2022 10:01:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD6BF4203F;
        Thu, 17 Nov 2022 10:01:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Nov 2022 10:01:45 +0000 (GMT)
Date:   Thu, 17 Nov 2022 11:01:43 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v1] s390/vfio-ap: GISA: sort out physical vs virtual
 pointers usage
Message-ID: <20221117110143.6892e7e8@p-imbrenda>
In-Reply-To: <166867501356.12564.3855578681315731621@t14-nrb.local>
References: <20221108152610.735205-1-nrb@linux.ibm.com>
        <659501fc-0ddc-2db6-cdcb-4990d5c46817@linux.ibm.com>
        <166867501356.12564.3855578681315731621@t14-nrb.local>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bIQlYfkO39qddXBOqiltyG92_mpxnZpi
X-Proofpoint-ORIG-GUID: bIQlYfkO39qddXBOqiltyG92_mpxnZpi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_05,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Nov 2022 09:50:14 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Janosch Frank (2022-11-15 09:56:52)
> > On 11/8/22 16:26, Nico Boehr wrote:  
> > > Fix virtual vs physical address confusion (which currently are the same)
> > > for the GISA when enabling the IRQ.
> > > 
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > ---
> > >   drivers/s390/crypto/vfio_ap_ops.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > > index 0b4cc8c597ae..20859cabbced 100644
> > > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > > @@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
> > >   
> > >       aqic_gisa.isc = nisc;
> > >       aqic_gisa.ir = 1;
> > > -     aqic_gisa.gisa = (uint64_t)gisa >> 4;
> > > +     aqic_gisa.gisa = (uint64_t)virt_to_phys(gisa) >> 4;  
> > 
> > I'd suggest doing s/uint64_t/u64/ or s/uint64_t/unsigned long/ but I'm 
> > wondering if (u32)(u64) would be more appropriate anyway.  
> 
> The gisa origin is a unsigned int, hence you are right, uint64_t is odd. But since virt_to_phys() returns unsigned long, the cast to uint64_t is now useless.
> 
> My suggestion is to remove the cast alltogether.

I agree to remove it
