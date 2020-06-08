Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6561F1977
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgFHM50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:57:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53108 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729706AbgFHM50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 08:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591621044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUm1Yo5Aid4TMrOqqlc50Lm+RhYPQ/fOeFf4c/GrH5w=;
        b=HHsy2c0JyXdMIxRfW0LPwZ5i4daoT6/wwrXDJzQQVSpZdFjTTMte/dbctW0POx16zwdjMq
        szvXWbA4gXnD0qi9DfhnYh3bJ2AK+HYf/mbWQMfkwuk1mmmo+B1aP2y+aGr9zr/r+5hGmN
        GmhEgkilblYtEplfXhoLNGXBElnb/o4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-x9uuYlRJMSGOQuHgcEx50A-1; Mon, 08 Jun 2020 08:57:23 -0400
X-MC-Unique: x9uuYlRJMSGOQuHgcEx50A-1
Received: by mail-wr1-f72.google.com with SMTP id c14so7081719wrw.11
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 05:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUm1Yo5Aid4TMrOqqlc50Lm+RhYPQ/fOeFf4c/GrH5w=;
        b=FloQ6WiNlt0+lfekXX+SGQ7G2C2ZKhc6JUSClZz0rc+JEj7IMcHGti5itxBCEj6dnG
         ebkb4PubYdtobwgt9E4tri1ih8swEnwLvrTjMdApp24+tCyN8bobeaOuXhXhy53NN/UM
         qFiG+XleMHSKfhtVkUIS07XJ5B68rPEDQsgvbv/IvSnlyxo5DjLfSB5P7/UkxzIbLlp9
         68oNIj7WCPD6dWDqKt0Gu1yxSasfUTIV4EnlQsF8R2OYygPAvDDXjDPE+rMWkIK1JqzX
         OzQKOsPdl32/u//uWNXvxWJdrV7GAlK/nTkKPWQGxh1g03wqDiFytZ/1zf5o/J0GzkkC
         27cg==
X-Gm-Message-State: AOAM5335iLE83dyniSAYvg+y7lKZA5alLhjHH9IV06JjtcYWSGiuvsqr
        LHxTi5/FKc17W/pAczE5HQ0fgKiRG9Jckf+T0SZVjE3MStg4ISagzcopJzfMdapVTnKJc+3O7ea
        fiTqPoenmvxF1
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr23045678wrx.215.1591621041759;
        Mon, 08 Jun 2020 05:57:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6e3sTNx0BsPz+9n2RfJG0sF3B20sQwi851ltjAWHGGejg4F5dTAyhk0S80jQnxkAgrZInQQ==
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr23045654wrx.215.1591621041544;
        Mon, 08 Jun 2020 05:57:21 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.87.23])
        by smtp.gmail.com with ESMTPSA id s132sm23406546wmf.12.2020.06.08.05.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 05:57:21 -0700 (PDT)
Subject: Re: [PATCH v2 17/18] kvm/eventfd: Use sequence counter with
 associated spinlock
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200608005729.1874024-1-a.darwish@linutronix.de>
 <20200608005729.1874024-18-a.darwish@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc198b70-7521-47be-0f1d-ff5ac754cb69@redhat.com>
Date:   Mon, 8 Jun 2020 14:57:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200608005729.1874024-18-a.darwish@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/06/20 02:57, Ahmed S. Darwish wrote:
> A sequence counter write side critical section must be protected by some
> form of locking to serialize writers. A plain seqcount_t does not
> contain the information of which lock must be held when entering a write
> side critical section.
> 
> Use the new seqcount_spinlock_t data type, which allows to associate a
> spinlock with the sequence counter. This enables lockdep to verify that
> the spinlock used for writer serialization is held when the write side
> critical section is entered.
> 
> If lockdep is disabled this lock association is compiled out and has
> neither storage size nor runtime overhead.
> 
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> ---
>  include/linux/kvm_irqfd.h | 2 +-
>  virt/kvm/eventfd.c        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kvm_irqfd.h b/include/linux/kvm_irqfd.h
> index dc1da020305b..dac047abdba7 100644
> --- a/include/linux/kvm_irqfd.h
> +++ b/include/linux/kvm_irqfd.h
> @@ -42,7 +42,7 @@ struct kvm_kernel_irqfd {
>  	wait_queue_entry_t wait;
>  	/* Update side is protected by irqfds.lock */
>  	struct kvm_kernel_irq_routing_entry irq_entry;
> -	seqcount_t irq_entry_sc;
> +	seqcount_spinlock_t irq_entry_sc;
>  	/* Used for level IRQ fast-path */
>  	int gsi;
>  	struct work_struct inject;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 67b6fc153e9c..8694a2920ea9 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -303,7 +303,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	INIT_LIST_HEAD(&irqfd->list);
>  	INIT_WORK(&irqfd->inject, irqfd_inject);
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
> -	seqcount_init(&irqfd->irq_entry_sc);
> +	seqcount_spinlock_init(&irqfd->irq_entry_sc, &kvm->irqfds.lock);
>  
>  	f = fdget(args->fd);
>  	if (!f.file) {
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

