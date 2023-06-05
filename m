Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FC2722DD7
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjFERqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFERql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:46:41 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF16F1
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:46:40 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-78a3e1ed1deso257996241.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685987200; x=1688579200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLmydWHjLSbXU8tIcqSwN4g2fOd1z0gySQpKm7q+7yE=;
        b=blMiOClG9Py2mCB0eYhbQNQlNaJEUfyVnYFk5NBG6u4SazxSAucT99b2neLnU0FaDX
         7vE+lxRUVuGtc/lnAJEILSA84POKGbKmjXVQHHB3o60yKgJ+YLK5U7JddTblQ+qREJGx
         BpIDD2ceKosHjRebexq9qoWzZAKVX5bi5VcLM/53CCbm8FBuDM7DvYIm24wNlZZ9BiFW
         Z1OhALBYz5KfJ3z40sgfLUbNV1er50ccipDxFsfnTTWHJggvZe9UI77xITgg3RmVwwah
         HCA8mpFNYtF6QhcWhJ/3crf8/NRJrR/8jpnktgTUc2m0EOFNUP0nUwxwXQCQ1fjkg9pj
         l+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987200; x=1688579200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLmydWHjLSbXU8tIcqSwN4g2fOd1z0gySQpKm7q+7yE=;
        b=VphFYbWA08iVrLTmbXBxk2g4vYMELy1B3xW7tzo2RPdPGHHJVvVp+ibYRXqm4OUsMU
         GNnP5Ygwvt/XPPwbBOxsv6AoRQE/ihphccYZ0ggT21tZoPOW4Zn/P6T7NttVTn9yo/pj
         kk9iNqtrupc6jrPvChRdz8Yeh4wkFroGchAFNJ9S2iYwM9cXAfFM5eQFa9wcQ4Db9dR3
         /by9BPo1idRy1gLrxxH/FswRwOWGTnkstv2yH0TVu5+5OalOrqpc9IV23dsK+Hs50jIL
         940GuumliD0WJHU3WqMjNMKeeLgXinKEgdvvbmgIVYsHAuvPsrDtQbLEFbo+t/1iQeiI
         d5Pg==
X-Gm-Message-State: AC+VfDx7xxlaGG5o9ApS2SARykXCJhgrf4dS0oKaausIXW6LVbdm/y8P
        x9ZLLRsMbibyZyIxGo0dsbhWkdnvlP99B0yBp9THCw==
X-Google-Smtp-Source: ACHHUZ4Gv2+q+vynU6HEULCsA7sYdJuP/Sw+DQ5YTtegMnvWhx0lzh5D/f0UxCNMgD7DlI/ccPxmRquzz4Ysn+6H41o=
X-Received: by 2002:a1f:bf49:0:b0:462:ac61:27e7 with SMTP id
 p70-20020a1fbf49000000b00462ac6127e7mr2295162vkf.16.1685987199816; Mon, 05
 Jun 2023 10:46:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
In-Reply-To: <20230602161921.208564-4-amoorthy@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 5 Jun 2023 10:46:03 -0700
Message-ID: <CAF7b7moGyGqd-83xaJ0pLVSyWSRmPmKNZ_=6OzZAU4ytUPXYCw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

By the way, I'd like to solicit opinions on the checks that
kvm_populate_efault_info is performing: specifically the the
exit-reason-unset check

On Fri, Jun 2, 2023 at 9:19=E2=80=AFAM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> +                                    uint64_t gpa, uint64_t len, uint64_t=
 flags)
> +{
>  ...
> +       else if (WARN_ON_ONCE(vcpu->run->exit_reason !=3D KVM_EXIT_UNKNOW=
N))
> +               goto out;

What I intended this check to guard against was the first problematic
case (A) I called out in the cover letter

> The implementation strategy for KVM_CAP_MEMORY_FAULT_INFO has risks: for
> example, if there are any existing paths in KVM_RUN which cause a vCPU
> to (1) populate the kvm_run struct then (2) fail a vCPU guest memory
> access but ignore the failure and then (3) complete the exit to
> userspace set up in (1), then the contents of the kvm_run struct written
> in (1) will be corrupted.

What I wrote was actually incorrect, as you may see: if in (1) the
exit reason !=3D KVM_EXIT_UNKNOWN then the exit-reason-unset check will
prevent writing to the run struct. Now, if for some reason this flow
involved populating most of the run struct in (1) but only setting the
exit reason in (3) then we'd still have a problem: but it's not
feasible to anticipate everything after all :)

I also mentioned a different error case (B)

> Another example: if KVM_RUN fails a guest memory access for which the
> EFAULT is annotated but does not return the EFAULT to userspace, then
> later returns an *un*annotated EFAULT to userspace, then userspace will
> receive incorrect information.

When the second EFAULT is un-annotated the presence/absence of the
exit-reason-unset check is irrelevant: userspace will observe an
annotated EFAULT in place of an un-annotated one either way.

There's also a third interesting case (C) which I didn't mention: an
annotated EFAULT which is ignored/suppressed followed by one which is
propagated to userspace. Here the exit-reason-unset check will prevent
the second annotation from being written, so userspace sees an
annotation with bad contents, If we believe that case (A) is a weird
sequence of events that shouldn't be happening in the first place,
then case (C) seems more important to ensure correctness in. But I
don't know anything about how often (A) happens in KVM, which is why I
want others' opinions.

So, should we drop the exit-reason-unset check (and the accompanying
patch 4) and treat existing occurrences of case (A) as bugs, or should
we maintain the check at the cost of incorrect behavior in case (C)?
Or is there another option here entirely?

Sean, I remember you calling out that some of the emulated mmio code
follows the pattern in (A), but it's been a while and my memory is
fuzzy. What's your opinion here?
