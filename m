Return-Path: <kvm+bounces-70621-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIGmLsgWimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70621-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:18:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66BA6112FCD
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EB67302003B
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D925385EE5;
	Mon,  9 Feb 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbQSPqW2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="slE6rZXk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115D1385536
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770657464; cv=pass; b=UqHH/PSoDbEWHmb+r/Q8vJ6xiagz+QMdojlEJZin9mwjw9h2lDRxyCXBjlEd6u40ocPUlYeXhF6FMbxjTl5JtNx+WYjLXf8lkfe8DyiePetpa1Q2ZpNa0ighin14WxWoHbozw0URRE+eop+z6En74beId+nw6a0PefiHrumqeW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770657464; c=relaxed/simple;
	bh=3femj1AcnoV3TonaUwh7+xzY2aG/Sot2KV0a5e28QcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kE/oVFjOZk/XIB6O7aVHEu+8mD/K2b92YXzkxGuiZ0Q0V+Or5+dXqpGsB4NBtKpfBSo0BBGrWNOk7HhSV6WVWOKrIpgw+ZHjK0RIwyQ9fY82vQwQMdyMmd6lrnVRlOfJ/Qvx4dit4mfrX528xGEeTVD3ZdN2WvtHZOYseDtsaRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DbQSPqW2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=slE6rZXk; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770657462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=obiVR3q8SepdZAU9neUIjR9lqNQPaWsMI1bD68lMK6M=;
	b=DbQSPqW2ylaK6xua/kKyibeZURGInnhgr/beyns5UYsrJp3Ew0NBdastvLyz/ZqbsfKuyS
	OLJgxJByt6K1BnVPtt0hJpOCJmGPa6Z7Vv2Iku8Ry8vLDgjV0YESvwdcPsHid9JUNKiOBC
	DB0Q8MPcx3OX5yLcIptzjLGk//yE76k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-omsczntVNHGgBJrbcsdUTw-1; Mon, 09 Feb 2026 12:17:41 -0500
