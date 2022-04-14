Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708A35017DD
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241249AbiDNPv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 11:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352718AbiDNPRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 11:17:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32250AF1DB
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649948729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lm2KX6xCsFISk/1YBbLurDta6IDegO+AQCRb/5z8eAw=;
        b=RY8UCyLYf/+ALTdlAOtoZ0Qif8gUflDU8Nvd0L7iB5PbzyFeD0bk9+p5g7/vNKGgT+Gifw
        hPrGwAMtITvlpCRqy31kw9CWuj5epao4z6CRdNTjSvtSVTFMDp4/QcnoGxBYTBbivySCS5
        t/AaVCzw272rg1Tu0F3TriP+z4e2JGM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-KwZOhR5DNP6phKCfHpVbfg-1; Thu, 14 Apr 2022 11:05:27 -0400
X-MC-Unique: KwZOhR5DNP6phKCfHpVbfg-1
Received: by mail-il1-f200.google.com with SMTP id k2-20020a056e02134200b002caaa88e702so3179526ilr.0
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lm2KX6xCsFISk/1YBbLurDta6IDegO+AQCRb/5z8eAw=;
        b=tGbEoUq+kEKa2KgN++anyp10p53IloidLsmKkcquBA7+smp4idLEb46GVrMABgmVjG
         SifIkZw7Tz0ubyRSese3brMGIVkQ8AcJG3htukN3v1oIHk1SRTQc/tuWz5z3k5SHyKEy
         /zbnmnSoIWhTiALwEFjwfUaROOrEeZX7a2TbNcYk7YOW652sD0XfSNDZX0fpal8QraeM
         LPrK1XRmeXt5gjaFonNqt2SZiKrf/v8tICNI/QtQgshvSzbiWVANjPMqSCJeN8FoW32U
         D8wnX+RzCFSPq549fFjCSRCKIySxBRfJMZKNE5AoBJx7InjFFi0TwTtRzMpy5S+pfHmi
         AbHg==
X-Gm-Message-State: AOAM530ersoshOO4zDBwr0zCoq1CDpG71lCAZhBhCWORHbc5cj85TvpU
        6XFkbeT1PYApJfDeEH2RZTA1U+5x4emo7HyABapg3cBVaLM/o+tP689QdGIjC4NBD8koasq7lXc
        RHY7v7JkdfhMm
X-Received: by 2002:a05:6638:16d2:b0:323:7285:474b with SMTP id g18-20020a05663816d200b003237285474bmr1492756jat.61.1649948726970;
        Thu, 14 Apr 2022 08:05:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyc/BZT0Z5C+G+l+ZYXKVVuTF4wLTQtkTki4+46inVlgigZB8yoPfeQABUizixqViIdsYjoWQ==
X-Received: by 2002:a05:6638:16d2:b0:323:7285:474b with SMTP id g18-20020a05663816d200b003237285474bmr1492738jat.61.1649948726653;
        Thu, 14 Apr 2022 08:05:26 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id v11-20020a92d24b000000b002caacf87598sm1177280ilg.1.2022.04.14.08.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:05:26 -0700 (PDT)
Date:   Thu, 14 Apr 2022 11:05:25 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] kvm: selftests: Fix cut-off of addr_gva2gpa lookup
Message-ID: <Ylg4Nel3rDpHUzKT@xz-m1.local>
References: <20220414010703.72683-1-peterx@redhat.com>
 <Ylgn/Jw+FMIFqqc0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ylgn/Jw+FMIFqqc0@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 01:56:12PM +0000, Sean Christopherson wrote:
