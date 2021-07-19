Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FDC3CD555
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 15:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbhGSMUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 08:20:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236780AbhGSMUd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 08:20:33 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JCZ5XC068579;
        Mon, 19 Jul 2021 09:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zI9IsPXOZ/pth+cYFUA6cViBl/XUuGrBrhq4P620G7w=;
 b=s1/5EawJiiPUIXpZbd6ZOBp3p7fWC9HF6cblfe/AarGkNqqbPkvFI6LEG2/QM2xnnpFW
 A1vxfkNeSMrb5/TFVTbz7IhTatNHCCUTn9OImxeqm9Veqjp2xekT1Q/c99xximlEmDjl
 Ggfl1OGv4K9DPXJ2qM9IY4YzxpB5F2er2UK0TRSwNjMtMITX77a2e58kJPNsHEDuRSzb
 J/LNT0K1UI0UGL/mrKAvU7ult+xiCaXJV1B9tCDo50DCILbl+aBb4UmLdA3JjbNs6Yey
 FdXxtMVtZBKN0X4VH5jPQiAvO7duGZJktyLkzmrKb6w1v8N7hDp8N6suOZNX2+exLWgG AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39w8w8j31s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 09:01:01 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16JCZ7vr068816;
        Mon, 19 Jul 2021 09:01:01 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39w8w8j31b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 09:01:01 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16JCvQ3Y023795;
        Mon, 19 Jul 2021 13:01:00 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 39upua6mam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 13:01:00 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16JD10u139453182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 13:01:00 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0373512405A;
        Mon, 19 Jul 2021 13:01:00 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30635124053;
        Mon, 19 Jul 2021 13:00:57 +0000 (GMT)
Received: from [9.65.195.237] (unknown [9.65.195.237])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jul 2021 13:00:56 +0000 (GMT)
Subject: Re: [RFC PATCH 5/6] i386/sev: add support to encrypt BIOS when
 SEV-SNP is enabled
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
 <20210709215550.32496-6-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <0ab7b398-238e-38c5-aed1-fd39fd9c7f7c@linux.ibm.com>
Date:   Mon, 19 Jul 2021 16:00:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-6-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bd-Q-Ylrryquhx6cR2t5G70vOxixS09J
X-Proofpoint-GUID: ZBuzWph7wexbdrcXb7aqGoMKAZ8ZmYeL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_05:2021-07-19,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 adultscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/07/2021 0:55, Brijesh Singh wrote:
> The KVM_SEV_SNP_LAUNCH_UPDATE command is used for encrypting the bios
> image used for booting the SEV-SNP guest.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  target/i386/sev.c        | 33 ++++++++++++++++++++++++++++++++-
>  target/i386/trace-events |  1 +
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 259408a8f1..41dcb084d1 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -883,6 +883,30 @@ out:
>      return ret;
>  }
>  
> +static int
> +sev_snp_launch_update(SevGuestState *sev, uint8_t *addr, uint64_t len, int type)

This seems similar to the SEV LAUNCH_UPDATE_DATA API (with the added
`type` argument).  In SEV API these are the limitations (from the SEV
API document):

* PADDR - System physical address of the data to be encrypted.
          Must be 16 B aligned.
* LENGTH - Length of the data to be encrypted.
           Must be a multiple of 16 B.

But in SNP_LAUNCH_UPDATE it is my understanding that addr must be page
aligned (4KB) and length must be in whole pages (because the underlying
types are PAGE_TYPE_NORMAL, PAGE_TYPE_ZERO, ...).

So what happens if we call sev_encrypt_flash with a non-page-aligned
addr / length?

Or maybe I misunderstood the SNP ABI document?

-Dov



> +{
> +    int ret, fw_error;
> +    struct kvm_sev_snp_launch_update update = {};
> +
> +    if (!addr || !len) {
> +        return 1;
> +    }
> +
> +    update.uaddr = (__u64)(unsigned long)addr;
> +    update.len = len;
> +    update.page_type = type;
> +    trace_kvm_sev_snp_launch_update(addr, len, type);
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_UPDATE,
> +                    &update, &fw_error);
> +    if (ret) {
> +        error_report("%s: SNP_LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
> +                __func__, ret, fw_error, fw_error_to_str(fw_error));
> +    }
> +
> +    return ret;
> +}
> +
>  static int
>  sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
>  {
> @@ -1161,7 +1185,14 @@ sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
>  
>      /* if SEV is in update state then encrypt the data else do nothing */
>      if (sev_check_state(sev_guest, SEV_STATE_LAUNCH_UPDATE)) {
> -        int ret = sev_launch_update_data(sev_guest, ptr, len);
> +        int ret;
> +
> +        if (sev_snp_enabled()) {
> +            ret = sev_snp_launch_update(sev_guest, ptr, len,
> +                                        KVM_SEV_SNP_PAGE_TYPE_NORMAL);
> +        } else {
> +            ret = sev_launch_update_data(sev_guest, ptr, len);
> +        }
>          if (ret < 0) {
>              error_setg(errp, "failed to encrypt pflash rom");
>              return ret;
> diff --git a/target/i386/trace-events b/target/i386/trace-events
> index 18cc14b956..0c2d250206 100644
> --- a/target/i386/trace-events
> +++ b/target/i386/trace-events
> @@ -12,3 +12,4 @@ kvm_sev_launch_finish(void) ""
>  kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
>  kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
>  kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
> +kvm_sev_snp_launch_update(void *addr, uint64_t len, int type) "addr %p len 0x%" PRIx64 " type %d"
> 
