Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2745783440
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjHUU1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 16:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjHUU1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 16:27:34 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EF8E3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 13:27:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 165D684;
        Mon, 21 Aug 2023 13:27:30 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id AvSqfoOeBXHq; Mon, 21 Aug 2023 13:27:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 86CE239;
        Mon, 21 Aug 2023 13:27:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 86CE239
Date:   Mon, 21 Aug 2023 13:27:25 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
Message-ID: <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net>
References: <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com> <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com> <ZNJ2V2vRXckMwPX2@google.com>
 <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net> <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net> <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net> <ZN+BRjUxouKiDSbx@google.com>
 <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1343589949-1692649645=:24657"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1343589949-1692649645=:24657
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 18 Aug 2023, Eric Wheeler wrote:
> On Fri, 18 Aug 2023, Sean Christopherson wrote:
> > On Thu, Aug 17, 2023, Eric Wheeler wrote:
> > > On Thu, 17 Aug 2023, Sean Christopherson wrote:
> > > > > > kprobe:handle_ept_violation
> > > > > > {
> > > > > > 	printf("vcpu = %lx pid = %u MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> > > > > > 	       arg0, ((struct kvm_vcpu *)arg0)->pid->numbers[0].nr,
> > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_seq,
> > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_in_progress,
> > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_start,
> > > > > > 	       ((struct kvm_vcpu *)arg0)->kvm->mmu_invalidate_range_end);
> > > > > > }
> > > > > > 
> > > > > > If you don't have BTF info, we can still use a bpf program, but to get at the
> > > > > > fields of interested, I think we'd have to resort to pointer arithmetic with struct
> > > > > > offsets grab from your build.
> > > > > 
> > > > > We have BTF, so hurray for not needing struct offsets!

We found a new sample in 6.1.38, right after a lockup, where _all_ log 
entries show inprog=1, in case that is interesting. Here is a sample, 
there are 500,000+ entries so let me know if you want the whole log.

To me, these are opaque numbers.  What do they represent?  What are you looking for in them?

      1 ept[0] vcpu=ffff9964cdc48000 seq=80854227 inprog=1 start=7fa3183a3000 end=7fa3183a4000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854228 inprog=1 start=7fa3183a3000 end=7fa3183a4000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854229 inprog=1 start=7fa3183a4000 end=7fa3183a5000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085422a inprog=1 start=7fa3183a4000 end=7fa3183a5000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085422b inprog=1 start=7fa3183a8000 end=7fa3183a9000
      2 ept[0] vcpu=ffff9964cdc48000 seq=8085422d inprog=1 start=7fa3183a9000 end=7fa3183aa000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085422e inprog=1 start=7fa3183a9000 end=7fa3183aa000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854232 inprog=1 start=7fa3183ac000 end=7fa3183ad000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854233 inprog=1 start=7fa3183ad000 end=7fa3183ae000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854235 inprog=1 start=7fa3183ae000 end=7fa3183af000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854236 inprog=1 start=7fa3183ae000 end=7fa3183af000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854237 inprog=1 start=7fa3183b1000 end=7fa3183b2000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854239 inprog=1 start=7fa3183b3000 end=7fa3183b4000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085423a inprog=1 start=7fa3183b3000 end=7fa3183b4000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085423d inprog=1 start=7fa3183b7000 end=7fa3183b8000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085423e inprog=1 start=7fa3183b7000 end=7fa3183b8000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085423f inprog=1 start=7fa3183b8000 end=7fa3183b9000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854240 inprog=1 start=7fa3183b8000 end=7fa3183b9000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854241 inprog=1 start=7fa3183b9000 end=7fa3183ba000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854242 inprog=1 start=7fa3183b9000 end=7fa3183ba000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854243 inprog=1 start=7fa3183ba000 end=7fa3183bb000
      2 ept[0] vcpu=ffff9964cdc48000 seq=80854244 inprog=1 start=7fa3183ba000 end=7fa3183bb000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854246 inprog=1 start=7fa3183bb000 end=7fa3183bc000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854247 inprog=1 start=7fa3183bc000 end=7fa3183bd000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854248 inprog=1 start=7fa3183bc000 end=7fa3183bd000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854249 inprog=1 start=7fa3183bd000 end=7fa3183be000
      2 ept[0] vcpu=ffff9964cdc48000 seq=8085424b inprog=1 start=7fa3183be000 end=7fa3183bf000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085424c inprog=1 start=7fa3183be000 end=7fa3183bf000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085424e inprog=1 start=7fa3183bf000 end=7fa3183c0000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854250 inprog=1 start=7fa3183c0000 end=7fa3183c1000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854251 inprog=1 start=7fa3183c1000 end=7fa3183c2000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854255 inprog=1 start=7fa3183c5000 end=7fa3183c6000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854256 inprog=1 start=7fa3183c5000 end=7fa3183c6000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854257 inprog=1 start=7fa3183c6000 end=7fa3183c7000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854259 inprog=1 start=7fa3183c7000 end=7fa3183c8000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085425a inprog=1 start=7fa3183c7000 end=7fa3183c8000
      2 ept[0] vcpu=ffff9964cdc48000 seq=8085425b inprog=1 start=7fa3183c8000 end=7fa3183c9000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085425c inprog=1 start=7fa3183c8000 end=7fa3183c9000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085425e inprog=1 start=7fa3183c9000 end=7fa3183ca000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854260 inprog=1 start=7fa3183ca000 end=7fa3183cb000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854261 inprog=1 start=7fa3183cb000 end=7fa3183cc000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854262 inprog=1 start=7fa3183cb000 end=7fa3183cc000
      2 ept[0] vcpu=ffff9964cdc48000 seq=80854263 inprog=1 start=7fa3183ce000 end=7fa3183cf000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854264 inprog=1 start=7fa3183ce000 end=7fa3183cf000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854265 inprog=1 start=7fa3183cf000 end=7fa3183d0000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854266 inprog=1 start=7fa3183cf000 end=7fa3183d0000
      1 ept[0] vcpu=ffff9964cdc48000 seq=80854268 inprog=1 start=7fa3183d4000 end=7fa3183d5000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085426b inprog=1 start=7fa3183d6000 end=7fa3183d7000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085426c inprog=1 start=7fa3183d6000 end=7fa3183d7000
      1 ept[0] vcpu=ffff9964cdc48000 seq=8085426d inprog=1 start=7fa3183d7000 end=7fa3183d8000

