Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1209329972B
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 20:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793451AbgJZTkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 15:40:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1786270AbgJZTkU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 15:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603741218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lpnjO+j0owMSyjQB1uE/7UdTp3Y8ra4ZJKBoSrw2Up0=;
        b=CifMVqaPoRK7Za/9R2aThnsZyda7ysApWvlHRfkqUscqaU2/UMm7W7LGYgA/LlLRVjg9jy
        toyoVO9u/+m0KZQI+ZF65QcrI1b5pkIo0IaJvSYvsSh+cDqcD+FjIT0cgiWfCmssHIklTl
        PiiUvHGK7Vu5caP3ynQr++0PPS8sKAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-xu2zlgm-O2K-fuMDMhbPEA-1; Mon, 26 Oct 2020 15:40:13 -0400
X-MC-Unique: xu2zlgm-O2K-fuMDMhbPEA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BB9C804B66;
        Mon, 26 Oct 2020 19:40:11 +0000 (UTC)
Received: from ovpn-113-173.rdu2.redhat.com (ovpn-113-173.rdu2.redhat.com [10.10.113.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 939966EF40;
        Mon, 26 Oct 2020 19:40:09 +0000 (UTC)
Message-ID: <849d7acb00b3dadc3fc7db1e574c03dc74a06270.camel@redhat.com>
Subject: Re: [PATCH v6 2/4] KVM: x86: report negative values from wrmsr
 emulation to userspace
From:   Qian Cai <cai@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 26 Oct 2020 15:40:09 -0400
In-Reply-To: <20200922211025.175547-3-mlevitsk@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
         <20200922211025.175547-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-09-23 at 00:10 +0300, Maxim Levitsky wrote:
> This will allow the KVM to report such errors (e.g -ENOMEM)
> to the userspace.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reverting this and its dependency:

72f211ecaa80 KVM: x86: allow kvm_x86_ops.set_efer to return an error value

on the top of linux-next (they have also unfortunately merged into the mainline
at the same time) fixed an issue that a simple Intel KVM guest is unable to boot
below.

.config: http://people.redhat.com/qcai/x86.config

qemu-kvm-4.2.0-34.module+el8.3.0+7976+077be4ec.x86_64

# /usr/libexec/qemu-kvm -name ubuntu-20.04-server-cloudimg -cpu host -smp 2 -m 2g -hda ./ubuntu-20.04-server-cloudimg.qcow2 -cdrom ./ubuntu-20.04-server-cloudimg.iso  -nic user,hostfwd=tcp::2222-:22 -nographic

[    1.141022] evm: Initialising EVM extended attributes:
[    1.143344] evm: security.selinux
[    1.144968] evm: security.SMACK64
[    1.146574] evm: security.SMACK64EXEC
[    1.148305] evm: security.SMACK64TRANSMUTE
[    1.150215] evm: security.SMACK64MMAP
[    1.151960] evm: security.apparmor
[    1.153755] evm: security.ima
[    1.155454] evm: security.capability
[    1.155456] evm: HMAC attrs: 0x1
[    1.162331] ata1.00: ATA-7: QEMU HARDDISK, 2.5+, max UDMA/100
[    1.162635] PM:   Magic number: 8:937:635
[    1.165607] ata1.00: 2147483648 sectors, multi 16: LBA48 
[    1.169799] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2.5+ PQ: 0 ANSI: 5
[    1.174196] rtc_cmos 00:00: setting system clock to 2020-10-26T13:38:53 UTC (1603719533)
[    1.178237] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.178293] sd 0:0:0:0: [sda] 2147483648 512-byte logical blocks: (1.10 TB/1.00 TiB)
[    1.180567] ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    1.183986] sd 0:0:0:0: [sda] Write Protect is off
[error: kvm run failed No such file or directory
 RAX=0000000000000000 RBX=0000000000000000 RCX=0000000000000150 RDX=000000008000001c
RSI=0000000000000000 RDI=0000000000000150 RBP=ffffb67840083e40 RSP=ffffb67840083e00
R8 =ffff931dfda17608 R9 =0000000000000000 R10=ffff931dfda17848 R11=0000000000000000
R12=0000000000000000 R13=00000000000000b7 R14=ffff931dfd4013c0 R15=ffffffffaa8f48d0
RIP=ffffffffaa078894 RFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0000 0000000000000000 ffffffff 00c00000
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 0000000000000000 ffffffff 00c00000
GS =0000 ffff931dfda00000 ffffffff 00c00000
LDT=0000 0000000000000000 ffffffff 00c00000
TR =0040 fffffe0000003000 0000206f 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=0000000000000000 CR3=000000002960a001 CR4=00760ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000 
DR6=00000000fffe0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=dc 60 4e 00 4c 89 e0 41 5c 5d c3 0f 1f 44 00 00 89 f0 89 f9 <0f> 30 31 c0 0f 1f 44 00 00 c3 55 48 c1 e2 20 89 f6 48 09 d6 89 c2 48 89 e5 48 83 ec 08 89

> ---
>  arch/x86/kvm/emulate.c | 7 +++++--
>  arch/x86/kvm/x86.c     | 6 +++++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 1d450d7710d63..d855304f5a509 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3702,13 +3702,16 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
>  static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>  {
>  	u64 msr_data;
> +	int ret;
>  
>  	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
>  		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
> -	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
> +
> +	ret = ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data);
> +	if (ret > 0)
>  		return emulate_gp(ctxt, 0);
>  
> -	return X86EMUL_CONTINUE;
> +	return ret < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
>  }
>  
>  static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 063d70e736f7f..e4b07be450d4e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1612,8 +1612,12 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  {
>  	u32 ecx = kvm_rcx_read(vcpu);
>  	u64 data = kvm_read_edx_eax(vcpu);
> +	int ret = kvm_set_msr(vcpu, ecx, data);
>  
> -	if (kvm_set_msr(vcpu, ecx, data)) {
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret > 0) {
>  		trace_kvm_msr_write_ex(ecx, data);
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;