X-MC-Unique: omsczntVNHGgBJrbcsdUTw-1
X-Mimecast-MFC-AGG-ID: omsczntVNHGgBJrbcsdUTw_1770657460
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4376761037bso1581295f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:17:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770657460; cv=none;
        d=google.com; s=arc-20240605;
        b=kkIHkHvgvvaVlTSqAI4zbTElTggVFQDOwwjbWWgMpLvLKIvW8MLVV2eU5LsNtfjCkN
         zSenVZ90pWhA7DdhKutNow8fBr22inmMarMqPCr5X/C1Vpqc23S5NvAJ5sOPrDRQMt9B
         DMYTmeReadoNgXavLjahQ8QtlCaSpT0OT/d+/8LAVcVot3aSvkZfPypGRO/7vhAG1UVT
         ZQufN6PJhVSoKVgoqJF4K6fbqLsptpreS7SoDu1V/INqECf09GOQDK4gr5zZEwXZ8C2W
         mLqzLFiyTrzu0IbLc6oORivjsrM1sO+txa7HKr/VSqDqEJDK2oi1Zb2/v5gXzKeUMAfv
         qZIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=obiVR3q8SepdZAU9neUIjR9lqNQPaWsMI1bD68lMK6M=;
        fh=6y7G8kXoasgaBwsznqcGSbs7VdlLI3HN5scWWUqdNkQ=;
        b=WNJd/u0nUTAWQqWrI/yANWGRDY16UduZhBB9fw7+CNFeYVUNR1qhCDUKRMi0WiY8Fp
         fHtruf3HyrOIuj1odNOEO5bYyWherdfdy3aXJihjrOqRR44c5bFoJI4Q0V6LwGWJATm8
         qRpMBBAEct2/qs79GmjXlsGU9yqSDeAHEjdrCY5kjk3xQ/uywsTK1Ey+CAAQ12jSqpBb
         uTH+9AZ5gsLRXe/dIBgNqhReruk9BahxMOGEn+7RMsFNru1ZAA729Bepgjx8XTB382tl
         Hno+wcCN13NpT17VRLU8Ek6EDwZjm8yUlP0ZzeEy1l4lTPG8Ozn/XBFZLDYYOesgZd/E
         ndWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770657460; x=1771262260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obiVR3q8SepdZAU9neUIjR9lqNQPaWsMI1bD68lMK6M=;
        b=slE6rZXkVe6/Jbt8x1436hIhExCC02bKUh1C5wxIBQfbG2vebgalnuEHuv4xB3gbVV
         yQdBxFbVOHmjuOp2QzEa7uNotmJiHbIhpsdOMEYKNN8R1cj6mDyv57InHhbbqgFNpo/Q
         ea+qHMl6Rx0Ol2gkXRbSbjlNGqKExl9F2k5LwhHXVv4T7xBaD3/UZRpHrUsIRsD0aukL
         nWRbuwntBixeTxbtVr03ClBTeqiCFcTZHLuxm9p3Ud5YmESWoSwt1FqtESV+5komNRmV
         c7/5UCMP1/XV+fPGxvD8EraJQu6fqLSCpN3+m+BuFU1BysFGnKNIVMfkQG0nkJFp2wQD
         TnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770657460; x=1771262260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=obiVR3q8SepdZAU9neUIjR9lqNQPaWsMI1bD68lMK6M=;
        b=KCSuYCJYBXsxh7Q0HTvcRQcUmvL3B7HTRYPNVBFAuhcPKpdh/igPp0o+EA+nKE7pBt
         CzDPukUtQAWBgOuBPf8vQnJ8TWzs8FoXaoiVqCf7JKRv8A8ODR0nqJcwJvD4J83ZUDDy
         uYiCSUtuLW1LvRJfbaU1vWLm1WXgQfI1QL2BgNrjL2kc5dX8KMbDOrCeG16t/vbroZSJ
         3Mf+kugICXbaUx4AZOsGb1Ui0QwF6pwDHPwzpjhdaKG68C7s8hIDZwhfxzpT/jOiixtF
         zup2g5JRaBc2hQE5+1FbhPplQHSo7wjqYof7J0K/tJU/BSEpyquZ4/FWF1TvqpGGhRqB
         msrg==
X-Forwarded-Encrypted: i=1; AJvYcCWJaPkKFZVTQTy4noYRfyG8jN8ajdyg45tzSwH9XeJbTjrZyvA1yqimP8cJA05ofTcoudw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywkc67KWxskApqnYmbHELbMOUpPF1YUj2u4I6V8e9wpTIvcSsT0
	Li3SyiD7/ZWDoPX2hTrWq2+1bWT3uYcQLUEgYvjHWqefP/cpUt4EbsJKLOKXOA8QK3aYXAVUtpt
	YUs4cH8YjGNHx+91jdhN1EEj/pYEUj3PmOcIkKF0vFERtzDJ0I0RO42yMuaah/vKHci0ikPJwry
	Ri8HRHON6VvhvL7Gt++5i+tmwOpbL5
X-Gm-Gg: AZuq6aKCvWjs/ZgpGIskXdl5OSoA4u6DGLupanSN99vefw+g0FXejJJPBgnBSLhlP05
	/sIM0h8XI1ledWX/kTgoes4JD63vAeCKX4Q0wajrQvrwW2dwGmuwCWicBXQUEix3Lvmyu4R1csT
	8rwxh7p9ZoyO+eaDcaFbUGF+TxnzejnWFKNTofiI96FiQa1t4vH3bIsB0XxNvMi8FqJtRALeF4z
	D2bgovJXJM7r6HrOu/WNPYF8xEU1hH2lz15WLjEMbjgPJd07z1+FycHk+TvmE34+giAHA==
X-Received: by 2002:a05:6000:400b:b0:436:14fa:a3fd with SMTP id ffacd0b85a97d-437791ea33amr172519f8f.24.1770657460337;
        Mon, 09 Feb 2026 09:17:40 -0800 (PST)
