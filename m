Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916356BF6A9
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 00:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCQXvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 19:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCQXu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 19:50:58 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C963E1FC
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:50:48 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id t4so7399196ybg.11
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 16:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679097047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40SYtescCvfCGAi5XHERgN8nFtAU5GVizy5oS3Wu78M=;
        b=PN2NchNdEqSQQBKCQBvGRp/x1n2ZVsVm0u/dTl7Zw9sD8pb59coqoNYMw5jzVARg0e
         997l3uWBuZUfvHK7e4z9uT26rpW18VdcMU0T15Pwdik5eGGESupmKFsQmF/xnPVSIfuw
         F4xKWkBsX+MNR/LTZpp+AcL7MkVQbkRk6AFfL1sJo4tcaOOYzHgSk8VkFbwK6HJTMtZH
         1D0fiaF0nnMrUoEHiGsNFqRBwSQXbUb6vhPNg8+LTqwjeROivMadpN3zAY5hgd7ZNOmK
         THqMdv8HVo7MpwII9JtYWOoHDRVZzPSmlS44qXfgnHg/VXc3yAIuE/xo3dogja5G9Jka
         Q3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679097047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40SYtescCvfCGAi5XHERgN8nFtAU5GVizy5oS3Wu78M=;
        b=bfCaIWlV5mJfDlGM3fZwrPNRYoFEHVUyXUA8rSQNdlWazbaNJCZrXWNX8forLAXhmf
         T/RZelarjsEJo6InzEzg5yq84sKsHScBa0w1bulDUndpSpfVd0Jx8Rome2Z6S5+VcsMo
         43Pd/KcxZc+j8eFXbYP+69LxHn3zTqDBUFP2Kie6A/Rc2BflYvLPeugaOvOb+HCESOwm
         s/SDQq9LYkj4ASR+4i/fWrdi/GOQtQ1A8u20SBNjsvbGTM3qksSfEYScVtck1k8kx3ss
         w/vrHDzdWDoAQbomsMlOe9WWi7+Cqjox2MyAwV/GTkgG7XYihgwACwNW2bhDbQbQrtaR
         VYdA==
X-Gm-Message-State: AO0yUKVVzLRmGp8IU/RGGLisjc8h5zjndZ0eLRCOqpxPWw7E+JbagXjf
        ThnDb0WZtFaTGyyxClnX79CGgT12+CCwLplAHcPc1g==
X-Google-Smtp-Source: AK7set/Vi3ON1GlUJyGCEco27zQ94kbvwQdMrcdXjmrDz6vFXVppSAos02WE1Z14n+7DYs0RWKUMCKIVB+9Wr+eHsec=
X-Received: by 2002:a25:9347:0:b0:b0a:7108:71e9 with SMTP id
 g7-20020a259347000000b00b0a710871e9mr146258ybo.4.1679097047406; Fri, 17 Mar
 2023 16:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <20230211014626.3659152-3-vipinsh@google.com>
 <ZBTw6ymNg0gYxhtW@google.com>
In-Reply-To: <ZBTw6ymNg0gYxhtW@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 17 Mar 2023 16:50:11 -0700
Message-ID: <CAHVum0dKw-i5v+m8xgD=8bqs3tajFbJoSnZadjYtXSORKcuF0g@mail.gmail.com>
Subject: Re: [Patch v3 2/7] KVM: x86/mmu: Atomically clear SPTE dirty state in
 the clear-dirty-log flow
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Mar 17, 2023 at 3:59=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 10, 2023, Vipin Sharma wrote:
> > @@ -1677,8 +1670,13 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kv=
m,
> >  static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page=
 *root,
> >                                 gfn_t gfn, unsigned long mask, bool wrp=
rot)
> >  {
> > +     /*
> > +      * Either all SPTEs in TDP MMU will need write protection or none=
. This
> > +      * contract will not be modified for TDP MMU pages.
> > +      */
> > +     u64 clear_bit =3D (wrprot || !kvm_ad_enabled()) ? PT_WRITABLE_MAS=
K :
> > +                                                     shadow_dirty_mask=
;
>
> Switching from spte_ad_need_write_protect() to kvm_ad_enabled() belongs i=
n a
> separate.  In the unlikely event that the above assertion/contracts is in=
valid,
> then any issues should bisect to the switch, not to a much more complex p=
atch.
>
> I'll make that happen when applying.

Make sense, thanks!
