Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472126EFB46
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 21:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjDZTpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 15:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDZTo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 15:44:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E05A2117
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682538248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CU69wKejwOMDppClKDYq19yj03ls8og4z5qIG2uSb9U=;
        b=fetVXsnYx3Rxy9se00coikCqncEmBoegzHgQxAFaRadDB2On0gv2BGDbHIODrtNMFIzhpn
        VZXR8O3p724z+AEs2aefCzTh2FW4FMFmbyP6YDjQ4PyL6VEpbkDxgSYjA0TYsKLvuU7XzW
        7OxbuODTHExfrUY08dyAujn2KOnPWO4=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-BWH2WJthPOGsLv01LZJPZw-1; Wed, 26 Apr 2023 15:44:07 -0400
X-MC-Unique: BWH2WJthPOGsLv01LZJPZw-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-772a3262ef4so2468353241.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 12:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682538246; x=1685130246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CU69wKejwOMDppClKDYq19yj03ls8og4z5qIG2uSb9U=;
        b=HcShwlGgFsPKIIdNrCpUBgxFUlj5CZx94jTbsJlehGhCiL5ysgUCgWUB4gAPGfyupD
         fg/Dnv8qRI3z3YVaCWGgNP27/4K+z15fUiyU+EZ6ROH6jC36uhaQUUF4o5vN/fQjpVCS
         WoBpZaglDatMj4iuq4W1yW3fIq0W9JGH6sQ94y+E2uWDAhxfQ8bN8A9HNoXjM/XgpS6X
         9ri79hTSz4U6y3qjmgRUh5rNQVr5UR7Ev1PUn+to8W9U8HKUJbcWtOwp1BZid9AKb6XK
         d3f2FQPBZLiGfEiwmrfXr4QJJfsWxoi21YOC2/uwosSYWlKE6XNEg+kXh2wIXlmEljP8
         Ka2g==
X-Gm-Message-State: AAQBX9crAdraGGxPsqT9EZzgUEcM+smlfEdTEKbolQHCML7nSDA+jiiO
        rZuBbeTGprfKkPc9cz+Uy2Rli7+wshQwx96Wejg29L3/D347HJlNks9xIvBFgjDAfMC9YK9jSaH
        Mfkirgqlb/jgRDKF5b9Qv5roka08j2W4+zEh8ALriCw==
X-Received: by 2002:a67:be05:0:b0:42c:7f68:3da7 with SMTP id x5-20020a67be05000000b0042c7f683da7mr9325915vsq.29.1682538245822;
        Wed, 26 Apr 2023 12:44:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350ae1/wLvvTOZSRM+56KhIlSssMem8ehV3S5SNvr/HasjBRhzN4Pe2L1ULwRDoVgD8Q5vL+j9uS4oWY2eP5C2gQ=
X-Received: by 2002:a67:be05:0:b0:42c:7f68:3da7 with SMTP id
 x5-20020a67be05000000b0042c7f683da7mr9325908vsq.29.1682538245428; Wed, 26 Apr
 2023 12:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230426125119.11472-1-frankja@linux.ibm.com>
In-Reply-To: <20230426125119.11472-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 21:43:54 +0200
Message-ID: <CABgObfaD4hGe0atddjW5s5A0ejB7ujHu1V9sJdEC3dt3=T+-8Q@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] KVM: s390: Changes for 6.4
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023 at 2:52=E2=80=AFPM Janosch Frank <frankja@linux.ibm.co=
m> wrote:
>
> Hi Paolo,
>
> nothing major for today, two patches that continue our phys_to_virt()
> conversion efforts and a patch that increases readability.
>
> Please pull,
> Janosch

Queued, thanks.

Paolo

> The following changes since commit eeac8ede17557680855031c6f305ece2378af3=
26:
>
>   Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.4-1
>
> for you to fetch changes up to 8a46df7cd135fe576c18efa418cd1549e51f2732:
>
>   KVM: s390: pci: fix virtual-physical confusion on module unload/load (2=
023-04-20 16:30:35 +0200)
>
> ----------------------------------------------------------------
> Minor cleanup:
>  - phys_to_virt conversion
>  - Improvement of VSIE AP management
>
> ----------------------------------------------------------------
> Nico Boehr (2):
>       KVM: s390: interrupt: fix virtual-physical confusion for next alert=
 GISA
>       KVM: s390: pci: fix virtual-physical confusion on module unload/loa=
d
>
> Pierre Morel (1):
>       KVM: s390: vsie: clarifications on setting the APCB
>
>  arch/s390/kvm/interrupt.c |  4 ++--
>  arch/s390/kvm/pci.c       |  2 +-
>  arch/s390/kvm/vsie.c      | 50 +++++++++++++++++++++++++++--------------=
------
>  3 files changed, 32 insertions(+), 24 deletions(-)
>
>
> Nico Boehr (2):
>   KVM: s390: interrupt: fix virtual-physical confusion for next alert
>     GISA
>   KVM: s390: pci: fix virtual-physical confusion on module unload/load
>
> Pierre Morel (1):
>   KVM: s390: vsie: clarifications on setting the APCB
>
>  arch/s390/kvm/interrupt.c |  4 ++--
>  arch/s390/kvm/pci.c       |  2 +-
>  arch/s390/kvm/vsie.c      | 50 +++++++++++++++++++++++----------------
>  3 files changed, 32 insertions(+), 24 deletions(-)
>
> --
> 2.40.0
>

