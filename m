Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140DE1D281B
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgENGpM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 May 2020 02:45:12 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35602 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgENGpM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:45:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=teawaterz@linux.alibaba.com;NM=1;PH=DS;RN=41;SR=0;TI=SMTPD_---0TyVQ4ms_1589438698;
Received: from 30.30.201.163(mailfrom:teawaterz@linux.alibaba.com fp:SMTPD_---0TyVQ4ms_1589438698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 May 2020 14:45:00 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [virtio-dev] [PATCH v3 00/15] virtio-mem: paravirtualized memory
From:   teawater <teawaterz@linux.alibaba.com>
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
Date:   Thu, 14 May 2020 14:44:57 +0800
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7848642F-6AA7-4B5E-AE0E-DB0857C94A93@linux.alibaba.com>
References: <20200507103119.11219-1-david@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

I got a kernel warning with v2 and v3.
// start a QEMU that is get from https://github.com/davidhildenbrand/qemu/tree/virtio-mem-v2 and setup a file as a ide disk.
/home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc-i440fx-2.1,accel=kvm,usb=off -cpu host -no-reboot -nographic -device ide-hd,drive=hd -drive if=none,id=hd,file=/home/teawater/old.img,format=raw -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/sda nokaslr swiotlb=noforce" -m 1g,slots=10,maxmem=2G -smp 1 -s -monitor unix:/home/teawater/qemu/m,server,nowait

// Setup virtio-mem and plug 256m memory in qemu monitor:
object_add memory-backend-ram,id=mem1,size=256m
device_add virtio-mem-pci,id=vm0,memdev=mem1
qom-set vm0 requested-size 256M

// Go back to the terminal and access file system will got following kernel warning.
[   19.515549] pci 0000:00:04.0: [1af4:1015] type 00 class 0x00ff00
[   19.516227] pci 0000:00:04.0: reg 0x10: [io  0x0000-0x007f]
[   19.517196] pci 0000:00:04.0: BAR 0: assigned [io  0x1000-0x107f]
[   19.517843] virtio-pci 0000:00:04.0: enabling device (0000 -> 0001)
[   19.535957] PCI Interrupt Link [LNKD] enabled at IRQ 11
[   19.536507] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
[   19.537528] virtio_mem virtio0: start address: 0x100000000
[   19.538094] virtio_mem virtio0: region size: 0x10000000
[   19.538621] virtio_mem virtio0: device block size: 0x200000
[   19.539186] virtio_mem virtio0: memory block size: 0x8000000
[   19.539752] virtio_mem virtio0: subblock size: 0x400000
[   19.540357] virtio_mem virtio0: plugged size: 0x0
[   19.540834] virtio_mem virtio0: requested size: 0x0
[   20.170441] virtio_mem virtio0: plugged size: 0x0
[   20.170933] virtio_mem virtio0: requested size: 0x10000000
[   20.172247] Built 1 zonelists, mobility grouping on.  Total pages: 266012
[   20.172955] Policy zone: Normal

/ # ls
[   26.724565] ------------[ cut here ]------------
[   26.725047] ata_piix 0000:00:01.1: DMA addr 0x000000010fc14000+49152 overflow (mask ffffffff, bus limit 0).
[   26.726024] WARNING: CPU: 0 PID: 179 at /home/teawater/kernel/linux2/kernel/dma/direct.c:364 dma_direct_map_page+0x118/0x130
[   26.727141] Modules linked in:
[   26.727456] CPU: 0 PID: 179 Comm: ls Not tainted 5.6.0-rc5-next-20200311+ #9
[   26.728163] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[   26.729305] RIP: 0010:dma_direct_map_page+0x118/0x130
[   26.729825] Code: 8b 1f e8 3b 70 59 00 48 8d 4c 24 08 48 89 c6 4c 89 2c 24 4d 89 e1 49 89 e8 48 89 da 48 c7 c7 08 6c 34 82 31 c0 e8 d8 8e f7 ff <00
[   26.731683] RSP: 0000:ffffc90000213838 EFLAGS: 00010082
[   26.732205] RAX: 0000000000000000 RBX: ffff88803ebeb1b0 RCX: ffffffff82665148
[   26.732913] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 0000000000000046
[   26.733621] RBP: 000000000000c000 R08: 00000000000001df R09: 00000000000001df
[   26.734338] R10: 0000000000000000 R11: ffffc900002135a8 R12: 00000000ffffffff
[   26.735054] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88803d55f5b0
[   26.735772] FS:  00000000024e9880(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[   26.736579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.737162] CR2: 00000000005bfc7f CR3: 0000000107e12004 CR4: 0000000000360ef0
[   26.737879] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   26.738591] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   26.739307] Call Trace:
[   26.739564]  dma_direct_map_sg+0x64/0xb0
[   26.739969]  ? ata_scsi_write_same_xlat+0x350/0x350
[   26.740461]  ata_qc_issue+0x214/0x260
[   26.740839]  ata_scsi_queuecmd+0x16a/0x490
[   26.741255]  scsi_queue_rq+0x679/0xa60
[   26.741639]  blk_mq_dispatch_rq_list+0x90/0x510
[   26.742099]  ? elv_rb_del+0x1f/0x30
[   26.742456]  ? deadline_remove_request+0x6a/0xb0
[   26.742926]  blk_mq_do_dispatch_sched+0x78/0x100
[   26.743397]  blk_mq_sched_dispatch_requests+0xf9/0x170
[   26.743924]  __blk_mq_run_hw_queue+0x7e/0x130
[   26.744365]  __blk_mq_delay_run_hw_queue+0x107/0x150
[   26.744874]  blk_mq_run_hw_queue+0x61/0x100
[   26.745299]  blk_mq_sched_insert_requests+0x71/0x110
[   26.745798]  blk_mq_flush_plug_list+0x14b/0x210
[   26.746258]  blk_flush_plug_list+0xbf/0xe0
[   26.746675]  blk_finish_plug+0x27/0x40
[   26.747056]  read_pages+0x7c/0x190
[   26.747399]  __do_page_cache_readahead+0x19c/0x1b0
[   26.747886]  filemap_fault+0x54e/0x9a0
[   26.748268]  ? alloc_set_pte+0x102/0x610
[   26.748673]  ? walk_component+0x64/0x2e0
[   26.749072]  ? filemap_map_pages+0xfa/0x3f0
[   26.749498]  ext4_filemap_fault+0x2c/0x3b
[   26.749911]  __do_fault+0x38/0xb0
[   26.750251]  __handle_mm_fault+0xd2a/0x16d0
[   26.750678]  handle_mm_fault+0xe2/0x1f0
[   26.751069]  do_page_fault+0x250/0x590
[   26.751448]  async_page_fault+0x34/0x40
[   26.751841] RIP: 0033:0x5bfc7f
[   26.752155] Code: Bad RIP value.
[   26.752481] RSP: 002b:00007ffef0289cd8 EFLAGS: 00010246
[   26.752999] RAX: 0000000000000001 RBX: 00007ffef028af81 RCX: 00007ffef028af84
[   26.753715] RDX: 00007ffef0289e01 RSI: 00007ffef0289ea8 RDI: 0000000000000001
[   26.754424] RBP: 00000000000000ac R08: 0000000000000001 R09: 0000000000000006
[   26.755144] R10: 000000000089fc18 R11: 0000000000000246 R12: 00007ffef0289ea8
[   26.755853] R13: 000000000043a5f0 R14: 0000000000000000 R15: 0000000000000000
[   26.756560] ---[ end trace 23cc3e9021358587 ]---
[   26.778034] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.778690] ata2.00: failed command: READ DMA
[   26.779131] ata2.00: cmd c8/00:e8:92:ad:00/00:00:00:00:00/e0 tag 0 dma 118784 in
[   26.779131]          res 50/00:00:0a:80:03/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.780691] ata2.00: status: { DRDY }
[   26.781603] ata2.00: configured for MWDMA2
[   26.782034] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[   26.782958] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[   26.783646] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[   26.784321] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad 92 00 00 e8 00
[   26.785056] blk_update_request: I/O error, dev sda, sector 44434 op 0x0:(READ) flags 0x80700 phys_seg 3 prio class 0
[   26.786118] ata2: EH complete
[   26.810033] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.810690] ata2.00: failed command: READ DMA
[   26.811133] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.811133]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.812681] ata2.00: status: { DRDY }
[   26.813569] ata2.00: configured for MWDMA2
[   26.813992] ata2: EH complete
[   26.826031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.826687] ata2.00: failed command: READ DMA
[   26.827131] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.827131]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.828668] ata2.00: status: { DRDY }
[   26.829552] ata2.00: configured for MWDMA2
[   26.829972] ata2: EH complete
[   26.842030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.842686] ata2.00: failed command: READ DMA
[   26.843127] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.843127]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.844656] ata2.00: status: { DRDY }
[   26.845538] ata2.00: configured for MWDMA2
[   26.845961] ata2: EH complete
[   26.858030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.858690] ata2.00: failed command: READ DMA
[   26.859132] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.859132]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.860656] ata2.00: status: { DRDY }
[   26.861542] ata2.00: configured for MWDMA2
[   26.861960] ata2: EH complete
[   26.874030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.874693] ata2.00: failed command: READ DMA
[   26.875131] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.875131]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.876675] ata2.00: status: { DRDY }
[   26.877554] ata2.00: configured for MWDMA2
[   26.877976] ata2: EH complete
[   26.890030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.890655] ata2.00: failed command: READ DMA
[   26.891082] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.891082]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.892544] ata2.00: status: { DRDY }
[   26.893408] ata2.00: configured for MWDMA2
[   26.893812] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[   26.894698] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[   26.895356] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[   26.895993] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad fa 00 00 08 00
[   26.896693] blk_update_request: I/O error, dev sda, sector 44538 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   26.897668] ata2: EH complete
[   26.922032] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.922652] ata2.00: failed command: READ DMA
[   26.923080] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.923080]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.924538] ata2.00: status: { DRDY }
[   26.925404] ata2.00: configured for MWDMA2
[   26.925807] ata2: EH complete
[   26.938031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.938650] ata2.00: failed command: READ DMA
[   26.939076] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.939076]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.940529] ata2.00: status: { DRDY }
[   26.941391] ata2.00: configured for MWDMA2
[   26.941793] ata2: EH complete
[   26.954031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.954652] ata2.00: failed command: READ DMA
[   26.955079] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.955079]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.956536] ata2.00: status: { DRDY }
[   26.957400] ata2.00: configured for MWDMA2
[   26.957800] ata2: EH complete
[   26.970031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.970653] ata2.00: failed command: READ DMA
[   26.971079] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.971079]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.972536] ata2.00: status: { DRDY }
[   26.973402] ata2.00: configured for MWDMA2
[   26.973804] ata2: EH complete
[   26.986030] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.986654] ata2.00: failed command: READ DMA
[   26.987082] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   26.987082]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   26.988541] ata2.00: status: { DRDY }
[   26.989406] ata2.00: configured for MWDMA2
[   26.989807] ata2: EH complete
[   27.002031] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   27.002653] ata2.00: failed command: READ DMA
[   27.003083] ata2.00: cmd c8/00:08:fa:ad:00/00:00:00:00:00/e0 tag 0 dma 4096 in
[   27.003083]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
[   27.004541] ata2.00: status: { DRDY }
[   27.005404] ata2.00: configured for MWDMA2
[   27.005806] sd 1:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
[   27.006688] sd 1:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[   27.007346] sd 1:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command
[   27.007982] sd 1:0:0:0: [sda] tag#0 CDB: Read(10) 28 00 00 00 ad fa 00 00 08 00
[   27.008680] blk_update_request: I/O error, dev sda, sector 44538 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   27.009649] ata2: EH complete
Bus error

