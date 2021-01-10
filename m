Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2362F08EE
	for <lists+kvm@lfdr.de>; Sun, 10 Jan 2021 19:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbhAJSBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jan 2021 13:01:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37270 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbhAJSA7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 Jan 2021 13:00:59 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10AHWAFQ026142;
        Sun, 10 Jan 2021 13:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TqFXtMwV6FPZU4nQYVtls4+GGXV/SFLuf+eK3133/XM=;
 b=RXNWxjkrz6NgG69W5eJp2AV9TG+G7udjDWIGP6yEz3oIx3TXHQX4jq3siG57MTtnSG0m
 sLZLQ0wMtwCiC6j6/Q8ie+6FP0Y6vtcItBfHsgqJlUSmJdHfMYoD4GPkbsNaCH4Owuwa
 opep/Zxq34+JcMMhYJujgq2zgs4GbC0napj6FkCVsWYsGxGfEZTjwYjUgUnXAKSd17Cn
 pdAQQCqGr+XKue8XZBhDVo0QeuIdNOt4RkUG+L+UhqvdH1+Yejy7fSC7P0uMcKsYByye
 PzKCx4pLGuw7lNdqWq6/KNVtEB5ECj5t9ufvGW2NOPh+EnwB9Z82TAXKnfeTJYon4JAR ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3605j0gpcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 13:00:10 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10AHpGWX072067;
        Sun, 10 Jan 2021 13:00:10 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3605j0gpb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 13:00:10 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10AHuirU011616;
        Sun, 10 Jan 2021 18:00:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447sehj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 18:00:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10AI02P217760604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Jan 2021 18:00:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8793742047;
        Sun, 10 Jan 2021 18:00:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 545D842067;
        Sun, 10 Jan 2021 18:00:04 +0000 (GMT)
