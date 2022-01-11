Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB9C48A939
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 09:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiAKIUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 03:20:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233700AbiAKIUi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 03:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641889238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCO6vPBy6jZvJ/apBaDhWh4U75qH/6OkzhJvoEEWmXM=;
        b=NlpuWhrz5aUiEdzCv7al64lSa76DC4pHmYgaTUBCyOjVyTtTk/qyIkUqAo3A+CZTvMWUU6
        aLgd5YcvlyVL9anS7lVQWx7TBU+8wc6bn7E+v26pnlQ5pnxds1pln/7zOps1ZSwqwB2rib
        oSmdmeFY+VFfyln+PgwkKi68+TtHPl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-DxwaTWFePZydVvaek4eJhg-1; Tue, 11 Jan 2022 03:20:34 -0500
X-MC-Unique: DxwaTWFePZydVvaek4eJhg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 031D7343CA;
        Tue, 11 Jan 2022 08:20:33 +0000 (UTC)
Received: from lacos-laptop-7.usersys.redhat.com (unknown [10.39.192.140])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C8DF7AB40;
        Tue, 11 Jan 2022 08:19:54 +0000 (UTC)
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, seanjc@google.com, erdemaktas@google.com,
        kvm@vger.kernel.org, isaku.yamahata@intel.com,
        "Min M . Xu" <min.m.xu@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
 <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
 <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
 <20220110110120.ldjekirdzgmgex4z@sirius.home.kraxel.org>
 <0771d5e3-c1b8-c3ad-3f3c-f117dfcc4d13@intel.com>
From:   Laszlo Ersek <lersek@redhat.com>
Message-ID: <92b8e17f-802f-bcfc-e937-3c4712cc9cfb@redhat.com>
Date:   Tue, 11 Jan 2022 09:19:53 +0100
MIME-Version: 1.0
In-Reply-To: <0771d5e3-c1b8-c3ad-3f3c-f117dfcc4d13@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/22 13:09, Xiaoyao Li wrote:
> On 1/10/2022 7:01 PM, Gerd Hoffmann wrote:
>>>> If you go without pflash, then you likely will not have a
>>>> standards-conformant UEFI variable store. (Unless you reimplement
>>>> the variable arch protocols in edk2 on top of something else than
>>>> the Fault Tolerant Write and Firmware Volume Block protocols.)
>>>> Whether a conformant UEFI varstore matters to you (or to TDX in
>>>> general) is something I can't comment on.
>>>
>>> Thanks for your reply! Laszlo
>>>
>>> regarding "standards-conformant UEFI variable store", I guess you
>>> mean the
>>> change to UEFI non-volatile variables needs to be synced back to the
>>> OVMF_VARS.fd file. right?
>>
>> Yes.  UEFI variables are expected to be persistent, and syncing to
>> OVMF_VARS.fd handles that.
>
> Further question.
>
> Is it achieved via read-only memslot that when UEFI variable gets
> changed, it exits to QEMU with KVM_EXIT_MMIO due to read-only memslot
> so QEMU can sync the change to OVMF_VAR.fd?

Yes.

When the flash device is in "romd_mode", that's when a readonly KVM
memslot is used. In this case, the guest can read and execute from the
memory region in question, only writes trap to QEMU. Such a write
(WRITE_BYTE_CMD) is what the guest's flash driver uses to flip the flash
device out of "romd_mode".

When the flash device is not in "romd_mode", then no KVM memslot is used
at all, and both reads and writes trap to QEMU. Once the flash
programming is done, the guest's flash driver issues a particular write
command (READ_ARRAY_CMD) that flips the device back to "romd_mode" (and
then the readonly KVM memslot is re-established).

Here's a rough call tree (for the non-SMM case, updating a
non-authenticated non-volatile variable):

  VariableServiceSetVariable()                             [MdeModulePkg/Universal/Variable/RuntimeDxe/Variable.c]
    UpdateVariable()                                       [MdeModulePkg/Universal/Variable/RuntimeDxe/Variable.c]
      UpdateVariableStore()                                [MdeModulePkg/Universal/Variable/RuntimeDxe/Variable.c]
        FvbProtocolWrite()                                 [OvmfPkg/QemuFlashFvbServicesRuntimeDxe/FwBlockService.c]
          QemuFlashWrite()                                 [OvmfPkg/QemuFlashFvbServicesRuntimeDxe/QemuFlash.c]

            QemuFlashPtrWrite (WRITE_BYTE_CMD /* 0x10 */)
               QEMU:
                pflash_write()                             [hw/block/pflash_cfi01.c]
                  (wcycle == 0)
                  memory_region_rom_device_set_romd(false) [softmmu/memory.c]
                    ...
                      kvm_region_del()                     [accel/kvm/kvm-all.c]
                        kvm_set_phys_mem(false)            [accel/kvm/kvm-all.c]
                          /* unregister the slot */

                  /* Single Byte Program */
                  wcycle++

            QemuFlashPtrWrite (Buffer[Loop])
              QEMU:
                pflash_write()                             [hw/block/pflash_cfi01.c]
                  (wcycle == 1)
                  /* Single Byte Program */
                  pflash_data_write()                      [hw/block/pflash_cfi01.c]
                  pflash_update()                          [hw/block/pflash_cfi01.c]
                    blk_pwrite()                           [block/block-backend.c]
                  wcycle = 0

            QemuFlashPtrWrite (READ_ARRAY_CMD /* 0xff */)
              QEMU:
                pflash_write()                             [hw/block/pflash_cfi01.c]
                  (wcycle == 0)
                  memory_region_rom_device_set_romd(false) [softmmu/memory.c]
                    /* no actual change */
                  /* Read Array */
                  memory_region_rom_device_set_romd(true)  [softmmu/memory.c]
                    kvm_region_add()                       [accel/kvm/kvm-all.c]
                      kvm_set_phys_mem(true)               [accel/kvm/kvm-all.c]
                        /* register the new slot */
                        kvm_mem_flags()                    [accel/kvm/kvm-all.c]
                          ... memory_region_is_romd() ...  [include/exec/memory.h]
                          flags |= KVM_MEM_READONLY

Thanks
Laszlo

