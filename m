Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08B62C8C0B
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgK3SEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbgK3SEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 13:04:31 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B628FC0613D3
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:03:51 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id e5so62583pjt.0
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4aiUo+R2FBXYOJi5Lz6koIizaWvK7CXEvnPP0gtkHY=;
        b=WJN/cBIIUk6MohKQRQk8JObz3Y9LIRoDzY/g4r9a3kx9ncZpcSl9Ijsv5SCGIzibSh
         0TlyUwNA6WUTeVaDji0unOXv2cdZvhXuvxjCnwjIn3x+0V8XE3TAIDrJzsrpNG+3aDf4
         O64vuJ+VwNbyqtWnGvDLZtyNBklkHcD86NkM+4KIgWOyxWehIcHAbicMIjz8UVVfaNdu
         3KCfphu4L9CefgQu1LAF6kGWwy5dKyguiC1tYJR9q8cvgpGxIPIYuSAgf5my0+GwTpWT
         jRZr3rRQ0PbEFDMRsQGjs3CEbCzRbcnlGqc5b5xAzkV8ryWyPL0pCFk54q9NH+Gmr1KI
         NhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4aiUo+R2FBXYOJi5Lz6koIizaWvK7CXEvnPP0gtkHY=;
        b=OlQFTCzluQoe3TCzg9773g7vYtDHH8Q7Q60WrZe8pldgi6ZBzfiCCo2xswV2j9pzJT
         MYiYg7aliLVZ9xOQm+3m9rV6PeDXHvR0pRS6JNTJcTFXFxZXWarCKTMHD6xmMgUxOucv
         yEq7R058EqPa/l5b4iJJvutzWBKvdRlQAPRduPWXBmkB5WoLCDET8ql/LfyfcUMV4xNE
         g5EttsTAsYFl0Tpy7MuPbRCjzZ0gc1udlaS2EnRet50B4uXq0iBwYE0jw3m3xon8vd3B
         EDBoe63yPeVm60cztxbJd34ttoo534yE3v3lQCs8mYF3g0vCx0rEjN9BE6VwOmFOcCdD
         Rabg==
X-Gm-Message-State: AOAM530w28+4zSY5DifyO1nKRnwBof2SIqHm3heIrKfbcFXFL1PnPPNo
        UtvqM1iIoxyH3rrjkJcgw5QXO3MYgmTiApzQmIljOw==
X-Google-Smtp-Source: ABdhPJxHm++0XMttvWDRWWKqxHdfZjFoymYvLuXf+7L3uOgrG9s2Gg6KNpvokgO5TP6MqRad6jHADnjuLxLnCan07K8=
X-Received: by 2002:a17:90a:2e8c:: with SMTP id r12mr27529821pjd.101.1606759430885;
 Mon, 30 Nov 2020 10:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20201127164131.2244124-18-daniel.vetter@ffwll.ch>
 <202011280356.rPWHFNW4-lkp@intel.com> <20201130142820.GN401619@phenom.ffwll.local>
In-Reply-To: <20201130142820.GN401619@phenom.ffwll.local>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 30 Nov 2020 10:03:40 -0800
Message-ID: <CAKwvOdnSrsnTgPEuQJyaOTSkTP2dR9208Y66HQG_h1e2LKfqtw@mail.gmail.com>
Subject: Re: [PATCH v7 17/17] mm: add mmu_notifier argument to follow_pfn
To:     Vasily Gorbik <gor@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30, 2020 at 6:28 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> So I guess kvm platforms that don't set KVM_ARCH_WANT_MMU_NOTIFIER exist,
> and at least on powerpc they're consistent with KVM_CAP_SYNC_MMU
> signalling that the guest pagetables stays in sync automatically with any
> updates. So for that case I guess we could use unsafe_follow_pfn.
>
> But on s390 this seems different: No mmu notifier, but KVM_CAP_SYNC_MMU is
> set. So I guess there's some hardware magic on s390 that I don't know
> about.

+ Vasily + Heiko +s390

