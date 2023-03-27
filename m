Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2206CA8E4
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 17:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjC0P2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 11:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjC0P2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 11:28:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61210F5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:28:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5425c04765dso91084597b3.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 08:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679930897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f8JBRCY78ZSzuGLljBnUO/BHHKr3CYdvg+wmNXBil8g=;
        b=dqcHIJaGv5oQNTDf+jYjjPGGrIVf7GBwZMp7QKzoL40Ol9sdvVPKCNKWbbq9GE7KJw
         fTe0CyY9fv3KCh7uuvmqRddtg/Qdj1MvgfH3ZyNEhKzEzNOSYGKNPt782BB/RfXJWV0h
         YJXLib9kYrO/dThgwZ0DbEiBsrdteZ4adqj21utoOgQJb7NLVZKoUJW0adZJi/N4hmia
         erYe9zOl2i+p43YBOvbYEVtB4ZqgZkM/KEWnBpoH4GL6Yht+9fXQr+hIalSF/naVn7/t
         8Zo/gVSY6HGrlNNil6YicEPptQqFj0G/BaNEChxrR62BvW2eXaTWH4xtjoB4udj0inYZ
         TO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679930897;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f8JBRCY78ZSzuGLljBnUO/BHHKr3CYdvg+wmNXBil8g=;
        b=hG7G2O50uRetHfJPy1FRP+IyEKhPpzzGXEP1AYZPj2o34UwXOAR9q6o1KsgjHtKEaD
         BNsmZriDkSCrmrmroLhC6ylynk6nRolgseXb327mWbO9u8f3CuOiKEqfGUgLkAdQ3Nha
         x2PV2oDx2MrEUgOoj0GK7yNfOyK0xO7u7vtbgGm4+ss38gdQ57nXYW8Utr0Xl180mlgA
         4mN/GMnKkyd8L5ZSldlCD51AneUBj7VMXj9eydlTEg2IwJJVzx75inATLjiYYi7Wt43K
         8o+omQOQa0G6or82/Sz5+KleKIE34XHTIMIf6G809EUYcBgQv1lSbUAiIFA6QAtkd8Lt
         IrOw==
X-Gm-Message-State: AAQBX9cyar6biJeOn/i0yGpYlO2tb8qO6SCYsV6W5AHf88MjIInrQ96K
        tcaf7/MVHAYykkOwCXz1ClfbSnAzN9E=
X-Google-Smtp-Source: AKy350b83eGk6L6ND7l/neGCC3/wJiQDCcFmipF8r8V3OiF/SEkhLqe+P7zSzlOtyKX9choru9pVg685uOI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:eb02:0:b0:545:883a:544d with SMTP id
 n2-20020a81eb02000000b00545883a544dmr5743906ywm.9.1679930897136; Mon, 27 Mar
 2023 08:28:17 -0700 (PDT)
Date:   Mon, 27 Mar 2023 08:28:15 -0700
In-Reply-To: <151c3b04-31db-6a50-23af-c6886098c85c@redhat.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com> <151c3b04-31db-6a50-23af-c6886098c85c@redhat.com>
Message-ID: <ZCG2D1PyWobdb8jk@google.com>
Subject: Re: [PATCH 0/6] KVM: x86: Unhost the *_CMD MSR mess
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023, Paolo Bonzini wrote:
> On 3/22/23 02:14, Sean Christopherson wrote:
> > Revert the FLUSH_L1D enabling, which has multiple fatal bugs, clean up
> > the existing PRED_CMD handling, and reintroduce FLUSH_L1D virtualization
> > without inheriting the mistakes made by PRED_CMD.
> > 
> > The last patch hardens SVM against one of the bugs introduced in the
> > FLUSH_L1D enabling.
> > 
> > I'll post KUT patches tomorrow.  I have the tests written (and they found
> > bugs in my code, :shocked-pikachu:), just need to write the changelogs.
> > Wanted to get this out sooner than later as I'm guessing I'm not the only
> > one whose VMs won't boot on Intel CPUs...
> 
> Hi Sean,
> 
> did you post them?

No, I'll get that done today (I pinky swear this time).
