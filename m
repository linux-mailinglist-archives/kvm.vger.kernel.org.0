Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED77053798D
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiE3LGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 07:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiE3LGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 07:06:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A7855483;
        Mon, 30 May 2022 04:06:31 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U91UOw026575;
        Mon, 30 May 2022 11:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=wK6/q36Gb8XJZO9BQ/uI6Vo7ghIK6y7J+vH6fv00uZI=;
 b=qWQjS4onfIvfEI+7GG+3Eik2am6ikgdxgtm/N7poDWQTsm20HkdbjWzbIYmsEPc9ae9A
 nGz9L2rOwPLNNFxWh3wvYtyb4FVvc8kOD5AF1rcIeivZg7d9h0o5cbdKrlHL5Qs4HRUO
 twoVaV3xAIBwCXPu0iGLPO4fb44PB66PdIRyipmc+nnD1Kw5Dfwu9hL3bYzRLe6caBuG
 iqtz4HkimRnJSmuYhL+z7kWAHlvv0WfdWBD8IdgkuV+cyeh7ZPrhh21ZzKVbzk0YlRZu
 YmCRQcn1GmbIteOV8sp1955BnsV3oByefsH5C+NfuoeoOWhHZ/w8rNXUraRgGJD7Dx7n hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcrgpw8mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 11:06:30 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UAlVuQ006005;
        Mon, 30 May 2022 11:06:29 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcrgpw8kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 11:06:29 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UAok5M016575;
        Mon, 30 May 2022 11:06:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3gbcc69x5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 11:06:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UAq4Ik40829360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 10:52:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8543211C078;
        Mon, 30 May 2022 11:06:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE86E11C064;
        Mon, 30 May 2022 11:06:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 11:06:23 +0000 (GMT)
Date:   Mon, 30 May 2022 13:06:21 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 15/19] KVM: s390: pv: asynchronous destroy for
 reboot
Message-ID: <20220530130621.5256a0b1@p-imbrenda>
In-Reply-To: <49c2667ecfc2c628c13cae79796ffac4ddc2c0c3.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-16-imbrenda@linux.ibm.com>
        <49c2667ecfc2c628c13cae79796ffac4ddc2c0c3.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 243vsKcxalx1whJALGpcdThRix-8ZFKf
X-Proofpoint-ORIG-GUID: S04ELvEcyK5xQkai81T9A5vz7kbs2Jb8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 11:46:26 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
> [...]
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index b20f2cbd43d9..36bc107bbd7d 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c  
> [...]
> > +/**
> > + * kvm_s390_pv_deinit_vm_async - Perform an asynchronous teardown of
> > a
> > + * protected VM.
> > + * @kvm the VM previously associated with the protected VM
> > + * @rc return value for the RC field of the UVCB
> > + * @rrc return value for the RRC field of the UVCB
> > + *
> > + * Tear down the protected VM that had previously been set aside
> > using
> > + * kvm_s390_pv_deinit_vm_async_prepare.
> > + *
> > + * Context: kvm->lock needs to be held  
> 
> ...and will be released...

no, I decided to refactor this so that the lock won't be held at
all when not needed (you'll see in the next respin), should be cleaner

> 
> > + *
> > + * Return: 0 in case of success, -EINVAL if no protected VM had been
> > + * prepared for asynchronous teardowm, -EIO in case of other errors.
> > + */
> > +int kvm_s390_pv_deinit_vm_async(struct kvm *kvm, u16 *rc, u16 *rrc)  
> 
> Do you also want to set rc and rrc as in kvm_s390_pv_deinit_vm_async_prepare()?

oh... no I don't

I should propagate the actual RC and RRC from the UVC, which I'm not
doing (will fix)

