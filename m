Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1CF16175A
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 17:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgBQQNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 11:13:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30106 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729787AbgBQQNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 11:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581955979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y4BrwNB8Hj+0yioJs/TNbq3UIy2YcgCIxzyiFyjCQAg=;
        b=ITVCh3hA/VfLWg8J1fqnS1JZQaDL/u8SXPDXGUhildpom3Afs54Pwbd8mE1vX4uahhNtjQ
        b5Pvl/c8v63Dgh/ONruAjGzyVb9F9mKIT7lU1BLYZ9f+/ChhMN0RuIeaLWvyw0qXt5JqeF
        ggwfMDBc8oRrvVKAIVQkL/PSxIA2lI4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-8xX4jS6COiK_g8uYswE7rw-1; Mon, 17 Feb 2020 11:12:57 -0500
X-MC-Unique: 8xX4jS6COiK_g8uYswE7rw-1
Received: by mail-wr1-f69.google.com with SMTP id o9so9213764wrw.14
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 08:12:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Y4BrwNB8Hj+0yioJs/TNbq3UIy2YcgCIxzyiFyjCQAg=;
        b=ll4BGCD76u83YXKKh+KOyjdmWEkfH4aWnbIoojNPT1w2SQT6gk8iUmlmp9lu5gO8Wi
         qF1KohfpHxlusQVgiGQMjPjAjMOCisf8lci321wu6tXeKkFaxzrn3jkUTz200OjkWR7K
         ZcH3WW0KQPEpxomwI9JiaWgYLOrjaoFV26yzch+bCrDxqX3aYV639xcLdHv2ZMtJD7o9
         X1EN8FWiqepxwFzKtKG7y+rWBnBElp7+husEQkifZZeU6dIPweDlam55vOwoLkyHgGU5
         Lv8WJ+IrBdVOQTYO/UNQd+zNr5TohBWOyTqihE/Z9HJb19AyC3n8rbIpb/LW0QEn01/x
         u9Uw==
X-Gm-Message-State: APjAAAXbPrNmPuyZrx75t+lZlOj/gyg7v2JTobjEH+JJOoBNJ+N+xOui
        b0wKh9vxWQY5Md3CleaDc/7WKFOEm+N+TchfrYmJThMszz5EuWyS5a8Y20HrIerlEBHPpbS8kac
        LTDWpEfr3csc3
X-Received: by 2002:a1c:de55:: with SMTP id v82mr22788257wmg.48.1581955975771;
        Mon, 17 Feb 2020 08:12:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxtQWNKO6flhNFKqu/ZAXkV8yFXLY+LuFPsQB3R9PZdhyRgH7Tx8YdMlaBzAtJxLRXuRCwQg==
X-Received: by 2002:a1c:de55:: with SMTP id v82mr22788238wmg.48.1581955975563;
        Mon, 17 Feb 2020 08:12:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o15sm1596709wra.83.2020.02.17.08.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 08:12:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt EOI
In-Reply-To: <1581647558-8216-1-git-send-email-linmiaohe@huawei.com>
References: <1581647558-8216-1-git-send-email-linmiaohe@huawei.com>
Date:   Mon, 17 Feb 2020 17:12:54 +0100
Message-ID: <87mu9h9oqh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Commit 13db77347db1 ("KVM: x86: don't notify userspace IOAPIC on edge
> EOI") said, edge-triggered interrupts don't set a bit in TMR, which means
> that IOAPIC isn't notified on EOI. And var level indicates level-triggered
> interrupt.
> But commit 3159d36ad799 ("KVM: x86: use generic function for MSI parsing")
> replace var level with irq.level by mistake. Fix it by changing irq.level
> to irq.trig_mode.
>
> Fixes: 3159d36ad799 ("KVM: x86: use generic function for MSI parsing")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/irq_comm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 79afa0bb5f41..c47d2acec529 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -417,7 +417,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>  
>  			kvm_set_msi_irq(vcpu->kvm, entry, &irq);
>  
> -			if (irq.level &&
> +			if (irq.trig_mode &&
>  			    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
>  						irq.dest_id, irq.dest_mode))
>  				__set_bit(irq.vector, ioapic_handled_vectors);

Assuming Radim's comment (13db77347db1) is correct, the change in
3159d36ad799 looks wrong and your patch restores the status
quo. Actually, kvm_set_msi_irq() always sets irq->level = 1 so checking
it is pointless.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(but it is actually possible that there's a buggy userspace out there
which expects EOI notifications; we won't find out unless we try to fix
the bug).

-- 
Vitaly

