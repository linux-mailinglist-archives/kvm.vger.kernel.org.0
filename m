Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E417C1C478B
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 22:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEDUB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 16:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726816AbgEDUB0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 16:01:26 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C029C061A0E
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 13:01:26 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w29so81951qtv.3
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 13:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WgubC2Z2oGM4A5Njnye3JH+tCzZ03fvavr65xjrogvc=;
        b=byoBOldMgeHecwxlmLT6bSoBGMqq5XVrcCE/QIXTwZ5Z1zmAMjCQD3wL11UJwDU2lw
         3qhTF9LVQf9dkkUIV71g+SWr/RfuCb3/XGvc1R2LfzdjtH8rYgfM96Bl6RBDPaHp990D
         asZVW5bGvKDz/BlUViwpGaZFOPO5opbcH/VTC+kmtaZ4brqdecmRCKURV3ah0oCE1dAN
         fjyfOVIkh+8VXtfajjydyGp1VIFazLovVGOyOoZjQQvq2kONRooMHTka6BjNApa+t5ok
         VrlY/HpHtrmnLajDts1PqoCvS2x0PvnP3mSjm4poXsTfXJOYDAkwEwO8amq/GCGdJehP
         go1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WgubC2Z2oGM4A5Njnye3JH+tCzZ03fvavr65xjrogvc=;
        b=WRYc3cWsEQYDyQOcebQkVXZzeYqiJOhttEVp0gnAo0w4MBkQu48ZEP1ZyNIf63rsi1
         m5qJIvsvmh+UKZMlCTA4bRfhJKPPUVjh5vmGSZZgrEBoF+0T2WBjbfmIwAnesEjGcluK
         Kj9OTHYKXB8tPMJp2iQc/G4AwXGfCyBp8H0Tcqw7au+JWl59sJwx9nVNtyosRvE3hwou
         zAw0DYGkwt1L9P4LM1+pte3hNsDprwOBjCmSYKrGNZoad6b6uqDObWvqL/dEebC+deXM
         bDvzvFe0tun8VO29SuA1s8Y5Et2ctKJntC7RmHoPEfp9xqekuJJCnnjwvM6qCrMA5Vqv
         6a0g==
X-Gm-Message-State: AGi0Pua81D3QzkzVuedwN4pDA8wOJU2m7jMtDJjyCj4ZxrzPJwTeUtko
        Tq2zBW6H0AahYl31JGWy2FfPIJPwQ+4=
X-Google-Smtp-Source: APiQypIe6YV0BMjlELv09gZGrZM8PJzohFM36QsELGEVtRnQfj46T79bUlNCRqUae9T4ajx7WUuKQw==
X-Received: by 2002:ac8:24b7:: with SMTP id s52mr827620qts.316.1588622485189;
        Mon, 04 May 2020 13:01:25 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d4sm11335892qtw.25.2020.05.04.13.01.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 13:01:24 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVhHH-0003EA-Q2; Mon, 04 May 2020 17:01:23 -0300
Date:   Mon, 4 May 2020 17:01:23 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
Message-ID: <20200504200123.GA26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836917028.8433.13715345616117345453.stgit@gimli.home>
 <20200501234849.GQ26002@ziepe.ca>
 <20200504122643.52267e44@x1.home>
 <20200504184436.GZ26002@ziepe.ca>
 <20200504133552.3d00c77d@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504133552.3d00c77d@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 01:35:52PM -0600, Alex Williamson wrote:

> Ok, this all makes a lot more sense with memory_lock still in the
> picture.  And it looks like you're not insisting on the wait_event, we
> can block on memory_lock so long as we don't have an ordering issue.
> I'll see what I can do.  Thanks,

Right, you can block on the rwsem if it is ordered properly vs
mmap_sem.

Jason
