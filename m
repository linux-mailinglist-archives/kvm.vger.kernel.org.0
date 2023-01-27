Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC967DA88
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 01:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjA0AQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 19:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjA0AP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 19:15:57 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958C76C126
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 16:15:22 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id k4so3738424vsc.4
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 16:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QjeHhACl8gnIS4cmcvzy1UcNTbu80hG/eXrpn1xCMvY=;
        b=pz7k21q+eoVbdLB/KOGFdbVo0S75UR2AiRZhExahr91vXX4JB8Kai5pp0+zLhwm1tR
         HAbyi0mTdWrta+50nwzdTsyLe19F0UFHIyxkoZImiCy2Yad4f5BhvlPTanir+f59Odxj
         jpIzXUXs5Kh/llv8MEo25DmxudF61ctx7nW1MMOgTDiP1TszPCKpx/3lLrRw8n1FgvwP
         ybAbVwkcP4sprkey9Tp996iqPfzoMATFIpkdW7O2/gSRp1Hg7zx8c/aLuoWphFVl2SdT
         fRUi87ZOmgchrxUj+7xrwSwJo2o+8YizQ7+M9SPVH54jdtsVm0uwvU+hhW5pUseBD9eu
         36Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QjeHhACl8gnIS4cmcvzy1UcNTbu80hG/eXrpn1xCMvY=;
        b=uKXqovG8SLmCmkSN5H5qXF9qn/suVinsvxj+mT5Qqer+rtdPXIHa62sLTpFvMlqDuq
         pCLN7mnqK9KDgqMAKSQKDqmAax11g5/kTocYqeyWoUIeIXH9eh2Yte4g/vn6TkFyT1rf
         ucgYy9A1n3Kd1D/cZ33bZrYjpBj1WIdUU1K5HE3XGKsHlzK1JvM+aLTDyEIuVKNadQpU
         tmv9QTgguzTJerg4kTb2Jr7cH3fiw0/HGyBpozuucrHyJStVHlM+oR7AYBzjfFFBnNTQ
         RI+pnJdLCwC4vXWRaVLJPytY431VxtHBe382HTVjVHU46A+7b7zzx0SJAgXARYgRcK8n
         clYw==
X-Gm-Message-State: AFqh2kqld59jPDqPbHcwZpXTJ0vjfhZ2Jgby5851R4InhWRG4QFQUwsJ
        Qzy01cOFEXfRwfadO30UReueNavWgvHgOZNofCLKkKSzAHnc34CO
X-Google-Smtp-Source: AMrXdXuqZ1Jh6mZlyLbFkX/dM4JRRvAtX1YB6jX74MnLmQWTS8Bx7U7BHD40c2kaVy2lFNh0D1QB/AluFR6znHuhy5E=
X-Received: by 2002:a67:66c2:0:b0:3ce:ce8c:4175 with SMTP id
 a185-20020a6766c2000000b003cece8c4175mr4726661vsc.48.1674778497531; Thu, 26
 Jan 2023 16:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20230126210401.2862537-1-dmatlack@google.com> <Y9MA0+Q/rO5Voa0D@google.com>
In-Reply-To: <Y9MA0+Q/rO5Voa0D@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 26 Jan 2023 16:14:31 -0800
Message-ID: <CALzav=dXWkX7aFga=T9fk1auXcArECLXMOEotWnGODeGVL44iQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Replace tdp_mmu_page with a bit in the role
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Jan 26, 2023 at 2:38 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 26, 2023, David Matlack wrote:
> > Replace sp->tdp_mmu_page with a bit in the page role. This reduces the
> > size of struct kvm_mmu_page by a byte.
>
> No it doesn't.  I purposely squeezed the flag into an open byte in commit
>
>   ca41c34cab1f ("KVM: x86/mmu: Relocate kvm_mmu_page.tdp_mmu_page for better cache locality")
>
> I double checked just to make sure: the size is 184 bytes before and after.

My mistake, thanks for pointing it out.

>
> I'm not opposed to this change, but I also don't see the point.  The common code
> ends up with an arch hook in the appropriate place anyways[*], and I think we'll
> want to pay careful attention to the cache locality of the struct as whole, e.g.
> naively dumping the arch crud at the end of the common kvm_mmu_page structure may
> impact performance, especially for shadow paging.
>
> And just drop the WARN_ON() sanity check in kvm_tdp_mmu_put_root() .
>
> Hmm, actually, if we invert the order for the shadow MMU, e.g. embed "struct
> kvm_mmu_page" in a "struct kvm_shadow_mmu_page" or whatever, then the size of
> TDP MMU pages should shrink substantially.
>
> So my vote is to hold off for now and take a closer look at this in the common
> MMU series proper.

Sounds good to me.

>
> [*] https://lore.kernel.org/all/20221208193857.4090582-20-dmatlack@google.com
>
> > Note that in tdp_mmu_init_sp() there is no need to explicitly set
> > sp->role.tdp_mmu=1 for every SP since the role is already copied to all
> > child SPs.
> >
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Link: https://lore.kernel.org/kvm/b0e8eb55-c2ee-ce13-8806-9d0184678984@redhat.com/
>
> Drop the trailing slash, otherwise directly clicking the link goes sideways.

I don't have any problem clicking this link, but I can try to omit the
trailing slash in the future.
