Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A842E4B24AC
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349589AbiBKLpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:45:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiBKLpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:45:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16277EBC
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644579932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQ8YEo22ps5NigvvVJRI9VbNgqerPawLnII9A47TtAk=;
        b=ao0Fg8SA/54JqVenKHZkgEW8SzDK6HEaJYIZ0bqqulrHuI5r5hMuM6RFUiYxiJJte/Hd3g
        xmCKlXD5UryjO21XF0p765udnizJ1qooy00qlez5tuRITwHzxHNAWFoNI7M6LFd7fqKkUE
        lnybS0VmwPb7XhQsUEBB9mDtyNGyTSI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-KlwEEOsFPlGeUZMyJTifrA-1; Fri, 11 Feb 2022 06:45:31 -0500
X-MC-Unique: KlwEEOsFPlGeUZMyJTifrA-1
Received: by mail-wm1-f71.google.com with SMTP id bg16-20020a05600c3c9000b0034bea12c043so5779860wmb.7
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:45:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DQ8YEo22ps5NigvvVJRI9VbNgqerPawLnII9A47TtAk=;
        b=4ehm/xwypl6BpbGLFqm01f7CouF4U+/R8GnSZA9r8GiGyHctk2cJU5yt3h0AbqJ6a+
         Olh76TZUTUhpWXoNDRfrRbGmF2YyvRDK830XBevmIA6AFaS+SKtj+V2L23+u4vCwJweS
         ZwlfmupKdeYqZd90vcfoZOfeo0ZfzNODOBaH/0ekjEoVopejnWjRnj6lFjln6NZ7xn3I
         2awxqRix1WjyL80fEtIge/miS9Qw9SUObP/oj/9+1YfkDWf33RRXAm3GeEEhm0EMnSib
         kqbpwWlZSRe6LGAGGO4jWGEq1GAGs7mJ1m3XwMLUGvvu8jx20Pe5fcuT7VJ25Y9wh6xW
         I2rQ==
X-Gm-Message-State: AOAM530ntJg05nxcfebmvbPkixBl7IpcXiQLPO13F4zjDeCJ/1BuGtap
        ShsgWjiEG+lAfcKIEufseb/Q0EegEz1iH4keql4AiMn6xzHxaOhVzkH5PiSvYU5VY8V1Aumel6u
        tXwumKHSfcGzL
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr1079849wrr.168.1644579929884;
        Fri, 11 Feb 2022 03:45:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyyHxJw23lPiOuOKGQuFMysTofU8rIByb81GZfOLYpN/WVJ5RLk+oIb8abUTzeFuBojd/jcoQ==
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr1079834wrr.168.1644579929581;
        Fri, 11 Feb 2022 03:45:29 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u11sm17593465wrt.108.2022.02.11.03.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 03:45:28 -0800 (PST)
Message-ID: <51fcfb88-417b-e638-78b7-bbca82d8bd8b@redhat.com>
Date:   Fri, 11 Feb 2022 12:45:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 09/12] KVM: MMU: look for a cached PGD when going from
 32-bit to 64-bit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-10-pbonzini@redhat.com> <YgW8ySdRSWjPvOQx@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgW8ySdRSWjPvOQx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 02:32, Sean Christopherson wrote:
> Maybe cached_root_find_and_rotate() or cached_root_find_and_age()?

I'll go for cached_root_find_and_keep_current() and 
cached_root_find_without_current(), respectively.

> 
> Hmm, while we're refactoring this, I'd really prefer we not grab vcpu->arch.mmu
> way down in the helpers.  @vcpu is needed only for the request, so what about
> doing this?
> 
> 	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
> 		/*
> 		 * <whatever kvm_mmu_reload() becomes> will set up a new root
> 		 * prior to the next VM-Enter.  Free the current root if it's
> 		 * valid, i.e. if a valid root was evicted from the cache.
> 		 */
> 		if (VALID_PAGE(vcpu->arch.mmu->root.hpa))
> 			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> 		return;
> 	}

I tried, but it's much easier to describe the cache functions if their 
common postcondition is "vcpu->arch.mmu->root.hpa is never stale"; which 
requires not a struct kvm_vcpu* but at least a struct kvm*, for the MMU 
lock.

I could change kvm_mmu_free_roots and cached_root_* to take a struct 
kvm* plus a struct kvm_mmu*.  Does that sound better?

Paolo

