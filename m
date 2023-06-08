Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABA57289B6
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 22:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbjFHUzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 16:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjFHUzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 16:55:08 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C5A133;
        Thu,  8 Jun 2023 13:55:07 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-53fa455cd94so110174a12.2;
        Thu, 08 Jun 2023 13:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686257706; x=1688849706;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6oWrHsl4d9N87fafwcjt6WPe/4TeEPsaBiFgd+6930M=;
        b=nq8AaAsGA71zvWXKV0bCclZE1ncs4V6jl3FXcw0S1vk/1waURyQRsDA4Zbc1QyAnQD
         YkTIr9cyAzhKoMq4fRi9cJ+gzlvIO7UH6djIYVw+8KIiM/I4OcI+lGb1yengwlt9lACH
         eSUuUQtwboeBwqYMdDmOV5q9PwF43isu+hwPBUh1EpjglEpVFz3Zz5bclUsyOWxd/bfb
         es3rKeHSdz7ZzNbTvODd2nbn0uuE9xHVp/j4kxOXStMOXr+rwNH5ZOQhzmTRCa8oaplm
         X8iVzZmnjolukj+Ydp59sSnM/zRQB1+QNpTud+BLoxgojKMcavcKFFGVZKOWgtMSO3wC
         HymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686257706; x=1688849706;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6oWrHsl4d9N87fafwcjt6WPe/4TeEPsaBiFgd+6930M=;
        b=DMajDgMDmOtxCJ9ztzd9GsyzY5u68c4I99jQZbsinMH+ZZpNRSHjn6KyVKp8bCGvQl
         kzyiMRe5aV16qg+StlKAdS6xZn+TES/Q6MD/JxSVX3Z02RtBx7Vo1n/Sr8rwKyx1mb9c
         1fJA6yo9aE5HE0zwOlqmBiSPVu6PJN57SGq69lXP5UHU6hy+s8J75R6L9r/Z3BSzzCAl
         0ekPJKCCAmwmu8XakexdXOCGqt89xlzuBtTWObE3LtSU5oDEVCG58h35em+LM1+CI14O
         rgyiIKm5DRgoOS+JUvTjejKunkyc8O670AJKRYN37uFXFu7ra/c2P4uFoTew8IpIg87b
         BPYw==
X-Gm-Message-State: AC+VfDxInQH/G72lHubFoLz4N8AaotCGuCJ0FLALOUSM3OLGLrKDAzvC
        DTscIdbEXGvekP5xRymyFQI=
X-Google-Smtp-Source: ACHHUZ4gbObRZDrvgIXT/8eQTVGSpbJ+KVNHWHPfvNroTSiN8l2IHf0LuTF7mtwbQ8JQa31BuQfxsA==
X-Received: by 2002:a17:90a:6348:b0:253:727e:4b41 with SMTP id v8-20020a17090a634800b00253727e4b41mr4683052pjs.34.1686257706282;
        Thu, 08 Jun 2023 13:55:06 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id nn4-20020a17090b38c400b002562cfb81dfsm3430923pjb.28.2023.06.08.13.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:55:05 -0700 (PDT)
Date:   Thu, 8 Jun 2023 13:55:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v14 055/113] KVM: TDX: TDP MMU TDX support
Message-ID: <20230608205503.GL2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <a7fc71f5d30676e9360f3db040feb7e6ac18203f.1685333728.git.isaku.yamahata@intel.com>
 <CAAYXXYzR6JZq8OOD2qqC_vVGiCa3e5KmZZ+36YffGW6JFK4+Hw@mail.gmail.com>
 <CAAYXXYyUbqjmrezTw=p_yBkkB-o9H-Xg_J5rBCe1CXUpF5PM+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAYXXYyUbqjmrezTw=p_yBkkB-o9H-Xg_J5rBCe1CXUpF5PM+A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 04:29:35AM -0700,
Erdem Aktas <erdemaktas@google.com> wrote:

> On Sun, May 28, 2023 at 9:21 PM <isaku.yamahata@intel.com> wrote:
> >
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > +static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > +                                      enum pg_level level, kvm_pfn_t pfn)
> > +{
> > +       int tdx_level = pg_level_to_tdx_sept_level(level);
> > +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +       struct tdx_module_output out;
> > +       gpa_t gpa = gfn_to_gpa(gfn);
> > +       hpa_t hpa = pfn_to_hpa(pfn);
> > +       hpa_t hpa_with_hkid;
> > +       u64 err;
> > +
> > +       /* TODO: handle large pages. */
> > +       if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > +               return -EINVAL;
> > +
> > +       if (unlikely(!is_hkid_assigned(kvm_tdx))) {
> > +               /*
> > +                * The HKID assigned to this TD was already freed and cache
> > +                * was already flushed. We don't have to flush again.
> > +                */
> > +               err = tdx_reclaim_page(hpa, false, 0);
> > +               if (KVM_BUG_ON(err, kvm))
> > +                       return -EIO;
> > +               tdx_unpin(kvm, pfn);
> > +               return 0;
> > +       }
> > +
> > +       do {
> > +               /*
> > +                * When zapping private page, write lock is held. So no race
> > +                * condition with other vcpu sept operation.  Race only with
> > +                * TDH.VP.ENTER.
> > +                */
> > +               err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
> > +       } while (unlikely(err == TDX_ERROR_SEPT_BUSY));
> > +       if (KVM_BUG_ON(err, kvm)) {
> > +               pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
> > +               return -EIO;
> > +       }
> > +
> > +       hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
> > +       do {
> > +               /*
> > +                * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
> > +                * this page was removed above, other thread shouldn't be
> > +                * repeatedly operating on this page.  Just retry loop.
> > +                */
> > +               err = tdh_phymem_page_wbinvd(hpa_with_hkid);
> > +       } while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
> > +       if (KVM_BUG_ON(err, kvm)) {
> > +               pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> > +               return -EIO;
> > +       }
> 
> 
> It seems like when the TD is destroyed, all the TD private pages are
> removed with tdx_reclaim_page which also clears the page with
> movdir64b instruction. But when the page is removed while the TD is
> alive (in this case), the page content is never cleared with movdir64b
> which causes any poisoned cache line to be consumed by the host
> resulting in #MC exceptions in the host context.
> 
> We should clear the page before returning it back to the free pool by
> calling tdx_clear_page((unsigned long)__va(hpa)) here.

Thank you for catching it up. I'll fix tdx_sept_drop_private_spte(),
tdx_sept_free_private_spt() (and tdx_sept_merge_private_spt() for large page
support).  We should clear the page for Not only guest memory, but also
secure-ept.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
