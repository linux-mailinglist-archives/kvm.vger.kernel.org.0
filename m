Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D6477BED0
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjHNRUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjHNRUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:20:49 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925CB10D0
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:20:48 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-686e29cb7a0so5133131b3a.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692033648; x=1692638448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hb60I+by4IYJ2RvslpchrA01TfAlxGb3Z0+HBOXiSTM=;
        b=pc+bbMTD1I5N3vZCfumM2t4nBCGZMoSKh1EZd+s47/QBV6vLHyfZp+yPg+iVHrgERE
         HyAwzkXN+/tiLqI93mIN41Wn6Tru4HSW/8uLarQRuFGJ+uVhv+EJFgKTxo9/TTXVQ/9y
         RYvMgZoLzBSRxl0VVK+UUQgKR3fKe+zRdvSS1ZQSqfLxzLjwoS4CUSCRqCPSaLO1tt26
         7isneEyU61tcxyvg9QIE2rqY5UI0/eRciGyEi/0nv6w15Ke6usVMYFOoPOB+92FQlZRN
         BITs220K+iiyRXjekNRUEzTTxsV263YYq7XNvmoGShahRVANJSZmRqI/ktQ4Z9SIkiew
         SQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692033648; x=1692638448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hb60I+by4IYJ2RvslpchrA01TfAlxGb3Z0+HBOXiSTM=;
        b=iE7kzLN6xCfKjBNWczyl7XgItXZ2ScFgMilMYvu09JQJYwrUh9eQLu73OdQR0dDDt/
         2OvpjlszxoAMyRP6CiarVtdsbrswI4a46mYSReVY3YL0iarLox8BXRFjCHugIXM1gBYl
         rquoiyAFVdmYcWLEmEQQKToFlkXDrHzZ6pkU5WEARUpleo9KtoTTHgMHMAjtunF5N5qB
         IjAi4FDV8hpoMr4O+pYwg+3BltAsUFtQ33+HB9FGm3I+YOHPDXuiuR+JB477km4zYKwx
         EV0fcgdFsnvAyY52D3gRQy2uCjCeIHew23uUWJrFPLC9Zyo9n19C1PtWgZ7vCHvcDH6p
         bV4A==
X-Gm-Message-State: AOJu0YziX9lW7a6r8Eo8wfZHLWlytxqDfIHwaf7hGjU1mrQCDi68K7+R
        4suu9RzHBJdFFwRlp9RldT9S2pYb6zE=
X-Google-Smtp-Source: AGHT+IGQ08GfI1AHFkD/9MYPa37qaV6H9DwO3VplFWWx/OqI1SEMkNX8PtGisP5vPTSri9S6IrzNu9rT9wE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2313:b0:687:3110:7faa with SMTP id
 h19-20020a056a00231300b0068731107faamr4235606pfh.5.1692033647805; Mon, 14 Aug
 2023 10:20:47 -0700 (PDT)
Date:   Mon, 14 Aug 2023 10:20:40 -0700
In-Reply-To: <82ba1020-bfbe-dcab-1d8c-961f30c7bf12@intel.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com> <20230729011608.1065019-8-seanjc@google.com>
 <82ba1020-bfbe-dcab-1d8c-961f30c7bf12@intel.com>
Message-ID: <ZNpiaGsEnoOxAspP@google.com>
Subject: Re: [PATCH v2 07/21] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Zeng Guang wrote:
> 
> On 7/29/2023 9:15 AM, Sean Christopherson wrote:
> > +static __always_inline int kvm_governed_feature_index(unsigned int x86_feature)
> > +{
> > +	switch (x86_feature) {
> > +#define KVM_GOVERNED_FEATURE(x) case x: return KVM_GOVERNED_##x;
> > +#include "governed_features.h"
> > +	default:
> > +		return -1;
> > +	}
> > +}
> > +
> > +static __always_inline int kvm_is_governed_feature(unsigned int x86_feature)
> > +{
> > +	return kvm_governed_feature_index(x86_feature) >= 0;
> > +}
> > +
> 
> I think it proper to return a bool, not "int" instead.

Yeah.  I'm pretty sure someone brought this up in v1 too, and I spaced on it.