> On Wed, Apr 13, 2022, Peter Xu wrote:
> > Our QE team reported test failure on access_tracking_perf_test:
> > 
> > Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> > guest physical test memory offset: 0x3fffbffff000
> > 
> > Populating memory             : 0.684014577s
> > Writing to populated memory   : 0.006230175s
> > Reading from populated memory : 0.004557805s
> > ==== Test Assertion Failure ====
> >   lib/kvm_util.c:1411: false
> >   pid=125806 tid=125809 errno=4 - Interrupted system call
> >      1  0x0000000000402f7c: addr_gpa2hva at kvm_util.c:1411
> >      2   (inlined by) addr_gpa2hva at kvm_util.c:1405
> >      3  0x0000000000401f52: lookup_pfn at access_tracking_perf_test.c:98
> >      4   (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
> >      5   (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
> >      6  0x00007fefe9ff81ce: ?? ??:0
> >      7  0x00007fefe9c64d82: ?? ??:0
> >   No vm physical memory at 0xffbffff000
> > 
> > And I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46
> > bits PA.
> > 
> > It turns out that the address translation for clearing idle page tracking
> > returned wrong result, in which addr_gva2gpa()'s last step should have
> 
> "should have" is very misleading, that makes it sound like the address was
> intentionally truncated.  Or did you mean "should have been treated as 64-bit
> value"?

No I was purely lazy yesterday as it was late, sorry.  Obviously I should
have hold-off the patch until this morning because I do plan to look at
this into more details.

So sadly it's only gcc that's not working properly with the bitfields.. at
least in my minimum test here.

---8<---
$ cat a.c
#include <stdio.h>

struct test1 {
    unsigned long a:24;
    unsigned long b:40;
};

int main(void)
{
    struct test1 val;
    val.b = 0x123456789a;
    printf("0x%lx\n", val.b * 16);
    return 0;
}
$ gcc -o a.gcc a.c
$ clang -o a.clang a.c
$ ./a.gcc
0x23456789a0
$ ./a.clang
0x123456789a0
$ objdump -d a.gcc | grep -A20 -w main
0000000000401126 <main>:
  401126:       55                      push   %rbp
  401127:       48 89 e5                mov    %rsp,%rbp
  40112a:       48 83 ec 10             sub    $0x10,%rsp
  40112e:       48 8b 45 f8             mov    -0x8(%rbp),%rax
  401132:       25 ff ff ff 00          and    $0xffffff,%eax
  401137:       48 89 c2                mov    %rax,%rdx
  40113a:       48 b8 00 00 00 9a 78    movabs $0x123456789a000000,%rax
  401141:       56 34 12
  401144:       48 09 d0                or     %rdx,%rax
  401147:       48 89 45 f8             mov    %rax,-0x8(%rbp)
  40114b:       48 8b 45 f8             mov    -0x8(%rbp),%rax
  40114f:       48 c1 e8 18             shr    $0x18,%rax
  401153:       48 c1 e0 04             shl    $0x4,%rax
  401157:       48 ba ff ff ff ff ff    movabs $0xffffffffff,%rdx
  40115e:       00 00 00
  401161:       48 21 d0                and    %rdx,%rax     <-------------------
  401164:       48 89 c6                mov    %rax,%rsi
  401167:       bf 10 20 40 00          mov    $0x402010,%edi
  40116c:       b8 00 00 00 00          mov    $0x0,%eax
  401171:       e8 ba fe ff ff          callq  401030 <printf@plt>
$ objdump -d a.clang | grep -A20 -w main
0000000000401130 <main>:
  401130:       55                      push   %rbp
  401131:       48 89 e5                mov    %rsp,%rbp
  401134:       48 83 ec 10             sub    $0x10,%rsp
  401138:       c7 45 fc 00 00 00 00    movl   $0x0,-0x4(%rbp)
  40113f:       48 8b 45 f0             mov    -0x10(%rbp),%rax
  401143:       48 25 ff ff ff 00       and    $0xffffff,%rax
  401149:       48 b9 00 00 00 9a 78    movabs $0x123456789a000000,%rcx
  401150:       56 34 12 
  401153:       48 09 c8                or     %rcx,%rax
  401156:       48 89 45 f0             mov    %rax,-0x10(%rbp)
  40115a:       48 8b 75 f0             mov    -0x10(%rbp),%rsi
  40115e:       48 c1 ee 18             shr    $0x18,%rsi
  401162:       48 c1 e6 04             shl    $0x4,%rsi
  401166:       48 bf 10 20 40 00 00    movabs $0x402010,%rdi
  40116d:       00 00 00 
  401170:       b0 00                   mov    $0x0,%al
  401172:       e8 b9 fe ff ff          callq  401030 <printf@plt>
  401177:       31 c0                   xor    %eax,%eax
  401179:       48 83 c4 10             add    $0x10,%rsp
  40117d:       5d                      pop    %rbp
---8<---

> 
> > treated "pte[index[0]].pfn" to be a 32bit value.
> 
> It didn't get treated as a 32-bit value, it got treated as a 40-bit value, because
> the pfn is stored as 40 bits.
> 
> struct pageTableEntry {
> 	uint64_t present:1;
> 	uint64_t writable:1;
> 	uint64_t user:1;
> 	uint64_t write_through:1;
> 	uint64_t cache_disable:1;
> 	uint64_t accessed:1;
> 	uint64_t dirty:1;
> 	uint64_t reserved_07:1;
> 	uint64_t global:1;
> 	uint64_t ignored_11_09:3;
> 	uint64_t pfn:40;  <================
> 	uint64_t ignored_62_52:11;
> 	uint64_t execute_disable:1;
> };
> 
> > In above case the GPA
> > address 0x3fffbffff000 got cut-off into 0xffbffff000, then it caused
> > further lookup failure in the gpa2hva mapping.
> > 
> > I didn't yet check any other test that may fail too on some hosts, but
> > logically any test using addr_gva2gpa() could suffer.
> > 
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > index 9f000dfb5594..6c356fb4a9bf 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> > @@ -587,7 +587,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> >  	if (!pte[index[0]].present)
> >  		goto unmapped_gva;
> >  
> > -	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> > +	return ((vm_paddr_t)pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
> 
> This is but one of many paths that can get burned by pfn being 40 bits.  The
> most backport friendly fix is probably to add a pfn=>gpa helper and use that to
> place the myriad "pfn * vm->page_size" instances.

Yes, I'll respin.

> 
> For a true long term solution, my vote is to do away with the bit field struct
> and use #define'd masks and whatnot.

I agree.

Thanks,

-- 
Peter Xu

