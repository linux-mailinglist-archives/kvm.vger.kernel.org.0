Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193144ACD13
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiBHBFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245701AbiBGX1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 18:27:32 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B09EC0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 15:27:32 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id e28so15712376pfj.5
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 15:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KVQbHmXJXEUUK9WaxnXa944qWSKejG3/VlU2/JcjjTQ=;
        b=oigxKzpVr6LQrOlqPqsrESAfYtNuXliH+BIwZnOzZdGHwV6JN4vZYwBvhFAyWakLet
         r6cH6XyH7MipymQrkM8nQOGqn5dPjcKj5FOsJIcZBCruwbtmmh7UCyMwe0iY8zVL92Rt
         ObpIND3a1D/zgCy4wnxvKwi31vmeVJO5ZqSj0lxWR/mS+eBBD9kL1fIx5JpSP8OgMpX0
         cpf09haXReN764dHKN+DzKluMsgogKinieHuIZAShW6wCvivRn4pkmTMiuYe05mQLeKv
         eGWDb2sJAxBw3olVoqAiX0WFiFcf0X+mRVe9qr8XdXisQeOwH4aPY9aYq9Mz6mfoTAQ7
         bh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KVQbHmXJXEUUK9WaxnXa944qWSKejG3/VlU2/JcjjTQ=;
        b=VbsJSxjMP6TbTHdJK5crDu2hxqE903/PcF/0ReDJggJOLGuDGwUcNTZmpWgEiZ/VKg
         tiZMYXCJvKZOoNVgRw2ArSXjtO1ObdybJmzC5lbBrd4pp3/D8IjtGUw+/7zd5DELCm0o
         6VUbdW0HifgwK5LmKTqNxrZx5V92u8n36RL9q4Zlz/AIDrL1VsYOOJq6QicqSCt9r4+x
         reBXVTGPbqOGZCs3R2lAIPLVs3VA5jVgeeS5jSR1YLXHI8W3PruIU0P/XGzbwJkxEsi3
         T2VlpfSJQA93GS6hTn1Ihe2QeM9XyK2iYgJ+69dw2q9zltQsUJ18cO9R1GWuJxqSmE7F
         ivSg==
X-Gm-Message-State: AOAM530uoTXwm06rySaFAt1MVRmNxmWW2kk+6Hd6uZvA3Ku2oBGKTonl
        sSvTxpfMxmydh3NKp9lW57pL9w==
X-Google-Smtp-Source: ABdhPJxldfR2n4p4M6GdeB1cOtw9U8ns9csEpIPbsw4cgGUQ5XO6H4W53T8JzXmu6uvhJD0dj8eBPA==
X-Received: by 2002:a63:ee01:: with SMTP id e1mr1365492pgi.508.1644276451628;
        Mon, 07 Feb 2022 15:27:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k9sm12415190pfi.134.2022.02.07.15.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 15:27:31 -0800 (PST)
Date:   Mon, 7 Feb 2022 23:27:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
Message-ID: <YgGq31edopd6RMts@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <YgGmgMMR0dBmjW86@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgGmgMMR0dBmjW86@google.com>
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

On Mon, Feb 07, 2022, David Matlack wrote:
> On Fri, Feb 04, 2022 at 06:56:55AM -0500, Paolo Bonzini wrote:
> > The TDP MMU has a performance regression compared to the legacy
> > MMU when CR0 changes often.  This was reported for the grsecurity
> > kernel, which uses CR0.WP to implement kernel W^X.  In that case,
> > each change to CR0.WP unloads the MMU and causes a lot of unnecessary
> > work.  When running nested, this can even cause the L1 to hardly
> > make progress, as the L0 hypervisor it is overwhelmed by the amount
> > of MMU work that is needed.
> > 
> > The root cause of the issue is that the "MMU role" in KVM is a mess
> > that mixes the CPU setup (CR0/CR4/EFER, SMM, guest mode, etc.)
> > and the shadow page table format.  Whenever something is different
> > between the MMU and the CPU, it is stored as an extra field in struct
> > kvm_mmu---and for extra bonus complication, sometimes the same thing
> > is stored in both the role and an extra field.
> > 
> > So, this is the "no functional change intended" part of the changes
> > required to fix the performance regression.  It separates neatly
> > the shadow page table format ("MMU role") from the guest page table
> > format ("CPU role"), and removes the duplicate fields.
> 
> What do you think about calling this the guest_role instead of cpu_role?
> There is a bit of a precedent for using "guest" instead of "cpu" already
> for this type of concept (e.g. guest_walker), and I find it more
> intuitive.

Haven't looked at the series yet, but I'd prefer not to use guest_role, it's
too similar to is_guest_mode() and kvm_mmu_role.guest_mode.  E.g. we'd end up with

  static union kvm_mmu_role kvm_calc_guest_role(struct kvm_vcpu *vcpu,
  					      const struct kvm_mmu_role_regs *regs)
  {
	union kvm_mmu_role role = {0};

	role.base.access = ACC_ALL;
	role.base.smm = is_smm(vcpu);
	role.base.guest_mode = is_guest_mode(vcpu);
	role.base.direct = !____is_cr0_pg(regs);

	...
  }

and possibly

	if (guest_role.guest_mode)
		...

which would be quite messy.  Maybe vcpu_role if cpu_role isn't intuitive?
