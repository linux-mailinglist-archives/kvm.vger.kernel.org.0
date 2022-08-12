Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD0E590CD6
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 09:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbiHLHtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237221AbiHLHtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 03:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EA9DA6C0E
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 00:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P9aXlR/Mplh04GQrDWgRazGoxB/j8ggsCOd7dQOiifk=;
        b=N9SGhwdL/F97Ndjir5hSfC2kftqzFY879YzdXgyezATiS1JhCaypaczBhOGUkF3Sk5Ie3X
        ArKM9bMwgkUgVs3NWosUkN9V4SJtbdarbPDQA6H1oyHajus+QwoWoN8QLdZwUosQzU+S55
        2JVGkkGiRE83xDQyaeSMGuEMgpPUCk8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-182-KOCvlO1ZNWWToumkSrrfTA-1; Fri, 12 Aug 2022 03:49:12 -0400
X-MC-Unique: KOCvlO1ZNWWToumkSrrfTA-1
Received: by mail-ed1-f69.google.com with SMTP id j19-20020a05640211d300b0043ddce5c23aso172812edw.14
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 00:49:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=P9aXlR/Mplh04GQrDWgRazGoxB/j8ggsCOd7dQOiifk=;
        b=oCNVnSoBWiIKxwjzAtsp+Dwq9I2q/FpQw/cZa87a6T469Ml05K5xYQJtBEYjM1NUHA
         1gBT+Bu+v3+L9kRbKvgTexfk44BC5lflBf/Ee1ll8VWtSjmeOu6E5kpU0eqXFWT/40hG
         Dt/gWGe/5vSX47EPDs6vrIs31PxxwPrhy3wHkmFJ/xXQQzc0dPnB8sfCaXrlgKI7X3T5
         2F/4uLJnc2XQ3gzT/t5Buc+A6LY4DEPuCjzL6vtykHL0AVKwZlwE49UKICsVMsWmOQoa
         iB92zS+udY3C43vuqLBDR2DoxdmQ0d3h4B9VJWlCO6jtQTWxAxL/nBVHb7kzKa5QiSck
         uzTQ==
X-Gm-Message-State: ACgBeo1ii4QOUozcSL6vqABUcANx0Hk+OQ2gH3BTevL7kzh1Pvo0ptd5
        dprHZXaNeG5bngUOLcxIR/6pDWY7JJ1XFW0cv7D0Faio3wSZE1cjA3ARFCCOJ7X+lAmQdv2iM7u
        HpvDgAnbZ7VQx
X-Received: by 2002:a17:906:7309:b0:731:5c2:a9a6 with SMTP id di9-20020a170906730900b0073105c2a9a6mr1927017ejc.486.1660290550930;
        Fri, 12 Aug 2022 00:49:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR73en81mvQ3rlFGU0JoyKHAlXz7aryxpJTcMdrGUL8WTRn6f+/V2wLGkqFs5NiqLB0R0djPNw==
X-Received: by 2002:a17:906:7309:b0:731:5c2:a9a6 with SMTP id di9-20020a170906730900b0073105c2a9a6mr1927001ejc.486.1660290550764;
        Fri, 12 Aug 2022 00:49:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id f7-20020a056402068700b0043ce97fe4f7sm937094edy.44.2022.08.12.00.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:49:10 -0700 (PDT)
Message-ID: <a9035e7c-4587-6df7-c16c-e656d1734145@redhat.com>
Date:   Fri, 12 Aug 2022 09:49:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 0/2] KVM: selftests: Fix Clang build issues in
 KVM_ASM_SAFE()
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        "open list:CLANG/LLVM BUILD SUPPORT" <llvm@lists.linux.dev>,
        kvm list <kvm@vger.kernel.org>
References: <20220722234838.2160385-1-dmatlack@google.com>
 <CALzav=frNna1fZYTxwz+Lo=1=zsOLAKoAd3pntXfUiDNdJ_PoA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALzav=frNna1fZYTxwz+Lo=1=zsOLAKoAd3pntXfUiDNdJ_PoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/22 00:53, David Matlack wrote:
> On Fri, Jul 22, 2022 at 4:48 PM David Matlack <dmatlack@google.com> wrote:
>>
>> The LLVM integrated assembler has some differences from the GNU
>> assembler, and recent commit 3b23054cd3f5 ("KVM: selftests: Add x86-64
>> support for exception fixup") seems to be tripping over a few of those
>> differences.
> 
> Paolo, what do you think about these changes? I'm still hitting the
> mentioned Clang build issues on kvm/master, commit 93472b797153
> ("Merge tag 'kvmarm-5.20' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into
> HEAD").

I had missed them, so thanks for pinging.

Paolo

