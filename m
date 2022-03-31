Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9E4EE276
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 22:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241311AbiCaURo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 16:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbiCaURn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 16:17:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979032405A8;
        Thu, 31 Mar 2022 13:15:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t4so679650pgc.1;
        Thu, 31 Mar 2022 13:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G3GMOK4NcGeu/Rm7pxZSYI23p/RSyGdy+8yXGjFy7BQ=;
        b=FvbCqjOPfZjPFbAOGXjM+Ct6mKiwSgG2xGBSoByDrEXPhNfK9gBjvmWy/5TprtIXR4
         6EYkYaa5U7HKkXv+2Ysgkt+PGxxNBiqd1LLzjgFGXYjA67h97ag0JcsWEgKiWp0xZviR
         QyrBlKQWC7EOWzxt43deQ07Ds2gKKkGi52Wq9BFJex57VM4tLoe5rAnVS2d9gAJz6oOu
         5HXp2nEbpLMQ/XuY9EAxH3mPpN0VGUijXC2hUw/MO05xiPHqM18bM/VILlXVhxBcw2uZ
         axoT9sX3fjtQ99ToQjF/ECVx+y91a8gZYemKNfEKEgO6kgSpgLjRyoKSzo+mqmAr1C3c
         UjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G3GMOK4NcGeu/Rm7pxZSYI23p/RSyGdy+8yXGjFy7BQ=;
        b=se+sdV0My+kEvBtllV49FsoJ2LXk+3elTd8I+EgOcR/EIXx5mvn9/0H2nbgWg1Z23+
         udFxotahAsYP1CF76lf2lsMwvG0vJm0Bk43OECcFefn3FHS7wrV0mIMjGeAGgfM5DepL
         0GemCnkBTZZD+5qrykt4l7V0pKRpaJUsbFPsaV9zerPB0Vb+LFC9AeDdJEz5f6qUhcOA
         BO5rSZBQjEUz3huSA9XAV4SKeXt6WQCLY9HDCae3Mlt4Ys3YPtjm6WuPZp6pMvRV3BSJ
         Lezwc8lRqBq85//PmTbbPjqEs4F28PiNtqNOAF3iN0cvcBzDKi2TlDvgjfMlsm98sovG
         EcXA==
X-Gm-Message-State: AOAM532FnHiK5wO1le0VmjAQfjGhDV8jCops9HHjeFDAPTPU0pLk0Th2
        1DcgmKf/Ivhng2xdYOA67as=
X-Google-Smtp-Source: ABdhPJx+MElvTq7xqT6Ah0xsQ/9J0CaUC/E45h+HRia1cTzUYRcJMoVVdO7sN+vE3B3Az1hICugsZw==
X-Received: by 2002:a65:6753:0:b0:385:fa8a:188f with SMTP id c19-20020a656753000000b00385fa8a188fmr12246379pgu.499.1648757754218;
        Thu, 31 Mar 2022 13:15:54 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id w129-20020a628287000000b004fdc453b49asm328013pfd.39.2022.03.31.13.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 13:15:53 -0700 (PDT)
Date:   Thu, 31 Mar 2022 13:15:50 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 023/104] x86/cpu: Add helper functions to
 allocate/free MKTME keyid
Message-ID: <20220331201550.GC2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
 <2386151bc0a42b2eda895d85b459bf7930306694.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2386151bc0a42b2eda895d85b459bf7930306694.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 02:21:06PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > MKTME keyid is assigned to guest TD.  The memory controller encrypts guest
> > TD memory with key id.  Add helper functions to allocate/free MKTME keyid
> > so that TDX KVM assign keyid.
> 
> Using MKTME keyid is wrong, at least not accurate I think.  We should use
> explicitly use "TDX private KeyID", which is clearly documented in the spec:
>   
> https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf
> 
> Also, description of IA32_MKTME_KEYID_PARTITIONING MSR clearly says TDX private
> KeyIDs span the range (NUM_MKTME_KIDS+1) through
> (NUM_MKTME_KIDS+NUM_TDX_PRIV_KIDS).  So please just use TDX private KeyID here.
> 
> 
> > 
> > Also export MKTME global keyid that is used to encrypt TDX module and its
> > memory.
> 
> This needs explanation why the global keyID needs to be exported.

How about the followings?

TDX private host key id is assigned to guest TD.  The memory controller
encrypts guest TD memory with the assigned host key id (HIKD).  Add helper
functions to allocate/free TDX private host key id so that TDX KVM manage
it.

Also export the global TDX private host key id that is used to encrypt TDX
module, its memory and some dynamic data (e.g. TDR).  When VMM releasing
encrypted page to reuse it, the page needs to be flushed with the used host
key id.  VMM needs the global TDX private host key id to flush such pages
TDX module accesses with the global TDX private host key id.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
