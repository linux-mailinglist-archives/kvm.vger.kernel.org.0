Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB6D4DA450
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351657AbiCOVGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244955AbiCOVGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8580611C06
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647378292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1r/SZEsNrbQgR8XCDBtO94cGTTINRL5AaqX8Y8QKbyM=;
        b=axv57qRrsoR00DXvRgN/jbaZIZLZjgZQasZuOxsNTDf9ZX8MinD0UGpIms5TR3BqG07ihc
        BH4J6f0xXFXVikrAIuFTkFHQpJ2O0lZ9DRgIltiL87WUViLn9hQCor67MFAD9NpULMMtIe
        dlFYb8ZAPHS1nxwNczJYaIEZPZ6RKRU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-aEhId8jTP0yxAGlmnmNk6g-1; Tue, 15 Mar 2022 17:04:51 -0400
X-MC-Unique: aEhId8jTP0yxAGlmnmNk6g-1
Received: by mail-ej1-f70.google.com with SMTP id hq34-20020a1709073f2200b006d677c94909so53875ejc.8
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:04:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1r/SZEsNrbQgR8XCDBtO94cGTTINRL5AaqX8Y8QKbyM=;
        b=vKdHN7m/HTbGYlyrCwXKVc1e3VFdiSzs3FYsfOcsl3S6RNeTBMe132FkWWdN8/ccyT
         Irz1QJwbBqDnjxqC09oCWSCOiBxvrrEBIGDLi4zmpfM3SRYUKFsjZzSnHJz2aN2x753f
         Tj3A0INfbpHkokMxpeTy8R2+nRkHjT1wg1zMbw9yd3llzn7XeyvaIlUXMP0DkzjV8SDm
         VZK9Whdcp9iLG+0ame61eqhuF02yRedzMNeQVzmgcTewshvXERe6cqWQQgcQqld4ZIU0
         GRQOlU/gWkebioEC3CUQ8+YNcy/V+ggoeWTMlRGd342mxfE87lO6qyuiWx58eEu00cPS
         Rp0g==
X-Gm-Message-State: AOAM531tC1hVM0dBb2axXGiK0h5PoCm2clWWCKV7666+lRW/XCbznPhq
        aautUT9d4phYpe6kMd/kpAy7AGlOmjY/eIP4zoNpGDEfrViY0c+0X8f0RuRQ/jF2+9au9G44QzR
        75bSYRAewpVCu
X-Received: by 2002:a17:907:2d10:b0:6db:e3f7:2cb2 with SMTP id gs16-20020a1709072d1000b006dbe3f72cb2mr7044451ejc.491.1647378290201;
        Tue, 15 Mar 2022 14:04:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFURJou0qHK3Ty0YITnet1XUuDQ4l0/RdLru/LNmM8UKD9zSw6Bk4nUOBNf8RjiKVC5dVhFQ==
X-Received: by 2002:a17:907:2d10:b0:6db:e3f7:2cb2 with SMTP id gs16-20020a1709072d1000b006dbe3f72cb2mr7044438ejc.491.1647378289947;
        Tue, 15 Mar 2022 14:04:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s4-20020a170906a18400b006db0a78bde8sm64359ejy.87.2022.03.15.14.04.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:04:49 -0700 (PDT)
Message-ID: <87fe8fef-ab3c-6459-6494-06d3d74308a6@redhat.com>
Date:   Tue, 15 Mar 2022 22:04:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2 4/5] KVM: X86: Handle implicit supervisor access with
 SMAP
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
 <20220311070346.45023-5-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220311070346.45023-5-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 08:03, Lai Jiangshan wrote:
> -	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
> -	int index = (pfec >> 1) +
> -		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
> +	bool explicit_access = !(access & PFERR_IMPLICIT_ACCESS);
> +	bool not_smap = (rflags & X86_EFLAGS_AC) && explicit_access;
> +	int index = (pfec + (!!not_smap << PFERR_RSVD_BIT)) >> 1;

Also possible:

         u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
         bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
         int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;

Paolo

