Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4901745E3F
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjGCOMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 10:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjGCOM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 10:12:27 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9475E5C;
        Mon,  3 Jul 2023 07:12:25 -0700 (PDT)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
        id 1qGKHs-0008Fl-00; Mon, 03 Jul 2023 16:12:20 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 6937BC02FD; Mon,  3 Jul 2023 16:08:53 +0200 (CEST)
Date:   Mon, 3 Jul 2023 16:08:53 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@gmail.com>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Subject: Re: [PATCH V2] MIPS: KVM: Fix NULL pointer dereference
Message-ID: <20230703140853.GA16247@alpha.franken.de>
References: <20230628110817.3167337-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230628110817.3167337-1-chenhuacai@loongson.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 07:08:17PM +0800, Huacai Chen wrote:
> After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support") we
> get a NULL pointer dereference when creating a KVM guest:
> 
> [  146.243409] Starting KVM with MIPS VZ extensions
> [  149.849151] CPU 3 Unable to handle kernel paging request at virtual address 0000000000000300, epc == ffffffffc06356ec, ra == ffffffffc063568c
> [  149.849177] Oops[#1]:
> [  149.849182] CPU: 3 PID: 2265 Comm: qemu-system-mip Not tainted 6.4.0-rc3+ #1671
> [  149.849188] Hardware name: THTF CX TL630 Series/THTF-LS3A4000-7A1000-ML4A, BIOS KL4.1F.TF.D.166.201225.R 12/25/2020
> [  149.849192] $ 0   : 0000000000000000 000000007400cce0 0000000000400004 ffffffff8119c740
> [  149.849209] $ 4   : 000000007400cce1 000000007400cce1 0000000000000000 0000000000000000
> [  149.849221] $ 8   : 000000240058bb36 ffffffff81421ac0 0000000000000000 0000000000400dc0
> [  149.849233] $12   : 9800000102a07cc8 ffffffff80e40e38 0000000000000001 0000000000400dc0
> [  149.849245] $16   : 0000000000000000 9800000106cd0000 9800000106cd0000 9800000100cce000
> [  149.849257] $20   : ffffffffc0632b28 ffffffffc05b31b0 9800000100ccca00 0000000000400000
> [  149.849269] $24   : 9800000106cd09ce ffffffff802f69d0
> [  149.849281] $28   : 9800000102a04000 9800000102a07cd0 98000001106a8000 ffffffffc063568c
> [  149.849293] Hi    : 00000335b2111e66
> [  149.849295] Lo    : 6668d90061ae0ae9
> [  149.849298] epc   : ffffffffc06356ec kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
> [  149.849324] ra    : ffffffffc063568c kvm_vz_vcpu_setup+0x64/0x328 [kvm]
> [  149.849336] Status: 7400cce3 KX SX UX KERNEL EXL IE
> [  149.849351] Cause : 1000000c (ExcCode 03)
> [  149.849354] BadVA : 0000000000000300
> [  149.849357] PrId  : 0014c004 (ICT Loongson-3)
> [  149.849360] Modules linked in: kvm nfnetlink_queue nfnetlink_log nfnetlink fuse sha256_generic libsha256 cfg80211 rfkill binfmt_misc vfat fat snd_hda_codec_hdmi input_leds led_class snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core snd_pcm snd_timer snd serio_raw xhci_pci radeon drm_suballoc_helper drm_display_helper xhci_hcd ip_tables x_tables
> [  149.849432] Process qemu-system-mip (pid: 2265, threadinfo=00000000ae2982d2, task=0000000038e09ad4, tls=000000ffeba16030)
> [  149.849439] Stack : 9800000000000003 9800000100ccca00 9800000100ccc000 ffffffffc062cef4
> [  149.849453]         9800000102a07d18 c89b63a7ab338e00 0000000000000000 ffffffff811a0000
> [  149.849465]         0000000000000000 9800000106cd0000 ffffffff80e59938 98000001106a8920
> [  149.849476]         ffffffff80e57f30 ffffffffc062854c ffffffff811a0000 9800000102bf4240
> [  149.849488]         ffffffffc05b0000 ffffffff80e3a798 000000ff78000000 000000ff78000010
> [  149.849500]         0000000000000255 98000001021f7de0 98000001023f0078 ffffffff81434000
> [  149.849511]         0000000000000000 0000000000000000 9800000102ae0000 980000025e92ae28
> [  149.849523]         0000000000000000 c89b63a7ab338e00 0000000000000001 ffffffff8119dce0
> [  149.849535]         000000ff78000010 ffffffff804f3d3c 9800000102a07eb0 0000000000000255
> [  149.849546]         0000000000000000 ffffffff8049460c 000000ff78000010 0000000000000255
> [  149.849558]         ...
> [  149.849565] Call Trace:
> [  149.849567] [<ffffffffc06356ec>] kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
> [  149.849586] [<ffffffffc062cef4>] kvm_arch_vcpu_create+0x184/0x228 [kvm]
> [  149.849605] [<ffffffffc062854c>] kvm_vm_ioctl+0x64c/0xf28 [kvm]
> [  149.849623] [<ffffffff805209c0>] sys_ioctl+0xc8/0x118
> [  149.849631] [<ffffffff80219eb0>] syscall_common+0x34/0x58
> 
> The root cause is the deletion of kvm_mips_commpage_init() leaves vcpu
> ->arch.cop0 NULL. So fix it by making cop0 from a pointer to an embedded
> object.
> 
> Fixes: 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")
> Cc: stable@vger.kernel.org
> Reported-by: Yu Zhao <yuzhao@google.com>
> Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> V2: Update commit message and add Reported-by/Reviewed-by.
> 
>  arch/mips/include/asm/kvm_host.h |  6 +++---
>  arch/mips/kvm/emulate.c          | 22 +++++++++++-----------
>  arch/mips/kvm/mips.c             | 16 ++++++++--------
>  arch/mips/kvm/trace.h            |  8 ++++----
>  arch/mips/kvm/vz.c               | 20 ++++++++++----------
>  5 files changed, 36 insertions(+), 36 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
