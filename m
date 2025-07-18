Return-Path: <kvm+bounces-52887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 158B8B0A1C7
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A9681C22FD5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844082D8371;
	Fri, 18 Jul 2025 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VaUgI9tG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E192D77F0
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 11:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837354; cv=none; b=da293Q/kWu43TyotQHm6VMkC65ZywNj7UNSrdHq21DCVVIsQBqDwEr2Vg9hT56syPkRUijzQIktJmXiwdAxhMYfpfeZgL1RybHkX+6hKBj4HtqYFJNUh8S4N9KGZdNgF/OhsnJno1r32Dz44vJP9iva2adyHz15HvB2N5xF6AY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837354; c=relaxed/simple;
	bh=BBCIJJlDLwuO3Rt2Xfz64r1W7I7tZy0awNIPraZD3KY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3y200mKlGHNy7rM26NoQs/gX4B/ZJJTgMgEdSJkqtunuAnoqIDdeUOR1xnqmPja7avWnawBZ7ts4UIG53n38OB2I6m6yIqn+dHGV5ftPO/EJyxgYypyFPyjxMQWpdQ5V5pk7QrdAVlhGuzry5kI9hidibLTays0PPgXsJqoGPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VaUgI9tG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752837352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBA7xsX3f/iwBHfD/uycAAiF9tf7BvrMU968pipgS30=;
	b=VaUgI9tGvW4pBJWnO+zwLz2ajQBexG4dWQaXqduGwRCu7t8bEPfTEUnchox2bpKM1NcS/J
	acY0suN/S2eKtQuDTs8TRs2faBxfR1EeJVX5f+mtL/95lah/NKbzzRK70TfmZtUEDkQ8u0
	M4NV+kYP6ff8eeMOoYsxG52DHDPDRgs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-IpxgPV_fNU6pKhILPzyEuQ-1; Fri, 18 Jul 2025 07:15:50 -0400
X-MC-Unique: IpxgPV_fNU6pKhILPzyEuQ-1
X-Mimecast-MFC-AGG-ID: IpxgPV_fNU6pKhILPzyEuQ_1752837350
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-311ef4fb5fdso2536539a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 04:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752837350; x=1753442150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBA7xsX3f/iwBHfD/uycAAiF9tf7BvrMU968pipgS30=;
        b=QLjJZ/sFCRuxtT7drUQA1Li3GXzceqNMb1KzAmfJ7Gc1VO/z43GZZ8pmCYQNdM/HmD
         MyE65HJkXDKrYSZwvWcktYMwS2MxnP6YE8UcaZKAeJ1I3SHZZOo3+SKvv9oYzxlgcBJv
         EzbIzTkCC96mCSwkFhOdpik46LnQNd2kTpchdqgEPUHlHjcDQPyzLPpFPsguwhAGCLNP
         9pTUwwZVqWPQzuawLJoe5A0l6mxyWuGebaNvneyDoZkCKI26t4JRh/7+LSWsp0Ats00J
         etbDhD6WpCtpWB1iv7xKUwNmV51/yTT6icBNzXSzXX1j7gAa5FsChj8LnxWSDPGX1h6p
         hzPA==
X-Forwarded-Encrypted: i=1; AJvYcCWo1+ghfWQDUIboBFQdWoSeSj28zFxkYQ660HytVApVIx7S8DoDldtKpwPsfm9pP0m2cgk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC92EhVR2trpjpcS1eeZHa4HhFco8P+QMLtAi8LoI0YfqebTVo
	Ld1zMjQuiEfE6eJoruCYwx9basdJyA3hJXdqWYV0ni2I//i53wjtzZLzGuj7YSI1+Cl9xeFGgu8
	jjviYusV60q7rAJ83AZVSQF2gYTxjeZDP6Aj6X9M7OyH4/0fyovXgRRkyq7he1Ti6WK/lFivj0X
	Om+2jCDyFCzLlqo1G1mW2jDESTOlyH
X-Gm-Gg: ASbGncvSV2bGNv5i24aex9eYAbnw2Oo0PJifMyGHuwiRjW2HyY05HBPyd046UuTHl2+
	Sx/6Z0b0Ye9t8mfNwmqzvkZTiXu5XIdsZyJ8NUg+VGFjjbx0jEtEQm1sNf/FtMiByqL/5wKSys7
	0DIuq4+THC7C8Vqsa2fRM=
