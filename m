Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535C75FF3C
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 03:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfGEBBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 21:01:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35780 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfGEBBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 21:01:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so373089wmg.0;
        Thu, 04 Jul 2019 18:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7LtxNi+8FnUawhqN2BoV1q5YaICdoGGasmOZOaJ0jpE=;
        b=VeKZrTQrAtr/R1e7E9LGHYxk3RCLvMhvqcvDtNJlR0UQ1jiZRVu3BYYYvOuikODeAt
         oJbi0tffyHcjqoJDlt4pLnVsyifrX3HzDUywgBI2/dMCFysidTg0QnoJm748YhM4zEll
         1DbYw0HbwU0mXCk+kEr04e+wb/DXI1ZLJ5hXZPLz3XLn/v+4UlhKNor2c+e5Wd58cgro
         c5APCo3nFgKpcJE+sctXBKKDqhkBdqZL/mWnjzsA7mLv92gWaIXv3Z3mZCrp58KTWT8z
         dQWiO6W2dUfNuhRf4DEHO4pxKmR1iOw7BilOi39hGXWpaJwtnyuR0WdQ0orH12G1RwIR
         0yIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7LtxNi+8FnUawhqN2BoV1q5YaICdoGGasmOZOaJ0jpE=;
        b=IKVNuvB6MaeHWsGpVSX5m6E6HYrx0tDX4bwXmE0hr98AY0dVka7axk/M2tCWMIb3SU
         +ENQHMyQB686D05+43bdH/VFhhjeC9QuqGylxYdBec4TM0CpE7IEMIonmGVXQgWzeJb+
         MIJ60pJU1IJo8sGDyzWmSMr2a/Wp08yrUtyZx9OahWtnbWgiC4LfQJQ3JRqgQfqit2aL
         wohHpYp1IVG0zswRbtv9/5qlMFzHEJs9lXLBeKFAhOI7o/O5gLtQQhGAAgl17ccCJhHH
         6nNHE4HZ1qGclCWCrpMPITnF21mW5gppc6q1rLe5AUz0NVpznhISfzhslRrW4jPnzAQ4
         l+4w==
X-Gm-Message-State: APjAAAUyp2bEuU0a2cZa96vxqUGiQJOCclTGaNyiP8hfpjO199Edk6SZ
        WgO3Bca81T1hwG7rWpykRX41p9pIv2ffTILb+6E=
X-Google-Smtp-Source: APXvYqxWUjNasMFkYsHLRnokZmHKfBKm6i6kh0NDnLi0Is28JRpT9qpTTdXPSyq5fGjKQ274A9qXUq4X2NmZZRvAs6U=
X-Received: by 2002:a05:600c:204c:: with SMTP id p12mr421726wmg.121.1562288469490;
 Thu, 04 Jul 2019 18:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190530112811.3066-1-pbonzini@redhat.com> <20190530112811.3066-2-pbonzini@redhat.com>
 <CACVXFVP-B7uKUGn75rZdu0e4QxUOsSqv8FL0vY2ubmuucvxqjQ@mail.gmail.com> <bd7fa062-6c71-13a2-5bbf-0dea859ae75f@redhat.com>
In-Reply-To: <bd7fa062-6c71-13a2-5bbf-0dea859ae75f@redhat.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Fri, 5 Jul 2019 09:00:58 +0800
Message-ID: <CACVXFVNuFLMOmX_KuvQG-+-zasAxcbrL+sbXEGaKa8C1K3mxKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM General <kvm@vger.kernel.org>, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 4:16 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/05/19 05:27, Ming Lei wrote:
> > It should be fine to implement scsi_commit_rqs() as:
> >
> >  if (shost->hostt->commit_rqs)
> >        shost->hostt->commit_rqs(shost, hctx->queue_num);
> >
> > then scsi_mq_ops_no_commit can be saved.
> >
> > Because .commit_rqs() is only called when BLK_STS_*_RESOURCE is
> > returned from scsi_queue_rq(), at that time shost->hostt->commit_rqs should
> > have been hit from cache given .queuecommand is called via
> > host->hostt->queuecommand.
>
> This is not about d-cache, it's about preserving the heuristics that
> blk-mq applies depending on whether commit_rqs is there or not.

Fair enough, at least difference would be made by the check in
blk_mq_make_request() if scsi_commit_rqs is provided unconditionally,
so looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming Lei
