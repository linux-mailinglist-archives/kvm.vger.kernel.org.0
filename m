Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B066851E141
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 23:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355009AbiEFVln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343973AbiEFVlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:41:40 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C686F4A9
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 14:37:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g8so7267875pfh.5
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 14:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wDlo/3xACgXAwIyvRAGw9rxCX/T/ZCg3pbeJ6EmzJxc=;
        b=i8zh5ZKxoyPeA0SqzdaWZX+Kwc1I9CU7yG9bWNwwo4a3uMEv2Zn6KklIdQWEkDQ4P1
         CSvi01zCHmGs5vC7lwaawX58+1jSKl7zOMZdrGYGg00etgdxmQmYzN5/idOOOrc+/8bz
         e+Sg7rFI6/yX8rdh17bXS1vz1LE2WxeSCpsmFzm+P0RhiovlJeqUcV/IHvEOJldbMQ5z
         PGcu+wEe6FfiJwsEdAVv/t3dMyo7Ql5I3kdbq1QNjWY/Mp5rSbdHK0+84l31rHwxKWkO
         M4Im2GZSj+eTKnJOnXbDXMByB0bRvD85+xHrigLH7KLkjxEfVDisVKBA11q8EMfo9jmn
         2Jgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wDlo/3xACgXAwIyvRAGw9rxCX/T/ZCg3pbeJ6EmzJxc=;
        b=IPCiEuDPMOAljvGyai63s/6J+HWdXFPK5TXv0hgj5qmzrPvPdjsG/ydhykzTCbtng9
         Mm4nLTmA/xaTAu/1b+/FtCZQflRlGWZvi+kUY7UPp6bR4qfFN2kr6bHKbOXDLiOg+r3T
         pxA3pR3tzuD8bRcwGWZlJBwIEaLqH2++o1Vp3tPCoH2BmWy16WNrCOeFsTIxEoCicMur
         OiKmY3DDafUrvnxlf8ByqL7Ld0YZvMTlOH3EvXDPwK4cVs534FqcFTZ5BSRw5IV/UHaN
         xQTcmUfYnoCuCBTrQAO2mOSN6S7Fm3cTROLpdnP/MV79hqS+CgUpCogE7YmlfSklt+4s
         CyPQ==
X-Gm-Message-State: AOAM533YtM72SqR4Mf0itVBqcrc+YLOse4NRoegZyfq6Tx02Cx0YLl6O
        f7CtEj01fll3UofNhIqyX3S8th2MXc0ehQ==
X-Google-Smtp-Source: ABdhPJzia9KVpHse2ThgWwuNRKDj+zzCOTlETRn+9WJ+6EE/ct9hPNk9Hyc/HM5tg3cAxabSilrlOQ==
X-Received: by 2002:a63:444f:0:b0:39d:3aa5:c9f0 with SMTP id t15-20020a63444f000000b0039d3aa5c9f0mr4349860pgk.363.1651873076058;
        Fri, 06 May 2022 14:37:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n21-20020a170903405500b0015e8d4eb1f9sm2189166pla.67.2022.05.06.14.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 14:37:55 -0700 (PDT)
Date:   Fri, 6 May 2022 21:37:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 003/128] KVM: selftests: Unconditionally compile KVM
 selftests with -Werror
Message-ID: <YnWVMJYdk6wDYcgj@google.com>
References: <20220504224914.1654036-1-seanjc@google.com>
 <20220504224914.1654036-4-seanjc@google.com>
 <875ymk137s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ymk137s.fsf@redhat.com>
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

On Thu, May 05, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Specify -Werror when compiling KVM's selftests, there's zero reason to
> > let warnings sneak into the selftests.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index af582d168621..c8efaaeb0885 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -153,7 +153,7 @@ LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/x86/include
> >  else
> >  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
> >  endif
> > -CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> > +CFLAGS += -Wall -Werror -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> >  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
> >  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> >  	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
> 
> "-Werror" in kvm-unit-tests is a constant source of pain as different
> GCC versions tend to produce different warnings. It's going to be even
> worse for selftests: e.g. bisecting an 'old' kernel on a system with
> somewhat 'newer' compiler and selftests don't even build.
> 
> Personally, I'd prefer "-Werror" to be an acceptance criteria for
> upstream patches (e.g. if something produces warnings on Paolo's
> setup -- the patch doesn't get accepted) but not the hardcoded default
> in Makefile.

I've no objection to dropping this patch.  I mostly added it to ensure that I
didn't sneak in a warning in any of the intermediate patches, and I can accomplish
that by feeding in -Werror via EXTRA_CFLAGS.