X-Received: by 2002:a17:90b:4fcc:b0:312:e1ec:de44 with SMTP id 98e67ed59e1d1-31c9e77050fmr15952282a91.27.1752837349699;
        Fri, 18 Jul 2025 04:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9QbxoyibgZZyMUpEIKM/wsW0LKvXoPiVOFHYBhjUnG4a++/+O1Hcc5xvbKFBhDfEiitqwkezMta44uTRF0SM=
X-Received: by 2002:a17:90b:4fcc:b0:312:e1ec:de44 with SMTP id
 98e67ed59e1d1-31c9e77050fmr15952224a91.27.1752837349203; Fri, 18 Jul 2025
 04:15:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250718062429.238723-1-lulu@redhat.com> <CACGkMEv0yHC7P1CLeB8A1VumWtTF4Bw4eY2_njnPMwT75-EJkg@mail.gmail.com>
 <aHopXN73dHW/uKaT@intel.com>
In-Reply-To: <aHopXN73dHW/uKaT@intel.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 18 Jul 2025 19:15:37 +0800
X-Gm-Features: Ac12FXwz4rGUXJq91Ex4E_n4Za48YoQX-dFUm3kg_pscGZgwjRVf5myne0oT9ho
Message-ID: <CACGkMEvNaKgF7bOPUahaYMi6n2vijAXwFvAhQ22LecZGSC-_bg@mail.gmail.com>
Subject: Re: [PATCH v1] kvm: x86: implement PV send_IPI method
To: Chao Gao <chao.gao@intel.com>
Cc: Cindy Lu <lulu@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, "Kirill A. Shutemov" <kas@kernel.org>, "Xin Li (Intel)" <xin@zytor.com>, 
	Rik van Riel <riel@surriel.com>, "Ahmed S. Darwish" <darwi@linutronix.de>, 
	"open list:KVM PARAVIRT (KVM/paravirt)" <kvm@vger.kernel.org>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2025 at 7:01=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Fri, Jul 18, 2025 at 03:52:30PM +0800, Jason Wang wrote:
> >On Fri, Jul 18, 2025 at 2:25=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote=
:
> >>
> >> From: Jason Wang <jasowang@redhat.com>
> >>
> >> We used to have PV version of send_IPI_mask and
> >> send_IPI_mask_allbutself. This patch implements PV send_IPI method to
> >> reduce the number of vmexits.
>
> It won't reduce the number of VM-exits; in fact, it may increase them on =
CPUs
> that support IPI virtualization.

Sure, but I wonder if it reduces the vmexits when there's no APICV or
L2 VM. I thought it can reduce the 2 vmexits to 1?

>
> With IPI virtualization enabled, *unicast* and physical-addressing IPIs w=
on't
> cause a VM-exit.

Right.

> Instead, the microcode posts interrupts directly to the target
> vCPU. The PV version always causes a VM-exit.

Yes, but it applies to all PV IPI I think.

>
> >>
> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >> Tested-by: Cindy Lu <lulu@redhat.com>
> >
> >I think a question here is are we able to see performance improvement
> >in any kind of setup?
>
> It may result in a negative performance impact.

Userspace can check and enable PV IPI for the case where it suits.

For example, HyperV did something like:

void __init hv_apic_init(void)
{
  if (ms_hyperv.hints & HV_X64_CLUSTER_IPI_RECOMMENDED) {
                pr_info("Hyper-V: Using IPI hypercalls\n");
                /*
                 * Set the IPI entry points.
                 */
                orig_apic =3D *apic;

                apic_update_callback(send_IPI, hv_send_ipi);
                apic_update_callback(send_IPI_mask, hv_send_ipi_mask);
                apic_update_callback(send_IPI_mask_allbutself,
hv_send_ipi_mask_allbutself);
                apic_update_callback(send_IPI_allbutself,
hv_send_ipi_allbutself);
                apic_update_callback(send_IPI_all, hv_send_ipi_all);
                apic_update_callback(send_IPI_self, hv_send_ipi_self);
}

send_IPI_mask is there.

Thanks

>
> >
> >Thanks
> >
> >
>


