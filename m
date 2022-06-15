Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901AB54CA48
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353677AbiFONuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 09:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349034AbiFONuP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 09:50:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3E7540A2B
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655300998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAPbR5j85LOSc/uUO5yb0n9ef48ITqfSmedim8wIrpQ=;
        b=DFztoGtDgw6bj+VQD/FPax9S3dfvG9S36UKieynRjpIPSfljT8L01FOUXjBDbIGikXxSz/
        2Mu4vs0z4Pik1HeqEx5Lo7/Oujp96o2enUjuhsyt6jZKaWGlLLZZ29fSwHHqwF7X0jVOLb
        X47dnZ2oO850bguJQlGdOIs50KzXSqc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-hTC5aA4YO5aEPHgpzxzWDg-1; Wed, 15 Jun 2022 09:49:57 -0400
X-MC-Unique: hTC5aA4YO5aEPHgpzxzWDg-1
Received: by mail-wm1-f72.google.com with SMTP id v184-20020a1cacc1000000b0039c7efa3e95so5108129wme.3
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=qAPbR5j85LOSc/uUO5yb0n9ef48ITqfSmedim8wIrpQ=;
        b=TTMcLCRZuWmoAO4zaZeYFCb/pVmA4T0Fy5g1DXWYLvZyMQvAhvONt1vnxoYSeEMW4Q
         M899auilYFqjiNQdrqWPq2eH3zZ2QNodVCxi4uHCwL3dq0JyMKP6a3nSPRV4UUk1S5ea
         kowxqFnU6mPNKOyuNTnEXYR4c4BgTYDSHkbu9QrZk0hRLJTmsaHzI/GqhG2OX1IOF39k
         JCVoclQvrJww7SqCLSbYRR7auLoXMep/BwKZM4hxp1nWvmM/zn0hQOEgQK9PHVYDDlxZ
         H8MkYZ/YlC4x4igXXdeh2+UtwJcfDeEkFo5bSTOsH6ZVCyBvSOLEPzmpwGjMy5WGPBgY
         LzgQ==
X-Gm-Message-State: AJIora8Og+w37ji+NOFGBdcwBcgmhcxII+aI42TOo6Stcih/K3WmIsS4
        hfIZ+QkW3KCxSSQ+sPQ07eIaQTqqVldgUs+95+MCvfKYsjxgeJrLo/2zc5otyH8wku0PW9Bodnh
        JBi245/3xjAq/
X-Received: by 2002:a5d:64c7:0:b0:218:4a82:ffa4 with SMTP id f7-20020a5d64c7000000b002184a82ffa4mr10271117wri.592.1655300996316;
        Wed, 15 Jun 2022 06:49:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t68px3Z0pIFZrrZR8tfeumJ2fm/ZTWi69+daynHKKs9lxp7L+cgihOUkbg6rq7EGQUHj0u7Q==
X-Received: by 2002:a5d:64c7:0:b0:218:4a82:ffa4 with SMTP id f7-20020a5d64c7000000b002184a82ffa4mr10271100wri.592.1655300996055;
        Wed, 15 Jun 2022 06:49:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d14-20020a056000114e00b0020fffbc122asm17245348wrx.99.2022.06.15.06.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 06:49:55 -0700 (PDT)
Message-ID: <20a204f5-5606-2b4d-9342-f3d1f0146f20@redhat.com>
Date:   Wed, 15 Jun 2022 15:49:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
References: <20220614233328.3896033-1-seanjc@google.com>
 <20220614233328.3896033-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 5/8] KVM: x86/mmu: Use separate namespaces for guest
 PTEs and shadow PTEs
In-Reply-To: <20220614233328.3896033-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 01:33, Sean Christopherson wrote:
> @@ -2027,8 +2013,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   	role.direct = direct;
>   	role.access = access;
>   	if (role.has_4_byte_gpte) {
> -		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
> -		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
> +		quadrant = gaddr >> (PAGE_SHIFT + (SPTE_LEVEL_BITS * level));
> +		quadrant &= (1 << ((PT32_LEVEL_BITS - SPTE_LEVEL_BITS) * level)) - 1;
>   		role.quadrant = quadrant;

That's just a fancy 1, though, and this is just

	/*
	 * Isolate the bits of the address that have already been used by the
	 * 8-byte shadow page table structures, but not yet in the 4-byte guest
	 * page tables.  For example, a 4-byte PDE consumes bits 31:22 and an
	 * 8-byte PDE consumes bits 29:21, so bits 31:30 go in the hash
	 * key.  The hash table look up up ensures that each sPTE points to
	 * the page for the correct portion of the guest page table structure.
	 */
	quadrant = gaddr >> (PAGE_SHIFT + (SPTE_LEVEL_BITS * level));
	quadrant &= (1 << level) - 1;

(Not the best comment, understood).

Paolo

