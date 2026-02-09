Return-Path: <kvm+bounces-70633-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IAo5KXwiimnLHQAAu9opvQ
	(envelope-from <kvm+bounces-70633-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:07:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FC8113629
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CA391300A316
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 18:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA67438A713;
	Mon,  9 Feb 2026 18:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOLK3+/j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j8E32zuZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293F37F8AD
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660470; cv=pass; b=Mx95PyCeklS3GuoYPfK1Ubn+ZlxRljSIsv58vc5U72jEZZ9xdjYGUd1E3hGk9UGP0RW12OOo3ScR9C0wzTZbV8aiGlBt4KRN6LjIr4igSnAgHiDFb7C3SqsEhMBjaay40qftaF3uAy/WSg3PRSCBNs3pF4ubfADukQXztmw3/XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660470; c=relaxed/simple;
	bh=DmIvxTeTqhqSojgQJMyDeTOy8AXh0jjNiKNkGUL50Eo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fQmPlQbH3fHcqOvtOmGZeAoYpR/oJTOHZFS/JwJlmrt9Uv4xlJGB5zR6ey7SMZCF1Su5/5LeAw2+Owhn2rOvUYrNCSBr8Puh34KKGoDuUxYWfRTt/REtmD9So//sfCvPwjgNszPMq8Lt8Oc0/7DPqJwzRagLwqo03RrFY1ocuNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOLK3+/j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j8E32zuZ; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770660468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaIOLGruaZpUOLzJ69isOfFAB3eXmjDAFo1v8TeFotw=;
	b=FOLK3+/jzHQ9OHbFsmn7ASX0MPEoJAbHSBPTRCfauc0E2h5NxBX7DQRYnU77rIpqj0l5zo
	vA7mCEoGtt7u4Hs17SyAXuVAqcQ90TSo1lr7umxSHAMLPbc3D9n5M/Ne3LBX3jHZGJOVOC
	NqIpC5/uNGQmSdi5jzVxufNnWERxbjs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-e99KUiHLOD6kpr9Egt2oKw-1; Mon, 09 Feb 2026 13:07:47 -0500
X-MC-Unique: e99KUiHLOD6kpr9Egt2oKw-1
X-Mimecast-MFC-AGG-ID: e99KUiHLOD6kpr9Egt2oKw_1770660466
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4801c1056c7so64565e9.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 10:07:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770660466; cv=none;
        d=google.com; s=arc-20240605;
        b=F/sOekPyB+vjGjt5N4RKYsX+hxg8FNviJawvUIa0YLmPD4u/CtB01kkDcvNQBJfWEQ
         N0SA4DUBA7yRXiMOFMmQFZ9QcEjYV9hN3ZXsdJW7hgdX88NVcgxOJDo7pC7uIZtTacoY
         wyUxZCF86R+YwZ81YtzW7J9KKhxalWhGgtRPgsB9z0IFvhVGo7EVC8w7JeJ0h5TEzM4e
         SF1vqJTOz6tJfdXAHexPATCd40OdiMZG8NHGXI3+noAV4r01SPWacrppjTXNKaxcGqrB
         tCnzeVWydxaGO7OEzl30y22U3k0h16G1p0PVcJZ22ySdtS9erHO+4HkB/mnkkUwcX0ol
         FxMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iaIOLGruaZpUOLzJ69isOfFAB3eXmjDAFo1v8TeFotw=;
        fh=yeQ2NkBHAGiQ11LtBS20hlE21EcpbaoSPFmuwqFtu+c=;
        b=Vrm4B/btBJUJJ9HQmH9bwa4W0gneopP85bsAR1c3s6NnbSSOTJlVo6yPLoTkNsYkIQ
         7sBKH6m77BvRY2SKQUArsN0Dy+ury7p0u2sIJ6WFYdzz/kpemxQcdNZUXNuVfLlF9Qgy
         7UrNKUKhQfEan42TWPi/e7fiDhCYbUaYINBJiBvJAr1eTkvuWJ/k+R8JDNGiO06AyM34
         ZgIhPCXFrxD6i147glG+RbFQ2LStsyuJ82b9YCp7izh/2Ij0RU3QCiamuWGCHYsxhOSW
         w9ojg+WDo/fsaDVJLuzvH6FARfb//FGW4niZpnmQvuHQNsO53LbeJia/A9sMRUzej9Kx
         WF7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770660466; x=1771265266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaIOLGruaZpUOLzJ69isOfFAB3eXmjDAFo1v8TeFotw=;
        b=j8E32zuZ12hZABmam/AwvxarXGvrWsrjU/fe+wc+4U6wRmLM/sbNuTcKgiNA0U9Sm8
         LLgG7G7MO33rvwLpM/elNM683rTACbU6RmJF42NiABeGYjq9Os0J9P13Gqqb44lyqh2y
         n6cdM5zWuHwC0QQiOQVOQAHunfAaQrZMTWV5DUX67YmecIvVu1inM2zJA2Y9hAu1yirT
         7GE2je5l5Az1YrQNuNtdJPi0mLZg58gPdYYKM8tjl2xc51839iGjKFujMwuqYfmV893t
         VzCo5pJZx3WmlIgrSXB/yGAn6o4ir/UvxqbJIHCjq7UCi2llvUbjI9JSmxd8sM5qYnNo
         vQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770660466; x=1771265266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iaIOLGruaZpUOLzJ69isOfFAB3eXmjDAFo1v8TeFotw=;
        b=RRGc3KhZ9X4AENegJ8VTuIJ3dTkOr+H7yaLBeMAEcBVSuXT9QXaW7fcrqjvJjBOrcT
         /k7bwSAvFH4O9TMvfV62SHe/2ba6UF1zDED1l4vrP9J2cBkGQD8cIBkcykqPQ5/oKNlP
         0l5X2PYZ3BQKWJzxmLMymzll93w7yRGq8Umdo6QefqC5377C6v8Y8K5PSiiPHUi9aaDt
         f4QYt7ol4dLKOzmIinNdzqyAAW9w3g9cNyg7wwoBGfVVxyX39nrg90R97CAkNMZKZNqp
         g0oGErNALoTOwNsKcYt5TbyELog64xwI7Ff0z3AtGMa7MUWS/YVi3vP7QrLfFVPSbHxJ
         1/eg==
X-Forwarded-Encrypted: i=1; AJvYcCXKlHY2Un0v2ViGfO0t5Fw34f81qQW1HXMLDjl+P9KM1kcjf0pOeWEpEsK6xj1wjqx4gzM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcHLr1YzOpqLjuJna9xqa/kRvbJpEkbEbS23xIKaZampjDwZoP
	CHdh9X7RF7G5aID7sFvLEKF4+wUqAO5oaRwhxXwCMTq5ueBmWMej9IZnA0kpb249Nv2I+zxoF3A
	ZBF94x/Iz6W2C72yCsO4uY3o5QeQANY7uZjzTkiBwZQDiF4WG1992tq4JceDH9//lqIbwGSSqxJ
	z5IDkrSdblQUNrorbQJ8g0XofPySQh
X-Gm-Gg: AZuq6aL11wn37gH8aF24f8EXxeKjV8MiCRM3KrUE0DWeDEnRyZ1UfK6XYSosamDcnlP
	qAbuVtVZKogZ0kI27uk2ukBQgyhKOlUlQfJJc7wUpKB4jDmu8v9K2FrWy+3YoiJcyGXqRiFQnix
	INFZpbIZq34YRNHwFJzLeLbRSXZTPrwo/aIo27VRAzUWtRLfDP7VXS7yjQok3cdn8kx7rGhACN2
	kINr94Jmkp+QywTuqrOujJeQGnZ9V07FotLnAX/HxTX7z2osis8yRyhbYNcCsJ+Uob2Zg==
X-Received: by 2002:a05:600c:4444:b0:47b:deb9:f8a with SMTP id 5b1f17b1804b1-4832021fd97mr183332435e9.30.1770660465974;
        Mon, 09 Feb 2026 10:07:45 -0800 (PST)
X-Received: by 2002:a05:600c:4444:b0:47b:deb9:f8a with SMTP id
 5b1f17b1804b1-4832021fd97mr183331775e9.30.1770660465254; Mon, 09 Feb 2026
 10:07:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3z70oEePkgOBziVOKgFGae-0xMD+8xmsMV2PWM1v0ToA@mail.gmail.com>
In-Reply-To: <CAAhSdy3z70oEePkgOBziVOKgFGae-0xMD+8xmsMV2PWM1v0ToA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 19:07:33 +0100
X-Gm-Features: AZwV_QgxlPgnnuVhZ6s6V0CMfWw-2Gg31cnRTNXKphXHiRSwaWwir0wkP45a8ws
Message-ID: <CABgObfZ5-B9fFRLGrkP5CJ1jOMquuWyvAbg5=64VJRTiM5qpLA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.20
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <andrew.jones@oss.qualcomm.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	RCVD_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault.org:email,mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_FROM(0.00)[bounces-70633-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_ALL(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 38FC8113629
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 4:21=E2=80=AFAM Anup Patel <anup@brainfault.org> wro=
te:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.20:
> 1) Fixes for issues discovered by KVM API fuzzing in
>     AIA virtualization
> 2) Allow Zalasr, Zilsd and Zclsd extensions for Guest/VM
> 3) Add riscv vm satp modes in KVM selftests
> 4) Transparent huge support for G-stage
> 5) Adjust the number of available guest irq files based
>     on MMIO register sizes
>
> Please pull.
>
> Also, please note that we have a conflict with kvm-x86
> tree in tools/testing/selftests/kvm/lib/riscv/processor.c due
> to patch "KVM: riscv: selftests: Add riscv vm satp modes"
> discovered on linux-next.

