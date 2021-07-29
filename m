Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F373DA7E8
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 17:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238050AbhG2Pxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 11:53:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237817AbhG2Pxg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 11:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627574013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WIqDiJp6VaSn9dpR1kfsnItFG7gaXoSJekhGozotnW4=;
        b=KzdrR9cbOAEOJeou885JD8F3L9guYcg26WZLANqI8cIobcbIlN8vh/5INKqJqUnwrnp61H
        53ecLxuUbrscCbsgzYhsoPyxqciYwtOHi/cPDqVJH2HF3kvKqV8qhGWI0GP6awGhqvRPtI
        AdNQpyw4v32Tbf5prERzAkDMzPyKRPc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-18WL2xw7Ouqia2BdGS1O0Q-1; Thu, 29 Jul 2021 11:53:29 -0400
X-MC-Unique: 18WL2xw7Ouqia2BdGS1O0Q-1
Received: by mail-qt1-f198.google.com with SMTP id w19-20020ac87e930000b029025a2609eb04so2899528qtj.17
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 08:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WIqDiJp6VaSn9dpR1kfsnItFG7gaXoSJekhGozotnW4=;
        b=CGUeVt9qUa2kEijFqkLkQY6f5pgHGUMEY9pTG1Y29U0FBI8Hh6Gb/9UkEhwZi3Cool
         983ajYEkgdpFtoOu3Pg/mqB7mMT9On8QgN056i/JROSuE0XdDSWXMWbepMClpqMcc/yE
         4FlodSSpNQwa6KeZaLIMUWBmpd/i0jqe0B8vjgD2ZZpyAAWCIbjVSoq5MCIeUCgPaBXI
         I1vapZ0lzNkKAO3lzz1A5cRNvmquRxXpXWCNzX6ihi+GPdkQVD0m9BKvZAJcg3b40uKp
         Dt6YA38SUF9XP7bbFYgCObcuWuhzYBPlP2vHv72lu5i+afVYbe+ZBwGZjGx7m19F3z6L
         JC8w==
X-Gm-Message-State: AOAM533akgawIZ4j5qU3YKeWhGFEQ5uAQ5b0z6vP+GDeEGbza5cGN02J
        HDt9R+HUYxded7chNgx9kWXi5cUysLCVJkcVtYU1XHraTFc15y4gdMIjXDm2oi/zIipP3d5/GTg
        0NKmYrJkx1LkY
X-Received: by 2002:a37:46d1:: with SMTP id t200mr6017851qka.491.1627574008556;
        Thu, 29 Jul 2021 08:53:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx20AvvmwA3zsdeUzhxGgr6AKaj+/c2//3SiKDGKEF0n2dtIKt7qPdZIpPiTl4sSwosnRnUXg==
X-Received: by 2002:a37:46d1:: with SMTP id t200mr6017833qka.491.1627574008362;
        Thu, 29 Jul 2021 08:53:28 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id u186sm1990880qkb.11.2021.07.29.08.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:53:27 -0700 (PDT)
Date:   Thu, 29 Jul 2021 11:53:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 8/9] KVM: X86: Optimize pte_list_desc with per-array
 counter
Message-ID: <YQLO9upwcrBTIiqx@t490s>
References: <20210625153214.43106-1-peterx@redhat.com>
 <20210625153415.43620-1-peterx@redhat.com>
 <YQHGXhOc5gO9aYsL@google.com>
 <YQHRV/uEZ4LqPVNI@t490s>
 <dc9eb6da-59ce-2dd3-c39c-8348088cadcb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc9eb6da-59ce-2dd3-c39c-8348088cadcb@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 11:33:32AM +0200, Paolo Bonzini wrote:
> On 28/07/21 23:51, Peter Xu wrote:
> > Reasonable.  Not sure whether this would change the numbers a bit in the commit
> > message; it can be slightly better but also possible to be non-observable.
> > Paolo, let me know if you want me to repost/retest with the change (along with
> > keeping the comment in the other patch).
> 
> Yes, feel free please start from the patches in kvm/queue (there were some
> conflicts, so it will save you the rebasing work) and send v3 according to
> Sean's callbacks.

Will do.  Thanks,

-- 
Peter Xu

