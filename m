Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E6759FA4
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 22:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjGSU0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 16:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjGSU0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 16:26:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65EA1FD3
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 13:26:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c4cda9d3823so38152276.1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 13:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689798401; x=1692390401;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oORTKAKD7MRf0v4xbk757ByZ/sNqaom2rZH2Wg86KRU=;
        b=bEOzfcoWWy4HqF+LjstunfA56NXZLmLHiQw1a+rzmJlw9aFOS0BPsVsn1uWSnNOIsD
         RRmY9udu6EMhCUVOkPOzZXGY3AF5Xshy2HcU15CkH19Qtd6+/WAp5x5Sd+oGctKaQwcO
         Lfqe6fijofzX7bM24GfYLMg6qfz1Hsffobj9NsyLsKyyQm3d8D0OjupdoJrSPfwiSYm+
         I89OYAsSHBQTnY0FXHCLnUX4lGtZtRqeZ1j+YOsHGfYmNhx+qndb0fIXk45czVecHw/J
         RSjIHJ51rtWjnsolXYYOeRU3j+Uc+tLvccHhsQCUNTgZb1GRXBxuGot+QLtGrROV92p3
         iHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689798401; x=1692390401;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oORTKAKD7MRf0v4xbk757ByZ/sNqaom2rZH2Wg86KRU=;
        b=NcOQOzZA9rZinfL4zfa2qde4L6GLVZvj3b+aC6CI07Q1OLiXk/q7upOZj6idO4TlL6
         eo6/FZ+dcdP7DWiOYt4HmRBuBTvEYBHy+NOR/AHKMvFvIX5h4d1RDe84j0nFosDaRZmM
         T4a5YpIyxvUmsmhVkB0CUsLvH7iaDcDn15zTvdtepaco4TP9x+SRc40WYzeP+qLHOKy+
         k/z/eRyUjf2Y7xacd+B4Q8JmdemkKX9iAX0SbPsj30xSRPTv2GOohERT6SXdsb1b2JpF
         BHHTUJEAJRMPsKClUgKLIlq3P0cGine7Gi3WZ5bawae7nFO3SCNBeS9jAsyuFb4gnbaS
         oVLg==
X-Gm-Message-State: ABy/qLaRjmA/AdS9jFvWNg94+z0JO94bOcmxabwvYasLYLPpt1GNxcG9
        yADIt5h57wnOwyKjapGtCmQg2cQ2DAU=
X-Google-Smtp-Source: APBJJlFG4neUtPxHrc8s2HFAhQQamW52acnzsDPUjstNiqaqtW2RCtjjvUw1UD6pnY/4BJ11aHUzyCzOhfg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:53c4:0:b0:c6e:fe1a:3657 with SMTP id
 h187-20020a2553c4000000b00c6efe1a3657mr29884ybb.3.1689798400900; Wed, 19 Jul
 2023 13:26:40 -0700 (PDT)
Date:   Wed, 19 Jul 2023 13:26:39 -0700
In-Reply-To: <ZLg8ezG/XrZH+KGD@google.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com> <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com> <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com> <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com>
Message-ID: <ZLhG/0HAkX/ZtJTw@google.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Sean Christopherson wrote:
> On Mon, Jul 17, 2023, Weijiang Yang wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e2c549f147a5..7d9cfb7e2fe8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11212,6 +11212,31 @@ static void kvm_put_guest_fpu(struct kvm_vcpu
> > *vcpu)
> > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD trace_k=
vm_fpu(0);
> > =EF=BF=BD}

Huh.  After a bit of debugging, the mangling is due to mutt's default for s=
end_charset
being

  "us-ascii:iso-8859-1:utf-8"

and selecting iso-8859-1 instead of utf-8 as the encoding despite the origi=
nal
mail being utf-8.  In this case, mutt ran afoul of nbsp (u+00a0).

AFAICT, the solution is to essentially tell mutt to never try to use iso-88=
59-1
for sending mail

  set send_charset=3D"us-ascii:utf-8"
