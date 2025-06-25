Return-Path: <kvm+bounces-50690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F665AE856C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 723CD1794C9
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DFA263F27;
	Wed, 25 Jun 2025 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tum.de header.i=@tum.de header.b="PrMP3WDv"
X-Original-To: kvm@vger.kernel.org
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [129.187.255.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7CD25C81F;
	Wed, 25 Jun 2025 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.187.255.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860027; cv=none; b=jHHpwou7XP5exHxVvFrm+vZcDRL5H79qwMWzFzBfV2qyQxpfrcykcXJW02QdozM3Nyl+XTOBR3VXZoBKUIjBkppAERLKm9TwZdr6QsX8xtXy1auZi9S4YU+/HMOEKmOo1WZQiHj8X8ry8LVZKvViagszUN+ntDUFIundjd0wQbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860027; c=relaxed/simple;
	bh=PbYvShW9eZXDl9zcQylaxIY7W2/bTDgB+NiFXYT8H9Q=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=uS0vLwiJeHSgbiIxb/EOTG1CVVqrrH3qk9FoWC6Ezudj+dhFDEL1A4iMbmXYBI0D9yktgqm8iOdX+EaSKMP+o4R1ysq/2wgBuVx3TNbHq8c09J0iHR1p6MiF1/FQSbfXppcjtC8kw+1syXu15y4OJnpBUGQfBqbP6ftnAC0IIHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tum.de; spf=pass smtp.mailfrom=tum.de; dkim=pass (2048-bit key) header.d=tum.de header.i=@tum.de header.b=PrMP3WDv; arc=none smtp.client-ip=129.187.255.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tum.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tum.de
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
	by postout2.mail.lrz.de (Postfix) with ESMTP id 4bS3F04cZlzySN;
	Wed, 25 Jun 2025 15:53:24 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavis); dkim=pass (2048-bit key)
 reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tum.de; h=
	content-transfer-encoding:content-type:content-type:subject
	:subject:from:from:content-language:user-agent:mime-version:date
	:date:message-id:received:received; s=tu-postout21; t=
	1750859604; bh=rHOUNQI/LUioMhdXul5khE5zg/7fobUm4oyuXtkvfFY=; b=P
	rMP3WDvOz2bs/NhDHERQrdbx8jkAi+shyvqENWwuEUgeD6HcG0RRzN9UPe4Eyb21
	qp7+QZEDvkyayR0dga3iMmVEjYK6gqafT4uOc9husp76RHdy63zC4ihiYXexLbJf
	DzRG1toRdO5PEva79PoFT3fa2fpQ7oN92G4Ly3szq4RZZbrZ+fYJ/Vwf+vo0Qh8i
	8bFgBCmHE29PffajGBO+fsH8gHeIcYeauafQ1uz39rz06R/dFK4+WzInJ+Jc7euu
	uQzCETp0jeri+dtJe1oQDIdmU/8VIY68MTRPrXVEOQcymIPR/4mdBjQhRMd80c/9
	MLhW4/HMurMLOxMQxnVHA==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.873
X-Spam-Level:
Received: from postout2.mail.lrz.de ([127.0.0.1])
 by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavis, port 20024)
 with LMTP id hxZpH3LrEP1h; Wed, 25 Jun 2025 15:53:24 +0200 (CEST)
Received: from [IPV6:2a09:80c0:192:0:1a32:faf8:4a92:5176] (unknown [IPv6:2a09:80c0:192:0:1a32:faf8:4a92:5176])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4bS3Dz67mZzyRN;
	Wed, 25 Jun 2025 15:53:23 +0200 (CEST)
