Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CDD623466
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKIUSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiKIUSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:18:36 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C92210FCA
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:18:35 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id 4so18190678pli.0
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cI3lUlhNIUjbfjuHUsmnI8mgnTlKOQ5ksWoB1aZ25PM=;
        b=I/sKcQmUEyb0tEKrHj8+eSvdMgVOjUSOJzzCTBgX0yoWL/41RrqP2bA4vnPAcXbX+c
         rY5bH8T4DwWdyZ8UlWy1UOf8IVecObSOi1lx1LKLYDZD0YLUO2Ezy3UR4A0LHwjtu1nV
         hvWM/FC8AMHcAn+T2+UCaATt9nzBb+vIFzSV0j5cYFWM905zx2JDjUi0BEZWR77ZFOvc
         Zz8S829QSFppQN1P9UJ33W5UeAQD7Ignw8ef64F3S8DfP5h1yl/DV2bF+CUCYjR63A9Q
         iQpKHRbUVDnkYlJS9LQySmFQWvskk7GbgTlrI51ljwDIyeZFE/8bq9N4IVWiJyRFXRvP
         hHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cI3lUlhNIUjbfjuHUsmnI8mgnTlKOQ5ksWoB1aZ25PM=;
        b=bPcESEbSflpn2aLGbNA2vKiPg7iTJtpw4j92mt8stAhiDFyr6YO0U6+4jjLDIC2tbB
         JCTeDDek1Xy6/IMk3UxR2F7RFiDi+BcdxFiAWz/MPHYKHiZBTqkaSPI4BSw7bu7nhq/P
         e+lLg4K8iq9MHuUEyt4d9s5AGhbtt3CDEm2aX0zxPAD1Pdlw3U0sBT4edsq+tMmG5lcI
         QTYXpRZ2Nx9dqs5Gl3MaQTDEzoDfpvGixTS7CTPHxOJwGJYVciGOoCBgtexMkRmuKUS+
         98KGW7fCtG2R3Lu8/jj5BmGEchmqSmfxMFBWcZsUl6HLjfdjLuKSHYL3jFi+tV77Mfoi
         av8A==
X-Gm-Message-State: ACrzQf3AcgqO3UHva6nIvtnBN7sTb5dzS9ZTUubg3ClmpAq8TEWgYi5d
        6qEeOTnpaH123QRrZCzMnP1vxA==
X-Google-Smtp-Source: AMsMyM5/JJAytHYqYPrgQlMiY0Tf1CQA9n0tiCdPhmj3Tbrh9L04om7B+5j4lSj5vG+P9Qxn3cN1wA==
X-Received: by 2002:a17:90a:ab8e:b0:213:ef84:3bb9 with SMTP id n14-20020a17090aab8e00b00213ef843bb9mr53223205pjq.241.1668025115017;
        Wed, 09 Nov 2022 12:18:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090b070700b002137030f652sm1649564pjz.12.2022.11.09.12.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 12:18:34 -0800 (PST)
Date:   Wed, 9 Nov 2022 20:18:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: selftests: Make Hyper-V guest OS ID common
Message-ID: <Y2wLF+YcYX3cKhFe@google.com>
References: <20221105045704.2315186-1-vipinsh@google.com>
 <20221105045704.2315186-5-vipinsh@google.com>
 <874jv8p7c5.fsf@ovpn-194-83.brq.redhat.com>
 <CAHVum0eYbQJvXY_TVyjadAYVrAcwXSEyJhpddkcBSohj+i+LqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0eYbQJvXY_TVyjadAYVrAcwXSEyJhpddkcBSohj+i+LqA@mail.gmail.com>
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

On Wed, Nov 09, 2022, Vipin Sharma wrote:
> On Wed, Nov 9, 2022 at 5:48 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Vipin Sharma <vipinsh@google.com> writes:
> >
> > > Make guest OS ID calculation common to all hyperv tests and similar to
> > > hv_generate_guest_id().
> >
> > A similar (but without hv_linux_guest_id()) patch is present in my
> > Hyper-V TLB flush update:
> >
> > https://lore.kernel.org/kvm/20221101145426.251680-32-vkuznets@redhat.com/
> >
> 
> After getting feedback from David, I decided to remove
> LINUX_VERSION_CODE in v2. Our patches are functionally identical now.
> 
> @Sean, Paolo, Vitaly
> Should I be rebasing my v2 on top of TLB flush patch series and remove
> patch 4 and 5 from my series? I am not sure how these situations are
> handled.

In this case, unless Paolo is NOT planning on merging Vitaly's series for 6.2, I
would just wait for Vitaly's series to get pushed to kvm/queue.  I'm banking on
Paolo going on a queueing spree soon ;-)
