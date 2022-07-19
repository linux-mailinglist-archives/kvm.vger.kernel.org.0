Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF105797A4
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237056AbiGSK0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 06:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbiGSK0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 06:26:17 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67922108D;
        Tue, 19 Jul 2022 03:26:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso1038863pjb.1;
        Tue, 19 Jul 2022 03:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3l+HLhYfqzxi/x6gvVnPdxIk/vWRfgyAXjiA7yGImnI=;
        b=H58CLxA7+K163/ypV4lgNENxU3/Wdneirm87cBrQAlraAaHpLD/nrZu9QXNk+C9ktY
         al8RQLzfjUS+vrnb7cowPoZ7d5SrlrF3x+2IOKaSH4l7lDx344pAL3ucSAWm85efbkkO
         THC1BlT+WjExOYWdT0mX2wpEuzl+L31l0grZvw5LIajM6fWckF7w3v/AzFU0f9ZVZTNU
         he/H02OSstwffv8wYsrCeOzVYFKO05U7ktqv4a0/IiWmSKsU1Nj3j/RDpGcPZOL7CGFG
         BmepJjIl/Wa9VIjbBeN2AOckdMOMcT93iLlHDMlANoNcccdv6ECbFPZmubnYH7eoIuMf
         Dk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3l+HLhYfqzxi/x6gvVnPdxIk/vWRfgyAXjiA7yGImnI=;
        b=OFWhwIUaa77Rj2ijK+flGupTeKexjEDwIilR6Yo1KPb5K2i/1QnLofhOrZdKF6NlOd
         WJW1fF7rnwSRyXPHE959hCPnMY7kKoGp/JeXJpr6Srnj/eznR1i+wpuBZ8CExrWg+GVe
         xG39qm+gKqYJoRMrILbvRw8me268YdLiXZsi/LU5m1VmjaqJ0NVmJX8jht40dgEU+EUj
         7Ik0P1NrmSbOXQ8SIiYybvxpYcSmAn0ILjqzh713mpCZLjfrGTFaRY+nYC17bjzqq15H
         ZsRmV0bOCJRB4UZwlm1xc2afRZvG06I4TQa1AatAOn7DWHRQSQC7GNLGZ2yeq4tvcWiK
         KMXQ==
X-Gm-Message-State: AJIora+fQk2RFz57M6ayppvOuxb+5Z8BTyZ43yAMgDRtvQCwejiKfnka
        IZBqONBc3iwcwpP6uASQGfU=
X-Google-Smtp-Source: AGRyM1uufekVGGKrSJ2gaMc67vKamX1QCyzQmaeokurBK0ofYS7Gx/E0Vhca9alDKP7HndcswHPong==
X-Received: by 2002:a17:903:2ce:b0:16c:f66b:50fa with SMTP id s14-20020a17090302ce00b0016cf66b50famr8019911plk.109.1658226375737;
        Tue, 19 Jul 2022 03:26:15 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e74b00b0016be596c8afsm11192671plf.282.2022.07.19.03.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:26:15 -0700 (PDT)
Date:   Tue, 19 Jul 2022 03:26:14 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 039/102] KVM: x86/mmu: Allow per-VM override of the
 TDP max page level
Message-ID: <20220719102614.GV1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <e686602e7b57ed0c3600c663d03a9bf76190db0c.1656366338.git.isaku.yamahata@intel.com>
 <8227079db11c0473f1c368b305e40a94a73fc109.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8227079db11c0473f1c368b305e40a94a73fc109.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 12:27:24AM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TODO: This is a transient workaround patch until the large page support for
> > TDX is implemented.  Support large page for TDX and remove this patch.
> 
> I don't understand.  How does this patch have anything to do with what you are
> talking about here?
> 
> If you want to remove this patch later, then why not just explain the reason to
> remove when you actually have that patch?
> 
> > 
> > At this point, large page for TDX isn't supported, and need to allow guest
> > TD to work only with 4K pages.  On the other hand, conventional VMX VMs
> > should continue to work with large page.  Allow per-VM override of the TDP
> > max page level.
> 
> At which point/previous patch have you made/declared "large page for TDX isn't
> supported"?
> 
> If you want to declare you don't want to support large page for TDX, IMHO just
> declare it here, for instance:
> 
> "For simplicity, only support 4K page for TD guest."
>   
> > 
> > In the existing x86 KVM MMU code, there is already max_level member in
> > struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
> > page fault handler denies page size larger than max_level.
> > 
> > Add per-VM member to indicate the allowed maximum page size with
> > KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
> > kvm_page_fault with it.  For the guest TD, the set per-VM value for allows
> > maximum page size to 4K page size.  Then only allowed page size is 4K.  It
> > means large page is disabled.
> 
> To me it's overcomplicated.  You just need simple sentences for such simple
> infrastructural patch.  For instance:
> 
> "TDX requires special handling to support large private page.  For simplicity,
> only support 4K page for TD guest for now.  Add per-VM maximum page level
> support to support different maximum page sizes for TD guest and conventional
> VMX guest."
> 
> Just for your reference.

Thanks for the sentences. I'll replace the commit message with yours.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