Good, thanks.  Pulled.

Paolo


> diff --cc tools/testing/selftests/kvm/lib/riscv/processor.c
> index 373cf4d1ed809,e6ec7c224fc3e..0000000000000
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@@ -64,15 -68,15 +64,15 @@@ static uint64_t pte_index(struct kvm_v
>
>   void virt_arch_pgd_alloc(struct kvm_vm *vm)
>   {
>  -      size_t nr_pages =3D page_align(vm, ptrs_per_pte(vm) * 8) / vm->pa=
ge_size;
>  +      size_t nr_pages =3D vm_page_align(vm, ptrs_per_pte(vm) * 8) /
> vm->page_size;
>
> -       if (vm->pgd_created)
> +       if (vm->mmu.pgd_created)
>                 return;
>
> -       vm->pgd =3D vm_phy_pages_alloc(vm, nr_pages,
> -                                    KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> -                                    vm->memslots[MEM_REGION_PT]);
> -       vm->pgd_created =3D true;
> +       vm->mmu.pgd =3D vm_phy_pages_alloc(vm, nr_pages,
> +                                        KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +                                        vm->memslots[MEM_REGION_PT]);
> +       vm->mmu.pgd_created =3D true;
>   }
>
>   void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr=
)
> @@@ -220,14 -212,8 +221,14 @@@ void riscv_vcpu_mmu_setup(struct kvm_vc
>                 TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
>         }
>
>  +      max_satp_mode =3D vcpu_get_reg(vcpu, RISCV_CONFIG_REG(satp_mode))=
;
>  +
>  +      if ((satp_mode >> SATP_MODE_SHIFT) > max_satp_mode)
>  +              TEST_FAIL("Unable to set satp mode 0x%lx, max mode 0x%lx\=
n",
>  +                        satp_mode >> SATP_MODE_SHIFT, max_satp_mode);
>  +
> -       satp =3D (vm->pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
> +       satp =3D (vm->mmu.pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
>  -      satp |=3D SATP_MODE_48;
>  +      satp |=3D satp_mode;
>
>         vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(satp), satp);
>   }
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c
> b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 265e173b73709..1959bf556e88e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -359,17 +359,17 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
>         case VM_MODE_P56V57_4K:
>         case VM_MODE_P50V57_4K:
>         case VM_MODE_P41V57_4K:
> -               vm->pgtable_levels =3D 5;
> +               vm->mmu.pgtable_levels =3D 5;
>                 break;
>         case VM_MODE_P56V48_4K:
>         case VM_MODE_P50V48_4K:
>         case VM_MODE_P41V48_4K:
> -               vm->pgtable_levels =3D 4;
> +               vm->mmu.pgtable_levels =3D 4;
>                 break;
>         case VM_MODE_P56V39_4K:
>         case VM_MODE_P50V39_4K:
>         case VM_MODE_P41V39_4K:
> -               vm->pgtable_levels =3D 3;
> +               vm->mmu.pgtable_levels =3D 3;
>                 break;
>         default:
>                 TEST_FAIL("Unknown guest mode: 0x%x", vm->mode);
>
> Regards,
> Anup
>
> The following changes since commit 63804fed149a6750ffd28610c5c1c98cce6bd3=
77:
>
>   Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.20-1
>
> for you to fetch changes up to 376e2f8cca2816c489a9196e65cc904d1a907fd2:
>
>   irqchip/riscv-imsic: Adjust the number of available guest irq files
> (2026-02-06 19:05:34 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.20
>
> - Fixes for issues discovered by KVM API fuzzing in
>   kvm_riscv_aia_imsic_has_attr(), kvm_riscv_aia_imsic_rw_attr(),
>   and kvm_riscv_vcpu_aia_imsic_update()
> - Allow Zalasr, Zilsd and Zclsd extensions for Guest/VM
> - Add riscv vm satp modes in KVM selftests
> - Transparent huge support for G-stage
> - Adjust the number of available guest irq files based on
>   MMIO register sizes in DeviceTree or ACPI
>
> ----------------------------------------------------------------
> Jessica Liu (1):
>       RISC-V: KVM: Transparent huge page support
>
> Jiakai Xu (3):
>       RISC-V: KVM: Fix null pointer dereference in
> kvm_riscv_aia_imsic_has_attr()
>       RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw=
_attr()
>       RISC-V: KVM: Skip IMSIC update if vCPU IMSIC state is not initializ=
ed
>
> Pincheng Wang (2):
>       riscv: KVM: allow Zilsd and Zclsd extensions for Guest/VM
>       KVM: riscv: selftests: add Zilsd and Zclsd extension to get-reg-lis=
t test
>
> Qiang Ma (1):
>       RISC-V: KVM: Remove unnecessary 'ret' assignment
>
> Wu Fei (1):
>       KVM: riscv: selftests: Add riscv vm satp modes
>
> Xu Lu (3):
>       RISC-V: KVM: Allow Zalasr extensions for Guest/VM
>       RISC-V: KVM: selftests: Add Zalasr extensions to get-reg-list test
>       irqchip/riscv-imsic: Adjust the number of available guest irq files
>
>  arch/riscv/include/uapi/asm/kvm.h                  |   3 +
>  arch/riscv/kvm/aia.c                               |   2 +-
>  arch/riscv/kvm/aia_imsic.c                         |  13 +-
>  arch/riscv/kvm/mmu.c                               | 140 +++++++++++++++=
++++++
>  arch/riscv/kvm/vcpu_onereg.c                       |   4 +
>  arch/riscv/kvm/vcpu_pmu.c                          |   5 +-
>  arch/riscv/mm/pgtable.c                            |   2 +
>  drivers/irqchip/irq-riscv-imsic-state.c            |  12 +-
>  include/linux/irqchip/riscv-imsic.h                |   3 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |  17 ++-
>  .../selftests/kvm/include/riscv/processor.h        |   2 +
>  tools/testing/selftests/kvm/lib/guest_modes.c      |  41 ++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c         |  33 +++++
>  tools/testing/selftests/kvm/lib/riscv/processor.c  |  63 +++++++++-
>  tools/testing/selftests/kvm/riscv/get-reg-list.c   |  12 ++
>  15 files changed, 330 insertions(+), 22 deletions(-)
>


