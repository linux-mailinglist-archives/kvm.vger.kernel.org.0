Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9803CD3C7
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 13:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbhGSKnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 06:43:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235905AbhGSKnq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 06:43:46 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JB3C1l040568;
        Mon, 19 Jul 2021 07:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LnMCxKY7aZ2/AaHSgnjclpFZJPwcTB+6i9WKhgOEYeQ=;
 b=EtIgVryDQ7PmtVqJYTFkpnlU7yNUJGK188SZ0DnMvgDXsa18VM7O1HJatiCovrns8EDB
 Y26HCjJInzKvCMEfo8qwZGT/hqHKgOqiXlAX5+WbQsE5lAuUKtg7u5AkqmMhcmsdodd8
 uwwbQd1TDLkpG/C+xePQFrW24GY8ZmEz9Bj/5D0Vnce2SFCAUHq3nNT0JSIXd9JC/hDA
 FWktxKCdpp2AvTXAjtVbjml6vhFtyUMuZNmKQLaj+RomRf8zwM7ZyCQh2IlFOiFDgRtX
 5JSxRxscmP/kqm2kCOqCiW6fAQyscfRxUtsXTDb/x9I3gyTPlFXrvQJao0ICiIgrMNzR dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w5hr5sqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 07:24:13 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16JBBHR6095179;
        Mon, 19 Jul 2021 07:24:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w5hr5spf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 07:24:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16JB8VbT020476;
        Mon, 19 Jul 2021 11:24:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 39upu88p4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 11:24:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16JBO7O225559324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 11:24:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27DBDA4085;
        Mon, 19 Jul 2021 11:24:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04809A4081;
        Mon, 19 Jul 2021 11:24:03 +0000 (GMT)
Received: from [9.65.195.237] (unknown [9.65.195.237])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jul 2021 11:24:02 +0000 (GMT)
Subject: Re: [RFC PATCH 6/6] i386/sev: populate secrets and cpuid page and
 finalize the SNP launch
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
 <20210709215550.32496-7-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <a9ca3ae4-2460-f069-d8ad-52c063e19e97@linux.ibm.com>
Date:   Mon, 19 Jul 2021 14:24:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-7-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5HfnnlpJo6tWyB8EY3SbAiPg_g81O_us
X-Proofpoint-ORIG-GUID: _kCbJRv1jdSoTEhj754FzLzH1gljOXfm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_03:2021-07-16,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brijesh,

On 10/07/2021 0:55, Brijesh Singh wrote:
> During the SNP guest launch sequence, a special secrets and cpuid page
> needs to be populated by the SEV-SNP firmware. The secrets page contains
> the VM Platform Communication Key (VMPCKs) used by the guest to send and
> receive secure messages to the PSP. And CPUID page will contain the CPUID
> value filtered through the PSP.
> 
> The guest BIOS (OVMF) reserves these pages in MEMFD and location of it
> is available through the SNP boot block GUID. While finalizing the guest
> boot flow, lookup for the boot block and call the SNP_LAUNCH_UPDATE
> command to populate secrets and cpuid pages.
> 
> In order to support early boot code, the OVMF may ask hypervisor to
> request the pre-validation of certain memory range. If such range is
> present the call LAUNCH_UPDATE command to validate those address range

