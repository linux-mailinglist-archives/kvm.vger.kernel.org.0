Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81CD501D8C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 23:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244541AbiDNVhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 17:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiDNVhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 17:37:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B42267D0D
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 14:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649972089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+y0rTsN9NYq4kk+FFTr/ajEtcI961W4Mxu4oUxgLxck=;
        b=MbMYpQoFDmF9MBsW2Nh2sFZNR/zrp47NLeSFb0ibMffBijDI2jqGnX0bmEXfuE+6P55nAT
        xs8McMV9h31BvSYIfO4mF+gVNOzNzK2S72zHDRU+7gFjGpsnSABjUewav/1E7Z4AUEwPTO
        n9G2LPgV1VxRVbUFKlnsFudeVYzgeaw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-_B1WnQtjNMaBqra_PHaXuA-1; Thu, 14 Apr 2022 17:34:48 -0400
X-MC-Unique: _B1WnQtjNMaBqra_PHaXuA-1
Received: by mail-il1-f198.google.com with SMTP id v11-20020a056e0213cb00b002cbcd972206so3745754ilj.11
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 14:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+y0rTsN9NYq4kk+FFTr/ajEtcI961W4Mxu4oUxgLxck=;
        b=18pGjLUnupZ4J4o2vmUC1314rsQRNH2wGmER+zO0MuBL9p/3BdX8F1IMuAMRON8rI4
         Dg5VB/3hfQGzuPY9DU1ONykkYxE4vUMWqNtCmCEETrd199KqWdYGfJ9mKuBK/TfQXVOM
         CWcQTVW8zpUg6dfpXgl1sWAFkG9BP7i9nt8jb28szsF2kGSupeYQA/OoI5w7szI/OM3e
         YSQMLhxdeq+4hPZkYlwzqXL1LWyeVq4USQEgLuwvu+HrPlhFT6dkiSOp1AD3Fr8Oxhqv
         ZdDfo8YqTyGmvDQIjTM1PX0uapbXeNFI9tS7DRQjQ6eu4oihkVVTKHy2rLlKdzTrl3qV
         VOIQ==
X-Gm-Message-State: AOAM532AOFyLSirTE61QkoOwUuWdJw+OtCjnT7y2vXbd7EQVqXvANHvf
        ZpB9n0uk+DKHRMEKm8SUc7WdZtmu+CtyO48CIWxIZHBPgHWy7Vk/HWND3WXUDLtOCZuYjhWxNZg
        IzKRGWHwIe+Pq
X-Received: by 2002:a05:6638:268a:b0:326:6fab:af6 with SMTP id o10-20020a056638268a00b003266fab0af6mr2056935jat.280.1649972087657;
        Thu, 14 Apr 2022 14:34:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsz/H4zEgmUI9w3ohVvbnJW3K1Q3UuNlt8K1nemKc/C6G191ZhUEQeiG0Kzgr3FBEBEPhcSA==
X-Received: by 2002:a05:6638:268a:b0:326:6fab:af6 with SMTP id o10-20020a056638268a00b003266fab0af6mr2056928jat.280.1649972087404;
        Thu, 14 Apr 2022 14:34:47 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id e4-20020a056e020b2400b002ca9ffbb8fesm1825796ilu.72.2022.04.14.14.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 14:34:47 -0700 (PDT)
Date:   Thu, 14 Apr 2022 17:34:45 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
Message-ID: <YliTdb1LjfJoIcFc@xz-m1.local>
References: <20220414010703.72683-1-peterx@redhat.com>
 <Ylgn/Jw+FMIFqqc0@google.com>
 <bf15209d-2c50-9957-af24-c4f428f213b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bf15209d-2c50-9957-af24-c4f428f213b1@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 04:14:22PM +0200, Paolo Bonzini wrote:
> On 4/14/22 15:56, Sean Christopherson wrote:
> > > -	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> > > +	return ((vm_paddr_t)pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> > This is but one of many paths that can get burned by pfn being 40 bits.  The
> > most backport friendly fix is probably to add a pfn=>gpa helper and use that to
> > place the myriad "pfn * vm->page_size" instances.
> > 
> > For a true long term solution, my vote is to do away with the bit field struct
> > and use #define'd masks and whatnot.
> 
> Yes, bitfields larger than 32 bits are a mess.

It's very interesting to know this..

I just tried out with <32 bits bitfield and indeed gcc will behave
differently, by having the calculation done with 32bit (eax) rather than
64bit (rax).

The question is for >=32 bits it needs an extra masking instruction, while
that does not exist for the <32bits bitfield.

---8<---
#include <stdio.h>

struct test1 {
    unsigned long a:${X};
    unsigned long b:10;
};

int main(void)
{
    struct test1 val;
    val.a = 0x1234;
    printf("0x%lx\n", val.a * 16);
    return 0;
}
---8<---

When X=20:

0000000000401126 <main>:                                                                      
  401126:       55                      push   %rbp     
  401127:       48 89 e5                mov    %rsp,%rbp
  40112a:       48 83 ec 10             sub    $0x10,%rsp
  40112e:       8b 45 f8                mov    -0x8(%rbp),%eax
  401131:       25 00 00 f0 ff          and    $0xfff00000,%eax
  401136:       0d 34 12 00 00          or     $0x1234,%eax
  40113b:       89 45 f8                mov    %eax,-0x8(%rbp)
  40113e:       8b 45 f8                mov    -0x8(%rbp),%eax
  401141:       25 ff ff 0f 00          and    $0xfffff,%eax
  401146:       c1 e0 04                shl    $0x4,%eax     <----------- calculation (no further masking)
  401149:       89 c6                   mov    %eax,%esi
  40114b:       bf 10 20 40 00          mov    $0x402010,%edi
  401150:       b8 00 00 00 00          mov    $0x0,%eax
  401155:       e8 d6 fe ff ff          callq  401030 <printf@plt>

When X=40:

0000000000401126 <main>:                                                                      
  401126:       55                      push   %rbp                
  401127:       48 89 e5                mov    %rsp,%rbp                                      
  40112a:       48 83 ec 10             sub    $0x10,%rsp      
  40112e:       48 8b 45 f8             mov    -0x8(%rbp),%rax                                
  401132:       48 ba 00 00 00 00 00    movabs $0xffffff0000000000,%rdx                       
  401139:       ff ff ff                                                                      
  40113c:       48 21 d0                and    %rdx,%rax
  40113f:       48 0d 34 12 00 00       or     $0x1234,%rax
  401145:       48 89 45 f8             mov    %rax,-0x8(%rbp)
  401149:       48 b8 ff ff ff ff ff    movabs $0xffffffffff,%rax
  401150:       00 00 00 
  401153:       48 23 45 f8             and    -0x8(%rbp),%rax
  401157:       48 c1 e0 04             shl    $0x4,%rax    <------------ calculation
  40115b:       48 ba ff ff ff ff ff    movabs $0xffffffffff,%rdx
  401162:       00 00 00 
  401165:       48 21 d0                and    %rdx,%rax    <------------ masking (again)
  401168:       48 89 c6                mov    %rax,%rsi
  40116b:       bf 10 20 40 00          mov    $0x402010,%edi
  401170:       b8 00 00 00 00          mov    $0x0,%eax
  401175:       e8 b6 fe ff ff          callq  401030 <printf@plt>

That feels a bit less consistent to me, comparing to clang where at least
the behavior keeps the same for whatever length of bits in the bitfields.

Thanks,

-- 
Peter Xu

