Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5DC576A89
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiGOXSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiGOXSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:18:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3176890D91
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:18:08 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z12-20020a17090a7b8c00b001ef84000b8bso12874753pjc.1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XbW4ugQp+4Ks3aPPXecdjoIRykNNddTdltbpwPKe1dg=;
        b=AqupWTdfkCcwL2MkYOsMqRrMSV/a7tM0rRAIbHGRtwELMYjOPNPvTxm9ck4bRZ1LJL
         C+GsN6QPyU9IZu0yfL5Hgm1h0+17s2LZYsOW91bZ6cFdcMh0EGwB9pERCkCjGIgHX/sA
         75BbexmZoonEtKYsSNhYrh0PfX2kPtAIYusu0mprQ9KgDHOH6ThMFDC7dh/Ta9g3cGv4
         apb0wR/PWrWT6FsSLLxOb7Cgiqk2/C7Kh/1JjLL8dtlUWesUmYgAYWlNbkKGoi0qk97N
         jNwyZJjwpHDaYJnzuklojThL047k0a1K2rL3VK54fbnn8WNi0fun1SE3rTUCQe5gRGNH
         7Eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XbW4ugQp+4Ks3aPPXecdjoIRykNNddTdltbpwPKe1dg=;
        b=5VAm7P5IL2O8x4OkimaoAvBwQ3IuttVsKTQwVmcVatjYlf0hj6tzgmPuCj4+Xz3ly7
         2XIJVdmG/QvC7ip1tH9Ri2rZkLHjCcf8QYeeDQYN3OyAZrbTWZ7jYBtORcj7b+FgSesV
         oyWAecmrkLtxYUA9EulhrDuebVntIes3/snwJM5+tlYjmqQwv4I2mp66BCb+hVZQU32v
         /lyHUx+OKMCWGqvN0tiglMpgXIIL5QKwh2fesahe8suHTcE6eqXTfiPCL27LzSnURHBa
         lP7ErctAYOIrqzeGc9dJqrqP+RgXFc+bc3JS/PSWu7WZuO8a8MLD8j0lcvOz03CTI8CE
         EjLg==
X-Gm-Message-State: AJIora+sHMewPjQnB6KNgPFNqdNyEAR6jTnq5V7pJUs89UxdKnPNzjdF
        V0z3YDyZ/6flqA0taKkBT6mlemAIJE0YQg==
X-Google-Smtp-Source: AGRyM1tgMaamoYyeQMvHcg5nmNj0M22GhP3i8TJXo4psF2lgAUpv4/BagImN3kbzKBXY+aA3OoWDJA==
X-Received: by 2002:a17:902:c64b:b0:16b:d51a:dc24 with SMTP id s11-20020a170902c64b00b0016bd51adc24mr15965401pls.48.1657927087608;
        Fri, 15 Jul 2022 16:18:07 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f13-20020a170902ce8d00b0016c1a1c1405sm4204066plg.222.2022.07.15.16.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 16:18:06 -0700 (PDT)
Date:   Fri, 15 Jul 2022 23:18:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: Reject loading KVM if host.PAT[0] != WB
Message-ID: <YtH1q3C4F+LAEDTf@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
 <20220715230016.3762909-2-seanjc@google.com>
 <CALMp9eQdzZK4ZAyQZXUWff_zuRRdr=ugkujWfFrt9dP8uFcs=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQdzZK4ZAyQZXUWff_zuRRdr=ugkujWfFrt9dP8uFcs=Q@mail.gmail.com>
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

On Fri, Jul 15, 2022, Jim Mattson wrote:
> On Fri, Jul 15, 2022 at 4:02 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Reject KVM if entry '0' in the host's IA32_PAT MSR is not programmed to
> > writeback (WB) memtype.  KVM subtly relies on IA32_PAT entry '0' to be
> > programmed to WB by leaving the PAT bits in shadow paging and NPT SPTEs
> > as '0'.  If something other than WB is in PAT[0], at _best_ guests will
> > suffer very poor performance, and at worst KVM will crash the system by
> > breaking cache-coherency expecations (e.g. using WC for guest memory).
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> What if someone changes the host's PAT to violate this rule *after*
> kvm is loaded?

Then KVM (and probably many other things in the kernel) is hosed.  The same argument
(that KVM isn't paranoid enough) can likely be made for a number of MSRs and critical
registers.
