Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267FE3C9BE9
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 11:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhGOJfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 05:35:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234685AbhGOJfc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 05:35:32 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16F98NDM067114;
        Thu, 15 Jul 2021 05:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BLdUUlY9LFD5HLar2I/qXTTovDzIUCQkKhyDHwzP9AY=;
 b=mo4RfO6xdTl6chIPZsh085fVKeznVDAzxT5H1OmC6uiORoM964GmnXtkdf+b4YlvEORe
 F0K1M6mSczik5I8wmfP6HeXMndcuihQsiL+++vdBKuQK03GX+JpO+1l875PpkfhEN/qE
 oQ+lE/GuXg1Nc6bpmNmsP/1T+FIaVE8WVJrmYH33aRXM4JEcCng9Wnjq0vk6OzPvoMQK
 8q4x4zqJ46NsR7rDEc8hs0hwWBGYrn9RqsOqm7MNi2krvYwvg/g892hphWY+5F0sSIrk
 XEGWfwTrhp/PVdh+WZ4mOVOc89CcwCzJU8XeuIU9tDkkkDBnlAu9t7ojt3TPQpn+fx4u 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39tbj69wm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 05:32:28 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16F9BEMW077647;
        Thu, 15 Jul 2021 05:32:27 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39tbj69wkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 05:32:27 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16F9RoQ0020291;
        Thu, 15 Jul 2021 09:32:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 39s3p78k06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 09:32:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16F9WMjH32899536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 09:32:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F748A4057;
        Thu, 15 Jul 2021 09:32:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 214A7A4069;
        Thu, 15 Jul 2021 09:32:17 +0000 (GMT)
Received: from [9.160.50.212] (unknown [9.160.50.212])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 09:32:16 +0000 (GMT)
Subject: Re: [RFC PATCH 3/6] i386/sev: initialize SNP context
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-4-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <34b8bda5-9b4d-c1e0-0009-1a407a48dd4a@linux.ibm.com>
Date:   Thu, 15 Jul 2021 12:32:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-4-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P__0eO5IViPBg4jqoku5Y3N7HVR80X7w
X-Proofpoint-ORIG-GUID: lfK2eG9CkKyXQHMLg1-ScmGl-mbwJTpe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_04:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brijesh,

On 10/07/2021 0:55, Brijesh Singh wrote:
> When SEV-SNP is enabled, the KVM_SNP_INIT command is used to initialize
> the platform. The command checks whether SNP is enabled in the KVM, if
> enabled then it allocate a new ASID from the SNP pool and calls the

s/allocate/allocates/

> firmware to initialize the all the resources.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  target/i386/sev.c      | 24 +++++++++++++++++++++---
>  target/i386/sev_i386.h |  1 +
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 6b238ef969..84ae244af0 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -583,10 +583,17 @@ sev_enabled(void)
>      return !!sev_guest;
>  }
>  
> +bool
> +sev_snp_enabled(void)
> +{
> +    return sev_guest->snp;
> +}
> +
>  bool
>  sev_es_enabled(void)
>  {
> -    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
> +    return sev_snp_enabled() ||
> +           (sev_enabled() && (sev_guest->policy & SEV_POLICY_ES));
>  }
>  

Just making sure I understand:

* sev_enabled() returns true for SEV or newer (SEV or SEV-ES or
  SEV-SNP).
* sev_es_enabled() returns true for SEV-ES or newer (SEV-ES or SEV-SNP).
* sev_snp_enabled() returns true for SEV-SNP or newer (currently only
  SEV-SNP).

Is that indeed the intention?


-Dov


>  uint64_t
> @@ -1008,6 +1015,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      uint32_t ebx;
>      uint32_t host_cbitpos;
>      struct sev_user_data_status status = {};
> +    void *init_args = NULL;
>  
>      if (!sev) {
>          return 0;
> @@ -1061,7 +1069,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      sev->api_major = status.api_major;
>      sev->api_minor = status.api_minor;
>  
> -    if (sev_es_enabled()) {
> +    if (sev_snp_enabled()) {
> +        if (!kvm_kernel_irqchip_allowed()) {
> +            error_report("%s: SEV-SNP guests require in-kernel irqchip support",
> +                         __func__);
> +            goto err;
> +        }
> +
> +        cmd = KVM_SEV_SNP_INIT;
> +        init_args = (void *)&sev->snp_config.init;
> +
> +    } else if (sev_es_enabled()) {
>          if (!kvm_kernel_irqchip_allowed()) {
>              error_report("%s: SEV-ES guests require in-kernel irqchip support",
>                           __func__);
> @@ -1080,7 +1098,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      }
>  
>      trace_kvm_sev_init();
> -    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
> +    ret = sev_ioctl(sev->sev_fd, cmd, init_args, &fw_error);
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