>
> Not sure what to do with this now here ...
> -Daniel
>
>
> On Sat, Nov 28, 2020 at 03:10:40AM +0800, kernel test robot wrote:
> > Hi Daniel,
> >
> > I love your patch! Yet something to improve:
> >
> > [auto build test ERROR on linuxtv-media/master]
> > [also build test ERROR on char-misc/char-misc-testing v5.10-rc5]
> > [cannot apply to hnaz-linux-mm/master next-20201127]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:    https://github.com/0day-ci/linux/commits/Daniel-Vetter/follow_pfn-and-other-iomap-races/20201128-004421
> > base:   git://linuxtv.org/media_tree.git master
> > config: s390-randconfig-r032-20201127 (attached as .config)
> > compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project f095ac11a9550530a4a54298debb8b04b36422be)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install s390 cross compiling tool for clang build
> >         # apt-get install binutils-s390x-linux-gnu
> >         # https://github.com/0day-ci/linux/commit/d76a3489433ce67d45da86aa12953385427f0ac9
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Daniel-Vetter/follow_pfn-and-other-iomap-races/20201128-004421
> >         git checkout d76a3489433ce67d45da86aa12953385427f0ac9
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from arch/s390/include/asm/kvm_para.h:25:
> >    In file included from arch/s390/include/asm/diag.h:12:
> >    In file included from include/linux/if_ether.h:19:
> >    In file included from include/linux/skbuff.h:31:
> >    In file included from include/linux/dma-mapping.h:10:
> >    In file included from include/linux/scatterlist.h:9:
> >    In file included from arch/s390/include/asm/io.h:80:
> >    include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
> >                                                            ~~~~~~~~~~ ^
> >    include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
> >    #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
> >                                                              ^
> >    include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
> >            ___constant_swab32(x) :                 \
> >                               ^
> >    include/uapi/linux/swab.h:21:12: note: expanded from macro '___constant_swab32'
> >            (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |            \
> >                      ^
> >    In file included from arch/s390/kvm/../../../virt/kvm/kvm_main.c:18:
> >    In file included from include/linux/kvm_host.h:32:
> >    In file included from include/linux/kvm_para.h:5:
> >    In file included from include/uapi/linux/kvm_para.h:36:
> >    In file included from arch/s390/include/asm/kvm_para.h:25:
> >    In file included from arch/s390/include/asm/diag.h:12:
> >    In file included from include/linux/if_ether.h:19:
> >    In file included from include/linux/skbuff.h:31:
> >    In file included from include/linux/dma-mapping.h:10:
> >    In file included from include/linux/scatterlist.h:9:
> >    In file included from arch/s390/include/asm/io.h:80:
> >    include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
> >                                                            ~~~~~~~~~~ ^
> >    include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
> >    #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
> >                                                              ^
> >    include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
> >            ___constant_swab32(x) :                 \
> >                               ^
> >    include/uapi/linux/swab.h:22:12: note: expanded from macro '___constant_swab32'
> >            (((__u32)(x) & (__u32)0xff000000UL) >> 24)))
> >                      ^
> >    In file included from arch/s390/kvm/../../../virt/kvm/kvm_main.c:18:
> >    In file included from include/linux/kvm_host.h:32:
> >    In file included from include/linux/kvm_para.h:5:
> >    In file included from include/uapi/linux/kvm_para.h:36:
> >    In file included from arch/s390/include/asm/kvm_para.h:25:
> >    In file included from arch/s390/include/asm/diag.h:12:
> >    In file included from include/linux/if_ether.h:19:
> >    In file included from include/linux/skbuff.h:31:
> >    In file included from include/linux/dma-mapping.h:10:
> >    In file included from include/linux/scatterlist.h:9:
> >    In file included from arch/s390/include/asm/io.h:80:
> >    include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
> >                                                            ~~~~~~~~~~ ^
> >    include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
> >    #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
> >                                                              ^
> >    include/uapi/linux/swab.h:120:12: note: expanded from macro '__swab32'
> >            __fswab32(x))
> >                      ^
> >    In file included from arch/s390/kvm/../../../virt/kvm/kvm_main.c:18:
> >    In file included from include/linux/kvm_host.h:32:
> >    In file included from include/linux/kvm_para.h:5:
> >    In file included from include/uapi/linux/kvm_para.h:36:
> >    In file included from arch/s390/include/asm/kvm_para.h:25:
> >    In file included from arch/s390/include/asm/diag.h:12:
> >    In file included from include/linux/if_ether.h:19:
> >    In file included from include/linux/skbuff.h:31:
> >    In file included from include/linux/dma-mapping.h:10:
> >    In file included from include/linux/scatterlist.h:9:
> >    In file included from arch/s390/include/asm/io.h:80:
> >    include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            __raw_writeb(value, PCI_IOBASE + addr);
> >                                ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
> >                                                          ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
> >                                                          ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            readsb(PCI_IOBASE + addr, buffer, count);
> >                   ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            readsw(PCI_IOBASE + addr, buffer, count);
> >                   ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            readsl(PCI_IOBASE + addr, buffer, count);
> >                   ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            writesb(PCI_IOBASE + addr, buffer, count);
> >                    ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            writesw(PCI_IOBASE + addr, buffer, count);
> >                    ~~~~~~~~~~ ^
> >    include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
> >            writesl(PCI_IOBASE + addr, buffer, count);
> >                    ~~~~~~~~~~ ^
> > >> arch/s390/kvm/../../../virt/kvm/kvm_main.c:1894:40: error: no member named 'mmu_notifier' in 'struct kvm'
> >            r = follow_pfn(vma, addr, &pfn, &kvm->mmu_notifier);
> >                                             ~~~  ^
> >    arch/s390/kvm/../../../virt/kvm/kvm_main.c:1909:41: error: no member named 'mmu_notifier' in 'struct kvm'
> >                    r = follow_pfn(vma, addr, &pfn, &kvm->mmu_notifier);
> >                                                     ~~~  ^
> >    20 warnings and 2 errors generated.
> >
> > vim +1894 arch/s390/kvm/../../../virt/kvm/kvm_main.c
> >
> >   1885
> >   1886        static int hva_to_pfn_remapped(struct kvm *kvm, struct vm_area_struct *vma,
> >   1887                                       unsigned long addr, bool *async,
> >   1888                                       bool write_fault, bool *writable,
> >   1889                                       kvm_pfn_t *p_pfn)
> >   1890        {
> >   1891                unsigned long pfn;
> >   1892                int r;
> >   1893
> > > 1894                r = follow_pfn(vma, addr, &pfn, &kvm->mmu_notifier);
> >   1895                if (r) {
> >   1896                        /*
> >   1897                         * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
> >   1898                         * not call the fault handler, so do it here.
> >   1899                         */
> >   1900                        bool unlocked = false;
> >   1901                        r = fixup_user_fault(current->mm, addr,
> >   1902                                             (write_fault ? FAULT_FLAG_WRITE : 0),
> >   1903                                             &unlocked);
> >   1904                        if (unlocked)
> >   1905                                return -EAGAIN;
> >   1906                        if (r)
> >   1907                                return r;
> >   1908
> >   1909                        r = follow_pfn(vma, addr, &pfn, &kvm->mmu_notifier);
> >   1910                        if (r)
> >   1911                                return r;
> >   1912
> >   1913                }
> >   1914
> >   1915                if (writable)
> >   1916                        *writable = true;
> >   1917
> >   1918                /*
> >   1919                 * Get a reference here because callers of *hva_to_pfn* and
> >   1920                 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
> >   1921                 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
> >   1922                 * set, but the kvm_get_pfn/kvm_release_pfn_clean pair will
> >   1923                 * simply do nothing for reserved pfns.
> >   1924                 *
> >   1925                 * Whoever called remap_pfn_range is also going to call e.g.
> >   1926                 * unmap_mapping_range before the underlying pages are freed,
> >   1927                 * causing a call to our MMU notifier.
> >   1928                 */
> >   1929                kvm_get_pfn(pfn);
> >   1930
> >   1931                *p_pfn = pfn;
> >   1932                return 0;
> >   1933        }
> >   1934
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201130142820.GN401619%40phenom.ffwll.local.



-- 
Thanks,
~Nick Desaulniers
