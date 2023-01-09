Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E759A662910
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 15:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbjAIOwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 09:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbjAIOwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 09:52:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25AD373AA;
        Mon,  9 Jan 2023 06:50:41 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309DLcBA020828;
        Mon, 9 Jan 2023 14:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=FHx/pK7UbHd7cF/C7/sPVqB5iCoXCLVTjdEuHXQA9mg=;
 b=CiLnUYulcd3Y2FXk5Lj5WAh4KgxsfZcYKjxfCQ08zGWcNBqLvTSEqOgEDQKQGyTK9VcX
 BGDmbrW07oViNhu/TsJ6VkK+ta4f5V7BNRo4EWtEm/eFh+LFf/ru6aVuI3mqLsGu3+8L
 1EcK6JeiyqXdsSeBXwcdasCFXOf6DXR86xRFvd4rkGU0ixTBA1w+QOZ52pMEe9ufLsqd
 tm+Zzg+56oLusXSwc+NJEXmkI1ZR3x+p+xdUEU+wsYY+yvVy1r136SZK8w1uvRkL9KeL
 qd6R2az87Gp5cPIrfzaX2GENftn2xDngAV8MgiFVKu/GpOSgaLc7db9STQK77mx5FT/n +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjasrgbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 14:50:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 309EJob6023203;
        Mon, 9 Jan 2023 14:50:39 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjasrgbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 14:50:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3096uNxd021763;
        Mon, 9 Jan 2023 14:50:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3my0c6a78w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 14:50:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 309EoYss48300328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 14:50:34 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40FD120043;
        Mon,  9 Jan 2023 14:50:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6C7020040;
        Mon,  9 Jan 2023 14:50:33 +0000 (GMT)
Received: from osiris (unknown [9.179.30.90])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Jan 2023 14:50:33 +0000 (GMT)
Date:   Mon, 9 Jan 2023 15:50:32 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: interrupt: use READ_ONCE() before cmpxchg()
Message-ID: <Y7wpuAArn1Al6c9v@osiris>
References: <20230109125135.393784-1-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109125135.393784-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E0byUrtvdsaVDdFIqd8wf89HkzzhtxVg
X-Proofpoint-ORIG-GUID: A517Jdb_YGqdvI4fVmwSzimZXdRCWZKs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_08,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=623 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 01:51:35PM +0100, Heiko Carstens wrote:
> Use READ_ONCE() before cmpxchg() to prevent that the compiler generates
> code that fetches the to be compared old value several times from memory.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 1dae78deddf2..a3bf1b6a7962 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -83,8 +83,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>  		struct esca_block *sca = vcpu->kvm->arch.sca;
>  		union esca_sigp_ctrl *sigp_ctrl =
>  			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
> +		union esca_sigp_ctrl new_val = {0};
>  
> +		old_val = READ_ONCE(*sigp_ctrl);

FWIW, Claudio pointed out that this doesn't even compile.
Sending a new version - sorry about this!
