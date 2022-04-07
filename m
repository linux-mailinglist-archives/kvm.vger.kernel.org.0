Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A261B4F8A1A
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 00:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiDGUiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 16:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiDGUhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 16:37:03 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68473598F7
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 13:23:23 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j9so3514072lfe.9
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 13:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v3aZfabxzekEMOjAePaQMaMpU19mVrYZFeElRmeKm3o=;
        b=s3DhjuuVvsNc7ISVmTZ3pr4gsFhIbPpcbSBHQJPF5bfVBpwTAAedlSSd3th1nqQmhZ
         wQck8ROyKEGzCx25khY9rQGLBICgA4uJov/nftmeRFt6t3C1xbzPkqladUp6+kN8y3YS
         2tjCeKNizXoGc2IPpYR44KFvQrKclhdHkDTvC5rdZ+FgqKYfjGOan6e6yzppkSX8CRjl
         6DDGyZbLuSGbFotl6BMeyMVCVXfDj6SOF++1KjsOwMYjeNROajoaYSbv0FKKUr8mhvQT
         jVWrBy83tIVq5W0xqDpdqO7lYE0xTuiLVnFCRukrMic3Cb2ZqRn7xACdg2cho2GrOzWL
         lhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v3aZfabxzekEMOjAePaQMaMpU19mVrYZFeElRmeKm3o=;
        b=cGvwKyEiS/TjLeSoeoBJOfI/SKOfwj4FalhVpjMxWH3gVwUB/QDzr7n0uDi3n2TVn+
         QdjtaE49pFZ3V+a82ppzsQq1/J73YtR2Cc4uCgXDI2pnIvRwvp+i2tUMAAjMWttSiCNy
         cb0qYRKYfRruF2R2r3fLRQaFp7LYDVmd+X/Hx0rl9NlFbpM0S1t/OREP5VI98jP6sM+Q
         wops9iiJqHlxXWr2CbZVg/Ax/cUedIhyxLoViWMiGWWn0yyND3VoQVuaKLr3O++VajaR
         u28vTwFPWThNUFVzODG4eaTIuZUmtQofsIbQV0tOgkKrPU15EGsdeUHBbD4pljn/JhR8
         r7vA==
X-Gm-Message-State: AOAM530FbKY5zaKJKu2DxFujXVjBtxwyRq/1rrOZKU16ABYxLSkO2a/y
        fi4TfRa9f/dlszHQXGLzgkNXJsfpTxky1Q/yweMnOXsdEvs=
X-Google-Smtp-Source: ABdhPJzMKUVGvuvDCXXirl9amkEhAVZVq6GjbXmwQ6sEGeeeImLSFrFcc4bPuDEMbNimHSV2NgRruSdLbwMh14CgUjk=
X-Received: by 2002:a05:6512:c01:b0:448:6aec:65c5 with SMTP id
 z1-20020a0565120c0100b004486aec65c5mr10692711lfu.193.1649361553879; Thu, 07
 Apr 2022 12:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220405174637.2074319-1-pgonda@google.com> <Yk3Wg3eZsGZKb3Wm@google.com>
In-Reply-To: <Yk3Wg3eZsGZKb3Wm@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 7 Apr 2022 13:59:02 -0600
Message-ID: <CAMkAt6ompYSJK0xgmuyMTacLP2+iBjXapVWvj53sYjfzfDJjKQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SEV: Mark nested locking of vcpu->mutex
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        John Sperbeck <jsperbeck@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 6, 2022 at 12:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 05, 2022, Peter Gonda wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 75fa6dd268f0..673e1ee2cfc9 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1591,14 +1591,21 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
> >       atomic_set_release(&src_sev->migration_in_progress, 0);
> >  }
> >
> > +#define SEV_MIGRATION_SOURCE 0
> > +#define SEV_MIGRATION_TARGET 1
> >
> > -static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> > +/*
> > + * To avoid lockdep warnings callers should pass @vm argument with either
>
> I think it's important to call that these are false positives, saying "avoid
> lockdep warnings" suggests we're intentionally not fixing bugs :-)
>
> > + * SEV_MIGRATION_SOURCE or SEV_MIGRATE_TARGET. This allows subclassing of all
> > + * vCPU mutex locks.
> > + */
>
> If we use an enum, that'll make the param self-documenting.  And we can also use
> that to eliminate the remaining magic number '2'.  E.g. this as fixup.

Sounds good. I took this fixup into the V3. Thanks.
