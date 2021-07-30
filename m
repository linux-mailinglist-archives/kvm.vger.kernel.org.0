Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE63DBD02
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhG3QYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhG3QYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 12:24:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3033C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 09:24:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c16so11661098plh.7
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 09:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Dt7BPkqKJMerMDAUFj+9/P/yGyah1WPEScK3C0WzA4=;
        b=dB/7UCE7sp7q+bEm8dm5tdQNQGCMHmj7u+PrWEFahjhHDjJaNkqQkVeqD0H+Ls4llN
         C5sWP5NLwCkAZuvoYJCHubExu9LiCnALoCfusst8K06XqgFScxO7tlHOeFx+K1qS2MTw
         LMMfvx36FQU7t0ov0W6nl2B5AXFx3BcPlVItSW5YC4cWzaa/gl0XttSRyqP2oRaqjCAi
         zf8nLFILyqe51JcEL8GR42b/BAGQYqld4sO66AS6HhwyVENHdL8XW/C/H/xzlhMQcED5
         I43rIH/KK3LNK+yLFyD/40DB2bdvHosUf0Kwky1pBu3Chq+GSZxvyR9JeklPGv5evsDs
         eB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Dt7BPkqKJMerMDAUFj+9/P/yGyah1WPEScK3C0WzA4=;
        b=KFQhymQX1PBtanCT0i+txCeZntNGqrYEpvNUX9qaOF5wyCJrc+jiCGqtyFHwIolGH7
         MOK9ptuzfOb0LHVfjnub4T+4gsWn5wZNf55vSkgXIRzwaRm5enNuSTcb4bdGssHOuoJP
         nev8XN11cTdnsUjRdWBrG0t2WS+NJNnwfv9demqtY3WIKUfH4uLl+nLmbpfmJygGsCxY
         hf5VYCuHcj1aYpgZ70Setpoo14ImGT57drLZo8Q27oYsHq3wZyeKhiDz/skAlPVJEqaQ
         T16WSKNS70xKhK8ZCXet4ujOjwJ5EQsCutt2czJBI18HICk+XwciaCR/gp54uEARq0zf
         CHLw==
X-Gm-Message-State: AOAM531jOBPU5QjfLkitWNev06i/9u1S7xCZS8UT1Q4x315rXV6YVoP4
        GTFNdWUer2Ul/Ba85A9y2MNTpA==
X-Google-Smtp-Source: ABdhPJxTmfhIfPyjKz/UdLpI661R9AEt1hom4/brpTzb/gdG6WfcxlblSRvTcb3ctkd6UWtkgCV2vg==
X-Received: by 2002:a05:6a00:1508:b029:332:3aab:d842 with SMTP id q8-20020a056a001508b02903323aabd842mr3547511pfu.59.1627662245035;
        Fri, 30 Jul 2021 09:24:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i8sm3063415pfk.18.2021.07.30.09.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 09:24:04 -0700 (PDT)
Date:   Fri, 30 Jul 2021 16:24:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com
Subject: Re: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <YQQnoDq7d4KU4bAV@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-4-ricarkol@google.com>
 <YQLwP9T4hevAqa7w@google.com>
 <YQNRnbuucxcYJT2F@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQNRnbuucxcYJT2F@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021, Ricardo Koller wrote:
> On Thu, Jul 29, 2021 at 06:15:27PM +0000, Sean Christopherson wrote:
> > On Thu, Jun 10, 2021, Ricardo Koller wrote:
> > > +	struct ucall uc;
> > > +
> > > +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> > 
> > UCALL_UNHANDLED is a bit of an odd name.  Without the surrounding context, I would
> > have no idea that it's referring to an unhandled event, e.g. my gut reaction would
> > be that it means the ucall itself was unhandled. Maybe UCALL_UNHANDLED_EVENT?
> 
> I see. I can send a new patch (this was commited as 75275d7fbe) with a
> new name.

Eh, no need to post another patch.  If it can be fixed up in tree, great, if not,
no big deal.

> The only name I can think of that's more descriptive would be
> UCALL_UNHANDLED_EXCEPTION, but that's even longer.

Unfortunately, EXCEPTION is incorrect as x86 will route unexpected IRQs through
this as well.
