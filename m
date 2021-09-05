Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5E400E80
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 09:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhIEHJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 03:09:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhIEHJG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 03:09:06 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18574QPC144992;
        Sun, 5 Sep 2021 03:07:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y6k5gW/3UAInolLEbtJFwheUeA46SrVLgCf7P722ELU=;
 b=TBncN4iSjpCYU8TVHcYJuWkO6U8VNUQGJOOe2dndaTaADtXbvggL6M6IaEP+3JW9fTrs
 ah+CbUHGOlJPWBSA/FRfqCw51Rxl4Gbl8T8Yc71fhiGyUqWs/zuMr5tXiDobjOFZ8Hfi
 LqtAfgdS1j49ia+y0gvDPFRX6l4w9BdjEbIBDorFo/YCLwYt79WaD8Dg6tML5VxFhgtv
 whuFhfUPN+65tzHNjVPrj/hYREiG3Oq/B79B5cgRII8qwftdMUJXjbp+qDYXA3BlhqPG
 qGjhgGk5stVwR8KvC+c2H5VwN88wR2ALf/Em6YX+84poCiLEnAflZeyckCh3CeDruBby og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3avnsx2rts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 03:07:53 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 185752RY146150;
        Sun, 5 Sep 2021 03:07:52 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3avnsx2rth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 03:07:52 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 185779eD009118;
        Sun, 5 Sep 2021 07:07:51 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 3av0eagqg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 07:07:51 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18577o9d47710514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 5 Sep 2021 07:07:50 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A41FC6055;
        Sun,  5 Sep 2021 07:07:50 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03C38C6059;
        Sun,  5 Sep 2021 07:07:45 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  5 Sep 2021 07:07:45 +0000 (GMT)
Subject: Re: [RFC PATCH v2 04/12] i386/sev: initialize SNP context
To:     Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-5-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <48bcd5d9-c5da-1ae3-4943-4c3bd9a91c7b@linux.ibm.com>
Date:   Sun, 5 Sep 2021 10:07:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826222627.3556-5-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DKXvXnzlucK3YWn_Ttdvu1a7t5SQ8P9S
X-Proofpoint-ORIG-GUID: FQVOPd9eDpQ9hXK8rFTbIBU8rsmjN6Ev
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-04_09:2021-09-03,2021-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109050047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On 27/08/2021 1:26, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled, the KVM_SNP_INIT command is used to initialize
> the platform. The command checks whether SNP is enabled in the KVM, if
> enabled then it allocates a new ASID from the SNP pool and calls the
> firmware to initialize the all the resources.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev-stub.c |  6 ++++++
>  target/i386/sev.c      | 27 ++++++++++++++++++++++++---
>  target/i386/sev_i386.h |  1 +
>  3 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 0227cb5177..e4fb8e882e 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -81,3 +81,9 @@ sev_get_attestation_report(const char *mnonce, Error **errp)
>      error_setg(errp, "SEV is not available in this QEMU");
>      return NULL;
>  }
> +
> +bool
> +sev_snp_enabled(void)
> +{
> +    return false;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index ba08b7d3ab..b8bd6ed9ea 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -614,12 +614,21 @@ sev_enabled(void)
>      return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
>  }
>  
> +bool
> +sev_snp_enabled(void)
> +{
> +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> +
> +    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_SNP_GUEST);
> +}
> +
>  bool
>  sev_es_enabled(void)
>  {
>      ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
>  
> -    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
> +    return sev_snp_enabled() ||
> +            (sev_enabled() && SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
>  }
>  
>  uint64_t
> @@ -1074,6 +1083,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      uint32_t ebx;
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
> +    void *init_args = NULL;
>  
>      if (!sev_common) {
>          return 0;
> @@ -1126,7 +1136,18 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      sev_common->api_major = status.api_major;
>      sev_common->api_minor = status.api_minor;

Not visible here in the context: the code here is using the
SEV_PLATFORM_STATUS command to get the build_id, api_major, and api_minor.

I see that SNP has a new command SNP_PLATFORM_STATUS, which fills a
struct sev_data_snp_platform_status (hmmm, I can't find the struct's
definition; I assume it should look like Table 38 in 8.3.2 in SNP FW ABI
document).

My questions are:

1. Is it OK to call the "legacy" SEV_PLATFORM_STATUS when about to init
an SNP guest?
2. Do we want to save some info like installed TCB version and reported
TCB version, and maybe other fields from SNP platform status?
3. Should we check the state field in the platform status?



>  
> -    if (sev_es_enabled()) {
> +    if (sev_snp_enabled()) {
> +        SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
> +        if (!kvm_kernel_irqchip_allowed()) {
> +            error_report("%s: SEV-SNP guests require in-kernel irqchip support",
> +                         __func__);

Most errors in this function use error_setg(errp, ...).  This should follow.


> +            goto err;
> +        }
> +
> +        cmd = KVM_SEV_SNP_INIT;
> +        init_args = (void *)&sev_snp_guest->kvm_init_conf;
> +
> +    } else if (sev_es_enabled()) {
>          if (!kvm_kernel_irqchip_allowed()) {
>              error_report("%s: SEV-ES guests require in-kernel irqchip support",
>                           __func__);

Not part of this patch, but this error_report (and another one in the
SEV-ES case) should be converted to error_setg similarly.  Maybe add a
separate patch for fixing this for SEV-ES.



> @@ -1145,7 +1166,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      }
>  
>      trace_kvm_sev_init();

Suggestions:

1. log the guest type (SEV / SEV-ES / SEV-SNP)
2. log the SNP init flags value when initializing an SNP guest


-Dov

> -    ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
> +    ret = sev_ioctl(sev_common->sev_fd, cmd, init_args, &fw_error);
>      if (ret) {
>          error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
>                     __func__, ret, fw_error, fw_error_to_str(fw_error));
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index ae6d840478..e0e1a599be 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -29,6 +29,7 @@
>  #define SEV_POLICY_SEV          0x20
>  
>  extern bool sev_es_enabled(void);
> +extern bool sev_snp_enabled(void);
>  extern uint64_t sev_get_me_mask(void);
>  extern SevInfo *sev_get_info(void);
>  extern uint32_t sev_get_cbit_position(void);
> 
