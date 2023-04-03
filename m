Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DC66D443F
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbjDCMTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 08:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbjDCMTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 08:19:03 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069D61206E
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 05:18:31 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-5491fa028adso51406217b3.10
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 05:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680524310;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xz+xTJZERyISIcoATP0KD296OXxi7Qt/2urvL5RLnNU=;
        b=i8WhNIRGBEhchQTLkG2TGtSHcjeeTIic/f+WdpcpLeRGO4glmGX7LJXrEoXO8+Tqbh
         jy3khf5u5fy29SsB70vV/7Hbkqv1SBZ8lbtQ51jR0jbXqnWGel5UbZGpqkthnCuUbS1J
         dwpTUrjhqOgVXK3DAbsV1QwIlV1RDYuGSB92pB4P90ggSYkphZxuqjlU9qBa2jz8cmyC
         PUv3ElUbCIiAsT+Zd5SQJZnPq4k+rbOJgVariDQj9aHWXESSSvpKbALFVYD0rVQ9P42M
         0Kd0L654twoN8Cn8BVfEHvoYXBBJx0hSygeOZXEVbxZn9kCxrtN1JARp/3Up6kucPQXw
         53+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680524310;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xz+xTJZERyISIcoATP0KD296OXxi7Qt/2urvL5RLnNU=;
        b=cND7PVOSl+wRNYGR9xumoXxMu6lpOajT8/JnmovgebdCbnlYxn3ok8Sc7g4cxWOcNe
         NbWGZaCzpN2t3gkxA+dGyhZuehMA4VBc8oWhyRlfgqBTsl81oYyQaVJTQ+iMtdnm+05X
         kEIyYa3UPItpL3Ad5/lKDLigGp9ITqvCFJgkWAYfcnPupLpOcEt6MHjxydYYxzNkyGh3
         nhNkxmjDeOGGIipBL6UoUlteTKQCPpzZHbdKcuwpql6e0kl3deIbOYZFXfnUi0R7W9HB
         Kb9HfD7Cqz1olqlfzfcJjtr8rlmRn6JA77c1raVE0sqQZmc4ItzahB7j29WbrUyxrs+C
         TDCQ==
X-Gm-Message-State: AAQBX9eyiFGSGuBftT4Ol+r6PLwx1N5EQmSw4nExEBzCMZ8bI9LwTyzR
        plQnHLlTIQiLgM/NvXt7TBj0bhBaY4H1TfZA+HM=
X-Google-Smtp-Source: AKy350YpXiz3aA00nHjZ0odU8F17Ho8emao0sH7s/GZf0tSu+36pgySsekEPzMjZJdSc4mjFk++22FhSqskCJzmj5CU=
X-Received: by 2002:a81:b65f:0:b0:544:8bc1:a179 with SMTP id
 h31-20020a81b65f000000b005448bc1a179mr18234959ywk.4.1680524310113; Mon, 03
 Apr 2023 05:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230327144553.4315-1-faithilikerun@gmail.com> <20230329005755-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230329005755-mutt-send-email-mst@kernel.org>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 3 Apr 2023 08:18:18 -0400
Message-ID: <CAJSP0QW1FFYYMbwSdG94SvotMe_ER_4Dxe5e+2FAcQMWaJ3ucA@mail.gmail.com>
Subject: Re: [PATCH v9 0/5] Add zoned storage emulation to virtio-blk driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Sam Li <faithilikerun@gmail.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        hare@suse.de, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 at 01:01, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Mar 27, 2023 at 10:45:48PM +0800, Sam Li wrote:
> > This patch adds zoned storage emulation to the virtio-blk driver. It
> > implements the virtio-blk ZBD support standardization that is
> > recently accepted by virtio-spec. The link to related commit is at
> >
> > https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad15db65af8d7d981
> >
> > The Linux zoned device code that implemented by Dmitry Fomichev has been
> > released at the latest Linux version v6.3-rc1.
> >
> > Aside: adding zoned=on alike options to virtio-blk device will be
> > considered in following-up plan.
> >
> > Note: Sorry to send it again because of the previous incoherent patches caused
> > by network error.
>
> virtio bits look ok.
>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>
> merge through block layer tree I'm guessing?

Sounds good. Thank you!

Stefan
