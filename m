Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C705E57263C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiGLTqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 15:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiGLTph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 15:45:37 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380949C257;
        Tue, 12 Jul 2022 12:34:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso9551389pjk.3;
        Tue, 12 Jul 2022 12:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n4hhtUV/7d3Hrcufg5badfEYjmHc8zvs4wyYB+BVUlc=;
        b=F3WNmR0MIHppkPYJ0BpbyftgfXEZNu9242PskWmElgFE83zoA+TBu0d6D+k26Kijgu
         hSfBZd+iKP2vf2DWNOh8L+6go1H0gPBgQPtfNasdXWuDjzI7sSYI5BRG2dpVrZGzRTa5
         htBSzJTrtXPVc5cVWAj9rWH1h+hBTcCssG+FyM24iW868DqFaBH/7VqNmPeF/nq6+P0D
         iZ3Tf0HuJ+MVrcuLLdqfhlzHnoQ5OEhsx8h7+dAW8VeC7j9jk3+xt83SBXm9WqKrxAi6
         7ZkplvmTPn+9Zc+aBXGV0GTu4lGEsKBilVmilJd8xLkiLHi/Y1evvDkOAH3AVoJcK0R0
         EmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n4hhtUV/7d3Hrcufg5badfEYjmHc8zvs4wyYB+BVUlc=;
        b=kMXQ8IdtJHouhha3MySQ+kwDXNhgbLMQ+cOuNwiMEF9F3voPJm42TdMufB0zPYeY8v
         b2foAxtJuZyLERSsaRqtz0EG5si/rE7ANeMuewJ9m4ko1ucl7rgJFPJ/qypToPjNqImD
         BSVG6Zl3ZPWIssT7lsTlx9vXkpk2kDqH+iZW4QBI6Z3zIyv7Rws+D1z4vSiWwEpUceb1
         p2Eqh4M+Db4G0+nYe/4JPxDRBdjRqeC8m0gRRyn9jxcecDkuxsIGoMc7/gLblcCbKtQd
         bVL1HttIy8upw6tuUoUlSxpwgIBPttnMoHh1xkFxTkfCxuu5LfotW8Zj/vxekeR/53/I
         cz3Q==
X-Gm-Message-State: AJIora+gOAlWH1pFV8F41EEykkm6EsVs6ifnsG822Jfd+7G/bSZbHdmc
        5nbZwK/7FZV1MWUKRJLUSGQ=
X-Google-Smtp-Source: AGRyM1vmJf7MVlh38UJVbC6A6TPuqKkGNmTyQ0fKXiOJLkMonOBN0CiLf2DZFyOewJLkGjLqkrtPwQ==
X-Received: by 2002:a17:902:ab87:b0:16a:82a9:feb7 with SMTP id f7-20020a170902ab8700b0016a82a9feb7mr25889355plr.37.1657654470575;
        Tue, 12 Jul 2022 12:34:30 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id 64-20020a621943000000b00518764d09cdsm7198030pfz.164.2022.07.12.12.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 12:34:29 -0700 (PDT)
Date:   Tue, 12 Jul 2022 12:34:28 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH 08/12] Documentation: kvm: tdx-tdp-mmu: Properly format
 nested list for EPT state machine
