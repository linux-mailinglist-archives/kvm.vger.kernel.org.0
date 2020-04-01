Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3415019B5CB
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 20:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbgDASlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 14:41:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728427AbgDASlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 14:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585766465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pzTGLslFpdHXx/n6KMH3BGb7tsrM58pPmhp9HcVvhO8=;
        b=V3CmirXdWYh+cAhn1BJCb24bHJW1IUH6iMbwQBbw+gXQ94Zkzh3FluQU+8o3g3+GzaasHQ
        3P7V126pd+nr2uDLNjaL9yhz10nkzCw7JaEGKPbPtOYmW6iuS0m2HQMAX9q6QVs3P7PZd9
        qfkLHrlkuOqh33HPH3mg/ZEdo2Qm04Y=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-ckxxbrw9M1-un1I7cYc79w-1; Wed, 01 Apr 2020 14:41:03 -0400
X-MC-Unique: ckxxbrw9M1-un1I7cYc79w-1
Received: by mail-qt1-f200.google.com with SMTP id x10so699607qts.14
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 11:41:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pzTGLslFpdHXx/n6KMH3BGb7tsrM58pPmhp9HcVvhO8=;
        b=miF5+zYPPfRFzrVqVKyjLIBBrji/I+OY7prkSJYPpfAjCtWkSvxksbHO6FjtRpMVgK
         XWrFy+ixCRaxZrOm+XXA488I6MsY534hJRN707ccUeNlaQi7UsL71o9Zh1zBeWawn0mh
         FRIu4kLD2buL/CypckOe97pVLuTeolkVVo6mtf3EtGJm9KE4GxiERrAg3RmI60lAYcDQ
         cW1ApQeIwzjZCWDfPnbuS/57u0M7osQtzgELDOEViO8mk5/A1sOsEV4zqDM5sfTcHpbz
         /fFFdXo5OB8m04QxO4RttDZpoM3SPURwFQ+iy6va1//ItbP1yqzHUthDnzU6nlyaNJm8
         q7Sg==
X-Gm-Message-State: AGi0PuY/sRGn/KNvai+4SVRkHuhsRrv6Ckjmf/TI4qqwqqLtrYCGlb3/
        c2gscUbiBvUOUl8yE9AQuFRSZR9DKI27SVCVANxXySa/VZu+lMwbud3AIgAiWKV9ciga+c1ZDYt
        ybXik4PscsamnppeOnb/uTZ8lWIUL
X-Received: by 2002:a37:648:: with SMTP id 69mr3518432qkg.353.1585766461847;
        Wed, 01 Apr 2020 11:41:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypIMc9bCIQd9ksmq77FTW3moC9s27DVolZ+N3n7aLO1hGL4TxDrRq+ThIzKWs+QVbAwQifLBL0Ju6m1/bPHQJ3o=
X-Received: by 2002:a37:648:: with SMTP id 69mr3518405qkg.353.1585766461586;
 Wed, 01 Apr 2020 11:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200331192804.6019-1-eperezma@redhat.com> <c4d2b0b4-0b6d-cd74-0eb5-e7fdfe063d42@de.ibm.com>
In-Reply-To: <c4d2b0b4-0b6d-cd74-0eb5-e7fdfe063d42@de.ibm.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Apr 2020 20:40:25 +0200
Message-ID: <CAJaqyWc+fNzHE_p-pApZtj2ypNQfFLawCWf8GJmP8e=k=C+EgA@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] vhost: Reset batched descriptors on SET_VRING_BASE call
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 1, 2020 at 9:19 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> On 31.03.20 21:27, Eugenio P=C3=A9rez wrote:
> > Vhost did not reset properly the batched descriptors on SET_VRING_BASE
> > event. Because of that, is possible to return an invalid descriptor to
> > the guest.
> >
> > This series ammend this, resetting them every time backend changes, and
> > creates a test to assert correct behavior. To do that, they need to
> > expose a new function in virtio_ring, virtqueue_reset_free_head, only
> > on test code.
> >
> > Another useful thing would be to check if mutex is properly get in
> > vq private_data accessors. Not sure if mutex debug code allow that,
> > similar to C++ unique lock::owns_lock. Not acquiring in the function
> > because caller code holds the mutex in order to perform more actions.
>
>
>
> >
> > v3:
> > * Rename accesors functions.
> > * Make scsi and test use the accesors too.
> >
> > v2:
> > * Squashed commits.
> > * Create vq private_data accesors (mst).
> >
> > This is meant to be applied on top of
> > c4f1c41a6094582903c75c0dcfacb453c959d457 in
> > git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git.
>
>
> A quick test on s390 looks good.
>

Really good to know :).

Would it be possible to investigate when qemu launches the offending ioctls=
?

Thanks!

