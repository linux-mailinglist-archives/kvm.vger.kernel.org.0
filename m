Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5160E6068A5
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 21:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJTTId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 15:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJTTIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 15:08:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521921D1031
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:08:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g8-20020a17090a128800b0020c79f987ceso4405780pja.5
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7KaSUTIY6cNqvNAvPqG3Fbm75rkhgGc+LZ3JFLjVNac=;
        b=WehxH0aDm1aN762sYjZKUXIuVzz9fZ2QkXgTSbj0mrJZuCf4ho3O0k4DMHtVtR/34Y
         tYZE8yjQQdaknWgHh7bTyypsQMq19GKoheVyjgTfr8GLv+zSoitGZzvFb6KeRrQao2cG
         R6rbIq+1RUnWf15gZRxR5q6Jew2JDzjaeBDwOADr2ELgTbq1wFndNfy3OOX5ZqRHX5bN
         cLzs26bN0HcZ+gRQpLB7Zj+j1vgtqo1E5v60I2HAyMh5WoK8rOa1108sdvx4YedgCV/n
         s1K5iQ/tuCUfLv8dfyqne2ZKOnMUkGHV/BMzBVUV0H8zSQFUqNXzvNN9ir8mrt2Q7H/5
         oStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KaSUTIY6cNqvNAvPqG3Fbm75rkhgGc+LZ3JFLjVNac=;
        b=Dzx1Z4gz0qDjW4fMnCLAhfDZ5r7vX5qiHCWe/KvCasocAyovOZXY05s3bKQ9/F8mZu
         ndbxV1AC1TeXuq2ok2jxVtvYITmwynaVL6OWYesXHOR/2qUobC9AKiJsEZoxOpEzw96j
         PnfsCs34/sT7/2t57dcEMLLOOthFw/PmYbXRJLxXCQHGLVXg1riGxDhQu6yWNaiTnBHC
         zRBKJXhQM3VBPufwCANnl2/jVvajm4eG90FpSZH+EpAzdYIugdatYpVjK+0PjuyjFimU
         MMywcAs0W9HgE30+pDyvbfAKnFZrFvsV5LyyD1pbQZz08MzVzN6m0bW8IWwDQBkwP8C9
         XMrg==
X-Gm-Message-State: ACrzQf11egGZDXmtQstD4OduoACsflRQsm5nz1ZfC7BERTCwcRg5LzCj
        L7iPHl1HaIbyo5wIv1vFS2eXebs7LBzq8w==
X-Google-Smtp-Source: AMsMyM5STQUiqCU8n5hv5VfnReZjgRCxcjrcrlk5FCmBO7TCnBXsrFAJQDYyk+S4aPXI6GjbPiJu9Q==
X-Received: by 2002:a17:90b:1bc9:b0:20d:75b8:ee5d with SMTP id oa9-20020a17090b1bc900b0020d75b8ee5dmr18156367pjb.147.1666292909748;
        Thu, 20 Oct 2022 12:08:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j5-20020a170903024500b001853e6d6179sm13356582plh.162.2022.10.20.12.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 12:08:29 -0700 (PDT)
Date:   Thu, 20 Oct 2022 19:08:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 09/16] svm: move svm spec definitions to
 lib/x86/svm.h
Message-ID: <Y1GcqvYwBEkNVgbB@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-10-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-10-mlevitsk@redhat.com>
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

On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> This is first step of separating SVM code to a library
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm.h | 364 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm.h     | 359 +------------------------------------------------
>  2 files changed, 365 insertions(+), 358 deletions(-)
>  create mode 100644 lib/x86/svm.h
> 

...

> +enum {
> +		VMCB_CLEAN_INTERCEPTS = 1, /* Intercept vectors, TSC offset, pause filter count */

Indentation is too deep.

> +		VMCB_CLEAN_PERM_MAP = 2,   /* IOPM Base and MSRPM Base */
> +		VMCB_CLEAN_ASID = 4,	   /* ASID */
> +		VMCB_CLEAN_INTR = 8,	   /* int_ctl, int_vector */
> +		VMCB_CLEAN_NPT = 16,	   /* npt_en, nCR3, gPAT */
> +		VMCB_CLEAN_CR = 32,		/* CR0, CR3, CR4, EFER */
> +		VMCB_CLEAN_DR = 64,		/* DR6, DR7 */
> +		VMCB_CLEAN_DT = 128,	   /* GDT, IDT */
> +		VMCB_CLEAN_SEG = 256,	  /* CS, DS, SS, ES, CPL */
> +		VMCB_CLEAN_CR2 = 512,	  /* CR2 only */
> +		VMCB_CLEAN_LBR = 1024,	 /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
> +		VMCB_CLEAN_AVIC = 2048,	/* APIC_BAR, APIC_BACKING_PAGE,
> +					  PHYSICAL_TABLE pointer, LOGICAL_TABLE pointer */
> +		VMCB_CLEAN_ALL = 4095,
> +};