Message-ID: <20220712193428.GL1379820@ls.amr.corp.intel.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
 <20220709042037.21903-9-bagasdotme@gmail.com>
 <YskDcli+Lg6uKzYX@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YskDcli+Lg6uKzYX@debian.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 09, 2022 at 11:26:26AM +0700,
Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> On Sat, Jul 09, 2022 at 11:20:34AM +0700, Bagas Sanjaya wrote:
> >  The state machine of EPT entry
> >  ------------------------------
> > -(private EPT entry, shared EPT entry) =
> > -        (non-present, non-present):             private mapping is allowed
> > -        (present, non-present):                 private mapping is mapped
> > -        (non-present | SPTE_SHARED_MASK, non-present | SPTE_SHARED_MASK):
> > -                                                shared mapping is allowed
> > -        (non-present | SPTE_SHARED_MASK, present | SPTE_SHARED_MASK):
> > -                                                shared mapping is mapped
> > -        (present | SPTE_SHARED_MASK, any)       invalid combination
> > +* (private EPT entry, shared EPT entry)
> >  
> > -* map_gpa(private GPA): Mark the region that private GPA is allowed(NEW)
> > -        private EPT entry: clear SPTE_SHARED_MASK
> > -          present: nop
> > -          non-present: nop
> > -          non-present | SPTE_SHARED_MASK -> non-present (clear SPTE_SHARED_MASK)
> > +  * (non-present, non-present):
> > +       private mapping is allowed
> > +  * (present, non-present):
> > +       private mapping is mapped
> > +  * (non-present | SPTE_SHARED_MASK, non-present | SPTE_SHARED_MASK):
> > +       shared mapping is allowed
> > +  * (non-present | SPTE_SHARED_MASK, present | SPTE_SHARED_MASK):
> > +       shared mapping is mapped
> > +  * (present | SPTE_SHARED_MASK, any):
> > +       invalid combination
> >  
> > -        shared EPT entry: zap the entry, clear SPTE_SHARED_MASK
> > -          present: invalid
> > -          non-present -> non-present: nop
> > -          present | SPTE_SHARED_MASK -> non-present
> > -          non-present | SPTE_SHARED_MASK -> non-present
> > +* map_gpa (private GPA): Mark the region that private GPA is allowed(NEW)
> >  
> > -* map_gpa(shared GPA): Mark the region that shared GPA is allowed(NEW)
> > -        private EPT entry: zap and set SPTE_SHARED_MASK
> > -          present     -> non-present | SPTE_SHARED_MASK
> > -          non-present -> non-present | SPTE_SHARED_MASK
> > -          non-present | SPTE_SHARED_MASK: nop
> > +  * private EPT entry: clear SPTE_SHARED_MASK
> >  
> > -        shared EPT entry: set SPTE_SHARED_MASK
> > -          present: invalid
> > -          non-present -> non-present | SPTE_SHARED_MASK
> > -          present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK: nop
> > -          non-present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK: nop
> > +    * present: nop
> > +    * non-present: nop
> > +    * non-present | SPTE_SHARED_MASK -> non-present (clear SPTE_SHARED_MASK)
> >  
> > -* map(private GPA)
> > -        private EPT entry
> > -          present: nop
> > -          non-present -> present
> > -          non-present | SPTE_SHARED_MASK: nop. looping on EPT violation(NEW)
> > +  * shared EPT entry: zap the entry, clear SPTE_SHARED_MASK
> >  
> > -        shared EPT entry: nop
> > +    * present: invalid
> > +    * non-present -> non-present: nop
> > +    * present | SPTE_SHARED_MASK -> non-present
> > +    * non-present | SPTE_SHARED_MASK -> non-present
> >  
> > -* map(shared GPA)
> > -        private EPT entry: nop
> > +* map_gpa (shared GPA): Mark the region that shared GPA is allowed(NEW)
> >  
> > -        shared EPT entry
> > -          present: invalid
> > -          present | SPTE_SHARED_MASK: nop
> > -          non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
> > -          non-present: nop. looping on EPT violation(NEW)
> > +  * private EPT entry: zap and set SPTE_SHARED_MASK
> >  
> > -* zap(private GPA)
> > -        private EPT entry: zap the entry with keeping SPTE_SHARED_MASK
> > -          present -> non-present
> > -          present | SPTE_SHARED_MASK: invalid
> > -          non-present: nop as is_shadow_present_pte() is checked
> > -          non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> > -                                          checked
> > +    * present     -> non-present | SPTE_SHARED_MASK
> > +    * non-present -> non-present | SPTE_SHARED_MASK
> > +    * non-present | SPTE_SHARED_MASK: nop
> >  
> > -        shared EPT entry: nop
> > +  * shared EPT entry: set SPTE_SHARED_MASK
> >  
> > -* zap(shared GPA)
> > -        private EPT entry: nop
> > +    * present: invalid
> > +    * non-present -> non-present | SPTE_SHARED_MASK
> > +    * present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK: nop
> > +    * non-present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK: nop
> >  
> > -        shared EPT entry: zap
> > -          any -> non-present
> > -          present: invalid
> > -          present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
> > -          non-present: nop as is_shadow_present_pte() is checked
> > -          non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> > -                                          checked
> > +* map (private GPA)
> > +
> > +  * private EPT entry
> > +
> > +    * present: nop
> > +    * non-present -> present
> > +    * non-present | SPTE_SHARED_MASK: nop. looping on EPT violation(NEW)
> > +
> > +  * shared EPT entry: nop
> > +
> > +* map (shared GPA)
> > +
> > +  * private EPT entry: nop
> > +
> > +  * shared EPT entry:
> > +
> > +    * present: invalid
> > +    * present | SPTE_SHARED_MASK: nop
> > +    * non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
> > +    * non-present: nop. looping on EPT violation(NEW)
> > +
> > +* zap (private GPA)
> > +
> > +  * private EPT entry: zap the entry with keeping SPTE_SHARED_MASK
> > +
> > +    * present -> non-present
> > +    * present | SPTE_SHARED_MASK: invalid
> > +    * non-present: nop as is_shadow_present_pte() is checked
> > +    * non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> > +      checked
> > +
> > +  * shared EPT entry: nop
> > +
> > +* zap (shared GPA)
> > +
> > +  * private EPT entry: nop
> > +
> > +  * shared EPT entry: zap
> > +
> > +    * any -> non-present
> > +    * present: invalid
> > +    * present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
> > +    * non-present: nop as is_shadow_present_pte() is checked
> > +    * non-present | SPTE_SHARED_MASK: nop as is_shadow_present_pte() is
> > +      checked
> 
> IMO, the state machine lists above should have used tables instead.

Makes sense. I'll convert those into tables.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
