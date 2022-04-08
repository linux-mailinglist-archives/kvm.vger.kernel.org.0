Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8708E4F8E88
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbiDHFhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 01:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiDHFhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 01:37:02 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D956E13D64;
        Thu,  7 Apr 2022 22:35:00 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y8so2326824pfw.0;
        Thu, 07 Apr 2022 22:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M9GeHxOMMEsAW0gA0HYTOdLUoDAu3ektn3I3+ONaQ78=;
        b=iuN+YiAnhi4v1/0R0HOX4xh70eB3YiaK4mxf9D7VrRedSnKBVG1bPI7e4hBhLMyn6I
         EP3EQVc/c5XXRpoPZtxAE2grPFYBMXYm7VW9IRGucH2ZOw05Fjx80ms4gqWQ8Xc26/0s
         fQZB77ggqAr09i7Wp9zGWuKbn4kOkwahgb60gOXZyJ/XBilId/BGRSM1zycYTKbSbwTr
         qD1V4F5S3rTVl7krq0UmV0+3GZwKggtIYpUfJZfjrh6Xl/ySynO2lhELXWTIsXdpS315
         EVw2et4gxvLGuHtWUQjO53grE4n9TMzO0jefdg/9oT477pbO6U95H57vJNKRzo+z9qgj
         bCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M9GeHxOMMEsAW0gA0HYTOdLUoDAu3ektn3I3+ONaQ78=;
        b=1ewk4cbqiYgq+cHV0C8xTIx1bU6lSYUugLd2J4cjT6nJNhoDCvUo465sLFUZRqc0p/
         DQMyJuuVePiiS+cxCZHvTsI8UX8yOb6St2QSPYDQwoSFzWiNTVsQdo3JoqmVY3hB2R9Q
         GKAV12DC2bi+cZz5gI4tgQSdHX2WhLkgsFH7naD/NYSIinATOaNzYacHdrePFIpkWXa4
         eTPFCx9pnUUyz0gWB5U0mZsEf6tB4BXkk1w9li0Xxgxv+10WMyDQ2Ye/Y04LPRnqnNpJ
         jkK+/hsybQXWZw6p9lxyI/iTqXn01FYwi/6daFW9h8ZfZWIt3gexnLHvMsVFlQtpC/7o
         yEfg==
X-Gm-Message-State: AOAM5301ZYkSCQkwinWwcsXHm0s6SgudrRR1gnqifzh4bG/pnnHRuI6I
        mKAM1jL1i6jAnMOD/5eJuyyzIewA1JA=
X-Google-Smtp-Source: ABdhPJx/XECfC8Kwv7ypEIy3LDZeAQh4csiALroh2Vt6IrSaBqHpDu5jRjodhb64ZQWN1o2k2cYPKQ==
X-Received: by 2002:a62:1e03:0:b0:505:64c1:3e19 with SMTP id e3-20020a621e03000000b0050564c13e19mr7824024pfe.32.1649396100336;
        Thu, 07 Apr 2022 22:35:00 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id mn18-20020a17090b189200b001cac1781bb4sm10718776pjb.35.2022.04.07.22.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 22:34:59 -0700 (PDT)
Date:   Thu, 7 Apr 2022 22:34:57 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sagi Shahar <sagis@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 083/104] KVM: x86: Split core of hypercall
 emulation to helper function
Message-ID: <20220408053457.GA857847@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <f3293bd872a916bf33165a2ec0d6fc50533b817f.1646422845.git.isaku.yamahata@intel.com>
 <CAAhR5DFPsmxYXXXZ9WNW=MDWRRz5jrntPvsnKw7VTrRh5CbohQ@mail.gmail.com>
 <1eac9040-f75f-8838-bd75-521cb666c61a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1eac9040-f75f-8838-bd75-521cb666c61a@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 03:12:57PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> > > +       if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
> > > +               ret = -KVM_EPERM;
> > > +               goto out;
> > > +       }
> 
> Is this guaranteed by TDG.VP.VMCALL?

Yes. TDCALL instruction in TD results in #GP(0) if CPL > 0.
It's documented in trust domain CPU architectural extensions spec.
https://www.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf

Anyway VMM can't know TD guest CPL (or other CPU state).
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