Received: from [9.65.219.40] (unknown [9.65.219.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 10 Jan 2021 18:00:04 +0000 (GMT)
Subject: Re: [PATCH v2] target/i386/sev: add support to query the attestation
 report
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Tom Lendacky <Thomas.Lendacky@amd.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210105163943.30510-1-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
Message-ID: <f538fbad-fce9-e410-551e-5c957cf25cbd@linux.vnet.ibm.com>
Date:   Sun, 10 Jan 2021 20:00:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105163943.30510-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101100122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,


On 05/01/2021 18:39, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
> 
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
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
> v2:
>    * add trace event.
>    * fix the goto to return NULL on failure.
>    * make the mnonce as a base64 encoded string
> 
>   linux-headers/linux/kvm.h |  8 +++++
>   qapi/misc-target.json     | 38 ++++++++++++++++++++++
>   target/i386/monitor.c     |  6 ++++
>   target/i386/sev-stub.c    |  7 +++++
>   target/i386/sev.c         | 66 +++++++++++++++++++++++++++++++++++++++
>   target/i386/sev_i386.h    |  2 ++
>   target/i386/trace-events  |  1 +
>   7 files changed, 128 insertions(+)
> 
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 56ce14ad20..6d0f8101ba 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>   	KVM_SEV_DBG_ENCRYPT,
>   	/* Guest certificates commands */
>   	KVM_SEV_CERT_EXPORT,
> +	/* Attestation report */
> +	KVM_SEV_GET_ATTESTATION_REPORT,
> 
>   	KVM_SEV_NR_MAX,
>   };
> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>   	__u32 len;
>   };
> 
> +struct kvm_sev_attestation_report {
> +	__u8 mnonce[16];
> +	__u64 uaddr;
> +	__u32 len;
> +};
> +
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>   #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>   #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 06ef8757f0..5907a2dfaa 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -285,3 +285,41 @@
>   ##
>   { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'],
>     'if': 'defined(TARGET_ARM)' }
> +
> +
> +##
> +# @SevAttestationReport:
> +#
> +# The struct describes attestation report for a Secure Encrypted Virtualization
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
> +# This command is used to get the SEV attestation report, and is supported on AMD
> +# X86 platforms only.
> +#
> +# @mnonce: a random 16 bytes value encoded in base64 (it will be included in report)
> +#
> +# Returns: SevAttestationReport objects.
> +#
> +# Since: 5.3
> +#
> +# Example:
> +#
> +# -> { "execute" : "query-sev-attestation-report", "arguments": { "mnonce": "aaaaaaa" } }
> +# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
> +#
> +##
> +{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
> +  'returns': 'SevAttestationReport',
> +  'if': 'defined(TARGET_I386)' }
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 1bc91442b1..0c8377f900 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -736,3 +736,9 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
>   {
>       sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
>   }
> +
> +SevAttestationReport *
> +qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
> +{
> +    return sev_get_attestation_report(mnonce, errp);
> +}
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index c1fecc2101..cdc9a014ee 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -54,3 +54,10 @@ int sev_inject_launch_secret(const char *hdr, const char *secret,
>   {
>       return 1;
>   }
> +
> +SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp)
> +{
> +    error_setg(errp, "SEV is not available in this QEMU");
> +    return NULL;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1546606811..d1f90a1d8a 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -492,6 +492,72 @@ out:
>       return cap;
>   }
> 
> +SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp)
> +{
> +    struct kvm_sev_attestation_report input = {};
> +    SevAttestationReport *report = NULL;
> +    SevGuestState *sev = sev_guest;
> +    guchar *data;
> +    guchar *buf;
> +    gsize len;
> +    int err = 0, ret;
> +
> +    if (!sev_enabled()) {
> +        error_setg(errp, "SEV is not enabled");
> +        return NULL;
> +    }
> +
> +    /* lets decode the mnonce string */
> +    buf = g_base64_decode(mnonce, &len);
> +    if (!buf) {
> +        error_setg(errp, "SEV: failed to decode mnonce input");
> +        return NULL;
> +    }
> +
> +    /* verify the input mnonce length */
> +    if (len != sizeof(input.mnonce)) {
> +        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
> +                sizeof(input.mnonce), len);
> +        g_free(buf);
> +        return NULL;
> +    }
> +
> +    /* Query the report length */
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +            &input, &err);
> +    if (ret < 0) {
> +        if (err != SEV_RET_INVALID_LEN) {
> +            error_setg(errp, "failed to query the attestation report length "
> +                    "ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
> +            return NULL;

buf is not freed here.


-Dov




> +        }
> +    }
> +
> +    data = g_malloc(input.len);
> +    input.uaddr = (unsigned long)data;
> +    memcpy(input.mnonce, buf, sizeof(input.mnonce));
> +
> +    /* Query the report */
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +            &input, &err);
> +    if (ret) {
> +        error_setg_errno(errp, errno, "Failed to get attestation report"
> +                " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
> +        goto e_free_data;
> +    }
> +
> +    report = g_new0(SevAttestationReport, 1);
> +    report->data = g_base64_encode(data, input.len);
> +
> +    trace_kvm_sev_attestation_report(mnonce, report->data);
> +
> +e_free_data:
> +    g_free(data);
> +    g_free(buf);
> +    return report;
> +}
> +
>   static int
>   sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>   {
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index 4db6960f60..e2d0774708 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -35,5 +35,7 @@ extern uint32_t sev_get_cbit_position(void);
>   extern uint32_t sev_get_reduced_phys_bits(void);
>   extern char *sev_get_launch_measurement(void);
>   extern SevCapability *sev_get_capabilities(Error **errp);
> +extern SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp);
> 
>   #endif
> diff --git a/target/i386/trace-events b/target/i386/trace-events
> index a22ab24e21..8d6437404d 100644
> --- a/target/i386/trace-events
> +++ b/target/i386/trace-events
> @@ -10,3 +10,4 @@ kvm_sev_launch_update_data(void *addr, uint64_t len) "addr %p len 0x%" PRIx64
>   kvm_sev_launch_measurement(const char *value) "data %s"
>   kvm_sev_launch_finish(void) ""
>   kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
> +kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
> 
