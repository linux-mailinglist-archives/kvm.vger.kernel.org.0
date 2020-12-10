Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050A42D6174
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbgLJQQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:16:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7547 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732975AbgLJQQX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 11:16:23 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAG8JmK117442;
        Thu, 10 Dec 2020 11:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=2zSaeJyMImLTGA0olPxsmbdkSyRuOyihRCAxeyJ7UJ0=;
 b=sQr+E3e8uJRIH9+a0YrJf+GOAX307aJQu2li/sDhov22HSredp+vGS5fAAHOy2f7g+Sc
 IbTLe0vteyvnXXDT09TvXdm1XJGyNqt9ofD+kBr96FDI/ZQ747mOmSXFdCdRfvwE56sf
 PbenwjKq/Copz48MlTwMqdFXK//1245bby4Kgadcz1U1jJYBpzSGdNr73Jm+jvGCH8uo
 0mD9zXprOztBDhbw7c80TR65UMVPeYrouxY1kPnvWUJquvFdZfr9zst9fRdReuhJ08Va
 OCFvl/k1VtOwnXnDpjHVPiwWSkSYNyHsY7XyU0pAuJ5k1sJiiVQC1VrLUWnX+qLpZK00 kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpgss2rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:15:29 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAG8cwu119797;
        Thu, 10 Dec 2020 11:15:28 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35bpgss2r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 11:15:28 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAG7Kms017567;
        Thu, 10 Dec 2020 16:15:27 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u9rbak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 16:15:27 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAGEBNc18350588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 16:14:12 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D89DE6A057;
        Thu, 10 Dec 2020 16:14:11 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A30146A058;
        Thu, 10 Dec 2020 16:14:10 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.183.17])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Dec 2020 16:14:10 +0000 (GMT)
Message-ID: <22795177a81715d31a141887771b21e518b363c7.camel@linux.ibm.com>
Subject: Re: [PATCH] target/i386/sev: add the support to query the
 attestation report
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Date:   Thu, 10 Dec 2020 08:13:59 -0800
In-Reply-To: <20201204213101.14552-1-brijesh.singh@amd.com>
References: <20201204213101.14552-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=2 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1011 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-12-04 at 15:31 -0600, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> 
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the
> LAUNCH_MEASURE
> command the ATTESATION_REPORT command can be called while the guest
> is running.
> 
> Add a QMP interface "query-sev-attestation-report" that can be used
> to get the report encoded in base64.
> 
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  linux-headers/linux/kvm.h |  8 ++++++
>  qapi/misc-target.json     | 38 +++++++++++++++++++++++++++
>  target/i386/monitor.c     |  6 +++++
>  target/i386/sev-stub.c    |  7 +++++
>  target/i386/sev.c         | 54
> +++++++++++++++++++++++++++++++++++++++
>  target/i386/sev_i386.h    |  2 ++
>  6 files changed, 115 insertions(+)
> 
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 56ce14ad20..6d0f8101ba 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>  	KVM_SEV_DBG_ENCRYPT,
>  	/* Guest certificates commands */
>  	KVM_SEV_CERT_EXPORT,
> +	/* Attestation report */
> +	KVM_SEV_GET_ATTESTATION_REPORT,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>  	__u32 len;
>  };
>  
> +struct kvm_sev_attestation_report {
> +	__u8 mnonce[16];
> +	__u64 uaddr;
> +	__u32 len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 1e561fa97b..ec6565e6ef 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -267,3 +267,41 @@
>  ##
>  { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'],
>    'if': 'defined(TARGET_ARM)' }
> +
> +
> +##
> +# @SevAttestationReport:
> +#
> +# The struct describes attestation report for a Secure Encrypted
> Virtualization
> +# feature.
> +#
> +# @data:  guest attestation report (base64 encoded)
> +#
> +#
> +# Since: 5.2
> +##
> +{ 'struct': 'SevAttestationReport',
> +  'data': { 'data': 'str'},
> +  'if': 'defined(TARGET_I386)' }
> +
> +##
> +# @query-sev-attestation-report:
> +#
> +# This command is used to get the SEV attestation report, and is
> supported on AMD
> +# X86 platforms only.
> +#
> +# @mnonce: a random 16 bytes of data (it will be included in report)
> +#
> +# Returns: SevAttestationReport objects.
> +#
> +# Since: 5.2
> +#
> +# Example:
> +#
> +# -> { "execute" : "query-sev-attestation-report", "arguments": {
> "mnonce": "aaaaaaa" } }
> +# <- { "return" : { "data": "aaaaaaaabbbddddd"} }

It would be nice here, rather than returning a binary blob to break it
up into the actual returned components like query-sev does.

> +##
> +{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce':
> 'str' },
> +  'returns': 'SevAttestationReport',
> +  'if': 'defined(TARGET_I386)' }
[...]
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 93c4d60b82..28958fb71b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -68,6 +68,7 @@ struct SevGuestState {
>  
>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> +#define DEFAULT_ATTESATION_REPORT_BUF_SIZE      4096
>  
>  static SevGuestState *sev_guest;
>  static Error *sev_mig_blocker;
> @@ -490,6 +491,59 @@ out:
>      return cap;
>  }
>  
> +SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp)
> +{
> +    struct kvm_sev_attestation_report input = {};
> +    SevGuestState *sev = sev_guest;
> +    SevAttestationReport *report;
> +    guchar *data;
> +    int err = 0, ret;
> +
> +    if (!sev_enabled()) {
> +        error_setg(errp, "SEV is not enabled");
> +        return NULL;
> +    }
> +
> +    /* Verify that user provided random data length */

There should be a g_base64_decode here, shouldn't there, so we can pass
an arbitrary 16 byte binary blob.

> +    if (strlen(mnonce) != sizeof(input.mnonce)) {

So this if would check the decoded length.

> +        error_setg(errp, "Expected mnonce data len %ld got %ld",
> +                sizeof(input.mnonce), strlen(mnonce));
> +        return NULL;
> +    }
> +
> +    /* Query the report length */
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +            &input, &err);
> +    if (ret < 0) {
> +        if (err != SEV_RET_INVALID_LEN) {
> +            error_setg(errp, "failed to query the attestation report
> length "
> +                    "ret=%d fw_err=%d (%s)", ret, err,
> fw_error_to_str(err));
> +            return NULL;
> +        }
> +    }
> +
> +    data = g_malloc(input.len);
> +    input.uaddr = (unsigned long)data;
> +    memcpy(input.mnonce, mnonce, sizeof(input.mnonce));
> +
> +    /* Query the report */
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +            &input, &err);
> +    if (ret) {
> +        error_setg_errno(errp, errno, "Failed to get attestation
> report"
> +                " ret=%d fw_err=%d (%s)", ret, err,
> fw_error_to_str(err));

report should be set to NULL here to avoid returning uninitialized data
from the goto.

> +        goto e_free_data;
> +    }
> +
> +    report = g_new0(SevAttestationReport, 1);
> +    report->data = g_base64_encode(data, input.len);
> +
> +e_free_data:
> +    g_free(data);
> +    return report;
> +}
> +
>  static int
>  sev_read_file_base64(const char *filename, guchar **data, gsize
> *len)

James


