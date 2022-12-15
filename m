Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B38364E1ED
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 20:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiLOTpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 14:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOTpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 14:45:22 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244EC511CE;
        Thu, 15 Dec 2022 11:45:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso201661pjh.1;
        Thu, 15 Dec 2022 11:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Uan2hxIVFGpaAzm8yWbumiX1BUKNnPwbkIQk8xgSHc=;
        b=pdb9LqgSsAQzWo52jBrj63MNfYkepe8sHph27S2SslJhMQ8lvQZKzcyVS9xiV2gf/U
         jm8OySNgQl9WvqwQ3cdPy8/6spDqJepo/ao52QorB//Bg13KqJ/AJeWwAgSFsixNbfTg
         QpHXuyGE/bX5oyFCzAUdvXaRH6k8tRZg2vQ2rR6JAN3E7aq8DInMRvamV2p36x8YXgbu
         Mp1Jm2fRb0fELyjQxR0BsZN7M62hM+Z1FwiJlOvwPf+K7o00/MsnByVLONiPazmWfeYy
         oB8Hr5si/4SKvckN3rZvCcxpTdQdFNgBxklIAMwSQ4sJUsMVgQk0hmj8cdC6u8Pp/uY5
         NhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Uan2hxIVFGpaAzm8yWbumiX1BUKNnPwbkIQk8xgSHc=;
        b=hAqsuwhvovW/6RUD2n76ffu+9IXbQx+/kDjBDGWs3DMKndFxqbbUvJwUaEPgu7TQMT
         DDEya7xoI0GtbcpM67JTj0iyUYhim9Zyb3UgJXkWVECprPiZkJUh+0N61Xpbsnb9PXZY
         Cwgen8QLCOMGIJC8OQ+Mjvd84fjjom247tLeJ4jikP51WtTmw2tWUSQDbDaQzMi+GuKU
         sWD5DNOp9nTUA9+hn30j5uXcURWgwnc1CF7Vnx0FQ02GS8vfnAEGzdbhR2LUiFtrWniX
         YTv+p1g+np1rvmg7z2mnOF+c+iYE4Nn2nWRWk/VbPiAO00nXF6/cndw8q1LGSRXUE1Mf
         uVog==
X-Gm-Message-State: AFqh2kqoIEGv1nRq/71aSV/t/c6dSLMzyMXulkKPotr1dLJPloLN+eqg
        ukEJ8vIorw4YrE7xn6FzmD0=
X-Google-Smtp-Source: AMrXdXs19x+y1Qgsw1lVqFiIU71in7HC7bDE66JgLhNoJZyUDKgQyg86pb0+Z7GeBl/Q+DgvSX/mcA==
X-Received: by 2002:a17:902:ef89:b0:190:dcdd:edcb with SMTP id iz9-20020a170902ef8900b00190dcddedcbmr9572364plb.56.1671133520369;
        Thu, 15 Dec 2022 11:45:20 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902ecc400b001895d871c95sm35992plh.70.2022.12.15.11.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 11:45:19 -0800 (PST)
Date:   Thu, 15 Dec 2022 11:45:18 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        zhi.a.wang@intel.com
Subject: Re: [PATCH v10 011/108] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20221215194518.GD3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <5f1a80e9ab037fa88d8821a6548638d282070f1d.1667110240.git.isaku.yamahata@intel.com>
 <20221123120047.00001a9d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221123120047.00001a9d@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 12:00:47PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sat, 29 Oct 2022 23:22:12 -0700
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > A VMM interacts with the TDX module using a new instruction
> > (SEAMCALL).  A TDX VMM uses SEAMCALLs where a VMX VMM would have
> > directly interacted with VMX instructions.  For instance, a TDX VMM
> > does not have full access to the VM control structure corresponding
> > to VMX VMCS.  Instead, a VMM induces the TDX module to act on behalf
> > via SEAMCALLs.
> > 
> > Export __seamcall and define C wrapper functions for SEAMCALLs for
> > readability.  Some SEAMCALL APIs donates pages to TDX module or guest
> > TD. The pages are encrypted with TDX private host key id set in high
> 
> It seems a little bit confusing here.
> 
> I guess you are talking about the host pages donated to TDX module will
> be encrypted with TDX module global key id, which is used to
> encrypted the pages only used by TDX module. For pages donated to the
> TD guest, the pages are encrypted with TD guest prviate key id?

Basically yes. Only TDR is encrypted with the global key id.


> It might be better that you can talk about the actual reaason instead of
> the key id stuff. For example Some SEMCALL APIs will zap or write the
> pages donated by VMM via MOVDIR64B, which requires the VMM to flush the
> cachelines.

How about the followings?

Some SEAMCALL APIs donates host pages to TDX module or guest TD and the
donated pages are encrypted.  Some of such SEAMCALLs flush cache lines
(typically by movdir64b instruction), some don't.  Those that doesn't
clear cache lines require the VMM to flush the cache lines to avoid cache
line alias.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
