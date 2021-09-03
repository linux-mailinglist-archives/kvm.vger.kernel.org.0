Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E7940068C
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 22:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350451AbhICUZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 16:25:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234379AbhICUZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 16:25:42 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183K3x6M159710;
        Fri, 3 Sep 2021 16:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qA/OCpTSqT1LnE1E2iFKkpt3s6BTVZ9j6/a3swLPawA=;
 b=SqgKstoNJTYc1SFCqN20n8toxrMrJQltsQxCLfHs7ZQ5T4DFhR0QmFr+oQ1ZOyJR3HCo
 LIWQZbbAPMT9AoVk1WHYeQqkf8z6eh2JfGsVHhyQwlRDYBEQoIvhvpSBrWXF8+pb7dkI
 geHHPnNbxWlPye8TZTgH4AfebL1ZQRnFACTLogF9pauj5hi0oOCNUAtjRU0mhL2xH8Qb
 ZhKZvvVCMlA9WCngNUp+ge+LQudHBJXK5zWRFpsNDWwBrHoiXV4971sQXRpqxbORVMrT
 3WxSifTWOQKJh2Pt+zARKLiV5vejXOnLnqU9K84/AosoPHTxrHd6MGzh4GyXXISuUlc7 Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aurkf2r9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 16:24:30 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183K5NMU168485;
        Fri, 3 Sep 2021 16:24:30 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aurkf2r94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 16:24:30 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183KCEcJ032498;
        Fri, 3 Sep 2021 20:24:29 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 3au6q8b7xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 20:24:28 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183KOQMg50528756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 20:24:26 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EEECC605A;
        Fri,  3 Sep 2021 20:24:26 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4DD0C6066;
        Fri,  3 Sep 2021 20:24:22 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  3 Sep 2021 20:24:22 +0000 (GMT)
Subject: Re: [RFC PATCH v2 07/12] i386/sev: populate secrets and cpuid page
 and finalize the SNP launch
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
 <20210826222627.3556-8-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <815caff2-6cf5-fef9-1493-c626d29d8cd2@linux.ibm.com>
Date:   Fri, 3 Sep 2021 23:24:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826222627.3556-8-michael.roth@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AYmqbcEC4ahMy3piHEO4mO70JZEUhH1w
X-Proofpoint-ORIG-GUID: u0e2hH545G6FvWKzOS9XFKe1eUv-BLqN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_07:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

On 27/08/2021 1:26, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> During the SNP guest launch sequence, a special secrets and cpuid page
> needs to be populated by the SEV-SNP firmware. 

Just to be clear: these are two distinct pages.  I suggest rephrasing to
"... a special secrets page and a special cpuid page need to be
populated ..." (or something along these lines).

