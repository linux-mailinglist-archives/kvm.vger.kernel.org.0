Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF35F4793
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 18:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJDQ3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 12:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiJDQ3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 12:29:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AD611A27
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 09:29:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gf8so10757208pjb.5
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=IUxbD+pJkUKiwbTjlub7r43XjTNODGmK4AtCtZnddII=;
        b=RcwD9AmyzJcl4BrMwpMbX3I2CGmDQBZUfJWQyO7V/MdQX8eufTUMUaCrrRYTdqmf4j
         6FP0J5TTLCL4ycWDcx/DbirihNzccdTtnhcFXO0m9+0PiCvYrURVw96WsrTVpVWtPXnj
         tTogAyZ1LS5lCPWtzNW/sHb4mDVEOjHnW6AYho9Qct8lUCRBE9C2cLb0GgZiXHsaYZw2
         LkFEjdiYelRSF1H/V0ZSsjswPx+4EBi9H0t1DlmW3pV6IoKN9jrEdHrlfbxW4Y5/os5f
         Q4q8PlfHE5VX5nCU2iJBuibzrd6XpD7jvXRpC7jlgoSy4RqIUnYWjHtEbPqS723bOwcr
         3l5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=IUxbD+pJkUKiwbTjlub7r43XjTNODGmK4AtCtZnddII=;
        b=gTHtxGo9Z6OCGHIw4HYPkUTrN1AYo+XjzJaHIkZitOTKWk9C77dfF+UdGZhXEFme2Q
         Ds5ttMfKdFrU/qIHneb/bJkC3HrtDcJuI8Q59PgYWAATsjmLILbPwtA2sARhjjY7xNOk
         KbM3cktscEOjPJvQMwP1GsoL5G2WWOU8YudAU8Z57axqZUUnC4E2lfQRACI8lvD0mnTL
         fSV+aZyL7JW+eedwepNdUMZAxo1yUO8qP6TX27C/tg8cJwkKGmb40t3tf+c7S7KaJvnU
         ZyidRH/OivLSlEX6PbaXAUlUXIJYakeaGLs0RFyYF5JVyyfWHwN8DMzaYgG5UVsW3UYF
         shRA==
X-Gm-Message-State: ACrzQf1a2EIHYThIa0KjuYzdpnAw3yplJ7ClKCYOr0RTYGy5k95sfkh0
        e4oUJBnXWLu/b2ekABziFs5y/w==
X-Google-Smtp-Source: AMsMyM6kX3Gi8e2o1YL0eQILvJFlD5uxOsQjZtLQ2jNsk/OIBLFtxjrbZwKKg4SCn+Tb84n3i4Kffg==
X-Received: by 2002:a17:902:8695:b0:17f:71ed:dac1 with SMTP id g21-20020a170902869500b0017f71eddac1mr4794424plo.127.1664900987738;
        Tue, 04 Oct 2022 09:29:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902cf0a00b00177f25f8ab3sm9149694plg.89.2022.10.04.09.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 09:29:45 -0700 (PDT)
Date:   Tue, 4 Oct 2022 16:29:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Carlos Bilbao <carlos.bilbao@amd.com>
Cc:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Message-ID: <YzxfdQ7DrT9X6t7j@google.com>
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
 <dd357565-d428-499f-fa0e-e35aa043449f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd357565-d428-499f-fa0e-e35aa043449f@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022, Carlos Bilbao wrote:
> On 10/4/22 09:05, Carlos Bilbao wrote:
> 
> > Reserved fields of struct sev_es_save_area are named by their order of
> > appearance, but right now they jump from reserved_5 to reserved_7. Rename
> > them with the correct order.
> > 
> > Fixes: 6d3b3d34e39eb ("KVM: SVM: Update the SEV-ES save area mapping")
> Actually, there is no bug, so this Fix tag could go. Thanks!!

Fixes: is appropriate, if we think it's worth fixing.  Personally, I don't think
it's worth the churn/effort to keep the reserved numbers accurate, e.g. if the
two bytes in reserved_1 are used, then every other field will need to be updated
just to accomodate a tiny change.  We'll find ourselves in a similar situation if
field is added in the middle of reserved_3,

If we really want to the number to have any kind of meaning without needing a pile
of churn for every update, the best idea I can think of is to name them reserved_<offset>.
That way only the affected reserved field needs to be modified when adding new
legal fields.  But that has it's own flavor of maintenance burden as calculating
and verifying the offset is a waste of everyone's time.

TL;DR: I vote to sweep this under the rug and live with arbitrary/bad numbers.
