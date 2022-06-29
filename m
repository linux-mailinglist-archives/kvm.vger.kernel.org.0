Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCCC55F891
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 09:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiF2HK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 03:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiF2HK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 03:10:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31C34D13C
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 00:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656486654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZvTx60T8SrTvLjjgPn5MiyZZGW9roiM/MTUblQZ6zA=;
        b=di85NQUnrn1ASt+46msL4NaCendNJu9nchjP8JYkNuMPuT4xMU9oEcYMsJvt5Bf4Vbln52
        qcQ1cbd9F2/c5rjldmLPaPi27jxpzoEjYk/zxn9fF2hGyK5XgOpmB1y89B0NT9r4I42TrS
        8HjJJCfZi3ifUqNZisJIY5+0pwO9DUs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-NNyunGPaP-O5AT3EUPdIkQ-1; Wed, 29 Jun 2022 03:10:52 -0400
X-MC-Unique: NNyunGPaP-O5AT3EUPdIkQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF9EA380114B;
        Wed, 29 Jun 2022 07:10:51 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A099240F06D;
        Wed, 29 Jun 2022 07:10:49 +0000 (UTC)
Message-ID: <a7aaa76a415859d152cee83d6f59c254fbeb8fb8.camel@redhat.com>
Subject: Re: [PATCH v6 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 29 Jun 2022 10:10:48 +0300
In-Reply-To: <63f6419c-6411-af7f-1ce3-bf3cf09e99e3@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
         <84d30ead-7c8e-1f81-aa43-8a959e3ae7d0@amd.com>
         <a5fe4ca7a412c7e4970d7c0d48b17cefcd91833c.camel@redhat.com>
         <63f6419c-6411-af7f-1ce3-bf3cf09e99e3@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 23:34 +0700, Suthikulpanit, Suravee wrote:
> Maxim,
> 
> On 6/28/2022 8:43 PM, Maxim Levitsky wrote:
> > > With the commit 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base"),
> > > APICV/AVIC is now inhibit when the guest kernel boots w/ option "nox2apic" or "x2apic_phys"
> > > due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
> > > 
> > > These cases used to work. In theory, we should be able to allow AVIC works in this case.
> > > Is there a way to modify logic in kvm_lapic_xapic_id_updated() to allow these use cases
> > > to work w/ APICv/AVIC?
> > > 
> > > Best Regards,
> > > Suravee
> > > 
> > This seems very strange, I assume you test the kvm/queue of today,
> 
> Yes
> 
> > which contains a fix for a typo I had in the list of inhibit reasons
> > (commit 5bdae49fc2f689b5f896b54bd9230425d3643dab - KVM: SEV: fix misplaced closing parenthesis)
> 
> Yes
> 
> > Could you share more details on the test? How many vCPUs in the guest, is x2apic exposed to the guest?
> 
> With the problem happens w/ 257 vCPUs or more (i.e. vcpu ID 0x100).
> 
> > Looking through the code the the __x2apic_disable, touches the MSR_IA32_APICBASE so I would expect
> > the APICV_INHIBIT_REASON_APIC_BASE_MODIFIED inhibit to be triggered and not APICV_INHIBIT_REASON_APIC_ID_MODIFIED
> > 
> > 
> > I don't see yet how the x2apic_phys can trigger these inhibits.
> 
> When I add WARN_ON_ONCE at the point when we set the APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
> I get this call stack.

Great, thanks for the info, now it all clear.

For > 255 vCPUs, it is not possible to have APIC_ID == vcpu_id, thus the check kvm_lapic_xapic_id_updated
should truncate the vcpu_id to 8 bit.

I'll send a patch to fix this, very soon.

In addition to that later we should check that both AVIC (I think it doesn't crash) and APICv doesn't crash in this case
(when a guest still attempts to enable APIC on vCPU > 254 (255 also can't be used for regular apic)).

Thanks,
Best regards,
	Maxim Levitsky

> 
>   11 [  105.470685] ------------[ cut here ]------------
>   12 [  105.470686] WARNING: CPU: 279 PID: 11511 at arch/x86/kvm/lapic.c:2057 kvm_lapic_xapic_id_updated.cold+0x13/0x2f [kvm]
>   13 [  105.470769] Modules linked in: kvm_amd kvm irqbypass nf_tables nfnetlink bridge stp llc squashfs loop vfat fat dm_multipath intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd wmi_bmof sg ipmi_ssif dm_mod acpi_ipmi ccp k10temp ipmi_si acpi_cpufreq sch_fq_codel ipmi_devintf ipmi_msghandler fuse ip_tables ext4 mbcache jbd2 btrfs blake2b_generic zstd_compress raid10 raid456 async_raid6_recov async_memcpy as    ync_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 linear ast 
> i2c_algo_bit drm_vram_helper drm_ttm_helper ttm crct10dif_pclmul crc32_pclmul ses crc32c_intel drm_kms_helper enclosure ghash_clmulni_intel nvme sd_mod scsi_transport_sas syscopyarea aesni_intel sysfillrect crypto_simd nvme_core sysimgblt cryptd t10_pi fb_sys_fops tg3 uas crc64_rocksoft_generic i2c_designware_platform ptp crc64_rocksoft drm     i2c_piix4 i2c_designware_core usb_storage pps_core crc64 wmi pinctrl_amd i2c_core
>   14 [  105.470851] CPU: 279 PID: 11511 Comm: qemu-system-x86 Kdump: loaded Not tainted 5.19.0-rc1-kvm-queue-x2avic+ #38
>   15 [  105.470856] Hardware name: AMD Corporation QUARTZ/QUARTZ, BIOS TQZ0080D 05/11/2022
>   16 [  105.470858] RIP: 0010:kvm_lapic_xapic_id_updated.cold+0x13/0x2f [kvm]
>   17 [  105.470906] Code: db 8f fd ff 48 c7 c7 8d e8 ca c0 e8 43 27 88 ce 31 c0 e9 f8 90 fd ff 48 c7 c6 00 6a ca c0 48 c7 c7 e5 e8 ca c0 e8 29 27 88 ce <0f> 0b 48 8b 83 90 00 00 00 ba 01 00 00 00 be 04 00 00 00 5b 48 8b
>   18 [  105.470909] RSP: 0018:ffffb13a436d7d40 EFLAGS: 00010246
>   19 [  105.470913] RAX: 0000000000000030 RBX: ffff9f0372c98400 RCX: 0000000000000000
>   20 [  105.470916] RDX: 0000000000000000 RSI: ffffffff8fd59e05 RDI: 00000000ffffffff
>   21 [  105.470918] RBP: ffffb13a436d7e40 R08: 0000000000000030 R09: 0000000000000002
>   22 [  105.470920] R10: 000000000000000f R11: ffff9f21c5c2fc80 R12: ffff9f0372c64250
>   23 [  105.470921] R13: ffff9f0372c64250 R14: 00007f9ac9ffa2f0 R15: ffff9f0344da7000
>   24 [  105.470930] FS:  00007f9ac9ffb640(0000) GS:ffff9f118edc0000(0000) knlGS:0000000000000000
>   25 [  105.470932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   26 [  105.470934] CR2: 00007fa34c73c001 CR3: 00000001b71a2003 CR4: 0000000000770ee0
>   27 [  105.470936] PKRU: 55555554
>   28 [  105.470938] Call Trace:
>   29 [  105.470942]  <TASK>
>   30 [  105.470945]  kvm_apic_state_fixup+0x85/0xb0 [kvm]
>   31 [  105.471002]  kvm_arch_vcpu_ioctl+0xa01/0x14b0 [kvm]
>   32 [  105.471080]  ? __local_bh_enable_ip+0x37/0x70
>   33 [  105.471088]  ? copy_fpstate_to_sigframe+0x2f6/0x360
>   34 [  105.471099]  ? mod_objcg_state+0xd2/0x360
>   35 [  105.471109]  ? refill_obj_stock+0xb0/0x160
>   36 [  105.471116]  ? kvm_vcpu_ioctl+0x4bc/0x680 [kvm]
>   37 [  105.471156]  kvm_vcpu_ioctl+0x4bc/0x680 [kvm]
>   38 [  105.471197]  __x64_sys_ioctl+0x83/0xb0
>   39 [  105.471206]  do_syscall_64+0x3b/0x90
>   40 [  105.471218]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>   41 [  105.471228] RIP: 0033:0x7fa356d19a2b
>   42 [  105.471232] Code: ff ff ff 85 c0 79 8b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 f3 0f 00 f7 d8 64 89 01 48
>   43 [  105.471235] RSP: 002b:00007f9ac9ffa248 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>   44 [  105.471240] RAX: ffffffffffffffda RBX: 000000008400ae8e RCX: 00007fa356d19a2b
>   45 [  105.471243] RDX: 00007f9ac9ffa2f0 RSI: ffffffff8400ae8e RDI: 000000000000010c
>   46 [  105.471245] RBP: 0000561ce47ee560 R08: 0000561ce2351954 R09: 0000561ce2351c5c
>   47 [  105.471248] R10: 00007f9ab80037b0 R11: 0000000000000246 R12: 00007f9ac9ffa2f0
>   48 [  105.471266] R13: 00007f9ab80037b0 R14: fff0000000000000 R15: 00007f9ac97fb000
>   49 [  105.471270]  </TASK>
>   50 [  105.471272] ---[ end trace 0000000000000000 ]---
> 
> Best Regards,
> Suravee
> 


