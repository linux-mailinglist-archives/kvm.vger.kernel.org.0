Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E5227F6D1
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 02:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbgJAAmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 20:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731339AbgJAAmX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 20:42:23 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601512942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1dZAHWtiKSMf8mYBi0q5UFXISwoH04KbR1oFeQ0MPNQ=;
        b=P2vZSEdwV0+DCsqwpeMnsKgnO0B2BK7jSd7MxDNZDFkN7pYYtNyXvmQZgkyDOGNPxVsPp8
        DC5W19PzR29mEbNvFnNcsqN+qLRzull3BeyOEWfgYjNdZvYTQbx3SjQq/4K1WaZvVyrXOU
        0IhSDTXobFevQjHcXey/LXiWs7E6/Ac=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-QX91XpIaOH22LGKwJB44Wg-1; Wed, 30 Sep 2020 20:42:18 -0400
X-MC-Unique: QX91XpIaOH22LGKwJB44Wg-1
Received: by mail-qt1-f198.google.com with SMTP id 7so2438300qtp.18
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 17:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1dZAHWtiKSMf8mYBi0q5UFXISwoH04KbR1oFeQ0MPNQ=;
        b=g11s5zawbV/Nt7WrPO8hdJkrdURh+zFjXkz+81bLNo11fmMGw/FnKJbYSkI3f6A2Ni
         wdK2/G4w5DuVkqry0RJCQcXT3yNH30QN4W/5e8NhCNi7Nq0AEuPlK8AJt0io0vQ36qua
         HFjtaKW0oN/fR/azbohoXhDkW9MxXBNfAtUX8sS/voVuzI5lidK2M9oo8W32Umxg+NDb
         tOK/VI+NYFqHmEuqGYDxoKgxYSpzMHI6+rW6tO1v68AFiogjL2DmiDJwZMb40sZh4n6A
         yAxiRMV3DI7tpvaXQhte75rePiEB1vkLLQy0gf2PRnTh5A2Xs/Y3CgcoK1ILoglkKre8
         mi8g==
X-Gm-Message-State: AOAM530iPWY+30vA2HhMtLxCzVQgT2grxhQ9TUqGlYw/Vzn5h1V01n2R
        9oyZWM1rUNQT7kbWxATkMLXXyBSpJtMpAS/HPn+5rZvBS59gmMufSHqz06h618FEiKQd4zEpYe+
        RxS6IN2n6HWyL
X-Received: by 2002:a05:620a:b18:: with SMTP id t24mr5452563qkg.401.1601512937986;
        Wed, 30 Sep 2020 17:42:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIDSvnLGUwNL+2BLIEvn9OGWviDasq6qOhSb244j0gvhx6q/5RSZ+zbvBvAe8dG2VfZreS1Q==
X-Received: by 2002:a05:620a:b18:: with SMTP id t24mr5452548qkg.401.1601512937723;
        Wed, 30 Sep 2020 17:42:17 -0700 (PDT)
Received: from xz-x1 (toroon474qw-lp130-09-184-147-14-204.dsl.bell.ca. [184.147.14.204])
        by smtp.gmail.com with ESMTPSA id y46sm4602375qtc.30.2020.09.30.17.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 17:42:17 -0700 (PDT)
Date:   Wed, 30 Sep 2020 20:42:18 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v12 00/13] KVM: Dirty ring interface
Message-ID: <20201001004218.GA6063@xz-x1>
References: <20200930214948.47225-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200930214948.47225-1-peterx@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 05:49:35PM -0400, Peter Xu wrote:
> - rebase

I made the same mistake again on rebasing to 5.9-rc7 rather than kvm/queue.
Doing it again.  Sorry for the noise.

-- 
Peter Xu