Thanks,

-Eric


> 
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32524620 inprog=1 start=7f32477d7000 end=7f32477d8000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32524aee inprog=1 start=7f3252209000 end=7f325220a000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32527895 inprog=1 start=7f329504d000 end=7f329504e000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=325279eb inprog=1 start=7f3296f00000 end=7f3296f01000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=325279f5 inprog=1 start=7f3296fae000 end=7f3296faf000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32527b4d inprog=1 start=7f329937e000 end=7f329937f000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32525ef6 inprog=1 start=7f3272503000 end=7f3272504000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32526517 inprog=1 start=7f327a568000 end=7f327a569000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=325268e8 inprog=1 start=7f327e4a4000 end=7f327e4a5000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=32527543 inprog=1 start=7f328f8ca000 end=7f328f8cb000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c861ab6 inprog=1 start=7fb4c67de000 end=7fb4c67df000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c862600 inprog=1 start=7fb48c132000 end=7fb48c133000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c862a8b inprog=1 start=7fb4f06b8000 end=7fb4f06b9000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c862b9f inprog=1 start=7fb4f1861000 end=7fb4f1862000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c862d33 inprog=1 start=7fb4e72f5000 end=7fb4e72f6000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c86415c inprog=1 start=7fb49fb5a000 end=7fb49fb5b000
>       1 ept[0] vcpu=ffff9c43d5618000 seq=1c864162 inprog=1 start=7fb49fb59000 end=7fb49fb5a000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862ba1 inprog=1 start=7fb4f0e24000 end=7fb4f0e25000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862bab inprog=1 start=7fb4f0e26000 end=7fb4f0e27000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862bb1 inprog=1 start=7fb4f0e27000 end=7fb4f0e28000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862cbd inprog=1 start=7fb4efffd000 end=7fb4efffe000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862cc4 inprog=1 start=7fb4f0692000 end=7fb4f0693000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862d32 inprog=1 start=7fb4dd282000 end=7fb4dd283000
>       1 ept[0] vcpu=ffff9c533e1dc680 seq=1c862d36 inprog=1 start=7fb4e8e97000 end=7fb4e8e98000
>       1 ept[0] vcpu=ffff9c436d26c680 seq=3252adeb inprog=1 start=7f326209b000 end=7f326209c000
> 
> The entire dump is 22,687 lines if you want to see it, here (expires in 1 week):
> 
> 	https://privatebin.net/?9a3bff6b6fd2566f#BHjrt4NGpoXL12NWiUDpThifi9E46LNXCy7eWzGXgqYx
> 
> > > 
> > > What is involved in doing this with struct offsets for Linux v6.1.x?
> > 
> > Unless you are up for a challenge, I'd drop the PID entirely, getting that will
> > be ugly.
> > 
> > For the KVM info, you need the offset of "kvm" within struct kvm_vcpu (more than
> > likely it's '0'), and then the offset of each of the mmu_invaliate_* fields within
> > struct kvm.  These need to come from the exact kernel you're running, though unless
> > a field is added/removed to/from struct kvm between kernel versions, the offsets
> > should be stable.
> > 
> > A cheesy/easy way to get the offsets is to feed offsetof() into __aligned and
> > then compile.  So long as the offset doesn't happen to be a power-of-2, the
> > compiler will yell.  E.g. with this
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 92c50dc159e8..04ec37f7374a 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -543,7 +543,13 @@ struct kvm_hva_range {
> >   */
> >  static void kvm_null_fn(void)
> >  {
> > +       int v __aligned(offsetof(struct kvm_vcpu, kvm));
> > +       int w __aligned(offsetof(struct kvm, mmu_invalidate_seq));
> > +       int x __aligned(offsetof(struct kvm, mmu_invalidate_in_progress));
> > +       int y __aligned(offsetof(struct kvm, mmu_invalidate_range_start));
> > +       int z __aligned(offsetof(struct kvm, mmu_invalidate_range_end));
> >  
> > +       v = w = x = y = z = 0;
> >  }
> >  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
> > 
> > I get yelled at with (trimmed):
> > 
> > arch/x86/kvm/../../../virt/kvm/kvm_main.c:546:34: error: requested alignment ‘0’ is not a positive power of 2 [-Werror=attributes]
> > arch/x86/kvm/../../../virt/kvm/kvm_main.c:547:20: error: requested alignment ‘36960’ is not a positive power of 2
> > arch/x86/kvm/../../../virt/kvm/kvm_main.c:549:20: error: requested alignment ‘36968’ is not a positive power of 2
> > arch/x86/kvm/../../../virt/kvm/kvm_main.c:551:20: error: requested alignment ‘36976’ is not a positive power of 2
> > arch/x86/kvm/../../../virt/kvm/kvm_main.c:553:20: error: requested alignment ‘36984’ is not a positive power of 2
> 
> Neat trick.
> 
> So here are my numbers:
> 
> # make modules  KDIR=virt 2>&1 | grep -A1 alignment |grep -v ^-
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:568:40: error: requested alignment ‘0’ is not a positive power of 2 [-Werror=attributes]
>   568 |        int v __aligned(offsetof(struct kvm_vcpu, kvm));
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:569:40: error: requested alignment ‘39552’ is not a positive power of 2
>   569 |        int w __aligned(offsetof(struct kvm, mmu_invalidate_seq));
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:570:40: error: requested alignment ‘39560’ is not a positive power of 2
>   570 |        int x __aligned(offsetof(struct kvm, mmu_invalidate_in_progress));
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:571:40: error: requested alignment ‘39568’ is not a positive power of 2
>   571 |        int y __aligned(offsetof(struct kvm, mmu_invalidate_range_start));
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:572:40: error: requested alignment ‘39576’ is not a positive power of 2
>   572 |        int z __aligned(offsetof(struct kvm, mmu_invalidate_range_end));
> 
> and the resulting script:
> 	kprobe:handle_ept_violation
> 	{
> 		$kvm = *((uint64 *)((uint64)arg0 + 0));
> 
> 		printf("vcpu=%08lx seq=%08lx inprog=%lx start=%08lx end=%08lx\n",
> 			arg0, 
> 		       *((uint64 *)($kvm + 39552)),
> 		       *((uint64 *)($kvm + 39560)),
> 		       *((uint64 *)($kvm + 39568)),
> 		       *((uint64 *)($kvm + 39576))
> 		       );
> 	}
> 
> ... but the output shows all 0's except vcpu:
> 
> 	# bpftrace ./handle_ept_violation.bt |grep ^vcpu | uniq -c
> 	     11 vcpu=ffff9d518541c680 seq=00000000 inprog=0 start=00000000 end=00000000
> 	     29 vcpu=ffff9d80cc120000 seq=00000000 inprog=0 start=00000000 end=00000000
> 	    331 vcpu=ffff9d5f1d1a2340 seq=00000000 inprog=0 start=00000000 end=00000000
> 	    858 vcpu=ffff9d80c7b98000 seq=00000000 inprog=0 start=00000000 end=00000000
> 	   2183 vcpu=ffff9d6033fb2340 seq=00000000 inprog=0 start=00000000 end=00000000
> 
> Did I do something wrong here?
> 
> -Eric
> 
> > 
> > Then take those offsets and do math.  For me, this provides the same output as
> > the above pretty version.  Just use common sense and verify you're getting sane
> > data.
> > 
> > kprobe:handle_ept_violation
> > {
> > 	$kvm = *((uint64 *)((uint64)arg0 + 0));
> > 
> > 	printf("vcpu = %lx MMU seq = %lx, in-prog = %lx, start = %lx, end = %lx\n",
> > 	       arg0,
> >                *((uint64 *)($kvm + 36960)),
> >                *((uint64 *)($kvm + 36968)),
> >                *((uint64 *)($kvm + 36976)),
> >                *((uint64 *)($kvm + 36984)));
> > }
> > 
> > 
> 
> 
> 
> 
> 
> 
> --
> Eric Wheeler
> 
> 
--8323328-1343589949-1692649645=:24657--
