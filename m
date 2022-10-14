Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D36C5FF55A
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJNV2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJNV2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:28:11 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DCE9A299
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:28:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b5so5388807pgb.6
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TUL+SkC7/koWX+CyJ2/PD9/CBLbq2G9cpQ2gXTLP9mQ=;
        b=FJYhKHLLUm8mE2yX5H3zXOKYKhzcfIgAAI3C4FwOqjzD20sYlqciVAS8RJXmxiA9qW
         kJp1PhxazDMYSVxpUukm6au9DxjlqdYP6whWFEfbgIf77SwMmddhg/CqZuGs98m0hMCG
         52W2g/gteeV0i+2OswtkKH13tGy0Mba6L0JUuwwIAg9mFQVs1iMatpv15wJ43T16ycoV
         Lx2qBbAEDz7K+c8Qqf0Ika5zgaROXj26MSIwKp4jihHI2OXLZT9aO6mnet0aiUfWCzSf
         oejKV/39Uc76CV9VlOVngnUQ9XTvIZD8itnKt5lXysuPjQs0RWTBFj8uxUzfBvAecfdO
         V6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUL+SkC7/koWX+CyJ2/PD9/CBLbq2G9cpQ2gXTLP9mQ=;
        b=Y5wB0UvoF7ucXLJxqd8CdP7CK1nzzvuHFR8MO6YYp4HlgMcqjplFG1ZayydeyJY3px
         oG0mQCdYuAxoRADvvDKzu4EugQxt1XdX9BybI0ouEyAewhMnVVIiakG6JeQhwvdlyEbo
         L5ZWkg6iNmiQcKp2ulAIUze6auE+yNuEoAwitJYXoLEXB6h7hG+3VnNPrbRB0CgT2O2L
         qYlmo2sCOxrQBeIz5S9SySS/tSzE+TgrfXY4xpAotN8+yt7tczCisSTItq364KTmJqoQ
         ZCxpX/DhQtKKRw4g9/0kIjs8TUjs8wtaH1L0AhDQF9jUrDnym6Ed9rTFwRneJ2/sWiMP
         6p3g==
X-Gm-Message-State: ACrzQf3tuK/tTVa434i3B74sfOI19Yp2ebKXPAQhheUhSYUeB/OPLqma
        P/517b9MIAUtLQsH0vEv+x2sQw==
X-Google-Smtp-Source: AMsMyM7DX2VY33DbNCRga+aaC9tQU3wY2Pnt5YZgE/m67b//0sp7Yz2kcSc6xw7BXLbNRSRIGls7RQ==
X-Received: by 2002:a63:8b44:0:b0:45f:952f:c426 with SMTP id j65-20020a638b44000000b0045f952fc426mr6083058pge.623.1665782890167;
        Fri, 14 Oct 2022 14:28:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c16-20020a17090a109000b0020d39ffe987sm1893977pja.50.2022.10.14.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:28:09 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:28:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v9 12/14] KVM: selftests: aarch64: Add dirty logging
 tests into page_fault_test
Message-ID: <Y0nUZuiRJh/WUnVd@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-13-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-13-ricarkol@google.com>
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

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> @@ -395,6 +415,21 @@ static bool punch_hole_in_backing_store(struct kvm_vm *vm,
>  	return true;
>  }
>  
> +static bool check_write_in_dirty_log(struct kvm_vm *vm,
> +		struct userspace_mem_region *region, uint64_t host_pg_nr)

static bool check_write_in_dirty_log(struct kvm_vm *vm,
				     struct userspace_mem_region *region,
				     uint64_t host_pg_nr)
