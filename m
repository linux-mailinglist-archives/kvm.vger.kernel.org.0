Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3D46EB595
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 01:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjDUXNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 19:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbjDUXNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 19:13:17 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A68F1FDD
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:13:15 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-4409786dab8so739094e0c.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682118794; x=1684710794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9APFc9ivpo5zXMKU527+SylS9PZXuFh6E82kT31e0A=;
        b=P9Vl/3JCowxD5BocUQXmOQbViMcaUKTXTfAkYZn8U86XJ5oBHf22lL6i+aKYxKP8uM
         TVu/CV7AcIWPQb5IDm0vu+qWxQ8xF7daPyHs6231/ontULu9s1SIhqbVbdMsleMrD326
         UFELebg4FBce8YPAIYI8ajKqji3tUdfjMwgfYbUSorEJljbh+pz0SoQ1vVlZXjoy3V2d
         BAK/FjR6kDiUNQOyQTkU594EFz6367ZkS8t1puIMK5yZO77+h2VkKQDYgJB28PsTdZJJ
         ZvBqbULS03HEfP7nbXY9HHU1Xjr09dbqEr1lXGPbc3CTzJkXP4coFCIo+Ma38w/wmo0y
         2jvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682118794; x=1684710794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9APFc9ivpo5zXMKU527+SylS9PZXuFh6E82kT31e0A=;
        b=gtH30nSVlUxvg5kobADAuItGS2kRx0YdWDkriCY+KTElnQGa4EviZmHrOe2AunnelJ
         LU6gLfTA9Q00by6dUQJIEv0bMYnEY/y4RZNlYlyoGB3RpsSMPFXC+S51so1iPta7MxLG
         zj06hTe6LSB9HDGbVLC9iGXggpjwpD16gfmTMdKJwJD4Xvn5irBiG9kyZgNV9O8zOsiA
         s0hbQzZJvq/ELXeOP3Q3V0GblQfo2cnlvty6/nswtCYxuCKeFz46DEyy2C9QtU01zETr
         83rCHsSHc2c23/7ZCZ/VACAqnVYHpnwFKfrIV2xhBzN40xLxGeUHOpdB+PEr8Qbc1+uk
         w02g==
X-Gm-Message-State: AAQBX9fLP0wnhlgrL+AOWuLULLgGQjJcNHuH3BMHs06ADeXkKprpLCcl
        94G8tm/SEHWiYsQgyjM9m30+y9pw3AEbvsQDcl7hs4jIYro9C7f8AUD4zg==
X-Google-Smtp-Source: AKy350aBwtj33i0EyeclKXhYJ9xm52ked+sEEeS1vtU3I7lcyaDXT8VhjfhFHlIHUtaLo84g7v7YOJ+SnMqv0QpDQRE=
X-Received: by 2002:a1f:bd04:0:b0:43f:f81c:293d with SMTP id
 n4-20020a1fbd04000000b0043ff81c293dmr1426001vkf.8.1682118794652; Fri, 21 Apr
 2023 16:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230421214946.2571580-1-seanjc@google.com>
In-Reply-To: <20230421214946.2571580-1-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 21 Apr 2023 16:12:48 -0700
Message-ID: <CALzav=f=TFoqpR5tPDPOujoO6Gix-+zL-sZyyZK27qJvGPP9dg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 2:49=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
>  {
>         struct kvm_mmu_page *root;
>
> -       lockdep_assert_held_write(&kvm->mmu_lock);
> -       list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> -               if (!root->role.invalid &&
> -                   !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
> +       /*
> +        * Note!  mmu_lock isn't held when destroying the VM!  There can'=
t be
> +        * other references to @kvm, i.e. nothing else can invalidate roo=
ts,
> +        * but walking the list of roots does need to be guarded against =
roots
> +        * being deleted by the asynchronous zap worker.
> +        */
> +       rcu_read_lock();
> +
> +       list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {

I see that roots are removed from the list with list_del_rcu(), so I
agree this should be safe.

KVM could, alternatively, acquire the mmu_lock in
kvm_mmu_uninit_tdp_mmu(), which would let us keep the lockdep
assertion and drop the rcu_read_lock() + comment. That might be worth
it in case someone accidentally adds a call to
kvm_tdp_mmu_invalidate_all_roots() without mmu_lock outside of VM
teardown. kvm_mmu_uninit_tdp_mmu() is not a particularly performance
sensitive path and adding the mmu_lock wouldn't add much overhead
anyway (it would block for at most a few milliseconds waiting for the
async work to reschedule).
