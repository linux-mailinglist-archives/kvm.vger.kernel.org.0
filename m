Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB34B6BD055
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCPM7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCPM7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:59:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFE1B7892
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 05:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678971440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aX2QqFfdjp7jgV9E+zVgtvevlOLcc7y3m2q5zGbplzo=;
        b=D88Po9uHdf3MNwtBr54+APDmE8NJGrVeiHNay34FljH4yx5dsxyNhnydze7DvSuxmZzoYA
        Wlg2dkcVZI5oT+H7JQ9mz0PV7GUhB4t5/wfnVsXO6JfnCprgiRLVxXAl0UEvaS/OkSa2lL
        IFqNNVh4f8VY4mo+gPFuq7wUErCE/g8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-01_oZoozNNW7hOauhG_0vQ-1; Thu, 16 Mar 2023 08:57:19 -0400
X-MC-Unique: 01_oZoozNNW7hOauhG_0vQ-1
Received: by mail-wm1-f72.google.com with SMTP id t1-20020a7bc3c1000000b003dfe223de49so2586701wmj.5
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 05:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678971438;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aX2QqFfdjp7jgV9E+zVgtvevlOLcc7y3m2q5zGbplzo=;
        b=f66Yjzf33sTsouanc8obLctcm0v4V9D5IE6x2Emvn0gL90C6o1JAFCVobMPSOiUp7/
         Xo7dkPDChZS24e0vTBDu2vcbM/VjGvM6pR086dIC3SsAJEex+iVokZyfLBSTESi5byeg
         Q3hP9IkCjzCwGciS/FFIC07DeN71CHIfyIVxqmHvFGSUtwEGfU8LqoMBtHG6aetUrOKZ
         rrRld2xAv3pcFQ/A7iH1oHp1ixUlUOsuB1oIbrji/PkD9tFctSAqbKk39UOcBQn3y34p
         HCysa1PNZ9/VLqbWuf50AE5HH/f6cMq6TaZ+dIVS7jCS609GWW8n4q0VD/n32yV6mk1x
         Y42g==
X-Gm-Message-State: AO0yUKUhlNQj2n2DM+/EzNn2SYOve9Qbz5UoZHz7XkTGGpe/HXMPIy5Y
        AV9M8xmQWIRpG/BcOlXkS5qMXI3Xmf3R/tUNhS9qNJyOoSpsuwDgIIV+L02qwVdsWEPdJuQV+Lw
        Z2s+nZCj6CJKS
X-Received: by 2002:a05:6000:10c:b0:2d2:d324:e44f with SMTP id o12-20020a056000010c00b002d2d324e44fmr271726wrx.16.1678971438287;
        Thu, 16 Mar 2023 05:57:18 -0700 (PDT)
X-Google-Smtp-Source: AK7set/DVuxydZAtFqlh7no9cHVi1OrO/XtGtV8WY3e053BaX8Z97CrWK9FOKJ8lXi4bbekIK4OFJw==
X-Received: by 2002:a05:6000:10c:b0:2d2:d324:e44f with SMTP id o12-20020a056000010c00b002d2d324e44fmr271709wrx.16.1678971438008;
        Thu, 16 Mar 2023 05:57:18 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id x8-20020a5d60c8000000b002cea8664304sm7175075wrt.91.2023.03.16.05.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 05:57:17 -0700 (PDT)
Message-ID: <6467e120-67d4-84c6-20cc-c6426ea9e877@redhat.com>
Date:   Thu, 16 Mar 2023 13:57:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v10 03/16] x86/virt/tdx: Make INTEL_TDX_HOST depend on
 X86_X2APIC
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1678111292.git.kai.huang@intel.com>
 <d1e1295070bf6b34180978748e2d4be337c24e57.1678111292.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <d1e1295070bf6b34180978748e2d4be337c24e57.1678111292.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06.03.23 15:13, Kai Huang wrote:
> TDX capable platforms are locked to X2APIC mode and cannot fall back to
> the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
> requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.
> 
> Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

