Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF34EE203
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240973AbiCaTnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 15:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240934AbiCaTnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 15:43:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24CC13CA02;
        Thu, 31 Mar 2022 12:41:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w21so594420pgm.7;
        Thu, 31 Mar 2022 12:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qsGcrQBwGTi+5NyS4qf8vP5dYOxF5bqb0qAb2tXdERc=;
        b=MStKuYmsLi0xX9P60xtA4qXl1aL+4rnXErAvTDwSewkBhFWiHmgzo3dl7EZPvmo+k5
         QbL6C+JeUvrHGryk6qn3yyWAX/3HTQIGe0tiFp6eqqRM9zZOkNaIgfGmkcEDDXVoYX33
         oA6vxV14x+fYrf4hSYdYgLysEoUu/AY2mpCMcljU6XwrZuDDLtBwXZJgm3kmemHnhyLk
         rWyPWjyF/zfIgyOV3n1Z7pMy7e3gX3tfHKMG9JHAd+Vl8q6K0J0uA7EH8WucRSPLRuEN
         Yk/Mfm/txzFS9uo5/2vOiDcgm33TN/Zxl3HyjwF9w/OF+Ycy+PDs6a1/s+ADfO13Q70D
         TH5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qsGcrQBwGTi+5NyS4qf8vP5dYOxF5bqb0qAb2tXdERc=;
        b=2wCiv+Eyw5n2MojPblpEDWYiGQyg5ISkj/hTyrgsl1jn38s9DBvt6i3t6hlWp2HwRP
         NaOrpD4wGlf3WhRlzZrJjC6u8ZxbStSh2Mu0Wm510/0uh6JTEHlg3Jznp2OEVNqBQOlb
         4nZvLVxbfFzqM5SPh020082hRSDMEiQRY6QbbOzz9irrmB7bm8MdIojur1vDyipcnfIv
         IyFQLypcRp0eZ64r3tN4QUVCBVkrl9AXvNd1pjRhdRv1HgQY2w0FdYNbqzCnnN2HHqH2
         gTFRFD5nLsyxUoVeLxEpboApTKMeHLdAZE+wy2te2eLPn+rxe+HdSwyvwjkSGOuZ9g3Q
         rGQw==
X-Gm-Message-State: AOAM531JVXdXd4Uxlv9YPa04FQaPpaP85nOaYVg7AAfafFhpI/6Oe6EW
        MGTMnY+hFE9HSlpERcCKS8I=
X-Google-Smtp-Source: ABdhPJxeaZ3jtyAxJe4EcbTylaLFD7g+Wd8z0WzP82DRl7tI7JsL5M55iZIIweIke4/eFcpKqgaFow==
X-Received: by 2002:a63:bf0e:0:b0:386:361f:e97a with SMTP id v14-20020a63bf0e000000b00386361fe97amr11961114pgf.552.1648755706247;
        Thu, 31 Mar 2022 12:41:46 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id h20-20020a056a001a5400b004fb1b4b010asm267163pfv.162.2022.03.31.12.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 12:41:45 -0700 (PDT)
Date:   Thu, 31 Mar 2022 12:41:44 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <20220331194144.GA2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <36aac3cb7c7447db6454ee396e25eea3bad378e6.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <36aac3cb7c7447db6454ee396e25eea3bad378e6.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 04:31:10PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>

> > Add a wrapper function to initialize the TDX module and get system-wide
> > parameters via those APIs.  Because TDX requires VMX enabled, It will be
> > called on-demand when the first guest TD is created via x86 KVM init_vm
> > callback.
> 
> Why not just merge this patch with the change where you implement the init_vm
> callback?  Then you can just declare this patch as "detect and initialize TDX
> module when first VM is created", or something like that..

Ok. Anyway in the next respoin, tdx module initialization will be done when
loading kvm_intel.ko.  So the whole part will be changed and will be a part
of module loading.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
