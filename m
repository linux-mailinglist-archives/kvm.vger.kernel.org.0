Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB3F66E2DD
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjAQP4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 10:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjAQPz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 10:55:59 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588EE4C38
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 07:55:58 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o13so29315564pjg.2
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 07:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UbgquiiX7N3OGbZUAey4uX+ltor2RNYMswldRrMABEY=;
        b=jzu8BDcQXQEi5N0lmqcvWWqwPv/CoaFJwZGGPGN0yqOhoHz6ZuEuiNbiH8cBYNstFF
         g2KXjCnA8E4OkMAwYq5gNWmrvelJL8U6H6xP3Mn/J3OhpgZMWpYT/CDiuIt8oLPkLqxZ
         wqh6tjGMwu/awfI4GSyHfwCDwirBHRgui1tqoiPDxDkcvRZZD7B0al8/Qvr4N8PQJYBE
         B9CuQlEK/8/YDtRW74IpaW/liZ2SVJtFWBNkUfsU0KecZbJJq6dNZ3w2HbCvN9XD4qoI
         U41K2PsLl2VUf3SG1YluVNWxt4/Z0aUmt9al1sstjAQ3n2TW9sCPtdF0+dGsDIe06ljb
         Dq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UbgquiiX7N3OGbZUAey4uX+ltor2RNYMswldRrMABEY=;
        b=zr33zr+CKRzeZzfohR+MQve8J+BjxqzB65touFCggWCs/JF230kjvXCDANoACAyCcL
         UIjdKIWAlNMcewzBWrqRA07Lq0ymrWNKLp7HSQkPsIxjKTKC/tjQ9rrj79Hye0XXgv6V
         150hQZWCzpsg/GmmLUxfzoiVfrNCfyp/pVdmRPmhop+uA0AkGyCCmogOXjkUXpJ9vKXh
         6n4xklxY+US2S4Jidf2wEb8OJ1vGqpGf7s/Efpq0A63Wlom6ZZR11DPBta8a1eZlgs0h
         vFzZVaDsgRg6RtI1dk06Rgwro9L4+yWadWc/wwYtJJOTHyo5zyB4XAiv54XT9W7j+Aw2
         kTFg==
X-Gm-Message-State: AFqh2krTfcaZ7PJqG7JmhpHK2iewWFa9twjjLl4Kanx0iOti1fOSMMrJ
        Y2jW4J3lJMn5yoP3oAcdk9rBMw==
X-Google-Smtp-Source: AMrXdXtU4h4WpUPuHSkzluQ4H80BcZY2RsZAvMKNoxPZndfx5WIGX6pMpN7KnbrmaNRFaVh80/bHYA==
X-Received: by 2002:a05:6a20:7d8d:b0:b8:c859:7fc4 with SMTP id v13-20020a056a207d8d00b000b8c8597fc4mr268884pzj.1.1673970957653;
        Tue, 17 Jan 2023 07:55:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 127-20020a630985000000b004ba55bd69ddsm8969026pgj.57.2023.01.17.07.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:55:57 -0800 (PST)
Date:   Tue, 17 Jan 2023 15:55:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8bFCb+rs25dKcMY@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
 <20230113151258.00006a6d@gmail.com>
 <Y8F1uPsW56fVdhmC@google.com>
 <20230114111621.00001840@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230114111621.00001840@gmail.com>
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

On Sat, Jan 14, 2023, Zhi Wang wrote:
> On Fri, 13 Jan 2023 15:16:08 +0000 > Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Fri, Jan 13, 2023, Zhi Wang wrote:
> > > Better add a FIXME: here as this has to be fixed later.
> > 
> > No, leaking the page is all KVM can reasonably do here.  An improved
> > comment would be helpful, but no code change is required.
> > tdx_reclaim_page() returns an error if and only if there's an
> > unexpected, fatal error, e.g. a SEAMCALL with bad params, incorrect
> > concurrency in KVM, a TDX Module bug, etc.  Retrying at a later point is
> > highly unlikely to be successful.
> 
> Hi:
> 
> The word "leaking" sounds like a situation left unhandled temporarily.
> 
> I checked the source code of the TDX module[1] for the possible reason to
> fail when reviewing this patch:
> 
> tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_reclaim.c
> tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_wbinvd.c
> 
> a. Invalid parameters. For example, page is not aligned, PA HKID is not zero...
> 
> For invalid parameters, a WARN_ON_ONCE() + return value is good enough as
> that is how kernel handles similar situations. The caller takes the
> responsibility.
>  
> b. Locks has been taken in TDX module. TDR page has been locked due to another
> SEAMCALL, another SEAMCALL is doing PAMT walk and holding PAMT lock... 
> 
> This needs to be improved later either by retry or taking tdx_lock to avoid
> TDX module fails on this.

No, tdx_reclaim_page() already retries TDH.PHYMEM.PAGE.RECLAIM if the target page
is contended (though I'd question the validity of even that), and TDH.PHYMEM.PAGE.WBINVD
is performed only when reclaiming the TDR.  If there's contention when reclaiming
the TDR, then KVM effectively has a use-after-free bug, i.e. leaking the page is
the least of our worries.


On Thu, Jan 12, 2023 at 8:34 AM <isaku.yamahata@intel.com> wrote:
> +static int tdx_reclaim_page(hpa_t pa, bool do_wb, u16 hkid)
> +{
> +       struct tdx_module_output out;
> +       u64 err;
> +
> +       do {
> +               err = tdh_phymem_page_reclaim(pa, &out);
> +               /*
> +                * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +                * state.  i.e. destructing TD.
> +                * TDH.PHYMEM.PAGE.RECLAIM  requires TDR and target page.
> +                * Because we're destructing TD, it's rare to contend with TDR.
> +                */
> +       } while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
> +       if (WARN_ON_ONCE(err)) {
> +               pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +               return -EIO;
> +       }
> +
> +       if (do_wb) {
> +               /*
> +                * Only TDR page gets into this path.  No contention is expected
> +                * because of the last page of TD.
> +                */
> +               err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(pa, hkid));
> +               if (WARN_ON_ONCE(err)) {
> +                       pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +                       return -EIO;
> +               }
> +       }
> +
> +       tdx_clear_page(pa);
> +       return 0;
> +}
