Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5627D790229
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 20:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343720AbjIASnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 14:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjIASnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 14:43:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0037C1B2
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 11:43:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d78452de9cbso2098383276.2
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 11:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693593783; x=1694198583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v5dtrH/QRuYrVKE5hX6k22Sthf/F5kmL32WEpHVMHJY=;
        b=zRk/k9a9OaUXNF1GbfWUwJPJJSfqD5Dg7v3GOwuiUVgompMiwcl9gQYzotcRhdfN3l
         HQI+XSOFIJ+Gb9240KeflBIBELZguPqaTmOlsqvPCTXV7c0X/vY+bb1++wsB7QM+NjJm
         t/7BEZEjODiCVSNFdJpDR7OGZhHAVvuuQUrBaquv6iK5Mso/ru+q41GEKxc3s+hwf2OR
         va1eQUTSBvPazpLcU6ZkYUxS3O8VySAh49YnahRm2Tihc4izB94UbFuYZnli0P5B1s2i
         rhmQO5av38XhPPSVQjKfDvL4R7G/s6qxgleqOHUfjtZzgLzXquxMg6vlqfo/1d+37X8m
         rTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693593783; x=1694198583;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v5dtrH/QRuYrVKE5hX6k22Sthf/F5kmL32WEpHVMHJY=;
        b=BQFMHqgmRsB2RKnUW0CkyW9X73O5wEhPjhlQoS9F6Z+wSN45AVlIxgJdhc2jhKcRvr
         +rxTzmS+qbfIBuBMoAkSJiKyne1kHybRkwQ5/B372MQsxN7T47bKEuJZldnNCXepZOn5
         Wjnp8c6k2sytqCaLT+1Gi65R5EAPlysJ6s2dZfb3mW1bxJG6FXQgxYDeS46DIov7sdSs
         b8F4XvbF0mrMFUUfgtZ/w+2n7qznyctzfyQOhRD9OAAnikC5/L16Vjb88EXQORz1uYHu
         zPd+LpCBVJpv4KyqeX5ASdVnzI0NT/DGZ+bkISlx6UW66RxA8eB09zq4iLZ4279fahjy
         rWLQ==
X-Gm-Message-State: AOJu0YxbU+0kEHb9ZcrURiU5fpFMTsc1Iq0l/BDbdv57oE4fGScqPDs5
        AV5P0kTzQhDsNmK+pH7odpiRO3oRAO4=
X-Google-Smtp-Source: AGHT+IG0qM0//cDkf/PDSLBNEX67DkbSxG0HWR/mCMySifwiXVav3TtewhTE0SusOybsTBXYZMGnO7ZhBoA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3056:0:b0:d7b:92d7:5629 with SMTP id
 w83-20020a253056000000b00d7b92d75629mr98185ybw.8.1693593783142; Fri, 01 Sep
 2023 11:43:03 -0700 (PDT)
Date:   Fri, 1 Sep 2023 11:43:01 -0700
In-Reply-To: <CABgObfZoJjz1-CMGCQqNjA8i_DivgevEhw+EqfbD463JAMe_bA@mail.gmail.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com> <20230830000633.3158416-4-seanjc@google.com>
 <ZPDNielH+HOYV89u@google.com> <CABgObfZoJjz1-CMGCQqNjA8i_DivgevEhw+EqfbD463JAMe_bA@mail.gmail.com>
Message-ID: <ZPIwtfkVAyFWy41I@google.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 31, 2023, Paolo Bonzini wrote:
> On Thu, Aug 31, 2023 at 7:27=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > +Like
> >
> > On Tue, Aug 29, 2023, Sean Christopherson wrote:
> > > Please pull MMU changes for 6.6, with a healthy dose of KVMGT cleanup=
s mixed in.
> > > The other highlight is finally purging the old MMU_DEBUG code and rep=
lacing it
> > > with CONFIG_KVM_PROVE_MMU.
> > >
> > > All KVMGT patches have been reviewed/acked and tested by KVMGT folks.=
  A *huge*
> > > thanks to them for all the reviews and testing, and to Yan in particu=
lar.
> >
> > FYI, Like found a brown paper bag bug[*] that causes selftests that mov=
e memory
> > regions to fail when compiled with CONFIG_KVM_EXTERNAL_WRITE_TRACKING=
=3Dy.  I'm
> > redoing testing today with that forced on, but barring more falling, th=
e fix is:
>=20
> Ok, I'll apply these by hand.

In case you haven't taken care of this already, here's an "official" tested=
 fix.

Like, if you can give your SoB, I'd rather give you full author credit and =
sub
me out entirely.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 1 Sep 2023 16:55:56 +0000
Subject: [PATCH] KVM: x86/mmu: Fix inverted check when detecting external p=
age
 tracker(s)

When checking for the presence of external users of page write tracking,
check that the list of external trackers is NOT empty.

Fixes: aa611a99adb4 ("KVM: x86: Reject memslot MOVE operations if KVMGT is =
attached")
Reported-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/page_track.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
index 62f98c6c5af3..d4d72ed999b1 100644
--- a/arch/x86/kvm/mmu/page_track.h
+++ b/arch/x86/kvm/mmu/page_track.h
@@ -32,7 +32,7 @@ void kvm_page_track_delete_slot(struct kvm *kvm, struct k=
vm_memory_slot *slot);
=20
 static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
 {
-	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
+	return !hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
 }
 #else
 static inline int kvm_page_track_init(struct kvm *kvm) { return 0; }

base-commit: 22a1c60f8beca52229911b5133d010ff76588921
--=20

