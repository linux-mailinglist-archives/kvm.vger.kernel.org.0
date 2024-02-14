Return-Path: <kvm+bounces-8696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7844985504A
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DBDF1C20A1D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 17:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BC785291;
	Wed, 14 Feb 2024 17:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="X5EoG8ES"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA916087B
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707931508; cv=none; b=kX7l2W93gjwIZ4Vp3CN2VpVJk6GoNEAg6Wj2eA2hIQmeWDAiYIpaNEVkrl7W1ezL42J544LlKxJNK7EKBVTL7N53EpLn8mpYvepE80cBV8OXfqMObeTlsOtdb1dTRSh0w3wNj2sDFv9TSgzSYHDY8P7fRibpamtFSJ41q7a5/js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707931508; c=relaxed/simple;
	bh=xnJEOXMyQ16q1CYxAU9GLzyR3RlfLbpHk5Ch3Z8TKjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V5njK4L59jF9R/a/rqRoKiBy3szfqRnUp4FiqfxWJK0f5R9qDhiJBmwhctz2Zp7GVP4SXcP4rUFAI5hjl/UU2aU2IXbJeVMnNYFk6owHDdbn8xsLb1tjCsS8hUNaQmtuY67EBroZHX60ZVCe70xrxAsHP0HskfbrIHyAsB2HsRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=X5EoG8ES; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1raIB8-001qlY-6B; Wed, 14 Feb 2024 17:32:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=zaoe2PuTPC0KEV5B2TYz6uYs4IPZhcFJ3jwNnqN39Lc=; b=X5EoG8ESHu02jq4MrnOK4a9jxU
	ooa9j69H1D5Yhvmml2rGzUziyjHcpjuUFyV3yKhFqjELT3mqOYQhGPCeImKwkWUBtminoFHyp9Dxw
	nozu/3fG0KrZ/MdnLgEf+5eu5vdJxTLKVZcRRolvvK8jPvsy2KaCoO/zrSb9yic+dNm2LjXeWqQJV
	Gn/3Hkc8dHubuyPZmiDoEt2Fl/wsGeh9cBM4Ms5kULJFPivKogEV3YjD8nXn1v0cj5r65s3BzHpfD
	HTB5LlRaBq9r0QIhOkP6caqbY/To/nXYdcKSVKtD/+vQ3N9C3+FAnNFwGPUGnOqwrYj0+0oFcUEjQ
	gtrA5A/w==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1raIB6-0006zN-TW; Wed, 14 Feb 2024 17:32:09 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1raIB1-009iNI-Ny; Wed, 14 Feb 2024 17:32:03 +0100
Message-ID: <2379a9bc-a679-4b96-831b-13ab6779189b@rbox.co>
Date: Wed, 14 Feb 2024 17:32:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] KVM: x86/xen: Inject vCPU upcall vector when local
 APIC is enabled
Content-Language: pl-PL, en-GB
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>
References: <6150a0a8c3d911c6c2ada23c0b9c8b35991bd235.camel@infradead.org>
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <6150a0a8c3d911c6c2ada23c0b9c8b35991bd235.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/24 20:00, David Woodhouse wrote:
> ...
> Astute reviewers may note that kvm_xen_inject_vcpu_vector() function has
> a WARN_ON_ONCE() in the case where kvm_irq_delivery_to_apic_fast() fails
> and returns false. In the case where the MSI is not delivered due to the
> local APIC being disabled, kvm_irq_delivery_to_apic_fast() still returns
> true but the value in *r is zero. So the WARN_ON_ONCE() remains correct,
> as that case should still never happen.

I'm curious about that WARN_ON_ONCE(). It seems that a small modification
to xen_shinfo_test is enough to trigger it.

--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -87,6 +87,8 @@ enum {
 
 #define EVTCHNSTAT_interdomain		2
 
+#define MAX_XAPIC_ID	0xff
+
 struct evtchn_send {
 	u32 port;
 };
@@ -425,6 +427,7 @@ static void *juggle_shinfo_state(void *arg)
 
 int main(int argc, char *argv[])
 {
+	struct kvm_vcpu *vcpus[MAX_XAPIC_ID + 3];
 	struct timespec min_ts, max_ts, vm_ts;
 	struct kvm_xen_hvm_attr evt_reset;
 	struct kvm_vm *vm;
@@ -445,7 +448,8 @@ int main(int argc, char *argv[])
 
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm = vm_create_with_vcpus(ARRAY_SIZE(vcpus), guest_code, vcpus);
+	vcpu = vcpus[0];
 
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -516,6 +520,12 @@ int main(int argc, char *argv[])
 	};
 	vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &pvclock);
 
