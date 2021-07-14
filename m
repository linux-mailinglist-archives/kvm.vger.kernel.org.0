Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034D93C89D3
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhGNRco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 13:32:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhGNRco (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Jul 2021 13:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626283792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J4aFB/uKxXnBXjUlGHEb9ojkf1Pfaznz71pZk8uYwNQ=;
        b=LOrkYAaEXhMZXlKc5OlmKMNj4mMMSCip77ypuuQaad1zS1ds5DkAGqolBjOb2a8MXAK6B9
        in2XvUUFMW0VBz6cuHX7pRoZYV2FXzD12NZR95XJh43+MW8OfHG8tWcXNcKb2OZVsRnJ4p
        O0VQLQEPEp9Ul7UzvgBV0n54GbyJGKo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-vHdoSHRdNle49XM0XDsHBQ-1; Wed, 14 Jul 2021 13:29:50 -0400
X-MC-Unique: vHdoSHRdNle49XM0XDsHBQ-1
Received: by mail-wm1-f70.google.com with SMTP id m40-20020a05600c3b28b02901f42375a73fso1075424wms.5
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 10:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J4aFB/uKxXnBXjUlGHEb9ojkf1Pfaznz71pZk8uYwNQ=;
        b=MfIwoLW+bViiubRkRyJGPyHvE5Md7WxQ5okDuq33QfXJ7qmaD/1Vk0BbMPjRxQiHgq
         61cvZSvXkx4iKF59HshFs5MPjAuv5H8LkBKvZ9az+77D/JnEgJPQPkPxWYTEIYUETutS
         ybJ8/NbNU23DFa2eXLwHEWIYL8wmtxFi/5gSDr0BABcdHOi7TWyKeLX5DiJNU6+nm6fL
         PejbrAvFdKNcwBFqEI34SUOtNH2lsrGbmx4dPvOjzPwasvfPBD81H8UlvyZ8kinXOiRZ
         obzbxwiE/7/YBfc3kubOoTEii2JOMWqM9x7c5gfTGQcRZaBIqWL5NUr69O+7ZgROIr5o
         Iibw==
X-Gm-Message-State: AOAM5327Z+1froIkLTm4Na/DAvBIIrWLhxkvDaCjubuAKvNo2OqaDY6k
        vtbzOCK8oTrxoMAFiXEecLq32TK/RYJADE1oUsHoKz/tsCmI6aAsofMqqp/mCFzcK9epGC6Euzr
        zqm8eV/OwU2CM
X-Received: by 2002:a7b:c083:: with SMTP id r3mr12485371wmh.97.1626283784450;
        Wed, 14 Jul 2021 10:29:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHRHFYlvAYhUza8YqsNpBHhmiuMHvMTvGHGnw+Rd2d+3Jjj5qRStlJOhoaHQ3r4aJmVGskZw==
X-Received: by 2002:a7b:c083:: with SMTP id r3mr12485352wmh.97.1626283784199;
        Wed, 14 Jul 2021 10:29:44 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id p2sm2715589wma.27.2021.07.14.10.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 10:29:43 -0700 (PDT)
Date:   Wed, 14 Jul 2021 18:29:40 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 6/6] i386/sev: populate secrets and cpuid page and
 finalize the SNP launch
Message-ID: <YO8fBDve7yOP4BZi@work-vm>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-7-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709215550.32496-7-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
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

Just a thought, but maybe use a 'Range' from include/qemu/range.h ?

Dave

> +static struct snp_pre_validated_range pre_validated[2];
> +
> +static bool
> +detectoverlap(uint32_t start, uint32_t end,
> +              struct snp_pre_validated_range *overlap)
> +{
> +    int i;
> +
> +    for (i = 0; i < ARRAY_SIZE(pre_validated); i++) {
> +        if (pre_validated[i].start < end && start < pre_validated[i].end) {
> +            memcpy(overlap, &pre_validated[i], sizeof(*overlap));
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
> -- 
> 2.17.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