> The secrets page contains
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
> present the call SNP_LAUNCH_UPDATE command to validate those address
> range without affecting the measurement. See the SEV-SNP specification
> for further details.
> 
> Finally, call the SNP_LAUNCH_FINISH to finalize the guest boot.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/sev.c        | 189 ++++++++++++++++++++++++++++++++++++++-
>  target/i386/trace-events |   2 +
>  2 files changed, 189 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 867c0cb457..0009c93d28 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -33,6 +33,7 @@
>  #include "monitor/monitor.h"
>  #include "exec/confidential-guest-support.h"
>  #include "hw/i386/pc.h"
> +#include "qemu/range.h"
>  
>  #define TYPE_SEV_COMMON "sev-common"
>  OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
> @@ -107,6 +108,19 @@ typedef struct __attribute__((__packed__)) SevInfoBlock {
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

Just curious: isn't secrets_len always 4096? (same for cpuid_len)
Though it might be a good future proofing to have a length field.


> +    /* CPUID page address */
> +    uint32_t cpuid_addr;
> +    uint32_t cpuid_len;
> +} SevSnpBootInfoBlock;
> +
>  static Error *sev_mig_blocker;
>  
>  static const char *const sev_fw_errlist[] = {
> @@ -1086,6 +1100,162 @@ static Notifier sev_machine_done_notify = {
>      .notify = sev_launch_get_measure,
>  };
>  
> +static int
> +sev_snp_launch_update_gpa(uint32_t hwaddr, uint32_t size, uint8_t type)
> +{
> +    void *hva;
> +    MemoryRegion *mr = NULL;
> +    SevSnpGuestState *sev_snp_guest =
> +        SEV_SNP_GUEST(MACHINE(qdev_get_machine())->cgs);
> +
> +    hva = gpa2hva(&mr, hwaddr, size, NULL);
> +    if (!hva) {
> +        error_report("SEV-SNP failed to get HVA for GPA 0x%x", hwaddr);
> +        return 1;
> +    }
> +
> +    return sev_snp_launch_update(sev_snp_guest, hwaddr, hva, size, type);
> +}
> +
> +static bool
> +detect_first_overlap(uint64_t start, uint64_t end, Range *range_list,
> +                     size_t range_count, Range *overlap_range)
> +{
> +    int i;
> +    bool overlap = false;
> +    Range new;
> +
> +    assert(overlap_range);

Also:
assert(end >= start)
assert(range_count == 0 || range_list)

> +    range_make_empty(overlap_range);
> +    range_init_nofail(&new, start, end - start + 1);
> +
> +    for (i = 0; i < range_count; i++) {
> +        if (range_overlaps_range(&new, &range_list[i]) &&
> +            (range_is_empty(overlap_range) ||
> +             range_lob(&range_list[i]) < range_lob(overlap_range))) {
> +            *overlap_range = range_list[i];
> +            overlap = true;
> +        }
> +    }
> +
> +    return overlap;
> +}
> +
> +static void snp_ovmf_boot_block_setup(void)
> +{
> +    SevSnpBootInfoBlock *info;
> +    uint32_t start, end, sz;
> +    int ret;
> +    Range validated_ranges[2];
> +
> +    /*
> +     * Extract the SNP boot block for the SEV-SNP guests by locating the
> +     * SNP_BOOT GUID. The boot block contains the information such as location
> +     * of secrets and CPUID page, additionaly it may contain the range of
> +     * memory that need to be pre-validated for the boot.
> +     */
> +    if (!pc_system_ovmf_table_find(SEV_SNP_BOOT_BLOCK_GUID,
> +        (uint8_t **)&info, NULL)) {

Fix indent of arguments.


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
> +    range_init_nofail(&validated_ranges[0], info->secrets_addr, info->secrets_len);
> +    range_init_nofail(&validated_ranges[1], info->cpuid_addr, info->cpuid_len);
> +    start = info->pre_validated_start;
> +    end = info->pre_validated_end;
> +
> +    while (start < end) {
> +        Range overlap_range;
> +
> +        /* Check if the requested range overlaps with Secrets and CPUID page */
> +        if (detect_first_overlap(start, end, validated_ranges, 2,

Replace the literal 2 with ARRAY_SIZE(validated_ranges).


> +                                 &overlap_range)) {
> +            if (start < range_lob(&overlap_range)) {
> +                sz = range_lob(&overlap_range) - start;
> +                if (sev_snp_launch_update_gpa(start, sz,
> +                    KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {

Fix indent of arguments (if possible).

> +                    error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
> +                                 start, sz);
> +                    exit(1);
> +                }
> +            }
> +
> +            start = range_upb(&overlap_range) + 1;
> +            continue;
> +        }
> +
> +        /* Validate the remaining range */
> +        if (sev_snp_launch_update_gpa(start, end - start,

I think the second argument should be:    end - start + 1 .

Consider start=0x8000 end=0x8fff (inclusive). In this case you want to
validate exactly 0x1000 bytes starting at 0x8000.  So the size should be
0x8fff - 0x8000 + 1.

I assume all this doesn't matter for the underlying calls which operate
at whole pages anyway (are there proper asserts in sev_snp_launch_update
(or in KVM) that verify that start and sz are page-size-aligned?)



> +            KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {

Fix indent of arguments.


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
> +sev_snp_launch_finish(SevSnpGuestState *sev_snp)
> +{
> +    int ret, error;
> +    Error *local_err = NULL;
> +    struct kvm_sev_snp_launch_finish *finish = &sev_snp->kvm_finish_conf;
> +
> +    trace_kvm_sev_snp_launch_finish();
> +    ret = sev_ioctl(SEV_COMMON(sev_snp)->sev_fd, KVM_SEV_SNP_LAUNCH_FINISH, finish, &error);
> +    if (ret) {
> +        error_report("%s: SNP_LAUNCH_FINISH ret=%d fw_error=%d '%s'",
> +                     __func__, ret, error, fw_error_to_str(error));
> +        exit(1);
> +    }
> +
> +    sev_set_guest_state(SEV_COMMON(sev_snp), SEV_STATE_RUNNING);
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
>  sev_launch_finish(SevGuestState *sev_guest)
>  {
> @@ -1121,7 +1291,12 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
>  
>      if (running) {
>          if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
> -            sev_launch_finish(SEV_GUEST(sev_common));
> +            if (sev_snp_enabled()) {
> +                snp_ovmf_boot_block_setup();
> +                sev_snp_launch_finish(SEV_SNP_GUEST(sev_common));
> +            } else {
> +                sev_launch_finish(SEV_GUEST(sev_common));
> +            }
>          }
>      }
>  }
> @@ -1236,7 +1411,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
>      qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
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

In this trace format string you use the notation A+B to indicate addr=A
 len=B.  But for the pre-validated range the arguments are 'start' and
'end' (and not 'addr' and 'len'), so I suggest choosing a different
notation to log that range.

-Dov
