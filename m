Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD2246FF42
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 12:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbhLJLDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 06:03:43 -0500
Received: from foss.arm.com ([217.140.110.172]:40616 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240141AbhLJLDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1E5B2B;
        Fri, 10 Dec 2021 03:00:06 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B09E33F73B;
        Fri, 10 Dec 2021 03:00:05 -0800 (PST)
Date:   Fri, 10 Dec 2021 11:00:02 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     "haibiao.xiao" <haibiao.xiao@zstack.io>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com,
        "haibiao.xiao" <xiaohaibiao331@outlook.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool] Makefile: 'lvm version' works incorrect.
 Because CFLAGS can not get sub-make variable $(KVMTOOLS_VERSION)
Message-ID: <20211210110002.137a2fc3@donnerap.cambridge.arm.com>
In-Reply-To: <28ff4bb3-851a-e287-b008-c2a91370c90d@zstack.io>
References: <20211204061436.36642-1-haibiao.xiao@zstack.io>
        <20211209155746.3f6bd016@donnerap.cambridge.arm.com>
        <28ff4bb3-851a-e287-b008-c2a91370c90d@zstack.io>
Organization: ARM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Dec 2021 10:55:40 +0800
"haibiao.xiao" <haibiao.xiao@zstack.io> wrote:

Hi,

> On Thu, 9 Dec 2021 15:57:46 +0000, Andre Przywara wrote:
> > On Sat,  4 Dec 2021 14:14:36 +0800
> > "haibiao.xiao" <haibiao.xiao@zstack.io> wrote:
> > 
> > Hi,
> >   
> >> From: "haibiao.xiao" <xiaohaibiao331@outlook.com>
> >>
> >> Command 'lvm version' works incorrect.
> >> It is expected to print:
> >>
> >>     # ./lvm version
> >>     # kvm tool [KVMTOOLS_VERSION]
> >>
> >> but the KVMTOOLS_VERSION is missed:
> >>
> >>     # ./lvm version
> >>     # kvm tool
> >>
> >> The KVMTOOLS_VERSION is defined in the KVMTOOLS-VERSION-FILE file which
> >> is included at the end of Makefile. Since the CFLAGS is a 'Simply
> >> expanded variables' which means CFLAGS is only scanned once. So the
> >> definetion of KVMTOOLS_VERSION at the end of Makefile would not scanned
> >> by CFLAGS. So the '-DKVMTOOLS_VERSION=' remains empty.
> >>
> >> I fixed the bug by moving the '-include $(OUTPUT)KVMTOOLS-VERSION-FILE'
> >> before the CFLAGS.  
> > 
> > While this is indeed a bug that this patch fixes, I wonder if we should
> > actually get rid of this whole versioning attempt altogether at this
> > point. Originally this was following the containing kernel version, but
> > it is stuck ever since at v3.18, without any change.
> > 
> > So either we introduce proper versioning (not sure it's worth it?), or we
> > just remove all code that pretends to print a version number? Or just
> > hardcode v3.18 into the printf, at least for now? At the very least I
> > think we don't need a KVMTOOLS-VERSION-FILE anymore.
> >   
> 
> Thanks for your reply. 
> 
> The reason I look at this project is tend to learn something about kvm. 
> With the version number I can tell which kernel(kvm) is compatible.

I am afraid this is not what the version number tells you. The Linux
kernel provides a stable interface to userland, that includes KVM.
So you should be able to run any kvmtool version on any host kernel
(ignoring bugs). Granted, you will only get the features implemented in
both parts, but this only applies to new features (like PMU
virtualisation), not the main functionality.

> Although it is stuck at v3.18, there still some commits in recent 
> months, which means the kvmtool still changing according to the kvm 
> features.

Sure, we keep it alive, but adapting to new kernel features is only one
part of that. Recently we mostly improved functionality (like
adding firmware support, emulating later PCIe versions, ...) and were
fixing bugs, independent of the kernel version.

> So I think what's kvmtool need is a version control, but not 
> remove/hardcode.

So whether that's really worth it, is the question. If you need some number
to compare, distributions tend to use the date of the last commit for that.

Cheers,
Andre


> 
> Thanks,
> haibiao.xiao
> > Cheers,
> > Andre
> >   
> >>
> >> Signed-off-by: haibiao.xiao <xiaohaibiao331@outlook.com>
> >> ---
> >>  Makefile | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Makefile b/Makefile
> >> index bb7ad3e..9afb5e3 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -17,6 +17,7 @@ export E Q
> >>  
> >>  include config/utilities.mak
> >>  include config/feature-tests.mak
> >> +-include $(OUTPUT)KVMTOOLS-VERSION-FILE
> >>  
> >>  CC	:= $(CROSS_COMPILE)gcc
> >>  CFLAGS	:=
> >> @@ -559,5 +560,4 @@ ifneq ($(MAKECMDGOALS),clean)
> >>  
> >>  KVMTOOLS-VERSION-FILE:
> >>  	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
> >> --include $(OUTPUT)KVMTOOLS-VERSION-FILE
> >> -endif
> >> +endif
> >> \ No newline at end of file  

