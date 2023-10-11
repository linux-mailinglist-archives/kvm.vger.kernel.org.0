Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D127C6020
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 00:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjJKWEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 18:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbjJKWEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 18:04:40 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D422A9E
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 15:04:38 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6c7c2c428c1so733645a34.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 15:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697061878; x=1697666678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjjnXqI9pbqoQJZ2xQAPRouGUG/LzE7OccZFWoVEwes=;
        b=QPCTut9iZjXxh21AVtrfd39txHsTkiQItQ26kSVPQF+EbI0KyK7jmO7KuP78J+zwV8
         md5TVTjdThFWNcA3FPSBSpjawZrZomntPZP6/oX20gDtJCV59RxbCtBfdJo194j4HDkV
         5pYFxKgdXpa/V6+L3JihzFh09Ack61Hw1e4c9TP8sPMNhY4K01ZS6I2KSPb3P+5BkhX2
         skL1t3x4YyRZ6o2NB1imKylt4duhmWl+66g2nRugSy7zh4sSjdKzGAi4GBgWCkIuJXJ2
         e616y+UxiJ15D/7cue2SzlREpY+mDwVMVhMcMHcblaUqd5jCDiEr4HLwRX1/ExH/7Bz9
         3bbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697061878; x=1697666678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjjnXqI9pbqoQJZ2xQAPRouGUG/LzE7OccZFWoVEwes=;
        b=n/LAbL0lzt5YDh4UIeuGVZeK3SH4TIfBoi8W9xsaPMIq7aKvWBwBlqLX5GyeOqA+Gp
         Dlpb9gyQj8eSh2zvZfn9xO/HlP83nwyXjflLnEnJaCVcGRTEL14PleN0XTUuMnyzVnE+
         ocph6E93Opbalshf/Zx0RBzqIDTAEfmC2Vyfs9iAFJe6+dJXkLLgcP0UYvkrt4uskuY3
         hvYVmC7XI03TTwoaZI1nC4ws9zY5GrRWabUbl80zl9CA477fko5s/qENri8P3yW1WmqH
         AqAO5dfRCHTbrpev+kgpI97tggHpTOypmCwolytSid0ciiO5+snZkH22pIIgPcNtaHyI
         coPg==
X-Gm-Message-State: AOJu0Yw1ngcOUx1jjC8YSv/c2470GO0lHLxCNR2mSISuaQA69GIjaUTZ
        3LyEIH2Z7IyZjXihIS7XXV/KaTNhJli2qY0pn1znug==
X-Google-Smtp-Source: AGHT+IG0se0BKjzQv599bsjggnp+VNDb3eO/7HsXNoOFWxmAUDb5hh1HcVYt8wlFdNMonYsDKX0aC5GQRpMR/Jr64JM=
X-Received: by 2002:a05:6808:1b10:b0:3ae:60f:117a with SMTP id
 bx16-20020a0568081b1000b003ae060f117amr11511266oib.3.1697061878139; Wed, 11
 Oct 2023 15:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mqUkP1jDf_TF_DpGcAKqn+nYx4ZPasW00qT4nOr-76e_Q@mail.gmail.com>
 <ZR9SLOQcFEqPg01A@google.com>
In-Reply-To: <ZR9SLOQcFEqPg01A@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Wed, 11 Oct 2023 15:04:02 -0700
Message-ID: <CAF7b7moMG1=CcUSjjkXw=Bcf_ws43ft4omQmY6rDS_6Vr1hPnA@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 5, 2023 at 5:17=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> > Sorry, what exactly are you suggesting via "bite the bullet" here?
>
> Add another boolean, the "bool can_do_userfault" from the diff that got s=
nipped.

Whoops, somehow mistook that for my patch being quoted back to me :/
