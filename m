Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25AC5F9E92
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiJJMPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiJJMPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:15:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9A745F70;
        Mon, 10 Oct 2022 05:15:20 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AAo99s007555;
        Mon, 10 Oct 2022 12:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Reky3j3CZB2fE6wnJu5qdhlJ6cBXLTGKSGwYq1g9QKo=;
 b=HoY00ypUguZx4VxqMUk85S7/Om8UEvIrfVvkftB+6DBx2c0zBag8AcSO8/mQEQ6QC8wW
 +4OvJNJ017pv3lbPBRmJWt3ZBV5/UfLNCfHtzjT2VAId5P3lgzyo3dmObvQVSNZVUp+u
 2s3vOb0V22PQDLsSXxQ/zCN0CB2UwhZh3IIBUMaDi/Ypn2TItgBDLth08SPVE26CKsdL
 HGi6RvOnu6SQrgMEUdGSMmo2vxHikpTURV6rQlnXg7MB9KRAeaCaWKVGB2UTm670Bbt1
 hwSr67rtxUv4rX+k+bz4aAPqjcj7h5Qbi2Wt4SelJUfxOLBW0/BcdAnWgt+aTx4BasPL qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jhbbgnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 12:15:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29ABvOGS019911;
        Mon, 10 Oct 2022 12:15:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k3jhbbgmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 12:15:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29AC5d8g003192;
        Mon, 10 Oct 2022 12:15:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3k30u9a1cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Oct 2022 12:15:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29ACFiRB51904852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 12:15:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C01D3A4054;
        Mon, 10 Oct 2022 12:15:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60802A405C;
        Mon, 10 Oct 2022 12:15:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Oct 2022 12:15:13 +0000 (GMT)
Date:   Mon, 10 Oct 2022 14:15:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v14 3/6] KVM: s390: pv: add
 KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
Message-ID: <20221010141511.25eca963@p-imbrenda>
In-Reply-To: <748d07b8-1746-c12a-ccfb-89c8b15901d9@linux.ibm.com>
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
        <20220930140150.37463-4-imbrenda@linux.ibm.com>
        <748d07b8-1746-c12a-ccfb-89c8b15901d9@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EMcjSMIDhU5XE7nm4uDQrItG0pjcFef2
X-Proofpoint-ORIG-GUID: zYQm4HhJ9CiZlwR3fVXdm4qt5BpMYaKy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_06,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Oct 2022 13:45:54 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 9/30/22 16:01, Claudio Imbrenda wrote:
> > Add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE to signal that the
> > KVM_PV_ASYNC_DISABLE and KVM_PV_ASYNC_DISABLE_PREPARE commands for the
> > KVM_S390_PV_COMMAND ioctl are available.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   arch/s390/kvm/kvm-s390.c | 3 +++
> >   include/uapi/linux/kvm.h | 1 +
> >   2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index d0027964a6f5..7a3bd68efd85 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -618,6 +618,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   	case KVM_CAP_S390_BPB:
> >   		r = test_facility(82);
> >   		break;
> > +	case KVM_CAP_S390_PROTECTED_ASYNC_DISABLE:
> > +		r = async_destroy && is_prot_virt_host();
> > +		break;
> >   	case KVM_CAP_S390_PROTECTED:
> >   		r = is_prot_virt_host();
> >   		break;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 02602c5c1975..9afe0084b2c5 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
> >   #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
> >   #define KVM_CAP_S390_ZPCI_OP 221
> >   #define KVM_CAP_S390_CPU_TOPOLOGY 222
> > +#define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 225  
> 
> I can see 223 in Paolo's next, is there a 224 that I've missed?

no, I set this to an arbitrarily high value to avoid conficts

seems like I got it more or less right :)

feel free to change the value of the macro when merging, so it's
contiguous.

> 
> 
> >   
> >   #ifdef KVM_CAP_IRQ_ROUTING
> >     
> 

