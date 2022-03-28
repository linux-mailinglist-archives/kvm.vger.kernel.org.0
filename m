Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68C14E919F
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 11:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiC1JoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 05:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbiC1JoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 05:44:09 -0400
Received: from nksmu.kylinos.cn (mailgw.kylinos.cn [123.150.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1601A13D70
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 02:42:27 -0700 (PDT)
X-UUID: b6a0ff8252da446992cfca6a1374c7c5-20220328
X-UUID: b6a0ff8252da446992cfca6a1374c7c5-20220328
Received: from cs2c.com.cn [(172.17.111.24)] by nksmu.kylinos.cn
        (envelope-from <liucong2@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 368360695; Mon, 28 Mar 2022 17:41:30 +0800
X-ns-mid: postfix-624182FC-5984937277
Received: from [172.20.12.219] (unknown [172.20.12.219])
        by cs2c.com.cn (NSMail) with ESMTPSA id 77B993848661;
        Mon, 28 Mar 2022 09:42:20 +0000 (UTC)
Message-ID: <de27054a-900b-d1fc-69be-82cb6c893c44@kylinos.cn>
Date:   Mon, 28 Mar 2022 17:41:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] kvm/arm64: Fix memory section did not set to kvm
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <mw2ty4ijin-mw2ty4ijio@nsmail6.0>
 <CAFEAcA_xpi2kCdHK-K=T3-pbHjWS47xyCzG47wg3HBSKFo4z8w@mail.gmail.com>
From:   Cong Liu <liucong2@kylinos.cn>
In-Reply-To: <CAFEAcA_xpi2kCdHK-K=T3-pbHjWS47xyCzG47wg3HBSKFo4z8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/3/25 23:00, Peter Maydell wrote:
> On Fri, 25 Mar 2022 at 14:42, <liucong2@kylinos.cn> wrote:
>> I found this issue on qmeu 4.2 with host linux 4.19, I want to
>> use qxl on arm64. on arm64, default page size is 64k, and the
>> qxl_rom_size is fixed 8192.
> 
> OK, so the fix to this is "use a newer QEMU".
> 
>> but when I read qxl_rom region in guest, guest os stopped and
>> I can see error message "load/store instruction decodeing not
>> implemented" in host side. it is because qxl rom bar memory
>> region didn't commit to kvm.
> 
>> I only try qemu 6.0 rather than the latest version because
>>
>> I meet some compile issue. commit ce7015d9e8669e
>>
>> start v6.1.0-rc0, it will change the default qxl rom bar size
>> to 64k on my platform. then my problem disappear. but when
>> others create a memory region with the size less than one
>> page. when it run into kvm_align_section, it return 0
>> again.
> 
> This is correct behaviour. If the memory region is less than
> a complete host page then it is not possible for KVM to
> map it into the guest as directly accessible memory,
> because that can only be done in host-page sized chunks,
> and if the MR is a RAM region smaller than the page then
> there simply is not enough backing RAM there to map without
> incorrectly exposing to the guest whatever comes after the
> contents of the MR.

actually, even with fixed 8192 qxl rom bar size, the RAMBlock
size corresponding to MemoryRegion will also be 64k. so it can
map into the guest as directly accessible memory. now it failed
just because we use the wrong size. ROUND_UP(n, d) requires
that d be a power of 2, it is faster than QEMU_ALIGN_UP().
and the qemu_real_host_page_size should always a power of 2.
seems we can use this patch and no need to fall back to "treat
like MMIO device access".

> 
> For memory regions smaller than a page, KVM and QEMU will
> fall back to "treat like MMIO device access". As long as the
I don't understand how it works, can you help explain or tell me
which part of the code I should read to understand?

I add some test code on qemu 6.2.0, add a new bar(rom_test) in
qxl with 2048 bytes. it followed with qxl rom bar. in the guest
kernel, map rom_test bar and printf rom_test->magic and rom_test->id.
this mr with size of 2048 bytes will not commit to kvm but I
still read the content I write in qemu side. So it should be the 
mechanism you mentioned that took effect.

the test code appended.
it works with some differences between arm64 and x86. in x86, it
printf rom_test->magic and rom_test->id correctly, but in arm64.
it printf rom_test->magic correctly. when I try to print the
rom_test->id. I get "load/store instruction decoding not
implemented" error message.

> guest is using simple load/store instructions to access the
> memory region (ie loading or storing a single general
> purpose register with no writeback, no acquire/release
> semantics, no load-store exclusives) this will work fine.
> KVM will drop out to QEMU, which will do the load or store
> and return the data to KVM, which will simulate the instruction
> execution and resume the guest.
> 
> If you see the message about "load/store instruction
> decoding not implemented", that means the guest was trying
> to access the region with something other than a simple
> load/store. In this case you need to either:
>   (1) change the device model to use a page-sized memory region
>   (2) change the guest to use a simple load/store instruction
>       to access it
>
> Which of these is the right thing will depend on exactly
> what the device and memory region is.
> 
> thanks
> -- PMM


+static void init_qxl_rom_test(PCIQXLDevice *d)
+{
+    QXLRom_test *rom = memory_region_get_ram_ptr(&d->rom_bar_test);
+
+    memset(rom, 0, 2048);
+
+    rom->magic      = cpu_to_le32(SPICE_MAGIC_CONST("abcd"));
+    rom->id         = cpu_to_le32(SPICE_MAGIC_CONST("ABCD"));
+}
+
  static void init_qxl_rom(PCIQXLDevice *d)
  {
      QXLRom *rom = memory_region_get_ram_ptr(&d->rom_bar);
@@ -2113,7 +2123,10 @@ static void qxl_realize_common(PCIQXLDevice *qxl, 
Error **errp)
      qxl->rom_size = qxl_rom_size();
      memory_region_init_rom(&qxl->rom_bar, OBJECT(qxl), "qxl.vrom",
                             qxl->rom_size, &error_fatal);
+    memory_region_init_rom(&qxl->rom_bar_test, OBJECT(qxl), 
"qxl.vrom_test",
+                           2048, &error_fatal);
      init_qxl_rom(qxl);
+    init_qxl_rom_test(qxl);
      init_qxl_ram(qxl);

      qxl->guest_surfaces.cmds = g_new0(QXLPHYSICAL, qxl->ssd.num_surfaces);
@@ -2136,6 +2149,9 @@ static void qxl_realize_common(PCIQXLDevice *qxl, 
Error **errp)
      pci_register_bar(&qxl->pci, QXL_ROM_RANGE_INDEX,
                       PCI_BASE_ADDRESS_SPACE_MEMORY, &qxl->rom_bar);

+    pci_register_bar(&qxl->pci, 4,
+                     PCI_BASE_ADDRESS_SPACE_MEMORY, &qxl->rom_bar_test);
+
      pci_register_bar(&qxl->pci, QXL_RAM_RANGE_INDEX,
                       PCI_BASE_ADDRESS_SPACE_MEMORY, &qxl->vga.vram);

diff --git a/hw/display/qxl.h b/hw/display/qxl.h
index 30d21f4d0b..3690edf17b 100644
--- a/hw/display/qxl.h
+++ b/hw/display/qxl.h
@@ -100,6 +100,7 @@ struct PCIQXLDevice {
      QXLModes           *modes;
      uint32_t           rom_size;
      MemoryRegion       rom_bar;
+    MemoryRegion       rom_bar_test;
  #if SPICE_SERVER_VERSION >= 0x000c06 /* release 0.12.6 */
      uint16_t           max_outputs;
  #endif



Regards,
Cong.