I cannot reproduce this warning with set file as nvdimm with following command.
sudo /home/teawater/qemu/qemu/x86_64-softmmu/qemu-system-x86_64 -machine pc,accel=kvm,kernel_irqchip,nvdimm -no-reboot -nographic -kernel /home/teawater/kernel/bk2/arch/x86/boot/bzImage -append "console=ttyS0 root=/dev/pmem0 swiotlb=noforce" -m 1g,slots=1,maxmem=2G -smp 1 -device nvdimm,id=nv0,memdev=mem0 -object memory-backend-file,id=mem0,mem-path=/home/teawater/old.img,size=268435456 -monitor unix:/home/teawater/qemu/m,server,nowait

Best,
Hui

> 2020年5月7日 18:31，David Hildenbrand <david@redhat.com> 写道：
> 
> This series is based on latest linux-next. The patches are located at:
>    https://github.com/davidhildenbrand/linux.git virtio-mem-v3
> 
> Patch #1 - #10 where contained in v2 and only contain minor modifications
> (mostly smaller fixes). The remaining patches are new and contain smaller
> optimizations.
> 
> Details about virtio-mem can be found in the cover letter of v2 [1]. A
> basic QEMU implementation was posted yesterday [2].
> 
> [1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
> [2] https://lkml.kernel.org/r/20200506094948.76388-1-david@redhat.com
> 
> v2 -> v3:
> - "virtio-mem: Paravirtualized memory hotplug"
> -- Include "linux/slab.h" to fix build issues
> -- Remember the "region_size", helpful for patch #11
> -- Minor simplifaction in virtio_mem_overlaps_range()
> -- Use notifier_from_errno() instead of notifier_to_errno() in notifier
> -- More reliable check for added memory when unloading the driver
> - "virtio-mem: Allow to specify an ACPI PXM as nid"
> -- Also print the nid
> - Added patch #11-#15
> 
> Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Cc: Samuel Ortiz <samuel.ortiz@intel.com>
> Cc: Robert Bradford <robert.bradford@intel.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> David Hildenbrand (15):
>  virtio-mem: Paravirtualized memory hotplug
>  virtio-mem: Allow to specify an ACPI PXM as nid
>  virtio-mem: Paravirtualized memory hotunplug part 1
>  virtio-mem: Paravirtualized memory hotunplug part 2
>  mm: Allow to offline unmovable PageOffline() pages via
>    MEM_GOING_OFFLINE
>  virtio-mem: Allow to offline partially unplugged memory blocks
>  mm/memory_hotplug: Introduce offline_and_remove_memory()
>  virtio-mem: Offline and remove completely unplugged memory blocks
>  virtio-mem: Better retry handling
>  MAINTAINERS: Add myself as virtio-mem maintainer
>  virtio-mem: Add parent resource for all added "System RAM"
>  virtio-mem: Drop manual check for already present memory
>  virtio-mem: Unplug subblocks right-to-left
>  virtio-mem: Use -ETXTBSY as error code if the device is busy
>  virtio-mem: Try to unplug the complete online memory block first
> 
> MAINTAINERS                     |    7 +
> drivers/acpi/numa/srat.c        |    1 +
> drivers/virtio/Kconfig          |   17 +
> drivers/virtio/Makefile         |    1 +
> drivers/virtio/virtio_mem.c     | 1962 +++++++++++++++++++++++++++++++
> include/linux/memory_hotplug.h  |    1 +
> include/linux/page-flags.h      |   10 +
> include/uapi/linux/virtio_ids.h |    1 +
> include/uapi/linux/virtio_mem.h |  208 ++++
> mm/memory_hotplug.c             |   81 +-
> mm/page_alloc.c                 |   26 +
> mm/page_isolation.c             |    9 +
> 12 files changed, 2314 insertions(+), 10 deletions(-)
> create mode 100644 drivers/virtio/virtio_mem.c
> create mode 100644 include/uapi/linux/virtio_mem.h
> 
> -- 
> 2.25.3
> 
> 
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org

