Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 397BB7C566D
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 16:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjJKOK6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 11 Oct 2023 10:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjJKOK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 10:10:57 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C3D90;
        Wed, 11 Oct 2023 07:10:54 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5F6H5xhmz6K6hC;
        Wed, 11 Oct 2023 22:10:31 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Wed, 11 Oct
 2023 15:10:52 +0100
Date:   Wed, 11 Oct 2023 15:10:51 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
CC:     Gregory Price <gregory.price@memverge.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Ira Weiny" <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-cxl@vger.kernel.org>, <qemu-devel@nongnu.org>
Subject: Re: Accessing emulated CXL memory is unstable
Message-ID: <20231011151051.0000343c@Huawei.com>
In-Reply-To: <CAB=+i9S_uAUfPWSR2mJ=EzB-O2w-puK232CxbgWn8mx+YpMJCQ@mail.gmail.com>
References: <CAB=+i9S4NSJ7iNvqguWKvFvo=cMQC21KeNETsqmJoEpj+iDmig@mail.gmail.com>
        <ZSKupRw+mRrASUaY@memverge.com>
        <CAB=+i9S_uAUfPWSR2mJ=EzB-O2w-puK232CxbgWn8mx+YpMJCQ@mail.gmail.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Oct 2023 09:50:07 +0900
Hyeonggon Yoo <42.hyeyoo@gmail.com> wrote:

> On Wed, Oct 11, 2023 at 12:54 AM Gregory Price
> <gregory.price@memverge.com> wrote:
> >
> > On Tue, Oct 10, 2023 at 10:35:03AM +0900, Hyeonggon Yoo wrote:  
> > > Hello folks,
> > >
> > > I experienced strange application crashes/internal KVM errors
> > > while playing with emulated type 3 CXL memory. I would like to know
> > > if this is a real issue or I missed something during setup.
> > >
> > > TL;DR: applications crash when accessing emulated CXL memory,
> > > and stressing VM subsystem causes KVM internal error
> > > (stressing via stress-ng --bigheap)
> > >  
> > ...  
> > >
> > > Hmm... it crashed, and it's 'invalid opcode'.
> > > Is this because the fetched instruction is different from what's
> > > written to memory during exec()?
> > >  
> >
> > This is a known issue, and the working theory is 2 issues:  
> 
> Okay, at least it's a known issue. Thank you for confirming that!
Yeah - have an outstanding request in my list to at least print a
warning on this.  There are usecases where you want to use KVM
and the emulated support but there are gremlins as you discovered.

> 
> >
> > 1) CXL devices are implemented on top of an MMIO-style dispatch system
> >    and as a result memory from CXL is non-cacheable.  We think there
> >    may be an issue with this in KVM but it hasn't been investigated
> >    fully.
> >
> > 2) When we originally got CXL memory support, we discovered an edge case
> >    where code pages hosted on CXL memory would cause a crash whenever an
> >    instruction spanned across a page barrier.  A similar issue could
> >    affect KVM.

The TCG case was thought to be fixed.  KVM will indeed blow up if you
try to run instructions out of the emulated CXL memory whether or not they
cross page boundaries.  That could be fixed by a caching layer inbetween
so KVM thought it was running on page based translation but CXL was
doing some interesting write back stuff underneath. Can sort of see how
it might work but it's complex.

> >
> > We haven't done much research into the problem beyond this.  For now, we
> > all just turn KVM off while we continue development.  
> 
> Thank you for summarizing the current state of the issue.
> Hope it will be resolved! ;)

Any resolution whilst retaining the full routing / decoder emulation in
QEMU is tricky to put it lightly.  No one has taken it on yet as mostly
TCG get's us going.

> 
> But I'm not sure if turning off KVM solves the problem.
> `numactl --membind=1 --show` works fine, but other basic UNIX commands like ls
> crashes QEMU when it's bind to the CXL NUMA node.

Hmm. This is new if KVM is definitely off?

> 
> [root@localhost ~]# numactl --membind=1 --show
> policy: bind
> preferred node: 1
> physcpubind: 0
> cpubind: 0
> nodebind: 0
> membind: 1
> [root@localhost ~]# numactl --membind=1 ls
> 
> qemu: fatal: cpu_io_recompile: could not find TB for pc=(nil)
> RAX=0000777f80000000 RBX=0000000000000000 RCX=0000000000000028
> RDX=0000000000000000
> RSI=0000000000000354 RDI=0000000000000000 RBP=ffff88810628af40
> RSP=ffffc900008cfd20
> R8 =ffff88810628af40 R9 =ffffc900008cfcc4 R10=000000000000000d
> R11=0000000000000000
> R12=0000000390440000 R13=ffff888107a464c0 R14=0000000000000000
> R15=ffff88810a49cd18
> RIP=ffffffff810743e6 RFL=00000007 [-----PC] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 0000000000000000 00000000 00000000
> CS =0010 0000000000000000 ffffffff 00af9b00 DPL=0 CS64 [-RA]
> SS =0000 0000000000000000 00000000 00000000
> DS =0000 0000000000000000 00000000 00000000
> FS =0000 0000000000000000 00000000 00000000
> GS =0000 ffff88817bc00000 00000000 00000000
> LDT=0000 0000000000000000 00000000 00008200 DPL=0 LDT
> TR =0040 fffffe0000003000 00004087 00008900 DPL=0 TSS64-avl
> GDT=     fffffe0000001000 0000007f
> IDT=     fffffe0000000000 00000fff
> CR0=80050033 CR2=00007fcb2504641c CR3=0000000390440000 CR4=007506f0
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
> DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> CCS=0000777f80000000 CCD=0000000390440000 CCO=ADDQ
> EFER=0000000000000d01
> FCW=037f FSW=0000 [ST=0] FTW=00 MXCSR=00001f80
> FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
> FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
> FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
> FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
> YMM00=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM01=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM02=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM03=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM04=0000000000000000 0000000000000000 00006968705f6e6f 657800006c6c6577
> YMM05=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM06=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM07=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM08=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM09=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM10=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM11=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM12=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM13=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM14=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> YMM15=0000000000000000 0000000000000000 0000000000000000 0000000000000000
> cxl2.sh: line 24:  5386 Aborted                 (core dumped) $QEMU
> -cpu Cascadelake-Server -smp 1 -M q35,cxl=on -m 4G,maxmem=8G,slots=4
> -object memory-backend-ram,id=vmem0,share=on,size=4G -device pxb-cc
> 
> --
> Cheers,
> Hyeonggon
> 

