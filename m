Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C5860057C
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 04:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiJQCyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Oct 2022 22:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiJQCy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Oct 2022 22:54:29 -0400
Received: from out0-153.mail.aliyun.com (out0-153.mail.aliyun.com [140.205.0.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5007B0;
        Sun, 16 Oct 2022 19:54:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047207;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.PeOkqYT_1665975263;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PeOkqYT_1665975263)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 10:54:24 +0800
Date:   Mon, 17 Oct 2022 10:54:23 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Reduce refcount if single_open() fails in
 kvm_mmu_rmaps_stat_open()
Message-ID: <20221017025423.GA117575@k08j02272.eu95sqa>
References: <a75900413bb8b1e556be690e9588a0f92e946a30.1665733883.git.houwenlong.hwl@antgroup.com>
 <Y0lts0nU6fO7rrSK@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0lts0nU6fO7rrSK@x1n>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 10:09:55PM +0800, Peter Xu wrote:
> On Fri, Oct 14, 2022 at 03:55:11PM +0800, Hou Wenlong wrote:
> > Refcount is increased before calling single_open() in
> > kvm_mmu_rmaps_stat_open(), If single_open() fails, refcount should be
> > restored, otherwise the vm couldn't be destroyed.
> > 
> > Fixes: 3bcd0662d66fd ("KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file")
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/debugfs.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> > index cfed36aba2f7..412ed1b341fa 100644
> > --- a/arch/x86/kvm/debugfs.c
> > +++ b/arch/x86/kvm/debugfs.c
> > @@ -162,7 +162,12 @@ static int kvm_mmu_rmaps_stat_open(struct inode *inode, struct file *file)
> >  	if (!kvm_get_kvm_safe(kvm))
> >  		return -ENOENT;
> >  
> > -	return single_open(file, kvm_mmu_rmaps_stat_show, kvm);
> > +	if (single_open(file, kvm_mmu_rmaps_stat_show, kvm)) {
> > +		kvm_put_kvm(kvm);
> > +		return -ENOMEM;
> > +	}
> 
> Thanks for fixing this.  Would it be nicer to wire the single_open retval
> (even though it'll only fail with -ENOMEM with current code base)?
> 
I agree, it would be nicer to return the single_open() retval directly.
I just follow how failure of simple_attr_open() is handled in kvm_debugfs_open(),
but I think it should be changed too. 

> -- 
> Peter Xu
