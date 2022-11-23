Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE1A63576C
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiKWJly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237981AbiKWJld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:41:33 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89284FC716;
        Wed, 23 Nov 2022 01:39:08 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN7Peo3010134;
        Wed, 23 Nov 2022 09:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=G7MppZwrAD9hv1WL9YxVrbxXR61NAceyba4rmUIFQno=;
 b=jHsvQkoX6LuIDBgOgy7q0OMsLn30SY4BFfXVxlTN975u0YwdZ7+6OBgHdXJ23F6rZIp8
 +pIU1xHQOQkKw9J5U14Mga+ZLQuwzcgh1sAZjRu4eGWn71naCSEV60D4RVnE/50IVizt
 QKjdEh8eWJ5cYgMoHnOQB7igFw3pY0Du+SDDe1uRHzVCcRC5yjIJe4G2AMPmZWHQBMye
 kyup1GF2faYENS0Q3qk9v2GTGdWDOmxO4IxGQ3PsY2sKcbF2HuIbu5/F3AY0zqB7cz2i
 D2ruoIhJkv5cN2rWYPvqKQi9JiNiWISwLkWfbd6/FehbCDS+QkhFGjzzUBVx5BVB6xYY Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w5pwp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:39:07 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN9MK8c013102;
        Wed, 23 Nov 2022 09:39:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w5pwn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:39:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN9YkdD021747;
        Wed, 23 Nov 2022 09:39:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps8wfew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 09:39:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN9d1rv63177088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 09:39:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6308142042;
        Wed, 23 Nov 2022 09:39:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B27442041;
        Wed, 23 Nov 2022 09:39:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 09:39:01 +0000 (GMT)
Date:   Wed, 23 Nov 2022 10:38:59 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        "Collin L. Walling" <walling@linux.ibm.com>,
        Jason J Herne <jjherne@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: Fix the initialization of the epoch
 extension (epdx) field
Message-ID: <20221123103859.1d861c44@p-imbrenda>
In-Reply-To: <20221123090833.292938-1-thuth@redhat.com>
References: <20221123090833.292938-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VB7N-UmU2w5V8YnsGnJfOrH4quVoW2GC
X-Proofpoint-ORIG-GUID: mmYlp7Uaw75Lq2JRuQlR7jx7IdMePVU_
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=994 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 10:08:33 +0100
Thomas Huth <thuth@redhat.com> wrote:

> We recently experienced some weird huge time jumps in nested guests when
> rebooting them in certain cases. After adding some debug code to the epoch
> handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
> obvious that the "epdx" field (the multi-epoch extension) did not get set
> to 0xff in case the "epoch" field was negative.
> Seems like the code misses to copy the value from the epdx field from
> the guest to the shadow control block. By doing so, the weird time
> jumps are gone in our scenarios.
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
> Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/vsie.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 94138f8f0c1c..ace2541ababd 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -546,8 +546,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
>  		scb_s->eca |= scb_o->eca & ECA_CEI;
>  	/* Epoch Extension */
> -	if (test_kvm_facility(vcpu->kvm, 139))
> +	if (test_kvm_facility(vcpu->kvm, 139)) {
>  		scb_s->ecd |= scb_o->ecd & ECD_MEF;
> +		scb_s->epdx = scb_o->epdx;

looks quite straightforward

> +	}
>  
>  	/* etoken */
>  	if (test_kvm_facility(vcpu->kvm, 156))