+	struct kvm_xen_hvm_attr ua = {
+		.type = KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR,
+		.u.vector = EVTCHN_VECTOR,
+	};
+	vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &ua);
+
 	struct kvm_xen_hvm_attr vec = {
 		.type = KVM_XEN_ATTR_TYPE_UPCALL_VECTOR,
 		.u.vector = EVTCHN_VECTOR,

[   28.669825] ------------[ cut here ]------------
[   28.669831] WARNING: CPU: 5 PID: 1050 at arch/x86/kvm/xen.c:509 kvm_xen_inject_vcpu_vector.isra.0+0x50/0x60 [kvm]
[   28.669867] Modules linked in: 9p netfs qrtr sunrpc intel_rapl_msr intel_rapl_common kvm_intel kvm 9pnet_virtio 9pnet rapl pcspkr i2c_piix4 drm zram crct10dif_pclmul crc32_pclmul crc32c_intel ata_generic virtio_blk pata_acpi ghash_clmulni_intel serio_raw fuse qemu_fw_cfg virtio_console
[   28.669882] CPU: 5 PID: 1050 Comm: xen_shinfo_test Not tainted 6.8.0-rc2+ #6
[   28.669884] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
[   28.669885] RIP: 0010:kvm_xen_inject_vcpu_vector.isra.0+0x50/0x60 [kvm]
[   28.669911] Code: 08 48 8d 54 24 08 48 c7 44 24 0c 00 00 00 00 c7 44 24 1c 00 00 00 00 c6 44 24 10 01 e8 99 6d fd ff 84 c0 74 05 48 83 c4 20 c3 <0f> 0b 48 83 c4 20 c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
[   28.669912] RSP: 0018:ffffc90001323cb0 EFLAGS: 00010046
[   28.669914] RAX: 0000000000000000 RBX: ffffc900036c1000 RCX: ffffc90001323c2c
[   28.669915] RDX: 0000000000000004 RSI: ffffffff82630bb0 RDI: ffffffff82667eb6
[   28.669916] RBP: 0000000000000001 R08: ffffc90001323c70 R09: ffffc90001323c68
[   28.669916] R10: 0000000000000001 R11: 0000000000000000 R12: ffff888107b43870
[   28.669917] R13: ffffc900036cb278 R14: 0000000000000000 R15: ffff888107b427c0
[   28.669918] FS:  00007f2033afc740(0000) GS:ffff88842fc80000(0000) knlGS:0000000000000000
[   28.669919] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.669920] CR2: 0000000000000000 CR3: 00000001203d1000 CR4: 0000000000752ef0
[   28.669922] PKRU: 55555554
[   28.669923] Call Trace:
[   28.669924]  <TASK>
[   28.669925]  ? kvm_xen_inject_vcpu_vector.isra.0+0x50/0x60 [kvm]
[   28.669949]  ? __warn+0x81/0x170
[   28.669952]  ? kvm_xen_inject_vcpu_vector.isra.0+0x50/0x60 [kvm]
[   28.669976]  ? report_bug+0x189/0x1c0
[   28.669979]  ? handle_bug+0x38/0x70
[   28.669981]  ? exc_invalid_op+0x13/0x60
[   28.669983]  ? asm_exc_invalid_op+0x16/0x20
[   28.669987]  ? kvm_xen_inject_vcpu_vector.isra.0+0x50/0x60 [kvm]
[   28.670011]  kvm_xen_set_evtchn_fast+0x40f/0x430 [kvm]
[   28.670037]  irqfd_wakeup+0x160/0x270 [kvm]
[   28.670057]  ? kvm_xen_vcpu_get_attr+0x210/0x210 [kvm]
[   28.670082]  __wake_up_common+0x7f/0xb0
[   28.670085]  eventfd_write+0x9d/0x1e0
[   28.670087]  ? security_file_permission+0x2c/0x40
[   28.670090]  vfs_write+0xc1/0x500
[   28.670092]  ? do_syscall_64+0xa2/0x180
[   28.670094]  ? lockdep_hardirqs_on+0x7d/0x100
[   28.670097]  ksys_write+0x59/0xd0
[   28.670099]  do_syscall_64+0x95/0x180
[   28.670101]  ? do_syscall_64+0xa2/0x180
[   28.670104]  entry_SYSCALL_64_after_hwframe+0x46/0x4e
[   28.670106] RIP: 0033:0x7f2033c07c74
[   28.670110] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 80 3d f5 76 0d 00 00 74 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 55 48 89 e5 48 83 ec 20 48 89
[   28.670111] RSP: 002b:00007ffe79281ad8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[   28.670113] RAX: ffffffffffffffda RBX: 00007f2033069ff1 RCX: 00007f2033c07c74
[   28.670113] RDX: 0000000000000008 RSI: 00007ffe79281ae8 RDI: 0000000000000109
[   28.670114] RBP: 00007ffe79281af0 R08: 000000000041d22c R09: 00000000ffffffff
[   28.670115] R10: 00007f2033b09b78 R11: 0000000000000202 R12: 0000000000000002
[   28.670116] R13: 00000000007e52a0 R14: 00007f2033068000 R15: 0000000000000000
[   28.670120]  </TASK>
[   28.670121] irq event stamp: 305006
[   28.670122] hardirqs last  enabled at (305005): [<ffffffff81eb9cf4>] do_syscall_64+0x54/0x180
[   28.670124] hardirqs last disabled at (305006): [<ffffffff81eda4a2>] _raw_spin_lock_irq+0x52/0x60
[   28.670125] softirqs last  enabled at (305000): [<ffffffff81039cce>] fpu_swap_kvm_fpstate+0x7e/0x120
[   28.670127] softirqs last disabled at (304998): [<ffffffff81039c7d>] fpu_swap_kvm_fpstate+0x2d/0x120
[   28.670129] ---[ end trace 0000000000000000 ]---

As I understand, splat here is due to APIC map being gone (because of physical
APIC ID aliasing?), but I'm not sure what is the expected behaviour.

Thanks,
Michal