s/LAUNCH_UPDATE/SNP_LAUNCH_UPDATE/
(to show it's the same command you refer to above)

> without affecting the measurement. See the SEV-SNP specification for
> further details.
> 
> Finally, call the SNP_LAUNCH_FINISH to finalize the guest boot.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  target/i386/sev.c        | 184 ++++++++++++++++++++++++++++++++++++++-
>  target/i386/trace-events |   2 +
>  2 files changed, 184 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 41dcb084d1..f438e09d33 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -93,6 +93,19 @@ typedef struct __attribute__((__packed__)) SevInfoBlock {
>      uint32_t reset_addr;
>  } SevInfoBlock;
>  
> +#define SEV_SNP_BOOT_BLOCK_GUID "bd39c0c2-2f8e-4243-83e8-1b74cebcb7d9"
> +typedef struct __attribute__((__packed__)) SevSnpBootInfoBlock {
> +    /* Prevalidate range address */
> +    uint32_t pre_validated_start;
> +    uint32_t pre_validated_end;
> +    /* Secrets page address */
> +    uint32_t secrets_addr;
> +    uint32_t secrets_len;
> +    /* CPUID page address */
> +    uint32_t cpuid_addr;
> +    uint32_t cpuid_len;
> +} SevSnpBootInfoBlock;
> +
>  static SevGuestState *sev_guest;
>  static Error *sev_mig_blocker;
>  
> @@ -1014,6 +1027,158 @@ static Notifier sev_machine_done_notify = {
>      .notify = sev_launch_get_measure,
>  };
>  
> +static int
> +sev_snp_launch_update_gpa(uint32_t hwaddr, uint32_t size, uint8_t type)

hwaddr is a confusing name here because it is also a typedef (which is
most likely uint64_t...).  Maybe call this argument `gpa` ?


> +{
> +    void *hva;
> +    MemoryRegion *mr = NULL;
> +
> +    hva = gpa2hva(&mr, hwaddr, size, NULL);
> +    if (!hva) {
> +        error_report("SEV-SNP failed to get HVA for GPA 0x%x", hwaddr);
> +        return 1;
> +    }
> +
> +    return sev_snp_launch_update(sev_guest, hva, size, type);
> +}
> +
> +struct snp_pre_validated_range {
> +    uint32_t start;
> +    uint32_t end;
> +};
> +
> +static struct snp_pre_validated_range pre_validated[2];
> +
> +static bool
> +detectoverlap(uint32_t start, uint32_t end,
> +              struct snp_pre_validated_range *overlap)

naming conventions dictate: detect_overlap

> +{
> +    int i;
> +
> +    for (i = 0; i < ARRAY_SIZE(pre_validated); i++) {
> +        if (pre_validated[i].start < end && start < pre_validated[i].end) {
> +            memcpy(overlap, &pre_validated[i], sizeof(*overlap));

Maybe simpler than memcpy:

    *overlap = pre_validated[i];


> +            return true;
> +        }
> +    }
> +
> +    return false;
> +}
> +
> +static void snp_ovmf_boot_block_setup(void)
> +{
> +    struct snp_pre_validated_range overlap;
> +    SevSnpBootInfoBlock *info;
> +    uint32_t start, end, sz;
> +    int ret;
> +
> +    /*
> +     * Extract the SNP boot block for the SEV-SNP guests by locating the
> +     * SNP_BOOT GUID. The boot block contains the information such as location
> +     * of secrets and CPUID page, additionaly it may contain the range of
> +     * memory that need to be pre-validated for the boot.
> +     */
> +    if (!pc_system_ovmf_table_find(SEV_SNP_BOOT_BLOCK_GUID,
> +        (uint8_t **)&info, NULL)) {
> +        error_report("SEV-SNP: failed to find the SNP boot block");
> +        exit(1);
> +    }
> +
> +    trace_kvm_sev_snp_ovmf_boot_block_info(info->secrets_addr,
> +                                           info->secrets_len, info->cpuid_addr,
> +                                           info->cpuid_len,
> +                                           info->pre_validated_start,
> +                                           info->pre_validated_end);
> +
> +    /* Populate the secrets page */
> +    ret = sev_snp_launch_update_gpa(info->secrets_addr, info->secrets_len,
> +                                    KVM_SEV_SNP_PAGE_TYPE_SECRETS);
> +    if (ret) {
> +        error_report("SEV-SNP: failed to insert secret page GPA 0x%x",
> +                     info->secrets_addr);
> +        exit(1);
> +    }
> +
> +    /* Populate the cpuid page */
> +    ret = sev_snp_launch_update_gpa(info->cpuid_addr, info->cpuid_len,
> +                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
> +    if (ret) {
> +        error_report("SEV-SNP: failed to insert cpuid page GPA 0x%x",
> +                     info->cpuid_addr);
> +        exit(1);
> +    }
> +
> +    /*
> +     * Pre-validate the range using the LAUNCH_UPDATE_DATA, if the
> +     * pre-validation range contains the CPUID and Secret page GPA then skip
> +     * it. This is because SEV-SNP firmware pre-validates those pages as part
> +     * of adding secrets and cpuid LAUNCH_UPDATE type.
> +     */
> +    pre_validated[0].start = info->secrets_addr;
> +    pre_validated[0].end = info->secrets_addr + info->secrets_len;
> +    pre_validated[1].start = info->cpuid_addr;
> +    pre_validated[1].end = info->cpuid_addr + info->cpuid_len;
> +    start = info->pre_validated_start;
> +    end = info->pre_validated_end;
> +
> +    while (start < end) {
> +        /* Check if the requested range overlaps with Secrets and CPUID page */
> +        if (detectoverlap(start, end, &overlap)) {
> +            if (start < overlap.start) {
> +                sz = overlap.start - start;
> +                if (sev_snp_launch_update_gpa(start, sz,
> +                    KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
> +                    error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
> +                                 start, sz);
> +                    exit(1);
> +                }
> +            }
> +
> +            start = overlap.end;
> +            continue;
> +        }
> +
> +        /* Validate the remaining range */
> +        if (sev_snp_launch_update_gpa(start, end - start,
> +            KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
> +            error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
> +                         start, end - start);
> +            exit(1);
> +        }
> +
> +        start = end;
> +    }
> +}
> +
> +static void
> +sev_snp_launch_finish(SevGuestState *sev)
> +{
> +    int ret, error;
> +    Error *local_err = NULL;
> +    struct kvm_sev_snp_launch_finish *finish = &sev->snp_config.finish;
> +
> +    trace_kvm_sev_snp_launch_finish();

Maybe the trace should show some info about the snp_config.finish fields?


> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_FINISH, finish, &error);
> +    if (ret) {
> +        error_report("%s: SNP_LAUNCH_FINISH ret=%d fw_error=%d '%s'",
> +                     __func__, ret, error, fw_error_to_str(error));
> +        exit(1);
> +    }
> +
> +    sev_set_guest_state(sev, SEV_STATE_RUNNING);
> +
> +    /* add migration blocker */
> +    error_setg(&sev_mig_blocker,
> +               "SEV: Migration is not implemented");
> +    ret = migrate_add_blocker(sev_mig_blocker, &local_err);
> +    if (local_err) {
> +        error_report_err(local_err);
> +        error_free(sev_mig_blocker);
> +        exit(1);
> +    }
> +}
> +
> +
>  static void
>  sev_launch_finish(SevGuestState *sev)
>  {
> @@ -1048,7 +1213,12 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
>  
>      if (running) {
>          if (!sev_check_state(sev, SEV_STATE_RUNNING)) {
> -            sev_launch_finish(sev);
> +            if (sev_snp_enabled()) {
> +                snp_ovmf_boot_block_setup();
> +                sev_snp_launch_finish(sev);
> +            } else {
> +                sev_launch_finish(sev);
> +            }
>          }
>      }
>  }
> @@ -1164,7 +1334,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      }
>  
>      ram_block_notifier_add(&sev_ram_notifier);
> -    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> +
> +    /*
> +     * The machine done notify event is used by the SEV guest to get the
> +     * measurement of the encrypted images. When SEV-SNP is enabled then
> +     * measurement is part of the attestation report and the measurement
> +     * command does not exist. So skip registering the notifier.
> +     */
> +    if (!sev_snp_enabled()) {
> +        qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> +    }
> +
>      qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
>  
>      cgs->ready = true;
> diff --git a/target/i386/trace-events b/target/i386/trace-events
> index 0c2d250206..db91287439 100644
> --- a/target/i386/trace-events
> +++ b/target/i386/trace-events
> @@ -13,3 +13,5 @@ kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa
>  kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
>  kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
>  kvm_sev_snp_launch_update(void *addr, uint64_t len, int type) "addr %p len 0x%" PRIx64 " type %d"
> +kvm_sev_snp_launch_finish(void) ""
> +kvm_sev_snp_ovmf_boot_block_info(uint32_t secrets_gpa, uint32_t slen, uint32_t cpuid_gpa, uint32_t clen, uint32_t s, uint32_t e) "secrets 0x%x+0x%x cpuid 0x%x+0x%x pre-validate 0x%x+0x%x"

The last argument is an end-addr (not a length), so maybe the format
string should end with:

   ".... pre-validate 0x%x - 0x%x"

Also I'd prefer to log the SevSnpBootInfoBlock fields in the order they
appear in the struct.


-Dov
