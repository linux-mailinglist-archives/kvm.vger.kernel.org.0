Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C0718A5E
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 21:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjEaTmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 15:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjEaTmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 15:42:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C081E9F;
        Wed, 31 May 2023 12:42:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-30ae901a9ffso4152f8f.2;
        Wed, 31 May 2023 12:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685562128; x=1688154128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H+Lrg+cef4AzgdRPNwMc3JQ+W3n37RMN6RoH/5pQGBs=;
        b=Pq+rb06tiVg+mAqAr48Y8tAJvGvxKMrtXmSN2iUJAAQdTnXhrKim1F1yrjTjVEcuhN
         eBqSElUhXbc7/35Qj054/PzSUQpIas6insFVetQa3OdeG7g2jYlSvi5jGYvv5AMXQjXe
         ESxHdhw7O4Vnpq2VAgj/MD66vVzRnXjgQZ8cGTjzhnwTgO/f7zlRG9OlREHxOC/hCQFz
         1igMcgNFA3avLZ+Q0GJRUbjglAqOdOQqfrJvp3OEXS+kNZC9jcs/7OrjpiAupmfRLLQl
         maUbEb4E3mH/i+HnUniSapWSE87MC+KkO6RlXoQWdaLt0oPmjgEu0jjlLSZ0OmrFDrnJ
         v+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685562128; x=1688154128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+Lrg+cef4AzgdRPNwMc3JQ+W3n37RMN6RoH/5pQGBs=;
        b=WCGdexas9Ps9bXQo55p/oUi7u154GZcCLe6Zj51kdLhfUWQyrVaYjVEU0s7StJeiM/
         3f1MkOO7DSvkDalAywfPvVpq9rk49pX6zsSfgKy+G/WXxMCOQGcIUvMW3SFN5UkGu/zr
         R59yxvx4o2QX1IdVGC5epN1Gqsyyt5NsxPddjeSi87UQY5sd/vQdwSeGAZWHmnTZp3+a
         U3Rnx08wTJAC6Ix1jwfRD9dfXCl6QHQydfBeC7UQrqXRB2f7ZN4d9I30Jbq0675Sjg7t
         FzmAqLNa+RMk+IqQZcr/fExy9KrX/YNFetfHCD95x2497MidaeAxkxGnlhJFwHpcs7KO
         VKXg==
X-Gm-Message-State: AC+VfDxNbrO9qUkcRAFQSYn9QoOlJGKgc+413Do5o+Z6mEfnqH/tp6Jr
        AfEuVZoArC0pw3NLQn8jyQ==
X-Google-Smtp-Source: ACHHUZ6RaZ6tKSDvEcd+c6MOPkOYZzF/6vqW3Uq46Du52RlraPAzAzTBHB6S2sKzPJEJb4EdDlYCMw==
X-Received: by 2002:a5d:4249:0:b0:309:3bb5:7968 with SMTP id s9-20020a5d4249000000b003093bb57968mr124961wrr.16.1685562128024;
        Wed, 31 May 2023 12:42:08 -0700 (PDT)
Received: from p183 ([46.53.253.153])
        by smtp.gmail.com with ESMTPSA id t6-20020adfdc06000000b003063a1cdaf2sm7804584wri.48.2023.05.31.12.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 12:42:07 -0700 (PDT)
Date:   Wed, 31 May 2023 22:42:05 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Message-ID: <047566b9-c2ef-40c7-9a76-caa8607b3f6b@p183>
References: <20230531155821.80590-1-jon@nutanix.com>
 <ZHeP75vG8xA+UeHt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZHeP75vG8xA+UeHt@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 11:20:31AM -0700, Sean Christopherson wrote:
> On Wed, May 31, 2023, Jon Kohler wrote:
> > Commit 8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()") changed
> > vmx_vmexit from SYM_FUNC_START to SYM_INNER_LABEL, accidentally
> > removing 16 byte alignment as SYM_FUNC_START uses SYM_A_ALIGN and
> > SYM_INNER_LABEL does not. Josh mentioned [1] this was unintentional.
> 
> Anyone know if this is this stable material, or just nice to have?

Can this improve vmexit latency? I didn't measure it.
