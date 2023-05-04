Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327EF6F76DA
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjEDUUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjEDUTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:19:25 -0400
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993D18FC4
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:05:22 -0700 (PDT)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-559d359a7f8so7615057b3.0
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 13:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683230591; x=1685822591;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6d3N2trVvF/0SP9aYKkzozOiaqRgiMUEtCybqqCwYC4=;
        b=nSt06goC2EesMw51N0ovK0I5GoG2O8RRMiZd97+/QV3gTGlHOQ/YlocZxIKdFrCpDq
         xlMu5W80BEbbwTuK25jEybNR7E1NWok2AtRJ4Lghz4ll3c763axF5nNlCagzrqlnXBQo
         OsMw6+5s/60AQLRSJTr4q4r3Y68l8R8wgve6zjYz4rBFZHSpXh9uQoytpYpRgc1O4Jdw
         B9PHr/ZesgS8grOLiJehoJzYvo+FKS6GFjqopm/tuYyB7xoxpSRqwaqOGP21TzDnP0BB
         uXcDQG0E2HfsIkBDlXXooTTVcO4NOH/ETRXLaTrhUSiblqF5B/cgFrDiHeBGUv4cZDzw
         3fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683230591; x=1685822591;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6d3N2trVvF/0SP9aYKkzozOiaqRgiMUEtCybqqCwYC4=;
        b=GpUCEYHgDrwQkrzAJhMQaVun2i1Kcs5RDv0RUBNRt41KfrezN5YbTKu1S2KfUDeaoQ
         Gar9b33lAOfu9PX4uSy0ZJrKkq0iOYB2NyUncEptni/EelYW7GUGS638J0qJ6X9KVZYI
         SKVriKTyz8rJiZorgHN7VbOenmPKJp228STT2eOGJRJo15HE4V36w5eewzghgsYQUXyc
         ta5rrIwK+PcaaWKzSB0iUay4g4eUsyWJsDw00oZVX3/gthaZaFkYoNQxDrKNT/oXvyuP
         dy6q3jdGMwSFl9kG63LJChzRzBMAIibJhaqAErOkbOCGJFTaQpSnSzIsEkjpHmHcbfdw
         7Ffg==
X-Gm-Message-State: AC+VfDwrMQPfFCjBRwU/WLBVjMGzURt9HyblpHn8DCIYEtdtrc5nBCvt
        V70qReT/jIlaGSg3Mb6isYOJsUcZTLQ=
X-Google-Smtp-Source: ACHHUZ6PuvZPi6zDMylo7QfkM96x9IBh58YDyqmz4u9ST0E5CBqQ++ARqtoyXc3r/vmAbveuvG4IuNYS3I8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a52:b0:247:b82f:b42 with SMTP id
 lb18-20020a17090b4a5200b00247b82f0b42mr19846pjb.4.1683230082371; Thu, 04 May
 2023 12:54:42 -0700 (PDT)
Date:   Thu, 4 May 2023 12:54:40 -0700
In-Reply-To: <ZBH4RizqdigXeYte@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-21-seanjc@google.com>
 <ZBGfmLuORj+ZBziv@yzhao56-desk.sh.intel.com> <ZBH4RizqdigXeYte@google.com>
Message-ID: <ZFQNgKGcexo0nQ4S@google.com>
Subject: Re: [PATCH v2 20/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023, Sean Christopherson wrote:
> On Wed, Mar 15, 2023, Yan Zhao wrote:
> > On Fri, Mar 10, 2023 at 04:22:51PM -0800, Sean Christopherson wrote:
> > > Disable the page-track notifier code at compile time if there are no
> > > external users, i.e. if CONFIG_KVM_EXTERNAL_WRITE_TRACKING=3Dn.  KVM =
itself
> > > now hooks emulated writes directly instead of relying on the page-tra=
ck
> > > mechanism.
> > >=20
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h       |  2 ++
> > >  arch/x86/include/asm/kvm_page_track.h |  2 ++
> > >  arch/x86/kvm/mmu/page_track.c         |  9 ++++-----
> > >  arch/x86/kvm/mmu/page_track.h         | 29 +++++++++++++++++++++++--=
--
> > >  4 files changed, 33 insertions(+), 9 deletions(-)
> > >=20
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 1a4225237564..a3423711e403 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1265,7 +1265,9 @@ struct kvm_arch {
> > >  	 * create an NX huge page (without hanging the guest).
> > >  	 */
> > >  	struct list_head possible_nx_huge_pages;
> > > +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> > >  	struct kvm_page_track_notifier_head track_notifier_head;
> > > +#endif
> > >  	/*
> > >  	 * Protects marking pages unsync during page faults, as TDP MMU pag=
e
> > >  	 * faults only take mmu_lock for read.  For simplicity, the unsync
> > > diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include=
/asm/kvm_page_track.h
> > > index deece45936a5..53c2adb25a07 100644
> > > --- a/arch/x86/include/asm/kvm_page_track.h
> > > +++ b/arch/x86/include/asm/kvm_page_track.h
> > The "#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING" can be moved to the
> > front of this file?
> > All the structures are only exposed for external users now.
>=20
> Huh.  I've no idea why I didn't do that.  IIRC, the entire reason past me=
 wrapped
> track_notifier_head in an #ifdef was to allow this change in kvm_page_tra=
ck.h.
>=20
> I'll do this in the next version unless I discover an edge case I'm overl=
ooking.

Ah, deja vu.  I tried this first time around, and got yelled at by the kern=
el test
robot.  Unsuprisingly, my second attempt yielded the same result :-)

  HDRTEST drivers/gpu/drm/i915/gvt/gvt.h
In file included from <command-line>:
gpu/drivers/gpu/drm/i915/gvt/gvt.h:236:45: error: field =E2=80=98track_node=
=E2=80=99 has incomplete type
  236 |         struct kvm_page_track_notifier_node track_node;
      |                                             ^~~~~~~~~~

The problem is direct header inclusion.  Nothing in the kernel includes gvt=
.h
when CONFIG_DRM_I915_GVT=3Dn, but the header include guard tests include he=
aders
directly on the command line.  I think I'll define a "stub" specifically to=
 play
nice with this sort of testing.  Guarding the guts of gvt.h with CONFIG_DRM=
_I915_GVT
would just propagate the problem, and guarding the node definition in "stru=
ct
intel_vgpu" would be confusing since the guard would be dead code for all i=
ntents
and purposes.

The obvious alternative would be to leave kvm_page_track_notifier_node outs=
ide of
the #ifdef, but I really want to bury kvm_page_track_notifier_head for KVM'=
s sake,
and having "head" buried but not "node" would also be weird and confusing.

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/k=
vm_page_track.h
index 33f087437209..3d040741044b 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -51,6 +51,12 @@ void kvm_page_track_unregister_notifier(struct kvm *kvm,
=20
 int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn);
 int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn);
+#else
+/*
+ * Allow defining a node in a structure even if page tracking is disabled,=
 e.g.
+ * to play nice with testing headers via direct inclusion from the command=
 line.
+ */
+struct kvm_page_track_notifier_node {};
 #endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
=20
 #endif

