Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2543D62FB7F
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 18:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiKRRVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 12:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242524AbiKRRVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 12:21:09 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E038E08C
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:21:08 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id c203so5463361pfc.11
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1Oryu9eYijvMsGzuGNY+4ss+EsPW5oP6Dg+KrpYPu4=;
        b=l+5HxQ2ht/FVlVHXqkeng5hmVoDGkwPWuSkXfmfsMsOVA7VnHUub/lW3gO9fCA+9KW
         V9KIruuX4PNmzFtrrWW/oefPgSQBCeqBS+/NosWa3v14bN3M0abQ1dJ5NZhMFVxc0ocG
         2CzsM3Htxaeg9bBZ7zqwSaviIEFiK9Ec8AkHIB45yABYeoDR72r5CRGNpgXRotcDNQjh
         V0TKWUCdDRP5/sLRsS5oK+/eMZfisdCrgXQBVmqhLO26xZNJbO6j1XhJ4LVJwljkKnyG
         UypUciCWay0hFVGN740aadBIZKDzUN5X96FHPLPDk1KQ/LeP8p3+fxvKs4XGTzL75SF6
         rBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1Oryu9eYijvMsGzuGNY+4ss+EsPW5oP6Dg+KrpYPu4=;
        b=Gkb+LOYKmMzkjXmPd0QJzTp7IlpIbtHTKTmFmkMPzb4M8O/FCVBeHup97CYnPFiLGw
         Tmc/fyBB2WdU3mL0h5RZaB6bVfKfx7E+5Ya1dV+uP3/APLEYyK8wxP/9LHdz0xG7jNkA
         RZllTrxYMj4b4YANPini1zzmonKmORMhdHZ/0BvOqWq9T19Pcr0o7SqTgjFoawEL24GC
         6NQRuA0uCD5P8mJg3eh274U9jIGAvgrbg/WyMTt7OkmsxhipnYhPva95oVB9lWtUUV2u
         h9EBJC9KUrrMHhWC9Wqi6HPIVrsn4KYSbPiQnwFT3+V0212V0IQ9++G35phEQk9O/EEa
         WzMQ==
X-Gm-Message-State: ANoB5pmHxmOrSB6wwz89HKx2QlGiCB0nKoSFV3emhh1Gq+yGvqvBQpJF
        oUwmACHH163o6VV0/BHgMm1FeQ==
X-Google-Smtp-Source: AA0mqf4VrDF4hTVbqKTc72aoAVl5y5PhlUgwY9/90TF0BZPJ2zdVI9/WYRYH2+ph7XWz/zvH50nyXA==
X-Received: by 2002:a63:ff17:0:b0:470:8f8d:eb51 with SMTP id k23-20020a63ff17000000b004708f8deb51mr7340377pgi.69.1668792067748;
        Fri, 18 Nov 2022 09:21:07 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e22-20020a635456000000b00477078686a9sm3045206pgm.42.2022.11.18.09.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:21:07 -0800 (PST)
Date:   Fri, 18 Nov 2022 17:21:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2] KVM: x86: avoid memslot check in NX hugepage recovery
 if it cannot succeed
Message-ID: <Y3e+/r0MFzJxsX3m@google.com>
References: <20221118162447.3185950-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118162447.3185950-1-pbonzini@redhat.com>
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

On Fri, Nov 18, 2022, Paolo Bonzini wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..5d85f1a61793 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1603,6 +1603,8 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
>  				     struct kvm_memory_slot *new,
>  				     enum kvm_mr_change change)
>  {
> +	int old_flags = old ? old->flags : 0;
> +	int new_flags = new ? new->flags : 0;
>  	int r;
>  
>  	/*
> @@ -1627,6 +1629,11 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
>  		}
>  	}
>  
> +	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
> +		int change = (new_flags & KVM_MEM_LOG_DIRTY_PAGES) ? 1 : -1;
> +		atomic_set(&kvm->nr_memslots_dirty_logging,
> +			   atomic_read(&kvm->nr_memslots_dirty_logging) + change);

Again, this needs to be done in the "commit" stage, and IMO should be x86-only.

https://lore.kernel.org/all/Y3bTu4%2FnUfpX+Enm@google.com

> +	}
>  	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
>  
>  	/* Free the bitmap on failure if it was allocated above. */
> -- 
> 2.31.1
> 
