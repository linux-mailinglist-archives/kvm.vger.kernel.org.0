Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6817A2BE
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCEKAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:00:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgCEKA1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 05:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583402425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h9c3Oo/RuEHs22bhUV7ITfbICrFSfIEa7L4Ikjb6rqs=;
        b=FOyvF56peCZPKLIZurAoxd1oXeyGhIjxp6O5LD9D5BpBd/b3Kym/S0qaokQEWpazfHpAT+
        aQWRVsMuKCkadBfcnnH0ai96w4kzsbq7pk0QuMHHhMNQ0AxCSOjrCj+BANmJEQKA7AB4qX
        DBcpTt3TAbBxpQtN6xtqUJBHb2v1BtU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-lI3352K2M5y22SxX9KI6Ag-1; Thu, 05 Mar 2020 05:00:24 -0500
X-MC-Unique: lI3352K2M5y22SxX9KI6Ag-1
Received: by mail-wm1-f72.google.com with SMTP id y7so1879518wmd.4
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 02:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=h9c3Oo/RuEHs22bhUV7ITfbICrFSfIEa7L4Ikjb6rqs=;
        b=XZG2Pn00oEWbbKc0HpSrA6Bwu+fhudRmr8jKVVtet/ykxjGgtAbrUSN4HIn56dfMTC
         RtZ+J4+0osGTK1nTRh64B9SKmU6HT1US9F055DJa61hLASzrm4j5QqAnTr9gQGUTB8UF
         yp0BBoMs4PHHJBUQpilHN2/7QrAhIxwX4FcCkftNjgN+aWz3/2YAUNSIrZ5fHq47I7m8
         LKEhtn70yTbqcgiw0tW2x574QwOLV8eV/SNjxuZzxORaeaDur/CpgDePM2fGHUdRud25
         QNj2NIs7V99J6pQxsav5y703Fa8Kql49sr7RtWnhaoEKwpHiRYiviW+rkv/Kaq6iR1+a
         CAHA==
X-Gm-Message-State: ANhLgQ0Nr+h3JjPtutMLgEi7V/5ixnQ6C2KjUKCeTVpEtghgJAN4IkXB
        rbncldYuMOoObJRmO6gGFd1qha7wWIlh84i3KVDgFRBTdx10deWQUyY7R5//1wvTVIpjK7m09+V
        kO5QBTz2MC+wB
X-Received: by 2002:adf:ed4c:: with SMTP id u12mr10026074wro.204.1583402422953;
        Thu, 05 Mar 2020 02:00:22 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs1BoO4KZ5s7zmZKx1MVnI40qzqSNNmxzRndp8CmpnaWitVLFzRckZCZjjtUM9MSCoyPkYzyQ==
X-Received: by 2002:adf:ed4c:: with SMTP id u12mr10026049wro.204.1583402422768;
        Thu, 05 Mar 2020 02:00:22 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e11sm42114205wrm.80.2020.03.05.02.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 02:00:21 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix warning due to implicit truncation on 32-bit KVM
In-Reply-To: <20200305002422.20968-1-sean.j.christopherson@intel.com>
References: <20200305002422.20968-1-sean.j.christopherson@intel.com>
Date:   Thu, 05 Mar 2020 11:00:20 +0100
Message-ID: <87wo7zcea3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly cast the integer literal to an unsigned long when stuffing a
> non-canonical value into the host virtual address during private memslot
> deletion.  The explicit cast fixes a warning that gets promoted to an
> error when running with KVM's newfangled -Werror setting.
>
>   arch/x86/kvm/x86.c:9739:9: error: large integer implicitly truncated
>   to unsigned type [-Werror=overflow]
>
> Fixes: a3e967c0b87d3 ("KVM: Terminate memslot walks via used_slots"

Missing ')'

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ba4d476b79ad..fa03f31ab33c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9735,8 +9735,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		if (!slot || !slot->npages)
>  			return 0;
>  
> -		/* Stuff a non-canonical value to catch use-after-delete. */
> -		hva = 0xdeadull << 48;
> +		/*
> +		 * Stuff a non-canonical value to catch use-after-delete.  This
> +		 * ends up being 0 on 32-bit KVM, but there's no better
> +		 * alternative.
> +		 */
> +		hva = (unsigned long)(0xdeadull << 48);
>  		old_npages = slot->npages;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

