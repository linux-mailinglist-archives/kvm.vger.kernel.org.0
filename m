Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3CA5593CC
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 08:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiFXG4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 02:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiFXG4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 02:56:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC4367E7B;
        Thu, 23 Jun 2022 23:56:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25O5xuxr026752;
        Fri, 24 Jun 2022 06:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=G0hXMEEysvvtc+AXz++5jj6f32eOu+pQFiE21Qxf8jw=;
 b=dOU0WpCEhVrw3WnVUD8QFLBskVVLqfcZ/baZ9sp2DUayKYyQE9SfjW+hii4Z14JoyRhB
 44AZyjcHU9xgbtmsmnsJ3eDC/6WYNhRZXc57lPoHG5p32NqaL79AHo+G3DqhiCyuatcd
 kBPB08vh0K83BclK6Ce1WAigqu3ujgxyE7Kp1LlujCo5bnaU9KyrMUCCVifFPAPacUmd
 YYTs4svvtLX5YUF93MJU34pFWU1laTRuwC3VL2PGr9tIEYWFQ6rot2MFI8X17IL3D8iU
 +CstFQYoUlK2WNtelAexWGbAHiD0lH+9opsOSlRxEq6bBk9C6uEfm3WCOvk/fWgZXTFd NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw6ghtu4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:56:51 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25O5VObQ005566;
        Fri, 24 Jun 2022 06:56:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gw6ghtu3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:56:50 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25O6pjRG023589;
        Fri, 24 Jun 2022 06:56:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3gvtjp8rhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 06:56:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25O6uiNL21758246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 06:56:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5BFB11C052;
        Fri, 24 Jun 2022 06:56:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F6B311C04A;
        Fri, 24 Jun 2022 06:56:44 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.95.53])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 06:56:44 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220620125437.37122-3-pmorel@linux.ibm.com>
References: <20220620125437.37122-1-pmorel@linux.ibm.com> <20220620125437.37122-3-pmorel@linux.ibm.com>
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <165605380436.8840.11959073846437899088@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 24 Jun 2022 08:56:44 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Nf4IdCt2vTnG34TTVS81qORF2H9i_rSJ
X-Proofpoint-GUID: 595agiu9tXu4QJ4Ifyw8ibvT3-sl5-3R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_04,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 clxscore=1011 mlxlogscore=929 phishscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240023
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2022-06-20 14:54:36)
[...]
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 766028d54a3e..bb54196d4ed6 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
[...]
> @@ -3403,6 +3426,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         rc =3D kvm_s390_vcpu_setup(vcpu);
>         if (rc)
>                 goto out_ucontrol_uninit;
> +
> +       kvm_s390_sca_set_mtcr(vcpu->kvm);

We set the MTCR in the vcpu create. Does it also make sense to set it in kv=
m_arch_vcpu_destroy?

[...]
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 12c464c7cddf..77a692238585 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
[...]
> +       case 15:
> +               trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2=
);
> +               insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
> +               return -EREMOTE;

Maybe the API documentation should clearly note that once you turn on KVM_C=
AP_S390_CPU_TOPOLOGY, you will get exits to userspace for STSI 15.x.y, rega=
rdless of whether KVM_CAP_S390_USER_STSI is on or off.

Other than that, looks good, hence:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
