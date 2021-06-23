Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0573B1BD3
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFWOCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 10:02:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230263AbhFWOCN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 10:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624456795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+F5l5QW3STX3y3/WEJ/bMw23bThzj09neVyyElnu8M=;
        b=DHUxPvCpa9YfjRomBooI3V6j2ZvBJM2vVRtBh35oHsEHsPCeAkGVlFthSxrXSZbQsGnS43
        tw942VMVIWC1WBfDkTvhRejIM1nlLdRIcBKmYQ8ljCLWjdUSBEadYwnPkPjTanAYC6plqi
        ZltZpPA/vw7WjX9/z+NDtG69F1SuBK4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-wcwPQeaZM267_LxB_zdZJw-1; Wed, 23 Jun 2021 09:59:53 -0400
X-MC-Unique: wcwPQeaZM267_LxB_zdZJw-1
Received: by mail-ej1-f71.google.com with SMTP id ho42-20020a1709070eaab02904a77ea3380eso1023993ejc.4
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 06:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W+F5l5QW3STX3y3/WEJ/bMw23bThzj09neVyyElnu8M=;
        b=T2PMmwSmXJ3TWAEaXM19sbmW+gSj+QlRYXeJE6lzS5B2qToizH763L1pCa7vnjSzIL
         ezSFAXpRjBBDP6TjfnlMguZ5kvG8w4ruP+JTn/fn3d4lbG2EtoOtrxzrw4HBO9UbKqnx
         WJhn0k17fEC1OC0+qs4aJ+8mAnp+bXRBXVOuucwtit+7qIhksZcc+JXp5wE+nQY98vL1
         9wki8vOfo9SCt1kig7wecdHjrV87BzeFASdd5u0FGUJLPtQ6KhdG1UMKXHcFZWNZPGUe
         CzXSZdlHXe1XYWv1CNThbD+JrSbLI3wCh45UdP43QaJQuMN99nNF+fpZE/ozgrV70pK/
         /TFw==
X-Gm-Message-State: AOAM532I532ascniNzHjkVy1piHTYAACTsBI6XPIIt9h7KhEytuNGp0S
        F83fFUkfHalcLp508CLpnVzi+bXsbzKh55vud5YQ33xpiUKH0AwFNkoz1qkZR0U9YLGcqfVimSB
        LTqaujVt4T0K2
X-Received: by 2002:aa7:dcd9:: with SMTP id w25mr9584655edu.372.1624456792872;
        Wed, 23 Jun 2021 06:59:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLHabZmyqKCiK4K8pfsG0grstezdILx8RDtMnSnWBdAxMkonqBuG3peMm/7+YrUFSAudLzSw==
X-Received: by 2002:aa7:dcd9:: with SMTP id w25mr9584628edu.372.1624456792651;
        Wed, 23 Jun 2021 06:59:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qq26sm7351945ejb.6.2021.06.23.06.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:59:52 -0700 (PDT)
Subject: Re: [PATCH 03/54] KVM: x86: Properly reset MMU context at vCPU
 RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2460a222-947a-6913-117c-f222f1dd0579@redhat.com>
Date:   Wed, 23 Jun 2021 15:59:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:56, Sean Christopherson wrote:
> +	/*
> +	 * Reset the MMU context if paging was enabled prior to INIT (which is
> +	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
> +	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
> +	 * checked because it is unconditionally cleared on INIT and all other
> +	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
> +	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
> +	 */
> +	if (old_cr0 & X86_CR0_PG)
> +		kvm_mmu_reset_context(vcpu);

Why not just check "if (init_event)", with a simple comment like

	/*
	 * Reset the MMU context in case paging was enabled prior to INIT (CR0
	 * will be '0' prior to RESET).
	 */

?

Paolo

