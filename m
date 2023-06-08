Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F6728BC2
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbjFHX33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjFHX3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:29:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5787030F0;
        Thu,  8 Jun 2023 16:29:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-65311774e52so905951b3a.3;
        Thu, 08 Jun 2023 16:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686266962; x=1688858962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6RGbjUYsdaohPZQXqH0ffB3I+/zH7l+P+guRk55pY3o=;
        b=GKUqaxYpA9sPWVTJUqhY/WvUJd0oMJh68pPhWRdgURVT0nWmLLk+PH0CZGMNu9NA5Z
         bRiLFi1+g5t3OToeIuLBoxouHAfU/mDzBROQ7M/Tsef1mypcXnCe8LHxoBxLOrnM6ZbM
         4qfiJ87XgvvzdG45loNAZ4ywZD1ZcvLtxj+IIyoilamuFhZLXVq+SmbFp1cwklOXpCuI
         yEEPvPJpyQ5KGkMGD6k2sp8h4rNxvLBHg68PEehqHNEXuLkCIioiOmhVzjyKekLNCh4n
         fp6Ni/Frzf10PCiBBZbi7+BkpecMiiJJcRMZP40H3H/+HasliRX+d3grVqDxmZpSIs9v
         CZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686266962; x=1688858962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RGbjUYsdaohPZQXqH0ffB3I+/zH7l+P+guRk55pY3o=;
        b=MiE5LnXODgV5mhJxBZDTIka27DotXVcxRQFyg6FKH3EK7TJCtTqzNTe4h4IWUFMhmI
         PvlBd5FNYtXfr8GqonUNF9hNfemc0gjtPoDD+SFM+ArbtUtnisVuRPme684Llew5o+N3
         +FFHbxAJOCOVrQxawwYFyu7pHWIiGtvO3UdV3LCAa7EtoOgE5rCNvxNFnhKUralf2VAp
         +YPGUhS+OAvDwoB5AK9W9T98ryZ+LY4wTFXaLB8j4SK7oE91YqLKBHykevFvBgMSq/22
         s34BE5PLegLgGfVoy39h/wuThp+6P4arovCfDkpJ3xJXpxNG71GRDtq5+Tzp4TuXOgQp
         +FDw==
X-Gm-Message-State: AC+VfDxOd0Pxg0fgTEQvOJwyrZ7dcebMBrGhu1dfGdw2579MeVxFGBSl
        aN2StNjsSV2ElSW9MHegiS0=
X-Google-Smtp-Source: ACHHUZ5BemoIUtUyIQMWaimD9moPUg4gS1XMy0WBlsJ68BJAUvGHQpvMYcO3s/oFNl28ctNzJaryZw==
X-Received: by 2002:a05:6a20:e617:b0:105:dafa:fec2 with SMTP id my23-20020a056a20e61700b00105dafafec2mr4523293pzb.53.1686266961618;
        Thu, 08 Jun 2023 16:29:21 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id q24-20020a62e118000000b0063b85893633sm1535576pfh.197.2023.06.08.16.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 16:29:20 -0700 (PDT)
Date:   Thu, 8 Jun 2023 16:29:19 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v11 08/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230608232919.GM2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <50386eddbb8046b0b222d385e56e8115ed566526.1685887183.git.kai.huang@intel.com>
 <20230608002725.xc25dantcwdxsuil@box.shutemov.name>
 <19ea7470e9d6fa698f9ad7caff3279873e530a0b.camel@intel.com>
 <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230608114128.vu75wlcojpyjak22@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023 at 02:41:28PM +0300,
"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com> wrote:

> On Thu, Jun 08, 2023 at 02:40:27AM +0000, Huang, Kai wrote:
> > On Thu, 2023-06-08 at 03:27 +0300, kirill.shutemov@linux.intel.com wrote:
> > > On Mon, Jun 05, 2023 at 02:27:21AM +1200, Kai Huang wrote:
> > > > For now both 'tdsysinfo_struct' and CMRs are only used during the module
> > > > initialization.  But because they are both relatively big, declare them
> > > > inside the module initialization function but as static variables.
> > > 
> > > This justification does not make sense to me. static variables will not be
> > > freed after function returned. They will still consume memory.
> > > 
> > > I think you need to allocate/free memory dynamically, if they are too big
> > > for stack.
> > 
> > 
> > I do need to keep tdsysinfo_struct as it will be used by KVM too.
> 
> Will you pass it down to KVM from this function? Will KVM use the struct
> after the function returns?

KVM needs tdsysinfo_struct to create guest TD.  It doesn't require
1024-alignment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
