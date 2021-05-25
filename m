Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FFA38FA79
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 08:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhEYGHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 02:07:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhEYGHa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 02:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621922760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9QfkiWTazDYUtE1Luc4hV82nC6GoaJdxYTDUHwiTtU=;
        b=elkSVROjKOW/SlkKOE2jCFZnuWBJWfUW4poMUXWdHFPbvTNKwX+7DG117k160kCNFkDCJJ
        Nz5aaSOqs06nEWlbt2JM/fIAmug2D/mF2aT1TlTE1ns8GKNcpoxmeljXLkbjXFtzXKZ2J4
        vu/Sj0C1GDH+w6TJmnTIJ+RP8M+b718=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-mCXE189QOFyKKvt6yJVTDw-1; Tue, 25 May 2021 02:05:57 -0400
X-MC-Unique: mCXE189QOFyKKvt6yJVTDw-1
Received: by mail-wm1-f70.google.com with SMTP id l185-20020a1c25c20000b029014b0624775eso5515642wml.6
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 23:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=r9QfkiWTazDYUtE1Luc4hV82nC6GoaJdxYTDUHwiTtU=;
        b=iZym7FCqaaXiI76AaEkJfQE0dCjdu67sZnci3cpyBvW0J8aF+lu/fNAOtxR9qxxYJG
         HP1E/ptwfSIN/lv64CGWFD9jgXUjcLIEcNlds47KYVwCIeqcwPOFGEHwuaaD6miWDRg0
         LyJE5RbSzp38zKibWUJ9j1Ar0wNWBnTEdg2uZOe7w3aCnC+T/Qxw0YRPzSoEbWoBua6R
         tvudZpmYsYvv9xOzaZMW9uc8f+62W9ZPnxAXjPUIfOF0AJPUaryW0ZtbrRjuj9otyZ/7
         5nasqp897ob6U6lh9SBXuTN7bX3Rg5Uqvk7EvTRBmssMX0F0DNp5dygHp2JGauOMnecZ
         Z6qQ==
X-Gm-Message-State: AOAM530ebIiinCpddtiHk/2MexZ0vWckVxvlzZLY4JRkwKEqTvlB2kk5
        UHEzOrHTqE6hBI0dmAcHvkBzuXgtrH1yhu4LRYLdkPO16XJ5O5+zroxF+GjnsGuk0pnOforXHMC
        aL2vwNeuRq5VJsgbuqig+i3SgESbVgrTNg5RCRRifCmQO9iowfJGTxOkTUtTdhX+m
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr24582950wri.327.1621922756265;
        Mon, 24 May 2021 23:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfsthrHqZDORFny3PkPPPeOrcDPeoQH9q5hYHy/9xCUEv21MTIaAZm54SxRMgPqJN2wFdkfQ==
X-Received: by 2002:a5d:64cf:: with SMTP id f15mr24582933wri.327.1621922756019;
        Mon, 24 May 2021 23:05:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n20sm9759911wmk.12.2021.05.24.23.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 23:05:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Fix ERROR: modpost: .kvm_vcpu_can_poll undefined!
In-Reply-To: <1621911770-11744-1-git-send-email-wanpengli@tencent.com>
References: <1621911770-11744-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 25 May 2021 08:05:54 +0200
Message-ID: <87im378i0t.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Export kvm_vcpu_can_poll to fix ERROR: modpost: .kvm_vcpu_can_poll undefined!
>

Fixes: 0fee89fbc44b ("KVM: PPC: exit halt polling on need_resched()")

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 62522c1..8eaec42 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2949,6 +2949,7 @@ bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
>  {
>  	return single_task_running() && !need_resched() && ktime_before(cur, stop);
>  }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_can_poll);
>  
>  /*
>   * The vCPU has executed a HLT instruction with in-kernel mode enabled.

-- 
Vitaly

