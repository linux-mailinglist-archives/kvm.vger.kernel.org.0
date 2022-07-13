Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74FB572CC0
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 06:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiGMEwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 00:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGMEwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 00:52:30 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED32747B4;
        Tue, 12 Jul 2022 21:52:28 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g4so9484603pgc.1;
        Tue, 12 Jul 2022 21:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f+2JZdBzasgGHckT/qIQE4icgRViC0qsA2MSto8NDn0=;
        b=V0wNlNnK5fIIKNAa2arZj41YZReklJHRPo+C78C1okjHvG56ge+bpDJoIWy5sw+rYv
         HNd0/srG5X5ooWe5lC7NOTsMCEY3bmhxyfOkWFZgvoDzrlQNyj2+x1nkQi3oTKw67gFi
         +VVLoI2VkHXwk2lZfEAm/WJLKNXZntb8/3C+Dj6tAr/6QV3PyQWurY2t4fCyewtzBmjq
         CVeaEnrz3dyPLUbkYYEDvBYyqUOwIf4mGgI7o0cy44rsswwiuefLnUUVnFb50mKHyNat
         XXhCNp+hHF0YJKMzw4lhJK5bzF2l35YtOFe5EELRF9cs2qgidphc87rt1HF1LUckgjUR
         LAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f+2JZdBzasgGHckT/qIQE4icgRViC0qsA2MSto8NDn0=;
        b=kk79y/k9QSWgzfsHOFvnsM/Oj7Hp3RKE3PJ6eZKBA3DDAHdor7OE1MISGS8JKZqCub
         qRmQN5NcwL+mn4xEQepfj1lCZTFmXn5DEfGbqNO/e6Xp8ar8OctOyxa8fGksxR8K7zyO
         cDeXOdPKldR9H3l9G+M/vk4mz1a1LfFF1m0cMWus6VZE3lKVpgPG605IdaqR96J/OCh7
         cHAG4Iv55M6/G1i+vAF90VidJqEzVHsFmspo48wcVYmEXQb+NBoOiXZcC47c//S64y3H
         guD0rghDsX/ElGtn381Ugv2RmrwmPxXcZnQQREq7g8mcXi6QFmbusF3GIUxEn65DZ6g6
         d5Iw==
X-Gm-Message-State: AJIora/s+JTbRJhI/kQRpPpLGAD93RNXiOwoE9JpGk1rrUE8doW4TVx+
        u9uLVjUd9BM54tP3LiCOSkE=
X-Google-Smtp-Source: AGRyM1t7Btwv7T208HKhn5NasujOBYMMqx2MyKfcdQM5RRbJJNsTJ0W5M8EPk4oKrdpfSlCNKLK/RA==
X-Received: by 2002:a63:f952:0:b0:412:8852:80fe with SMTP id q18-20020a63f952000000b00412885280femr1480766pgk.194.1657687948199;
        Tue, 12 Jul 2022 21:52:28 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902ff0100b0016a581f9ac2sm7713652plj.234.2022.07.12.21.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 21:52:27 -0700 (PDT)
Date:   Tue, 12 Jul 2022 21:52:25 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v7 033/102] KVM: x86/mmu: Add address conversion
 functions for TDX shared bits
Message-ID: <20220713045225.GP1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <69f4b4942d5f17fad40a8d08556488b8e4b7954d.1656366338.git.isaku.yamahata@intel.com>
 <6cc36b662dffaf0aa2a2f389f073daa2d63a530b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6cc36b662dffaf0aa2a2f389f073daa2d63a530b.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 02:15:20PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> I don't think this is appropriate any more.  You can add Co-developed-by I
> guess.

Makes sense.


> > 
> > TDX repurposes one GPA bits (51 bit or 47 bit based on configuration) to
> > indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> > GPA.shared is set, GPA is converted existing conventional EPT pointed by
> > EPTP.  If GPA.shared bit is cleared, GPA is converted by Secure-EPT(S-EPT)
> 
> Not sure whether Secure EPT has even been mentioned before in this series.  If
> not, perhaps better to explain it here.  Or not sure whether you need to mention
> S-EPT at all.
> 
> > TDX module manages.  VMM has to issue SEAM call to TDX module to operate on
> 
> SEAM call -> SEAMCALL
> 
> > S-EPT.  e.g. populating/zapping guest page or shadow page by TDH.PAGE.{ADD,
> > REMOVE} for guest page, TDH.PAGE.SEPT.{ADD, REMOVE} S-EPT etc.
> 
> Not sure why you want to mention those particular SEAMCALLs.
> 
> > 
> > Several hooks needs to be added to KVM MMU to support TDX.  Add a function
> 
> needs -> need.
> 
> Not sure why you need first sentence at all.
> 
> But I do think you should mention adding per-VM scope 'gfn_shared_mask' thing.
> 
> > to check if KVM MMU is running for TDX and several functions for address
> > conversation between private-GPA and shared-GPA.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/mmu.h              | 32 ++++++++++++++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index e5d4e5b60fdc..2c47aab72a1b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1339,7 +1339,9 @@ struct kvm_arch {
> >  	 */
> >  	u32 max_vcpu_ids;
> >  
> > +#ifdef CONFIG_KVM_MMU_PRIVATE
> >  	gfn_t gfn_shared_mask;
> > +#endif
> 
> As Xiaoyao said, please introduce gfn_shared_mask in this patch.
> 
> And by applying this patch, nothing will prevent you to turn on INTEL_TDX_HOST
> and KVM_INTEL, which also turns on KVM_MMU_PRIVATE.
> 
> So 'kvm_arch::gfn_shared_mask' is guaranteed to be 0?  If not, can legal
> (shared) GFN for normal VM be potentially treated as private?
> 
> If yes, perhaps explicitly call out in changelog so people don't need to worry
> about?

struct kvm that includes struct kvm_arch is guaranteed to be zero.

Here is the updated commit message.

Author: Isaku Yamahata <isaku.yamahata@intel.com>
Date:   Tue Jul 12 00:10:13 2022 -0700

    KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
    
    TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
    indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
    GPA.shared is set, GPA is converted existing conventional EPT pointed by
    EPTP.  If GPA.shared bit is cleared, GPA is converted by TDX module.
    VMM has to issue SEAMCALLs to operate.
    
    Add a member to remember GPA shared bit for each guest TDs, add address
    conversion functions between private GPA and shared GPA and test if GPA
    is private.
    
    Because struct kvm_arch (or struct kvm which includes struct kvm_arch. See
    kvm_arch_alloc_vm() that passes __GPF_ZERO) is zero-cleared when allocated,
    the new member to remember GPA shared bit is guaranteed to be zero with
    this patch unless it's initialized explicitly.
    
    Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
    Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
    Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
