Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2786746FE
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjASXOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjASXN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:13:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B26C8F6ED
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:10:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so7410042pjm.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0xs+AkRX0zji5V82YtiqWPnSpc8i90g+KOIeXERoTho=;
        b=E9JGR/DLpZ8PWbvGleifqa8xv945rGeHQuV9agxi1nvZWhWkEugJeJIoYa1Txl+eRI
         W/a2e38An1fyzflFgGBQl9zsPJR5hRHKRToCUytngjx+39AWN+wx3ouMyj5izqOJJZ6X
         hVSuNR+op0VzuyELdO5nwXm4oo2m5C5oFYmRP4PHg6bTmdf1lk2uc+pQdlq1dOmTtVO9
         aYfdU7C9OtXyHEYUUf6JgN1Dfyn5Sd7RK5nhHOovC8UT3BG+c59v3ZLfau02MC3X3PWN
         dQK1JscyWhzuw+BznyHlVvPVk+b/6oTyJgJqgscHCvbcMUDEWsAk5g+DjB0u2OqzO/jo
         +Cjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xs+AkRX0zji5V82YtiqWPnSpc8i90g+KOIeXERoTho=;
        b=iKyDIZf2KwP9pFjp1n4luJ7bHT4y/4fbSBLK9ICn0E/M+NdQygpJz6ZKJJFPvo+S7m
         9lk7+f22x53pby7t9lRpTPtUZJRZsfGPahOOQJRyiZqOjhgImbhjI+b/AD6UOncKXIy8
         nmuvuFgRHys7M92bEf9MkLfZhsjjoHfCepwLlUG7EbAdp/ns+YWH+A/nyIRGlyfvspUt
         11iT5VaAe+AgWBqydnZ78QDlSwTctBTN+1rIzAwFY7iiao2oJPgR+95lJJZsq5usnyHV
         7iFgXmtVDdAyiWJGApON8hrCLuTa+Cb+OdwMSPdUy1lMwrdBmhbOhPRE7Se2Ot+abT+T
         o8nQ==
X-Gm-Message-State: AFqh2kq3+DJTaq6YQP8iGS98HE9cmItP5HWFoB2nwF/7YojpoW6b1G8j
        ftavy44nO5cV0i2sdsxhjs2yjhQltG2vRHTASxQ=
X-Google-Smtp-Source: AMrXdXtLdY9B9kb1IsRD3qRSPR+b05c975sdeIA2zxjCFJyKFVjFEdhIO/Xx8VlDsBEGX1YzwpOv1g==
X-Received: by 2002:a05:6a20:2d83:b0:a4:efde:2ed8 with SMTP id bf3-20020a056a202d8300b000a4efde2ed8mr110451pzb.0.1674169799183;
        Thu, 19 Jan 2023 15:09:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c4-20020a63da04000000b0047911890728sm21663872pgh.79.2023.01.19.15.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:09:58 -0800 (PST)
Date:   Thu, 19 Jan 2023 23:09:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 0/6] KVM: x86/mmu: Fix wrong usages of range-based tlb
 flushing
Message-ID: <Y8nNw4kxyedN2kaI@google.com>
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
 <167408992939.2370458.7888282998581500159.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167408992939.2370458.7888282998581500159.b4-ty@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023, Sean Christopherson wrote:
> On Mon, 10 Oct 2022 20:19:11 +0800, Hou Wenlong wrote:
> > Commit c3134ce240eed ("KVM: Replace old tlb flush function with new one
> > to flush a specified range.") replaces old tlb flush function with
> > kvm_flush_remote_tlbs_with_address() to do tlb flushing. However, the
> > gfn range of tlb flushing is wrong in some cases. E.g., when a spte is
> > dropped, the start gfn of tlb flushing should be the gfn of spte not the
> > base gfn of SP which contains the spte. Although, as Paolo said, Hyper-V
> > may treat a 1-page flush the same if the address points to a huge page,
> > and no fixes are reported so far. So it seems that it works well for
> > Hyper-V. But it would be better to use the correct size for huge page.
> > So this patchset would fix them and introduce some helper functions as
> > David suggested to make the code clear.
> > 
> > [...]
> 
> David and/or Hou, it's probably a good idea to double check my results, there
> were a few minor conflicts and I doubt anything would fail if I messed up.

Gah, doesn't even compile because I missed a paranthesis.  Messed up my scripts
and didn't pull 'mmu' into 'next.

Force pushed, new hashes are below.  Testing now...

[1/6] KVM: x86/mmu: Move round_gfn_for_level() helper into mmu_internal.h
      https://github.com/kvm-x86/linux/commit/bb05964f0a3c
[2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in kvm_set_pte_rmapp()
      https://github.com/kvm-x86/linux/commit/c61baeaa2a14
[3/6] KVM: x86/mmu: Reduce gfn range of tlb flushing in tdp_mmu_map_handle_target_level()
      https://github.com/kvm-x86/linux/commit/24c17bc3def7
[4/6] KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
      https://github.com/kvm-x86/linux/commit/873f68d8dac3
[5/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
      https://github.com/kvm-x86/linux/commit/22f34c933198
[6/6] KVM: x86/mmu: Cleanup range-based flushing for given page
      https://github.com/kvm-x86/linux/commit/e7b406974086
