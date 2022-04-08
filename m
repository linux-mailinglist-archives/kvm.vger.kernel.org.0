Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331044F8E13
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbiDHDwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 23:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiDHDwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 23:52:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69359B823B;
        Thu,  7 Apr 2022 20:50:32 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p8so7319382pfh.8;
        Thu, 07 Apr 2022 20:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pGPSjdqFhm6JbWsLEGkHGwtIOYGZCPpDVeSUP4v73cA=;
        b=khNzBrZQA9Zi9WGe0/dhPo+UEjVpCb97erCc7tj/bNgXPVwSpD8c7kP7v8tqgcmDpL
         hdkUmEyE4KQLoXRIn7IgPeb/m+/hveO7p3KS6BAMkiC1tLgo380tjYOf2aB7M6J3weU2
         9zJLAdVXo435elDtaeT1k6AljhSzxKbqzr0BWct7CM2ZwKjyZhWynb1UwvjJm7dTkUXf
         56pAAfI3v4hMwr55lioXLmMDyNoKjwa9lPJX/kgOHbefuoHiJmXIT3dGFPrPsRPcA+lp
         5nJ2SdR9qFSCRbNdLNZPeuioohw41cOYp+r+xqTME1/9yu6B0tkr5L/AT8J84RcTefMl
         YoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pGPSjdqFhm6JbWsLEGkHGwtIOYGZCPpDVeSUP4v73cA=;
        b=WipsZTlheZHRFWHHvKGHNPVv3lUq9Qqyuq0mzTz9pSUUZUnk0ZELkvu/Lo/pKnaGa7
         I0QSHzxeUf5Eicrg7LNdqwKPCgiE4BauKE5RRB0Z5UfZPXiEwWOuXlAYZYhXGaggW+dU
         34GJYnuWYcNhkkPNjY9dAj3rNAU9LYpEzACpQmmdxLQykBQqDwzkLNqhDUMQtuqU49S5
         tG/FaShbWcVDD55My99WzAnmXrPsPlzgpUA6zqcNSEd/TPJKuXM2IG0fTDAfS8EWRzx/
         mqlx/WbcoZEcmB5HFoXltHoD3fCaizih+9TQhmNRfPP4NPb7frAoDWUcsgkbYCYa5HRI
         ZQkA==
X-Gm-Message-State: AOAM531gYC3aedz8/XmaqdeDoYiT0siLzFQqsgwRGfaANE5Y+rS8wccV
        6ydFrRDowp+v5IX5Sd/xoTY=
X-Google-Smtp-Source: ABdhPJzSdc0sQccqftnTGIzy8mY3AIFZaGnlW1Ak8wlKbfun72U8iv7sNHv2Rbqu7AQE/vcQNSk+RQ==
X-Received: by 2002:a65:670b:0:b0:382:243d:fa with SMTP id u11-20020a65670b000000b00382243d00famr13816032pgf.360.1649389831816;
        Thu, 07 Apr 2022 20:50:31 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a0023c500b004fae15ab86dsm23944711pfc.52.2022.04.07.20.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 20:50:30 -0700 (PDT)
Date:   Thu, 7 Apr 2022 20:50:29 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 102/104] KVM: TDX: Add methods to ignore accesses
 to CPU state
Message-ID: <20220408035029.GH2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <3a278829a8617b86b36c32b68a82bc727013ace8.1646422845.git.isaku.yamahata@intel.com>
 <7ec77c3c-7819-38bb-96ac-ca249e2e0f42@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7ec77c3c-7819-38bb-96ac-ca249e2e0f42@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 05:56:36PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > TDX protects TDX guest state from VMM.  Implements to access methods for
> > TDX guest state to ignore them or return zero.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> For most of these, it would be interesting to see which paths actually can
> be hit.  For SEV, it's all cut out by
> 
>         if (vcpu->arch.guest_state_protected)
>                 return 0;
> 
> in functions such as __set_sregs_common.  Together with the fact that TDX
> does not get to e.g. handle_set_cr0, this should prevent most such calls
> from happening.  So most of these should be KVM_BUG_ON or WARN_ON, not just
> returns.

If debug mode is enabled, guest state isn't protected.  memory/cpu state can
be read/written via SEAMCALLs.  So guest_state_protected isn't set to true.

Anyway for now with this patch series, debug mode isn't supported well, I will
go with adding KVM_BUG_ON/WARN_ON.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
