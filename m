Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076F23B1F0E
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFWQ4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:56:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57456 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229889AbhFWQ4Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 12:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624467246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnWqNpZjxa8PSj4WCQhRZUcTS8WNyX/P84LcySX9I+0=;
        b=ekcc8ZitZ1dnUx0SzJ5bHryA5WNiBhQOiy6+ktrf4PtP6wKRkWl6EpBr0Jon1Vsz2nOP14
        ebn9FeVXRpkMpjN6KSdiz19r56kKp7O5HIm/kBPM8rlejNCJcuhyFD5F3B2C+rNnVwpzWD
        ck+D6+FV0wXBnHbASJmsDKSpkve/dKk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-6A6mqNr5MVK9ljYzHQydUw-1; Wed, 23 Jun 2021 12:54:04 -0400
X-MC-Unique: 6A6mqNr5MVK9ljYzHQydUw-1
Received: by mail-ed1-f72.google.com with SMTP id g13-20020a056402090db02903935a4cb74fso1679936edz.1
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vnWqNpZjxa8PSj4WCQhRZUcTS8WNyX/P84LcySX9I+0=;
        b=qYtU7Nstq9yyUTuewXM1dax2v0qgzc+vDYqQizHs+iNg4M568lNdpFRaWv/khbpFpz
         edb1to7IiU22ZbK5uoStVkqwCho1AIHDlX+zNufBeUQVD/rVMB0pvzQ0yT7WyhUI0tAz
         Zw3buJGT77xco0sCj4+kH4+Ze3RMciZI34X5OeU1rOwCYrY8pJ5Ka0Th22k7yXI5F4Je
         Z8T6tf9hV2kcQC9O9kBbO6x/t++z6A7s54xWPwl6ftYyLqtiUDBNQTCqPSm6KUG6Ofmz
         q6fEvHOF7Hy7AWA5PijFKu3p2z70unLvL4lf82/MimlHG8dRzIzAdfD3wiVlcIVzPChO
         gRVA==
X-Gm-Message-State: AOAM531AX+Y/ecabPuJwwA+5frVKzoXvnMJvf/3eKecIPXGGR06imymN
        qrrliq+YJouApk9sYQHTf99pJM45LzUC8A8UQ2MvrxmG9XEEVSkRG5PT0kpUj3VWthmb62oyjbg
        Wbw6BCi9tG8s3
X-Received: by 2002:a05:6402:30a8:: with SMTP id df8mr966977edb.7.1624467243559;
        Wed, 23 Jun 2021 09:54:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO0FxB536UZ2+tuygUHR0WhBNRzPenZ91hXh6Pvei98xcu2zGCe+8AWzSElLqLVbms1mcfVg==
X-Received: by 2002:a05:6402:30a8:: with SMTP id df8mr966961edb.7.1624467243383;
        Wed, 23 Jun 2021 09:54:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jz27sm143372ejc.33.2021.06.23.09.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 09:54:02 -0700 (PDT)
Subject: Re: [PATCH 12/54] KVM: x86/mmu: Drop the intermediate "transient"
 __kvm_sync_page()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-13-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ceaf3545-42ce-e855-bd3a-ac470edb7e08@redhat.com>
Date:   Wed, 23 Jun 2021 18:54:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:56, Sean Christopherson wrote:
> @@ -2008,10 +2001,19 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   			goto trace_get_page;
>   
>   		if (sp->unsync) {
> -			/* The page is good, but __kvm_sync_page might still end
> -			 * up zapping it.  If so, break in order to rebuild it.
> +			/*
> +			 * The page is good, but is stale.  "Sync" the page to
> +			 * get the latest guest state, but don't write-protect
> +			 * the page and don't mark it synchronized!  KVM needs
> +			 * to ensure the mapping is valid, but doesn't need to
> +			 * fully sync (write-protect) the page until the guest
> +			 * invalidates the TLB mapping.  This allows multiple
> +			 * SPs for a single gfn to be unsync.
> +			 *
> +			 * If the sync fails, the page is zapped.  If so, break
> +			 * If so, break in order to rebuild it.
>   			 */

This should be a separate patch I think.  In addition it should point out the
place where write protection does happen, which is mmu_unsync_children:

                         /*
                          * The page is good, but is stale.  kvm_sync_page does
                          * get the latest guest state, but (unlike mmu_unsync_children)
                          * it doesn't write-protect the page or mark it synchronized!
                          * This way the validity of the mapping is ensured, but the
                          * overhead of write protection is not incurred until the
                          * guest invalidates the TLB mapping.  This allows multiple
                          * SPs for a single gfn to be unsync.
                          *
                          * If the sync fails, the page is zapped.  If so, break
                          * in order to rebuild it.
                          */

Paolo