X-Received: by 2002:a05:6000:400b:b0:436:14fa:a3fd with SMTP id
 ffacd0b85a97d-437791ea33amr172482f8f.24.1770657459828; Mon, 09 Feb 2026
 09:17:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206145622.2433924-1-chenhuacai@loongson.cn>
In-Reply-To: <20260206145622.2433924-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 18:17:26 +0100
X-Gm-Features: AZwV_QjBtz9lA_DiHImRN_CVO1-zyt5IKnzotZXjwj61dvndjwONXCdx2J-FJDI
Message-ID: <CABgObfYtQcXV-GWYktTq04KZKEVLyVGx4wz7XzgA6sdy=iTHsw@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.20
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:email];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70621-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 66BA6112FCD
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 3:56=E2=80=AFPM Huacai Chen <chenhuacai@loongson.cn>=
 wrote:
>
> The following changes since commit 18f7fcd5e69a04df57b563360b88be72471d6b=
62:
>
>   Linux 6.19-rc8 (2026-02-01 14:01:13 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.20
>
> for you to fetch changes up to 2d94a3f7088b69ae25e27fb98d7f1ef572c843f9:
>
>   KVM: LoongArch: selftests: Add steal time test case (2026-02-06 09:28:0=
1 +0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> LoongArch KVM changes for v6.20
>
> 1. Add more CPUCFG mask bits.
> 2. Improve feature detection.
> 3. Add FPU/LBT delay load support.
> 4. Set default return value in KVM IO bus ops.
> 5. Add paravirt preempt feature support.
> 6. Add KVM steal time test case for tools/selftests.
>
> ----------------------------------------------------------------
> Bibo Mao (13):
>       LoongArch: KVM: Add more CPUCFG mask bits
>       LoongArch: KVM: Move feature detection in kvm_vm_init_features()
>       LoongArch: KVM: Add msgint registers in kvm_init_gcsr_flag()
>       LoongArch: KVM: Check VM msgint feature during interrupt handling
>       LoongArch: KVM: Handle LOONGARCH_CSR_IPR during vCPU context switch
>       LoongArch: KVM: Move LSX capability check in exception handler
>       LoongArch: KVM: Move LASX capability check in exception handler
>       LoongArch: KVM: Move LBT capability check in exception handler
>       LoongArch: KVM: Add FPU/LBT delay load support
>       LoongArch: KVM: Set default return value in KVM IO bus ops
>       LoongArch: KVM: Add paravirt preempt feature in hypervisor side
>       LoongArch: KVM: Add paravirt vcpu_is_preempted() support in guest s=
ide
>       KVM: LoongArch: selftests: Add steal time test case
>
>  arch/loongarch/include/asm/kvm_host.h      |   9 +++
>  arch/loongarch/include/asm/kvm_para.h      |   4 +-
>  arch/loongarch/include/asm/loongarch.h     |   1 +
>  arch/loongarch/include/asm/qspinlock.h     |   4 +
>  arch/loongarch/include/uapi/asm/kvm.h      |   1 +
>  arch/loongarch/include/uapi/asm/kvm_para.h |   1 +
>  arch/loongarch/kernel/paravirt.c           |  21 ++++-
>  arch/loongarch/kvm/exit.c                  |  21 ++++-
>  arch/loongarch/kvm/intc/eiointc.c          |  43 ++++------
>  arch/loongarch/kvm/intc/ipi.c              |  26 ++----
>  arch/loongarch/kvm/intc/pch_pic.c          |  31 ++++---
>  arch/loongarch/kvm/interrupt.c             |   4 +-
>  arch/loongarch/kvm/main.c                  |   8 ++
>  arch/loongarch/kvm/vcpu.c                  | 125 +++++++++++++++++++++++=
------
>  arch/loongarch/kvm/vm.c                    |  39 +++++----
>  tools/testing/selftests/kvm/Makefile.kvm   |   1 +
>  tools/testing/selftests/kvm/steal_time.c   |  96 ++++++++++++++++++++++
>  17 files changed, 319 insertions(+), 116 deletions(-)
>