Message-ID: <c090efb3-ef82-499f-a5e0-360fc8420fb7@tum.de>
Date: Wed, 25 Jun 2025 15:53:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
From: Manuel Andreas <manuel.andreas@tum.de>
Subject: [PATCH] x86/hyper-v: Filter non-canonical addresses passed via
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST(_EX)
Autocrypt: addr=manuel.andreas@tum.de; keydata=
 xjMEY9Zx/RYJKwYBBAHaRw8BAQdALWzRzW9a74DX4l6i8VzXGvv72Vz0qfvj9s7bjBD905nN
 Jk1hbnVlbCBBbmRyZWFzIDxtYW51ZWwuYW5kcmVhc0B0dW0uZGU+wokEExYIADEWIQQuSfNX
 11QV6exAUmOqZGwY4LuingUCY9Zx/QIbAwQLCQgHBRUICQoLBRYCAwEAAAoJEKpkbBjgu6Ke
 McQBAPyP530S365I50I5rM2XjH5Hr9YcUQATD5dusZJMDgejAP9T/wUurwQSuRfm1rK8cNcf
 w4wP3+PLvL+J+kuVku93CM44BGPWcf0SCisGAQQBl1UBBQEBB0AmCAf31tLBD5tvtdZ0XX1B
 yGLUAxhgmFskGyPhY8wOKQMBCAfCeAQYFggAIBYhBC5J81fXVBXp7EBSY6pkbBjgu6KeBQJj
 1nH9AhsMAAoJEKpkbBjgu6Kej6YA/RvJdXMjsD5csifolLw53KX0/ElM22SvaGym1+KiiVND
 AQDy+y+bCXI+J713/AwLBsDxTEXmP7Cp49ZqbAu83NnpBQ==
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

In KVM guests with Hyper-V hypercalls enabled, the hypercalls 
HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX 
allow a guest to request invalidation of portions of a virtual TLB.
For this, the hypercall parameter includes a list of GVAs that are supposed 
to be invalidated.

However, when non-canonical GVAs are passed, there is currently no 
filtering in place and they are eventually passed to checked invocations of 
INVVPID on Intel / INVLPGA on AMD.
While the AMD variant (INVLPGA) will silently ignore the non-canonical 
address and perform a no-op, the Intel variant (INVVPID) will fail and end 
up in invvpid_error, where a WARN_ONCE is triggered:

invvpid failed: ext=0x0 vpid=1 gva=0xaaaaaaaaaaaaa000
WARNING: CPU: 6 PID: 326 at arch/x86/kvm/vmx/vmx.c:482 
invvpid_error+0x91/0xa0 [kvm_intel]
Modules linked in: kvm_intel kvm 9pnet_virtio irqbypass fuse
CPU: 6 UID: 0 PID: 326 Comm: kvm-vm Not tainted 6.15.0 #14 PREEMPT(voluntary)
RIP: 0010:invvpid_error+0x91/0xa0 [kvm_intel]
Call Trace:
  <TASK>
  vmx_flush_tlb_gva+0x320/0x490 [kvm_intel]
  ? __pfx_vmx_flush_tlb_gva+0x10/0x10 [kvm_intel]
  ? kfifo_copy_out+0xcf/0x120
  kvm_hv_vcpu_flush_tlb+0x24f/0x4f0 [kvm]
  ? __pfx_kvm_hv_vcpu_flush_tlb+0x10/0x10 [kvm]
  ? kvm_pmu_is_valid_msr+0x6e/0x80 [kvm]
  ? kvm_get_msr_common+0x219/0x20f0 [kvm]
  kvm_arch_vcpu_ioctl_run+0x3013/0x5810 [kvm]
  /* ... */

Hyper-V documents that invalid GVAs (those that are beyond a partition's 
GVA space) are to be ignored. While not completely clear whether this 
ruling also applies to non-canonical GVAs, it is likely fine to make that 
assumption.

The following patch addresses the issue by skipping non-canonical GVAs 
before calling the architecture-specific invalidation primitive.
I've validated it against a PoC and the issue seems to be fixed.

Signed-off-by: Manuel Andreas <manuel.andreas@tum.de>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
  arch/x86/kvm/hyperv.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 24f0318c50d7..644a7aae6dab 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1979,6 +1979,9 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
  		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
  			goto out_flush_all;

+                if (is_noncanonical_invlpg_address(entries[i], vcpu))
+                        continue;
+
  		/*
  		 * Lower 12 bits of 'address' encode the number of additional
  		 * pages to flush.
-- 
2.50.0

