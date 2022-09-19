Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F85BD256
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiISQiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 12:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiISQiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 12:38:19 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA34356E0
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 09:38:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c198so91214pfc.13
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=gY/UR9x/qOV2lGsC3f/dNydQCP5zey4ni1VZmLdB2sU=;
        b=a17YlCo4W0uVFQSimQafEREjJhNlH9kb+63RuRVf41i/AZXMoemz0mLoN4QX70s9Zb
         ecKTBbTuvHERgtsHhbu4v3d7zulBtVAgkpW0VjyVXu5vWjVdZiwUKabiw2PCY21H3CRO
         fdfwxUtktAx+2vdVrN9qkuSAf5OToVZuI/OfchZ1vU+49bSFecdnd+EfkeAO09TfxFIQ
         e8NEOC0RVt4jAgXhR+yEkQsEyhwqI1DdKW6+R3g92S5Yo+0NWD0ecwZfPBrc0sjqM/OH
         2tlB9ya9/TBvQ8vkQ9VqdF/+ae+A9RP+30x73i2xWxGnsTAaNFnmAb0MnHgeqLZUAiLF
         V0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=gY/UR9x/qOV2lGsC3f/dNydQCP5zey4ni1VZmLdB2sU=;
        b=oB4py7M46tKShxJcZcr5b7nlSZZsK/HCgB8jcc5U6Zz/IfaeGMUAEDUTw7/tLmJ803
         F9jA0tbUarDCYVdjP8FZneW1rYYurSvhEcoXj0vGfe7ny66fPpQJ0rdrtjOdvqbeB7u1
         wXy2izSIxwdDAWbc4K+fByAoHX5TOHvY23kfiSxZdJMB/i2g0qP9dNqwFrhYil4RS3Xb
         VUYh6sTHqHYH/oybyLc93/rvcmBmNJCrGX9ve5TQJw9yQPwK/9xP8B6gM6Q7QFQdGF4o
         6ckQIzGIqJ+S6hqCkajPh4ZU3nt3UG856N3TN/7Ug+fos16dqZbXLI76o2n0e/y2mne1
         xaOQ==
X-Gm-Message-State: ACrzQf2lwOnA26RY6PsKQ1wEMLW1+X22322PnJftpV1ABOdv5AlV+znk
        yNF7zJj51t3FFNK4NbMZ4mFvWw==
X-Google-Smtp-Source: AMsMyM4riMa7m9Kmjyb6lV4lCPhU+JvUDmpzSnBTRy+EoC39ozFv24uP/la1fuH1jYm+AHcO9h7PRA==
X-Received: by 2002:a05:6a00:b41:b0:52f:59dc:75 with SMTP id p1-20020a056a000b4100b0052f59dc0075mr19642038pfo.33.1663605498289;
        Mon, 19 Sep 2022 09:38:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id az8-20020a056a02004800b0043a20e50c1bsm2388227pgb.84.2022.09.19.09.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 09:38:17 -0700 (PDT)
Date:   Mon, 19 Sep 2022 16:38:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, rananta@google.com, dmatlack@google.com,
        bgardon@google.com, reijiw@google.com, axelrasmussen@google.com,
        oupton@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Yyia9uqpaIm4JyH+@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
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

On Mon, Sep 19, 2022, Marc Zyngier wrote:
> On Tue, 6 Sep 2022 18:09:17 +0000, Ricardo Koller wrote:
> > This series adds a new aarch64 selftest for testing stage 2 fault handling for
> > various combinations of guest accesses (e.g., write, S1PTW), backing sources
> > (e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
> > on a readonly memslot). Each test tries a different combination and then checks
> > that the access results in the right behavior (e.g., uffd faults with the right
> > address and write/read flag). Some interesting combinations are:
> > 
> > [...]
> 
> Given how long this has been around, I've picked this series up, applying
> Oliver's fixes in the process.

Any chance this can be undone?  A big reason why this is at v6 is because of the
common API changes, and due to KVM Forum I've effectively had three working days
since this was posted, and others have probably had even less, i.e. lack of reviews
on v6 isn't because no one cares.

It's not the end of the world if we have to fix things up on top, but we'd avoid
a decent amount of churn if we can instead unwind and do a v7.
