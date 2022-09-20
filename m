Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922D65BEC25
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiITRj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiITRjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:39:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C1D6C764
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:39:24 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c7so3355156pgt.11
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rWpDMhOTDtTlNFqC0FU+bCgE4TlD7DZUXOVCdFqtqHk=;
        b=PRow5KNOVsY28eo7kfO2cOVUKtEv+lCi3ZX8z4TiJsOjv0FUD7vk+vFBT/KwldnYZy
         QmGUMLx7Xt3KMnzeVnUerCkCa95gY4yxR4LoFiIf59s12Ihj93YqO5G/CZOpYVyynfMP
         qXYS9+S/ZBUC1GOZuaKLSPqa4JBoihZzivyTOHcXWSv3+mLJSbUxFAgL7KrY5AbdXo6c
         EfibQ2SFVtyPHUpJMsRf0OciCrgJB8hQdHVzLm5Vzhq4Y3CzXVbNZi7CAiSpvmuKuZjg
         4CDECEq9ZZdgQ0MU2yXBcgT2hux5SfMddR0KpTmQQvJyKrLGVGVirjKII/EDtQp9MaHb
         8A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rWpDMhOTDtTlNFqC0FU+bCgE4TlD7DZUXOVCdFqtqHk=;
        b=XTqLope9TDYVUmwCAbV2sAREJ9/KWJIF0+LP45zruA+prAI5aJl84a/trOzIttx9P9
         WsMwjapEyWS4OvNUHpqq9g1jBLm8qyvPppS8zm2863fX3AfZDksg40KD6irrN983axv7
         0//M9Jvvv/IN6iAIMEh2QIZwlBbG3rkMYbHPnm9eBhZLAnxQF5G1msf3QYHsRkwCsvPJ
         LZfdT+K0R/ofix/u1Zjrkr3aRaVS4tYj9IIK0uULIVEqpKppcFvPY9iDQLTQCm5Pkzyh
         prx0/zoaJaJO37ZdfxTk+kI1hqXlr+HL+TpnBZjDuCblJdaHTSsjntLsmtlHbgLdlzDb
         DYfg==
X-Gm-Message-State: ACrzQf3GtgPTwsme4c39NHWqVyQ6B/QtVy6dfXDw5sIh54JZAFoghEdG
        y9OUdgbWtkdkvB1ksiD4W0/9Ng==
X-Google-Smtp-Source: AMsMyM7YVFBVZtE00/uCv5CjoaO8irYok0FfFUmpXpjxXcb/R8kRHl4P3avVo2jOETzZf3X8iEIb+Q==
X-Received: by 2002:a05:6a00:4c11:b0:53e:4f07:fce9 with SMTP id ea17-20020a056a004c1100b0053e4f07fce9mr25634942pfb.66.1663695563550;
        Tue, 20 Sep 2022 10:39:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902714500b00178957d17a4sm129916plm.286.2022.09.20.10.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 10:39:23 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:39:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v7 07/13] KVM: selftests: Add vm->memslots[] and enum
 kvm_mem_region_type
Message-ID: <Yyn6x6Y8wlMgSrgZ@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920042551.3154283-8-ricarkol@google.com>
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

On Tue, Sep 20, 2022, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to

Preferred kernel style is to wrap changelogs at ~75 chars, e.g. so that `git show`
stays under 80 chars.

And in general, please incorporate checkpatch into your workflow, e.g. there's
also a spelling mistake below.

  WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
  #9: 
  anonymous 4K.  There are a couple of issues with that.  First, tests willing to

  WARNING: 'spreaded' may be misspelled - perhaps 'spread'?
  #12: 
  the hardcoded assumption of memslot #0 holding most things is spreaded
                                                              ^^^^^^^^

  total: 0 errors, 2 warnings, 94 lines checked

> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.

...

> @@ -105,6 +119,13 @@ struct kvm_vm {
>  struct userspace_mem_region *
>  memslot2region(struct kvm_vm *vm, uint32_t memslot);
>  
> +inline struct userspace_mem_region *

Should be static inline.

> +vm_get_mem_region

Please don't insert newlines before the function name, it makes searching painful.
Ignore existing patterns in KVM selfetsts, they're wrong.  ;-)  Linus has a nice
explanation/rant on this[*].

The resulting declaration will run long, but at least for me, I'll take that any
day over putting the function name on a new line.

[*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com


> (struct kvm_vm *vm, enum kvm_mem_region_type mrt)

One last nit, what about "region" or "type" instead of "mrt"?  The acronym made me
briefly pause to figure out what "mrt" meant, which is silly because the name really
doesn't have much meaning.

> +{
> +	assert(mrt < NR_MEM_REGIONS);
> +	return memslot2region(vm, vm->memslots[mrt]);
> +}

...

> @@ -293,8 +287,16 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
>  	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
>  						 nr_extra_pages);
>  	struct kvm_vm *vm;
> +	int i;
> +
> +	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> +		 vm_guest_mode_string(mode), nr_pages);
> +
> +	vm = ____vm_create(mode);
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);

The spacing is weird here.  Adding the region and stuffing vm->memslots are what
should be bundled together, not creating the VM and adding the common region.  I.e.

	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
		 vm_guest_mode_string(mode), nr_pages);

	vm = ____vm_create(mode);

	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
	for (i = 0; i < NR_MEM_REGIONS; i++)
		vm->memslots[i] = 0;

>  
> -	vm = ____vm_create(mode, nr_pages);
> +	for (i = 0; i < NR_MEM_REGIONS; i++)
> +		vm->memslots[i] = 0;
>  
>  	kvm_vm_elf_load(vm, program_invocation_name);
>  
> -- 
> 2.37.3.968.ga6b4b080e4-goog
> 
